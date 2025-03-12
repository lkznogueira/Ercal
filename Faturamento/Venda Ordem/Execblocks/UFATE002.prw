#Include "Totvs.ch"
#include "protheus.ch"
#include "topconn.ch"

Static _nQtdEst := 0
Static _nQtdFin	:= 0
Static lRetval  := .T.

/*/-------------------------------------------------------------------
- Programa: UFATE002
- Autor: Wellington Gonçalves
- Data: 19/09/2022
- Descrição: Acionado atravez da remessa do contrato, apos a inclusão
do pedido do cliente, apresenta a tela do novo pedido de remessa do
destinatário, acionado pelo PE FT400LIB.
-------------------------------------------------------------------/*/

User Function UFATE002() //este

	Local aArea 	:= FWGetArea()
	Local nTipo		:= ' '
	Local lIncluiu  := .F.

	if type("PARAMIXB") == "U"//add carlos daniel para validar se parambix é presente 
		nTipo := 2	
	else
		nTipo := PARAMIXB
	endif  

	// se a operação for remessa e se o contrato for do tipo Conta Ordem (c/ ou s/ nota Mãe)
	if lRetval .and. nTipo == 2 .AND. ADA->ADA_XORDEM == "1"

		// pego o saldo do contrato após a inclusão do pedido
		aSaldoADB := CalcQtdADB(ADA->ADA_NUMCTR)

		// preciso verificar se o usuário não cancelou a tela de inclusão do pedido de venda
		// estas variáveis são alimentadas no P.E FT400PED que estão neste mesmo fonte
		// com o saldo do contrato antes da abertura do pedido de venda
		// se um dos saldos for diferente significa que houve inclusão do pedido de venda
		if _nQtdEst <> aSaldoADB[1] .OR. _nQtdFin <> aSaldoADB[2]
			lIncluiu  := .T.
			// função que inclui o pedido de venda de remessa
			FWMsgRun(,{|oSay| IncPedido(SC5->C5_NUM,nTipo)},'Aguarde...','Incluindo Pedido de Remessa...')  //Trecho foi eliminado e alterado para chamada no PV pois o usuário somente gera depois do retorno OK do cliente.

		endif

	endif

	FWRestArea(aArea)

Return(Nil)

/*/-------------------------------------------------------------------
	- Programa: CalcQtdADB
	- Autor: Wellington Gonçalves
	- Data: 19/09/2022
	- Descrição: Função que soma os saldos da ADB.
-------------------------------------------------------------------/*/
Static Function CalcQtdADB(cNumCtr)

	Local aArea		:= FWGetArea()
	Local aAreaADB	:= ADB->(FWGetArea())
	Local aRet 		:= {0,0}

	ADB->(DbSetOrder(1)) // ADB_FILIAL + ADB_NUMCTR + ADB_ITEM
	if ADB->(DbSeek(xFilial("ADB") + cNumCtr))
		While ADB->(!Eof()) .AND. ADB->ADB_FILIAL == xFilial("ADB") .AND. ADB->ADB_NUMCTR == cNumCtr
			aRet[1] += ADB->ADB_QTDENT
			aRet[2] += ADB->ADB_QTDEMP
			ADB->(DbSkip())
		EndDo
	endif

	FWRestArea(aAreaADB)
	FWRestArea(aArea)

Return(aRet)

/*/-------------------------------------------------------------------
	- Programa: IncPedido
	- Autor: Wellington Gonçalves
	- Data: 19/09/2022
	- Descrição: Função que inclui o pedido de venda automático
-------------------------------------------------------------------/*/
Static Function IncPedido(cNumPed,nTipo)

	Local lRet              := .T.
	Local aArea             := FWGetArea()
	Local aAreaSC5          := SC5->(FWGetArea())
	Local aAreaSC6          := SC6->(FWGetArea())
	Local cCliente          := ADA->ADA_XCLIOR
	Local cLoja             := ADA->ADA_XLOJOR
	Local cNewPV            := ""
	Private lMsHelpAuto 	:= .T.
	Private lMsErroAuto 	:= .F.

	//Valida cliente
	dbSelectArea("SA1")
	dbSetOrder(1)
	if MsSeek(xFilial("SA1") + cCliente + cLoja)
		if SA1->A1_MSBLQL<>'1'
			
			U_UFATE009()

			AbrePV(cCliente,cLoja,cNumPed,@cNewPV,nTipo)

			if !Empty(cNewPV) .AND. cNewPV <> cNumPed
				// atualizo os campos C6_CONTRAT e C6_ITEMCON do pedido gerado
				AtuSC6(cNumPed,cNewPV)
			else
				MsgInfo("Ocorreu um erro na geração do Pedido de Remessa!")
			endif
		else
			MsgInfo("Cliente Bloqueado!")
		endif
	endif

	FWRestArea(aAreaSC5)
	FWRestArea(aAreaSC6)
	FWRestArea(aArea)

Return(lRet)

/*/-------------------------------------------------------------------
	- Programa: AtuSC6
	- Autor: Wellington Gonçalves
	- Data: 19/09/2022
	- Descrição: Função que atualiza campos na SC6 referentes ao contrato
-------------------------------------------------------------------/*/

Static Function AtuSC6(cPedOld,cPedAtu)

	Local aArea     := FWGetArea()
	Local aAreaSC6  := SC6->(FWGetArea())
	Local cChave    := ""
	Local aItens    := {}
	Local nX        := 1

	// se o pedido de remessa foi incluido
	if !Empty(cPedOld) .AND. !Empty(cPedAtu)
		// posiciono nos itens do pedido de vendas
		SC6->(DbsetOrder(1)) // C6_FILIAL + C6_NUM + C6_ITEM + C6_PRODUTO
		if SC6->(DbSeek(xFilial("SC6") + cPedOld))
			// pego todas as chaves dos itens do pedido original
			While SC6->(!Eof()) .AND. SC6->C6_FILIAL == xFilial("SC6") .AND. SC6->C6_NUM == cPedOld
				cChave := SC6->C6_FILIAL + SC6->C6_PRODUTO + cPedAtu + SC6->C6_ITEM
				aadd(aItens,{cChave,SC6->C6_CONTRAT,SC6->C6_ITEMCON,SC6->C6_OPC}) //,SC6->C6_XEMB
				SC6->(DbSkip())
			EndDo

			// posiciono nos itens correspondentes do pedido customizado
			For nX := 1 To Len(aItens)
				// posiciono nos itens do pedido de vendas
				SC6->(DbsetOrder(2)) // C6_FILIAL + C6_PRODUTO + C6_NUM + C6_ITEM
				if SC6->(DbSeek(aItens[nX,1]))
					if RecLock("SC6",.F.)
						SC6->C6_CONTRAT := aItens[nX,2]
						SC6->C6_ITEMCON := aItens[nX,3]
						SC6->C6_OPC		:= aItens[nX,4]
						SC6->(MsUnLock())
					endif
				endif
			Next nX
		endif
	endif

	FWRestArea(aAreaSC6)
	FWRestArea(aArea)

Return(Nil)

/*/-------------------------------------------------------------------
	- Programa: AbrePv
	- Autor: Wellington Gonçalves
	- Data: 19/09/2022
	- Descrição: Função que abre tela de inclusão do pedido
-------------------------------------------------------------------/*/

Static Function AbrePv(cCliente,cLoja,cNumPed,cNewPv,nTipo)

	Local aAreaSD2  := SD2->(FWGetArea())
	Local aAreaSC5  := SC5->(FWGetArea())
	Local aAreaSC6  := SC6->(FWGetArea())
	Local aArea     := FWGetArea()
	Local aColsC6   := {}
	Local aHeadC6   := {}
	Local aPedCob   := {}
	Local aDadosCfo := {}
	Local bCampo    := {|nCPO| Field(nCPO) }
	Local cFilOld   := cFilAnt
	Local cVend     := ""
	Local cCampo    := ""
	Local cItSC6    := StrZero(0,Len(SC6->C6_ITEM))
	Local cTes      := ""
	Local cLanguage	:= "P"
	Local cOper     := SuperGetMV("MV_XOPRORD",.F.,"85")
	Local cContrato := ADA->ADA_NUMCTR
	Local lFt400Lin := ExistBlock("FT400LIN")
	Local lFt400Cab := ExistBlock("FT400CAB")
	Local nX        := 0
	Local nY        := 0
	Local nMaxFor   := 0
	Local nMaxVend  := Fa440CntVen()
	Local nUsado    := 0
	Local aRotinaBkp:= {}
	Local nStack    := GetSX8Len()
	Local nQtdPed   := 0

	Private aheadGrade := {}
	Private aColsGrade := {}
	Private aheader    := {}
	Private acols      := {}
	Private n          := 1

	#IFDEF SPANISH
		cLanguage	:= "S"
	#ELSE
		#IFDEF ENGLISH
			cLanguage	:= "E"
		#ENDIF
	#ENDIF

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Preparar pedido de venda com base no contrato de parceria               ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If !Empty(cContrato)

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Monta aHeader do SC6                                 ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		aHeadC6 := {}
		dbSelectArea("SX3")
		dbSetOrder(1)
		MsSeek("SC6",.T.)
		While ( !Eof() .And. SX3->X3_ARQUIVO == "SC6" )

			If ( X3Uso(SX3->X3_USADO) .And.;
					!Trim(SX3->X3_CAMPO)=="C6_NUM" .And.;
					Trim(SX3->X3_CAMPO) != "C6_QTDEMP" .And.;
					Trim(SX3->X3_CAMPO) != "C6_QTDENT" .And.;
					cNivel >= SX3->X3_NIVEL ) .Or.;
					Trim(SX3->X3_CAMPO)=="C6_CONTRAT" .Or. ;
					Trim(SX3->X3_CAMPO)=="C6_ITEMCON"
				Aadd(aHeadC6,{IIF(cLanguage == "P",SX3->X3_TITULO,IIF(cLanguage == "S",SX3->X3_TITSPA,SX3->X3_TITENG)),;
					SX3->X3_CAMPO,;
					SX3->X3_PICTURE,;
					SX3->X3_TAMANHO,;
					SX3->X3_DECIMAL,;
					SX3->X3_VALID,;
					SX3->X3_USADO,;
					SX3->X3_TIPO,;
					SX3->X3_ARQUIVO,;
					SX3->X3_CONTEXT })

			EndIf

			dbSelectArea("SX3")
			dbSkip()

		EndDo

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Posiciona registros                                                     ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		dbSelectArea("ADA")
		dbSetOrder(1)
		MsSeek(xFilial("ADA") + cContrato)

		dbSelectArea("SA1")
		dbSetOrder(1)
		MsSeek(xFilial("SA1") + cCliente + cLoja)

		dbSelectArea("SE4")
		dbSetOrder(1)
		MsSeek(xFilial("SE4") + ADA->ADA_CONDPG)

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Cria as variaveis do Pedido de Venda                                    ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		dbSelectArea("SC5")
		nMaxFor := FCount()
		For nX := 1 To nMaxFor
			M->&(EVAL(bCampo,nX)) := CriaVar(FieldName(nX),.T.)
		Next nX

		M->C5_TIPO    := "N"
		M->C5_CLIENTE := cCliente
		M->C5_LOJACLI := cLoja
		M->C5_LOJAENT := cLoja
		M->C5_XPEDORD := cNumPed
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Atualiza as informacoes padroes a partir do Cliente                     ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		a410Cli("C5_CLIENTE",cCliente,.F.)
		a410Loja("C5_LOJACLI",cLoja,.F.)

		M->C5_TIPOCLI := SA1->A1_TIPO
		M->C5_CONDPAG := ADA->ADA_CONDPG
		M->C5_TABELA  := ADA->ADA_TABELA
		M->C5_DESC1   := ADA->ADA_DESC1
		M->C5_DESC2   := ADA->ADA_DESC2
		M->C5_DESC3   := ADA->ADA_DESC3
		M->C5_DESC4   := ADA->ADA_DESC4
		M->C5_MOEDA   := ADA->ADA_MOEDA
		M->C5_TIPLIB  := ADA->ADA_TIPLIB

		//	M->C5_TPCARGA := ADA->ADA_TPCARGA
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Transfere vendedores                                                    ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		cVend := "1"

		For nX := 1 To nMaxVend

			cCampo := "ADA_VEND"+cVend
			If ADA->(FieldPos(cCampo)) > 0
				nY := ADA->(FieldPos(cCampo))
				cCampo := "C5"+SubStr(cCampo,4)
				M->&(cCampo) := ADA->(FieldGet(nY))
			EndIf

			cCampo := "ADA_COMIS"+cVend
			If ADA->(FieldPos(cCampo)) > 0
				nY := ADA->(FieldPos(cCampo))
				cCampo := "C5"+SubStr(cCampo,4)
				M->&(cCampo) := ADA->(FieldGet(nY))
			EndIf

			cVend := Soma1(cVend,1)

		Next nX

		If lFt400Cab
			ExecBlock("FT400CAB",.F.,.F.)
		Endif

		// prenche o nome do cliente, pois este ponto de entrada atualiza o nome de acordo com a ADA
		M->C5_XNOMCLI := Posicione("SA1",1,XFILIAL("SA1") + cCliente + cLoja ,"A1_NOME")

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Preenche o Acols do Pedido de Venda                                     ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		nUsado := Len(aHeadC6)

		dbSelectArea("ADB")
		dbSetOrder(1)
		MsSeek(xFilial("ADB")+cContrato)

		While ( !Eof() .And. xFilial("ADB") == ADB->ADB_FILIAL .And.;
				cContrato == ADB->ADB_NUMCTR )

			// função que retorna a quantidade gerada no pedido
			nQtdPed := RetQtdPed(cNumPed,ADB->ADB_NUMCTR,ADB->ADB_ITEM)

			//nQtdPed := U_RetQtdFat(cNumPed,ADB->ADB_NUMCTR,ADB->ADB_ITEM)-U_RetQtdOrd(cNumPed,ADB->ADB_NUMCTR,ADB->ADB_ITEM)

			/*/
			if nQtdPed<1  //Se o usuário deletou 1 ou mais itens  Claudio 12.04.20
				dbSelectArea("ADB")
				ADB->(DbSkip())
				Loop
			endif
			/*/

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Posiciona registros                                                     ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			dbSelectArea("SB1")
			dbSetOrder(1)
			MsSeek(xFilial("SB1")+ADB->ADB_CODPRO)

			// função que retorna a TES de acordo com o tipo de operação
			cTES := MaTesInt(2, cOper ,cCliente,cLoja,"C",ADB->ADB_CODPRO,"C6_TES")

			dbSelectArea("SF4")
			dbSetOrder(1)
			MsSeek(xFilial("SF4")+cTes)

			aadd(aColsC6,Array(nUsado+1))
			nY := Len(aColsC6)
			aColsC6[nY,nUsado+1] := .F.

			For nX := 1 To nUsado

				Do Case
				Case ( AllTrim(aHeadC6[nX,2]) == "C6_ITEM" )
					cItSC6 := Soma1(cItSC6)
					aColsC6[nY,nX] := cItSC6
				Case ( AllTrim(aHeadC6[nX,2]) == "C6_PRODUTO" )
					aColsC6[nY,nX] := ADB->ADB_CODPRO
				Case ( AllTrim(aHeadC6[nX,2]) == "C6_UM" )
					aColsC6[nY,nX] := SB1->B1_UM
				Case ( AllTrim(aHeadC6[nX,2]) == "C6_QTDVEN" )
					aColsC6[nY,nX] := nQtdPed// ADB->ADB_QUANT-ADB->ADB_QTDEMP-ADB->ADB_QTDENT
				Case ( AllTrim(aHeadC6[nX,2]) == "C6_PRCVEN" )
					aColsC6[nY,nX] := fGetValor()
				Case ( AllTrim(aHeadC6[nX,2]) == "C6_NFORI" )
					aColsC6[nY,nX] := ADA->ADA_XNFORI
				Case ( AllTrim(aHeadC6[nX,2]) == "C6_SERIORI" )
					aColsC6[nY,nX] := ADA->ADA_XSEORI
				Case ( AllTrim(aHeadC6[nX,2]) == "C6_XCHVORI" )
					aColsC6[nY,nX] := ADA->ADA_XCHORI
				Case ( AllTrim(aHeadC6[nX,2]) == "C6_XEMIORI" )
					aColsC6[nY,nX] := ADA->ADA_XEMORI
				Case ( AllTrim(aHeadC6[nX,2]) == "C6_VALOR" )
					aColsC6[nY,nX] := a410Arred(GDFieldGet("C6_QTDVEN",nY,NIL,aHeadC6,aColsC6)*;
						GDFieldGet("C6_PRCVEN",nY,NIL,aHeadC6,aColsC6),"C6_VALOR")
				Case ( AllTrim(aHeadC6[nX,2]) == "C6_TES" )
					aColsC6[nY,nX] := cTes
				Case ( AllTrim(aHeadC6[nX,2]) == "C6_CF" )

					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Define o CFO                                         ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					aDadosCFO := {}
					Aadd(aDadosCfo,{"OPERNF"  ,"S"})
					Aadd(aDadosCfo,{"TPCLIFOR",SA1->A1_TIPO})
					Aadd(aDadosCfo,{"UFDEST"  ,SA1->A1_EST})
					Aadd(aDadosCfo,{"INSCR"   ,SA1->A1_INSCR})
					Aadd(aDadosCfo,{"CONTR"	  ,SA1->A1_CONTRIB})

					aColsC6[nY,nX] := MaFisCfo(,SF4->F4_CF,aDadosCfo)

				Case ( AllTrim(aHeadC6[nX,2]) == "C6_SEGUM" )
					aColsC6[nY,nX] := SB1->B1_SEGUM
				Case ( AllTrim(aHeadC6[nX,2]) == "C6_LOCAL" )
					aColsC6[nY,nX] := ADB->ADB_LOCAL
				Case ( AllTrim(aHeadC6[nX,2]) == "C6_VALDESC" )
					If ADB->ADB_PRUNIT > 0
						aColsC6[nY,nX] := A410Arred((ADB->ADB_PRUNIT*aColsC6[nY,Ascan(aHeadC6,{|x| Trim(x[2])=="C6_QTDVEN"})]*ADB->ADB_DESC)/100,"C6_VALDESC")
					Else
						aColsC6[nY,nX] := A410Arred((ADB->ADB_VALDES / ADB->ADB_QUANT)*aColsC6[nY,Ascan(aHeadC6,{|x| Trim(x[2])=="C6_QTDVEN"})],"C6_VALDESC")
					EndIf
				Case ( AllTrim(aHeadC6[nX,2]) == "C6_DESCONT" )
					aColsC6[nY,nX] := ADB->ADB_DESC
				Case ( AllTrim(aHeadC6[nX,2]) == "C6_ENTREG" )
					aColsC6[nY,nX] := dDataBase
				Case ( AllTrim(aHeadC6[nX,2]) == "C6_DESCRI" )
					aColsC6[nY,nX] := ADB->ADB_DESPRO
				Case ( AllTrim(aHeadC6[nX,2]) == "C6_PRUNIT" )
					aColsC6[nY,nX] := ADB->ADB_PRUNIT
				Case ( AllTrim(aHeadC6[nX,2]) == "C6_CONTRAT" )
					aColsC6[nY,nX] := SPACE(TAMSX3("C6_CONTRAT")[1])
				Case ( AllTrim(aHeadC6[nX,2]) == "C6_ITEMCON" )
					aColsC6[nY,nX] := SPACE(TAMSX3("C6_ITEMCON")[1])
				Case ( AllTrim(aHeadC6[nX,2]) == "C6_QTDLIB" )
					aColsC6[nY,nX] := 0
				Case ( AllTrim(aHeadC6[nX,2]) == "C6_UNSVEN" )
					aColsC6[nY,nX] := ADB->ADB_UNSVEN
				Case ( "C6_COMIS" $ AllTrim(aHeadC6[nX,2])  )
					If	ADB->(FieldPos("ADB"+SubStr(AllTrim(aHeadC6[nX,2]),3)))>0
						aColsC6[nY,nX] := ADB->(FieldGet(FieldPos("ADB"+SubStr(AllTrim(aHeadC6[nX,2]),3))))
					Else
						aColsC6[nY,nX] := CriaVar(aHeadC6[nX,2],.T.)
					EndIf
				Case ( AllTrim(aHeadC6[nX,2]) == "C6_CODISS" )
					aColsC6[nY,nX] := SB1->B1_CODISS
				OtherWise
					aColsC6[nY,nX] := CriaVar(aHeadC6[nX,2],.T.)
				EndCase

				If lFt400Lin .AND. !IsInCallStack('MATA410')
					aColsC6 := Execblock("FT400LIN",.F.,.F.,{aHeadC6,aColsC6})
				Endif

			Next nX

			If !Empty(ADB->ADB_TESCOB) .And. Empty(ADB->ADB_PEDCOB)
				aadd(aPedCob,aColsC6[nY])
			EndIf

			cFilAnt := IIf(Empty(ADB->ADB_FILENT),cFilAnt,ADB->ADB_FILENT)

			dbSelectArea("ADB")
			ADB->(DbSkip())

		EndDo

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Verifica se ha pedido para cobranca                                     ³
		//ÀÄÄÄÄÄÄÄ?ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If Len(aPedCob) > 0
			aColsC6 := aPedCob
		EndIf

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Grava o Pedido de Venda                                                 ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If !Empty(aColsC6)

			Begin Transaction

				aCols   := aColsC6
				aHeader := aHeadC6

				For nX := 1 To Len(aCols)
					MatGrdMont(nX)
				Next nX

				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Variaveis Utilizadas pela Funcao a410Inclui          ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				PRIVATE ALTERA := .F.
				PRIVATE INCLUI := .T.
				PRIVATE cCadastro := "Pedido de Venda de Remessa" //"Pedido de Venda"

				Pergunte("MTA410",.F.)
				aRotinaBkp := aRotina
				SC5->(a410Inclui(Alias(),Recno(),4,.T.,nStack,,.T.,nTipo))
				aRotina   := aRotinaBkp
				cNewPv    := SC5->C5_NUM

			End Transaction

			cFilAnt := cFilOld
		Else
			MsgInfo("Não há saldo faturado disponivel neste Pedido ","Atenção")
		EndIf

	EndIf

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Restaura a integridade da rotina                                    ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cFilAnt := cFilOld

	FWRestArea(aAreaSD2)
	FWRestArea(aAreaSC5)
	FWRestArea(aAreaSC6)
	FWRestArea(aArea)

Return()

/*/-------------------------------------------------------------------
	- Programa: fGetValor
	- Autor: Tarcisio Silva Miranda
	- Data: 12/10/2022
	- Descrição: Retorna o valor da nota fiscal.
-------------------------------------------------------------------/*/

Static Function fGetValor()

	Local nReturn 		:= 0
	Local cQuery    	:= ""
	Local cAliasQry 	:= ""
	Local nPosCod    	:= 1
	Local nPosEmp    	:= 2
	Local nPosFil     	:= 3
	Local cParam 	 	:= SuperGetMv("MV_XCLINFE",,"")
	Local aDeParaCli 	:= &(cParam)
	Local nPosArray  	:= aScan(aDeParaCli,{|x|Alltrim(Upper(x[nPosCod])) == ADA->ADA_XCLIOR+ADA->ADA_XLOJOR })
	Local cEmpPsq    	:= '02'//iif(nPosArray>0,aDeParaCli[nPosArray][nPosEmp],"01")
	Local cFilPsq     	:= '4200'//iif(nPosArray>0,aDeParaCli[nPosArray][nPosFil],"")
//VALOR DA NOTA
	cQuery := " SELECT  " 									+ CRLF
	cQuery += " 	SUM(D2_PRCVEN) AS VALMERCAD " 			+ CRLF
	cQuery += " FROM SD2"+cEmpPsq+"0 SD2 "        			+ CRLF
	cQuery += " WHERE SD2.D_E_L_E_T_ = ' '  " 				+ CRLF
	cQuery += " AND D2_FILIAL 	= '"+cFilPsq+"' " 			+ CRLF
	cQuery += " AND D2_DOC	 	= '"+ADA->ADA_XNFORI+"' " 	+ CRLF
	cQuery += " AND D2_SERIE 	= '"+ADA->ADA_XSEORI+"' " 	+ CRLF
	cQuery += " AND D2_CLIENTE 	= '"+ADA->ADA_XCLIOR+"' " 	+ CRLF
	cQuery += " AND D2_LOJA 	= '"+ADA->ADA_XLOJOR+"' " 	+ CRLF
	cQuery += " AND D2_ITEM 	= '01' " 					+ CRLF

	cAliasQry := MPSysOpenQuery(cQuery)

	if !(cAliasQry)->(Eof())
		nReturn := (cAliasQry)->VALMERCAD
	endif

	if Select(cAliasQry) > 0 .AND. !Empty(cAliasQry)
		(cAliasQry)->(DbCloseArea())
	endif

Return(nReturn)

/*/-------------------------------------------------------------------
	- Programa: RetQtdFat
	- Autor: Claudio Ferreira
	- Data: 19/09/2022
	- Descrição: Função que retorna a quantidade entregue (Faturada) pedido de venda
-------------------------------------------------------------------/*/

User Function RetQtdFat(cNumPed,cNumCtr,cItemCtr)

	Local aArea         := FWGetArea()
	Local nRet          := 0
	Local cPulaLinha	:= chr(13)+chr(10)
	Local cQry          := ""

	// verifico se o alias já existe
	If Select("QRYSC6") > 0
		QRYSC6->(DbCloseArea())
	EndIf

	cQry := " SELECT "												+ cPulaLInha
	cQry += " SC6.C6_QTDENT AS QTD "                                + cPulaLInha
	cQry += " FROM "                                                + cPulaLInha
	cQry += " " + RetSqlName("SC6") + " SC6 "                       + cPulaLInha
	cQry += " WHERE "                                               + cPulaLInha
	cQry += " SC6.D_E_L_E_T_ <> '*' "                               + cPulaLInha
	cQry += " AND SC6.C6_FILIAL = '" + xFilial("SC6") + "' "        + cPulaLInha
	cQry += " AND SC6.C6_NUM = '" + cNumPed + "' "                  + cPulaLInha
	cQry += " AND SC6.C6_CONTRAT = '" + cNumCtr + "' "              + cPulaLInha
	cQry += " AND SC6.C6_ITEMCON = '" + cItemCtr + "' "             + cPulaLInha

	// converto a query para o protheus
	cQry := ChangeQuery(cQry)

	// crio o alias temporario
	TcQuery cQry New Alias "QRYSC6" // Cria uma nova area com o resultado do query

	// se a consulta retornou registros
	if QRYSC6->(!Eof())
		nRet := QRYSC6->QTD
	endif

	// verifico se o alias já existe
	If Select("QRYSC6") > 0
		QRYSC6->(DbCloseArea())
	EndIf

	FWRestArea(aArea)

Return(nRet)

/*/-------------------------------------------------------------------
	- Programa: RetQtdOrd
	- Autor: Claudio Ferreira
	- Data: 19/09/2022
	- Descrição: Função que retorna a quantidade em pedido de venda
-------------------------------------------------------------------/*/

User Function RetQtdOrd(cNumPed,cNumCtr,cItemCtr)

	Local aArea         := FWGetArea()
	Local nRet          := 0
	Local cPulaLinha	:= chr(13)+chr(10)
	Local cQry          := ""

	// verifico se o alias já existe
	If Select("QRYSC6") > 0
		QRYSC6->(DbCloseArea())
	EndIf

	cQry := " SELECT "												+ cPulaLInha
	cQry += " SUM( SC6.C6_QTDVEN ) AS QTD "                         + cPulaLInha
	cQry += " FROM "                                                + cPulaLInha
	cQry += " " + RetSqlName("SC5") + " SC5 "                       + cPulaLInha
	cQry += ", " + RetSqlName("SC6") + " SC6 "                      + cPulaLInha
	cQry += " WHERE "                                               + cPulaLInha
	cQry += " SC6.D_E_L_E_T_ <> '*' "                               + cPulaLInha
	cQry += " AND SC5.C5_FILIAL = '" + xFilial("SC5") + "' "        + cPulaLInha
	cQry += " AND SC6.C6_FILIAL = '" + xFilial("SC6") + "' "        + cPulaLInha
	cQry += " AND SC5.C5_XPEDORD = '" + cNumPed + "' "              + cPulaLInha
	cQry += " AND SC6.C6_NUM = SC5.C5_NUM " 	          		    + cPulaLInha
	cQry += " AND SC6.C6_CONTRAT = '" + cNumCtr + "' "              + cPulaLInha
	cQry += " AND SC6.C6_ITEMCON = '" + cItemCtr + "' "             + cPulaLInha

	// converto a query para o protheus
	cQry := ChangeQuery(cQry)

	// crio o alias temporario
	TcQuery cQry New Alias "QRYSC6" // Cria uma nova area com o resultado do query

	// se a consulta retornou registros
	if QRYSC6->(!Eof())
		nRet := QRYSC6->QTD
	endif

	// verifico se o alias já existe
	If Select("QRYSC6") > 0
		QRYSC6->(DbCloseArea())
	EndIf

	FWRestArea(aArea)

Return(nRet)

/*/-------------------------------------------------------------------
	- Programa: RetQtdPed
	- Autor: Tarcisio Silva Miranda
	- Data: 19/09/2022
	- Descrição: Retorna a quantidade do pedido/contrato.
-------------------------------------------------------------------/*/

Static Function RetQtdPed(cNumPed,cNumCtr,cItemCtr)

	Local nReturn 	 := 0
	Local cQuery     := ""
	Local cAliasQry	 := ""
	Default cNumPed  := ""
	Default cNumCtr  := ""
	Default cItemCtr := ""

	cQuery := " SELECT " 											+ CRLF
	cQuery += " 	SUM( SC6.C6_QTDVEN ) AS QTD " 					+ CRLF
	cQuery += " FROM " + RetSqlName("SC6") + " SC6  " 				+ CRLF
	cQuery += " WHERE SC6.D_E_L_E_T_ = ' ' " 						+ CRLF
	cQuery += " AND SC6.C6_CONTRAT = '"+cNumCtr+"' " 				+ CRLF
	cQuery += " AND SC6.C6_ITEMCON = '"+cItemCtr+"' " 				+ CRLF
	cQuery += " AND C6_FILIAL||C6_NUM IN ( " 						+ CRLF
	cQuery += " 	SELECT C5_FILIAL||C5_NUM " 						+ CRLF
	cQuery += " 	FROM " + RetSqlName("SC5") + " SC5 " 			+ CRLF
	cQuery += " 	WHERE SC5.D_E_L_E_T_ = ' ' " 					+ CRLF
	cQuery += " 	AND SC5.C5_FILIAL 	= '"+FWxFilial("SC5")+"' " 	+ CRLF
	cQuery += " 	AND SC5.C5_NUM 		= '"+cNumPed+"' " 			+ CRLF
	cQuery += " 	)  " 											+ CRLF

	cAliasQry := MPSysOpenQuery(cQuery)

	//Verifica se retornou dados na consulta, e se a quantidade é maior que zero.
	if !(cAliasQry)->(Eof()) .AND. (cAliasQry)->QTD > 0
		nReturn := (cAliasQry)->QTD
	endif

	//Fechando alias caso esteja aberta.
	if Select(cAliasQry) > 0 .AND. !Empty(cAliasQry)
		(cAliasQry)->(DbCloseArea())
	endif

Return(nReturn)

