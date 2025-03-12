/* ===
Analista Carlos Daniel tela de contratos importados do sistema oficina5
=== */

#Include 'Protheus.ch'
#Include 'FWMVCDef.ch'

//Variáveis Estáticas
Static cTitulo := "Pedidos Importados"

/*/{Protheus.doc} aTela3
Função funcao para cadastro contratos importados (Exemplo de Modelo 3 - Z02 x Z03)
@author Carlos Daniel
@since 23032021
@version 1.0
	@return Nil, Função não tem retorno
	@example
	u_aTela3()
/*/

User Function aTela3()
	Local aArea   := GetArea()
	Local oBrowse
	
	//Instânciando FWMBrowse - Somente com dicionário de dados
	oBrowse := FWMBrowse():New()
	
	//Setando a tabela de cadastro cabecalho
	oBrowse:SetAlias("Z02")

	//Setando a descrição da rotina
	oBrowse:SetDescription(cTitulo)
	
	//Ativa a Browse
	oBrowse:Activate()
	
	RestArea(aArea)
Return Nil

/*---------------------------------------------------------------------*
 | Func:  MenuDef                                                      |
 | Autor: Carlos Daniel                                               |
 | Data:  23/03/2021                                                   |
 | Desc:  Criação do menu MVC                                          |
 *---------------------------------------------------------------------*/

Static Function MenuDef()
	Local aRot := {}
	
	//Adicionando opções
	ADD OPTION aRot TITLE 'Visualizar' ACTION 'VIEWDEF.aTela3' OPERATION MODEL_OPERATION_VIEW   ACCESS 0 //OPERATION 1
	ADD OPTION aRot TITLE 'Incluir'    ACTION 'VIEWDEF.aTela3' OPERATION MODEL_OPERATION_INSERT ACCESS 0 //OPERATION 3
	ADD OPTION aRot TITLE 'Alterar'    ACTION 'VIEWDEF.aTela3' OPERATION MODEL_OPERATION_UPDATE ACCESS 0 //OPERATION 4
	ADD OPTION aRot TITLE 'Excluir'    ACTION 'VIEWDEF.aTela3' OPERATION MODEL_OPERATION_DELETE ACCESS 0 //OPERATION 5

Return aRot

/*---------------------------------------------------------------------*
 | Func:  ModelDef                                                     |
 | Autor: Carlos Daniel                                               |
 | Data:  23/03/2021                                                   |
 | Desc:  Criação do modelo de dados MVC                               |
 *---------------------------------------------------------------------*/

Static Function ModelDef()
	Local oModel 		:= Nil
	Local oStPai 		:= FWFormStruct(1, 'Z02')
	Local oStFilho 	:= FWFormStruct(1, 'Z03')
	Local aZ03Rel		:= {}
	
	//Definições dos campos
	oStPai:SetProperty('Z02_NUMCTR',    MODEL_FIELD_WHEN,    FwBuildFeature(STRUCT_FEATURE_WHEN,    '.F.'))                                 //Modo de Edição
	oStPai:SetProperty('Z02_NUMCTR',    MODEL_FIELD_INIT,    FwBuildFeature(STRUCT_FEATURE_INIPAD,  'GetSXENum("Z02", "Z02_NUMCTR")'))       //Ini Padrão
	oStPai:SetProperty('Z02_CODCLI',   MODEL_FIELD_VALID,   FwBuildFeature(STRUCT_FEATURE_VALID,   'ExistCpo("ZZ1", M->Z02_CODCLI)'))      //Validação de Campo
	oStFilho:SetProperty('Z03_NUMCTR',  MODEL_FIELD_WHEN,    FwBuildFeature(STRUCT_FEATURE_WHEN,    '.F.'))                                 //Modo de Edição
	oStFilho:SetProperty('Z03_NUMCTR',  MODEL_FIELD_OBRIGAT, .F. )                                                                          //Campo Obrigatório
	oStFilho:SetProperty('Z03_CODCLI', MODEL_FIELD_OBRIGAT, .F. )                                                                          //Campo Obrigatório
	oStFilho:SetProperty('Z03_ITEM', MODEL_FIELD_INIT,    FwBuildFeature(STRUCT_FEATURE_INIPAD,  'u_zIniMus()'))                         //Ini Padrão
	
	//Criando o modelo e os relacionamentos
	oModel := MPFormModel():New('aTela3M')
	oModel:AddFields('Z02MASTER',/*cOwner*/,oStPai)
	oModel:AddGrid('Z03DETAIL','Z02MASTER',oStFilho,/*bLinePre*/, /*bLinePost*/,/*bPre - Grid Inteiro*/,/*bPos - Grid Inteiro*/,/*bLoad - Carga do modelo manualmente*/)  //cOwner é para quem pertence
	
	//Fazendo o relacionamento entre o Pai e Filho
	aAdd(aZ03Rel, {'Z03_FILIAL','Z02_FILIAL'} )
	aAdd(aZ03Rel, {'Z03_NUMCTR',	'Z02_NUMCTR'})
	aAdd(aZ03Rel, {'Z03_CODCLI','Z02_CODCLIT'}) 
	
	oModel:SetRelation('Z03DETAIL', aZ03Rel, Z03->(IndexKey(1))) //IndexKey -> quero a ordenação e depois filtrado
	oModel:GetModel('Z03DETAIL'):SetUniqueLine({"Z03_DESC"})	//Não repetir informações ou combinações {"CAMPO1","CAMPO2","CAMPOX"}
	oModel:SetPrimaryKey({})
	
	//Setando as descrições
	oModel:SetDescription("Grupo de Produtos")
	oModel:GetModel('Z02MASTER'):SetDescription('Cadastro')
	oModel:GetModel('Z03DETAIL'):SetDescription('CDs')
Return oModel

/*---------------------------------------------------------------------*
 | Func:  ViewDef                                                      |
 | Autor: Carlos Daniel                                               |
 | Data:  23/03/2021                                                   |
 | Desc:  Criação da visão MVC                                         |
 *---------------------------------------------------------------------*/

Static Function ViewDef()
	Local oView		:= Nil
	Local oModel		:= FWLoadModel('aTela3')
	Local oStPai		:= FWFormStruct(2, 'Z02')
	Local oStFilho	:= FWFormStruct(2, 'Z03')
	
	//Criando a View
	oView := FWFormView():New()
	oView:SetModel(oModel)
	
	//Adicionando os campos do cabeçalho e o grid dos filhos
	oView:AddField('VIEW_Z02',oStPai,'Z02MASTER')
	oView:AddGrid('VIEW_Z03',oStFilho,'Z03DETAIL')
	
	//Setando o dimensionamento de tamanho
	oView:CreateHorizontalBox('CABEC',30)
	oView:CreateHorizontalBox('GRID',70)
	
	//Amarrando a view com as box
	oView:SetOwnerView('VIEW_Z02','CABEC')
	oView:SetOwnerView('VIEW_Z03','GRID')
	
	//Habilitando título
	oView:EnableTitleView('VIEW_Z02','Cabeçalho - Cadastro')
	oView:EnableTitleView('VIEW_Z03','Grid - CDs')
	
	//Força o fechamento da janela na confirmação
	oView:SetCloseOnOk({||.T.})
	
	//Remove os campos de Código do Artista e CD
	oStFilho:RemoveField('Z03_COCLI')
	oStFilho:RemoveField('Z03_NUMCTR')
Return oView

/*/{Protheus.doc} zIniMus
Função que inicia o código sequencial da grid
@type function
@author Carlos DAniel
@since 23/03/2021
@version 1.0
/*/

User Function zIniMus()
	Local aArea := GetArea()
	Local cCod  := StrTran(Space(TamSX3('Z03_ITEM')[1]), ' ', '0')
	Local oModelPad  := FWModelActive()
	Local oModelGrid := oModelPad:GetModel('Z03DETAIL')
	Local nOperacao  := oModelPad:nOperation
	Local nLinAtu    := oModelGrid:nLine
	Local nPosCod    := aScan(oModelGrid:aHeader, {|x| AllTrim(x[2]) == AllTrim("Z03_ITEM")})
	
	//Se for a primeira linha
	If nLinAtu < 1
		cCod := Soma1(cCod)
	
	//Senão, pega o valor da última linha
	Else
		cCod := oModelGrid:aCols[nLinAtu][nPosCod]
		cCod := Soma1(cCod)
	EndIf
	
	RestArea(aArea)
Return cCod