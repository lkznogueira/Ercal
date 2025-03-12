#include "rwmake.ch"
#include "topconn.ch"
#include "protheus.ch"
#include "TBICONN.CH"
              
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTBCLIB    บAutor  ณDIVERSOS            บ Data ณ  01/12/08   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Conjunto de Funcoes Genericas                              บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณTOTVS GO           										  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRETPROX   บAutor  ณClแudio Ferreira    บ Data ณ  12/09/07   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Funcao para determinar qual serแ o proximo numero para o   บฑฑ
ฑฑบ          ณ Campo informado                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณu_RETPROX(cCampo,[nTam],[cRetorno],[cTipFil],[cCpoFil])	  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function RETPROX(cCampo,nTam,cRetorno,cTipFil,cCpoFil)
Local cArea:= Alias()
Local cQuery:='',cTabela
Local cFil
Local QAux,nSeq
Default cTipFil:=''
Default cCpoFil:=''
Default nTam=TamSx3(cCampo)[1]
Default cRetorno:=''

Private lRet:=empty(cRetorno)

cTabela:=Substr(cCampo,1,At('_',cCampo)-1) 
cFil:=cTabela+'_FILIAL'
cTabela:=iif(len(cTabela)==2,"S","")+cTabela


	cQuery := "SELECT MAX("+cCampo+")as NSEQUEN FROM "+RetSqlName(cTabela)+" WHERE "
	cQuery += "D_E_L_E_T_<>'*' AND "
	cQuery += " B1_COD NOT IN ('MANUTENCAO     ','TERCEIROS      ') AND " //Protecao para produtos cadastrados automaticamente pelo modulo MNT
	cQuery += cFil+" = '"+xfilial(cTabela)+"' "     
	if !empty(cTipFil+cCpoFil)
		cQuery += " AND "+cCpoFil+" = '"+cTipFil+"'"
	endif
	cQuery:=Changequery(cQuery)
	TCQUERY cQuery NEW ALIAS "QAux"
	if Empty(QAux->NSEQUEN)
      cRetorno:=cTipFil+Strzero(1,nTam-len(cTipFil))
    else
	  cRetorno:=cTipFil+Soma1(Substr(QAux->NSEQUEN,len(cTipFil)+1,nTam-len(cTipFil)))
    endif
	QAux->(dbCloseArea())
    
dbselectarea(cArea)    
Return iif(!lRet,.t.,cRetorno)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMemToReg  บAutor  ณClแudio Ferreira    บ Data ณ  12/12/08   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Fun็ใo para gravar as variaveis de memory para o registro  บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณu_MemToReg(cAlias) 										  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function MemToReg(cAlias)
Local aArea    := GetArea()
Local nX    := 0           
Local bCampo := { |nField| FieldName(nField) }

dbSelectArea(cAlias)
For nX := 1 To FCount()
	If "FILIAL" $ FieldName(nX)
		FieldPut(nX,xFilial(cAlias))
	Else
		FieldPut(nX,M->&(Eval(bCampo,nX)))
	Endif
Next
RestArea(aArea)
Return(Nil)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณSaveArea  บAutor  ณNelson Henrique     บ Data ณ  12/12/08   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Classe para salvar areas e ponteiros                       บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ                  										  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
CLASS SaveArea
DATA aAlias
DATA mAlias
METHOD new() constructor
METHOD add(_cAlias)
METHOD save()
METHOD restore()
METHOD clear()
ENDCLASS

//------------------------------------------------------------------------//
METHOD new() CLASS SaveArea
::aAlias := {}
::mAlias := {}
Return Self

//------------------------------------------------------------------------//
METHOD add(_cAlias) CLASS SaveArea
aAdd(::aAlias,_cAlias)
Return

//------------------------------------------------------------------------//
METHOD clear() CLASS SaveArea
::aAlias := {}
::mAlias := {}
Return

//------------------------------------------------------------------------//
METHOD save() CLASS SaveArea
Local x
For x := 1 to Len(::aAlias)
	DbSelectArea(::aAlias)
	AaDd(::mAlias,{::aAlias,IndexOrd(),Recno()})
next x
Return

//------------------------------------------------------------------------//
METHOD restore() CLASS SaveArea
Local x
For x:= 1 to Len(::mAlias)
	DbSelectArea(::mAlias[x,1])
	DbSetOrder(::mAlias[x,2])
	DbGoto(::mAlias[x,3])
Next x
Return 

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRETLOG    บAutor  ณClแudio Ferreira    บ Data ณ  23/03/07   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Funcao para descriptografar o USERLGI/USERLGA              บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณu_RETLOG('UI')       										  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

//http://tdn.totvs.com/pages/releaseview.action?pageId=6814934

User Function RETLOG(cCampo)
Local _Ret:=''            
Local i,cStatus,cUsuarioI,cUsuarioA,cDataI,cDataA,cTipo := "0"    
cCampo:=Upper(cCampo)
if cCampo$('UI-DI-UA-DA')                                    
  cTipo := IIF(cCampo$('UI-DI'),"1","2")                                    
  LeLog(@cStatus,@cUsuarioI,@cUsuarioA,@cDataI,@cDataA,cTipo)
  _Ret:=IIF(cCampo$('UI-DI'),IIF(cCampo=='UI',cUsuarioI,cDataI),IIF(cCampo=='UA',cUsuarioA,cDataA))
endif 
return(_Ret)

/*

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณLogProc   บAutor  ณClแudio Ferreira    บ Data ณ  12/09/08   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Classe para Gerar Relatorio de Log de Processos            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ                  										  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

CLASS LogProc
DATA aLog
DATA cProcName
METHOD new() constructor
METHOD add(_cAlias)
METHOD setname(_cName)
METHOD inlog()
METHOD execute()
METHOD clear()
ENDCLASS

//------------------------------------------------------------------------//
METHOD new() CLASS LogProc
::aLog := {}  
::cProcName:=''
Return Self

//------------------------------------------------------------------------//
METHOD add(_cMsg) CLASS LogProc
aAdd(::aLog,_cMsg)
Return 

//------------------------------------------------------------------------//
METHOD setname(_cName) CLASS LogProc
::cProcName:=_cName
Return  

//------------------------------------------------------------------------//
METHOD clear() CLASS LogProc
::aLog := {}
::cProcName:=''
Return

//------------------------------------------------------------------------//
METHOD inlog(_cMsg) CLASS LogProc
Private lRet:=!ascan(::aLog,_cMsg)==0
Return lRet

//------------------------------------------------------------------------//
METHOD execute() CLASS LogProc
titulo   := "LOG DO PROCESSO - "+::cProcName
cDesc1   := "Este programa irแ emitir um Log de Processo"
cDesc2   := "conforme parametros especificados."
cDesc3   := ""
cString  := ""
aReturn  := { "Zebrado", 1,"Administracao", 2, 2, 1, "",1 }
nLastKey := 0
ntamanho := "P"
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
RptStatus({|| ILogProc(::aLog)},Titulo)

Return Nil

Static Function ILogProc(aLog)
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


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณSendMail  บAutor  ณClแudio Ferreira    บ Data ณ  12/09/07   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Classe para enviar email                                   บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ                  										  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

CLASS SendMail
DATA cFile 
DATA cSubject 
DATA cBody    
DATA lShedule 
DATA cTo     
DATA cCc  
DATA cBCC     
DATA cFrom      
DATA cLogMsg     
DATA lEchoMsg 
DATA nSMTPPort
DATA nSMTPTime
DATA nPOPPort 
DATA cSmtp
DATA cPop
DATA cAccount
DATA cPsw
DATA cAthAcc
DATA cAthPsw

METHOD new() constructor
METHOD SetAttachment(_cFile)
METHOD SetSubject(_cSubject)
METHOD SetTo(_cTo)
METHOD SetCc(_cCc)
METHOD SetBCC(_cBCC)
METHOD SetFrom(_cFrom)
METHOD SetBody(_cBody)
METHOD SetShedule(_lDef)
METHOD SetEchoMsg(_lDef)
METHOD SetSMTPPort(_nSMTPPort) 
METHOD SetPOPPort(_nPOPPort) 
METHOD SetSmtp(_cSmtp)
METHOD SetPop(_cPop)
METHOD SetAccount(_cAccount)
METHOD SetPsw(_cPsw)
METHOD SetAthAcc(_cAthAcc)
METHOD SetAthPsw(_cAthPsw)
METHOD Edit()
METHOD Send()
ENDCLASS

//------------------------------------------------------------------------//
METHOD new() CLASS SendMail
::cFile := ""
::cSubject := ""
::cBody    := space(240)
::lShedule := isBlind()
::cTo      := space(100)
::cCc      := space(100)    
::cBCC     := space(100)
::cFrom    := space(100)
::cLogMsg  := ""
::lEchoMsg :=  .T.
::nSMTPPort := 587                    // Porta do servidor SMTP
::nSMTPTime := 60 
::nPOPPort  := 110
::cSmtp:= space(100)
::cPop:= space(100)
::cAccount:= space(100)
::cPsw:= space(100)
::cAthAcc:= space(100)
::cAthPsw:= space(100)


Return Self

//------------------------------------------------------------------------//
METHOD SetSMTPPort(_nSMTPPort) CLASS SendMail
::nSMTPPort := _nSMTPPort
Return     

//------------------------------------------------------------------------//
METHOD SetPOPPort(_nPOPPort) CLASS SendMail
::nPOPPort := _nPOPPort
Return     

//------------------------------------------------------------------------//
METHOD SetAttachment(_cFile) CLASS SendMail
::cFile := _cFile
Return     

//------------------------------------------------------------------------//
METHOD SetSubject(_cSubject) CLASS SendMail
::cSubject := padr(_cSubject,100)
Return     

//------------------------------------------------------------------------//
METHOD SetTo(_cTo) CLASS SendMail
::cTo := _cTo
Return     

//------------------------------------------------------------------------//
METHOD SetCc(_cCc) CLASS SendMail
::cCc := _cCc
Return      

//------------------------------------------------------------------------//
METHOD SetBCC(_cBCC) CLASS SendMail
::cBCC := _cBCC
Return 

//------------------------------------------------------------------------//
METHOD SetFrom(_cFrom) CLASS SendMail
::cFrom := _cFrom
Return  

//------------------------------------------------------------------------//
METHOD SetBody(_cBody) CLASS SendMail
::cBody := _cBody
Return  

//------------------------------------------------------------------------//
METHOD SetShedule(_lDef) CLASS SendMail
::lShedule := _lDef
Return  

//------------------------------------------------------------------------//
METHOD SetEchoMsg(_lDef) CLASS SendMail
::lEchoMsg := _lDef
Return  

METHOD SetSmtp(_cSmtp) CLASS SendMail
::cSmtp := _cSmtp
Return  

METHOD SetPop(_cPop) CLASS SendMail
::cPop:= _cPop
Return  
METHOD SetAccount(_cAccount) CLASS SendMail
::cAccount := _cAccount
Return  
METHOD SetPsw(_cPsw) CLASS SendMail
::cPsw := _cPsw
Return  
METHOD SetAthAcc(_cAthAcc) CLASS SendMail
::cAthAcc := _cAthAcc
Return  
METHOD SetAthPsw(_cAthPsw) CLASS SendMail
::cAthPsw := _cAthPsw
Return  

//------------------------------------------------------------------------//
METHOD Edit() CLASS SendMail 
LOCAL oDlg, nOP, nCol1, nCol2, nSize, nLinha, nLinAux    

DO WHILE !::lShedule

   nOp  :=0
   nCol1:=8
   nCol2:=33
   nSize:=225  
   nLinha:=15 

   DEFINE MSDIALOG oDlg OF oMainWnd FROM 0,0 TO 350,544 PIXEL TITLE "Envio de E-mail"

        nLinAux:=nLinha
        nLinha+=10

  		@ nLinha,nCol1 Say   "De:"      Size 012,08             OF oDlg PIXEL 
  		@ nLinha,nCol2 MSGET ::cFrom      Size nSize,10  F3 "_EM" OF oDlg PIXEL 
        nLinha+=15

  		@ nLinha,nCol1 Say   "Para:"    Size 016,08             OF oDlg PIXEL
  		@ nLinha,nCol2 MSGET ::cTo        Size nSize,10  F3 "_EM" OF oDlg PIXEL
        nLinha+=15

  		@ nLinha,nCol1 Say   "CC:"      Size 016,08             OF oDlg PIXEL
  		@ nLinha,nCol2 MSGET ::cCC        Size nSize,10  F3 "_EM" OF oDlg PIXEL
        nLinha+=15

  		@ nLinha,nCol1 Say   "Assunto:" Size 021,08             OF oDlg PIXEL
  		@ nLinha,nCol2 MSGET ::cSubject   Size nSize,10           OF oDlg PIXEL
        nLinha+=15

  		@ nLinha,nCol1 Say   "Mensagem:"   Size 016,08             OF oDlg PIXEL
  		@ nLinha,nCol2 Get   ::cBody      Size nSize,20  MEMO     OF oDlg PIXEL HSCROLL

  		@ nLinAux,nCol1-4 To nLinha+28,268 LABEL " Dados de Envio " OF oDlg PIXEL 
        nLinha+=35

    DEFINE SBUTTON FROM nLinha,(oDlg:nClientWidth-4)/2-90 TYPE 1 ACTION (If(Empty(::cTo),Help("",1,"AVG0001054"),(oDlg:End(),nOp:=1))) ENABLE OF oDlg PIXEL
    DEFINE SBUTTON FROM nLinha,(oDlg:nClientWidth-4)/2-45 TYPE 2 ACTION (oDlg:End()) ENABLE OF oDlg PIXEL

   ACTIVATE MSDIALOG oDlg CENTERED

   IF nOp = 0
      RETURN .f.
   ENDIF

   EXIT

ENDDO

Return .t. 

//------------------------------------------------------------------------//
METHOD Send() CLASS SendMail 
LOCAL cServer, cAccount, cPassword, lAutentica, cUserAut, cPassAut
local oServer  := Nil
local oMessage := Nil
local nErr     := 0   
local lOk	   :=.t.

cPOP := ::cPop
IF empty(cPOP) .and. EMPTY((cPOP:=AllTrim(GetNewPar("MV_WFPOP3",""))))
   ::cLogMsg := "Nome do Servidor POP nao definido no 'MV_WFPOP3'"
   if ::lEchoMsg 
     IF !::lShedule
        MSGINFO(::cLogMsg)
     ELSE
        ConOut(::cLogMsg)
     ENDIF
   endif  
   RETURN .F.
ENDIF

cServer:= ::cSmtp

IF empty(cServer) .and. EMPTY((cServer:=AllTrim(GetNewPar("MV_RELSERV",""))))
   ::cLogMsg := "Nome do Servidor de Envio de E-mail nao definido no 'MV_RELSERV'"
   if ::lEchoMsg 
     IF !::lShedule
        MSGINFO(::cLogMsg)
     ELSE
        ConOut(::cLogMsg)
     ENDIF
   endif  
   RETURN .F.
ENDIF

cAccount:= ::cAccount

IF empty(cAccount) .and. EMPTY((cAccount:=AllTrim(GetNewPar("MV_RELACNT",""))))
   ::cLogMsg := "Conta para acesso ao Servidor de E-mail nao definida no 'MV_RELACNT'"
   if ::lEchoMsg 
     IF !::lShedule
        MSGINFO(::cLogMsg)
     ELSE
        ConOut(::cLogMsg)
     ENDIF
   endif  
   RETURN .F.   
ENDIF   

IF EMPTY(::cTo)
   ::cLogMsg := "E-mail para envio, nao informado."
   if ::lEchoMsg 
     IF !::lShedule
        MSGINFO(::cLogMsg)
     ELSE
        ConOut(::cLogMsg)
     ENDIF
   endif  
   RETURN .F.   
ENDIF   

IF EMPTY(::cFrom)
   ::cLogMsg := "E-mail de envio, nao informado."
   if ::lEchoMsg 
     IF !::lShedule
        MSGINFO(::cLogMsg)
     ELSE
        ConOut(::cLogMsg)
     ENDIF
   endif  
   RETURN .F.   
ENDIF  


::cCC  := ::cCC + SPACE(200)
::cTo  := ::cTo + SPACE(200)
::cSubject:=::cSubject+SPACE(100)

cAttachment:=::cFile

cPassword := ::cPsw
if empty(cPassword)
  cPassword := AllTrim(GetNewPar("MV_RELPSW"," "))  
endif         
lAutentica:= GetMv("MV_RELAUTH",,.F.)         //Determina se o Servidor de Email necessita de Autentica็ใo

cUserAut  := ::cAthAcc
if empty(cUserAut)
  cUserAut  := Alltrim(GetMv("MV_RELAUSR",," "))//Usuแrio para Autentica็ใo no Servidor de Email 
endif   

cPassAut  := ::cAthPsw
if empty(cPassAut)
  cPassAut  := Alltrim(GetMv("MV_RELAPSW",," "))//Senha para Autentica็ใo no Servidor de Email 
endif   

// Instancia um novo TMailManager
oServer := tMailManager():New()    

if GetMv("MV_RELSSL",,.F.)
  // Usa SSL na conexao
  oServer:setUseSSL(.T.) 
Endif

if GetMv("MV_RELTLS",,.F.)
  // Usa SSL na conexao
  oServer:setUseTLS(.T.) 
Endif

_nSMTPPort:=::nSMTPPort
_nPOPPort:=::nPOPPort
if At(':',cServer)>0
  _nSMTPPort:=Val(Substr(cServer,At(':',cServer)+1)) 
  cServer:=Substr(cServer,1,At(':',cServer)-1)   
endif


// Inicializa
oServer:init(cPOP, cServer, cAccount, cPassword, _nPOPPort, _nSMTPPort)

// Define o Timeout SMTP
if oServer:SetSMTPTimeout(::nSMTPTime) != 0
   ::cLogMsg := "[ERROR]Falha ao definir timeout "
   if ::lEchoMsg 
     IF !::lShedule
        MSGINFO(::cLogMsg)
     ELSE
        ConOut(::cLogMsg)
     ENDIF
   endif  
   return .F.
endif

// Conecta ao servidor
nErr := oServer:smtpConnect()
if nErr <> 0
   ::cLogMsg := "[ERROR]Falha ao conectar: " + oServer:getErrorString(nErr)
   if ::lEchoMsg 
     IF !::lShedule
        MSGINFO(::cLogMsg)
     ELSE
        ConOut(::cLogMsg)
     ENDIF
   endif  
  oServer:smtpDisconnect()
  return .F.
endif
                      
If lAutentica
// Realiza autenticacao no servidor
nErr := oServer:smtpAuth(cUserAut,cPassAut)
if nErr <> 0
   ::cLogMsg := "[ERROR]Falha ao autenticar: " + oServer:getErrorString(nErr)
   if ::lEchoMsg 
     IF !::lShedule
        MSGINFO(::cLogMsg)
     ELSE
        ConOut(::cLogMsg)
     ENDIF
   endif  
  oServer:smtpDisconnect()
  return .F.
endif
Endif

// Cria uma nova mensagem (TMailMessage)
oMessage := tMailMessage():new()
oMessage:clear()
oMessage:cFrom    := ::cFrom
oMessage:cTo      := ::cTo   
If !EMPTY(::cCC)
  oMessage:cCC      := ::cCC
Endif  
If !EMPTY(::cBCC)
  oMessage:cBCC      := ::cBCC
Endif  

oMessage:cSubject := ::cSubject
oMessage:cBody    := ::cBody
                                        
// Envia a mensagem
nErr := oMessage:send(oServer)
if nErr <> 0
     ::cLogMsg := "[ERROR]Falha ao enviar: " + oServer:getErrorString(nErr)
     if ::lEchoMsg 
       IF !::lShedule
          MSGINFO(::cLogMsg)
       ELSE
          ConOut(::cLogMsg)
       ENDIF
     endif  
  oServer:smtpDisconnect()
  return .F.
endif

// Disconecta do Servidor
oServer:smtpDisconnect()

IF lOk 
     ::cLogMsg := "E-mail enviado com sucesso."
     if ::lEchoMsg 
       IF !::lShedule
          MSGINFO(::cLogMsg)
       ELSE
          ConOut(::cLogMsg)
       ENDIF
     endif  
ENDIF   

RETURN lOk 

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณExtract   บAutor  ณClaudio Ferreira    บ Data ณ  22/10/08   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Classe para Extrair Drive/Path e Nome do arquivo do cFile  บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ                  										  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
CLASS Extract
DATA cDrive
DATA cPath 
DATA cFullPath
DATA cFile
DATA cExt     
DATA cFileName
METHOD new() constructor
METHOD SetFile(_cFile)
ENDCLASS

//------------------------------------------------------------------------//
METHOD new() CLASS Extract
::cDrive :=""
::cPath :=""
::cFullPath :=""
::cFile :=""
::cFileName :=""
::cExt :=""
Return Self

//------------------------------------------------------------------------//
METHOD SetFile(_cFile) CLASS Extract
LOCAL cDrive     := ""
LOCAL cDir       := ""

SplitPath(_cFile, @cDrive, @cDir )
cDir := Alltrim(cDrive) + Alltrim(cDir)
::cDrive     := cDrive
::cFullPath  := Strtran(cDir,'/','\') 
::cPath      := Strtran(lower(::cFullPath),lower(::cDrive),'')
::cFileName  := Strtran(lower(_cFile),lower(cDir),'')
::cExt       := Substr(::cFileName,at('.',::cFileName),len(::cFileName)-at('.',::cFileName)+1)
::cFile      := Strtran(lower(::cFileName),lower(::cExt),'')
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณSplitLine บAutor  ณFrederico F Duarte  บ Data ณ  18/09/07   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Fun็ใo para quebrar linha em partes resultantes num array  บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ                  										  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User function SplitLine(_cStr,_cSep) 
Local _aRet := {}, _cTemp

_cStr += IIF(right(_cStr,len(_cSep))#_cSep,_cSep,"")

DO WHILE len(_cStr) > 0
	_cTemp := subStr(_cStr,1,at(_cSep,_cStr) - len(_cSep))
	_cStr  := subStr(_cStr,at(_cSep,_cStr) + len(_cSep))
	aAdd(_aRet,_cTemp)
ENDDO

Return _aRet


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณSplitText บAutor  ณClaudio Ferreira    บ Data ณ  24/01/09   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Fun็ใo para quebrar texto em partes resultantes num array  บฑฑ
ฑฑบ          ณ Utiliza quebra inteligente para quebrar no espa็o em brancoบฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ                  										  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User function SplitText(_cText,_nTam,_cChar) 
Local _aRet := {}, _cAux,_cAux2, cAux
Default _cChar:=".,:; "

	cAux := Alltrim(_cText)
	
	While !Empty(cAux)
		_cAux := SubStr(cAux,1,_nTam)
		_cAux2:= _cAux
		If len(cAux) > _nTam  		
		  While !right(_cAux,1)$_cChar  .and. !SubStr(cAux,_nTam+1,1)$_cChar
			_cAux := left(_cAux,len(_cAux) - 1)
			if empty(_cAux) //Nใo conseguiu quebrar
			  _cAux := _cAux2 //Recupera string salva
			  exit
			endif
		  EndDo
        Endif
     	aAdd(_aRet,_cAux)  
     	cAux := SubStr(cAux,len(_cAux) + 1)
     	While left(cAux,1)$_cChar
     	  cAux := Right(cAux,len(cAux) - 1)
		Enddo
	EndDo

Return _aRet
           
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณSqlRet    บAutor  ณClแudio Ferreira    บ Data ณ  14/01/09   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Fun็ใo para retornar o campo via SQL                       บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณu_SqlRet(cCampo,cCond)									  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function SqlRet(cCampo,cCond,cEmp)
Local  cAlias:= Alias()
Local cQuery:=''
Local QAux,Retorno
Local cTabela:=Substr(cCampo,1,At('_',cCampo)-1) 
Local cFil:=cTabela+'_FILIAL'  
Default cEmp:=''

cTabela:=iif(len(cTabela)==2,"S","")+cTabela

if empty(cEmp)
  cFrom:=RetSqlName(cTabela)
else
  cFrom:=cTabela+cEmp+'0'
endif 
         
	cQuery := "SELECT "+cCampo+" as cRet  FROM "+cFrom+" WHERE "
	cQuery += "D_E_L_E_T_<>'*' AND "
	cQuery += cFil+" = '"+xfilial(cTabela)+"' AND  "
	cQuery += cCond
	cQuery:=Changequery(cQuery)
	TCQUERY cQuery NEW ALIAS "QAux"
	Retorno:=QAux->cRet
	QAux->(dbCloseArea())
    
dbselectarea(cAlias)    
Return Retorno  

User Function GeraGNRE


WinExec("C:\PROGRA~1\GNRE\GNRE.exe d:\gnre.txt")      

Return


User Function ConsContrib(cIE,cUF,lView) 
Local cURL      := PadR(GetNewPar("MV_SPEDURL","http://"),250)
Local cSituacao := '9'

if !empty(cIE+cUF) .and.  !'ISENT'$UPPER(cIE) //.and. IsReady(cURL)
   cSituacao :=ConsCad(cIE,cUF,lView)
endif   
                                       
Return cSituacao

/*/{Protheus.doc} ConsCad
Funcao realiza a consulta do contribuinte junto a SEFAZ.

@author  David Moraes
@since 04/10/2012
@version 1.0 

@param cIE, character, Inscri็ใo Estadual
@param cUF, character, Unidade Federativa (Estado)
/*/
Static Function ConsCad(cIE,cUF,lView)        

Local cURL       := PadR(GetMv("MV_SPEDURL"),250)
Local cIdEnt     := "" 
Local cRazSoci   := ""	
Local cRegApur   := ""
Local cCnpj      := ""
Local cCpf       := ""
Local cSituacao  := ""   
Local cPictCNPJ  := "" 

Local dIniAtiv   := Date()
Local dAtualiza  := Date()

Local nX         := {}

Local cSituacao:='9'

Private oWS

cIdEnt := GetIdEnt()

oWs:= WsNFeSBra() :New()
oWs:cUserToken    := "TOTVS"
oWs:cID_ENT       := cIdEnt
oWs:cUF           := cUF
oWs:cCNPJ         := ""
oWs:cCPF          := ""
oWs:cIE           := Alltrim(cIE)
oWS:_URL          := AllTrim(cURL)+"/NFeSBRA.apw"

If oWs:CONSULTACONTRIBUINTE()

	If Type("oWs:OWSCONSULTACONTRIBUINTERESULT:OWSNFECONSULTACONTRIBUINTE") <> "U" 
		If ( Len(oWs:OWSCONSULTACONTRIBUINTERESULT:OWSNFECONSULTACONTRIBUINTE) > 0 )
			nX := Len(oWs:OWSCONSULTACONTRIBUINTERESULT:OWSNFECONSULTACONTRIBUINTE)

			If ValType(oWs:OWSCONSULTACONTRIBUINTERESULT:OWSNFECONSULTACONTRIBUINTE[nX]:dInicioAtividade) <> "U"			
				dIniAtiv  := oWs:OWSCONSULTACONTRIBUINTERESULT:OWSNFECONSULTACONTRIBUINTE[nX]:dInicioAtividade
		   	Else
				dIniAtiv  := ""
			EndIf            
			cRazSoci  := oWs:OWSCONSULTACONTRIBUINTERESULT:OWSNFECONSULTACONTRIBUINTE[nX]:cRazaoSocial
			cRegApur  := oWs:OWSCONSULTACONTRIBUINTERESULT:OWSNFECONSULTACONTRIBUINTE[nX]:cRegimeApuracao
			cCnpj     := oWs:OWSCONSULTACONTRIBUINTERESULT:OWSNFECONSULTACONTRIBUINTE[nX]:cCNPJ
			cCpf      := oWs:OWSCONSULTACONTRIBUINTERESULT:OWSNFECONSULTACONTRIBUINTE[nX]:cCPF
		   	cIe       := oWs:OWSCONSULTACONTRIBUINTERESULT:OWSNFECONSULTACONTRIBUINTE[nX]:cIE
		   	cUf       := oWs:OWSCONSULTACONTRIBUINTERESULT:OWSNFECONSULTACONTRIBUINTE[nX]:cUF
			cSituacao := oWs:OWSCONSULTACONTRIBUINTERESULT:OWSNFECONSULTACONTRIBUINTE[nX]:cSituacao	

		  	If ValType(oWs:OWSCONSULTACONTRIBUINTERESULT:OWSNFECONSULTACONTRIBUINTE[nX]:dUltimaSituacao) <> "U"
			  	dAtualiza := oWs:OWSCONSULTACONTRIBUINTERESULT:OWSNFECONSULTACONTRIBUINTE[nX]:dUltimaSituacao           
			Else
				dAtualiza := ""
			EndIf

			If ( cSituacao == "1" )
				cSituacao := "1 - Habilitado"		//"1 - Habilitado"
			ElseIf ( cSituacao == "0" )
				cSituacao := "0 - Nใo Habilitado"	//"0 - Nใo Habilitado"
			EndIf 
			
 
			If ( !Empty(cCnpj) ) 
				cCnpj		:= cCnpj
				cPictCNPJ	:= "@R 99.999.999/9999-99"
			Else  
				cCnpj		:= cCPF
				cPictCNPJ	:= "@R 999.999.999-99"
			EndIf
			
			DEFINE FONT oFont BOLD
			if lView
		
			DEFINE MSDIALOG oDlgKey TITLE "Retorno do Consulta Contribuinte" FROM 0,0 TO 200,355 PIXEL OF GetWndDefault()  //"Retorno do Consulta Contribuinte"
			
			@ 008,010 SAY "Inํcio das Atividades:"	PIXEL FONT oFont OF oDlgKey		//"Inํcio das Atividades:"
			@ 008,072 SAY If(Empty(dIniAtiv),"",DtoC(dIniAtiv))	 PIXEL OF oDlgKey
			@ 008,115 SAY "UF:"	PIXEL FONT oFont OF oDlgKey		//"UF:"
			@ 008,124 SAY cUf		PIXEL OF oDlgKey
			@ 020,010 SAY "Razใo Social:"	PIXEL FONT oFont OF oDlgKey		//"Razใo Social:"
			@ 020,048 SAY cRazSoci	PIXEL OF oDlgKey		
			@ 032,010 SAY "CNPJ/CPF:"	PIXEL FONT oFont OF oDlgKey		//"CNPJ/CPF:"
			@ 032,040 SAY cCnpj		PIXEL PICTURE cPictCNPJ OF oDlgKey		
			@ 032,115 SAY "IE:"	PIXEL FONT oFont OF oDlgKey		//"IE:"
			@ 032,123 SAY cIe		PIXEL OF oDlgKey		
			@ 044,010 SAY "Regime:"	PIXEL FONT oFont OF oDlgKey		//"Regime:"
			@ 044,035 SAY cRegApur	PIXEL OF oDlgKey		      	
			@ 056,010 SAY "Situa็ใo:"	PIXEL FONT oFont OF oDlgKey		//"Situa็ใo:"
			@ 056,038 SAY cSituacao	PIXEL OF oDlgKey             	
			@ 068,010 SAY "Atualizado em:"	PIXEL FONT oFont OF oDlgKey		//"Atualizado em:"
  			@ 068,055 SAY If(Empty(dAtualiza),"",DtoC(dAtualiza))	 PIXEL OF oDlgKey
			
			@ 80,137 BUTTON oBtnCon PROMPT "Ok" SIZE 38,11 PIXEL ACTION oDlgKey:End()	//"Ok"
		
			ACTIVATE DIALOG oDlgKey CENTERED		  
		    Endif
		EndIf
	EndIf	
Else         
    if lView
	  Aviso("SPED",IIf(Empty(GetWscError(3)),GetWscError(1),GetWscError(3)),{'ERRO'},3)
	endif  
EndIf
				
Return cSituacao           



User Function MA030ROT
	//Aadd(aRotina, { 'Consulta Sefaz',  "U_A030Consut" , 0 ,0,0, NIL })//menu cliente
   Aadd(aRotina, { 'VALIDA CNPJ',  "U_vAlcnpj" , 0 ,0,0, NIL })//menu cliente
Return

User Function A030Consut
	Alert(u_ConsContrib(SA1->A1_INSCR,SA1->A1_EST,.T.))
Return
 
        
             
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณToExcel   บAutor  ณClaudio Ferreira    บ Data ณ  23/12/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Classe para exportar para Excel                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ CMS             								            		  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
CLASS ToExcel
DATA aExcel
DATA aStyle
Data aColumn
METHOD new() constructor
METHOD addColumn()
METHOD addStyle()
METHOD addSheet()
METHOD addRow()
METHOD addCell()
METHOD clear()
METHOD execute()
ENDCLASS

//------------------------------------------------------------------------//
METHOD new() CLASS ToExcel
::aExcel := {}
::aStyle := {}
::aColumn:= {}
aadd(::aStyle,{"Default",'<Alignment ss:Vertical="Bottom"/> <Borders/> <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="10" ss:Color="#000000"/>  <Interior/>   <NumberFormat/>    <Protection/>'})
Return Self

//------------------------------------------------------------------------//
METHOD addColumn(aColumn) CLASS ToExcel
aAdd(::aColumn,aColumn)
Return 

//------------------------------------------------------------------------//
METHOD addStyle(aStyle) CLASS ToExcel
aAdd(::aStyle,aStyle)
Return 

//------------------------------------------------------------------------//
METHOD addSheet(addSheet) CLASS ToExcel
aAdd(::aExcel,addSheet)
Return Len(::aExcel)

//------------------------------------------------------------------------//
METHOD addRow(nSheet,aRow) CLASS ToExcel
aAdd(::aExcel[nSheet][2],aRow)
Return Len(::aExcel[nSheet][2])

//------------------------------------------------------------------------//
METHOD addCell(nSheet,nRow,aCell) CLASS ToExcel
Local i
for i:=1 to 7-Len(aCell) 
  aAdd(aCell,'')
next i
aAdd(::aExcel[nSheet][2][nRow][2],aCell)
Return

//------------------------------------------------------------------------//
METHOD clear() CLASS ToExcel
::aExcel := {}
Return

//------------------------------------------------------------------------//
METHOD execute() CLASS ToExcel
LOCAL cDirDocs   := MsDocPath()
Local cArquivo := CriaTrab(,.F.)
Local cPath		:= AllTrim(GetTempPath())
Local oExcelApp
Local nHandle
Local cCrLf 	:= Chr(13) + Chr(10)
Local nHandle := MsfCreate(cDirDocs+"\"+cArquivo+".xml",0)
Local i,ii,iii, c	

If nHandle > 0
  fWrite(nHandle, '<?xml version="1.0"?>' )
  fWrite(nHandle, cCrLf ) // Pula linha
  fWrite(nHandle, '<?mso-application progid="Excel.Sheet"?>' )
  fWrite(nHandle, cCrLf ) // Pula linha
  fWrite(nHandle, '<Workbook xmlns="urn:schemas-microsoft-com:office:spreadsheet" xmlns:o="urn:schemas-microsoft-com:office:office"  xmlns:x="urn:schemas-microsoft-com:office:excel"  xmlns:ss="urn:schemas-microsoft-com:office:spreadsheet"  xmlns:html="http://www.w3.org/TR/REC-html40">' )
  fWrite(nHandle, cCrLf ) // Pula linha   
  fWrite(nHandle, '<Styles>' )
  fWrite(nHandle, cCrLf ) // Pula linha
  For i:=1 to Len(::aStyle)   
    fWrite(nHandle, '<Style ss:ID="'+::aStyle[i,1]+'">' )
    fWrite(nHandle, ::aStyle[i,2]+'</Style>')
    fWrite(nHandle, cCrLf ) // Pula linha
  Next i
  fWrite(nHandle, '</Styles>' )
  fWrite(nHandle, cCrLf ) // Pula linha
  For i:=1 to Len(::aExcel)  
    fWrite(nHandle, '<Worksheet ss:Name="'+::aExcel[i,1]+'">' )
    fWrite(nHandle, cCrLf ) // Pula linha
    fWrite(nHandle, '<Table>' )
    fWrite(nHandle, cCrLf ) // Pula linha
    For c:=1 to Len(::aColumn)   
      fWrite(nHandle, '<Column ss:Index="'+Alltrim(Str(::aColumn[c,1],4))+'" ss:AutoFitWidth="0" ss:Width="'+Alltrim(Str(::aColumn[c,2],4))+'"/>' )
      fWrite(nHandle, cCrLf ) // Pula linha
    Next c
    For ii:=1 to Len(::aExcel[i][2])  
      fWrite(nHandle, '<Row>' )
      fWrite(nHandle, cCrLf ) // Pula linha
      For iii:=1 to Len(::aExcel[i][2][ii][2])  
	     fWrite(nHandle, '<Cell'+iif(!Empty(::aExcel[i][2][ii][2][iii][1]),' ss:StyleID="'+::aExcel[i][2][ii][2][iii][1]+'"','')+;
	     iif(!Empty(::aExcel[i][2][ii][2][iii][4]),' ss:Formula="'+::aExcel[i][2][ii][2][iii][4]+'"','')+;
	     iif(!Empty(::aExcel[i][2][ii][2][iii][5]),' ss:Index="'+::aExcel[i][2][ii][2][iii][5]+'"','')+;
	     iif(!Empty(::aExcel[i][2][ii][2][iii][6]),' ss:MergeAcross="'+::aExcel[i][2][ii][2][iii][6]+'"','')+;
	     '>' )
	     fWrite(nHandle, '<Data ss:Type="'+::aExcel[i][2][ii][2][iii][2]+'">' )
	     fWrite(nHandle, ::aExcel[i][2][ii][2][iii][3])               
	     if !Empty(::aExcel[i][2][ii][2][iii][7])
	        cComment:='<Comment ss:Author="TBCGO"><ss:Data xmlns="http://www.w3.org/TR/REC-html40"><B><Font html:Face="Tahoma" '+;
            'x:CharSet="1" html:Size="9" html:Color="#000000">'+AllTrim(UsrRetName(RetCodUsr()))+':</Font></B><Font html:Face="Tahoma" x:CharSet="1" '+;
            'html:Size="9" html:Color="#000000">&#10;'+::aExcel[i][2][ii][2][iii][7]+'</Font></ss:Data></Comment>'  
         else    
		    cComment:=''
         endif   
	     fWrite(nHandle, '</Data>'+cComment+'</Cell>' )
   	  fWrite(nHandle, cCrLf ) // Pula linha
      Next iii
      fWrite(nHandle, '</Row>' )
      fWrite(nHandle, cCrLf ) // Pula linha
    Next ii
    fWrite(nHandle, '</Table>' )
    fWrite(nHandle, cCrLf ) // Pula linha
    fWrite(nHandle, '</Worksheet>' )
    fWrite(nHandle, cCrLf ) // Pula linha
  Next i
  fWrite(nHandle, '</Workbook>' )
  fWrite(nHandle, cCrLf ) // Pula linha
  fClose(nHandle)
  
  If !ApOleClient("com.sun.star.ServiceManager") .AND.  !ApOleClient("MSExcel")
	//Local onde o arquivo sera salvo.
	cPath := cGetFile ( '*.xml' , 'Salvar arquivo Excel', 1, 'C:\TEMP', .F., GETF_LOCALHARD + GETF_NETWORKDRIVE,.F.,.T.)
	cPath += ".xml"      
  Endif   
  cDrive     := ""
  cDir       := ""
  SplitPath(cPath, @cDrive, @cDir )
  cDir := Alltrim(cDrive) + Alltrim(cDir)
  CpyS2T( cDirDocs+"\"+cArquivo+".xml" , cDir, .T. )
  FErase(cDirDocs+"\"+cArquivo+".xml")
  If !ApOleClient("com.sun.star.ServiceManager") .AND.  !ApOleClient("MSExcel")
		MsgAlert( 'MsExcel nao instalado'+chr(13)+chr(10)+chr(13)+chr(10)+'O arquivo foi salvo em '+ cPath) //
  Else
	  oExcelApp := MsExcel():New()
	  oExcelApp:WorkBooks:Open( cPath+cArquivo+".xml" ) // Abre uma planilha
	  oExcelApp:SetVisible(.T.)
  EndIf
   
Else
	MsgAlert( "Falha na cria็ใo do arquivo" ) //
Endif
Return Self                     
