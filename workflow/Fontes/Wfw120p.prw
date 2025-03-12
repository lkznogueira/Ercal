#Include "Protheus.Ch"
#Include "Ap5Mail.Ch"

#Define		NCRNIVEL	01
#Define		NCRAPROV	02
#Define		NCRSTATUS	03
#Define		NCRUSER		04

#Define		CRLF   		Chr(13) + Chr(10)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ WFW120P  บ Autor ณ Claudio Vilarinho  บ Data ณ  21/07/16   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ PONTO DE ENTRADA PARA ENVIO DO E-MAIL PARA A APROVAวรO     บฑฑ
ฑฑบ          ณ DO PEDIDO DE COMPRAS.                                      บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP11 IDE                                                   บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User Function WFW120P( nOpcao, oProcess , lShowMsg )

Local cNumPC	:= ""
//Local aAreaSCR	:= {}
Local cQuery	:= ""
Local aDadosSCR	:= {}
Local nI		:= 0

Default	lShowMsg:= .T.
Default	nOpcao 	:= 0

If 	ValType(nOpcao) = "A"
	nOpcao := nOpcao[1]
EndIf

//====================================================================================================
//ณCriacao do processo do WorkFlow.	                                         ณ
//====================================================================================================
If nOpcao <> 0 .And. oProcess == Nil
	oProcess := TWFProcess():New( "PEDCOM" , "Pedido de Compras" )
EndIf

Do Case
	
	Case nOpcao == 0 // Inicio do WorkFlow.
		
			//====================================================================================================
			//ณPosiciona no Pedido de Compra.					                         ณ
			//====================================================================================================
			If IsInCallStack("MATA120") .And. Type("ParamIxb") == "C"
			
				DBSelectArea("SC7")
				SC7->( DBSetOrder(1)) // C7_FILIAL+C7_NUM+C7_ITEM+C7_SEQUEN
				SC7->( DBSeek( ParamIxb ) )
				
			EndIf
			
			cNumPC := SC7->C7_NUM
			
			//====================================================================================================
			//ณMonta matriz com dados de aprovacao.				                         ณ
			//====================================================================================================
			aDadosSCR := {}
			
			If	IsInCallStack("MATA097")

				//====================================================================================================
				//ณSe chamado da aprovaca pelo sistema, a SCR esta filtrada, entao deve-se   ณ
				//ณfazer por query.															 ณ
				//====================================================================================================
				DBSelectArea("SCR")
				
				cQuery := " SELECT	SCR.* "
				cQuery += " FROM	"+RetSqlName("SCR")+"	SCR "
				cQuery += " WHERE	SCR.CR_FILIAL	= '"+xFilial("SCR")+"' "
				cQuery += " AND		SCR.CR_TIPO		= 'PC' "
				cQuery += " AND		SCR.CR_NUM		= '"+PadR(cNumPC,TamSx3("CR_NUM")[1])+"' "
				cQuery += " AND		SCR.CR_STATUS 	= '02' " // Em aprovacao.
				cQuery += " AND		SCR.D_E_L_E_T_	= '' "
				cQuery += " ORDER 	BY CR_FILIAL , CR_TIPO , CR_NUM , CR_NIVEL "
				
				cQuery	:= ChangeQuery(cQuery)
				DBUseArea(.T., "TOPCONN", TCGenQry(,,cQuery),"TRBSCR",.F.,.T.)
				
				DBSelectArea("TRBSCR")
				TRBSCR->( DBGoTop() )
				While TRBSCR->( !Eof() )

						aAdd( aDadosSCR ,  { TRBSCR->CR_NIVEL , TRBSCR->CR_APROV , TRBSCR->CR_STATUS , TRBSCR->CR_USER } )
						
				TRBSCR->( DBSkip() )
				EndDo
		        
				TRBSCR->( DBCloseArea() )
				
			Else

				DBSelectArea("SCR")
				SCR->( DBSetOrder(1 )) // CR_FILIAL+CR_TIPO+CR_NUM+CR_NIVEL
				SCR->( DBSeek( xFilial("SCR") + "PC" + PadR( cNumPC , TamSx3("CR_NUM")[1] ) ) )
				
				While SCR->( !Eof() ) .And. SCR->( CR_FILIAL + CR_TIPO + CR_NUM ) == xFilial("SCR") + "PC" + PadR( cNumPC , TamSx3("CR_NUM")[1] )
		  		
						If	SCR->CR_STATUS 	== "02"
							
							aAdd( aDadosSCR ,  { SCR->CR_NIVEL , SCR->CR_APROV , SCR->CR_STATUS , SCR->CR_USER } )
							
						EndIf
					
				SCR->( DBSkip() )
				EndDo
				
			EndIf
			
			For	nI := 1 To Len(aDadosSCR)
			
				//====================================================================================================
				//ณCriacao do processo do WorkFlow.					                         ณ
				//====================================================================================================
				oProcess := TWFProcess():New( "PEDCOM" , "Pedido de Compras" )
				
				//====================================================================================================
				//ณChama a funcao de envio do WorkFlow.				                         ณ
				//====================================================================================================
				If	lShowMsg
					FWMsgRun( , {|| fInicioWF( oProcess, cNumPC , aClone(aDadosSCR[nI]) ) } ,, "Enviando workflow de aprova็ใo! Aguarde..." )
				Else
					FInicioWF( oProcess , cNumPC , aClone( aDadosSCR[nI] ) )
				EndIF
				
				oProcess:Free()
				
	        Next nI
	        
	Case nOpcao == 1 // Retorno do WorkFlow.
		
		FRetornoWF( oProcess )
		oProcess:Free()
		
	Case nOpcao == 2  // TimeOut do WorkFlow.
		
		FTimeOutWF( oProcess )
		oProcess:Free()
		
EndCase

Return()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function FInicioWF( oProcess , cNumPC , aDadSCRAux )

Local cMailID 	:= ""
Local oHtml 	:= Nil
Local cQuery	:= ""
Local cCodForne	:= ""
Local cLojForne	:= ""
Local cNomForne	:= ""
Local nValTotPC	:= 0
//Local nQtdHistPC:= 03
Local cIDLink	:= ""
Local cMailTo   := ""
Local cSubAux	:= ""
Local cMailDest	:= ""
Local cArqHtml	:= ""
Local cHtmlWF	:= ""
Local aHistSCR	:= {}
Local nI		:= 0
Local lRateio	:= .F.
Local _nXF 		:= 0
//Local nTotal	:= 0
Local cUltPed

//====================================================================================================
//ณ Criacao de uma nova tarefa e abertura do HTML.                           ณ
//====================================================================================================
oProcess:NewTask( "PEDCOM" , "/workflow/wfw120p2.htm" )

oProcess:cSubject	:= "PC: " + cNumPC
oProcess:bReturn 	:= "U_WFW120P(1)"
oProcess:bTimeOut 	:= { { "U_WFW120P(2)" , 0 , 0 , 5 } }

oHtml 	:= oProcess:oHtml
cMailID	:= oProcess:Start()    //Inicio o Processo e guardo o ID do processo

//====================================================================================================
//ณ Posiciona no Pedido de Compra.				                             ณ
//====================================================================================================
DBSelectArea("SC7")
SC7->( DBSetOrder(1) ) // C7_FILIAL+C7_NUM+C7_ITEM+C7_SEQUEN
SC7->( DBSeek( xFilial("SC7") + cNumPC ) )

cCodForne	:= SC7->C7_FORNECE
cLojForne	:= SC7->C7_LOJA
cNomForne	:= AllTrim( Posicione( "SA2" , 1 , xFilial("SA2") + cCodForne + cLojForne , "A2_NOME" ) )

//====================================================================================================
//ณVerifica se o Pedido tem Rateio.											 ณ
//====================================================================================================
If ( SC7->C7_RATEIO == "1" )
	lRateio := .T.
EndIf

//====================================================================================================
//ณDados do aprovador corrente.				                             	 ณ
//====================================================================================================
oHtml:ValByName( "aprov_nivel" 	, aDadSCRAux[NCRNIVEL]				)
oHtml:ValByName( "aprov_cod"	, aDadSCRAux[NCRUSER]				)
oHtml:ValByName( "aprov_nome"	, UsrFullName(aDadSCRAux[NCRUSER])	)
oHtml:ValByName( "aprov_status"	, fStatusSCR(aDadSCRAux[NCRSTATUS])	)

//====================================================================================================
//ณDados do Cabecalho do HTML.				                             	 ณ
//====================================================================================================
oHtml:ValByName( "emissao"		, SC7->C7_EMISSAO												)
oHtml:ValByName( "lb_nome"		, Posicione("SA2",1,xFilial("SA2")+SC7->C7_FORNECE,"A2_NREDUZ")	)

DBSelectArea("SE4")
SE4->( DBSetOrder(1) )
SE4->( DBSeek( xFilial("SE4") + SC7->C7_COND ) )

oHtml:ValByName( "lb_cond"		, SE4->E4_DESCRI )
oHtml:ValByName( "pedido"		, SC7->C7_NUM ) 

oHtml:ValByName( "lb_filial"	, cFilAnt +" - "+ FWFilialName(cEmpAnt,cFilAnt,1) )
oHtml:ValByName( "lb_empresa"	, cEmpAnt +" - "+ SM0->M0_NOME ) //sigamat (apsdu)

oHtml:ValByName( "lb_compr"		, UsrFullName(SC7->C7_USER) )

//====================================================================================================
//ณDescricao do Processo.					                             	 ณ
//====================================================================================================
oProcess:fDesc := "Pedido de Compras [ "+ cNumPC +" ]."

//====================================================================================================
//ณTratamento dos Itens.					                             	 ณ
//====================================================================================================
While !SC7->( Eof() ) .And. SC7->( C7_FILIAL + C7_NUM ) = xFilial("SC7") + cNumPC

		nValTotPC += ( SC7->C7_TOTAL + SC7->C7_VALIPI )

		aAdd( (oHtml:ValByName( "produto.quant" 		) )	, Transform(SC7->C7_QUANT					,PesqPict("SC7","C7_QUANT"	) )	)
		aAdd( (oHtml:ValByName( "produto.descricao"		) )	, Posicione("SB1",1,xFilial("SB1")+SC7->C7_PRODUTO,"B1_DESC")				)
//		aAdd( (oHtml:ValByName( "produto.ccusto" 		) )	, IIF(lRateio,"RATEIO",AllTrim(SC7->C7_CC))									)
		//aAdd( (oHtml:ValByName( "produto.mercadoria"	) )	, Transform(SC7->C7_TOTAL					,PesqPict("SC7","C7_TOTAL"	) )	)
		//aAdd( (oHtml:ValByName( "produto.preco" 		) ) , Transform(SC7->C7_PRECO					,PesqPict("SC7","C7_PRECO"	) )	)	
		aAdd( (oHtml:ValByName( "produto.preco"         ) ) , Transform( SC7->C7_PRECO                  ,'@E 99,999.99'               ) )//alterado para leitura pre็o
//		aAdd( (oHtml:ValByName( "produto.valipi" 		) )	, Transform(SC7->C7_VALIPI					,PesqPict("SC7","C7_VALIPI"	) )	)
		aAdd( (oHtml:ValByName( "produto.total" 		) )	, Transform(SC7->C7_TOTAL + SC7->C7_VALIPI	,PesqPict("SC7","C7_TOTAL"	) )	)
		aAdd( (oHtml:ValByName( "produto.obs"			) )	, Transform(SC7->C7_OBS						,PesqPict("SC7","C7_OBS" 	) )	)
//		aAdd( (oHtml:ValByName( "produto.corcam"		) )	, Transform(SC7->C7_CO						,PesqPict("SC7","C7_CO" 	) )	)

SC7->(DBSkip())
Enddo

//====================================================================================================
//ณSequencia de aprovacao de acordo com o controle de alcadas.             	 ณ
//====================================================================================================
If	IsInCallStack("MATA097")

	//====================================================================================================
	//ณSe chamado da aprovaca pelo sistema, a SCR esta filtrada, entao deve-se   ณ
	//ณfazer por query.															 ณ
	//====================================================================================================
	DBSelectArea("SCR")

	cQuery := " SELECT	SCR.* "
	cQuery += " FROM	"+RetSqlName("SCR")+"	SCR "
	cQuery += " WHERE	SCR.CR_FILIAL	= '"+xFilial("SCR")+"' "
	cQuery += " AND		SCR.CR_TIPO		= 'PC' "
	cQuery += " AND		SCR.CR_NUM		= '"+PadR(cNumPC,TamSx3("CR_NUM")[1])+"' "
	cQuery += " AND		SCR.D_E_L_E_T_	= '' "
	cQuery += " ORDER 	BY CR_FILIAL , CR_TIPO , CR_NUM , CR_NIVEL "
	
	cQuery	:= ChangeQuery(cQuery)
	DBUseArea(.T., "TOPCONN", TCGenQry(,,cQuery),"TRBSCR2",.F.,.T.)
	
	DBSelectArea("TRBSCR2")
	TRBSCR2->(DBGoTop())
		
	While	!TRBSCR2->(Eof())
	
			aAdd( aHistSCR ,  { TRBSCR2->CR_NIVEL , TRBSCR2->CR_APROV , TRBSCR2->CR_STATUS , TRBSCR2->CR_USER } )

	TRBSCR2->(DBSkip())
	EndDo
	
	TRBSCR2->(DBCloseArea())

Else

	DBSelectArea("SCR")
	SCR->( DBSetOrder(1) ) // CR_FILIAL+CR_TIPO+CR_NUM+CR_NIVEL
	SCR->( DBSeek( xFilial("SCR") + "PC" + PadR( cNumPC , TamSx3("CR_NUM")[1] ) ) )
	
	While 	!SCR->( Eof() ) .And. SCR->( CR_FILIAL + CR_TIPO + CR_NUM ) == xFilial("SCR") + "PC" + PadR( cNumPC , TamSx3("CR_NUM")[1] )
                                                                  
			aAdd( aHistSCR ,  { SCR->CR_NIVEL , SCR->CR_APROV , SCR->CR_STATUS , SCR->CR_USER } )

	SCR->(DBSkip())
	EndDo              

EndIf
	
For	nI := 1 To Len(aHistSCR)

	DBSelectArea("SAK")	
	SAK->(DBGoTop())

	aAdd( (oHtml:ValByName( "cr.nivel" 	)), aHistSCR[nI][NCRNIVEL] )
	aAdd( (oHtml:ValByName( "cr.nombre"	)), UsrFullName(aHistSCR[nI][NCRUSER]))
	aAdd( (oHtml:ValByName( "cr.status"	)), fStatusSCR(aHistSCR[nI][NCRSTATUS]))

Next nI

//====================================================================================================
//ณHistorico dos ultimos Pedidos de Compra do Fornecedor.	             	 ณ
//====================================================================================================
/*
cQuery := " SELECT TOP 3"
cQuery += " 	SUBSTRING(SC7.C7_EMISSAO,1,4) 		AS ANO		, "
cQuery += " 	SUBSTRING(SC7.C7_EMISSAO,5,2) 		AS MES		, "
cQuery += " 	SUM(SC7.C7_TOTAL + SC7.C7_VALIPI) 	AS TOTAL	  "
cQuery += " FROM 	"+ RetSqlName("SC7") +" SC7 "
cQuery += " WHERE	SC7.D_E_L_E_T_	=  '' "
cQuery += " AND		SC7.C7_FORNECE 	=  '"+ cCodForne +"' " 
cQuery += " AND		SC7.C7_LOJA 	=  '"+ cLojForne +"' " 
cQuery += " AND		SC7.C7_NUM 		!= '"+ cNumPC   +"' "
cQuery += " AND		SC7.C7_CONAPRO	=  'L' "
cQuery += " AND		CONVERT( DATETIME , SC7.C7_EMISSAO , 122 ) > DATEADD( m , -("+ AllTrim( STR( nQtdHistPc ) ) +"), GETDATE() ) "
cQuery += " GROUP 	BY SUBSTRING(SC7.C7_EMISSAO,1,4) , SUBSTRING(SC7.C7_EMISSAO,5,2) "
cQuery += " ORDER 	BY SUBSTRING(SC7.C7_EMISSAO,1,4) DESC, SUBSTRING(SC7.C7_EMISSAO,5,2) DESC "
*/

//====================================================================================================
//ณฺltimo pedido de venda - Vilarinho                    	             	 ณ
//====================================================================================================

cQuery := " SELECT MAX(C7_NUM) AS ULTPED FROM "+ RetSqlName("SC7") +" SC7 "
cQuery += " WHERE D_E_L_E_T_ = ' ' "
cQuery += "	AND SC7.C7_FORNECE = '"+ cCodForne +"' "
cQuery += "	AND SC7.C7_LOJA = '"+ cLojForne +"' "
cQuery += "	AND SC7.C7_NUM != '"+ cNumPC   +"' "

If Select("TRBUPC") > 0
	TRBUPC->(DBCloseArea())
EndIf

cQuery	:= ChangeQuery(cQuery)
DBUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), "TRBUPC",.F.,.T.)

DBSelectArea("TRBUPC")
TRBUPC->(DBGoTop())

cUltPed := TRBUPC->ULTPED

TRBUPC->(DBCloseArea())


cQuery := " SELECT "
cQuery += " 	C7_NUM, C7_ITEM, C7_PRODUTO, B1_DESC, C7_QUANT, C7_PRECO, C7_TOTAL "
cQuery += " FROM 	"+ RetSqlName("SC7") +" SC7 "
cQuery += " 	INNER JOIN "+ RetSqlName("SB1") +" SB1 ON B1_COD = C7_PRODUTO "
cQuery += " WHERE	SC7.D_E_L_E_T_	=  '' "
cQuery += " AND SB1.D_E_L_E_T_	=  '' "
cQuery += " AND		SC7.C7_FORNECE 	=  '"+ cCodForne +"' " 
cQuery += " AND		SC7.C7_LOJA 	=  '"+ cLojForne +"' " 
cQuery += " AND		SC7.C7_NUM 		=  '"+ cUltPed   +"' "
cQuery += " AND		SC7.C7_CONAPRO	=  'L' "
cQuery += " ORDER 	BY C7_ITEM "

If Select("TRBHPC") > 0
	TRBHPC->(DBCloseArea())
EndIf

cQuery	:= ChangeQuery(cQuery)
DBUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), "TRBHPC",.F.,.T.)

DBSelectArea("TRBHPC")
TRBHPC->(DBGoTop())

TCSetField( "TRBHPC" , "TOTAL" , "N" , TAMSX3("C7_TOTAL")[1] , TAMSX3("C7_TOTAL")[2] )

DBSelectArea("TRBHPC")

If 	!TRBHPC->(Eof())

	While 	TRBHPC->(!EOF())
	
//		aAdd( ( oHtml:ValByName( "cp.refer"	) ) , TRBHPC->MES + "/" + TRBHPC->ANO						)
//		aAdd( ( oHtml:ValByName( "cp.total"	) ) , Transform(TRBHPC->TOTAL,PesqPict("SC7","C7_TOTAL") )	)
		aAdd( ( oHtml:ValByName( "cp.numero"	) ) , TRBHPC->C7_NUM )
		aAdd( ( oHtml:ValByName( "cp.item"		) ) , TRBHPC->C7_ITEM )
		aAdd( ( oHtml:ValByName( "cp.produto"	) ) , TRBHPC->C7_PRODUTO )
		aAdd( ( oHtml:ValByName( "cp.descric"	) ) , TRBHPC->B1_DESC )
		aAdd( ( oHtml:ValByName( "cp.quantid"	) ) , Transform(TRBHPC->C7_QUANT,PesqPict("SC7","C7_QUANT") )	)
		aAdd( ( oHtml:ValByName( "cp.preco"		) ) , Transform(TRBHPC->C7_PRECO,PesqPict("SC7","C7_PRECO") )	)
		aAdd( ( oHtml:ValByName( "cp.total"		) ) , Transform(TRBHPC->C7_TOTAL,PesqPict("SC7","C7_TOTAL") )	)
	
	TRBHPC->(DbSkip(1))
	EndDo

Else
//	aAdd( (oHtml:ValByName( "cp.refer"	)), "" )
//	aAdd( (oHtml:ValByName( "cp.total" 	)), "" )

	aAdd( ( oHtml:ValByName( "cp.numero"	) ) , "" )
	aAdd( ( oHtml:ValByName( "cp.item"		) ) , "" )
	aAdd( ( oHtml:ValByName( "cp.produto"	) ) , "" )
	aAdd( ( oHtml:ValByName( "cp.descric"	) ) , "" )
	aAdd( ( oHtml:ValByName( "cp.quantid"	) ) , "" )
	aAdd( ( oHtml:ValByName( "cp.preco"		) ) , "" )
	aAdd( ( oHtml:ValByName( "cp.total"		) ) , "" )

EndIf

TRBHPC->(DBCloseArea())

//====================================================================================================
// Inicia-se o processo de identifica็ใo da cota็ใo
//====================================================================================================
DBSelectArea("SC7")
SC7->( DBSetOrder(1) ) // C7_FILIAL+C7_NUM+C7_ITEM+C7_SEQUEN
SC7->( DBSeek( xFilial("SC7") + cNumPC ) )

cCodForne	:= SC7->C7_FORNECE
cLojForne	:= SC7->C7_LOJA
cNumCt 		:= SC7->C7_NUMCOT

	DbSelectArea("SC8")
	SC8->( DbSetOrder(3) )
	if 	SC8->( DbSeek( xFilial("SC7")+cNumCt ) )
		oHtml:ValByName( "nCotacao"," - Nr.:"+cNumCt+" EM "+dtoc(SC8->C8_EMISSAO) )
	endif

	do while !SC8->( Eof() ) .and. (xFilial("SC7")+cNumCt) = (xFilial("SC8")+SC8->C8_NUM)

//		if SC8->C8_FORNECE == cCodForne .and. SC8->C8_LOJA == cLojForne
		
			AAdd( (oHtml:ValByName( "cotacao.item" )),SC8->C8_ITEM )
			AAdd( (oHtml:ValByName( "cotacao.codigo" )),SC8->C8_PRODUTO )
			AAdd( (oHtml:ValByName( "cotacao.descricao" )),Posicione('SB1',1,xFilial('SB1')+SC8->C8_PRODUTO,'B1_DESC') )
			AAdd( (oHtml:ValByName( "cotacao.fornecedor" )),Posicione('SA2',1,xFilial('SA2')+C8_FORNECE,'A2_NREDUZ') )
			AAdd( (oHtml:ValByName( "cotacao.total" )),TRANSFORM( SC8->C8_TOTAL,'@E 99,999.99' ) )		                     
			AAdd( (oHtml:ValByName( "cotacao.entrega" )),dtoc(SC8->C8_DATPRF) )		                     
			AAdd( (oHtml:ValByName( "cotacao.condPag" )),Posicione('SE4',1,xFilial('SE4')+SC8->C8_COND,'E4_DESCRI') )
			++_nXF
		
//		endif
			
		SC8->( DbSkip() )
	
	enddo 

		SC7->( DbSkip() )

	if _nXF == 0
		
		oHtml:ValByName( "nCotacao"," - NรO HOUVE COTAวรO PARA ESTE PEDIDO DE COMPRA" )
		AAdd( (oHtml:ValByName( "cotacao.item" )), "" )
		AAdd( (oHtml:ValByName( "cotacao.codigo" )), "" )
		AAdd( (oHtml:ValByName( "cotacao.descricao" )), "" )
		AAdd( (oHtml:ValByName( "cotacao.fornecedor" )), "" )
		AAdd( (oHtml:ValByName( "cotacao.total" )), "" )
		AAdd( (oHtml:ValByName( "cotacao.entrega" )), "" )
		AAdd( (oHtml:ValByName( "cotacao.condPag" )), "" )

	endif

//====================================================================================================
// Inicia-se o processo de identifica็ใo dos ๚ltimos pre็os
//====================================================================================================

aUltPrc	:= {0,0,0}

DBSelectArea("SC7")
SC7->( DBSetOrder(1) ) // C7_FILIAL+C7_NUM+C7_ITEM+C7_SEQUEN
SC7->( DBSeek( xFilial("SC7") + cNumPC ) )

    While !SC7->( Eof() ) .and. SC7->C7_NUM = cNumPC

       aUltPrc	:= U_UltPrc(SC7->C7_PRODUTO)
      
//       nTotal := nTotal + SC7->C7_TOTAL
//       AAdd( (oHtml:ValByName( "produto.item" )),SC7->C7_ITEM )
//       AAdd( (oHtml:ValByName( "produto.codigo" )),SC7->C7_PRODUTO )

//       dbSelectArea('SB1')
//       SB1->( dbSetOrder(1) )
//       SB1->( dbSeek(xFilial('SB1')+SC7->C7_PRODUTO) )    

//       AAdd( (oHtml:ValByName( "produto.descricao" )),Posicione('SB1',1,xFilial('SB1')+SC7->C7_PRODUTO,'B1_DESC') )
//       AAdd( (oHtml:ValByName( "produto.quant" )),TRANSFORM( SC7->C7_QUANT,'@E 99,999.99' ) )		              
//       AAdd( (oHtml:ValByName( "produto.preco" )),TRANSFORM( SC7->C7_PRECO,'@E 99,999.99' ) )		                     
//       AAdd( (oHtml:ValByName( "produto.total" )),TRANSFORM( SC7->C7_TOTAL,'@E 99,999.99' ) )		                     
//       AAdd( (oHtml:ValByName( "produto.unid" )) ,SB1->B1_UM )		              
//       AAdd( (oHtml:ValByName( "produto.entrega" )),dtoc(SC7->C7_DATPRF) )		                     
//       AAdd( (oHtml:ValByName( "produto.condPag" )),Posicione('SE4',1,xFilial('SE4')+SC7->C7_COND,'E4_DESCRI') )		                     

	   AAdd( (oHtml:ValByName( "produto.ultimo" )), aUltPrc[1] )    
//	   AAdd( (oHtml:ValByName( "produto.penult" )), aUltPrc[2] )    
//	   AAdd( (oHtml:ValByName( "produto.antepe" )), aUltPrc[3] )    

       SC7->( dbSkip() )

    Enddo


//====================================================================================================
//ณAlimenta variais de Total.								             	 ณ
//====================================================================================================
oHtml:ValByName( "lbTotal" , TransForm( nValTotPC,PesqPict("SC7","C7_TOTAL") ) )

//====================================================================================================
//ณAlimenta variais do objeto WF.							             	 ณ
//====================================================================================================
oProcess:ClientName( cUserName )
oProcess:cTo		:= GetNewPar( "MV_MAILSUB" , "carlosds@ercal.com.br" )
oProcess:UserSiga	:= aDadSCRAux[04]	 //Coloque aqui o codigo do usuario do Siga para quem vai o Email.

Sleep(1000)

//====================================================================================================
//ณStarta processo do messenger.							             	 ณ
//====================================================================================================
cIDLink := oProcess:Start( "/workflow/emp" + cEmpAnt + '/pedcom' )

//====================================================================================================
//ณPosiciona na conta de WorkFlow.							             	 ณ
//====================================================================================================
DBSelectArea("WF7")
WF7->( DBGoTop() )

//====================================================================================================
//ณNome do arquivo HTML.									             	 ณ
//====================================================================================================
cArqHtml	:= cIDLink + ".htm"

//====================================================================================================
//ณJoga o conteudo do HTML na variavel cHtmlWF.				             	 ณ
//====================================================================================================
cHtmlWF		:= WFLoadFile( "/workflow/emp"+ cEmpAnt +'/pedcom/'+ cArqHtml )

//====================================================================================================
//ณAltera a clausula mailto do HTML original.				             	 ณ
//====================================================================================================
cMailTo		:= "mailto:" + AllTrim( WF7->WF7_ENDERE )
cHtmlWF		:= StrTran( cHtmlWF , cMailTo , "WFHTTPRET.APL" )

//====================================================================================================
//ณGrava no messenger o html do WF.							             	 ณ
//====================================================================================================
WfSaveFile( "/workflow/emp"+ cEmpAnt +'/pedcom/'+ cIdLink + ".htm" , cHtmlWF ) // grava novamente com as alteracoes necessarias.

//====================================================================================================
//ณEnvia e-mail com link do WF para o aprovador.			             	 ณ
//====================================================================================================
cSubAux := "WF APROVAวรO: "+ Capital( AllTrim( cNomForne ) ) +" / Valor: "+ AllTrim( TransForm( nValTotPC , PesqPict("SC7","C7_TOTAL") ) ) +" / PC: "+ cNumPC +"."

cMailDest := AllTrim( UsrRetMail( oProcess:UserSiga ) )
//funcao que Envia Email 
fSendLink(	cSubAux							,;
			cMailDest						,;
			AllTrim( 'http://'+ GetMV( "MV_WFWS" ,, "189.112.2.45:8098" ) ) + '/emp' + cEmpAnt + '/pedcom/' + cIdLink + '.htm'	,;
			1	)

 

//====================================================================================================
//ณCria rastreabilidade do WF.								             	 ณ
//====================================================================================================
RastreiaWF( oProcess:fProcessID +'.'+ oProcess:fTaskID , oProcess:fProcCode , "10001" , 'Processo do Pedido ['+ cNumPC +'] iniciado!' )

Return()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function fRetornoWF( oProcess )

Local cNumPC 	:= oProcess:oHtml:RetByName('pedido')
Local cCodApro	:= ""
Local cUsrApro	:= oProcess:oHtml:RetByName('aprov_cod')
Local cGrpApro	:= ""
Local cNivelSCR	:= oProcess:oHtml:RetByName('aprov_nivel')
Local cInvest	:= oProcess:oHtml:RetByName('invest')
Local lPedPCOK	:= .F.
Local lTemNivel	:= .F.
Local cNomArq	:=  oProcess:oHtml:RetByName('WFMAILID')
Local cEmpAnt	:=  oProcess:oHtml:RetByName('WFEMPRESA')


Local aRetSaldo	:= {}
Local nTotal	:= 0
Local cObs		:= ""
Local dRefer	:= Nil
Local lAprovou	:= .F.
Local cCodRastro:= ""
Local lLiberou	:= .F.

Local cSubAux 	:= ""
Local cMailDest := ""
Local cCompra	:= ""


//====================================================================================================
//ณPosiciona no Pedido de Compra.				                             ณ
//====================================================================================================
DBSelectArea("SC7")
SC7->(DBSetOrder(1)) // C7_FILIAL+C7_NUM+C7_ITEM+C7_SEQUEN
If	SC7->( DBSeek( xFilial("SC7") + cNumPC ) ) .And. !( SC7->C7_CONAPRO == "L" )

	cCompra := SC7->C7_USER
	
	//====================================================================================================
	//ณPosiciona no Usuario Aprovador.				                             ณ
	//====================================================================================================
	DBSelectArea("SAK")
	SAK->( DBSetOrder(2) ) // AK_FILIAL+AK_USER
	If	SAK->( DBSeek(xFilial("SAK") + cUsrApro ) )
		cCodApro := SAK->AK_COD
	EndIf

	//====================================================================================================
	//ณPosiciona no controle de alcadas.			                             ณ
	//====================================================================================================
	DBSelectArea("SCR")
	lAchou	:= .F.
	
	If !Empty( cUsrApro )
	
		SCR->( DBSetOrder(2) ) // CR_FILIAL+CR_TIPO+CR_NUM+CR_USER
		If SCR->( DBSeek( xFilial("SCR") + "PC" + PadR( cNumPC , TamSx3("CR_NUM")[1] ) + cUsrApro ) )
			lAchou	:= .T.
		EndIf
	
	Else
	
		SCR->( DBSetOrder(1) ) // CR_FILIAL+CR_TIPO+CR_NUM+CR_NIVEL
		If SCR->( DBSeek( xFilial("SCR") + "PC" + PadR( cNumPC , TamSx3("CR_NUM")[1] ) + cNivelSCR ) )
			cUsrApro	:= SCR->CR_APROV
			lAchou		:= .T.
		EndIf
		
	EndIf

	If 	lAchou .And. SCR->CR_STATUS == "02" .And. !Empty( cCodApro )

		//====================================================================================================
		//ณVariaveis utilizadas na rotina MaAlcDoc.		                             ณ
		//====================================================================================================
		aRetSaldo 	:= MaSalAlc( cCodApro , dDataBase )
		nTotal		:= xMoeda( SCR->CR_TOTAL , SCR->CR_MOEDA , aRetSaldo[2] , SCR->CR_EMISSAO ,, SCR->CR_TXMOEDA )
		cGrpApro	:= SC7->C7_APROV
		cObs		:= oProcess:oHtml:RetByName('lbmotivo')
		dRefer		:= dDataBase
		lAprovou	:= Upper( oProcess:oHtml:RetByName('RBAPROVA') ) == "SIM"
		cCodRastro	:= IIf( lAprovou , "10003" , "10004")
	
		//====================================================================================================
		//ณAtualiza o rastreamento do WF.				                             ณ
		//====================================================================================================
		RastreiaWF( oProcess:fProcessID +'.'+ oProcess:fTaskID , oProcess:fProcCode , cCodRastro )
		
		//====================================================================================================
		//ณChama rotina de aprovacao/reprovacao.		                             ณ
		//====================================================================================================
		lLiberou := MaAlcDoc( { SCR->CR_NUM , SCR->CR_TIPO , nTotal , cCodApro , cUsrApro , cGrpApro ,,,,, cObs } , dRefer , IIf( lAprovou , 4 , 6 ) )
		
	EndIf

EndIf
	
oProcess:Finish()
oProcess:Free()

cNomArq := SubStr(cNomArq,3,len(cNomArq))

ConOut("[001] Arquivo - /workflow/emp" + cEmpAnt +"/pedcom/"+ cNomArq +".htm")
//cArqTmp := "\workflow\emp"+ cEmpAnt +'\pedcom\'+ cIdLink + ".htm"
FErase("/workflow/emp" + cEmpAnt +"/pedcom/"+ cNomArq +".htm")     
//====================================================================================================
//ณCR_STATUS== "01" - Bloqueado p/ sistema (aguardando outros niveis)		 ณ
//ณCR_STATUS== "02" - Aguardando Liberacao do usuario						 ณ
//ณCR_STATUS== "03" - Pedido Liberado pelo usuario							 ณ
//ณCR_STATUS== "04" - Pedido Bloqueado pelo usuario 						 ณ
//ณCR_STATUS== "05" - Pedido Liberado por outro usuario						 ณ
//====================================================================================================

//====================================================================================================
//ณ Verifica se o pedido esta totalmente liberado e se tem niveis.           ณ
//====================================================================================================
lPedPCOK	:= .T.
lTemNivel	:= .F.
cNivelSCR	:= ""

DBSelectArea("SCR")
SCR->( DBSetOrder(1) ) // CR_FILIAL+CR_TIPO+CR_NUM+CR_NIVEL
SCR->( DBSeek( xFilial("SCR") + "PC" + PadR( cNumPC , TamSx3("CR_NUM")[1] ) ) )

While !SCR->( Eof() ) .And. SCR->( CR_FILIAL + CR_TIPO + CR_NUM ) == xFilial("SCR") + "PC" + PadR( cNumPC , TamSx3("CR_NUM")[1] )

	If 	SCR->CR_STATUS $ "01/02"
		lPedPCOK	:= .F.
		lTemNivel	:= .T.
	ElseIf 	SCR->CR_STATUS == "04"
		lPedPCOK	:= .F.
		lTemNivel	:= .F.
		Exit
	EndIf

SCR->( DBSkip() )
EndDo

cMailDest := UsrRetMail( cCompra )
cSubAux := "WF APROVAวรO - PC: "+  AllTrim( cNumPC ) +". "+cCodApro+"."

If lPedPCOK

	//====================================================================================================
	//ณRealiza a liberacao do Pedido.				                             ณ
	//====================================================================================================
	DBSelectArea("SC7")
	SC7->(DBSetOrder(1)) // C7_FILIAL+C7_NUM+C7_ITEM+C7_SEQUEN
	If SC7->(DBSeek(xFilial("SC7")+cNumPC))
		
		While !SC7->(Eof()) .And. SC7->(C7_FILIAL+C7_NUM) == xFilial("SC7")+cNumPC
				
				SC7->(RecLock("SC7",.F.))
					SC7->C7_CONAPRO := "L"
					SC7->C7_XINVEST := cInvest
				SC7->(MsUnLock())
				
		SC7->(DBSkip())
		EndDo
		
		fSendLink(	cSubAux							,;
					cMailDest						, ,;
					2	)

	EndIf

Else
	If lTemNivel
	
		DBSelectArea("SC7")
		SC7->(DBSetOrder(1)) // C7_FILIAL+C7_NUM+C7_ITEM+C7_SEQUEN
		If	SC7->( DBSeek( xFilial("SC7") + cNumPC ) )
			U_WFW120P( 0 , Nil , .F. )
		EndIf

	EndIf

EndIf

If !lAprovou

	fSendLink(	cSubAux							,;
				cMailDest						, ,;
				3 , cObs , cCodApro	)
EndIf 

Return()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function fTimeOutWF( oProcess )

Return()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function fStatusSCR(_cCRStatus)

Local cSituaca := ""

Do 	Case
	
	Case _cCRStatus == "01"
		cSituaca := "Aguardando"
	Case _cCRStatus == "02"
		cSituaca := "Em aprova็ใo"
	Case _cCRStatus == "03"
		cSituaca := "Aprovado"
	Case _cCRStatus == "04"
		cSituaca := "Bloqueado"
	Case _cCRStatus == "05"
		cSituaca := "Nivel aprovado"

EndCase

Return(cSituaca)

/*######################################################################
	ULTIMOS PREวOS
######################################################################*/
	User Function UltPrc(cCod)
	Local aArea		:= GetArea()
	Local aRet		:= {0,0,0}
	Local cAlias	:= GetNextAlias()
	       
	BeginSql Alias cAlias
		SELECT DISTINCT D1_FILIAL, D1_COD, D1_DOC, D1_SERIE, D1_DTDIGIT, D1_VUNIT, D1_QUANT, D1_UM
		FROM %TABLE:SD1% SD1
		WHERE  SD1.D_E_L_E_T_ = ' '
			AND SD1.D1_COD = %Exp:cCod%
			AND SD1.D1_TIPO = 'N'
		ORDER BY D1_DTDIGIT DESC
	EndSql

	_aQuery := GetLastQuery()
	 MemoWrite("/totvs/protheus12/binarios/wfw120p_ult_prc.txt",_aQuery[2])
	 If (cAlias)->(!EOF())
	  _N := 1  
	  While (cAlias)->(!EOF()) .AND. _N < 4
//	   aRet[_N] := "R$ "+alltrim(str((cAlias)->D1_VUNIT))+" - "+alltrim(str((cAlias)->D1_QUANT))+alltrim((cAlias)->D1_UM)
	   aRet[_N] := alltrim(str((cAlias)->D1_VUNIT))
	   _N++
	   (cAlias)->(dbSkip())
	  EndDo
	 EndIf	

	RestArea(aArea)
	Return aRet


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function fSendLink(cSubject,cTo,cLinkWF,nOpc,cObs,cAprova)

Local cHtml		 := ""
Local lEnviado	 := .F.
Local cEndWf	:= AllTrim( 'http://'+ GetMV( "MV_WFWS" ,, "189.112.1.248:8099" ) )

cHtml := '<html xmlns="http://www.w3.org/1999/xhtml">'
cHtml += '<head>'
cHtml += '	<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />'
cHtml += '	<title>Aprovacao - Pedido de Compra</title>'
cHtml += '</head>'
cHtml += '<body>'
cHtml += '<center>'
cHtml += '<table width="760" bgcolor="#FFFFFF" cellpadding="0" cellspacing="0" >'
cHtml += '	<tr>'
cHtml += '		<td width="760"><img src="'+ cEndWf +'/logowf.png" /></td>'
cHtml += '	</tr>'
cHtml += '	<tr>'
cHtml += '		<td style="font-family:Tahoma;font-size:18px;color:#000000;"><br><center>Aprova็ใo de Pedido de Compra.</center><br></td>'
cHtml += '	</tr>'

If nOpc == 1

cHtml += '	<tr>'
cHtml += '		<td bgColor="#4682B4" style="font-family:Tahoma;font-size:14px;color:#FFFFFF;" align="center"><b><a href="'+cLinkWF+'"><font color="#FFFFFF">Clique Aqui</font></a></b> para aprovar o Pedido.</td>'
cHtml += '	</tr>'

ElseIf nOpc == 2

cHtml += '	<tr>'
cHtml += '		<td bgColor="#008B00" style="font-family:Tahoma;font-size:14px;color:#FFFFFF;" align="center">O pedido foi aprovado e encontra-se liberado.</td>'
cHtml += '	</tr>'

ElseIf nOpc == 3  

cHtml += '	<tr>'
cHtml += '		<td bgColor="#008B00" style="font-family:Tahoma;font-size:14px;color:#FFFFFF;" align="center">O pedido foi reprovado pelo aprovador: '+ AllTrim( UsrFullName( cAprova ) ) +'.</td>'
cHtml += '	</tr>'
cHtml += '	<tr>'
cHtml += '		<td style="font-family:Tahoma;font-size:14px;color:#000000;"><br>Motivo: '+ cObs +'</td>'
cHtml += '	</tr>'
cHtml += '	<tr>'
cHtml += '		<td bgColor="#008B00" colspan="2" height="01px"></td>'
cHtml += '	</tr>'

EndIf

cHtml += '</table>'

cHtml += '</center>'
cHtml += '</body>'
cHtml += '</html>'
//funcao enviando email
lEnviado := U_NTSNDEML( ,,,, cTo , cSubject , cHtml ,, .T.  )


If 	!lEnviado
	MsgAlert("Erro ao enviar E-mail ao Aprovador.","WorkFlow")
//Else
	//MsgAlert( "E-mail eviado com sucesso ao Aprovador." , "WorkFlow" )
EndIf

Return()
