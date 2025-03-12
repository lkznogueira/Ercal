#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "TBICONN.CH"
#DEFINE CRLF CHR(13)+CHR(10)

/*
_____________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦Programa  ¦ MT110GRV    ¦ Autor ¦ Carlos Daniel      ¦ Data ¦ 12/03/14 ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Descriçào ¦ Ponto de Entrada usado no laco de gravação dos itens da SC ¦¦¦
¦¦¦          ¦ na função A110GRAVA, executado após gravar o item da SC,	  ¦¦¦
¦¦¦          ¦ a cada item gravado da SC o ponto é executado.             ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Uso       ¦ 						                                      ¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
*/

User Function MT110GRV()

	Local lCopia		:= ParamIxb[1]
	Local lIsDeleted    := .F.
	Local nRecno		:= SC1->( Recno() )   
	
	If FunName() == "MATA110" //se for solicitacao compras pega o informado
   		Private xNATURE := CC1XNATURE
   		Private xDESNAT := cC1XDESNAT
	ElseIf FunName() == "MNTA420" // se for corretiva aponta natureza definida
		Private xNATURE := "02010203"
   		Private xDESNAT := "PREST.DE SERV.P/MAN.DE CAMINHOES"
	EndIf

	DEFAULT lCopia	    := .F.


	IF ( lCopia )
		//..Por Enquanto nao faz nada
	EndIF
	
	dbSelectArea("SC1")
	lIsDeleted := SC1->( Deleted() )
	If !lIsDeleted
		RecLock("SC1",.F.)
			SC1->C1_XNATURE := xNATURE
			SC1->C1_XDESNAT := xDESNAT
			//SC1->C1_CC      := cC1CC
		SC1->(MsUnLock())
	endif

return
