#Include 'RwMake.ch'
#Include 'TopConn.ch'
#Include 'Protheus.ch'
#Include "FWPrintSetup.ch"
#Include "RPTDEF.CH"
#Include "TbiCode.ch"
#Include "TbiConn.ch"
#Include "fileio.ch"

/*/{Protheus.doc} BMFIN01
@description Fonte de geracao de boletos - Ercal
@type function


@version 1
@author oficina5-Raphael Ferreira
@since 20/10/2021
@param _cSubC, variant, param_description
@param _cDir, variant, param_description
@param _lMsg, variant, param_description
@return variant, return_description
/*/
User Function BMFIN02(_cSubC, _cDir, _lMsg, _lEmail)

	Local cSelEmpresa 	:= cEmpAnt//"01"
	Local cSelFilial	:= cFilAnt//"0101"
	Local cArqTrab		:= ""

	Local i				:= 0
	Local aCampos		:= {}
	Local aStrut		:= {}
	Local aSql			:= {}
	Local cAbatim		:= "%'" + STRTRAN( MVABATIM , "|" , "','" ) + "'%"
	Local aFormPgto		:= StrTokArr(AllTrim(GETMV( 'MV_PGTOBOL' ,, ''  )), "/")
	Local cFormPgto		:= ""

	Default _lMsg		:= .T.
	Default _lEmail		:= .F.

	If Funname() == "RPC" .Or. Funname() == space(8)

		Private	bPrepAmb := {||  RpcSetType( 3 ), RpcSetEnv( cSelEmpresa, cSelFilial,,,"FIN") }

		LJMsgRun("Preparando o ambiente ...","Aguarde...",bPrepAmb)

		__cInterNet := NIL

	Endif

	Private _cSubConta  := Alltrim(_cSubC) // Se estiver preenchido veio de outra rotina e o título está posicionado. Geração direta. MFIN003
	Private _cPasta     := Alltrim(_cDir)  // Se estiver preenchido veio de outra rotina e o título está posicionado. Geração direta. MFIN003 grava pasta especifica
	Private cIndexName  := ""
	Private cIndexKey   := ""
	Private cFilter     := ""
	Private cPerg		:= "BMFIN01"

	Private oMark		:= Nil
	Private cMark   	:= GetMark()
	Private lExec      	:= .F.
	Private lInverte	:= .F.

	Private _cNumBco := ""
	Private _cNumAge := ""
	Private _cNumCta := ""
	Private _cNumSCt := ""

	Private _cAlias1		:= GetNextAlias()
	Private _cAlias2		:= GetNextAlias()

	cFormPgto	:= "%"
	For i:=1 To Len(aFormPgto)
		cFormPgto	+= "'" + aFormPgto[i] + "',"
	Next i

	cFormPgto := SubStr(cFormPgto,1, Len(cFormPgto) - 1) + "%"

	//Valida o grupo de perguntas
	ValidPerg()

	If Empty(_cSubConta)   // Se estiver preenchido veio de outra rotina e o título está posicionado. Geração direta. MFIN003
		//Chama a tela de parametros
		If !Pergunte(cPerg,.T.)
			Return()
		EndIf
	Else
		Pergunte(cPerg,.F.) // Gerar título a título. Vindo de outra rotina. Geração direta. MFIN003 - NAO PODE ALTERAR/CRIAR PERGUNTAS SEM DAR MANUTENÇÕES

		_cSQL:="SELECT * FROM " +RetSqlName("SE1")
		_cSQL+=" WHERE D_E_L_E_T_<>'*'  " 
		_cSQL+=" AND E1_VENCREA BETWEEN (SELECT TO_CHAR(SYSDATE, 'YYYYMMDD') AS data_atual FROM dual) " 
		_cSQL+=" AND (SELECT TO_CHAR(SYSDATE+7, 'YYYYMMDD') AS data_atual FROM dual) "

		_cSQL := ChangeQuery(_cSQL) //comando para evitar erros de incompatibilidade de bancos

	  	TcQuery _cSQL New Alias "QRYSE1" // Cria uma nova area com o resultado do query 

	  	QRYSE1->(DbGoTop())
//criar while para percorrer todas as linhas da query
		MV_PAR01 := QRYSE1->E1_PREFIXO
		MV_PAR02 := QRYSE1->E1_PREFIXO
		MV_PAR03 := QRYSE1->E1_NUM
		MV_PAR04 := QRYSE1->E1_NUM
		MV_PAR05 := "  "
		MV_PAR06 := "ZZ"
		MV_PAR07 := QRYSE1->E1_CLIENTE
		MV_PAR08 := QRYSE1->E1_CLIENTE
		MV_PAR09 := QRYSE1->E1_LOJA
		MV_PAR10 := QRYSE1->E1_LOJA
		MV_PAR11 := QRYSE1->E1_EMISSAO
		MV_PAR12 := QRYSE1->E1_EMISSAO
		MV_PAR13 := QRYSE1->E1_VENCTO
		MV_PAR14 := dDataBase + 10000
		MV_PAR15 := 2
		MV_PAR16 := QRYSE1->E1_NUMBOR
		MV_PAR17 := QRYSE1->E1_NUMBOR
		MV_PAR18 := ""
	EndIf

	_cNumBco := PADR( GETMV( 'O5_BORNBCO' ,, ''  ) , TamSX3('E1_PORTADO')[01])
	_cNumAge := PADR( GETMV( 'O5_BORNAGE' ,, ''  ) , TamSX3('E1_AGEDEP')[01])
	_cNumCta := PADR( GETMV( 'O5_BORNCTA' ,, ''  ) , TamSX3('E1_CONTA')[01])
	_cNumSCt := PADR( GETMV( 'O5_BORNSCT' ,, ''  ) , TamSX3('EE_SUBCTA')[01])

	aSql := {	"SE1.E1_OK"			,;
				"SE1.E1_FILIAL"		,;
				"SE1.E1_NUMBOR"		,;
				"SE1.E1_PREFIXO"	,;
				"SE1.E1_NUM"		,;
				"SE1.E1_PARCELA"	,;
				"SE1.E1_CLIENTE"	,;
				"SE1.E1_LOJA"		,;
				"SA1.A1_NOME"		,;
				"SA1.A1_EMAIL"		,;
				"SE1.E1_EMISSAO"	,;
				"SE1.E1_VENCTO"		,;
				"SE1.E1_PORTADO"	,;
				"SE1.E1_AGEDEP"		,;
				"SE1.E1_CONTA"		,;
				"SE1.E1_TIPO" 		,;
				"SE1.E1_ACRESC"		,;
				"SE1.E1_DECRESC"	 }

	aCampos	:= {}

	//¦+-------------------------------------------------------------+¦
	//¦¦Carrega as Informações dos Campos!   				         ¦¦
	//¦+-------------------------------------------------------------+¦

//	DBSelectArea("SX3")
//	SX3->( DBSetOrder(2) )
//	For i := 1 to Len(aSql)
//		SX3->( DBGoTop() )
//		If SX3->( DBSeek( PadR( Substr( aSql[i] , 5 , Len(aSql) ) , 10 ) ) )
//			Aadd( aCampos	, { X3_CAMPO , "" , X3Titulo() , X3_PICTURE } )
//			Aadd( aStrut	, { X3_CAMPO , X3_TIPO , IIF( Alltrim( Upper(X3_CAMPO) ) $ "A1_NOME/A1_EMAIL" , 40 , X3_TAMANHO ) , X3_DECIMAL } )
//		Endif
//	Next i

	For i := 1 to Len(aSql)
	
		_cCampo		:= Substr(aSql[i] , 5 , Len(aSql) )
		_cTipo		:= GetSx3Cache(_cCampo,"X3_TIPO")
		_cDescri	:= GetSx3Cache(_cCampo,"X3_TITULO")
		_cPicture	:= GetSx3Cache(_cCampo,"X3_PICTURE")
		_cTamanho	:= GetSx3Cache(_cCampo,"X3_TAMANHO")
		_cDecimal	:= GetSx3Cache(_cCampo,"X3_DECIMAL")
	
		Aadd( aCampos	, { _cCampo ,;
							"" ,;
							_cDescri ,;
							_cPicture } )
							
		Aadd( aStrut	, { _cCampo ,;
							_cTipo ,;
							IIF( Alltrim( Upper(_cCampo) ) $ "A1_NOME/A1_EMAIL" , 40 , _cTamanho ) ,;
							_cDecimal } )
							
	Next i

	//¦+-------------------------------------------------------------+¦
	//¦¦Cria area Temporária   		        				         ¦¦
	//¦+-------------------------------------------------------------+¦
	If Select(_cAlias1) <> 0
		(_cAlias1)->( DBCloseArea() )
	EndIf

//	cArqTrab := CriaTrab( aStrut , .T. )
//	DBUseArea( .T. , "DBFCDX" , cArqTrab , _cAlias1 , .T. , .F. )
	
	oTable := FWTemporaryTable():New(_cAlias1)
	oTable:SetFields(aStrut)
	oTable:AddIndex("1", {"E1_CLIENTE","E1_PREFIXO","E1_NUM","E1_PARCELA","E1_TIPO","E1_EMISSAO"} )
	oTable:Create()

	//¦+-------------------------------------------------------------+¦
	//¦¦Select para trazer os titulos, conforme parametros!          ¦¦
	//¦+-------------------------------------------------------------+¦
	If Select(_cAlias2) <> 0
		(_cAlias2)->( DBCloseArea() )
	EndIf

	BeginSql Alias _cAlias2
		SELECT
			SE1.E1_OK,
			SE1.E1_FILIAL,
			SE1.E1_NUMBOR,
			SE1.E1_PREFIXO,
			SE1.E1_NUM,
			SE1.E1_PARCELA,
			SE1.E1_CLIENTE,
			SE1.E1_LOJA,
			SA1.A1_NOME,
			SA1.A1_EMAIL,
			SE1.E1_EMISSAO,
			SE1.E1_VENCTO,
			SE1.E1_PORTADO,
			SE1.E1_AGEDEP,
			SE1.E1_CONTA,
			SE1.E1_TIPO,
			SE1.E1_ACRESC,
			SE1.E1_DECRESC 
		FROM
			%TABLE:SE1% SE1 
			INNER JOIN %TABLE:SA1% SA1 ON SA1.A1_COD = SE1.E1_CLIENTE AND SA1.A1_LOJA = SE1.E1_LOJA AND SA1.%NotDel%
		WHERE
			SE1.E1_SALDO > 0 
			AND SE1.%NotDel%
			//AND SE1.E1_FILIAL = %Exp:xFilial("SE1")%
			AND SE1.E1_PREFIXO BETWEEN %Exp:MV_PAR01% AND %Exp:MV_PAR02%
			AND SE1.E1_NUM BETWEEN %Exp:MV_PAR03% AND %Exp:MV_PAR04%
			AND SE1.E1_PARCELA BETWEEN %Exp:MV_PAR05% AND %Exp:MV_PAR06%
			AND SE1.E1_CLIENTE BETWEEN %Exp:MV_PAR07% AND %Exp:MV_PAR08%
			AND SE1.E1_LOJA BETWEEN %Exp:MV_PAR09% AND %Exp:MV_PAR10%
			AND SE1.E1_EMISSAO BETWEEN %Exp:MV_PAR11% AND %Exp:MV_PAR12%
			AND SE1.E1_VENCTO BETWEEN %Exp:MV_PAR13% AND %Exp:MV_PAR14%
			AND SE1.E1_NUMBOR BETWEEN %Exp:MV_PAR16% AND %Exp:MV_PAR17%
			AND SE1.E1_TIPO NOT IN (%Exp:cAbatim%)
			AND SE1.E1_XBANCO IN (%Exp:cFormpgto%)
	EndSql

	TCSetField(_cAlias2, "E1_EMISSAO"	, "D", 08, 0)
	TCSetField(_cAlias2, "E1_VENCTO"	, "D", 08, 0)

	DbSelectArea(_cAlias2)
	DbGoTop()

	//¦+-------------------------------------------------------------+¦
	//¦¦Preenche a area Temporária com informações do Select	     ¦¦
	//¦+-------------------------------------------------------------+¦
	While (_cAlias2)->( !Eof() )

		DBSelectArea(_cAlias1)
		(_cAlias1)->(RecLock( _cAlias1 , .T. ))

		For i := 1 to Len( aCampos )
			&( _cAlias1+"->"+ Alltrim( aCampos[i][1] ) ) := &( _cAlias2+"->"+ aCampos[i][1] )
		Next

		(_cAlias1)->( MsUnlock() )

		(_cAlias2)->( DBSkip() )
	EndDo

	(_cAlias2)->( DBCloseArea() )

//	cIndexKey := "E1_CLIENTE+E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO+DTOS(E1_EMISSAO)"
//	IndRegua( _cAlias1 , cArqTrab , cIndexKey ,,, "" , .F. )
//	DBSetIndex( cArqTrab + OrdBagExt() )	

	DBSelectArea(_cAlias1)	
	DBSetOrder(1)
	DBGoTop()

	If Empty(_cSubConta)   // Se estiver preenchido veio de outra rotina e o título está posicionado. Geração direta. MFIN003

		DEFINE MSDIALOG oDlg TITLE OemToAnsi("Impressão de Boletos - Seleção de Títulos") From 9,0 To 450,800 OF oMainWnd PIXEL

		oMark := MsSelect():New(_cAlias1,"E1_OK",,aCampos,@lInverte,@cMark,{35,oDlg:nLeft,oDlg:nBottom,oDlg:nRight})

		oMark:oBrowse:lhasMark 		:= .T.
		oMark:oBrowse:lCanAllmark 	:= .T.
		oMark:oBrowse:nScrollType 	:= 0
		oMark:oBrowse:Align 		:= CONTROL_ALIGN_ALLCLIENT
		oMark:bMark					:= {|| Disp() }

		ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar(oDlg,{|| lExec := .T., oDlg:End()},{||lExec := .F., oDlg:End()}) CENTER

		DbGoTop()

	Else

		// Se estiver preenchido veio de outra rotina e o título está posicionado. Geração direta. MFIN003
		(_cAlias1)->(DbGoTop())
		While (_cAlias1)->(!Eof())
			RecLock(_cAlias1,.F.)
			(_cAlias1)->E1_OK := cMark
			(_cAlias1)->( MsUnlock() )

			lExec := .T.
			(_cAlias1)->(DbSkip())
		EndDo
		(_cAlias1)->(DbGoTop())
	EndIf

	If lExec

		If _lMsg
			Processa( {|| MontaRel()}, "Aguarde...","Imprimindo os Boletos...",.F.)
		Else
			MontaRel()
		EndIf

	EndIf
	
	oTable:Delete()

Return()

/*/{Protheus.doc} Disp
@description Funcao de marcacao dos titulos
@type function
@version  
@author oficina5 - Raphael Ferreira
@since 20/10/2021
@return variant, return_description
/*/
Static Function Disp()

	(_cAlias1)->(RecLock(_cAlias1,.F.))
	If Marked("E1_OK")
		(_cAlias1)->E1_OK := cMark
	Else
		(_cAlias1)->E1_OK := ""
	Endif
	(_cAlias1)->(MsUnlock())

	oMark:oBrowse:Refresh()
Return()

/*/{Protheus.doc} MontaRel
@description Impressao do boleto
@type function
@version  
@author oficina5 - Raphael
@since 20/10/2021
@return variant, return_description
/*/
Static Function MontaRel()

	Local oPrint

	Local lStart		:= .T.
	Local lPrint		:= .T.

	Local aDadosEmp 	:= {}
	Local aDadosTit		:= {}
	Local aDadosBanco	:= {}
	Local aDatSacado	:= {}
	Local aBolText  	:= {}
	Local aCB_RN_NN 	:= {}
	Local aDadosSM0		:= {}
	Local aDadosCob		:= {}

	Local _cChave		:= ""
	Local _cCodCliM		:= ""
	Local _cNomeCli		:= ""
	Local _cMail		:= ""
	Local cTxtMulta		:= ""

	Local _cFaixAtu		:= ""
	Local _cConvenio	:= ""
	Local _cCntCorrente := ""

	Local nVlTit		:= 0
	Local nVlrAbat		:= 0
	Local nI			:= 0

	Private _cCarteira		:= ""
	Private cFilePrintert	:= ""

	(_cAlias1)->(DbGoTop())

	Do While (_cAlias1)->(!EOF())

		If Marked("E1_OK") .or. !Empty(_cSubConta)   // ou vindo de outra rotina o título está posicionado. Geração direta. MFIN003

			// cSql := "SELECT R_E_C_N_O_ AS RCNO FROM " + RetSqlName("SE1") + " WHERE E1_FILIAL = '"+ (_cAlias1)->E1_FILIAL + "' AND E1_NUM = '" + (_cAlias1)->E1_NUM + "' AND E1_PREFIXO = '" + (_cAlias1)->E1_PREFIXO + "'
			// cSql += " AND E1_PARCELA = '" + (_cAlias1)->E1_PARCELA + "' AND E1_TIPO = '"+ (_cAlias1)->E1_TIPO +"' AND D_E_L_E_T_ = '' "
			// dbUseArea(.T.,"TOPCONN",TCGENQRY(,,cSql),_cAlias2,.F.,.T.)

			BeginSql Alias _cAlias2
				SELECT R_E_C_N_O_ AS RCNO 
				FROM %TABLE:SE1% SE1
				WHERE E1_FILIAL = %ExP:(_cAlias1)->E1_FILIAL%
				AND E1_NUM		= %ExP:(_cAlias1)->E1_NUM%
				AND E1_PREFIXO	= %ExP:(_cAlias1)->E1_PREFIXO%
				AND E1_PARCELA	= %ExP:(_cAlias1)->E1_PARCELA%
				AND E1_TIPO		= %ExP:(_cAlias1)->E1_TIPO%
				AND SE1.%NotDel%
			EndSql

			DbSelectArea("SE1")
			SE1->(DbSetOrder(1))
			SE1->(dbGoTo((_cAlias2)->RCNO))

			(_cAlias2)->(DbCloseArea())

			If (_cAlias1)->E1_PREFIXO == SE1->E1_PREFIXO .And. SE1->E1_NUM == (_cAlias1)->E1_NUM .And. SE1->E1_PARCELA == (_cAlias1)->E1_PARCELA .And. SE1->E1_TIPO == (_cAlias1)->E1_TIPO

				If Empty( SE1->E1_NUMBCO) .And. Empty(SE1->E1_PORTADO) .And. Empty(SE1->E1_AGEDEP) .And. Empty(SE1->E1_CONTA)
					DbSelectArea("SA6")
					SA6->(DbSetOrder(1))
					SA6->(DbSeek(xFilial("SA6") + _cNumBco + _cNumAge + _cNumCta))

					DbSelectArea("SEE")
					SEE->(DbSetOrder(1))
					SEE->(DbSeek(xFilial("SEE") + _cNumBco + _cNumAge + _cNumCta + _cNumSCt))

				Else
					DbSelectArea("SA6")
					SA6->(DbSetOrder(1))
					If SA6->(!DbSeek(xFilial("SA6") + SE1->E1_PORTADOR + SE1->E1_AGEDEP + SE1->E1_CONTA))
						MsgAlert("Não foi possível posicionar no BANCO (SA6). Favor Acionar TI!!","BMFIN01")
						Return()
					Endif

					DbSelectArea("SEE")
					SEE->(DbSetOrder(1))
					If SEE->(!DbSeek(xFilial("SEE") + SE1->E1_PORTADOR + SE1->E1_AGEDEP + SE1->E1_CONTA + _cNumSCt))
						MsgAlert("Não foi possível posicionar no BANCO (SEE). Favor Acionar TI!!","BMFIN01")
						Return()
					Endif

					_cNumBco := SE1->E1_PORTADOR
					_cNumAge := SE1->E1_AGEDEP
					_cNumCta := SE1->E1_CONTA
				EndIf

				DbSelectArea("SA1")
				SA1->(DbSetOrder(1))
				SA1->(DbSeek(xFilial("SA1") + SE1->E1_CLIENTE + SE1->E1_LOJA))

				If MV_PAR15 == 1
					cFilePrintert := Alltrim(SE1->E1_FILIAL) + Alltrim(SE1->E1_PREFIXO)  +  Alltrim(SE1->E1_NUM)  +  Alltrim(SE1->E1_PARCELA)  +  DTOS(dDataBase)
					cCaminho := Alltrim(Iif(Empty(_cPasta),"C:\TEMP\",_cPasta))  // _cPasta veio da rotina automática - gerar fechamento

					If Substr(cCaminho,Len(cCaminho),1) <> "\"
						cCaminho := cCaminho + "\"
					Endif

					If Empty(_cPasta) // _cPasta veio da rotina automática - gerar fechamento
						oPrint := FWMsPrinter():New(cFilePrintert  , IMP_PDF, .T., , .T., , , , , , .F., )
						lPrint := oPrint:setup()
					Else
						oPrint := FWMSPrinter():New( cFilePrintert , IMP_PDF, .T., cCaminho,.T.,,,,, .F. ,, .F. )
						oPrint:cPathPDF	:= cCaminho
						oPrint:lViewPDF := .T.
					Endif

					//CRIA A SENHA
					//oPrint:SetPassword(substr(SA1->A1_CGC,1,6))
					//fim Senha
					oPrint:SetResolution(75)
					oPrint:SetPortrait()
					oPrint:SetPaperSize(DMPAPER_A4)
					oPrint:SetMargin(60,60,60,60)

				Else

					_cChave	:= ("-F"+ Alltrim(SE1->E1_FILIAL) + "-C" + Alltrim(SE1->E1_CLIENTE) + "-L" +  Alltrim(SE1->E1_LOJA) + "-P" +  Alltrim(SE1->E1_PREFIXO) + "-N" + Alltrim(SE1->E1_NUM)+"-V"+IIF(Alltrim(Str(SE1->E1_VENCREA-date()))=="0","hoje",Alltrim(Str(SE1->E1_VENCREA-date()))))

					If !lStart .And. _cCodCliM <> _cChave
						oPrint:Print()
						IncProc(Alltrim(SE1->E1_FILIAL) + Alltrim(SE1->E1_PREFIXO)  +  Alltrim(SE1->E1_NUM)  +  Alltrim(SE1->E1_PARCELA)  +  DTOS(dDataBase) + ".pdf")

						//¦+-------------------------------------------------------------+¦
						//¦¦Dispara o e-mail 							        		 ¦¦
						//¦+-------------------------------------------------------------+¦
						//ENVIAEMAIL(_cCodCliM,_cNomeCli,_cMail)

						FreeObj(oPrint)

						//¦+-------------------------------------------------------------+¦
						//¦¦ Start novo cliente			        				         ¦¦
						//¦+-------------------------------------------------------------+¦
						lStart		:= .T.
						_cCodCliM 	:= _cChave
						_cMail	  	:= Alltrim(SA1->A1_EMAIL)
						_cNomeCli	:= SubStr(Alltrim(SA1->A1_NOME),1,20)
					Endif
					
					If lStart
						cFilePrintert := "Boletos - " +  Alltrim(SE1->E1_FILIAL) + Alltrim(SE1->E1_PREFIXO)  +  Alltrim(SE1->E1_NUM) +  DTOS(dDataBase) + StrTran(time(),":")
						
						oPrint := FWMsPrinter():New(cFilePrintert, IMP_PDF, .T., , .T., , , , , ,.F., )

						//CRIA A SENHA
						oPrint:SetPassword(substr(SA1->A1_CGC,1,6))
						//fim Senha
						oPrint:cPathPDF := GetTempPath()//"\spool\" // caminho onde será gerado o boleto
						oPrint:lViewPDF := .F.
						oPrint:SetResolution(75)
						oPrint:SetPortrait() // ordem rerlatorio retrato
						oPrint:SetPaperSize(DMPAPER_A4)
						oPrint:SetMargin(60,60,60,60)

						_cCodCliM 	:= _cChave
						_cMail	  	:= Alltrim(SA1->A1_EMAIL)
						_cNomeCli	:= SubStr(Alltrim(SA1->A1_NOME),1,20)

						lStart := .F.

						If SA1->A1_BLEMAIL <> "1"
							IncProc()
							SE1->(DbSkip())
							Loop
						Endif
					Endif
				Endif

				nVlrAbat	:=  SomaAbat(SE1->E1_PREFIXO,SE1->E1_NUM,SE1->E1_PARCELA,"R",1,,SE1->E1_CLIENTE,SE1->E1_LOJA)
				nVlTit		:= ( (SE1->E1_SALDO + SE1->E1_ACRESC) - nVlrAbat - SE1->E1_DECRESC )

				If Val(SEE->EE_DIASPRT) > 0
					cMsgProtesto := "SUJEITO A PROTESTO " + StrZero(Val(SEE->EE_DIASPRT),2) + " DIAS APÓS O VENCIMENTO "
				Else
					cMsgProtesto := ""
				Endif

				If SE1->E1_TIPODES == "1" .And. SE1->E1_DESCFIN > 0
					cMsgDesconto := "DESCONTO PARA PAGAMENTO ATÉ "+ dToc(SE1->E1_VENCTO)+" - R$ "+TRANSFORM(( nVlTit * SE1->E1_DESCFIN ) / 100,"@E 999,999,999,999.99")
				ElseIf SE1->E1_TIPODES == "2" .And. SE1->E1_DESCFIN > 0
					cMsgDesconto := "DESCONTO AO DIA PARA PAGAMENTO ANTECIPADO AO VENCIMENTO - R$ "+TRANSFORM(((( nVlTit * SE1->E1_DESCFIN) / 100) / 30),"@E 999,999,999,999.99")
				Else
					cMsgDesconto := ""
				Endif

				If SEE->EE_XMULTA > 0
					cTxtMulta	:= "APÓS O VENCIMENTO COBRAR MULTA DE R$"
				EndIf

				aBolText  := {	"JUROS DE MORA DE R$ ",;
					" AO DIA.",;
					cTxtMulta,;
					cMsgProtesto,;
					cMsgDesconto,;
					SEE->EE_XMEN1,;
					SEE->EE_XMEN2	}

				//¦+-------------------------------------------------------------+¦
				//¦¦Valida as informações de Carteira / Nosso Numero/ Convenio   ¦¦
				//¦+-------------------------------------------------------------+¦
				IF SEE->EE_CODIGO == "001" // Banco Do Brasil
					_cCarteira 	:= "17"
					_cFaixAtu	:= Soma1(StrZero(Val(AllTrim(SEE->EE_FAXATU)),10))
					_cConvenio	:= AllTrim(SEE->EE_CODEMP)
					_cDvNN	  	:= ""

				ELSEIF SEE->EE_CODIGO == "399" // HSBC
					_cCarteira 	:= "CSB"
					_cFaixAtu	:= Soma1(StrZero(Val(AllTrim(SEE->EE_FAXATU)),5))
					_cConvenio	:= AllTrim(SEE->EE_CODEMP)
					_cDvNN	  	:= MODULO11(_cFaixAtu+_cConvenio)


				ELSEIF SEE->EE_CODIGO == "104" // Caixa Economica Federal
					_cCarteira 	:= "RG"
					_cFaixAtu	:= Soma1(StrZero(Val(AllTrim(SEE->EE_FAXATU)),15))
					_cConvenio	:= AllTrim(SEE->EE_CODEMP)
					_cDvNN	  	:= MODULO11(_cConvenio)


				ElSEIF SEE->EE_CODIGO == "237" // Bradesco
					_cCarteira	:= "09"
					_cFaixAtu	:= Soma1(StrZero(Val(AllTrim(SEE->EE_FAXATU)),11))
					_cConvenio	:= AllTrim(SEE->EE_CODEMP)
					_cDvNN	  	:= ""

				ElSEIF SEE->EE_CODIGO == "341" // Itaú 08/06/16
					_cCarteira	:= Alltrim(SEE->EE_CODCART)
					_cFaixAtu	:= StrZero(Val(Alltrim(SEE->EE_FAXATU))+1,12)
					_cConvenio	:= AllTrim(SEE->EE_CODEMP)
					_cDvNN	  	:= ""

				ElSEIF SEE->EE_CODIGO == "033" // Santander
					_cCarteira	:= SEE->EE_CODCART
					_cFaixAtu	:= StrZero(Val(Alltrim(SEE->EE_FAXATU))+1,12)
					_cConvenio	:= AllTrim(SEE->EE_CODEMP)
					_cDvNN	  	:= ""

				ElSEIF SEE->EE_CODIGO == "756" // SICOOB
					_cCarteira	:= Alltrim(SEE->EE_CODCART)
					_cFaixAtu	:= Soma1(StrZero(Val(AllTrim(SEE->EE_FAXATU)),7))
					_cConvenio	:= AllTrim(SEE->EE_CODEMP)
					_cDvNN	  	:= ""
				ENDIF

				If Empty(SE1->E1_NUMBCO)
					//Gravo o incremendo na faixa nos parametros de banco
					RecLock("SEE",.F.)
					SEE->EE_FAXATU := _cFaixAtu
					SEE->(MsUnlock())

				Else //Caso o nosso número já exista, busco do titulo

					_cDvNN	  	:= ""

					If SEE->EE_CODIGO == "001"
						_cFaixAtu	:= SubStr(Alltrim(SE1->E1_NUMBCO),8,Len(Alltrim(SE1->E1_NUMBCO)))

					ElseIf SEE->EE_CODIGO == "104"
						_cFaixAtu 	:= Substr(AllTrim(SE1->E1_NUMBCO),3,Len(Alltrim(SE1->E1_NUMBCO)))

					ElseIf SEE->EE_CODIGO == "237"
						_cFaixAtu 	:= SubStr(AllTrim(SE1->E1_NUMBCO),1,Len(Alltrim(SE1->E1_NUMBCO)) -1)

					ElseIf SEE->EE_CODIGO == "341"
						_cFaixAtu 	:= SubStr(AllTrim(SE1->E1_NUMBCO),1,Len(Alltrim(SE1->E1_NUMBCO)) -1)

					ElseIf SEE->EE_CODIGO == "033"
						_cFaixAtu 	:= AllTrim(SE1->E1_NUMBCO)

					ElseIf SEE->EE_CODIGO == "756"
						_cFaixAtu 	:= SubStr(AllTrim(SE1->E1_NUMBCO),1,Len(Alltrim(SE1->E1_NUMBCO)) -1)
					Endif
				Endif

				DbSelectArea("SE1")

				If SA6->A6_COD == "399"
					_cCntCorrente := StrZero(Val(SA6->A6_NUMCON),5)

				ElseIf SA6->A6_COD == "237"
					_cCntCorrente := Strzero(Val(SA6->A6_NUMCON),7)

				ElseIf SA6->A6_COD == "341"
					_cCntCorrente := StrZero(Val(SA6->A6_NUMCON),5)

				ElseIf SA6->A6_COD == "033"
					_cCntCorrente := Alltrim(SA6->A6_NUMCON)

				ElseIf SA6->A6_COD == "756"
					_cCntCorrente := Strzero(Val(SA6->A6_NUMCON),7)

				Else
					_cCntCorrente := StrZero(Val(SA6->A6_NUMCON),10)

				Endif

				aDadosBanco  := {	SA6->A6_COD							,; // [1]Numero do Banco
				SA6->A6_NREDUZ						,; // [2]Nome do Banco
				SA6->A6_AGENCIA						,; // [3]Agência
				_cCntCorrente						,; // [4]Conta Corrente
				SA6->A6_DVCTA						,; // [5]Dígito da conta corrente  -> SUBSTR(SA6->A6_NUMCON,Len(AllTrim(SA6->A6_NUMCON)),1),;
					_cCarteira							,; // [6]Codigo da Carteira
				Substr(SA6->A6_AGENCIA,6,1)			 } // [7]Digito da Agência

				If Empty(SEE->EE_XCNPJ)
					aDadosEmp := {	SM0->M0_NOMECOM										,;//[1]	Nome da Empresa //SM0->M0_NOMECOM
					SM0->M0_ENDCOB									   	,;//[2]	Endereco //SM0->M0_ENDCOB
					SM0->M0_BAIRCOB                                     ,;//[3] Bairro
					SM0->M0_CIDCOB                                      ,;//[4] Cidade
					SM0->M0_ESTCOB									   	,;//[5]	Estado
					Transform(SM0->M0_CEPCOB,PesqPict("SA1","A1_CEP"))  ,;//[6]	CEP
					SM0->M0_TEL										   	,;//[7]	Telefone
					SM0->M0_CGC										   	,;//[8]	CNPJ
					Subs(SM0->M0_INSC,1,3)+"."+Subs(SM0->M0_INSC,4,3)+"."+ ;
						Subs(SM0->M0_INSC,7,3)+"."+Subs(SM0->M0_INSC,10,3)	 }//[9] Inscricao Estadual
				Else
					aDadosSM0	:= FWLoadSM0()

					For nI:=1 To Len(aDadosSM0)
						If AllTrim(aDadosSM0[nI][18]) == AllTrim(SEE->EE_XCNPJ)

							aDadosCob	:= FWSM0Util():GetSM0Data( aDadosSM0[nI][1] , aDadosSM0[nI][2] , {"M0_NOMECOM", "M0_ENDCOB", "M0_BAIRCOB", "M0_CIDCOB", "M0_ESTCOB", "M0_CEPCOB", "M0_TEL", "M0_CGC", "M0_INSC"} )

							aDadosEmp := {	aDadosCob[1][2]						,;//[1]	Nome da Empresa //SM0->M0_NOMECOM
							aDadosCob[2][2]									   	,;//[2]	Endereco //SM0->M0_ENDCOB
							aDadosCob[3][2]                                     ,;//[3] Bairro
							aDadosCob[4][2]                                     ,;//[4] Cidade
							aDadosCob[5][2]									   	,;//[5]	Estado
							Transform(aDadosCob[6][2],PesqPict("SA1","A1_CEP")) ,;//[6]	CEP
							aDadosCob[7][2]									   	,;//[7]	Telefone
							aDadosCob[8][2]									   	,;//[8]	CNPJ
							Subs(aDadosCob[9][2],1,3)+"."+Subs(aDadosCob[9][2],4,3)+"."+ ;
								Subs(aDadosCob[9][2],7,3)+"."+Subs(aDadosCob[9][2],10,3)	 }//[9] Inscricao Estadual
						EndIf
					Next nI

					If Empty(aDadosEmp)
						aDadosEmp := {	SM0->M0_NOMECOM						,;//[1]	Nome da Empresa //SM0->M0_NOMECOM
						SM0->M0_ENDCOB									   	,;//[2]	Endereco //SM0->M0_ENDCOB
						SM0->M0_BAIRCOB                                     ,;//[3] Bairro
						SM0->M0_CIDCOB                                      ,;//[4] Cidade
						SM0->M0_ESTCOB									   	,;//[5]	Estado
						Transform(SM0->M0_CEPCOB,PesqPict("SA1","A1_CEP"))  ,;//[6]	CEP
						SM0->M0_TEL										   	,;//[7]	Telefone
						SM0->M0_CGC										   	,;//[8]	CNPJ
						Subs(SM0->M0_INSC,1,3)+"."+Subs(SM0->M0_INSC,4,3)+"."+ ;
							Subs(SM0->M0_INSC,7,3)+"."+Subs(SM0->M0_INSC,10,3)	 }//[9] Inscricao Estadual
					EndIf

				EndIf

				If Empty(SA1->A1_ENDCOB)
					aDatSacado   := {	AllTrim(SA1->A1_NOME)           				 ,; // [1]Razão Social
					AllTrim(SA1->A1_COD )+"-"+SA1->A1_LOJA           ,; // [2]Código
					AllTrim(SA1->A1_END )+"-"+AllTrim(SA1->A1_BAIRRO),; // [3]Endereço
					AllTrim(SA1->A1_MUN )                            ,; // [4]Cidade
					SA1->A1_EST                                      ,; // [5]Estado
					SA1->A1_CEP                                      ,; // [6]CEP
					SA1->A1_CGC									  	 ,;	// [7]CGC
					SA1->A1_PESSOA									  } // [8]PESSOA
				Else
					aDatSacado   := {	AllTrim(SA1->A1_NOME)            						,;   	// [1]Razão Social
					AllTrim(SA1->A1_COD )+"-"+SA1->A1_LOJA              	,;   	// [2]Código
					AllTrim(SA1->A1_ENDCOB)+"-"+AllTrim(SA1->A1_BAIRROC)	,;   	// [3]Endereço
					AllTrim(SA1->A1_MUNC)	                            	,;   	// [4]Cidade
					SA1->A1_ESTC	                                    	,;   	// [5]Estado
					SA1->A1_CEPC                                       		,;   	// [6]CEP
					SA1->A1_CGC												,;		// [7]CGC
					SA1->A1_PESSOA											}		// [8]PESSOA
				Endif

				nVlrAbat	:=  SomaAbat(SE1->E1_PREFIXO,SE1->E1_NUM,SE1->E1_PARCELA,"R",1,,SE1->E1_CLIENTE,SE1->E1_LOJA)
				nVlTit		:= ( (SE1->E1_SALDO + SE1->E1_ACRESC) - nVlrAbat - SE1->E1_DECRESC )

				//Função que monta o código de barras, nosso numero e linha digitavel
				aCB_RN_NN := {}
				aCB_RN_NN := Ret_cBarra( aDadosBanco[1],aDadosBanco[3],aDadosBanco[4],aDadosBanco[5],aDadosBanco[6],nVlTit,_cConvenio,_cFaixAtu,_cDvNN )

				//Array com os dados dos títulos
				aDadosTit	:= {	AllTrim(SE1->E1_NUM)+AllTrim(SE1->E1_PARCELA)				,; // [1] Número do título
				SE1->E1_EMISSAO                              				,; // [2] Data da emissão do título
				dDataBase                    								,; // [3] Data da emissão do boleto
				SE1->E1_VENCTO                               				,; // [4] Data do vencimento
				nVlTit						             					,; // [5] Valor do título
				IIF(aDadosBanco[1] $ "399/237/341/033/756" ,aCB_RN_NN[3]+ "-" + aCB_RN_NN[4],aCB_RN_NN[3])	,; // [6] Nosso número
				SE1->E1_PREFIXO                               				,; // [7] Prefixo da NF
				SE1->E1_TIPO	                           					,; // [8] Tipo do Titulo
				SE1->E1_DECRESC                               				,; // [9] Valor do desconto
				SE1->E1_VALJUR												 } //[10] VALOR DA TAXA PERMANENCIA

				//¦+-----------------------------+¦
				//¦¦Faz a Impressão do Boleto    ¦¦
				//¦+-----------------------------+¦
				Impress(oPrint,aDadosEmp,aDadosTit,aDadosBanco,aDatSacado,aBolText,aCB_RN_NN,_cConvenio)

				If MV_PAR15 == 1
					oPrint:Print()
					IncProc(oPrint:cPathPDF + Alltrim(SE1->E1_FILIAL) + Alltrim(SE1->E1_PREFIXO)  +  Alltrim(SE1->E1_NUM)  +  Alltrim(SE1->E1_PARCELA)  +  DTOS(dDataBase) + ".pdf")
					FreeObj(oPrint)
				Endif
			EndIf

		Endif

		DbSelectArea(_cAlias1)
		(_cAlias1)->(DbSkip())
	EndDo

	If MV_PAR15 == 2 .And. (_cAlias1)->(EOF()) .And.  Alltrim(SE1->E1_NUM) <> ""
		oPrint:Print(.F.)
		IncProc(Alltrim(SE1->E1_FILIAL) + Alltrim(SE1->E1_PREFIXO)  +  Alltrim(SE1->E1_NUM)  +  Alltrim(SE1->E1_PARCELA)  +  DTOS(dDataBase) + ".pdf")
		ENVIAEMAIL(_cCodCliM,_cNomeCli,_cMail)
	Endif

	(_cAlias1)->(DbCloseArea())

Return()

/*/{Protheus.doc} Impress
@description Impressao do boelto
@type function
@version  
@author oficina5 - Raphael Ferreira
@since 20/10/2021
@param oPrint, object, param_description
@param aDadosEmp, array, param_description
@param aDadosTit, array, param_description
@param aDadosBanco, array, param_description
@param aDatSacado, array, param_description
@param aBolText, array, param_description
@param aCB_RN_NN, array, param_description
@param _cConvenio, variant, param_description
@return variant, return_description
/*/
Static Function Impress(oPrint,aDadosEmp,aDadosTit,aDadosBanco,aDatSacado,aBolText,aCB_RN_NN,_cConvenio)

	Local oFont8
	Local oFont8n
	Local oFont11c
	Local oFont11
	Local oFont10
	Local oFont13
	Local oFont16n
	Local oFont15
	Local oFont14n
	Local oFont24
	Local nI := 0
	Local cNosNum := ''

	oPrint:StartPage()// Inicia uma nova pagina

	//Parametros de TFont.New()
	//1.Nome da Fonte (Windows)
	//3.Tamanho em Pixels
	//5.Bold (T/F)
	oFont8   := TFont():New("Arial",9,10,.T.,.F.,5,.T.,5,.T.,.F.)
	oFont8n	 := TFont():New("Arial",9,10,.T.,.T.,5,.T.,5,.T.,.F.)
	oFont9   := TFont():New("Arial",9,10,.T.,.F.,5,.T.,5,.T.,.F.)
	oFont11c := TFont():New("Courier New",9,11,.T.,.T.,5,.T.,5,.T.,.F.)
	oFont10  := TFont():New("Arial",9,11,.T.,.T.,5,.T.,5,.T.,.F.)
	oFont11  := TFont():New("Arial",9,12,.T.,.T.,5,.T.,5,.T.,.F.)
	oFont13  := TFont():New("Arial",9,14,.T.,.T.,5,.T.,5,.T.,.F.)
	oFont18  := TFont():New("Arial",9,19,.T.,.T.,5,.T.,5,.T.,.F.)
	oFont20  := TFont():New("Arial",9,21,.T.,.T.,5,.T.,5,.T.,.F.)
	oFont21  := TFont():New("Arial",9,22,.T.,.T.,5,.T.,5,.T.,.F.)
	oFont22n := TFont():New("Arial",9,23,.T.,.T.,5,.T.,5,.T.,.F.)
	oFont16n := TFont():New("Arial",9,17,.T.,.F.,5,.T.,5,.T.,.F.)
	oFont15  := TFont():New("Arial",9,16,.T.,.T.,5,.T.,5,.T.,.F.)
	oFont15n := TFont():New("Arial",9,16,.T.,.F.,5,.T.,5,.T.,.F.)
	oFont14n := TFont():New("Arial",9,16,.T.,.F.,5,.T.,5,.T.,.F.)
	oFont24  := TFont():New("Arial",9,25,.T.,.T.,5,.T.,5,.T.,.F.)

	//¦+-------------------------------------------------------------+¦
	//¦¦ Banco Do Brasil                     				         ¦¦
	//¦+-------------------------------------------------------------+¦
	IF aDadosBanco[1] == "001"

		/******************/
		/* PRIMEIRA PARTE */
		/******************/
		nRow1 := 0

		oPrint:Line (nRow1+0120,500,nRow1+0040, 500)
		oPrint:Line (nRow1+0120,710,nRow1+0040, 710)
		oPrint:SayBitmap(nRow1+0020,100,"BOL001.JPG",0350,0090)

		oPrint:Say  (nRow1+0080,510,aDadosBanco[1]+"-9",oFont20 )		// [1]Numero do Banco

		oPrint:Say  (nRow1+0084,1900,"Comprovante de Entrega",oFont10)
		oPrint:Line (nRow1+0120,100,nRow1+0120,2300)

		oPrint:Say  (nRow1+0150,100 ,"Beneficiário",oFont8)
		oPrint:Say  (nRow1+0200,100 ,aDadosEmp[1],oFont8)					//Nome + CNPJ

		oPrint:Say  (nRow1+0150,1060,"Agência/Código Beneficiário",oFont8)
		oPrint:Say  (nRow1+0200,1080,AllTrim(aDadosBanco[3]) + "-" + SA6->A6_DVAGE + " / " + aDadosBanco[4] + "-" + aDadosBanco[5],oFont10)

		oPrint:Say  (nRow1+0150,1510,"Nro.Documento",oFont8)
		oPrint:Say  (nRow1+0200,1510,aDadosTit[7]+aDadosTit[1],oFont10) //Prefixo +Numero+Parcela

		oPrint:Say  (nRow1+0250,100 ,"Pagador",oFont8)
		oPrint:Say  (nRow1+0300,100 ,left(aDatSacado[1],40),oFont10)	//Nome

		oPrint:Say  (nRow1+0250,1060,"Vencimento",oFont8)
		oPrint:Say  (nRow1+0300,1060,StrZero(Day(aDadosTit[4]),2) +"/"+ StrZero(Month(aDadosTit[4]),2) +"/"+ Right(Str(Year(aDadosTit[4])),4),oFont10)

		oPrint:Say  (nRow1+0250,1510,"Valor do Documento",oFont8)
		oPrint:Say  (nRow1+0300,1550,AllTrim(Transform(aDadosTit[5],"@E 999,999,999.99")),oFont10)

		oPrint:Say  (nRow1+0400,0100,"Recebi(emos) o bloqueto/título"	,oFont10 )
		oPrint:Say  (nRow1+0450,0100,"com as caracteristicas acima."	,oFont10 )
		oPrint:Say  (nRow1+0350,1060,"Data"								,oFont8  )
		oPrint:Say  (nRow1+0350,1410,"Assinatura"						,oFont8  )
		oPrint:Say  (nRow1+0450,1060,"Data"								,oFont8  )
		oPrint:Say  (nRow1+0450,1410,"Entregador"						,oFont8  )

		oPrint:Line (nRow1+0220, 100,nRow1+0220,1900 )
		oPrint:Line (nRow1+0320, 100,nRow1+0320,1900 )
		oPrint:Line (nRow1+0420,1050,nRow1+0420,1900 )
		oPrint:Line (nRow1+0520, 100,nRow1+0520,2300 )

		oPrint:Line (nRow1+0520,1050,nRow1+0120,1050 )
		oPrint:Line (nRow1+0520,1400,nRow1+0320,1400 )
		oPrint:Line (nRow1+0320,1500,nRow1+0120,1500 )
		oPrint:Line (nRow1+0520,1900,nRow1+0120,1900 )

		oPrint:Say  ( nRow1+0165,1910,"(  )Mudou-se"					,oFont8 )
		oPrint:Say  ( nRow1+0205,1910,"(  )Ausente"						,oFont8 )
		oPrint:Say  ( nRow1+0245,1910,"(  )Não existe não indicado"		,oFont8 )
		oPrint:Say  ( nRow1+0285,1910,"(  )Recusado"					,oFont8 )
		oPrint:Say  ( nRow1+0325,1910,"(  )Não procurado"				,oFont8 )
		oPrint:Say  ( nRow1+0365,1910,"(  )Endeço insuficiente"			,oFont8 )
		oPrint:Say  ( nRow1+0405,1910,"(  )Desconhecido"				,oFont8 )
		oPrint:Say  ( nRow1+0445,1910,"(  )Falecido"					,oFont8 )
		oPrint:Say  ( nRow1+0485,1910,"(  )Outros(anotar no verso)"		,oFont8 )

		/*****************/
		/* SEGUNDA PARTE */
		/*****************/
		nRow2 := 110

		//Pontilhado separador
		For nI := 100 to 2300 step 50
			oPrint:Line(nRow2+0550, nI,nRow2+0550, nI+30)
		Next nI

		oPrint:Line (nRow2+0680,100,nRow2+0680,2300)
		oPrint:Line (nRow2+0680,500,nRow2+0600, 500)
		oPrint:Line (nRow2+0680,710,nRow2+0600, 710)
		oPrint:SayBitmap(nRow2+0580,100,"BOL001.JPG",0350,0090)

		oPrint:Say  (nRow2+0640,510,aDadosBanco[1]+"-9",oFont20 )	// [1]Numero do Banco

		oPrint:Say  (nRow2+0640,715,aCB_RN_NN[2],oFont15)  	//	Linha Digitavel do Codigo de Barras

		oPrint:Say  (nRow2+0644,2030,"Recibo do Pagador",oFont10)

		oPrint:Line (nRow2+0780,100,nRow2+0780,2300 )
		oPrint:Line (nRow2+0880,100,nRow2+0880,2300 )
		oPrint:Line (nRow2+0880,1800,nRow2+0880,2300 )

		oPrint:Line (nRow2+0950,100,nRow2+0950,2300 )
		oPrint:Line (nRow2+1020,100,nRow2+1020,2300 )
		oPrint:Line (nRow2+0880,500,nRow2+1020,500)
		oPrint:Line (nRow2+0950,770,nRow2+1020,770)
		oPrint:Line (nRow2+0880,1000,nRow2+1020,1000)
		oPrint:Line (nRow2+0880,1300,nRow2+0950,1300)
		oPrint:Line (nRow2+0880,1480,nRow2+1020,1480)

		oPrint:Say  (nRow2+0710,100 ,"Local de Pagamento",oFont8)
		oPrint:Say  (nRow2+0750,100 ,"PAGÁVEL EM QUALQUER BANCO.",oFont10)
		oPrint:Say  (nRow2+0765,400 ," ",oFont10)

		oPrint:Say  (nRow2+0710,1810,"Vencimento",oFont8)
		cString	:= StrZero(Day(aDadosTit[4]),2) +"/"+ StrZero(Month(aDadosTit[4]),2) +"/"+ Right(Str(Year(aDadosTit[4])),4)
		nCol := 1810+(374-(len(cString)*22))
		oPrint:Say  (nRow2+0750,nCol,cString,oFont11c)

		oPrint:Say  (nRow2+0810,100 ,"Beneficiário",oFont8)
		oPrint:Say  (nRow2+0840,100 ,AllTrim(aDadosEmp[1]) ,oFont8) //Nome + CNPJ   // + " - " + aDadosEmp[2]
		oPrint:Say  (nRow2+0835+35,100 ,AllTrim(aDadosEmp[2]) + " -  " + aDadosEmp[3] + " - " + AllTrim(aDadosEmp[4]) + " -  " + aDadosEmp[5] + " -  " + aDadosEmp[6],oFont8) //Endereço e Bairro, Cidade, Estado e Cep

		oPrint:Say  (nRow2+0810,1300 ,"CNPJ Beneficiário: " + Transform(aDadosEmp[8],"@R 99.999.999/9999-99") ,oFont8)

		oPrint:Say  (nRow2+0810,1810,"Agência/Código Beneficiário",oFont8)
		cString := Alltrim(AllTrim(aDadosBanco[3])  + "-" + SA6->A6_DVAGE + " / " + aDadosBanco[4] + "-" + aDadosBanco[5])
		oPrint:Say  (nRow2+0850,1830,cString,oFont11c)

		oPrint:Say  (nRow2+0910,100 ,"Data do Documento",oFont8)
		oPrint:Say  (nRow2+0940,100, StrZero(Day(aDadosTit[2]),2) +"/"+ StrZero(Month(aDadosTit[2]),2) +"/"+ Right(Str(Year(aDadosTit[2])),4),oFont10)

		oPrint:Say  (nRow2+0910,505 ,"Nro.Documento",oFont8)
		oPrint:Say  (nRow2+0940,605 ,aDadosTit[7]+aDadosTit[1],oFont10) //Prefixo +Numero+Parcela

		oPrint:Say  (nRow2+0910,1005,"Especie Doc.",oFont8)
		oPrint:Say  (nRow2+0940,1050,"DM",oFont10) 		  //Tipo do Titulo

		oPrint:Say  (nRow2+0910,1305,"Aceite",oFont8)
		oPrint:Say  (nRow2+0940,1400,"N",oFont10)

		oPrint:Say  (nRow2+0910,1485,"Data do Processamento",oFont8)
		oPrint:Say  (nRow2+0940,1550,StrZero(Day(aDadosTit[3]),2) +"/"+ StrZero(Month(aDadosTit[3]),2) +"/"+ Right(Str(Year(aDadosTit[3])),4),oFont10) // Data impressao

		oPrint:Say  (nRow2+0910,1810,"Nosso Número",oFont8)
		cString := Alltrim(aDadosTit[6])
		nCol := 1810+(374-(len(cString)*22))
		oPrint:Say  (nRow2+0940,nCol,cString,oFont11c)

		oPrint:Say  (nRow2+0980,100 ,"Uso do Banco",oFont8)

		oPrint:Say  (nRow2+0980,505 ,"Carteira",oFont8)
		oPrint:Say  (nRow2+1010,500 ,aDadosBanco[6],oFont9)

		oPrint:Say  (nRow2+0980,775 ,"Especie",oFont8)
		oPrint:Say  (nRow2+1010,805 ,"REAL",oFont10)
		oPrint:Say  (nRow2+0980,1005,"Quantidade",oFont8)
		oPrint:Say  (nRow2+0980,1485,"Valor"     ,oFont8)

		oPrint:Say  (nRow2+0980,1810,"Valor do Documento",oFont8)
		cString := Alltrim(Transform(aDadosTit[5],"@E 99,999,999.99"))
		nCol := 1810+(374-(len(cString)*22))
		oPrint:Say  (nRow2+1010,nCol,cString ,oFont11c)

		oPrint:Say  (nRow2+1050,100 ,"Instruções (Todas informações deste bloqueto são de exclusiva responsabilidade do Beneficiário)",oFont8)
		oPrint:Say  (nRow2+1050,1450 ,"Bordero Nro :"+SE1->E1_NUMBOR,oFont10)

		oPrint:Say  (nRow2+1100,100 ,aBolText[6] ,oFont10)
		oPrint:Say  (nRow2+1150,100 ,aBolText[1]+" " + AllTrim(Transform(((aDadosTit[5] * SE1->E1_PORCJUR ) / 100),"@E 999,999.99")+""+aBolText[2])  ,oFont10) // Juros de Mora de R$ xxxx ao Dia

		If SEE->EE_XMULTA > 0
			oPrint:Say  (nRow2+1200,100 ,aBolText[3]+" " + AllTrim(Transform(((aDadosTit[5] * SEE->EE_XMULTA) / 100),"@E 999,999.99"))+"",oFont10)  //  Apos venciamento multa de R$ xxxxx
		EndIf

		oPrint:Say  (nRow2+1250,100 ,aBolText[4] ,oFont10)
		oPrint:Say  (nRow2+1300,100 ,aBolText[5] ,oFont10)
		oPrint:Say  (nRow2+1350,100 ,aBolText[7] ,oFont10)

		oPrint:Say  (nRow2+1050,1810,"(-)Desconto/Abatimento",oFont8)
		oPrint:Say  (nRow2+1120,1810,"(-)Outras Deduções"    ,oFont8)
		oPrint:Say  (nRow2+1190,1810,"(+)Mora/Multa"         ,oFont8)
		oPrint:Say  (nRow2+1260,1810,"(+)Outros Acréscimos"  ,oFont8)
		oPrint:Say  (nRow2+1330,1810,"(=)Valor Cobrado"      ,oFont8)

		oPrint:Say  (nRow2+1400,100 ,"Pagador",oFont8)
		oPrint:Say  (nRow2+1430,350 ,LEFT(aDatSacado[1],45)+" ("+aDatSacado[2]+")",oFont10)
		oPrint:Say  (nRow2+1483,350 ,aDatSacado[3],oFont10)
		oPrint:Say  (nRow2+1536,350 ,aDatSacado[6]+"    "+aDatSacado[4]+" - "+aDatSacado[5],oFont10) // CEP+Cidade+Estado

		if aDatSacado[8] = "J"
			oPrint:Say  (nRow2+1589,350 ,"CNPJ: " + TRANSFORM(aDatSacado[7],"@R 99.999.999/9999-99"),oFont10) // CGC
		Else
			oPrint:Say  (nRow2+1589,350 ,"CPF: " + TRANSFORM(aDatSacado[7],"@R 999.999.999-99"),oFont10) 	// CPF
		EndIf

		oPrint:Say  (nRow2+1605,100 ,"Sacador/Avalista",oFont8)
		oPrint:Say  (nRow2+1645,1500,"Autenticacao Mecanica",oFont8)

		oPrint:Line (nRow2+0680,1800,nRow2+1370,1800 )
		oPrint:Line (nRow2+1090,1800,nRow2+1090,2300 )
		oPrint:Line (nRow2+1160,1800,nRow2+1160,2300 )
		oPrint:Line (nRow2+1230,1800,nRow2+1230,2300 )
		oPrint:Line (nRow2+1300,1800,nRow2+1300,2300 )
		oPrint:Line (nRow2+1370,100 ,nRow2+1370,2300 )
		oPrint:Line (nRow2+1610,100 ,nRow2+1610,2300 )

		/******************/
		/* TERCEIRA PARTE */
		/******************/

		nRow3 := 20

		For nI := 100 to 2300 step 50
			oPrint:Line(nRow3+1850, nI, nRow3+1850, nI+30)
		Next nI

		oPrint:Line (nRow3+1970,100,nRow3+1970,2300)
		oPrint:Line (nRow3+1970,500,nRow3+1890, 500)
		oPrint:Line (nRow3+1970,710,nRow3+1890, 710)
		oPrint:SayBitmap(nRow3+1870,100,"BOL001.JPG",0350,0090)

		oPrint:Say  (nRow3+1930,510,aDadosBanco[1]+"-9",oFont20 )	// 	[1]Numero do Banco

		oPrint:Say  (nRow3+1934,715,aCB_RN_NN[2],oFont15)  	//	Linha Digitavel do Codigo de Barras

		oPrint:Line (nRow3+2070,100,nRow3+2070,2300 )
		oPrint:Line (nRow3+2170,100,nRow3+2170,2300 )
		oPrint:Line (nRow3+2240,100,nRow3+2240,2300 )
		oPrint:Line (nRow3+2310,100,nRow3+2310,2300 )

		oPrint:Line (nRow3+2170,500 ,nRow3+2310,500 )
		oPrint:Line (nRow3+2240,770 ,nRow3+2310,770 )
		oPrint:Line (nRow3+2170,1000,nRow3+2310,1000)
		oPrint:Line (nRow3+2170,1300,nRow3+2240,1300)
		oPrint:Line (nRow3+2170,1480,nRow3+2310,1480)

		oPrint:Say  (nRow3+2000,100 ,"Local de Pagamento",oFont8)
		oPrint:Say  (nRow3+2040,100 ,"PAGÁVEL EM QUALQUER BANCO.",oFont10)

		oPrint:Say  (nRow3+2055,400 ," ",oFont10)

		oPrint:Say  (nRow3+2000,1810,"Vencimento",oFont8)
		cString := StrZero(Day(aDadosTit[4]),2) +"/"+ StrZero(Month(aDadosTit[4]),2) +"/"+ Right(Str(Year(aDadosTit[4])),4)
		nCol	 	 := 1810+(374-(len(cString)*22))
		oPrint:Say  (nRow3+2040,nCol,cString,oFont11c)

		oPrint:Say  (nRow3+2100,100 ,"Beneficiário",oFont8)

		oPrint:Say  (nRow3+2135,100 ,AllTrim(aDadosEmp[1]) ,oFont8) //Nome + CNPJ   // + " - " + aDadosEmp[2]
		oPrint:Say  (nRow3+2135+30,100 ,AllTrim(aDadosEmp[2]) + " -  " + aDadosEmp[3] + " - " + AllTrim(aDadosEmp[4]) + " -  " + aDadosEmp[5] + " -  " + aDadosEmp[6],oFont8) //Endereço e Bairro, Cidade, Estado e Cep

		oPrint:Say  (nRow3+2100,1300 ,"CNPJ Beneficiário: " + Transform(aDadosEmp[8],"@R 99.999.999/9999-99") ,oFont8)

		oPrint:Say  (nRow3+2100,1810,"Agência/Código Beneficiário",oFont8)
		cString := Alltrim(AllTrim(aDadosBanco[3]) + "-" + SA6->A6_DVAGE + " / " + aDadosBanco[4] + "-" + aDadosBanco[5])
		oPrint:Say  (nRow3+2140,1830,cString ,oFont11c)

		oPrint:Say  (nRow3+2200,100 ,"Data do Documento",oFont8)
		oPrint:Say (nRow3+2230,100, StrZero(Day(aDadosTit[2]),2) +"/"+ StrZero(Month(aDadosTit[2]),2) +"/"+ Right(Str(Year(aDadosTit[2])),4), oFont10)

		oPrint:Say  (nRow3+2200,505 ,"Nro.Documento",oFont8)
		oPrint:Say  (nRow3+2230,605 ,aDadosTit[7]+aDadosTit[1],oFont10) //Prefixo +Numero+Parcela

		oPrint:Say  (nRow3+2200,1005,"Especie Doc.",oFont8)
		oPrint:Say  (nRow3+2230,1050,"DM",oFont10) 		  //Tipo do Titulo

		oPrint:Say  (nRow3+2200,1305,"Aceite",oFont8)
		oPrint:Say  (nRow3+2230,1400,"N"     ,oFont10)

		oPrint:Say  (nRow3+2200,1485,"Data do Processamento",oFont8)
		oPrint:Say  (nRow3+2230,1550,StrZero(Day(aDadosTit[3]),2) +"/"+ StrZero(Month(aDadosTit[3]),2) +"/"+ Right(Str(Year(aDadosTit[3])),4)                               ,oFont10) // Data impressao

		oPrint:Say  (nRow3+2200,1810,"Nosso Número",oFont8)
		cString := Alltrim(aDadosTit[6])
		nCol := 1810+(374-(len(cString)*22))
		oPrint:Say  (nRow3+2230,nCol,cString,oFont11c)

		oPrint:Say  (nRow3+2270,100 ,"Uso do Banco",oFont8)

		oPrint:Say  (nRow3+2270,505 ,"Carteira"	,oFont8)
		oPrint:Say  (nRow3+2300,500 ,aDadosBanco[6],oFont9)

		oPrint:Say  (nRow3+2270,775 ,"Espécie"	,oFont8)
		oPrint:Say  (nRow3+2300,805 ,"R$"     ,oFont10)
		oPrint:Say  (nRow3+2270,1005,"Quantidade",oFont8)
		oPrint:Say  (nRow3+2270,1485,"Valor"     ,oFont8)

		oPrint:Say  (nRow3+2270,1810,"Valor do Documento",oFont8)
		cString := Alltrim(Transform(aDadosTit[5],"@E 99,999,999.99"))
		nCol 	 := 1810+(374-(len(cString)*22))
		oPrint:Say  (nRow3+2300,nCol,cString,oFont11c)

		oPrint:Say  (nRow3+2340,100 ,"Instruções (Todas informações deste bloqueto são de exclusiva responsabilidade do Beneficiário)",oFont8)
		oPrint:Say  (nRow3+2340,1450 ,"Bordero Nro :"+SE1->E1_NUMBOR,oFont10)

		oPrint:Say  (nRow3+2390,100 ,aBolText[6] ,oFont10)

		oPrint:Say  (nRow3+2440,100 ,aBolText[1]+" " + AllTrim(Transform( ((aDadosTit[5] * SE1->E1_PORCJUR ) / 100) ,"@E 999,999.99")+""+aBolText[2])  ,oFont10) // Juros de Mora de R$ xxxx ao Dia

		If SEE->EE_XMULTA > 0
			oPrint:Say  (nRow3+2490,100 ,aBolText[3]+" " + AllTrim(Transform(((aDadosTit[5] * SEE->EE_XMULTA) / 100),"@E 999,999.99"))+"",oFont10)  //  Apos venciamento multa de R$ xxxxx
		EndIf

		oPrint:Say  (nRow3+2540,100 ,aBolText[4] ,oFont10)
		oPrint:Say  (nRow3+2590,100 ,aBolText[5] ,oFont10)
		oPrint:Say  (nRow3+2640,100 ,aBolText[7] ,oFont10)

		oPrint:Say  (nRow3+2340,1810,"(-)Desconto/Abatimento",oFont8)
		oPrint:Say  (nRow3+2410,1810,"(-)Outras Deduções"    ,oFont8)
		oPrint:Say  (nRow3+2480,1810,"(+)Mora/Multa"         ,oFont8)
		oPrint:Say  (nRow3+2550,1810,"(+)Outros Acréscimos"  ,oFont8)
		oPrint:Say  (nRow3+2620,1810,"(=)Valor Cobrado"      ,oFont8)

		oPrint:Say  (nRow3+2690,100 ,"Pagador",oFont8)
		oPrint:Say  (nRow3+2700,350 ,LEFT(aDatSacado[1],45)+" ("+aDatSacado[2]+")",oFont10)

		if aDatSacado[8] = "J"
			oPrint:Say (nRow3+2700,1800,"CNPJ: "+TRANSFORM(aDatSacado[7],"@R 99.999.999/9999-99"),oFont10) // CGC
		Else
			oPrint:Say (nRow3+2700,1800,"CPF: "+TRANSFORM(aDatSacado[7],"@R 999.999.999-99"),oFont10) 		// CPF
		EndIf

		oPrint:Say  (nRow2+1589,1850,aDadosTit[6],oFont10)

		oPrint:Say  (nRow3+2753,350 ,aDatSacado[3],oFont10)
		oPrint:Say  (nRow3+2806,350 ,aDatSacado[6]+" "+aDatSacado[4]+" - "+aDatSacado[5],oFont10) 		// CEP+Cidade+Estado
		oPrint:Say  (nRow3+2806,1750,aDadosTit[6],oFont10)

		oPrint:Say  (nRow3+2815,100 ,"Sacador/Avalista",oFont8)
		oPrint:Say  (nRow3+2855,1500,"Autenticações Mecânica - Ficha de Compensação",oFont8)

		oPrint:Line (nRow3+1970,1800,nRow3+2660,1800)
		oPrint:Line (nRow3+2380,1800,nRow3+2380,2300)
		oPrint:Line (nRow3+2450,1800,nRow3+2450,2300)
		oPrint:Line (nRow3+2520,1800,nRow3+2520,2300)
		oPrint:Line (nRow3+2590,1800,nRow3+2590,2300)
		oPrint:Line (nRow3+2660,100 ,nRow3+2660,2300)
		oPrint:Line (nRow3+2820,100 ,nRow3+2820,2300)

		oPrint:Code128c(nRow3+2950,100,aCB_RN_NN[1], 40)ç
		cConta := SA6->A6_NUMCON

		DbSelectArea("SE1")
		RecLock("SE1",.F.)
		If Empty(SE1->E1_NUMBCO)
			SE1->E1_NUMBCO		:=	aCB_RN_NN[3]
			SE1->E1_PORTADOR 	:=	'001'
			SE1->E1_AGEDEP 		:=	_cNumAge
			SE1->E1_CONTA 		:=	_cNumCta
		EndIf
		SE1->(MsUnlock())

		oPrint:EndPage() // Finaliza a pagina
	EndIf

	//¦+-------------------------------------------------------------+¦
	//¦¦  HSBC                              				         ¦¦
	//¦+-------------------------------------------------------------+¦
	IF aDadosBanco[1] == "399"

		/******************/
		/* PRIMEIRA PARTE */
		/******************/
		nRow1 := 0

		oPrint:Line (nRow1+0120,500,nRow1+0040, 500)
		oPrint:Line (nRow1+0120,710,nRow1+0040, 710)
		oPrint:SayBitmap(nRow1+0020,100,"BOL399.JPG",0350,0090)

		oPrint:Say  (nRow1+0080,510,aDadosBanco[1]+"-9",oFont20 )		// [1]Numero do Banco

		oPrint:Say  (nRow1+0084,1900,"Comprovante de Entrega",oFont10)
		oPrint:Line (nRow1+0120,100,nRow1+0120,2300)

		oPrint:Say  (nRow1+0150,100 ,"Beneficiário",oFont8)
		oPrint:Say  (nRow1+0200,100 ,aDadosEmp[1],oFont8)					//Nome + CNPJ

		oPrint:Say  (nRow1+0150,1060,"Agência/Código Beneficiário",oFont8)
		oPrint:Say  (nRow1+0200,1080,AllTrim(aDadosBanco[3]) + " / " + aDadosBanco[4] + aDadosBanco[5],oFont10)

		oPrint:Say  (nRow1+0150,1510,"Nro.Documento",oFont8)
		oPrint:Say  (nRow1+0200,1510,aDadosTit[7]+aDadosTit[1],oFont10) //Prefixo +Numero+Parcela

		oPrint:Say  (nRow1+0250,100 ,"Pagador",oFont8)
		oPrint:Say  (nRow1+0300,100 ,left(aDatSacado[1],40),oFont10)	//Nome

		oPrint:Say  (nRow1+0250,1060,"Vencimento",oFont8)
		oPrint:Say  (nRow1+0300,1060,StrZero(Day(aDadosTit[4]),2) +"/"+ StrZero(Month(aDadosTit[4]),2) +"/"+ Right(Str(Year(aDadosTit[4])),4),oFont10)

		oPrint:Say  (nRow1+0250,1510,"Valor do Documento",oFont8)
		oPrint:Say  (nRow1+0300,1550,AllTrim(Transform(aDadosTit[5],"@E 999,999,999.99")),oFont10)

		oPrint:Say  (nRow1+0400,0100,"Recebi(emos) o bloqueto/título"	,oFont10 )
		oPrint:Say  (nRow1+0450,0100,"com as caracteristicas acima."	,oFont10 )
		oPrint:Say  (nRow1+0350,1060,"Data"								,oFont8  )
		oPrint:Say  (nRow1+0350,1410,"Assinatura"						,oFont8  )
		oPrint:Say  (nRow1+0450,1060,"Data"								,oFont8  )
		oPrint:Say  (nRow1+0450,1410,"Entregador"						,oFont8  )

		oPrint:Line (nRow1+0220, 100,nRow1+0220,1900 )
		oPrint:Line (nRow1+0320, 100,nRow1+0320,1900 )
		oPrint:Line (nRow1+0420,1050,nRow1+0420,1900 )
		oPrint:Line (nRow1+0520, 100,nRow1+0520,2300 )

		oPrint:Line (nRow1+0520,1050,nRow1+0120,1050 )
		oPrint:Line (nRow1+0520,1400,nRow1+0320,1400 )
		oPrint:Line (nRow1+0320,1500,nRow1+0120,1500 )
		oPrint:Line (nRow1+0520,1900,nRow1+0120,1900 )

		oPrint:Say  ( nRow1+0165,1910,"(  )Mudou-se"					,oFont8 )
		oPrint:Say  ( nRow1+0205,1910,"(  )Ausente"						,oFont8 )
		oPrint:Say  ( nRow1+0245,1910,"(  )Não existe não indicado"		,oFont8 )
		oPrint:Say  ( nRow1+0285,1910,"(  )Recusado"					,oFont8 )
		oPrint:Say  ( nRow1+0325,1910,"(  )Não procurado"				,oFont8 )
		oPrint:Say  ( nRow1+0365,1910,"(  )Endeço insuficiente"			,oFont8 )
		oPrint:Say  ( nRow1+0405,1910,"(  )Desconhecido"				,oFont8 )
		oPrint:Say  ( nRow1+0445,1910,"(  )Falecido"					,oFont8 )
		oPrint:Say  ( nRow1+0485,1910,"(  )Outros(anotar no verso)"		,oFont8 )

		/*****************/
		/* SEGUNDA PARTE */
		/*****************/
		nRow2 := 110

		//Pontilhado separador
		For nI := 100 to 2300 step 50
			oPrint:Line(nRow2+0550, nI,nRow2+0550, nI+30)
		Next nI

		oPrint:Line (nRow2+0680,100,nRow2+0680,2300)
		oPrint:Line (nRow2+0680,500,nRow2+0600, 500)
		oPrint:Line (nRow2+0680,710,nRow2+0600, 710)
		oPrint:SayBitmap(nRow2+0580,100,"BOL399.JPG",0350,0090)

		oPrint:Say  (nRow2+0640,510,aDadosBanco[1]+"-9",oFont20 )	// [1]Numero do Banco

		oPrint:Say  (nRow2+0640,715,aCB_RN_NN[2],oFont15)  	//	Linha Digitavel do Codigo de Barras

		oPrint:Say  (nRow2+0644,2030,"Recibo do Pagador",oFont10)

		oPrint:Line (nRow2+0780,100,nRow2+0780,2300 )
		oPrint:Line (nRow2+0880,100,nRow2+0880,2300 )
		oPrint:Line (nRow2+0880,1800,nRow2+0880,2300 )

		oPrint:Line (nRow2+0950,100,nRow2+0950,2300 )
		oPrint:Line (nRow2+1020,100,nRow2+1020,2300 )
		oPrint:Line (nRow2+0880,500,nRow2+1020,500)
		oPrint:Line (nRow2+0950,770,nRow2+1020,770)
		oPrint:Line (nRow2+0880,1000,nRow2+1020,1000)
		oPrint:Line (nRow2+0880,1300,nRow2+0950,1300)
		oPrint:Line (nRow2+0880,1480,nRow2+1020,1480)

		oPrint:Say  (nRow2+0710,100 ,"Local de Pagamento",oFont8)
		oPrint:Say  (nRow2+0750,100 ,"PAGAR EM QUALQUER AGÊNCIA BANCARIA ATÉ O VENCIMENTO OU CANAIS ELETRÔNICOS DO HSBC.",oFont10)
		oPrint:Say  (nRow2+0765,400 ," ",oFont10)

		oPrint:Say  (nRow2+0710,1810,"Vencimento",oFont8)
		cString	:= StrZero(Day(aDadosTit[4]),2) +"/"+ StrZero(Month(aDadosTit[4]),2) +"/"+ Right(Str(Year(aDadosTit[4])),4)
		nCol := 1810+(374-(len(cString)*22))
		oPrint:Say  (nRow2+0750,nCol,cString,oFont11c)

		oPrint:Say  (nRow2+0810,100 ,"Beneficiário",oFont8)
		oPrint:Say  (nRow2+0840,100 ,AllTrim(aDadosEmp[1]) ,oFont8) //Nome + CNPJ   // + " - " + aDadosEmp[2]
		oPrint:Say  (nRow2+0835+35,100 ,AllTrim(aDadosEmp[2]) + " -  " + aDadosEmp[3] + " - " + AllTrim(aDadosEmp[4]) + " -  " + aDadosEmp[5] + " -  " + aDadosEmp[6],oFont8) //Endereço e Bairro, Cidade, Estado e Cep

		oPrint:Say  (nRow2+0810,1300 ,"CNPJ Beneficiário: " + Transform(aDadosEmp[8],"@R 99.999.999/9999-99") ,oFont8)

		oPrint:Say  (nRow2+0810,1810,"Agência/Código Beneficiário",oFont8)
		cString := Alltrim(AllTrim(aDadosBanco[3]) + " / " + aDadosBanco[4] + aDadosBanco[5] )
		oPrint:Say  (nRow2+0850,1830,cString,oFont11c)

		oPrint:Say  (nRow2+0910,100 ,"Data do Documento",oFont8)
		oPrint:Say  (nRow2+0940,100, StrZero(Day(aDadosTit[2]),2) +"/"+ StrZero(Month(aDadosTit[2]),2) +"/"+ Right(Str(Year(aDadosTit[2])),4),oFont10)

		oPrint:Say  (nRow2+0910,505 ,"Nro.Documento",oFont8)
		oPrint:Say  (nRow2+0940,605 ,aDadosTit[7]+aDadosTit[1],oFont10) //Prefixo +Numero+Parcela

		oPrint:Say  (nRow2+0910,1005,"Especie Doc.",oFont8)
		oPrint:Say  (nRow2+0940,1050,"PD",oFont10) 		  //Tipo do Titulo

		oPrint:Say  (nRow2+0910,1305,"Aceite",oFont8)
		oPrint:Say  (nRow2+0940,1390,"NÃO",oFont10) //COLUNA 1400

		oPrint:Say  (nRow2+0910,1485,"Data do Processamento",oFont8)
		oPrint:Say  (nRow2+0940,1550,StrZero(Day(aDadosTit[3]),2) +"/"+ StrZero(Month(aDadosTit[3]),2) +"/"+ Right(Str(Year(aDadosTit[3])),4),oFont10) // Data impressao

		oPrint:Say  (nRow2+0910,1810,"Nosso Número",oFont8)
		cString := Alltrim(aDadosTit[6])
		nCol := 1810+(394-(len(cString)*22))
		oPrint:Say  (nRow2+0940,nCol,cString,oFont11c)

		oPrint:Say  (nRow2+0980,100 ,"Uso do Banco",oFont8)

		oPrint:Say  (nRow2+0980,505 ,"Carteira",oFont8)
		oPrint:Say  (nRow2+1010,500 ,aDadosBanco[6],oFont9)

		oPrint:Say  (nRow2+0980,775 ,"Especie",oFont8)
		oPrint:Say  (nRow2+1010,805 ,"REAL",oFont10)
		oPrint:Say  (nRow2+0980,1005,"Quantidade",oFont8)
		oPrint:Say  (nRow2+0980,1485,"Valor"     ,oFont8)

		oPrint:Say  (nRow2+0980,1810,"Valor do Documento",oFont8)
		cString := Alltrim(Transform(aDadosTit[5],"@E 99,999,999.99"))
		nCol := 1810+(374-(len(cString)*22))
		oPrint:Say  (nRow2+1010,nCol,cString ,oFont11c)

		oPrint:Say  (nRow2+1050,100 ,"Instruções (Todas informações deste bloqueto são de exclusiva responsabilidade do Beneficiário)",oFont8)
		oPrint:Say  (nRow2+1050,1450 ,"Bordero Nro :"+SE1->E1_NUMBOR,oFont10)

		oPrint:Say  (nRow2+1100,100 ,aBolText[6] ,oFont10)
		oPrint:Say  (nRow2+1150,100 ,aBolText[1]+" " + AllTrim(Transform(((aDadosTit[5] * SE1->E1_PORCJUR ) / 100),"@E 999,999.99") +""+aBolText[2])  ,oFont10) // Juros de Mora de R$ xxxx ao Dia

		If SEE->EE_XMULTA > 0
			oPrint:Say  (nRow2+1200,100 ,aBolText[3]+" " + AllTrim(Transform(((aDadosTit[5] * SEE->EE_XMULTA) / 100),"@E 999,999.99"))+"",oFont10)  //  Apos venciamento multa de R$ xxxxx
		EndIf

		oPrint:Say  (nRow2+1250,100 ,aBolText[4] ,oFont10)
		oPrint:Say  (nRow2+1300,100 ,aBolText[5] ,oFont10)
		oPrint:Say  (nRow2+1350,100 ,aBolText[7] ,oFont10)

		oPrint:Say  (nRow2+1050,1810,"(-)Desconto/Abatimento",oFont8)
		oPrint:Say  (nRow2+1120,1810,"(-)Outras Deduções"    ,oFont8)
		oPrint:Say  (nRow2+1190,1810,"(+)Mora/Multa"         ,oFont8)
		oPrint:Say  (nRow2+1260,1810,"(+)Outros Acréscimos"  ,oFont8)
		oPrint:Say  (nRow2+1330,1810,"(=)Valor Cobrado"      ,oFont8)

		oPrint:Say  (nRow2+1400,100 ,"Pagador",oFont8)
		oPrint:Say  (nRow2+1430,350 ,LEFT(aDatSacado[1],45)+" ("+aDatSacado[2]+")",oFont10)
		oPrint:Say  (nRow2+1483,350 ,aDatSacado[3],oFont10)
		oPrint:Say  (nRow2+1536,350 ,aDatSacado[6]+"    "+aDatSacado[4]+" - "+aDatSacado[5],oFont10) // CEP+Cidade+Estado

		if aDatSacado[8] = "J"
			oPrint:Say  (nRow2+1589,350 ,"CNPJ: " + TRANSFORM(aDatSacado[7],"@R 99.999.999/9999-99"),oFont10) // CGC
		Else
			oPrint:Say  (nRow2+1589,350 ,"CPF: " + TRANSFORM(aDatSacado[7],"@R 999.999.999-99"),oFont10) 	// CPF
		EndIf

		oPrint:Say  (nRow2+1605,100 ,"Pagador/Avalista",oFont8)
		oPrint:Say  (nRow2+1645,1500,"Autenticacao Mecanica",oFont8)

		oPrint:Line (nRow2+0680,1800,nRow2+1370,1800 )
		oPrint:Line (nRow2+1090,1800,nRow2+1090,2300 )
		oPrint:Line (nRow2+1160,1800,nRow2+1160,2300 )
		oPrint:Line (nRow2+1230,1800,nRow2+1230,2300 )
		oPrint:Line (nRow2+1300,1800,nRow2+1300,2300 )
		oPrint:Line (nRow2+1370,100 ,nRow2+1370,2300 )
		oPrint:Line (nRow2+1610,100 ,nRow2+1610,2300 )

		/******************/
		/* TERCEIRA PARTE */
		/******************/

		nRow3 := 20

		For nI := 100 to 2300 step 50
			oPrint:Line(nRow3+1850, nI, nRow3+1850, nI+30)
		Next nI

		oPrint:Line (nRow3+1970,100,nRow3+1970,2300)
		oPrint:Line (nRow3+1970,500,nRow3+1890, 500)
		oPrint:Line (nRow3+1970,710,nRow3+1890, 710)
		oPrint:SayBitmap(nRow3+1870,100,"BOL399.JPG",0350,0090)

		oPrint:Say  (nRow3+1930,510,aDadosBanco[1]+"-9",oFont20 )	// 	[1]Numero do Banco

		oPrint:Say  (nRow3+1934,715,aCB_RN_NN[2],oFont15)  	//	Linha Digitavel do Codigo de Barras

		oPrint:Line (nRow3+2070,100,nRow3+2070,2300 )
		oPrint:Line (nRow3+2170,100,nRow3+2170,2300 )
		oPrint:Line (nRow3+2240,100,nRow3+2240,2300 )
		oPrint:Line (nRow3+2310,100,nRow3+2310,2300 )

		oPrint:Line (nRow3+2170,500 ,nRow3+2310,500 )
		oPrint:Line (nRow3+2240,770 ,nRow3+2310,770 )
		oPrint:Line (nRow3+2170,1000,nRow3+2310,1000)
		oPrint:Line (nRow3+2170,1300,nRow3+2240,1300)
		oPrint:Line (nRow3+2170,1480,nRow3+2310,1480)

		oPrint:Say  (nRow3+2000,100 ,"Local de Pagamento",oFont8)
		oPrint:Say  (nRow3+2040,100 ,"PAGAR EM QUALQUER AGÊNCIA BANCARIA ATÉ O VENCIMENTO OU CANAIS ELETRÔNICOS DO HSBC.",oFont10)

		oPrint:Say  (nRow3+2055,400 ," ",oFont10)

		oPrint:Say  (nRow3+2000,1810,"Vencimento",oFont8)
		cString := StrZero(Day(aDadosTit[4]),2) +"/"+ StrZero(Month(aDadosTit[4]),2) +"/"+ Right(Str(Year(aDadosTit[4])),4)
		nCol	 	 := 1810+(394-(len(cString)*22))
		oPrint:Say  (nRow3+2040,nCol,cString,oFont11c)

		oPrint:Say  (nRow3+2100,100 ,"Beneficiário",oFont8)

		oPrint:Say  (nRow3+2135,100 ,AllTrim(aDadosEmp[1]) ,oFont8) //Nome + CNPJ   // + " - " + aDadosEmp[2]
		oPrint:Say  (nRow3+2135+30,100 ,AllTrim(aDadosEmp[2]) + " -  " + aDadosEmp[3] + " - " + AllTrim(aDadosEmp[4]) + " -  " + aDadosEmp[5] + " -  " + aDadosEmp[6],oFont8) //Endereço e Bairro, Cidade, Estado e Cep

		oPrint:Say  (nRow3+2100,1300 ,"CNPJ Beneficiário: " + Transform(aDadosEmp[8],"@R 99.999.999/9999-99") ,oFont8)

		oPrint:Say  (nRow3+2100,1810,"Agência/Código Beneficiário",oFont8)
		cString := Alltrim(AllTrim(aDadosBanco[3]) + " / " + aDadosBanco[4] + aDadosBanco[5])
		oPrint:Say  (nRow3+2140,1830,cString ,oFont11c)

		oPrint:Say  (nRow3+2200,100 ,"Data do Documento",oFont8)
		oPrint:Say (nRow3+2230,100, StrZero(Day(aDadosTit[2]),2) +"/"+ StrZero(Month(aDadosTit[2]),2) +"/"+ Right(Str(Year(aDadosTit[2])),4), oFont10)

		oPrint:Say  (nRow3+2200,505 ,"Nro.Documento",oFont8)
		oPrint:Say  (nRow3+2230,605 ,aDadosTit[7]+aDadosTit[1],oFont10) //Prefixo +Numero+Parcela

		oPrint:Say  (nRow3+2200,1005,"Especie Doc.",oFont8)
		oPrint:Say  (nRow3+2230,1050,"PD",oFont10) 		  //Tipo do Titulo

		oPrint:Say  (nRow3+2200,1305,"Aceite",oFont8)
		oPrint:Say  (nRow3+2230,1390,"NÃO"     ,oFont10) //COLUNA 1400

		oPrint:Say  (nRow3+2200,1485,"Data do Processamento",oFont8)
		oPrint:Say  (nRow3+2230,1550,StrZero(Day(aDadosTit[3]),2) +"/"+ StrZero(Month(aDadosTit[3]),2) +"/"+ Right(Str(Year(aDadosTit[3])),4)                               ,oFont10) // Data impressao

		oPrint:Say  (nRow3+2200,1810,"Nosso Número",oFont8)
		cString := Alltrim(aDadosTit[6])
		nCol := 1810+(374-(len(cString)*22))
		oPrint:Say  (nRow3+2230,nCol,cString,oFont11c)

		oPrint:Say  (nRow3+2270,100 ,"Uso do Banco",oFont8)

		oPrint:Say  (nRow3+2270,505 ,"Carteira"	,oFont8)
		oPrint:Say  (nRow3+2300,500 ,aDadosBanco[6],oFont9)

		oPrint:Say  (nRow3+2270,775 ,"Espécie"	,oFont8)
		oPrint:Say  (nRow3+2300,805 ,"R$"     ,oFont10)
		oPrint:Say  (nRow3+2270,1005,"Quantidade",oFont8)
		oPrint:Say  (nRow3+2270,1485,"Valor"     ,oFont8)

		oPrint:Say  (nRow3+2270,1810,"Valor do Documento",oFont8)
		cString := Alltrim(Transform(aDadosTit[5],"@E 99,999,999.99"))
		nCol 	 := 1810+(374-(len(cString)*22))
		oPrint:Say  (nRow3+2300,nCol,cString,oFont11c)

		oPrint:Say  (nRow3+2340,100 ,"Instruções (Todas informações deste bloqueto são de exclusiva responsabilidade do Beneficiário)",oFont8)
		oPrint:Say  (nRow3+2340,1450 ,"Bordero Nro :"+SE1->E1_NUMBOR,oFont10)

		oPrint:Say  (nRow3+2390,100 ,aBolText[6] ,oFont10)

		oPrint:Say  (nRow3+2440,100 ,aBolText[1]+" " + AllTrim(Transform(((aDadosTit[5] * SE1->E1_PORCJUR) / 100) ,"@E 999,999.99")+""+aBolText[2])  ,oFont10) // Juros de Mora de R$ xxxx ao Dia

		If SEE->EE_XMULTA > 0
			oPrint:Say  (nRow3+2490,100 ,aBolText[3]+" " + AllTrim(Transform(((aDadosTit[5] * SEE->EE_XMULTA) / 100),"@E 999,999.99"))+"",oFont10)  //  Apos venciamento multa de R$ xxxxx
		EndIf

		oPrint:Say  (nRow3+2540,100 ,aBolText[4] ,oFont10)
		oPrint:Say  (nRow3+2590,100 ,aBolText[5] ,oFont10)
		oPrint:Say  (nRow3+2640,100 ,aBolText[7] ,oFont10)

		oPrint:Say  (nRow3+2340,1810,"(-)Desconto/Abatimento",oFont8)
		oPrint:Say  (nRow3+2410,1810,"(-)Outras Deduções"    ,oFont8)
		oPrint:Say  (nRow3+2480,1810,"(+)Mora/Multa"         ,oFont8)
		oPrint:Say  (nRow3+2550,1810,"(+)Outros Acréscimos"  ,oFont8)
		oPrint:Say  (nRow3+2620,1810,"(=)Valor Cobrado"      ,oFont8)

		oPrint:Say  (nRow3+2690,100 ,"Pagador",oFont8)
		oPrint:Say  (nRow3+2700,350 ,LEFT(aDatSacado[1],45)+" ("+aDatSacado[2]+")",oFont10)

		if aDatSacado[8] = "J"
			oPrint:Say (nRow3+2700,1800,"CNPJ: "+TRANSFORM(aDatSacado[7],"@R 99.999.999/9999-99"),oFont10) // CGC
		Else
			oPrint:Say (nRow3+2700,1800,"CPF: "+TRANSFORM(aDatSacado[7],"@R 999.999.999-99"),oFont10) 		// CPF
		EndIf

		oPrint:Say  (nRow2+1589,1850,aDadosTit[6],oFont10)

		oPrint:Say  (nRow3+2753,350 ,aDatSacado[3],oFont10)
		oPrint:Say  (nRow3+2806,350 ,aDatSacado[6]+" "+aDatSacado[4]+" - "+aDatSacado[5],oFont10) 		// CEP+Cidade+Estado
		oPrint:Say  (nRow3+2806,1750,aDadosTit[6],oFont10)

		oPrint:Say  (nRow3+2815,100 ,"Pagador/Avalista",oFont8)
		oPrint:Say  (nRow3+2855,1500,"Autenticações Mecânica - Ficha de Compensação",oFont8)

		oPrint:Line (nRow3+1970,1800,nRow3+2660,1800)
		oPrint:Line (nRow3+2380,1800,nRow3+2380,2300)
		oPrint:Line (nRow3+2450,1800,nRow3+2450,2300)
		oPrint:Line (nRow3+2520,1800,nRow3+2520,2300)
		oPrint:Line (nRow3+2590,1800,nRow3+2590,2300)
		oPrint:Line (nRow3+2660,100 ,nRow3+2660,2300)
		oPrint:Line (nRow3+2820,100 ,nRow3+2820,2300)

		oPrint:FWMSBAR("INT25", 68, 2, aCB_RN_NN[1], oPrint, .F., Nil, .T., 0.035, 1.2, Nil, Nil, "A", .F.)

		cConta := SA6->A6_NUMCON

		DbSelectArea("SE1")
		RecLock("SE1",.f.)
		If Empty(SE1->E1_NUMBCO)
			SE1->E1_NUMBCO		:=	aCB_RN_NN[3]  + aCB_RN_NN[4] // Nosso número (Ver fórmula para calculo) com o digito verificado
			SE1->E1_PORTADOR 	:=	'399'
			SE1->E1_AGEDEP 		:=	_cNumAge
			SE1->E1_CONTA 		:=	_cNumCta
		endif
		SE1->(MsUnlock())

		oPrint:EndPage() // Finaliza a pagina
	EndIf

	//¦+-------------------------------------------------------------+¦
	//¦¦ Caixa Economica Federal            				         ¦¦
	//¦+-------------------------------------------------------------+¦
	IF aDadosBanco[1] == "104"

		/******************/
		/* PRIMEIRA PARTE */
		/******************/
		nRow1 := 0

		oPrint:Line (nRow1+0120,500,nRow1+0040, 500)
		oPrint:Line (nRow1+0120,710,nRow1+0040, 710)
		oPrint:SayBitmap(nRow1+0020,100,"BOL104.JPG",0350,0090)

		oPrint:Say  (nRow1+0080,510,aDadosBanco[1]+"-9",oFont20 )		// [1]Numero do Banco

		oPrint:Say  (nRow1+0084,1900,"Comprovante de Entrega",oFont10)
		oPrint:Line (nRow1+0120,100,nRow1+0120,2300)

		oPrint:Say  (nRow1+0150,100 ,"Beneficiário",oFont8)
		oPrint:Say  (nRow1+0200,100 ,aDadosEmp[1],oFont8)					//Nome + CNPJ

		oPrint:Say  (nRow1+0150,1060,"Agência/Código Beneficiário",oFont8)
		oPrint:Say  (nRow1+0200,1080,AllTrim(aDadosBanco[3]) + " / " + Alltrim(SEE->EE_CODEMP) + "- 5" ,oFont10)

		oPrint:Say  (nRow1+0150,1510,"Nro.Documento",oFont8)
		oPrint:Say  (nRow1+0200,1510,aDadosTit[7]+aDadosTit[1],oFont10) //Prefixo +Numero+Parcela

		oPrint:Say  (nRow1+0250,100 ,"Pagador",oFont8)
		oPrint:Say  (nRow1+0300,100 ,left(aDatSacado[1],40),oFont10)	//Nome

		oPrint:Say  (nRow1+0250,1060,"Vencimento",oFont8)
		oPrint:Say  (nRow1+0300,1060,StrZero(Day(aDadosTit[4]),2) +"/"+ StrZero(Month(aDadosTit[4]),2) +"/"+ Right(Str(Year(aDadosTit[4])),4),oFont10)

		oPrint:Say  (nRow1+0250,1510,"Valor do Documento",oFont8)
		oPrint:Say  (nRow1+0300,1550,AllTrim(Transform(aDadosTit[5],"@E 999,999,999.99")),oFont10)

		oPrint:Say  (nRow1+0400,0100,"Recebi(emos) o bloqueto/título"	,oFont10 )
		oPrint:Say  (nRow1+0450,0100,"com as caracteristicas acima."	,oFont10 )
		oPrint:Say  (nRow1+0350,1060,"Data"								,oFont8  )
		oPrint:Say  (nRow1+0350,1410,"Assinatura"						,oFont8  )
		oPrint:Say  (nRow1+0450,1060,"Data"								,oFont8  )
		oPrint:Say  (nRow1+0450,1410,"Entregador"						,oFont8  )

		oPrint:Line (nRow1+0220, 100,nRow1+0220,1900 )
		oPrint:Line (nRow1+0320, 100,nRow1+0320,1900 )
		oPrint:Line (nRow1+0420,1050,nRow1+0420,1900 )
		oPrint:Line (nRow1+0520, 100,nRow1+0520,2300 )

		oPrint:Line (nRow1+0520,1050,nRow1+0120,1050 )
		oPrint:Line (nRow1+0520,1400,nRow1+0320,1400 )
		oPrint:Line (nRow1+0320,1500,nRow1+0120,1500 )
		oPrint:Line (nRow1+0520,1900,nRow1+0120,1900 )

		oPrint:Say  ( nRow1+0165,1910,"(  )Mudou-se"					,oFont8 )
		oPrint:Say  ( nRow1+0205,1910,"(  )Ausente"						,oFont8 )
		oPrint:Say  ( nRow1+0245,1910,"(  )Não existe não indicado"		,oFont8 )
		oPrint:Say  ( nRow1+0285,1910,"(  )Recusado"					,oFont8 )
		oPrint:Say  ( nRow1+0325,1910,"(  )Não procurado"				,oFont8 )
		oPrint:Say  ( nRow1+0365,1910,"(  )Endeço insuficiente"			,oFont8 )
		oPrint:Say  ( nRow1+0405,1910,"(  )Desconhecido"				,oFont8 )
		oPrint:Say  ( nRow1+0445,1910,"(  )Falecido"					,oFont8 )
		oPrint:Say  ( nRow1+0485,1910,"(  )Outros(anotar no verso)"		,oFont8 )

		/*****************/
		/* SEGUNDA PARTE */
		/*****************/
		nRow2 := 110

		//Pontilhado separador
		For nI := 100 to 2300 step 50
			oPrint:Line(nRow2+0550, nI,nRow2+0550, nI+30)
		Next nI

		oPrint:Line (nRow2+0680,100,nRow2+0680,2300)
		oPrint:Line (nRow2+0680,500,nRow2+0600, 500)
		oPrint:Line (nRow2+0680,710,nRow2+0600, 710)
		oPrint:SayBitmap(nRow2+0580,100,"BOL104.JPG",0350,0090)

		oPrint:Say  (nRow2+0640,510,aDadosBanco[1]+"-9",oFont20 )	// [1]Numero do Banco

		oPrint:Say  (nRow2+0640,715,aCB_RN_NN[2],oFont15)  	//	Linha Digitavel do Codigo de Barras

		oPrint:Say  (nRow2+0644,2030,"Recibo do Pagador",oFont10)

		oPrint:Line (nRow2+0780,100,nRow2+0780,2300 )
		oPrint:Line (nRow2+0880,100,nRow2+0880,2300 )
		oPrint:Line (nRow2+0880,1800,nRow2+0880,2300 )

		oPrint:Line (nRow2+0950,100,nRow2+0950,2300 )
		oPrint:Line (nRow2+1020,100,nRow2+1020,2300 )
		oPrint:Line (nRow2+0880,500,nRow2+1020,500)
		oPrint:Line (nRow2+0950,770,nRow2+1020,770)
		oPrint:Line (nRow2+0880,1000,nRow2+1020,1000)
		oPrint:Line (nRow2+0880,1300,nRow2+0950,1300)
		oPrint:Line (nRow2+0880,1480,nRow2+1020,1480)

		oPrint:Say  (nRow2+0710,100 ,"Local de Pagamento",oFont8)
		oPrint:Say  (nRow2+0750,100 ,"PREFERENCIALMENTE NAS CASAS LOTÉRICAS ATÉ O VALOR LIMITE.",oFont10)
		oPrint:Say  (nRow2+0765,400 ," ",oFont10)

		oPrint:Say  (nRow2+0710,1810,"Vencimento",oFont8)
		cString	:= StrZero(Day(aDadosTit[4]),2) +"/"+ StrZero(Month(aDadosTit[4]),2) +"/"+ Right(Str(Year(aDadosTit[4])),4)
		nCol := 1810+(374-(len(cString)*22))
		oPrint:Say  (nRow2+0750,nCol,cString,oFont11c)

		oPrint:Say  (nRow2+0810,100 ,"Beneficiário",oFont8)
		oPrint:Say  (nRow2+0840,100 ,AllTrim(aDadosEmp[1]) ,oFont8) //Nome + CNPJ   // + " - " + aDadosEmp[2]
		oPrint:Say  (nRow2+0835+35,100 ,AllTrim(aDadosEmp[2]) + " -  " + aDadosEmp[3] + " - " + AllTrim(aDadosEmp[4]) + " -  " + aDadosEmp[5] + " -  " + aDadosEmp[6],oFont8) //Endereço e Bairro, Cidade, Estado e Cep

		oPrint:Say  (nRow2+0810,1300 ,"CNPJ Beneficiário: " + Transform(aDadosEmp[8],"@R 99.999.999/9999-99") ,oFont8)

		oPrint:Say  (nRow2+0810,1810,"Agência/Código Beneficiário",oFont8)
		cString	:= AllTrim(aDadosBanco[3]) + " / " + Alltrim(SEE->EE_CODEMP) + "- " + Modulo11(AllTrim(SEE->EE_CODEMP))
		oPrint:Say  (nRow2+0850,1830,cString,oFont11c)

		oPrint:Say  (nRow2+0910,100 ,"Data do Documento",oFont8)
		oPrint:Say  (nRow2+0940,100, StrZero(Day(aDadosTit[2]),2) +"/"+ StrZero(Month(aDadosTit[2]),2) +"/"+ Right(Str(Year(aDadosTit[2])),4),oFont10)

		oPrint:Say  (nRow2+0910,505 ,"Nro.Documento",oFont8)
		oPrint:Say  (nRow2+0940,605 ,aDadosTit[7]+aDadosTit[1],oFont10) //Prefixo +Numero+Parcela

		oPrint:Say  (nRow2+0910,1005,"Especie Doc.",oFont8)
		oPrint:Say  (nRow2+0940,1050,"DM",oFont10) 		  //Tipo do Titulo

		oPrint:Say  (nRow2+0910,1305,"Aceite",oFont8)
		oPrint:Say  (nRow2+0940,1390,"N",oFont10) //COLUNA 1400

		oPrint:Say  (nRow2+0910,1485,"Data do Processamento",oFont8)
		oPrint:Say  (nRow2+0940,1550,StrZero(Day(aDadosTit[3]),2) +"/"+ StrZero(Month(aDadosTit[3]),2) +"/"+ Right(Str(Year(aDadosTit[3])),4),oFont10) // Data impressao

		oPrint:Say  (nRow2+0910,1810,"Nosso Número",oFont8)
		cString :=  Substr(Alltrim(aCB_RN_NN[3]),1,2) + Substr(Alltrim(aCB_RN_NN[3]),3,LEN(aCB_RN_NN[3])) + "-" + aCB_RN_NN[4]
		nCol := 1810+(450-(len(cString)*22))
		oPrint:Say  (nRow2+0940,nCol,cString,oFont11c)

		oPrint:Say  (nRow2+0980,100 ,"Uso do Banco",oFont8)

		oPrint:Say  (nRow2+0980,505 ,"Carteira",oFont8)
		oPrint:Say  (nRow2+1010,500 ,aDadosBanco[6],oFont9)

		oPrint:Say  (nRow2+0980,775 ,"Espécie Moeda",oFont8)
		oPrint:Say  (nRow2+1010,805 ,"R$",oFont10)
		oPrint:Say  (nRow2+0980,1005,"Quantidade Moeda",oFont8)
		oPrint:Say  (nRow2+0980,1485,"Valor"     ,oFont8)

		oPrint:Say  (nRow2+0980,1810,"Valor do Documento",oFont8)
		cString := Alltrim(Transform(aDadosTit[5],"@E 99,999,999.99"))
		nCol := 1810+(374-(len(cString)*22))
		oPrint:Say  (nRow2+1010,nCol,cString ,oFont11c)

		oPrint:Say  (nRow2+1050,100 ,"Instruções (Todas informações deste bloqueto são de exclusiva responsabilidade do Beneficiário)",oFont8)
		oPrint:Say  (nRow2+1050,1450 ,"Bordero Nro :"+SE1->E1_NUMBOR,oFont10)

		oPrint:Say  (nRow2+1100,100 ,aBolText[6] ,oFont10)
		oPrint:Say  (nRow2+1150,100 ,aBolText[1]+" " + AllTrim(Transform(((aDadosTit[5] * SE1->E1_PORCJUR) / 100),"@E 999,999.99")+""+aBolText[2])  ,oFont10) // Juros de Mora de R$ xxxx ao Dia

		If SEE->EE_XMULTA > 0
			oPrint:Say  (nRow2+1200,100 ,aBolText[3]+" " + AllTrim(Transform(((aDadosTit[5] * SEE->EE_XMULTA) / 100),"@E 999,999.99"))+"",oFont10)  //  Apos venciamento multa de R$ xxxxx
		EndIf

		oPrint:Say  (nRow2+1250,100 ,"SAC CAIXA: 0800 726 0101 (informações, reclamações, sugestões e elogios)" ,oFont8)
		oPrint:Say  (nRow2+1300,100 ,"Para pessoas com deficiência auditiva ou de fala: 0800 726 2492" ,oFont8)
		oPrint:Say  (nRow2+1350,100 ,"Ouvidoria: 0800 725 7474                        caixa.gov.br" ,oFont8)

		oPrint:Say  (nRow2+1050,1810,"(-)Desconto",oFont8)
		oPrint:Say  (nRow2+1120,1810,"(-)Outras Deduções/Abatimento",oFont8)
		oPrint:Say  (nRow2+1190,1810,"(+)Mora/Multa/Juros"   ,oFont8)
		oPrint:Say  (nRow2+1260,1810,"(+)Outros Acréscimos"  ,oFont8)
		oPrint:Say  (nRow2+1330,1810,"(=)Valor Cobrado"      ,oFont8)

		oPrint:Say  (nRow2+1400,100 ,"Pagador",oFont8)
		oPrint:Say  (nRow2+1430,350 ,LEFT(aDatSacado[1],45)+" ("+aDatSacado[2]+")",oFont10)
		oPrint:Say  (nRow2+1483,350 ,aDatSacado[3],oFont10)
		oPrint:Say  (nRow2+1536,350 ,aDatSacado[6]+"    "+aDatSacado[4]+" - "+aDatSacado[5],oFont10) // CEP+Cidade+Estado

		if aDatSacado[8] = "J"
			oPrint:Say  (nRow2+1589,350 ,"CNPJ: " + TRANSFORM(aDatSacado[7],"@R 99.999.999/9999-99"),oFont10) // CGC
		Else
			oPrint:Say  (nRow2+1589,350 ,"CPF: " + TRANSFORM(aDatSacado[7],"@R 999.999.999-99"),oFont10) 	// CPF
		EndIf

		oPrint:Say  (nRow2+1605,100 ,"Pagador/Avalista",oFont8)
		oPrint:Say  (nRow2+1645,1500,"Autenticacao Mecanica",oFont8)

		oPrint:Line (nRow2+0680,1800,nRow2+1370,1800 )
		oPrint:Line (nRow2+1090,1800,nRow2+1090,2300 )
		oPrint:Line (nRow2+1160,1800,nRow2+1160,2300 )
		oPrint:Line (nRow2+1230,1800,nRow2+1230,2300 )
		oPrint:Line (nRow2+1300,1800,nRow2+1300,2300 )
		oPrint:Line (nRow2+1370,100 ,nRow2+1370,2300 )
		oPrint:Line (nRow2+1610,100 ,nRow2+1610,2300 )

		/******************/
		/* TERCEIRA PARTE */
		/******************/

		nRow3 := 20

		For nI := 100 to 2300 step 50
			oPrint:Line(nRow3+1850, nI, nRow3+1850, nI+30)
		Next nI

		oPrint:Line (nRow3+1970,100,nRow3+1970,2300)
		oPrint:Line (nRow3+1970,500,nRow3+1890, 500)
		oPrint:Line (nRow3+1970,710,nRow3+1890, 710)
		oPrint:SayBitmap(nRow3+1870,100,"BOL104.JPG",0350,0090)

		oPrint:Say  (nRow3+1930,510,aDadosBanco[1]+"-9",oFont20 )	// 	[1]Numero do Banco

		oPrint:Say  (nRow3+1934,715,aCB_RN_NN[2],oFont15)  	//	Linha Digitavel do Codigo de Barras

		oPrint:Line (nRow3+2070,100,nRow3+2070,2300 )
		oPrint:Line (nRow3+2170,100,nRow3+2170,2300 )
		oPrint:Line (nRow3+2240,100,nRow3+2240,2300 )
		oPrint:Line (nRow3+2310,100,nRow3+2310,2300 )

		oPrint:Line (nRow3+2170,500 ,nRow3+2310,500 )
		oPrint:Line (nRow3+2240,770 ,nRow3+2310,770 )
		oPrint:Line (nRow3+2170,1000,nRow3+2310,1000)
		oPrint:Line (nRow3+2170,1300,nRow3+2240,1300)
		oPrint:Line (nRow3+2170,1480,nRow3+2310,1480)

		oPrint:Say  (nRow3+2000,100 ,"Local de Pagamento",oFont8)
		oPrint:Say  (nRow3+2040,100 ,"PREFERENCIALMENTE NAS CASAS LOTÉRICAS ATÉ O VALOR LIMITE.",oFont10)

		oPrint:Say  (nRow3+2055,400 ," ",oFont10)

		oPrint:Say  (nRow3+2000,1810,"Vencimento",oFont8)
		cString := StrZero(Day(aDadosTit[4]),2) +"/"+ StrZero(Month(aDadosTit[4]),2) +"/"+ Right(Str(Year(aDadosTit[4])),4)
		nCol	 	 := 1810+(374-(len(cString)*22))
		oPrint:Say  (nRow3+2040,nCol,cString,oFont11c)

		oPrint:Say  (nRow3+2100,100 ,"Beneficiário",oFont8)
		oPrint:Say  (nRow3+2135,100 ,AllTrim(aDadosEmp[1]) ,oFont8) //Nome + CNPJ   // + " - " + aDadosEmp[2]
		oPrint:Say  (nRow3+2135+30,100 ,AllTrim(aDadosEmp[2]) + " -  " + aDadosEmp[3] + " - " + AllTrim(aDadosEmp[4]) + " -  " + aDadosEmp[5] + " -  " + aDadosEmp[6],oFont8) //Endereço e Bairro, Cidade, Estado e Cep

		oPrint:Say  (nRow3+2100,1300 ,"CNPJ Beneficiário: " + Transform(aDadosEmp[8],"@R 99.999.999/9999-99") ,oFont8)

		oPrint:Say  (nRow3+2100,1810,"Agência/Código Beneficiário",oFont8)
		cString	:= AllTrim(aDadosBanco[3]) + " / " + Alltrim(SEE->EE_CODEMP) + "- " + Modulo11(AllTrim(SEE->EE_CODEMP))
		oPrint:Say  (nRow3+2140,1830,cString ,oFont11c)

		oPrint:Say  (nRow3+2200,100 ,"Data do Documento",oFont8)
		oPrint:Say (nRow3+2230,100, StrZero(Day(aDadosTit[2]),2) +"/"+ StrZero(Month(aDadosTit[2]),2) +"/"+ Right(Str(Year(aDadosTit[2])),4), oFont10)

		oPrint:Say  (nRow3+2200,505 ,"Nro.Documento",oFont8)
		oPrint:Say  (nRow3+2230,605 ,aDadosTit[7]+aDadosTit[1],oFont10) //Prefixo +Numero+Parcela

		oPrint:Say  (nRow3+2200,1005,"Especie Doc.",oFont8)
		oPrint:Say  (nRow3+2230,1050,"DM",oFont10) 		  //Tipo do Titulo

		oPrint:Say  (nRow3+2200,1305,"Aceite",oFont8)
		oPrint:Say  (nRow3+2230,1390,"N"     ,oFont10) //COLUNA 1400

		oPrint:Say  (nRow3+2200,1485,"Data do Processamento",oFont8)
		oPrint:Say  (nRow3+2230,1550,StrZero(Day(aDadosTit[3]),2) +"/"+ StrZero(Month(aDadosTit[3]),2) +"/"+ Right(Str(Year(aDadosTit[3])),4)                               ,oFont10) // Data impressao

		oPrint:Say  (nRow3+2200,1810,"Nosso Número",oFont8)
		cString :=  Substr(Alltrim(aCB_RN_NN[3]),1,2) + Substr(Alltrim(aCB_RN_NN[3]),3,LEN(aCB_RN_NN[3])) + "-" + aCB_RN_NN[4]
		nCol := 1810+(450-(len(cString)*22))
		oPrint:Say  (nRow3+2230,nCol,cString,oFont11c)

		oPrint:Say  (nRow3+2270,100 ,"Uso do Banco",oFont8)

		oPrint:Say  (nRow3+2270,505 ,"Carteira"	,oFont8)
		oPrint:Say  (nRow3+2300,500 ,aDadosBanco[6],oFont9)

		oPrint:Say  (nRow3+2270,775 ,"Espécie Moeda"	,oFont8)
		oPrint:Say  (nRow3+2300,805 ,"R$"     ,oFont10)
		oPrint:Say  (nRow3+2270,1005,"Quantidade Moeda",oFont8)
		oPrint:Say  (nRow3+2270,1485,"Valor"     ,oFont8)

		oPrint:Say  (nRow3+2270,1810,"Valor do Documento",oFont8)
		cString := Alltrim(Transform(aDadosTit[5],"@E 99,999,999.99"))
		nCol 	 := 1810+(374-(len(cString)*22))
		oPrint:Say  (nRow3+2300,nCol,cString,oFont11c)

		oPrint:Say  (nRow3+2340,100 ,"Instruções (Todas informações deste bloqueto são de exclusiva responsabilidade do Beneficiário)",oFont8)
		oPrint:Say  (nRow3+2340,1450 ,"Bordero Nro :"+SE1->E1_NUMBOR,oFont10)

		oPrint:Say  (nRow3+2390,100 ,aBolText[6] ,oFont10)
		oPrint:Say  (nRow3+2440,100 ,aBolText[1]+" "+AllTrim(Transform(((aDadosTit[5] * SE1->E1_PORCJUR) / 100) ,"@E 999,999.99")+""+aBolText[2])  ,oFont10) // Juros de Mora de R$ xxxx ao Dia

		If SEE->EE_XMULTA > 0
			oPrint:Say  (nRow3+2490,100 ,aBolText[3]+" " + AllTrim(Transform(((aDadosTit[5] * SEE->EE_XMULTA) / 100),"@E 999,999.99"))+"",oFont10)  //  Apos venciamento multa de R$ xxxxx
		EndIf

		oPrint:Say  (nRow3+2540,100 ,aBolText[4] ,oFont10)
		oPrint:Say  (nRow3+2590,100 ,aBolText[5] ,oFont10)
		oPrint:Say  (nRow3+2640,100 ,aBolText[7] ,oFont10)

		oPrint:Say  (nRow3+2340,1810,"(-)Desconto",oFont8)
		oPrint:Say  (nRow3+2410,1810,"(-)Outras Deduções/Abatimento",oFont8)
		oPrint:Say  (nRow3+2480,1810,"(+)Mora/Multa/Juros"   ,oFont8)
		oPrint:Say  (nRow3+2550,1810,"(+)Outros Acréscimos"  ,oFont8)
		oPrint:Say  (nRow3+2620,1810,"(=)Valor Cobrado"      ,oFont8)

		oPrint:Say  (nRow3+2690,100 ,"Pagador",oFont8)
		oPrint:Say  (nRow3+2700,350 ,LEFT(aDatSacado[1],45)+" ("+aDatSacado[2]+")",oFont10)

		if aDatSacado[8] = "J"
			oPrint:Say (nRow3+2700,1800,"CNPJ: "+TRANSFORM(aDatSacado[7],"@R 99.999.999/9999-99"),oFont10) // CGC
		Else
			oPrint:Say (nRow3+2700,1800,"CPF: "+TRANSFORM(aDatSacado[7],"@R 999.999.999-99"),oFont10) 		// CPF
		EndIf

		oPrint:Say  (nRow2+1589,1850,Substr(Alltrim(aCB_RN_NN[3]),1,2) + Substr(Alltrim(aCB_RN_NN[3]),3,LEN(aCB_RN_NN[3])) + "-" + aCB_RN_NN[4],oFont10)

		oPrint:Say  (nRow3+2753,350 ,aDatSacado[3],oFont10) // Endereço + Bairro
		oPrint:Say  (nRow3+2806,350 ,aDatSacado[6]+" "+aDatSacado[4]+" - "+aDatSacado[5],oFont10) 		// CEP+Cidade+Estado
		oPrint:Say  (nRow3+2806,1750,Substr(Alltrim(aCB_RN_NN[3]),1,2) + Substr(Alltrim(aCB_RN_NN[3]),3,LEN(aCB_RN_NN[3])) + "-" + aCB_RN_NN[4],oFont10)

		oPrint:Say  (nRow3+2815,100 ,"Pagador/Avalista",oFont8)
		oPrint:Say  (nRow3+2855,1500,"Autenticações Mecânica - Ficha de Compensação",oFont8)

		oPrint:Line (nRow3+1970,1800,nRow3+2660,1800)
		oPrint:Line (nRow3+2380,1800,nRow3+2380,2300)
		oPrint:Line (nRow3+2450,1800,nRow3+2450,2300)
		oPrint:Line (nRow3+2520,1800,nRow3+2520,2300)
		oPrint:Line (nRow3+2590,1800,nRow3+2590,2300)
		oPrint:Line (nRow3+2660,100 ,nRow3+2660,2300)
		oPrint:Line (nRow3+2820,100 ,nRow3+2820,2300)

		oPrint:Code128c(nRow3+3000,100,aCB_RN_NN[1], 46)

		cConta := SA6->A6_NUMCON

		DbSelectArea("SE1")
		RecLock("SE1",.f.)
		If Empty(SE1->E1_NUMBCO)
			SE1->E1_NUMBCO		:=	aCB_RN_NN[3] // + aCB_RN_NN[4] // Nosso número (Ver fórmula para calculo) com o digito verificado
			SE1->E1_PORTADOR 	:=	'104'
			SE1->E1_AGEDEP 		:=	_cNumAge
			SE1->E1_CONTA 		:=	_cNumCta
		endif
		SE1->(MsUnlock())

		oPrint:EndPage() // Finaliza a pagina
	EndIf

	//¦+-------------------------------------------------------------+¦
	//¦¦ Bradesco                           				         ¦¦
	//¦+-------------------------------------------------------------+¦
	IF aDadosBanco[1] == "237"

		/******************/
		/* PRIMEIRA PARTE */
		/******************/

		nRow1 := 0

		oPrint:Line (nRow1+0120,500,nRow1+0040, 500)
		oPrint:Line (nRow1+0120,710,nRow1+0040, 710)
		oPrint:SayBitmap(nRow1+0020,100,"BOL237.JPG",0350,0090)

		oPrint:Say  (nRow1+0080,510,aDadosBanco[1]+"-"+Modulo11(aDadosBanco[1]),oFont20 )		// [1]Numero do Banco

		oPrint:Say  (nRow1+0084,1900,"Comprovante de Entrega",oFont10)
		oPrint:Line (nRow1+0120,100,nRow1+0120,2300)

		oPrint:Say  (nRow1+0150,100 ,"Beneficiário",oFont8)
		oPrint:Say  (nRow1+0200,100 ,aDadosEmp[1],oFont8)					//Nome + CNPJ

		oPrint:Say  (nRow1+0150,1060,"Agência/Código Beneficiário",oFont8)
		oPrint:Say  (nRow1+0200,1080,Alltrim(AllTrim(aDadosBanco[3])  + "-" + SA6->A6_DVAGE + " / " + aDadosBanco[4] + "-" + SEE->EE_DVCTA)  ,oFont10)

		oPrint:Say  (nRow1+0150,1510,"Nro.Documento",oFont8)
		oPrint:Say  (nRow1+0200,1510,aDadosTit[7]+aDadosTit[1],oFont10) //Prefixo +Numero+Parcela

		oPrint:Say  (nRow1+0250,100 ,"Pagador",oFont8)
		oPrint:Say  (nRow1+0300,100 ,left(aDatSacado[1],40),oFont10)	//Nome

		oPrint:Say  (nRow1+0250,1060,"Vencimento",oFont8)
		oPrint:Say  (nRow1+0300,1060,StrZero(Day(aDadosTit[4]),2) +"/"+ StrZero(Month(aDadosTit[4]),2) +"/"+ Right(Str(Year(aDadosTit[4])),4),oFont10)

		oPrint:Say  (nRow1+0250,1510,"Valor do Documento",oFont8)
		oPrint:Say  (nRow1+0300,1550,AllTrim(Transform(aDadosTit[5],"@E 999,999,999.99")),oFont10)

		oPrint:Say  (nRow1+0400,0100,"Recebi(emos) o bloqueto/título"	,oFont10 )
		oPrint:Say  (nRow1+0450,0100,"com as caracteristicas acima."	,oFont10 )
		oPrint:Say  (nRow1+0350,1060,"Data"								,oFont8  )
		oPrint:Say  (nRow1+0350,1410,"Assinatura"						,oFont8  )
		oPrint:Say  (nRow1+0450,1060,"Data"								,oFont8  )
		oPrint:Say  (nRow1+0450,1410,"Entregador"						,oFont8  )

		oPrint:Line (nRow1+0220, 100,nRow1+0220,1900 )
		oPrint:Line (nRow1+0320, 100,nRow1+0320,1900 )
		oPrint:Line (nRow1+0420,1050,nRow1+0420,1900 )
		oPrint:Line (nRow1+0520, 100,nRow1+0520,2300 )

		oPrint:Line (nRow1+0520,1050,nRow1+0120,1050 )
		oPrint:Line (nRow1+0520,1400,nRow1+0320,1400 )
		oPrint:Line (nRow1+0320,1500,nRow1+0120,1500 )
		oPrint:Line (nRow1+0520,1900,nRow1+0120,1900 )

		oPrint:Say  ( nRow1+0165,1910,"(  )Mudou-se"					,oFont8 )
		oPrint:Say  ( nRow1+0205,1910,"(  )Ausente"						,oFont8 )
		oPrint:Say  ( nRow1+0245,1910,"(  )Não existe não indicado"		,oFont8 )
		oPrint:Say  ( nRow1+0285,1910,"(  )Recusado"					,oFont8 )
		oPrint:Say  ( nRow1+0325,1910,"(  )Não procurado"				,oFont8 )
		oPrint:Say  ( nRow1+0365,1910,"(  )Endeço insuficiente"			,oFont8 )
		oPrint:Say  ( nRow1+0405,1910,"(  )Desconhecido"				,oFont8 )
		oPrint:Say  ( nRow1+0445,1910,"(  )Falecido"					,oFont8 )
		oPrint:Say  ( nRow1+0485,1910,"(  )Outros(anotar no verso)"		,oFont8 )

		/*****************/
		/* SEGUNDA PARTE */
		/*****************/
		nRow2 := 110

		//Pontilhado separador
		For nI := 100 to 2300 step 50
			oPrint:Line(nRow2+0550, nI,nRow2+0550, nI+30)
		Next nI

		oPrint:Line (nRow2+0680,100,nRow2+0680,2300)
		oPrint:Line (nRow2+0680,500,nRow2+0600, 500)
		oPrint:Line (nRow2+0680,710,nRow2+0600, 710)

		oPrint:SayBitmap(nRow2+0580,100,"BOL237.JPG",0350,0090)

		oPrint:Say  (nRow2+0640,510,aDadosBanco[1]+"-"+Modulo11(aDadosBanco[1]),oFont20 )	// [1]Numero do Banco

		oPrint:Say  (nRow2+0640,715,aCB_RN_NN[2],oFont15)  	//	Linha Digitavel do Codigo de Barras

		oPrint:Say  (nRow2+0644,2030,"Recibo do Pagador",oFont10)

		oPrint:Line (nRow2+0780,100,nRow2+0780,2300 )
		oPrint:Line (nRow2+0880,100,nRow2+0880,2300 )
		oPrint:Line (nRow2+0880,1800,nRow2+0880,2300 )

		oPrint:Line (nRow2+0950,100,nRow2+0950,2300 )
		oPrint:Line (nRow2+1020,100,nRow2+1020,2300 )
		oPrint:Line (nRow2+0880,500,nRow2+1020,500)
		oPrint:Line (nRow2+0950,380,nRow2+1020,380) //linha
		oPrint:Line (nRow2+0950,770,nRow2+1020,770)
		oPrint:Line (nRow2+0880,1000,nRow2+1020,1000)
		oPrint:Line (nRow2+0880,1300,nRow2+0950,1300)
		oPrint:Line (nRow2+0880,1480,nRow2+1020,1480)

		oPrint:Say  (nRow2+0710,100 ,"Local de Pagamento",oFont8)
		oPrint:Say  (nRow2+0750,100 ,"Pagável Preferencialmente em qualquer Agência Bradesco.",oFont10)
		oPrint:Say  (nRow2+0765,400 ,"  ",oFont10)

		oPrint:Say  (nRow2+0710,1810,"Vencimento",oFont8)
		cString	:= StrZero(Day(aDadosTit[4]),2) +"/"+ StrZero(Month(aDadosTit[4]),2) +"/"+ Right(Str(Year(aDadosTit[4])),4)
		nCol := 1810+(374-(len(cString)*22))
		oPrint:Say  (nRow2+0750,nCol,cString,oFont11c)

		oPrint:Say  (nRow2+0810,100 ,"Beneficiário",oFont8)
		oPrint:Say  (nRow2+0840,100 ,AllTrim(aDadosEmp[1]) ,oFont8) //Nome + CNPJ   // + " - " + aDadosEmp[2]
		oPrint:Say  (nRow2+0835+35,100 ,AllTrim(aDadosEmp[2]) + " -  " + aDadosEmp[3] + " - " + AllTrim(aDadosEmp[4]) + " -  " + aDadosEmp[5] + " -  " + aDadosEmp[6],oFont8) //Endereço e Bairro, Cidade, Estado e Cep

		oPrint:Say  (nRow2+0810,1300 ,"CNPJ Beneficiário: " + Transform(aDadosEmp[8],"@R 99.999.999/9999-99") ,oFont8)

		oPrint:Say  (nRow2+0810,1810,"Agência/Código Beneficiário",oFont8)
		cString := Alltrim(AllTrim(aDadosBanco[3])  + "-" + SA6->A6_DVAGE + " / " + aDadosBanco[4] + "-" + SEE->EE_DVCTA)
		oPrint:Say  (nRow2+0850,1830,cString,oFont11c)

		oPrint:Say  (nRow2+0910,100 ,"Data de Emissao",oFont8)
		oPrint:Say  (nRow2+0940,100, StrZero(Day(aDadosTit[2]),2) +"/"+ StrZero(Month(aDadosTit[2]),2) +"/"+ Right(Str(Year(aDadosTit[2])),4),oFont10)

		oPrint:Say  (nRow2+0910,505 ,"Número do Documento",oFont8)
		oPrint:Say  (nRow2+0940,605 ,aDadosTit[7]+aDadosTit[1],oFont10) //Prefixo +Numero+Parcela

		oPrint:Say  (nRow2+0910,1005,"Espécie Documento",oFont8)
		oPrint:Say  (nRow2+0940,1050,"DM",oFont10) 		  //Tipo do Titulo aDadosTit[8

		oPrint:Say  (nRow2+0910,1305,"Aceite",oFont8)
		oPrint:Say  (nRow2+0940,1390,"N",oFont10) //COLUNA 1400

		oPrint:Say  (nRow2+0910,1485,"Data do Processamento",oFont8)
		oPrint:Say  (nRow2+0940,1550,StrZero(Day(aDadosTit[3]),2) +"/"+ StrZero(Month(aDadosTit[3]),2) +"/"+ Right(Str(Year(aDadosTit[3])),4),oFont10) // Data impressao

		oPrint:Say  (nRow2+0910,1810,"Carteira / Nosso Número",oFont8)
		cString :=  Substr(Alltrim(aDadosTit[6]),1,2)+ "/" + Substr(Alltrim(aDadosTit[6]),3,LEN(aDadosTit[6])-2)
		nCol := 1810+(450-(len(cString)*22))
		oPrint:Say  (nRow2+0940,nCol,cString,oFont11c)

		oPrint:Say  (nRow2+0980,100 ,"Uso do Banco",oFont8)

		oPrint:Say  (nRow2+0980,405 ,"CIP"         ,oFont8)
		oPrint:Say  (nRow2+1010,405 ,"000"      	,oFont10)

		oPrint:Say  (nRow2+0980,505 ,"Carteira",oFont8)
		oPrint:Say  (nRow2+1010,525 ,_cCarteira,oFont10)

		oPrint:Say  (nRow2+0980,775 ,"Moeda",oFont8)
		oPrint:Say  (nRow2+1010,805 ,"R$",oFont10)

		oPrint:Say  (nRow2+0980,1005,"Quantidade",oFont8)
		oPrint:Say  (nRow2+0980,1485,"Valor"     ,oFont8)

		oPrint:Say  (nRow2+0980,1810,"Valor do Documento",oFont8)
		cString := Alltrim(Transform(aDadosTit[5],"@E 99,999,999.99"))
		nCol := 1810+(374-(len(cString)*22))
		oPrint:Say  (nRow2+1010,nCol,cString ,oFont11c)

		oPrint:Say  (nRow2+1050,100 ,"Instruções (Todas informações deste bloqueto são de exclusiva responsabilidade do Beneficiário)",oFont8)
		oPrint:Say  (nRow2+1050,1450 ,"Bordero Nro :"+SE1->E1_NUMBOR,oFont10)

		oPrint:Say  (nRow2+1100,100 ,aBolText[6] ,oFont10)
		oPrint:Say  (nRow2+1150,100 ,aBolText[1]+" " + AllTrim(Transform(((aDadosTit[5] * SE1->E1_PORCJUR) / 100) ,"@E 999,999.99")+""+aBolText[2])  ,oFont10)

		If SEE->EE_XMULTA > 0
			oPrint:Say  (nRow2+1200,100 ,aBolText[3]+" " + AllTrim(Transform(((aDadosTit[5] * SEE->EE_XMULTA) / 100),"@E 999,999.99"))+"",oFont10)
		EndIf

		oPrint:Say  (nRow2+1250,100 ,aBolText[4] ,oFont10)
		oPrint:Say  (nRow2+1300,100 ,aBolText[5] ,oFont10)
		oPrint:Say  (nRow2+1350,100 ,aBolText[7] ,oFont10)

		oPrint:Say  (nRow2+1050,1810,"(-)Desconto",oFont8)
		oPrint:Say  (nRow2+1120,1810,"(-)Outras Deduções",oFont8)
		oPrint:Say  (nRow2+1190,1810,"(+)Mora/Multa"   ,oFont8)
		oPrint:Say  (nRow2+1260,1810,"(+)Outros Acréscimos"  ,oFont8)
		oPrint:Say  (nRow2+1330,1810,"(=)Valor Cobrado"      ,oFont8)

		oPrint:Say  (nRow2+1400,100 ,"Pagador",oFont8)
		oPrint:Say  (nRow2+1430,350 ,LEFT(aDatSacado[1],45)+" ("+aDatSacado[2]+")",oFont10)
		oPrint:Say  (nRow2+1483,350 ,aDatSacado[3],oFont10)
		oPrint:Say  (nRow2+1536,350 ,aDatSacado[6]+"    "+aDatSacado[4]+" - "+aDatSacado[5],oFont10) // CEP+Cidade+Estado

		If aDatSacado[8] = "J"
			oPrint:Say  (nRow2+1589,350 ,"CNPJ: " + TRANSFORM(aDatSacado[7],"@R 99.999.999/9999-99"),oFont10) // CGC
		Else
			oPrint:Say  (nRow2+1589,350 ,"CPF: " + TRANSFORM(aDatSacado[7],"@R 999.999.999-99"),oFont10) 	// CPF
		EndIf

		oPrint:Say  (nRow2+1605,100 ,"Pagador/Avalista",oFont8)
		oPrint:Say  (nRow2+1645,1500,"Autenticacao Mecanica",oFont8)

		oPrint:Line (nRow2+0680,1800,nRow2+1370,1800 )
		oPrint:Line (nRow2+1090,1800,nRow2+1090,2300 )
		oPrint:Line (nRow2+1160,1800,nRow2+1160,2300 )
		oPrint:Line (nRow2+1230,1800,nRow2+1230,2300 )
		oPrint:Line (nRow2+1300,1800,nRow2+1300,2300 )
		oPrint:Line (nRow2+1370,100 ,nRow2+1370,2300 )
		oPrint:Line (nRow2+1610,100 ,nRow2+1610,2300 )

		/******************/
		/* TERCEIRA PARTE */
		/******************/

		nRow3 := 20

		For nI := 100 to 2300 step 50
			oPrint:Line(nRow3+1850, nI, nRow3+1850, nI+30)
		Next nI

		oPrint:Line (nRow3+1970,100,nRow3+1970,2300)
		oPrint:Line (nRow3+1970,500,nRow3+1890, 500)
		oPrint:Line (nRow3+1970,710,nRow3+1890, 710)
		oPrint:SayBitmap(nRow3+1870,100,"BOL237.JPG",0350,0090)

		oPrint:Say  (nRow3+1930,510,aDadosBanco[1]+"-"+Modulo11(aDadosBanco[1]),oFont20 )	// 	[1]Numero do Banco

		oPrint:Say  (nRow3+1934,715,aCB_RN_NN[2],oFont15)  	//	Linha Digitavel do Codigo de Barras

		oPrint:Line (nRow3+2070,100,nRow3+2070,2300 )
		oPrint:Line (nRow3+2170,100,nRow3+2170,2300 )
		oPrint:Line (nRow3+2240,100,nRow3+2240,2300 )
		oPrint:Line (nRow3+2310,100,nRow3+2310,2300 )

		oPrint:Line (nRow3+2170,500 ,nRow3+2310,500 )
		oPrint:Line (nRow3+2240,380 ,nRow3+2310,380) //linha
		oPrint:Line (nRow3+2240,770 ,nRow3+2310,770 )
		oPrint:Line (nRow3+2170,1000,nRow3+2310,1000)
		oPrint:Line (nRow3+2170,1300,nRow3+2240,1300)
		oPrint:Line (nRow3+2170,1480,nRow3+2310,1480)

		oPrint:Say  (nRow3+2000,100 ,"Local de Pagamento",oFont8)
		oPrint:Say  (nRow3+2040,100 ,"Pagável Preferencialmente em qualquer Agência Bradesco.",oFont10)

		oPrint:Say  (nRow3+2000,1810,"Vencimento",oFont8)
		cString := StrZero(Day(aDadosTit[4]),2) +"/"+ StrZero(Month(aDadosTit[4]),2) +"/"+ Right(Str(Year(aDadosTit[4])),4)
		nCol	 	 := 1810+(374-(len(cString)*22))
		oPrint:Say  (nRow3+2040,nCol,cString,oFont11c)

		oPrint:Say  (nRow3+2100,100 ,"Beneficiário",oFont8)
		oPrint:Say  (nRow3+2135,100 ,AllTrim(aDadosEmp[1]) ,oFont8) //Nome + CNPJ   // + " - " + aDadosEmp[2]
		oPrint:Say  (nRow3+2135+30,100 ,AllTrim(aDadosEmp[2]) + " -  " + aDadosEmp[3] + " - " + AllTrim(aDadosEmp[4]) + " -  " + aDadosEmp[5] + " -  " + aDadosEmp[6],oFont8) //Endereço e Bairro, Cidade, Estado e Cep

		oPrint:Say  (nRow3+2100,1300 ,"CNPJ Beneficiário: " + Transform(aDadosEmp[8],"@R 99.999.999/9999-99") ,oFont8)

		oPrint:Say  (nRow3+2100,1810,"Agência/Código Beneficiário",oFont8)
		cString := Alltrim(AllTrim(aDadosBanco[3])  + "-" + SA6->A6_DVAGE + " / " + aDadosBanco[4] + "-" + SEE->EE_DVCTA)
		oPrint:Say  (nRow3+2140,1830,cString ,oFont11c)

		oPrint:Say  (nRow3+2200,100 ,"Data de Emissão",oFont8)
		oPrint:Say (nRow3+2230,100, StrZero(Day(aDadosTit[2]),2) +"/"+ StrZero(Month(aDadosTit[2]),2) +"/"+ Right(Str(Year(aDadosTit[2])),4), oFont10)

		oPrint:Say  (nRow3+2200,505 ,"Número do Documento",oFont8)
		oPrint:Say  (nRow3+2230,605 ,aDadosTit[7]+aDadosTit[1],oFont10) //Prefixo +Numero+Parcela

		oPrint:Say  (nRow3+2200,1005,"Espécie Documento",oFont8)
		oPrint:Say  (nRow3+2230,1050,"DM",oFont10) 		  //Tipo do Titulo

		oPrint:Say  (nRow3+2200,1305,"Aceite",oFont8)
		oPrint:Say  (nRow3+2230,1390,"N"     ,oFont10) //COLUNA 1400

		oPrint:Say  (nRow3+2200,1485,"Data do Processamento",oFont8)
		oPrint:Say  (nRow3+2230,1550,StrZero(Day(aDadosTit[3]),2) +"/"+ StrZero(Month(aDadosTit[3]),2) +"/"+ Right(Str(Year(aDadosTit[3])),4)                               ,oFont10) // Data impressao

		oPrint:Say  (nRow3+2200,1810,"Nosso Número",oFont8)
		cString :=  Substr(Alltrim(aDadosTit[6]),1,2)+ "/" + Substr(Alltrim(aDadosTit[6]),3,LEN(aDadosTit[6]))
		nCol := 1810+(450-(len(cString)*22))
		oPrint:Say  (nRow3+2230,nCol,cString,oFont11c)

		oPrint:Say  (nRow3+2270,100 ,"Uso do Banco",oFont8)
		oPrint:Say  (nRow3+2270,405 ,"CIP"                                       ,oFont8)
		oPrint:Say  (nRow3+2300,405 ,"000"                                     	,oFont10)

		oPrint:Say  (nRow3+2270,505 ,"Carteira"	,oFont8)
		oPrint:Say  (nRow3+2300,510 ,aDadosBanco[6],oFont10)

		oPrint:Say  (nRow3+2270,775 ,"Moeda"	,oFont8)
		oPrint:Say  (nRow3+2300,805 ,"R$"     ,oFont10)

		oPrint:Say  (nRow3+2270,1005,"Quantidade",oFont8)
		oPrint:Say  (nRow3+2270,1485,"Valor"     ,oFont8)

		oPrint:Say  (nRow3+2270,1810,"Valor do Documento",oFont8)
		cString := Alltrim(Transform(aDadosTit[5],"@E 99,999,999.99"))
		nCol 	 := 1810+(374-(len(cString)*22))
		oPrint:Say  (nRow3+2300,nCol,cString,oFont11c)

		oPrint:Say  (nRow3+2340,100 ,"Instruções (Todas informações deste bloqueto são de exclusiva responsabilidade do beneficiário.)",oFont8)
		oPrint:Say  (nRow3+2340,1450 ,"Bordero Nro :"+SE1->E1_NUMBOR,oFont10)

		oPrint:Say  (nRow3+2390,100 ,aBolText[6] ,oFont10)
		oPrint:Say  (nRow3+2440,100 ,aBolText[1]+" "+AllTrim(Transform( ((aDadosTit[5] * SE1->E1_PORCJUR ) / 100) ,"@E 999,999.99")+""+aBolText[2])  ,oFont10) // Juros de Mora de R$ xxxx ao Dia

		If SEE->EE_XMULTA > 0
			oPrint:Say  (nRow3+2490,100 ,aBolText[3]+" " + AllTrim(Transform(((aDadosTit[5] * SEE->EE_XMULTA) / 100),"@E 999,999.99"))+"",oFont10)  //  Apos venciamento multa de R$ xxxxx
		EndIf

		oPrint:Say  (nRow3+2540,100 ,aBolText[4] ,oFont10)
		oPrint:Say  (nRow3+2590,100 ,aBolText[5] ,oFont10)
		oPrint:Say  (nRow3+2640,100 ,aBolText[7] ,oFont10)

		oPrint:Say  (nRow3+2340,1810,"(-)Desconto",oFont8)
		oPrint:Say  (nRow3+2410,1810,"(-)Outras Deduçõe",oFont8)
		oPrint:Say  (nRow3+2480,1810,"(+)Mora/Multa"   ,oFont8)
		oPrint:Say  (nRow3+2550,1810,"(+)Outros Acréscimos"  ,oFont8)
		oPrint:Say  (nRow3+2620,1810,"(=)Valor Cobrado"      ,oFont8)

		oPrint:Say  (nRow3+2690,100 ,"Pagador",oFont8)
		oPrint:Say  (nRow3+2700,350 ,LEFT(aDatSacado[1],45)+" ("+aDatSacado[2]+")",oFont10)

		if aDatSacado[8] = "J"
			oPrint:Say (nRow3+2700,1800,"CNPJ: "+TRANSFORM(aDatSacado[7],"@R 99.999.999/9999-99"),oFont10) // CGC
		Else
			oPrint:Say (nRow3+2700,1800,"CPF: "+TRANSFORM(aDatSacado[7],"@R 999.999.999-99"),oFont10) 		// CPF
		EndIf

		oPrint:Say  (nRow2+1589,1850,Substr(Alltrim(aCB_RN_NN[3]),1,2) + Substr(Alltrim(aCB_RN_NN[3]),3,LEN(aCB_RN_NN[3])) + "-" + aCB_RN_NN[4],oFont10)

		oPrint:Say  (nRow3+2753,350 ,aDatSacado[3],oFont10)
		oPrint:Say  (nRow3+2806,350 ,aDatSacado[6]+" "+aDatSacado[4]+" - "+aDatSacado[5],oFont10) 		// CEP+Cidade+Estado

		oPrint:Say  (nRow3+2815,100 ,"Pagador/Avalista",oFont8)
		oPrint:Say  (nRow3+2855,1500,"Autenticações Mecânica - Ficha de Compensação",oFont8)

		oPrint:Line (nRow3+1970,1800,nRow3+2660,1800)
		oPrint:Line (nRow3+2380,1800,nRow3+2380,2300)
		oPrint:Line (nRow3+2450,1800,nRow3+2450,2300)
		oPrint:Line (nRow3+2520,1800,nRow3+2520,2300)
		oPrint:Line (nRow3+2590,1800,nRow3+2590,2300)
		oPrint:Line (nRow3+2660,100 ,nRow3+2660,2300)
		oPrint:Line (nRow3+2820,100 ,nRow3+2820,2300)

		oPrint:Code128c(nRow3+2950,100,aCB_RN_NN[1], 40)

		cConta := SA6->A6_NUMCON

		DbSelectArea("SE1")
		RecLock("SE1",.F.)
		If Empty(SE1->E1_NUMBCO)
			SE1->E1_NUMBCO		:=	Substr(aCB_RN_NN[3],3,Len(aCB_RN_NN[3]))  + aCB_RN_NN[4]
			SE1->E1_PORTADOR 	:=	'237'
			SE1->E1_AGEDEP 		:=	_cNumAge
			SE1->E1_CONTA 		:=	_cNumCta
		Endif
		SE1->(MsUnlock())

		oPrint:EndPage() // Finaliza a pagina
	EndIf

	//¦+-------------------------------------------------------------+¦
	//¦¦ Itaú                           				         ¦¦
	//¦+-------------------------------------------------------------+¦
	IF aDadosBanco[1] == "341"

		/******************/
		/* PRIMEIRA PARTE */
		/******************/

		nRow1 := 0

		oPrint:Line (nRow1+0120,500,nRow1+0040, 500)
		oPrint:Line (nRow1+0120,710,nRow1+0040, 710)
		oPrint:SayBitmap(nRow1+0020,100,"BOL341.JPG",0350,0090)

		oPrint:Say  (nRow1+0080,510,aDadosBanco[1]+"-"+Modulo11(aDadosBanco[1]),oFont20 )		// [1]Numero do Banco

		oPrint:Say  (nRow1+0084,1900,"Comprovante de Entrega",oFont10)
		oPrint:Line (nRow1+0120,100,nRow1+0120,2300)

		oPrint:Say  (nRow1+0150,100 ,"Beneficiário",oFont8)
		oPrint:Say  (nRow1+0200,100 ,aDadosEmp[1],oFont8)					//Nome + CNPJ

		oPrint:Say  (nRow1+0150,1060,"Agência/Código Beneficiário",oFont8)
		//		oPrint:Say  (nRow1+0200,1080,Alltrim(AllTrim(aDadosBanco[3])  + "-" + SA6->A6_DVAGE + " / " + aDadosBanco[4] + "-" + SEE->EE_DVCTA)  ,oFont10)
		oPrint:Say  (nRow1+0200,1080,Alltrim(AllTrim(aDadosBanco[3]) + "/" + aDadosBanco[4] + "-" + SEE->EE_DVCTA)  ,oFont10)

		oPrint:Say  (nRow1+0150,1510,"Nro.Documento",oFont8)
		oPrint:Say  (nRow1+0200,1510,aDadosTit[7]+aDadosTit[1],oFont10) //Prefixo +Numero+Parcela

		oPrint:Say  (nRow1+0250,100 ,"Pagador",oFont8)
		oPrint:Say  (nRow1+0300,100 ,left(aDatSacado[1],40),oFont10)	//Nome

		oPrint:Say  (nRow1+0250,1060,"Vencimento",oFont8)
		oPrint:Say  (nRow1+0300,1060,StrZero(Day(aDadosTit[4]),2) +"/"+ StrZero(Month(aDadosTit[4]),2) +"/"+ Right(Str(Year(aDadosTit[4])),4),oFont10)

		oPrint:Say  (nRow1+0250,1510,"Valor do Documento",oFont8)
		oPrint:Say  (nRow1+0300,1550,AllTrim(Transform(aDadosTit[5],"@E 999,999,999.99")),oFont10)

		oPrint:Say  (nRow1+0400,0100,"Recebi(emos) o bloqueto/título"	,oFont10 )
		oPrint:Say  (nRow1+0450,0100,"com as caracteristicas acima."	,oFont10 )
		oPrint:Say  (nRow1+0350,1060,"Data"								,oFont8  )
		oPrint:Say  (nRow1+0350,1410,"Assinatura"						,oFont8  )
		oPrint:Say  (nRow1+0450,1060,"Data"								,oFont8  )
		oPrint:Say  (nRow1+0450,1410,"Entregador"						,oFont8  )

		oPrint:Line (nRow1+0220, 100,nRow1+0220,1900 )
		oPrint:Line (nRow1+0320, 100,nRow1+0320,1900 )
		oPrint:Line (nRow1+0420,1050,nRow1+0420,1900 )
		oPrint:Line (nRow1+0520, 100,nRow1+0520,2300 )

		oPrint:Line (nRow1+0520,1050,nRow1+0120,1050 )
		oPrint:Line (nRow1+0520,1400,nRow1+0320,1400 )
		oPrint:Line (nRow1+0320,1500,nRow1+0120,1500 )
		oPrint:Line (nRow1+0520,1900,nRow1+0120,1900 )

		oPrint:Say  ( nRow1+0165,1910,"(  )Mudou-se"					,oFont8 )
		oPrint:Say  ( nRow1+0205,1910,"(  )Ausente"						,oFont8 )
		oPrint:Say  ( nRow1+0245,1910,"(  )Não existe não indicado"		,oFont8 )
		oPrint:Say  ( nRow1+0285,1910,"(  )Recusado"					,oFont8 )
		oPrint:Say  ( nRow1+0325,1910,"(  )Não procurado"				,oFont8 )
		oPrint:Say  ( nRow1+0365,1910,"(  )Endeço insuficiente"			,oFont8 )
		oPrint:Say  ( nRow1+0405,1910,"(  )Desconhecido"				,oFont8 )
		oPrint:Say  ( nRow1+0445,1910,"(  )Falecido"					,oFont8 )
		oPrint:Say  ( nRow1+0485,1910,"(  )Outros(anotar no verso)"		,oFont8 )

		/*****************/
		/* SEGUNDA PARTE */
		/*****************/
		nRow2 := 110

		//Pontilhado separador
		For nI := 100 to 2300 step 50
			oPrint:Line(nRow2+0550, nI,nRow2+0550, nI+30)
		Next nI

		oPrint:Line (nRow2+0680,100,nRow2+0680,2300)
		oPrint:Line (nRow2+0680,500,nRow2+0600, 500)
		oPrint:Line (nRow2+0680,710,nRow2+0600, 710)

		oPrint:SayBitmap(nRow2+0580,100,"BOL341.JPG",0350,0090)

		oPrint:Say  (nRow2+0640,510,aDadosBanco[1]+"-"+Modulo11(aDadosBanco[1]),oFont20 )	// [1]Numero do Banco

		oPrint:Say  (nRow2+0640,715,aCB_RN_NN[2],oFont15)  	//	Linha Digitavel do Codigo de Barras

		oPrint:Say  (nRow2+0644,2030,"Recibo do Pagador",oFont10)

		oPrint:Line (nRow2+0780,100,nRow2+0780,2300 )
		oPrint:Line (nRow2+0880,100,nRow2+0880,2300 )
		oPrint:Line (nRow2+0880,1800,nRow2+0880,2300 )

		oPrint:Line (nRow2+0950,100,nRow2+0950,2300 )
		oPrint:Line (nRow2+1020,100,nRow2+1020,2300 )
		oPrint:Line (nRow2+0880,500,nRow2+1020,500)
		oPrint:Line (nRow2+0950,380,nRow2+1020,380) //linha
		oPrint:Line (nRow2+0950,770,nRow2+1020,770)
		oPrint:Line (nRow2+0880,1000,nRow2+1020,1000)
		oPrint:Line (nRow2+0880,1300,nRow2+0950,1300)
		oPrint:Line (nRow2+0880,1480,nRow2+1020,1480)

		oPrint:Say  (nRow2+0710,100 ,"Local de Pagamento",oFont8)
		//		oPrint:Say  (nRow2+0750,100 ,"Pagável Preferencialmente em qualquer Agência Itaú.",oFont10)
		oPrint:Say  (nRow2+0750,100 ,"Até o vencimento, preferencialmente no Itaú e Após o vencimento, somente no Itaú",oFont10)
		oPrint:Say  (nRow2+0765,400 ,"  ",oFont10)

		oPrint:Say  (nRow2+0710,1810,"Vencimento",oFont8)
		cString	:= StrZero(Day(aDadosTit[4]),2) +"/"+ StrZero(Month(aDadosTit[4]),2) +"/"+ Right(Str(Year(aDadosTit[4])),4)
		nCol := 1810+(374-(len(cString)*22))
		//		oPrint:Say  (nRow2+0750,nCol,cString,oFont11c)
		//		oPrint:SayAlign(nRow2+0750,1830,cString, oFont11c,,,,1,1)
		oPrint:SayAlign(nRow2+0735,1830, cString, oFont11c , 0300 , 050 ,, 1 , 1 )

		oPrint:Say  (nRow2+0810,100 ,"Beneficiário",oFont8)
		oPrint:Say  (nRow2+0840,100 ,AllTrim(aDadosEmp[1]) ,oFont8) //Nome + CNPJ   // + " - " + aDadosEmp[2]
		oPrint:Say  (nRow2+0835+35,100 ,AllTrim(aDadosEmp[2]) + " -  " + aDadosEmp[3] + " - " + AllTrim(aDadosEmp[4]) + " -  " + aDadosEmp[5] + " -  " + aDadosEmp[6],oFont8) //Endereço e Bairro, Cidade, Estado e Cep

		oPrint:Say  (nRow2+0810,1300 ,"CNPJ Beneficiário: " + Transform(aDadosEmp[8],"@R 99.999.999/9999-99") ,oFont8)

		oPrint:Say  (nRow2+0810,1810,"Agência/Código Beneficiário",oFont8)
		//		cString := Alltrim(AllTrim(aDadosBanco[3])  + "-" + SA6->A6_DVAGE + " / " + aDadosBanco[4] + "-" + SEE->EE_DVCTA)
		cString := Alltrim(AllTrim(aDadosBanco[3]) + "/" + aDadosBanco[4] + "-" + SEE->EE_DVCTA)
		//		oPrint:Say  (nRow2+0850,1830,cString,oFont11c)
		oPrint:SayAlign(nRow2+0834,1830, cString, oFont11c , 0300 , 050 ,, 1 , 1 )

		oPrint:Say  (nRow2+0910,100 ,"Data de Emissao",oFont8)
		oPrint:Say  (nRow2+0940,100, StrZero(Day(aDadosTit[2]),2) +"/"+ StrZero(Month(aDadosTit[2]),2) +"/"+ Right(Str(Year(aDadosTit[2])),4),oFont10)

		oPrint:Say  (nRow2+0910,505 ,"Número do Documento",oFont8)
		oPrint:Say  (nRow2+0940,605 ,aDadosTit[7]+aDadosTit[1],oFont10) //Prefixo +Numero+Parcela

		oPrint:Say  (nRow2+0910,1005,"Espécie Documento",oFont8)
		oPrint:Say  (nRow2+0940,1050,"DM",oFont10) 		  //Tipo do Titulo aDadosTit[8

		oPrint:Say  (nRow2+0910,1305,"Aceite",oFont8)
		oPrint:Say  (nRow2+0940,1390,"N",oFont10) //COLUNA 1400

		oPrint:Say  (nRow2+0910,1485,"Data do Processamento",oFont8)
		oPrint:Say  (nRow2+0940,1550,StrZero(Day(aDadosTit[3]),2) +"/"+ StrZero(Month(aDadosTit[3]),2) +"/"+ Right(Str(Year(aDadosTit[3])),4),oFont10) // Data impressao

		oPrint:Say  (nRow2+0910,1810,"Carteira / Nosso Número",oFont8)
		cString :=  _cCarteira + "/" + Alltrim(aDadosTit[6])
		nCol := 1810+(450-(len(cString)*22))
		//		oPrint:Say  (nRow2+0940,nCol,cString,oFont11c)
		oPrint:SayAlign(nRow2+0912,1830,cString, oFont11c , 0300 , 050 ,, 1 , 1 )

		oPrint:Say  (nRow2+0980,100 ,"Uso do Banco",oFont8)

		oPrint:Say  (nRow2+0980,405 ,"CIP"         ,oFont8)
		oPrint:Say  (nRow2+1010,405 ,"000"      	,oFont10)

		oPrint:Say  (nRow2+0980,505 ,"Carteira",oFont8)
		oPrint:Say  (nRow2+1010,525 ,_cCarteira,oFont10)

		oPrint:Say  (nRow2+0980,775 ,"Moeda",oFont8)
		oPrint:Say  (nRow2+1010,805 ,"R$",oFont10)

		oPrint:Say  (nRow2+0980,1005,"Quantidade",oFont8)
		oPrint:Say  (nRow2+0980,1485,"Valor"     ,oFont8)

		oPrint:Say  (nRow2+0980,1810,"Valor do Documento",oFont8)
		cString := Alltrim(Transform(aDadosTit[5],"@E 99,999,999.99"))
		nCol := 1810+(374-(len(cString)*22))
		//		oPrint:Say  (nRow2+1010,nCol,cString ,oFont11c)
		oPrint:SayAlign(nRow2+976,1830, cString, oFont11c , 0300 , 050 ,, 1 , 1 )

		oPrint:Say  (nRow2+1050,100 ,"Instruções (Todas informações deste bloqueto são de exclusiva responsabilidade do Beneficiário)",oFont8)
		oPrint:Say  (nRow2+1050,1450 ,"Bordero Nro :"+SE1->E1_NUMBOR,oFont10)

		oPrint:Say  (nRow2+1100,100 ,aBolText[6] ,oFont10)
		oPrint:Say  (nRow2+1150,100 ,aBolText[1]+" " + AllTrim(Transform(((aDadosTit[5] * SE1->E1_PORCJUR) / 100) ,"@E 999,999.99")+""+aBolText[2])  ,oFont10)

		If SEE->EE_XMULTA > 0
			oPrint:Say  (nRow2+1200,100 ,aBolText[3]+" " + AllTrim(Transform(((aDadosTit[5] * SEE->EE_XMULTA) / 100),"@E 999,999.99"))+"",oFont10)
		EndIf

		oPrint:Say  (nRow2+1250,100 ,aBolText[4] ,oFont10)
		oPrint:Say  (nRow2+1300,100 ,aBolText[5] ,oFont10)
		oPrint:Say  (nRow2+1350,100 ,aBolText[7] ,oFont10)

		oPrint:Say  (nRow2+1050,1810,"(-)Desconto",oFont8)
		oPrint:Say  (nRow2+1120,1810,"(-)Outras Deduções",oFont8)
		oPrint:Say  (nRow2+1190,1810,"(+)Mora/Multa"   ,oFont8)
		oPrint:Say  (nRow2+1260,1810,"(+)Outros Acréscimos"  ,oFont8)
		oPrint:Say  (nRow2+1330,1810,"(=)Valor Cobrado"      ,oFont8)

		oPrint:Say  (nRow2+1400,100 ,"Pagador",oFont8)
		oPrint:Say  (nRow2+1430,350 ,LEFT(aDatSacado[1],45)+" ("+aDatSacado[2]+")",oFont10)
		oPrint:Say  (nRow2+1483,350 ,aDatSacado[3],oFont10)
		oPrint:Say  (nRow2+1536,350 ,aDatSacado[6]+"    "+aDatSacado[4]+" - "+aDatSacado[5],oFont10) // CEP+Cidade+Estado

		If aDatSacado[8] = "J"
			oPrint:Say  (nRow2+1589,350 ,"CNPJ: " + TRANSFORM(aDatSacado[7],"@R 99.999.999/9999-99"),oFont10) // CGC
		Else
			oPrint:Say  (nRow2+1589,350 ,"CPF: " + TRANSFORM(aDatSacado[7],"@R 999.999.999-99"),oFont10) 	// CPF
		EndIf

		oPrint:Say  (nRow2+1605,100 ,"Pagador/Avalista",oFont8)
		oPrint:Say  (nRow2+1645,1500,"Autenticacao Mecanica",oFont8)

		oPrint:Line (nRow2+0680,1800,nRow2+1370,1800 )
		oPrint:Line (nRow2+1090,1800,nRow2+1090,2300 )
		oPrint:Line (nRow2+1160,1800,nRow2+1160,2300 )
		oPrint:Line (nRow2+1230,1800,nRow2+1230,2300 )
		oPrint:Line (nRow2+1300,1800,nRow2+1300,2300 )
		oPrint:Line (nRow2+1370,100 ,nRow2+1370,2300 )
		oPrint:Line (nRow2+1610,100 ,nRow2+1610,2300 )

		/******************/
		/* TERCEIRA PARTE */
		/******************/

		nRow3 := 20

		For nI := 100 to 2300 step 50
			oPrint:Line(nRow3+1850, nI, nRow3+1850, nI+30)
		Next nI

		oPrint:Line (nRow3+1970,100,nRow3+1970,2300)
		oPrint:Line (nRow3+1970,500,nRow3+1890, 500)
		oPrint:Line (nRow3+1970,710,nRow3+1890, 710)
		oPrint:SayBitmap(nRow3+1870,100,"BOL341.JPG",0350,0090)

		oPrint:Say  (nRow3+1930,510,aDadosBanco[1]+"-"+Modulo11(aDadosBanco[1]),oFont20 )	// 	[1]Numero do Banco

		oPrint:Say  (nRow3+1934,715,aCB_RN_NN[2],oFont15)  	//	Linha Digitavel do Codigo de Barras

		oPrint:Line (nRow3+2070,100,nRow3+2070,2300 )
		oPrint:Line (nRow3+2170,100,nRow3+2170,2300 )
		oPrint:Line (nRow3+2240,100,nRow3+2240,2300 )
		oPrint:Line (nRow3+2310,100,nRow3+2310,2300 )

		oPrint:Line (nRow3+2170,500 ,nRow3+2310,500 )
		oPrint:Line (nRow3+2240,380 ,nRow3+2310,380) //linha
		oPrint:Line (nRow3+2240,770 ,nRow3+2310,770 )
		oPrint:Line (nRow3+2170,1000,nRow3+2310,1000)
		oPrint:Line (nRow3+2170,1300,nRow3+2240,1300)
		oPrint:Line (nRow3+2170,1480,nRow3+2310,1480)

		oPrint:Say  (nRow3+2000,100 ,"Local de Pagamento",oFont8)
		oPrint:Say  (nRow3+2040,100 ,"Até o vencimento, preferencialmente no Itaú e Após o vencimento, somente no Itaú",oFont10)

		oPrint:Say  (nRow3+2000,1810,"Vencimento",oFont8)
		cString := StrZero(Day(aDadosTit[4]),2) +"/"+ StrZero(Month(aDadosTit[4]),2) +"/"+ Right(Str(Year(aDadosTit[4])),4)
		nCol	 	 := 1810+(374-(len(cString)*22))
		//		oPrint:Say  (nRow3+2040,nCol,cString,oFont11c)
		oPrint:SayAlign(nRow3+2025,1830, cString, oFont11c , 0300 , 050 ,, 1 , 1 )

		oPrint:Say  (nRow3+2100,100 ,"Beneficiário",oFont8)
		oPrint:Say  (nRow3+2135,100 ,AllTrim(aDadosEmp[1]) ,oFont8) //Nome + CNPJ   // + " - " + aDadosEmp[2]
		oPrint:Say  (nRow3+2135+30,100 ,AllTrim(aDadosEmp[2]) + " -  " + aDadosEmp[3] + " - " + AllTrim(aDadosEmp[4]) + " -  " + aDadosEmp[5] + " -  " + aDadosEmp[6],oFont8) //Endereço e Bairro, Cidade, Estado e Cep

		oPrint:Say  (nRow3+2100,1300 ,"CNPJ Beneficiário: " + Transform(aDadosEmp[8],"@R 99.999.999/9999-99") ,oFont8)

		oPrint:Say  (nRow3+2100,1810,"Agência/Código Beneficiário",oFont8)
		//		cString := Alltrim(AllTrim(aDadosBanco[3])  + "-" + SA6->A6_DVAGE + " / " + aDadosBanco[4] + "-" + SEE->EE_DVCTA)
		cString := Alltrim(AllTrim(aDadosBanco[3])+ "/" + aDadosBanco[4] + "-" + SEE->EE_DVCTA)
		//		oPrint:Say  (nRow3+2140,1830,cString ,oFont11c)
		oPrint:SayAlign(nRow3+2124,1830, cString, oFont11c , 0300 , 050 ,, 1 , 1 )

		oPrint:Say  (nRow3+2200,100 ,"Data de Emissão",oFont8)
		oPrint:Say (nRow3+2230,100, StrZero(Day(aDadosTit[2]),2) +"/"+ StrZero(Month(aDadosTit[2]),2) +"/"+ Right(Str(Year(aDadosTit[2])),4), oFont10)

		oPrint:Say  (nRow3+2200,505 ,"Número do Documento",oFont8)
		oPrint:Say  (nRow3+2230,605 ,aDadosTit[7]+aDadosTit[1],oFont10) //Prefixo +Numero+Parcela

		oPrint:Say  (nRow3+2200,1005,"Espécie Documento",oFont8)
		oPrint:Say  (nRow3+2230,1050,"DM",oFont10) 		  //Tipo do Titulo

		oPrint:Say  (nRow3+2200,1305,"Aceite",oFont8)
		oPrint:Say  (nRow3+2230,1390,"N"     ,oFont10) //COLUNA 1400

		oPrint:Say  (nRow3+2200,1485,"Data do Processamento",oFont8)
		oPrint:Say  (nRow3+2230,1550,StrZero(Day(aDadosTit[3]),2) +"/"+ StrZero(Month(aDadosTit[3]),2) +"/"+ Right(Str(Year(aDadosTit[3])),4)                               ,oFont10) // Data impressao

		//		oPrint:Say  (nRow3+2200,1810,"Nosso Número",oFont8)
		oPrint:Say  (nRow3+2200,1810,"Carteira / Nosso Número",oFont8)
		cString :=  _cCarteira + "/" + Alltrim(aDadosTit[6])
		nCol := 1810+(450-(len(cString)*22))
		//		oPrint:Say  (nRow3+2230,nCol,cString,oFont11c)
		oPrint:SayAlign(nRow3+2202,1830,cString, oFont11c , 0300 , 050 ,, 1 , 1 )

		oPrint:Say  (nRow3+2270,100 ,"Uso do Banco",oFont8)
		oPrint:Say  (nRow3+2270,405 ,"CIP"                                       ,oFont8)
		oPrint:Say  (nRow3+2300,405 ,"000"                                     	,oFont10)

		oPrint:Say  (nRow3+2270,505 ,"Carteira"	,oFont8)
		oPrint:Say  (nRow3+2300,510 ,aDadosBanco[6],oFont10)

		oPrint:Say  (nRow3+2270,775 ,"Moeda"	,oFont8)
		oPrint:Say  (nRow3+2300,805 ,"R$"     ,oFont10)

		oPrint:Say  (nRow3+2270,1005,"Quantidade",oFont8)
		oPrint:Say  (nRow3+2270,1485,"Valor"     ,oFont8)

		oPrint:Say  (nRow3+2270,1810,"Valor do Documento",oFont8)
		cString := Alltrim(Transform(aDadosTit[5],"@E 99,999,999.99"))
		nCol 	 := 1810+(374-(len(cString)*22))
		//		oPrint:Say  (nRow3+2300,nCol,cString,oFont11c)
		oPrint:SayAlign(nRow3+2266,1830, cString, oFont11c , 0300 , 050 ,, 1 , 1 )

		oPrint:Say  (nRow3+2340,100 ,"Instruções (Todas informações deste bloqueto são de exclusiva responsabilidade do beneficiário.)",oFont8)
		oPrint:Say  (nRow3+2340,1450 ,"Bordero Nro :"+SE1->E1_NUMBOR,oFont10)

		oPrint:Say  (nRow3+2390,100 ,aBolText[6] ,oFont10)
		oPrint:Say  (nRow3+2440,100 ,aBolText[1]+" "+AllTrim(Transform( ((aDadosTit[5] * SE1->E1_PORCJUR ) / 100) ,"@E 999,999.99")+""+aBolText[2])  ,oFont10) // Juros de Mora de R$ xxxx ao Dia

		If SEE->EE_XMULTA > 0
			oPrint:Say  (nRow3+2490,100 ,aBolText[3]+" " + AllTrim(Transform(((aDadosTit[5] * SEE->EE_XMULTA) / 100),"@E 999,999.99"))+"",oFont10)  //  Apos venciamento multa de R$ xxxxx
		EndIf

		oPrint:Say  (nRow3+2540,100 ,aBolText[4] ,oFont10)
		oPrint:Say  (nRow3+2590,100 ,aBolText[5] ,oFont10)
		oPrint:Say  (nRow3+2640,100 ,aBolText[7] ,oFont10)

		oPrint:Say  (nRow3+2340,1810,"(-)Desconto",oFont8)
		oPrint:Say  (nRow3+2410,1810,"(-)Outras Deduçõe",oFont8)
		oPrint:Say  (nRow3+2480,1810,"(+)Mora/Multa"   ,oFont8)
		oPrint:Say  (nRow3+2550,1810,"(+)Outros Acréscimos"  ,oFont8)
		oPrint:Say  (nRow3+2620,1810,"(=)Valor Cobrado"      ,oFont8)

		oPrint:Say  (nRow3+2690,100 ,"Pagador",oFont8)
		oPrint:Say  (nRow3+2700,350 ,LEFT(aDatSacado[1],45)+" ("+aDatSacado[2]+")",oFont10)

		if aDatSacado[8] = "J"
			oPrint:Say (nRow3+2700,1800,"CNPJ: "+TRANSFORM(aDatSacado[7],"@R 99.999.999/9999-99"),oFont10) // CGC
		Else
			oPrint:Say (nRow3+2700,1800,"CPF: "+TRANSFORM(aDatSacado[7],"@R 999.999.999-99"),oFont10) 		// CPF
		EndIf

		oPrint:Say  (nRow3+2753,350 ,aDatSacado[3],oFont10)
		oPrint:Say  (nRow3+2806,350 ,aDatSacado[6]+" "+aDatSacado[4]+" - "+aDatSacado[5],oFont10) 		// CEP+Cidade+Estado

		oPrint:Say  (nRow3+2815,100 ,"Pagador/Avalista",oFont8)
		oPrint:Say  (nRow3+2855,1500,"Autenticações Mecânica - Ficha de Compensação",oFont8)

		oPrint:Line (nRow3+1970,1800,nRow3+2660,1800)
		oPrint:Line (nRow3+2380,1800,nRow3+2380,2300)
		oPrint:Line (nRow3+2450,1800,nRow3+2450,2300)
		oPrint:Line (nRow3+2520,1800,nRow3+2520,2300)
		oPrint:Line (nRow3+2590,1800,nRow3+2590,2300)
		oPrint:Line (nRow3+2660,100 ,nRow3+2660,2300)
		oPrint:Line (nRow3+2820,100 ,nRow3+2820,2300)

		oPrint:Code128c(nRow3+2950,100,aCB_RN_NN[1], 40)

		cConta := SA6->A6_NUMCON

		DbSelectArea("SE1")
		RecLock("SE1",.F.)
		If Empty(SE1->E1_NUMBCO)
			SE1->E1_NUMBCO		:=	aCB_RN_NN[3] + aCB_RN_NN[4]
			SE1->E1_PORTADOR 	:=	'341'
			SE1->E1_AGEDEP 		:=	_cNumAge
			SE1->E1_CONTA 		:=	_cNumCta
		Endif
		SE1->(MsUnlock())

		oPrint:EndPage() // Finaliza a pagina
	EndIf

	//¦+-------------------------------------------------------------+¦
	//¦¦ Santander                           				         ¦¦
	//¦+-------------------------------------------------------------+¦
	IF aDadosBanco[1] == "033"

		cNosNum := SubStr( aCB_RN_NN[3], 6, Len( aCB_RN_NN[3] ) )

		cNosNum := cNosNum + aCB_RN_NN[4]
		/******************/
		/* PRIMEIRA PARTE */
		/******************/
		nRow1 := 0

		oPrint:Line (nRow1+0120,500,nRow1+0040, 500)
		oPrint:Line (nRow1+0120,710,nRow1+0040, 710)
		oPrint:SayBitmap(nRow1+0020,100,"BOL033.JPG",0350,0090)

		oPrint:Say  (nRow1+0075,510,aDadosBanco[1]+"-7",oFont20 )		// [1]Numero do Banco

		oPrint:Say  (nRow1+0084,1900,"Comprovante de Entrega",oFont10)
		oPrint:Line (nRow1+0120,100,nRow1+0120,2300)

		oPrint:Say  (nRow1+0150,100 ,"Beneficiario",oFont8)
		oPrint:Say  (nRow1+0200,100 ,aDadosEmp[1],oFont8)					//Nome + CNPJ

		oPrint:Say  (nRow1+0150,1060,"Agência/Código Cedente",oFont8)
		//oPrint:Say  (nRow1+0200,1060,AllTrim(aDadosBanco[3]) + " / " + aDadosBanco[4] + "-" + aDadosBanco[5],oFont10)
		oPrint:Say  (nRow1+0200,1060,AllTrim(aDadosBanco[3]) + " / " + _cConvenio ,oFont10)

		oPrint:Say  (nRow1+0150,1510,"Nro.Documento",oFont8)
		oPrint:Say  (nRow1+0200,1510,aDadosTit[7]+aDadosTit[1],oFont10) //Prefixo +Numero+Parcela

		oPrint:Say  (nRow1+0250,100 ,"Pagador",oFont8)
		oPrint:Say  (nRow1+0300,100 ,left(aDatSacado[1],40),oFont10)	//Nome

		oPrint:Say  (nRow1+0250,1060,"Vencimento",oFont8)
		oPrint:Say  (nRow1+0300,1060,StrZero(Day(aDadosTit[4]),2) +"/"+ StrZero(Month(aDadosTit[4]),2) +"/"+ Right(Str(Year(aDadosTit[4])),4),oFont10)

		oPrint:Say  (nRow1+0250,1510,"Valor do Documento",oFont8)
		oPrint:Say  (nRow1+0300,1550,AllTrim(Transform(aDadosTit[5],"@E 999,999,999.99")),oFont10)

		oPrint:Say  (nRow1+0400,0100,"Recebi(emos) o bloqueto/título"	,oFont10 )
		oPrint:Say  (nRow1+0450,0100,"com as caracteristicas acima."	,oFont10 )
		oPrint:Say  (nRow1+0350,1060,"Data"								,oFont8  )
		oPrint:Say  (nRow1+0350,1410,"Assinatura"						,oFont8  )
		oPrint:Say  (nRow1+0450,1060,"Data"								,oFont8  )
		oPrint:Say  (nRow1+0450,1410,"Entregador"						,oFont8  )

		oPrint:Line (nRow1+0220, 100,nRow1+0220,1900 )
		oPrint:Line (nRow1+0320, 100,nRow1+0320,1900 )
		oPrint:Line (nRow1+0420,1050,nRow1+0420,1900 )
		oPrint:Line (nRow1+0520, 100,nRow1+0520,2300 )

		oPrint:Line (nRow1+0520,1050,nRow1+0120,1050 )
		oPrint:Line (nRow1+0520,1400,nRow1+0320,1400 )
		oPrint:Line (nRow1+0320,1500,nRow1+0120,1500 )
		oPrint:Line (nRow1+0520,1900,nRow1+0120,1900 )

		oPrint:Say  ( nRow1+0165,1910,"(  )Mudou-se"					,oFont8 )
		oPrint:Say  ( nRow1+0205,1910,"(  )Ausente"						,oFont8 )
		oPrint:Say  ( nRow1+0245,1910,"(  )Não existe não indicado"		,oFont8 )
		oPrint:Say  ( nRow1+0285,1910,"(  )Recusado"					,oFont8 )
		oPrint:Say  ( nRow1+0325,1910,"(  )Não procurado"				,oFont8 )
		oPrint:Say  ( nRow1+0365,1910,"(  )Endeço insuficiente"			,oFont8 )
		oPrint:Say  ( nRow1+0405,1910,"(  )Desconhecido"				,oFont8 )
		oPrint:Say  ( nRow1+0445,1910,"(  )Falecido"					,oFont8 )
		oPrint:Say  ( nRow1+0485,1910,"(  )Outros(anotar no verso)"		,oFont8 )

		/*****************/
		/* SEGUNDA PARTE */
		/*****************/
		nRow2 := 110

		//Pontilhado separador
		For nI := 100 to 2300 step 50
			oPrint:Line(nRow2+0550, nI,nRow2+0550, nI+30)
		Next nI

		oPrint:Line (nRow2+0680,100,nRow2+0680,2300)
		oPrint:Line (nRow2+0680,500,nRow2+0600, 500)
		oPrint:Line (nRow2+0680,710,nRow2+0600, 710)
		oPrint:SayBitmap(nRow2+0580,100,"BOL033.JPG",0350,0090)

		oPrint:Say  (nRow2+0635,510,aDadosBanco[1]+"-7",oFont20 )	// [1]Numero do Banco

		oPrint:Say  (nRow2+0644,1800,"Recibo do Pagador",oFont10)

		oPrint:Line (nRow2+0780,100,nRow2+0780,2300 )
		oPrint:Line (nRow2+0880,100,nRow2+0880,2300 )
		oPrint:Line (nRow2+0950,100,nRow2+0950,2300 )
		oPrint:Line (nRow2+1020,100,nRow2+1020,2300 )
		oPrint:Line (nRow2+1090,100,nRow2+1090,2300 )

		oPrint:Line (nRow2+0950,500,nRow2+1090,500)
		oPrint:Line (nRow2+1020,770,nRow2+1090,770)
		oPrint:Line (nRow2+0950,1000,nRow2+1090,1000)
		oPrint:Line (nRow2+0950,1300,nRow2+1020,1300)
		oPrint:Line (nRow2+0950,1480,nRow2+1090,1480)

		oPrint:Say  (nRow2+0710,100 ,"Local de Pagamento",oFont8)
		oPrint:Say  (nRow2+0750,100 ,"Pagável Preferencialmente no Santander.",oFont10)
		oPrint:Say  (nRow2+0765,400 ," ",oFont10)

		oPrint:Say  (nRow2+0710,1810,"Vencimento",oFont8)
		cString	:= StrZero(Day(aDadosTit[4]),2) +"/"+ StrZero(Month(aDadosTit[4]),2) +"/"+ Right(Str(Year(aDadosTit[4])),4)
		nCol := 1820+(374-(len(cString)*22))
		oPrint:Say  (nRow2+0750,nCol,cString,oFont11c)

		oPrint:Say  (nRow2+0810,100 ,"Beneficiário",oFont8)
		oPrint:Say  (nRow2+0850,100 ,AllTrim(aDadosEmp[1])  ,oFont8) //Nome + CNPJ

		oPrint:Say  (nRow2+0810,1250 ,"CNPJ do Beneficiário: " + Transform(aDadosEmp[8],"@R 99.999.999/9999-99") ,oFont8)

		oPrint:Say  (nRow2+0810,1810,"Agência/Código Beneficiário",oFont8)
		//cString := Alltrim(AllTrim(aDadosBanco[3]) + " / " + aDadosBanco[4] + "-" + aDadosBanco[5])
		cString := Alltrim(AllTrim(aDadosBanco[3]) + " / " + _cConvenio )

		nCol := 1820+(374-(len(cString)*22))
		oPrint:Say  (nRow2+0850,nCol,cString,oFont11c)

		oPrint:Say (nRow2+0910,0100,"Endereço Beneficiário",oFont8)
		//oPrint:Say (nRow2+0940,0100,AllTrim(aDadosEmp[2])+" "+Alltrim(aDadosEmp[3])+" "+Alltrim(aDadosEmp[4]) + " - " + AllTrim(aDadosEmp[5]) + " - " + AllTrim(aDadosEmp[6]) + " - " + AllTrim(aDadosEmp[7]) ,oFont8n)					// [1] Nome
		oPrint:Say (nRow2+0940,0100,AllTrim(aDadosEmp[2])+" "+Alltrim(aDadosEmp[3])+" "+Alltrim(aDadosEmp[4]) + " - " + AllTrim(aDadosEmp[5]) + " - " + AllTrim(aDadosEmp[6]) ,oFont8n)					// [1] Nome

		oPrint:Say  (nRow2+0980,100 ,"Data do Documento",oFont8)
		oPrint:Say  (nRow2+1010,100, StrZero(Day(aDadosTit[2]),2) +"/"+ StrZero(Month(aDadosTit[2]),2) +"/"+ Right(Str(Year(aDadosTit[2])),4),oFont10)

		oPrint:Say  (nRow2+0980,505 ,"Nro.Documento",oFont8)
		oPrint:Say  (nRow2+1010,605 ,aDadosTit[7]+aDadosTit[1],oFont10) //Prefixo +Numero+Parcela

		oPrint:Say  (nRow2+0980,1005,"Especie Doc.",oFont8)
		oPrint:Say  (nRow2+1010,1050,"DM",oFont10) 		  //Tipo do Titulo

		oPrint:Say  (nRow2+0980,1305,"Aceite",oFont8)
		oPrint:Say  (nRow2+1010,1400,"N",oFont10)

		oPrint:Say  (nRow2+0980,1485,"Data do Processamento",oFont8)
		oPrint:Say  (nRow2+1010,1550,StrZero(Day(aDadosTit[3]),2) +"/"+ StrZero(Month(aDadosTit[3]),2) +"/"+ Right(Str(Year(aDadosTit[3])),4),oFont10) // Data impressao

		oPrint:Say  (nRow2+0910,1810,"Nosso Número",oFont8)
		nCol := 1820+(374-(len(cString)*22))
		oPrint:Say  (nRow2+0940,nCol, Transform(cNosNum,"@R 9999999-9") ,oFont11c)

		oPrint:Say  (nRow2+1050,100 ,"Uso do Banco",oFont8)

		oPrint:Say  (nRow2+1050,505 ,"Carteira",oFont8)
		oPrint:Say  (nRow2+1080,500 ,aDadosBanco[6],oFont9)

		oPrint:Say  (nRow2+1050,775 ,"Especie",oFont8)
		oPrint:Say  (nRow2+1080,805 ,"REAL",oFont10)
		oPrint:Say  (nRow2+1050,1005,"Quantidade",oFont8)
		oPrint:Say  (nRow2+1050,1485,"Valor"     ,oFont8)

		oPrint:Say  (nRow2+0980,1810,"Valor do Documento",oFont8)
		cString := Alltrim(Transform(aDadosTit[5],"@E 99,999,999.99"))
		nCol := 1820+(374-(len(cString)*22))
		oPrint:Say  (nRow2+1010,nCol,cString ,oFont11c)

		oPrint:Say  (nRow2+1120,100 ,"Instruções (Todas informações deste bloqueto são de exclusiva responsabilidade do Beneficiário)",oFont8)

		oPrint:Say  (nRow2+1150,100 ,aBolText[6] ,oFont10)
		oPrint:Say  (nRow2+1200,100 ,aBolText[1]+" " + AllTrim(Transform(((aDadosTit[5] * SE1->E1_PORCJUR) / 100) ,"@E 999,999.99")+""+aBolText[2])  ,oFont10)

		If SEE->EE_XMULTA > 0
			oPrint:Say  (nRow2+1250,100 ,aBolText[3]+" " + AllTrim(Transform(((aDadosTit[5] * SEE->EE_XMULTA) / 100),"@E 999,999.99"))+"",oFont10)
		EndIf

		oPrint:Say  (nRow2+1300,100 ,aBolText[4] ,oFont10)
		oPrint:Say  (nRow2+1350,100 ,aBolText[5] ,oFont10)
		oPrint:Say  (nRow2+1350,100 ,aBolText[7] ,oFont10)

		oPrint:Say  (nRow2+1050,1810,"(-)Desconto/Abatimento",oFont8)
		oPrint:Say  (nRow2+1120,1810,"(-)Outras Deduções"    ,oFont8)
		oPrint:Say  (nRow2+1190,1810,"(+)Mora/Multa"         ,oFont8)
		oPrint:Say  (nRow2+1260,1810,"(+)Outros Acréscimos"  ,oFont8)
		oPrint:Say  (nRow2+1330,1810,"(=)Valor Cobrado"      ,oFont8)

		oPrint:Say  (nRow2+1400,100 ,"Pagador",oFont8)
		oPrint:Say  (nRow2+1430,350 ,LEFT(aDatSacado[1],45)+" ("+aDatSacado[2]+")",oFont10)
		oPrint:Say  (nRow2+1483,350 ,aDatSacado[3],oFont10)
		oPrint:Say  (nRow2+1536,350 ,aDatSacado[6]+"    "+aDatSacado[4]+" - "+aDatSacado[5],oFont10) // CEP+Cidade+Estado

		if aDatSacado[8] = "J"
			oPrint:Say  (nRow2+1589,350 ,"CNPJ: " + TRANSFORM(aDatSacado[7],"@R 99.999.999/9999-99"),oFont10) // CGC
		Else
			oPrint:Say  (nRow2+1589,350 ,"CPF: " + TRANSFORM(aDatSacado[7],"@R 999.999.999-99"),oFont10) 	// CPF
		EndIf

		oPrint:Say  (nRow2+1605,100 ,"Pagador/Avalista",oFont8)
		oPrint:Say  (nRow2+1645,1500,"Autenticacao Mecanica",oFont8)

		oPrint:Line (nRow2+0680,1800,nRow2+1370,1800 )
		oPrint:Line (nRow2+1090,1800,nRow2+1090,2300 )
		oPrint:Line (nRow2+1160,1800,nRow2+1160,2300 )
		oPrint:Line (nRow2+1230,1800,nRow2+1230,2300 )
		oPrint:Line (nRow2+1300,1800,nRow2+1300,2300 )
		oPrint:Line (nRow2+1370,100 ,nRow2+1370,2300 )
		oPrint:Line (nRow2+1610,100 ,nRow2+1610,2300 )

		/******************/
		/* TERCEIRA PARTE */
		/******************/

		nRow3 := 20

		For nI := 100 to 2300 step 50
			oPrint:Line(nRow3+1850, nI, nRow3+1850, nI+30)
		Next nI

		oPrint:Line (nRow3+1970,100,nRow3+1970,2300)
		oPrint:Line (nRow3+1970,500,nRow3+1890, 500)
		oPrint:Line (nRow3+1970,710,nRow3+1890, 710)
		oPrint:SayBitmap(nRow3+1870,100,"BOL033.JPG",0350,0090)

		oPrint:Say  (nRow3+1925,510,aDadosBanco[1]+"-7",oFont20 )	// 	[1]Numero do Banco

		oPrint:Say  (nRow3+1934,755,aCB_RN_NN[2],oFont15)  	//	Linha Digitavel do Codigo de Barras

		oPrint:Line (nRow3+2070,100,nRow3+2070,2300 )
		oPrint:Line (nRow3+2170,100,nRow3+2170,2300 )
		oPrint:Line (nRow3+2240,100,nRow3+2240,2300 )
		oPrint:Line (nRow3+2310,100,nRow3+2310,2300 )

		oPrint:Line (nRow3+2170,500 ,nRow3+2310,500 )
		oPrint:Line (nRow3+2240,770 ,nRow3+2310,770 )
		oPrint:Line (nRow3+2170,1000,nRow3+2310,1000)
		oPrint:Line (nRow3+2170,1300,nRow3+2240,1300)
		oPrint:Line (nRow3+2170,1480,nRow3+2310,1480)

		oPrint:Say  (nRow3+2000,100 ,"Local de Pagamento",oFont8)
		oPrint:Say  (nRow3+2040,100 ,"Pagável Preferencialmente no Santander.",oFont10)

		oPrint:Say  (nRow3+2055,400 ," ",oFont10)

		oPrint:Say  (nRow3+2000,1810,"Vencimento",oFont8)
		cString := StrZero(Day(aDadosTit[4]),2) +"/"+ StrZero(Month(aDadosTit[4]),2) +"/"+ Right(Str(Year(aDadosTit[4])),4)
		nCol	 	 := 1810+(374-(len(cString)*22))
		oPrint:Say  (nRow3+2040,nCol,cString,oFont11c)

		oPrint:Say  (nRow3+2100,100 ,"Beneficiário",oFont8)
		oPrint:Say  (nRow3+2140,100 ,AllTrim(aDadosEmp[1]) + " - "+aDadosEmp[2]	,oFont10) //Nome + CNPJ

		oPrint:Say  (nRow3+2100,1810,"Agência/Código Beneficiário",oFont8)
		//cString := Alltrim(AllTrim(aDadosBanco[3]) + " / " + aDadosBanco[4] + "-" + aDadosBanco[5])
		cString := Alltrim(AllTrim(aDadosBanco[3]) + " / " + _cConvenio )
		nCol 	 := 1810+(374-(len(cString)*22))
		oPrint:Say  (nRow3+2140,nCol,cString ,oFont11c)

		oPrint:Say  (nRow3+2200,100 ,"Data do Documento",oFont8)
		oPrint:Say (nRow3+2230,100, StrZero(Day(aDadosTit[2]),2) +"/"+ StrZero(Month(aDadosTit[2]),2) +"/"+ Right(Str(Year(aDadosTit[2])),4), oFont10)

		oPrint:Say  (nRow3+2200,505 ,"Nro.Documento",oFont8)
		oPrint:Say  (nRow3+2230,605 ,aDadosTit[7]+aDadosTit[1],oFont10) //Prefixo +Numero+Parcela

		oPrint:Say  (nRow3+2200,1005,"Espécie Doc.",oFont8)
		oPrint:Say  (nRow3+2230,1050,"DM",oFont10) 		  //Tipo do Titulo

		oPrint:Say  (nRow3+2200,1305,"Aceite",oFont8)
		oPrint:Say  (nRow3+2230,1400,"N"     ,oFont10)

		oPrint:Say  (nRow3+2200,1485,"Data do Processamento",oFont8)
		oPrint:Say  (nRow3+2230,1550,StrZero(Day(aDadosTit[3]),2) +"/"+ StrZero(Month(aDadosTit[3]),2) +"/"+ Right(Str(Year(aDadosTit[3])),4)                               ,oFont10) // Data impressao

		oPrint:Say  (nRow3+2200,1810,"Nosso Número",oFont8)
		nCol 	 := 1810+(374-(len(cString)*22))
		oPrint:Say  (nRow3+2230,nCol,Transform(cNosNum,"@R 9999999-9"),oFont11c)

		oPrint:Say  (nRow3+2270,100 ,"Uso do Banco",oFont8)

		oPrint:Say  (nRow3+2270,505 ,"Carteira"	,oFont8)
		oPrint:Say  (nRow3+2300,500 ,aDadosBanco[6],oFont9)

		oPrint:Say  (nRow3+2270,775 ,"Espécie"	,oFont8)
		oPrint:Say  (nRow3+2300,805 ,"REAL"     ,oFont10)
		oPrint:Say  (nRow3+2270,1005,"Quantidade",oFont8)
		oPrint:Say  (nRow3+2270,1485,"Valor"     ,oFont8)

		oPrint:Say  (nRow3+2270,1810,"Valor do Documento",oFont8)
		cString := Alltrim(Transform(aDadosTit[5],"@E 99,999,999.99"))
		nCol 	 := 1810+(374-(len(cString)*22))
		oPrint:Say  (nRow3+2300,nCol,cString,oFont11c)

		oPrint:Say  (nRow3+2340,100 ,"Instruções (Todas informações deste bloqueto são de exclusiva responsabilidade do beneficiário)",oFont8)

		oPrint:Say  (nRow3+2390,100 ,aBolText[6] ,oFont10)
		oPrint:Say  (nRow3+2440,100 ,aBolText[1]+" "+AllTrim(Transform( ((aDadosTit[5] * SE1->E1_PORCJUR ) / 100) ,"@E 999,999.99")+""+aBolText[2])  ,oFont10) // Juros de Mora de R$ xxxx ao Dia

		If SEE->EE_XMULTA > 0
			oPrint:Say  (nRow3+2490,100 ,aBolText[3]+" " + AllTrim(Transform(((aDadosTit[5] * SEE->EE_XMULTA) / 100),"@E 999,999.99"))+"",oFont10)  //  Apos venciamento multa de R$ xxxxx
		EndIf

		oPrint:Say  (nRow3+2540,100 ,aBolText[4] ,oFont10)
		oPrint:Say  (nRow3+2590,100 ,aBolText[5] ,oFont10)
		oPrint:Say  (nRow3+2640,100 ,aBolText[7] ,oFont10)

		oPrint:Say  (nRow3+2340,1810,"(-)Desconto/Abatimento",oFont8)
		oPrint:Say  (nRow3+2410,1810,"(-)Outras Deduções"    ,oFont8)
		oPrint:Say  (nRow3+2480,1810,"(+)Mora/Multa"         ,oFont8)
		oPrint:Say  (nRow3+2550,1810,"(+)Outros Acréscimos"  ,oFont8)
		oPrint:Say  (nRow3+2620,1810,"(=)Valor Cobrado"      ,oFont8)

		oPrint:Say  (nRow3+2690,100 ,"Pagador",oFont8)
		oPrint:Say  (nRow3+2700,350 ,LEFT(aDatSacado[1],45)+" ("+aDatSacado[2]+")",oFont10)

		if aDatSacado[8] = "J"
			oPrint:Say (nRow3+2700,1800,"CNPJ: "+TRANSFORM(aDatSacado[7],"@R 99.999.999/9999-99"),oFont10) // CGC
		Else
			oPrint:Say (nRow3+2700,1800,"CPF: "+TRANSFORM(aDatSacado[7],"@R 999.999.999-99"),oFont10) 		// CPF
		EndIf

		oPrint:Say  (nRow3+2753,350 ,aDatSacado[3],oFont10)
		oPrint:Say  (nRow3+2806,350 ,aDatSacado[6]+"    "+aDatSacado[4]+" - "+aDatSacado[5],oFont10) 		// CEP+Cidade+Estado

		oPrint:Say  (nRow3+2815,100 ,"Pagador/Avalista",oFont8)
		oPrint:Say  (nRow3+2855,1500,"Autenticações Mecânica - Ficha de Compensação",oFont8)

		oPrint:Line (nRow3+1970,1800,nRow3+2660,1800)
		oPrint:Line (nRow3+2380,1800,nRow3+2380,2300)
		oPrint:Line (nRow3+2450,1800,nRow3+2450,2300)
		oPrint:Line (nRow3+2520,1800,nRow3+2520,2300)
		oPrint:Line (nRow3+2590,1800,nRow3+2590,2300)
		oPrint:Line (nRow3+2660,100 ,nRow3+2660,2300)
		oPrint:Line (nRow3+2820,100 ,nRow3+2820,2300)

		//MSBAR("INT25",26.7,1.5,aCB_RN_NN[1],oPrint,.F.,Nil,Nil,0.025,1.5,Nil,Nil,"A",.F.)
		oPrint:FWMSBAR("INT25", 68, 2, aCB_RN_NN[1], oPrint, .F., Nil, .T., 0.035, 1.2, Nil, Nil, "A", .F.)

		cConta := SA6->A6_NUMCON

		DbSelectArea("SE1")
		RecLock("SE1",.f.)
		If Empty(SE1->E1_NUMBCO)
			SE1->E1_NUMBCO		:=	cNosNum //aCB_RN_NN[3] + aCB_RN_NN[4] // Nosso número (Ver fórmula para calculo) com o digito verificado
			SE1->E1_PORTADOR 	:=	'033'
			SE1->E1_AGEDEP 		:=	_cNumAge
			SE1->E1_CONTA 		:=	_cNumCta
		endif
		SE1->(MsUnlock())

		oPrint:EndPage() // Finaliza a pagina
	EndIf

	//¦+-------------------------------------------------------------+¦
	//¦¦ SICOOB                           				         ¦¦
	//¦+-------------------------------------------------------------+¦
	IF aDadosBanco[1] == "756"

		/******************/
		/* PRIMEIRA PARTE */
		/******************/
		nRow1 := 0

		oPrint:Line (nRow1+0120,500,nRow1+0040, 500)
		oPrint:Line (nRow1+0120,710,nRow1+0040, 710)
		oPrint:SayBitmap(nRow1+0020,100,"BOL756.JPG",0350,0090)

		oPrint:Say  (nRow1+0080,510,aDadosBanco[1]+"-"+Modulo11(aDadosBanco[1],"N"),oFont20 )		// [1]Numero do Banco

		oPrint:Say  (nRow1+0084,1900,"Comprovante de Entrega",oFont10)
		oPrint:Line (nRow1+0120,100,nRow1+0120,2300)

		oPrint:Say  (nRow1+0150,100 ,"Beneficiário",oFont8)
		oPrint:Say  (nRow1+0200,100 ,aDadosEmp[1],oFont8)					//Nome + CNPJ

		oPrint:Say  (nRow1+0150,1060,"Agência/Código Beneficiário",oFont8)
		oPrint:Say  (nRow1+0200,1080,Alltrim(AllTrim(aDadosBanco[3])  + "-" + SA6->A6_DVAGE + " / " + aDadosBanco[4] + "-" + SEE->EE_DVCTA)  ,oFont10)

		oPrint:Say  (nRow1+0150,1510,"Nro.Documento",oFont8)
		oPrint:Say  (nRow1+0200,1510,aDadosTit[7]+aDadosTit[1],oFont10) //Prefixo +Numero+Parcela

		oPrint:Say  (nRow1+0250,100 ,"Pagador",oFont8)
		oPrint:Say  (nRow1+0300,100 ,left(aDatSacado[1],40),oFont10)	//Nome

		oPrint:Say  (nRow1+0250,1060,"Vencimento",oFont8)
		oPrint:Say  (nRow1+0300,1060,StrZero(Day(aDadosTit[4]),2) +"/"+ StrZero(Month(aDadosTit[4]),2) +"/"+ Right(Str(Year(aDadosTit[4])),4),oFont10)

		oPrint:Say  (nRow1+0250,1510,"Valor do Documento",oFont8)
		oPrint:Say  (nRow1+0300,1550,AllTrim(Transform(aDadosTit[5],"@E 999,999,999.99")),oFont10)

		oPrint:Say  (nRow1+0400,0100,"Recebi(emos) o bloqueto/título"	,oFont10 )
		oPrint:Say  (nRow1+0450,0100,"com as caracteristicas acima."	,oFont10 )
		oPrint:Say  (nRow1+0350,1060,"Data"								,oFont8  )
		oPrint:Say  (nRow1+0350,1410,"Assinatura"						,oFont8  )
		oPrint:Say  (nRow1+0450,1060,"Data"								,oFont8  )
		oPrint:Say  (nRow1+0450,1410,"Entregador"						,oFont8  )

		oPrint:Line (nRow1+0220, 100,nRow1+0220,1900 )
		oPrint:Line (nRow1+0320, 100,nRow1+0320,1900 )
		oPrint:Line (nRow1+0420,1050,nRow1+0420,1900 )
		oPrint:Line (nRow1+0520, 100,nRow1+0520,2300 )

		oPrint:Line (nRow1+0520,1050,nRow1+0120,1050 )
		oPrint:Line (nRow1+0520,1400,nRow1+0320,1400 )
		oPrint:Line (nRow1+0320,1500,nRow1+0120,1500 )
		oPrint:Line (nRow1+0520,1900,nRow1+0120,1900 )

		oPrint:Say  ( nRow1+0165,1910,"(  )Mudou-se"					,oFont8 )
		oPrint:Say  ( nRow1+0205,1910,"(  )Ausente"						,oFont8 )
		oPrint:Say  ( nRow1+0245,1910,"(  )Não existe não indicado"		,oFont8 )
		oPrint:Say  ( nRow1+0285,1910,"(  )Recusado"					,oFont8 )
		oPrint:Say  ( nRow1+0325,1910,"(  )Não procurado"				,oFont8 )
		oPrint:Say  ( nRow1+0365,1910,"(  )Endeço insuficiente"			,oFont8 )
		oPrint:Say  ( nRow1+0405,1910,"(  )Desconhecido"				,oFont8 )
		oPrint:Say  ( nRow1+0445,1910,"(  )Falecido"					,oFont8 )
		oPrint:Say  ( nRow1+0485,1910,"(  )Outros(anotar no verso)"		,oFont8 )

		/*****************/
		/* SEGUNDA PARTE */
		/*****************/
		nRow2 := 110

		//Pontilhado separador
		For nI := 100 to 2300 step 50
			oPrint:Line(nRow2+0550, nI,nRow2+0550, nI+30)
		Next nI

		oPrint:Line (nRow2+0680,100,nRow2+0680,2300)
		oPrint:Line (nRow2+0680,500,nRow2+0600, 500)
		oPrint:Line (nRow2+0680,710,nRow2+0600, 710)

		oPrint:SayBitmap(nRow2+0580,100,"BOL756.JPG",0350,0090)

		oPrint:Say  (nRow2+0640,510,aDadosBanco[1]+"-"+Modulo11(aDadosBanco[1],"N"),oFont20 )	// [1]Numero do Banco

		oPrint:Say  (nRow2+0640,715,aCB_RN_NN[2],oFont15)  	//	Linha Digitavel do Codigo de Barras

		oPrint:Say  (nRow2+0644,2030,"Recibo do Pagador",oFont10)

		oPrint:Line (nRow2+0780,100,nRow2+0780,2300 )
		oPrint:Line (nRow2+0880,100,nRow2+0880,2300 )
		oPrint:Line (nRow2+0880,1800,nRow2+0880,2300 )

		oPrint:Line (nRow2+0950,100,nRow2+0950,2300 )
		oPrint:Line (nRow2+1020,100,nRow2+1020,2300 )
		oPrint:Line (nRow2+0880,500,nRow2+1020,500)
		//oPrint:Line (nRow2+0950,380,nRow2+1020,380) //linha CCIP
		oPrint:Line (nRow2+0950,770,nRow2+1020,770)
		oPrint:Line (nRow2+0880,1000,nRow2+1020,1000)
		oPrint:Line (nRow2+0880,1300,nRow2+0950,1300)
		oPrint:Line (nRow2+0880,1480,nRow2+1020,1480)

		oPrint:Say  (nRow2+0710,100 ,"Local de Pagamento",oFont8)
		//oPrint:Say  (nRow2+0750,100 ,"Pagável em qualquer banco até a data de vencimento.",oFont10)
		oPrint:Say  (nRow2+0750,100 ,"Pagável Preferencialmente no Sicoob.",oFont10)
		oPrint:Say  (nRow2+0765,400 ,"  ",oFont10)

		oPrint:Say  (nRow2+0710,1810,"Vencimento",oFont8)
		cString	:= StrZero(Day(aDadosTit[4]),2) +"/"+ StrZero(Month(aDadosTit[4]),2) +"/"+ Right(Str(Year(aDadosTit[4])),4)
		nCol := 1810+(374-(len(cString)*22))
		oPrint:Say  (nRow2+0750,nCol,cString,oFont11c)

		oPrint:Say  (nRow2+0810,100 ,"Beneficiário",oFont8)
		oPrint:Say  (nRow2+0840,100 ,AllTrim(aDadosEmp[1]) ,oFont8) //Nome + CNPJ   // + " - " + aDadosEmp[2]
		oPrint:Say  (nRow2+0835+35,100 ,AllTrim(aDadosEmp[2]) + " -  " + aDadosEmp[3] + " - " + AllTrim(aDadosEmp[4]) + " -  " + aDadosEmp[5] + " -  " + aDadosEmp[6],oFont8) //Endereço e Bairro, Cidade, Estado e Cep

		oPrint:Say  (nRow2+0810,1300 ,"CNPJ Beneficiário: " + Transform(aDadosEmp[8],"@R 99.999.999/9999-99") ,oFont8)

		oPrint:Say  (nRow2+0810,1810,"Agência/Código Beneficiário",oFont8)
		//cString := Alltrim(AllTrim(aDadosBanco[3])  + "-" + SA6->A6_DVAGE + " / " + aDadosBanco[4] + "-" + SEE->EE_DVCTA)
		cString := Alltrim(AllTrim(aDadosBanco[3])  + "-" + SA6->A6_DVAGE + " / " + SEE->EE_CODEMP)
		oPrint:Say  (nRow2+0850,1830,cString,oFont11c)

		oPrint:Say  (nRow2+0910,100 ,"Data de Emissao",oFont8)
		oPrint:Say  (nRow2+0940,100, StrZero(Day(aDadosTit[2]),2) +"/"+ StrZero(Month(aDadosTit[2]),2) +"/"+ Right(Str(Year(aDadosTit[2])),4),oFont10)

		oPrint:Say  (nRow2+0910,505 ,"Número do Documento",oFont8)
		oPrint:Say  (nRow2+0940,605 ,aDadosTit[7]+aDadosTit[1],oFont10) //Prefixo +Numero+Parcela

		oPrint:Say  (nRow2+0910,1005,"Espécie Documento",oFont8)
		oPrint:Say  (nRow2+0940,1050,"DM",oFont10) 		  //Tipo do Titulo aDadosTit[8

		oPrint:Say  (nRow2+0910,1305,"Aceite",oFont8)
		oPrint:Say  (nRow2+0940,1390,"N",oFont10) //COLUNA 1400

		oPrint:Say  (nRow2+0910,1485,"Data do Processamento",oFont8)
		oPrint:Say  (nRow2+0940,1550,StrZero(Day(aDadosTit[3]),2) +"/"+ StrZero(Month(aDadosTit[3]),2) +"/"+ Right(Str(Year(aDadosTit[3])),4),oFont10) // Data impressao

		oPrint:Say  (nRow2+0910,1810,"Nosso Número",oFont8)
		cString :=  Substr(Alltrim(aDadosTit[6]),15,Len(aDadosTit[6]))
		nCol := 1810+(450-(len(cString)*22))
		oPrint:Say  (nRow2+0940,nCol,cString,oFont11c)

		oPrint:Say  (nRow2+0980,100 ,"Uso do Banco",oFont8)

		//oPrint:Say  (nRow2+0980,405 ,"CIP"         ,oFont8)
		//oPrint:Say  (nRow2+1010,405 ,"000"      	,oFont10)

		oPrint:Say  (nRow2+0980,505 ,"Carteira",oFont8)
		oPrint:Say  (nRow2+1010,525 ,_cCarteira,oFont10)

		oPrint:Say  (nRow2+0980,775 ,"Espécie Moeda",oFont8)
		oPrint:Say  (nRow2+1010,805 ,"R$",oFont10)

		oPrint:Say  (nRow2+0980,1005,"Quantidade",oFont8)
		oPrint:Say  (nRow2+0980,1485,"Valor"     ,oFont8)

		oPrint:Say  (nRow2+0980,1810,"Valor do Documento",oFont8)
		cString := Alltrim(Transform(aDadosTit[5],"@E 99,999,999.99"))
		nCol := 1810+(374-(len(cString)*22))
		oPrint:Say  (nRow2+1010,nCol,cString ,oFont11c)

		oPrint:Say  (nRow2+1050,100 ,"Instruções (Todas informações deste bloqueto são de exclusiva responsabilidade do Beneficiário)",oFont8)
		oPrint:Say  (nRow2+1050,1450 ,"Bordero Nro :"+SE1->E1_NUMBOR,oFont10)

		oPrint:Say  (nRow2+1100,100 ,aBolText[6] ,oFont10)
		oPrint:Say  (nRow2+1150,100 ,aBolText[1]+" " + AllTrim(Transform(((aDadosTit[5] * SE1->E1_PORCJUR) / 100) ,"@E 999,999.99")+""+aBolText[2])  ,oFont10)

		If SEE->EE_XMULTA > 0
			oPrint:Say  (nRow2+1200,100 ,aBolText[3]+" " + AllTrim(Transform(((aDadosTit[5] * SEE->EE_XMULTA) / 100),"@E 999,999.99"))+"",oFont10)
		EndIf

		oPrint:Say  (nRow2+1250,100 ,aBolText[4] ,oFont10)
		oPrint:Say  (nRow2+1300,100 ,aBolText[5] ,oFont10)
		oPrint:Say  (nRow2+1350,100 ,aBolText[7] ,oFont10)

		oPrint:Say  (nRow2+1050,1810,"(-)Desconto",oFont8)
		oPrint:Say  (nRow2+1120,1810,"(-)Outras Deduções",oFont8)
		oPrint:Say  (nRow2+1190,1810,"(+)Mora/Multa"   ,oFont8)
		oPrint:Say  (nRow2+1260,1810,"(+)Outros Acréscimos"  ,oFont8)
		oPrint:Say  (nRow2+1330,1810,"(=)Valor Cobrado"      ,oFont8)

		oPrint:Say  (nRow2+1400,100 ,"Pagador",oFont8)
		oPrint:Say  (nRow2+1430,350 ,LEFT(aDatSacado[1],45)+" ("+aDatSacado[2]+")",oFont10)
		oPrint:Say  (nRow2+1483,350 ,aDatSacado[3],oFont10)
		oPrint:Say  (nRow2+1536,350 ,aDatSacado[6]+"    "+aDatSacado[4]+" - "+aDatSacado[5],oFont10) // CEP+Cidade+Estado

		If aDatSacado[8] = "J"
			oPrint:Say  (nRow2+1589,350 ,"CNPJ: " + TRANSFORM(aDatSacado[7],"@R 99.999.999/9999-99"),oFont10) // CGC
		Else
			oPrint:Say  (nRow2+1589,350 ,"CPF: " + TRANSFORM(aDatSacado[7],"@R 999.999.999-99"),oFont10) 	// CPF
		EndIf

		oPrint:Say  (nRow2+1589,1850,Substr(Alltrim(aCB_RN_NN[3]),1,2) + Substr(Alltrim(aCB_RN_NN[3]),3,LEN(aCB_RN_NN[3])) + "-" + aCB_RN_NN[4],oFont10)

		oPrint:Say  (nRow2+1605,100 ,"Pagador/Avalista",oFont8)
		oPrint:Say  (nRow2+1645,1500,"Autenticacao Mecanica",oFont8)

		oPrint:Line (nRow2+0680,1800,nRow2+1370,1800 )
		oPrint:Line (nRow2+1090,1800,nRow2+1090,2300 )
		oPrint:Line (nRow2+1160,1800,nRow2+1160,2300 )
		oPrint:Line (nRow2+1230,1800,nRow2+1230,2300 )
		oPrint:Line (nRow2+1300,1800,nRow2+1300,2300 )
		oPrint:Line (nRow2+1370,100 ,nRow2+1370,2300 )
		oPrint:Line (nRow2+1610,100 ,nRow2+1610,2300 )

		/******************/
		/* TERCEIRA PARTE */
		/******************/

		nRow3 := 20

		For nI := 100 to 2300 step 50
			oPrint:Line(nRow3+1850, nI, nRow3+1850, nI+30)
		Next nI

		oPrint:Line (nRow3+1970,100,nRow3+1970,2300)
		oPrint:Line (nRow3+1970,500,nRow3+1890, 500)
		oPrint:Line (nRow3+1970,710,nRow3+1890, 710)
		oPrint:SayBitmap(nRow3+1870,100,"BOL756.JPG",0350,0090)

		oPrint:Say  (nRow3+1930,510,aDadosBanco[1]+"-"+Modulo11(aDadosBanco[1],"N"),oFont20 )	// 	[1]Numero do Banco

		oPrint:Say  (nRow3+1934,715,aCB_RN_NN[2],oFont15)  	//	Linha Digitavel do Codigo de Barras

		oPrint:Line (nRow3+2070,100,nRow3+2070,2300 )
		oPrint:Line (nRow3+2170,100,nRow3+2170,2300 )
		oPrint:Line (nRow3+2240,100,nRow3+2240,2300 )
		oPrint:Line (nRow3+2310,100,nRow3+2310,2300 )

		oPrint:Line (nRow3+2170,500 ,nRow3+2310,500 )
		//oPrint:Line (nRow3+2240,380 ,nRow3+2310,380) //linha CCIP
		oPrint:Line (nRow3+2240,770 ,nRow3+2310,770 )
		oPrint:Line (nRow3+2170,1000,nRow3+2310,1000)
		oPrint:Line (nRow3+2170,1300,nRow3+2240,1300)
		oPrint:Line (nRow3+2170,1480,nRow3+2310,1480)

		oPrint:Say  (nRow3+2000,100 ,"Local de Pagamento",oFont8)
		//oPrint:Say  (nRow3+2040,100 ,"Pagável em qualquer banco até a data de vencimento.",oFont10)
		oPrint:Say  (nRow3+2040,100 ,"Pagável Preferencialmente no Sicoob.",oFont10)


		oPrint:Say  (nRow3+2000,1810,"Vencimento",oFont8)
		cString := StrZero(Day(aDadosTit[4]),2) +"/"+ StrZero(Month(aDadosTit[4]),2) +"/"+ Right(Str(Year(aDadosTit[4])),4)
		nCol	 	 := 1810+(374-(len(cString)*22))
		oPrint:Say  (nRow3+2040,nCol,cString,oFont11c)

		oPrint:Say  (nRow3+2100,100 ,"Beneficiário",oFont8)
		oPrint:Say  (nRow3+2135,100 ,AllTrim(aDadosEmp[1]) ,oFont8) //Nome + CNPJ   // + " - " + aDadosEmp[2]
		oPrint:Say  (nRow3+2135+30,100 ,AllTrim(aDadosEmp[2]) + " -  " + aDadosEmp[3] + " - " + AllTrim(aDadosEmp[4]) + " -  " + aDadosEmp[5] + " -  " + aDadosEmp[6],oFont8) //Endereço e Bairro, Cidade, Estado e Cep

		oPrint:Say  (nRow3+2100,1300 ,"CNPJ Beneficiário: " + Transform(aDadosEmp[8],"@R 99.999.999/9999-99") ,oFont8)

		oPrint:Say  (nRow3+2100,1810,"Agência/Código Beneficiário",oFont8)
		//cString := Alltrim(AllTrim(aDadosBanco[3])  + "-" + SA6->A6_DVAGE + " / " + aDadosBanco[4] + "-" + SEE->EE_DVCTA)
		cString := Alltrim(AllTrim(aDadosBanco[3])  + "-" + SA6->A6_DVAGE + " / " + SEE->EE_CODEMP)
		oPrint:Say  (nRow3+2140,1830,cString ,oFont11c)

		oPrint:Say  (nRow3+2200,100 ,"Data de Emissão",oFont8)
		oPrint:Say (nRow3+2230,100, StrZero(Day(aDadosTit[2]),2) +"/"+ StrZero(Month(aDadosTit[2]),2) +"/"+ Right(Str(Year(aDadosTit[2])),4), oFont10)

		oPrint:Say  (nRow3+2200,505 ,"Número do Documento",oFont8)
		oPrint:Say  (nRow3+2230,605 ,aDadosTit[7]+aDadosTit[1],oFont10) //Prefixo +Numero+Parcela

		oPrint:Say  (nRow3+2200,1005,"Espécie Documento",oFont8)
		oPrint:Say  (nRow3+2230,1050,"DM",oFont10) 		  //Tipo do Titulo

		oPrint:Say  (nRow3+2200,1305,"Aceite",oFont8)
		oPrint:Say  (nRow3+2230,1390,"N"     ,oFont10) //COLUNA 1400

		oPrint:Say  (nRow3+2200,1485,"Data do Processamento",oFont8)
		oPrint:Say  (nRow3+2230,1550,StrZero(Day(aDadosTit[3]),2) +"/"+ StrZero(Month(aDadosTit[3]),2) +"/"+ Right(Str(Year(aDadosTit[3])),4)                               ,oFont10) // Data impressao

		oPrint:Say  (nRow3+2200,1810,"Nosso Número",oFont8)
		cString :=  Substr(Alltrim(aDadosTit[6]),15,Len(aDadosTit[6]))
		nCol := 1810+(450-(len(cString)*22))
		oPrint:Say  (nRow3+2230,nCol,cString,oFont11c)

		oPrint:Say  (nRow3+2270,100 ,"Uso do Banco",oFont8)
		//oPrint:Say  (nRow3+2270,405 ,"CIP"                                       ,oFont8)
		//oPrint:Say  (nRow3+2300,405 ,"000"                                     	,oFont10)

		oPrint:Say  (nRow3+2270,505 ,"Carteira"	,oFont8)
		oPrint:Say  (nRow3+2300,510 ,aDadosBanco[6],oFont10)

		oPrint:Say  (nRow3+2270,775 ,"Espécie Moeda"	,oFont8)
		oPrint:Say  (nRow3+2300,805 ,"R$"     ,oFont10)

		oPrint:Say  (nRow3+2270,1005,"Quantidade",oFont8)
		oPrint:Say  (nRow3+2270,1485,"Valor"     ,oFont8)

		oPrint:Say  (nRow3+2270,1810,"Valor do Documento",oFont8)
		cString := Alltrim(Transform(aDadosTit[5],"@E 99,999,999.99"))
		nCol 	 := 1810+(374-(len(cString)*22))
		oPrint:Say  (nRow3+2300,nCol,cString,oFont11c)

		oPrint:Say  (nRow3+2340,100 ,"Instruções (Todas informações deste bloqueto são de exclusiva responsabilidade do beneficiário.)",oFont8)
		oPrint:Say  (nRow3+2340,1450 ,"Bordero Nro :"+SE1->E1_NUMBOR,oFont10)

		oPrint:Say  (nRow3+2390,100 ,aBolText[6] ,oFont10)
		oPrint:Say  (nRow3+2440,100 ,aBolText[1]+" "+AllTrim(Transform( ((aDadosTit[5] * SE1->E1_PORCJUR ) / 100) ,"@E 999,999.99")+""+aBolText[2])  ,oFont10) // Juros de Mora de R$ xxxx ao Dia

		If SEE->EE_XMULTA > 0
			oPrint:Say  (nRow3+2490,100 ,aBolText[3]+" " + AllTrim(Transform(((aDadosTit[5] * SEE->EE_XMULTA) / 100),"@E 999,999.99"))+"",oFont10)  //  Apos venciamento multa de R$ xxxxx
		EndIf

		oPrint:Say  (nRow3+2540,100 ,aBolText[4] ,oFont10)
		oPrint:Say  (nRow3+2590,100 ,aBolText[5] ,oFont10)
		oPrint:Say  (nRow3+2640,100 ,aBolText[7] ,oFont10)

		oPrint:Say  (nRow3+2340,1810,"(-)Desconto",oFont8)
		oPrint:Say  (nRow3+2410,1810,"(-)Outras Deduçõe",oFont8)
		oPrint:Say  (nRow3+2480,1810,"(+)Mora/Multa"   ,oFont8)
		oPrint:Say  (nRow3+2550,1810,"(+)Outros Acréscimos"  ,oFont8)
		oPrint:Say  (nRow3+2620,1810,"(=)Valor Cobrado"      ,oFont8)

		oPrint:Say  (nRow3+2690,100 ,"Pagador",oFont8)
		oPrint:Say  (nRow3+2700,350 ,LEFT(aDatSacado[1],45)+" ("+aDatSacado[2]+")",oFont10)

		if aDatSacado[8] = "J"
			oPrint:Say (nRow3+2700,1800,"CNPJ: "+TRANSFORM(aDatSacado[7],"@R 99.999.999/9999-99"),oFont10) // CGC
		Else
			oPrint:Say (nRow3+2700,1800,"CPF: "+TRANSFORM(aDatSacado[7],"@R 999.999.999-99"),oFont10) 		// CPF
		EndIf

		oPrint:Say  (nRow3+2753,350 ,aDatSacado[3],oFont10)
		oPrint:Say  (nRow3+2806,350 ,aDatSacado[6]+" "+aDatSacado[4]+" - "+aDatSacado[5],oFont10) 		// CEP+Cidade+Estado

		oPrint:Say  (nRow3+2815,100 ,"Pagador/Avalista",oFont8)
		oPrint:Say  (nRow3+2855,1500,"Autenticações Mecânica - Ficha de Compensação",oFont8)

		oPrint:Line (nRow3+1970,1800,nRow3+2660,1800)
		oPrint:Line (nRow3+2380,1800,nRow3+2380,2300)
		oPrint:Line (nRow3+2450,1800,nRow3+2450,2300)
		oPrint:Line (nRow3+2520,1800,nRow3+2520,2300)
		oPrint:Line (nRow3+2590,1800,nRow3+2590,2300)
		oPrint:Line (nRow3+2660,100 ,nRow3+2660,2300)
		oPrint:Line (nRow3+2820,100 ,nRow3+2820,2300)

		oPrint:Code128c(nRow3+2950,100,aCB_RN_NN[1], 40)

		cConta := SA6->A6_NUMCON

		If Empty(SE1->E1_NUMBCO)
			DbSelectArea("SE1")
			RecLock("SE1",.F.)
			SE1->E1_NUMBCO		:= StrTran(Substr(Alltrim(aDadosTit[6]),15,Len(aDadosTit[6])), "-","")
			SE1->E1_PORTADOR 	:=	'756'
			SE1->E1_AGEDEP 		:=	_cNumAge
			SE1->E1_CONTA 		:=	_cNumCta
			SE1->(MsUnlock())
		Endif

		oPrint:EndPage() // Finaliza a pagina
	EndIf

Return()

/*/{Protheus.doc} Ret_cBarra
@description Funcao que gera o codigo de barras
@type function
@version  
@author oficina5-Raphael Ferreira
@since 20/10/2021
@param cBanco, character, param_description
@param cAgencia, character, param_description
@param cConta, character, param_description
@param cDacCC, character, param_description
@param cCarteira, character, param_description
@param nValor, numeric, param_description
@param cConvenio, character, param_description
@param cFaixAtu, character, param_description
@param cDvNN, character, param_description
@return variant, return_description
/*/
Static Function Ret_cBarra( cBanco, cAgencia, cConta, cDacCC, cCarteira, nValor, cConvenio, cFaixAtu, cDvNN )
	Local cCampoL		:= ""
	Local dDtBase		:= ctod("07/10/1997")
	Local cNumBco		:= ""
	Local cDvBco		:= ""
	Local cLinDig		:= ""
	Local cCodBarSD		:= ''
	Local cDvCodBar		:= ''
	Local cDv			:= ''
	Local cCdBarras	:= ''
	Local cLBlSDv01		:= ''
	Local cLBlSDv02		:= ''
	Local cLBlCDv02		:= ''
	Local cLBlSDv03		:= ''
	Local cLBlCDv03		:= ''
	Local cLBlSDv04		:= ''
	Local cLBlSDv05		:= ''
	Local cNumDig		:= ''

	IF cBanco == "001"

		//Montando o Nosso Número
		cNumBco		:= AllTrim(SEE->EE_CODEMP) +  Iif(Empty(cFaixAtu), Soma1(StrZero(Val(AllTrim(SEE->EE_FAXATU)),10)), cFaixAtu )
		cDvBco		:= AllTrim(Modulo11(cNumBco))

		//Montando o Fator de Vencimento para composição na linha digitavel e codigo de barras
		cFatorVenc := Str(SE1->E1_VENCTO - dDtBase,4)

		//Montanso o código de Barras
		cCdBarras	:= cBanco + "9" + cFatorVenc + StrZero(nValor*100,10) + '000000' + Subs(cNumBco,1,17) + cCarteira
		cDvCb := Mod11Cb( cCdBarras )
		cCdBarras	:= cBanco + "9" + AllTrim(Str(cDvCb))  +  cFatorVenc + StrZero(nValor*100,10) + '000000' + Subs(cNumBco,1,17) + cCarteira

		//Montando a Linha Digitável
		cDv1 	:= Modulo10(cBanco + "9" + SubsTr(cCdBarras,20,5))
		cLinDig := cBanco + "9" + SubsTr(cCdBarras,20,5) + AllTrim(Str(cDv1))

		cDv2 	:= Modulo10(SubsTr(cCdBarras,25,10))

		cLinDig += SubsTr(cCdBarras,25,10) + AllTrim(Str(cDv2))

		cDv3	:= Modulo10( SubsTr(cCdBarras,35,10))
		cLinDig += SubsTr(cCdBarras,35,10) + AllTrim(Str(cDv3))

		cLinDig += AllTrim(Str(cDvCb))

		cLinDig += cFatorVenc + StrZero(nValor*100,10)
		cLinDig:=Transform(cLinDig,"@R 99999.99999 99999.999999 99999.999999 9 99999999999999")

	EndIf

	IF cBanco == "399"

		//Montando o Nosso Número
		cNumBco 	:= cConvenio + strzero(val(cFaixAtu),5)	//Nosso Numero sem Digito
		cDvBco		:= AllTrim(Modulo11(cNumBco))

		//Montando o Fator de Vencimento para composição na linha digitavel e codigo de barras
		cFatorVenc := Str(SE1->E1_VENCTO - dDtBase,4)

		//Campo Livre para o calculo do Digito final da linha digitavel e codigo de barras
		cCampoL := cNumBco + cDvBco + ALLTRIM(cAgencia) + cConta + SA6->A6_DVCTA + "00"+"1"

		//Montando os dados para o código de barras
		cDvCb1 := Mod11Cb( cBanco + "9" + cFatorVenc + StrZero(nValor*100,10) + cCampoL )
		cDvCb := ModuloDAC( cBanco + "9" + cFatorVenc + StrZero(nValor*100,10) + cCampoL )

		//Montanso o código de Barras
		cCdBarras := cBanco + "9" + cDvCb + cFatorVenc + StrZero(nValor*100,10) + cCampoL

		//Montando a Linha Digitável
		cDv1 	:= Modulo10(cBanco + "9" + SubsTr(cCdBarras,20,5))
		cLinDig := cBanco + "9" + SubsTr(cCdBarras,20,5) + AllTrim(Str(cDv1))

		cDv2 	:= Modulo10(SubsTr(cCdBarras,25,6) + SubsTr(cCdBarras,31,4))

		cLinDig += SubsTr(cCdBarras,25,6) + SubsTr(cCdBarras,31,4) + AllTrim(Str(cDv2))

		cDv3	:= Modulo10( SubsTr(cCdBarras,35,5) + SubsTr(cCdBarras,40,5))
		cLinDig += SubsTr(cCdBarras,35,5) + SubsTr(cCdBarras,40,5) + AllTrim(Str(cDv3))

		cLinDig += cDvCb

		cLinDig += cFatorVenc + StrZero(nValor*100,10)
		cLinDig	:=	Transform(cLinDig,"@R 99999.99999 99999.999999 99999.999999 9 99999999999999")
	EndIf

	IF cBanco == "104"

		//Montando o Nosso Número
		cNumBco		:= ALLTRIM(SEE->EE_CODCART) + IIF(Empty(cFaixAtu), Soma1(StrZero(Val(AllTrim(SEE->EE_FAXATU)),15)), cFaixAtu )
		cDvBco		:= AllTrim(Modulo11(cNumBco))

		//Montando o Fator de Vencimento para composição na linha digitavel e codigo de barras
		cFatorVenc :=  Strzero(SE1->E1_VENCTO - ctod("07/10/97"),4)

		//Cod da Empresa + Dv
		cConvenio := cConvenio + Alltrim(Modulo11(cConvenio))

		//Campo Livre para o calculo do Digito final da linha digitavel e codigo de barras
		cCampoL := cConvenio + Substr(cNumBco,3,3) + "1" + Substr(cNumBco,6,3) + "4" + Substr(cNumBco,9,9)  //Campo Livre 20 a 44
		cCampoL:= cCampoL + Alltrim(Modulo11(cCampoL))

		//Digito Verificador do Código de Barras
		cDvCb := Mod11Cb( cBanco + "9" + cFatorVenc + Strzero(nValor*100,10) + cCampoL )

		//Montanso o código de Barras
		cCdBarras := cBanco + "9" + AllTrim(Str(cDvCb)) + cFatorVenc + StrZero(nValor*100,10) + cCampoL

		//Montando a Linha Digitável
		cDv1 	:= Modulo10(cBanco + "9" + SubsTr(cCampoL,1,5))
		cLinDig := cBanco + "9" + SubsTr(cCampoL,1,5) + AllTrim(Str(cDv1))

		cDv2 	:= Modulo10(SubsTr(cCampoL,6,10))
		cLinDig += SubsTr(cCampoL,6,10) + AllTrim(Str(cDv2))

		cDv3	:= Modulo10( SubsTr(cCampoL,16,10) )
		cLinDig += SubsTr(cCampoL,16,10) + AllTrim(Str(cDv3))

		cLinDig += AllTrim(Str(cDvCb))

		cLinDig += cFatorVenc + StrZero( (round(nValor,2) * 100),10)
		cLinDig	:=	Transform(cLinDig,"@R 99999.99999 99999.999999 99999.999999 9 99999999999999")
	Endif

	IF cBanco == "237"
		//Montando o Nosso Número
		cNumBco		:= ALLTRIM(SEE->EE_CODCART) + IIF(Empty(cFaixAtu), Soma1(StrZero(Val(AllTrim(SEE->EE_FAXATU)),11)), cFaixAtu)
		cDvBco		:= Modulo11(cNumBco)

		//Montando o Fator de Vencimento para composição na linha digitavel e codigo de barras
		cFatorVenc := Strzero(SE1->E1_VENCTO - ctod("07/10/97"),4)

		//Campo Livre para o calculo do Digito final da linha digitavel e codigo de barras
		cCampoL := Alltrim(cAgencia) + cNumBco + cConta + "0"

		//Digito Verificador do Código de Barras
		cDvCb := Mod11Cb( cBanco + "9" + cFatorVenc + Strzero(nValor*100,10) + cCampoL )

		//Montanso o código de Barras
		cCdBarras := cBanco + "9" + AllTrim(Str(cDvCb)) + cFatorVenc + StrZero(nValor*100,10) + cCampoL

		//Montando a Linha Digitável
		cDv1 	:= Modulo10(cBanco + "9" + SubsTr(cCampoL,1,5))
		cLinDig := cBanco + "9" + SubsTr(cCampoL,1,5) + AllTrim(Str(cDv1))

		cDv2 	:= Modulo10(SubsTr(cCampoL,6,10))
		cLinDig += SubsTr(cCampoL,6,10) + AllTrim(Str(cDv2))

		cDv3	:= Modulo10( SubsTr(cCampoL,16,10) )
		cLinDig += SubsTr(cCampoL,16,10) + AllTrim(Str(cDv3))

		//codigo verificador do codigo de barras
		cLinDig += AllTrim(Str(cDvCb))

		cLinDig += cFatorVenc + StrZero( (round(nValor,2) * 100),10)
		cLinDig	:=	Transform(cLinDig,"@R 99999.99999 99999.999999 99999.999999 9 99999999999999")

	Endif

	IF cBanco == "341"

		//Montando o Nosso Número
		cNumBco		:= cFaixAtu
		cDvBco		:= modulo10(Alltrim(cAgencia)+cConta+cCarteira+cFaixAtu)  //Digito verificador no Nosso Numero modulo 10

		//Montando o Fator de Vencimento para composição na linha digitavel e codigo de barras
		cFatorVenc := Strzero(SE1->E1_VENCTO - ctod("07/10/97"),4)

		//Campo Livre para o calculo do Digito final da linha digitavel e codigo de barras
		cCampoL := cCarteira + cValToChar(cFaixAtu) + cValToChar(cDvBco) + Alltrim(cAgencia) + cConta + cDacCC + "000"

		cDvBco := cValToChar(cDvBco)

		//Digito Verificador do Código de Barras
		cDvCb := Mod11Cb( cBanco + "9" + cFatorVenc + Strzero(nValor*100,10) + cCampoL )

		//Montanso o código de Barras
		cCdBarras := cBanco + "9" + AllTrim(Str(cDvCb)) + cFatorVenc + StrZero(nValor*100,10) + cCampoL

		//Montando a Linha Digitável
		cDv1 	:= Modulo10(cBanco + "9" + SubsTr(cCampoL,1,5))
		cLinDig := cBanco + "9" + SubsTr(cCampoL,1,5) + AllTrim(Str(cDv1))

		cDv2 	:= Modulo10(SubsTr(cCampoL,6,10))
		cLinDig += SubsTr(cCampoL,6,10) + AllTrim(Str(cDv2))

		cDv3	:= Modulo10( SubsTr(cCampoL,16,10) )
		cLinDig += SubsTr(cCampoL,16,10) + AllTrim(Str(cDv3))

		//codigo verificador do codigo de barras
		cLinDig += AllTrim(Str(cDvCb))

		cLinDig += cFatorVenc + StrZero( (round(nValor,2) * 100),10)
		cLinDig	:=	Transform(cLinDig,"@R 99999.99999 99999.999999 99999.999999 9 99999999999999")

	Endif

	IF cBanco == "033"

		//Montando o Nosso Número
		If Len(cFaixAtu) < 12

			cNumBco	:= StrZero(Val( Alltrim(cFaixAtu)),13)
			cNumDig := cNumBco

		Else

			cNumBco	:= cFaixAtu
			cDvBco	:= cValToChar( Mod11aST( cNumBco ) ) //modulo10(Alltrim(cAgencia)+cConta+cCarteira+cFaixAtu)  //Digito verificador no Nosso Numero modulo 10
			cNumDig := cNumBco + cDvBco

		EndIf

		//Montando o Fator de Vencimento para composição na linha digitavel e codigo de barras
		cFatorVenc := Strzero(SE1->E1_VENCTO - ctod("07/10/97"),4)

		//Composicao do Ccdigo de barras sem o DV
		//No BCO + Cod Moeda + Fat Vencto + Valor + Fixo 9 + Cod Cedente +  Nosso Numero + IOP = 0 + Tp Mod Carteira
		cCodBarSD := cBanco + '9' + cFatorVenc + Strzero(nValor*100,10) + '9' + substr(cConvenio,1,7)+  cNumDig + '0' + cCarteira

		//Calculo do Dv do Codigo de barras
		//Seguir o modelo 11 do leiaute do banco Santander
		cDvCodBar := Modulo11b(cCodBarSD)

		//Transformar o valor recebido em string
		cDv := cvaltochar(cDvCodBar)

		//Composicao do codigo de barras completo
		//           No BCO + Cod Moeda + Dv Cod Barras + Fat Vencto + Valor + Fixo 9 + Cod Cedente + Nosso Numero + IOP = 0 + Tp Mod Carteira
		cCdBarras := cBanco + '9' + cDv + cFatorVenc + Strzero(nValor*100,10) + '9' + substr(cConvenio,1,7) + cNumDig + '0' + cCarteira

		//Linha digitavel
		//Primeiro Grupo
		cLBlSDv01 := cBanco + '99' + "." + SubStr(cConvenio,1,4) + AllTrim(cvaltochar(Mod10St(cBanco+'99'+SubStr(cConvenio,1,4))))	//Bloco 01 com o digito

		cLBlSDv02 := SubStr(cConvenio,5,3) + Substr(cNumDig,1,7)																	//Bloco 02 sem o digito
		cLBlCDv02 := SubStr(cLBlSDv02,1,5) + '.' + SubStr(cLBlSDv02,6,Len(cLBlSDv02)) + AllTrim(cvaltochar(Mod10St(cLBlSDv02)))//Bloco 02 com o digito

		cLBlSDv03 := Substr(cNumDig,8,Len(cNumDig)) + '0' + cCarteira				//Bloco 03 sem o digito
		cLBlCDv03 := SubStr(cLBlSDv03,1,5) + '.' + SubStr(cLBlSDv03,6,Len(cLBlSDv03)) + AllTrim(cvaltochar(Mod10St(cLBlSDv03)))		//Bloco 03 com o digito

		cLBlSDv04 := cDv 														//Bloco 04 com o digito

		cLBlSDv05 := cFatorVenc +  Strzero(nValor*100,10)						//Bloco 05 com o digito

		//Compposicao da linha digitavel
		//Exemplo: 99999.99999 99999.999999 99999.999999 9 99999999999999
		cLindig := cLBlSDv01 + Space(1) + cLBlCDv02 + Space(1) + cLBlCDv03 + Space(1) + cLBlSDv04 + Space(1) + cLBlSDv05
	EndIf

	//¦+---------------------------------------------------------+¦
	//¦¦SICOOB
	//¦+---------------------------------------------------------+¦
	IF cBanco == "756"

		//Montando o Nosso Número
		//Numero Cooperativa 04 + cod.cliente 10 + nosso numero 07 (iniciado em 1) - Constante para Calculo 3197
		cNumBco		:= ALLTRIM(SEE->EE_AGENCIA) + StrZero(Val(Alltrim(SEE->EE_CODEMP)),10) + cFaixAtu
		cDvBco		:= Modulo11(cNumBco,"N")

		//Montando o Fator de Vencimento para composição na linha digitavel e codigo de barras
		cFatorVenc := AllTrim(Str(1000 + (SE1->E1_VENCTO - CToD("03/07/2000"))))

		cParcela 	:= IIF(Empty(SE1->E1_PARCELA),"001",StrZero(Val(SE1->E1_PARCELA),3))
		cModalidade	:= "0"+AllTrim(SEE->EE_CODCART)

		// Campo Livre -> Carteira Cobrança 01 + Cod.Agencia/Cooperativa 04 + Modalidade 02 +
		// Cod. Associativo/cliente 07 + Nosso Numero Bol 08 + Num Parcela (Unica = 0001) 03
		// 25 Digitos
		cCampoL := cValToChar(Val(SEE->EE_CODCART)) + Alltrim(cAgencia) + cModalidade + StrZero(Val(SEE->EE_CODEMP),7) + cFaixAtu +cDvBco  + cParcela

		//Digito Verificador do Código de Barras
		cDvCb 	:= Mod11Cb( cBanco + "9" + cFatorVenc + Strzero(nValor*100,10) + cCampoL )

		//Montando o código de Barras
		cCdBarras := cBanco + "9" + AllTrim(Str(cDvCb)) + cFatorVenc + StrZero(nValor*100,10) + cCampoL

		//Montando a Linha Digitável
		cDv1 	:= Modulo10(cBanco + "9" + SubsTr(cCampoL,1,5))
		cLinDig := cBanco + "9" + SubsTr(cCampoL,1,5) + AllTrim(Str(cDv1))

		cDv2 	:= Modulo10(SubsTr(cCampoL,6,10))
		cLinDig += SubsTr(cCampoL,6,10) + AllTrim(Str(cDv2))

		cDv3	:= Modulo10( SubsTr(cCampoL,16,10) )
		cLinDig += SubsTr(cCampoL,16,10) + AllTrim(Str(cDv3))

		//codigo verificador do codigo de barras
		cLinDig += AllTrim(Str(cDvCb))

		cLinDig += cFatorVenc + StrZero( (round(nValor,2) * 100),10)
		cLinDig	:=	Transform(cLinDig,"@R 99999.99999 99999.999999 99999.999999 9 99999999999999")

	Endif

	If !Empty(cLinDig) .AND. !Empty(cCdBarras)
		RecLock("SE1",.F.)
		SE1->E1_C_LINDG := StrTran(StrTran(cLinDig,".","")," ","")
		SE1->E1_CODDIG	:= StrTran(StrTran(cLinDig,".","")," ","")
		SE1->E1_C_CODBA	:= cCdBarras
		SE1->E1_CODBAR	:= cCdBarras
		MsUnlock()
	EndIf

Return({cCdBarras,cLinDig,cNumBco,cDvBco})

/*/{Protheus.doc} Modulo11
@description Funcao de calculo do modulo 11
@type function
@version  
@author oficina5-Raphael Ferreira
@since 20/10/2021
@param cData, character, param_description
@param cTipo, character, param_description
@return variant, return_description
/*/
Static Function Modulo11(cData,cTipo)

	Local nResto	:= 0
	Local L := Len(cdata)
	Local D := 0
	Local P := 1

	//¦+------------------------+¦
	//¦¦Banco Do Brasil         ¦¦
	//¦+------------------------+¦
	If SEE->EE_CODIGO=="001"
		L := Len(cdata)
		D := 0
		P := 1
		While L > 0
			P := P + 1
			D := D + (Val(SubStr(cData, L, 1)) * P)
			If P = 9
				P := 1
			End
			L := L - 1
		End
		D := 11 - (mod(D,11))
		If (D == 10 .Or. D == 11 .Or. D == 0)
			D := 1
		Endif
		D := AllTrim(Str(D))
	Endif

	//¦+------------+¦
	//¦¦HSBC        ¦¦
	//¦+------------+¦
	If SEE->EE_CODIGO=="399"
		L := Len(cdata)
		D := 0
		P := 1
		While L > 0
			P := P + 1
			D := D + (Val(SubStr(cData, L, 1)) * P)
			If P = 7
				P := 1
			End
			L := L - 1
		End
		nResto:=(mod(D,11))

		If nResto==0 .OR. nResto==1
			D:=0
		Else
			D:=(11-nResto)
		Endif

		D := ALLTRIM(Str(D))
	Endif

	//¦+------------+¦
	//¦¦CEF         ¦¦
	//¦+------------+¦
	If SEE->EE_CODIGO=="104"
		L := Len(cdata)
		D := 0
		P := 1

		While L > 0
			P := P + 1
			D := D + (Val(SubStr(cData, L, 1)) * P)
			If P = 9
				P := 1
			EndIf
			L := L - 1
		End

		D := 11 - (mod(D,11))
		//If (D == 0 .OR. D > 9)
		If (D > 9)
			D := 0
		End

		D := AllTrim(Str(D))
	Endif

	//¦+------------+¦
	//¦¦BRADESCO    ¦¦
	//¦+------------+¦
	If SEE->EE_CODIGO == "237"
		L := Len(cdata)
		D := 0
		P := 1
		DV:= " "

		While L > 0
			P := P + 1
			D := D + (Val(SubStr(cData, L, 1)) * P)
			If P == 7
				P := 1
			End
			L := L - 1
		End

		D := 11 - (mod(D,11))

		If D == 10
			D := "P"
		ElseIf D == 11
			D := "0"
		Endif

		D := AllTrim(cValToChar(D))
	Endif

	//¦+------------+¦
	//¦¦ITAÚ        ¦¦
	//¦+------------+¦
	If SEE->EE_CODIGO == "341"
		L := Len(cdata)
		D := 0
		P := 1
		DV:= " "

		While L > 0
			P := P + 1
			D := D + (Val(SubStr(cData, L, 1)) * P)
			If P == 7
				P := 1
			End
			L := L - 1
		End

		D := 11 - (mod(D,11))

		If (D == 0 .or. D == 1)
			DV := "1"
		End

		D := AllTrim(cValToChar(D))
	Endif

	//¦+------------+¦
	//¦¦SICOOB      ¦¦
	//¦+------------+¦
	If SEE->EE_CODIGO == "756"
		D := 0
		IF cTipo == "N"
			D := 0
			P := 0
			aConst	:= {3,1,9,7}
			FOR L := 1 TO Len(cdata)
				P := P + 1
				D := D + (Val(SubStr(cData, L, 1)) * aConst[P])
				If P = 4
					P := 0
				End
			NEXT
			nResto	:= mod(D,11)

			if nResto == 0 .OR. nResto == 1
				D	:= 0
			ELSE
				D := 11 - nResto //(mod(D,11))
			ENDIF

			D := AllTrim(cValToChar(D))

		ELSEIF cTipo == "C"
			L := Len(cdata)
			D := 0
			P := 1
			While L > 0
				P := P + 1
				D := D + (Val(SubStr(cData, L, 1)) * P)
				If P = 9
					P := 1
				End
				L := L - 1
			End

			D := 11 - (mod(D,11))

			If (D == 0 .Or. D == 1 .Or. D == 10 .Or. D == 11)
				D := 1
			End

			D := AllTrim(cValToChar(D))

		EndIf

	Endif

Return(D)

/*/{Protheus.doc} Mod11CB
@description Funcao do modulo 11 do codigo de barras
@type function
@version  
@author oficina5-Raphael Ferreira
@since 20/10/2021
@param cData, character, param_description
@return variant, return_description
/*/
Static Function Mod11CB(cData) // Modulo 11 com base 9

	Local CBL, CBD, CBP := 0

	CBL := Len(cdata)
	CBD := 0
	CBP := 1

	While CBL > 0
		CBP := CBP + 1
		CBD := CBD + (Val(SubStr(cData, CBL, 1)) * CBP)
		If CBP = 9
			CBP := 1
		End
		CBL := CBL - 1
	End

	_nCBResto := mod(CBD,11)  //Resto da Divisao
	CBD := 11 - _nCBResto

	If (CBD == 0 .Or. CBD == 1 .Or. CBD > 9)
		CBD := 1
	End

Return(CBD)

/*/{Protheus.doc} Modulo10
@description Funcao de calculo do modulo 10
@type function
@version  
@author oficina5-Raphael Ferreira
@since 20/10/2021
@param cData, character, param_description
@return variant, return_description
/*/
Static Function Modulo10(cData)
	LOCAL L, D, P, nInt := 0

	L := Len(cdata)
	D := 0
	P := 2
	N := 0

	While L > 0
		N := (Val(SubStr(cData, L, 1)) * P)
		If N > 9
			D := D + (Val(SubsTr(Str(N,2),1,1)) + Val(SubsTr(Str(N,2),2,1)))
		Else
			D := D + N
		Endif
		If P = 2
			P := 1
		Elseif P = 1
			P := 2
		EndIf
		L := L - 1
	End
	nInt := (Int((D / 10)) + 1) * 10
	D:= nInt - D

	If D == 10
		D:=0
	Endif

Return(D)

/*/{Protheus.doc} ModuloDAC
@description
@type function
@version  
@author oficina5-Raphael Ferreira
@since 20/10/2021
@param cData, character, param_description
@return variant, return_description
/*/
Static Function ModuloDAC(cData)

	Local	L := Len(cdata)
	Local	D := 0
	Local	P := 1

	While L > 0
		P := P + 1
		D := D + (Val(SubStr(cData, L, 1)) * P)
		If P = 9
			P := 1
		End
		L := L - 1
	End

	D := 11 - (mod(D,11))

	D := ALLTRIM(Str(D))

Return(D)

/*/{Protheus.doc} ENVIAEMAIL
@description Funcao de envio de e-mail
@type function
@version  
@author oficina5-Raphael Ferreira
@since 20/10/2021
@param _cChave, variant, param_description
@param _cNomeCli, variant, param_description
@param _cMail, variant, param_description
@return variant, return_description
/*/
Static Function ENVIAEMAIL(_cChave,_cNomeCli,_cMail)

	Local lOk			:= .T.
	Local cTitulo 		:= "Olá! O seu Boleto Bancario - " + Substr(_cChave,At("-N",_cChave) + 2,9) + " - " + Substr(SM0->M0_NOMECOM,1,At(CHR(32),SM0->M0_NOMECOM)-1) +"  - "+ _cNomeCli+" - Vence em "+Substr(_cChave,At("-V",_cChave) + 2,2)+" dia(s)"
	Local cPara			:= _cMail
	Local cMsgZap		:= "Aviso de Vencimento do Boleto" +CRLF+CRLF+"Olá, "+_cNomeCli+","+ CRLF+CRLF+"Gostaríamos de informá-lo que o seu boleto de número: *" + Substr(_cChave,At("-N",_cChave) + 2,9) + "*, está disponível para pagamento e vence em *"+Substr(_cChave,At("-V",_cChave) + 2,4)+" dia(s)*."+ CRLF+CRLF+"Por favor, confira o documento anexo e, se necessário, entre em contato conosco para qualquer dúvida."+ CRLF+CRLF+"Agradecemos pela sua atenção."+ CRLF+CRLF+"Atenciosamente, " + CRLF+ Alltrim(SM0->M0_NOMECOM) //Ver melhor forma para ajustar o nome para "Grupo Ercal"
	Local cCopia		:= Alltrim(MV_PAR18)
	Local cMensagem     := ""
	Local cAttachment 	:= ""// "\SPOOL\"+ALLTRIM(cFilePrintert)+".PDF"	//GetTempPath() + ALLTRIM(cFilePrintert)+".PDF"
	Local cArquivo		:= GetTempPath() + ALLTRIM(cFilePrintert)+".PDF"
	Local cEndWf	    := AllTrim( 'http://'+ GetMV( "MV_WFWS" ,, "189.112.1.248:8099" ) )

	If File(cArquivo)
		If !CPYT2S(cArquivo,"\spool\",.F.)
			lOk	:= .F.
		Else
			cAttachment	:= "\spool\" + ALLTRIM(cFilePrintert)+".PDF"
		EndIf
	EndIf
	
	//U_MSGZAP('5534999819351' ,cMsgZap ,cArquivo)
	
	If lOk

		cMensagem := '<html xmlns="http://www.w3.org/1999/xhtml">'
		cMensagem += '<head>'
		cMensagem += '	<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />'
		cMensagem += '	<title>BOLETO - Grupo Ercal</title>'
		cMensagem += '</head>'
		cMensagem += '<body>'
		cMensagem += '<table width="760" bgcolor="#FFFFFF" cellpadding="0" cellspacing="0" >'
		cMensagem += '<h2><strong>ATEN&Ccedil;&Atilde;O PARA EVITAR FRAUDES EM BOLETOS DE PAGAMENTO DO GRUPO ERCAL</strong></h2>'
		cMensagem += '<p><strong>Prezado Cliente,</strong></p>'
		cMensagem += '<p>Segue em anexo o boleto banc&aacute;rio para pagamento referente ao t&iacute;tulo,&nbsp; <strong>'+ Substr(_cChave,At("-N",_cChave) + 2,9) +', </strong>emitido em <strong>'+ dToc(SE1->E1_EMISSAO) +'</strong>, no valor de <strong>'+Padl("R$"+transform(SE1->E1_VALOR,"@E 999,999,999.99"),16)+'</strong>, com vencimento para o&nbsp;dia <strong>'+ dToc(SE1->E1_VENCTO) +'</strong>.</p>'
		cMensagem += '<p>Com o objetivo de evitar fraudes no pagamento dos boletos dos clientes do <strong>GRUPO ERCAL</strong>, solicitamos sua aten&ccedil;&atilde;o para alguns procedimentos muito importantes.</p>'
		cMensagem += '<ol>'
		cMensagem += '	<li><strong>Todos </strong>os nossos boletos s&atilde;o gerados pelo <strong>Banco Santander</strong>. Assim, <strong>antes</strong> do pagamento, atente-se ao banco e benefici&aacute;rio: <strong>'+SM0->M0_NOMECOM+';</strong></li>'
		cMensagem += '	<li>Como mais uma medida de seguran&ccedil;a, o <strong>GRUPO ERCAL</strong> adotou tamb&eacute;m a criptografia nas mensagens, outra ferramenta para proteger dados contra roubos, altera&ccedil;&otilde;es&nbsp;ou comprometimento no seu conte&uacute;do, exigindo que o cliente efetue o desbloqueio do boleto <strong>antes</strong> do pagamento.</li>'
		cMensagem += '</ol>'
		cMensagem += '<p>&nbsp;</p>'
		cMensagem += '<p style="text-align:center"><img alt="" height="200" src="'+ cEndWf +'/swboleto.png" width="600" /></p>'
		cMensagem += '<p>Para esclarecimentos ou d&uacute;vidas adicionais, favor fazer contato conosco pelo telefone:&nbsp;<a href="https://www.google.com/search?q=grupo+ercal&amp;oq=grupo+ercal&amp;gs_lcrp=EgZjaHJvbWUqCggAEAAY4wIYgAQyCggAEAAY4wIYgAQyEAgBEC4YrwEYxwEYgAQYjgUyBwgCEAAYgAQyBggDEEUYPDIGCAQQRRg8MgYIBRBFGDzSAQgxNTY2ajBqNKgCALACAA&amp;sourceid=chrome&amp;ie=UTF-8">(34) 3230-3300</a> ou pelo e-mail: <a href="mailto:Kelly.nascimento@ercal.com.br">Kelly.nascimento@ercal.com.br</a></p>'
		cMensagem += '<p>&nbsp;</p>'
		cMensagem += '<p style="text-align: center;"><strong>GRUPO ERCAL: Construindo um pa&iacute;s mais forte em parceria com quem produz!</strong></p>'
		cMensagem += '<p style="text-align: center;"><br />'
		cMensagem += '________________________________________________________________<br />'
		cMensagem += 'Obs: Esta &eacute; uma mensagem autom&aacute;tica. Por favor, n&atilde;o responda a este e-mail.</p>'
		cMensagem += '<table cellpadding="0" cellspacing="0" style="width:760px">'
		cMensagem += '</table>'
		cMensagem += '</table>'
		cMensagem += '</body>'
		cMensagem += '</html>'
		MemoWrite("C:\TEMP\boletoHTM.txt",cMensagem)

		//sendMail(cPara,cCopia,,cTitulo,cMensagem,cAttachment,,)

		If FERASE(cAttachment) == -1
			Conout('Falha na deleção do Arquivo' + cAttachment)
		Else
			Conout('Arquivo Enviado via e-mail e deletado com sucesso.' + cAttachment)
		Endif
	EndIf

Return()

/*/{Protheus.doc} ValidPerg
@description Funcao de criacao de perguntas na SX1
@type function
@version  
@author oficina5-Raphael Ferreira
@since 20/10/2021
@return variant, return_description
/*/
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
	aAdd(aRegs,{cPerg,"15","E-mail/Impressao ?","","","mv_chi","C",01,0,0,"C","","MV_PAR15","Impresso","","","","","E-mail","","","","","","","","","","","","","","","","","","","","","","","",""})
	aAdd(aRegs,{cPerg,"16","Do Bordero     ?","","","mv_chk","C",06,0,0,"G","","MV_PAR16","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	aAdd(aRegs,{cPerg,"17","Ate Bordero    ?","","","mv_chl","C",06,0,0,"G","","MV_PAR17","","","","ZZZZZZ","","","","","","","","","","","","","","","","","","","","","","","","",""})
	aAdd(aRegs,{cPerg,"18","Email Copia    ?","","","mv_chm","C",60,0,0,"G","","MV_PAR18","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})

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

/*/{Protheus.doc} Mod11aSt
@description Funcao de calculo do digito verificador Nosso Numero
@type function
@version  
@author oficina5-Raphael Ferreira
@since 20/10/2021
@param cCodBarSD, character, param_description
@return variant, return_description
/*/
Static  Function Mod11aSt(cCodBarSD)
	/*----------------------------------------------------------------------------------------------------------------
	Módulo 11 - Multiplicar da direita para a esquerda, aplicando o peso de 2 até 9, até o final do número,
	reiniciando em 2 se necessário. Somar os resultados obtidos e dividi-lo por 11 (onze).
	Se o resto desta divisão for igual a 10(dez) o dígito será = 1 (um), se for igual a 0 (zero) ou  1 (um)  o digito será 0 (zero).
	Qualquer “Resto” diferente de “0,1 ou 10” subtrair o resto de 11 para obter o dígito.
	------------------------------------------------------------------------------------------------------------------*/
	Local nPeso1 	:= 2
	Local nPeso2 	:= 9
	Local nTot 		:= 0
	Local nMul 		:= nPeso1
	Local i         := 0
	Local nResult	:= 0
	Local cRet		:= ''

	//Executa o calculo dos valores recebidos para compor o digito
	For i := Len(cCodBarSD) to 1 step -1
		nTot += Val(SubStr(cCodBarSD,i,1)) * nMul
		nMul := if(nMul=nPeso2, nPeso1, nMul+1)
	Next

	//Modulo do resultado
	_nResto := Mod(nTot,11)
	nResult :=  _nResto

	//Testa se o resto esta entre 0,1 ou 10
	If(nResult == 10)
		cRet := '1'
	ElseIf (nResult == 1 .Or. nResult == 0)
		cRet := '0'
	Else
		nResult := nResult-11
		cRet := Str(abs(nResult),1)
	EndIf

Return(cRet)

/*/{Protheus.doc} Modulo11b
@description funcao de calculo do digito verificador do codigo de barras
@type function
@version  
@author oficina5-Raphael Ferreira
@since 20/10/2021
@param cCodBarSD, character, param_description
@return variant, return_description
/*/
Static Function Modulo11b(cCodBarSD)

	Local nPeso1 	:= 2
	Local nPeso2 	:= 9
	Local nTot 		:= 0
	Local nMul 		:= nPeso1
	Local i         := 0
	Local nResult	:= 0
	Local cRet		:= ''

	//Executa o calculo dos valores recebidos para compor o digito
	For i := Len(cCodBarSD) to 1 step -1
		nTot += Val(SubStr(cCodBarSD,i,1)) * nMul
		nMul := if(nMul=nPeso2, nPeso1, nMul+1)
	Next

	//Multiplica o resultado por 10
	nResult := (nTot*10)

	//Modulo do resultado
	nResult := Mod(nResult,11)

	//Testa se o resto esta entre 0,1 ou 10
	/*------------------------------------------------------------------
	Nota: O resto desta divisao sera o digito de controle.
	Se o resto for igual a 0, 1 ou 10 o digito sera = 1 (um).
	-------------------------------------------------------------------*/
	If(nResult == 10 .Or. nResult == 1 .Or. nResult == 0)
		cRet := '1'
	Else
		cRet := Str(nResult,1)
	EndIf

Return(cRet)

/*/ {Protheus.doc} Modulo10
Cálculo do dígito verificador da linha digitável
@author Oficina5-Raphael Ferreira
@version 1
@since 05/04/2017
@return Nil
@obs
@sample
/*/
Static Function Mod10St(cLBlSDv01)
	Local i			:= 0
	Local nMul 		:= 2
	Local nTot		:= 0
	Local nVal		:= 0
	Local nResult 	:= 0

	/*--------------------------------------------------------------------------------------------
	Módulo 10 - CÁLCULO:

	Multiplicar, da direita para a esquerda, por 2 e 1, respectivamente, ate o final do numero.
	Somar os resultados obtidos. Dividir o total desta soma por dez.
	Se o resto for = 0, o dogito sera = 0, se diferente subtrair o divisor pelo resto, ou seja,
	subtrair 10 do resto.
	Obs.: Quando o resultado da multiplicacao for > 9, efetuar a soma os dois digitos.
	Ex: 9 x 2 = 18, entao 1+ 8 = 9

	Exemplo:  033 9 9 0282

	0 3 3 9 9 0 2 8 2
	x x x x x x x x x
	2 1 2 1 2 1 2 1 2
	---------------------------------------------------------------------------------------------*/

	//Executa o calculo dos valores recebidos para compor o digito
	For i := Len(cLBlSDv01) to 1 step -1
		nVal := Val(SubStr(cLBlSDv01,i,1)) * nMul

		//Verifica se o total é > que 9, se sim somar os dois algoritimos
		If nVal > 9
			nTot += Val(LEFT (cValToChar(nVal),1))
			nTot += Val(RIGHT(cValToChar(nVal),1))
		Else //Caso contraio só somar o número
			nTot += nVal
		Endif

		//Fator multiplicador que deve ser alterado a cada calculo, 2 e 1 respectivamente
		nMul := If(nMul=2, 1, nMul+1)

	Next

	//Dividir o somatorio dos valores por 10
	nResult := (nTot%10)

	//Se o resto for 0, retornar Zero, caso contrario subtrair o divisor pelo resto
	If nResult == 0
		cRet := '0'
	Else
		cRet := Str(10 - nResult)
	Endif

Return (cRet)

/*/{Protheus.doc} sendMail
description
@type function
@version  
@author oficina5
@since 29/11/2021
@param _cTo, variant, param_description
@param _cCC, variant, param_description
@param _cBcc, variant, param_description
@param _cSubject, variant, param_description
@param _cBody, variant, param_description
@param _cAttachment, variant, param_description
@param _cNomUsr, variant, param_description
@param _cTemplate, variant, param_description
@return variant, return_description
/*/
Static Function sendMail(_cTo,_cCC,_cBcc,_cSubject,_cBody,_cAttachment,_cNomUsr,_cTemplate)

	Local oServer   := TMailManager():New()    	As Object    // CLIENTE DO SERVIDOR DE E-MAIL
	Local oMessage  := TMailMessage():New()     As Object    // CONSTRUTOR DA MENSAGEM

	Local oError 	:= Errorblock({|e| Break(e) })


	Local cServer     	:= AllTrim(GetMV("MV_RELSERV"))		As Character
	Local cAccount    	:= AllTrim(GetMv("MV_RELACNT"))		As Character
	Local cPassword   	:= AllTrim(GetMv("MV_RELPSW"))		As Character
	Local cFrom			:= AllTrim(GetMv("MV_RELFROM"))		As Character

	Local nTimeOut    	:= GetMv("MV_RELTIME",,60)		As Numeric		// Tempo de Espera antes de abortar a Conexao
	Local nPort     	:= 0        					As Numeric     // PORTA DE COMUNICAÇÃO

	Local xRet							As Variant

	Local cLog			:= ""			As Character
	Local cUser			:= ""			As Character

	Local lOk         	:= .F.			As Logical
	Local lAutentica  	:= GetMv("MV_RELAUTH")

	Private cTo				:= ""		As Character
	Private cCC				:= ""		As Character
	Private bcCC			:= ""		As Character
	Private cBody			:= ""		As Character
	Private cSubject		:= ""		As Character
	Private cAttachment		:= ""		As Character

	Default _cTo			:= ""
	Default _cCC			:= ""
	Default _cBcc			:= ""
	Default _cSubject		:= ""
	Default _cBody			:= ""
	Default _cAttachment	:= ""
	Default _cNomUsr		:= ""
	Default _cTemplate		:= ""

	cTo				:= _cTo
	cCC				:= _cCC
	bcCC			:= _cBcc
	cBody			:= _cBody
	cSubject		:= _cSubject
	cAttachment		:= _cAttachment

	If Substr(cServer,At(":",cServer)+1,Len(cServer)) == "587"
		nPort := 587 // PORTA PARA COMUNICAÇÃO DO SMTP COM TLS
		oServer:SetUseTLS(.T.)

	ElseIf Substr(cServer,At(":",cServer)+1,Len(cServer)) == "25"
		nPort := 25 // PORTA PADRÃO DE COMUNICAÇÃO DO SMTP

	ElseIf Substr(cServer,At(":",cServer)+1,Len(cServer)) == "465"
		nPort := 465 // PORTA PARA COMUNICAÇÃO DO SMTP COM SSL
		oServer:SetUseSSL(.T.)
	Endif

	If nPort == 0
		nPort := 587 // PORTA PARA COMUNICAÇÃO DO SMTP COM TLS
		oServer:SetUseTLS(.T.)
	Endif

	If At(":",cServer) > 0
		cServer := Substr(cServer,1,At(":",cServer)-1)
	Endif

	BEGIN SEQUENCE
		xRet := oServer:Init( "", cServer, cAccount, cPassword, 0, nPort)
		If (!xRet == 0)
			cLog := NoAcento("CONNECT_SENDMAIL -> Não foi possível estabelecer a conexão com o servidor: ") + oServer:GetErrorString(xRet)
			BREAK
		EndIf

		// DEFINE O TEMPO MÁXIMO DA REQUISIÇÃO
		xRet := oServer:SetSMTPTimeOut(nTimeOut)
		If (!xRet == 0)
			cLog := NoAcento("CONNECT_SENDMAIL -> Não foi possível definir o time-out de ") + CValToChar(nTimeOut) + " segundos"
			BREAK
		EndIf

		// ESTABELECE A CONEXÃO COM O SERVIDOR SMTP
		xRet := oServer:SMTPConnect()
		If (!xRet == 0)
			cLog := NoAcento("CONNECT_SENDMAIL -> Não foi possível estabelecer conexao com o servidor de SMTP: ") + oServer:GetErrorString(xRet)
			BREAK
		EndIf

		// REALIZA A AUTENTICAÇÃO NO SERVIDOR
		If lAutentica
			xRet := oServer:SMTPAuth(cAccount, cPassword)
			If (!xRet == 0)
				cUser	:= If( At( "@" , cAccount ) > 0 , Subs( cAccount , 1 , At( "@" , cAccount ) - 1 ) , cAccount )
				xRet	:= oServer:SMTPAuth(cUser, cPassword)

				If (!xRet == 0)
					cLog := NoAcento("CONNECT_SENDMAIL -> Não foi possível se autenticar no servidor de SMTP: ") + oServer:GetErrorString(xRet)
					BREAK
				Endif
			EndIf
		EndIf

		//Limpa o objeto
		oMessage:Clear()

		If _cTemplate == "SA1"
			self:oAuxCliente:Mail()
		Endif

		//Popula com os dados de envio
		oMessage:cDate    			:= CValToChar(Date())
		oMessage:cFrom              := cFrom
		oMessage:cTo                := cTo
		oMessage:cCc                := cCC
		oMessage:cBcc               := bcCC
		oMessage:cSubject           := cSubject
		oMessage:cBody              := cBody
		oMessage:MsgBodyType( "text/html" )

		If !Empty(cAttachment)
			If oMessage:AttachFile( cAttachment ) < 0
				cLog := NoAcento("SENDMAIL_CONNECT -> Erro ao atachar o arquivo" )
				BREAK
			Else
				//adiciona uma tag informando que é um attach e o nome do arq
				oMessage:AddAtthTag( 'Content-Disposition: attachment; filename=' + cAttachment)
			EndIf
		Endif

		// REALIZA O ENVIO DO E-MAIL
		xRet := oMessage:Send(oServer)
		If (!xRet == 0)
			cLog := NoAcento("CONNECT_SENDMAIL -> Não foi possível realizar o envio da mensagem: ") + oServer:GetErrorString(xRet)
			BREAK
		EndIf

		// DESCONECTA DO SERVIDOR SMTP
		xRet := oServer:SMTPDisconnect()
		If (!xRet == 0)
			cLog := NoAcento("CONNECT_SENDMAIL -> Não foi possível realizar a desconexão do servidor SMTP: ") + oServer:GetErrorString( xRet )
			BREAK
		EndIf

		RECOVER
		cONOUT( cLog)

	END SEQUENCE

	If Empty(cLog)
		lOk := .T.
	Endif

	ErrorBlock( oError )

Return(lOk)
