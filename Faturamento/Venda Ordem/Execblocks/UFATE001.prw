#Include "Rwmake.ch"
#Include "Protheus.ch"
#Include "Totvs.ch"

/*/-------------------------------------------------------------------
- Programa: UFATE001
- Autor: Tarcisio Silva Miranda
- Data: 19/09/2022
- Descrição: Acionado pelo ponto de entrada FISTRFNFE , valida
a transmissão da nota fiscal, trava a transmissão caso a nota
referente ao pedido de vendas de remessa do destinatário ,
seja transmitido antes da remessa do contrato do cleinte.
-------------------------------------------------------------------/*/      

User Function UFATE001()

	Local aAreaSC5	:= SC5->(FWGetArea())
	Local lReturn 	:= .T.
	Local cQuery    := ""
	Local cAliasQry := ""
	Local cUrl		:= Padr( GetNewPar("MV_SPEDURL",""), 250 )
	Local cIdEnt 	:= GetIdEnt(cUrl)

	//Verifica se o pedido é customizado, de ordem.
	cQuery := " SELECT " 									+ CRLF
	cQuery += " 	  C5_XPEDORD AS PEDORDEM " 				+ CRLF
	cQuery += " 	, C5_FILIAL  AS FILIAL " 				+ CRLF
	cQuery += " FROM " + RetSqlName("SC5")+ " SC5 "  		+ CRLF
	cQuery += " WHERE SC5.D_E_L_E_T_ = ' '  " 				+ CRLF
	cQuery += " AND C5_FILIAL 	= '"+SF2->F2_FILIAL+"' " 	+ CRLF
	cQuery += " AND C5_NOTA 	= '"+SF2->F2_DOC+"' " 		+ CRLF
	cQuery += " AND C5_SERIE 	= '"+SF2->F2_SERIE+"' " 	+ CRLF
	cQuery += " AND C5_CLIENTE 	= '"+SF2->F2_CLIENTE+"' " 	+ CRLF
	cQuery += " AND C5_LOJACLI 	= '"+SF2->F2_LOJA+"' " 		+ CRLF
	cQuery += " AND C5_XPEDORD <> ' ' " 					+ CRLF

	cAliasQry := MPSysOpenQuery(cQuery)

	if !(cAliasQry)->(Eof())

		//Procura o pedido padrão atrávez do pedido customizado.
		SC5->(DbSetOrder(1))
		//Posiciona no pedido padrão.
		if SC5->(DbSeek( (cAliasQry)->FILIAL + (cAliasQry)->PEDORDEM ))
			//Valida se o pedido padrão esta faturado.
			if Empty(SC5->C5_NOTA)
				lReturn := .F.
				MsgInfo("É necessário faturar o Pedido " + AllTrim(cNumPedOrd) + " antes de transmitir a nota fiscal.","Atenção!")
			else
				//Se o pedido padrão estiver faturado, verifica se a NF esta transmitida.
				if !fVldNFTrans(cIdEnt, cUrl, SC5->C5_SERIE, SC5->C5_NOTA)
					lReturn := .F.
					MsgInfo("É necessário transmitir a nota " + AllTrim(SC5->C5_NOTA) + " antes de transmitir a nota." + AllTrim(SF2->F2_DOC),"Atenção!")
				endif
			endif
		else
			lReturn := .F.
			MsgInfo("O Pedido " + AllTrim(cNumPedOrd) + " foi excluído, esta remessa não poderá ser transmitida!","Atenção!")
		endif
	endif

	if lReturn
		SpedNFeRemessa()
	endif

	//Fecha a alias, se estiver aberta.
	if Select(cAliasQry) > 0 .AND. !Empty(cAliasQry)
		(cAliasQry)->(DbCloseArea())
	endif

	FWRestArea(aAreaSC5)

Return(.F.)

/*/-------------------------------------------------------------------
	- Programa: fVldNFTrans
	- Autor: Tarcísio Silva Miranda.
	- Data: 19/09/2022
	- Descrição: Valida se a NF foi transmitida.
-------------------------------------------------------------------/*/

Static Function fVldNFTrans(cIdEnt, cUrl, cSerie, cDoc)

	Local cRecomendacao		:= ""
	Local lOk				:= .F.
	Local oWs				:= Nil
	Local oRetorno			:= Nil
	Local lReturn 			:= .F.
	Default cIdEnt 			:= ""
	Default cUrl 			:= ""
	Default cSerie 			:= ""
	Default cDoc 			:= ""

	oWS:= wsNfeSBra():new()
	oWS:cUserToken	:= "TOTVS"
	oWS:cId_ent		:= cIdEnt
	oWS:_url		:= AllTrim(cUrl)+"/NFeSBRA.apw"
	oWS:cIdInicial  := cSerie+cDoc
	oWS:cIdFinal    := cSerie+cDoc

	lOk := oWS:monitorFaixa()

	oRetorno := oWS:oWsMonitorFaixaResult:oWSMonitorNfe

	if lOk
		if len(oRetorno) > 0
			cRecomendacao	:= PadR(oRetorno[1]:cRecomendacao,250)
			lReturn 		:= AllTrim(cRecomendacao) == "001 - Emissão de DANFE autorizada"
		endif
	endif

	FreeObj( oWs )
	oWs	:= nil

Return(lReturn)

/*/-------------------------------------------------------------------
	- Programa: GetIdEnt
	- Autor: Tarcisio Silva Miranda.
	- Data: 19/09/2022
	- Descrição: Obtem o codigo da entidade.
-------------------------------------------------------------------/*/

Static Function GetIdEnt(cUrl)

	Local aArea  	:= FWGetArea()
	Local cIdEnt 	:= ""
	Local oWs		:= Nil
	Default cUrl	:= ""

	oWS := WsSPEDAdm():New()
	oWS:cUSERTOKEN := "TOTVS"

	oWS:oWSEMPRESA:cCNPJ       := IIF(SM0->M0_TPINSC==2 .Or. Empty(SM0->M0_TPINSC),SM0->M0_CGC,"")
	oWS:oWSEMPRESA:cCPF        := IIF(SM0->M0_TPINSC==3,SM0->M0_CGC,"")
	oWS:oWSEMPRESA:cIE         := SM0->M0_INSC
	oWS:oWSEMPRESA:cIM         := SM0->M0_INSCM
	oWS:oWSEMPRESA:cNOME       := SM0->M0_NOMECOM
	oWS:oWSEMPRESA:cFANTASIA   := SM0->M0_NOME
	oWS:oWSEMPRESA:cENDERECO   := FisGetEnd(SM0->M0_ENDENT)[1]
	oWS:oWSEMPRESA:cNUM        := FisGetEnd(SM0->M0_ENDENT)[3]
	oWS:oWSEMPRESA:cCOMPL      := FisGetEnd(SM0->M0_ENDENT)[4]
	oWS:oWSEMPRESA:cUF         := SM0->M0_ESTENT
	oWS:oWSEMPRESA:cCEP        := SM0->M0_CEPENT
	oWS:oWSEMPRESA:cCOD_MUN    := SM0->M0_CODMUN
	oWS:oWSEMPRESA:cCOD_PAIS   := "1058"
	oWS:oWSEMPRESA:cBAIRRO     := SM0->M0_BAIRENT
	oWS:oWSEMPRESA:cMUN        := SM0->M0_CIDENT
	oWS:oWSEMPRESA:cCEP_CP     := Nil
	oWS:oWSEMPRESA:cCP         := Nil
	oWS:oWSEMPRESA:cDDD        := Str(FisGetTel(SM0->M0_TEL)[2],3)
	oWS:oWSEMPRESA:cFONE       := AllTrim(Str(FisGetTel(SM0->M0_TEL)[3],15))
	oWS:oWSEMPRESA:cFAX        := AllTrim(Str(FisGetTel(SM0->M0_FAX)[3],15))
	oWS:oWSEMPRESA:cEMAIL      := UsrRetMail(RetCodUsr())
	oWS:oWSEMPRESA:cNIRE       := SM0->M0_NIRE
	oWS:oWSEMPRESA:dDTRE       := SM0->M0_DTRE
	oWS:oWSEMPRESA:cNIT        := IIF(SM0->M0_TPINSC==1,SM0->M0_CGC,"")
	oWS:oWSEMPRESA:cINDSITESP  := ""
	oWS:oWSEMPRESA:cID_MATRIZ  := ""
	oWS:oWSOUTRASINSCRICOES:oWSInscricao := SPEDADM_ARRAYOFSPED_GENERICSTRUCT():New()
	oWS:_URL := AllTrim(cURL)+"/SPEDADM.apw"

	If oWs:ADMEMPRESAS()
		cIdEnt  := oWs:cADMEMPRESASRESULT
	Else
		Aviso("SPED",IIf(Empty(GetWscError(3)),GetWscError(1),GetWscError(3)),{"Entidade"},3)
	EndIf

	FWRestArea(aArea)

Return(cIdEnt)
