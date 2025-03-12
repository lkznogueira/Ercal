#Include "Totvs.ch"

/*/-----------------------------------------------------------------------------
Programa: UFATE009
Autor: Claudio Ferreira
Data: 06/2022
Descrição: Tela pedido ordem, acionado através dos fontes MT410TOK/UFATE008.
-----------------------------------------------------------------------------/*/

User Function UFATE009()

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

Return(Nil)

/*/-----------------------------------------------------------------------------
	Programa: TelaUsr
	Autor: Claudio Ferreira
	Data: 06/2022
	Descrição: Apresenta a tela para preenchimento dos dados.
-----------------------------------------------------------------------------/*/

Static Function TelaUsr()

	Private oDlg
	Private oCliNom
	Private oCliLoj
	Private oNfNum
	Private oNfSer
	Private oNfEmi
	Private oNfChv
	Private cCliCod           := SC5->C5_CLIENT
	Private cCliLoj           := SC5->C5_LOJAENT
	Private cCliNom           := ""
	Private cNfNum            := Space(TamSX3("F2_DOC")[1])
	Private cNfSer            := Space(TamSX3("F2_SERIE")[1])
	Private dNfEmi            := CtoD("")
	Private cNfChv            := Space(TamSX3("F2_CHVNFE")[1])
//tras dados nota grid 1 copia pedido
	SA1->(dbSeek(fwxFilial("SA1") + cCliCod + cCliLoj))
	cCliNom := SA1->A1_NOME
	cNfNum  := ADA->ADA_XNFORI
	cNfSer  := ADA->ADA_XSEORI
	cNfChv  := ADA->ADA_XCHORI
	dNfEmi  := ADA->ADA_XEMORI

	// posiciona no pedido..
	Define msDialog oDlg Title "Complemente o Pedido de Remessa" from 000,000 to 250,750 Pixel Style 128

	oDlg:lEscClose := .F.

	@ 020,025 Say "Cliente:" Size 025,008 of oDlg Pixel
	@ 018,060 msGet oCliCod Var cCliCod Size 032,010  When .F. of oDlg Pixel
	@ 018,096 msGet oCliLoj Var cCliLoj Size 016,010  When .F. of oDlg Pixel
	@ 018,127 msGet oCliNom Var cCliNom Size 214,010  When .F. of oDlg Pixel
	
	@ 035,025 Say "Nota Fiscal:" Size 032,008 of oDlg Pixel
	@ 033,060 msGet oNfNum Var cNfNum Size 060,010 of oDlg Pixel F3 "XSF2" Valid fValCampo() HASBUTTON
	
	@ 035,124 Say "Serie:" Size 020,008 of oDlg Pixel
	@ 033,143 msGet oNfSer Var cNfSer Size 026,010 of oDlg Pixel When .F.
	
	@ 035,192 Say "Emissao:" Size 025,008 of oDlg Pixel
	@ 033,224 msGet oNfEmi Var dNfEmi Size 047,010 of oDlg Pixel When .F.
	
	@ 050,025 Say "Chave:" Size 025,008 of oDlg Pixel
	@ 048,060 msGet oNfChv Var cNfChv Size 166,010 of oDlg Pixel When .F.

	Define sButton from 080,025 Type 01 Enable Action IIf(VldNota(@cNfNum, @cNfSer, dNfEmi, cNfChv, cCliCod, cCliLoj), (U_fGrvPedOrd(cNfNum, cNfSer, cNfChv, dNfEmi, cCliCod, cCliLoj), oDlg:End()), .T.) of oDlg Pixel
	Define sButton from 080,068 Type 02 Enable Action oDlg:End() of oDlg Pixel
	//Define sButton from 080,068 Type 02 Enable Action IIf(VldNota(@cNfNum, @cNfSer, dNfEmi, cNfChv, cCliCod, cCliLoj), (U_fGrvPedOrd(cNfNum, cNfSer, cNfChv, dNfEmi, cCliCod, cCliLoj), oDlg:End()), .T.) of oDlg Pixel

	Activate msDialog oDlg Centered

Return(Nil)

/*/-----------------------------------------------------------------------------
	Programa: fValCampo
	Autor: Claudio Ferreira
	Data: 06/2022
	Descrição: limpa o resto dos campos se a nf estiver vazia.
-----------------------------------------------------------------------------/*/
Static Function fValCampo()

	if empty(cNfNum)

		cNfNum := ""
		cNfSer := ""
		dNfEmi := cTod("")
		cNfChv := ""

		oNfNum:Refresh()
		oNfSer:Refresh()
		oNfEmi:Refresh()
		oNfChv:Refresh()

	endif

Return(.T.)

/*/-----------------------------------------------------------------------------
	Programa: VldNota
	Autor: Claudio Ferreira
	Data: 06/2022
	Descrição: Valida se a chave e os dados estão corretos.
-----------------------------------------------------------------------------/*/
Static Function VldNota(cNfNum, cNfSer, dNfEmi, cNfChv, cCliCod, cCliLoj)

	Local lRet	:= .T.

	cNfChv := StrTran(cNfChv," ","")
	If lRet .AND. (SubStr(cNfChv, 03, 02) <> Right(cValToChar(Year(dNfEmi)), 2) .OR. SubStr(cNfChv, 05, 02) <> StrZero(Month(dNfEmi), 2))
		msgAlert("A data da nota fiscal não está de acordo com a chave da NFe", "Aviso")
		lRet := .F.
	EndIf

	If lRet .AND. SubStr(cNfChv, 23, 03) <> StrZero(Val(cNfSer), 3)
		msgAlert("A série não está de acordo com a chave da NFe", "Aviso")
		lRet := .F.
	Else
		cNfSer := cNfSer//StrZero(Val(cNfSer), 3)
	EndIf

	If lRet .AND. SubStr(cNfChv, 26, 09) <> StrZero(Val(cNfNum), 9)
		msgAlert("Nota fiscal não está de acordo com a chave da NFe", "Aviso")
		lRet := .F.
	Else
		cNfNum := StrZero(Val(cNfNum), 9)
	EndIf

Return(lRet)

/*/-----------------------------------------------------------------------------
	Programa: fGrvPedOrd
	Autor: Claudio Ferreira
	Data: 06/2022
	Descrição: Grava os campos customizados na gravação do pedido de remessa
do destinatario.
-----------------------------------------------------------------------------/*/
User Function fGrvPedOrd(cNfNum, cNfSer, cNfChv, dNfEmi, cCliente, cLoja)

	Local aArea    		:= FWGetArea()
	
	ADA->(RecLock("ADA", .F.))
	ADA->ADA_XNFORI := cNfNum
	ADA->ADA_XSEORI := cNfSer
	ADA->ADA_XCHORI := cNfChv
	ADA->ADA_XEMORI := dNfEmi
	ADA->(msUnlock())

	FWRestArea(aArea)

Return(Nil)
