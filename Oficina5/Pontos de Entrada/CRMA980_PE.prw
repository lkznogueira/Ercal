#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "FWMVCDEF.CH" 

//-------------------------------------------------------------------
/*/{Protheus.doc} CRMA980
@description Ponto de Entrada do Model MVC da rotina CRMA980 - Clientes
@author 
@since 01/01/2024
@version 1.0
@type function
/*/
//-------------------------------------------------------------------

User Function CRMA980()

	Local oModMVC	:= Nil
	Local cIdExec	:= ""
	Local cIdForm	:= ""
	Local xRet		:= .T.
	
	If ParamIXB == NIL
		Return(.T.)
	Endif

	oModMVC	:= ParamIXB[1]
	cIdExec	:= ParamIXB[2]
	cIdForm	:= ParamIXB[3]

	If cIdExec == "MODELCOMMITNTTS" .And. (oModMVC:GetOperation() >= 3 .And. oModMVC:GetOperation() <= 5) .And. ExistBlock("webHookConnect")
//		FWMsgRun(,{|| U_webHookConnect("SA1", oModMVC:GetOperation(), {SA1->A1_COD, SA1->A1_LOJA}) }, "Sincronização Connect", "Processando...")
		U_webHookConnect("SA1", oModMVC:GetOperation(), {SA1->A1_COD, SA1->A1_LOJA})
	Endif

Return xRet

