#INCLUDE "topconn.ch"
#INCLUDE "Protheus.ch"
#INCLUDE "TbiConn.ch"
#INCLUDE "rwmake.ch"

User function M410PVNF()

Local cFilPed := SC5->C5_FILIAL
Local nNumPed := SC5->C5_NUM
Local cQry    := ""
Local cQrySC9 := ""
Local cText   := ""
Local nTotal  := 0
Local aArray  := {}
Local nI      := 0
Local lRet    := .T.

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

		cText := "Esse cliente não permite o faturamento parcial do pedido, por favor verifique o(s) iten(s) "

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

		MsgAlert(cText, 'Atenção !!!!')

	EndIf

Return lRet
