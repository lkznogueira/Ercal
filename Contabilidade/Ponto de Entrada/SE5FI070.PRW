#INCLUDE "topconn.ch"     
#INCLUDE "rwmake.ch"
/*
_____________________________________________________________________________
�����������������������������������������������������������������������������
��+-----------------------------------------------------------------------+��
���Programa  � SE5FI070     � Autor � Claudio Ferreira  � Data � 25/04/17 ���
��+----------+------------------------------------------------------------���
���Descri��o � Ponto de entrada                                           ���
���          � Atualiza��o flag devolu��o CH                              ���
���          �                                                            ���
��+----------+------------------------------------------------------------���
���Uso       � Ercal								                      ���
��+-----------------------------------------------------------------------+��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function SE5FI070()
   If SE5->(FieldPos("E5_CHQDEV")) > 0  
	   RecLock('SE5',.F.) 
	   SE5->E5_CHQDEV:=SE1->E1_CHQDEV 
	   SE5->(MsUnlock())
   EndIf   
Return NIL    

User Function F070EST()
   If SE5->(FieldPos("E5_CHQDEV")) > 0  
	   RecLock('SE5',.F.) 
	   SE5->E5_CHQDEV:=SE1->E1_CHQDEV 
	   SE5->(MsUnlock())
   EndIf  
Return NIL 

