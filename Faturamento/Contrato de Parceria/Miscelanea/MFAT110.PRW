#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'TOTVS.CH'

/*/{Protheus.doc} MFAT110
// Altera data entrega
@author Carlos Daniel
/*/
User Function MFAT110()

	Local _aCoors 		:= FWGetDialogSize(oMainWnd)
	Local _aSize     	:= MsAdvSize( .T. )
	Local _aObjAux		:= {}
	Local _aPosAux		:= {}
	Local _aInfo		:= {}
	Local _cTitAux		:= "Ajusta data Entrega - Contrato de Parceria"
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

	_aCoors[03]	:= 230 // Linha
	_aCoors[04]	:= 550 // Coluna

	_aPosAux[01][03] := 230
	_aPosAux[01][04] := 550

	_oFont  := TFont():New('Verdana',,16,.F.)

	DEFINE MSDIALOG _oDlg TITLE _cTitAux FROM _aCoors[1],_aCoors[2] TO _aCoors[3],_aCoors[4] OF oMainWnd PIXEL

	TSay():New( _aPosAux[01][01] +05 , 10 , {|| 'Contrato: ' + ADA->ADA_NUMCTR + " - " + Alltrim(ADA->ADA_XNOMC)} , _oDlg ,,_oFont,,,, .T. ,,, 200 , 20 )
	
    TSay():New( _aPosAux[01][01] + 27  , 10 , {|| 'Nova Data: '} , _oDlg ,,_oFont,,,, .T. ,,, 200 , 20 )
    oGet := TGet():New( _aPosAux[01][01] + 25, 65,,_oDlg,60,08,,,,,,.F.,,.T.,,.F.,,.F.,.F.,,.F.,.F. ,,"dVEncto",,,,.T.)
	oGet:bSetGet := {| u | IIF( PCount() == 0, dVEncto, dVEncto := u ) }
	oGet:bValid	 := {| u | IIF( dVEncto < Date(), .F. , .T. ) }

    //TSay():New( _aPosAux[01][01] + 55  , 10 , {|| 'Justificativa: '} , _oDlg ,,_oFont,,,, .T. ,,, 200 , 20 )
    //tMultiget():new(_aPosAux[01][01] + 65, 10, {| u | if( pCount() > 0, _cMemo := u, _cMemo ) },   _oDlg, 260, 80, , , , , , .T. )

	ACTIVATE MSDIALOG _oDlg ON INIT EnchoiceBar( _oDlg , _bOk , _bCancel ,,,,,,, .F. ) CENTERED

    If _xRet[1]
		//If Empty(_cMemo) .Or. Empty(dVEncto)
		//	MsgAlert("Campos (Justificativa e/ou Vencimento) sem preenchimento!")
		//	U_MFAT110()
		//Else	
        	RecLock("ADA",.F.)
			ADA->ADA_XVCTO := dVEncto
			ADA->(MsUnlock())		
			//MsgInfo("Alteração Concluida com Sucesso!")
		//EndIf
    EndIf

Return()

User Function MFAT111()
//User Function MNT420AD()
//Local cStatus := M->ADA_STATUS
Private dVEncto		:= dDataBase//cTod("//")


//IF cStatus = "A" 
    oFont1 := TFont():New("Arial",,18,,.t.,,,,,.f.)
	
	oDlg := MsDialog():New(0,0,100,200,"Altera Data Carregamento",,,,,CLR_BLACK,CLR_WHITE,,,.T.)

	oSay1 := TSay():New(10,10,{||"DT Atual:"},oDlg,,,,,,.T.,,)
	oSay2 := TSay():New(10,50,{||M->ADA_XVCTO},oDlg,,oFont1,,,,.T.,,)

	oSay3 := TSay():New(22,10,{||"Nova Data:"},oDlg,,,,,,.T.,CLR_HBLUE,)
	oGet1 := tGet():New(20,50,{|u| if(PCount() == 0, dVEncto, dVEncto := u)},oDlg,40,8,"@!",{||.T.},;
		,,,,,.T.,,,{|| .T.},,,,,,,"dDtOrigi")
       
    oBtn1 := tButton():New(34,50,"Ok",oDlg,{||fGrvData()},40,10,,,,.T.)
	
	oDlg:Activate(,,,.T.,{||.T.},,{||})
	//oDlg:End()
//EndIf
Return
Static Function fGrvData()

	//If AllTrim(UPPER(cUserName))$"Administrador"
		M->ADA_XVCTO := dVEncto
		//MsgInfo("Alteração Concluida com Sucesso!")
	//Else
		//Alert("Data Carregamento Alterada com Sucesso!")
    //EndIf
	oDlg:End()
Return
