#Include "Protheus.ch"

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³MVCHVNFE  ³ Autor ³ Carlos Daniel         ³ Data ³31/01/2022³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Locacao   ³ Ercal            ³Contato ³                                 ±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
 
User Function MVCHVNFE(cParametro)
    Local aArea    := GetArea()
    Local lConsAtu := Nil
    Local lConsNov := Nil
    Local nOpcao   := 0
    Local aBotoes  := {}
    Local cMensag  := ""
    Default cParametro := "MV_CHVNFE"
     
    //Se tiver parâmetro
    If !Empty(cParametro)
        lConsAtu := GetNewPar(cParametro, .F.)
         
        //Adiciona os botões
        aAdd(aBotoes, Iif(lConsAtu,  "Manter Habilitado",   "Habilitar"))   //Opção 1
        aAdd(aBotoes, Iif(!lConsAtu, "Manter Desabilitado", "Desabilitar")) //Opção 2
        aAdd(aBotoes, "Cancelar")                                           //Opção 3
         
        //Mostra o aviso e pega o botão
        cMensag := "Atualmente o parametro esta " + Iif(lConsAtu, "HABILITADO", "DESABILITADO") + "." + CRLF
        cMensag += "Deseja alterar?"
        nOpcao := Aviso("Atencao", cMensag, aBotoes, 2)
         
        //Definindo a opção nova
        If nOpcao == 1
            lConsNov := .T.
        ElseIf nOpcao == 2
            lConsNov := .F.
        EndIf
         
        //Se não for nulo
        If lConsNov != Nil
            //Se o conteúdo novo for diferente do atual
            If lConsNov != lConsAtu
                PutMV(cParametro, lConsNov)
                 
                Final("Atenção", "A tela será fechada e deve ser aberta novamente!")
            EndIf
        EndIf
    EndIf
     
    RestArea(aArea)
Return
