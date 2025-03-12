#include "protheus.ch"

/*/-------------------------------------------------------------------
- Programa: UFATE004
- Autor: Claudio Ferreira
- Data: 10/04/2020
- Descrição: Limpa os campos customizados na copia do contrato,
acionado pelo PE FT400VCP.
-------------------------------------------------------------------/*/

/***********************/
User Function UFATE004()
/***********************/

	Local nOpcX := ParamixB[1]

	if nOpcX == 6
		// Caso seja copia
		M->ADA_XCLIOR := Space(TamSx3("ADA_XCLIOR")[1])
		M->ADA_XLOJOR := Space(TamSx3("ADA_XLOJOR")[1])
		M->ADA_XORDEM := "2"
		M->ADA_XNFORI := Space(TamSx3("ADA_XNFORI")[1])
		M->ADA_XSEORI := Space(TamSx3("ADA_XSEORI")[1])
		M->ADA_XCHORI := Space(TamSx3("ADA_XCHORI")[1])
		M->ADA_XEMORI := Space(TamSx3("ADA_XEMORI")[1])

	endif

Return(Nil)
