#INCLUDE "rwmake.ch"
#INCLUDE "topconn.ch"   
#INCLUDE "Protheus.ch"

User Function F060ACT()
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
��� Programa � F060ACT � Autor � CARLOS DANIEL        � Data �    10/11/15 ��
�������������������������������������������������������������������������͹��
���Descricao � Retorna NOVA SITUACAO                                      ���
�������������������������������������������������������������������������Ĵ��
���Utilizacao� ERCAL - Financeiro                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
          
Private cPerg      := "SerEr1"
//Private dVEnc := "SERASA/PROTESTO"
//Bloqueio Para atualiza��o anual dos fonts Carlos Daniel
PutSX1(cPerg , "01" , "Modo Imp.	             " , "" , "" , "mv_ch1" , "N" , 1  , 0 , 1 , "C" , "", "", "", "", "mv_par01" , "(1)SERASA" ,"","","", "(2)PROTESTO" ,"","","(3)ADVOGADO", "   " , "" , "(4)CARTEIRA" , "" , "" , "" , "" , "" , "" )

pergunte(cPerg,.T.)    

RecLock("SE1",.F.)
	SE1->E1_MOTIVO := cvaltochar(mv_par01)
MsUnlock()	

Return(.T.)    