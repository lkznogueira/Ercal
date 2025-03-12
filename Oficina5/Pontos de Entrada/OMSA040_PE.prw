#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "FWMVCDEF.CH" 

//-------------------------------------------------------------------
/*/{Protheus.doc} OMSA040
@description Ponto de Entrada do Model MVC da rotina OMSA040 - Motoristas
@author 
@since 01/01/2024
@version 1.0
@type function
/*/
//-------------------------------------------------------------------

User Function OMSA040()

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
//		FWMsgRun(,{|| U_webHookConnect("DA4", oModMVC:GetOperation(), {DA4->DA4_COD}) }, "Sincronização Connect", "Processando...")
		U_webHookConnect("DA4", oModMVC:GetOperation(), {DA4->DA4_COD})
	Endif

Return xRet

