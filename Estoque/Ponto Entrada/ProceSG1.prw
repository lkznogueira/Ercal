#include "topconn.ch"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MATA650A  �Autor  �Microsiga           � Data �  11/13/13   ���
�������������������������������������������������������������������������͹��
���Desc.     � Atualiza SG1 - Descri��o PA                                 ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/


User Function ProceSG1()
Private cQry := ""

if MsgYesNo("Aten��o! Essa Rotina Vai Alimentar a Descri��o do Produto PA na Estrutura. Deseja continuar?","Atualiza��o Complemento de Produtos")
	
Processa({|| ProcSG1() },"Processando.....")

EndIf
	              
Return()
        
Static Function ProcSG1()
Private nx := 0
ProcRegua(nx)

DbSelectArea("SG1")

SG1->(DbSetOrder(1))  

While  SG1->(!Eof())

 	If SG1->(RecLock("SG1",.F.)) 
	   SG1->G1_XDESC := POSICIONE("SB1",1,"    "+SG1->G1_COD,"B1_DESC") 
   	   SG1->G1_E_XUM   := POSICIONE("SB1",1,"    "+SG1->G1_COD,"B1_UM")
	   SG1->(MSUnlock())	           
    EndIf	
	nx++    
	SG1->(DbSkip())

EndDo             

alert( "Pronto.")

Return()                                                                   
