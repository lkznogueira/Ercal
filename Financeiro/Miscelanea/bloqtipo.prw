#INCLUDE "rwmake.ch"
#INCLUDE "topconn.ch"
#INCLUDE "Protheus.ch"
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±º Programa ³ bloqtipo º Autor ³ CARLOS DANIEL      º Data ³   07/011/23  ±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Utilizacao³ ERCAL EMPRESAS REUNIDAS - Gatilho bloqueio inclusao tipo   ³±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function bloqtipo()

	Local tIpo := " "
	Local cUsrAtu  := RetCodUsr()


	If FunName() == "FINA050" .or. FunName() == "FINA750"
		tIpo := TRIM(M->E2_TIPO)
		If cUsrAtu == "000175" .or. cUsrAtu == "000086"
			If tIpo == "PR" .or. tIpo == "PA"
				MsgAlert("TIPO PA E PR NAO É PERMITIDO A INCLUSÃO MANUAL")
				tIpo := " "
			EndIf
		EndIf
	Elseif FunName() == "FINA040" .or. FunName() == "FINA740" .or. FunName() == "FATA400"
		tIpo := TRIM(M->E1_TIPO)
		If cUsrAtu == "000175" .or. cUsrAtu == "000086"
			If tIpo == "PR" .or. tIpo == "RA"
				MsgAlert("TIPO RA E PR NAO É PERMITIDO A INCLUSÃO MANUAL")
				tIpo := " "
			EndIf
		EndIf
	EndIf

Return(tipo)
