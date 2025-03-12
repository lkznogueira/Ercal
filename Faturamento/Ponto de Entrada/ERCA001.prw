#INCLUDE "protheus.ch"
#INCLUDE "topconn.ch"
#INCLUDE "rwmake.ch"
#INCLUDE "tbiconn.ch"
#INCLUDE "ap5mail.ch"
//sistema de gravacao pedido de venda para supra massa vindo app vendas
//Carlos Daniel
#DEFINE CRLF CHR(13) + CHR(10)

User Function ERCA001()

	Local nKeyPed	:= ""
	Local cLinha	:= ""
	Local aCabec	:= {}
	Local aItem		:= {}
	Local aItens	:= {}
	Local cErro		:= ""
	
	Local cQuery	:= ""
	Local cAlias	:= GetNextAlias()
	
	Private lMsErroAuto		:= .F.
	//Private lAutoErrNoFile	:= .T.
	
	RpcClearEnv()
	RpcSetType( 3 )
	RpcSetEnv( "02", "4207" )
	
	Conout( "INICIO SCHEDULE - INTEGRACAO PEDIDO DE VENDA - " + DTOC( Date() ) + " - " + Time() )
	
	cQuery := " SELECT * " + CRLF
	cQuery += "		FROM USER_FORCA_VENDAS.TBL_PEDIDO CAB " + CRLF
	cQuery += "		LEFT JOIN USER_FORCA_VENDAS.TBL_ITEM_PEDIDO ITEM " + CRLF
	cQuery += "			ON ITEM.CD_PEDIDO_AFV = CAB.CD_PEDIDO_AFV " + CRLF
	cQuery += "		WHERE FL_IMPORTADO_ERP = 0 " + CRLF
	cQuery += "		ORDER BY CAB.CD_PEDIDO_AFV "
	
	DBUseArea( .T., "TOPCONN", TCGenQry( ,, cQuery ), cAlias, .T., .T. )
	
	While !(cAlias)->( Eof() )
	
		nKeyPed := (cAlias)->CD_PEDIDO_AFV
		cLinha	:= "01"
		aItens	:= {}
		
		aCabec := { { "C5_TIPO"		, "N"		   		   				, Nil },;
					{ "C5_CLIENTE"	, (cAlias)->CD_CLIENTE 				, Nil },;
					{ "C5_LOJACLI"	, (cAlias)->CD_LOJA	   				, Nil },;
					{ "C5_CONDPAG"	, (cAlias)->CD_CONDICAO_PAGAMENTO	, Nil },;
					{ "C5_VEND1"	, (cAlias)->CD_VENDEDOR				, Nil },;
					{ "C5_COMIS1"	, (cAlias)->PC_COMISSAO				, Nil },;
					{ "C5_FECENT"	, Date()							, Nil },;
					{ "C5_NATUREZ"	, "01010102"						, Nil } }
		
		While !(cAlias)->( Eof() ) .And. (cAlias)->CD_PEDIDO_AFV == nKeyPed
		   IF (cAlias)->CD_TABELA == '000010'
		   		aItem := { { "C6_ITEM"		, cLinha	   		   								, Nil },;
					   		{ "C6_PRODUTO"	, (cAlias)->CD_PRODUTO 								, Nil },;
					   		{ "C6_QTDVEN"	, (cAlias)->QT_VENDIDA 								, Nil },;
					   		{ "C6_PRCVEN"	, (cAlias)->VL_PRECO								, Nil },;
					   		{ "C6_VALOR"	, Round( (cAlias)->( QT_VENDIDA * VL_PRECO ), 2 )	, Nil },; 
					   		{ "C6_TES"		, "74"				   						   		, Nil },;
					   		{ "C6_ENTREG"	, Date()											, Nil } }
		   ELSE 
				aItem := { { "C6_ITEM"		, cLinha	   		   								, Nil },;
					   		{ "C6_PRODUTO"	, (cAlias)->CD_PRODUTO 								, Nil },;
					   		{ "C6_QTDVEN"	, (cAlias)->QT_VENDIDA 								, Nil },;
					   		{ "C6_PRCVEN"	, (cAlias)->VL_PRECO								, Nil },;
					   		{ "C6_VALOR"	, Round( (cAlias)->( QT_VENDIDA * VL_PRECO ), 2 )	, Nil },; 
					   		{ "C6_OPER"		, "50"				   								, Nil },;
					   		{ "C6_ENTREG"	, Date()											, Nil } }
			ENDIF
			aAdd( aItens, aClone( aItem ) )
			
			cLinha := Soma1( cLinha )
			
			(cAlias)->( DbSkip() )
		
		EndDo
		
		Begin Transaction
		
			lMsErroAuto := .F.
			
			MSExecAuto( { |x,y,z| MATA410(x,y,z) }, aCabec, aItens, 3 )
			If lMsErroAuto
				MostraErro()
			ENdIf
			
			If !lMsErroAuto
			
				cQuery := " UPDATE USER_FORCA_VENDAS.TBL_PEDIDO " + CRLF
				cQuery += "		SET FL_IMPORTADO_ERP = 1, " + CRLF
				cQuery += "			DT_IMPORTACAO_ERP = TO_DATE( '" + DTOS( Date() ) + "', 'yyyymmdd' ), " + CRLF
				cQuery += "			DS_MSG_IMPORTACAO_ERP = 'Importado com sucesso' " + CRLF
				cQuery += "		WHERE CD_PEDIDO_AFV = '" + cValToChar( nKeyPed ) + "' "
				
				If TCSqlExec( cQuery ) < 0
					cErro := TCSQLError()
				EndIf
			
			Else
				aEval( GetAutoGRLog(), { |x| cErro += x + "<BR />" } )
			EndIf
		
		End Transaction
		
		If !Empty( cErro )
		
			cQuery := " UPDATE USER_FORCA_VENDAS.TBL_PEDIDO " + CRLF
			cQuery += "		SET FL_IMPORTADO_ERP = 2, " + CRLF
			cQuery += "			DT_IMPORTACAO_ERP = TO_DATE( '" + DTOS( Date() ) + "', 'yyyymmdd' ), " + CRLF
			cQuery += "			DS_MSG_IMPORTACAO_ERP = 'Erro ao importar' " + CRLF
			cQuery += "		WHERE CD_PEDIDO_AFV = '" + cValToChar( nKeyPed ) + "' "
			
			If TCSqlExec( cQuery ) < 0
				cErro := TCSQLError()
			EndIf
			
			Conout( StrTran( cErro, "<BR />", CRLF ) )
			
			fEnvMail( nKeyPed, cErro )
		EndIf
	
	EndDo
	
	If Select( cAlias ) > 0
		(cAlias)->( DBCloseArea() )
	EndIf
	
	Conout( "FIM SCHEDULE - INTEGRACAO PEDIDO DE VENDA - " + DTOC( Date() ) + " - " + Time() )

Return

Static Function fEnvMail( nKeyPed, cErro )

	Local cServer	:= GetMv("MV_RELSERV")	// Nome do Servidor de Envio de E-mail utilizado nos relatorios
	Local cAccount	:= GetMv("MV_RELACNT")	// Conta a ser utilizada no envio de E-Mail para os relatorios
	Local cFrom		:= GetMv("MV_RELFROM")	// E-mail utilizado no campo FROM no envio de relatorios por e-mail
	Local cPassword	:= GetMv("MV_RELPSW")	// Senha da Conta de E-Mail para envio de relatorios
	Local lAuth		:= GetMv("MV_RELAUTH")	// Servidor de EMAIL necessita de Autenticacao?
	Local cMailTo	:= GetMv("MV_XMAILER")	// Destinatario
	
	Local cSubject	:= "[ERROS] Importação de PV nº " + cValToChar( nKeyPed )
	
	CONNECT SMTP SERVER cServer ACCOUNT cAccount PASSWORD cPassword RESULT lConectou
	
	If lConectou
	
		If lAuth
		
			If MailAuth( cAccount, cPassword )
			
				SEND MAIL FROM cFrom TO cMailTo SUBJECT cSubject BODY fHTMLBody( nKeyPed, cErro ) RESULT lEnviado
				
				If lEnviado
					ConOut( "E-mail enviado!" )
				Else
					ConOut( "Falha durante o envio do e-mail!" )
				EndIf
			
			Else
				ConOut( "Falha durante a autenticacao!" )
			EndIf
		
		EndIf
		
		DISCONNECT SMTP SERVER RESULT lDesconectou
	
	Else
		ConOut( "Falha ao conectar no servidor de e-mail!" )
	EndIf

Return

Static Function fHTMLBody( nKeyPed, cErro )

	Local cHTML	:= ""
	
	cHTML := "<HTML>"
	cHTML += "	<HEAD>"
	cHTML += "		<TITLE>Erros de Importação</TITLE>"
	cHTML += "	</HEAD>"
	cHTML += "	<BODY>"
	cHTML += "Prezados,<BR />"
	cHTML += "<BR />"
	cHTML += "Segue abaixo os erros encontrados durante a integração do PV nº " + cValToChar( nKeyPed ) + "<BR />"
	cHTML += "<BR />"
	cHTML += cErro
	cHTML += "	</BODY>"
	cHTML += "</HTML>"

Return cHTML
