#include "rwmake.ch"
#include"protheus.ch"
/*
_____________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦Programa  ¦ ercfrete   ¦ Autor ¦ Carlos Daniel       ¦ Data ¦ 26/10/21 ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Descriçào ¦ Ponto de Entrada p/tratar calculo frete sobre tipo vend. 70¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦ Uso      ¦ Uso Para Ercal empresas Reunidas Calcario                  ¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
*/


User Function ercfrete()

	Local cTipo  := M->c5_XTIPO
	Local nFrete := M->c5_xdesp
	Local nQuant := M->c6_qtdven
	Local vFreUn := M->c5_xdespu
	Local vFrete


	if ctipo = '70' .and. nfrete <> 0 // verifica se for tipo 70 e tiver despesa de frete

		vFrete := (nQuant*vFreUn)
		M->C5_XDESP := vFrete
		alert("VALOR DESPESA TRANSPORTE ALTERADO")
	ELSE
		return()
	endif
	oGetPV:refresh()

return .T.
