//-------------------------------------------------------------------
/*/{Protheus.doc} MA040TOK
@description Validações do Cadastro de Vendedores MATA040
@author 
@since 01/01/2024
@version 1.0
@type function
/*/
//-------------------------------------------------------------------

User Function MA040TOK()

	Local nOpcao	:= 0
	Local cCodigo	:= ""

	If ExistBlock("webHookConnect")
		If FWIsInCallStack("A040Inclui")
			nOpcao	:= 3
			cCodigo	:= M->A3_COD
		ElseIf FWIsInCallStack("A040Altera")
			nOpcao	:= 4
			cCodigo	:= SA3->A3_COD
		ElseIf FWIsInCallStack("A040Exclui")
			nOpcao	:= 5
			cCodigo	:= SA3->A3_COD
		Endif
		U_webHookConnect("SA3", nOpcao, {cCodigo})
	Endif
	
Return(.T.)
