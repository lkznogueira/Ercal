#include "Protheus.ch"

/*/-------------------------------------------------------------------
- Programa: FT400LIB
- Autor: Wellington Gonçalves
- Data: 25/03/2020
- Descrição: Ponto de Entrada localizado após a geração do Pedido
de Venda.
-------------------------------------------------------------------/*/

User Function FT400LIB()

	Local aArea := FWGetArea()

	if ExistBlock("UFATE002")
		U_UFATE002()
	endif

	FWRestArea(aArea)

Return(Nil)
