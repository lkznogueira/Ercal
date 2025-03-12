#Include "Protheus.ch"
#Include "TopConn.ch"


//Legendas
Static oBmpVerde    := LoadBitmap( GetResources(), "BR_VERDE")
Static oBmpAmarelo := LoadBitmap( GetResources(), "BR_AMARELO")
Static oBmpLaranja    := LoadBitmap( GetResources(), "BR_LARANJA")
Static oBmpCinza    := LoadBitmap( GetResources(), "BR_CINZA")
 
/*/{Protheus.doc} telzap
Função para Enviar Whatsapp Cobrança
@author Carlos Daniel
@since 15/10/2024
@version 1.0
@type function
/*/
 
User Function telzap()
    Local aArea := GetArea()
    //Objetos da Janela
    Private oDlgPvt
    Private oMsGetSE1
    Private aHeadSE1 := {}
    Private aColsSE1 := {}
    Private oBtnSalv
    Private oBtnFech
    Private oBtnLege
    //Tamanho da Janela
    Private    nJanLarg    := 1450
    Private    nJanAltu    := 600
    //Fontes
    Private    cFontUti   := "Tahoma"
    Private    oFontAno   := TFont():New(cFontUti,,-38)
    Private    oFontSub   := TFont():New(cFontUti,,-20)
    Private    oFontSubN  := TFont():New(cFontUti,,-20,,.T.)
    Private    oFontBtn   := TFont():New(cFontUti,,-14)
    Private    nNumZap
    Private    nFil
    Private    cPrx
    Private    nTitulo
    Private    cCliente
    Private    cLoja
    Private    dEmiss
    Private    dVenc
    Private    nBord
     
    //Criando o cabeçalho da Grid
    //              Título               Campo        Máscara                        Tamanho                   Decimal                   Valid               Usado  Tipo F3     Combo    CBOX
    aAdd(aHeadSE1, {"",                  "XX_COR",    "@BMP",                        002,                      0,                        ".F.",              "   ", "C", "",    "V",     "",      "",        "", "V"})
    aAdd(aHeadSE1, {"ENVIA",             "XX_ENVIA", "",                             009,                      0,                        "Pertence('01')",   ".T.", "C", "",    "", "1=SIM;0=NÃO"} )
    aAdd(aHeadSE1, {"Prefixo",           "E1_PREFIXO",  "",                           TamSX3("E1_PREFIXO")[01],0,                        ".T.",              ".T.", "C", "",    ""} )
    aAdd(aHeadSE1, {"Titulo",            "E1_NUM",   "",                              TamSX3("E1_NUM")[01],    0,                        "NaoVazio()",       ".T.", "C", "",    ""} )
    aAdd(aHeadSE1, {"Parcela",           "E1_PARCELA", "",                            TamSX3("E1_PARCELA")[01],0,                        "PERTENCE('1234')", ".T.", "C", "",    ""} )
    aAdd(aHeadSE1, {"Cliente",           "E1_CLIENTE", "",                            TamSX3("E1_CLIENTE")[01],0,                        "Pertence('01')",   ".T.", "C", "",    ""} )
    aAdd(aHeadSE1, {"Loja",              "E1_LOJA",  "",                              TamSX3("E1_LOJA")[01],   0,                        ".T.",              ".T.", "C", "",    ""} )
    aAdd(aHeadSE1, {"Nome",              "E1_NOMCLI",  "",                            TamSX3("E1_NOMCLI")[01], 0,                        ".T.",              ".T.", "C", "",    ""} )
    aAdd(aHeadSE1, {"Tipo",              "E1_TIPO",  "",                              TamSX3("E1_TIPO")[01],   0,                        ".T.",              ".T.", "C", "",    ""} )
    aAdd(aHeadSE1, {"Valor",             "E1_VALOR",  "@E 999,999,999,999",           012,                     0,                        ".T.",              ".T.", "N", "",    ""} )
    aAdd(aHeadSE1, {"Saldo ",            "E1_SALDO",  "@E 999,999,999,999",           012,                     0,                        ".T.",              ".T.", "N", "",    ""} )
    aAdd(aHeadSE1, {"Vencimento",        "E1_VENCREA",  "",                           TamSX3("E1_VENCREA")[01],0,                        ".T.",              ".T.", "D", "",    ""} )
    aAdd(aHeadSE1, {"1° Envio",          "E1_XDENV1",  "",                            TamSX3("E1_XDENV1")[01],0,                         ".T.",              ".T.", "D", "",    ""} )
    aAdd(aHeadSE1, {"2° Envio",          "E1_XDENV2",  "",                            TamSX3("E1_XDENV2")[01],0,                         ".T.",              ".T.", "D", "",    ""} )
    aAdd(aHeadSE1, {"3° Envio",          "E1_XDENV3",  "",                            TamSX3("E1_XDENV3")[01],0,                         ".T.",              ".T.", "D", "",    ""} )
    aAdd(aHeadSE1, {"WHATSAPP",          "A1_TEL", "",                                012,0,                                             ".T.",              ".T.", "C", "",    ""} )
    aAdd(aHeadSE1, {"BORDERO",           "E1_NUMBOR", "",                             TamSX3("E1_NUMBOR")[01],0,                         ".T.",              ".T.", "C", "",    ""} )
    
    Processa({|| fCarAcols()}, "Processando")
 
    //Criação da tela com os dados que serão informados
    DEFINE MSDIALOG oDlgPvt TITLE "Lista de Titulos" FROM 000, 000  TO nJanAltu, nJanLarg COLORS 0, 16777215 PIXEL
        //Labels gerais
        @ 004, 003 SAY "COB"                SIZE 200, 030 FONT oFontAno  OF oDlgPvt COLORS RGB(149,179,215) PIXEL
        @ 004, 050 SAY "Listagem de"        SIZE 200, 030 FONT oFontSub  OF oDlgPvt COLORS RGB(031,073,125) PIXEL
        @ 014, 050 SAY "Titulos" SIZE 200, 030 FONT oFontSubN OF oDlgPvt COLORS RGB(031,073,125) PIXEL
         
        //Botões
        @ 006, (nJanLarg/2-001)-(0052*01) BUTTON oBtnFech  PROMPT "Fechar"        SIZE 050, 018 OF oDlgPvt ACTION (oDlgPvt:End())                               FONT oFontBtn PIXEL
        @ 006, (nJanLarg/2-001)-(0052*02) BUTTON oBtnLege  PROMPT "Legenda"       SIZE 050, 018 OF oDlgPvt ACTION (fLegenda())                                  FONT oFontBtn PIXEL
        @ 006, (nJanLarg/2-001)-(0052*03) BUTTON oBtnSalv  PROMPT "Enviar"        SIZE 050, 018 OF oDlgPvt ACTION (fEnviar())                                   FONT oFontBtn PIXEL
         
        //Grid dos Titulos
        oMsGetSE1 := MsNewGetDados():New(    029,;                //nTop      - Linha Inicial
                                            003,;                //nLeft     - Coluna Inicial
                                            (nJanAltu/2)-3,;     //nBottom   - Linha Final
                                            (nJanLarg/2)-3,;     //nRight    - Coluna Final
                                            GD_UPDATE,;//GD_INSERT + GD_UPDATE + GD_DELETE,;                   //nStyle    - Estilos para edição da Grid (GD_INSERT = Inclusão de Linha; GD_UPDATE = Alteração de Linhas; GD_DELETE = Exclusão de Linhas)
                                            "AllwaysTrue()",;    //cLinhaOk  - Validação da linha
                                            ,;                   //cTudoOk   - Validação de todas as linhas
                                            "",;                 //cIniCpos  - Função para inicialização de campos
                                            ,;                   //aAlter    - Colunas que podem ser alteradas
                                            ,;                   //nFreeze   - Número da coluna que será congelada
                                            9999,;               //nMax      - Máximo de Linhas
                                            ,;                   //cFieldOK  - Validação da coluna
                                            ,;                   //cSuperDel - Validação ao apertar '+'
                                            ,;                   //cDelOk    - Validação na exclusão da linha
                                            oDlgPvt,;            //oWnd      - Janela que é a dona da grid
                                            aHeadSE1,;           //aHeader   - Cabeçalho da Grid
                                            aColsSE1)            //aCols     - Dados da Grid
         
    ACTIVATE MSDIALOG oDlgPvt CENTERED
     
    RestArea(aArea)
Return
 
/*------------------------------------------------*
 | Func.: fCarAcols                               |
 | Desc.: Função que carrega o aCols              |
 *------------------------------------------------*/
 
Static Function fCarAcols()
    Local aArea  := GetArea()
    Local cQry   := ""
    Local nAtual := 0
    Local nTotal := 0
    Local oBmpAux
    Private cPerg := "telzap"
	//Chama a tela de parametros
	If !Pergunte(cPerg,.T.)
		Return()
	EndIf
    //Seleciona dados do titulos
    cQry := " SELECT "                                                  + CRLF
    cQry += "     E1_PREFIXO, "                                         + CRLF
    cQry += "     E1_NUM, "                                             + CRLF
    cQry += "     E1_PARCELA, "                                         + CRLF
    cQry += "     E1_CLIENTE, "                                         + CRLF
    cQry += "     E1_LOJA, "                                            + CRLF
    cQry += "     E1_NOMCLI, "                                          + CRLF
    cQry += "     E1_TIPO, "                                            + CRLF
    cQry += "     E1_VALOR, "                                           + CRLF
    cQry += "     E1_SALDO, "                                           + CRLF
    cQry += "     E1_VENCTO, "                                          + CRLF
    cQry += "     E1_NUMBOR, "                                          + CRLF
    cQry += "     E1_XDENV1, "                                          + CRLF
    cQry += "     E1_XDENV2, "                                          + CRLF
    cQry += "     E1_XDENV3, "                                          + CRLF
    cQry += "     REPLACE(REPLACE((SELECT A1_TEL FROM SA1010 SA1 WHERE sa1.d_e_l_e_t_ <> '*' AND A1_COD = E1_CLIENTE AND A1_LOJA = E1_LOJA), '.'),'-') as E1_TEL, "                                             + CRLF
    cQry += "     E1_VENCREA "                                          + CRLF
    cQry += " FROM "                                                    + CRLF
    cQry += "     " + RetSQLName('SE1') + " SE1 "                       + CRLF
    cQry += " WHERE "                                                   + CRLF
    cQry += "     E1_FILIAL = '" + FWxFilial('SE1') + "' "              + CRLF
    cQry += " AND E1_SALDO <> 0 "                                       + CRLF
    cQry += " AND E1_PREFIXO BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+"' "+ CRLF
    cQry += " AND E1_NUM BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+"' "    + CRLF
    cQry += " AND E1_PARCELA BETWEEN '"+MV_PAR05+"' AND '"+MV_PAR06+"' "+ CRLF
    cQry += " AND E1_CLIENTE BETWEEN '"+MV_PAR07+"' AND '"+MV_PAR08+"' "+ CRLF
    cQry += " AND E1_LOJA BETWEEN '"+MV_PAR09+"' AND '"+MV_PAR10+"' "   + CRLF
    cQry += " AND E1_EMISSAO BETWEEN '"+dtos(MV_PAR11)+"' AND '"+dtos(MV_PAR12)+"' " + CRLF
    cQry += " AND E1_VENCTO BETWEEN '"+dtos(MV_PAR13)+"' AND '"+dtos(MV_PAR14)+"' "  + CRLF
    cQry += " AND E1_NUMBOR BETWEEN '"+MV_PAR15+"' AND '"+MV_PAR16+"' " + CRLF
    cQry += " AND "                                                     + CRLF
    cQry += "     TRIM(E1_TIPO) IN ('NF','BOL') "                       + CRLF
    cQry += "     AND SE1.D_E_L_E_T_ = ' ' "                            + CRLF
    //cQry += " ORDER BY "                                                + CRLF
    //cQry += "     E1_NUM "                                            + CRLF
    MemoWrite("C:\TEMP\QueryWhats.txt",cQry)
    TCQuery cQry New Alias "QRY_SE1"
     
    //Setando o tamanho da régua
    Count To nTotal
    ProcRegua(nTotal)
     
    //Enquanto houver dados
    QRY_SE1->(DbGoTop())
    While ! QRY_SE1->(EoF())
     
        //Atualizar régua de processamento
        nAtual++
        IncProc("Adicionando " + Alltrim(QRY_SE1->E1_NUM) + " (" + cValToChar(nAtual) + " de " + cValToChar(nTotal) + ")...")
        If !Empty(nNumZap)
            nNumZap := QRY_SE1->E1_TEL
        EndIf
        //Cor Padrao  
        oBmpAux := oBmpCinza

        //Se for 1 envio
        If !Empty(QRY_SE1->E1_XDENV1)
            oBmpAux := oBmpVerde      
        EndIf
        If  !Empty(QRY_SE1->E1_XDENV1) .and. !Empty(QRY_SE1->E1_XDENV2) //Se for 2 envio
            oBmpAux := oBmpAmarelo
        EndIf
        If  !Empty(QRY_SE1->E1_XDENV1) .and. !Empty(QRY_SE1->E1_XDENV2) .and. !Empty(QRY_SE1->E1_XDENV3)//Se for 3 envio
            oBmpAux := oBmpLaranja
        EndIf
        //Adiciona o item no aCols
        aAdd(aColsSE1, { ;
            oBmpAux,;
            "0",;
            QRY_SE1->E1_PREFIXO,;
            QRY_SE1->E1_NUM,;
            QRY_SE1->E1_PARCELA,;
            QRY_SE1->E1_CLIENTE,;
            QRY_SE1->E1_LOJA,;
            QRY_SE1->E1_NOMCLI,;
            QRY_SE1->E1_TIPO,;
            QRY_SE1->E1_VALOR,;
            QRY_SE1->E1_SALDO,;
            STOD(QRY_SE1->E1_VENCREA),;
            STOD(QRY_SE1->E1_XDENV1),;
            STOD(QRY_SE1->E1_XDENV2),;
            STOD(QRY_SE1->E1_XDENV3),;
            QRY_SE1->E1_TEL,;
            QRY_SE1->E1_NUMBOR,;
            .F.;
        })
         
        QRY_SE1->(DbSkip())
    EndDo
    QRY_SE1->(DbCloseArea())
     
    RestArea(aArea)
Return
 
/*--------------------------------------------------------*
 | Func.: fLegenda                                        |
 | Desc.: Função que mostra uma descrição das legendas    |
 *--------------------------------------------------------*/
 
Static Function fLegenda()
    Local aLegenda := {}
     
    AADD(aLegenda,{"BR_VERDE"    	,"   1° Envio" })
    AADD(aLegenda,{"BR_AMARELO"     ,"   2° Envio" })
    AADD(aLegenda,{"BR_LARANJA"    	,"   3° Envio" })
    AADD(aLegenda,{"BR_CINZA" 	    ,"   Sem Envio" })
     
    BrwLegenda("Relação de Titulos", "Legenda", aLegenda)
Return
 
/*--------------------------------------------------------*
 | Func.: fEnviar                                         |
 | Desc.: Função que percorre as linhas e faz a gravação  |
 *--------------------------------------------------------*/
 
Static Function fEnviar()

    Local aColsAux := oMsGetSE1:aCols
    Local nPosPrx  := aScan(aHeadSE1, {|x| Alltrim(x[2]) == "E1_PREFIXO"})
    Local nPosNum  := aScan(aHeadSE1, {|x| Alltrim(x[2]) == "E1_NUM"})
    Local nPosPar  := aScan(aHeadSE1, {|x| Alltrim(x[2]) == "E1_PARCELA"})
    Local nPosCli  := aScan(aHeadSE1, {|x| Alltrim(x[2]) == "E1_CLIENTE"})
    Local nPosLoj  := aScan(aHeadSE1, {|x| Alltrim(x[2]) == "E1_LOJA"})
    Local nPosVlr  := aScan(aHeadSE1, {|x| Alltrim(x[2]) == "E1_VALOR"})
    Local nEnvia   := aScan(aHeadSE1, {|x| Alltrim(x[2]) == "XX_ENVIA"})
    Local nPosTp   := aScan(aHeadSE1, {|x| Alltrim(x[2]) == "E1_TIPO"})
    Local nNumZ    := aScan(aHeadSE1, {|x| Alltrim(x[2]) == "A1_TEL"})
    Local nPosDel  := Len(aHeadSE1) + 1
    Local nLinha   := 0
    Local nBord
    Local cPrefix
    Local nNumero
    Local nParcela
    Local cTipo
    //Percorrendo todas as linhas
      
    For nLinha := 1 To Len(aColsAux)
    
        cPrefix := aColsAux[nLinha][nPosPrx]
        nNumero := aColsAux[nLinha][nPosNum]
        nParcela := aColsAux[nLinha][nPosPar]
        cTipo := aColsAux[nLinha][nPosTp]
        nNumZap := TRIM(aColsAux[nLinha][nNumZ])

        If aColsAux[nLinha][nEnvia] == '1'

            //Posiciona no registro    
            DbSelectArea("SE1")
            SE1->(DbSetOrder(1)) // E1_FILIAL+E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO
            SE1->(DbSeek(xFilial()+cPrefix+nNumero+nParcela+cTipo))
            //POSICIONA CLIENTE
            DbSelectArea("SA1")
            SA1->(DbSetOrder(1))
            SA1->(DbSeek(xFilial("SA1")+aColsAux[nLinha][nPosCli]+aColsAux[nLinha][nPosLoj]))
            //Se a linha estiver excluída
            
            If !Len(nNumZap) >= 10
                MsgInfo("Numero invalido, favor seguir o padrão 34999999999 ou 3432303300 10 ou 11 digitos com o DD!", "Atenção")
                Return
            EndIf
            nBord := SE1->E1_NUMBOR
            nFil := SE1->E1_FILIAL
            cPrx := SE1->E1_PREFIXO
            nTitulo := SE1->E1_NUM
            cCliente := SE1->E1_CLIENTE
            cLoja := SE1->E1_LOJA
            dEmiss := SE1->E1_EMISSAO
            dVenc := SE1->E1_VENCTO

            iF !Empty(nBord)
                IF !Empty(nNumZap)

                    RecLock('SE1', .F.)
                        If !Empty(SE1->E1_XDENV1) .and. !Empty(SE1->E1_XDENV2) .and. Empty(SE1->E1_XDENV3)
                            SE1->E1_XDENV3 := Date()
                        EndIf
                        If !Empty(SE1->E1_XDENV1) .and. Empty(SE1->E1_XDENV2)
                            SE1->E1_XDENV2 := Date()
                        EndIf
                        IF Empty(SE1->E1_XDENV1)
                            SE1->E1_XDENV1 := Date()
                        EndIf
                    //SBM->BM_GRUPO  := aColsAux[nLinha][nPosCod]
                    SE1->(MsUnlock()) 
                    if MsgYesNo("Deseja Alterar no Cadastro do Cliente o n°"+ nNumZap+", se sim confirme?", "CLIENTE")
					    RecLock("SA1",.F.)
			            SA1->A1_TEL := TRIM(nNumZap)
			            SA1->(MsUnlock())
				    Endif
                    U_BMFIN01("", "", .F., "", nNumZap, nFil, cPrx, nTitulo, cCliente, cLoja, dEmiss, dVenc ,nBord)
                Else
                    MsgInfo("WhatsApp não Enviado, numero não encontrado!", "Atenção")
                EndIf
            Else
                MsgInfo("Titulo Precisa Estar em Bordero para Enviar Boleto!", "Atenção") 
            EndIf 
            SA1->(dbCloseArea())
            SE1->(dbCloseArea())
        EndIf

    Next

    oDlgPvt:End()
Return

Static Function ValidPerg()
	Local _aArea	:= (GetArea())
	Local aRegs		:= {}
	Local i,j

	DbSelectArea("SX1")
	SX1->(DbSetOrder(1))
	cPerg := PADR(cPerg,10)

	aAdd(aRegs,{cPerg,"01","De Prefixo     ?","","","mv_ch1","C",03,0,0,"G","","MV_PAR01","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	aAdd(aRegs,{cPerg,"02","Ate Prefixo    ?","","","mv_ch2","C",03,0,0,"G","","MV_PAR02","","","","ZZZ","","","","","","","","","","","","","","","","","","","","","","","","",""})
	aAdd(aRegs,{cPerg,"03","De Numero      ?","","","mv_ch3","C",09,0,0,"G","","MV_PAR03","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	aAdd(aRegs,{cPerg,"04","Ate Numero     ?","","","mv_ch4","C",09,0,0,"G","","MV_PAR04","","","","ZZZZZZ","","","","","","","","","","","","","","","","","","","","","","","","",""})
	aAdd(aRegs,{cPerg,"05","De Parcela     ?","","","mv_ch5","C",02,0,0,"G","","MV_PAR05","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	aAdd(aRegs,{cPerg,"06","Ate Parcela    ?","","","mv_ch6","C",02,0,0,"G","","MV_PAR06","","","","ZZZ","","","","","","","","","","","","","","","","","","","","","","","","",""})
	aAdd(aRegs,{cPerg,"07","De Cliente     ?","","","mv_cha","C",06,0,0,"G","","MV_PAR07","","","","","","","","","","","","","","","","","","","","","","","","","SA1CLI","","","",""})
	aAdd(aRegs,{cPerg,"08","Ate Cliente    ?","","","mv_chb","C",06,0,0,"G","","MV_PAR08","","","","ZZZZZZ","","","","","","","","","","","","","","","","","","","","","SA1CLI","","","",""})
	aAdd(aRegs,{cPerg,"09","De Loja        ?","","","mv_chc","C",02,0,0,"G","","MV_PAR09","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	aAdd(aRegs,{cPerg,"10","Ate Loja       ?","","","mv_chd","C",02,0,0,"G","","MV_PAR10","","","","ZZ","","","","","","","","","","","","","","","","","","","","","","","","",""})
	aAdd(aRegs,{cPerg,"11","De Emissao     ?","","","mv_che","D",08,0,0,"G","","MV_PAR11","","","","01/01/00","","","","","","","","","","","","","","","","","","","","","","","","",""})
	aAdd(aRegs,{cPerg,"12","Ate Emissao    ?","","","mv_chf","D",08,0,0,"G","","MV_PAR12","","","","31/12/99","","","","","","","","","","","","","","","","","","","","","","","","",""})
	aAdd(aRegs,{cPerg,"13","De Vencimento  ?","","","mv_chg","D",08,0,0,"G","","MV_PAR13","","","","01/01/00","","","","","","","","","","","","","","","","","","","","","","","","",""})
	aAdd(aRegs,{cPerg,"14","Ate Vencimento ?","","","mv_chh","D",08,0,0,"G","","MV_PAR14","","","","31/12/99","","","","","","","","","","","","","","","","","","","","","","","","",""})
	aAdd(aRegs,{cPerg,"15","Do Bordero     ?","","","mv_chi","C",06,0,0,"G","","MV_PAR15","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	aAdd(aRegs,{cPerg,"16","Ate Bordero    ?","","","mv_chk","C",06,0,0,"G","","MV_PAR16","","","","ZZZZZZ","","","","","","","","","","","","","","","","","","","","","","","","",""})
	
	For i:=1 to Len(aRegs)
		If !dbSeek(cPerg+aRegs[i,2])
			RecLock("SX1",.T.)
			For j:=1 to FCount()
				If j <= Len(aRegs[i])
					FieldPut(j,aRegs[i,j])
				Endif
			Next
			SX1->(MsUnlock())
		Endif
	Next

	RestArea(_aArea)

Return()
