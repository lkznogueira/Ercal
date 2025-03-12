#Include "TOTVS.ch"

/*/{Protheus.doc} User Function zExe242
   Exemplo de consumo de REST usando FWRest
   @type  Function
   @author Atilio
   @since 20/02/2023
   @see https://tdn.totvs.com/display/public/framework/FWRest
*/

/*
   Consumindo API da Receita Federal para consulta de CNPJ
*/

User Function vAlcnpj()
    Local aArea         := FWGetArea()
    Local aHeader       := {}    
    Local oRestClient   := FWRest():New("https://www.receitaws.com.br/v1/cnpj/")
    Local cCNPJ := " "
    Local cSituacao := " "
    Local oJson
    
    If AllTrim(SA1->A1_PESSOA) == "J"
        cCNPJ := SA1->A1_CGC
    Else
        Alert("CONSULTA VÁLIDA APENAS PARA CNPJ")
        Return()
    EndIf
    
    // Adiciona os headers necessários para a requisição
    aAdd(aHeader, 'User-Agent: Mozilla/4.0 (compatible; Protheus ' + GetBuild() + ')')
    aAdd(aHeader, 'Content-Type: application/json; charset=utf-8')
    
    // Define a URL completa para o CNPJ e aciona o método GET
    oRestClient:setPath(cCNPJ)
    
    If oRestClient:Get(aHeader)
        // Cria o objeto JSON a partir da resposta
        oJson := JSonObject():New()
        If (oJson:FromJson(oRestClient:cResult) )== NIL
            cSituacao := oJson["situacao"]
            If cSituacao <> "ATIVA"             
                if MsgYesNo("Cliente com situação Juntos a RECEITA "+ cSituacao+", Deseja Bloquear?", "CLIENTE")
					RecLock("SA1",.F.)
			        SA1->A1_MSBLQL := '1'
			        SA1->(MsUnlock())
				Endif
                //Return()
            Else    
                MsgInfo("Situação da empresa: " + cSituacao)
            EndIf
        Else
            Alert("Erro ao converter JSON.")
            //Return()
        EndIf
        FreeObj(oJson)
    Else
        // Captura e exibe os erros da requisição
        cLastError := oRestClient:GetLastError()
        cErrorDetail := oRestClient:GetResult()
        Alert("Erro ao consumir a API: " + cErrorDetail)
    Endif

    FWRestArea(aArea)
Return
