/*/
旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
�"PROTHEUS.CH" eh Utilizado para substituir a constante CRLF pe�
쿹o seu valor real e os comandos para criacao de DIALOG em suas�
퀁espectivas chamadas de funcao								   �
읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸/*/
#INCLUDE "PROTHEUS.CH"

/*/
旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
�"TBICONN.CH" Traduzir os comandos PREPARE ENVIRONMENT e  RESET�
쿐NVIRONMENT nas respectivas chamadas de funcao 			   �
읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸/*/
#INCLUDE "TBICONN.CH"

/*/
旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
쿏efine as opcoes para a cGetFile							   �
� 															   �
쿚bs.: As constantes do tipo GETF_???... estao definidas no  ar�
�      quivo de cabecalho "PRCONST.CH"						   �
읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸/*/
#DEFINE _OPC_cGETFILE ( GETF_RETDIRECTORY + GETF_LOCALFLOPPY + GETF_LOCALHARD + GETF_NETWORKDRIVE + GETF_SHAREAWARE )

/*/
旼컴컴컴컴컫컴컴컴컴컴컴컴쩡컴컴쩡컴컴컴컴컴컴컴컴컴컴쩡컴컴컫컴컴컴컴컴�
쿑un뇚o    쿢_ImgSra      쿌utor쿘arinaldo de Jesus   � Data �13/05/2005�
쳐컴컴컴컴컵컴컴컴컴컴컴컴좔컴컴좔컴컴컴컴컴컴컴컴컴컴좔컴컴컨컴컴컴컴컴�
쿏escri뇚o 쿔mportar as Fotos dos Funcionarios                          �
쳐컴컴컴컴컵컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
쿞intaxe   �<vide parametros formais>									�
쳐컴컴컴컴컵컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
쿛arametros�<vide parametros formais>									�
쳐컴컴컴컴컵컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
쿢so       쿒enerico                      								�
읕컴컴컴컴컨컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�/*/
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
旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
� Verifica se a Variavel Publica oMainWnd esta declarada e se o�
� seu tipo eh objeto 										   �
읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸/*/
Local lExecInRmt	:= ( Type( "oMainWnd" ) == "O" )

/*/
旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
쿎oloca o Ponteiro do Cursos do Mouse em estado de Espera	   �
읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸/*/
CursorWait()

Begin Sequence

	/*/
	旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
	� Monta o Titulo para o Dialogo								   �
	읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸/*/
	cTitle := "Importa豫o das Fotos dos Funcion�rios"

	/*/
	旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
	� Monta Bloco para o Init da Window							   �
	읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸/*/
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
						MsgInfo( OemToAnsi( "Importa豫o Finalizada" ) , cTitle );
					}

	/*/
	旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
	� Se a Execucao nao for a partir do Menu do SIGA 			   �
	읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸/*/
	IF !( lExecInRmt )

		/*/
		旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
		쿏eclara a Variavel oMainWnd que vai ser utilizada para a   mon�
		퀃agem da Caixa de Dialogo ( Janela de Abertura ) do programa  �
		읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸/*/
		Private oMainWnd

		IF (;
				( cEmp == NIL );
				.or.;
				( cFil == NIL );
			)

			/*/
			旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
			� Verifica se existe uma area reservada para o Alias SM0	   �
			읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸/*/
			IF ( Select( "SM0" ) == 0 )
				/*/
				旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
				쿏eclara e inicializa a variavel cArqEmp que sera utilizada  in�
				퀃ernamente pela funcao OpenSM0()							   �
				읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸/*/
				Private cArqEmp := "sigamat.emp"
				/*/
				旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
				쿌bre o Cadastro de Empresas								   �
				읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸/*/
				OpenSM0()
			EndIF

			/*/
			旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
			� Verifica se existe uma area reservada para o Alias SM0	   �
			읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸/*/
			IF ( Select( "SM0" ) == 0 )
				/*/
				旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
				쿢tilizamos a funcao MsgInfo() para Mostrar a mensagem ao   usua�
				퀁io															�
				읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�/*/
				MsgInfo( "N�o foi poss�vel abrir o Cadastro de Empresas" )
				/*/
				旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
				쿏esviamos o controle do programa para a primeira instrucao apos�
				쿽 End Sequence													�
				읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�/*/
				Break
			EndIF

			/*/
			旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
			쿔nicializamos as Variavels aEmpresas e a Recnos como um   Array�
			�"vazio" que serao utilizados durante o "Laco" While para armaze�
			쿻ar informacoes da Tabela referenciada pelo Alias SM0.         �
			읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�/*/
			aEmpresas	:= {}
			aRecnos		:= {}

			/*/
			旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
			쿢tiliza a Funcao dbGoTop() para posicionar no Primeiro Registro�
			쿭a Tabela referenciada pelo Alias SM0.							�
			읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�/*/
			SM0->( dbGoTop() )

			/*/
			旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
			쿐xecuta o Laco While enquanto a funcao Eof() retornar .F. carac�
			퀃erizando que ainda nao chegou ao final de arquivo.			�
			읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�/*/
			While SM0->( !Eof() )
				/*/
				旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
				쿎arrega apenas os n Primeiros Registros nao repetidos		   �
				읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸/*/
				IF SM0->( UniqueKey( "M0_CODIGO" , "SM0" ) )
					/*/
					旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
					쿎arrega informacoes da Empresa na Variavel cEmpresa.			�
					쿚bs.: A funcao AllTrim() retira todos os espacos a Direita e  a�
					쿐squerda de uma Variavel do Tipo Caractere.					�
					읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�/*/
					cEmpresa := SM0->( M0_CODIGO + " - " + AllTrim( M0_NOME ) + " / " + AllTrim( M0_FILIAL ) )
					/*/
					旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
					쿌diciona o Conteudo da variavel cEmpresa ao Array aEmpresas    �
					읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�/*/
					aAdd( aEmpresas , cEmpresa )
					/*/
					旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
					쿌diciona o Recno Atual da Tabela referenciada pelo Alias SM0 ao�
					쿪rray aRecnos.													�
					읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�/*/
					SM0->( aAdd( aRecnos , Recno() ) )
				EndIF
				/*/
				旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
				쿌 funcao dbSkip() e utilizada para Mover o Ponteiro da Tabela. �
				쿛or padrao ela sempre ira mover para o proximo registro. Porem,�
				퀃emos a opcao de mover n Registros Tanto "para baixo"    quanto�
				�"para cima". Ex: dbSkip( 1 ) salta para o registro  imediatamen�
				퀃e posterior e eh o mesmo que dbSkip(), dbSkip( 2 ) salta  dois�
				퀁egistros; dbSkip( 10 ) salta 10 registros; dbSkip( -1 )  salta�
				쿾ara o registro imediatamente anterior; dbSkip( -2 ) salta dois�
				퀁egistros "acima"; dbSkip( -10 ) para 10 registros acima...    �
				읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�/*/
				SM0->( dbSkip() )
			End While

			/*/
			旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
			쿢tilizamos a funcao Empty() para verificar se o Array aEmpresas�
			쿮sta vazio. Se estiver vazio eh porque nao exitem registros  na�
			쿟abela referenciada pelo Alias SM0								�
			읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�/*/
			IF Empty( aRecnos )
				/*/
				旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
				쿢tilizamos a funcao MsgInfo() para Mostrar a mensagem ao   usua�
				퀁io															�
				읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�/*/
				MsgInfo( "N�o Existem Empresas Cadastradas no SIGAMAT.EMP" )
				/*/
				旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
				쿏esviamos o controle do programa para a primeira instrucao apos�
				쿽 End Sequence													�
				읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�/*/
				Break
			EndIF

			/*/
			旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
			쿌tribuimos aa variavel lConfirm o valor .F. ( Falso )		   �
			읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸/*/
			lConfirm	:= .F.

			/*/
			旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
			쿏eclara a Variavel __cInterNet								   �
			읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸/*/
			__cInterNet		:= NIL

			/*/
			旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
			쿏efine o tipo de fonte a ser utilizado no Objeto Dialog	   �
			읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸/*/
			DEFINE FONT oFont NAME "Courier New" SIZE 0,-11 BOLD
			/*/
			旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
			쿏isponibiliza Dialog para a Escolha da Empresa				   �
			읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸/*/
			DEFINE MSDIALOG oDlg TITLE OemToAnsi( "Selecione a Empresa" ) From 0,0 TO 100,430 OF GetWndDefault() STYLE DS_MODALFRAME STATUS  PIXEL
				/*/
				旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
				쿏efine o Objeto ComboBox                                       �
				읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�/*/
				@ 020,010 COMBOBOX oEmpresas VAR cEmpresa ITEMS aEmpresas SIZE 200,020 OF oDlg PIXEL FONT oFont
				/*/
				旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
				쿝edefine o Ponteiro oEmpresas:nAt							   �
				읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸/*/
				oEmpresas:nAt		:= 1
				/*/
				旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
				쿏efine a Acao para o Bloco bChange do objeto do Tipo ComboBox �
				읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸/*/
				oEmpresas:bChange	:= { || ( nEmpresa := oEmpresas:nAt ) }
				/*/
				旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
				쿔nicializa a Variavel nEmpresa							       �
				읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸/*/
				Eval( oEmpresas:bChange )
				/*/
				旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
				쿙ao permite sair ao se pressionar a tecla ESC.				   �
				읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸/*/
				oDlg:lEscClose := .F.
				/*/
				旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
				쿏efine o Bloco para a Inicializacao do Dialog.				   �
				읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸/*/
				bDialogInit := { || EnchoiceBar( oDlg , { || lConfirm := .T. , oDlg:End() } , { || lConfirm := .F. , oDlg:End() } ) }
			ACTIVATE MSDIALOG oDlg CENTERED ON INIT Eval( bDialogInit )

			/*/
			旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
			쿞e nao Clicou no Botao OK da EnchoiceBar abandona o processo   �
			읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�/*/
			IF !( lConfirm )
				/*/
				旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
				쿏esviamos o controle do programa para a primeira instrucao apos�
				쿽 End Sequence													�
				읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�/*/
				Break
			EndIF

			/*/
			旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
			쿌tribuimos aa variavel nEmpresa o Conteudo ( Recno ) armazenado�
			쿻o Array aRecnos para o Elemento nRecEmpresa.					�
			읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�/*/
			nRecEmpresa := aRecnos[ nEmpresa ]
			
			/*/
			旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
			쿢tilizamos a funcao MsGoto() para efetuarmos Garantirmos que  o�
			쿾onteiro da Tabela referenciada pelo Alias SM0 esteja posiciona�
			쿭o no Registro armazenado na variavel nEmpresa. MsGoto() verifi�
			쿬a se o registro ja esta posicionado e, se nao estiver, executa�
			쿪 Funcao dbGoto( n ) passando como parametro o conteudo de  nEm�
			쿾resa como parametro. Eh a funcao dbGoto() quem    efetivamente�
			쿶ra efetuar o posicionamento do Ponteiro da Tabela no registro.�
			읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�/*/
			SM0->( MsGoto( nRecEmpresa ) )

			/*/
			旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
			쿌tribuimos aa variavel cEmp o conteudo do campo M0_CODIGO da Ta�
			쿫ela referenciada pelo Alias SM0								�
			읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�/*/
			cEmp	:= SM0->M0_CODIGO
			/*/
			旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
			쿌tribuimos aa variavel cFil o conteudo do campo M0_CODIGO da Ta�
			쿫ela referenciada pelo Alias SM0								�
			읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�/*/
			cFil	:= SM0->M0_CODFIL

			/*/
			旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
			쿎oncatenamos, ao conteudo ja existente na variavel cTitle,   as�
			쿶nformacoes da Empresa.										�
			읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�/*/
			cTitle	+= " Empresa: "
			cTitle	+= aEmpresas[ nEmpresa ]

		EndIF

		/*/
		旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
		쿎oloca o Ponteiro do Cursos do Mouse em estado de Espera	   �
		읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸/*/
		CursorWait()

		/*/
		旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
		쿛reparando o ambiente para trabalhar com as Tabelas do SIGA.  �
		쿌brindo a empresa Definida na Variavel cEmp e para a Filial de�
		쿯inida na variavel cFil									   �
		읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸/*/
		PREPARE ENVIRONMENT EMPRESA ( cEmp ) FILIAL ( cFil ) MODULO "CFG"

			/*/
			旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
			쿔nicializando as Variaveis Publicas						   �
			읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸/*/
			InitPublic()

			/*/
			旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
			쿎arregando as Configuracoes padroes ( Variaveis de Ambiente ) �
			읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸/*/
			SetsDefault()

			/*/
			旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
			쿝edefine nModulo de forma a Garantir que o Modulo seja SIGAGE �
			읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸/*/
			SetModulo( "SIGACFG" , "CFG" )

			/*/
			旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
			쿝efefine __cInterNet para que nao ocorra erro na SetPrint()   �
			읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸/*/
			__cInterNet	:= NIL

			/*/
			旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
			쿝efefine lMsHelpAuto para que a MsgNoYes() Seja Executada	   �
			읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸/*/
			lMsHelpAuto		:= .T.

			/*/
			旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
			쿝efefine lMsFinaAuto para que a Final() seja executada    como�
			퀂e estivesse no Remote										   �
			읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸/*/
			lMsFinalAuto	:= .T.

			/*/
			旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
			쿢tiliza o Comando DEFINE WINDOW para criar uma nova janela. Es�
			퀃e comando sera convertido em Chamada de funcao pelo   pre-pro�
			쿬essador que utilizara o "PROTHEUS.CH" para identificar em que�
			쿽u em qual arquivo .CH ( Clipper Header ) esta definida a  tra�
			쿭ucao para o comando.										   �
			�															   �
			쿏EFINE WINDOW cria a janela								   �
			쿑ROM 001,001 define as coordenadas da Janela ( Linha Inicial ,�
			쿎oluna Inicial)											   �
			쿟O 400,500 define as coordenadas da Janela ( Linha Final ,  Co�
			쿹una Final )												   �
			쿟ITLE OemToAnsi( cTitle ) Define o titulo para a Janela       �
			쿚emToAnsi() converte o conteudo do texto da string cTitle   do�
			쿛adrao Oem para o Ansi.									   �
			읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸/*/
			DEFINE WINDOW oMainWnd FROM 001,001 TO 400,500 TITLE OemToAnsi( cTitle )
			/*/
			旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
			쿌CTIVATE WINDOW ativa a Janela ( Caixa de Dialogo ou Dialog ) �
			쿘AXIMIZED define que a forma sera Maximixada				   �
			쿚N INIT define o programa que sera executado na  Inicializacao�
			쿭a Janela 													   �
			읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸/*/
		  	ACTIVATE WINDOW oMainWnd MAXIMIZED ON INIT ( Eval( bWindowInit ) , oMainWnd:End() )

		RESET ENVIRONMENT

	Else

		/*/
		旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
		� Processa a Importacao										   �
		읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸/*/
  		Eval( bWindowInit )

	EndIF

End Sequence

Return( NIL )

/*/
旼컴컴컴컴컫컴컴컴컴컴컴컴쩡컴컴쩡컴컴컴컴컴컴컴컴컴컴쩡컴컴컫컴컴컴컴컴�
쿑un뇚o    쿒etSraImg	  쿌utor쿘arinaldo de Jesus   � Data �13/05/2005�
쳐컴컴컴컴컵컴컴컴컴컴컴컴좔컴컴좔컴컴컴컴컴컴컴컴컴컴좔컴컴컨컴컴컴컴컴�
쿏escri뇚o 쿔mportar as Fotos dos Funcionarios                          �
쳐컴컴컴컴컵컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
쿞intaxe   �<vide parametros formais>									�
쳐컴컴컴컴컵컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
쿛arametros�<vide parametros formais>									�
쳐컴컴컴컴컵컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
쿢so       쿒enerico                      								�
읕컴컴컴컴컨컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�/*/
Static Function GetSraImg( lShowLog )

Local aLogTitle		:= {}
Local aLogFile		:= {}

Local a_fOpcoesGet

Local b_fOpcoes
Local bMakeLog

/*/
旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
쿏isponibiliza Dialog para a Escolha do Diretorio              �
읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸/*/
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
	旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
	쿣erifica se o Diretorio Foi Selecionado					   �
	읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸/*/
	IF Empty( cPath )
		MsgInfo( OemToAnsi( "N�o foi poss�vel encontrar o diret�rio de imagens" ) )
		Break
	EndIF

	/*/
	旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
	쿚btem os arquivos a serem importados .JPG					   �
	읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸/*/
	cPathFile	:= ( cPath + cMaskJPG )
	aFilesJPG	:= Array( aDir( cPathFile ) )
	nFilesJPG	:= aDir( cPathFile , aFilesJPG )

	/*/
	旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
	쿚btem os arquivos a serem importados .JPEG					   �
	읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸/*/
	cPathFile	:= ( cPath + cMaskJPEG )
	aFilesJPEG	:= Array( aDir( cPathFile ) )
	nFilesJPEG	:= aDir( cPathFile , aFilesJPEG )

	/*/
	旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
	쿚btem os arquivos a serem importados .BMP					   �
	읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸/*/
	cPathFile	:= ( cPath + cMaskBMP )
	aFilesBMP	:= Array( aDir( cPathFile ) )
	nFilesBMP	:= aDir( cPathFile , aFilesBMP )

	nFiles		:= ( nFilesJPG + nFilesJPEG + nFilesBMP )

	/*/
	旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
	쿞e nao existirem arquivos a serem importados abandona         �
	읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸/*/
	IF ( nFiles == 0 )
		MsgInfo( "N�o Existem Imagens a serem importadas" )
		Break
	EndIF

	/*/
	旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
	쿢nifica os arquivos                                           �
	읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸/*/
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
			MsgInfo( OemToAnsi( "Importa豫o Cancelada Pelo Usu�rio." ) )
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
	旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
	쿞e nao existirem arquivos a serem importados abandona         �
	읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸/*/
	nFiles	:= Len( aFiles )
	IF ( nFiles == 0 )
		MsgInfo( "N�o Existem Imagens a serem importadas" )
		Break
	EndIF

	/*/
	旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
	� Seta o Numero de Elementos da 1a BarGauge					   �
	읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸/*/
	BarGauge1Set( nFiles )

	/*/
	旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
	� Seta o Repositorio de Imagens que sera utilizado			   �
	읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸/*/
	SetRepName( "SIGAADV" )

		/*/
		旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
		� Libera imagens Pendentes									   �
		읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸/*/
		FechaReposit()	//For뇇 o Fechamento o Repositorio de Imangens
			PackRepository()
		FechaReposit()	//For뇇 o Fechamento o Repositorio de Imangens

	/*/
	旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
	� Seta o Repositorio de Imagens que sera utilizado			   �
	읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸/*/
	SetRepName( "SIGAADV" )

	/*/
	旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
	� Retorna a Ordem do Indice a ser utilizado conforme expressao �
	읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸/*/
	nSraOrder := RetOrder( "SRA" , "RA_FILIAL+RA_MAT" ) 

	/*/
	旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
	� Seta a Ordem para o SRA									   �
	읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸/*/
	SRA->( dbSetOrder( nSraOrder ) )        //erro aqui = NIL

	/*/
	旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
	� Efetua um Laco para processar Todos os arquivos a serem impor�
	� tados														   �
	읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸/*/
	For nFile := 1 To nFiles
		/*/
		旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
		� Obtem o Nome do arquivo a ser Importado					   �
		읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸/*/
		cFile		:= aFiles[ nFile ]
		/*/
		旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
		� Concatena o "Path" do arquivo com o proprio arquivo		   �
		읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸/*/
		cPathFile	:= ( cPath + cFile )
		/*/
		旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
		쿘onsta o Texto que sera apresentado no Dialog de processamento�
		읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸/*/
		cMsgIncProc	:= "Importando Imagem: "
		cMsgIncProc	+= cPathFile
		/*/
		旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
		쿔ncrementa a Regua de Processamento						   �
		읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸/*/
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
		旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
		� Efetiva a Importacao das Imagens							   �
		읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸/*/
		IF !( DlgPutImg( cPathFile , cPath , cFile ) )
			/*/
			旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
			� Se nao conseguiu importar a imagem adiciona ao Log		   �
			읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸/*/
			aAdd( aLogFile , ( "Nao foi Possivel Adicionar a Imagem: " + cPathFile ) )
		EndIF
	Next nFile

	/*/
	旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
	� Libera imagens Pendentes									   �
	읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸/*/
	FechaReposit()	//For뇇 o Fechamento o Repositorio de Imangens
		PackRepository()
	FechaReposit()	//For뇇 o Fechamento o Repositorio de Imangens

End Sequence

/*/
旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
� Se ocorreu alguma inconsistencia na importacao das imagens   �
읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸/*/
IF !Empty( aLogFile )

	/*/
	旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
	� Define o Titulo para o Relatorio de LOG					   �
	읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸/*/
	cTitulo := "Inconsistencias na Importacao de Fotos"
	aAdd( aLogTitle , cTitulo )
	/*/
	旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
	� Monta o Bloco para a Geracao do Log           			   �
	읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸/*/
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
	旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
	� Disponibiliza o Log de Inconsistencias			   		   �
	읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸/*/
	MsAguarde( bMakeLog , "Gerando o Log" )

	IF !( lShowLog )
		MsgInfo( OemToAnsi( "O Arquivo de Log foi gerado em: " + cPathLogFile ) )
	EndIF

EndIF

Return( NIL )

/*/
旼컴컴컴컴컫컴컴컴컴컴컴컴쩡컴컴쩡컴컴컴컴컴컴컴컴컴컴쩡컴컴컫컴컴컴컴컴�
쿑un뇚o    쿏lgPutImg     쿌utor쿘arinaldo de Jesus   � Data �13/05/2005�
쳐컴컴컴컴컵컴컴컴컴컴컴컴좔컴컴좔컴컴컴컴컴컴컴컴컴컴좔컴컴컨컴컴컴컴컴�
쿏escri뇚o 쿔mportar as Fotos dos Funcionarios                          �
쳐컴컴컴컴컵컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
쿞intaxe   �<vide parametros formais>									�
쳐컴컴컴컴컵컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
쿛arametros�<vide parametros formais>									�
쳐컴컴컴컴컵컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
쿢so       쿒enerico                      								�
읕컴컴컴컴컨컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�/*/
Static Function DlgPutImg( cPathFile , cPath , cFile )

Local bDialogInit

Local oDlg
Local oRepository

Local lPutOk := .T.

/*/
旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
� Monta Dialogo "Escondido" para possibilitar a importacao  das�
� imagens													   �
읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸/*/
DEFINE MSDIALOG oDlg FROM 0,0 TO 0,0 PIXEL

	/*/
	旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
	� Cria um Objeto do Tipo Repositorio						   �
	읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸/*/
	@ 000,000 REPOSITORY oRepository SIZE 0,0 OF oDlg

	/*/
	旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
	� Efetiva a importacao da imagem     						   �
	읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸/*/
	lPutOk		:= PutImg( oRepository , cPathFile , cPath , cFile )
	bDialogInit	:= { || oRepository:lStretch := .T. , oDlg:End() , oRepository := NIL , oDlg:= NIL }

/*/
旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
� Ativa e Fecha o Dialogo									   �
읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸/*/
ACTIVATE MSDIALOG oDlg ON INIT Eval( bDialogInit )

Return( lPutOk )

/*/
旼컴컴컴컴컫컴컴컴컴컴컴컴쩡컴컴쩡컴컴컴컴컴컴컴컴컴컴쩡컴컴컫컴컴컴컴컴�
쿑un뇚o    쿛utImg        쿌utor쿘arinaldo de Jesus   � Data �13/05/2005�
쳐컴컴컴컴컵컴컴컴컴컴컴컴좔컴컴좔컴컴컴컴컴컴컴컴컴컴좔컴컴컨컴컴컴컴컴�
쿏escri뇚o 쿒ravar a Imagem no Repositorio de Imagens e Vincula-la    ao�
�          쿯uncionario													�
쳐컴컴컴컴컵컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
쿞intaxe   �<vide parametros formais>									�
쳐컴컴컴컴컵컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
쿛arametros�<vide parametros formais>									�
쳐컴컴컴컴컵컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
쿢so       쿒enerico                      								�
읕컴컴컴컴컨컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�/*/
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
	旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
	� Verifica se o arquio de Imagem existe						   �
	읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸/*/
	IF !( lPutOk := File( cPathFile ) )
		Break
	EndIF

	/*/
	旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
	� Utiliza a funcao RetFileName() para retinar o Nome do arquivo�
	� sem o "path" e sem o Extenso								   �
	읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸/*/
   	cSraBitMap := RetFileName( cPathFile )

	/*/
	旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
	� Procura o Funcionario										   �
	읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸/*/
	lFound := SRA->( dbSeek( cSraBitMap , .F. ) )      
	/*/
	旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
	� Se nao Encontrou o Funcionario, abandona					   �
	읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸/*/
	IF !( lFound )
		Break
	EndIF

	/*/
	旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
	� Armazena o Recno   										   �
	읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸/*/
	nRecno := SRA->( Recno() )  //devera ter recno do registro OK

	/*/
	旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
	� Utiliza o "Method" :IsertBmp para inserir a imagem no  Reposi�
	� torio de Imagens do Protheus								   �
	읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸/*/
	lPutOk	:= ( cSraBitMap == oRepository:InsertBmp( cPathFile , NIL , @lPut ) )       //verificar poor que imagem nao salva

	/*/
	旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
	� Se adicionou a Imagem no Repositorio, vincula a imagem ao Fun�
	� cionario													   �
	읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸/*/
	IF (;
			!( lPutOk );	//Obtido a partir do Teste de Retorno do Metodo :InsertBmp()  //VERIFICAR POR QUE O MESMO NAO ESTA SALVANDO
			.and.;
			( lPut );	//Retornado por referencia pelo Metodo :InsertBmp() .T. Inseriu a Nova Imagem, caso contrario, .F.
		)	
		/*/
		旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
		� Garante o Posicionamento no Registro						   �
		읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸/*/
	   	SRA->( MsGoto( nRecno ) )
	 	/*/
		旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
		� Lock no Registro     										   �
		읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸/*/
		IF SRA->( lLock := RecLock( "SRA" , .F. ) )
			/*/
			旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
			� Vincula a Imagem     										   �
			읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸/*/
			SRA->RA_BITMAP := cSraBitMap        //nesse ponto efetua grava豫o ALTERAR PARA QUE INSIRA CODIGO CORRETAMENTO
			/*/
			旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
			� Atualiza o Vinculo da Imagem								   �
			읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸/*/
	    	oRepository:LoadBmp( cSraBitMap )
			oRepository:Refresh()
			/*/
			旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
			� Libera o Registro    										   �
			읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸/*/
			SRA->( MsUnLock() )
			/*/
			旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
			� Move a Imagem para um Diretorio "Backup"					   �
			읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸/*/
			MoveFile( cPathFile , cPath , cFile )
		EndIF
	EndIF

End Sequence

/*/
旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
� Retona se Conseguiu Gravar a Imagem     					   �
읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸/*/
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
旼컴컴컴컴컫컴컴컴컴컴컴컴쩡컴컴쩡컴컴컴컴컴컴컴컴컴컴쩡컴컴컫컴컴컴컴컴�
쿑un뇚o    쿘oveFile	  쿌utor쿘arinaldo de Jesus   � Data �13/05/2005�
쳐컴컴컴컴컵컴컴컴컴컴컴컴좔컴컴좔컴컴컴컴컴컴컴컴컴컴좔컴컴컨컴컴컴컴컴�
쿏escri뇚o 쿘over as Imagens que foram importadas para o Repositorio   e�
�          퀆inculadas ao Funcionario para um diretorio "BackUp"		�
쳐컴컴컴컴컵컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
쿞intaxe   �<vide parametros formais>									�
쳐컴컴컴컴컵컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
쿛arametros�<vide parametros formais>									�
쳐컴컴컴컴컵컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
쿢so       쿒enerico                      								�
읕컴컴컴컴컨컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�/*/
Static Function MoveFile( cPathFile , cPath , cFile )

Local cNewPath
Local cNewPathFile

Begin Sequence

	/*/
	旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
	� Define o "Path" para "Backup" das imagens					   �
	읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸/*/
	cNewPath := ( cPath + "BACK\" )

	/*/
	旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
	� Verifica se o "Path" para "Backup" existe e, se nao  existir,�
	� cria-o													   �
	읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸/*/
	IF !( DirMake( cNewPath ) )
		Break
	EndIF

	/*/
	旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
	� Define o novo "Path" e nome do arquivo. 					   �
	읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸/*/
	cNewPathFile := ( cNewPath + cFile )

	/*/
	旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
	� Move o arquivo para o "Path" de "Backup"					   �
	읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸/*/
	FileMove( cPathFile , cNewPathFile )

End Sequence

Return( NIL )

/*/
旼컴컴컴컴컫컴컴컴컴컴컴컴쩡컴컴쩡컴컴컴컴컴컴컴컴컴컴쩡컴컴컫컴컴컴컴컴�
쿑un뇚o    쿐qualFile     쿌utor쿘arinaldo de Jesus   � Data �29/03/2005�
쳐컴컴컴컴컵컴컴컴컴컴컴컴좔컴컴좔컴컴컴컴컴컴컴컴컴컴좔컴컴컨컴컴컴컴컴�
쿏escri뇚o 쿣erifica se Dois Arquivos sao Iguais                        �
쳐컴컴컴컴컵컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
쿞intaxe   �<vide parametros formais>									�
쳐컴컴컴컴컵컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
쿛arametros�<vide parametros formais>									�
쳐컴컴컴컴컵컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
쿢so       쿒enerico                      								�
읕컴컴컴컴컨컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�/*/
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
旼컴컴컴컴컫컴컴컴컴컴컴컴쩡컴컴쩡컴컴컴컴컴컴컴컴컴컴쩡컴컴컫컴컴컴컴컴�
쿑un뇚o    쿏irMake       쿌utor쿘arinaldo de Jesus   � Data �29/03/2005�
쳐컴컴컴컴컵컴컴컴컴컴컴컴좔컴컴좔컴컴컴컴컴컴컴컴컴컴좔컴컴컨컴컴컴컴컴�
쿏escri뇚o 쿎ria um Diretorio                                           �
쳐컴컴컴컴컵컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
쿞intaxe   �<vide parametros formais>									�
쳐컴컴컴컴컵컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
쿛arametros�<vide parametros formais>									�
쳐컴컴컴컴컵컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
쿢so       쿒enerico                      								�
읕컴컴컴컴컨컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�/*/
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
旼컴컴컴컴컫컴컴컴컴컴컴컴쩡컴컴쩡컴컴컴컴컴컴컴컴컴컴쩡컴컴컫컴컴컴컴컴�
쿑un뇚o    쿑ileMove      쿌utor쿘arinaldo de Jesus   � Data �29/03/2005�
쳐컴컴컴컴컵컴컴컴컴컴컴컴좔컴컴좔컴컴컴컴컴컴컴컴컴컴좔컴컴컨컴컴컴컴컴�
쿏escri뇚o 쿘over um arquivo de Diretorio                               �
쳐컴컴컴컴컵컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
쿞intaxe   �<vide parametros formais>									�
쳐컴컴컴컴컵컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
쿛arametros�<vide parametros formais>									�
쳐컴컴컴컴컵컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
쿢so       쿒enerico                      								�
읕컴컴컴컴컨컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�/*/
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
