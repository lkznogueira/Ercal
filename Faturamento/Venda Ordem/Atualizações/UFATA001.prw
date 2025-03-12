#Include "Totvs.ch"
#Include "Protheus.ch"

#DEFINE CSS_BOTAO " QPushButton { color: #FFFFFF; font-weight:bold; "+;
	"    background-color: qlineargradient(x1: 0, y1: 0, x2: 0, y2: 1, stop: 0 #3AAECB, stop: 1 #0F9CBF); "+;
	"    border:1px solid #369CB5; "+;
	"    border-radius: 3px; } "+;
	" QPushButton:pressed { "+;
	"    background-color: qlineargradient(x1: 0, y1: 0, x2: 0, y2: 1, stop: 0 #148AA8, stop: 1 #39ACC9); "+;
	"    border:1px solid #369CB5; }";

Static cAliasCab := Nil //XSF2

/*/-------------------------------------------------------------------
- Programa:UFATA001
- Autor: Tarcisio Silva Miranda
- Data: 02/02/2022
- Descrição: Consulta especifica ,movimentações SF2.
-------------------------------------------------------------------/*/

User Function UFATA001()

	Local aArea         := FWGetArea()
	Local lReturn 		:= .T.
	Private cCadastro   := "Consulta de Notas fiscais"

	UFATA001()

	FWRestArea(aArea)

Return(lReturn)

/*/-------------------------------------------------------------------
	- Programa: UFATA001
	- Autor: Tarcisio Silva Miranda
	- Data: 22/03/2022
	- Descrição: Monta a tela.
-------------------------------------------------------------------/*/

Static Function UFATA001()

	Local aCoors 		:= fRetSize()
	Local oFWLayer 		:= NIL
	Local oBrowseCab    := NIL
	Local oPanelBtn     := NIL
	Local oPanelCab     := NIL
	Local oBut1         := NIL
	Local oBut2         := NIL
	Local cTitulo       := "Consulta de Notas fiscais"
	Static oTmpCab      := NIL
	Static oDlgLib      := NIL

	DEFINE MSDIALOG oDlgLib Title cTitulo  From aCoors[1], aCoors[2] To aCoors[3], aCoors[4] Pixel Style 128

	oDlgLib:lEscClose := .F.

	// objeto para divisao da tela
	oFWLayer := FWLayer():New()
	oFWLayer:Init( oDlgLib, .F., .T. )

	////////////////////////// DIVISÃO DA TELA EM PAINEIS /////////////////////////////

	oFWLayer:AddLine('GRID',90,.F.)
	oFWLayer:AddLine('BTN',10,.T.)
	oFWLayer:addCollumn('CENTRAL',100,.F.,'GRID')

	oFWLayer:addWindow('CENTRAL','PAINELPAI'	,'Consulta de Notas fiscais' ,100,.F.,.F.,{|| },'GRID',{|| })

	// capturo os containers
	oPanelBtn   := oFWLayer:GetLinePanel( 'BTN' )
	oPanelCab   := oFWLayer:GetWinPanel('CENTRAL','PAINELPAI'   , 'GRID')

	////////////////////////// CRIAÇÃO DOS GRIDS /////////////////////////////

	// monta grid do cabeçalho dos pedidos
	oBrowseCab := bGridCab(oPanelCab,@oTmpCab)

	////////////////////////// CRIAÇÃO DOS BOTÕES /////////////////////////////

	@ 003, (aCoors[4] / 2) - 055 BUTTON oBut1 PROMPT "Ok"       SIZE 050, 015 OF oPanelBtn PIXEL Action ConfirmarTela()
	@ 003, (aCoors[4] / 2) - 110 BUTTON oBut2 PROMPT "Cancelar" SIZE 050, 015 OF oPanelBtn PIXEL Action fSair() //verificar

	oBut1:SetCss( CSS_BOTAO )

	Activate MsDialog oDlgLib Center

	// excluo as tabelas temporarias
	oTmpCab:Delete()

Return(Nil)

/*/-------------------------------------------------------------------
	- Programa:fRetSize
	- Autor: Tarcisio Silva Miranda
	- Data: 02/02/2022
	- Descrição: Redimenciona a tela de consulta.
-------------------------------------------------------------------/*/

Static Function fRetSize()

	Local aRet := {}

	aAdd(aRet,000)
	aAdd(aRet,000)
	aAdd(aRet,400)
	aAdd(aRet,800)

Return(aRet)

/*/-------------------------------------------------------------------
	- Programa:bGridCab
	- Autor: Tarcisio Silva Miranda
	- Data: 02/02/2022
	- Descrição: Função que cria a estrutura do Browser.
-------------------------------------------------------------------/*/

Static Function bGridCab(oPanel,oTmpCab)

	Local oBrowse       := NIL
	Local aCampos       := {}
	Local aSeek         := {}
	Local aIndice	    := {}
	Local aStruct       := {}
	Local cTitulo       := "Consulta de Notas fiscais"
	Local aFieFilter    := {}

	//Array contendo os indices da tabela temporária
	aAdd(aIndice,{"TR_DOC"    })
	aAdd(aIndice,{"TR_SERIE"  })
	aAdd(aIndice,{"TR_EMISSAO"})
	aAdd(aIndice,{"TR_CHVNFE" })

	//Array contendo os campos da tabela temporária
	AAdd(aCampos,{"TR_DOC"       , TamSX3("F2_DOC")[3]        , TamSX3("F2_DOC")[1] 	, TamSX3("F2_DOC")[2]       })
	AAdd(aCampos,{"TR_SERIE"     , TamSX3("F2_SERIE")[3]      , TamSX3("F2_SERIE")[1]   , TamSX3("F2_SERIE")[2]     })
	AAdd(aCampos,{"TR_EMISSAO"   , TamSX3("F2_EMISSAO")[3]    , TamSX3("F2_EMISSAO")[1] , TamSX3("F2_EMISSAO")[2]   })
	AAdd(aCampos,{"TR_CHVNFE" 	 , TamSX3("F2_CHVNFE")[3]     , TamSX3("F2_CHVNFE")[1]  , TamSX3("F2_CHVNFE")[2]    })

	// adicionar busca no browser
	aAdd(aFieFilter,{"TR_TM" 	,AllTrim(GetSx3Cache("F2_DOC"      	 ,"X3_TITULO" )) , TamSX3("F2_DOC" )[3]        , TamSX3("F2_DOC")[1]	    , TamSX3("F2_DOC")[2]	     ,PesqPict(GetSx3Cache("F2_DOC"        ,"X3_ARQUIVO") , "F2_DOC"        )})
	aAdd(aFieFilter,{"TR_CF" 	,AllTrim(GetSx3Cache("F2_SERIE"      ,"X3_TITULO" )) , TamSX3("F2_SERIE" )[3]      , TamSX3("F2_SERIE")[1]	    , TamSX3("F2_SERIE")[2]	     ,PesqPict(GetSx3Cache("F2_SERIE"      ,"X3_ARQUIVO") , "F2_SERIE"      )})
	aAdd(aFieFilter,{"TR_DOC" 	,AllTrim(GetSx3Cache("F2_EMISSAO"    ,"X3_TITULO" )) , TamSX3("F2_EMISSAO" )[3]    , TamSX3("F2_EMISSAO")[1]	, TamSX3("F2_EMISSAO")[2]	 ,PesqPict(GetSx3Cache("F2_EMISSAO"    ,"X3_ARQUIVO") , "F2_EMISSAO"    )})
	aAdd(aFieFilter,{"TR_CODIG" ,AllTrim(GetSx3Cache("F2_CHVNFE"     ,"X3_TITULO" )) , TamSX3("F2_CHVNFE" )[3]     , TamSX3("F2_CHVNFE")[1]	    , TamSX3("F2_CHVNFE")[2]	 ,PesqPict(GetSx3Cache("F2_CHVNFE"     ,"X3_ARQUIVO") , "F2_CHVNFE"     )})

	//Campos que irão compor o combo de pesquisa na tela principal
	aAdd(aSeek,{AllTrim(GetSx3Cache("F2_DOC"       ,"X3_TITULO" )) , {{"", TamSX3("F2_DOC"     )[3]    ,TamSX3("F2_DOC"     )[1]    , TamSX3("F2_DOC"     )[2]    , "TR_TM" 	,PesqPict(GetSx3Cache("F2_DOC"       ,"X3_ARQUIVO") , "F2_DOC"       ) }}, 1, .T. } )
	aAdd(aSeek,{AllTrim(GetSx3Cache("F2_SERIE"     ,"X3_TITULO" )) , {{"", TamSX3("F2_SERIE"     )[3]  ,TamSX3("F2_SERIE"     )[1]  , TamSX3("F2_SERIE"     )[2]  , "TR_CF" 	,PesqPict(GetSx3Cache("F2_SERIE"     ,"X3_ARQUIVO") , "F2_SERIE"     ) }}, 2, .T. } )
	aAdd(aSeek,{AllTrim(GetSx3Cache("F2_EMISSAO"   ,"X3_TITULO" )) , {{"", TamSX3("F2_EMISSAO"    )[3] ,TamSX3("F2_EMISSAO"    )[1] , TamSX3("F2_EMISSAO"    )[2] , "TR_DOC"   	,PesqPict(GetSx3Cache("F2_EMISSAO"   ,"X3_ARQUIVO") , "F2_EMISSAO"   ) }}, 3, .T. } )
	aAdd(aSeek,{AllTrim(GetSx3Cache("F2_CHVNFE"    ,"X3_TITULO" )) , {{"", TamSX3("F2_CHVNFE"    )[3]  ,TamSX3("F2_CHVNFE"    )[1]  , TamSX3("F2_CHVNFE"    )[2]  , "TR_CODIG" 	,PesqPict(GetSx3Cache("F2_CHVNFE"    ,"X3_ARQUIVO") , "F2_CHVNFE"    ) }}, 4, .T. } )

	//Montando estrutura das colunas
	aAdd(aStruct,{"F2_DOC"     		,"TR_DOC"    ,05})
	aAdd(aStruct,{"F2_SERIE"     	,"TR_SERIE"  ,05})
	aAdd(aStruct,{"F2_EMISSAO"    	,"TR_EMISSAO",10})
	aAdd(aStruct,{"F2_CHVNFE"    	,"TR_CHVNFE" ,15})

	///////////////////////////////////////////////////////////////////////////
	//////////////////      CRIO A TABELA TEMPORARIA     //////////////////////
	///////////////////////////////////////////////////////////////////////////

	// crio a tabela temporária
	ULIB001(@oTmpCab,aCampos,aIndice)

	// chamo função para consulta de Notas fiscais
	RefreshDados()

	///////////////////////////////////////////////////////////////////////////
	////////////////// 		      CRIO O GRID		     //////////////////////
	///////////////////////////////////////////////////////////////////////////

	oBrowse := FWBrowse():New(oPanel)
	oBrowse:SetDataTable(.T.)
	oBrowse:SetAlias( cAliasCab ) //cAliasCab
	oBrowse:SetDescription( cTitulo )

	// Desabilita a impressão das informações disponíveis no Browse.
	oBrowse:DisableReport()

	// Desabilita a gravação das configurações realizadas no Browse.
	oBrowse:DisableSaveConfig()

	// Desabilita a utilização das configurações do Browse.
	oBrowse:DisableConfig()

	//Habilita a utilização da pesquisa de registros no Browse.
	oBrowse:SetSeek(,aSeek)

	//Indica os campos que serão apresentados na edição de filtros.
	oBrowse:SetFieldFilter(aFieFilter)

	//Habilita a utilização do filtro no Browse.
	oBrowse:SetUseFilter(0,)

	//Detalhes das colunas que serão exibidas.
	fCrgColuns(oBrowse,aStruct)

	//Deixa a cor padrão da Grid.
	oBrowse:SetClrAlterRow(128128128)

	oBrowse:Activate()

Return(oBrowse)

/*/-------------------------------------------------------------------
	- Programa:fCrgColuns
	- Autor: Tarcisio Silva Miranda
	- Data: 02/02/2022
	- Descrição: Função responsael pela criação dos colunas da grid.
-------------------------------------------------------------------/*/

Static Function fCrgColuns(oBrowse,aStruct)

	Local nX       	:= 1
	Local aCampos   := {}
	Default oBrowse := Nil
	Default aStruct	:= {}

	for nX := 1 to len(aStruct)

		aAdd(aCampos, FwBrwColumn():New())
		aCampos[len(aCampos)]:SetData( &('{||' + aStruct[nX][2] + '}') 	 										) // campo referente a coluna
		aCampos[len(aCampos)]:SetTitle( AllTrim(GetSx3Cache(aStruct[nX,1],"X3_TITULO" )) 						) // campo referente a coluna
		aCampos[len(aCampos)]:SetSize(aStruct[nX,3]																) // tamanho da coluna
		aCampos[len(aCampos)]:SetPicture( PesqPict(GetSx3Cache(aStruct[nX,1],"X3_ARQUIVO") , aStruct[nX][1] )	) // mascara da coluna
		aCampos[len(aCampos)]:SetReadVar( aStruct[nX,2] 														) // adiciono a variavel em memoria para edicao
		aCampos[len(aCampos)]:SetDecimal( TamSx3(aStruct[nX,1])[2]	 											) // Define alinhamento da coluna.
		aCampos[len(aCampos)]:SetType( TamSx3(aStruct[nX,1])[3] 												) //Define O tipo da coluna. D,C,N,M
		aCampos[len(aCampos)]:SetDoubleClick( {|| ConfirmarTela() } 											) //Define ação para o clique na grid.

	next nX

	oBrowse:SetColumns(aCampos)

Return(Nil)

/*/-------------------------------------------------------------------
	- Programa:RefreshDados
	- Autor: Tarcisio Silva Miranda
	- Data: 02/02/2022
	- Descrição: Função que efetua a carga dos dados..
-------------------------------------------------------------------/*/

Static Function RefreshDados()

	Local cParam 	  := SuperGetMv("MV_XCLINFE",,"")
	Local nPosCod     := 1
	Local nPosEmp     := 2
	Local nPosFil     := 3
	Local aDeParaCli  := &(cParam) //{{'02083001','02','4200'},{'00371401','99','01'}}
	Local nPosArray   := aScan(aDeParaCli,{|x|Alltrim(Upper(x[nPosCod])) == ADA->ADA_XCLIOR+ADA->ADA_XLOJOR })
	Local cFilPsq     := "4200" //iif(nPosArray>0,aDeParaCli[nPosArray][nPosFil],"")
	Local cEmpPsq     := "02"//iif(nPosArray>0,aDeParaCli[nPosArray][nPosEmp],"01") // ver
	Local cQuery      := ""
	Local cAliasQry   := ""

	cQuery := " SELECT  "                           				+ CRLF
	cQuery += "      F2_DOC       	AS DOC "        				+ CRLF
	cQuery += "     ,F2_SERIE       AS SERIE "      				+ CRLF
	cQuery += "     ,F2_EMISSAO     AS EMISSAO "    				+ CRLF
	cQuery += "     ,F2_CHVNFE     	AS CHAVENFE "   				+ CRLF
	cQuery += " FROM SF2"+cEmpPsq+"0 SF2 "        					+ CRLF
	cQuery += " WHERE SF2.D_E_L_E_T_ = ' ' "        				+ CRLF
	cQuery += " AND F2_FILIAL   = '"+cFilPsq+"' "  					+ CRLF
	cQuery += " AND F2_CLIENTE  = '"+ADA->ADA_XCLIOR+"' " 			+ CRLF
	cQuery += " AND F2_LOJA 	= '"+ADA->ADA_XLOJOR+"' " 			+ CRLF
	//Removendo todas as notas que já foram integradas nos pedidos.
	cQuery += " AND F2_CHVNFE NOT IN ( " 							+ CRLF
	cQuery += " 	SELECT   "                      				+ CRLF
	cQuery += " 		DISTINCT(C6_XCHVORI) AS CHVNFE   "      	+ CRLF
	cQuery += " 	FROM SC6"+cEmpPsq+"0 SC6 "        				+ CRLF
	cQuery += " 	WHERE SC6.D_E_L_E_T_ = ' '   "              	+ CRLF
	cQuery += " 	AND C6_XCHVORI <> ' '   "                   	+ CRLF
	cQuery += " 	AND C6_FILIAL 	= '"+cFilPsq+"'  " 				+ CRLF
	cQuery += " 	AND C6_CLI	  	= '"+ADA->ADA_XCLIOR+"'  " 		+ CRLF
	cQuery += " 	AND C6_LOJA 	= '"+ADA->ADA_XLOJOR+"' ) " 	+ CRLF
	//trazendo somente os cfops abaixo.
	cQuery += " AND F2_FILIAL||F2_DOC IN ( " 						+ CRLF
	cQuery += " 	SELECT  " 										+ CRLF
	cQuery += " 		D2_FILIAL||D2_DOC AS CHVSF2  " 				+ CRLF
	cQuery += " 	FROM SD2"+cEmpPsq+"0 SD2 " 						+ CRLF
	cQuery += " 	WHERE SD2.D_E_L_E_T_ = ' '  " 					+ CRLF
	cQuery += " 	AND D2_FILIAL 	= '"+cFilPsq+"'  " 				+ CRLF
	cQuery += " 	AND D2_CLIENTE 	= '"+ADA->ADA_XCLIOR+"'  " 		+ CRLF
	cQuery += " 	AND D2_LOJA 	= '"+ADA->ADA_XLOJOR+"'  " 		+ CRLF
	cQuery += " 	AND D2_CF IN ('5120','6120')) " 				+ CRLF
	//Ordenando a query.
	cQuery += " ORDER BY    "                       				+ CRLF
	cQuery += " 	F2_DOC   "                      				+ CRLF

	// crio o alias temporario
	cAliasQry := MPSysOpenQuery(cQuery)

	if (cAliasQry)->(Eof())
		Help(NIL, NIL, "Ação não permitida!", NIL, "Não foram encontrados registros, com base no preenchimento dos parâmetros.", 1, 0, NIL, NIL, NIL, NIL, NIL, {"Verifique o parametro MV_XCLINFE!"})
	else
		While !(cAliasQry)->(Eof())

			(cAliasCab)->(RecLock(cAliasCab,.T.))
			(cAliasCab)->TR_DOC      := AllTrim((cAliasQry)->DOC)
			(cAliasCab)->TR_SERIE    := AllTrim((cAliasQry)->SERIE)
			(cAliasCab)->TR_EMISSAO  := sTod((cAliasQry)->EMISSAO)
			(cAliasCab)->TR_CHVNFE   := AllTrim((cAliasQry)->CHAVENFE)
			(cAliasCab)->(MsUnLock())
			(cAliasQry)->(DbSkip())
		enddo
	endif

	if Select(cAliasQry) > 0 .AND. !Empty(cAliasQry)
		(cAliasQry)->(DbCloseArea())
	endif

Return(Nil)

/*/-------------------------------------------------------------------
	- Programa: fSair
	- Autor: Tarcisio Silva Miranda
	- Data: 02/02/2022
	- Descrição: Botão de cancelar.
-------------------------------------------------------------------/*/

Static Function fSair()

	Local aArea     := FWGetArea()
	Local aAreaTRB  := (cAliasCab)->(FWGetArea())

	oDlgLib:End() // verificar

	FWRestArea(aAreaTRB)
	FWRestArea(aArea)

Return(Nil)

/*/-------------------------------------------------------------------
	- Programa: ConfirmarTela
	- Autor: Tarcisio Silva Miranda
	- Data: 02/02/2022
	- Descrição: Função que realiza a confirmação dos registros.
-------------------------------------------------------------------/*/

Static Function ConfirmarTela()

	Local aArea     := FWGetArea()
	Local aAreaTRB  := (cAliasCab)->(FWGetArea())

	cNfNum := PadR(AllTrim((cAliasCab)->TR_DOC)		,TamSx3("F2_DOC")[1])
	cNfSer := PadR(AllTrim((cAliasCab)->TR_SERIE)	,TamSx3("F2_SERIE")[1])
	dNfEmi := (cAliasCab)->TR_EMISSAO
	cNfChv := PadR(AllTrim((cAliasCab)->TR_CHVNFE)	,TamSx3("F2_CHVNFE")[1])

	oNfNum:Refresh()
	oNfSer:Refresh()
	oNfEmi:Refresh()
	oNfChv:Refresh()

	oDlgLib:End()

	FWRestArea(aAreaTRB)
	FWRestArea(aArea)

Return(.T.)

/*/-------------------------------------------------------------------
	- Programa: ULIB001
	- Autor: Tarcisio Silva Miranda
	- Data: 25/12/2021
	- Descrição: Função que cria tabela temporaria de dados.
-------------------------------------------------------------------/*/

Static Function ULIB001(oTmpArea,aStru,aIndTemp)

	Local nX            := 1
	Default oTmpArea    := Nil
	Default aStru       := {}
	Default aIndTemp    := {}

	// crio o objeto da tabela temporaria
	oTmpArea := FWTemporaryTable():New( )

	// atribuo os campos da tabela
	oTmpArea:SetFields(aStru)

	// crio os indices
	For nX := 1 To Len(aIndTemp)
		oTmpArea:AddIndex(StrZero(nX,2), aIndTemp[nX])
	Next nX

	// cria a tabela temporária no banco
	oTmpArea:Create()

	cAliasCab := oTmpArea:GetAlias()

Return(Nil)
