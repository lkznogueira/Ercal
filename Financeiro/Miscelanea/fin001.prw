/*______________________________________________________________________
   ¦Autor     ¦ Carlos Daniel                       ¦ Data ¦ 01/04/24 ¦
   +----------+-------------------------------------------------------¦
   ¦Descrição ¦ Gatilho grava sa1 info de cobranca                    ¦
  ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
#include "protheus.ch"
#include "topconn.ch"

user function fin001()
	local cInfo := M->E1_XINFO
	local cCli  := M->E1_CLIENTE
	local cLoja := M->E1_LOJA
	Local cObs
	Local nNum  := M->E1_NUM
	Local cRet  := '2'
	local cText
	//posicionando no cliente
	DbSelectArea("SA1")
	SA1->(DbSetOrder(1))
	SA1->(DbSeek(xFilial("SA1")+cCli+cLoja))
	cObs := SA1->A1_XOBS //MUDAR PARA XOBS
	cText := cObs+('- '+DTOC(Date())+' - '+nNum+' - '+cInfo+' ')
	
	IF !empty(trim(cInfo))
		IF M->E1_XINFO $ SA1->A1_XOBS
			cRet := '1'
			return cRet
		Else
			RecLock("SA1",.F.)
			SA1->A1_XOBS := cText
			SA1->(MsUnlock())
		EndIf
		cRet := '1'
	EndIF

return cRet

user function fin002()
	local xPerfil := M->E1_XPERFIL
	local cCli  := M->E1_CLIENTE
	local cLoja := M->E1_LOJA
	Local cGrav := .F.
	Local cRisco
	Local cPer
	Local cText
	Local nNum  := M->E1_NUM
	//posicionando no cliente
	DbSelectArea("SA1")
	SA1->(DbSetOrder(1))
	SA1->(DbSeek(xFilial("SA1")+cCli+cLoja))
	
	IF xPerfil <> ' '
		IF xPerfil $ 'N/R'
			IF xPerfil == 'N'
				cPer := 'NEGOCIACAO'
			Else
				cPer := 'RENEGOCIADO'
			EndIf
			cRisco := 'B'
			cGrav := .T.
		ELSEIF xPerfil $ 'S/P'
			IF xPerfil == 'S'
				cPer := 'SERASA'
			Else
				cPer := 'PROTESTO'
			EndIf
			cRisco := 'C'
			cGrav := .T.
		ELSEIF xPerfil == 'J'
			cPer := 'JURIDICO'
			cRisco := 'D'
			cGrav := .T.
		Else
			cGrav := .F.
		EndIf
		
		IF cGrav
			cObs := SA1->A1_XOBS //MUDAR PARA XOBS
			cText := cObs+('- '+cPer+' - '+DTOC(Date())+' - '+nNum+' -  *Alteração de Status* ')
			cRet := '1'
			RecLock("SA1",.F.)
			SA1->A1_RISCO:= cRisco
			SA1->A1_XOBS := cText
			SA1->(MsUnlock())
		ELSE
			cRet := M->E1_XNEG
		ENDIF
	EndIF

return cRet
