#INCLUDE "PROTHEUS.CH"


User Function RCOMM039
 

Local _cTipo := ' '
Local _cRetorno := .T.

msgAlert('passei aqui P.E: RCOMM039')

_cTipo := POSICIONE('SED',1,xFilial('SED')+M->C1_XNATURE,'ED_TIPO')


If _cTipo <> 2
	MsgStop('Natureza financeira sint�tica, s� ser�o permitidas as analiticas')
	Return _cRetorno 
EndIf 
 

Return _cRetorno