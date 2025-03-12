//Bibliotecas
#Include "TOTVS.ch"
 
/*/{Protheus.doc} User Function zZapSend
Fun��o que dispara uma mensagem para um smartphone com o aplicativo do WhatsApp
@type  Function
@author Atilio
@since 05/08/2021
@version version
@param cTelDestin, Caractere, Telefone de destino com o pa�s 55 e o ddd - por exemplo 5514999998888
@param cMensagem,  Caractere, Mensagem que ser� enviada para esse WhatsApp
@param cAnexo,     Caractere, Caminho do arquivo que tem de estar dentro da Protheus Data
@return aRet, Array, Posi��o 1 define se deu certo o envio com .T. ou .F. e a Posi��o 2 � o JSON obtido como resposta do envio com o protocolo
@obs � necess�rio baixar a classe NETiZAP desenvolvida pelo grande J�lio Wittwer
    dispon�vel em https://github.com/siga0984/NETiZAP/blob/master/NETiZAP.prw
/*/
 
User Function zZapSend(cTelDestin, cMensagem, cAnexo)
    Local aArea  := GetArea()
    Local cLinha := SuperGetMV("MV_X_ZAPLI", .F., "5521986855299")
    Local nPorta := SuperGetMV("MV_X_ZAPPO", .F., 13155)
    Local cChave := SuperGetMV("MV_X_ZAPCH", .F., "fUzanE5ncxlTAWBjMO30")
    Local aRet   := {.F., ""}
    Local oZap
    Local oFile
    Local cArqConteu
    Local cArqEncode
    Local cExtensao
    Local cArqNome
    Default cTelDestin := ""
    Default cMensagem  := ""
    Default cAnexo     := ""
 
    //Retira caracteres em branco dos lados
    cTelDestin := Alltrim(cTelDestin)
    cMensagem  := Alltrim(cMensagem)
 
    //Transforma o texto em UTF-8
    cMensagem := EncodeUTF8(cMensagem)
 
    //Retira caracteres especiais do telefone por exemplo +55 (14) 9 9999-8888
    cTelDestin := StrTran(cTelDestin, " ", "")
    cTelDestin := StrTran(cTelDestin, "+", "")
    cTelDestin := StrTran(cTelDestin, "(", "")
    cTelDestin := StrTran(cTelDestin, ")", "")
    cTelDestin := StrTran(cTelDestin, "-", "")
 
    //Se houver telefone, mensagem, o n�mero for menor que 12 caracteres (551400000000) e n�o iniciar com 55 n�o ir� enviar a mensagem
    If Empty(cTelDestin) .And. Empty(cMensagem) .And. Len(cTelDestin) < 12 .And. SubStr(cTelDestin, 1, 2) != "55"
        aRet[1] := .F.
        aRet[2] := '[{"error":"Parametro(s) enviado(s) para zZapSend, invalido(s)"}]'
    Else
        //Se na mesma mensagem, tiver o -Enter- normal e tags br, retira os -Enter-
        If CRLF $ cMensagem .And. "<br>" $ cMensagem
            cMensagem := StrTran(cMensagem, CRLF, '')
        EndIf
 
        //Agora, ir� converter o restante para o formato que o WhatsApp entenda
        cMensagem := StrTran(cMensagem, CRLF   , '\n')
        cMensagem := StrTran(cMensagem, '<br>' , '\n')
        cMensagem := StrTran(cMensagem, '<b>'  , '*')
        cMensagem := StrTran(cMensagem, '</b>' , '*')
        cMensagem := StrTran(cMensagem, '<i>'  , '_')
        cMensagem := StrTran(cMensagem, '</i>' , '_')
         
        //Instancia a classe, e passa os parametros da NETiZAP
        oZap := NETiZAP():New(cLinha, cChave, nPorta)
 
        //Define o destino e a mensagem de envio
        oZap:SetDestiny(cTelDestin)
        oZap:SetText(cMensagem)
 
        //Se o par�metro do arquivo estiver preenchido, e ele existir
        If ! Empty(cAnexo) .And. File(cAnexo)
            //Tenta abrir o arquivo
            oFile   := FwFileReader():New(cAnexo)
            If oFile:Open()
                //Busca o conte�do do arquivo (foi usado FWFileReader ao inv�s de MemoRead, por causa de limita��o de bytes na leitura)
                cArqConteu  := oFile:FullRead()
                cArqEncode  := Encode64(cArqConteu)
 
                //Busca a extens�o do arquivo
                cExtensao := Upper(SubStr(cAnexo, RAt(".", cAnexo) + 1))
 
                //Busca o nome do arquivo sem extens�o
                cArqNome := SubStr(cAnexo, RAt("\", cAnexo) + 1)
 
                //S� ir� prosseguir, se for um pdf ou uma imagem
                If cExtensao $ "PDF,PNG,JPG,BMP,GIF"
                    //Se a extens�o for PDF, tira o pdf do nome, para n�o ficar por exemplo, arquivo.pdf.pdf
                    If cExtensao == "PDF"
                        cArqNome := SubStr(cArqNome, 1, RAt(".", cArqNome) - 1)
                    EndIf
                    oZap:SetFile(cArqNome, cExtensao, cArqEncode)
 
                    //Atualiza o retorno conforme se a mensagem foi enviada ou houve falha
                    If oZap:FileSend()
                        aRet[1] := .T.
                        aRet[2] := oZap:GetResponse()
                    Else
                        aRet[1] := .F.
                        aRet[2] := oZap:GetLastError()
                    EndIf
 
                Else
                    aRet[1] := .F.
                    aRet[2] := '[{"error":"Extensao invalida, aguardando pdf ou imagens png, jpg, bmp e gif"}]'
                EndIf
 
                oFile:Close()
            EndIf
 
        //Sen�o existir o arquivo, ir� ser enviado uma mensagem simples
        Else
            //Atualiza o retorno conforme se a mensagem foi enviada ou houve falha
            If oZap:MessageSend()
                aRet[1] := .T.
                aRet[2] := oZap:GetResponse()
            Else
                aRet[1] := .F.
                aRet[2] := oZap:GetLastError()
            EndIf
        EndIf
    EndIf
 
    RestArea(aArea)
Return aRet
