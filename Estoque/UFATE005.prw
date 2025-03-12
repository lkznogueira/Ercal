#INCLUDE "TOTVS.CH"

/*/-----------------------------------------------------------------------------
Programa: UFATE005
Autor: Claudio Ferreira
Data: 06/2022
Descrição: Tela pedido ordem
-----------------------------------------------------------------------------/*/
User Function UFATE005()

If SC6->(FieldPos("C6_XCHVORI"))> 0   //Claudio 09.06.22
	If !(SC5->C5_TIPO $ "DB")
		// posiciona no cliente
		SA1->(dbSetOrder(1)) // A1_FILIAL+A1_COD+A1_LOJA
		SA1->(dbSeek(fwxFilial("SA1") + SC5->C5_CLIENTE + SC5->C5_LOJACLI))

		If Empty(SC5->C5_NOTA) 
			// pedido a ordem de terceiros
			TelaUsr()
		else
			MsgAlert("Nota Fiscal encerrada! ")	
		EndIf
	EndIf
else
  MsgAlert("Opção não existente nesta empresa! ")			
Endif
Return



Static Function TelaUsr()
	Local oDlg
	Local oCliNom
	Local cCliCod           := SC5->C5_CLIENT
	Local cCliLoj           := SC5->C5_LOJAENT
	Local cCliNom           := ""
	Local cNfNum            := Space(TamSX3("F2_DOC")[1])
	Local cNfSer            := Space(TamSX3("F2_SERIE")[1])
	Local dNfEmi            := CtoD("")
	Local cNfChv            := Space(TamSX3("F2_CHVNFE")[1])

	SA1->(dbSeek(fwxFilial("SA1") + cCliCod + cCliLoj))
	cCliNom           := SA1->A1_NOME

    // posiciona SC6
	SC6->(dbSetOrder(1)) // C6_FILIAL+C6_NUM+C6_ITEM+C6_PRODUTO	
	if SC6->(dbSeek(fwxFilial("SC6") + SC5->C5_NUM)) 			
		cNfNum := SC6->C6_NFORI 
		cNfSer := SC6->C6_SERIORI  
		cNfChv := SC6->C6_XCHVORI 
		dNfEmi := SC6->C6_XEMIORI 				
	   msUnlock()
    endif


	// posiciona no pedido .
	Define msDialog oDlg Title "Complemente o Pedido de Remessa" from 000,000 to 250,750 Pixel

		@ 020,025 Say "Cliente:" Size 025,008 of oDlg Pixel
		@ 018,060 msGet cCliCod Size 032,010  When .F. of oDlg Pixel
		@ 018,096 msGet cCliLoj Size 016,010  When .F. of oDlg Pixel
		@ 018,127 msGet oCliNom Var cCliNom Size 214,010 When .F. of oDlg Pixel

		@ 035,025 Say "Nota Fiscal:" Size 032,008 of oDlg Pixel
		@ 033,060 msGet cNfNum Size 060,010 of oDlg Pixel
		@ 035,124 Say "Serie:" Size 020,008 of oDlg Pixel
		@ 033,143 msGet cNfSer Size 026,010 of oDlg Pixel
		@ 035,192 Say "Emissao:" Size 025,008 of oDlg Pixel
		@ 033,224 msGet dNfEmi Size 047,010 of oDlg Pixel

		@ 050,025 Say "Chave:" Size 025,008 of oDlg Pixel
		@ 048,060 msGet cNfChv Size 166,010 of oDlg Pixel		

		Define sButton from 080,025 Type 01 Enable Action IIf(VldNota(@cNfNum, @cNfSer, dNfEmi, cNfChv, cCliCod, cCliLoj), (U_GrvPedOrd(cNfNum, cNfSer, cNfChv, dNfEmi, cCliCod, cCliLoj), oDlg:End()), .T.) of oDlg Pixel
		Define sButton from 080,068 Type 02 Enable Action oDlg:End() of oDlg Pixel

	Activate msDialog oDlg Centered

Return



Static Function VldNota(cNfNum, cNfSer, dNfEmi, cNfChv, cCliCod, cCliLoj)
	Local lRet              := .T.
	cNfChv := StrTran(cNfChv," ","")
	If lRet .AND. (SubStr(cNfChv, 03, 02) <> Right(cValToChar(Year(dNfEmi)), 2) .OR. SubStr(cNfChv, 05, 02) <> StrZero(Month(dNfEmi), 2))
		msgAlert("A data da nota fiscal não está de acordo com a chave da NFe", "Aviso")
		lRet := .F.
	EndIf

	If lRet .AND. SubStr(cNfChv, 23, 03) <> StrZero(Val(cNfSer), 3)
		msgAlert("A série não está de acordo com a chave da NFe", "Aviso")
		lRet := .F.
	Else
		cNfSer := StrZero(Val(cNfSer), 3)
	EndIf

	If lRet .AND. SubStr(cNfChv, 26, 09) <> StrZero(Val(cNfNum), 9)
		msgAlert("Nota fiscal não está de acordo com a chave da NFe", "Aviso")
		lRet := .F.
	Else
		cNfNum := StrZero(Val(cNfNum), 9)
	EndIf


Return(lRet)



User Function GrvPedOrd(cNfNum, cNfSer, cNfChv, dNfEmi, cCliente, cLoja)
	Local aArea             := GetArea()
	Local aAreaSC5          := SC5->(GetArea())
	Local aAreaSC6          := SC6->(GetArea())

    // posiciona SC6
	SC6->(dbSetOrder(1)) // C6_FILIAL+C6_NUM+C6_ITEM+C6_PRODUTO	
	if SC6->(dbSeek(fwxFilial("SC6") + SC5->C5_NUM)) .AND. RecLock("SC6", .F.)				
		C6_NFORI := cNfNum
		C6_SERIORI := cNfSer
		C6_XCHVORI := cNfChv
		C6_XEMIORI := dNfEmi				
	   msUnlock()
    endif


	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Restaura a integridade da rotina                                    ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	RestArea(aAreaSC5)
	RestArea(aAreaSC6)
	RestArea(aArea)

Return
