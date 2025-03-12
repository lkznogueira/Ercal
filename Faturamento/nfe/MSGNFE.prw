#INCLUDE "RWMAKE.CH"
#INCLUDE "PROTHEUS.CH"


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MSGNFE   ºAutor  ³CARLOS DANIEL        º Data ³  05/11/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ FUNÇÃO UTILIZADA NO CADASTRO DE FORMULAS E NO FONTE NFESEFAZ±±
±±º          ³ UTILIZADA PARA MENSAGENS PADROES                           º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ ERCAL                                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function MSGNFE(_nPar)

	LOCAL _cRet := ""
	LOCAL aAreaSd2 :={}
	LOCAL aRetorno		:= {}
	LOCAL cMsg := ""
	LOCAL cNOMEVEND := ""
	LOCAL cCodProd := SD2->D2_COD
	Local cDesProd := SD2->D2_DESC
	LOCAL cDatEmi := SF2->F2_EMISSAO //data emissao
	LOCAL cGprod  := ""
	LOCAL cFilizz := ""
	LOCAL dData   := DATE()
	LOCAL nLinhas := 0
	LOCAL nLinha  := 0
	LOCAL cMemo
	LOCAL cContrat := ""
	Local fUncao   := FUNNAME()

	If fUncao <> "MATA103"
		//Posiciona no Pedido e pega campos de mensagem e observação
		SC5->( dbSetOrder(1) )
		SC5->( dbSeek(xFilial("SC5")+SD2->(D2_PEDIDO)),.F.)

		cContrat := SC5->C5_CONTRA

		SC5->(dbCloseArea())

		DbSelectArea("SA3")
		DbSetOrder(1)
		DbSeek(xFilial("SA3")+SC5->C5_VEND1)
		cNOMEVEND := Posicione("SA3",1,xFilial("SA3")+SF2->F2_VEND1,"A3_NOME")
		_cRet := "Vendedor: " + ALLTRIM(SF2->F2_VEND1) + " - " + ALLTRIM(cNOMEVEND)+";"
		_cRet += "End. Cobrança:"+" Rua:"+AllTrim(SA1->A1_ENDCOB) + "/ " + AllTrim(SA1->A1_MUNC) + "/" + AllTrim(SA1->A1_ESTC) + "/ CEP:" + AllTrim(SA1->A1_CEPC)+ ";"
		// Local Entrega: " + AllTrim(SA1->A1_ENDENT) + ", " + AllTrim(SA1->A1_MUNE) + "/" + AllTrim(SA1->A1_ESTE)
		//PEGA NOTA MAE PARA SER INFORMADA
		cQuery := "SELECT SC6.C6_NUM, SC6.C6_SERIE, SC6.C6_NOTA, SC6.C6_CONTRAT"
		cQuery += " FROM "+RetSqlName("SC6")+" SC6 "
		cQuery += "INNER JOIN " +RetSqlName("ADB")+" ADB ON ADB.ADB_FILIAL = SC6.C6_FILIAL AND ADB.ADB_NUMCTR = SC6.C6_CONTRAT"
		cQuery += "WHERE SC6.D_E_L_E_T_ != '*'"
		cQuery += "AND ADB.D_E_L_E_T_ != '*'"
		cQuery += "AND SC6.C6_CONTRAT = '"+cContrat+"'"
		cQuery += "AND SC6.C6_FILIAL = '"+xFilial("ADB")+"'"
		cQuery += "AND SC6.C6_TES = '527'"
		Count To nLinha
		cQuery := ChangeQuery(cQuery)

		IF SELECT("QADB")>1
			QADB->(DbCloseArea())
		ENDIF

		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"QADB",.T.,.T.)

		dbSelectArea("QADB")
		QADB->(DbGotop())



		If nLinha > 0
			_cRet := "Vendedor: " + ALLTRIM(SF2->F2_VEND1) + " - " + ALLTRIM(cNOMEVEND)+" - NF-eMãe:"+ QADB->C6_NOTA+";"
		ELSE
			_cRet := "Vendedor: " + ALLTRIM(SF2->F2_VEND1) + " - " + ALLTRIM(cNOMEVEND)+";"
		ENDIF
		_cRet += "End. Cob.:"+" "+AllTrim(SA1->A1_ENDCOB) + "/ " + AllTrim(SA1->A1_MUNC) + "/" + AllTrim(SA1->A1_ESTC) + "/ CEP:" + AllTrim(SA1->A1_CEPC)+ ";"


		// --------------------------------------------------------------------------------------------------------------------------
		// DADOS NOTA REFERENTE A GARANTIA DO PRODUTO
		// --------------------------------------------------------------------------------------------------------------------------

		aAreaSd2 := SD2->(GetArea())

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
		//If nLinhas > 0
		IF !Empty(cGprod)
			//cGprod  := QZZ3->ZZ3_PROD
			//cFilizz := QZZ3->ZZ3_FILIAL
			_cRet += AllTrim(QZZ3->BOX)+" - "
			_cRet += "DT. Fabricação"+Space(2)+CVALTOCHAR(dData)+ ";"
		EndIF

		QZZ3->(DbCloseArea())
		DbSelectArea("SA3")
		dbCloseArea("SA3")

		RestArea(aAreaSD2)
	else
		Return
	EndIf
Return _cRet
