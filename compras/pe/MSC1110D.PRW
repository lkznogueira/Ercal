#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "TBICONN.CH"
//#DEFINE CRLF CHR(13)+CHR(10)

//Criado Carlos Daniel bloqueio de exclusao de SC aprovada
User Function MSC1110D() 

Local lExclui := .T.

If SC1->C1_APROV == 'L'// .AND. SC1->C1_PEDIDO == ' '

    lExclui := .F.
	Alert("SC Aprovada por "+ SC1->C1_NOMAPRO+"E nao pode ser excluida.")

EndIf


Return (lExclui) 
