#include "rwmake.ch"
#include "TbiConn.ch"
#include "TbiCode.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MT160WF   ºAutor  ³Carlos Daniel        º Data ³ 25/07/2013 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Ponto de entrada para envio de Workflow na apos confirmacao º±±
±±º          ³ da Geracao de Cotacao                                      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³                                                           º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

user function MT160WF()

//GRAVA DADOS SC8 NA SC7
Private cNumCot := PARAMIXB[01]
Private aArqSC8 := {"SC8",SC8->(IndexOrd()),SC8->(Recno())}
Private aArqSC7 := {"SC7",SC7->(IndexOrd()),SC7->(Recno())}

dbSelectArea("SC8")
dbSetOrder(1)
dbSeek(xFilial("SC8")+cNumCot)

While ! Eof() .And. ;
      xFilial("SC8") == SC8->C8_FILIAL .And. ;
      cNumCot        == SC8->C8_NUM

   dbSelectArea("SC7")
   dbSetOrder(1)
   dbSeek(xFilial("SC7")+SC8->C8_NUMPED+SC8->C8_ITEMPED)

   If ! Eof()
      RecLock("SC7",.F.)
      Replace C7_XLOCAL With SUBSTR(SC8->C8_XLOCAL,1,4)
      MsUnlock()
   EndIf

   dbSelectArea("SC8")
   dbSkip()

EndDo

dbSelectArea(aArqSC7[1])
dbSetOrder(aArqSC7[2])
dbGoTo(aArqSC7[3])

dbSelectArea(aArqSC8[1])
dbSetOrder(aArqSC8[2])
dbGoTo(aArqSC8[3])

//CHAMA WORKFLOW
	U_WFW120P()
RETURN .T.