#include "PROTHEUS.ch"
 

/*
__________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦Programa  ¦ FA050INC  ¦ Utilizador ¦ Claudio Ferreira ¦ Data ¦ 20/06/12¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Descriçào ¦ Ponto de Entrada na confirmação do Tit Pagar               ¦¦¦
¦¦¦          ¦ Utilizado para validar o preenchimento do C.Custo Deb      ¦¦¦
¦¦¦          ¦ 															  ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦ Uso      ¦ TOTVS-GO                                                   ¦¦¦    
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
*/  

User Function FA050INC()
Local lRet:=.t.

if 'TMSA144D'$Funname() .or. 'TMSA250'$Funname()
  M->E2_CCD:=DT7->DT7_CC
endif   

if 'GPEM670'$Funname()
  Return .t. //Ignora Titulo folha
endif

if IsInCallStack("FINA340")
  Return .t. //Ignora compensacao
endif

if empty(M->E2_CCD) .AND. M->E2_RATEIO<>'S'
  Aviso('Atenção!','Informar o campo [C.Custo Deb]',{'Ok'})
  lRet:=.f.
endif

Return lRet