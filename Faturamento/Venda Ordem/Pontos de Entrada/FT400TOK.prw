#include "protheus.ch"
#include "topconn.ch"

/*/-------------------------------------------------------------------
- Programa: FT400TOK
- Autor: Wellington Gonçalves
- Data: 25/03/2020
- Descrição: Ponto de Entrada localizado na validação do contrato
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
