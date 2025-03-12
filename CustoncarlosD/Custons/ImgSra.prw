/*/
здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
Ё"PROTHEUS.CH" eh Utilizado para substituir a constante CRLF peЁ
Ёlo seu valor real e os comandos para criacao de DIALOG em suasЁ
Ёrespectivas chamadas de funcao								   Ё
юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды/*/
#INCLUDE "PROTHEUS.CH"

/*/
здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
Ё"TBICONN.CH" Traduzir os comandos PREPARE ENVIRONMENT e  RESETЁ
ЁENVIRONMENT nas respectivas chamadas de funcao 			   Ё
юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды/*/
#INCLUDE "TBICONN.CH"

/*/
здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
ЁDefine as opcoes para a cGetFile							   Ё
Ё 															   Ё
ЁObs.: As constantes do tipo GETF_???... estao definidas no  arЁ
Ё      quivo de cabecalho "PRCONST.CH"						   Ё
юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды/*/
#DEFINE _OPC_cGETFILE ( GETF_RETDIRECTORY + GETF_LOCALFLOPPY + GETF_LOCALHARD + GETF_NETWORKDRIVE + GETF_SHAREAWARE )

/*/
зддддддддддбддддддддддддддбдддддбдддддддддддддддддддддбддддддбдддддддддд©
ЁFun┤┘o    ЁU_ImgSra      ЁAutorЁMarinaldo de Jesus   Ё Data Ё13/05/2005Ё
цддддддддддеддддддддддддддадддддадддддддддддддддддддддаддддддадддддддддд╢
ЁDescri┤┘o ЁImportar as Fotos dos Funcionarios                          Ё
цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢
ЁSintaxe   Ё<vide parametros formais>									Ё
цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢
ЁParametrosЁ<vide parametros formais>									Ё
цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢
ЁUso       ЁGenerico                      								Ё
юддддддддддадддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды/*/
User Function ImgSra( cEmp , cFil )   

Local aEmpresas
Local aRecnos
Local bWindowInit
Local bDialogInit
Local cTitle
Local cEmpresa
Local lConfirm
Local nEmpresa
Local nRecEmpresa
Local oDlg
Local oFont
Local oEmpresas
/*/
здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
Ё Verifica se a Variavel Publica oMainWnd esta declarada e se oЁ
Ё seu tipo eh objeto 										   Ё
юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды/*/
Local lExecInRmt	:= ( Type( "oMainWnd" ) == "O" )

/*/
здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
ЁColoca o Ponteiro do Cursos do Mouse em estado de Espera	   Ё
юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды/*/
CursorWait()

Begin Sequence

	/*/
	здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	Ё Monta o Titulo para o Dialogo								   Ё
	юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды/*/
	cTitle := "ImportaГЦo das Fotos dos FuncionАrios"

	/*/
	здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	Ё Monta Bloco para o Init da Window							   Ё
	юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды/*/
	bWindowInit	:= { ||;
	  					Proc2BarGauge(	{ || GetSraImg( lExecInRmt ) }	,;	//Variavel do Tipo Bloco de Codigo com a Acao ser Executada
										cTitle							,;	//Variavel do Tipo Texto ( Caractere/String ) com o Titulo do Dialogo
										NIL								,;	//Variavel do Tipo Texto ( Caractere/String ) com a Mensagem para a 1a. BarGauge
										NIL								,;	//Variavel do Tipo Texto ( Caractere/String ) com a Mensagem para a 2a. BarGauge
										.F.								,;	//Variavel do Tipo Logica que habilitara o botao para "Abortar" o processo
										.T.								,;	//Variavel do Tipo Logica que definira o uso de controle de estimativa de tempo na 1a. BarGauge
										.F.								,;	//Variavel do Tipo Logica que definira o uso de controle de estimativa de tempo 2a. BarGauge
										.F.				 				 ;	//Variavel do Tipo Logica que definira se a 2a. BarGauge devera ser mostrada
  									 ),;
						MsgInfo( OemToAnsi( "ImportaГЦo Finalizada" ) , cTitle );
					}

	/*/
	здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	Ё Se a Execucao nao for a partir do Menu do SIGA 			   Ё
	юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды/*/
	IF !( lExecInRmt )

		/*/
		здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
		ЁDeclara a Variavel oMainWnd que vai ser utilizada para a   monЁ
		Ёtagem da Caixa de Dialogo ( Janela de Abertura ) do programa  Ё
		юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды/*/
		Private oMainWnd

		IF (;
				( cEmp == NIL );
				.or.;
				( cFil == NIL );
			)

			/*/
			здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
			Ё Verifica se existe uma area reservada para o Alias SM0	   Ё
			юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды/*/
			IF ( Select( "SM0" ) == 0 )
				/*/
				здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
				ЁDeclara e inicializa a variavel cArqEmp que sera utilizada  inЁ
				Ёternamente pela funcao OpenSM0()							   Ё
				юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды/*/
				Private cArqEmp := "sigamat.emp"
				/*/
				здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
				ЁAbre o Cadastro de Empresas								   Ё
				юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды/*/
				OpenSM0()
			EndIF

			/*/
			здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
			Ё Verifica se existe uma area reservada para o Alias SM0	   Ё
			юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды/*/
			IF ( Select( "SM0" ) == 0 )
				/*/
				зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
				ЁUtilizamos a funcao MsgInfo() para Mostrar a mensagem ao   usuaЁ
				Ёrio															Ё
				юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды/*/
				MsgInfo( "NЦo foi possМvel abrir o Cadastro de Empresas" )
				/*/
				зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
				ЁDesviamos o controle do programa para a primeira instrucao aposЁ
				Ёo End Sequence													Ё
				юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды/*/
				Break
			EndIF

			/*/
			зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
			ЁInicializamos as Variavels aEmpresas e a Recnos como um   ArrayЁ
			Ё"vazio" que serao utilizados durante o "Laco" While para armazeЁ
			Ёnar informacoes da Tabela referenciada pelo Alias SM0.         Ё
			юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды/*/
			aEmpresas	:= {}
			aRecnos		:= {}

			/*/
			зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
			ЁUtiliza a Funcao dbGoTop() para posicionar no Primeiro RegistroЁ
			Ёda Tabela referenciada pelo Alias SM0.							Ё
			юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды/*/
			SM0->( dbGoTop() )

			/*/
			зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
			ЁExecuta o Laco While enquanto a funcao Eof() retornar .F. caracЁ
			Ёterizando que ainda nao chegou ao final de arquivo.			Ё
			юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды/*/
			While SM0->( !Eof() )
				/*/
				здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
				ЁCarrega apenas os n Primeiros Registros nao repetidos		   Ё
				юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды/*/
				IF SM0->( UniqueKey( "M0_CODIGO" , "SM0" ) )
					/*/
					зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
					ЁCarrega informacoes da Empresa na Variavel cEmpresa.			Ё
					ЁObs.: A funcao AllTrim() retira todos os espacos a Direita e  aЁ
					ЁEsquerda de uma Variavel do Tipo Caractere.					Ё
					юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды/*/
					cEmpresa := SM0->( M0_CODIGO + " - " + AllTrim( M0_NOME ) + " / " + AllTrim( M0_FILIAL ) )
					/*/
					зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
					ЁAdiciona o Conteudo da variavel cEmpresa ao Array aEmpresas    Ё
					юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды/*/
					aAdd( aEmpresas , cEmpresa )
					/*/
					зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
					ЁAdiciona o Recno Atual da Tabela referenciada pelo Alias SM0 aoЁ
					Ёarray aRecnos.													Ё
					юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды/*/
					SM0->( aAdd( aRecnos , Recno() ) )
				EndIF
				/*/
				зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
				ЁA funcao dbSkip() e utilizada para Mover o Ponteiro da Tabela. Ё
				ЁPor padrao ela sempre ira mover para o proximo registro. Porem,Ё
				Ёtemos a opcao de mover n Registros Tanto "para baixo"    quantoЁ
				Ё"para cima". Ex: dbSkip( 1 ) salta para o registro  imediatamenЁ
				Ёte posterior e eh o mesmo que dbSkip(), dbSkip( 2 ) salta  doisЁ
				Ёregistros; dbSkip( 10 ) salta 10 registros; dbSkip( -1 )  saltaЁ
				Ёpara o registro imediatamente anterior; dbSkip( -2 ) salta doisЁ
				Ёregistros "acima"; dbSkip( -10 ) para 10 registros acima...    Ё
				юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды/*/
				SM0->( dbSkip() )
			End While

			/*/
			зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
			ЁUtilizamos a funcao Empty() para verificar se o Array aEmpresasЁ
			Ёesta vazio. Se estiver vazio eh porque nao exitem registros  naЁ
			ЁTabela referenciada pelo Alias SM0								Ё
			юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды/*/
			IF Empty( aRecnos )
				/*/
				зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
				ЁUtilizamos a funcao MsgInfo() para Mostrar a mensagem ao   usuaЁ
				Ёrio															Ё
				юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды/*/
				MsgInfo( "NЦo Existem Empresas Cadastradas no SIGAMAT.EMP" )
				/*/
				зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
				ЁDesviamos o controle do programa para a primeira instrucao aposЁ
				Ёo End Sequence													Ё
				юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды/*/
				Break
			EndIF

			/*/
			здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
			ЁAtribuimos aa variavel lConfirm o valor .F. ( Falso )		   Ё
			юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды/*/
			lConfirm	:= .F.

			/*/
			здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
			ЁDeclara a Variavel __cInterNet								   Ё
			юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды/*/
			__cInterNet		:= NIL

			/*/
			здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
			ЁDefine o tipo de fonte a ser utilizado no Objeto Dialog	   Ё
			юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды/*/
			DEFINE FONT oFont NAME "Courier New" SIZE 0,-11 BOLD
			/*/
			здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
			ЁDisponibiliza Dialog para a Escolha da Empresa				   Ё
			юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды/*/
			DEFINE MSDIALOG oDlg TITLE OemToAnsi( "Selecione a Empresa" ) From 0,0 TO 100,430 OF GetWndDefault() STYLE DS_MODALFRAME STATUS  PIXEL
				/*/
				зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
				ЁDefine o Objeto ComboBox                                       Ё
				юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды/*/
				@ 020,010 COMBOBOX oEmpresas VAR cEmpresa ITEMS aEmpresas SIZE 200,020 OF oDlg PIXEL FONT oFont
				/*/
				здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
				ЁRedefine o Ponteiro oEmpresas:nAt							   Ё
				юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды/*/
				oEmpresas:nAt		:= 1
				/*/
				здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
				ЁDefine a Acao para o Bloco bChange do objeto do Tipo ComboBox Ё
				юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды/*/
				oEmpresas:bChange	:= { || ( nEmpresa := oEmpresas:nAt ) }
				/*/
				здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
				ЁInicializa a Variavel nEmpresa							       Ё
				юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды/*/
				Eval( oEmpresas:bChange )
				/*/
				здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
				ЁNao permite sair ao se pressionar a tecla ESC.				   Ё
				юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды/*/
				oDlg:lEscClose := .F.
				/*/
				здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
				ЁDefine o Bloco para a Inicializacao do Dialog.				   Ё
				юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды/*/
				bDialogInit := { || EnchoiceBar( oDlg , { || lConfirm := .T. , oDlg:End() } , { || lConfirm := .F. , oDlg:End() } ) }
			ACTIVATE MSDIALOG oDlg CENTERED ON INIT Eval( bDialogInit )

			/*/
			зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
			ЁSe nao Clicou no Botao OK da EnchoiceBar abandona o processo   Ё
			юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды/*/
			IF !( lConfirm )
				/*/
				зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
				ЁDesviamos o controle do programa para a primeira instrucao aposЁ
				Ёo End Sequence													Ё
				юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды/*/
				Break
			EndIF

			/*/
			зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
			ЁAtribuimos aa variavel nEmpresa o Conteudo ( Recno ) armazenadoЁ
			Ёno Array aRecnos para o Elemento nRecEmpresa.					Ё
			юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды/*/
			nRecEmpresa := aRecnos[ nEmpresa ]
			
			/*/
			зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
			ЁUtilizamos a funcao MsGoto() para efetuarmos Garantirmos que  oЁ
			Ёponteiro da Tabela referenciada pelo Alias SM0 esteja posicionaЁ
			Ёdo no Registro armazenado na variavel nEmpresa. MsGoto() verifiЁ
			Ёca se o registro ja esta posicionado e, se nao estiver, executaЁ
			Ёa Funcao dbGoto( n ) passando como parametro o conteudo de  nEmЁ
			Ёpresa como parametro. Eh a funcao dbGoto() quem    efetivamenteЁ
			Ёira efetuar o posicionamento do Ponteiro da Tabela no registro.Ё
			юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды/*/
			SM0->( MsGoto( nRecEmpresa ) )

			/*/
			зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
			ЁAtribuimos aa variavel cEmp o conteudo do campo M0_CODIGO da TaЁ
			Ёbela referenciada pelo Alias SM0								Ё
			юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды/*/
			cEmp	:= SM0->M0_CODIGO
			/*/
			зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
			ЁAtribuimos aa variavel cFil o conteudo do campo M0_CODIGO da TaЁ
			Ёbela referenciada pelo Alias SM0								Ё
			юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды/*/
			cFil	:= SM0->M0_CODFIL

			/*/
			зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
			ЁConcatenamos, ao conteudo ja existente na variavel cTitle,   asЁ
			Ёinformacoes da Empresa.										Ё
			юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды/*/
			cTitle	+= " Empresa: "
			cTitle	+= aEmpresas[ nEmpresa ]

		EndIF

		/*/
		здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
		ЁColoca o Ponteiro do Cursos do Mouse em estado de Espera	   Ё
		юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды/*/
		CursorWait()

		/*/
		здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
		ЁPreparando o ambiente para trabalhar com as Tabelas do SIGA.  Ё
		ЁAbrindo a empresa Definida na Variavel cEmp e para a Filial deЁ
		Ёfinida na variavel cFil									   Ё
		юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды/*/
		PREPARE ENVIRONMENT EMPRESA ( cEmp ) FILIAL ( cFil ) MODULO "CFG"

			/*/
			здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
			ЁInicializando as Variaveis Publicas						   Ё
			юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды/*/
			InitPublic()

			/*/
			здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
			ЁCarregando as Configuracoes padroes ( Variaveis de Ambiente ) Ё
			юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды/*/
			SetsDefault()

			/*/
			здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
			ЁRedefine nModulo de forma a Garantir que o Modulo seja SIGAGE Ё
			юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды/*/
			SetModulo( "SIGACFG" , "CFG" )

			/*/
			здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
			ЁRefefine __cInterNet para que nao ocorra erro na SetPrint()   Ё
			юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды/*/
			__cInterNet	:= NIL

			/*/
			здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
			ЁRefefine lMsHelpAuto para que a MsgNoYes() Seja Executada	   Ё
			юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды/*/
			lMsHelpAuto		:= .T.

			/*/
			здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
			ЁRefefine lMsFinaAuto para que a Final() seja executada    comoЁ
			Ёse estivesse no Remote										   Ё
			юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды/*/
			lMsFinalAuto	:= .T.

			/*/
			здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
			ЁUtiliza o Comando DEFINE WINDOW para criar uma nova janela. EsЁ
			Ёte comando sera convertido em Chamada de funcao pelo   pre-proЁ
			Ёcessador que utilizara o "PROTHEUS.CH" para identificar em queЁ
			Ёou em qual arquivo .CH ( Clipper Header ) esta definida a  traЁ
			Ёducao para o comando.										   Ё
			Ё															   Ё
			ЁDEFINE WINDOW cria a janela								   Ё
			ЁFROM 001,001 define as coordenadas da Janela ( Linha Inicial ,Ё
			ЁColuna Inicial)											   Ё
			ЁTO 400,500 define as coordenadas da Janela ( Linha Final ,  CoЁ
			Ёluna Final )												   Ё
			ЁTITLE OemToAnsi( cTitle ) Define o titulo para a Janela       Ё
			ЁOemToAnsi() converte o conteudo do texto da string cTitle   doЁ
			ЁPadrao Oem para o Ansi.									   Ё
			юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды/*/
			DEFINE WINDOW oMainWnd FROM 001,001 TO 400,500 TITLE OemToAnsi( cTitle )
			/*/
			здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
			ЁACTIVATE WINDOW ativa a Janela ( Caixa de Dialogo ou Dialog ) Ё
			ЁMAXIMIZED define que a forma sera Maximixada				   Ё
			ЁON INIT define o programa que sera executado na  InicializacaoЁ
			Ёda Janela 													   Ё
			юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды/*/
		  	ACTIVATE WINDOW oMainWnd MAXIMIZED ON INIT ( Eval( bWindowInit ) , oMainWnd:End() )

		RESET ENVIRONMENT

	Else

		/*/
		здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
		Ё Processa a Importacao										   Ё
		юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды/*/
  		Eval( bWindowInit )

	EndIF

End Sequence

Return( NIL )

/*/
зддддддддддбддддддддддддддбдддддбдддддддддддддддддддддбддддддбдддддддддд©
ЁFun┤┘o    ЁGetSraImg	  ЁAutorЁMarinaldo de Jesus   Ё Data Ё13/05/2005Ё
цддддддддддеддддддддддддддадддддадддддддддддддддддддддаддддддадддддддддд╢
ЁDescri┤┘o ЁImportar as Fotos dos Funcionarios                          Ё
цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢
ЁSintaxe   Ё<vide parametros formais>									Ё
цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢
ЁParametrosЁ<vide parametros formais>									Ё
цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢
ЁUso       ЁGenerico                      								Ё
юддддддддддадддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды/*/
Static Function GetSraImg( lShowLog )

Local aLogTitle		:= {}
Local aLogFile		:= {}

Local a_fOpcoesGet

Local b_fOpcoes
Local bMakeLog

/*/
здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
ЁDisponibiliza Dialog para a Escolha do Diretorio              Ё
юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды/*/
Local cPath 		:= cGetFile( "Fotos dos Funcionarios |????????.JPG| Fotos dos Funcionarios |????????.JPEG| Fotos dos Funcionarios |????????.BMP|" , OemToAnsi( "Selecione Diretorio" ) , NIL , "" , .F. , _OPC_cGETFILE )
Local cTime			:= Time()

Local cMaskJPG		:= "????????.JPG"
Local cMaskJPEG		:= "????????.JPEG"
Local cMaskBMP		:= "????????.BMP"

Local aFiles
Local aFilesJPG
Local aFilesJPEG
Local aFilesBMP

Local cFil
Local cMat
Local cFile
Local cTitulo
Local cPathFile
Local cMsgIncProc
Local c_fOpcoesGet
Local cPathLogFile

Local lf_Opcoes

Local nFile
Local nFiles
Local nFilesJPG
Local nFilesJPEG
Local nFilesBMP
Local nSraOrder

Local u_fOpcoesRet

Begin Sequence

	/*/
	здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	ЁVerifica se o Diretorio Foi Selecionado					   Ё
	юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды/*/
	IF Empty( cPath )
		MsgInfo( OemToAnsi( "NЦo foi possМvel encontrar o diretСrio de imagens" ) )
		Break
	EndIF

	/*/
	здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	ЁObtem os arquivos a serem importados .JPG					   Ё
	юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды/*/
	cPathFile	:= ( cPath + cMaskJPG )
	aFilesJPG	:= Array( aDir( cPathFile ) )
	nFilesJPG	:= aDir( cPathFile , aFilesJPG )

	/*/
	здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	ЁObtem os arquivos a serem importados .JPEG					   Ё
	юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды/*/
	cPathFile	:= ( cPath + cMaskJPEG )
	aFilesJPEG	:= Array( aDir( cPathFile ) )
	nFilesJPEG	:= aDir( cPathFile , aFilesJPEG )

	/*/
	здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	ЁObtem os arquivos a serem importados .BMP					   Ё
	юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды/*/
	cPathFile	:= ( cPath + cMaskBMP )
	aFilesBMP	:= Array( aDir( cPathFile ) )
	nFilesBMP	:= aDir( cPathFile , aFilesBMP )

	nFiles		:= ( nFilesJPG + nFilesJPEG + nFilesBMP )

	/*/
	здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	ЁSe nao existirem arquivos a serem importados abandona         Ё
	юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды/*/
	IF ( nFiles == 0 )
		MsgInfo( "NЦo Existem Imagens a serem importadas" )
		Break
	EndIF

	/*/
	здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	ЁUnifica os arquivos                                           Ё
	юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды/*/
	aFiles := {}
	aEval( aFilesJPG  , { |cFile| aAdd( aFiles , cFile ) } )
	aEval( aFilesJPEG , { |cFile| aAdd( aFiles , cFile ) } )
	aEval( aFilesBMP  , { |cFile| aAdd( aFiles , cFile ) } )
	aFilesJPG	:= NIL
	aFilesJPEG	:= NIL
	aFilesBMP	:= NIL

	IF ( MsgNoYes( "Deseja Selecionar as Imagens a Serem Importadas?" ) )

		b_fOpcoes := { ||;
							a_fOpcoesGet	:= {},;
							u_fOpcoesRet	:= "",;
							aEval( aFiles , { |cFile,cAlias| cAlias := SubStr( cFile , 1 , 8 ) , c_fOpcoesGet := ( cAlias + " - " + cFile ) , aAdd( a_fOpcoesGet , c_fOpcoesGet ) , u_fOpcoesRet += cAlias } ),;
							c_fOpcoesGet	:= u_fOpcoesRet,;
							nFiles			:= Len( aFiles ),;
							lf_Opcoes		:= f_Opcoes(	@u_fOpcoesRet				,;	//Variavel de Retorno
															"Imagens"					,;	//Titulo da Coluna com as opcoes
															a_fOpcoesGet				,;	//Opcoes de Escolha (Array de Opcoes)
															c_fOpcoesGet				,;	//String de Opcoes para Retorno
															NIL							,;	//Nao Utilizado
															NIL							,;	//Nao Utilizado
															.F.							,;	//Se a Selecao sera de apenas 1 Elemento por vez
															8							,;	//Tamanho da Chave
															nFiles						,;	//No maximo de elementos na variavel de retorno
															.T.							,;	//Inclui Botoes para Selecao de Multiplos Itens
															.F.							,;	//Se as opcoes serao montadas a partir de ComboBox de Campo ( X3_CBOX )
															NIL							,;	//Qual o Campo para a Montagem do aOpcoes
															.F.							,;	//Nao Permite a Ordenacao
															.F.							,;	//Nao Permite a Pesquisa
															.T.			    			,;	//Forca o Retorno Como Array
															NIL				 			 ;	//Consulta F3
					  									);
					 }

		MsAguarde( b_fOpcoes )

		IF !( lf_Opcoes )
			MsgInfo( OemToAnsi( "ImportaГЦo Cancelada Pelo UsuАrio." ) )
			Break
		EndIF

		a_fOpcoesGet	:= {}

		For nFile := 1 To nFiles
            IF ( aScan( u_fOpcoesRet , { |cElem| ( cElem == SubStr( aFiles[ nFile ] , 1 , 8 ) ) } ) > 0 )
            	aAdd( a_fOpcoesGet , aFiles[ nFile ] )
            EndIF
		Next nFile

		aFiles 			:= a_fOpcoesGet
		a_fOpcoesGet	:= NIL

	EndIF

	/*/
	здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	ЁSe nao existirem arquivos a serem importados abandona         Ё
	юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды/*/
	nFiles	:= Len( aFiles )
	IF ( nFiles == 0 )
		MsgInfo( "NЦo Existem Imagens a serem importadas" )
		Break
	EndIF

	/*/
	здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	Ё Seta o Numero de Elementos da 1a BarGauge					   Ё
	юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды/*/
	BarGauge1Set( nFiles )

	/*/
	здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	Ё Seta o Repositorio de Imagens que sera utilizado			   Ё
	юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды/*/
	SetRepName( "SIGAADV" )

		/*/
		здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
		Ё Libera imagens Pendentes									   Ё
		юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды/*/
		FechaReposit()	//For┤o o Fechamento o Repositorio de Imangens
			PackRepository()
		FechaReposit()	//For┤o o Fechamento o Repositorio de Imangens

	/*/
	здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	Ё Seta o Repositorio de Imagens que sera utilizado			   Ё
	юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды/*/
	SetRepName( "SIGAADV" )

	/*/
	здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	Ё Retorna a Ordem do Indice a ser utilizado conforme expressao Ё
	юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды/*/
	nSraOrder := RetOrder( "SRA" , "RA_FILIAL+RA_MAT" ) 

	/*/
	здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	Ё Seta a Ordem para o SRA									   Ё
	юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды/*/
	SRA->( dbSetOrder( nSraOrder ) )        //erro aqui = NIL

	/*/
	здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	Ё Efetua um Laco para processar Todos os arquivos a serem imporЁ
	Ё tados														   Ё
	юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды/*/
	For nFile := 1 To nFiles
		/*/
		здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
		Ё Obtem o Nome do arquivo a ser Importado					   Ё
		юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды/*/
		cFile		:= aFiles[ nFile ]
		/*/
		здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
		Ё Concatena o "Path" do arquivo com o proprio arquivo		   Ё
		юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды/*/
		cPathFile	:= ( cPath + cFile )
		/*/
		здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
		ЁMonsta o Texto que sera apresentado no Dialog de processamentoЁ
		юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды/*/
		cMsgIncProc	:= "Importando Imagem: "
		cMsgIncProc	+= cPathFile
		/*/
		здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
		ЁIncrementa a Regua de Processamento						   Ё
		юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды/*/
		IncPrcG1Time( cMsgIncProc	,;	//01 -> Inicio da Mensagem
					  nFiles		,;	//02 -> Numero de Registros a Serem Processados
					  cTime			,;	//03 -> Tempo Inicial
					  .T.			,;	//04 -> Defina se eh um processo unico ou nao ( DEFAULT .T. )
					  1				,;	//05 -> Contador de Processos
					  1		 		,;	//06 -> Percentual para Incremento
					  NIL			,;	//07 -> Se Deve Incrementar a Barra ou Apenas Atualizar a Mensagem
					  .T.			 ;	//08 -> Se Forca a Atualizacao das Mensagens
					)
		/*/
		здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
		Ё Efetiva a Importacao das Imagens							   Ё
		юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды/*/
		IF !( DlgPutImg( cPathFile , cPath , cFile ) )
			/*/
			здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
			Ё Se nao conseguiu importar a imagem adiciona ao Log		   Ё
			юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды/*/
			aAdd( aLogFile , ( "Nao foi Possivel Adicionar a Imagem: " + cPathFile ) )
		EndIF
	Next nFile

	/*/
	здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	Ё Libera imagens Pendentes									   Ё
	юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды/*/
	FechaReposit()	//For┤o o Fechamento o Repositorio de Imangens
		PackRepository()
	FechaReposit()	//For┤o o Fechamento o Repositorio de Imangens

End Sequence

/*/
здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
Ё Se ocorreu alguma inconsistencia na importacao das imagens   Ё
юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды/*/
IF !Empty( aLogFile )

	/*/
	здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	Ё Define o Titulo para o Relatorio de LOG					   Ё
	юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды/*/
	cTitulo := "Inconsistencias na Importacao de Fotos"
	aAdd( aLogTitle , cTitulo )
	/*/
	здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	Ё Monta o Bloco para a Geracao do Log           			   Ё
	юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды/*/
	bMakeLog := { || cPathLogFile := fMakeLog(	{ aLogFile }	,;	//Array que contem os Detalhes de Ocorrencia de Log
												aLogTitle		,;	//Array que contem os Titulos de Acordo com as Ocorrencias
												NIL				,;	//Pergunte a Ser Listado
												lShowLog		,;	//Se Havera "Display" de Tela
												NIL				,;	//Nome Alternativo do Log
												cTitulo			,;	//Titulo Alternativo do Log
												"M"				,;	//Tamanho Vertical do Relatorio de Log ("P","M","G")
												"L"				,;	//Orientacao do Relatorio ("P" Retrato ou "L" Paisagem )
												NIL				,;	//Array com a Mesma Estrutura do aReturn
												.T.				 ;	//Se deve Manter ( Adicionar ) no Novo Log o Log Anterior
			  								);
				}
	/*/
	здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	Ё Disponibiliza o Log de Inconsistencias			   		   Ё
	юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды/*/
	MsAguarde( bMakeLog , "Gerando o Log" )

	IF !( lShowLog )
		MsgInfo( OemToAnsi( "O Arquivo de Log foi gerado em: " + cPathLogFile ) )
	EndIF

EndIF

Return( NIL )

/*/
зддддддддддбддддддддддддддбдддддбдддддддддддддддддддддбддддддбдддддддддд©
ЁFun┤┘o    ЁDlgPutImg     ЁAutorЁMarinaldo de Jesus   Ё Data Ё13/05/2005Ё
цддддддддддеддддддддддддддадддддадддддддддддддддддддддаддддддадддддддддд╢
ЁDescri┤┘o ЁImportar as Fotos dos Funcionarios                          Ё
цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢
ЁSintaxe   Ё<vide parametros formais>									Ё
цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢
ЁParametrosЁ<vide parametros formais>									Ё
цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢
ЁUso       ЁGenerico                      								Ё
юддддддддддадддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды/*/
Static Function DlgPutImg( cPathFile , cPath , cFile )

Local bDialogInit

Local oDlg
Local oRepository

Local lPutOk := .T.

/*/
здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
Ё Monta Dialogo "Escondido" para possibilitar a importacao  dasЁ
Ё imagens													   Ё
юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды/*/
DEFINE MSDIALOG oDlg FROM 0,0 TO 0,0 PIXEL

	/*/
	здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	Ё Cria um Objeto do Tipo Repositorio						   Ё
	юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды/*/
	@ 000,000 REPOSITORY oRepository SIZE 0,0 OF oDlg

	/*/
	здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	Ё Efetiva a importacao da imagem     						   Ё
	юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды/*/
	lPutOk		:= PutImg( oRepository , cPathFile , cPath , cFile )
	bDialogInit	:= { || oRepository:lStretch := .T. , oDlg:End() , oRepository := NIL , oDlg:= NIL }

/*/
здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
Ё Ativa e Fecha o Dialogo									   Ё
юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды/*/
ACTIVATE MSDIALOG oDlg ON INIT Eval( bDialogInit )

Return( lPutOk )

/*/
зддддддддддбддддддддддддддбдддддбдддддддддддддддддддддбддддддбдддддддддд©
ЁFun┤┘o    ЁPutImg        ЁAutorЁMarinaldo de Jesus   Ё Data Ё13/05/2005Ё
цддддддддддеддддддддддддддадддддадддддддддддддддддддддаддддддадддддддддд╢
ЁDescri┤┘o ЁGravar a Imagem no Repositorio de Imagens e Vincula-la    aoЁ
Ё          Ёfuncionario													Ё
цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢
ЁSintaxe   Ё<vide parametros formais>									Ё
цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢
ЁParametrosЁ<vide parametros formais>									Ё
цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢
ЁUso       ЁGenerico                      								Ё
юддддддддддадддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды/*/
Static Function PutImg( oRepository , cPathFile , cPath , cFile )

Local cSraBitMap

Local lPutOk	:= .F.
Local lPut		:= .F.
Local lLock		:= .F.
Local lAllOk	:= .F.
Local lFound	:= .F.

Local nRecno

Begin Sequence

	/*/
	здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	Ё Verifica se o arquio de Imagem existe						   Ё
	юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды/*/
	IF !( lPutOk := File( cPathFile ) )
		Break
	EndIF

	/*/
	здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	Ё Utiliza a funcao RetFileName() para retinar o Nome do arquivoЁ
	Ё sem o "path" e sem o Extenso								   Ё
	юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды/*/
   	cSraBitMap := RetFileName( cPathFile )

	/*/
	здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	Ё Procura o Funcionario										   Ё
	юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды/*/
	lFound := SRA->( dbSeek( cSraBitMap , .F. ) )      
	/*/
	здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	Ё Se nao Encontrou o Funcionario, abandona					   Ё
	юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды/*/
	IF !( lFound )
		Break
	EndIF

	/*/
	здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	Ё Armazena o Recno   										   Ё
	юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды/*/
	nRecno := SRA->( Recno() )  //devera ter recno do registro OK

	/*/
	здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	Ё Utiliza o "Method" :IsertBmp para inserir a imagem no  ReposiЁ
	Ё torio de Imagens do Protheus								   Ё
	юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды/*/
	lPutOk	:= ( cSraBitMap == oRepository:InsertBmp( cPathFile , NIL , @lPut ) )       //verificar poor que imagem nao salva

	/*/
	здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	Ё Se adicionou a Imagem no Repositorio, vincula a imagem ao FunЁ
	Ё cionario													   Ё
	юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды/*/
	IF (;
			!( lPutOk );	//Obtido a partir do Teste de Retorno do Metodo :InsertBmp()  //VERIFICAR POR QUE O MESMO NAO ESTA SALVANDO
			.and.;
			( lPut );	//Retornado por referencia pelo Metodo :InsertBmp() .T. Inseriu a Nova Imagem, caso contrario, .F.
		)	
		/*/
		здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
		Ё Garante o Posicionamento no Registro						   Ё
		юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды/*/
	   	SRA->( MsGoto( nRecno ) )
	 	/*/
		здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
		Ё Lock no Registro     										   Ё
		юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды/*/
		IF SRA->( lLock := RecLock( "SRA" , .F. ) )
			/*/
			здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
			Ё Vincula a Imagem     										   Ё
			юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды/*/
			SRA->RA_BITMAP := cSraBitMap        //nesse ponto efetua gravaГЦo ALTERAR PARA QUE INSIRA CODIGO CORRETAMENTO
			/*/
			здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
			Ё Atualiza o Vinculo da Imagem								   Ё
			юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды/*/
	    	oRepository:LoadBmp( cSraBitMap )
			oRepository:Refresh()
			/*/
			здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
			Ё Libera o Registro    										   Ё
			юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды/*/
			SRA->( MsUnLock() )
			/*/
			здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
			Ё Move a Imagem para um Diretorio "Backup"					   Ё
			юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды/*/
			MoveFile( cPathFile , cPath , cFile )
		EndIF
	EndIF

End Sequence

/*/
здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
Ё Retona se Conseguiu Gravar a Imagem     					   Ё
юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды/*/
lAllOk := (;
				( lFound );	//Verifica se Encontrou o Funcionario
				.and.;
				!( lPutOk );	//Obtido a partir do Teste de Retorno do Metodo :InsertBmp()
				.and.;
				( lPut );	//Retornado por referencia pelo Metodo :InsertBmp() .T. Inseriu a Nova Imagem, caso contrario, .F.
				.and.;
				( lLock );	//Gravou a Referencia da Imagem no SRA ( Cadastro de Funcionarios )
			)	

Return( lAllOk )

/*/
зддддддддддбддддддддддддддбдддддбдддддддддддддддддддддбддддддбдддддддддд©
ЁFun┤┘o    ЁMoveFile	  ЁAutorЁMarinaldo de Jesus   Ё Data Ё13/05/2005Ё
цддддддддддеддддддддддддддадддддадддддддддддддддддддддаддддддадддддддддд╢
ЁDescri┤┘o ЁMover as Imagens que foram importadas para o Repositorio   eЁ
Ё          Ёvinculadas ao Funcionario para um diretorio "BackUp"		Ё
цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢
ЁSintaxe   Ё<vide parametros formais>									Ё
цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢
ЁParametrosЁ<vide parametros formais>									Ё
цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢
ЁUso       ЁGenerico                      								Ё
юддддддддддадддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды/*/
Static Function MoveFile( cPathFile , cPath , cFile )

Local cNewPath
Local cNewPathFile

Begin Sequence

	/*/
	здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	Ё Define o "Path" para "Backup" das imagens					   Ё
	юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды/*/
	cNewPath := ( cPath + "BACK\" )

	/*/
	здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	Ё Verifica se o "Path" para "Backup" existe e, se nao  existir,Ё
	Ё cria-o													   Ё
	юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды/*/
	IF !( DirMake( cNewPath ) )
		Break
	EndIF

	/*/
	здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	Ё Define o novo "Path" e nome do arquivo. 					   Ё
	юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды/*/
	cNewPathFile := ( cNewPath + cFile )

	/*/
	здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	Ё Move o arquivo para o "Path" de "Backup"					   Ё
	юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды/*/
	FileMove( cPathFile , cNewPathFile )

End Sequence

Return( NIL )

/*/
зддддддддддбддддддддддддддбдддддбдддддддддддддддддддддбддддддбдддддддддд©
ЁFun┤┘o    ЁEqualFile     ЁAutorЁMarinaldo de Jesus   Ё Data Ё29/03/2005Ё
цддддддддддеддддддддддддддадддддадддддддддддддддддддддаддддддадддддддддд╢
ЁDescri┤┘o ЁVerifica se Dois Arquivos sao Iguais                        Ё
цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢
ЁSintaxe   Ё<vide parametros formais>									Ё
цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢
ЁParametrosЁ<vide parametros formais>									Ё
цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢
ЁUso       ЁGenerico                      								Ё
юддддддддддадддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды/*/
Static Function EqualFile( cFile1 , cFile2 )

Local lIsEqualFile	:= .F.

Local nfhFile1	:= fOpen( cFile1 )
Local nfhFile2	:= fOpen( cFile2 )

Begin Sequence

	IF (;
			( nfhFile1 <= 0 );
			.or.;
			( nfhFile2 <= 0 );
		)
		Break
	EndIF

	lIsEqualFile := ArrayCompare( GetAllTxtFile( nfhFile1 ) , GetAllTxtFile( nfhFile2 ) )

	fClose( nfhFile1 )
	fClose( nfhFile2 )

End Sequence

Return( lIsEqualFile )

/*/
зддддддддддбддддддддддддддбдддддбдддддддддддддддддддддбддддддбдддддддддд©
ЁFun┤┘o    ЁDirMake       ЁAutorЁMarinaldo de Jesus   Ё Data Ё29/03/2005Ё
цддддддддддеддддддддддддддадддддадддддддддддддддддддддаддддддадддддддддд╢
ЁDescri┤┘o ЁCria um Diretorio                                           Ё
цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢
ЁSintaxe   Ё<vide parametros formais>									Ё
цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢
ЁParametrosЁ<vide parametros formais>									Ё
цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢
ЁUso       ЁGenerico                      								Ё
юддддддддддадддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды/*/
Static Function DirMake( cMakeDir , nTimes , nSleep )

Local lMakeOk
Local nMakeOk

IF !( lMakeOk := lIsDir( cMakeDir ) )
	MakeDir( cMakeDir )
	nMakeOk			:= 0
	DEFAULT nTimes	:= 10
	DEFAULT nSleep	:= 1000
	While (;
			!( lMakeOk := lIsDir( cMakeDir ) );
			.and.;
			( ++nMakeOk <= nTimes );
	   )
		Sleep( nSleep )
		MakeDir( cMakeDir )
	End While
EndIF

Return( lMakeOk )

/*/
зддддддддддбддддддддддддддбдддддбдддддддддддддддддддддбддддддбдддддддддд©
ЁFun┤┘o    ЁFileMove      ЁAutorЁMarinaldo de Jesus   Ё Data Ё29/03/2005Ё
цддддддддддеддддддддддддддадддддадддддддддддддддддддддаддддддадддддддддд╢
ЁDescri┤┘o ЁMover um arquivo de Diretorio                               Ё
цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢
ЁSintaxe   Ё<vide parametros formais>									Ё
цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢
ЁParametrosЁ<vide parametros formais>									Ё
цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢
ЁUso       ЁGenerico                      								Ё
юддддддддддадддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды/*/
Static Function FileMove( cOldPathFile , cNewPathFile , lErase )

Local lMoveFile

Begin Sequence

	IF !(;
			lMoveFile := (;
							( __CopyFile( cOldPathFile , cNewPathFile ) );
							.and.;
							File( cNewPathFile );
							.and.;
							EqualFile( cOldPathFile , cNewPathFile );
						 );
		)
		Break
	EndIF

	DEFAULT lErase := .T.
	IF ( lErase )
		fErase( cOldPathFile )
	EndIF	

End Sequence

Return( lMoveFile )
