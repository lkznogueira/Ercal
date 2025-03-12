#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "TBICONN.CH"
#DEFINE CRLF CHR(13)+CHR(10)

/*
_____________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦Programa  ¦ MTA130C8    ¦ Autor ¦ Totvs              ¦ Data ¦ 12/08/13 ¦¦¦
¦¦+----------+---------------------------------D---------------------------¦¦¦
¦¦¦Descriçào ¦ P.E. para gravao da natureza da solicitação de compras na  ¦¦¦
¦¦¦          ¦ cotação.                                                   ¦¦¦
¦¦¦          ¦                                                            ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Uso       ¦ Mineração Montividiu                                       ¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
*/

User Function MTA130C8()
//User Function MTA131C8()

dbSelectArea("SC8")
     RecLock("SC8",.F.)
     Replace C8_XNATURE With SC1->C1_XNATURE,;
      		 C8_XDESNAT WITH SC1->C1_XDESNAT,;
      		 C8_XLOCAL 	WITH SC1->C1_XLOCAL,;
      		 C8_OBS 	WITH SC1->C1_OBS
     MsUnlock()
Return

/*
User Function MTA130C8()

RecLock("SC8",.F.)
	SC8->C8_XNATURE := SC1->C1_XNATURE
	SC8->C8_XDESNAT := SC1->C1_XDESNAT 
	SC8->C8_XLOCAL  := SC1->C1_XLOCAL   
    SC8->C8_OBS     := SC1->C1_OBS       
    
    
	
SC8->(MsUnLock()) 



Return Nil
*/
