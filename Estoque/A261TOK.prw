#include "protheus.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �A261TOK   �Autor  �TOTVS               � Data �  10/19/10   ���
�������������������������������������������������������������������������͹��
���Desc.     �Na rotina de transf. (mod 2), nao aceita transferir um      ���
���          �produto para outro codigo.                                  ���
�������������������������������������������������������������������������͹��
���Uso       �                                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function A261TOK()
Local lret := .t.
/*
Local nx

for nx := 1 to len(acols)
	if !GdDeleted(nx)
		if acols[nx][1] <> acols[nx][6]
			MsgStop("O produto origem tem que ser o mesmo do produto destino, favor corrigir a linha: "+alltrim(str(nx)),"Aten��o")
			lret := .f.
			exit
		endif
	endif
next nx		
*/
Return(lret)
