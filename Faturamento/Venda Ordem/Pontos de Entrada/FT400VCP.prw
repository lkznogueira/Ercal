#include "protheus.ch"

/*/-------------------------------------------------------------------
- Programa: FT400VCP
- Autor: Claudio Ferreira
- Data: 10/04/2020
- Descrição: Ponto de entrada na abertura da tela do contrato.
-------------------------------------------------------------------/*/

User Function FT400VCP()

	Local aArea := FWGetArea()
	
	if ExistBlock("UFATE004")
		U_UFATE004()
	endif

	FWRestArea(aArea)

Return(Nil)
