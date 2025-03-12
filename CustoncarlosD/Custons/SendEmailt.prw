user function SendEmailt() 

Local cUser := "", cPass := "", cSendSrv := ""
Local cMsg := ""
Local nSendPort := 0, nSendSec := 1, nTimeout := 0
Local xRet
Local oServer, oMessage  
Private cPerg      := "Email1"

PutSX1(cPerg , "01" , "Email Envio          " , "" , "" , "mv_ch1" , "C" , 30 , 0 , 0 , "G" , "", "", "", "", "mv_par01" , "        " ,"","","", "        " ,"","","", "        " , "" , "" , "" , "" , "" , "" , "" , "" )
PutSX1(cPerg , "02" , "Senha                " , "" , "" , "mv_ch2" , "C" , 30 , 0 , 0 , "G" , "", "", "", "", "mv_par02" , "        " ,"","","", "   	  " ,"","","", "        " , "" , "" , "" , "" , "" , "" , "" , "" )
PutSX1(cPerg , "03" , "De                   " , "" , "" , "mv_ch3" , "C" , 30 , 0 , 0 , "G" , "", "", "", "", "mv_par03" , "        " ,"","","", "        " ,"","","", "        " , "" , "" , "" , "" , "" , "" , "" , "" )
PutSX1(cPerg , "04" , "Para                 " , "" , "" , "mv_ch4" , "C" , 30 , 0 , 0 , "G" , "", "", "", "", "mv_par04" , "        " ,"","","", "   	  " ,"","","", "        " , "" , "" , "" , "" , "" , "" , "" , "" )
PutSX1(cPerg , "05" , "Porta SMTP           " , "" , "" , "mv_ch5" , "N" , 3  , 0 , 0 , "G" , "", "", "", "", "mv_par05" , "        " ,"","","", "        " ,"","","", "        " , "" , "" , "" , "" , "" , "" , "" , "" )
PutSX1(cPerg , "06" , "Servidor SMTP        " , "" , "" , "mv_ch6" , "C" , 30 , 0 , 0 , "G" , "", "", "", "", "mv_par06" , "        " ,"","","", "   	  " ,"","","", "        " , "" , "" , "" , "" , "" , "" , "" , "" )
PutSX1(cPerg , "07" , "Assunto              " , "" , "" , "mv_ch7" , "C" , 30 , 0 , 0 , "G" , "", "", "", "", "mv_par07" , "        " ,"","","", "        " ,"","","", "        " , "" , "" , "" , "" , "" , "" , "" , "" )
PutSX1(cPerg , "08" , "Mensagem             " , "" , "" , "mv_ch8" , "C" , 99 , 0 , 0 , "G" , "", "", "", "", "mv_par08" , "        " ,"","","", "   	  " ,"","","", "        " , "" , "" , "" , "" , "" , "" , "" , "" )
PutSX1(cPerg , "09" , "Tempo Resposta       " , "" , "" , "mv_ch9" , "N" , 3  , 0 , 0 , "G" , "", "", "", "", "mv_par09" , "        " ,"","","", "        " ,"","","", "        " , "" , "" , "" , "" , "" , "" , "" , "" )


pergunte(cPerg,.T.)
   
  cUser := alltrim(mv_par01) //GetMV( "MV_RELACNT" ) 
  cPass := alltrim(mv_par02) //GetMV( "MV_RELAPSW" )
  cSendSrv := alltrim(mv_par06) // define the send server
  nTimeout := mv_par09 // define the timout to 60 seconds
   
  oServer := TMailManager():New()
   
  nSendPort := mv_par05 //default port for SMTP protocol with SSL
  oServer:SetUseSSL( .T. )
  oServer:SetUseTLS( .F. )
   
  // once it will only send messages, the receiver server will be passed as ""
  // and the receive port number won't be passed, once it is optional
  xRet := oServer:Init( "", cSendSrv, cUser, cPass, , nSendPort )
  if xRet != 0
   Alert("Não foi possível inicializar o servidor SMTP: " + oServer:GetErrorString( xRet ))
  //conout( cMsg )
  return
  endif
   
  // the method set the timout for the SMTP server
  xRet := oServer:SetSMTPTimeout( nTimeout )
  if xRet != 0
     Alert("Não foi possível configurar " + cProtocol + " tempo limite para " + cValToChar( nTimeout ))
    //conout( cMsg )
  endif
   
  // estabilish the connection with the SMTP server
  xRet := oServer:SMTPConnect()
  if xRet <> 0
     Alert("Não foi possível conectar no servidor SMTP: " + oServer:GetErrorString( xRet ))
    //conout( cMsg )
    return
  endif
   
  // authenticate on the SMTP server (if needed)
  xRet := oServer:SmtpAuth( cUser, cPass )
  if xRet <> 0
     Alert("Não foi possível autenticar no servidor SMTP: " + oServer:GetErrorString( xRet ))
    //conout( cMsg )
    oServer:SMTPDisconnect()
    return
  endif
   
  oMessage := TMailMessage():New()
  oMessage:Clear()
   
  oMessage:cDate := cValToChar( Date() )
  oMessage:cFrom := mv_par03
  oMessage:cTo := mv_par04
  oMessage:cSubject := mv_par07
  oMessage:cBody := mv_par08
  
  xRet := oMessage:Send( oServer )
  if xRet <> 0
     Alert("Não foi possível enviar uma mensagem: " + oServer:GetErrorString( xRet ))
    //conout( cMsg )
  endif
   
  xRet := oServer:SMTPDisconnect()
  if xRet <> 0
     Alert("Não foi possível desconectar do servidor SMTP: " + oServer:GetErrorString( xRet ))
    //conout( cMsg )
  endif     
   Alert("Mensagem enviada com sucesso: ")
return  
