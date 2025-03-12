#INCLUDE "protheus.ch"
#INCLUDE "rwmake.ch"
#INCLUDE "topconn.ch"

/*
_____________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦Programa  ¦ RESTM001    ¦ Autor ¦                  ¦ Data ¦ 01/01/2001 ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Descriçào ¦ Rotina de Ajuste de Saldos de estoque     				  ¦¦¦
¦¦¦          ¦                                                            ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Uso       ¦             		                                          ¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
*/
User Function RESTM001()

Private oDlg08 

//variaveis dos parametros
Private cPerg := "RESTM001"

AjustaSX1()
//Pergunte(cPerg,.T.) //chama perguntas antes da tela explicativa
 
//Montando Dialog para parametrização
@ 200,1 TO 420,410 DIALOG oDlg08 TITLE OemToAnsi("Ajuste de Saldos")
@ 10,10 TO 080,197
@ 20,018 Say " Este programa tem o objetivo de efetuar movimentos de ajuste "
@ 28,018 Say " de saldos. Utilize os parâmetros para preparar "
@ 36,018 Say " as configurações do processamento."

@ 90,018 BMPBUTTON TYPE 15 ACTION ProcLogView(,"RESTM001")
@ 90,108 BMPBUTTON TYPE 05 ACTION Pergunte(cPerg,.T.)
@ 90,138 BMPBUTTON TYPE 01 ACTION OkVldParam()
@ 90,168 BMPBUTTON TYPE 02 ACTION Close(oDlg08)



Activate Dialog oDlg08 Centered 

Return 

/*
_____________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦Programa  ¦ OkVldParam    ¦ Autor ¦ Totvs          ¦ Data ¦ 10/03/2021 ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Descriçào ¦ Faz validaçao para o Processamento da rotina               ¦¦¦
¦¦¦          ¦                                                            ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Uso       ¦ TOTVS - GO		                                          ¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
*/
Static Function OkVldParam()

Local lRet := .T.

Pergunte(cPerg,.F.) //força criar parametros pelo grupo de perguntas

if lRet
	Processa({|| lRet := DoProcMov() },"Processando...")
	iif(lRet, Close(oDlg08),)//fecha dlg
endif


Return lRet


Static Function DoProcMov()
Local aArea
Local _cSQL := ""        
Local nCount := 0

Local lRet   := .t.
Local aMovimento := {}

Local dDatai := MV_PAR01
Local dDataf := MV_PAR02
Local cPrdi  := MV_PAR03
Local cPrdf   := MV_PAR04
Local cTipoi   := MV_PAR05
Local cTipof := MV_PAR06
Local cLocal := MV_PAR07
Local cLocPara := MV_PAR08
Local olddDataBase := dDataBase


Private lMsErroAuto      := .F. //necessario a criacao
 
_cSQL:="SELECT * FROM " +RetSqlName("SB1")
_cSQL+=" WHERE D_E_L_E_T_<>'*' AND B1_FILIAL ='"+xFilial('SB1')+"' AND B1_LOCPAD = '"+cLocal+"' " 
_cSQL+="AND B1_COD >='"+cPrdi+"' AND B1_COD <='"+cPrdf+"' " 
_cSQL+="AND B1_TIPO >='"+cTipoi+"' AND B1_TIPO <='"+cTipof+"' " 
_cSQL+=" ORDER BY B1_COD,B1_LOCPAD "

_cSQL := ChangeQuery(_cSQL) //comando para evitar erros de incompatibilidade de bancos
    
if select("QRYSB1") > 0
	QRYSB1->(dbCloseArea())
endif

TcQuery _cSQL New Alias "QRYSB1" // Cria uma nova area com o resultado do query 

QRYSB1->(DbGoTop())

if QRYSB1->(EOF())
	MSGInfo("Não foram encontrados movimentos para o processamento.","Movimentos")
	lRet := .F.
endif

QRYSB1->(DbEval( {|| nCount++  } ) )

QRYSB1->(DbGoTop())
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿	
//³ Inicializa o log de processamento   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
ProcLogIni( {},"RESTM001")

ProcLogAtu("INICIO")
ProcRegua(nCount)
SBZ->(DbSetOrder(1))
SB1->(DbSetOrder(1))
if lRet     
	While QRYSB1->(!EOF())

			aArea   := GetArea()

			dDataBase := dDatai
			While dDataBase <= dDataf
			    if Dow(dDataBase) >=2 .and. Dow(dDataBase) <=6 //Seg  a Sexta 		    

					aMovimento:={}			            
					SB1->(DbSeek(xFilial('SB1') + QRYSB1->B1_COD ) )
					IncProc("Incluindo Movimentos...: "+Alltrim(SB1->B1_COD)+" - "+SB1->B1_DESC)
					nQtd    := CalcEst(SB1->B1_COD, SB1->B1_LOCPAD,dDataBase+1)[1] 
					nQtdAtu := CalcEst(SB1->B1_COD, SB1->B1_LOCPAD,LastDay(dDataBase)+1)[1] 
					//Verifica a origem do estoque maximo
					if SBZ->(DbSeek(xFilial('SBZ') + QRYSB1->B1_COD ) )
					  nStqMax := SBZ->BZ_EMAX  //Indicador de produtos
					else
					  nStqMax := SB1->B1_EMAX //Cadastro de produtos
                    endif
					if nQtd > nStqMax  .or. nQtd < nStqMax
					    nPerc = Randomize( 1, 10 )
					    if nQtd > nStqMax
					      nQtdLan := nQtd - nStqMax + ((nQtd - nStqMax)*(nPerc/100)) 
						  cLocOri := SB1->B1_LOCPAD
						  cLocDes := cLocPara
						  nDia 	  := 0
						  if (nQtdLan > nQtdAtu)
						  	ProcLogAtu("MENSAGEM",OemToAnsi("Prod "+Alltrim(SB1->B1_COD)+" - "+Substr(SB1->B1_DESC,1,20)+" Saldo Insuficiente "+cLocOri+"; Qtd Lanc:"+ Alltrim(Str(nQtdLan,16,2))+" Qtd Fim Mês:"+ Alltrim(Str(nQtdAtu,16,2))))
							exit   
						  endif						  
						else
						  nQtdLan := (nStqMax *(nPerc/100) ) + Abs(nQtd)
						  cLocOri := cLocPara
						  cLocDes := SB1->B1_LOCPAD
						  nDia 	  := -1
						  nQtdOri := CalcEst(SB1->B1_COD, cLocOri,dDataBase+1)[1] 
						  
						  if (nQtdOri <= 0)
						  	ProcLogAtu("MENSAGEM",OemToAnsi("Prod "+Alltrim(SB1->B1_COD)+" - "+Substr(SB1->B1_DESC,1,20)+" Saldo Insuficiente "+cLocOri+"; Qtd Lanc:"+ Alltrim(Str(nQtdLan,16,2))))
							exit   
						  endif	

						  nQtdLan := Min(nQtdLan,nQtdOri)
						endif

						 ProcLogAtu("MENSAGEM",OemToAnsi("Prod "+Alltrim(SB1->B1_COD)+" - "+Substr(SB1->B1_DESC,1,20)+ " LocOri: "+cLocOri+" LocaDes: "+cLocDes+" Qtd:"+ Alltrim(Str(nQtdLan,16,2)))) 
						// Transferencias
						aAutoCab    := {}
						aAutoItens  := {}

						aAuto       := {}
						aLinha      := {}

						// Cabeçalho
						aAdd(aAuto,{"",dDatabase+nDia}) 

						// Itens a Incluir
						// Origem
						aAdd(aLinha,{"D3_COD"       ,SB1->B1_COD        ,Nil}) //Cod Produto origem
						aAdd(aLinha,{"D3_DESCRI"    ,SB1->B1_DESC       ,Nil}) //descr produto origem
						aAdd(aLinha,{"D3_UM"        ,SB1->B1_UM         ,Nil}) //unidade medida origem
						aAdd(aLinha,{"D3_LOCAL"     ,cLocOri            ,Nil}) //armazem origem
						aAdd(aLinha,{"D3_LOCALIZ"   ,""                 ,Nil}) //Informar endereÃ§o origem


						// Destino
						aAdd(aLinha,{"D3_COD"       ,SB1->B1_COD        ,Nil}) //cod produto destino
						aAdd(aLinha,{"D3_DESCRI"    ,SB1->B1_DESC       ,Nil}) //descr produto destino
						aAdd(aLinha,{"D3_UM"        ,SB1->B1_UM         ,Nil}) //unidade medida destino
						aAdd(aLinha,{"D3_LOCAL"     ,cLocDes            ,Nil}) //armazem destino
						aadd(aLinha,{"D3_LOCALIZ"	, ""				,Nil}) //Informar endereÃ§o destino
						
						aadd(aLinha,{"D3_NUMSERI", "", Nil}) //Numero serie
						aadd(aLinha,{"D3_LOTECTL", "", Nil}) //Lote Origem
						aadd(aLinha,{"D3_NUMLOTE", "", Nil}) //sublote origem
						aadd(aLinha,{"D3_DTVALID", ctod(''), Nil}) //data validade
						aadd(aLinha,{"D3_POTENCI", 0, Nil}) // Potencia

						aAdd(aLinha,{"D3_QUANT"     ,nQtdLan            ,Nil}) //Quantidade
						aAdd(aLinha,{"D3_QTSEGUM"   ,0                  ,Nil}) //Seg unidade medida
						aAdd(aLinha,{"D3_ESTORNO"   ,""                 ,Nil}) //Estorno
						aAdd(aLinha,{"D3_NUMSEQ"    ,""                 ,Nil}) // Numero sequencia D3_NUMSEQ

						aAdd(aLinha,{"D3_LOTECTL"   ,""                 ,Nil}) //Lote destino
						aAdd(aLinha,{"D3_NUMLOTE"   ,""                 ,Nil}) //sublote destino
						aAdd(aLinha,{"D3_DTVALID"   ,ctod('')           ,Nil}) //validade lote destino
						aAdd(aLinha,{"D3_ITEMGRD"   ,""                 ,Nil}) //Item Grade

						aAdd(aLinha,{"D3_CODLAN"    ,""  		       ,Nil}) //cat83 prod origem
						aAdd(aLinha,{"D3_CODLAN"    ,""   		      ,Nil}) //cat83 prod destino


						aAdd(aAuto,aLinha)
					
						//aAuto := FWVetByDic(aAuto,"SD3",.T.)

						lMsErroAuto := .F.

						// Transferências
						MSExecAuto({|x,y| MATA261(x,y)},aAuto,3)
						If lMsErroAuto
							MostraErro()
							exit
						EndIF
					Endif
				endif
				dDataBase++
            Enddo
			If lMsErroAuto
				exit
			EndIF
			RestArea(aArea)				
			QRYSB1->(dbskip()) //proximo 		
	endDo  
endif
dDataBase	:= olddDataBase
QRYSB1->(dbCloseArea())


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Atualiza o log de processamento   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
ProcLogAtu("FIM")
Return lRet	


Static Function AjustaSX1()

/*
U_xputSx1( cPerg,"01","Data Inicio  ?","."     ,"."       ,"mv_CH1","D",08,0,0,"G","","","","","MV_PAR01","","","","","","","","","","","","","","","","")
U_xputSx1( cPerg,"02","Data Fim     ?","."     ,"."       ,"mv_CH2","D",08,0,0,"G","","","","","MV_PAR02","","","","","","","","","","","","","","","","")
U_xputSx1( cPerg,"03","Produto de   ?","."     ,"."       ,"mv_CH3","C",15,0,0,"G","","SB1","","","MV_PAR03","","","","","","","","","","","","","","","","")                        
U_xputSx1( cPerg,"04","Produto ate  ?","."     ,"."       ,"mv_CH4","C",15,0,0,"G","","SB1","","","MV_PAR04","","","","","","","","","","","","","","","","")                        
U_xputSx1( cPerg,"05","Tipo de      ?","."     ,"."       ,"mv_CH5","C",02,0,0,"G","","02","","","MV_PAR05","","","","","","","","","","","","","","","","")                        
U_xputSx1( cPerg,"06","Tipo ate     ?","."     ,"."       ,"mv_CH6","C",02,0,0,"G","","02","","","MV_PAR06","","","","","","","","","","","","","","","","")                        
U_xputSx1( cPerg,"07","Local Ori    ?","."     ,"."       ,"mv_CH7","C",02,0,0,"G","","","","","MV_PAR07","","","","","","","","","","","","","","","","")                        
U_xputSx1( cPerg,"08","Local Des    ?","."     ,"."       ,"mv_CH7","C",02,0,0,"G","","","","","MV_PAR08","","","","","","","","","","","","","","","","")                        
*/		
Return 
