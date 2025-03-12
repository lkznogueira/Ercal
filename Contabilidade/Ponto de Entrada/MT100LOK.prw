#include "totvs.ch"

/*
__________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦Programa  ¦ MT100LOK   ¦ Autor Claudio Ferreira      ¦  Data ¦ 14/04/18¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Descriçào ¦ Ponto de Entrada na confirmação da linha                   ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦ Uso      ¦ Gravar a conta do produto na tabela SD1                    ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
*/

User Function MT100LOK()
Local lRetorno:= .T.
 
//Atualiza Conta Contábil
UpdCta()
////////

Return(lRetorno)    

Static Function UpdCta()   
Local aArea   := GetArea()
Local nCod    := aScan(aHeader,{|x|UPPER(Alltrim(x[2])) == "D1_COD"})
Local nCusto  := aScan(aHeader,{|x|UPPER(Alltrim(x[2])) == "D1_CC"})
Local nContaSD1  := aScan(aHeader,{|x|UPPER(Alltrim(x[2])) == "D1_CONTA"})   
Local nTes    := aScan(aHeader,{|x|UPPER(Alltrim(x[2])) == "D1_TES"})
Local nRat    := aScan(aHeader,{|x|UPPER(Alltrim(x[2])) == "D1_RATEIO"})
Local cConta  := aCols[n][nContaSD1]
Local cCusto  := ""

Local lStq := Posicione("SF4",1,xFilial("SF4")+aCols[n][nTes],"F4_ESTOQUE")=='S'
Local lAtf := Posicione("SF4",1,xFilial("SF4")+aCols[n][nTes],"F4_ATUATF")=='S'
Local lRat := aCols[n][nRat]=='1'

DbSelectArea("SB1")
DbSetorder(1)
Dbseek(xFilial("SB1")+aCols[n][nCod])

If lStq
  cConta := iif(!empty(SF4->F4_XCTAD),SF4->F4_XCTAD,iif(!'VZA'$Upper(U_RetCta('141',U_RetGrpCtb())),U_RetCta('141',U_RetGrpCtb()),IF(!EMPTY(SB1->B1_CONTA),SB1->B1_CONTA,cConta))) 
elseif lAtf 
  cConta := iif(!empty(SF4->F4_XCTAD),SF4->F4_XCTAD,U_RetCtaIm())
elseif lRat
  cCusto :=aBackColsSDE[1][2][1][3]//1o Centro de Custo 
  cConta := iif(!empty(SF4->F4_XCTAD),SF4->F4_XCTAD,U_RetCtaCC(cCusto))
else  
  cConta := iif(!empty(SF4->F4_XCTAD),SF4->F4_XCTAD,U_RetCtaCC(aCols[n][nCusto]))
endif

aCols[n][nContaSD1] := cConta

RestArea(aArea)
Return