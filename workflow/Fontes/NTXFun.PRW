#Include 'Protheus.ch'
#Include 'Totvs.ch'
#Include 'AP5Mail.ch'

/*
===============================================================================================================================
Programa--------: NTSNDEML
Autor-----------: Marcos Felipe
Data da Criacao-: 05/01/2015
===============================================================================================================================
Descrição-------: Rotina para processar envio de e-mail
===============================================================================================================================
Parametros------: cAccount  - conta de e-mail que será utilizada para envio
----------------: cPassword - senha da conta de e-mail
----------------: cServer   - endereço do servidor do serviço de e-mail
----------------: cFrom     - conta de e-mail que será o remetente da mensagem
----------------: cEmail    - conta de e-mail de destino do e-mail
----------------: cAssunto  - assunto que será configurado no e-mail
----------------: cMensagem - mensagem a ser enviada no corpo do e-mail
----------------: cAttach   - anexos a serem enviados com o e-mail
----------------: lMsg      - define se serão registradas mensagens no console.log do serviço
----------------: cLog      - variável para gravação do log do processamento
----------------: lAuth     - identifica se o servidor requer autenticação para envio do e-mail
===============================================================================================================================
Retorno---------: Lógico - Identifica se o e-mail foi enviado com sucessoo
===============================================================================================================================
*/

User Function NTSNDEML( cAccount , cPassword , cServer , cFrom , cEmail , cAssunto , cMensagem , cAttach , lMsg , cLog , lAuth )

Local cEmailTo	:= ""
Local cEmailCc	:= ""
Local lResult	:= .F.
Local cError	:= ""
Local cUser		:= ""
Local nAt		:= ""
Local cFromGe 	:= AllTrim( GetMV( "MV_ACEMAIL" ,, "" ) )

Default cAccount	:= GetMV( "MV_RELACNT" )
Default cPassword	:= GetMV( "MV_RELPSW"  )
Default cServer		:= GetMV( "MV_RELSERV" )
Default cFrom		:= GetMV( "MV_RELFROM" )
Default cEmail		:= ''
Default cAssunto	:= ''
Default cMensagem	:= ''
Default cAttach		:= ''
Default lMsg		:= .T.
Default cLog		:= ""
Default lAuth		:= GetMv( "MV_RELAUTH" ,, .F. )

//----------------------------------------------------------------------------------------------------
// Verifica se serao utilizados os valores padrao
//----------------------------------------------------------------------------------------------------
cAccount	:= IIf( Empty( cAccount  ) , GetMV( "MV_RELACNT" )														, cAccount  )
cPassword	:= IIf( Empty( cPassword ) , GetMV( "MV_RELPSW"  )														, cPassword )
cServer		:= IIf( Empty( cServer   ) , GetMV( "MV_RELSERV" )														, cServer   )
cAttach 	:= IIf( Empty( cAttach   ) , ""																			, cAttach   )
cFrom		:= IIf( Empty( cFrom     ) , Iif( Empty( GetMV( "MV_RELFROM" ) ) , cAccount , GetMV( "MV_RELFROM" ) )	, cFrom     )

//----------------------------------------------------------------------------------------------------
// Verifica se esta utilizando o email do parametro global
//----------------------------------------------------------------------------------------------------
If !EMPTY( cFromGe )

	If Alltrim(cFrom) == Alltrim( GetMV( "MV_RELACNT" ) ) .or. Alltrim(cFrom) == Alltrim( GetMV( "MV_RELFROM" ) )
		cFrom := cFromGe
	EndIf
	
EndIf


//----------------------------------------------------------------------------------------------------
// Envia o e-mail para a lista selecionada. Envia como CC
//----------------------------------------------------------------------------------------------------
cEmailTo := SubStr( cEmail , 1							, At( Chr(59) , cEmail ) - 1	)
cEmailCc := SubStr( cEmail , At( Chr(59) , cEmail ) + 1	, Len( cEmail )					)

CONNECT SMTP SERVER cServer ACCOUNT cAccount PASSWORD cPassword RESULT lResult

//----------------------------------------------------------------------------------------------------
// Verifica se o Servidor de EMAIL necessita de Autenticacao
//----------------------------------------------------------------------------------------------------
If lResult .and. lAuth

	lResult := MailAuth( cAccount , cPassword ) // Primeiro tenta fazer a Autenticacao de E-mail utilizando o e-mail completo
	
	If !lResult // Se nao conseguiu fazer a Autenticacao usando o E-mail completo, tenta fazer a autenticacao usando apenas o nome de usuario do E-mail
	
		nAt 	:= At( "@" , cAccount )
		cUser 	:= If( nAt > 0 , Subs( cAccount , 1 , nAt - 1 ) , cAccount )
		lResult := MailAuth( cUser , cPassword )
		
	EndIf
	
EndIf

//----------------------------------------------------------------------------------------------------
// Executa o ponto de entrada que permite ao usuario customizar a mensagem HTML a ser enviada
//----------------------------------------------------------------------------------------------------
If ExistBlock("AcaMail")
	cMensagem := ExecBlock( "AcaMail" , .F. , .F. , { FunName() , cFrom , cEmailTo , cAssunto , cMensagem , cAttach } )
EndIf

If lResult

	SEND MAIL FROM cFrom	TO      	cEmailTo ;
							CC     		cEmailCc ;
							SUBJECT 	cAssunto ;
							BODY    	cMensagem;
							ATTACHMENT  cAttach  ;
							RESULT		lResult

	If !lResult
		
		//----------------------------------------------------------------------------------------------------
		// Erro no envio do email
		//----------------------------------------------------------------------------------------------------
		GET MAIL ERROR cError
		
		If lMsg
			Conout("Erro no envio do email")
		EndIf
		
	EndIf

	DISCONNECT SMTP SERVER

Else

	//----------------------------------------------------------------------------------------------------
	// Erro na conexao com o SMTP Server
	//----------------------------------------------------------------------------------------------------
	GET MAIL ERROR cError
	
	If lMsg
		Conout("Erro na conexao com o SMTP Server")
	EndIf
	
EndIf

Return( lResult )
