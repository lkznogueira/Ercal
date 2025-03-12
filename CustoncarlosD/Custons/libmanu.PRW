#INCLUDE "rwmake.ch"  

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³          ºAutor  ³CARLOS DANIEL       º Data ³  15/12/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ PE para inclusao de botao no aRotina do pedido de venda.   º±±
±±º          ³                                                            º±±
±±º	   		 ³              				                              º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/


User Function libmanu(cAlias)

Local aArea     := GetArea()
Local aAreaSC9  := SC9->(GetArea())
Local cPedido   := ""
Local cAliasSC9 := "SC9"
Local cQuery    := ""
Local nOpcA     := 0
Local nRecSc9   := 0
Local nTotRec   := 0
Local lContinua := .T.
Local lQuery    := .F.
Local lHelp     := .T.
Local bValid    := {|| (cAliasSC9)->(Recno()) <= nTotRec}
//-- Variaveis utilizadas pela funcao wmsexedcf
Private aLibSDB	:= {}
Private aWmsAviso:= {}  

If SC9->C9_BLCRED == "10" .OR. SC9->C9_BLEST == "10"
	HELP(" ",1,"A450NFISCA")
	lContinua := .F.
EndIf

If SC9->C9_BLCRED == "  " .And. SC9->C9_BLEST == "  " .And. SC9->C9_BLWMS=="  "
	Help(" ",1,"A450JALIB")
	lContinua := .F.
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Caso os parametros MV_CUSFIFO e MV_FFONLIN estejam habilitados nao sera |
//|permitida a liberacao manual de estoque.                                |
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If SuperGetMv("MV_CUSFIFO",.F.,.F.) .And. SuperGetMv("MV_FFONLIN",.F.,.F.)
	PutHelp ("PA450FIFO",	{"Quando utilizado o Custo Fifo On-Line"	,"não e permitida a liberação manual do "	,"saldo bloqueado por estoque."	},;
							{"When used the Cost Fifo On-Line and"		,"not allowed the manual release of the"	,"balance blocked for supply."	},;
							{"Cuando utilizado el costo Fifo On-Line"	,"no permitido el lanzamiento manual del"	,"saldo bloqueado por estoque."	},;
							.F.)
	Help(" ",1,"A450FIFO")
	lContinua := .F.
EndIf

dbSelectArea("SC5")
dbSetOrder(1)
MsSeek(xFilial("SC5")+SC9->C9_PEDIDO)
If ( SC5->C5_TIPO$"BD" )
	Help(" ",1,"A450NCRED")
	lContinua := .F.
EndIf

If lContinua
	dbSelectArea(cAlias)
	nOpcA := a450Tela( @lContinua , .T. , .T. )
	#IFDEF TOP
		IF TcSrvType() == "AS/400"
			dbSelectArea("SC9")
			Set Filter to
			dbSetOrder(1)
			aAreaSC9 := GetArea()
		EndIf
	#ENDIF
	If ( ExistBlock("MTA456P") )
		If ( !Execblock("MTA456P",.F.,.F.,{nOpca}) )
			nOpcA := 0
		EndIf
	EndIf
	Do Case
	Case ( nOpcA == 1 )
		a450Grava(1,.T.,.T.)
		If (Existblock("MTA456I"))
			ExecBlock("MTA456I",.f.,.f.)
		EndIf
	Case ( nOpcA == 3 )
		a450Grava(2,.T.,.T.)
		If (Existblock("MTA456R"))
			ExecBlock("MTA456R",.f.,.f.)
		EndIf
	Case ( nOpcA == 4 )
		cPedido := SC9->C9_PEDIDO
		dbSelectArea("SC9")
		dbSetOrder(1)
		#IFDEF TOP
			If .T.//TcSrvType()<>"AS/400"
				lQuery := .T.

				bValid := {|| .T.}

				cAliasSC9 := "A450LIBMAN"
				cQuery := "SELECT C9_FILIAL,C9_PEDIDO,C9_BLCRED,R_E_C_N_O_ SC9RECNO"
				cQuery += "FROM "+RetSqlName("SC9")+" SC9 "
				cQuery += "WHERE SC9.C9_FILIAL = '"+xFilial("SC9")+"' AND "
				cQuery += "SC9.C9_PEDIDO = '"+cPedido+"' AND "
				cQuery += "(SC9.C9_BLEST <> '  ' OR "
				cQuery += "SC9.C9_BLCRED <> '  ' ) AND "
				cQuery += "SC9.C9_BLCRED NOT IN('10','09') AND "
				cQuery += "SC9.C9_BLEST <> '10' AND "
				cQuery += "SC9.D_E_L_E_T_ = ' ' "
				cQuery := ChangeQuery(cQuery)

				dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasSC9,.T.,.T.)
			Else
		#ENDIF
			MsSeek(cFilial+cPedido)
		#IFDEF TOP
			EndIf
		#ENDIF


		nTotRec := SC9->(LastRec())

		While ( !Eof() .And. (cAliasSC9)->C9_FILIAL == xFilial("SC9") .And.;
				(cAliasSC9)->C9_PEDIDO == cPedido .And. Eval(bValid) ) 				

			If lQuery
				SC9->(MsGoto((cAliasSC9)->SC9RECNO))
			Else
				(cAliasSC9)->(dbSkip())
				nRecSc9 := (cAliasSC9)->(Recno())
				(cAliasSC9)->(dbSkip(-1))
			Endif

			If !( (Empty(SC9->C9_BLCRED) .And. Empty(SC9->C9_BLEST)) .Or.;
					(SC9->C9_BLCRED=="10" .And. SC9->C9_BLEST=="10") .Or.;
					SC9->C9_BLCRED=="09" )


				a450Grava(1,.T.,.T.,@lHelp)

			EndIf
			IF (Existblock("MTA456I"))
				ExecBlock("MTA456I",.f.,.f.)
			EndIf

			If lQuery
				dbSelectArea(cAliasSC9)
				dbSkip()
			Else
				(cAliasSC9)->(MsGoto(nRecSc9))
			Endif

		EndDo
		If lQuery
			dbSelectArea(cAliasSC9)
			dbCloseArea()
			dbSelectArea("SC9")
		EndIf
	EndCase
	If ExistBlock("MTA456L")
		Execblock("MTA456L",.F.,.F.,{nOpca})
	EndIf
	//-- Integrado ao wms devera avaliar as regras para convocacao do servico e disponibilizar os 
	//-- registros do SDB para convocacao
	If	IntDL() .And. !Empty(aLibSDB)
		WmsExeDCF('2')
	EndIf
EndIf
RestArea(aAreaSC9)
//Eval(bFiltraBrw)
RestArea(aArea)
Return(lContinua)