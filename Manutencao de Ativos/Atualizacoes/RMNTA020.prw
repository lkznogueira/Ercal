#INCLUDE "rwmake.ch"

/*
���������������������������������������������������������������������������������
���������������������������������������������������������������������������������
�����������������������������������������������������������������������������ͻ��
���Programa  � RMNTA020  � Autor � Wellington Gon�alves  � Data �  07/01/13   ���
�����������������������������������������������������������������������������͹��
���Descricao � AxCadastro de Grupos de Bens					          	 	  ���
���          �                                                         		  ���
�����������������������������������������������������������������������������͹��
���Uso       �Montvidiu		                                        		  ���
�����������������������������������������������������������������������������ͼ��
���������������������������������������������������������������������������������
���������������������������������������������������������������������������������
*/

User Function RMNTA020()

Local cPerg   := "ZZ2"
Local cVldAlt := ".T." // Validacao para permitir a alteracao. Pode-se utilizar ExecBlock.
Local cVldExc := ".T." // Validacao para permitir a exclusao. Pode-se utilizar ExecBlock.

Private cString := "ZZ2"

dbSelectArea("ZZ2")
dbSetOrder(1)

cPerg   := "ZZ2"

Pergunte(cPerg,.F.)
SetKey(123,{|| Pergunte(cPerg,.T.)}) // Seta a tecla F12 para acionamento dos parametros

AxCadastro(cString,"Cadastro de Grupos de Bens.",cVldExc,cVldAlt)

Set Key 123 To // Desativa a tecla F12 do acionamento dos parametros

Return()