#INCLUDE "PROTHEUS.CH"
/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³          ³ Autor ³ Carlos Daniel         ³ Data ³09/03/2024³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Locacao   ³ Ercal            ³Contato ³                                 ±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
//PONTO DE ENTRADA QUE ENVIA DADOS PARA GRAVACAO
User Function F460SE1()
    local aRet := {}
	Local _aCoors 		:= FWGetDialogSize(oMainWnd)
	Local _aSize     	:= MsAdvSize( .T. )
	Local _aObjAux		:= {}
	Local _aPosAux		:= {}
	Local _aInfo		:= {}
	Local _cTitAux		:= "Tela Negociacao"
    Local _cMemo        := Space(250) //define tipo campo e tamanho
	//Local dLiga			:= cTod("//")
	//Local dPrlg			:= cTod("//")
	Local _xRet			:= { .F. , "" }
	Local _bOk			:= {|x| _xRet := { .T.  , _cMemo } , _oDlg:End() }
	Local _bCancel		:= {|x| _xRet := { .F.  , _cMemo } , _oDlg:End() }
    Local lContinua     := .F.
	Local oGet			:= Nil

	Private _oDlg		:= Nil
	
	//VERIFICA SE TITULO TEM NEGOCIACAO
    If !FwIsIncallStack("U_MFAT300") .And. MsgYesNo('Titulo referente Negociação?')  //pergunta se deseja deletar
		lContinua := .T.
	Else 
		aRet := {{"E1_XNEG","2"},;
                 {"E1_XINFO"," "}}
		Return aRet                      
	EndIF

If lContinua
	aAdd( _aObjAux , { 100 , 100 , .T. , .T. } )
	_aInfo   := { _aSize[ 1 ] , _aSize[ 2 ] , _aSize[ 3 ] , _aSize[ 4 ] , 3 , 2 }
	_aPosAux := MsObjSize( _aInfo , _aObjAux )

	_aCoors[03]	:= 180 // Linha
	_aCoors[04]	:= 550 // Coluna

	_aPosAux[01][03] := 180
	_aPosAux[01][04] := 550

	_oFont  := TFont():New('Verdana',,16,.F.)

	DEFINE MSDIALOG _oDlg TITLE _cTitAux FROM _aCoors[1],_aCoors[2] TO _aCoors[3],_aCoors[4] OF oMainWnd PIXEL

	TSay():New( _aPosAux[01][01] +05 , 10 , {|| 'Liquidação: ' + M->FO0_NUMLIQ} , _oDlg ,,_oFont,,,, .T. ,,, 200 , 20 )
    TSay():New( _aPosAux[01][01] + 20  , 10 , {|| 'Observação: '} , _oDlg ,,_oFont,,,, .T. ,,, 200 , 20 )
    //oGet := TGet():New( _aPosAux[01][01] + 35, 10,,_oDlg,255,08,,,,,,.F.,,.T.,,.F.,,.F.,.F.,,.F.,.F. ,,,,,,.T.)
	oGet := TGet():New( _aPosAux[01][01] + 35,010,{ | u | If( PCount() == 0, _cMemo, _cMemo := u ) },_oDlg,250,009,"@!",,0,,,.F.,,.T.,,.F.,,.F.,.F.,,.F.,.F.,,/*24*/,,,,,,,,,,,/*cPlaceHold*/)
	oGet:cPlaceHold	 := 'Informe dados da Negociação'

    ACTIVATE MSDIALOG _oDlg ON INIT EnchoiceBar( _oDlg , _bOk , _bCancel ,,,,,,, .F. ) CENTERED
	If _xRet[1]	
    	aRet := {{"E1_XNEG","1"},;
             	{"E1_XINFO",_cMemo}}
	Else
    	aRet := {{"E1_XNEG","2"},;
             	{"E1_XINFO"," "}}		
    EndIf
EndIf

Return aRet

//PONTO ENTRADA QUE RECEBE OS DADOS E GRAVA

User Function F460VAL()
    local aCompl := aClone(PARAMIXB) 
    //local nX := 1

    Reclock("SE1",.f.)
			SE1->E1_XINFO  := aCompl[2][2]
			SE1->E1_XNEG  := aCompl[1][2]
			SE1->(MsUnlock())
			SE1->(dbSkip())
    
Return nil

