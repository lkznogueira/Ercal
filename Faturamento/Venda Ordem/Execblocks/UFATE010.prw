#Include "Protheus.ch"
#Include "Totvs.ch"

/*/-----------------------------------------------------------------------------
Programa: UFATE010
Autor: Tarcisio Silva Miranda
Data: 15/09/2022
Descri��o: Valida se n�o foi deletado ou incluso nenhum linha no pedido de copia
do contrato de parceria, acionado atrav�s dos fontes MT410TOK/UFATE008.
-----------------------------------------------------------------------------/*/

User Function UFATE010()

	Local lReturn   := .T.
    
    //So entra na valida��o se for o outro pedido.
	if !empty(M->C5_XPEDORD)
		lReturn := fVldPV()
	endif

Return(lReturn)

/*/-----------------------------------------------------------------------------
Programa: fVldPV
Autor: Tarcisio Silva Miranda
Data: 15/09/2022
Descri��o: Valida se n�o foi deletado ou incluso nenhum linha no pedido de copia
do contrato de parceria.
-----------------------------------------------------------------------------/*/

Static Function fVldPV()

	Local lReturn    := .T.
	Local nX         := 1
	Local cQuery     := ""
	Local cAliasQry  := ""
	Local nUsado     := len(aHeader)+1
	Local nQtdPedNew := 0
    Local nQtdPedOld := 0

    //Conta quantos itens tem no pedido novo.
	for nX := 1 to len(aCols)
		if !aCols[nX][nUsado]
			nQtdPedNew ++
		endif
	next nX
    
    //Conta os itens do pedido original gravado..
	cQuery := " SELECT "                                    + CRLF
	cQuery += "     COUNT(*) AS QTDLINHA "                  + CRLF
	cQuery += " FROM " + RetSqlName("SC6") + " SC6 "        + CRLF
	cQuery += " WHERE SC6.D_E_L_E_T_ = ' '  "               + CRLF
	cQuery += " AND C6_NUM      = '"+M->C5_XPEDORD+"'  "    + CRLF
	cQuery += " AND C6_FILIAL   = '"+FWxFilial("SC6")+"'  " + CRLF

	cAliasQry := MPSysOpenQuery(cQuery)
    
    //Verifica se retornou dados na consulta, e se a quantidade � maior que zero.
	if !(cAliasQry)->(Eof()) .AND. (cAliasQry)->QTDLINHA > 0
		nQtdPedOld := (cAliasQry)->QTDLINHA
	endif

    //Fecha a alias aberta.
	if Select(cAliasQry) > 0 .AND. !Empty(cAliasQry)
		(cAliasQry)->(DbCloseArea())
	endif
    //Se n�o forem quantidades iguais, vai travar o pedido.
    if nQtdPedNew != nQtdPedOld
        MsgAlert("Os itens n�o est�o iguais, verifique o pedido!","Aten��o!")
        lReturn := .F.
    endif

Return(lReturn)
