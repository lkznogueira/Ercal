#INCLUDE "protheus.ch"
#INCLUDE "topconn.ch"
#INCLUDE "rwmake.ch"
#INCLUDE "tbiconn.ch"
#INCLUDE "ap5mail.ch"
//envio email com base inclusao de contrato parceria
//Carlos Daniel
#DEFINE CRLF CHR(13) + CHR(10)

User Function wfctr()
	Local cSelEmpresa 	:= cEmpAnt//"01"
	Local cSelFilial	:= cFilAnt//"0101"

	Local nKeyPed	:= ""
	Local cMsg		:= ""
	
	Local cQuery	:= ""
	Local cAlias	:= GetNextAlias()
	
	Private lMsErroAuto		:= .F.
    Private lEncerOk := .F.
	//Private lAutoErrNoFile	:= .T.
	
    If Funname() == "RPC" .Or. Funname() == space(8)

		Private	bPrepAmb := {||  RpcSetType( 3 ), RpcSetEnv( cSelEmpresa, cSelFilial,,,"FAT") }

		LJMsgRun("Preparando o ambiente ...","Aguarde...",bPrepAmb)

		__cInterNet := NIL

	Endif

	//RpcClearEnv()
	//RpcSetType( 3 )
	//RpcSetEnv( "02", "4207" )
	
	Conout( "INICIO SCHEDULE - ANALISANDO CONTRATOS NOVOS - " + DTOC( Date() ) + " - " + Time() )
	
	cQuery := " SELECT * FROM "+RetSqlName("ADA")+" ADA " + CRLF
	cQuery += "	WHERE ADA.D_E_L_E_T_ != '*' " + CRLF
	cQuery += "	AND ADA_XEMAIL = ' ' "
	
	DBUseArea( .T., "TOPCONN", TCGenQry( ,, cQuery ), cAlias, .T., .T. )
	
	While !(cAlias)->( Eof() )
	
		nKeyPed := (cAlias)->ADA_NUMCTR

        dbSelectArea("ADA")
	    ADA->(dbSetOrder(1))
	    ADA->(dbSeek(xFilial("ADA")+nKeyPed))
        cMsg := "[CONTRATO] " + cValToChar( nKeyPed )+" [FILIAL] "+cSelFilial
        //ENVIA EMAIL
	    fEnvMail( nKeyPed, cMsg, lEncerOk )	
        // verifica se email foi aprovado
        //lEncerOk := .T.
        Begin Transaction
	        If lEncerOk
		        RecLock("ADA")
		        ADA->ADA_XEMAIL := "S"
		        MsUnLock()
            Else
                RecLock("ADA")
		        ADA->ADA_XEMAIL := "N"
		        MsUnLock()
	        EndIf
        End Transaction	
				
	EndDo
	
	If Select( cAlias ) > 0
		(cAlias)->( DBCloseArea() )
	EndIf
	
	Conout( "FIM SCHEDULE - CONTRATOS NOVOS INCLUSOS - " + DTOC( Date() ) + " - " + Time() )

Return

Static Function fEnvMail( nKeyPed, cMsg, lEncerOk )

	Local cServer	:= GetMv("MV_RELSERV")	// Nome do Servidor de Envio de E-mail utilizado nos relatorios
	Local cAccount	:= GetMv("MV_RELACNT")	// Conta a ser utilizada no envio de E-Mail para os relatorios
	Local cFrom		:= "carlosds@ercal.com.br"//GetMv("MV_RELFROM")	// E-mail utilizado no campo FROM no envio de relatorios por e-mail
	Local cPassword	:= GetMv("MV_RELPSW")	// Senha da Conta de E-Mail para envio de relatorios
	Local lAuth		:= GetMv("MV_RELAUTH")	// Servidor de EMAIL necessita de Autenticacao?
	Local cMailTo	:= GetMv("MV_XMAILER")	// Destinatario
	
	Local cSubject	:= "[INCLUSAO] Foi incluido um novo contrato de nº " + cValToChar( nKeyPed )
	//Local lEncerOk := .F.

	CONNECT SMTP SERVER cServer ACCOUNT cAccount PASSWORD cPassword RESULT lConectou
	
	If lConectou
	
		If lAuth
		
			If MailAuth( cAccount, cPassword )
			
				SEND MAIL FROM cFrom TO cMailTo SUBJECT cSubject BODY fHTMLBody( nKeyPed, cMsg ) RESULT lEnviado
				
				If lEnviado
					ConOut( "E-mail enviado!" )
                    lEncerOk := .T.
				Else
					ConOut( "Falha durante o envio do e-mail!" )
                    lEncerOk := .F.
				EndIf
			
			Else
				ConOut( "Falha durante a autenticacao!" )
                lEncerOk := .F.
			EndIf
		
		EndIf
		
		DISCONNECT SMTP SERVER RESULT lDesconectou
	
	Else
		ConOut( "Falha ao conectar no servidor de e-mail!" )
        lEncerOk := .F.
	EndIf

Return

Static Function fHTMLBody( nKeyPed, cMsg )

	Local cHTML	:= ""
	
	cHTML := "<HTML>"
	cHTML += "	<HEAD>"
	cHTML += "		<TITLE>Contrato Novo Incluido</TITLE>"
	cHTML += "	</HEAD>"
	cHTML += "	<BODY>"
	cHTML += "Prezados,<BR />"
	cHTML += "<BR />"
	cHTML += "Foi incluido um novo Contrato no sistema nº " + cValToChar( nKeyPed ) + "<BR />"
	cHTML += "<BR />"
	cHTML += cMsg
	cHTML += "	</BODY>"
	cHTML += "</HTML>"

Return cHTML
