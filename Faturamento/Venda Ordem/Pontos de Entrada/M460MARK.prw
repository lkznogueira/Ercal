#include "protheus.ch"
#include "topconn.ch"

/*/-------------------------------------------------------------------
-�Programa: M460MARK
-�Autor:�Wellington�Gon�alves
-�Data:�24/09/2019
-�Descri��o:�O ponto de entrada M460MARK � utilizado para validar os
pedidos marcados e est� localizado no in�cio da fun��o a460Nota
(endere�a rotinas para a gera��o dos arquivos SD2/SF2).
Ser� informado no terceiro par�metro a s�rie selecionada na gera��o
da nota e o n�mero da nota fiscal poder� ser verificado pela vari�vel
private cNumero.
-------------------------------------------------------------------/*/

User Function M460MARK()

	Local aArea     := FWGetArea()
	Local lRet      := .T.

	if ExistBlock("UFATE007")
		lRet := U_UFATE007()
	endif

	FWRestArea(aArea)

Return(lRet)
