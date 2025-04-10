#INCLUDE "PROTHEUS.CH"


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MT100GE2  �Autor  �Carlos Daniel       � Data �  26/06/12   ���
�������������������������������������������������������������������������͹��
���Desc.     � PE chamado durante a gera��o da SE2.                       ���
���          � Utilizado para complementar o titulo a pagar              .���
�������������������������������������������������������������������������͹��
���Uso       � Ercal                                                      ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

USER FUNCTION MT100GE2
Local   nPosItem := aScan(aHEADER,{|x| Trim(x[2])=="D1_ITEMCTA"})
Local   cPedido := aScan(aHEADER,{|x| Trim(x[2])=="D1_PEDIDO"})
Local   cFormax := ' '

if !empty(acols[1,cPedido])
  DbSelectArea("SC7")
  DbSetOrder(1)
  If MsSeek(xFilial("SC7")+acols[1,cPedido]+"0001")
		  cFormax := C7_XFORMA
      RecLock("SE2", .F. )
      SE2->E2_XFORMA   := cFormax //Grava A FORMA PG informada na 1 linha
      MsUnLock()
  Endif
EndIf

if !empty(acols[1,nPosItem])
  RecLock("SE2", .F. )
  SE2->E2_ITEMD   := acols[1,nPosItem] //Grava o item informado na 1 linha
  MsUnLock()
endif
Return  
