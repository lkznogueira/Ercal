#INCLUDE "PROTHEUS.CH"

/*/{Protheus.doc} returnBank
    (return data banck of file)
    @type  Function
    @author byudi
    @since 08/08/2020
    @version version
    @param aConfig1, aConfig2
    @return {}
    @example
    (examples)
    @see (byudi.com.br)
    /*/
user function returnBank( aConfig1, aConfig2)

    Local lRet			:= .T.
    Local cPosNum		:= ""
    Local cPosData		:= ""
    Local cPosValor		:= ""
    Local cPosOcor		:= ""
    Local cPosDescr		:= ""
    Local cPosDif		:= "" 
    Local lPosNum		:=.F.
    Local lPosData		:=.F.
    Local lPosValor		:=.F.
    Local lPosOcor		:=.F.
    Local lPosDescr		:=.F.
    Local lPosDif		:=.F.
    Local lPosBco		:=.F.
    Local lPosAge		:=.F.
    Local lPosCta		:=.f.
    Local nLidos		:= 0
    Local nLenNum		:= 0
    Local nLenData		:= 0
    Local nLenValor		:= 0
    Local nLenDescr		:= 0
    Local nLenOcor		:= 0
    Local nLenDif		:= 0
    Local nLenBco		:= 0
    Local nLenAge		:= 0
    Local nLenCta		:= 0
    Local cArqConf		:= ""
    Local cArqEnt		:= ""
    Local xBuffer
    Local nHdlBco		:= 0
    Local cBanco 		:= 	Space(TamSX3("E5_BANCO")[1])
    Local cAgencia 		:= 	Space(TamSX3("E5_AGENCIA")[1]) 
    Local cConta 		:= 	Space(TamSX3("E5_CONTA")[1])
    Local cDifer		:= ""
    Local lPosVSI		:=.F.
    Local lPosDSI 		:=.F.
    Local lPosDCI 		:=.F.
    Local nLenVSI		:= 0
    Local nLenDSI		:= 0
    Local nLenDCI		:= 0
    Local cPosVSI		:= ""
    Local cPosDSI		:= ""
    Local cPosDCI		:= ""
    Local lFebraban		:= .F.
    Local nTipoDat		:= 0
    Local nHdlConf		:= 0
    Local nTamArq		:= 0
    Local nTamDet		:= 0
    Local cPosBco		:= ""
    Local cPosAge		:= ""
    Local cPosCta		:= ""
    Local nLinha		:= 0
    Local nTamA6Cod		:= TamSX3( "A6_COD"     )[1]
    Local nTamA6Agn 	:= TamSX3( "A6_AGENCIA" )[1]
    Local nTamA6Num 	:= TamSX3( "A6_NUMCON"  )[1]
    Local aConta		:= {}
    Local lFa473Cta 	:= ExistBlock("FA473CTA")
    Local lTemLacto		:= .F.
    local aLog          :=  {}

    dbSelectArea("SA6")
    SA6->(DBSetOrder(1))

    lFebraban := IIF(SEE->EE_BYTESXT > 200 , .t., .f.)
    nTamDet	  := IIF(SEE->EE_BYTESXT > 0, SEE->EE_BYTESXT + 2, 202 )
    nTipoDat  := SEE->EE_TIPODAT

    If Empty(nTipoDat)
        nTipoDat := IIF(nTamDet > 202, 4,1)		//1 = ddmmaa		4= ddmmaaaa
    EndIf

    //Abre arquivo de configuracao
    cArqConf:=aConfig2[1]

   
    nHdlConf:=FOPEN(cArqConf,0+64)
    

    //Leitura do arquivo de configuracao
    nLidos := 0
    FSEEK(nHdlConf,0,0)
    nTamArq:=FSEEK(nHdlConf,0,2)
    FSEEK(nHdlConf,0,0)

    While nLidos <= nTamArq
        
        //Verifica o tipo de qual registro foi lido
        xBuffer := Space(85)
        FREAD(nHdlConf,@xBuffer,85)
        
        If SubStr(xBuffer,1,1) == CHR(1)  // Header
            nLidos+=85
            Loop
        EndIF
        
        If SubStr(xBuffer,1,1) == CHR(4) // Saldo Final
            nLidos+=85
            Loop
        EndIf
        
        //Dados do Saldo Inicial (Bco/Ag/Cta) 
        If !lPosBco  //Nro do Banco
            cPosBco:=Substr(xBuffer,17,10)
            nLenBco:=1+Int(Val(Substr(xBuffer,20,3)))-Int(Val(Substr(xBuffer,17,3)))
            lPosBco:= .T.
            nLidos+=85
            Loop
        EndIf
        If !lPosAge  //Agencia
            cPosAge :=Substr(xBuffer,17,10)
            nLenAge :=1+Int(Val(Substr(xBuffer,20,3)))-Int(Val(Substr(xBuffer,17,3)))
            lPosAge :=.T.
            nLidos+=85
            Loop
        EndIf
        If !lPosCta  //Nro Cta Corrente
            cPosCta=Substr(xBuffer,17,10)
            nLenCta=1+Int(Val(Substr(xBuffer,20,3)))-Int(Val(Substr(xBuffer,17,3)))
            lPosCta=.T.
            nLidos+=85
            Loop
        Endif
        If !lPosDif   // Diferencial de Lancamento
            cPosDif  :=Substr(xBuffer,17,10)
            nLenDif  :=1+Int(Val(Substr(xBuffer,20,3)))-Int(Val(Substr(xBuffer,17,3)))
            lPosDif  :=.t.
            nLidos+=85
            Loop
        EndIf

        //Os dados abaixo não são utilizados na reconciliacao.
        //Estao ai apenas p/leitura do arquivo de configuracao.
        If !lPosVSI   // Valor Saldo Inicial
            cPosVSI  :=Substr(xBuffer,17,10)
            nLenVSI  :=1+Int(Val(Substr(xBuffer,20,3)))-Int(Val(Substr(xBuffer,17,3)))
            lPosVSI  :=.t.
            nLidos+=85
            Loop
        EndIf
        If !lPosDSI   // Data Saldo Inicial
            cPosDSI  :=Substr(xBuffer,17,10)
            nLenDSI  :=1+Int(Val(Substr(xBuffer,20,3)))-Int(Val(Substr(xBuffer,17,3)))
            lPosDSI  :=.t.
            nLidos+=85
            Loop
        EndIf
        If !lPosDCI   // Identificador Deb/Cred do Saldo Inicial
            cPosDCI  :=Substr(xBuffer,17,10)
            nLenDCI  :=1+Int(Val(Substr(xBuffer,20,3)))-Int(Val(Substr(xBuffer,17,3)))
            lPosDCI  :=.t.
            nLidos+=85
            Loop
        EndIf
        
        //Dados dos Movimentos 
        If !lPosNum  // Nro do Lancamento no Extrato
            cPosNum:=Substr(xBuffer,17,10)
            nLenNum:=1+Int(Val(Substr(xBuffer,20,3)))-Int(Val(Substr(xBuffer,17,3)))
            lPosNum:=.t.
            nLidos+=85
            Loop
        EndIf
        
        If !lPosData  // Data da Movimentacao
            cPosData:=Substr(xBuffer,17,10)
            nLenData:=1+Int(Val(Substr(xBuffer,20,3)))-Int(Val(Substr(xBuffer,17,3)))
            lPosData:=.t.
            nLidos+=85
            Loop
        EndIf
        
        If !lPosValor  // Valor Movimentado
            cPosValor=Substr(xBuffer,17,10)
            nLenValor=1+Int(Val(Substr(xBuffer,20,3)))-Int(Val(Substr(xBuffer,17,3)))
            lPosValor=.t.
            nLidos+=85
            Loop
        EndIf
        
        If !lPosOcor // Ocorrencia do Banco
            cPosOcor	:=Substr(xBuffer,17,10)
            nLenOcor :=1+Int(Val(Substr(xBuffer,20,3)))-Int(Val(Substr(xBuffer,17,3)))
            lPosOcor	:=.t.
            nLidos+=85
            Loop
        EndIf
        
        If !lPosDescr  // Descricao do Lancamento
            cPosDescr:=Substr(xBuffer,17,10)
            nLenDescr:=1+Int(Val(Substr(xBuffer,20,3)))-Int(Val(Substr(xBuffer,17,3)))
            lPosDescr:=.t.
            nLidos+=85
            Loop
        EndIf
        
        If !lPosDif   // Diferencial de Lancamento
            cPosDif  :=Substr(xBuffer,17,10)
            nLenDif  :=1+Int(Val(Substr(xBuffer,20,3)))-Int(Val(Substr(xBuffer,17,3)))
            lPosDif  :=.t.
            nLidos+=85
            Loop
        EndIf
        
        Exit
    Enddo

    //fecha arquivo de configuracao
    Fclose(nHdlConf)

    //Abre arquivo enviado pelo banco
    cArqEnt:= aConfig2[2]
    IF !FILE(cArqEnt)
        aAdd(aLog,{0,"Arquivo do Banco não encontrado"}) //"Arquivo do Banco não encontrado"
        Return {}
    Else
        nHdlBco:=FOPEN(cArqEnt,0+64)
    EndIF

    nLidos:=0
    FSEEK(nHdlBco,0,0)
    nTamArq:=FSEEK(nHdlBco,0,2)
    FSEEK(nHdlBco,0,0)

    nLidos 		:= 0


    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
    //³ Desenha o cursor e o salva para poder moviment -lo ³
    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
    nLidos 		:= 0

    While nLidos <= nTamArq
        nLinha++
        
        //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
        //³ Tipo qual registro foi lido ³
        //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
        xBuffer:=Space(nTamDet)
        FREAD(nHdlBco,@xBuffer,nTamDet)
        
        //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
        //³ Verifica o diferencial do registro de Lancamento 			³
        //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
        If !lFebraban  // 200 posicoes
            cDifer :=Substr(xBuffer,Int(Val(Substr(cPosDif, 1,3))),nLenDif )
        Else
            cDifer := "xx"  // 240 posicoes
        Endif
        
        // Header do arquivo
        IF (SubStr(xBuffer,1,1) == "0" .and. !lFebraban).or. ; // 200 posicoes
            (Substr(xBuffer,8,1) == "0" .and. lFebraban)			// 240 posicoes
            nLidos+=nTamDet
            Loop
        EndIF
        
        //Trailer do arquivo
        IF (SubStr(xBuffer,1,1) == "9" .and. !lFebraban) .or. ; //200 posicoes
            (Substr(xBuffer,8,1) == "9" .and. lFebraban)			 //240 posicoes
            nLidos+=nTamDet
            Exit
        EndIF
        
        // Saldo Inicial
        IF (SubStr(xBuffer,1,1) == "1" .and. cDifer == "0" .and. !lFebraban) .or. ;
                (SubStr(xBuffer,8,1) == "1" .and. lFebraban)
            cBanco   := Substr(xBuffer,Int(Val(Substr(cPosBco, 1,3))),nLenBco )
            cAgencia := Substr(xBuffer,Int(Val(Substr(cPosAge, 1,3))),nLenAge )
            cConta   := Substr(xBuffer,Int(Val(Substr(cPosCta, 1,3))),nLenCta )
            If lFa473Cta
                aConta   := ExecBlock("FA473CTA", .F., .F., {cBanco, cAgencia, cConta} )
                cBanco   := aConta[1]
                cAgencia := aConta[2]
                cConta   := aConta[3]
            Endif

            If cBanco != aConfig1[2]
                lTemLacto := .T.
                Exit
            EndIf	
                
            A473VldBco( @cBanco , @cAgencia , @cConta, @nLinha, @aLog, @lRet )
                    
            cBanco 		:= PadR( cBanco   , nTamA6Cod )
            cAgencia 	:= PadR( cAgencia , nTamA6Agn )
            cConta 		:= PadR( cConta   , nTamA6Num )

            If AllTrim(cBanco)!= AllTrim(aConfig1[2])
                aADD(aLog,{nLinha, "Banco não cadastrado" } ) //"Banco não cadastrado"
                lRet := .F.
            Endif

            nLidos+=nTamDet
            Loop
        EndIF

        nLidos += nTamDet

    Enddo

    //Fecha arquivo do Banco 
    Fclose(nHdlBco)

return {cBanco, cAgencia, cConta}

/*/{Protheus.doc} zTiraZeros
    (retired zeros left position)
    @type  Function
    @author byudi
    @since 08/08/2020
    @version 01
    @param cRetorno
    @return {}
    @example
    (examples)
    @see (byudi.com.br)
    /*/
User Function zTiraZeros(cTexto)
    
    Local   _aArea      :=  GetArea()
    Local   _cRetorno   :=  ""
    Local   _lContinua  :=  .T.
    Default _cTexto     :=  ""
 
    _cRetorno := alltrim(_cTexto)
 
    While _lContinua

        If subStr(_cRetorno, 1, 1) <> "0" .Or. len(_cRetorno) ==0
            _lContinua := .f.
        EndIf
         
        If _lContinua
            _cRetorno := substr(_cRetorno, 2, len(_cRetorno))
        EndIf
    EndDo
     
    restArea(_aArea)
    
return _cRetorno
