#INCLUDE 'TCBROWSE.CH'
#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'TBICONN.CH'
#INCLUDE 'TOTVS.CH'
#INCLUDE 'TOPCONN.CH'
#INCLUDE 'FWMVCDEF.CH'

/*/{Protheus.doc} MFAT101
@author Lucas Nogueira
/*/
User Function MFAT101()
	Local _cFiltro      := ""

	Private oBrowse		:= Nil

	Private cCadastro	:= " Log's Alteração de Vencimento "
	Private aRotina		:= MenuDef()

	oBrowse := FWmBrowse():New()
	oBrowse:SetDescription( cCadastro )
	oBrowse:SetAlias( 'ZZY' )
	oBrowse:SetMenuDef( 'MFAT101' )

	_cFiltro := " ZZY_NUMCTR = '" + ADA->ADA_NUMCTR + "'" //7
	oBrowse:SetFilterDefault(_cFiltro)

	oBrowse:Activate()

Return()


/*/{Protheus.doc} MenuDef
@author Lucas Nogueira
@version 1.0
@type function
/*/
Static Function MenuDef()

	Local aRotina	:= {}

	ADD OPTION aRotina Title 'Visualizar'       Action 'VIEWDEF.MFAT101'	OPERATION 2   ACCESS 0

Return aRotina


/*/{Protheus.doc} ModelDef
//TODO Descricao auto-gerada.
@author Lucas Nogueira
/*/
Static Function ModelDef()
	Local oStruZZY:= FWFormStruct( 1, 'ZZY' )
	Local oModel   := MPFormModel():New( 'MFAT101M' ) // ao encerrar soma valor da proposta

	oModel:AddFields( 'ZZYMASTER', /*cOwner*/, oStruZZY )
	oModel:GetModel('ZZYMASTER'):SetPrimaryKey({ 'ZZY_FILIAL' , 'ZZY_NUMCTR' })

Return oModel


/*/{Protheus.doc} ViewDef
@author Lucas Nogueira
/*/
Static Function ViewDef()
	Local oModel    := FWLoadModel( 'MFAT101' )
	Local oStruZZY  := FWFormStruct( 2, 'ZZY' )
	Local oView     := FWFormView():New()

	oView:SetModel( oModel )

	oView:AddField( 'VIEW_ZZY'  , oStruZZY	, 'ZZYMASTER' 	)

	oView:CreateHorizontalBox('TOTAL', 100)

	oView:SetOwnerView('VIEW_ZZY', 'TOTAL'	)

	oView:SetCloseOnOk( { ||.T. } )

Return oView
