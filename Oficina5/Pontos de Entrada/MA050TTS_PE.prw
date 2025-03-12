//-------------------------------------------------------------------
/*/{Protheus.doc} MA050TTS
@description Validações do Cadastro de Transportadoras MATA050
@author 
@since 01/01/2024
@version 1.0
@type function
/*/
//-------------------------------------------------------------------

User Function MA050TTS()

	Local nOpcao	:= 0
	Local cCodigo	:= ""

	If ExistBlock("webHookConnect")
		If INCLUI
			nOpcao	:= 3
			cCodigo	:= M->A4_COD
		ElseIf ALTERA
			nOpcao	:= 4
			cCodigo	:= SA4->A4_COD
		Else
			nOpcao	:= 5
			cCodigo	:= SA4->A4_COD
		Endif
		U_webHookConnect("SA4", nOpcao, {cCodigo})
	Endif
	
Return(.T.)
