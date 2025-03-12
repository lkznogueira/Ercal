#Include "Protheus.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RMNTA021  ºAutor  ³Wellington Gonçalvesº Data ³  07/01/2013 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Retorna proximo codigo do bem				              º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Montvidiu			                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function RMNTA021()

Local _cLocal	:= GetArea()
Local _nProx	:= ''
Local _cGrup	:= M->T9_XGRUPO 

cQry := " SELECT MAX(CAST(SUBSTR(ST9.T9_CODBEM, 5, 6) AS FLOAT)) PROX "
cQry += " FROM "+RetSqlName("ST9")+" ST9 "
//cQry += " WHERE ST9.D_E_L_E_T_<>'*' "
cQry += " WHERE ST9.D_E_L_E_T_<>'*' AND SUBSTR(ST9.T9_CODBEM, 0, 4) = '" + SUBSTR(_cGrup, 0, 4) + "'"

If Select("QAUX") > 0
	QAUX->(DbCloseArea())
EndIf

cQry := ChangeQuery(cQry)

dbUseArea(.T., "TOPCONN", TCGenQry(,,cQry), "QAUX", .F., .T.)

IF Empty(QAUX->PROX)
	_nProx:=STRZERO(1, 6)
ELSE
	
	_nProx:=STRZERO(QAUX->PROX+1, 6)
	_nAux := VAL(_nProx)
	
	FreeUsedCode()
	While !MayIUseCode("ST9"+xFilial("ST9")+STRZERO(_nAux, 6))
		_nAux+=1
	EndDo
	
	_nProx:=STRZERO(_nAux, 6)
	
ENDIF
QAUX->(DbCloseArea())

RestArea(_cLocal)

RETURN (_cGrup + _nProx)