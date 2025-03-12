// _________________________________________________________________________________________________
//|Quando se referir aos complementos para geracao dos registros C110, C111, C112, C113, C114 e C115|
//|  a tabela CDT também deve ser alimentada, pois ela que efetua o relacionamentos com as outras   |
//|  conforme registro. C110 = Tab. CDT, C111 = Tab. CDG, , C112 = Tab. CDC, C113 = Tab. CDD,       |
//|  C114 = Tab. CDE e C115 = Tab. CDF                                                              |
//|_________________________________________________________________________________________________|
//ajuste Carlos Daniel
User Function MATUCOMP()
LOCAL cContrat := "" 
LOCAL cNota := "" 
LOCAL cSerie := ""  
LOCAL cAlias := Criatrab(Nil,.F.)
LOCAL cAlias1 := Criatrab(Nil,.F.)
//LOCAL cAlias2 := Criatrab(Nil,.F.)
LOCAL cQrey := Space(0) 
//LOCAL cQrey2 := Space(0) 
LOCAL cQry := Space(0) 
cEntSai := ParamIXB[1]
cDoc    := ParamIXB[3]
cSerie  := ParamIXB[2]
cCliefor:= ParamIXB[4]
cLoja   := ParamIXB[5]
CDT->(DbSetOrder(1)) 
CDD->(DbSetOrder(1)) 
lExiste := CDT->(dbSeek(xFilial("CDT")+cEntSai+cDoc+cSerie+cClieFor+cLoja))
lExist  := CDD->(dbSeek(xFilial("CDD")+cEntSai+cDoc+cSerie+cClieFor+cLoja))

If cEntSai="S"
	If lExiste
		RecLock("CDT",.F.)
	Else
		RecLock("CDT",.T.)
	EndIf
	/*
	//PEGA CF NOTA PRINCIPAL
	cQrey2 := " SELECT D2_CF
	cQrey2 += " FROM "+RetSqlName("SD2")+" SD2 
	cQrey2 += " WHERE SD2.D_E_L_E_T_ != '*'
	cQrey2 += " AND D2_DOC = '"+cDoc+"'
	cQrey2 += " AND D2_SERIE = '"cSerie"'
	cQrey2 += " AND D2_FILIAL = '"+xFilial("SF2")+"'
	cQrey2 += " AND D2_CLIENTE = '"+cClieFor+"'
	cQrey2 += " AND D2_LOJA = '"+cLoja+"'
	cQrey2 += " AND ROWNUM = 1
		
	DbUseArea(.T., "TOPCONN", TcGenQry(,, cQrey2), cAlias2, .T., .T.)
	DbGotop()
	*/
	IF SD2->D2_CF = '5116' .OR. SD2->D2_CF = '6116' .OR. SD2->D2_CF = '5118' .OR. SD2->D2_CF = '6118'
	
		CDT->CDT_FILIAL	:= xFilial("CDT")
		CDT->CDT_TPMOV	:= cEntSai
		CDT->CDT_DOC	:= cDoc
		CDT->CDT_SERIE	:= cSerie
		CDT->CDT_CLIFOR	:= cClieFor
		CDT->CDT_LOJA	:= cLoja
		CDT->CDT_IFCOMP := "000010"
		CDT->CDT_DCCOMP := 'XXX'
		MsUnLock()
		FkCommit()
    
		if !empty(SD2->D2_NFORI)
			If lExist
				RecLock("CDD",.F.)
				Else
				RecLock("CDD",.T.)
				EndIf
			CDD->CDD_FILIAL	:= xFilial("CDD")
			CDD->CDD_TPMOV	:= cEntSai
			CDD->CDD_DOC	:= cDoc
			CDD->CDD_SERIE	:= cSerie
			CDD->CDD_CLIFOR	:= cClieFor
			CDD->CDD_LOJA	:= cLoja
			CDD->CDD_IFCOMP :=  "000010"
			CDD->CDD_DOCREF := SD2->D2_NFORI
			CDD->CDD_SERREF := SD2->D2_SERIORI
			CDD->CDD_SDOC 	:= cSerie
			CDD->CDD_SDOCRF	:= SD2->D2_SERIORI
			CDD->CDD_PARREF	:= cClieFor
			CDD->CDD_LOJREF	:= cLoja
			MsUnLock()
			FkCommit() 
		Else
			If lExist
				RecLock("CDD",.F.)
			Else
				RecLock("CDD",.T.)
			EndIf
			SC5->( dbSetOrder(1) )
			SC5->( dbSeek(xFilial("SC5")+SD2->(D2_PEDIDO)),.F.)

			cContrat := SC5->C5_CONTRA

			//PEGA NOTA MAE PARA SER INFORMADA
			cQry += " SELECT SC6.C6_NUM, SC6.C6_SERIE, SC6.C6_NOTA, SC6.C6_CONTRAT
			cQry += " FROM "+RetSqlName("SC6")+" SC6 
			cQry += " INNER JOIN " +RetSqlName("ADB")+" ADB ON ADB.ADB_FILIAL = SC6.C6_FILIAL AND ADB.ADB_NUMCTR = SC6.C6_CONTRAT
			cQry += " WHERE SC6.D_E_L_E_T_ != '*'
			cQry += " AND ADB.D_E_L_E_T_ != '*'
			cQry += " AND SC6.C6_CONTRAT = '"+cContrat+"'
			cQry += " AND SC6.C6_FILIAL = '"+xFilial("ADB")+"'
			cQry += " AND SC6.C6_TES = '527'

			DbUseArea(.T., "TOPCONN", TcGenQry(,, cQry), cAlias, .T., .T.)
			DbGotop()
			//PEGA CHAVE DA NOTA MAE
			cQrey := " SELECT F2_CHVNFE
			cQrey += " FROM "+RetSqlName("SF2")+" SF2 
			cQrey += " WHERE SF2.D_E_L_E_T_ != '*'
			cQrey += " AND F2_DOC = '"+(cAlias)->C6_NOTA+"'
			cQrey += " AND F2_SERIE = '"+(cAlias)->C6_SERIE+"'
			cQrey += " AND F2_FILIAL = '"+xFilial("SF2")+"'
			cQrey += " AND F2_CLIENTE = '"+cClieFor+"'
			cQrey += " AND F2_LOJA = '"+cLoja+"'
		
			DbUseArea(.T., "TOPCONN", TcGenQry(,, cQrey), cAlias1, .T., .T.)
			DbGotop()
		
			If (cAlias)->C6_NOTA <> " "
				cNota := (cAlias)->C6_NOTA
				cSerie := alltrim((cAlias)->C6_SERIE)
			ELSE
				cNota := ' '
				cSerie := ' '			
			endif	
			CDD->CDD_FILIAL	:= xFilial("CDD")
			CDD->CDD_TPMOV	:= cEntSai
			CDD->CDD_DOC	:= cDoc
			CDD->CDD_SERIE	:= cSerie
			CDD->CDD_CLIFOR	:= cClieFor
			CDD->CDD_LOJA	:= cLoja
			CDD->CDD_IFCOMP := "000010"
			CDD->CDD_SDOC 	:= cSerie
			CDD->CDD_PARREF	:= cClieFor
			CDD->CDD_LOJREF	:= cLoja
			CDD->CDD_DOCREF := cNota
			CDD->CDD_SERREF := cSerie
			CDD->CDD_CHVNFE := (cAlias1)->F2_CHVNFE
			(cAlias)->(dbSkip())
			(cAlias1)->(dbSkip())
			MsUnLock()
			FkCommit()
		endif 
	EndIf
Else 

    
	If lExist	
		RecLock("CDD",.F.)
	Else	
		RecLock("CDD",.T.)	
		CDD->CDD_FILIAL	:= xFilial("CDD")	
		CDD->CDD_TPMOV	:= cEntSai	
		CDD->CDD_DOC	:= cDoc	
		CDD->CDD_SERIE	:= cSerie	
		CDD->CDD_CLIFOR	:= cClieFor	
		CDD->CDD_LOJA	:= cLoja
	EndIf									
	CDD->CDD_IFCOMP := SF4->F4_CODINFC
	MsUnLock()
	FkCommit()
EndIf	

Return
