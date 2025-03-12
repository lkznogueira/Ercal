#include "protheus.ch"
#include "topconn.ch"

/*/-------------------------------------------------------------------
- Programa: UFATE007
- Autor: Wellington Gonçalves
- Data: 24/09/2019
- Descrição: Acionado pelo ponto de entrada M460MARK , valida o 
faturamento do pedido de vendas, trava o faturamento caso a pedido
de vendas de remessa do destinatário seja transmitido antes da remessa 
do contrato do cleinte.
-------------------------------------------------------------------/*/

User Function UFATE007()

	Local aArea     := GetArea()
	Local aAreaSC5  := SC5->(GetArea())
	Local lRet      := .T.

	// posiciono no pedido de venda
	SC5->(DbSetOrder(1)) // C5_FILIAL + C5_NUM
	if SC5->(DbSeek(SC9->C9_FILIAL + SC9->C9_PEDIDO))
		// função que valida contrato de conta e ordem
		lRet := ValidCtr(SC5->C5_XPEDORD)
	endif

	RestArea(aAreaSC5)
	RestArea(aArea)

Return(lRet)

/*/-------------------------------------------------------------------
	- Programa: ValidCtr
	- Autor: Wellington Gonçalves
	- Data: 27/03/2020
	- Descrição: Função que valida se o pedido pode ser faturado
-------------------------------------------------------------------/*/

Static Function ValidCtr(cNumPedOrd)

	Local aArea         := GetArea()
	Local aAreaSC5	    := SC5->(GetArea())
	Local lRet 			:= .T.
	Default cNumPedOrd  := ""

	// se for contrato de conta e ordem
	if !Empty(cNumPedOrd)
		SC5->(DbSetOrder(1)) // C5_FILIAL + C5_NUM
		if SC5->(DbSeek(xFilial("SC5") + cNumPedOrd))
			// se o pedido não tiver sido faturado
			if Empty(SC5->C5_NOTA)
				lRet := .F.
				MsgInfo("Atenção, É necessário faturar o Pedido " + AllTrim(cNumPedOrd) + " antes de faturar o Pedido de Remessa")
			endif
		else
			lRet := .F.
			MsgInfo("Atenção, O Pedido " + AllTrim(cNumPedOrd) + " foi excluído, esta remessa não poderá ser faturada!")
		endif

	endif

	RestArea(aAreaSC5)
	RestArea(aArea)

Return(lRet)
