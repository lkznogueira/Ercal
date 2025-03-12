#INCLUDE "PROTHEUS.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGETPESO   บAutor  ณMicrosiga           บ Data ณ  21/03/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Programa para realizar a integracao da balanca com o siste บฑฑ
ฑฑบ          ณ ma PROTHEUS.Realizada na tela de faturamento de pedido de  บฑฑ
ฑฑบ          ณ venda                                                      บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Montividiu                                                 บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

//User Function GetPeso()

User Function GetPeso()
                   
Local nHand   := 1
Local nTempo := 700
Local cPorta := GetMv("MV_CONEBAL") //**Conteudo do parametro: "COM1:9600,N,8,1"
Local cString := ""
Local cRetVar := "-1"
Local cMens   := "Deseja repesar?"
Local bEstab := .T.
Local x

Private cPeso := ""
              
While .T.

     cString := ""
     cPeso   := ""
     aPesos := {}
     bEstab := .T.
     
     If MsOpenPort(nHand,cPorta) // Abrindo porta

          Sleep(nTempo)           // Tempo para capturar os dados
          MSRead(nHand, @cPeso)   // Capturando os dados

          MsClosePort(nHand)      // Fechando porta
     
        nIni := SubStr(cPeso,6,5)
        nFim := SubStr(cPeso,6,5)

          // Irregularidade de conesใo ou falta dos caracteres delimitadores
          If nIni = -1 .or. nFim = -1
               cMsg := "A balan็a estแ desligada ou o cabo estแ desconectado ou a" + chr(13)
               cMsg += "conexใo informada no parametro MV_CONFBAL estแ errada," + chr(13)
               cMsg += "pois nใo foi possํvel encontrar os caracteres delimitadores."
               MsgBox(cMsg)
               If MsgYesNo(cMens,OemToAnsi('ATENCAO'))
                    Loop
               Else
                    Exit
               EndIf
          EndIf    

          cPeso := SubStr(cPeso,6,5)

          aPesos := SubStr(cPeso,6,5)
     
        // Poucas Amostras
        If len(aPesos) < 4
               MsgBox("Nใo foi possํvel adquirir o peso devido a poucas amostas." + chr(13) + "Por favor, repesar a pe็a.")
               If MsgYesNo(cMens,OemToAnsi('ATENCAO'))
                    Loop
               Else
                    Exit
               EndIf
        EndIf

          // Verificando a Estabilidade
          For x := 2 to len(aPesos)
               If aPesos[x] != aPesos[1]
               bEstab := .F.
               Exit
               EndIf
          Next     

          If ! bEstab
               MsgBox("O peso da balan็a nใo estแ estabilizado." + chr(13) + "Por favor, repesar a pe็a.")
               If MsgYesNo(cMens,OemToAnsi('ATENCAO'))
                    Loop
               Else
                    Exit
               EndIf
          Endif


          // Verificando Peso Negativo
          If asc(substr(aPesos[1], 2, 1)) = 45
               MsgBox("O peso da balan็a estแ NEGATIVO." + chr(13) + "Por favor, repesar a pe็a.")
               If MsgYesNo(cMens,OemToAnsi('ATENCAO'))
                    Loop
               Else
                    Exit
               EndIf
          EndIf


          // Verificando Sobrecarga
          If asc(substr(aPesos[1], 8, 1)) = 32
               MsgBox("SOBRECARGA NA BALANวA !!!" + chr(13) + "Por favor, retire o peso excessivo e verifique a TARA.")
               If MsgYesNo(cMens,OemToAnsi('ATENCAO'))
                    Loop
               Else
                    Exit
               EndIf
          EndIf

          // Balan็a Zerada
          If substr(aPesos[1], 3, 6) = " 0.000"
               MsgBox("BALANวA SEM CARGA !!!" + chr(13) + "Por favor, coloque a pe็a sobre a balan็a.")
               If MsgYesNo(cMens,OemToAnsi('ATENCAO'))
                    Loop
               Else
                    Exit
               EndIf
          EndIf

          // Peso Correto
          cRetVar := substr(aPesos[1], 3, 6)
        Exit
     Else
          MsgBox("Nใo foi possํvel conectar a porta especificada." + chr(13) +"Verifique se o cabo da balan็a estแ conectado" + chr(13) + chr(13) + cPorta)
          If MsgYesNo(cMens,OemToAnsi('ATENCAO'))
               Loop
          Else
               Exit
          EndIf
     EndIf
EndDo

Return cRetVar


Static Function explode(cSeparator, cString)
    Local aRetVar := {}
    Local cTemp
    Local bExec := .T.
    Local nPos
    
    While bExec
          nPos := At(cSeparator, cString)
          If nPos = 0
               bExec := .F.
               Exit
          EndIf
        cTemp := substr(cString, 1, nPos)
          aadd(aRetVar, cTemp)
          cString := substr(cString, nPos + 1)
     EndDo
Return aRetVar
