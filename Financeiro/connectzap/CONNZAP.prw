#Include 'Protheus.ch'
#Include 'parmtype.ch'
#Include 'Totvs.ch'

*****************************************************************************
*+-------------------------------------------------------------------------+*
*|Funcao      | CONNECTZAP  | Autor | Jader Berto         	           	   |*
*+------------+------------------------------------------------------------+*
*|Data        | 13.08.2019                                                 |*
*+------------+------------------------------------------------------------+*
*|Descricao   | Tela de leitura do QRCODE - WhatsApp    		 		   |*
*+------------+------------------------------------------------------------+*
*|Partida     | Qualquer programa										   |*
*|            | 				 	 	                                   |*
*+------------+------------------------------------------------------------+*
*|             ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL            |*
*+-------------------------------------------------------------------------+*
*| Programador       |   Data   | Motivo da alteracao                      |*
*+-------------------+----------+------------------------------------------+*
*|                	 |  	      |					                       |*
*+-------------------+----------+------------------------------------------+* 
*****************************************************************************

User function CONNZAP()
Local oNewPag
Local oStepWiz := nil
Local oPanelBkg
Private oPanel
Private cMsg := space(50)
Private oDlg := nil
Private cNome
Private cStatus := ""
Private oSay1
Private cGet1 := ""
Private cGet2 := space(14)
Private cGet3 := space(250)
Private cGet4 := space(250)
Private cMyNumb := ""
Private cMsgPerf:= ""

Private nX
Private oGreen := LoadBitmap( GetResources(), "BR_VERDE" )
Private oRed := LoadBitmap( GetResources(), "BR_VERMELHO")
Private oList, oOK, oNO
Private aListAux 
Private aList := {} // Vetor com elementos do Browse

   MakeDir( "\qrcode" )

   cNome := Alltrim(GetMv("MV_SESSAO"))
        


	oDlg:= MSDialog():New(0,0,350, 300,'Conecte o WhatsApp com seu SmartPhone',,,,nOr(WS_VISIBLE,WS_POPUP),CLR_BLACK,CLR_WHITE,,,.T.,,,,.T.)
	oDlg:nWidth := 700
	oDlg:nHeight := 600
	oPanelBkg:= tPanel():New(0,0,"",oDlg,,,,,,350,300)
	oStepWiz:= FWWizardControl():New(oPanelBkg)//Instancia a classe FWWizard
	oStepWiz:ActiveUISteps()
	 
	//----------------------
	// Pagina 1
	//----------------------
	oNewPag := oStepWiz:AddStep("1")
	//Altera a descrição do step
	oNewPag:SetStepDescription("Seleção de TOKEN")
	//Define o bloco de construção
	oNewPag:SetConstruction({|Panel|cria_pg1(Panel, @cNome)})
	//Define o bloco ao clicar no botão Próximo
	oNewPag:SetNextAction({||valida_pg1(@cNome)})
	//Define o bloco ao clicar no botão Cancelar
	oNewPag:SetCancelAction({||, fCancel()})
	 
	//----------------------
	// Pagina 2
	//----------------------
	oNewPag := oStepWiz:AddStep("2", {|Panel|cria_pg2(Panel)})
	oNewPag:SetStepDescription("Leitura de QrCode")
	oNewPag:SetNextAction({||valida_pg2(@cNome)})
	//Define o bloco ao clicar no botão Voltar
	oNewPag:SetCancelAction({||, fCancel()})
	 
	//----------------------
	// Pagina 3
	//----------------------
	oNewPag := oStepWiz:AddStep("3", {||oDlg:End()})
	oNewPag:SetStepDescription("Teste de Envio")
	oNewPag:SetConstruction({|Panel|cria_pg3(Panel, @cNome)})
	oNewPag:SetNextAction({||oDlg:End()})
	oNewPag:SetCancelAction({||, fCancel()})
	oNewPag:SetPrevAction({||, .T.})
	 
	oStepWiz:Activate()
	ACTIVATE DIALOG oDlg CENTER
	oStepWiz:Destroy()
	Return
	 
	//--------------------------
	// Construção da página 1
	//--------------------------
	Static Function cria_pg1(oPanel, cNome)
	Local aItems := {}
	Local aData  := {}
	Local cDataFt  
	Local cDataSv
	Local oFont  
	
    oFont := TFont():New('Courier new',,-14,.T.)
    oSay1:= TSay():New(10,10,{||'Escolha o seu token de acesso'},oPanel,,,,,,.T.,,,200,20)

    aData := GetAPOInfo("CONNZAP.prw")
    cDataFt := DTOS(aData[4])
    cDataSv := HttpGet("https://arquivos.connectzap.com.br/connectzap_versao/versao.txt")
    
    If cDataFt == cDataSv
        oSay2:= TSay():New(50,10,{||'Seu programa está atualizado!'},oPanel,,oFont,,,,.T.,CLR_BLUE,CLR_WHITE,200,20)
    Else
        oSay2:= TSay():New(50,10,{||'Existe uma nova versão de programa!'},oPanel,,oFont,,,,.T.,CLR_RED,CLR_WHITE,200,20)
        oTButton1 := TButton():New( 60, 10, "Baixar",oPanel,{||ShellExecute("Open", "https://arquivos.connectzap.com.br/connectzap.zip", "", "", 1)}, 25,10,,,.F.,.T.,.F.,,.F.,,,.F. ) 
    EndIf


    cNome := PADR(cNome,30)

    AADD(aItems, Alltrim(GetMV("MV_SESSAO")))

    oCombo := tComboBox():new(20,10,{|u|if(pcount()>0,cNome:=u,cNome)},aItems,100,20,oPanel,,,,,,.t.,,,,,,,,,)

Return
  
 
//----------------------------------------
// Validação do botão Próximo da página 1
//----------------------------------------
Static Function valida_pg1(cNome)
Local cStrJson := ""
Local oOBJ
Local lRet := .T.

  cNome := Alltrim(cNome)
 
 
  Processa({||cStrJson := U_fStatus(cNome)})
  
  sleep(4000)

  // ?> Deserializa a string JSON
  FWJsonDeserialize(cStrJson, @oOBJ)

  If oOBJ == nil
    Help(" ",1, "Help",,"O firewall do servidor Protheus está bloqueando o acesso ao endereço https://api.connectzap.com.br. Favor procurar o administrador do sistema.",1,0)
    Return .F.
  EndIf


  cStatus := oOBJ:Status
  
Return lRet


//----------------------------------------
// Validação do botão Próximo da página 1
//----------------------------------------
Static Function valida_pg2(cNome)
Local lRet := .T.

 
  If cStatus # "CONNECTED"
    Help(" ",1, "Help",,"O serviço do Whatsapp não está sincronizado, faça a leitura do Qrcode!",1,0)
    Return .F.
  EndIf
  
Return lRet


//--------------------------
// Construção da página 2
//--------------------------
Static Function cria_pg2(oPanel)
Local oTimer
Local oOBJ
Local oFont  
Local lHasButton := .T.
Local cCode


    oFont := TFont():New('Courier new',,-14,.T.)
    
    //oTGet2 := TGet():New( 10,10,{|u| if( PCount() > 0, cMsg := u, cMsg ) } ,oPanel,180,009,,,0,,,.F.,,.T.,,.F.,,.F.,.F.,,.T.,.F.,,cMsg,,,, )
    oSay1  := TSay():New( 10,10,{|u| if( PCount() > 0, cMsg := u, cMsg ) } ,oPanel,,oFont,,,,.T.,CLR_BLUE,CLR_WHITE,300,009)
   
    cStrJson := U_fStatus(cNome)
    FWJsonDeserialize(cStrJson, @oOBJ)
    cStatus := oOBJ:Status:state

    If cStatus $ "NOTFOUND|DISCONNECTED"
        cStrJson := U_fStart(cNome)

        Sleep(15000)

        cStrJson := U_fStatus(cNome)

        FWJsonDeserialize(cStrJson, @oOBJ)

        cStatus := oOBJ:Status:state

    EndIf

    If cStatus == "CONNECTED"
        oSay1:SetText('Seu WhatsApp já está conectado!')
        oTBitmap1 := TBitmap():New(25,110,260,184,,'\qrcode\whatsapp.png',.T.,oPanel, {||},,.F.,.F.,,,.F.,,.T.,,.F.)
        Return
    Else
        cStrJson := U_fStart(cNome)
        Sleep(3000)

        oTimer := TTimer():New(1, {|| BuscaQR(oPanel) }, oDlg )
        oTimer:Activate()

        oSay1:SetText('Abra o WhatsApp Web do seu SmartPhone e aponte a camera para o QRCODE:')

       oSay2:= TSay():New(165,10,{||'Conectar inserindo o código no aplicativo:'},oPanel,,oFont,,,,.T.,CLR_BLUE,CLR_WHITE,200,20)
       
       TGet():New( 175, 10, { | u | If( PCount() == 0, cGet2, cGet2 := u ) },oPanel, ;
       60, 010, "@R (99) 99999-9999",, 0, 16777215,,.F.,,.T.,,.F.,,.F.,.F.,,.F.,.F. ,,"cGet2",,,,lHasButton  )


       oTButton1 := TButton():New( 176, 75, "OK",oPanel,{||cCode := fStrCode(oPanel, cGet2, cNome)}, 25,10,,,.F.,.T.,.F.,,.F.,,,.F. ) 



    EndIf       

Return

 
//--------------------------
// Construção da página 3
//--------------------------
Static Function cria_pg3(oPanel, cNome)
Local lHasButton := .T.
Local oFont  

// Cria Vetor para teste
aListAux := {'','',''}
aadd(aList, aListAux)


oFont := TFont():New('Courier new',,-14,.T.,.T.)

oSay0:= TSay():New(10,10,{||'Mensagem:'},oPanel,,,,,,.T.,,,200,20)


    oTMultiget1 := tMultiget():new( 20, 10, {| u | if( pCount() > 0, cGet1 := u, cGet1 ) }, ;
    oPanel, 175, 92, , , , , , .T. )

    
    oSay0:= TSay():New(10,195,{||'Contatos para Mailling:'},oPanel,,,,,,.T.,,,200,75)

    oList := TCBrowse():New( 20 , 195, 145, 150,,{'','Nome','Celular'},{20,50,50,50},;
    oPanel,,,,,{||},,oFont,,,,,.F.,,.T.,,.F.,,, )


    oSay2:= TSay():New(120,10,{||'Celular:'},oPanel,,,,,,.T.,,,70,20)

    TGet():New( 130, 10, { | u | If( PCount() == 0, cGet2, cGet2 := u ) },oPanel, ;
     60, 010, "@R (99) 99999-9999",, 0, 16777215,,.F.,,.T.,,.F.,,.F.,.F.,,.F.,.F. ,,"cGet2",,,,lHasButton  )



    oSay2:= TSay():New(120,70,{||'Planilha para Mailling (.CSV):'},oPanel,,,,,,.T.,,,70,20)

    TGet():New( 130, 70, { | u | If( PCount() == 0, cGet4, cGet4 := u ) },oPanel, ;
     90, 010, "!@",, 0, 16777215,,.F.,,.T.,,.F.,,.F.,.F.,,.F.,.F. ,,"cGet4",,,,lHasButton  )
    oTButton1 := TButton():New( 131, 160, "Abrir",oPanel,{||zChooseFile("cGet4")}, 25,10,,,.F.,.T.,.F.,,.F.,,,.F. ) 


    oSay3:= TSay():New(150,10,{||'Escolha um arquivo ou cole um LINK da internet (opcional):'},oPanel,,,,,,.T.,,,200,20)

    TGet():New( 160, 10, { | u | If( PCount() == 0, cGet3, cGet3 := u ) },oPanel, ;
    150, 010, "!@",, 0, 16777215,,.F.,,.T.,,.F.,,.F.,.F.,,.F.,.F. ,,"cGet3",,,,lHasButton  )
    oTButton1 := TButton():New( 161, 160, "Abrir",oPanel,{||zChooseFile("cGet3")}, 25,10,,,.F.,.T.,.F.,,.F.,,,.F. ) 
  
    
    oTButton2 := TButton():New( 180, 10, "Enviar",oPanel,{||Processa({|| fEnvia() }, "Enviando Mensagem...")}, 25,10,,,.F.,.T.,.F.,,.F.,,,.F. ) 


Return

Static Function fStrCode(oPanel, cMobile, cNome)
Local cReturn
Local nTimeOut := 120
Local aHeadOut := {}
Local cHeadRet := ""
Local cPostParms:= ""
Local cUrl := SUPERGETMV("MV_ZAPURL", .F., "https://api.connectzap.com.br/sistema")
Local cSession := Alltrim(cNome)
Local oJs
Local cCode    := ""
Local lHasButton := .T.
Local oOBJ
Local oGet1
Local oGet2
Local cGetCode1:= "    "
Local cGetCode2:= "    "

    cUrl    += "/getCode"

    AAdd(aHeadOut, "User-Agent: Chrome/65.0 (compatible; Protheus " + GetBuild() + ")")
    aadd(aHeadOut,'Content-Type: application/json')

    oJs := JsonObject():New()
    oJs['SessionName'] := cSession
    oJs['phonefull']   := '55'+Replace(Replace(Replace(Replace(cMobile,"(",""),")",""),"-","")," ","")
    cPostParms := oJs:tojson()
    Freeobj(oJs)  

    cReturn := HttpPost(cUrl,,cPostParms,nTimeOut,aHeadOut,@cHeadRet)

    FWJsonDeserialize(cReturn, @oOBJ)

    cCode := oOBJ:Status:code

    cGetCode1 := SubStr(cCode, 1, 4)
    cGetCode2 := SubStr(cCode, 5, 4)

    oGet1 := TGet():New( 175, 120, {|u| Iif(PCount() > 0 , cGetCode1 := u, cGetCode1)},oPanel, ;
    30, 010, "!@",, 0, 16777215,,.F.,,.T.,,.F.,,.F.,.F.,,.F.,.F. ,,,,,,lHasButton  )
    oGet1:lReadOnly  := .T.

    oGet2 := TGet():New( 175, 150, {|u| Iif(PCount() > 0 , cGetCode2 := u, cGetCode2)},oPanel, ;
    30, 010, "!@",, 0, 16777215,,.F.,,.T.,,.F.,,.F.,.F.,,.F.,.F. ,,,,,,lHasButton  )
    oGet2:lReadOnly  := .T.


    

Return cCode


Static Function fEnvia()
Local nTot := Len(aList)
Local nInd

    ProcRegua(nTot)

    //cGet1 := Replace(cGet1, CHR(13)+CHR(10), "\n")

    If !Empty(cGet2)
        U_MSGZAP('55'+cGet2 ,cGet1, cGet3)
    EndIf

    If !Empty(aList[1][3])

        IncProc("Enviando Mailling linha " + cValToChar(1) + " de " + cValToChar(nTot) + "...")

        oList:GoPosition(1)
        For nInd := 1 To nTot


            If U_MSGZAP('55'+aList[nInd][3] ,cGet1, cGet3)     
                aList[nInd,01] := oGreen
            Else
                aList[nInd,01] := oRed
            EndIf  

            Sleep(4000)
            
            IncProc("Enviando linha " + cValToChar(nInd) + " de " + cValToChar(nTot) + "...")
            
            oList:Skip(1)
        Next nInd

        
        // Seta o vetor a ser utilizado
        oList:SetArray(aList)

        // Monta a linha a ser exibida no Browse
        oList:bLine := {||{ aList[oList:nAt,01],;
        aList[oList:nAt,02],;
        aList[oList:nAt,03]} }

        oList:GoPosition(1)
    EndIf

Return

Static Function zChooseFile(cGet)
    Local cResultado := ""
    Local cComando   := ""
    Local cDir       := GetTempPath()
    Local cNomBat    := "zChooseFile.bat"
    Local cArquivo   := "resultado.txt"
    Local cMac       := ""
    Default cMascara := "Todos Arquivos (*.*)|*.*"
     
    //Se o resultado já existir, exclui
    If File(cDir + cArquivo)
        FErase(cDir + cArquivo)
    EndIf
     
    //Monta o comando para abrir a tela de seleção do windows
    cComando += '@echo off' + CRLF
    cComando += 'setlocal' + CRLF
    cComando += 'set ps_cmd=powershell "Add-Type -AssemblyName System.windows.forms|Out-Null;$f=New-Object System.Windows.Forms.OpenFileDialog;$f.Filter=' + "'"+cMascara+"'" + ';$f.showHelp=$true;$f.ShowDialog()|Out-Null;$f.FileName"' + CRLF
    cComando += '' + CRLF
    cComando += 'for /f "delims=" %%I in (' + "'%ps_cmd%'" + ') do set "filename=%%I"' + CRLF
    cComando += '' + CRLF
    cComando += 'if defined filename (' + CRLF
    cComando += '    echo %filename% > '+cArquivo + CRLF
    cComando += ')' + CRLF
     
    //Gravando em um .bat o comando
    MemoWrite(cDir + cNomBat, cComando)
     
    //Executando o comando através do .bat
    WaitRun(cDir+cNomBat, 2)
     
    //Se existe o arquivo
    If File(cDir + cArquivo)
     
        //Pegando o resultado que o usuário escolheu
        cResultado := MemoRead(cDir + cArquivo)
    EndIf

    &cGet := Padr(cResultado,250)

    If cGet == "cGet4"
        
        cGet4 := Replace(Alltrim(cGet4), Chr(13)+Chr(10))
        
        If File(cGet4) .And. Upper(SubStr(cGet4, RAt('.', cGet4) + 1, 3)) == 'CSV'
            Processa({|| fContatos() }, "Lendo Planilha de Contatos...")
        Else
            MsgStop("Arquivo e/ou extensão inválida!", "Atenção")
        EndIf
        
    EndIf


Return cResultado

Static Function fContatos()
Local aArea      := GetArea()
Local nTotLinhas := 0
Local cLinAtu    := ""
Local nLinhaAtu  := 0
Local aLinha     := {}
Local oArquivo
Local aLinhas
Private cDirLog    := GetTempPath() + "x_importacao\"
Private cLog       := ""

    aList := {}

    //Definindo o arquivo a ser lido
    oArquivo := FWFileReader():New(cGet4)
     
    //Se o arquivo pode ser aberto
    If (oArquivo:Open())
 
        //Se não for fim do arquivo
        If ! (oArquivo:EoF())
 
            //Definindo o tamanho da régua
            aLinhas := oArquivo:GetAllLines()
            nTotLinhas := Len(aLinhas)
            ProcRegua(nTotLinhas)
             
            //Método GoTop não funciona (dependendo da versão da LIB), deve fechar e abrir novamente o arquivo
            oArquivo:Close()
            oArquivo := FWFileReader():New(cGet4)
            oArquivo:Open()
 
            IncProc("Analisando linha " + cValToChar(1) + " de " + cValToChar(nTotLinhas) + "...")

            //Enquanto tiver linhas
            While (oArquivo:HasLine())
 
                //Incrementa na tela a mensagem
                nLinhaAtu++
                 
                //Pegando a linha atual e transformando em array
                cLinAtu := oArquivo:GetLine()
                aLinha  := StrTokArr(cLinAtu, ";")
                 
            
                cNmCont := aLinha[1]
                cCel    := aLinha[2]

                aListAux := {oRed, cNmCont, cCel}
                aadd(aList, aListAux)
                
                IncProc("Analisando linha " + cValToChar(nLinhaAtu) + " de " + cValToChar(nTotLinhas) + "...")
                 
            EndDo
         Else
            MsgStop("Arquivo não tem conteúdo!", "Atenção")
        EndIf
 
        //Fecha o arquivo
        oArquivo:Close()
    Else
        MsgStop("Arquivo não pode ser aberto!", "Atenção")
    EndIf

    oList:ResetLen()

    // Seta o vetor a ser utilizado
    oList:SetArray(aList)
    
    // Monta a linha a ser exibida no Browse
    oList:bLine := {||{ oRed,;
    aList[oList:nAt,02],;
    aList[oList:nAt,03]} }

    
    RestArea(aArea)

Return


Static Function BuscaQR(oPanel)
Local cStrJson := ""
Local oOBJ
Local cFile 

cNome := alltrim(cNome)

cFile := "qrcode_"+cNome+".png"


    cStrJson := U_fStatus(cNome)
    FWJsonDeserialize(cStrJson, @oOBJ)

    cStatus := oOBJ:Status:state
 
    If cStatus == "CONNECTED"
        oSay1:SetText('Seu WhatsApp foi conectado!')
        oTBitmap1 := TBitmap():New(25,110,260,184,,'\qrcode\whatsapp.png',.T.,oPanel, {||},,.F.,.F.,,,.F.,,.T.,,.F.)
        valida_pg2(@cNome)
        Return (cStatus == "CONNECTED")
    EndIf
    
    fQrCode(cNome, .T.)

    Sleep(1000)

    oTBitmap1 := TBitmap():New(25,110,260,184,,'\qrcode\'+cFile,.T.,oPanel,{||},,.F.,.F.,,,.F.,,.T.,,.F.)



    cStrJson := U_fStatus(cNome)

Return ("CONNECTED" $ cStrJson)




User Function fClose(cNome)
Local cReturn
Local nTimeOut := 120
Local aHeadOut := {}
Local cHeadRet := ""
Local cPostParms:= ""
Local cUrl := SUPERGETMV("MV_ZAPURL", .T., "https://api.connectzap.com.br/sistema")
Local cSession := Alltrim(cNome)
Local oJs

    cUrl    += "/Close"
    
    aadd(aHeadOut,'Content-Type: application/json')

    oJs := JsonObject():New()
    oJs['SessionName'] := cSession
    oJs['View'] := .T.
    cPostParms := oJs:tojson()
    Freeobj(oJs) 

    cReturn := HttpPost(cUrl,,cPostParms,nTimeOut,aHeadOut,@cHeadRet)

Return cReturn


  
User Function fStart(cNome)
Local cReturn
Local nTimeOut := 120
Local aHeadOut := {}
Local cHeadRet := ""
Local cPostParms:= ""
Local cUrl := SUPERGETMV("MV_ZAPURL", .T., "https://api.connectzap.com.br/sistema")
Local cSession := Alltrim(cNome)
Local oJs

    cUrl    += "/Start"

    aadd(aHeadOut,'Content-Type: application/json')

    oJs := JsonObject():New()
    oJs['SessionName'] := cSession
    oJs['View'] := .T.
    cPostParms := oJs:tojson()
    Freeobj(oJs) 

    cReturn := HttpPost(cUrl,,cPostParms,nTimeOut,aHeadOut,@cHeadRet)

    Sleep(2000)

Return cReturn


  
Static Function fQrCode(cNome, lImage)
Local cReturn
Local nTimeOut := 120
Local aHeadOut := {}
Local cHeadRet := ""
Local cPostParms:= ""
Local cUrl := SUPERGETMV("MV_ZAPURL", .T., "https://api.connectzap.com.br/sistema")
Local cSession := Alltrim(cNome)
Local cFile := "qrcode_"+alltrim(cNome)+".png"
Local oJs

    cUrl    += "/QRCode"

    AAdd(aHeadOut, "User-Agent: Chrome/65.0 (compatible; Protheus " + GetBuild() + ")")
    aadd(aHeadOut,'Content-Type: application/json')

    oJs := JsonObject():New()
    oJs['SessionName'] := cSession
    oJs['View'] := .T.
    cPostParms := oJs:tojson()
    Freeobj(oJs)  

    cReturn := HttpPost(cUrl,,cPostParms,nTimeOut,aHeadOut,@cHeadRet)

    memowrite('\qrcode\'+cFile, cReturn)

Return cReturn


User Function fStatus(cNome)
Local cReturn
Local nTimeOut := 120
Local aHeadOut := {}
Local cHeadRet := ""
Local cPostParms:= ""
Local cUrl := SUPERGETMV("MV_ZAPURL", .T., "https://api.connectzap.com.br/sistema")
Local cSession := Alltrim(cNome)
Local oJs

    cUrl    += "/Status"

    AAdd(aHeadOut, "User-Agent: Chrome/65.0 (compatible; Protheus " + GetBuild() + ")")
    aadd(aHeadOut,'Content-Type: application/json')

    oJs := JsonObject():New()
    oJs['SessionName'] := cSession
    cPostParms := oJs:tojson()
    Freeobj(oJs)  


    cReturn := HttpPost(cUrl,,cPostParms,nTimeOut,aHeadOut,@cHeadRet)
        
Return cReturn

User Function fContato(cCelular, cContato, cNmContat)
Local cReturn
Local nTimeOut := 120
Local aHeadOut := {}
Local cHeadRet := ""
Local cPostParms:= ""
Local cUrl := SUPERGETMV("MV_ZAPURL", .T., "https://api.connectzap.com.br/sistema")
Local cSession := Alltrim(SUPERGETMV("MV_SESSAO", .T., "SEUTOKENAQUI"))
Local oJs

    cUrl    += "/sendContactVcard"

    AAdd(aHeadOut, "User-Agent: Chrome/65.0 (compatible; Protheus " + GetBuild() + ")")
    aadd(aHeadOut,'Content-Type: application/json')

    oJs := JsonObject():New()
    oJs['SessionName']  := cSession
    oJs['phonefull']    := cCelular
    oJs['contact']      := cContato
    oJs['namecontact']  := cNmContat
    
    
    cPostParms := oJs:tojson()
    Freeobj(oJs)  


    cReturn := HttpPost(cUrl,,cPostParms,nTimeOut,aHeadOut,@cHeadRet)
        
Return cReturn


Static Function fCancel()

    oDlg:End()

Return .T.

