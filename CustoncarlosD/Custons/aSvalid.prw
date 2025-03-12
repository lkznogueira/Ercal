#include "protheus.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³aSvalid   ºAutor  ³Carlos Daniel       º Data ³  05/10/17   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ valida tipo contribuindo cadastro cliente                  º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/   
User Function aSvalid() 
Local aEst   := AllTrim(M->A1_EST)  
Local aRest  := AllTrim(M->A1_GRPTRIB) 
Local aContr := AllTrim(M->A1_CONTRIB)

If aRest == "001" .OR. aRest == "002" 
	If aEst == "MG" 
		If aContr == "1"
			If aRest # "001"  
				MsgAlert("cliente foi informado como Contribuinte o Grupo deve ser 001 favor verificar. ") 
				M->A1_GRPTRIB  := " "
	   			Return(M->A1_GRPTRIB)
			Endif
		Else 
			If aRest # "002"  
				MsgAlert("cliente foi informado como Não Contribuinte o Grupo deve ser 002 favor verificar. ")
	   			M->A1_GRPTRIB  := " "
				Return(M->A1_GRPTRIB)
			Endif
		Endif 
	Else
		MsgAlert("cliente do estado "+aEst+" o Grupo Cliente deve ser 002 ou 003 Favor Verificar ")  
		M->A1_GRPTRIB  := " "
		Return(M->A1_GRPTRIB)
	Endif
Else 
	If aEst # "MG"                                       
		If aContr == "1"
			If aRest # "003"  
				MsgAlert("cliente foi informado como Contribuinte o Grupo deve ser 003 favor verificar. ")
	   			M->A1_GRPTRIB  := " "
	   			Return(M->A1_GRPTRIB)
			Endif
		Else 
			If aRest # "004"  
				MsgAlert("cliente foi informado como Não Contribuinte o Grupo deve ser 004 favor verificar. ")
				M->A1_GRPTRIB  := " "
	   			Return(M->A1_GRPTRIB)
			Endif
		Endif 
	Else
		MsgAlert("cliente do estado "+aEst+" o Grupo Cliente deve ser 001 ou 002 Favor Verificar ") 
		M->A1_GRPTRIB  := " "
		Return(M->A1_GRPTRIB)
	EndIF
Endif
Return(aRest)