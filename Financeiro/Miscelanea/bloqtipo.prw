#INCLUDE "rwmake.ch"
#INCLUDE "topconn.ch"
#INCLUDE "Protheus.ch"
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
��� Programa � bloqtipo � Autor � CARLOS DANIEL      � Data �   07/011/23  ��
�������������������������������������������������������������������������͹��
�������������������������������������������������������������������������Ĵ��
���Utilizacao� ERCAL EMPRESAS REUNIDAS - Gatilho bloqueio inclusao tipo   ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function bloqtipo()

	Local tIpo := " "
	Local cUsrAtu  := RetCodUsr()


	If FunName() == "FINA050" .or. FunName() == "FINA750"
		tIpo := TRIM(M->E2_TIPO)
		If cUsrAtu == "000175" .or. cUsrAtu == "000086"
			If tIpo == "PR" .or. tIpo == "PA"
				MsgAlert("TIPO PA E PR NAO � PERMITIDO A INCLUS�O MANUAL")
				tIpo := " "
			EndIf
		EndIf
	Elseif FunName() == "FINA040" .or. FunName() == "FINA740" .or. FunName() == "FATA400"
		tIpo := TRIM(M->E1_TIPO)
		If cUsrAtu == "000175" .or. cUsrAtu == "000086"
			If tIpo == "PR" .or. tIpo == "RA"
				MsgAlert("TIPO RA E PR NAO � PERMITIDO A INCLUS�O MANUAL")
				tIpo := " "
			EndIf
		EndIf
	EndIf

Return(tipo)
