#include "protheus.ch"
#include "topconn.ch"

/*/-------------------------------------------------------------------
-�Programa: UFATE006
-�Autor:�Wellington�Gon�alves
-�Data:�24/09/2019
-�Descri��o:�Acionado pelo ponto de entrada M410PVNF , valida o 
faturamento do pedido de vendas, trava o faturamento caso a pedido
de vendas de remessa do destinat�rio seja transmitido antes da remessa 
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
	-�Programa: ValidCtr
	-�Autor:�Wellington�Gon�alves
	-�Data:�27/03/2020
	-�Descri��o:�Fun��o que valida se o pedido pode ser faturado
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
				MsgInfo("� necess�rio faturar o Pedido " + AllTrim(cNumPedOrd) + " antes de faturar o Pedido de Remessa","Aten��o!")
			endif
		else
			lRet := .F.
			MsgInfo("O Pedido " + AllTrim(cNumPedOrd) + " foi exclu�do, esta remessa n�o poder� ser faturada!","Aten��o!")
		endif

	endif

	FWRestArea(aAreaSC5)

Return(lRet)
