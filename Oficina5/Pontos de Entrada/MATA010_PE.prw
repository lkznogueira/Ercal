#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "FWMVCDEF.CH" 

//-------------------------------------------------------------------
/*/{Protheus.doc} ITEM
@description Ponto de Entrada do Model MVC da rotina MATA010 - Produtos
@author 
@since 01/01/2024
@version 1.0
@type function
/*/
//-------------------------------------------------------------------

User Function ITEM()

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
//		FWMsgRun(,{|| U_webHookConnect("SB1", oModMVC:GetOperation(), {SB1->B1_COD}) }, "Sincronização Connect", "Processando...")
		U_webHookConnect("SB1", oModMVC:GetOperation(), {SB1->B1_COD})
	Endif

Return xRet

