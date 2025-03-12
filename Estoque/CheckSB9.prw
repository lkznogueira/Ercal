#include "rwmake.ch" 
#INCLUDE "PROTHEUS.CH"

/*
_____________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦Programa  ¦ CHECKSB9   ¦ Autor ¦ Claudio Ferreira    ¦ Data ¦ 15/03/12 ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Descriçào ¦ Função para verificar divergencias no fechamento           ¦¦¦
¦¦¦          ¦                                                            ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦ Uso      ¦ TBC                                                        ¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
*/

// USO u_CHECKSB9(.F.,CTOD('31/12/15'))       
// lParam1: T=Grava, F=Só lista
// dParam2: a partir de 
User Function CHECKSB9()

Private cPerg 		:= "CHECKSB9"
Private aLog:={}

ValidPerg()          // Cria pergunta
if  !pergunte(cPerg,.t.)
	return
endif                          


lGrava   := mv_par06==2
dDataIni := mv_par05

if msgyesno("Confirma checagem dos saldos de virada?")
 Processa( {|| RunProc(lGrava,dDataIni) } )
endif 
Return


Static Function RunProc(lGrava,dDataIni) 
Local aArea  := GetArea() 
Local aLog:={}  
Local nCont:=0 
Local lPrim:=.t.
Local cFilAtu:=xFilial('SB9')
Local nTotAtu:=nTotCalc:=0
 
Local cQry:="SELECT A.* "+;
"FROM "+RetSqlName("SB9")+" A, "+RetSqlName("SB1")+" B "+;
"WHERE A.D_E_L_E_T_<>'*' AND B.D_E_L_E_T_<>'*' "+;  
" AND B9_COD=B1_COD "+;
" AND B9_DATA>='"+ DTOS(mv_par05) +"' "+;
" AND B9_COD BETWEEN '"+ mv_par01 +"' AND '"+ mv_par02 +"' "+;
" AND B1_TIPO BETWEEN '"+ mv_par03 +"' AND '"+ mv_par04 +"' "+;
" AND B9_FILIAL  = '" + xFilial("SB9") + "' "+;
" AND B1_FILIAL  = '" + xFilial("SB1") + "' "+;
" ORDER BY B9_FILIAL,B9_COD,B9_LOCAL,B9_DATA  "

cAliasQry	:= "QSB9"
dbUseArea( .T., "TopConn", TCGenQry(,,cQry),cAliasQry, .F., .F. )

Dbselectarea("QSB9")
dbEval({|| nCont++})
DBGotop()
ProcRegua(nCont)

cProd:='    '
dDataini:=ctod('')
cProd:=QSB9->B9_COD 
While !Eof() .and. QSB9->B9_FILIAL = cFilAtu
  IncProc()
  if cProd<>QSB9->B9_COD
    cProd:=QSB9->B9_COD 
    lPrim:=.t.
  endif  
  dData:=Stod(QSB9->B9_DATA)
  if empty(dData)
	Dbselectarea("QSB9")
    DbSkip()
    loop
  endif            
  
  BEGIN TRANSACTION                             
  
  cLocal:=QSB9->B9_LOCAL
  nRecSB9:=QSB9->R_E_C_N_O_
  //Alert(Str(nRecSB9))                                 
  SB9->(DbGoto(nRecSB9))
  SB9->(RecLock( "SB9" , .F. ))
  SB9->(dbDelete())
  
  nQtd    := CalcEst(cProd, cLocal,dData+1)[1] 
  nValor  := CalcEst(cProd, cLocal,dData+1)[2] 
  if nQtd<0.01
    nValor:=0
  endif 
  nVlrUnit:= nValor/nQtd 
  if nVlrUnit>9999999999
     nVlrUnit:=9999999999
  endif
  Dbselectarea("SB9")
  DbGoto(nRecSB9)
  DbReCall()           
  MsUnlock()
  //Alert(Str(nRecSB9)) 
  END TRANSACTION

  if Round(SB9->B9_QINI,4)<>Round(nQtd,4)  .or. Round(SB9->B9_VINI1,4)<>Round(nValor,4)
    if lPrim
	  aadd(aLog,' ')
	  aadd(aLog,'>> Prod:'+SB9->B9_COD+' '+Posicione('SB1',1,xFilial('SB1')+SB9->B9_COD,'B1_DESC'))
	  lPrim:=.f.
    endif    
    cWrite:=' '
	if lGrava  
      cWrite:='W'
	endif
	aadd(aLog,'>> Armz:'+SB9->B9_LOCAL+' Data:'+dtoc(dData)+' Divergência - Atual: Qtd > '+Transform(SB9->B9_QINI,'@e 9,999,999.9999')+' Valor > '+Transform(SB9->B9_VINI1,'@e 9,999,999.99')+' Calculado: Qtd > '+Transform(nQtd,'@e 9,999,999.9999')+' Valor > '+Transform(nValor,'@e 9,999,999.99')+' '+cWrite)
	nTotAtu+=SB9->B9_VINI1
	nTotCalc+=nValor
	if lGrava  
	  RecLock( "SB9" , .F. )
	  SB9->B9_QINI:=nQtd
	  SB9->B9_VINI1:=nValor
	  SB9->B9_CM1:=nVlrUnit
	  MsUnlock() 
	endif
  endif
  Dbselectarea("QSB9")
  DbSkip()
  if cProd<>QSB9->B9_COD
    //exit    
  endif  
Enddo  

if nTotAtu+nTotCalc<>0
	aadd(aLog,'>>                       TOTAIS:                                  Atual > '+Transform(nTotAtu,'@e 999,999,999.99')+'                            Calculado:  '+Transform(nTotCalc,'@e 999,999,999.99')+' '+cWrite)
Endif

Dbselectarea("SB9")
dbClearFilter()
 
QSB9->(dbCloseArea())

                        
RestArea(aArea) 


if Len(aLog)=0
	aadd(aLog,'>> Não foram encontradas inconsistências')
endif
LogProc("Log do processo",aLog)
          
Return    


/*
_____________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦Programa  ¦ LogProc  ¦ Autor ¦ Claudio Ferreira      ¦ Data ¦ 12/09/08 ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Descriçào ¦ Relatorio de Log de Processos                              ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦ Uso      ¦ Generico                                                   ¦¦¦
¦¦¦          ¦                                                            ¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
*/

Static Function LogProc(cOrigem,aLog)

titulo   := "LOG DO PROCESSO - "+cOrigem
cDesc1   := "Este programa irá emitir um Log de Processo"
cDesc2   := "conforme parametros especificados."
cDesc3   := ""
cString  := ""
aReturn  := { "Zebrado", 1,"Administracao", 2, 2, 1, "",1 }
nLastKey := 0
ntamanho := "M"
wnrel    := "LOGPROC"
nomeProg := "LOGPROC"
li       := 99
m_pag    := 1
nTipo    := IIF(aReturn[4]==1,15,18)
wnrel    := SetPrint(cString,wnrel,,@titulo,cDesc1,cDesc2,cDesc3,.F.,,.F.,)
If LastKey() == 27 .Or. nLastKey == 27
	Return
Endif
SetDefault(aReturn,cString)
RptStatus({|| ILogPro2(cOrigem,aLog)},Titulo)

Return Nil

Static Function ILogPro2(cOrigem,aLog)
Local _xi
cabec1  := "Descricao do Evento"
cabec2  := ""
SetRegua(len(aLog))
For _xi:=1 to len(aLog)
	incregua()
	if li > 60
		li:=Cabec(titulo,cabec1,cabec2,nomeprog,nTamanho,nTipo)+1
	endif
	@ li,000 Psay aLog[_xi]
	li++
Next

Roda(0,nTamanho)

Set Device to Screen

If aReturn[5] == 1
	Set Printer To
	dbCommitAll()
	ourspool(wnrel)
endif

MS_FLUSH()

Return Nil   

Static Function ValidPerg()
_sAlias	:=	Alias()
dbSelectArea("SX1")
dbSetOrder(1)
cPerg 	:=	PADR(cPerg,10)
//                                                                                  -SA1-
/*
U_xputSx1(     cPerg,"01","Produto de?","."     ,"."       ,"mv_ch1","C",15,0,0,"G","","","","","mv_par01","","","","","","","","","","","","","","","","")
U_xputSx1(     cPerg,"02","Produto ate?","."    ,"."       ,"mv_ch2","C",15,0,0,"G","","","","","mv_par02","","","","","","","","","","","","","","","","")
U_xputSx1(     cPerg,"03","Tipo de?","."        ,"."       ,"mv_ch3","C",02,0,0,"G","","02","","","mv_par03","","","","","","","","","","","","","","","","")
U_xputSx1(     cPerg,"04","Tipo ate?","."       ,"."       ,"mv_ch4","C",02,0,0,"G","","02","","","mv_par04","","","","","","","","","","","","","","","","")
U_xputSx1(     cPerg,"05","Data inicio?","."    ,"."       ,"mv_ch5","D",08,0,0,"G","","","","","mv_par05","","","","","","","","","","","","","","","","")
U_xputSx1(     cPerg,"06","Regrava SB9?","."    ,"."       ,"mv_cha","N",01,0,0,"C","","","","","mv_par06","1-Não","","","","2-Sim","","","","","","","","","","")
*/
dbSelectArea(_sAlias)

Return

