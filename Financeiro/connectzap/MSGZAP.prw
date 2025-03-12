#Include 'Protheus.ch'
#Include 'FWMVCDEF.ch'
#Include 'RestFul.CH'
#Include 'Totvs.CH'
#include "Fileio.ch"
/*
*****************************************************************************
*+-------------------------------------------------------------------------+*
*|Funcao      | MSGZAP  | Autor | Jader Berto (Connect Zap)                +*
*+------------+------------------------------------------------------------+*
*|Data        | 13.08.2019                                                 |*
*+------------+------------------------------------------------------------+*
*|Descricao   | Envio de WHATSAPP via Protheus					 		               |*
*+------------+------------------------------------------------------------+*
*|Partida     | Qualquer programa										                       |*
*|            | 				 	 	                                               |*
*+------------+------------------------------------------------------------+*
*| OBS.: NÃO RECOMENDAMOS A ALTERAÇÃO DOS PROGRAMAS.                       |*
*+-------------------------------------------------------------------------+*
*****************************************************************************
*/
/*---------------------------------------------------------------------------------------------------
//EXEMPLO DE CHAMADA
  *Com Anexo
	U_MSGZAP('5521992584067' ,'Teste Protheus','TSTPOLX01_210505_112556_Administrador.txt')

  *Sem Anexo
  U_MSGZAP('5521975267383' ,'Teste Protheus')

  *Mensagem para grupo
  U_MSGZAP('120363168542838243' ,'Teste Protheus','',.T.) 
/*-------------------------------------------------------------------------------------------------*/

/*---------------------------------------------------------------------------------------------------
//PARAMETROS
cCelular - [OBRIGATORIO] - Número (Ou ID de Grupo) para onde a mensagem será enviada
cMSG     - [OBRIGATORIO] - Mensagem à ser enviada
cAnexo   - [OPCIONAL]    - Caminho da IMAGEM/PDF/AUDIO/VIDEO/DOCUMENTO à ser enviado
lGroup   - [OPCIONAL]    - Se o destino for um grupo, colocar como .T. e mudar o ID no parametro cCelular
cSession - [OPCIONAL]    - Caso deseja enviar a mensagem com um TOKEN(Conta específica). 
                           Quando não preenchido o padrão é o Token contido no parametro MV_SESSAO
/*-------------------------------------------------------------------------------------------------*/

User function MSGZAP(cCelular ,cMsg, cAnexo,lGroup,cSession)
//Salvando o bloco de erro do sistema e Atribuindo tratamento personalizado 
Local bError   := ErrorBlock( { |oError| MyError( oError ) } )
Private lXRet  := .F.
Private lAuto  := IsBlind()
Private cStatus:= "" 
Private aParam := {lXRet, cCelular ,cMsg, cAnexo, cStatus}

  If lAuto
    RPCSetEnv("01", "01")
  EndIf

  BEGIN SEQUENCE

    //Forçando um erro para avalia-lo.
    lXRet := MSGZAP2(cCelular ,cMsg, cAnexo,lGroup,cSession)

  RECOVER
  //"Se ocorreu erro, após o BREAK, venho para cá"
  
  END SEQUENCE


  //Ponto de entrada após tentativa de envio da mensagem. Basta criar uma User Function em um outro fonte com esse nome.
  IF EXISTBLOCK("PE_CONN001")
    EXECBLOCK("PE_CONN001",.F.,.F.,aParam)
  ENDIF

  //Restaurando bloco de erro do sistema
  ErrorBlock( bError )

  If lAuto
    RpcClearEnv()
  EndIf


Return lXRet

Static Function MyError( oError )
  lXRet := .F.
  If lAuto
    conout("[CONNECT ZAP] Erro ocorrido na função MSGZAP "+CRLF+oError:Description)
  Else
    MsgInfo("[CONNECT ZAP] Houve uma falha na integração."+CRLF+CRLF+"Sua mensagem não pode ser enviada."+CRLF+CRLF+"Erro Ocorrido: "+ oError:Description , "Erro ocorrido." )
  EndIf
  BREAK
Return( NIL )


Static function MSGZAP2(cCelular ,cMsg, cAnexo,lGroup,cSession)
Local lRet
Private lAuto := IsBlind()




  cCelular	:= Replace(Replace(Replace(Replace(cCelular,"(",""),")",""),"-","")," ","")

  If cCelular == "55"
    If lAuto
        conout("CONNECTZAP = Favor enviar o número do celular WhatsApp.")
    else
        MSGINFO( "Favor enviar o número do celular WhatsApp.", "Problemas ao enviar" )
    EndIf

    Return .F.

  EndIf

  If Empty(cMsg)

    cMsg := " "

  EndIf
  If cAnexo == Nil
    lRet := SETZAP(cCelular ,cMsg,Nil,lGroup,cSession)
  ElseIf Empty(cAnexo)
    lRet := SETZAP(cCelular ,cMsg,Nil,lGroup,cSession)
  Else
    If !(".jpeg" $ cAnexo .OR. ".jpg" $ cAnexo .OR. ".bmp" $ cAnexo .OR. ".png" .OR. ".mp4" $ cAnexo)

    
      //lRet := SETZAP(cCelular ,cMsg)
      //sleep(3000)
      lRet := SETZAP(cCelular ,cMsg, cAnexo,lGroup,cSession)
    
    Else

      lRet := SETZAP(cCelular ,cMsg, cAnexo,lGroup,cSession)

      
    EndIf
  EndIf


Return lRet

Static function SETZAP(cCelular ,cMsg, cAnexo,lGroup, cSession)
Local oOBJ 
Local cStrJson 
Local lRet			:= .F.

Local nTimeOut := 120
Local aHeadOut := {}
Local cHeadRet := ""
Local cPostParms:= ""
Local cURL  := SUPERGETMV("MV_ZAPURL", .T., "https://api.connectzap.com.br/sistema")
Local xNome
Local Z        := 0
Local oJs
Local oFile
Default cSession := Alltrim(SUPERGETMV("MV_SESSAO", .T., "SEUTOKENAQUI"))



  Makedir("C:\temp")
  
  Makedir("C:\temp\files")


  cStrJson := U_fStatus(cSession)
  //Sleep(2000)
  FWJsonDeserialize(cStrJson, @oOBJ)
  cStatus := oOBJ:Status:state

  If cStatus $ "NOTFOUND|CLOSED|" .OR. cStatus == "DISCONNECTED"
    While !("QRCODE" $ U_fStatus(cSession))
      cStrJson := U_fStart(cSession)
      Sleep(3000)  
      If "CONNECTED" $ cStrJson
        exit
      EndIf
    End
  EndIf

  cMsg := EncodeUTF8(cMsg)
  //cMsg := Alltrim(Replace(cMsg,CHR(13)+CHR(10),"\n"))

  
  If Empty(cMsg)
    cMsg := " "
  EndIf

  If cAnexo # Nil .AND. !Empty(cAnexo)
      if lGroup//Se for grupo
        cUrl    += "/sendFileBase64Grupo"
        else
        cUrl    += "/sendFileBase64"
      endif
          
      aadd(aHeadOut,'Accept: application/json')
      aadd(aHeadOut,'Content-Type: application/json')
      Makedir("C:\temp")
      Makedir("C:\temp\files")

      
      cAnexo := Alltrim(Replace(cAnexo,CHR(13)+CHR(10),""))

      If "http" $ cAnexo
          xNome := DTOS(DATE())+Replace(TIME(),":","")
          MemoWrite("C:\temp\files\"+xNome, HttpGet(cAnexo))
          cAnexo     := Encode64(,"C:\\temp\\files\\"+xNome,.F.,.F.)
          If !(".jpeg" $ xNome .OR. ".jpg" $ xNome .OR. ".bmp" $ xNome .OR. ".png" .OR. ".mp4" $ xNome .OR. ".pdf" $ xNome)
              xNome+=".jpg"
          EndIf
      ElseIf "/" $ cAnexo
          xNome := SubStr(cAnexo, rat("/",cAnexo)+1,Len(cAnexo))
          __CopyFile(cAnexo, "C:\temp\files"+SubStr(cAnexo, rat("/",cAnexo),Len(cAnexo)))
          //cAnexo     := Encode64(,"C:\\temp\\files\\"+SubStr(cAnexo, rat("/",cAnexo)+1,Len(cAnexo)),.F.,.F.)
          cAnexo := "C:\temp\files\"+SubStr(cAnexo, rat("/",cAnexo)+1,Len(cAnexo))
          oFile   := FwFileReader():New(cAnexo)
          If oFile:Open()
            cAnexo := oFile:FullRead()
          EndIf
          oFile:Close()
          cAnexo := Encode64(cAnexo)
      Else
          
          xNome := SubStr(cAnexo, rat("\",cAnexo)+1,Len(cAnexo))

          __CopyFile(cAnexo, "C:\temp\files\"+SubStr(cAnexo, rat("\",cAnexo),Len(cAnexo)))
          
          cAnexo := "C:\temp\files\"+SubStr(cAnexo, rat("\",cAnexo),Len(cAnexo))
          oFile   := FwFileReader():New(cAnexo)
          If oFile:Open()
            cAnexo := oFile:FullRead()
          EndIf
          oFile:Close()
          cAnexo := Encode64(cAnexo)
      EndIf
          

		oJs := JsonObject():New()
		oJs['SessionName'] := cSession
	  if lGroup//Se para grupo
		oJs['groupId'] := cCelular
    else
		oJs['phonefull'] := cCelular
    endif
		oJs['base64'] := cAnexo
		oJs['originalname'] := xNome
		oJs['caption'] := cMsg
		cPostParms := oJs:tojson()
		Freeobj(oJs)  

  Else

    if lGroup//Se for grupo
        cUrl    += "/sendTextGrupo"
      else
        cUrl    += "/sendText"
    endif
        
    aadd(aHeadOut,'Accept: application/json')
    aadd(aHeadOut,'Content-Type: application/json')

		oJs := JsonObject():New()
		oJs['SessionName'] := cSession
    if lGroup//Se para grupo
		oJs['groupId'] := cCelular
    else
		oJs['phonefull'] := cCelular
    endif
		oJs['msg'] := Alltrim(cMsg)
		cPostParms := oJs:tojson()
		Freeobj(oJs)
  EndIf
    cPostParms := STRTRAN(cPostParms,'\\','\')
    cReturn := HttpPost(cUrl,,cPostParms,nTimeOut,aHeadOut,@cHeadRet)
    
    //sleep(3000)
    
    If cReturn # Nil   
      lRet := (oOBJ:Status:state == "CONNECTED") .OR. (oOBJ:Status:state == "CLOSED")
      
    Else
      lRet := .F.
    EndIf

    If !lRet   
      If !lAuto
        If MsgYesNo("O Sistema não está conectado ao WhatsApp."+CRLF+"Deseja conectar?", "Confirma?")
          U_CONNZAP()
        else
          lRet := .F.
        EndIf
      else
        conout("CONNECTZAP = Problema ao sincronizar com o Connectzap. Utilize o Painel de integração no protheus ou no site (painel.connectzap.com.br).")
        Return .F.
      EndIf
      cPostParms := STRTRAN(cPostParms,'\\','\')
      cReturn := HttpPost(cUrl,,cPostParms,nTimeOut,aHeadOut,@cHeadRet)

      FWJsonDeserialize(cReturn, @oOBJ)
      lRet := "success" $ cReturn

    EndIf




 
Return  lRet
