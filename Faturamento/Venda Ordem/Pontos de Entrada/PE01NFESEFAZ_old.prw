#include "protheus.ch"

/*1
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³PE01NFESEFAZºAutor  ³Totvs        	 º Data ³  11/12/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³  Ponto de Entrada para Msg NF-e                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ LMB                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

#DEFINE CRLF Chr(13)+Chr(10)

User Function PE01NFESEFAZ()

	Local aProd			:= PARAMIXB[1]
	Local cMensCli		:= PARAMIXB[2]
	Local cMensFis		:= PARAMIXB[3]
	Local aDest			:= PARAMIXB[4]
	Local aNota   		:= PARAMIXB[5]
	Local aInfoItem		:= PARAMIXB[6]
	Local aDupl			:= PARAMIXB[7]
	Local aTransp		:= PARAMIXB[8]
	Local aEntrega		:= PARAMIXB[9]
	Local aRetirada		:= PARAMIXB[10]
	Local aVeiculo		:= PARAMIXB[11]
	Local aReboque		:= PARAMIXB[12]
	Local aNfVincRur	:= PARAMIXB[13]
	Local aEspVol		:= PARAMIXB[14]
	Local aNfVinc		:= PARAMIXB[15]
	Local aDetPag		:= PARAMIXB[16]
	Local aObsCont		:= PARAMIXB[17]
	Local aRetorno		:= {}
	//Local cMsg          := ""
	Local cNOMEVEND     := ""
	LOCAL _cRet := ""
	//LOCAL aAreaSd2 :={}
	//LOCAL cCodProd := rtrim(PARAMIXB[1])
	LOCAL cCodProd := SD2->D2_COD
	//Local cDesProd := SD2->D2_DESC
	//LOCAL cDatEmi := SF2->F2_EMISSAO //data emissao
	LOCAL cGprod  := ""
	LOCAL cFilizz := ""
	LOCAL dData   := DATE()
	LOCAL nLinhas := 0
	LOCAL nLinha  := 0
	//LOCAL cMemo
	LOCAL cContrat := ""
	//LOCAL vIcm := 0
	LOCAL cEST  := SD2->D2_EST  //Estado do Cliente
	LOCAL cTIPc := ' '  //SE CONTRIBUINTE
	LOCAL cGrup := ' '  //Grupo do Produto
	//LOCAL nDESC := 0
	LOCAL nTotDeson     := 0
	local cTipo 		:= ""

	// preecho a variavel cTipo
	if empty( cTipo )
		cTipo := if( len(aNota) > 0, aNota[04], "" ) // pego o tipo do array aNota, posicao 4
	endIf

	SC5->( dbSetOrder(1) )
	SC5->( dbSeek(xFilial("SC5")+SD2->(D2_PEDIDO)),.F.)

	cContrat := SC5->C5_CONTRA

	DbSelectArea("SA3")
	DbSetOrder(1)
	DbSeek(xFilial("SA3")+SC5->C5_VEND1)
	cNOMEVEND := Posicione("SA3",1,xFilial("SA3")+SF2->F2_VEND1,"A3_COD")  //Posicione("SA3",1,xFilial("SA3")+SF2->F2_VEND1,"A3_NOME")

	//PEGA NOTA MAE PARA SER INFORMADA
	cQuery := "SELECT SC6.C6_NUM, SC6.C6_SERIE, SC6.C6_NOTA, SC6.C6_CONTRAT"
	cQuery += " FROM "+RetSqlName("SC6")+" SC6 "
	cQuery += "INNER JOIN " +RetSqlName("ADB")+" ADB ON ADB.ADB_FILIAL = SC6.C6_FILIAL AND ADB.ADB_NUMCTR = SC6.C6_CONTRAT"
	cQuery += "WHERE SC6.D_E_L_E_T_ != '*'"
	cQuery += "AND ADB.D_E_L_E_T_ != '*'"
	cQuery += "AND SC6.C6_CONTRAT = '"+cContrat+"'"
	cQuery += "AND SC6.C6_FILIAL = '"+xFilial("ADB")+"'"
	cQuery += "AND SC6.C6_TES IN ('527','5A7')"
	Count To nLinha
	cQuery := ChangeQuery(cQuery)

	IF SELECT("QADB")>1
		QADB->(DbCloseArea())
	ENDIF

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"QADB",.T.,.T.)

	dbSelectArea("QADB")
	QADB->(DbGotop())

	//icms dispensado
	If SF4->F4_AGREG='D'
		CD2->(dbSeek(xFilial("CD2")+"S"+SF2->F2_SERIE+SF2->F2_DOC+SF2->F2_CLIENTE+SF2->F2_LOJA+PadR(SD2->D2_ITEM,4)+SD2->D2_COD+"ICM"))
		if CD2->CD2_DESONE>0
			nTotDeson = CD2->CD2_DESONE
		Endif
	EndIf
	IF SF2->F2_DESCONT > 0
		nTotDeson := SF2->F2_DESCONT
	EndIF
	cGrup := Posicione("SB1",1,xFilial("SB1")+SD2->D2_COD,"B1_GRUPO")  //Grupo do Produto
	cTIPc := Posicione("SA1",1,xFilial("SA1")+SD2->D2_CLIENTE+SD2->D2_LOJA,"A1_CONTRIB")
	//SD2->D2_CF
	If cTIPc == '1'// .And. cEST <>'MG'
		If TRIM(SD2->D2_CF) == '5922' .or. TRIM(SD2->D2_CF) == '6922' //cGrup == '0056' .And. cEST <>'MG'//.OR. cGrup == '0106'
			_cRet := " PRECO NORMAL R$ "+AllTrim(Transform((SF2->F2_VALMERC+nTotDeson), "@ze 9,999,999,999,999.99")) +" MENOS DESCONTO CONCEDIDO R$ "+AllTrim(Transform(nTotDeson, "@ze 9,999,999,999,999.99")) +" VALOR FINAL APOS DESCONTO R$"+AllTrim(Transform(SF2->F2_VALMERC, "@ze 9,999,999,999,999.99"))
		//elseif cGrup == '0106' .And. cEST <>'MG'
			//_cRet := " PRECO NORMAL R$ "+AllTrim(Transform((SF2->F2_VALMERC+nTotDeson), "@ze 9,999,999,999,999.99")) +" MENOS DESCONTO CONCEDIDO R$ "+AllTrim(Transform(nTotDeson, "@ze 9,999,999,999,999.99")) +" VALOR FINAL APOS DESCONTO R$"+AllTrim(Transform(SF2->F2_VALMERC, "@ze 9,999,999,999,999.99"))
		EndIF
	EndIF
	_cRet += " Rep.: " +ALLTRIM(cNOMEVEND)+Space(1)

	If TRIM(SD2->D2_CF) == '5116' .or.  TRIM(SD2->D2_CF) == '6116' .or.  TRIM(SD2->D2_CF) == '5118' .or.  TRIM(SD2->D2_CF) == '6118'	//QADB->C6_NOTA <> ' ' //QADB->(LASTREC()) > 0 //+ ALLTRIM(SF2->F2_VEND1) + " - " + ALLTRIM(cNOMEVEND)+" - NF-eMãe:"+ QADB->C6_NOTA+";"
		_cRet += "- NFe Mãe:"+ QADB->C6_NOTA+Space(1)//";"
	EndIF
	_cRet += "End. Cob.:"+" "+AllTrim(SA1->A1_ENDCOB) + "/ " + AllTrim(SA1->A1_MUNC) + "/" + AllTrim(SA1->A1_ESTC) + "/ CEP:" + AllTrim(SA1->A1_CEPC)+ ";"

	// --------------------------------------------------------------------------------------------------------------------------
	// DADOS NOTA REFERENTE A GARANTIA DO PRODUTO
	// --------------------------------------------------------------------------------------------------------------------------

	cQuery := "SELECT ZZ3_FILIAL, ZZ3_COD, ZZ3_PROD, Trim( UTL_RAW.CAST_TO_VARCHAR2( DBMS_LOB.SUBSTR( ZZ3_BOX,2000 ) ) ) AS BOX "
	cQuery += "FROM "+RetSqlName("ZZ3")+" ZZ3 "
	cQuery += "WHERE ZZ3.ZZ3_FILIAL = '"+xFilial("ZZ3")+"' AND "
	cQuery += "ZZ3.ZZ3_PROD = '"+cCodProd+"' AND "
	cQuery += "ZZ3.D_E_L_E_T_ <> '*' "
	cQuery += "ORDER BY ZZ3.ZZ3_PROD "
	Count To nLinhas
	cQuery := ChangeQuery(cQuery)

	IF SELECT("QZZ3")>1
		QZZ3->(DbCloseArea())
	ENDIF

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"QZZ3",.T.,.T.)

	dbSelectArea("QZZ3")
	QZZ3->(DbGotop())
	cGprod  := QZZ3->ZZ3_PROD
	cFilizz := QZZ3->ZZ3_FILIAL

	IF !Empty(cGprod)
		_cRet += AllTrim(QZZ3->BOX)
		IF trim(cGprod) == '032116'
			_cRet += " - "+""
		else
			_cRet += "DT. Fabricação"+CVALTOCHAR(dData)//+ ";"
		endif
	EndIF
	cMensCli += _cRet

	//Mensagem Frete Autonomo Claudio 25.06.15
	If SC5->C5_FRETAUT>0
		nValIcmAut:=(SC5->C5_FRETAUT)*(SD2->D2_PICM/100)
		cMensFis+='Icms Frete Aut.'+Alltrim(Transform(nValIcmAut,"@e 999,999,999.99"))
		cMensFis+=' '+U_GetMsgFre(SF2->F2_DOC,SF2->F2_SERIE)
	Endif

	IF !Empty(SC5->C5_XLOTE) // Adicionado LOTE na nota fiscal
		cMensFis += ' LOTE: ' + Alltrim(SC5->C5_XLOTE)
	Endif
	//Mensagem Remessa Destinatário
	// posiciona SC6
	SC6->(dbSetOrder(1)) // C6_FILIAL+C6_NUM+C6_ITEM+C6_PRODUTO
	SC6->(dbSeek(fwxFilial("SC6") + SD2->D2_PEDIDO))

	If SC6->(FieldPos("C6_XCHVORI"))> 0   //Claudio 09.06.22
		If !Empty(SC6->C6_XCHVORI)
			cMensFis+=" REMESSA POR CONTA E ORDEM DE TERCEIROS - REF. NFE EMIT. ADQ. SOB No "+SC6->C6_NFORI+" / SERIE "+SC6->C6_SERIORI+" /  DE "+Dtoc(SC6->C6_XEMIORI)+" / CHAVE DE ACESSO "+SC6->C6_XCHVORI
		Endif
	Endif

	//Monta a mensagem de Conta e ordem.
	cMensCli += fRetMsgCO() // ver nota importacao pega errado garantia cMensCli

	QZZ3->(DbCloseArea())

	aadd(aRetorno,aProd)    //1
	aadd(aRetorno,cMensCli) //2
	aadd(aRetorno,cMensFis) //3
	aadd(aRetorno,aDest)    //4
	aadd(aRetorno,aNota)    //5
	aadd(aRetorno,aInfoItem)//6
	aadd(aRetorno,aDupl)    //7
	aadd(aRetorno,aTransp)  //8
	aadd(aRetorno,aEntrega) //9
	aadd(aRetorno,aRetirada)//10
	aadd(aRetorno,aVeiculo) //11
	aadd(aRetorno,aReboque) //12
	aadd(aRetorno,aNfVincRur) //13
	aadd(aRetorno,aEspVol) //14
	aadd(aRetorno,aNfVinc) //15
	aadd(aRetorno,aDetPag) //16
	aadd(aRetorno,aObsCont) //17

RETURN aRetorno

/*/-------------------------------------------------------------------
	- Programa: fRetMsgCO
	- Autor: Tarcisio Silva Miranda
	- Data: 16/03/2021
	- Descrição: Monta a mensagem de Conta e ordem.
-------------------------------------------------------------------/*/

Static Function fRetMsgCO()

	Local aAreaSC6 		:= SC6->(FwGetArea())
	Local cReturn  		:= ""
	Local cParam 		:= SuperGetMv("MV_XCLINFE",,"")
	Local nPosCod   	:= 1
	Local nPosEmp   	:= 2
	Local nPosFil   	:= 3
	Local aDeParaCli	:= &(cParam) //{{'02083001','02','4200'},{'00371401','99','01'}}
	Local nPosArray 	:= aScan(aDeParaCli,{|x|Alltrim(Upper(x[nPosCod])) == 'SC5->C5_CLIENTE+SC5->C5_LOJACLI' })
	Local cFilPsq   	:= '4200'//iif(nPosArray>0,aDeParaCli[nPosArray][nPosFil],"")
	Local cEmpPsq   	:= '02'//iif(nPosArray>0,aDeParaCli[nPosArray][nPosEmp],"01")
	Local cQuery    	:= ""
	Local cAliasQry 	:= ""
	Local aFieldSM0 	:= {}
	Local aSM0Data2 	:= {}
	
	//Verifica se o campo existe.
	If SC5->(FieldPos("C5_XPEDORD"))> 0   //Tarcisio 13.10.22
		//Verifica se o conteúdo esta populado.
		If !Empty(SC5->C5_XPEDORD)

			//Carrrega os dados da empresa que serão apresentados na consulta.
			aAdd(aFieldSM0,"M0_NOMECOM"	)
			aAdd(aFieldSM0,"M0_ENDCOB"	)
			aAdd(aFieldSM0,"M0_COMPCOB"	)
			aAdd(aFieldSM0,"M0_BAIRCOB"	)
			aAdd(aFieldSM0,"M0_CIDCOB"	)
			aAdd(aFieldSM0,"M0_ESTCOB"	)
			aAdd(aFieldSM0,"M0_INSC"	)
			aAdd(aFieldSM0,"M0_CGC"		)
			
			//Função que retorna os dados da empresa.
			aSM0Data2 	:= FWSM0Util():GetSM0Data( cEmpPsq , cFilPsq , aFieldSM0 )

			//Monto a query da nota fiscal mãe em uma string.
			cQuery := " SELECT  "                           				+ CRLF
			cQuery += "      F2_DOC       	AS DOC "        				+ CRLF
			cQuery += "     ,F2_SERIE       AS SERIE "      				+ CRLF
			cQuery += "     ,F2_EMISSAO     AS EMISSAO "    				+ CRLF
			cQuery += "     ,F2_CHVNFE     	AS CHAVENFE "   				+ CRLF
			//cQuery += " FROM SF2"+cEmpPsq+"0 SF2 "        					+ CRLF
			cQuery += " FROM SF2020 SF2 "        							+ CRLF
			cQuery += " WHERE SF2.D_E_L_E_T_ = ' ' "        				+ CRLF
			cQuery += " AND F2_FILIAL   = '"+cFilPsq+"' "  					+ CRLF
			cQuery += " AND F2_DOC 		= '"+SC6->C6_NFORI+"' " 			+ CRLF
			cQuery += " AND F2_SERIE 	= '"+SC6->C6_SERIORI+"' " 			+ CRLF

			//Executa a query desenvolvida acima.
			cAliasQry := MPSysOpenQuery(cQuery)

			//Verifico se a query retornou dados.
			if !(cAliasQry)->(Eof())
				cReturn += " // REMESSA POR CONTA ORDEM DE TERCEIRO " +" "
				if len(aSM0Data2) > 0
					cReturn += AllTrim(aSM0Data2[1][2]) +" "//M0_NOMECOM
					cReturn += AllTrim(aSM0Data2[2][2]) +" "//M0_ENDCOB
					cReturn += AllTrim(aSM0Data2[3][2]) +" "//M0_COMPCOB
					cReturn += AllTrim(aSM0Data2[4][2]) +" "//M0_BAIRCOB
					cReturn += AllTrim(aSM0Data2[5][2]) +" "//M0_CIDCOB
					cReturn += AllTrim(aSM0Data2[6][2]) +" INSC "//M0_ESTCOB
					cReturn += Alltrim(Transform(aSM0Data2[7][2],"@R 999.999.999-9999") )+" CNPJ " 		//M0_INSC
					cReturn += Alltrim(Transform(aSM0Data2[8][2],"@R 99.999.999/9999-99") )+" "			//M0_CGC
				endif
				cReturn += " NOTA "  + (cAliasQry)->DOC
				cReturn += " SERIE " + AllTrim((cAliasQry)->SERIE)
				cReturn += " EMISSÃO " + dToc(sTod((cAliasQry)->EMISSAO))
				cReturn += " CHAVE DE ACESSO " + (cAliasQry)->CHAVENFE
			endif

			//Se a Alias estiver aberta, eu fecho ela.
			if Select(cAliasQry) > 0 .AND. !Empty(cAliasQry)
				(cAliasQry)->(DbCloseArea())
			endif
		Endif
	Endif

	FwRestArea(aAreaSC6)

Return(cReturn)
