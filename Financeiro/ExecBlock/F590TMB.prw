#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'TOTVS.CH'

/*/{Protheus.doc} F590TMB
@description - O ponto de entrada foi criado para a manipulação dos campos que compõe a tela inicial da Manutenção de Borderôs.
@type function
@version  
@author Raphael Ferreira - Oficina5
@since 11/10/2021
@return variant, return_description
/*/
User Function F590TMB()

	Local lPanelFin	:= IsPanelFin()
	Local aBordero  := Array(3)
	Local nOpca		:= 0
	Local nRadio	:= 0
	Local nOpcAPriv	:= 0
	Local oDlg		:= Nil
	Local lBorAut	:= .F.

	If FWIsInCallStack("U_M460FIM")
		lBorAut := .T.
	EndIf

	If lBorAut
		aBordero[1] := 1
		aBordero[2] := xNumBor
		If lPrimeira
			aBordero[3] := 1
			lPrimeira	:= .F.
		Else
			aBordero[3] := 0
		EndIf
	Else
		nOpca := 0
		DEFINE MSDIALOG oDlg FROM  094,1 TO 200,293 TITLE "Manutenção de Borderô" PIXEL
		@ 05,07 TO 32, 140 OF oDlg  PIXEL
		If ! lPanelFin
			@ 10,10 RADIO oRadio VAR nRadio;
				ITEMS "Receber","Pagar"; //###
			3D SIZE 50,10 OF oDlg PIXEL

			@ 10,60 SAY "Bordero" SIZE 023,07 OF oDlg PIXEL  //
			@ 10,90 MSGET cNumBor          SIZE 023,10 OF oDlg PIXEL Valid VldBord(nRadio)//FA590NumC()

			DEFINE SBUTTON FROM 35,085 TYPE 1 ENABLE OF oDlg ACTION (nOpca := 1, oDlg:End())
			DEFINE SBUTTON FROM 35,115 TYPE 2 ENABLE OF oDlg ACTION (nOpca := 0, oDlg:End())

			ACTIVATE MSDIALOG oDlg CENTERED

		Else

			If lPanelFin .And. (Alltrim(cNumBor)) == ""
				F590Bord()
			Endif

			If Finwindow:cAliasFile == "SE1"
				nRadio := 1
			Else
				nRadio := 2
			Endif

			nOpca := nOpcAPriv

		Endif

		aBordero[1] := nRadio
		aBordero[2] := cNumBor
		aBordero[3] := nOpca
	EndIf

Return(aBordero)

/*/{Protheus.doc} VldBord
@description
@type function
@version  
@author Raphael Ferreira - oficina5
@since 22/11/2021
@return variant, return_description
/*/
Static Function VldBord(_nRadio)

	Local lRetorna	:=.F.
	Local aSaveArea	:= GetArea()
	Local cCart		:= ""
	Local nTamBor	:= TamSX3("EA_NUMBOR")[1]
	Local nRadio	:= _nRadio

	Default lF590Bord := .F.

	If lF590Bord
		If Finwindow:cAliasFile == "SE1"
			cCart := "R"
		Else
			cCart := "P"
		Endif
	Else
		cCart := IIf(nRadio==1,"R","P")
	Endif

	If !Empty(cNumBor)
		dbSelectArea( "SEA" )
		SEA->( dbSetOrder(2) )
		If SEA->( dbSeek(cFilAnt+PADR(cNumBor,nTamBor)+cCart,.t.) )
			__cFilBor := XFILIAL("SEA",cFilAnt)
			__cChvSEA := SEA->(EA_FILIAL+EA_NUMBOR+EA_CART)
			lRetorna  := .T.
		Endif
	Endif

// Ponto de Entrada para validacao sobre a selecao do bordero para manutencao.
	If ExistBlock( "FA590BOR" )
		lRetorna := ExecBlock( "FA590BOR", .F., .F., { cNumBor, cCart } )
	EndIf

	If !lRetorna
		Help(" ",1,"F590NOBORD")
	EndIf

	RestArea(aSaveArea)
Return lRetorna

