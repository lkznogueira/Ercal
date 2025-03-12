#include "protheus.ch"
#include "topconn.ch"

/*/-------------------------------------------------------------------
- Programa: M460MARK
- Autor: Wellington Gonçalves
- Data: 24/09/2019
- Descrição: O ponto de entrada M460MARK é utilizado para validar os
pedidos marcados e está localizado no início da função a460Nota
(endereça rotinas para a geração dos arquivos SD2/SF2).
Será informado no terceiro parâmetro a série selecionada na geração
da nota e o número da nota fiscal poderá ser verificado pela variável
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
