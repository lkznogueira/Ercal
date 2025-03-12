#INCLUDE "PROTHEUS.CH"
#INCLUDE "apwizard.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ                                                             
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณImport    บAutor  ณCarlos Daniel   บ Data ณ  18/08/12       บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Programa de importacao de tabelas                          บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Protheus 10/11                                             บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function Import

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณDeclaracao de variaveis                                 ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู  
Local oWizard
Local nMetGlob
Local nMetParc
Local oRadioArq
Local nRadioArq		:= 1
Local cText
Local cFile			:= replicate( " ", 80 )
Local cHeader 		:= "Importa็ใo de dados"
Local cTpArq		:= "Delimitado (*.csv)|*.CSV|"
Local cDelim		:= AllTrim(SuperGetMV("MV_TPDELI",.F.,';'))
Local nLinCabec		:= 1 // Padrใo sem linha de cabe็alho
Local cCabec		:= "" // String com o cabe็alho do arquivo original, se houver
Local nQtdCab		:= 1 // String com o cabe็alho do arquivo original, se houver
Local cNmAlias		:= "Clientes (SA1)"
Local cTipo			:= "1"

Private INCLUI	:= .T.
Private ALTERA	:= .F.

cText 	:= 	 "Esta rotina tem por objetivo importar registros, atrav้s " + ; 
			 "de um arquivo padrใo CSV (delimitado) , e armazena-los na tabela "+ ; 
			 "correspondente do sistema."+ CRLF + ; 
			 "Os nomes das colunas devem ser os mesmos nomes de campos a serem atualizados."+ CRLF + CRLF + ; 
			 "Ao final da importa็ใo serแ gerado um arquivo de log contendo as "+ ; 
			 "inconsist๊ncias."

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณPrimeiro Painel - Abertura     ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	DEFINE WIZARD oWizard 	TITLE "Import็ใo de dados" ;
							HEADER cHeader ; 
							MESSAGE "Apresenta็ใo." ;
							TEXT cText ;
							NEXT { || .T. } ;
							FINISH {|| .T.} PANEL
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณSegundo Painel - Arquivo e Contrato ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	CREATE PANEL oWizard 	HEADER cHeader ;
							MESSAGE "Selecione os tabela que deseja importar" ;
							BACK {|| .T. } ;
							NEXT {|| .T. } ;
							FINISH {|| .F. } ;
							PANEL         
	
	oPanel := oWizard:GetPanel( 2 )
	
	@ 15, 08 GROUP oGrpCon 	TO 140, 230 LABEL "Cadastro a ser importado" OF oPanel PIXEL DESIGN
	     
	@ 25,35 Radio oRadioArq Var nRadioArq Items "Clientes (SA1)",;
												"Produtos (SB1)",;
												"Fornecedores (SA2)",;
												"Vendedores (SA3)",;
												"Contas a Receber - em aberto (SE1)",;
												"Contas a Pagar - em aberto (SE2)",;
												"Saldos Iniciais - Estoque (SB9)",;
												"Saldos Lote/SubLote (SD5)",;
												"Equipamentos (NNB)",;
												"TES (SF4)",;
												"ATIVOS SN1/SN3",;
												"TRANSPORTADORA SA4";
											   	3D 	Size 170,10 Of oPanel PIXEL DESIGN ;
												ON CHANGE ImpChgRadio(nRadioArq,@cNmAlias)

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณSegundo Painel - Arquivo e Contrato ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	CREATE PANEL oWizard 	HEADER cHeader ;
							MESSAGE "Selecione o arquivo para importa็ใo." ;
							BACK {|| .T. } ;
							NEXT {|| ! empty( cDelim ) .and. ! empty( cFile ) } ;
							FINISH {|| .F. } ;
							PANEL         
	
	oPanel := oWizard:GetPanel( 3 )
	
	@ 10, 08 GROUP oGrpCon 	TO 40, 280 LABEL "Selecione um arquivo." ; 
							OF oPanel ;
							PIXEL ;
	     					DESIGN

	@ 20, 15 MSGET oArq 	VAR cFile WHEN .F. OF oPanel SIZE 140, 10 PIXEL ;
							MESSAGE "Utilize o botใo ao lado para selecionar" ; 

	DEFINE SBUTTON oButArq 	FROM 21, 160 ;
					 		TYPE 14 ;
					 		ACTION cFile := cGetFile(cTpArq, , 0, "SERVIDOR\", .T., GETF_LOCALFLOPPY + GETF_LOCALHARD + GETF_NETWORKDRIVE) ; 
					 		OF oPanel ;
					 		ENABLE
	
	@ 50, 08 GROUP oGrpCon 	TO 130, 280 LABEL "Informe as configura็๕es do arquivo." ; 
							OF oPanel ;
							PIXEL ;
	     					DESIGN
	     
  	@ 60,20 SAY "Delimitador" OF oPanel SIZE 35,8 PIXEL   
	@ 60,60 MSGET oDelim	VAR cDelim  ;
							PICTURE "@!" ;
							VALID !empty(cDelim) ;
							MESSAGE "Informe um delimitador de campo." ; 
							OF oPanel SIZE 10,8 PIXEL 
                         	
  	@ 80,20 SAY "Tipo" OF oPanel SIZE 35,8 PIXEL   
	@ 80,60 COMBOBOX oTipo  Var cTipo ITEMS {"1=Somente Log","2=Log + Importa็ใo"} 	SIZE 200,010 OF oPanel PIXEL  

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณTerceiro Painel - Confirmacao  / Processamento ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	CREATE PANEL oWizard 	HEADER cHeader ;
							MESSAGE "Confirma็ใo dos dados e inํcio de processamento." ; 
							BACK {|| .T. } ;
							NEXT {|| .T. } ;
							FINISH {|| .F. } ;
							PANEL         
							
	oPanel := oWizard:GetPanel( 4 )

	@ 010, 010 SAY "Arquivo" OF oPanel SIZE 140, 8 PIXEL   
	@ 010, 050 SAY cFile  OF oPanel SIZE 140, 8 COLOR CLR_HBLUE PIXEL  
	
	@ 030, 010 SAY  "Delimitador" OF oPanel SIZE 140, 8 PIXEL   
	@ 030, 050 SAY  cDelim  OF oPanel SIZE 140, 8 COLOR CLR_HBLUE PIXEL	


	@ 050, 010 SAY  "Alias" OF oPanel SIZE 140, 8 PIXEL   
	@ 050, 050 SAY  cNmAlias  OF oPanel SIZE 140, 8 COLOR CLR_HBLUE PIXEL	


	@ 070, 010 SAY  "Tipo Proc.:" OF oPanel SIZE 140, 8 PIXEL   
	@ 070, 050 SAY  IIf(cTipo=="1","Somente Log","Log+Importa็ใo")  OF oPanel SIZE 140, 8 COLOR CLR_HBLUE PIXEL	
                                      

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณQuarto Painel - Processamento                  ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	CREATE PANEL oWizard 	HEADER cHeader ;
							MESSAGE "Processamento da Importa็ใo." ; 
							BACK {|| .F. } ;
							NEXT {|| .T. } ;
							FINISH {|| .T. } ;
							EXEC {|| CursorWait(), IMPCADPro( oMetGlob, nRadioArq, cFile, cDelim, cTipo ), CursorArrow() } ;
							PANEL 
							        
	oPanel := oWizard:GetPanel( 5 )

	@ 25, 30 SAY "Importa็ใo" OF oPanel SIZE 140, 8 PIXEL   
	@ 40, 30 METER oMetGlob 	VAR nMetGlob ;
								TOTAL 100 ;
								SIZE 224,10 OF oPanel PIXEL UPDATE DESIGN ;
								BARCOLOR CLR_BLACK,CLR_WHITE ;
								COLOR CLR_WHITE,CLR_BLACK ;
							 	NOPERCENTAGE 

	
ACTIVATE WIZARD oWizard CENTER

Return NIL


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณIMPCADPro บAutor  ณCarlos Daniel   บ Data ณ  18/08/12       บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณImportacao do arquivo selecionado                           บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Totvs                                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function IMPCADPro( oMetGlob, nRadioArq, cFile, cDelim,cTipo )

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Declaracao de Variaveis                                             ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Local aArea		:= GetArea()
Local lFirst	:= .T.
Local cLinha 	:= ""
Local aHeader	:= {}
Local nHdl    	:= 	0
Local cEnvServ	:= GetEnvServer()
Local cIniFile	:= GetADV97()
Local cEnd		:= GetPvProfString(cEnvServ,"StartPath","",cIniFile)   
Local cDtHr 	:= DtoS(dDataBase)+"-"+Substr(time(),1,2)+"-"+Substr(time(),4,2)+"-"+Substr(time(),7,2)
Local cPath		:= "\IMPORT\"
Local cTipoLog	:= "Import_"
Local cNomeLog	:=	cPath+cTipoLog+cDtHr+"_Log.txt"
Local cArq		:=	cEnd+cNomeLog              
Local cLin		:= ""   
Local cCdAlias	:= ""
Local nQtReg	:= 0
Local nQtNOk	:= 0
Local nQtOk		:= 0
Local aLog		:= {}
Local lGrava	:= (cTipo == "2")   
Local cRotina	:= ""
Local nCont		:= 0

MAKEDIR(cEnd+cPath)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณValidacao do arquivo para importacao             ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

If !File(cFile) .OR. Empty(cFile)
	ApMsgStop("Problemas com arquivo informado!")
	RestArea(aArea)
	Return
EndIf


//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณIdentifica Alias de importacao                      ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Do Case
	Case nRadioArq == 1		// "Clientes (SA1)",;
		cCdAlias	:= "SA1"
		cRotina		:= "MATA030"

	Case nRadioArq == 2		// "Produtos (SB1)",;
		cCdAlias	:= "SB1"
		cRotina		:= "MATA010"

	Case nRadioArq == 3		// "Fornecedores (SA2)",;
		cCdAlias	:= "SA2"
		cRotina		:= "MATA020"

	Case nRadioArq == 4		// "Vendedores (SA3)",;
		cCdAlias	:= "SA3"
		cRotina		:= "MATA040"

	Case nRadioArq == 5		// "Contas a Receber - em aberto (SE1)",;
		cCdAlias	:= "SE1"
		cRotina		:= "FINA040"

	Case nRadioArq == 6		// "Contas a Pagar - em aberto (SE2)" 
		cCdAlias	:= "SE2"
		cRotina		:= "FINA050"

	Case nRadioArq == 7		// "Saldos Iniciais - Estoque (SB9)"
		cCdAlias	:= "SB9"
		cRotina		:= "MATA220"

	Case nRadioArq == 8		// "Saldos Lote/SubLote (SD5)"
		cCdAlias	:= "SD5"
		cRotina		:= "MATA390"
	Case nRadioArq == 9		// "Equipamentos (NNB)"
		cCdAlias	:= "NNB"
		cRotina		:= "AGRA025"
	Case nRadioArq == 10		// "CADASTRO DE TES (SF4)"
		cCdAlias	:= "SF4"
		cRotina		:= "MATA080"
	Case nRadioArq == 11		// "ATIVO SN1 / SN3
		cCdAlias	:= "SN1,SN3"
		cRotina		:= "ATFA010"
	Case nRadioArq == 12		// "TRANSPORTADRA (SA4)",;
		cCdAlias	:= "SA4"
		cRotina		:= "MATA050"
	OtherWise
		ApMsgStop("Nao existe tratamento para importa็ใo deste tipo de arquivo!")
		Return
EndCase



//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณInicia Log                            ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
AAdd(aLog, Replicate( '=', 80 ) )
AAdd(aLog, 'INICIANDO O LOG - I M P O R T A C A O   D E   D A D O S' )
AAdd(aLog, Replicate( '-', 80 ) )
AAdd(aLog, 'DATABASE...........: ' + DtoC( dDataBase ) )
AAdd(aLog, 'DATA...............: ' + DtoC( Date() ) )
AAdd(aLog, 'HORA...............: ' + Time() )
AAdd(aLog, 'ENVIRONMENT........: ' + GetEnvServer() )
AAdd(aLog, 'PATCH..............: ' + GetSrvProfString( 'StartPath', '' ) )
AAdd(aLog, 'ROOT...............: ' + GetSrvProfString( 'RootPath', '' ) )
AAdd(aLog, 'VERSรO.............: ' + GetVersao() )
AAdd(aLog, 'MำDULO.............: ' + 'SIGA' + cModulo )
AAdd(aLog, 'EMPRESA / FILIAL...: ' + SM0->M0_CODIGO + '/' + SM0->M0_CODFIL )
AAdd(aLog, 'NOME EMPRESA.......: ' + Capital( Trim( SM0->M0_NOME ) ) )
AAdd(aLog, 'NOME FILIAL........: ' + Capital( Trim( SM0->M0_FILIAL ) ) )
AAdd(aLog, 'USUมRIO............: ' + SubStr( cUsuario, 7, 15 ) )
AAdd(aLog, 'TABELA IMPORT......: ' + cCdAlias )
AAdd(aLog, 'ARQUIVO IMPORT.....: ' + cFile )
AAdd(aLog, 'DELIMITADOR........: ' + cDelim )
AAdd(aLog, 'MODO PROCESSAMENTO.: ' + IIf(lGrava,"Atualizacao","Simulacao") )
AAdd(aLog, Replicate( ':', 80 ) )
AAdd(aLog, '' )

AAdd(aLog, "Import = INICIO - Data "+DtoC(dDataBase)+ " as "+Time() )

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณLeitura do arquivo                        ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
FT_FUSE(cFile)
nTot := FT_FLASTREC()
nAtu := 0

oMetGlob:SetTotal(nTot)
CursorWait()     

FT_FGOTOP()
While !FT_FEOF()
	nAtu++
	oMetGlob:Set(nAtu)

	cLinha := LeLinha() //FT_FREADLN()
	
	If Empty(cLinha)
		FT_FSKIP()
		Loop
	EndIf

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณTratamento de colunas                     ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	aCols := {}
	aCols := TrataCols(cLinha,cDelim)
	If lFirst
		aHeader := aClone(aCols)
		lFirst := .F.

		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณValida nomes das colunas                   ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		cCpos := ImpVldCols(cCdAlias,aHeader)
		If !Empty(cCpos)
			ApMsgStop("Problemas na estrutura do arquivo, faltam as seguintes colunas "+cCpos)
			Return
		EndIf

	Else

		nQtReg++


		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณValidacao de campos obrigatorios                     ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		cMsg := ImpObrigat(cCdAlias,aCols,aHeader)
		If !Empty(cMsg)
			AtuLog("NO MOT: CAMPOS OBRIGATORIOS - REGISTRO IGNORADO - "+cMsg,@aLog,nAtu)
			nQtNOk++
			FT_FSKIP()
			Loop
		EndIf
	
	
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณChamada de rotina automatica de inclusao                ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		If lGrava
			aRet := {}
			aRet := ImpGrava(cCdAlias,cRotina,aCols,aHeader)
			If aRet[1]
				nQtOk++
				AtuLog("OK MOT:REGISTRO INCLUIDO"+aRet[2],@aLog,nAtu)
			
			Else
				AtuLog("NO MOT: PROBLEMAS NA GRAVACAO ROTINA AUTOMATICA - "+cRotina+" - "+aRet[2],@aLog,nAtu)
				nQtNOk++
			
			EndIF
		Else
			nQtOk++
			AtuLog("OK MOT:REGISTRO INCLUIDO",@aLog,nAtu)
		EndIf
	EndIf
	
	FT_FSKIP()
End
FT_FUSE()

AAdd(aLog, "Import = Total de Registros = "+ Alltrim(Str(nQtReg)))
AAdd(aLog, "Import = Registros Nao importados = "+ Alltrim(Str(nQtNOk)))
AAdd(aLog, "Import = Registros importados = "+ Alltrim(Str(nQtOk)))


AAdd(aLog, "Import = FIM Data "+DtoC(dDataBase)+ " as "+Time() )

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณFinaliza arquivo de Log                         ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
nHdl  := 	fCreate(cArq)
If nHdl == -1
	MsgAlert("O arquivo  "+cArq+" nao pode ser criado!","Atencao!")
	fClose(nHdl)
	fErase(cArq)
	RestArea(aArea)
 	Return()
EndIf

For nCont:=1 to Len(aLog)
	
	cLin += aLog[nCont] + CHR(13)+CHR(10)
	
	If fWrite(nHdl,cLin,Len(cLin)) != Len(cLin)
		fClose(nHdl)
	    fErase(cArq)
	    cLin:=""
		RestArea(aArea)
	    Return()
	EndIf
	
	cLin:=""
Next

fClose(nHdl)

ApMsgInfo("Verifique arquivo de log "+cArq)

RestArea(aArea)
Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณAtuLog    บAutor  ณCarlos Daniel   บ Data ณ  18/08/12       บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณAtualiza Array de Log                                       บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Totvs                                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function AtuLog(cMsg,aLog,nAtu)

AAdd(aLog, " Import = Linha "+StrZero(nAtu,12)+" = "+;
			" LOG = "+cMsg )
Return




/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณLeLinha   บAutor  ณCarlos Daniel   บ Data ณ  18/08/12       บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณTratamento de leitura de linha TXT, principalmente para     บฑฑ
ฑฑบ          ณcasos de ultrapassar 1Kb por linha                          บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Totvs                                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function LeLinha()
Local cLinhaTmp := ""
Local cLinhaM100 := ""

cLinhaTmp := FT_FReadLN()

If !Empty(cLinhaTmp)
	cIdent:= Substr(cLinhaTmp,1,1)
	If Len(cLinhaTmp) < 1023
		cLinhaM100 := cLinhaTmp
	Else
		cLinAnt := cLinhaTmp
		cLinhaM100 += cLinAnt
		Ft_FSkip()
		cLinProx:= Ft_FReadLN()
		If Len(cLinProx) >= 1023 .and. Substr(cLinProx,1,1) <> cIdent
			While Len(cLinProx) >= 1023 .and. Substr(cLinProx,1,1) <> cIdent .and. !Ft_fEof()
				cLinhaM100 += cLinProx
				Ft_FSkip()
				cLinProx := Ft_fReadLn()
				If Len(cLinProx) < 1023 .and. Substr(cLinProx,1,1) <> cIdent
					cLinhaM100 += cLinProx
				Endif
			Enddo
		Else
			cLinhaM100 += cLinProx
		Endif
	Endif
Endif

Return(cLinhaM100)





/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTrataCols    บAutor  ณCarlos Daniel   บ Data ณ  18/08/12    บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRetorna array com as colunas da linha informada             บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Totvs                                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function TrataCols(cLinha,cSep)
Local aRet 		:= {}
Local nPosSep	:= 0


nPosSep	:= At(cSep,cLinha)
While nPosSep <> 0
	AAdd(aRet, SubStr(cLinha,1,nPosSep-1)  )
	cLinha := SubStr(cLinha,nPosSep+1)
 	nPosSep	:= At(cSep,cLinha)
EndDo	
AAdd(aRet, cLinha )
Return aRet



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRetCol    บAutor  ณCarlos Daniel   บ Data ณ  18/08/12       บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRetorna conteudo de coluna especifica                       บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Totvs                                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function RetCol(cCpo,aCols,aHeader)
Local cRet 	:= ""
Local nPos	:= 0
Local aSX3Area	:= SX3->(GetArea())
Local i	

nPos := AScan(aHeader,{|x| Upper(AllTrim(x)) == Upper(Alltrim(cCpo)) })
// Inicialize uma variแvel para a string final
cString := ""

// Loop atrav้s do array
FOR i := 1 TO LEN(aCols)
    // Adicione cada item do array เ string, separando por vํrgula
    cString += aCols[i] + ", "
END

MemoWrite("C:\TEMP\IMPORTnPos.txt",cString)//para salvar array se der erro
If !Empty(nPos)
	If Upper(AllTrim(aCols[nPos])) <> "NULL"

		DbSelectArea("SX3")
		DbSetOrder(2)
		If MsSeek(cCpo)
			If SX3->X3_TIPO == "D"
				cRet := StoD(AllTrim(aCols[nPos]))
			ElseIf SX3->X3_TIPO == "N"
				cRet := Val(AllTrim(aCols[nPos]))
			Else
				cRet := PadR(Upper(AllTrim(aCols[nPos])),TamSX3(cCpo)[1])
			EndIf
		Else
			cRet := Upper(AllTrim(aCols[nPos]))
		EndIf
	EndIf
EndIf

SX3->(RestArea(aSX3Area))
Return cRet



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณImpVldCols    บAutor  ณCarlos Daniel   บ Data ณ  18/08/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณAnalise de colunas obrigatorias para cada alias             บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Totvs                                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function ImpVldCols(cCdAlias,aHeader)
Local cRet 		:= ""
//Local cFilSA1 	:= ""

Do Case
	Case cCdAlias == "SA1"
		
		If AScan(aHeader,{|x| Upper(AllTrim(x)) == Upper(Alltrim("A1_PESSOA")) })	== 0
			cRet += IIf(Empty(cRet),"","/")+"A1_PESSOA"
		EndIf
		If AScan(aHeader,{|x| Upper(AllTrim(x)) == Upper(Alltrim("A1_CGC")) })	== 0
			cRet += IIf(Empty(cRet),"","/")+"A1_CGC"
		EndIf
		If AScan(aHeader,{|x| Upper(AllTrim(x)) == Upper(Alltrim("A1_NOME")) })	== 0
			cRet += IIf(Empty(cRet),"","/")+"A1_NOME"
		EndIf
		If AScan(aHeader,{|x| Upper(AllTrim(x)) == Upper(Alltrim("A1_NREDUZ")) })	== 0
			cRet += IIf(Empty(cRet),"","/")+"A1_NREDUZ"
		EndIf
		If AScan(aHeader,{|x| Upper(AllTrim(x)) == Upper(Alltrim("A1_INSCR")) })	== 0
			cRet += IIf(Empty(cRet),"","/")+"A1_INSCR"
		EndIf
		If AScan(aHeader,{|x| Upper(AllTrim(x)) == Upper(Alltrim("A1_END")) })		== 0
			cRet += IIf(Empty(cRet),"","/")+"A1_END"
		EndIf
		If AScan(aHeader,{|x| Upper(AllTrim(x)) == Upper(Alltrim("A1_CEP")) })		== 0
			cRet += IIf(Empty(cRet),"","/")+"A1_CEP"
		EndIf
		If AScan(aHeader,{|x| Upper(AllTrim(x)) == Upper(Alltrim("A1_TIPO")) })	== 0
			cRet += IIf(Empty(cRet),"","/")+"A1_TIPO"
		EndIf
		If AScan(aHeader,{|x| Upper(AllTrim(x)) == Upper(Alltrim("A1_EST")) })		== 0
			cRet += IIf(Empty(cRet),"","/")+"A1_EST"
		EndIf
		If AScan(aHeader,{|x| Upper(AllTrim(x)) == Upper(Alltrim("A1_COD_MUN")) })		== 0
			cRet += IIf(Empty(cRet),"","/")+"A1_COD_MUN"
		EndIf
		If AScan(aHeader,{|x| Upper(AllTrim(x)) == Upper(Alltrim("A1_BAIRRO")) })		== 0
			cRet += IIf(Empty(cRet),"","/")+"A1_BAIRRO"
		EndIf 
		If AScan(aHeader,{|x| Upper(AllTrim(x)) == Upper(Alltrim("A1_INSCR")) })		== 0
			cRet += IIf(Empty(cRet),"","/")+"A1_INSCR"
		EndIf 
		If AScan(aHeader,{|x| Upper(AllTrim(x)) == Upper(Alltrim("A1_LC")) })		== 0
			cRet += IIf(Empty(cRet),"","/")+"A1_LC"
		EndIf
		If AScan(aHeader,{|x| Upper(AllTrim(x)) == Upper(Alltrim("A1_VENCLC")) })		== 0
			cRet += IIf(Empty(cRet),"","/")+"A1_VENCLC"
		EndIf
		
		
	Case cCdAlias == "SB1"

		If AScan(aHeader,{|x| Upper(AllTrim(x)) == Upper(Alltrim("B1_GRUPO")) })		== 0
			cRet += IIf(Empty(cRet),"","/")+"B1_GRUPO"
		EndIf		
		If AScan(aHeader,{|x| Upper(AllTrim(x)) == Upper(Alltrim("B1_COD")) })		== 0
			cRet += IIf(Empty(cRet),"","/")+"B1_COD"
		EndIf
		If AScan(aHeader,{|x| Upper(AllTrim(x)) == Upper(Alltrim("B1_DESC")) })	== 0
			cRet += IIf(Empty(cRet),"","/")+"B1_DESC"
		EndIf
		If AScan(aHeader,{|x| Upper(AllTrim(x)) == Upper(Alltrim("B1_TIPO")) })	== 0
			cRet += IIf(Empty(cRet),"","/")+"B1_TIPO"
		EndIf
		If AScan(aHeader,{|x| Upper(AllTrim(x)) == Upper(Alltrim("B1_UM")) })		== 0
			cRet += IIf(Empty(cRet),"","/")+"B1_UM"
		EndIf
		If AScan(aHeader,{|x| Upper(AllTrim(x)) == Upper(Alltrim("B1_LOCPAD")) })	== 0
			cRet += IIf(Empty(cRet),"","/")+"B1_LOCPAD"
		EndIf
		If AScan(aHeader,{|x| Upper(AllTrim(x)) == Upper(Alltrim("B1_E_SITUA")) })	== 0
			cRet += IIf(Empty(cRet),"","/")+"B1_E_SITUA"
		EndIf
		If AScan(aHeader,{|x| Upper(AllTrim(x)) == Upper(Alltrim("B1_POSIPI")) })	== 0
			cRet += IIf(Empty(cRet),"","/")+"B1_POSIPI"
		EndIf
		If AScan(aHeader,{|x| Upper(AllTrim(x)) == Upper(Alltrim("B1_ORIGEM")) })	== 0
			cRet += IIf(Empty(cRet),"","/")+"B1_ORIGEM"
		EndIf
		If AScan(aHeader,{|x| Upper(AllTrim(x)) == Upper(Alltrim("B1_GARANT")) })	== 0
			cRet += IIf(Empty(cRet),"","/")+"B1_GARANT" 
		EndIf 
		If AScan(aHeader,{|x| Upper(AllTrim(x)) == Upper(Alltrim("B1_XTPCON")) })	== 0
			cRet += IIf(Empty(cRet),"","/")+"B1_XTPCON" 
		EndIf 
				If AScan(aHeader,{|x| Upper(AllTrim(x)) == Upper(Alltrim("B1_LOCALIZ")) })	== 0
			cRet += IIf(Empty(cRet),"","/")+"B1_LOCALIZ" 
		EndIf 
				If AScan(aHeader,{|x| Upper(AllTrim(x)) == Upper(Alltrim("B1_GRTRIB")) })	== 0
			cRet += IIf(Empty(cRet),"","/")+"B1_GRTRIB" 
		EndIf

	Case cCdAlias == "SA2"

		If AScan(aHeader,{|x| Upper(AllTrim(x)) == Upper(Alltrim("A2_NOME")) })	== 0
			cRet += IIf(Empty(cRet),"","/")+"A2_NOME"
		EndIf
		If AScan(aHeader,{|x| Upper(AllTrim(x)) == Upper(Alltrim("A2_NREDUZ")) })	== 0
			cRet += IIf(Empty(cRet),"","/")+"A2_NREDUZ"
		EndIf
		If AScan(aHeader,{|x| Upper(AllTrim(x)) == Upper(Alltrim("A2_END")) })		== 0
			cRet += IIf(Empty(cRet),"","/")+"A2_END"
		EndIf
		If AScan(aHeader,{|x| Upper(AllTrim(x)) == Upper(Alltrim("A2_BAIRRO")) })		== 0
			cRet += IIf(Empty(cRet),"","/")+"A2_BAIRRO"
		EndIf
		If AScan(aHeader,{|x| Upper(AllTrim(x)) == Upper(Alltrim("A2_EST")) })		== 0
			cRet += IIf(Empty(cRet),"","/")+"A2_EST"
		EndIf
		If AScan(aHeader,{|x| Upper(AllTrim(x)) == Upper(Alltrim("A2_TIPO")) })	== 0
			cRet += IIf(Empty(cRet),"","/")+"A2_TIPO"
		EndIf
		If AScan(aHeader,{|x| Upper(AllTrim(x)) == Upper(Alltrim("A2_CGC")) })	== 0
			cRet += IIf(Empty(cRet),"","/")+"A2_CGC"
		EndIf
		If AScan(aHeader,{|x| Upper(AllTrim(x)) == Upper(Alltrim("A2_COD_MUN")) })	== 0
			cRet += IIf(Empty(cRet),"","/")+"A2_COD_MUN"
		EndIf
		If AScan(aHeader,{|x| Upper(AllTrim(x)) == Upper(Alltrim("A2_INSCR")) })	== 0
			cRet += IIf(Empty(cRet),"","/")+"A2_INSCR"
		EndIf
		If AScan(aHeader,{|x| Upper(AllTrim(x)) == Upper(Alltrim("A2_E_SITUA")) })	== 0
			cRet += IIf(Empty(cRet),"","/")+"A2_E_SITUA"
		EndIf
		If AScan(aHeader,{|x| Upper(AllTrim(x)) == Upper(Alltrim("A2_MSBLQL")) })	== 0
			cRet += IIf(Empty(cRet),"","/")+"A2_MSBLQL"
		EndIf
	Case cCdAlias == "SA4"

		If AScan(aHeader,{|x| Upper(AllTrim(x)) == Upper(Alltrim("A4_NOME")) })	== 0
			cRet += IIf(Empty(cRet),"","/")+"A4_NOME"
		EndIf
		If AScan(aHeader,{|x| Upper(AllTrim(x)) == Upper(Alltrim("A4_NREDUZ")) })	== 0
			cRet += IIf(Empty(cRet),"","/")+"A4_NREDUZ"
		EndIf


	Case cCdAlias == "SA3"

		If AScan(aHeader,{|x| Upper(AllTrim(x)) == Upper(Alltrim("A3_NOME")) })	== 0
			cRet += IIf(Empty(cRet),"","/")+"A3_NOME"
		EndIf

	Case cCdAlias == "SE1"

		If AScan(aHeader,{|x| Upper(AllTrim(x)) == Upper(Alltrim("E1_NUM")) })	== 0
			cRet += IIf(Empty(cRet),"","/")+"E1_NUM"
		EndIf
		If AScan(aHeader,{|x| Upper(AllTrim(x)) == Upper(Alltrim("E1_TIPO")) })	== 0
			cRet += IIf(Empty(cRet),"","/")+"E1_TIPO"
		EndIf
		If AScan(aHeader,{|x| Upper(AllTrim(x)) == Upper(Alltrim("E1_NATUREZ")) })	== 0
			cRet += IIf(Empty(cRet),"","/")+"E1_NATUREZ"
		EndIf
		If AScan(aHeader,{|x| Upper(AllTrim(x)) == Upper(Alltrim("E1_CLIENTE")) })	== 0
			cRet += IIf(Empty(cRet),"","/")+"E1_CLIENTE"
		EndIf
		If AScan(aHeader,{|x| Upper(AllTrim(x)) == Upper(Alltrim("E1_LOJA")) })	== 0
			cRet += IIf(Empty(cRet),"","/")+"E1_LOJA"
		EndIf
		If AScan(aHeader,{|x| Upper(AllTrim(x)) == Upper(Alltrim("E1_EMISSAO")) })	== 0
			cRet += IIf(Empty(cRet),"","/")+"E1_EMISSAO"
		EndIf
		If AScan(aHeader,{|x| Upper(AllTrim(x)) == Upper(Alltrim("E1_VENCTO")) })	== 0
			cRet += IIf(Empty(cRet),"","/")+"E1_VENCTO"
		EndIf
		If AScan(aHeader,{|x| Upper(AllTrim(x)) == Upper(Alltrim("E1_VENCREA")) })	== 0
			cRet += IIf(Empty(cRet),"","/")+"E1_VENCREA"
		EndIf
		If AScan(aHeader,{|x| Upper(AllTrim(x)) == Upper(Alltrim("E1_VALOR")) })	== 0
			cRet += IIf(Empty(cRet),"","/")+"E1_VALOR"
		EndIf
		If AScan(aHeader,{|x| Upper(AllTrim(x)) == Upper(Alltrim("E1_VLCRUZ")) })	== 0
			cRet += IIf(Empty(cRet),"","/")+"E1_VLCRUZ"
		EndIf

	Case cCdAlias == "SE2"

		If AScan(aHeader,{|x| Upper(AllTrim(x)) == Upper(Alltrim("E2_NUM")) })	== 0
			cRet += IIf(Empty(cRet),"","/")+"E2_NUM"
		EndIf
		If AScan(aHeader,{|x| Upper(AllTrim(x)) == Upper(Alltrim("E2_TIPO")) })	== 0
			cRet += IIf(Empty(cRet),"","/")+"E2_TIPO"
		EndIf
		If AScan(aHeader,{|x| Upper(AllTrim(x)) == Upper(Alltrim("E2_NATUREZ")) })	== 0
			cRet += IIf(Empty(cRet),"","/")+"E2_NATUREZ"
		EndIf
		If AScan(aHeader,{|x| Upper(AllTrim(x)) == Upper(Alltrim("E2_FORNECE")) })	== 0
			cRet += IIf(Empty(cRet),"","/")+"E2_FORNECE"
		EndIf
		If AScan(aHeader,{|x| Upper(AllTrim(x)) == Upper(Alltrim("E2_LOJA")) })	== 0
			cRet += IIf(Empty(cRet),"","/")+"E2_LOJA"
		EndIf
		If AScan(aHeader,{|x| Upper(AllTrim(x)) == Upper(Alltrim("E2_EMISSAO")) })	== 0
			cRet += IIf(Empty(cRet),"","/")+"E2_EMISSAO"
		EndIf
		If AScan(aHeader,{|x| Upper(AllTrim(x)) == Upper(Alltrim("E2_VENCTO")) })	== 0
			cRet += IIf(Empty(cRet),"","/")+"E2_VENCTO"
		EndIf
		If AScan(aHeader,{|x| Upper(AllTrim(x)) == Upper(Alltrim("E2_VENCREA")) })	== 0
			cRet += IIf(Empty(cRet),"","/")+"E2_VENCREA"
		EndIf
		If AScan(aHeader,{|x| Upper(AllTrim(x)) == Upper(Alltrim("E2_VALOR")) })	== 0
			cRet += IIf(Empty(cRet),"","/")+"E2_VALOR"
		EndIf
		If AScan(aHeader,{|x| Upper(AllTrim(x)) == Upper(Alltrim("E2_VLCRUZ")) })	== 0
			cRet += IIf(Empty(cRet),"","/")+"E2_VLCRUZ"
		EndIf

	Case cCdAlias == "SB9"

		If AScan(aHeader,{|x| Upper(AllTrim(x)) == Upper(Alltrim("B9_COD")) })	== 0
			cRet += IIf(Empty(cRet),"","/")+"B9_COD"
		EndIf
		If AScan(aHeader,{|x| Upper(AllTrim(x)) == Upper(Alltrim("B9_LOCAL")) })	== 0
			cRet += IIf(Empty(cRet),"","/")+"B9_LOCAL"
		EndIf
		If AScan(aHeader,{|x| Upper(AllTrim(x)) == Upper(Alltrim("B9_QINI")) })	== 0
			cRet += IIf(Empty(cRet),"","/")+"B9_QINI"
		EndIf

	Case cCdAlias == "SD5"

		If AScan(aHeader,{|x| Upper(AllTrim(x)) == Upper(Alltrim("D5_PRODUTO")) })	== 0
			cRet += IIf(Empty(cRet),"","/")+"D5_PRODUTO"
		EndIf
		If AScan(aHeader,{|x| Upper(AllTrim(x)) == Upper(Alltrim("D5_LOCAL")) })	== 0
			cRet += IIf(Empty(cRet),"","/")+"D5_LOCAL"
		EndIf
		If AScan(aHeader,{|x| Upper(AllTrim(x)) == Upper(Alltrim("D5_DATA")) })	== 0
			cRet += IIf(Empty(cRet),"","/")+"D5_DATA"
		EndIf
		If AScan(aHeader,{|x| Upper(AllTrim(x)) == Upper(Alltrim("D5_QUANT")) })	== 0
			cRet += IIf(Empty(cRet),"","/")+"D5_QUANT"
		EndIf
		If AScan(aHeader,{|x| Upper(AllTrim(x)) == Upper(Alltrim("D5_LOTECTL")) })	== 0
			cRet += IIf(Empty(cRet),"","/")+"D5_LOTECTL"
		EndIf
		If AScan(aHeader,{|x| Upper(AllTrim(x)) == Upper(Alltrim("D5_DTVALID")) })	== 0
			cRet += IIf(Empty(cRet),"","/")+"D5_DTVALID"
		EndIf
	Case cCdAlias == "NNB"

		If AScan(aHeader,{|x| Upper(AllTrim(x)) == Upper(Alltrim("NNB_CODIGO")) })	== 0
			cRet += IIf(Empty(cRet),"","/")+"NNB_CODIGO"
		EndIf
		If AScan(aHeader,{|x| Upper(AllTrim(x)) == Upper(Alltrim("NNB_DESCRI")) })	== 0
			cRet += IIf(Empty(cRet),"","/")+"NNB_DESCRI"
		EndIf
		If AScan(aHeader,{|x| Upper(AllTrim(x)) == Upper(Alltrim("NNB_PLACA")) })	== 0
			cRet += IIf(Empty(cRet),"","/")+"NNB_PLACA"
		EndIf
		If AScan(aHeader,{|x| Upper(AllTrim(x)) == Upper(Alltrim("NNB_TIPO")) })	== 0
			cRet += IIf(Empty(cRet),"","/")+"NNB_TIPO"
		EndIf
		If AScan(aHeader,{|x| Upper(AllTrim(x)) == Upper(Alltrim("NNB_CHASSI")) })	== 0
			cRet += IIf(Empty(cRet),"","/")+"NNB_CHASSI"
		EndIf
		If AScan(aHeader,{|x| Upper(AllTrim(x)) == Upper(Alltrim("NNB_SERIE")) })	== 0
			cRet += IIf(Empty(cRet),"","/")+"NNB_SERIE"
		EndIf
	Case cCdAlias == "SF4"

		If AScan(aHeader,{|x| Upper(AllTrim(x)) == Upper(Alltrim("F4_CODIGO")) })	== 0
			cRet += IIf(Empty(cRet),"","/")+"F4_CODIGO"
		EndIf
		If AScan(aHeader,{|x| Upper(AllTrim(x)) == Upper(Alltrim("F4_TIPO")) })	== 0
			cRet += IIf(Empty(cRet),"","/")+"F4_TIPO"
		EndIf
		If AScan(aHeader,{|x| Upper(AllTrim(x)) == Upper(Alltrim("F4_DUPLIC")) })	== 0
			cRet += IIf(Empty(cRet),"","/")+"F4_DUPLIC"
		EndIf
		If AScan(aHeader,{|x| Upper(AllTrim(x)) == Upper(Alltrim("F4_ESTOQUE")) })	== 0
			cRet += IIf(Empty(cRet),"","/")+"F4_ESTOQUE"
		EndIf
		If AScan(aHeader,{|x| Upper(AllTrim(x)) == Upper(Alltrim("F4_PODER3")) })	== 0
			cRet += IIf(Empty(cRet),"","/")+"F4_PODER3"
		EndIf
		If AScan(aHeader,{|x| Upper(AllTrim(x)) == Upper(Alltrim("F4_FINALID")) })	== 0
			cRet += IIf(Empty(cRet),"","/")+"F4_FINALID"
		EndIf
		If AScan(aHeader,{|x| Upper(AllTrim(x)) == Upper(Alltrim("F4_CF")) })	== 0
			cRet += IIf(Empty(cRet),"","/")+"F4_CF"
		EndIf
		If AScan(aHeader,{|x| Upper(AllTrim(x)) == Upper(Alltrim("F4_TEXTO")) })	== 0
			cRet += IIf(Empty(cRet),"","/")+"F4_TEXTO"
		EndIf
		If AScan(aHeader,{|x| Upper(AllTrim(x)) == Upper(Alltrim("F4_ICM")) })	== 0
			cRet += IIf(Empty(cRet),"","/")+"F4_ICM"
		EndIf
		If AScan(aHeader,{|x| Upper(AllTrim(x)) == Upper(Alltrim("F4_CREDICM")) })	== 0
			cRet += IIf(Empty(cRet),"","/")+"F4_CREDICM"
		EndIf
		If AScan(aHeader,{|x| Upper(AllTrim(x)) == Upper(Alltrim("F4_LFICM")) })	== 0
			cRet += IIf(Empty(cRet),"","/")+"F4_LFICM"
		EndIf
		If AScan(aHeader,{|x| Upper(AllTrim(x)) == Upper(Alltrim("F4_COMPL")) })	== 0
			cRet += IIf(Empty(cRet),"","/")+"F4_COMPL"
		EndIf
		If AScan(aHeader,{|x| Upper(AllTrim(x)) == Upper(Alltrim("F4_SITTRIB")) })	== 0
			cRet += IIf(Empty(cRet),"","/")+"F4_SITTRIB"
		EndIf
		If AScan(aHeader,{|x| Upper(AllTrim(x)) == Upper(Alltrim("F4_IPI")) })	== 0
			cRet += IIf(Empty(cRet),"","/")+"F4_IPI"
		EndIf
		If AScan(aHeader,{|x| Upper(AllTrim(x)) == Upper(Alltrim("F4_CREDIPI")) })	== 0
			cRet += IIf(Empty(cRet),"","/")+"F4_CREDIPI"
		EndIf
		If AScan(aHeader,{|x| Upper(AllTrim(x)) == Upper(Alltrim("F4_LFIPI")) })	== 0
			cRet += IIf(Empty(cRet),"","/")+"F4_LFIPI"
		EndIf
		If AScan(aHeader,{|x| Upper(AllTrim(x)) == Upper(Alltrim("F4_DESTACA")) })	== 0
			cRet += IIf(Empty(cRet),"","/")+"F4_DESTACA"
		EndIf
		If AScan(aHeader,{|x| Upper(AllTrim(x)) == Upper(Alltrim("F4_INCIDE")) })	== 0
			cRet += IIf(Empty(cRet),"","/")+"F4_INCIDE"
		EndIf
		If AScan(aHeader,{|x| Upper(AllTrim(x)) == Upper(Alltrim("F4_CTIPI")) })	== 0
			cRet += IIf(Empty(cRet),"","/")+"F4_CTIPI"
		EndIf
		If AScan(aHeader,{|x| Upper(AllTrim(x)) == Upper(Alltrim("F4_CSTPIS")) })	== 0
			cRet += IIf(Empty(cRet),"","/")+"F4_CSTPIS"
		EndIf
		If AScan(aHeader,{|x| Upper(AllTrim(x)) == Upper(Alltrim("F4_CSTCOF")) })	== 0
			cRet += IIf(Empty(cRet),"","/")+"F4_CSTCOF"
		EndIf
	
	Case cCdAlias == "SN1,SN3"

		If AScan(aHeader,{|x| Upper(AllTrim(x)) == Upper(Alltrim("N1_GRUPO")) })		== 0
			cRet += IIf(Empty(cRet),"","/")+"N1_GRUPO"
		EndIf		
		If AScan(aHeader,{|x| Upper(AllTrim(x)) == Upper(Alltrim("N1_CBASE")) })		== 0
			cRet += IIf(Empty(cRet),"","/")+"N1_CBASE"
		EndIf
		If AScan(aHeader,{|x| Upper(AllTrim(x)) == Upper(Alltrim("N1_ITEM")) })	== 0
			cRet += IIf(Empty(cRet),"","/")+"N1_ITEM"
		EndIf
		If AScan(aHeader,{|x| Upper(AllTrim(x)) == Upper(Alltrim("N1_QUANTD")) })	== 0
			cRet += IIf(Empty(cRet),"","/")+"N1_QUANTD"
		EndIf
		If AScan(aHeader,{|x| Upper(AllTrim(x)) == Upper(Alltrim("N1_AQUISIQ")) })		== 0
			cRet += IIf(Empty(cRet),"","/")+"N1_AQUISIQ"
		EndIf
		If AScan(aHeader,{|x| Upper(AllTrim(x)) == Upper(Alltrim("N1_DESCRIC")) })	== 0
			cRet += IIf(Empty(cRet),"","/")+"N1_DESCRIC"
		EndIf
		If AScan(aHeader,{|x| Upper(AllTrim(x)) == Upper(Alltrim("N1_CHAPA")) })	== 0
			cRet += IIf(Empty(cRet),"","/")+"N1_CHAPA"
		EndIf
		If AScan(aHeader,{|x| Upper(AllTrim(x)) == Upper(Alltrim("N1_VLAQUIS")) })	== 0
			cRet += IIf(Empty(cRet),"","/")+"N1_VLAQUIS"
		EndIf
	   /*	If AScan(aHeader,{|x| Upper(AllTrim(x)) == Upper(Alltrim("N1_SERIE")) })	== 0
			cRet += IIf(Empty(cRet),"","/")+"N1_SERIE"
		EndIf
		If AScan(aHeader,{|x| Upper(AllTrim(x)) == Upper(Alltrim("N1_NFISCAL")) })	== 0
			cRet += IIf(Empty(cRet),"","/")+"N1_NFISCAL"
		EndIf
		If AScan(aHeader,{|x| Upper(AllTrim(x)) == Upper(Alltrim("N1_PRODUTO")) })	== 0
			cRet += IIf(Empty(cRet),"","/")+"N1_PRODUTO"
		EndIf
		If AScan(aHeader,{|x| Upper(AllTrim(x)) == Upper(Alltrim("N1_LOCAL")) })	== 0
			cRet += IIf(Empty(cRet),"","/")+"N1_LOCAL"
		EndIf   */
		//SN3
		If AScan(aHeader,{|x| Upper(AllTrim(x)) == Upper(Alltrim("N3_TIPO")) })	== 0
			cRet += IIf(Empty(cRet),"","/")+"N3_TIPO"
		EndIf
		If AScan(aHeader,{|x| Upper(AllTrim(x)) == Upper(Alltrim("N3_HISTOR")) })	== 0
			cRet += IIf(Empty(cRet),"","/")+"N3_HISTOR"
		EndIf
		If AScan(aHeader,{|x| Upper(AllTrim(x)) == Upper(Alltrim("N3_CCONTAB")) })	== 0
			cRet += IIf(Empty(cRet),"","/")+"N3_CCONTAB"
		EndIf	
		If AScan(aHeader,{|x| Upper(AllTrim(x)) == Upper(Alltrim("N3_VORIG1")) })	== 0
			cRet += IIf(Empty(cRet),"","/")+"N3_VORIG1"
		EndIf	
		If AScan(aHeader,{|x| Upper(AllTrim(x)) == Upper(Alltrim("N3_CUSTBEM")) })	== 0
			cRet += IIf(Empty(cRet),"","/")+"N3_CUSTBEM"
		EndIf
		If AScan(aHeader,{|x| Upper(AllTrim(x)) == Upper(Alltrim("N3_CDEPREC")) })	== 0
			cRet += IIf(Empty(cRet),"","/")+"N3_CDEPREC"
		EndIf	
		If AScan(aHeader,{|x| Upper(AllTrim(x)) == Upper(Alltrim("N3_CCDEPR")) })	== 0
			cRet += IIf(Empty(cRet),"","/")+"N3_CCDEPR"
		EndIf	
		If AScan(aHeader,{|x| Upper(AllTrim(x)) == Upper(Alltrim("N3_DINDEPR")) })	== 0
			cRet += IIf(Empty(cRet),"","/")+"N3_DINDEPR"
		EndIf	
		If AScan(aHeader,{|x| Upper(AllTrim(x)) == Upper(Alltrim("N3_TXDEPR1")) })	== 0
			cRet += IIf(Empty(cRet),"","/")+"N3_TXDEPR1"
		EndIf
		If AScan(aHeader,{|x| Upper(AllTrim(x)) == Upper(Alltrim("N3_VRDACM1")) })	== 0
			cRet += IIf(Empty(cRet),"","/")+"N3_VRDACM1"
		EndIf
		If AScan(aHeader,{|x| Upper(AllTrim(x)) == Upper(Alltrim("N3_AQUISIC")) })	== 0
			cRet += IIf(Empty(cRet),"","/")+"N3_AQUISIC"
		EndIf		
		
EndCase

Return cRet



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณImpObrigatบAutor  ณCarlos Daniel   บ Data ณ  18/08/12       บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณValida preenchimento/conteudo de campos obrigatorios        บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Totvs                                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function ImpObrigat(cCdAlias,aCols,aHeader)
Local cRet 		:= ""

Do Case
	Case cCdAlias == "SA1"
		If Empty(RetCol("A1_PESSOA",aCols,aHeader))
			cRet += " / Coluna A1_PESSOA esta vazia! "
		EndIf
		If Empty(RetCol("A1_NOME",aCols,aHeader))
			cRet += " / Coluna A1_NOME esta vazia! "
		EndIf
		If Empty(RetCol("A1_CGC",aCols,aHeader))
			cRet += " / Coluna A1_CGC esta vazia! "
		EndIf
		If Empty(RetCol("A1_NREDUZ",aCols,aHeader))
			cRet += " / Coluna A1_NREDUZ esta vazia! "
		EndIf
		If Empty(RetCol("A1_END",aCols,aHeader))
			cRet += " / Coluna A1_END esta vazia! "
		EndIf
		If Empty(RetCol("A1_TIPO",aCols,aHeader))
			cRet += " / Coluna A1_TIPO esta vazia! "
		EndIf
		If Empty(RetCol("A1_EST",aCols,aHeader))
			cRet += " / Coluna A1_EST esta vazia! "
		EndIf
		If Empty(RetCol("A1_COD_MUN",aCols,aHeader))
			cRet += " / Coluna A1_COD_MUN esta vazia! "
		EndIf
		If Empty(RetCol("A1_BAIRRO",aCols,aHeader))
			cRet += " / Coluna A1_BAIRRO esta vazia! "
		EndIf
		If Empty(RetCol("A1_CEP",aCols,aHeader))
			cRet += " / Coluna A1_CEP esta vazia! "
		EndIf
		If Empty(RetCol("A1_INSCR",aCols,aHeader))
			cRet += " / Coluna A1_INSCR esta vazia! "
		EndIf
		If Empty(RetCol("A1_LC",aCols,aHeader))
			cRet += " / Coluna A1_LC esta vazia! "
		EndIf
		If Empty(RetCol("A1_VENCLC",aCols,aHeader))
			cRet += " / Coluna A1_VENCLC esta vazia! "
		EndIf


	Case cCdAlias == "SB1" 
		If Empty(RetCol("B1_GRUPO",aCols,aHeader))
			cRet += " / Coluna B1_GRUPO esta vazia! "
		EndIf
		If Empty(RetCol("B1_COD",aCols,aHeader))
			cRet += " / Coluna B1_COD esta vazia! "
		EndIf
		If Empty(RetCol("B1_DESC",aCols,aHeader))
			cRet += " / Coluna B1_DESC esta vazia! "
		EndIf
		If Empty(RetCol("B1_TIPO",aCols,aHeader))
			cRet += " / Coluna B1_TIPO esta vazia! "
		EndIf
		If Empty(RetCol("B1_UM",aCols,aHeader))
			cRet += " / Coluna B1_UM esta vazia! "
		EndIf
		If Empty(RetCol("B1_LOCPAD",aCols,aHeader))
			cRet += " / Coluna B1_LOCPAD esta vazia! "
		EndIf
		If Empty(RetCol("B1_E_SITUA",aCols,aHeader))
			cRet += " / Coluna B1_E_SITUA esta vazia! "
		EndIf
		If Empty(RetCol("B1_POSIPI",aCols,aHeader))
			cRet += " / Coluna B1_POSIPI esta vazia! "
		EndIf
		If Empty(RetCol("B1_ORIGEM",aCols,aHeader))
			cRet += " / Coluna B1_ORIGEM esta vazia! "
		EndIf
		If Empty(RetCol("B1_GARANT",aCols,aHeader))
			cRet += " / Coluna B1_GARANT esta vazia! "
		EndIf
	Case cCdAlias == "SA4"

		If Empty(RetCol("A4_NOME",aCols,aHeader))
			cRet += " / Coluna A4_NOME esta vazia! "
		EndIf
		If Empty(RetCol("A4_NREDUZ",aCols,aHeader))
			cRet += " / Coluna A4_NREDUZ esta vazia! "
		EndIf

	Case cCdAlias == "SA2"
		If Empty(RetCol("A2_NOME",aCols,aHeader))
			cRet += " / Coluna A2_NOME esta vazia! "
		EndIf
		If Empty(RetCol("A2_NREDUZ",aCols,aHeader))
			cRet += " / Coluna A2_NREDUZ esta vazia! "
		EndIf
		If Empty(RetCol("A2_END",aCols,aHeader))
			cRet += " / Coluna A2_END esta vazia! "
		EndIf
		If Empty(RetCol("A2_EST",aCols,aHeader))
			cRet += " / Coluna A2_EST esta vazia! "
		EndIf
		If Empty(RetCol("A2_TIPO",aCols,aHeader))
			cRet += " / Coluna A2_TIPO esta vazia! "
		EndIf

	Case cCdAlias == "SA3"
		If Empty(RetCol("A3_NOME",aCols,aHeader))
			cRet += " / Coluna A3_NOME esta vazia! "
		EndIf


	Case cCdAlias == "SE1"

		If Empty(RetCol("E1_NUM",aCols,aHeader))
			cRet += " / Coluna E1_NUM esta vazia! "
		EndIf
		If Empty(RetCol("E1_TIPO",aCols,aHeader))
			cRet += " / Coluna E1_TIPO esta vazia! "
		EndIf
		If Empty(RetCol("E1_NATUREZ",aCols,aHeader))
			cRet += " / Coluna E1_NATUREZ esta vazia! "
		EndIf
		If Empty(RetCol("E1_CLIENTE",aCols,aHeader))
			cRet += " / Coluna E1_CLIENTE esta vazia! "
		EndIf
		If Empty(RetCol("E1_LOJA",aCols,aHeader))
			cRet += " / Coluna E1_LOJA esta vazia! "
		EndIf
		If Empty(RetCol("E1_EMISSAO",aCols,aHeader))
			cRet += " / Coluna E1_EMISSAO esta vazia! "
		EndIf
		If Empty(RetCol("E1_VENCTO",aCols,aHeader))
			cRet += " / Coluna E1_VENCTO esta vazia! "
		EndIf
		If Empty(RetCol("E1_VENCREA",aCols,aHeader))
			cRet += " / Coluna E1_VENCREA esta vazia! "
		EndIf
		If Empty(RetCol("E1_VALOR",aCols,aHeader))
			cRet += " / Coluna E1_VALOR esta vazia! "
		EndIf
		If Empty(RetCol("E1_VLCRUZ",aCols,aHeader))
			cRet += " / Coluna E1_VLCRUZ esta vazia! "
		EndIf

	Case cCdAlias == "SE2"
		If Empty(RetCol("E2_NUM",aCols,aHeader))
			cRet += " / Coluna E2_NUM esta vazia! "
		EndIf
		If Empty(RetCol("E2_TIPO",aCols,aHeader))
			cRet += " / Coluna E2_TIPO esta vazia! "
		EndIf
		If Empty(RetCol("E2_NATUREZ",aCols,aHeader))
			cRet += " / Coluna E2_NATUREZ esta vazia! "
		EndIf
		If Empty(RetCol("E2_FORNECE",aCols,aHeader))
			cRet += " / Coluna E2_FORNECE esta vazia! "
		EndIf
		If Empty(RetCol("E2_LOJA",aCols,aHeader))
			cRet += " / Coluna E2_LOJA esta vazia! "
		EndIf
		If Empty(RetCol("E2_EMISSAO",aCols,aHeader))
			cRet += " / Coluna E2_EMISSAO esta vazia! "
		EndIf
		If Empty(RetCol("E2_VENCTO",aCols,aHeader))
			cRet += " / Coluna E2_VENCTO esta vazia! "
		EndIf
		If Empty(RetCol("E2_VENCREA",aCols,aHeader))
			cRet += " / Coluna E2_VENCREA esta vazia! "
		EndIf
		If Empty(RetCol("E2_VALOR",aCols,aHeader))
			cRet += " / Coluna E2_VALOR esta vazia! "
		EndIf
		If Empty(RetCol("E2_VLCRUZ",aCols,aHeader))
			cRet += " / Coluna E2_VLCRUZ esta vazia! "
		EndIf

	Case cCdAlias == "SB9"                       
		If Empty(RetCol("B9_COD",aCols,aHeader))
			cRet += " / Coluna B9_COD esta vazia! "
		EndIf
		If Empty(RetCol("B9_LOCAL",aCols,aHeader))
			cRet += " / Coluna B9_LOCAL esta vazia! "
		EndIf 
		
	Case cCdAlias == "NNB"                       
		If Empty(RetCol("NNB_CODIGO",aCols,aHeader))
			cRet += " / Coluna NNB_CODIGO esta vazia! "
		EndIf
		If Empty(RetCol("NNB_DESCRI",aCols,aHeader))
			cRet += " / Coluna NNB_DESCRI esta vazia! "
		EndIf
		If Empty(RetCol("NNB_PLACA",aCols,aHeader))
			cRet += " / Coluna NNB_PLACA esta vazia! "
		EndIf
		If Empty(RetCol("NNB_TIPO",aCols,aHeader))
			cRet += " / Coluna NNB_TIPO esta vazia! "
		EndIf   
		
	Case cCdAlias == "SF4"                       
		If Empty(RetCol("F4_CODIGO",aCols,aHeader))
			cRet += " / Coluna F4_CODIGO esta vazia! "
		EndIf
		If Empty(RetCol("F4_TIPO",aCols,aHeader))
			cRet += " / Coluna F4_TIPO esta vazia! "
		EndIf
		If Empty(RetCol("F4_DUPLIC",aCols,aHeader))
			cRet += " / Coluna F4_DUPLIC esta vazia! "
		EndIf
		If Empty(RetCol("F4_ESTOQUE",aCols,aHeader))
			cRet += " / Coluna F4_ESTOQUE esta vazia! "
		EndIf
		If Empty(RetCol("F4_PODER3",aCols,aHeader))
			cRet += " / Coluna F4_PODER3 esta vazia! "
		EndIf
		If Empty(RetCol("F4_FINALID",aCols,aHeader))
			cRet += " / Coluna F4_FINALID esta vazia! "
		EndIf
		If Empty(RetCol("F4_CF",aCols,aHeader))
			cRet += " / Coluna F4_CF esta vazia! "
		EndIf
		If Empty(RetCol("F4_TEXTO",aCols,aHeader))
			cRet += " / Coluna F4_TEXTO esta vazia! "
		EndIf
		If Empty(RetCol("F4_ICM",aCols,aHeader))
			cRet += " / Coluna F4_ICM esta vazia! "
		EndIf
		If Empty(RetCol("F4_CREDICM",aCols,aHeader))
			cRet += " / Coluna F4_CREDICM esta vazia! "
		EndIf
		If Empty(RetCol("F4_LFICM",aCols,aHeader))
			cRet += " / Coluna F4_LFICM esta vazia! "
		EndIf
		If Empty(RetCol("F4_COMPL",aCols,aHeader))
			cRet += " / Coluna F4_COMPL esta vazia! "
		EndIf
		If Empty(RetCol("F4_SITTRIB",aCols,aHeader))
			cRet += " / Coluna F4_SITTRIB esta vazia! "
		EndIf
		If Empty(RetCol("F4_IPI",aCols,aHeader))
			cRet += " / Coluna F4_IPI esta vazia! "
		EndIf
		If Empty(RetCol("F4_CREDIPI",aCols,aHeader))
			cRet += " / Coluna F4_CREDIPI esta vazia! "
		EndIf
		If Empty(RetCol("F4_LFIPI",aCols,aHeader))
			cRet += " / Coluna F4_LFIPI esta vazia! "
		EndIf		
		If Empty(RetCol("F4_DESTACA",aCols,aHeader))
			cRet += " / Coluna F4_DESTACA esta vazia! "
		EndIf	
		If Empty(RetCol("F4_INCIDE",aCols,aHeader))
			cRet += " / Coluna F4_INCIDE esta vazia! "
		EndIf
		If Empty(RetCol("F4_CTIPI",aCols,aHeader))
			cRet += " / Coluna F4_CTIPI esta vazia! "
		EndIf
		If Empty(RetCol("F4_CSTPIS",aCols,aHeader))
			cRet += " / Coluna F4_CSTPIS esta vazia! "
		EndIf
		If Empty(RetCol("F4_CSTCOF",aCols,aHeader))
			cRet += " / Coluna F4_CSTCOF esta vazia! "
		EndIf 
   
	Case cCdAlias == "SN1,SN3"                       
		If Empty(RetCol("N1_GRUPO",aCols,aHeader))
			cRet += " / Coluna N1_GRUPO esta vazia! "
		EndIf
		If Empty(RetCol("N1_CBASE",aCols,aHeader))
			cRet += " / Coluna N1_CBASE esta vazia! "
		EndIf
		If Empty(RetCol("N1_ITEM",aCols,aHeader))
			cRet += " / Coluna N1_ITEM esta vazia! "
		EndIf
		If Empty(RetCol("N1_QUANTD",aCols,aHeader))
			cRet += " / Coluna N1_QUANTD esta vazia! "
		EndIf
		If Empty(RetCol("N1_AQUISIQ",aCols,aHeader))
			cRet += " / Coluna N1_AQUISIQ esta vazia! "
		EndIf
		If Empty(RetCol("N1_DESCRIC",aCols,aHeader))
			cRet += " / Coluna N1_DESCRIC esta vazia! "
		EndIf
		If Empty(RetCol("N1_CHAPA",aCols,aHeader))
			cRet += " / Coluna N1_CHAPA esta vazia! "
		EndIf
		If Empty(RetCol("N1_VLAQUIS",aCols,aHeader))
			cRet += " / Coluna N1_VLAQUIS esta vazia! "
		EndIf
	  /*	If Empty(RetCol("N1_SERIE",aCols,aHeader))
			cRet += " / Coluna N1_SERIE esta vazia! "
		EndIf
		If Empty(RetCol("N1_NFISCAL",aCols,aHeader))
			cRet += " / Coluna N1_NFISCAL esta vazia! "
		EndIf
		If Empty(RetCol("N1_PRODUTO",aCols,aHeader))
			cRet += " / Coluna N1_PRODUTO esta vazia! "
		EndIf
		If Empty(RetCol("N1_LOCAL",aCols,aHeader))
			cRet += " / Coluna N1_LOCAL esta vazia! "
		EndIf   */
		If Empty(RetCol("N3_TIPO",aCols,aHeader))
			cRet += " / Coluna N3_TIPO esta vazia! "
		EndIf
		If Empty(RetCol("N3_HISTOR",aCols,aHeader))
			cRet += " / Coluna N3_HISTOR esta vazia! "
		EndIf
		If Empty(RetCol("N3_CCONTAB",aCols,aHeader))
			cRet += " / Coluna N3_CCONTAB esta vazia! "
		EndIf
		If Empty(RetCol("N3_VORIG1",aCols,aHeader))
			cRet += " / Coluna N3_VORIG1 esta vazia! "
		EndIf		
	   //	If Empty(RetCol("N3_CUSTBEM",aCols,aHeader))
		  //	cRet += " / Coluna N3_CUSTBEM esta vazia! "
	   //	EndIf
		
EndCase

Return cRet



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณImpGrava    บAutor  ณCarlos Daniel   บ Data ณ  18/08/12     บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณChamada da rotina automatica de gravacao                    บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Totvs                                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function ImpGrava(cCdAlias,cRotina,aCols,aHeader)
Local nX			:= 0
Local cRotAuto		:= ""
Local lOk			:= .F.
Local cMsg			:= ""
Local lGeraNumSeq	:= .T.
Local cArqErro		:= "ERRO_AUTO.TXT"
Local lTemFilial	:= .F.
Local cCpoFilial 	:= IIf( SubStr(cCdAlias,1,1) == "S", SubStr(cCdAlias,2,2), cCdAlias) + "_FILIAL"
Local cFilAlias		:= xFilial(cCdAlias) 
Local nCont := 1  

Private aCabec := {}
Private aLinha := {}
Private lMsHelpAuto := .T.                                         
Private lMsErroAuto := .F.    
Private aReg		:= {}


//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณMonta array com os campos do registro                          ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
For nX:=1 to Len(aHeader)
	AAdd(aReg, {	Upper(Alltrim(aHeader[nX]))					    ,;
					RetCol(Alltrim(aHeader[nX]),aCols,aHeader)		,;
					Nil} )

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณVerifica se possui campo sequencial informado                       ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	If cCdAlias $ "SA1/SA2"
		lGeraNumSeq	:= .F.
	EndIf

	//If cCdAlias == "SA1" .AND. Upper(Alltrim(aHeader[nX])) == "A1_COD" .AND. !Empty(RetCol(Alltrim(aHeader[nX]),aCols,aHeader))
		//lGeraNumSeq	:= .F.
	//EndIf
	If cCdAlias == "SA4" .AND. Upper(Alltrim(aHeader[nX])) == "A4_COD" .AND. !Empty(RetCol(Alltrim(aHeader[nX]),aCols,aHeader))
		lGeraNumSeq	:= .F.
	EndIf
	//If cCdAlias == "SA2" .AND. Upper(Alltrim(aHeader[nX])) == "A2_COD" .AND. !Empty(RetCol(Alltrim(aHeader[nX]),aCols,aHeader))
	//	lGeraNumSeq	:= .F.
	//EndIf
	If cCdAlias == "SA3" .AND. Upper(Alltrim(aHeader[nX])) == "A3_COD" .AND. !Empty(RetCol(Alltrim(aHeader[nX]),aCols,aHeader))
		lGeraNumSeq	:= .F.
	EndIf


	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณVerifica se informou filial no arquivo              ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	If Upper(Alltrim(aHeader[nX])) == cCpoFilial
		lTemFilial := .T.
    EndIf
Next

If lGeraNumSeq
	If cCdAlias == "SA1"
		nNumA1 := U_RtProx("SA1",M->A1_CGC,"A1_COD",6,M->A1_PESSOA)
		AAdd(aReg, {	"A1_COD"					    ,;
						nNumA1							,;
						Nil} )
		ConfirmSx8()
	EndIf
	If cCdAlias == "SA2"
		nNumA2 := U_RtProx("SA2",M->A2_CGC,"A2_COD",6,M->A2_PESSOA)
		AAdd(aReg, {	"A2_COD"					    ,;
						nNumA2							,;
						Nil} )
		ConfirmSx8()
	EndIf
	If cCdAlias == "SA4"
		AAdd(aReg, {	"A4_COD"					    ,;
						GetSxeNum("SA4","A4_COD")		,;
						Nil} )
		ConfirmSx8()
	EndIf
	If cCdAlias == "SA3"
		AAdd(aReg, {	"A3_COD"					    ,;
						GetSxeNum("SA3","A3_COD")		,;
						Nil} )
		ConfirmSx8()
	EndIf
EndIf
          
IF cCdAlias == 'SN1,SN3'
	cCdAlias := 'SN1'
ENDIF	

If !lTemFilial
	DbSelectArea(cCdAlias)
	AAdd(aReg, {	cCpoFilial					    ,;
					cFilAlias						,;
					Nil} )
EndIf

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณChamada da rotina automatica                                     ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
DbSelectArea(cCdAlias)
 					  	
IF cCdAlias == 'SN1'		
   GeraSN3(aCols,aHeader) 
ELSE
	cRotAuto := "MSExecAuto({|x,y| "+cRotina+"(x,y)},aReg,3)"
ENDIF      
//cRotAuto := "MSExecAuto({|x,y| "+cRotina+"(x,y)},aReg,3)"  //retirado Carlos Para chamar rotina caso seja importar Ativo Fixo
&cRotAuto

If lMsErroAuto
	MostraErro( GetSrvProfString("Startpath","") , cArqErro )
	cMsg := MemoRead(  GetSrvProfString("Startpath","") + '\' + cArqErro )
Else
	lOk := .T.
EndIf

Return {lOk, cMsg }

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัอออออออออออหออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณImpChgRadio    บAutor  ณCarlos Daniel   บ Data ณ  18/08/12  บฑฑ
ฑฑฬออออออออออุอออออออออออสออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณtratamento de mudanca to tipo de arquivo para importacao    บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Totvs                                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function ImpChgRadio(nRadioArq,cNmAlias)
Do Case
	Case nRadioArq == 1		
		cNmAlias := "Clientes (SA1)"
	Case nRadioArq == 2		 
		cNmAlias := "Produtos (SB1)"
	Case nRadioArq == 3		 
		cNmAlias := "Fornecedores (SA2)"
	Case nRadioArq == 4		 
		cNmAlias := "Vendedores (SA3)"
	Case nRadioArq == 5		 
		cNmAlias := "Contas a Receber - em aberto (SE1)"
	Case nRadioArq == 6		 
		cNmAlias := "Contas a Pagar - em aberto (SE2)" 
	Case nRadioArq == 7
		cNmAlias := "Saldos Iniciais - Estoque (SB9)"
	Case nRadioArq == 8
		cNmAlias := "Saldos Lote/SubLote (SD5)"
	Case nRadioArq == 9
		cNmAlias := "Saldos Lote/SubLote (NNB)"
	Case nRadioArq == 10
		cNmAlias := "cadastro Tes (SF4)" 
	Case nRadioArq == 11
		cNmAlias := "cadastro ATIVO (SN1/SN3)"
	Case nRadioArq == 12
		cNmAlias := "cadastro TRANSPORTADORA (SA4)"
	OtherWise	
		cNmAlias := "Processamento nao implementado" 
EndCase

Return     
//gera SN1 e SN3
Static Function GeraSN3(aCols,aHeader) 
Local dData :=''
Local aItens := {}
Local aDadosAuto := {} // Array com os dados a serem enviados pela MsExecAuto() para gravacao automatica dos itens do ativo 
Local aCab := { {'N1_FILIAL' ,'' ,NIL},; 
{'N1_CBASE' ,aCols[1] ,NIL},; 
{'N1_ITEM' ,aCols[2] ,NIL},; // ta vindo 1 e era 01
{'N1_AQUISIQ' ,CTOD(aCols[4]) ,NIL},; //data aquisicao     07/01/2014 aCols[4]
{'N1_DESCRIC' ,aCols[6] ,NIL},; 
{'N1_QUANTD' ,val(aCols[5]) ,NIL},; 
{'N1_GRUPO' ,aCols[3] ,NIL},;
{'N1_VLAQUIS' ,val(aCols[8]) ,NIL},;
{'N1_CHAPA' ,aCols[7] ,NIL} }
// Array com os dados a serem enviados pela MsExecAuto() para gravacao automatica da capa do bem 
Private lMsHelpAuto := .f. // Determina se as mensagens de help devem ser direcionadas para o arq. de log
Private lMsErroAuto := .f. // Determina se houve alguma inconsistencia na execucao da rotina 
aAdd(aItens,{ {'N3_TIPO' ,'10' , NIL},;
{'N3_HISTOR'  , aCols[10] , NIL},; 
{'N3_TPSALDO' ,'1' , NIL},; 
{'N3_TPDEPR'  ,'1' , NIL},; 
{'N3_CCONTAB' , aCols[11] , NIL},; 
{'N3_VORIG1'  , val(aCols[16]) , NIL},; 
{'N3_VMXDEPR' , 0 , NIL},; 
{'N3_VLSALV1' , 0 , NIL},; 
{'N3_PERDEPR' , 0 , NIL},; 
{'N3_PRODMES' , 0 , NIL},;
{'N3_CUSTBEM' , aCols[12] , NIL},;  //ccustbem esta faltando 0 antes
{'N3_CDEPREC' , aCols[13] , NIL},;
{'N3_CCDEPR'  , aCols[14] , NIL},; 
{'N3_TXDEPR1' , val(aCols[17]) , NIL},;
{'N3_VRDACM1' , val(aCols[18]) , NIL},;
{'N3_PRODANO' , 0 , NIL},; 
{'N3_DINDEPR' , CTOD(aCols[15]) ,NIL},; //data aCols[19] 
{'N3_AQUISIC' , CTOD(aCols[4]) ,NIL} } )
//array com os dados a serem enviados pela MsExecAuto() para gravacao automatica do item tipo 01
/*
aAdd(aItens,{ {'N3_TIPO' ,'10' , NIL},;
{'N3_HISTOR' , aCols[10] , NIL},; 
{'N3_TPSALDO' ,'1' , NIL},; 
{'N3_TPDEPR' ,'1' , NIL},; 
{'N3_CCONTAB' , aCols[11] , NIL},; 
{'N3_VORIG1' , val(aCols[18]) , NIL},; 
{'N3_VORIG2' , val(aCols[18]) , NIL},; 
{'N3_VORIG3' , val(aCols[18]) , NIL},; 
{'N3_VMXDEPR' , 0 , NIL},; 
{'N3_VLSALV1' , 0 , NIL},; 
{'N3_PERDEPR' , 0 , NIL},; 
{'N3_PRODMES' , 0 , NIL},;
{'N3_CUSTBEM' , aCols[12] , NIL},;
{'N3_CDEPREC' , aCols[13] , NIL},;
{'N3_CCDEPR' , aCols[14] , NIL},; 
{'N3_TXDEPR1' , val(aCols[17]) , NIL},;
{'N3_VRDACM1' , 0 , NIL},;
{'N3_PRODANO' , 0 , NIL},; 
{'N3_DINDEPR' , CTOD(aCols[15]) ,NIL} } ) //data CTOD(aCols[19]) 
*/                                                               

dData := CTOD(aCols[4])//onde vira a data ja determinada em um csv 

dDataBase := dData     //altera data base do sistema para data de aquisicao do ativo

MSExecAuto( {|X,Y,Z| ATFA010(X,Y,Z)} ,aCab,aItens, 3)   

If lMsErroAuto 
	lRetorno := .F. 
	MostraErro()
Else
	lRetorno:=.T.
EndIf
Return
