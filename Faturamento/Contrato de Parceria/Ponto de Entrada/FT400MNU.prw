#INCLUDE "rwmake.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �FT400MNU  �Autor  �Carlos Daniel       � Data �  15/05/14   ���
�������������������������������������������������������������������������͹��
���Desc.     � PE para inclusao de botao no aRotina do contrato de        ���
���          � parceria                                                   ���
���	   		 �              			                            	  ���
�������������������������������������������������������������������������͹��
���Uso       � ERCAL                                                      ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
//compilar
User Function FT400MNU

aadd(aRotina,{'Distrato','u_Distra01()',0,4,0,NIL})//add carlos  
//aadd(aRotina,{'Imprimir Contrato','FATR030',0,3,0,NIL})
If cEmpAnt == '50'
    aAdd(aRotina,{"APROVA CTR", "u_libcontr()", 0, 4, 0, Nil}) //Aprova Contrato 
EndIf
aadd(aRotina,{'Imprimir Contrato','u_xFATR030()',0,3,0,NIL}) //Rotina Gontijo
aAdd(aRotina,{"Altera Vencimento CTR","U_MFAT100()",0,4,0,NIL})
aAdd(aRotina,{"Atu. Data Vcto - Lote", "u_MFAT102()", 0, 4, 0, Nil}) //Rotina Gontijo
aAdd(aRotina,{"Altera Data Entrega","U_MFAT110()",0,4,0,NIL})
aAdd(aRotina,{"Log de Vencimento","U_MFAT101()",0,4,0,NIL})
aAdd(aRotina,{"Atu. Pre�o", "u_MFAT103()", 0, 4, 0, Nil}) //Rotina Gontijo  
aAdd(aRotina,{"Replica 4104 Venda Ordem", "u_copcontr()", 0, 4, 0, Nil}) //Carlos Daniel
aAdd(aRotina,{"Gera Provisorio", "u_criapr()", 0, 4, 0, Nil}) //Carlos Daniel 
 

Return
