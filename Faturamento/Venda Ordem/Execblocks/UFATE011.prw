#Include "Protheus.ch"

/*/-------------------------------------------------------------------
-�Programa: UFATE011
-�Autor:�Tarcisio Silva Miranda
-�Data: 15/09/2022
-�Descri��o:�Valida��o de campos da SC6.
iif(ExistBlock("UFATE011"),U_UFATE011(),.T.), acionado atav�s dos campos
C6_PRODUTO, C6_QTDVEN.
-------------------------------------------------------------------/*/

User Function UFATE011()

	Local lReturn := .T.

	if IsInCallStack('FATA400') .AND. !empty(M->C5_XPEDORD)
        lReturn := .F.
        MsgAlert("N�o � poss�vel efetuar altera��o na replica do pedido de contrato!", "Aten��o!")
	endif

Return(lReturn)
