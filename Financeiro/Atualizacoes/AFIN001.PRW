#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'TOTVS.CH'
#INCLUDE 'FWMVCDEF.CH'
#INCLUDE "FWBROWSE.CH"

/*/{Protheus.doc} AFIN001
description
@type function
@version  
@author oficina5
@since 12/11/2021
@return variant, return_description
/*/
User Function AFIN001()

	Local oBrowse
	Private lMsErroAuto := .F.

	DbSelectArea("Z00")

	oBrowse := FWMBrowse():New()
	oBrowse:SetAlias('Z00')
	oBrowse:SetDescription('Controle de Geração de Borderô')

	oBrowse:Activate()

Return()

/*
===============================================================================================================================
Programa--------: MenuDef
Autor-----------: Raphael Ferreira 
Data da Criacao-: 16/09/2020
===============================================================================================================================
Descrição-------: Função que define o menu do browser
===============================================================================================================================
Uso-------------: 
===============================================================================================================================
Parametros------:
===============================================================================================================================
Retorno---------: 
===============================================================================================================================
*/
Static Function MenuDef()

	Local aRotina := {}

	ADD OPTION aRotina TITLE 'Visualizar' 		ACTION 'VIEWDEF.AFIN001' 	OPERATION 2 ACCESS 0

Return(aRotina)

/*
===============================================================================================================================
Programa--------: MenuDef
Autor-----------: Raphael Ferreira 
Data da Criacao-: 16/09/2020
===============================================================================================================================
Descrição-------: Função Model MVC
===============================================================================================================================
Uso-------------: 
===============================================================================================================================
Parametros------:
===============================================================================================================================
Retorno---------: 
===============================================================================================================================
*/
Static Function ModelDef()

	Local oModel	:= Nil
	Local oStruZ00	:= FWFormStruct( 1, 'Z00', /*bAvalCampo*/,/*lViewUsado*/ )

	// Cria o objeto do Modelo de Dados
	oModel := MPFormModel():New('AFIN001M', ,/*bPosValidacao*/, /*bCommit*/, /*bCancel*/ )

	// Adiciona ao modelo uma estrutura de formulário de edição por campo
	oModel:AddFields( 'Z00MASTER', /*cOwner*/, oStruZ00, /*bPreValidacao*/, /*bPosValidacao*/, /*bCarga*/ )

	oModel:SetPrimaryKey({ 'Z00_FILIAL','Z00_CODIGO' })

	// Adiciona a descricao do Modelo de Dados
	oModel:SetDescription('Controle de Borderôs')

Return(oModel)

/*
===============================================================================================================================
Programa--------: MenuDef
Autor-----------: Raphael Ferreira 
Data da Criacao-: 16/09/2020
===============================================================================================================================
Descrição-------: Função View MVC
===============================================================================================================================
Uso-------------: 
===============================================================================================================================
Parametros------:
===============================================================================================================================
Retorno---------: 
===============================================================================================================================
*/
Static Function ViewDef()

	// Cria um objeto de Modelo de Dados baseado no ModelDef do fonte informado
	Local oModel	:= FWLoadModel('AFIN001')
	// Cria a estrutura a ser usada na View
	Local oStruZ00 := FWFormStruct( 2, 'Z00')
	Local oView

	// Cria o objeto de View
	oView := FWFormView():New()

	// Define qual o Modelo de dados será utilizado
	oView:SetModel( oModel )

	//Adiciona enchoice
	oView:AddField( 'VIEW_Z00', oStruZ00, 'Z00MASTER' )

	// Cria objeto de tela
	oView:CreateHorizontalBox( 'SUPZ00', 100)

	//Fecha a tela após finalizar a inclusão
	oView:SetCloseOnOk( { ||.T. } )

Return(oView)
