#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'TOTVS.CH'
#INCLUDE 'FWMVCDEF.CH'
#INCLUDE "FWBROWSE.CH"

/*/{Protheus.doc} AFIN002
description
@type function
@version  
@author oficina5
@since 12/11/2021
@return variant, return_description
/*/
User Function AFIN002()

	Local oBrowse

	Private aMsg := {}

	DbSelectArea("Z02")

	oBrowse := FWMBrowse():New()
	oBrowse:SetAlias('Z02')
	oBrowse:SetDescription('Controle de Geração Identificador de Depósitos')

	oBrowse:Activate()

Return()

/*/{Protheus.doc} MenuDef
description
@type function
@version  
@author oficina5
@since 17/12/2021
@return variant, return_description
/*/
Static Function MenuDef()

	Local aRotina := {}

	ADD OPTION aRotina Title 'Pesquisar'  Action 'PesqBrw'         OPERATION 1 ACCESS 0
	ADD OPTION aRotina Title 'Visualizar' Action 'VIEWDEF.AFIN002' OPERATION 2 ACCESS 0
	ADD OPTION aRotina Title 'Incluir'    Action 'VIEWDEF.AFIN002' OPERATION 3 ACCESS 0
	//ADD OPTION aRotina Title 'Alterar'    Action 'VIEWDEF.AFIN002' OPERATION 4 ACCESS 0
	//ADD OPTION aRotina Title 'Excluir'    Action 'VIEWDEF.AFIN002' OPERATION 5 ACCESS 0
	ADD OPTION aRotina Title 'Cancelar'   Action 'AFIN002E()' OPERATION 5 ACCESS 0

Return(aRotina)

/*/{Protheus.doc} ModelDef
description
@type function
@version  
@author oficina5
@since 17/12/2021
@return variant, return_description
/*/
Static Function ModelDef()

	Local oModel	:= Nil
	Local oStruZ02	:= FWFormStruct( 1, 'Z02', /*bAvalCampo*/,/*lViewUsado*/ )

	// Cria o objeto do Modelo de Dados
	oModel := MPFormModel():New('AFIN002M', ,/*bPosValidacao*/, { |oModel| AFIN002B(oModel) }/*bCommit*/, /*bCancel*/ )

	// Adiciona ao modelo uma estrutura de formulário de edição por campo
	oModel:AddFields( 'Z02MASTER', /*cOwner*/, oStruZ02, /*bPreValidacao*/, /*bPosValidacao*/, /*bCarga*/ )

	oModel:SetPrimaryKey({ 'Z02_FILIAL','Z02_CODID' })

	// Adiciona a descricao do Modelo de Dados
	oModel:SetDescription('Identificador de Depósito')

Return(oModel)

/*/{Protheus.doc} ViewDef
description
@type function
@version  
@author oficina5
@since 17/12/2021
@return variant, return_description
/*/
Static Function ViewDef()

	// Cria um objeto de Modelo de Dados baseado no ModelDef do fonte informado
	Local oModel	:= FWLoadModel('AFIN002')
	// Cria a estrutura a ser usada na View
	Local oStruZ02 := FWFormStruct( 2, 'Z02')
	Local oView

	// Cria o objeto de View
	oView := FWFormView():New()

	// Define qual o Modelo de dados será utilizado
	oView:SetModel( oModel )

	//Adiciona enchoice
	oView:AddField( 'VIEW_Z02', oStruZ02, 'Z02MASTER' )

	// Cria objeto de tela
	oView:CreateHorizontalBox( 'SUPZ02', 100)

	//Fecha a tela após finalizar a inclusão
	oView:SetCloseOnOk( { ||.T. } )

Return(oView)

/*/{Protheus.doc} User Function AFIN002A
@description Função de geração de sequencial Identificador de depósito
@type  Function
@author Raphael Ferreira - OFicina5
@since 17/12/2021
@version version
/*/
User Function AFIN002A()

	Local cRet      := ""
	Local cNumAtual := ""
	Local cProxNum  := 0

	If Select("TMPZ02") > 0
		TMPZ02->(DbCloseArea())
	EndIf

	BeginSql Alias "TMPZ02"
        SELECT MAX(Z02_CODID) Z02_CODID
        FROM %TABLE:Z02% Z02
        WHERE Z02.%NotDel%      
        AND Z02_FILIAL = %Exp:xFilial("Z02")%  
	EndSql

	If Empty(TMPZ02->Z02_CODID)
		cNumAtual := "000000001"
	Else
		cNumAtual := SubStr(TMPZ02->Z02_CODID, 1, Len(TMPZ02->Z02_CODID) - 1)
	EndIf

	TMPZ02->(DbCloseArea())

	cProxNum:= Soma1(cNumAtual)

	cRet    := cProxNum + Mod10D(cProxNum)

Return(cRet)

/*/{Protheus.doc} AFIN002B
@description Função executada ao finalizar a gravação do modelo
@type  Static Function
@author Raphael Ferreira - Oficina5
@since 17/12/2021
@version version
/*/
Static Function AFIN002B(oModel)

	Local lRet          := .T.
	Local nOperation    := oModel:GetOperation() // nOperation == 3 'Inclusão'    4 'Alteração'   5 'Exclusão'

	If nOperation := 3
		If M->Z02_RA == "S"
			oModel:LoadValue( 'Z02MASTER', 'Z02_STATUS', "A" )
			FWFormCommit( oModel )
		Else
			If AFIN002C(oModel)
				FWFormCommit( oModel )
			Else
				lRet := .F.
				Help(NIL, NIL, "AFIN002C", NIL, "Nenhum título encontrado para o cliente selecionado", 1, 0, NIL, NIL, NIL, NIL, NIL, {"Selecione um cliente com títulos em aberto!"})
			EndIf
		EndIf

	EndIf

	//

Return(lRet)

/*/{Protheus.doc} AFIN002C
description
@type function
@version  
@author oficina5
@since 20/12/2021
@param oModel, object, param_description
@return variant, return_description
/*/
Static Function AFIN002C(oModel)

	local oDialog   := Nil
	Local oPanel    := Nil
	Local aTitulos  := {}
	Local nOpc      := 2
	Local bEnd      := {|| nOpc := 0, oDialog:DeActivate() }
	Local bOk       := {|| nOpc := 1, oDialog:DeActivate() }
	Local lRet      := .T.

	Private oBrowseTit  := Nil
	Private lMarker     := .T.

	aTitulos := BuscaSE1()

	If Len(aTitulos) > 0
		oDialog := FWDialogModal():New()
		oDialog:SetBackground( .T. )
		oDialog:SetTitle('Seleção de títulos para depósito identificado')
		oDialog:SetEscClose(.T.)
		oDialog:SetSize( 300, 500 )
		oDialog:EnableFormBar(.T.)
		oDialog:CreateDialog()
		oDialog:CreateFormBar()
		oDialog:AddButton( "OK"        ,bOk         ,"OK"        ,, .T., .F., .T., )
		oDialog:AddButton( "Fechar"    ,bEnd        ,"Fechar"    ,, .T., .F., .T., )
		oPanel := oDialog:GetPanelMain()

		oBrowseTit := FWBrowse():New(oPanel)
		oBrowseTit:setDataArray()
		oBrowseTit:setArray( aTitulos )
		oBrowseTit:disableConfig()
		oBrowseTit:disableReport()
		oBrowseTit:SetLocate()

		//Cria o Mark Column
		oBrowseTit:AddMarkColumns({|| IIf(aTitulos[oBrowseTit:nAt,01], "LBOK", "LBNO")},;
			{|| SelectOne(oBrowseTit, aTitulos)},;
			{|| SelectAll(oBrowseTit, 01, aTitulos) })

		oBrowseTit:AddColumn({"Filial"		, {|| aTitulos[oBrowseTit:nAt,02]}				,"C",X3Picture("E1_FILIAL")     ,"CENTER",TamSx3("E1_FILIAL")[1]     , ,.T.,,,,,,,,})
		oBrowseTit:AddColumn({"Prefixo"		, {|| aTitulos[oBrowseTit:nAt,03]}				,"C",X3Picture("E1_PREFIXO")    ,"LEFT"  ,TamSx3("E1_PREFIXO")[1]    , ,.T.,,,,,,,,})
		oBrowseTit:AddColumn({"Número"		, {|| aTitulos[oBrowseTit:nAt,04]}				,"C",X3Picture("E1_NUM")        ,"CENTER",TamSx3("E1_NUM")[1]        , ,.T.,,,,,,,,})
		oBrowseTit:AddColumn({"Parcela"		, {|| aTitulos[oBrowseTit:nAt,05]}				,"C",X3Picture("E1_PARCELA")    ,"CENTER",TamSx3("E1_PARCELA")[1]    , ,.T.,,,,,,,,})
		oBrowseTit:AddColumn({"Tipo" 		, {|| aTitulos[oBrowseTit:nAt,06]}				,"C",X3Picture("E1_TIPO")       ,"LEFT"  ,TamSx3("E1_TIPO")[1]       , ,.T.,,,,,,,,})
		oBrowseTit:AddColumn({"Natureza" 	, {|| aTitulos[oBrowseTit:nAt,07]}				,"C",X3Picture("E1_NATUREZ")    ,"LEFT"  ,TamSx3("E1_NATUREZ")[1]    , ,.T.,,,,,,,,})
		oBrowseTit:AddColumn({"Cod. Cliente", {|| aTitulos[oBrowseTit:nAt,08]}				,"C",X3Picture("E1_CLIENTE")    ,"LEFT"  ,TamSx3("E1_CLIENTE")[1]    , ,.T.,,,,,,,,})
		oBrowseTit:AddColumn({"Loja" 		, {|| aTitulos[oBrowseTit:nAt,09]}				,"C",X3Picture("E1_LOJA")       ,"LEFT"  ,TamSx3("E1_LOJA")[1]       , ,.T.,,,,,,,,})
		oBrowseTit:AddColumn({"Cliente" 	, {|| aTitulos[oBrowseTit:nAt,10]}				,"C",X3Picture("E1_NOMCLI")     ,"LEFT"  ,TamSx3("E1_NOMCLI")[1]     , ,.T.,,,,,,,,})
		oBrowseTit:AddColumn({"Dt. Emissao" , {|| aTitulos[oBrowseTit:nAt,11]}				,"C",                           ,"LEFT"  ,08                         , ,.T.,,,,,,,,})
		oBrowseTit:AddColumn({"Venc. Real" 	, {|| aTitulos[oBrowseTit:nAt,12]}				,"C",                           ,"LEFT"  ,08                         , ,.T.,,,,,,,,})
		oBrowseTit:AddColumn({"Saldo" 		, {|| aTitulos[oBrowseTit:nAt,13]}              ,"N",PesqPict("SE1","E1_SALDO") ,"CENTER",TamSx3("E1_SALDO")[1]		 ,2,.T.,,,,,,,,})

		oBrowseTit:setEditCell( .F. )
		oBrowseTit:acolumns[01]:lEdit     	:= .T.

		oBrowseTit:Activate(.T.)
		oDialog:Activate(,,,.T.)

		FreeObj(oDialog)

		oBrowseTit:Destroy()
		FreeObj(oBrowseTit)

	Else
		lRet := .F.

	EndIf

	If nOpc == 0
		lRet := .F.
		Help(NIL, NIL, "AFIN002C", NIL, "Nenhum título selecionado", 1, 0, NIL, NIL, NIL, NIL, NIL, {"Selecione pelo menos um título!"})
	Else
		oModel:LoadValue( 'Z02MASTER', 'Z02_STATUS', "F" )
		AFIN002D(aTitulos)
	EndIf

Return(lRet)

/*/{Protheus.doc} AFIN002D
description
@type function
@version  
@author oficina5
@since 18/12/2021
@param _aTitulos, variant, param_description
@return variant, return_description
/*/
Static Function AFIN002D(_aTitulos)

	Local aTitulos  := _aTitulos
	Local nI        := 0

	For nI:=1 To Len(aTitulos)

		If aTitulos[nI][1]
			DbSelectArea("SE1")
			DbGoTo(aTitulos[nI][Len(aTitulos[nI])])
			Reclock("SE1", .F.)
			SE1->E1_XIDENT  := M->Z02_CODID
			MsUnlock()
		EndIf

	Next nI

Return

/*/{Protheus.doc} AFIN002E
@description Função de cancelamento do Código identificador de depósito
@type function
@version  
@author oficina5
@since 20/12/2021
@return variant, return_description
/*/
Static Function AFIN002E()

	Local aArea     := GetArea()

	If Z02->Z02_STATUS == "F"
		If MsgYesNo("Esse registro está ligado a um ou mais Títulos a Receber. Deseja continuar?")

			BeginSql Alias "TMPSE1"
                SELECT R_E_C_N_O_ RECSE1
                FROM %TABLE:SE1% SE1
                WHERE SE1.%NotDel%
                AND SE1.E1_XIDENT = %Exp:Z02->Z02_CODID%
			EndSql

			While TMPSE1->(!Eof())
				DbSelectArea("SE1")
				DbGoTo(TMPSE1->RECSE1)
				Reclock("SE1", .F.)
				SE1->E1_XIDENT = ""
				MsUnlock()
				TMPSE1->(DbSkip())
			EndDo

			Reclock("Z02", .F.)
			Z02->Z02_STATUS = "C"
			MsUnlock()

		EndIf

	ElseIf Z02->Z02_STATUS == "A"
		Reclock("Z02", .F.)
		Z02->Z02_STATUS = "C"
		MsUnlock()
	Else
		MsgAlert("O registro já está cancelado","AFIN002E")
	EndIf

	RestArea(aArea)

Return

/*/{Protheus.doc} AFIN002F
description
@type function
@version  
@author oficina5
@since 20/12/2021
@return variant, return_description
/*/
User Function AFIN002F()

	Local aArea     := GetArea()

	If SE1->E1_TIPO == "RA" .AND. SE1->E1_XIDENT == ""

		AFIN002G()

	EndIf

	RestArea(aArea)

Return()

/*/{Protheus.doc} AFIN002G
description
@type function
@version  
@author oficina5
@since 20/12/2021
@return variant, return_description
/*/
Static Function AFIN002G()

	local oDialog   := Nil
	Local oPanel    := Nil
	Local aTitulos  := {}
	Local nOpc      := 2
	Local bEnd      := {|| nOpc := 0, oDialog:DeActivate() }
	Local bOk       := {|| nOpc := 1, oDialog:DeActivate() }
	Local lRet      := .T.

	Private oBrowseZ02  := Nil

	aTitulos := BuscaZ02()

	If Len(aTitulos) > 0
		oDialog := FWDialogModal():New()
		oDialog:SetBackground( .T. )
		oDialog:SetTitle('Seleção de depósito identificado')
		oDialog:SetEscClose(.T.)
		oDialog:SetSize( 300, 500 )
		oDialog:EnableFormBar(.T.)
		oDialog:CreateDialog()
		oDialog:CreateFormBar()
		oDialog:AddButton( "OK"        ,bOk         ,"OK"        ,, .T., .F., .T., )
		oDialog:AddButton( "Fechar"    ,bEnd        ,"Fechar"    ,, .T., .F., .T., )
		oPanel := oDialog:GetPanelMain()

		oBrowseTit := FWBrowse():New(oPanel)
		oBrowseTit:setDataArray()
		oBrowseTit:setArray( aTitulos )
		oBrowseTit:disableConfig()
		oBrowseTit:disableReport()
		oBrowseTit:SetLocate()

		//Cria o Mark Column
		oBrowseTit:AddMarkColumns({|| IIf(aTitulos[oBrowseTit:nAt,01], "LBOK", "LBNO")},;
			{|| SelectOne(oBrowseTit, aTitulos)},;
			{|| SelectAll(oBrowseTit, 01, aTitulos) })

		oBrowseTit:AddColumn({"Filial"		, {|| aTitulos[oBrowseTit:nAt,02]}				,"C",X3Picture("E1_FILIAL")     ,"CENTER",TamSx3("E1_FILIAL")[1]     , ,.T.,,,,,,,,})
		oBrowseTit:AddColumn({"Prefixo"		, {|| aTitulos[oBrowseTit:nAt,03]}				,"C",X3Picture("E1_PREFIXO")    ,"LEFT"  ,TamSx3("E1_PREFIXO")[1]    , ,.T.,,,,,,,,})
		oBrowseTit:AddColumn({"Número"		, {|| aTitulos[oBrowseTit:nAt,04]}				,"C",X3Picture("E1_NUM")        ,"CENTER",TamSx3("E1_NUM")[1]        , ,.T.,,,,,,,,})
		oBrowseTit:AddColumn({"Parcela"		, {|| aTitulos[oBrowseTit:nAt,05]}				,"C",X3Picture("E1_PARCELA")    ,"CENTER",TamSx3("E1_PARCELA")[1]    , ,.T.,,,,,,,,})
		oBrowseTit:AddColumn({"Tipo" 		, {|| aTitulos[oBrowseTit:nAt,06]}				,"C",X3Picture("E1_TIPO")       ,"LEFT"  ,TamSx3("E1_TIPO")[1]       , ,.T.,,,,,,,,})
		oBrowseTit:AddColumn({"Natureza" 	, {|| aTitulos[oBrowseTit:nAt,07]}				,"C",X3Picture("E1_NATUREZ")    ,"LEFT"  ,TamSx3("E1_NATUREZ")[1]    , ,.T.,,,,,,,,})
		oBrowseTit:AddColumn({"Cod. Cliente", {|| aTitulos[oBrowseTit:nAt,08]}				,"C",X3Picture("E1_CLIENTE")    ,"LEFT"  ,TamSx3("E1_CLIENTE")[1]    , ,.T.,,,,,,,,})
		oBrowseTit:AddColumn({"Loja" 		, {|| aTitulos[oBrowseTit:nAt,09]}				,"C",X3Picture("E1_LOJA")       ,"LEFT"  ,TamSx3("E1_LOJA")[1]       , ,.T.,,,,,,,,})
		oBrowseTit:AddColumn({"Cliente" 	, {|| aTitulos[oBrowseTit:nAt,10]}				,"C",X3Picture("E1_NOMCLI")     ,"LEFT"  ,TamSx3("E1_NOMCLI")[1]     , ,.T.,,,,,,,,})
		oBrowseTit:AddColumn({"Dt. Emissao" , {|| aTitulos[oBrowseTit:nAt,11]}				,"C",                           ,"LEFT"  ,08                         , ,.T.,,,,,,,,})
		oBrowseTit:AddColumn({"Venc. Real" 	, {|| aTitulos[oBrowseTit:nAt,12]}				,"C",                           ,"LEFT"  ,08                         , ,.T.,,,,,,,,})
		oBrowseTit:AddColumn({"Saldo" 		, {|| aTitulos[oBrowseTit:nAt,13]}              ,"N",PesqPict("SE1","E1_SALDO") ,"CENTER",TamSx3("E1_SALDO")[1]		 ,2,.T.,,,,,,,,})

		oBrowseTit:setEditCell( .F. )
		oBrowseTit:acolumns[01]:lEdit     	:= .T.

		oBrowseTit:Activate(.T.)
		oDialog:Activate(,,,.T.)

		FreeObj(oDialog)

		oBrowseTit:Destroy()
		FreeObj(oBrowseTit)

	Else
		lRet := .F.

	EndIf

	If nOpc == 0
		lRet := .F.
		Help(NIL, NIL, "AFIN002C", NIL, "Nenhum título selecionado", 1, 0, NIL, NIL, NIL, NIL, NIL, {"Selecione pelo menos um título!"})
	Else
		oModel:LoadValue( 'Z02MASTER', 'Z02_STATUS', "F" )
		AFIN002D(aTitulos)
	EndIf

Return(lRet)

/*/{Protheus.doc} Mod11ID
description
@type function
@version  
@author oficina5
@since 17/12/2021
@param cNumAtual, character, param_description
@return variant, return_description
/*/
Static  Function Mod11ID(_cNumAtual)
	/*----------------------------------------------------------------------------------------------------------------
	Módulo 11 - Multiplicar da direita para a esquerda, aplicando o peso de 2 até 9, até o final do número,
	reiniciando em 2 se necessário. Somar os resultados obtidos e dividi-lo por 11 (onze).
	Se o resto desta divisão for igual a 10(dez) o dígito será = 1 (um), se for igual a 0 (zero) ou  1 (um)  o digito será 0 (zero).
	Qualquer “Resto” diferente de “0,1 ou 10” subtrair o resto de 11 para obter o dígito.
	------------------------------------------------------------------------------------------------------------------*/
	Local nPeso1 	:= 2
	Local nPeso2 	:= 7
	Local nTot 		:= 0
	Local nMul 		:= nPeso1
	Local i         := 0
	Local nResult	:= 0
	Local cRet		:= ''
    Local cNumAtual := _cNumAtual

	//Executa o calculo dos valores recebidos para compor o digito
	For i := 1 to Len(cNumAtual)
		nTot += Val(SubStr(cNumAtual,i,1)) * nMul
		nMul := if(nMul=nPeso2, nPeso1, nMul+1)
	Next

	//Modulo do resultado
	_nResto := Mod(nTot,11)
	nResult :=  _nResto

	//Testa se o resto esta entre 0,1 ou 10
	If(nResult == 10)
		cRet := '1'
	ElseIf (nResult == 1 .Or. nResult == 0)
		cRet := '0'
	Else
		nResult := nResult-11
		cRet := Str(abs(nResult),1)
	EndIf

Return(cRet)

/*/{Protheus.doc} Mod10D
description
@type function
@version  
@author oficina5
@since 13/06/2022
@param _cNumAtual, variant, param_description
@return variant, return_description
/*/
Static Function Mod10D(_cNumAtual)
	Local L,D,P 	:= 0
	Local B     	:= .F.
	Local cNumAtual	:= _cNumAtual

	L := Len(cNumAtual)
	B := .T.
	D := 0
	While L > 0
		P := Val(SubStr(cNumAtual, L, 1))
		If (B)
			P := P * 2
		End
		D := D + P
		L := L - 1
		B := !B
	End
	//D := 10 - (Mod(D,10))
	
	D := D % 10

	If D > 0 
		D := 10 - D
	EndIf

	D := CValToChar(D)
Return(D)

/*/{Protheus.doc} BuscaSE1
@description Função que alimenta o array de títulos para serem escolhidos
@type function
@version  
@author oficina5
@since 18/12/2021
@return variant, return_description
/*/
Static Function BuscaSE1()

	Local aRet      := {}

	If Select("TMPSE1") > 0
		TMPSE1->(DbCloseArea())
	EndIf

	BeginSql Alias "TMPSE1"
        SELECT 
            E1_FILIAL,
            E1_CLIENTE,
            E1_LOJA,
            E1_NATUREZ,
            E1_NOMCLI,
            E1_NUM,
            E1_PARCELA,
            E1_TIPO,
            E1_PORTADO,
            E1_PREFIXO,
            E1_SALDO,
            E1_EMISSAO,
            E1_VENCREA,
            R_E_C_N_O_ REC            
        FROM %TABLE:SE1% SE1
        WHERE SE1.%NotDel%
        AND SE1.E1_SALDO > 0
        AND SE1.E1_PORTADO = ''
        AND SE1.E1_CLIENTE = %Exp:M->Z02_CLIENT%
        AND SE1.E1_LOJA = %Exp:M->Z02_LOJA%
        AND SE1.E1_FILIAL = %Exp:xFilial("Z02")%
        AND SE1.E1_XIDENT = ''
	EndSql

	While TMPSE1->(!Eof())

		Aadd(aRet,{.F.,;
			TMPSE1->E1_FILIAL,;
			TMPSE1->E1_PREFIXO,;
			TMPSE1->E1_NUM,;
			TMPSE1->E1_PARCELA,;
			TMPSE1->E1_TIPO,;
			TMPSE1->E1_NATUREZ,;
			TMPSE1->E1_CLIENTE,;
			TMPSE1->E1_LOJA,;
			TMPSE1->E1_NOMCLI,;
			TMPSE1->E1_EMISSAO,;
			TMPSE1->E1_VENCREA,;
			TMPSE1->E1_SALDO,;
			TMPSE1->REC;
			})

		TMPSE1->(DbSkip())
	EndDo

	TMPSE1->(DbCloseArea())

Return(aRet)

/*/{Protheus.doc} BuscaZ02
description
@type function
@version  
@author oficina5
@since 20/12/2021
@param param_name, variant, param_description
@return variant, return_description
/*/
Static Function BuscaZ02()

	Local aRet      := {}

	If Select("TMPZ02") > 0
		TMPZ02->(DbCloseArea())
	EndIf

	BeginSql Alias "TMPZ02"
        SELECT 
            Z02_FILIAL,
            Z02_CODID,
            Z02_STATUS,
            Z02_CLIENT,
            Z02_LOJA,
            Z02_DTEMIS,
            Z02_DTPGTO,
            Z02_OBS,
            R_E_C_N_O_ REC            
        FROM %TABLE:Z02% Z02
        WHERE Z02.%NotDel%
        AND Z02.Z02_FILIAL = %Exp:xFilial("Z02")%
        AND Z02.Z02_STATUS = "A"
        AND Z02.Z02_RA = 'S'
        AND Z02.Z02_CLIENT = %Exp:SE1->E1_CLIENTE%
        AND Z02.Z02_LOJA = %Exp:SE1->E1_LOJA%
	EndSql

	While TMPZ02->(!Eof())

		Aadd(aRet,{.F.,;
			TMPZ02->Z02_FILIAL,;
			TMPZ02->Z02_CODID,;
			TMPZ02->Z02_STATUS,;
			TMPZ02->Z02_CLIENT,;
			TMPZ02->Z02_LOJA,;
			Posicione("SA1", 1, TMPZ02->Z02_CLIENT + TMPZ02->Z02_LOJA, "A1_NOME"),;
			TMPZ02->Z02_DTEMIS,;
			TMPZ02->Z02_DTPGTO,;
			TMPZ02->Z02_OBS,;
			TMPZ02->REC })

		TMPZ02->(DbSkip())
	EndDo

	TMPZ02->(DbCloseArea())

Return(aRet)

/*/{Protheus.doc} SelectOne
description
@type function
@version  
@author oficina5
@since 18/12/2021
/*/
Static Function SelectOne(oBrowse, aArquivo)

	// Local nPos  := oBrowseTit:nAt

	aArquivo[oBrowseTit:nAt,1] := !aArquivo[oBrowseTit:nAt,1]

	// oBrowseTit:GoTo(nPos)
	// oBrowseTit:oBrowse:Refresh()

Return(.T.)

/*/{Protheus.doc} SelectAll
description
@type function
@version  
@author oficina5
@since 18/12/2021
/*/
Static Function SelectAll(oBrowse, nCol, aArquivo)

	Local _ni   := 1
	//Local nPos  := oBrowseTit:nAt

	For _ni := 1 to len(aArquivo)
		aArquivo[_ni,1] := lMarker
	Next

	//oBrowse:Refresh()
	oBrowseTit:GoTop()
	oBrowseTit:oBrowse:Refresh()
	lMarker:=!lMarker

Return(.T.)
