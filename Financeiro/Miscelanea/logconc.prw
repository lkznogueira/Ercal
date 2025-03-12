#include "protheus.ch"

/*/{Protheus.doc} logcon
@description
@type function
@version 1
@author Raphael Ferreira - oficina5
@since 27/10/2021
@return variant, return_description
/*/
User Function logcon()

	Private aRotina	:= {}
	Private oBrowse
	Private cCadastro := "Log importacao conciliacao automatica"
	Private cIndice1,cIndice2,cIndice3
	Private aColunas := {}

	dbSelectArea("SX3")
	SX3->(dbSetOrder(1))
	SX3->(dbSeek("ZA1"))
	While SX3->(!Eof()) .and. SX3->X3_ARQUIVO = "ZA1"
		If X3USO(SX3->X3_USADO) .and. cNivel >= SX3->X3_NIVEL .and. SX3->X3_BROWSE = 'S'
			AADD(aColunas, {SX3->X3_TITULO,SX3->X3_CAMPO,SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_PICTURE} )
		Endif
		SX3->(dbSkip())
	End

	//Operaes de menu disponveis
	aAdd(aRotina, {"Visualizar"	, "AxVisual"  , 0, 2})
	if FwIsAdmin()
		aAdd(aRotina, {"Limpar Log" , "U_logconZ", 0, 3})
	endIf

	//Carrega os registros
	dbSelectArea("ZA1")
	ZA1->(dbGoTop())

	//Monta o browse
	oBrowse := FWmBrowse():New()
	oBrowse:SetAlias("ZA1")
	oBrowse:SetDescription(cCadastro)

	//seta as colunas para o browse
	oBrowse:SetFields(aColunas)
	oBrowse:DisableDetails()

	//Legenda da grade,  obrigatrio carregar antes de montar as colunas
	oBrowse:AddLegend("ZA1_STAT=='1'","YELLOW"      ,"Importado")
	oBrowse:AddLegend("ZA1_STAT=='2'","GREEN"       ,"Processado com sucesso")
	oBrowse:AddLegend("ZA1_STAT=='3'","RED"         ,"Processado com erro")

	//Abre a tela
	oBrowse:Activate()

Return

/*/{Protheus.doc} logconZ
description
@type function
@version  
@author Raphael Ferreira - oficina5
@since 27/10/2021
@return variant, return_description
/*/
user function logconZ()

	local cQuery := ""
	local cAlProc := ""

	if ! MsgYesNo("Deseja limpar a tabela de log, removendo os itens que ocorreram erros?", "Ateno")
		return
	endIf

	cQuery += " Select R_E_C_N_O_ REGZA1 "
	cQuery += " from " + RetSqlTab("ZA1")
	cQuery += " where D_E_L_E_T_ = ' ' "
	cQuery += "    and ZA1_STAT = '3' "

	cQuery := ChangeQuery(cQuery)

	cAlProc := MPSysOpenQuery(cQuery)

	while (cAlProc)->(!EoF())

		ZA1->(DbGoTo((cAlProc)->REGZA1))

		RecLock("ZA1", .F.)
		DbDelete()
		MsUnlock()

		(cAlProc)->(DbSkip())

	endDo

return
