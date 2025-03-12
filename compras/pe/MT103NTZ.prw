#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "TBICONN.CH"
#DEFINE CRLF CHR(13)+CHR(10)

/*
_____________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦Programa  ¦ MT103NTZ    ¦ Autor ¦ Totvs              ¦ Data ¦ 16/08/13 ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Descriçào ¦ Seleciona natureza no documento de entrada.                ¦¦¦
¦¦¦          ¦ 															  ¦¦¦
¦¦¦          ¦                                                            ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Uso       ¦ Mineração Montividiu                                       ¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
*/

User Function MT103NTZ()

Local cExpN1  := PARAMIXB[1]
Local cNatureza := ""
Local nX
Local nPosCod := aScan(aHeader, {|x| Alltrim(Upper(X[2])) == "D1_COD" })
Local nPosPed := aScan(aHeader, {|x| AllTrim(Upper(X[2])) == "D1_PEDIDO" })
Local nPosIte := aScan(aHeader, {|x| AllTrim(Upper(X[2])) == "D1_ITEMPC" })

	if !empty(cExpN1)
		Return(cExpN1)
	endif
	
	For nX:= 1 to len(aCols)
		If !Empty(aCols[nX][nPosPed]) .And. !aCols[nX][len(aHeader)+1]
			DbSelectArea("SC7")
			SC7->(DbSetOrder(19)) //C7_FILENT+C7_PRODUTO+C7_NUM+C7_ITEM
			If SC7->(MsSeek(xFilial("SC7")+aCols[nX][nPosCod]+aCols[nX][nPosPed]+aCols[nX][nPosIte]))
				If !cExpN1 == SC7->C7_XNATURE
					cNatureza := SC7->C7_XNATURE
					exit
				Else
					exit
				EndIf
			EndIf
		EndIf
	Next nX
	
	if empty(cNatureza)
		cNatureza := cExpN1
	endif
	
Return(cNatureza)