#INCLUDE "Protheus.ch"
#INCLUDE "Totvs.ch"
#INCLUDE "topconn.ch"

/*/{Protheus.doc} MT103FIM
// Ponto de entrada para recompor saldo do contrato caso a nota de devolução seja incluida.
@author Gontijo - 2022-04-30
/*/

User Function MT103FIM()

	Local aArea     := GetArea()
	Local aAreaF1   := SF1->(GetArea())
	Local aAreaD1   := SD1->(GetArea())
	Local nOpcao    := PARAMIXB[1]   // Opção Escolhida pelo usuario no aRotina
	Local nConfirma := PARAMIXB[2]   // Se o usuario confirmou a operação de gravação
	Local cTes       := Posicione('SD2',3,SD1->D1_FILIAL+SD1->D1_NFORI+SD1->D1_SERIORI,"D2_TES")
	Local cNF        := SD1->D1_DOC
	Local cSerie     := SD1->D1_SERIE
	Local cNFOrig    := SD1->D1_NFORI
	Local cSerieOrig := SD1->D1_SERIORI
	Local cFilOrig   := SD1->D1_FILIAL
	Local cCliOrig   := SD1->D1_FORNECE
	Local cLojOrig   := SD1->D1_LOJA
	Local cCtrOrig   := ""
	Local cQryAtu    := ""
	Local cPedido    := SD1->D1_PEDIDO
	Local cLocalArm  := ""

	DbSelectArea('SF4')
	SF4->(DbSetOrder(1))

	DbSelectArea('SD2')
	SD2->(DbSetOrder(3))

	DbSelectArea('SD1')
	SD1->(DbSetOrder(1))

	DbSelectArea('ADB')
	ADB->(DbSetOrder(3))

	SF4->(dbGoTop())

	SD2->(dbGoTop())

	ADB->(dbGoTop())

	If nOpcao == 3 .and. nConfirma == 1

		If SD2->(Dbseek(cFilOrig + cNFOrig + cSerieOrig + cCliOrig + cLojOrig))

			cCtrOrig := Posicione('SC5',1,cFilOrig+SD2->D2_PEDIDO,"C5_CONTRA")

			cOper := BuscaADB(cFilOrig,cCtrOrig)

			SD1->(dbGoTop())

			If SD1->(Dbseek(cFilOrig+cNF+cSerie+cCliOrig+cLojOrig))

				If SF4->(Dbseek(xFilial("SF4")+cTes))

					If cOper = '55'

						If SF4->F4_DUPLIC = 'N' .and. SF4->F4_ESTOQUE = 'S' .and. SF1->F1_TIPO = 'D'

							Begin Transaction

								While SD1->(!Eof()) .and. SD1->D1_FILIAL = cFilOrig .and. SD1->D1_DOC = cNF .and. SD1->D1_SERIE = cSerie

									//Monta o Update
									cQryAtu := "UPDATE "+RetSQLName('ADB')+" SET ADB_QTDEMP = (ADB_QTDEMP - "+cValToChar(SD1->D1_QUANT)+")" + CRLF
									cQryAtu += "WHERE D_E_L_E_T_ <> '*' "                                                                   + CRLF
									cQryAtu += "AND ADB_FILIAL = '"+SD1->D1_FILIAL+"' "                                                     + CRLF
									cQryAtu += "AND ADB_NUMCTR = '"+cCtrOrig+"' "                                                           + CRLF
									cQryAtu += "AND ADB_CODCLI = '"+SD1->D1_FORNECE+"' "                                                    + CRLF
									cQryAtu += "AND ADB_LOJCLI = '"+SD1->D1_LOJA+"' "                                                       + CRLF
									cQryAtu += "AND ADB_CODPRO = '"+SD1->D1_COD+"' "                                                        + CRLF

									MemoWrite("C:\TEMP\cQry_ADB.txt",cQryAtu)

									//Tenta executar o update
									nErro := TcSqlExec(cQryAtu)

									If nErro != 0

										MsgStop("Erro na execução da query: "+TcSqlError(), "Atenção")

										DisarmTransaction()

									EndIf

									SD1->(dbSkip())

								EndDo

							End Transaction

						ElseIf SF4->F4_DUPLIC = 'S' .and. SF4->F4_ESTOQUE = 'N' .and. SF1->F1_TIPO = 'D'

							Begin Transaction

								While SD1->(!Eof()) .and. SD1->D1_FILIAL = cFilOrig .and. SD1->D1_DOC = cNF .and. SD1->D1_SERIE = cSerie

									//Monta o Update
									cQryAtu := "UPDATE "+RetSQLName('ADB')+" SET ADB_QTDEMP = (ADB_QTDEMP + "+cValToChar(SD1->D1_QUANT)+")"   + CRLF
									cQryAtu += "WHERE D_E_L_E_T_ <> '*' "                                                                   + CRLF
									cQryAtu += "AND ADB_FILIAL = '"+SD1->D1_FILIAL+"' "                                                     + CRLF
									cQryAtu += "AND ADB_NUMCTR = '"+cCtrOrig+"' "                                                           + CRLF
									cQryAtu += "AND ADB_CODCLI = '"+SD1->D1_FORNECE+"' "                                                    + CRLF
									cQryAtu += "AND ADB_LOJCLI = '"+SD1->D1_LOJA+"' "                                                       + CRLF
									cQryAtu += "AND ADB_CODPRO = '"+SD1->D1_COD+"' "                                                        + CRLF

									MemoWrite("C:\TEMP\cQry_ADB.txt",cQryAtu)

									//Tenta executar o update
									nErro := TcSqlExec(cQryAtu)

									If nErro != 0

										MsgStop("Erro na execução da query: "+TcSqlError(), "Atenção")
										DisarmTransaction()

									EndIf

									//Monta o Update
									cQryAtuTot := "UPDATE "+RetSQLName('ADB')+" SET ADB_TOTAL = ADB_QUANT * ADB_PRCVEN"                        + CRLF
									cQryAtuTot += "WHERE D_E_L_E_T_ <> '*' "                                                                   + CRLF
									cQryAtuTot += "AND ADB_FILIAL = '"+SD1->D1_FILIAL+"' "                                                     + CRLF
									cQryAtuTot += "AND ADB_NUMCTR = '"+cCtrOrig+"' "                                                           + CRLF
									cQryAtuTot += "AND ADB_CODCLI = '"+SD1->D1_FORNECE+"' "                                                    + CRLF
									cQryAtuTot += "AND ADB_LOJCLI = '"+SD1->D1_LOJA+"' "                                                       + CRLF
									cQryAtuTot += "AND ADB_CODPRO = '"+SD1->D1_COD+"' "                                                        + CRLF

									MemoWrite("C:\TEMP\cQry_ADB.txt",cQryAtuTot)

									//Tenta executar o update
									nErro := TcSqlExec(cQryAtuTot)

									If nErro != 0

										MsgStop("Erro na execução da query: "+TcSqlError(), "Atenção")
										DisarmTransaction()

									EndIf

									SD1->(dbSkip())

								EndDo

							End Transaction

						EndIF

					ElseIf cOper = '70' //Contrato só tem notas de remessa, caso seja devolvido, a quantidade devolvida deve voltar a compor novamente o saldo do contrato

						Begin Transaction

							While SD1->(!Eof()) .and. SD1->D1_FILIAL = cFilOrig .and. SD1->D1_DOC = cNF .and. SD1->D1_SERIE = cSerie

								//Monta o Update
								cQryAtu := "UPDATE "+RetSQLName('ADB')+" SET ADB_QTDEMP = (ADB_QTDEMP - "+cValToChar(SD1->D1_QUANT)+")" + CRLF
								cQryAtu += "WHERE D_E_L_E_T_ <> '*' "                                                                   + CRLF
								cQryAtu += "AND ADB_FILIAL = '"+SD1->D1_FILIAL+"' "                                                     + CRLF
								cQryAtu += "AND ADB_NUMCTR = '"+cCtrOrig+"' "                                                           + CRLF
								cQryAtu += "AND ADB_CODCLI = '"+SD1->D1_FORNECE+"' "                                                    + CRLF
								cQryAtu += "AND ADB_LOJCLI = '"+SD1->D1_LOJA+"' "                                                       + CRLF
								cQryAtu += "AND ADB_CODPRO = '"+SD1->D1_COD+"' "                                                        + CRLF

								MemoWrite("C:\TEMP\cQry_ADB.txt",cQryAtu)

								//Tenta executar o update
								nErro := TcSqlExec(cQryAtu)

								If nErro != 0

									MsgStop("Erro na execução da query: "+TcSqlError(), "Atenção")

									DisarmTransaction()

								EndIf

								SD1->(dbSkip())

							EndDo

						End Transaction

					ElseIf cOper = '50'	//Contrato de venda direta, caso seja devolvido, deverá zerar o saldo do contrato e encerrar o mesmo

						Begin Transaction

							While SD1->(!Eof()) .and. SD1->D1_FILIAL = cFilOrig .and. SD1->D1_DOC = cNF .and. SD1->D1_SERIE = cSerie

								//Monta o Update
								cQryAtu := "UPDATE "+RetSQLName('ADB')+" SET ADB_QTDEMP = ADB_QUANT"                                    + CRLF
								cQryAtu += "WHERE D_E_L_E_T_ <> '*' "                                                                   + CRLF
								cQryAtu += "AND ADB_FILIAL = '"+SD1->D1_FILIAL+"' "                                                     + CRLF
								cQryAtu += "AND ADB_NUMCTR = '"+cCtrOrig+"' "                                                           + CRLF
								cQryAtu += "AND ADB_CODCLI = '"+SD1->D1_FORNECE+"' "                                                    + CRLF
								cQryAtu += "AND ADB_LOJCLI = '"+SD1->D1_LOJA+"' "                                                       + CRLF
								cQryAtu += "AND ADB_CODPRO = '"+SD1->D1_COD+"' "                                                        + CRLF

								MemoWrite("C:\TEMP\cQry_ADB.txt",cQryAtu)

								//Tenta executar o update
								nErro := TcSqlExec(cQryAtu)

								If nErro != 0

									MsgStop("Erro na execução da query: "+TcSqlError(), "Atenção")

									DisarmTransaction()

								EndIf

								SD1->(dbSkip())

							EndDo

							//Monta o Update
							cQryAtu := "UPDATE "+RetSQLName('ADA')+" SET ADA_STATUS = 'E'"                 + CRLF
							cQryAtu += "WHERE D_E_L_E_T_ <> '*' "                                          + CRLF
							cQryAtu += "AND ADA_FILIAL = '"+cFilOrig+"' "                                  + CRLF
							cQryAtu += "AND ADA_NUMCTR = '"+cCtrOrig+"' "                                  + CRLF
							cQryAtu += "AND ADA_CODCLI = '"+cCliOrig+"' "                                  + CRLF
							cQryAtu += "AND ADA_LOJCLI = '"+cLojOrig+"' "                                  + CRLF

							MemoWrite("C:\TEMP\cQry_ADA.txt",cQryAtu)

							//Tenta executar o update
							nErro := TcSqlExec(cQryAtu)

							If nErro != 0

								MsgStop("Erro na execução da query: "+TcSqlError(), "Atenção")
								DisarmTransaction()

							EndIf

						End Transaction

					EndIf

				EndIf

			Endif

		EndIf

	EndIf

	dbSelectArea("SC7")
	dbSetOrder(1)
	SC7->(dbGoTop())

	If SC7->(Dbseek(xFilial("SC7")+cPedido)) .and. PARAMIXB[2] == 1

		while !SC7->(eof()) .and. SC7->C7_NUM == cPedido

			cProd := C7_PRODUTO
			cLocalArm := C7_XLOCAL
			dData := dTos(C7_EMISSAO)
			nQtdLan := C7_QUANT
			cFornece := C7_FORNECE
			cLoja := C7_LOJA

			if empty(C7_XLOCAL)
				MovInterPr(cLocalArm,cPedido,cProd,dData,nQtdLan,cFornece,cLoja)
				SC7->(dbSkip())
			end
			// Avança para o próximo item do pedido

		enddo
	end

	SC7->(dbCloseArea())
	SF4->(dbCloseArea())
	SD2->(dbCloseArea())

	RestArea(aArea)
	RestArea(aAreaF1)
	RestArea(aAreaD1)

Return

Static Function BuscaADB(cFilOrig,cCtrOrig)

	Local cOper    := ""
	Local cQryOper := ""

	If Select("cQryOper") > 0
		cQryOper->(dbclosearea())
	EndIf

	cQryOper := "SELECT ADB_XTIPO AS OPERACAO "                                       + CRLF
	cQryOper += "FROM "+RetSqlName( "ADB" ) + " ADB "                                 + CRLF
	cQryOper += "WHERE ADB.D_E_L_E_T_ <> '*' "                                        + CRLF
	cQryOper += "AND ADB_FILIAL = '"+cFilOrig+"' "                                    + CRLF
	cQryOper += "AND ADB_NUMCTR = '"+cCtrOrig+"' "                                    + CRLF

	MemoWrite("C:\TEMP\cQryOper.txt",cQryOper)
	cQryOper := ChangeQuery(cQryOper)

	TcQuery cQryOper New Alias "cQryOper" // Cria uma nova area com o resultado do query

	cOper := cQryOper->OPERACAO

Return cOper

Static Function MovInterPr(cLocalArm,cPedido,cProd,dData,nQtdLan,cFornece,cLoja)

	Local aArea
	Local _cSQL := ""
	Local cLocOri := "02"
	Local cLocDes := SuperGetMV("MV_XARMCENT",.F.,.T.)

	//SALDO INICIAL ARMAZEM ORIGEM
	dbSelectArea("SB9")
	dbSetOrder(1)
	SB9->(dbGoTop())
	If SB9->(Dbseek(xFilial("SB9")+cProd+cLocOri))
		ConOut("O produto "+cProd+ " jï¿½ existe na SB9!")

	Else
		lMsErroAuto := .F.
		aLinhaSL      := {}
		//CRIAR EXECAUTO PARA CRIAï¿½ï¿½O DE SALDO INICIAL
		aadd(aLinhaSL,{"B9_COD",cProd,})
		aadd(aLinhaSL,{"B9_LOCAL",cLocOri,})
		aadd(aLinhaSL,{"B9_QINI",0,})
		//aadd(aLinhaSL,{"B9_DATA",dDataAtu,})
		MSExecAuto({|x,y| mata220(x,y)},aLinhaSL,3)
		If !lMsErroAuto
			ConOut("Incluido com sucesso! "+cProd)
		Else
			MostraErro()
		EndIf
		ConOut("Fim : "+Time())
	EndIf

	//SALDO INICIAL ARMAZEM DESTINO
	dbSelectArea("SB9")
	dbSetOrder(1)
	SB9->(dbGoTop())
	If SB9->(Dbseek(xFilial("SB9")+cProd+cLocDes))
		ConOut("O produto "+cProd+ " jï¿½ existe na SB9!")

	Else
		lMsErroAuto := .F.
		aLinhaSL      := {}
		//CRIAR EXECAUTO PARA CRIAï¿½ï¿½O DE SALDO INICIAL
		aadd(aLinhaSL,{"B9_COD",cProd,})
		aadd(aLinhaSL,{"B9_LOCAL",cLocDes,})
		aadd(aLinhaSL,{"B9_QINI",0,})
		//aadd(aLinhaSL,{"B9_DATA",dDataAtu,})
		MSExecAuto({|x,y| mata220(x,y)},aLinhaSL,3)
		If !lMsErroAuto
			ConOut("Incluido com sucesso! "+cProd)
		Else
			MostraErro()
		EndIf
		ConOut("Fim : "+Time())
	EndIf

	//TRANSFERENCIA
	dbSelectArea("SB2")
	dbSetOrder(1)
	SB2->(dbGoTop())
	If SB2->(DBSeek(xFilial("SB2")+cProd+cLocOri))
		RecLock("SB2",.F.)
		SB2->B2_QATU    += nQtdLan
		//SB2->B2_QTSEGUM := ConvUM(cProduto,nQtdLan,0,2) // 2UM
		//SB2->B2_XCHNOTA := cFilial+cNota+cFornece+cLoja //FILIAL+NOTA+FORNECEDOR+LOJA
		MsUnlock()
		//nSB2 := SB2->B2_QATU
	Endif

	//ExecAuto para movimento interno da filial de origem para filial 02 caso C7_XLOCAL nï¿½o preenchido

	_cSQL:="SELECT * FROM " +RetSqlName("SB1")
	_cSQL+=" WHERE D_E_L_E_T_<>'*' AND B1_FILIAL ='"+xFilial('SB1')+"' "
	_cSQL+="AND B1_COD >='"+cProd+"' AND B1_COD <='"+cProd+"' "
	_cSQL+=" ORDER BY B1_COD,B1_LOCPAD "

	_cSQL := ChangeQuery(_cSQL) //comando para evitar erros de incompatibilidade de bancos

	if select("QRYSB1") > 0
		QRYSB1->(dbCloseArea())
	endif

	TcQuery _cSQL New Alias "QRYSB1" // Cria uma nova area com o resultado do query

	QRYSB1->(DbGoTop())

	if !QRYSB1->B1_TIPO $ 'SV' .and. PARAMIXB[1] =! 5

		aArea   := GetArea()
		aAuto       := {}
		aLinha      := {}
		// Cabeï¿½alho
		//MELHORAR PADRÃO DOCUMENTO
		cDocumen := GetSxeNum("SD3","D3_DOC")
		aAdd(aAuto,{"AC"+cDocumen,dData})
		// Itens a Incluir
		// Origem
		aAdd(aLinha,{"D3_COD"       ,QRYSB1->B1_COD        ,Nil}) //Cod Produto origem
		aAdd(aLinha,{"D3_DESCRI"    ,QRYSB1->B1_DESC       ,Nil}) //descr produto origem
		aAdd(aLinha,{"D3_UM"        ,QRYSB1->B1_UM         ,Nil}) //unidade medida origem
		aAdd(aLinha,{"D3_LOCAL"     ,cLocOri            ,Nil}) //armazem origem
		aAdd(aLinha,{"D3_LOCALIZ"   ,""                 ,Nil}) //Informar endereÃ§o origem
		// Destino
		aAdd(aLinha,{"D3_COD"       ,QRYSB1->B1_COD        ,Nil}) //cod produto destino
		aAdd(aLinha,{"D3_DESCRI"    ,QRYSB1->B1_DESC       ,Nil}) //descr produto destino
		aAdd(aLinha,{"D3_UM"        ,QRYSB1->B1_UM         ,Nil}) //unidade medida destino
		aAdd(aLinha,{"D3_LOCAL"     ,cLocDes            ,Nil}) //armazem destino
		aadd(aLinha,{"D3_LOCALIZ"	, ""				,Nil}) //Informar endereÃ§o destino

		aadd(aLinha,{"D3_NUMSERI", "", Nil}) //Numero serie
		aadd(aLinha,{"D3_LOTECTL", "", Nil}) //Lote Origem
		aadd(aLinha,{"D3_NUMLOTE", "", Nil}) //sublote origem
		aadd(aLinha,{"D3_DTVALID", ctod(''), Nil}) //data validade
		aadd(aLinha,{"D3_POTENCI", 0, Nil}) // Potencia
		aadd(aLinha,{"D3_OBSERVA","Gerado pela U_MovInter",NIL})
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
		// Transferï¿½ncias
		MSExecAuto({|x,y| MATA261(x,y)},aAuto,3)
		If lMsErroAuto
			MostraErro()
		EndIF
	elseif PARAMIXB[1] == 5

		//construir estorno

		//-- Preenchimento dos campos
		aAuto := {}
		aadd(aAuto,{"D3_DOC", "AC"+cDocumen, Nil})
		aadd(aAuto,{"D3_COD", QRYSB1->B1_COD, Nil})
		//D3_ESTORNO = S

		DbSelectArea("SD3")
		DbSetOrder(2)
		DbSeek(xFilial("SD3")+cDocumen+QRYSB1->B1_COD)

		//-- Teste de Estorno
		nOpcAuto := 6 // Estornar
		MSExecAuto({|x,y| mata261(x,y)},aAuto,nOpcAuto)

		If lMsErroAuto
			MostraErro()
		Else
			conout("Estorno de movimentação multipla efetuada com sucesso")
		EndIf
		//execauto estorno SD3
		//eliminar saldo na SB2 após estorno


	endif

Return
