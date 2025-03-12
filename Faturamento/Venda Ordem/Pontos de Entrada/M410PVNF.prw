#INCLUDE "topconn.ch"
#INCLUDE "Protheus.ch"
#INCLUDE "TbiConn.ch"
#INCLUDE "rwmake.ch"

/*/-------------------------------------------------------------------
-�Programa: M410PVNF
-�Autor:�Wellington�Gon�alves
-�Data:�24/09/2019
-�Descri��o:�Valida��o na chamada do Prep Doc Sa�da no A��es
Relacionadas do Pedido de Venda.
-------------------------------------------------------------------/*/

User function M410PVNF()

	Local aArea  := FWGetArea()
	Local cFilPed := SC5->C5_FILIAL
	Local nNumPed := SC5->C5_NUM
	Local cQry    := ""
	Local cQrySC9 := ""
	Local cText   := ""
	Local nTotal  := 0
	Local aArray  := {}
	Local nI      := 0
	Local lRet    := .T.

	//O programa UFATE006 valida o faturamento do pedido de vendas, trava o 
	//faturamento caso a pedido de vendas de remessa do destinat�rio seja 
	//transmitido antes da remessa do contrato do cleinte.
	if ExistBlock("UFATE006")
		lRet := U_UFATE006()
	endif

	if lRet

		If Select("cQry") > 0
			cQry->(dbclosearea())
		EndIf

		cQry := "SELECT * "
		cQry += "FROM "+RetSqlName( "SC6" ) + " SC6 "
		cQry += "WHERE SC6.D_E_L_E_T_ <> '*' "
		cQry += "AND C6_NUM = '"+cFilPed+"' "
		cQry += "AND C6_FILIAL = '"+nNumPed+"' "
		cQry += "ORDER BY C6_FILIAL, C6_NUM, C6_ITEM"

		MemoWrite("C:\TEMP\Qtd.txt",cQry)
		cQry := ChangeQuery(cQry)

		TcQuery cQry New Alias "cQry" // Cria uma nova area com o resultado do query

		While !cQry->(EOF())

			If Select("cQrySC9") > 0
				cQry->(dbclosearea())
			EndIf

			nTotal := 0

			cQrySC9 += "SELECT SUM(C9_QTDLIB) AS TOTAL "
			cQrySC9 += "FROM "+RetSqlName( "SC9" ) + " SC9 "
			cQrySC9 += "WHERE SC9.C9_FILIAL = '"+cQry->C6_FILIAL+"' "
			cQrySC9 += "AND SC9.C9_PEDIDO = '"+cQry->C6_NUM+"' "
			cQrySC9 += "AND SC9.C9_ITEM = '"+cQry->C6_ITEM+"' "
			cQrySC9 += "AND SC9.D_E_L_E_T_ <>  '*' "
			cQrySC9 += "AND SC9.C9_QTDLIB > 0 "
			cQrySC9 += "AND SC9.C9_NFISCAL = ' ' "
			cQrySC9 += "AND SC9.C9_SERIENF = ' ' "

			MemoWrite("C:\TEMP\SC9_TOTAL.txt",cQrySC9)
			cQrySC6 := ChangeQuery(cQrySC9)

			TcQuery cQrySC9 New Alias "cQrySC9" // Cria uma nova area com o resultado do query

			nTotal := cQrySC9->TOTAL

			If nTotal < cQry->C6_QTDVEN

				aAdd( aArray, { cQry->C6_ITEM, .F.} )

			EndIf

			cQry->(dbSkip())

		EndDo

		If Len(aArray) > 0

			cText := "Esse cliente n�o permite o faturamento parcial do pedido, por favor verifique o(s) iten(s) "

			For nI := 1 to Len(aArray)

				cText += aArray[nI][1]

				If nI = Len(aArray)

					cText += " "

				Else

					cText += " ,"

				EndIf

			Next

			cText += "do pedido de venda "+AllTrim(nNumPed)

			lRet := .F.

			MsgAlert(cText, 'Aten��o !!!!')

		EndIf

	endif

	FWRestArea(aArea)

Return(lRet)
