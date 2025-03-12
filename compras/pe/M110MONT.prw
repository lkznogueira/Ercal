#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "TBICONN.CH"
#DEFINE CRLF CHR(13)+CHR(10)

/*
_____________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦Programa  ¦ M110MONT    ¦ Autor ¦ Totvs              ¦ Data ¦ 13/08/13 ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Descriçào ¦ Ponto de Entrada utilizado para colocar os campos padrões  ¦¦¦
¦¦¦          ¦ que são desabilitados para não aparecer na GRID. 		  ¦¦¦
¦¦¦          ¦                                                            ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Uso       ¦ Mineração Montividiu                                       ¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
*/

User Function M110MONT
Local _aArea	:= GetArea()
Local _aAreaSX3	:= SX3->(GetArea())
Local _aAreaSC1	:= SC1->(GetArea())
Local _cNumSC	:= ParamIXB[1]
Local _nOPc		:= ParamIXB[2]
Local _lCopia	:= ParamIXB[3]
Local _nX

Public _aSCAtual	:= {} //Array com a Inicialização da Solicitação de Compra
Public _aSCNova		:= {} //Array com a Alteração da Solicitação de Compra

_aBkpAHeader:= aClone(aHeader)
_aBkpACols	:= aClone(aCols)

aHeader		:= {}
aCols		:= {}
_cCampos	:= "{ "

DbSelectArea("SX3")
DbSetOrder(2)
SX3->(DbGoTop())
For _nX := 1 To Len(_aBkpAHeader)
	SX3->(DbGoTop())
	If SX3->(DbSeek(AllTrim(_aBkpAHeader[_nX,2]))) .And. !( UPPER(AllTrim(_aBkpAHeader[_nX,2])) == "C1_XNATURE" .OR. UPPER(AllTrim(_aBkpAHeader[_nX,2])) == "C1_XDESNAT" .OR. UPPER(AllTrim(_aBkpAHeader[_nX,2])) == "C1_XCDESC" )
		
		aADD(aHeader, {AllTrim(SX3->X3_TITULO), SX3->X3_CAMPO, SX3->X3_PICTURE, SX3->X3_TAMANHO, SX3->X3_DECIMAL, SX3->X3_VALID, SX3->X3_USADO, SX3->X3_TIPO, SX3->X3_F3, SX3->X3_CONTEXT, SX3->X3_CBOX, SX3->X3_RELACAO } )
		If _nOPc == 1 .And. !_lCopia
			_cCampos += "CriaVar('"+AllTrim(SX3->X3_CAMPO)+"', .T.), "
		Else
			If SX3->X3_CONTEXT != "V"
				_cCampos += "SC1->"+AllTrim(SX3->X3_CAMPO)+", "
			Else
				_cCampos += "CriaVar('"+AllTrim(SX3->X3_CAMPO)+"', .T.), "
			EndIF
		EndIF
	EndIf
Next _nX

_nPRec := aScan(_aBkpAHeader, {|X| UPPER(AllTrim(X[2])) == "C1_ALI_WT"} )
aADD(aHeader, {_aBkpAHeader[_nPRec, 01], _aBkpAHeader[_nPRec, 02], _aBkpAHeader[_nPRec, 03], _aBkpAHeader[_nPRec, 04], _aBkpAHeader[_nPRec, 05], _aBkpAHeader[_nPRec, 06], _aBkpAHeader[_nPRec, 07], _aBkpAHeader[_nPRec, 08], _aBkpAHeader[_nPRec, 09], _aBkpAHeader[_nPRec, 10], IIF(Len(_aBkpAHeader[_nPRec]) >= 11, _aBkpAHeader[_nPRec, 11], " "), IIF(Len(_aBkpAHeader[_nPRec]) >= 12, _aBkpAHeader[_nPRec, 12], " ") } )

_nPRec := aScan(_aBkpAHeader, {|X| UPPER(AllTrim(X[2])) == "C1_REC_WT"} )
aADD(aHeader, {_aBkpAHeader[_nPRec, 01], _aBkpAHeader[_nPRec, 02], _aBkpAHeader[_nPRec, 03], _aBkpAHeader[_nPRec, 04], _aBkpAHeader[_nPRec, 05], _aBkpAHeader[_nPRec, 06], _aBkpAHeader[_nPRec, 07], _aBkpAHeader[_nPRec, 08], _aBkpAHeader[_nPRec, 09], _aBkpAHeader[_nPRec, 10], IIF(Len(_aBkpAHeader[_nPRec]) >= 11, _aBkpAHeader[_nPRec, 11], " "), IIF(Len(_aBkpAHeader[_nPRec]) >= 12, _aBkpAHeader[_nPRec, 12], " ") } )

If _nOPc == 1 .And. !_lCopia
	_cCampos += " 'SC1', 0, .F. }"
Else
	If _lCopia
		_cCampos += "'SC1', 0, .F. }"
	Else
		_cCampos += "'SC1', SC1->(RECNO()), .F. }"
	EndIF
EndIf

If _nOPc == 1 //.Or. _aParam[3]
	If _lCopia
		DbSelectArea("SC1")
		DbSetOrder(1)
		SC1->(DbGoTop())
		If SC1->(DbSeek(xFilial("SC1")+_cNumSC))
			While SC1->(!EOF()) .And. SC1->(C1_FILIAL+C1_NUM) == xFilial("SC1")+_cNumSC
				&( "aADD( aCols, "+_cCampos+" )" )
				A110After(_lCopia, aCols)
				SC1->(DbSkip())
			EndDo
		EndIf
	Else
		&( "aADD( aCols, "+_cCampos+" )" )
		aCols[1][aScan(aHeader,{|x| Trim(x[2])=="C1_ITEM"})] := StrZero(1,Len(SC1->C1_ITEM))
	EndIF
//	
Else
	DbSelectArea("SC1")
	DbSetOrder(1)
	SC1->(DbGoTop())
	If SC1->(DbSeek(xFilial("SC1")+_cNumSC))
		While SC1->(!EOF()) .And. SC1->(C1_FILIAL+C1_NUM) == xFilial("SC1")+_cNumSC
			&( "aADD( aCols, "+_cCampos+" )" )
			SC1->(DbSkip())
		EndDo
	EndIf
EndIf

RestArea(_aAreaSC1)
RestArea(_aAreaSX3)
RestArea(_aArea)
Return