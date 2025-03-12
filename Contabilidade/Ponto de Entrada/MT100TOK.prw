#include "rwmake.ch"  
#Include "SigaWin.ch" 
#INCLUDE 'PROTHEUS.CH'
#include "TBICONN.CH"           
#include "TOPCONN.CH"

/*
__________________________________________________________________________
�����������������������������������������������������������������������������
��+-----------------------------------------------------------------------+��
���Programa  � MT100TOK  � Utilizador � Claudio Ferreira � Data � 04/06/12���
��+----------+------------------------------------------------------------���
���Descri��o � Ponto de Entrada na confirma��o da nota de entrada         ���
���          �                                                            ���
���          � 															  ���
��+----------+------------------------------------------------------------���
��� Uso      � TOTVS-GO                                                   ���    
��+-----------------------------------------------------------------------+��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
#include "rwmake.ch"  
#Include "SigaWin.ch"

/*
__________________________________________________________________________
�����������������������������������������������������������������������������
��+-----------------------------------------------------------------------+��
���Programa  � MT100TOK  � Utilizador � Claudio Ferreira � Data � 04/06/12���
��+----------+------------------------------------------------------------���
���Descri��o � Ponto de Entrada na confirma��o da nota de entrada         ���
���          �                                                            ���
���          � 															  ���
��+----------+------------------------------------------------------------���
��� Uso      � TOTVS-GO                                                   ���    
��+-----------------------------------------------------------------------+��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function MT100TOK()      
Local lRet:=.t. 
Local CESPECIE  
LOCAL cD1Espec := alltrim(CESPECIE)


if ('MATA103'$FUNNAME() .or. 'MATA116'$FUNNAME()) .and. !cTipo $ "D/"
  //Valida o preenchimento do C.Custo para TES Estoque="N" 
  lRet:=U_ValCCNF(aCols,aBackColsSDE)  
  if lRet .and. SuperGetMV("MV_XVALATF",.F.,.T.) //Valida falta da TES Imobilizado
    lRet:=U_ValImob(aCols)
  Endif  
endif     

IF cD1Espec $ 'CTE|CTEOS' .AND. (EMPTY(aInfAdic[10]) .OR. EMPTY(aInfAdic[11]) .OR. EMPTY(aInfAdic[12]) .OR. EMPTY(aInfAdic[13]))
	Aviso("Aten��o", "O Doc. � da ESPECIE CTE/CTEOS ent�o informe os campos UF Origem/Destino e MUM Origem/Destino localizado na aba INFORMA��ES ADICIONAIS!",{"OK"})           
	return .F.

ENDIF

Return lRet
 

User Function MT116TOK() 
Local lRet:=.t.  
Private aBackColsSDE:={}
//����������������������������������������������������������Ŀ
//� Ponto de Entrada Padrao                                  �
//������������������������������������������������������������
If ExistBlock("MT100TOK")
	lRet := ExecBlock("MT100TOK",.F.,.F.)
	If ValType(lRet) <> "L"
		lRet := .T.
	EndIf
EndIf

Return lRet