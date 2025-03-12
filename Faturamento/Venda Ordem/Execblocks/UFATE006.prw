#include "protheus.ch"
#include "topconn.ch"

/*/-------------------------------------------------------------------
- Programa: UFATE006
- Autor: Wellington Gonçalves
- Data: 24/09/2019
- Descrição: Acionado pelo ponto de entrada M410PVNF , valida o 
faturamento do pedido de vendas, trava o faturamento caso a pedido
de vendas de remessa do destinatário seja transmitido antes da remessa 
do contrato do cleinte.
-------------------------------------------------------------------/*/

User Function UFATE006()

	Local aArea  := FWGetArea()
	Local lRet   := .T.

	if !empty(SC5->C5_XPEDORD)
		lRet := ValidCtr(SC5->C5_XPEDORD)
	endif

	FWRestArea(aArea)

Return(lRet)

/*/-------------------------------------------------------------------
	- Programa: ValidCtr
	- Autor: Wellington Gonçalves
	- Data: 27/03/2020
	- Descrição: Função que valida se o pedido pode ser faturado
-------------------------------------------------------------------/*/

Static Function ValidCtr(cNumPedOrd)

	Local aAreaSC5	    := SC5->(FWGetArea())
	Local lRet 			:= .T.
	Default cNumPedOrd  := ""

	// se for contrato de conta e ordem
	if !Empty(cNumPedOrd)
		SC5->(DbSetOrder(1)) // C5_FILIAL + C5_NUM
		if SC5->(DbSeek(xFilial("SC5") + cNumPedOrd))
			if Empty(SC5->C5_NOTA)
				lRet := .F.
				MsgInfo("É necessário faturar o Pedido " + AllTrim(cNumPedOrd) + " antes de faturar o Pedido de Remessa","Atenção!")
			endif
		else
			lRet := .F.
			MsgInfo("O Pedido " + AllTrim(cNumPedOrd) + " foi excluído, esta remessa não poderá ser faturada!","Atenção!")
		endif

	endif

	FWRestArea(aAreaSC5)

Return(lRet)
