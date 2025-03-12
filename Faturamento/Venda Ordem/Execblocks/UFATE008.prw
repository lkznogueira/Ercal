#include "protheus.ch"
#include "topconn.ch"

/*/-------------------------------------------------------------------
- Programa: UFATE008
- Autor: Maiki Perin
- Data: 22/10/2019
- Descrição: Executado apos a confirmação do pedido de vendas de
remessa ao cliente do contrato, acionado através do PE MT410TOK.
-------------------------------------------------------------------/*/

User Function UFATE008()

	Local lRet          := .T.
	Local aArea         := GetArea()
	Local aAreaSC6      := SC6->(GetArea())
	Local nOpc          := PARAMIXB[1]	// Opção de manutenção

	if nOpc == 3 .AND. IsInCallStack('FATA400') .AND. !empty(M->C5_XPEDORD)
		lRet := U_UFATE010()
	elseif nOpc == 1 // exclusão

		// função que valida contrato de conta e ordem
		if ValidCtr(SC5->C5_NUM)  //Alterado por claudio  Não deixa excluir se o SC5->C5_XPEDORD estivesse vazio
			if !Empty(SC5->C5_XPEDORD) //Para PV com PEDORD deve limpar o contrato antes de excluir
				SC6->(DbSetOrder(1)) // C6_FILIAL + C6_NUM
				if SC6->(DbSeek(xFilial("SC6") + SC5->C5_NUM))
					While SC6->(!Eof()) .AND. SC6->C6_NUM == SC5->C5_NUM
						if RecLock("SC6",.F.)
							SC6->C6_CONTRAT := ""  // Limpa para não mexer nos saldos
							SC6->C6_ITEMCON := ""  // Limpa para não mexer nos saldos
							SC6->(MsUnLock())
							SC6->(DbSkip())
						endif
						SC6->(DbSkip())
					EndDo
				endif
			endif
		else
			lRet := .F.
		endif
	endif

	RestArea(aAreaSC6)
	RestArea(aArea)

Return(lRet)

/*/-------------------------------------------------------------------
	- Programa: ValidCtr
	- Autor: Wellington Gonçalves
	- Data: 27/03/2020
	- Descrição: Função que valida se o pedido pode ser excluido
-------------------------------------------------------------------/*/

Static Function ValidCtr(cNumPedOrd)

	Local lReturn 	:= .T.
	Local cQuery    := ""
	Local cAliasQry := ""

	cQuery := " SELECT " 									+ CRLF
	cQuery += " 	  C5_XPEDORD AS PEDORD " 				+ CRLF
	cQuery += " 	, C5_NUM 	 AS PEDIDO " 				+ CRLF
	cQuery += " FROM " + RetSqlName("SC5") + " SC5 " 		+ CRLF
	cQuery += " WHERE SC5.D_E_L_E_T_ = '  ' " 				+ CRLF
	cQuery += " AND C5_XPEDORD 	= '"+cNumPedOrd+"' " 		+ CRLF
	cQuery += " AND C5_FILIAL 	= '"+FWxFilial("SC5")+"' " 	+ CRLF

	cAliasQry := MPSysOpenQuery(cQuery)

	if !(cAliasQry)->(Eof())
		lReturn := .F.
		MsgInfo("Atenção, o Pedido " + AllTrim((cAliasQry)->PEDIDO) + " precisa ser excluído primeiramente!")
	endif

	if Select(cAliasQry) > 0 .AND. !Empty(cAliasQry)
		(cAliasQry)->(DbCloseArea())
	endif

Return(lReturn)
