#include "Protheus.ch"

/*/-------------------------------------------------------------------
-�Programa: FT400LIB
-�Autor:�Wellington�Gon�alves
-�Data:�25/03/2020
-�Descri��o:�Ponto de Entrada localizado ap�s a gera��o do Pedido
de Venda.
-------------------------------------------------------------------/*/

User Function FT400LIB()

	Local aArea := FWGetArea()

	if ExistBlock("UFATE002")
		U_UFATE002()
	endif

	FWRestArea(aArea)

Return(Nil)
