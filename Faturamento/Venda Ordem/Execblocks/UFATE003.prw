#include "protheus.ch"
#include "topconn.ch"

/*/-------------------------------------------------------------------
- Programa: UFATE003
- Autor: Wellington Gonçalves
- Data: 25/03/2020
- Descrição: Valida se o cliente e loja foram preenchidos caso for
conta ordem igual a sim, acionado pelo PE FT400TOK.
-------------------------------------------------------------------/*/

User Function UFATE003()

	Local aArea         := FWGetArea()
	Local lRet          := .T.

	// se o contrato for do tipo Conta Ordem
	if M->ADA_XORDEM == "1"
		//Se for conta e ordem, tem que preencher o cliente e o loja.
		if Empty(M->ADA_XCLIOR) .OR. Empty(M->ADA_XLOJOR)
			MsgStop("Preencha o codigo e loja referente a conta ordem.","Atenção!")
			lRet := .F.
		endif
	endif

	FWRestArea(aArea)

Return(lRet)
