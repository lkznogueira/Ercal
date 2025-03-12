#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'TOTVS.CH'

/*/{Protheus.doc} MFAT100
// Possibilita a Alteração do Vencimento do Contrato de Parceria
@author Lucas Nogueira
/*/
User Function MFAT100()

	Local _aCoors 		:= FWGetDialogSize(oMainWnd)
	Local _aSize     	:= MsAdvSize( .T. )
	Local _aObjAux		:= {}
	Local _aPosAux		:= {}
	Local _aInfo		:= {}

	Local _cTitAux		:= "Alteração Vencimento - Contrato de Parceria"
    Local _cMemo        := ""

	Local dVEncto		:= cTod("//")

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

	TSay():New( _aPosAux[01][01] +05 , 10 , {|| 'Contrato: ' + ADA->ADA_NUMCTR + " - " + Alltrim(ADA->ADA_XNOMC)} , _oDlg ,,_oFont,,,, .T. ,,, 200 , 20 )
	
    TSay():New( _aPosAux[01][01] + 27  , 10 , {|| 'Nova Validade: '} , _oDlg ,,_oFont,,,, .T. ,,, 200 , 20 )
    oGet := TGet():New( _aPosAux[01][01] + 25, 65,,_oDlg,60,08,,,,,,.F.,,.T.,,.F.,,.F.,.F.,,.F.,.F. ,,"dVEncto",,,,.T.)
	oGet:bSetGet := {| u | IIF( PCount() == 0, dVEncto, dVEncto := u ) }
	oGet:bValid	 := {| u | IIF( dVEncto < Date(), .F. , .T. ) }

    TSay():New( _aPosAux[01][01] + 55  , 10 , {|| 'Justificativa: '} , _oDlg ,,_oFont,,,, .T. ,,, 200 , 20 )
    tMultiget():new(_aPosAux[01][01] + 65, 10, {| u | if( pCount() > 0, _cMemo := u, _cMemo ) },   _oDlg, 260, 80, , , , , , .T. )

	ACTIVATE MSDIALOG _oDlg ON INIT EnchoiceBar( _oDlg , _bOk , _bCancel ,,,,,,, .F. ) CENTERED

    If _xRet[1]
		If Empty(_cMemo) .Or. Empty(dVEncto)
			MsgAlert("Campos (Justificativa e/ou Vencimento) sem preenchimento!")
			U_MFAT100()
		Else
			RecLock("ADA",.F.)
				ADA->ADA_XVENC := dVEncto
			ADA->(MsUnlock())

			DbSelectArea("ZZY")
			RecLock("ZZY",.T.)
				ZZY->ZZY_FILIAL	:= ADA->ADA_FILIAL
				ZZY->ZZY_NUMCTR	:= ADA->ADA_NUMCTR
				ZZY->ZZY_EMISSA	:= Date()
				ZZY->ZZY_DTOLD	:= ADA->ADA_XVENC
				ZZY->ZZY_DTNEW	:= dVEncto
				ZZY->ZZY_HORA	:= Time()
				ZZY->ZZY_CODUSR	:= __cUserId
				ZZY->ZZY_NOMUSR	:= Alltrim(Upper(UsrRetName(__cUserId)))
				ZZY->ZZY_JUSTIF	:= _cMemo
			ZZY->(MsUnlock())
			
			MsgInfo("Alteração Concluida com Sucesso!")
		EndIf
    EndIf

Return()
