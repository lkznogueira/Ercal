#INCLUDE "PROTHEUS.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "TOTVS.CH"
#INCLUDE "rwmake.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ AFIN012    ºAutor  ³Gontijoº                 Data ³  15/06/22  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Consulta pedidos com títulos não enviados para bancos e com	  º±±
±±º          ³ boletos não gerados                                     		  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Pirecal		                                        		  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function AFIN012()

    Local cQry :=  ""
	Private aCampos as array
	Private aDados as array
/*
	if !(Pergunte('AFIN012',.T.))
	    Alert("Cancelado pelo usuario!")
	    Return
	endif
*/
	aCampos := {}

    Aadd(aCampos, {'E1_FILIAL'	,'C',TAMSX3("E1_FILIAL")[1]     ,TAMSX3("E1_FILIAL")[2]    , 'Fil. Titulo'  ,PesqPict("SE1","E1_FILIAL")  , .T., ""})
    Aadd(aCampos, {'E1_PREFIXO'	,'C',TAMSX3("E1_PREFIXO")[1]    ,TAMSX3("E1_PREFIXO")[2]   , 'Prefixo'      ,PesqPict("SE1","E1_PREFIXO")  , .T., ""})
  	Aadd(aCampos, {'E1_NUM'		,'C',TAMSX3("E1_NUM")[1]		,TAMSX3("E1_NUM")[2]       , 'Titulo'       ,PesqPict("SE1","E1_NUM")      , .T., ""})
	Aadd(aCampos, {'E1_PARCELA'	,'C',TAMSX3("E1_PARCELA")[1]	,TAMSX3("E1_PARCELA")[2]   , 'Parcela'      ,PesqPict("SE1","E1_PARCELA")  , .T., ""})
	Aadd(aCampos, {'E1_TIPO'	,'C',TAMSX3("E1_TIPO")[1]		,TAMSX3("E1_TIPO")[2]      , 'Tipo'         ,PesqPict("SE1","E1_TIPO")     , .T., ""}) 
	Aadd(aCampos, {'E1_EMISSAO'	,'D',TAMSX3("E1_EMISSAO")[1]	,TAMSX3("E1_EMISSAO")[2]   , 'Emissao'      ,PesqPict("SE1","E1_EMISSAO")  , .T., ""})
	Aadd(aCampos, {'E1_VENCTO'	,'D',TAMSX3("E1_VENCTO")[1]		,TAMSX3("E1_VENCTO")[2]    , 'Vencimento'   ,PesqPict("SE1","E1_VENCTO")   , .T., ""})
	Aadd(aCampos, {'E1_VENCREA'	,'D',TAMSX3("E1_VENCREA")[1]	,TAMSX3("E1_VENCREA")[2]   , 'Venc.Real'    ,PesqPict("SE1","E1_VENCREA")  , .T., ""})
	Aadd(aCampos, {'C5_CLIENTE'	,'C',TAMSX3("C5_CLIENTE")[1]	,TAMSX3("C5_CLIENTE")[2]   , 'Cliente'      ,PesqPict("SC5","C5_CLIENTE")  , .T., ""})
	Aadd(aCampos, {'A1_NOME'	,'C',TAMSX3("A1_NOME")[1]    	,TAMSX3("A1_NOME")[2]      , 'Nome Cliente' ,PesqPict("SA1","A1_NOME")     , .T., ""})
	Aadd(aCampos, {'C5_LOJACLI'	,'C',TAMSX3("C5_LOJACLI")[1]	,TAMSX3("C5_LOJACLI")[2]   , 'Loja'         ,PesqPict("SC5","C5_LOJACLI")  , .T., ""})
 	Aadd(aCampos, {'C5_FILIAL'	,'C',TAMSX3("C5_FILIAL")[1]     ,TAMSX3("C5_FILIAL")[2]    , 'Fil. Pedido'  ,PesqPict("SC5","C5_FILIAL")   , .T., ""})
    Aadd(aCampos, {'C5_NUM'	    ,'C',TAMSX3("C5_NUM")[1]        ,TAMSX3("C5_NUM")[2]       , 'Num. Pedido'  ,PesqPict("SC5","C5_NUM")      , .T., ""})
	Aadd(aCampos, {'C5_EMISSAO'	,'D',TAMSX3("C5_EMISSAO")[1]	,TAMSX3("C5_EMISSAO")[2]   , 'Emissao'      ,PesqPict("SC5","C5_EMISSAO")  , .T., ""})
	Aadd(aCampos, {'E1_VALOR'	,'N',TAMSX3("E1_VALOR")[1]		,TAMSX3("E1_VALOR")[2]     , 'Total'        ,PesqPict("SE1","E1_VALOR")    , .T., ""})
	Aadd(aCampos, {'E1_SALDO'	,'N',TAMSX3("E1_SALDO")[1]		,TAMSX3("E1_SALDO")[2]     , 'Saldo'        ,PesqPict("SE1","E1_SALDO")    , .T., ""})	

	aDados := {}

	If Select("cQry") > 0
  	    
          cQry->(dbCloseArea())
  
    Endif

	cQry := " SELECT E1_FILIAL, E1_PREFIXO, E1_NUM, E1_PARCELA, E1_TIPO, E1_EMISSAO, E1_VENCTO, E1_VENCREA , C5_CLIENTE, A1_NOME, C5_LOJACLI, C5_FILIAL,C5_NUM, C5_EMISSAO, E1_VALOR, E1_SALDO " +CRLF 
    cQry += " FROM "+ RetSqlName( "SC5" ) + " SC5 ,"+ RetSqlName( "SA1" ) + " SA1 ,"+ RetSqlName( "SE1" ) + " SE1 "                                                                              +CRLF
    cQry += " WHERE C5_CLIENTE = A1_COD "                                                                                                                                                        +CRLF
    cQry += " AND C5_LOJACLI = A1_LOJA "                                                                                                                                                         +CRLF
    cQry += " AND C5_FILIAL = E1_FILORIG "                                                                                                                                                       +CRLF
    cQry += " AND C5_NUM = E1_PEDIDO "                                                                                                                                                           +CRLF
    cQry += " AND SC5.D_E_L_E_T_ <> '*' "                                                                                                                                                        +CRLF
    cQry += " AND SA1.D_E_L_E_T_ <> '*' "                                                                                                                                                        +CRLF
    cQry += " AND SE1.D_E_L_E_T_ <> '*' "                                                                                                                                                        +CRLF
    cQry += " AND E1_NUMBCO = ' ' "                                                                                                                                                              +CRLF
    cQry += " AND E1_TIPO = 'NF' "                                                                                                                                                               +CRLF
	cQry += " AND E1_SALDO > 0 "	  
	cQry += " AND E1_NUMLIQ = ' ' "	   
	cQry += " AND E1_PEDIDO <> ' ' "
	cQry += " AND E1_FILIAL = '"+xFilial('SE1')+"' "			 	                                                                                                                                                        +CRLF
    cQry += " ORDER BY C5_FILIAL, C5_NUM "                                                                                                                                                    +CRLF

    MemoWrite("C:\TEMP\PedBol.txt",cQry)
	cQry := ChangeQuery(cQry)

	TcQuery cQry New Alias "cQry"

    	While !cQry->(EOF())

            aAdd(aDados, {cQry->E1_FILIAL,cQry->E1_PREFIXO, cQry->E1_NUM, cQry->E1_PARCELA, cQry->E1_TIPO, StoD(cQry->E1_EMISSAO), StoD(cQry->E1_VENCTO), StoD(cQry->E1_VENCREA) , cQry->C5_CLIENTE, cQry->A1_NOME, cQry->C5_LOJACLI, cQry->C5_FILIAL,cQry->C5_NUM, StoD(cQry->C5_EMISSAO), cQry->E1_VALOR,cQry->E1_SALDO})   	
            cQry->(dbSkip())

		EndDo

	//Chamada da função de MarkBRowse
	AFIN012Z(aCampos /*Campos*/, aDados/*Dados*/, .T./*Campo Totalizador?*/, "E1_SALDO"/*Campo do Totalizado*/, .T./*Marcado?*/)

Return()

**************************************
User Function AFIN012A()
**************************************
	Local cAliasPrc as character

	Private aVetor  := {}
	Private oGet1
	Private oGet2
	Private cGet1 := CTOD(SPACE(8))
	Private cGet2 := Space(4)
	Private cGet3 := Space(4)
	Private cGet4 := Space(4)	
	Private lCheckBo1 := .F.
	Private lCheckBo2 := .F.
	Private lCheckBo3 := .F.
	Private lCheckBo4 := .F.			
	Private oVerdanaBold := TFont():New( 'Arial' , 6 , 20 , , .T. , , , , .T. , .F. )

Begin Transaction

	cAliasPrc := PARAMIXB[1]

	(cAliasPrc)->(DbGoTop())

	//Percore o alias do MarkBrowse
	While !(cAliasPrc)->(Eof())

		//Verifica os registros que foram marcados
		If !Empty((cAliasPrc)->MARK)

			Aadd(aVetor, {(cAliasPrc)->E1_FILIAL, (cAliasPrc)->E1_PREFIXO, (cAliasPrc)->E1_NUM, (cAliasPrc)->E1_PARCELA, (cAliasPrc)->E1_TIPO, (cAliasPrc)->E1_EMISSAO, (cAliasPrc)->E1_VENCTO, (cAliasPrc)->E1_VENCREA , (cAliasPrc)->C5_CLIENTE, (cAliasPrc)->A1_NOME, (cAliasPrc)->C5_LOJACLI, (cAliasPrc)->C5_FILIAL, (cAliasPrc)->C5_NUM, (cAliasPrc)->C5_EMISSAO})
		
			DbSelectArea("ZZB")
			DbSetOrder(1)

				RecLock("ZZB", .T.)
    			
					ZZB->ZZB_FILTIT     := (cAliasPrc)->E1_FILIAL
					ZZB->ZZB_PRXTIT     := (cAliasPrc)->E1_PREFIXO
					ZZB->ZZB_NUMTIT     := (cAliasPrc)->E1_NUM
					ZZB->ZZB_PACTIT     := (cAliasPrc)->E1_PARCELA
					ZZB->ZZB_TPOTIT     := (cAliasPrc)->E1_TIPO
					ZZB->ZZB_EMITIT     := (cAliasPrc)->E1_EMISSAO 
					ZZB->ZZB_VENCTO     := (cAliasPrc)->E1_VENCTO
					ZZB->ZZB_VENCREA    := (cAliasPrc)->E1_VENCREA  
					ZZB->ZZB_CLIPED     := (cAliasPrc)->C5_CLIENTE
					ZZB->ZZB_NOMECLI    := (cAliasPrc)->A1_NOME
					ZZB->ZZB_LOJACLI    := (cAliasPrc)->C5_LOJACLI 
					ZZB->ZZB_FILPED     := (cAliasPrc)->C5_FILIAL
					ZZB->ZZB_NUMPED     := (cAliasPrc)->C5_NUM
					ZZB->ZZB_EMIPED     := (cAliasPrc)->C5_EMISSAO
					ZZB->ZZB_VALTIT     := (cAliasPrc)->E1_VALOR
					ZZB->ZZB_SLDTIT     := (cAliasPrc)->E1_SALDO					

				ZZB->(MsUnlock())

		EndIf

		(cAliasPrc)->(DbSkip())

	EndDo

		ZZB->(DbCloseArea())

		If Len(aVetor) > 0

				Processa({|| AFIN012B() }, "Aguarde...", "Gerando liquidações ...",.F.)

		Else

				MsgStop("Nenhum título foi selecionado.", "Atenção !!!")

		EndIf

End Transaction

Return()

*****************************
Static Function AFIN012B()
*****************************

Local nValor    := 0
Local aCab      :={}
Local aParcelas :={}
Local aItens    :={}
Local nI        := 0
Local cFiltro   := ""
Local cQryZZB   := ""
Local cNum      := ""
Local nTotal    := 0

Begin Transaction

If Select("cQryZZB") > 0
  	    
    cQryZZB->(dbCloseArea())
  
Endif

cQryZZB := " SELECT ZZB_FILPED, ZZB_NUMPED, ZZB_CLIPED, ZZB_LOJACL "    +CRLF
cQryZZB += " FROM "+ RetSqlName( "ZZB" ) + " ZZB "                      +CRLF
cQryZZB += " GROUP BY ZZB_FILPED, ZZB_NUMPED, ZZB_CLIPED, ZZB_LOJACL "  +CRLF
cQryZZB += " ORDER BY ZZB_FILPED, ZZB_NUMPED "                          +CRLF

MemoWrite("C:\TEMP\BuscaPed.txt",cQryZZB)
cQryZZB := ChangeQuery(cQryZZB)

TcQuery cQryZZB New Alias "cQryZZB"

cQryZZB->(DbGoTop())

   	While !cQryZZB->(EOF())

	aCab      := {}
	aParcelas := {}
	aItens    := {}

		DbSelectArea("SC5")
		DbSetOrder(1)

		SC5->(DbGoTop())

		If DbSeek(cQryZZB->ZZB_FILPED+cQryZZB->ZZB_NUMPED,.T.)

			cFiltro := "E1_FILIAL == '"+SC5->C5_FILIAL+ "' .And. "
    		cFiltro += "E1_CLIENTE == '"+SC5->C5_CLIENTE+ "' .And. E1_LOJA == '"+SC5->C5_LOJACLI+ "' .And. "
			cFiltro += "E1_PEDIDO == '"+SC5->C5_NUM+ "' .And. "
    		//cFiltro += "E1_SITUACA $ '0FG' .And. E1_SALDO > 0 .and. "
    		cFiltro += "E1_TIPO = 'NF' .And. "	
    		cFiltro += "E1_SALDO > 0 .And. "	
    		cFiltro += "Empty(E1_NUMLIQ)"

			//Array do processo automatico (aAutoCab)
        	aCab := { {"cCondicao" ,SC5->C5_CONDPAG },;
        	{"cNatureza" ,SC5->C5_NATUREZ },;
        	{"E1_TIPO" ,"NF " },;
        	{"cCliente" ,SC5->C5_CLIENTE},;
        	{"nMoeda" ,1 },;
        	{"cLOJA" ,SC5->C5_LOJACLI }}

			nValor := BuscaValor(SC5->C5_FILIAL, SC5->C5_NUM, SC5->C5_CLIENTE, SC5->C5_LOJACLI)

			//------------------------------------------------------------
            //Monta as parcelas de acordo com a condição de pagamento
            //------------------------------------------------------------
            aParcelas := Condicao( nValor, SC5->C5_CONDPAG,, dDataBase)

			If Empty(cNum)
			
				cNum := Soma1(BuscaTit(SC5->C5_FILIAL))

			Else 

				cNum := Soma1(cNum)

			EndIf

			If Empty(cNum)

				cNum := '000000001'

			EndIf

			//--------------------------------------------------------------
            //Não é possivel mandar Acrescimo e Decrescimo junto.
            //Se mandar os dois valores maiores que zero considera Acrescimo
            //--------------------------------------------------------------
            For nI := 1 to Len(aParcelas)
                //Dados das parcelas a serem geradas
                Aadd(aItens,{{ "E1_FILIAL", SC5->C5_FILIAL },; //Prefixo
				{"E1_NUM" , cNum },; //Nro. TITULO
                {"E1_PREFIXO", "TST" },; //Nro. TITULO
                {"E1_VENCTO" , aParcelas[nI,1]},; //Data boa
                {"E1_VLCRUZ" , aParcelas[nI,2]},; //Valor do titulo
                {"E1_VALOR" , aParcelas[nI,2]},; //Valor do titulo
	            {"E1_ACRESC" , 0 },; //Acrescimo
                {"E1_DECRESC" , 0 }}) //Decrescimo

				//				{'E1_PARCELA', StrZero(nI,3)},;
 
                //cNum := Soma1(cNum)
            
			Next nI

		EndIf
	
	    If Len(aParcelas) > 0
        
		    //Liquidacao e reliquidacao
            //FINA460(nPosArotina,aAutoCab,aAutoItens,nOpcAuto,cAutoFil,cNumLiqCan)
            FINA460(, aCab, aItens, 3, cFiltro) //Inclusao
 
			lAlert := .T.

        Endif

	nTotal++

	cQryZZB->(DbSkip())

	EndDo

End Transaction

	If lAlert 

		MsgAlert('Liquidações geradas com sucesso !!!', 'Atenção')

		LimpaZZB()

	EndIF

Return

************************************************************************
Static Function AFIN012Z(aCampos, aDados, lCmpTot, cCmpTot, lMarcado)
************************************************************************

	Local aSize as array
	Local aObjects as array
	Local oDlgBrw as object
	Local aField as array
	Local nX as numeric
	Private cMark as character
	Private oTotSel as Object
	Private nTotSel as numeric
	Private oQtdSel as Object
	Private nQtdSel as numeric
	Private cAliasBrw as character	
	Private oTempTable as Object

	Private oCliDe as Object
	Private nCliDe := Space(6)
	Private oCliAte as Object
	Private nCliAte := Space(6)
	Private oEmiDe as Object
	Private nEmiDe := CtoD(SPACE(8))
	Private oEmiAte as Object
	Private nEmiAte := CtoD(SPACE(8))
	Private oCndDe as Object
	Private nCndDe := Space(3)
	Private oCndAte as Object
	Private nCndAte := Space(3)
	Private oButton1 as Object

	Default aCampos := {}
	Default aDados := {}
	Default lCmpTot := .F.
	Default cCmpTot := ""
	Default lMarcado := .T.

	//Verifica o campo totalizado
	If lCmpTot .And. Empty(cCmpTot)
		Alert("Parâmetro do campo do total inválido")
		Return()
	EndIf

	//Verifica se os campos do MarkBrowse foram passados como parâmetros
	If Len(aCampos) == 0
		Alert("Campos do MarkBrowse inexistentes")
		Return()
	EndIf

	//Verifica se os dados do MarkBrowse foram passados como parâmetros
	If Len(aDados) == 0
		Alert("Dados do MarkBrowse inexistentes")
		Return()
	EndIf

	nX := 0
	cMark := GetMark()
	nTotSel := 0
	nQtdSel := 0
	cAliasBrw := GetNextAlias()
	aRer := {}
	aField := {}

	//Definição do campo MARK
	aAdd( aField, { "MARK"		, "C", 002, 0, "Mark",, .F., "" } )

	//Definição dos campos conforme parâmetro
	For nX:=1 To Len(aCampos)
		aAdd(aField, aCampos[nX])
	Next nX

	aObjects := {}
	AAdd( aObjects, { 100, 30, .T., .F., .F. } )
	AAdd( aObjects, { 100, 100, .T., .T., .F. } )
	aSize := MsAdvSize( .T. ) //Parametros verifica se exist enchoice

	//Cria Arquivo Temporário
	oTempTable := FWTemporaryTable():New( cAliasBrw )

	//Seta os campos
	oTemptable:SetFields( aField )

	//Cria a tabela temporária
	oTempTable:Create()

	//Ajusta as colunas para o FWMarkBrowse
	aColumn := FGetColumn( aField )

	//Alimenta a tabela temporária do FWMarkBrose
	CrgMarkB(@cAliasBrw, aCampos, aDados)

	Define MsDialog oDlgBrw FROM aSize[7],00 To aSize[6],aSize[5] Title "Titulos a Receber - Liquidação" Pixel

	// Cria o conteiner onde serão colocados os paineis
	oTela     := FWFormContainer():New( oDlgBrw )
	cIdTela	  := oTela:CreateHorizontalBox( 10 )
	cIdRod	  := oTela:CreateHorizontalBox( 80 )

	oTela:Activate( oDlgBrw, .F. )

	//Cria os paineis onde serao colocados os browses
	oPanelUp  	:= oTela:GeTPanel( cIdTela )
	oPanelDown  := oTela:GeTPanel( cIdRod )

	oBrowse := FWMarkBrowse():New()
	oBrowse:SetColumns( aColumn )
	oBrowse:SetOwner( oPanelDown )
	oBrowse:SetDataTable()
	oBrowse:SetAlias( cAliasBrw )
	oBrowse:SetDescription("MarkBrowse")
	oBrowse:SetMenuDef( "" )
	oBrowse:SetWalkThru( .F. )
	oBrowse:SetAmbiente( .F. )
	oBrowse:DisableReport()
	oBrowse:DisableConfig()
	oBrowse:DisableFilter()
	oBrowse:SetFieldMark( "MARK" )
	oBrowse:SetAllMark( { || FMarkAll( oBrowse, lCmpTot, cCmpTot ) } )
	oBrowse:bMark := {|| FMArkOne(oBrowse, lCmpTot, cCmpTot )}

	oBrowse:Activate()

	//Quantidade Selecionado
	@ oPanelUp:nTop + 08, oPanelUp:nLeft + 10 	SAY   "Quantidade Selecionada" SIZE 038,007 OF oPanelUp PIXEL
	@ oPanelUp:nTop + 16, oPanelUp:nLeft + 10	MSGET oQtdSel Var nQtdSel SIZE 080,015	OF oPanelUp PIXEL WHEN .F. PICTURE "@E 999,999,999" HASBUTTON

	@ oPanelUp:nTop + 08, oPanelUp:nLeft + 200 	SAY   "Cliente de?" SIZE 038,007 OF oPanelUp PIXEL
	@ oPanelUp:nTop + 16, oPanelUp:nLeft + 200	MSGET oCliDe Var nCliDe SIZE 080,015	OF oPanelUp PIXEL F3 'SA1' PICTURE "@!" HASBUTTON
	
	@ oPanelUp:nTop + 08, oPanelUp:nLeft + 290 	SAY   "Cliente Até?" SIZE 038,007 OF oPanelUp PIXEL
	@ oPanelUp:nTop + 16, oPanelUp:nLeft + 290	MSGET oCliAte Var nCliAte SIZE 080,015	OF oPanelUp PIXEL F3 'SA1' PICTURE "@!" HASBUTTON
	
	@ oPanelUp:nTop + 08, oPanelUp:nLeft + 380	SAY   "Emissao de?" SIZE 038,007 OF oPanelUp PIXEL
	@ oPanelUp:nTop + 16, oPanelUp:nLeft + 380	MSGET oEmiDe Var nEmiDe SIZE 080,015	OF oPanelUp PIXEL PICTURE "@D" HASBUTTON
	
	@ oPanelUp:nTop + 08, oPanelUp:nLeft + 470 	SAY   "Emissão Ate?" SIZE 038,007 OF oPanelUp PIXEL
	@ oPanelUp:nTop + 16, oPanelUp:nLeft + 470	MSGET oEmiAte Var nEmiAte SIZE 080,015	OF oPanelUp PIXEL PICTURE "@D" HASBUTTON
	
	@ oPanelUp:nTop + 08, oPanelUp:nLeft + 560 	SAY   "Cond. Pgto de?" SIZE 038,007 OF oPanelUp PIXEL
	@ oPanelUp:nTop + 16, oPanelUp:nLeft + 560	MSGET oCndDe Var nCndDe SIZE 050,015	OF oPanelUp PIXEL F3 'SE4' PICTURE "@!" HASBUTTON
	
	@ oPanelUp:nTop + 08, oPanelUp:nLeft + 615	SAY   "Cond. Pgto ate?" SIZE 038,007 OF oPanelUp PIXEL
	@ oPanelUp:nTop + 16, oPanelUp:nLeft + 615	MSGET oCndAte Var nCndAte SIZE 050,015	OF oPanelUp PIXEL F3 'SE4' PICTURE "@!" HASBUTTON

	@ oPanelUp:nTop + 16, oPanelUp:nLeft + 850 BUTTON oButton1 PROMPT "Pesquisa" SIZE 090, 015 OF oPanelUp PIXEL ACTION {|| AtualizaGrid()}

	//Verifica se existe o campo de Total
	If lCmpTot
		//Total Selecionado
		@ 008, 110 	SAY   "Total Selecionado" SIZE 038,007 OF oPanelUp PIXEL
		@ 016, 110 	MSGET oTotSel Var nTotSel SIZE 080,015	OF oPanelUp PIXEL WHEN .F. PICTURE "@E 999,999,999.99" HASBUTTON
	EndIf

	//Verifica se já traz o MarkBrowse Selecionado
	If lMarcado
		FMarkAll( oBrowse, lCmpTot, cCmpTot )
	EndIf

	ACTIVATE MSDIALOG oDlgBrw CENTERED ON INIT (EnchoiceBar(oDlgBrw,{||FwMsgRun(Nil,{||ExecBlock("AFIN012a",.F.,.F.,{cAliasBrw}) },Nil,"Aguarde ..., Gravando dados ..."),oDlgBrw:End()},{||oDlgBrw:End()},,))

	//Exclui a tabela temporária
	oTempTable:Delete()

Return()

/*/{Protheus.doc} FGetColumn
Alteração das colunas do FWMARKBROWSE
@author Felipe Caiado
@since 24/05/2019
@version 1.0
@type Function
/*/
Static Function FGetColumn( aStruct )

	Local cCombo		as character
	Local nPos			as numeric
	Local nI			as numeric
	Local aColumns		as array
	Local aCombo		as array

	cCombo		:=	""
	nPos		:=	0
	nI			:=	0
	aColumns	:=	{}
	aCombo		:=	{}

	//Alimenta array com as colunas
	For nI := 1 to Len( aStruct )
		If aStruct[nI,7]

			nPos ++

			aAdd( aColumns, FWBrwColumn():New() )

			aColumns[nPos]:SetData( &( "{ || " + aStruct[nI,1] + " }" ) )
			aColumns[nPos]:SetTitle( aStruct[nI,5] )
			aColumns[nPos]:SetSize( aStruct[nI,3] )
			aColumns[nPos]:SetDecimal( aStruct[nI,4] )
			aColumns[nPos]:SetPicture( aStruct[nI,6] )
			aColumns[nPos]:SetType( aStruct[nI,2] )
			aColumns[nPos]:SetAlign( Iif( aStruct[nI,2] == "N", 2, 1 ) )

		EndIf
	Next nI

Return( aColumns )

/*/{Protheus.doc} FMarkAll
Inverte a seleção
@author Felipe Caiado
@since 24/05/2019
@version 1.0
@type Function
/*/
Static Function FMarkAll( oBrowse, lCmpTot, cCmpTot )

	Local cAlias as character
	Local cMark	as character

	cAlias	:=	oBrowse:Alias()
	cMark	:=	oBrowse:Mark()

	lMarkAll	:= .T.

	( cAlias )->( DBGoTop() )

	While ( cAlias )->( !Eof() )

		If RecLock( cAlias, .F. )
			( cAlias )->MARK := Iif( ( cAlias )->MARK == cMark, "  ", cMark )
			( cAlias )->( MsUnlock() )

			If ( cAlias )->MARK == cMark
				nQtdSel ++
			Else
				nQtdSel --
			EndIf

			//Verifica se existe o campo de Total
			If lCmpTot

				If ( cAlias )->MARK == cMark
					nTotSel += ( cAlias )->&(cCmpTot)
				Else
					ntotSel -= ( cAlias )->&(cCmpTot)
				EndIf

			EndIf

		EndIf

		( cAlias )->( DBSkip() )
	EndDo

	( cAlias )->( DBGoTop() )

	//Atualiza o Browse
	oBrowse:Refresh()

	//Atualiza a Quantidade
	oQtdSel:Refresh()

	//Verifica se existe o campo de Total
	If lCmpTot
		//Atualiza o Total
		oTotSel:Refresh()
	EndIf

Return()

/*/{Protheus.doc} FMarkOne
Inverte a seleção
@author Felipe Caiado
@since 24/05/2019
@version 1.0
@type Function
/*/
Static Function FMarkOne( oBrowse, lCmpTot, cCmpTot )

	Local cAlias as character
	Local cMark	as character

	cAlias	:=	oBrowse:Alias()
	cMark	:=	oBrowse:Mark()

	lMarkAll	:= .T.

	If ( cAlias )->MARK == cMark
		nQtdSel ++
	Else
		nQtdSel --
	EndIf

	//Verifica se existe o campo de Total
	If lCmpTot

		If ( cAlias )->MARK == cMark
			nTotSel += ( cAlias )->&(cCmpTot)
		Else
			ntotSel -= ( cAlias )->&(cCmpTot)
		EndIf

	EndIf

	//Atualiza o Browse
	oBrowse:Refresh()

	//Atualiza a Quantidade
	oQtdSel:Refresh()

	//Verifica se existe o campo de Total
	If lCmpTot
		//Atualiza o Total
		oTotSel:Refresh()
	EndIf

Return()

//-----------------------------------------------------------
/*/{Protheus.doc} CrgMarkB
Carrega o MArkBrowse
@author Felipe Caiado
@since 24/05/2019
@version 1.0

@type Function
/*/
//-----------------------------------------------------------
Static Function CrgMarkB(cAliasBrw, aCampos, aDados)

	Local nX as numeric
	Local ny as numeric

	nX := 0
	ny := 0

	For nX:=1 To Len(aDados)

		Reclock(cAliasBrw,.T.)
			For nY:=1 To Len(aCampos)
				(cAliasBrw)->&(aCampos[nY][1]) := aDados[nX][nY]
			Next nY
		(cAliasBrw)->(MsUnlock())

	Next nX

Return()

Static Function BuscaValor(cFilPed, cNumPed, cCliPed, cLojaCli)

Local nValor := 0
Local cQry   := 0


	If Select("cQry") > 0
  	    
    cQry->(dbCloseArea())
  
	Endif

		cQry := " SELECT SUM(ZZB_SLDTIT) AS VALOR"                           +CRLF
		cQry += " FROM "+ RetSqlName( "ZZB" ) + " ZZB "                      +CRLF
		cQry += " WHERE ZZB_FILPED = '"+cFilPed+"'"                          +CRLF
		cQry += " AND ZZB_NUMPED = '"+cNumPed+"'"                            +CRLF
		cQry += " AND ZZB_CLIPED = '"+cCliPed+"'"                            +CRLF
		cQry += " AND  ZZB_LOJACL= '"+cLojaCli+"'"                           +CRLF

		MemoWrite("C:\TEMP\BuscaValor.txt",cQry)
		cQry := ChangeQuery(cQry)

		TcQuery cQry New Alias "cQry"

		nValor := cQry->VALOR

Return nValor

Static Function BuscaTit(cFilPed)

Local cTitulo := 0
Local cQry   := 0


	If Select("cQry") > 0
  	    
    cQry->(dbCloseArea())
  
	Endif

		cQry := " SELECT MAX(E1_NUM) AS Titulo "                             +CRLF
		cQry += " FROM "+ RetSqlName( "SE1" ) + " SE1 "                      +CRLF
		cQry += " WHERE E1_FILIAL = '"+xFilial('SE1')+"'"                    +CRLF
		cQry += " AND E1_PREFIXO = 'TST'"                                    +CRLF
		cQry += " AND D_E_L_E_T_ <> '*'"                                     +CRLF


		MemoWrite("C:\TEMP\BuscaTit.txt",cQry)
		cQry := ChangeQuery(cQry)

		TcQuery cQry New Alias "cQry"

		cTitulo  := cQry->Titulo

Return cTitulo 

Static Function LimpaZZB

Local cQryZZB

    cQryZZB := "DELETE FROM " + RetSqlName( "ZZB" )                          + CRLF

	MemoWrite("C:\TEMP\DelZZB.txt",cQryZZB)

	nErro := TcSqlExec(cQryZZB)

	    If nErro != 0
            
            MsgStop("Erro na execução da query ZZB: "+TcSqlError(), "Atenção")
            DisarmTransaction()

		EndIF

Return

Static Function AtualizaGrid

Local cQryGrid := ""

	aDados := {}

	If Select("cQryGrid") > 0
  	    
          cQryGrid->(dbCloseArea())
  
    Endif

	cQryGrid := " SELECT E1_FILIAL, E1_PREFIXO, E1_NUM, E1_PARCELA, E1_TIPO, E1_EMISSAO, E1_VENCTO, E1_VENCREA , C5_CLIENTE, A1_NOME, C5_LOJACLI, C5_FILIAL,C5_NUM, C5_EMISSAO, E1_VALOR, E1_SALDO " +CRLF 
    cQryGrid += " FROM "+ RetSqlName( "SC5" ) + " SC5 ,"+ RetSqlName( "SA1" ) + " SA1 ,"+ RetSqlName( "SE1" ) + " SE1 "                                                                              +CRLF
    cQryGrid += " WHERE C5_CLIENTE = A1_COD "                                                                                                                                                        +CRLF
    cQryGrid += " AND C5_LOJACLI = A1_LOJA "                                                                                                                                                         +CRLF
    cQryGrid += " AND C5_FILIAL = E1_FILORIG "                                                                                                                                                       +CRLF
    cQryGrid += " AND C5_NUM = E1_PEDIDO "                                                                                                                                                           +CRLF
    cQryGrid += " AND SC5.D_E_L_E_T_ <> '*' "                                                                                                                                                        +CRLF
    cQryGrid += " AND SA1.D_E_L_E_T_ <> '*' "                                                                                                                                                        +CRLF
    cQryGrid += " AND SE1.D_E_L_E_T_ <> '*' "                                                                                                                                                        +CRLF
    cQryGrid += " AND E1_NUMBCO = ' ' "                                                                                                                                                              +CRLF
    cQryGrid += " AND E1_TIPO = 'NF' "                                                                                                                                                               +CRLF
	cQryGrid += " AND E1_SALDO > 0 "	                                                                                                                                                             +CRLF              
	cQryGrid += " AND E1_NUMLIQ = ' ' "	                                                                                                                                                             +CRLF                 
	cQryGrid += " AND E1_PEDIDO <> ' ' "                                                                                                                                                             +CRLF              
	cQryGrid += " AND E1_FILIAL = '"+xFilial('SE1')+"' "			 	                                                                                                                             +CRLF
    If !Empty(nCliDe)
	cQryGrid += " AND E1_CLIENTE >= '"+nCliDe+"' "                                                                                                                                                   +CRLF
	EndIf
	cQryGrid += " AND E1_CLIENTE <= '"+nCliAte+"' "                                                                                                                                                  +CRLF
	If !Empty(nCliAte)

	EndIf
	cQryGrid += " ORDER BY C5_FILIAL, C5_NUM "                                                                                                                                                       +CRLF

    MemoWrite("C:\TEMP\PedBol.txt",cQryGrid)
	cQryGrid := ChangeQuery(cQryGrid)

	TcQuery cQryGrid New Alias "cQryGrid"

    	While !cQryGrid->(EOF())

            aAdd(aDados, {cQryGrid->E1_FILIAL,cQryGrid->E1_PREFIXO, cQryGrid->E1_NUM, cQryGrid->E1_PARCELA, cQryGrid->E1_TIPO, StoD(cQryGrid->E1_EMISSAO), StoD(cQryGrid->E1_VENCTO), StoD(cQryGrid->E1_VENCREA) , cQryGrid->C5_CLIENTE, cQryGrid->A1_NOME, cQryGrid->C5_LOJACLI, cQryGrid->C5_FILIAL,cQryGrid->C5_NUM, StoD(cQryGrid->C5_EMISSAO), cQryGrid->E1_VALOR,cQryGrid->E1_SALDO})   	
            cQryGrid->(dbSkip())

		EndDo

	//Alimenta a tabela temporária do FWMarkBrose
	CrgMarkB(@cAliasBrw, aCampos, aDados)

	nTotSel := 0

	nQtdSel := 0

	//Atualiza o Browse
	oBrowse:Refresh()

	//Atualiza a Quantidade
	oQtdSel:Refresh()

	//Atualiza o Total
	oTotSel:Refresh()

	//oTempTable:Refresh()

Return
