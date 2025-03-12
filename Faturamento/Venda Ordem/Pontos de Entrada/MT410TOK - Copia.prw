#INCLUDE "rwmake.ch"
#INCLUDE "topconn.ch"
#INCLUDE "Protheus.ch"

/*/-------------------------------------------------------------------
- Programa: MT410TOK
- Autor: Carlos Daniel
- Data: 15/06/2017
- Descrição: Ponto de Entrada executado ao clicar no botão OK e pode
ser usado para validar a confirmação das operações: incluir, alterar,
copiar e excluir. Se o ponto de entrada retorna o conteúdo .T., o
sistema continua a operação, caso contrário, volta para a tela do
pedido
-------------------------------------------------------------------/*/

User Function MT410Tok()

	Local aArea  := FWGetArea()
	Local _lRet := .t.
	//Local I
	Local _mArea    := {"ADA", "SA1", "SE4", "SA3","ADB","SF4"}
	Local _mAlias   := U_SalvaAmbiente(_mArea)
	Local vDesc := 0
	LOCAL vIcm := 0
	LOCAL cEST  := ' '  //Estado do Cliente
	LOCAL cTIPc := ' '
	LOCAL cGrup := ' '  //Grupo do Produto
	LOCAL nDESC := 0
	LOCAL cSafra := ' ' //MARCACAO QUE IGNORA CONTRATOS ANTIGOS 26/06/2022
	Private cQry := Space(0)
	Private cQry1 := Space(0)
	Private cQry2 := Space(0)
	Private cAlias := Criatrab(Nil,.F.)
	Private cAlias1 := Criatrab(Nil,.F.)
	Private cAlias2 := Criatrab(Nil,.F.)

	//Executado apos a confirmação do pedido de vendas de remessa ao cliente do contrato.
	//Apresenta a tela pedido ordem, valida se não foi deletado ou incluso nenhum linha no
	//pedido de copia do contrato de parceria.
	if ExistBlock("UFATE008")
		_lRet := U_UFATE008()
	endif

	if _lRet

		// Valida cliente se tem debido para supra se o mesmo tem inadimplencia financeira .

		_nTotal:={}
		_nValor:=0
		//SE1->(Dbselectarea("SE1"))
		//SE1->(Dbsetorder(2))
		//SE1->(Dbseek(xFilial("SE1")+M->C5_CLIENTE+M->C5_LOJACLI))

		//While SE1->(!Eof()).And. SE1->E1_CLIENTE==M->C5_CLIENTE
			//If SE1->E1_SALDO>0 .And.SE1->E1_VENCTO<dDatabase
			//	AADD(_nTotal ,SE1->E1_SALDO)
			//Endif
			//SE1->(DbSkip())
		//End
		//For I:=1 to Len(_nTotal)
			//_nTotal[I]
			//_nValor:=_nValor+_nTotal[I]
		//Next
		SA1->(dbSetOrder(1))
		SA1->(dbSeek(xFilial("SA1")+M->C5_CLIENTE+M->C5_LOJACLI))

		SE4->(dbSetOrder(1))
		SE4->(dbSeek(xFilial("SE4")+ADA->ADA_CONDPG))

		SA3->(dbSetOrder(1))
		SA3->(dbSeek(xFilial("SA3")+ADA->ADA_VEND1))

		ADB->(dbSetOrder(1))
		ADB->(dbSeek(xFilial("ADB")+ADA->ADA_NUMCTR+"01"))

		cQry := " SELECT sum(E1_SALDO) as DIVIDA FROM SE1010 SE1 "
		cQry += " WHERE SE1.d_e_l_e_t_ <> '*' "
		cQry += " AND e1_saldo > 0 " 
		cQry += " AND e1_cliente = '"+M->C5_CLIENTE+"' "	
		cQry += " AND E1_TIPO NOT IN ('RA','NCC') "
		cQry += " (E1_VENCREA < "+DTOS(dDatabase)+" OR E1_XNEG = '1')"
		DbUseArea(.T., "TOPCONN", TcGenQry(,, cQry), cAlias, .T., .T.)
		DbGotop()

		cQry1 := " SELECT sum(E1_SALDO) as DIVIDA FROM SE1020 SE1 "
		cQry1 += " WHERE SE1.d_e_l_e_t_ <> '*' "
		cQry1 += " AND e1_saldo > 0 "
		cQry1 += " AND e1_cliente = '"+M->C5_CLIENTE+"' "
		cQry1 += " AND E1_TIPO NOT IN ('RA','NCC') "
		cQry1 += " (E1_VENCREA < "+DTOS(dDatabase)+" OR E1_XNEG = '1')"
		DbUseArea(.T., "TOPCONN", TcGenQry(,, cQry1), cAlias1, .T., .T.)
		DbGotop()

		cQry2 := " SELECT sum(E1_SALDO) as DIVIDA FROM SE1060 SE1 "
		cQry2 += " WHERE SE1.d_e_l_e_t_ <> '*' "
		cQry2 += " AND e1_saldo > 0 "
		cQry2 += " AND e1_cliente = '"+M->C5_CLIENTE+"' "
		cQry2 += " AND E1_TIPO NOT IN ('RA','NCC') "
		cQry2 += " AND (E1_VENCREA < "+DTOS(dDatabase)+" OR E1_XNEG = '1')"
		DbUseArea(.T., "TOPCONN", TcGenQry(,, cQry2), cAlias2, .T., .T.)
		DbGotop()

		_nValor := (cAlias)->DIVIDA+(cAlias1)->DIVIDA+(cAlias2)->DIVIDA
		If _nValor>0
			MsgBox("Favor entrar contato com Financeiro. RAMAL 1015 !!!","AVISO!!!",)
			_lRet := .T. //aceita salvar pedido mesmo com restrição
			//Return(_lRet)
			(cAlias)->(dbCloseArea())
			(cAlias1)->(dbCloseArea())
			(cAlias2)->(dbCloseArea())
		ELSE			
			(cAlias)->(dbCloseArea())
			(cAlias1)->(dbCloseArea())
			(cAlias2)->(dbCloseArea())
		Endif

		//aJUSTE iCMS DESONERADO

		IF ADB->ADB_XTIPO == '50' .OR. ADB->ADB_XTIPO == '70' .OR. ADB->ADB_XTIPO == '81'
			SF4->(DbSetOrder(1))
			SF4->(DbSeek(xFilial("SF4")+ADB->ADB_TES) )                    //FILIAL+CODIGO
		ELSEIF ADB->ADB_XTIPO == '55' .OR. ADB->ADB_XTIPO == '85'
			SF4->(DbSetOrder(1))
			SF4->(DbSeek(xFilial("SF4")+ADB->ADB_TES) )                    //FILIAL+CODIGO
		ENDIF

		//trata desconto ICMS desonerado Carlos Daniel
		IF SF4->F4_BASEICM == 0
			vIcm  := SF4->F4_BASEICM 
		Else
			vIcm  := (100-SF4->F4_BASEICM)
		EndIf
		cEST  := SA1->A1_EST  //Estado do Cliente
		cTIPc := SA1->A1_CONTRIB  //SE CONTRIBUINTE
		cGrup := Posicione("SB1",1,xFilial("SB1")+ADB->ADB_CODPRO,"B1_GRUPO")  //Grupo do Produto
		cSafra := TRIM(ADA->ADA_CODSAF)

		IF cSafra <> '000001'
				IF vIcm > 0 .AND. cEmpAnt <> '50'
					IF cTIPc == '1' .And. cEST <>'MG'  //SE CLIENTE FOR PRODUTO FORA DO ESTADO MG e grupo calcario
						IF cGrup == '0056' .OR. cGrup == '0108' .OR.  cGrup == '0106'
							IF cEST == 'PR' .OR. cEST== 'RS' .OR. cEST== 'RJ'.OR. cEST== 'SC' .OR. cEST== 'SP'
								IF DTos(ADA->ADA_EMISSA) <= '20230504'
									nDESC := 12
									vDesc := ROUND(((aCols[n,7] - ((aCols[n,7]*vIcm)/100))*nDESC/100),4)
								Else	
									nDESC := 0.88
									vDesc := ROUND((aCols[n,7]-(aCols[n,7]*nDESC)),4)//ROUND(((aCols[n,7] - ((aCols[n,7]*vIcm)/100))*nDESC/100),2)
								endIf
								MsgBox("CONTRIBUINTE FORA DO ESTADO, TERA DESCONTO DE R$: "+Alltrim(Transform(vDesc," @E 999,999.99"))+" na Nota fiscal!!!","AVISO!!!",)
								//vDesc := vIcm
							ELSE
								IF DTos(ADA->ADA_EMISSA) <= '20230504'
									nDESC := 7
									vDesc := ROUND(((aCols[n,7] - ((aCols[n,7]*vIcm)/100))*nDESC/100),4)
								Else	
									nDESC := 0.93
									vDesc := ROUND((aCols[n,7]-(aCols[n,7]*nDESC)),4)//ROUND(((aCols[n,7] - ((aCols[n,7]*vIcm)/100))*nDESC/100),2)
								endIf
								MsgBox("CONTRIBUINTE FORA DO ESTADO, TERA DESCONTO DE R$: "+Alltrim(Transform(vDesc," @E 999,999.99"))+" na Nota fiscal!!!","AVISO!!!",)
								//vDesc :=  vIcm
							ENDIF
							/*
						elseif cGrup == '0106'
							IF cEST == 'PR' .OR. cEST== 'RS' .OR. cEST== 'RJ'.OR. cEST== 'SC' .OR. cEST== 'SP'
								IF DTos(ADA->ADA_EMISSA) <= '20230504'
									nDESC := 12
									vDesc := ROUND(((aCols[n,7] - ((aCols[n,7]*vIcm)/100))*nDESC/100),4)
								Else	
									nDESC := 0.88
									vDesc := ROUND((aCols[n,7]-(aCols[n,7]*nDESC)),4)//ROUND(((aCols[n,7] - ((aCols[n,7]*vIcm)/100))*nDESC/100),2)
								endIf
								MsgBox("CONTRIBUINTE FORA DO ESTADO, TERA DESCONTO DE R$: "+Alltrim(Transform(vDesc," @E 999,999.99"))+" na Nota fiscal!!!","AVISO!!!",)
							ELSE
								IF DTos(ADA->ADA_EMISSA) <= '20230504'
									nDESC := 7
									vDesc := ROUND(((aCols[n,7] - ((aCols[n,7]*vIcm)/100))*nDESC/100),4)
								Else	
									nDESC := 0.93
									vDesc := ROUND((aCols[n,7]-(aCols[n,7]*nDESC)),4)//ROUND(((aCols[n,7] - ((aCols[n,7]*vIcm)/100))*nDESC/100),2)
								endIf
								MsgBox("CONTRIBUINTE FORA DO ESTADO, TERA DESCONTO DE R$: "+Alltrim(Transform(vDesc," @E 999,999.99"))+" na Nota fiscal!!!","AVISO!!!",)
								//vDesc :=  vIcm
							ENDIF
							*/
						ENDIF
					ENDIF
				ENDIF

		ELSE
			vDesc := aCols[n,20]
			MsgBox("Contribuinte ja teve desconto anteriormente na Nota fiscal!!!","AVISO!!!",)
		ENDIF
		M->C5_DESCONT := vDesc //verificar

	endif

	U_VoltaAmbiente(_mAlias)

	FWRestArea(aArea)

Return(_lRet)
