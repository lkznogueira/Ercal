#Include "TbiConn.ch"
#Include "TbiCode.ch"
#Include "Protheus.ch"
#Include "TopConn.ch"
#Include "Totvs.ch"

/*/-------------------------------------------------------------------
- Programa: fEnvEmail
- Autor: TBC
- Data: 29/08/02
- Descrição: Funcao para enviar email
-------------------------------------------------------------------/*/

User Function fEnvEmail(cArquivo,cTitulo,cSubject,cBody,lShedule,cTo,cCC)

    Local lAutentica := .F.
    Local cServer 	 := ""
    Local cAccount 	 := ""
    Local cPassword  := ""
    Local cUserAut 	 := ""
    Local cPassAut 	 := ""
    Local nSMTPPort  := SuperGetMv("MV_PORSMTP",,"587")
    Local oMail 	 := Nil
    Local oMessage   := Nil
    Local nErro 	 := 0
    Default cArquivo := ""
    Default cTitulo  := ""
    Default cSubject := ""
    Default cBody    := ""
    Default lShedule := .F.
    Default cTo      := ""
    Default cCc      := ""

    if empty((cServer:=AllTrim(SuperGetMv("MV_RELSERV",,""))))

        if !lShedule

            MsgInfo("Nome do Servidor de Envio de E-mail nao definido no 'MV_RELSERV'")

        else

            UCLogMsg("Nome do Servidor de Envio de E-mail nao definido no 'MV_RELSERV'")

        endif

        Return(.F.)

    endif

    if empty((cAccount:=AllTrim(AllTrim(SuperGetmv("MV_RELACNT",,"")))))

        if !lShedule

            MsgInfo("Conta para acesso ao Servidor de E-mail nao definida no 'MV_RELACNT'")

        else

            UCLogMsg("Conta para acesso ao Servidor de E-mail nao definida no 'MV_RELACNT'")

        endif

        Return(.F.)

    endif

    if lShedule .AND. empty(cTo)

        if !lShedule

            UCLogMsg("E-mail para envio, nao informado.")

        endif

        Return(.F.)

    endif

    if !lShedule

        cFrom:= SuperGetmv("MV_RELACNT",,"")
        cUser:= UsrRetName(RetCodUsr())

    else

        cFrom:= SuperGetmv("MV_RELACNT",,"")
        cUser:= AllTrim(SuperGetmv("MV_WFMLBOX",,""))

    endif

    cCC  	 := cCC + Space(200)
    cTo  	 := cTo + Space(200)
    cSubject := cSubject + Space(100)

    if empty(cFrom)

        if !lShedule

            MsgInfo("E-mail do remetente nao definido no cad. do usuario: " + cUser)

        else

            UCLogMsg("E-mail do remetente nao definido no cad. do usuario: " + cUser)

        endif

        Return(.F.)

    endif

    cAttachment := cArquivo
    cPassword   := AllTrim(SuperGetmv("MV_RELPSW",,""))
    lAutentica  := SuperGetmv("MV_RELAUTH",,"")
    cUserAut    := Alltrim(SuperGetmv("MV_RELAUSR",,""))
    cPassAut    := AllTrim(SuperGetmv("MV_RELPSW",,""))

    oMail := TMailManager():New()

    if SuperGetMv("MV_RELSSL",,.F.)

        oMail:setUseSSL(.T.)

    endif

    if SuperGetMv("MV_RELTLS",,.F.)

        oMail:setUseTLS(.T.)

    endif

    if At(':',cServer)>0

        if nSMTPPort == 0

            nSMTPPort := Val(Substr(cServer,At(':',cServer)+1))

        endif

        cServer := Substr(cServer,1,At(':',cServer)-1)

    endif

    oMail:Init( '', cServer , cAccount, cPassword, 0, nSMTPPort )
    oMail:SetSmtpTimeOut( 120 )
    UCLogMsg( 'Conectando do SMTP' )
    nErro := oMail:SmtpConnect()

    if nErro <> 0

        if !lShedule

            MsgInfo("ERROR:" + oMail:GetErrorString( nErro ))

        else

            UCLogMsg( "ERROR:" + oMail:GetErrorString( nErro ) )

        endif

        oMail:SMTPDisconnect()

        Return(.F.)

    endif

    if lAutentica

        nErro := oMail:SmtpAuth( cUserAut ,cPassAut )

        if nErro <> 0

            if !lShedule

                MsgInfo("ERROR:" + oMail:GetErrorString( nErro ))

            else

                UCLogMsg( "ERROR:" + oMail:GetErrorString( nErro ) )

            endif

            oMail:SMTPDisconnect()

            Return(.F.)

        endif

    endif

    oMessage := TMailMessage():New()
    oMessage:Clear()
    oMessage:cFrom                  := cFrom
    oMessage:cTo                    := cTo
    oMessage:cCc                    := cCC
    oMessage:cSubject               := cSubject
    oMessage:cBody                  := cBody

    nErro := oMessage:Send( oMail )

    if nErro <> 0

        if !lShedule

            MsgInfo("ERROR:" + oMail:GetErrorString( nErro ))

        else

            UCLogMsg( "ERROR:" + oMail:GetErrorString( nErro ) )

        endif

        Return(.F.)

    else

        if !lShedule

            //MsgInfo("E-mail enviado com sucesso para: "+ALLTRIM(cTo))
            UCLogMsg("E-mail enviado com sucesso para: "+ALLTRIM(cTo))

        else

            UCLogMsg("E-mail enviado com sucesso para: "+ALLTRIM(cTo))

        endif

    endif

    UCLogMsg( 'Desconectando do SMTP' )

    oMail:SMTPDisconnect()

Return(.T.)

/*/-------------------------------------------------------------------
    - Programa: UCLogMsg
    - Autor: Wellington Gonçalves
    - Data: 20/05/2019
    - Descrição: Função de Log, substituição do Conout.
-------------------------------------------------------------------/*/

Static Function UCLogMsg(cMsg)

    Default cMsg := ""

    LogMsg(FunName(), 22, 5, 1, '', '', cMsg)

Return(Nil)
