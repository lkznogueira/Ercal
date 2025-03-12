#Include "Protheus.ch"

/*/-------------------------------------------------------------------
- Programa: UFATE011
- Autor: Tarcisio Silva Miranda
- Data: 15/09/2022
- Descrição: Validação de campos da SC6.
iif(ExistBlock("UFATE011"),U_UFATE011(),.T.), acionado atavés dos campos
C6_PRODUTO, C6_QTDVEN.
-------------------------------------------------------------------/*/

User Function UFATE011()

	Local lReturn := .T.

	if IsInCallStack('FATA400') .AND. !empty(M->C5_XPEDORD)
        lReturn := .F.
        MsgAlert("Não é possível efetuar alteração na replica do pedido de contrato!", "Atenção!")
	endif

Return(lReturn)
