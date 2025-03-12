#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'TOTVS.CH'

/*/{Protheus.doc} histcli
// Inclui Historico cliente
@author Carlos Daniel
/*/
User Function histcli()

	Local _aCoors 		:= FWGetDialogSize(oMainWnd)
	Local _aSize     	:= MsAdvSize( .T. )
	Local _aObjAux		:= {}
	Local _aPosAux		:= {}
	Local _aInfo		:= {}

	Local _cTitAux		:= "Historico de Cobrança"
    Local _cMemo        := ""

	Local dLiga			:= cTod("//")
	Local dPrlg			:= cTod("//")

	Local _xRet			:= { .F. , "" }

	Local _bOk			:= {|x| _xRet := { .T.  , _cMemo } , _oDlg:End() }
	Local _bCancel		:= {|x| _xRet := { .F.  , _cMemo } , _oDlg:End() }

	Local oGet			:= Nil

	Private _oDlg		:= Nil

	aAdd( _aObjAux , { 100 , 100 , .T. , .T. } )
	_aInfo   := { _aSize[ 1 ] , _aSize[ 2 ] , _aSize[ 3 ] , _aSize[ 4 ] , 3 , 2 }
	_aPosAux := MsObjSize( _aInfo , _aObjAux )

	_aCoors[03]	:= 380 // Linha
	_aCoors[04]	:= 550 // Coluna

	_aPosAux[01][03] := 380
	_aPosAux[01][04] := 550

	_oFont  := TFont():New('Verdana',,16,.F.)

	DEFINE MSDIALOG _oDlg TITLE _cTitAux FROM _aCoors[1],_aCoors[2] TO _aCoors[3],_aCoors[4] OF oMainWnd PIXEL

	TSay():New( _aPosAux[01][01] +05 , 10 , {|| 'Cliente: ' + SA1->A1_COD + " - " + Alltrim(SA1->A1_NOME)} , _oDlg ,,_oFont,,,, .T. ,,, 200 , 20 )
	
    TSay():New( _aPosAux[01][01] + 27  , 10 , {|| 'Data Ligação: '} , _oDlg ,,_oFont,,,, .T. ,,, 200 , 20 )
    oGet := TGet():New( _aPosAux[01][01] + 25, 65,,_oDlg,60,08,,,,,,.F.,,.T.,,.F.,,.F.,.F.,,.F.,.F. ,,"dLiga",,,,.T.)
	oGet:bSetGet := {| u | IIF( PCount() == 0, dLiga, dLiga := u ) }
	oGet:bValid	 := {| u | IIF( dLiga < Date(), .F. , .T. ) }
//dt prc ligacao
	TSay():New( _aPosAux[01][01] + 44  , 10 , {|| 'Proxima Ligação: '} , _oDlg ,,_oFont,,,, .T. ,,, 200 , 20 )
    oGet := TGet():New( _aPosAux[01][01] + 42, 65,,_oDlg,60,08,,,,,,.F.,,.T.,,.F.,,.F.,.F.,,.F.,.F. ,,"dPrlg",,,,.T.)
	oGet:bSetGet := {| u | IIF( PCount() == 0, dPrlg, dPrlg := u ) }
	oGet:bValid	 := {| u | IIF( dPrlg < Date(), .F. , .T. ) }

    TSay():New( _aPosAux[01][01] + 55  , 10 , {|| 'Observação: '} , _oDlg ,,_oFont,,,, .T. ,,, 200 , 20 )
    tMultiget():new(_aPosAux[01][01] + 65, 10, {| u | if( pCount() > 0, _cMemo := u, _cMemo ) },   _oDlg, 260, 80, , , , , , .T. )

	ACTIVATE MSDIALOG _oDlg ON INIT EnchoiceBar( _oDlg , _bOk , _bCancel ,,,,,,, .F. ) CENTERED

    If _xRet[1]
		If Empty(_cMemo) .Or. Empty(dLiga)
			MsgAlert("Favor preencher a observação do Titulo!")
			U_histcli()
		Else
			//RecLock("SA1",.F.)
			//	SA1->A1_XLIGA := dLiga
			//SA1->(MsUnlock())

			DbSelectArea("ZZK")
			RecLock("ZZK",.T.)
				ZZK->ZZK_FILIAL	 := SE1->E1_FILIAL
				ZZK->ZZK_CODIGO  := GETSXENUM('ZZK','ZZK_CODIGO')                                                                                                   
				ZZK->ZZK_CLIENT  := SE1->E1_CLIENTE
				ZZK->ZZK_LOJA    := SE1->E1_LOJA
				ZZK->ZZK_EMISSA	 := Date()
				ZZK->ZZK_DTNEW	 := dLiga
				ZZK->ZZK_TITULO	 := SE1->E1_NUM
				ZZK->ZZK_PARCEL	 := SE1->E1_PARCELA
				ZZK->ZZK_CODUSR	 := __cUserId
				ZZK->ZZK_NOMUSR	 := Alltrim(Upper(UsrRetName(__cUserId)))
				ZZK->ZZK_OBS	 := _cMemo
				ZZK->ZZK_DTLIG   := dPrlg
			ZZK->(MsUnlock())
			
			MsgInfo("Alteração Concluida com Sucesso!")
		EndIf
    EndIf

Return()
