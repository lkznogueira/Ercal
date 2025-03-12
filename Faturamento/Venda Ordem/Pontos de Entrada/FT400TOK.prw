#include "protheus.ch"
#include "topconn.ch"

/*/-------------------------------------------------------------------
-�Programa: FT400TOK
-�Autor:�Wellington�Gon�alves
-�Data:�25/03/2020
-�Descri��o:�Ponto de Entrada localizado na valida��o do contrato
de parceria.
-------------------------------------------------------------------/*/

User Function FT400TOK()

	Local aArea  := FWGetArea()
	Local lRet   := .T.

	if ExistBlock("UFATE003")
		lRet := U_UFATE003()
	endif

	FWRestArea(aArea)

Return(lRet)
