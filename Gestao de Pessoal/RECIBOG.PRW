#INCLUDE "gper1030.ch"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "RPTDEF.CH"  
#INCLUDE "FWPrintSetup.ch"
#IFNDEF CRLF
	#DEFINE CRLF ( chr(13)+chr(10) )
#ENDIF

#DEFINE Imp_Spool      	2
#DEFINE ALIGN_H_LEFT   	0
#DEFINE ALIGN_H_RIGHT  	1
#DEFINE ALIGN_H_CENTER 	2
#DEFINE ALIGN_V_CENTER 	0
#DEFINE ALIGN_V_TOP	   	1
#DEFINE ALIGN_V_BOTTON 	2

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ GPER030  ³ Autor ³ R.H. - Ze Maria       ³ Data ³ 14.03.95 	        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Emissao de Recibos de Pagamento                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ GPER030(void)                                             	        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                               		   		³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³         ATUALIZACOES SOFRIDAS DESDE A CONSTRU€AO INICIAL                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Programador ³ Data   ³ Chd./Requisito ³  Motivo da Alteracao                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Ademar Jr.  ³22/03/13³Requisito:      ³-Unificacao dos fontes da fase padrao com ³±±
±±³            ³        ³RHU210_09_13    ³ a fase 4 (localizacoes).                 ³±±
±±³Sidney O.   ³02/04/14³M_RH007   TPDCQD³Alteracao da funcao f030Roteiro - nao     ³±±
±±³            ³        ³                ³exibe mais os roteiros G e J (INC e MUV)  ³±±
±±³Raquel Hager³02/09/14³TQM075			 ³Utilizacao de tabela S036 para Mensagens. ³±±
±±³Renan Borges³09/10/14³TQNUVG          ³Ajuste para imprimir log de ocorrências   ³±±
±±³			   ³ 		³                ³corretamente e sem gerar um relatório va- ³±±
±±³			   ³ 		³                ³zio após a impressão do log de ocorrências³±±
±±³Wag Mobile  ³31/10/14³TQTXLQ          ³Ajuste para imprimir verificando filtro da³±±
±±³			   ³ 		³                ³aba de filtro corretamente.               ³±±
±±³Allyson M   ³19/02/15³TRMMMT          ³Ajuste na validacao da data de aniversario³±±
±±³			   ³ 		³                ³no recibo enviado por email.	 			³±±
±±³Mariana M   ³08/04/15³TRVPPK        	 ³Ajuste no relatorio Zebrado para que no   ³±±
±±³			   ³ 		³                ³mes do aniversario do funcionario,apresen-³±±
±±³			   ³ 		³                ³tando a mensagem "Feliz Aniversario"		³±±
±±³	Emerson Ca³09/07/15³ PCREQ-4461      ³Criar a opção de envio de PDF por email   ³±±
±±³	          ³        ³                 ³Changset 294739                           ³±±
±±³Renan Borges³03/12/15³TTTLGI          ³Ajuste para enviar recibo de pagamento no ³±±
±±³			   ³ 		³                ³formato pdf por e-mail.                   ³±±
±±³Cícero Alves³17/12/15³TUABIP          ³Ajuste para imprimir bases no recibo da 1ª³±±
±±³			   ³ 		³                ³parcela do 13º em PDF				        ³±±
±±³Victor A.   ³03/05/16³TUOBR0          ³Ajuste na impressão direto na LPT1.       ³±±
±±³P. Pompeu...³30/06/16³TVNITS          ³Quebra por Func. e Ñ Exibir Bases no Zebr.³±±
±±³Matheus M.  ³27/07/16³TRMMMT          ³Ajuste para não exibir caracteres estra-  ³±±
±±³			   ³ 		³                ³nhos quando o driver de impressão for  	³±±
±±³			   ³ 		³                ³HP500C.								  	³±±
±±³Jonathan Glz³23/11/16³MMI-32          ³Ajuste en el reporte para la localizacion ³±±
±±³			   ³ 		³                ³para republica dominicana.                ³±±
±±³Isabel N.   ³04/01/17³MRH-3746        ³Ajuste no nome dos campos RA_CTDEPSAL para³±±
±±³            ³        ³                ³RA_CTDEPSA e RA_BCDEPSAL para RA_BCDEPSA, ³±±
±±³            ³        ³                ³conforme cadastrado no ATUSX.             ³±±
±±³Oswaldo L.  ³01/02/17³MRH-5780        ³Trativa para que o sistema apenas utilize ³±±
±±³            ³        ³                ³os campos de acordo com o pais conectado  ³±±
±±³M. Silveira ³09/02/17³MRH-6466        ³Geracao de LOG com as matriculas que nao  ³±±
±±³            ³        ³                ³foram enviadas por e-mail.				³±±
±±³Paulo O     ³06/03/17³MRH-5873        ³Acerto para Função fContinua() pular 7 ao ³±±
±±³Inzonha     ³        ³                ³inves de 8 linhas após o texto "Continua" ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function RECIBOG(lTerminal,cFilTerminal,cMatTerminal,cProcTerminal, nRecTipo, cPerTerminal, cSemanaTerminal)                 

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis Locais (Basicas)                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local cString	:= "SRA"        // alias do arquivo principal (Base)
Local aOrd   	:= {"Matricula","C.Custo","Nome","Chapa","C.Custo + Nome","Depto.","Depto. + Nome"} //"Matricula"###"C.Custo"###"Nome"###"Chapa"###"C.Custo + Nome"###"Depto."###"Depto. + Nome"
Local cDesc1 	:= "Emissao de Recibos de Pagamento."		//"Emiss„o de Recibos de Pagamento."
Local cDesc2 	:= "Ser impresso de acordo com os parametros solicitados pelo"		//"Ser  impresso de acordo com os parametros solicitados pelo"
Local cDesc3 	:= "usuario"		//"usu rio."
Local aDriver	:= ReadDriver(.T.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis Locais (Programa)                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local cIndCond
Local cRotBlank := Space(GetSx3Cache( "RCH_ROTEIR", "X3_TAMANHO" ))
Local Baseaux 	:= "S", cDemit := "N"
Local cHtml 	:= ""
Local cDriver	:= SuperGetMv("MV_DRIVER",.F.,"EPSON")

Private cMes	:= ""
Private cAno    := ""
Private aEmail  := {}
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define o numero da linha de impressão como 0                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
SetPrc(0,0)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis Private(Basicas)                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
private	nLi		 := 0
Private aReturn  := {"Zebrado", 1,"Administracao", 2, 2, 1, "",1 }	//"Zebrado"###"Administra‡„o"
Private nomeprog :="GPER030"
Private aLinha   := { }
Private nLastKey := 0
Private cPerg    :="GPER030"
Private cSem_De  := "  /  /    "
Private cSem_Ate := "  /  /    "
Private nAteLim , nBaseFgts , nFgts , nBaseIr , nBaseIrFe , nTipRel

Private cCompac := aDriver[1]
Private cNormal := aDriver[2]

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis Private(Programa)                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Private aLanca 			:= {}
Private aProve 			:= {}
Private aDesco 			:= {}
Private aBases 			:= {}
Private aInfo  			:= {}
Private aCodFol			:= {}
Private li     			:= _PROW()
Private Titulo 			:= "EMISSAO DE RECIBOS DE PAGAMENTOS"		//"EMISSO DE RECIBOS DE PAGAMENTOS"
Private lEnvioOk 		:= .F.
Private lRetCanc		:= .t.
Private cIRefSem    	:= GetMv("MV_IREFSEM",,"S")
Private aPerAberto		:= {}
Private aPerFechado		:= {}
Private cProcesso		:= "" // Armazena o processo selecionado na Pergunte GPR040 (mv_par01).
Private cRoteiro		:= "" // Armazena o Roteiro selecionado na Pergunte GPR040 (mv_par02).
Private cPeriodo		:= "" // Armazena o Periodo selecionado na Pergunte GPR040 (mv_par03).
Private cCcto			:= ""
Private cCond			:= ""
Private cRot			:= ""
Private lDepSf			:= Iif(SRA->(FieldPos("RA_DEPSF"))>0,.T.,.F.)
Private lLpt1			:= .F.
Private lFase4  		:= (cPaisLoc $ "ANG|ARG|COL|PTG|VEN")

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis da Impressao Grafica                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Private oPrint   
Private oArial08		:= TFont():New("Arial",08,08,,.F.,,,,.T.,.F.)//Normal
Private oArial08N		:= TFont():New("Arial",08,08,,.T.,,,,.T.,.F.)//Negrito
Private oArial10		:= TFont():New("Arial",10,10,,.F.,,,,.T.,.F.)//Normal
Private oArial10N		:= TFont():New("Arial",10,10,,.T.,,,,.T.,.F.)//Negriot
Private oPrinter		:= ""
Private oFont1 			:=	TFont():New( "Verdana", 07, 07, , .F., , , , .T., .F. )//Verbas
Private oFont2 			:=	TFont():New( "Verdana", 09, 09, , .F., , , , .T., .F. )//Cabeçalho e Rodapé
Private oFont2N 		:= 	TFont():New( "Verdana", 09, 09, , .T., , , , .T., .F. )//Cabeçalho e Rodapé Negrito
Private oFont3 			:=	TFont():New( "Verdana", 12, 12, , .T., , , , .T., .F. )//Titulo Interno
Private oFont4 			:=	TFont():New( "Verdana", 14, 14, , .T., , , , .T., .F. )//Titulo Maior
Private Semana
Private cSemana
Private lPDFEmail		:= .T. //PDF é por Email quando for .F. Visualizar o PDF no remote
Private lIsDriver		:= Iif(cDriver == "EPSON",.T.,.F.)
  
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Envia controle para a funcao SETPRINT                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
wnrel:="GPER030"            //Nome Default do relatorio em Disco

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica se o programa foi chamado do terminal - TCF         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
lTerminal := If( lTerminal == Nil, .F., lTerminal )

IF !( lTerminal )
	wnrel:=SetPrint(cString,wnrel,cPerg,Titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd)
Else           
	If Select("SRC")>0
		SRC->(DbCloseArea())
	EndIf
EndIF

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define a Ordem do Relatorio                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nOrdem := IF( !( lTerminal ), aReturn[8] , 1 )

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If !IsBlind()
	Pergunte(cPerg, .F.)
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Carregando variaveis mv_par?? para Variaveis do Sistema.     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cSemanaTerminal := IF( Empty( cSemanaTerminal ) , Space( Len( SRC->RC_SEMANA ) ) , cSemanaTerminal )
cProcesso  := IF( !( lTerminal ), mv_par01 , cProcTerminal		)   //Processo
cRoteiro   := IF( !( lTerminal ), mv_par02 , nRecTipo			)	//Emitir Recibos(Roteiro)
cPeriodo   := IF( !( lTerminal ), mv_par03 , cPerTerminal		)   //Periodo
Semana     := IF( !( lTerminal ), mv_par04 , cSemanaTerminal	)	//Numero da Semana
cSemana    := Semana

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verificar se o sistema esta trabalhando com ou sem roteiro   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
DbSelectArea( "RCH" )
DbSetOrder( 4 )
DbSeek(  xFilial( "RCH" ) + cProcesso + cRoteiro + cPeriodo + Semana, .F. )
If Eof()
	DbSeek(  xFilial( "RCH" ) + cProcesso + cRotBlank + cPeriodo + Semana, .F. )
Else
	cRotBlank := cRoteiro
EndIf

//Carregar os periodos abertos (aPerAberto) e/ou 
// os periodos fechados (aPerFechado), dependendo 
// do periodo (ou intervalo de periodos) selecionado
RetPerAbertFech(cProcesso	,; // Processo selecionado na Pergunte.
				cRotBlank	,; // Roteiro selecionado na Pergunte.
				cPeriodo	,; // Periodo selecionado na Pergunte.
				Semana		,; // Numero de Pagamento selecionado na Pergunte.
				NIL			,; // Periodo Ate - Passar "NIL", pois neste relatorio eh escolhido apenas um periodo.
				NIL			,; // Numero de Pagamento Ate - Passar "NIL", pois neste relatorio eh escolhido apenas um numero de pagamento.
				@aPerAberto	,; // Retorna array com os Periodos e NrPagtos Abertos
				@aPerFechado ) // Retorna array com os Periodos e NrPagtos Fechados
				
// Retorna o mes e o ano do periodo selecionado na pergunte.
AnoMesPer(	cProcesso	,; // Processo selecionado na Pergunte.
			cRotBlank	,; // Roteiro selecionado na Pergunte.
			cPeriodo	,; // Periodo selecionado na Pergunte.
			@cMes		,; // Retorna o Mes do Processo + Roteiro + Periodo selecionado
			@cAno		,; // Retorna o Ano do Processo + Roteiro + Periodo selecionado     
			Semana		 ) // Retorna a Semana do Processo + Roteiro + Periodo selecionado
			
dDataRef   := CTOD("01/" + cMes + "/" + cAno)
If MV_PAR05 # 4 
	msgAlert("Este relatório so realiza a impressao no formato PDF")
EndIf
nTipRel    := 4//IF( !( lTerminal ), mv_par05 , 3				)	//Tipo de Recibo (Pre-Impressão/Zebrado/EMail/PDF)
cFilDe     := IF( !( lTerminal ), mv_par06,cFilTerminal		)	//Filial De
cFilAte    := IF( !( lTerminal ), mv_par07,cFilTerminal		)	//Filial Ate
cCcDe      := IF( !( lTerminal ), mv_par08,SRA->RA_CC		)	//Centro de Custo De
cCcAte     := IF( !( lTerminal ), mv_par09,SRA->RA_CC		)	//Centro de Custo Ate
cMatDe     := IF( !( lTerminal ), mv_par10,cMatTerminal		)	//Matricula Des
cMatAte    := IF( !( lTerminal ), mv_par11,cMatTerminal		)	//Matricula Ate
cNomDe     := IF( !( lTerminal ), mv_par12,SRA->RA_NOME		)	//Nome De
cNomAte    := IF( !( lTerminal ), mv_par13,SRA->RA_NOME		)	//Nome Ate
ChapaDe    := IF( !( lTerminal ), mv_par14,SRA->RA_CHAPA	)	//Chapa De
ChapaAte   := IF( !( lTerminal ), mv_par15,SRA->RA_CHAPA	)	//Chapa Ate
Mensag1    := mv_par16										 	//Mensagem 1
Mensag2    := mv_par17											//Mensagem 2
Mensag3    := mv_par18											//Mensagem 3
cSituacao  := IF( !( lTerminal ),mv_par19, fSituacao( NIL , .F. ) )	//Situacoes a Imprimir
cCategoria := IF( !( lTerminal ),mv_par20, fCategoria( NIL , .F. ))	//Categorias a Imprimir
cBaseAux   := IF( !( lTerminal ),If(mv_par21 == 1,"S","N"),"S")	//Imprimir Bases
cDeptoDe   := IF( !( lTerminal ),mv_par22,SRA->RA_DEPTO 	)	//Depto. De
cDeptoAte  := IF( !( lTerminal ),mv_par23,SRA->RA_DEPTO 	)	//Depto. Ate
lQuebraFun := IIF( !( lTerminal ) .And. !Empty(MV_PAR24),(MV_PAR24 == 1),.F.) //Quebra por Funcionário?

If nTipRel == 4 //Apenas visualizar o PDF
	lPDFEmail	:= .F.
EndIf

limpArqPdf() //Limpar Recibos que por ventura ainda estejam no servidor

cMesAnoRef := StrZero(Month(dDataRef),2) + StrZero(Year(dDataRef),4)
If aReturn[5] == 3	//Impressao Direta na Porta
	lLpt1 := .T.
EndIf

IF !( lTerminal )
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Inicializa Impressao                                         ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If ! fInicia(cString,nTipRel)
		Return
	Endif 
EndIF

DbSelectArea( "SRA" )

RptStatus({|lEnd| R030Imp(@lEnd,wnRel,cString,cMesAnoRef,.f.)},Titulo)  // Chamada do Relatorio

Return( IF( lTerminal , cHtml , NIL ) )

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ R030IMP  ³ Autor ³ R.H. - Ze Maria       ³ Data ³ 14.03.95 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Processamento Para emissao do Recibo                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ R030Imp(lEnd,WnRel,cString,cMesAnoRef,lTerminal)			  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function R030Imp(lEnd,WnRel,cString,cMesAnoRef,lTerminal)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis Locais (Basicas)                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local aCodBenef   	:= {}
Local aTInss		:= {}
Local cAcessaSR1  	:= &("{ || " + ChkRH("GPER030","SR1","2") + "}")
Local cAcessaSRA  	:= &("{ || " + ChkRH("GPER030","SRA","2") + "}")
Local cAcessaSRC  	:= &("{ || " + ChkRH("GPER030","SRC","2") + "}")
Local cAcessaSRD  	:= &("{ || " + ChkRH("GPER030","SRD","2") + "}")
Local cNroHoras   	:= &("{ || If(aVerbasFunc[nReg,5] > 0 .And. cIRefSem == 'S', aVerbasFunc[nReg,5], aVerbasFunc[nReg,6]) }")
Local cHtml		  	:= ""
Local nHoras      	:= 0
Local nMes, nAno
Local nX
Local nReg		  	:= 0
Local cPerAnt	  	:= ""                    
Local cKey		  	:= ""
Local cInicio	  	:= ""
Local nBInssPA	  	:= 0 //Teto da base de INSS dos pro-labores/autonomos
Local dDataLibRh
Local cPerCorrente	:= ""
Local cSemCorrente	:= ""
Local cMesCorrente 	:= ""
Local cAnoCorrente 	:= ""

Local nTcfDadt		:= if(lTerminal,getmv("MV_TCFDADT",,0),0)		// indica o dia a partir do qual esta liberada a consulta ao TCF 
Local nTcfDfol		:= if(lTerminal,getmv("MV_TCFDFOL",,0),0)		// indica a quantidade de dias a somar ou diminuir no ultimo dia do mes corrente para liberar a consulta do TCF
Local nTcfD131		:= if(lTerminal,getmv("MV_TCFD131",,0),0)		// indica o dia a partir do qual esta liberada a consulta ao TCF
Local nTcfD132		:= if(lTerminal,getmv("MV_TCFD132",,0),0)		// indica o dia a partir do qual esta liberada a consulta ao TCF
Local nTcfDext		:= if(lTerminal,getmv("MV_TCFDEXT",,0),0)		// indica o dia a partir do qual esta liberada a consulta ao TCF
Local nDec
Local nPosMsg1		:= 0
Local nPosMsg2		:= 0
Local nPosMsg3		:= 0
Local cFilter	   	:= aReturn[7]

Private tamanho   	:= "M"
Private limite		:= 132
Private cDtPago   	:= ""
Private cTipoRot 	:= PosAlias("SRY", cRoteiro, SRA->RA_FILIAL, "RY_TIPO")
Private aVerbasFunc := {}
Private aTitle		:= {}
Private aLog		:= {}
Private cRotBlank
Private nHraExtra 	:= 0
Private nPagoDom	:= 0

Private cPict1		:= "@E 999,999,999.99"
Private cPict2 		:= "@E 99,999,999.99"
Private cPict3 		:= "@E 999,999.99"

Private nSalario	:= 0

//-Ordem 1 -> RCA_FILIAL+RCA_MNEMON
If FPOSREG("RCA", 1, XFILIAL("RCA")+"RHDECIMAIS")
	nDec := Val(Alltrim(RCA->RCA_CONTEU))
Else
	nDec := MsDecimais(1)
EndIf

If nDec = 0
	cPict1	:=	"@E 99,999,999,999"
	cPict2 	:=	"@E 9,999,999,999"
	cPict3 	:=	"@E 99,999,999"
Endif

// Ajuste do tipo da variavel
nTcfDadt	:= if(valtype(ntcfdadt)=="C",val(ntcfdadt),ntcfdadt)
nTcfD131	:= if(valtype(nTcfD131)=="C",val(nTcfD131),nTcfD131)
nTcfD132	:= if(valtype(nTcfD132)=="C",val(nTcfD132),nTcfD132)
nTcfDfol	:= if(valtype(ntcfdfol)=="C",val(ntcfdfol),ntcfdfol)
nTcfDext	:= if(valtype(ntcfdext)=="C",val(ntcfdext),ntcfdext)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//| Verifica se o Mes solicitado esta liberado para consulta no  |
//| terminal de consulta do funcionario.                         |
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If lTerminal

	dbSelectArea("RCH")
	dbSetOrder(6)
	IF cPaisLoc == "ARG" 
  		cKey 	:= "xFilial('RCH') + cProcesso" 
 		cInicio := "RCH_FILIAL + RCH_PROCES" 		
	Else
		cKey    := "xFilial('RCH') + cProcesso" + IIf(cRoteiro == "EXT", "", " + cRoteiro")
		cInicio := "RCH_FILIAL + RCH_PROCES" + IIf(cRoteiro == "EXT", "", " + RCH_ROTEIR")
	Endif
	
	DbSeek( &(cKey))
	If Eof()
		cRotBlank 	:= Space(GetSx3Cache( "RCH_ROTEIR", "X3_TAMANHO" ))
		cKey 	:= "xFilial('RCH') + cProcesso " + IIf(cRoteiro == "EXT", "", " + cRotBlank")
		cInicio := "RCH_FILIAL + RCH_PROCES " + IIf(cRoteiro == "EXT", "", " + RCH_ROTEIR")
		DbSeek( &(cKey))
	EndIf
	If !Eof()
		While RCH->( !Eof() .and. &(cInicio) == &(cKey))
			If Empty(RCH->RCH_DTFECH)
				cPerCorrente := RCH->RCH_PER
				cSemCorrente := RCH->RCH_NUMPAG
				cMesCorrente := RCH->RCH_MES
				cAnoCorrente := RCH->RCH_ANO
				Exit
			EndIf		
			RCH->( dbSkip() )
		EndDo
	EndIf

	If	(cPerCorrente == cPeriodo .AND. cSemCorrente == Semana)  .OR. ;
		( MesAno(dDataRef) >= (cAnoCorrente + cMesCorrente) )

		If  cTipoRot == "2" //Adiantamento
			If ( MesAno(dDataRef) > (cAnoCorrente + cMesCorrente) ) .Or.;
			   ( If(MesAno(Date()) == (cAnoCorrente + cMesCorrente), Day(Date()) < nTCFDADT,.F.) )
				Return( IF( lTerminal <> NIL .And. lTerminal , cHtml , NIL ) )
			EndIf
		ElseIf cTipoRot == "1" .and. !empty(nTCFDFOL) //Folha
			dDataLibRh := fMontaDtTcf(cMesCorrente + cAnoCorrente,nTCFDFOL)
			If Date() < dDataLibRH 
				Return( IF( lTerminal <> NIL .And. lTerminal , cHtml , NIL ) )
			Endif
		ElseIf cTipoRot == "5" //1a parcela 13o Salario
			If ( MesAno(dDataRef) > (cAnoCorrente + cMesCorrente) ) .Or.;
  			   ( If(MesAno(Date()) == (cAnoCorrente + cMesCorrente), Day(Date()) < nTCFD131,.F.) )
				Return( IF( lTerminal <> NIL .And. lTerminal , cHtml , NIL ) )
			Endif
		ElseIf cTipoRot == "6" //2a parcela 13o Salario
			If ( MesAno(dDataRef) > (cAnoCorrente + cMesCorrente) ) .Or.;
			   ( If(MesAno(Date()) == (cAnoCorrente + cMesCorrente), Day(Date()) < nTCFD132,.F.) )
				Return( IF( lTerminal <> NIL .And. lTerminal , cHtml , NIL ) )
			Endif
		ElseIf cRoteiro == "EXT"  // Valores Extras
			If ( MesAno(dDataRef) > (cAnoCorrente + cMesCorrente) ) .Or.;
			   ( If(MesAno(Date()) == (cAnoCorrente + cMesCorrente), Day(Date()) < nTCFDEXT,.F.) )
				Return( IF( lTerminal <> NIL .And. lTerminal , cHtml , NIL ) )
			Endif
		EndIf
	Endif
Endif

If cPaisLoc == "ARG"
	nMes := Month(dDataRef) - 1
	nAno := Year(dDataRef)
	If nMes == 0
		nMes := 12
		nAno := nAno - 1
	Endif
	If nMes < 0
		nMes := 12 - ( nMes * -1 )
		nAno := nAno - 1
	Endif
	
	dbSelectArea( "RCH")
	dbSetOrder(6)
	dbSeek(xFilial("RCH") + cProcesso + cRoteiro + Transform(nAno,"9999") + Transform(nMes,"99"))
	If Eof()
		dbSeek(xFilial("RCH") + cProcesso + Space(GetSx3Cache( "RCH_ROTEIR", "X3_TAMANHO" )) +Transform(nAno,"9999") + Transform(nMes,"99"))
	EndIF
	If !Eof()
		cPerAnt := RCH->RCH_PER + RCH->RCH_NUMPAG
	EndIf	
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Selecionando a Ordem de impressao escolhida no parametro.    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea( "SRA")
IF !( lTerminal )
	If nOrdem == 1			//"Matricula"
		dbSetOrder(1)
	ElseIf nOrdem == 2		//"C.Custo"
		dbSetOrder(2)
	ElseIf nOrdem == 3		//"Nome"
		dbSetOrder(3)
	Elseif nOrdem == 4		//"Chapa"
		cArqNtx  := CriaTrab(NIL,.f.)
		cIndCond :="RA_Filial + RA_Chapa + RA_Mat"
		IndRegua("SRA",cArqNtx,cIndCond,,,"Selecionando Registros...")		//"Selecionando Registros..."
	
	ElseIf nOrdem == 5		//"C.Custo + Nome"
		dbSetOrder(8)
	ElseIf nOrdem == 6		//"Depto"
		dbSetOrder(21)
	ElseIf nOrdem == 7		//"Depto. + Nome"
		dbSetOrder(22)
	Endif
	
	dbGoTop()

EndIF

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Selecionando o Primeiro Registro e montando Filtro.          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If nOrdem == 1 .or. lTerminal
	cInicio := "SRA->RA_FILIAL + SRA->RA_MAT"
	IF !( lTerminal )
		dbSeek(cFilDe + cMatDe,.T.)
		cFim    := cFilAte + cMatAte
	Else
		cFim    := &(cInicio)
	EndIF
ElseIf nOrdem == 2
	dbSeek(cFilDe + cCcDe + cMatDe,.T.)
	cInicio  := "SRA->RA_FILIAL + SRA->RA_CC + SRA->RA_MAT"
	cFim     := cFilAte + cCcAte + cMatAte
ElseIf nOrdem == 3
	dbSeek(cFilDe + cNomDe + cMatDe,.T.)
	cInicio := "SRA->RA_FILIAL + SRA->RA_NOME + SRA->RA_MAT"
	cFim    := cFilAte + cNomAte + cMatAte
ElseIf nOrdem == 4
	dbSeek(cFilDe + ChapaDe + cMatDe,.T.)
	cInicio := "SRA->RA_FILIAL + SRA->RA_CHAPA + SRA->RA_MAT"
	cFim    := cFilAte + ChapaAte + cMatAte
ElseIf nOrdem == 5
	dbSeek(cFilDe + cCcDe + cNomDe,.T.)
	cInicio  := "SRA->RA_FILIAL + SRA->RA_CC + SRA->RA_NOME"
	cFim     := cFilAte + cCcAte + cNomAte
ElseIf nOrdem == 6
	dbSeek(cFilDe + cDeptoDe + cMatDe,.T.)
	cInicio  := "SRA->RA_FILIAL + SRA->RA_DEPTO + SRA->RA_MAT"
	cFim     := cFilAte + cDeptoAte + cMatAte
ElseIf nOrdem == 7
	dbSeek(cFilDe + cDeptoDe + cNomDe,.T.)
	cInicio  := "SRA->RA_FILIAL + SRA->RA_DEPTO + SRA->RA_NOME"
	cFim     := cFilAte + cDeptoAte + cNomAte
Endif

dbSelectArea("SRA")
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Carrega Regua Processamento                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
#IFDEF TOP                  
	cAliasTMP := "QNRO"
	BeginSql alias cAliasTMP
		SELECT COUNT(*) as NROREG
		FROM %table:SRA% SRA
		WHERE      SRA.RA_FILIAL BETWEEN %exp:cFilDe%   AND %exp:cFilAte% 
			   AND SRA.RA_MAT    BETWEEN %exp:cMatDe%   AND %exp:cMatAte%
			   AND SRA.RA_CC     BETWEEN %exp:cCCDe%    AND %exp:cCCAte% 
			   AND SRA.RA_DEPTO  BETWEEN %exp:cDeptoDe% AND %exp:cDeptoAte% 
			   AND SRA.%notDel%
	EndSql

	nRegProc := (cAliasTMP)->(NROREG)
	( cAliasTMP )->( dbCloseArea() )	
	IF nTipRel # 3
		SetRegua(nRegProc)	// Total de elementos da regua
	Else
		IF !( lTerminal )
			GPProcRegua(nRegProc)// Total de elementos da regua
		EndIF
	EndIF
	
	dbSelectArea("SRA")
	
#ELSE
	IF nTipRel # 3
		SetRegua(RecCount())	// Total de elementos da regua
	Else
		IF !( lTerminal )
			GPProcRegua(RecCount())// Total de elementos da regua
		EndIF
	EndIF
	
	dbSelectArea("SRA")
	
#ENDIF 

TOTVENC:= TOTDESC:= FLAG:= CHAVE := 0

Desc_Fil 	:= Desc_End := DESC_CC:= DESC_FUNC:= ""
Desc_Comp	:= Desc_Est := Desc_Cid:= ""
DESC_MSG1	:= DESC_MSG2:= DESC_MSG3:= Space(01)
cFilialAnt 	:= Space(FwGetTamFilial)
Vez        	:= 0
OrdemZ     	:= 0

While SRA->( !Eof() .And. &cInicio <= cFim )

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Movimenta Regua Processamento                                ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	IF !( lTerminal )

		IF nTipRel # 3
			IncRegua()  // Anda a regua
		ElseIF !( lTerminal )
			GPIncProc(SRA->RA_FILIAL+" - "+SRA->RA_MAT+" - "+SRA->RA_NOME)
		EndIF

		If lEnd
			@Prow()+1,0 PSAY cCancel
			Exit
		Endif

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Consiste Filtro da setprint						             ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If ! Empty(cFilter) .And. ! SRA->(&(cFilter))
			dbSelectArea("SRA")
			dbSkip()
			Loop
		EndIf

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Consiste Parametrizacao do Intervalo de Impressao            ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If (SRA->RA_CHAPA < ChapaDe)   .Or. (SRA->RA_CHAPa > ChapaAte) .Or. ;
			(FtAcento( SRA->RA_NOME )   < cNomDe) .Or. (FtAcento( SRA->RA_NOME ) > cNomAte)   .Or. ;
			(SRA->RA_MAT < cMatDe)     .Or. (SRA->RA_MAT > cMatAte)    .Or. ;
			(SRA->RA_CC < cCcDe)       .Or. (SRA->RA_CC > cCcAte)      .Or. ;
			(SRA->RA_DEPTO < cDeptoDe) .Or. (SRA->RA_DEPTO > cDeptoAte)

			SRA->(dbSkip(1))
			Loop
		EndIf

	EndIF

	aLanca:={}         // Zera Lancamentos
	aProve:={}         // Zera Lancamentos
	aDesco:={}         // Zera Lancamentos
	aBases:={}         // Zera Lancamentos
	nAteLim := nBaseFgts := nFgts := nBaseIr := nBaseIrFe := 0.00
	
	Ordem_rel := 1     // Ordem dos Recibos
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica Data Demissao         ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cSitFunc := SRA->RA_SITFOLH
	dDtPesqAf:= CTOD("01/" + Left(cMesAnoRef,2) + "/" + Right(cMesAnoRef,4),"DDMMYY")
	If cSitFunc == "D" .And. (!Empty(SRA->RA_DEMISSA) .And. MesAno(SRA->RA_DEMISSA) > MesAno(dDtPesqAf))
		cSitFunc := " "
	Endif
	
	//-Busca o Salario Base do Funcionario
	nSalario := fBuscaSal(dDataRef,,,.F.)
	If nSalario == 0
		nSalario := SRA->RA_SALARIO
	EndIf
	
	IF !( lTerminal )
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Consiste situacao e categoria dos funcionarios			     |
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If !( cSitFunc $ cSituacao ) .OR.  ! ( SRA->RA_CATFUNC $ cCategoria )
			SRA->(dbSkip())
			Loop
		Endif
		If cSitFunc $ "D" .And. Mesano(SRA->RA_DEMISSA) # Mesano(dDataRef)
			SRA->(dbSkip())
			Loop
		Endif
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Consiste controle de acessos e filiais validas				 |
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If !(SRA->RA_FILIAL $ fValidFil()) .Or. !Eval(cAcessaSRA)
			SRA->(dbSkip())
			Loop
		EndIf
		
	EndIF
	
	If SRA->RA_Filial # cFilialAnt
		If ! Fp_CodFol(@aCodFol,Sra->Ra_Filial) .Or. ! fInfo(@aInfo,Sra->Ra_Filial)
			Return Nil
		Endif      
		Desc_Fil := If( lLpt1, fTAcento(aInfo[3]), aInfo[3] )
		Desc_End := If( lLpt1, fTAcento(aInfo[4]), aInfo[4] )	// Dados da Filial
		Desc_CGC := aInfo[8]
		DESC_MSG1:= DESC_MSG2:= DESC_MSG3:= Space(01)
		Desc_Est := Substr(fDesc("SX5","12"+If( lLpt1, fTAcento(aInfo[6]), aInfo[6] ),"X5DESCRI()"),1,20)
		Desc_Comp:= If( lLpt1, fTAcento(aInfo[14]), aInfo[14] )	// Complemento Cobranca
		Desc_Cid := If( lLpt1, fTAcento(aInfo[5]), aInfo[5] )
		End_Compl:= aInfo[4] + " " + aInfo[13] + " " + aInfo[05] + " " +;
					aInfo[06] + " " + aInfo[07]//endereço + bairro + cidade + estado + cep
		Desc_EndC:= If( lLpt1, fTAcento( End_Compl ), End_Compl )
		// MENSAGENS
		If !Empty(MENSAG1)        
		
			nPosMsg1		:= fPosTab("S036",Alltrim(MENSAG1), "==", 4)
			If nPosMsg1 > 0 
				DESC_MSG1	:= fTabela("S036",nPosMsg1,5)
			EndIf
		Endif   
		
		nPosMsg2		:= fPosTab("S036",Alltrim(MENSAG2), "==", 4)
		If nPosMsg2 > 0 
			DESC_MSG2	:= fTabela("S036",nPosMsg2,5)
		EndIf  
		
		nPosMsg3		:= fPosTab("S036",Alltrim(MENSAG3), "==", 4)
		If nPosMsg3 > 0 
			DESC_MSG3	:= fTabela("S036",nPosMsg3,5)
		EndIf
		
		dbSelectArea("SRA")
		cFilialAnt := SRA->RA_FILIAL
	Endif
	
	Totvenc := Totdesc := 0
	            
	//Carrega tabela de INSS para utilizacao nos pro-labores/autonomos
	If !cPaisLoc $ "CHI|PAR|DOM|" .AND. !lFase4
		Car_inss(@aTInss,MesAno(dDataRef))
	EndIf
	
	If Len(aTinss) > 0
		nBInssPA := aTinss[Len(aTinss),1]
	EndIf
	
	//Retorna as verbas do funcionario, de acordo com os periodos selecionados
	aVerbasFunc	:= RetornaVerbasFunc(	SRA->RA_FILIAL					,; // Filial do funcionario corrente
										SRA->RA_MAT	  					,; // Matricula do funcionario corrente
										NIL								,; // 
										cRoteiro	  					,; // Roteiro selecionado na pergunte
										NIL			  					,; // Array com as verbas que deverão ser listadas. Se NIL retorna todas as verbas.
										aPerAberto	  					,; // Array com os Periodos e Numero de pagamento abertos
										aPerFechado	 	 				 ) // Array com os Periodos e Numero de pagamento fechados

	If cRoteiro <> "EXT"
		For nReg := 1 to Len(aVerbasFunc)
			If (Len(aPerAberto) > 0 .AND. !Eval(cAcessaSRC)) .OR. (Len(aPerFechado) > 0 .AND. !Eval(cAcessaSRD)) .Or.;
			   ( aVerbasFunc[nReg,7] <= 0 )
				DbSkip()
				Loop
			EndIf
			
			If cPaisLoc $ "ANG*PER" .AND. cBaseAux = "N"
				if PosSrv( aVerbasFunc[nReg,3] , SRA->RA_FILIAL , "RV_TIPOCOD" ) $ "34"
					DbSkip()
		   			Loop
				Endif
			Endif
			
			If PosSrv( aVerbasFunc[nReg,3] , SRA->RA_FILIAL , "RV_TIPOCOD" ) == "1"
				If cPaisLoc == "PAR" .and. Eval(cNroHoras) = 30
					LocGHabRea(Ctod("01/"+SubStr(DTOC(dDataRef),4)), Ctod(StrZero(F_ULTDIA(dDataRef),2)+"/"+Strzero(Month(dDataRef),2)+"/"+right(str(Year(dDataRef)),2),"ddmmyy"),@nHoras)
				Else
					nHoras := aVerbasFunc[nReg,6]	//-Eval(cNroHoras)
				Endif
				fSomaPdRec("P",aVerbasFunc[nReg,3],nHoras,aVerbasFunc[nReg,7])
				TOTVENC += aVerbasFunc[nReg,7]
				
				If cPaisLoc == "BOL"       //soma Horas Extras para localizacao Bolivia
					If PosSrv(aVerbasFunc[nReg,3], SRA->RA_FILIAL, "RV_HE") == "S"
						nHraExtra:= nHraExtra + aVerbasFunc[nReg,6]
					Endif                                          
					//Soma a verba de Horas Trabalhadas no Domingo id 0779
					
					If (aVerbasFunc[nReg,3] == aCodFol[779,1])  
						nPagoDom:= nPagoDom + aVerbasFunc[nReg,6]
					Endif                                        
				Endif 
				
			Elseif SRV->RV_TIPOCOD == "2"
				fSomaPdRec("D",aVerbasFunc[nReg,3],aVerbasFunc[nReg,6],aVerbasFunc[nReg,7])
				TOTDESC += aVerbasFunc[nReg,7]
			Elseif SRV->RV_TIPOCOD $ "3/4"
				//No Paraguai imprimir somente o valor liquido
				If cPaisLoc <> "PAR" .Or. (aVerbasFunc[nReg,3] == aCodFol[047,1])
					fSomaPdRec("B",aVerbasFunc[nReg,3],aVerbasFunc[nReg,6],aVerbasFunc[nReg,7])
				Endif
			Endif
		
			If (aVerbasFunc[nReg,3] $ aCodFol[10,1]+'*'+aCodFol[15,1]+'*'+aCodFol[27,1])
				nBaseIr += aVerbasFunc[nReg,7]
			ElseIf (aVerbasFunc[nReg,3] $ aCodFol[13,1]+'*'+aCodFol[19,1])
				nAteLim += aVerbasFunc[nReg,7]
			Elseif (aVerbasFunc[nReg,3] $ aCodFol[108,1]+'*'+aCodFol[17,1])
				nBaseFgts += aVerbasFunc[nReg,7]
			Elseif (aVerbasFunc[nReg,3] $ aCodFol[109,1]+'*'+aCodFol[18,1])
				nFgts += aVerbasFunc[nReg,7]
			Elseif (aVerbasFunc[nReg,3] == aCodFol[16,1])
				nBaseIrFe += aVerbasFunc[nReg,7]
			Endif
		Next nReg

	Elseif cRoteiro == "EXT"
		dbSelectArea("SR1")
		dbSetOrder(1)
		If dbSeek( SRA->RA_FILIAL + SRA->RA_MAT )
			While !Eof() .And. SRA->RA_FILIAL + SRA->RA_MAT ==	SR1->R1_FILIAL + SR1->R1_MAT
				If Semana # "99"
					If SR1->R1_SEMANA # Semana
						dbSkip()
						Loop
					Endif
				Endif
				If !Eval(cAcessaSR1)
					dbSkip()
					Loop
				EndIf
				If PosSrv( SR1->R1_PD , SRA->RA_FILIAL , "RV_TIPOCOD" ) == "1"
					fSomaPdRec("P",SR1->R1_PD,SR1->R1_HORAS,SR1->R1_VALOR)
					TOTVENC = TOTVENC + SR1->R1_VALOR  
				Elseif SRV->RV_TIPOCOD == "2"
					fSomaPdRec("D",SR1->R1_PD,SR1->R1_HORAS,SR1->R1_VALOR)
					TOTDESC = TOTDESC + SR1->R1_VALOR
				Elseif SRV->RV_TIPOCOD $ "3/4"
					fSomaPdRec("B",SR1->R1_PD,SR1->R1_HORAS,SR1->R1_VALOR)
				Endif
				dbskip()
			Enddo
		Endif
	Endif             
	     
	If cPaisLoc == "ARG"
		dbSelectArea("SRD")
		If dbSeek(SRA->RA_FILIAL + SRA->RA_MAT + cProcesso + cRoteiro + cPerAnt)
			cDtPago := dtoc(SRD->RD_DATPGT)
		Endif
	Endif
	dbSelectArea("SRA")
	
	If TOTVENC = 0 .And. TOTDESC = 0
		dbSkip()
		Loop
	Endif
	             
	If Vez == 0 .And. cTipoRot == "1"	//--> Verifica se for FOLHA.
		PerSemana() // Carrega Datas referentes a Semana.
	EndIf
	
	If nTipRel == 4 .and. !( lTerminal ) //4 Visualizar o PDF 5 Enviar PDF por email
		nLi := 0 // zero a variavel de linha
		fImprPDF(lPDFEmail, .F. ) // imprime a primeira vez
		fImprPDF(lPDFEmail, .T.) // imprime a primeira vez
		ASize(AProve,0)
		ASize(ADesco,0)
		ASize(aBases,0)    
	Endif
	
	dbSelectArea("SRA")
	SRA->( dbSkip() )	
	if(lQuebraFun)/*Se desejar imprimir um comprovante por folha...*/		
		__Eject()	
	   	LI := 4
		SetPrc(LI,0)
	endIf
	
	TOTDESC := TOTVENC := 0
EndDo
                       
If nTipRel == 4 .and. !( lTerminal )
	IF ( Type( "oPrinter" ) == "O" )
		oPrinter:Preview()
		oPrinter:EndPage()                                                          
		FreeObj(oPrinter)
		oPrinter := Nil
	Else
		MSGALERT( "Não foram localizados demonstrativos de pagamentos disponíveis para esta consulta.", "Atenção!"	 ) //"Não foram localizados demonstrativos de pagamentos disponíveis para esta consulta."  -  "Atenção!"	
	EndIf
EndIf

Return( cHtml )

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³fLanca    ³ Autor ³ R.H. - Ze Maria       ³ Data ³ 14.03.95 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Impressao das Verbas (Lancamentos) Form. Continuo          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ fLanca()                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function fLanca(nConta)   // Impressao dos Lancamentos

Local cString := Transform(aLanca[nConta,5],cPict2)
Local nCol := If(aLanca[nConta,1]="P",41,If(aLanca[nConta,1]="D",56,27))

@ LI,01 PSAY aLanca[nConta,2]
@ LI,05 PSAY aLanca[nConta,3]
If aLanca[nConta,1] # "B"        // So Imprime se nao for base
	@ LI,36 PSAY TRANSFORM(aLanca[nConta,4],"999.99")
Endif
@ LI,nCol PSAY cString
Li ++

Return Nil

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³fImpTeste ºAutor  ³R.H. - Natie        º Data ³  11/29/01   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Testa impressao de Formulario Teste                         º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP5                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static function fImpTeste(cString,nTipoRel)
Local nArea := 0
//--Comando para nao saltar folha apos o MsFlush.
SetPgEject(.F.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Descarrega teste de impressao                                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
MS_Flush()

If !fInicia(cString,nTipRel)
	Return
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define o Li com a a linha de impressão correten para não saltar linhas no teste  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
li := _Prow()

If nTipoRel == 2
	@ LI,00 PSAY AvalImp(Limite)
Endif

nArea := Select("SRA")
If nArea > 0
	DbSelectArea(nArea)
EndIF

//--> Só pergunta na primeira impressão!
If Vez == 0
	Vez++
	lRetCanc	:= Pergunte("GPR30A",.T.)
EndIf

Return Vez

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³fInicia   ºAutor  ³Natie               º Data ³  04/12/01   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Inicializa parametros para impressao                        º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP5                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function  fInicia(cString,nTipoRel)

If LastKey() = 27 .Or. nLastKey = 27
	Return  .F.
Endif

If nTipoRel == 1 .OR. nTipoRel == 2
	SetDefault(aReturn,cString)
Endif

If LastKey() = 27 .OR. nLastKey = 27
	Return .F.
Endif

Return .T.

/*
ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿
³Fun‡…o	   ³fMontaDtTcf 	³Autor³Ricardo Duarte     ³ Data ³13/08/2004³
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´
³Descri‡…o ³Retorna a data valida para a consulta do Terminal Consulta  ³
³          ³do Funcionario                                         		³
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³Sintaxe   ³<Vide Parametros Formais>									³
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³Parametros³<Vide Parametros Formais>									³
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³Retorno   ³cHtml  														³
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³Uso	   ³GPER030       										    	³
ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
Static Function fMontaDtTcf(cMesAno,nDia)

Local dDataValida
Default nDia := 0

dDataValida := stod(right(cMesAno,4)+left(cMesAno,2)+"01")
dDataValida := stod(right(cMesAno,4)+left(cMesAno,2)+strzero(f_UltDia(dDataValida),2))+nDia

return(dDataValida)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o	 ³f030Roteiro³ Autor ³ Tatiane Matias        ³ Data ³ 28/02/05 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Selecionar o Roteiro                               		   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ³ f030Roteiro()											   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ Generico 												   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function f030Roteiro(l1Elem, lTipoRet, lVExtras)

Local cTitulo	:= "Roteiro de Calculo"
Local nFor		:= 0
Local nElem		:= 0
Local MvPar
Local MvParDef	:= ""
Local MvRetor	:= ""

Private aSit:={}
l1Elem := If (l1Elem = Nil , .F. , .T.)

DEFAULT lTipoRet	:= .T.                    
DEFAULT lVExtras	:= .T.

cAlias := Alias() 					// Salva Alias Anterior

IF lTipoRet
	MvPar:=&(Alltrim(ReadVar()))	// Carrega Nome da Variavel do Get em Questao
	mvRet:=Alltrim(ReadVar())		// Iguala Nome da Variavel ao Nome variavel de Retorno
EndIF

dbSelectArea("SRY")
If dbSeek(cFilial)
	CursorWait()
	While !Eof() .And. SRY->RY_FILIAL == cFilial
		If !(SRY->RY_TIPO $ "3*4*G*J")
			Aadd(aSit, SRY->RY_CALCULO + " - " + Alltrim(SRY->RY_DESC))
			MvParDef += SRY->RY_CALCULO
		EndIf
		dbSkip()
	Enddo  
	If lVExtras
		Aadd(aSit, "EXT - Valores Extras")
		MvParDef += "EXT"
	EndIf
	CursorArrow()
Endif

IF lTipoRet
	IF f_Opcoes(@MvPar,cTitulo,aSit,MvParDef,,,l1Elem, GetSx3Cache("RY_CALCULO","X3_TAMANHO"))  // Chama funcao f_Opcoes
		CursorWait()
		For nFor := 1 To Len( mVpar ) Step 3
			IF ( SubStr( mVpar , nFor , 3 ) # "***" )
				mvRetor += SubStr( mVpar , nFor , 3 )
			Endif
		Next nFor
		&MvRet := Mvretor
		CursorArrow()	
	EndIF	
EndIF

dbSelectArea(cAlias) // Retorna Alias

Return( IF( lTipoRet , .T. , MvParDef ) )

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³fRDescUbig ºAutor  ³Alceu Pereira       º Data ³  09/02/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Exibir descricao do Ubigeo contido na tabela auxiliar para   º±±
±±º          ³localizacao Peru.                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Generico Localizacao Peru                                   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function fRDescUbig()

Local nAux:= 1       
Local cDescUbigeo := STR0020
Local aTabUbiGeo := {}
    
fCarrTab( @aTabUbiGeo, "S022", Nil)
    
IF ( len(aTabUbiGeo) >= 1 )
    nAux := 1
	While ( nAux <= len(aTabUbiGeo) )               
        If ( aTabUbiGeo[nAux,1] == "S022" .And. aTabUbiGeo[nAux,5] == SubStr(SRA->RA_CEP,1,2) .And. aTabUbiGeo[nAux,6] == SubStr(SRA->RA_CEP,3,2) .And. aTabUbiGeo[nAux,7] == SubStr(SRA->RA_CEP,5,2) )
    		cDescUbigeo := aTabUbiGeo[nAux,8]
    		nAux := LEN(aTabUbiGeo)
    	Endif
    	nAux++
    End
Endif

Return cDescUbigeo

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³fRTipoEmpreºAutor  ³Alceu Pereira       º Data ³  15/07/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Exibir descricao do tipo de empregado da tabela S029 para    º±±
±±º          ³localizacao Peru.                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Generico Localizacao Peru                                   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function fRTipoEmp()

Local nAux:= 1       
Local cTpEmprega := ""
Local aTabTipoEmp := {}
    
fCarrTab( @aTabTipoEmp, "S029", Nil)
    
IF ( len(aTabTipoEmp) >= 1 )
    nAux := 1    
    
    If cPaisLoc == "PER"
		While ( nAux <= len(aTabTipoEmp) )               
	        If ( aTabTipoEmp[nAux,1] == "S029" .And. aTabTipoEmp[nAux,5] == SRA->RA_TPFUNC )
	    		cTpEmprega := Trim(aTabTipoEmp[nAux,6])
	    		nAux := LEN(aTabTipoEmp)
	    	Endif
	    	nAux++
	    End          
    Else
    	cTpEmprega := " "
    EndIf
Endif

Return cTpEmprega

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³fRetFerFuncºAutor  ³Alceu Pereira       º Data ³  19/07/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Retornar as datas de periodo aquisitivo, data inicio e data  º±±
±±º          ³fim das ferias de um funcionario.                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Generico Localizacao Peru                                   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function fRetFerFunc(dDataPerAd, dDataPerAt ,dDataIniF , dDAtaFimF)

Local cFil   := SRA->RA_FILIAL
Local cMat   := SRA->RA_MAT
Local aArea	 := GetArea()

dbSelectArea("SRH")  
DbSetOrder( 1 )
	If dbSeek( cFil + cMat )
		While !Eof() .AND. SRH->RH_FILIAL == cFil .AND. SRH->RH_MAT == cMat
			If AllTrim(Str(Ano(SRH->RH_DATAINI))) == cAno .AND. SRH->RH_FILIAL == cFil .AND. SRH->RH_MAT == cMat
				dDataPerAd := SRH->RH_DATABAS 
				dDataPerAt := SRH->RH_DBASEAT
				dDataIniF := SRH->RH_DATAINI
				dDAtaFimF := SRH->RH_DATAFIM
				Exit		
			Endif
		dbSkip()
		EndDo
	Endif
RestArea(aArea)   
Return         

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³fRTipoEmpreºAutor  ³Alceu Pereira       º Data ³  19/07/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Exibir descricao do tipo de AFP da tabela S004 para          º±±
±±º          ³localizacao Peru.                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Generico Localizacao Peru                                   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function fRDescAFP()
                                         
Local nAux:= 1       
Local cDescAfp := ""
Local aTabDescAFP := {}
    
fCarrTab( @aTabDescAFP, "S004", Nil)
    
IF ( len(aTabDescAFP) >= 1 )
    nAux := 1     
    
    If cPaisLoc == "COL" .OR. cPaisLoc == "PER"
		While ( nAux <= len(aTabDescAFP) )               
	        If ( aTabDescAFP[nAux,1] == "S004" .And. aTabDescAFP[nAux,5] == SRA->RA_CODAFP )
	    		cDescAfp := Trim(aTabDescAFP[nAux,6])
	    		nAux := LEN(aTabDescAFP)
	    	Endif
	    	nAux++
	    End    
    Else
		cDescAfp := ' '    
    EndIf
Endif

Return cDescAfp

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³fAfasSub   ºAutor  ³Alceu Pereira       º Data ³  25/07/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Retorna quantidade de dias de afastamentos subsidiados pela  º±±
±±º          ³empresa.                                                     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Generico Localizacao Peru.                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function fAfasSub(nDiasAfs) 

Local cFil   := SRA->RA_FILIAL
Local cMat   := SRA->RA_MAT
Local aArea	 := GetArea()        

dbSelectArea("SR8")  
DbSetOrder( 1 )
	If dbSeek( cFil + cMat )
		While !Eof() .AND. SR8->R8_FILIAL == cFil .AND. SR8->R8_MAT == cMat
			If cMes >= StrZero(Month(SR8->R8_DATAINI),2) .AND. cMes <= StrZero(Month(SR8->R8_DATAFIM),2) .AND. cAno = StrZero(Year(SR8->R8_DATAFIM),4)
				If SR8->R8_DPAGAR > 0
					nDiasAfs := nDiasAfs + SR8->R8_DPAGAR
				Endif                               
			Endif			
		  dbSkip()
		EndDo
	Endif
RestArea(aArea)

Return nDiasAfs 

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³fHorasFunc ºAutor  ³Alceu Pereira       º Data ³  25/07/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Retorna quantidade de horas trabalhadas ou quantidade de     º±±
±±º          ³horas extras feitas pelo funcionario.                        º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Generico Localizacao Peru.                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/            
Static Function fHorasFunc(lHorasExtras, nQuantHoras, Semana)

Local aArea	        := GetArea()        
Local cChaveSem     := ""
Local aVerbasLIQ    := {}
Local nAux			:= 0	
Local aPerAberto    := {}
Local aPerFechado   := {}
Local aPerTodos     := {}

If lHorasExtras == .T.

	fRetPerComp( 	cMes		  ,;	// Obrigatorio - Mes para localizar as informacoes
					cAno		  ,;	// Obrigatorio - Ano para localizar as informacoes
					xFilial("RCH"),;	// Opcional - Filial a Pesquisar
							  ,;		// Opcional - Filtro por Processo
				              ,;		// Opcional - Filtro por Roteiro
					@aPerAberto	  ,;	// Por Referencia - Array com os periodos Abertos
					@aPerFechado, ;		// Por Referencia - Array com os periodos Fechados
					@aPerTodos    ;		// Por Referencia - Array com os periodos Abertos e Fechados em Ordem Crescente
					 )
Endif					 

nQuantHoras := 0	   

cChaveSem := StrZero(Year(dDataRef),4)+StrZero(Month(dDataRef),2) 

dbSelectArea( "RCF" )
DbSetOrder( 1 )                                                                     

If RCF->( dbSeek( xFilial("RCF") + cChaveSem,.T.)) .AND. lHorasExtras == .F.
	nQuantHoras := RCF->RCF_HRSTRA + RCF->RCF_HRSDSR
Else
	aVerbasLIQ := RetornaVerbasFunc(SRA->RA_FILIAL, SRA->RA_MAT, ,fGetCalcRot("1"), , aPerAberto, aPerFechado )  
	For nAux:= 1 to len(aVerbasLIQ)
		If (PosSrv(aVerbasLIQ[nAux,3], SRA->RA_FILIAL, "RV_HE")) == "S"
			If PosSrv( aVerbasLIQ[nAux,3], SRA->RA_FILIAL, "RV_TIPOCOD" ) $ "1*3"
				nQuantHoras += aVerbasLIQ[nAux,6]
			Elseif PosSrv( aVerbasLIQ[nAux,3], SRA->RA_FILIAL, "RV_TIPOCOD" ) $ "2*4"
				nQuantHoras -= aVerbasLIQ[nAux,6]
			Endif
		Endif 
	Next		
Endif

RestArea (aArea)      

Return nQuantHoras


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³fTrocaCar      ³ Autor ³ Alceu Pereira    ³ Data ³10/12/2010³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Troca carecter da string passada como parametro            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ GPER030                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function fTrocaCar(cTexto) 

Local aAcento :={}
Local aAcSubs :={}
Local cImpCar := Space(01)
Local cImpLin :=""
Local cAux 	  :=""
Local cAux1	  :=""   
Local nTamTxt := Len(cTexto)	
Local nCount  := 0
Local nPos
  
aAcento := 	{	"€","‡","","Å","…","†"," ","„","¦",;
					"É","ˆ","‚","¡","“","”","•","¢","§",;
					"£","a","b","c","d","e","f","g","h",;
					"i","j","k","l","m","n","o","p","q",;
					"r","s","t","u","v","x","z","w","y",;
					"A","B","C","D","E","F","G","H","I",;
					"J","K","L","M","N","O","P","Q","R",;
					"S","T","U","V","X","Z","W","Y","0",;
					"1","2","3","4","5","6","7","8","9",;
					"&"}

aAcSubs := 	{	"C","c","A","A","a","a","a","a","a",;
					"E","e","e","i","o","o","o","o","o",;
					"u","a","b","c","d","e","f","g","h",;
					"i","j","k","l","m","n","o","p","q",;
					"r","s","t","u","v","x","z","w","y",;
					"A","B","C","D","E","F","G","H","I",;
					"J","K","L","M","N","O","P","Q","R",;
					"S","T","U","V","X","Z","W","Y","0",;
					"1","2","3","4","5","6","7","8","9",;
					"E"}

For nCount :=1 TO Len(AllTrim(cTexto))
	cImpCar	:=SubStr(cTexto,nCount,1)
	cAux	:=Space(01)  
    nPos 	:= 0
	nPos 	:= Ascan(aAcento,cImpCar)
	If nPos > 0
		cAux := aAcSubs[nPos]
	Elseif (cAux1 == Space(1) .And. cAux == space(1)) .Or. Len(cAux1) == 0
		cAux :=	""
	EndIf		
    cAux1 	:= 	cAux
	cImpCar	:=	cAux
	cImpLin	:=	cImpLin+cImpCar

Next nCount

cImpLin := Left(cImpLin+Space(nTamTxt),nTamTxt)

Return cImpLin  

/************Impressão PDF**********************************************************************************************/
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³fImprPDF  ³ Autor ³ R.H. - Emerson Cmapos ³ Data ³30/06/2015³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ IMRESSAO DO RECIBO EM PDF                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ fImprPDF()                                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function fImprPDF(lPDFEmail, lViaEmp)
Local nConta 		:= 0
Local cPath			:= ""
Local cFile			:= ""
Local cEmail		:= ""
Local cIdentUni		:= ""                      

default lPDFEmail	:= .F.
default lViaEmp 	:= .F.

//Gerar o PDF na Tela
If (!lPDFEmail .or. !lViaEmp) .AND. Empty(oPrinter) 
	oPrinter	:= FWMSPrinter():New("GPER030"  ,6,.F.,cPath,.T.,,,,,.F.)
	oPrinter:lViewPDF 	:= .T.
EndIf

//Gerar o PDF no Servidor para enviar via email
If lPDFEmail
	cIdentUni	:= DtoS(date())+SUBSTR(TIME()	, 1, 2) +SUBSTR(TIME(), 4, 2) +SUBSTR(TIME(), 7, 2)+AllTrim(Str(Int(Seconds()))) 
	cFile		:= SRA->RA_FILIAL+SRA->RA_MAT+dtos(dDataRef)+cIdentUni+"RecPag"  
	oPrinter	:= FWMSPrinter():New(cFile  ,6,.F.,cPath,.T.,,,,,.F.)
	oPrinter:lInJob 		:= .T.
	cEmail		:= If(SRA->RA_RECMAIL=="S",SRA->RA_EMAIL,"")
	If Empty(cEmail) 
		If Empty(aTitle)
			Aadd( aTitle, OemToAnsi("LOG das matrículas que não foram enviadas") ) //"LOG das matrículas que não foram enviadas"
			Aadd( aLog,{} )
			Aadd( aLog, { PADR( OemToAnsi("Filial"), FWGETTAMFILIAL) + " - " + PADR( OemToAnsi("Matricula"), 10 ) + " - " + PADR( OemToAnsi("Nome"), 45 ) + " - " + OemToAnsi("Ocorrência") } ) //"Filial"#"Matrícula"#"Nome"#"Ocorrência"
		EndIf
		Aadd( aLog, { PADR( SRA->RA_FILIAL, FWGETTAMFILIAL) + " - " + PADR( SRA->RA_MAT, 10) + " - " + PADR( SRA->RA_NOME, 45) + " - " + OemToAnsi("Sem e-mail cadastrado e/ou nao recebe e-mail (verif. campos: RA_EMAIL/RA_RECMAIL)") } ) //"Sem e-mail cadastrado e/ou nao recebe e-mail (verif. campos: RA_EMAIL/RA_RECMAIL)"
		Return()
	Else
		aAdd(aEmail, {{SRA->RA_NOME, cEmail,If(SRA->RA_RECMAIL=="S",.T.,.F.)},SRA->RA_FILIAL,SRA->RA_MAT,dtos(dDataRef),cIdentUni})	
    EndIf
EndIf

if !lViaEmp
	oPrinter:lServer 			:= .T.
	oPrinter:SetResolution(75)
	oPrinter:SetPortrait() //SetLandscape() // 
	oPrinter:SetPaperSize(DMPAPER_A4)
	oPrinter:SetMargin(60,60,60,60)
	oPrinter:nDevice 			:= IMP_PDF
	oPrinter:StartPage()
EndIf

If li >= 60 .and. !lViaEmp
	li := 0
Endif

if lViaEmp  
	nLi+=40	
	For i := 5 to 1500 step 50		
		oPrinter:Line(nLi, i, nLi, i + 30)
	Next i
	nLi+=40	
endIf 

//Cabeçalho
fCabPDF(oPrinter)
//Corpo
fLancPDF(oPrinter, nConta, lViaEmp)

If lPDFEmail
	oPrinter:Preview()
	oPrinter:EndPage()
	//oPrinter:Print()                                                           
	FreeObj(oPrinter)
	oPrinter := Nil
ElseIf lViaEmp
	oPrinter:EndPage()
EndIF

Return Nil

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³fCabPDF   ³ Autor ³ R.H. - Emerson Campos ³ Data ³30/06/2015³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ IMRESSAO Cabecalho em PDF                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ fCabPDF()                                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function fCabPDF(oPrinter)
Local cCodFunc	:= ""		//-- Codigo da Funcao do funcionario
Local cDescFunc	:= ""		//-- Descricao da Funcao do Funcionario
Local cDescCC	:= ""		//-- Descricao do Centro de Custo

/*
ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
³ Carrega Funcao do Funcion. de acordo com a Dt Referencia     ³
ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
fBuscaFunc(dDataRef, @cCodFunc, @cDescFunc   )

nLi += 10
oPrinter:Box( nLi, 004, nLi+20, 585, "-4" )			// Caixa da linha 
nLi += 10
oPrinter:SayAlign(nLi-8,004,"RECIBO DE PAGAMENTO  ",oFont4,585,005, /**/, 2, 1 ) //"RECIBO DE PAGAMENTO  "
nLi += 10
oPrinter:Box( nLi+5, 004, nLi+65, 585, "-4" )			// Caixa da linha
nLi += 20
oPrinter:Say(nLi,004,Space(3)+Substr("| Empresa   : ", 3) +  DESC_Fil,oFont2N)	//"| Empresa   : "

If cPaisLoc == "BRA"
	oPrinter:Say(nLi,450,"CNPJ  : "+ " " + Desc_CGC,oFont2N)	//"CNPJ  : "
Else
	oPrinter:Say(nLi,450,AllTrim(RetTitle("A1_CGC")) + ": " + Desc_CGC,oFont2N)	//"CNPJ  : "
EndIf

nLi += 10
cDescCC := If( lLpt1, fTAcento(DescCc(SRA->RA_CC,SRA->RA_FILIAL)), DescCc(SRA->RA_CC,SRA->RA_FILIAL) )
oPrinter:Say(nLi, 004,Space(3)+Substr("| C Custo   : ", 3) + SRA->RA_CC + " - " + cDescCC,oFont2N)	//"| C Custo   : "

If !Empty(Semana) .And. Semana # "99" .And.  Upper(SRA->RA_TIPOPGT) == "S"
	oPrinter:Say(nLi, 450,"Sem." + Semana + " (" + cSem_De + "a" + cSem_Ate + ")",oFont2N)	//'Sem.'###' a '
Else
	oPrinter:Say(nLi, 450,MesExtenso(MONTH(dDataRef))+"/"+STR(YEAR(dDataRef),4),oFont2N)
EndIf

nLi += 10
oPrinter:Say(nLi,004,Space(3)+Substr("| Matricula : ",3) + SRA->RA_MAT + "   " + "Nome  : " + If( lLpt1, fTAcento(SRA->RA_NOME), SRA->RA_NOME ),oFont2N)	//"| Matricula : " XXXXX +"   " + Nome  : " XXXXXXXXXXXXXXX
oPrinter:Say(nLi,447," Local : " + SRA->RA_FILIAL,oFont2N)	//" Local : "

nLi += 10
oPrinter:Say(nLi,004,Space(3)+Substr("| Funcao    : ",3)+cCodFunc+" - "+If( lLpt1, fTAcento(cDescFunc), cDescFunc ),oFont2N)	//"| Funcao    : "
If !Empty(SRA->RA_DEPTO)
	oPrinter:Say(nLi,240,"Depto." + ": " + SRA->RA_DEPTO + " - " + fDesc('SQB',SRA->RA_DEPTO,'QB_DESCRIC'),oFont2N)	//-9caracteres+30caracteres
EndIf
//oPrinter:Say(nLi,448," Local : " + SRA->RA_FILIAL,oFont2N)	//" Local : "
ORDEMZ ++
oPrinter:Say(nLi,447," Ordem : " + StrZero(ORDEMZ,4) ,oFont2N)	//"Ordem : "
//oPrinter:Say(nLi,545,StrZero(ORDEMZ,4),oFont2N)
nLi += 10

oPrinter:Say(nLi,004,Space(3) + Substr("| Salario    : ",3) + "  " + Alltrim(Transform(nSalario,cPict2)),oFont2N)	//Salario
oPrinter:Say(nLi,447, " CBO : " + fCodCBO(SRA->RA_FILIAL,cCodFunc ,dDataRef),oFont2N)	//" CBO : "

nLi += 10

oPrinter:Box( nLi, 004, nLi+23, 585, "-4" )			// Caixa da linha 
nLi += 15
oPrinter:Say(nLi,004,"   "+Substr("| P R O V E N T O S ", 3),oFont3)	//"| P R O V E N T O S "
oPrinter:Say(nLi,195,"  D E S C O N T O S",oFont3)	//"  D E S C O N T O S"
oPrinter:Say(nLi,390,"  B A S E S",oFont3)	//"  B A S E S"
nLi += 05
Return Nil


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³fLancPDF  ³ Autor ³ R.H. - Emerson Campos ³ Data ³01/07/2015³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Impressao das Verbas (Lancamentos) PDF                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ fLancPDF()                                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function fLancPDF(oPrinter, nConta, lViaEmp)   // Impressao dos Lancamentos

Local nTermina  	:= 0
Local nCont    		:= 0
Local nCont1   		:= 0
Local nValidos  	:= 0
Local aPos     		:= {}
Local nSpace    	:= 0
Local cMsgAniv  	:= ""
Local nPosFCab		:= 114 //Posição final do cabeçalho fCabPDF()
//Local nLi			:= nPosFCab                   

default lViaEmp		:= .F.

	If ( Ascan(aProve , {|aProve| aProve[3] >= 1000000} ) > 0 ) 
	  cPict3 := "@E 9999,999.99" // Variavel private criada na funcao R030Imp
	  aPos := {004,006,193,195,388,390,585}
	  nSpace := 1
	Else  
	  cPict3 := "@E 999,999.99"
	  aPos := {004,006,195,197,390,392,585}  
	EndIf
	
	nTermina := Max(Max(LEN(aProve),LEN(aDesco)),LEN(aBases))
	
	//oPrinter:Box(  nLi+5, aPos[1], nLi+520, aPos[7], "-4" )
	oPrinter:Box(  nLi+5, aPos[1], nLi+150, aPos[7], "-4" )
	//oPrinter:Box(  nLi+5, aPos[3], nLi+520, aPos[5], "-4" )
	oPrinter:Box(  nLi+5, aPos[3], nLi+150, aPos[5], "-4" )
	
	For nCont := 1 To nTermina
		
		//Quebrar pagina
		// somente imprime CONTINUA e quebra o recibo em dois se houver mais verbas a serem impressas
		If nValidos == 50 .and. nTermina > nValidos
			nLi += 20
			oPrinter:Box(  nLi+5, aPos[1], nLi+40, aPos[7], "-4" )
			nLi += 20		
			oPrinter:SayAlign(nLi-5,aPos[1],"CONTINUA !!!",oFont3,aPos[7],005, /**/, ALIGN_H_CENTER, ALIGN_V_CENTER ) // "CONTINUA !!!"
			nLi += 20
			
			oPrinter:EndPage()
			oPrinter:StartPage()
			
			nLi := 0
			fCabPDF(oPrinter)
			
			nValidos := 0
			
			If nLi >= 614
				nLi := nPosFCab   //Posição final do cabeçalho fCabPDF()
			Endif	
			
			oPrinter:Box(  nLi+5, aPos[1], nLi+520, aPos[7], "-4" )
			oPrinter:Box(  nLi+5, aPos[3], nLi+520, aPos[5], "-4" )
					
		EndIf
	 
	 	nLi += 10	
		//Imprime Proventos
		IF nCont <= LEN(aProve)	
			oPrinter:SayAlign(nLi,aPos[2],aProve[nCont,1],oFont1,195,005,,ALIGN_H_LEFT)
			oPrinter:SayAlign(nLi,aPos[2],TRANSFORM(aProve[nCont,2],'999.99'),oFont1,130,005,,ALIGN_H_RIGHT)
			oPrinter:SayAlign(nLi,aPos[2],TRANSFORM(aProve[nCont,3],cPict3),oFont1,189,005,,ALIGN_H_RIGHT)                                 
		ENDIF
		//Imprime Descontos
		IF nCont <= LEN(aDesco)
			oPrinter:SayAlign(nLi,aPos[4],aDesco[nCont,1],oFont1,390,005,,ALIGN_H_LEFT)
			oPrinter:SayAlign(nLi,aPos[4],TRANSFORM(aDesco[nCont,2],'999.99'),oFont1,130,005,,ALIGN_H_RIGHT)
			oPrinter:SayAlign(nLi,aPos[4],TRANSFORM(aDesco[nCont,3],cPict3),oFont1,192,005,,ALIGN_H_RIGHT)
		ENDIF
		//Imprime Base
		IF nCont <= LEN(aBases)
			If cBaseAux = "S" 
				oPrinter:SayAlign(nLi,aPos[6],aBases[nCont,1],oFont1,390,005,,ALIGN_H_LEFT)
				oPrinter:SayAlign(nLi,aPos[6],TRANSFORM(aBases[nCont,2],'999.99'),oFont1,130,005,,ALIGN_H_RIGHT)
				oPrinter:SayAlign(nLi,aPos[6],TRANSFORM(aBases[nCont,3],cPict3),oFont1,192,005,,ALIGN_H_RIGHT)
			EndIf
		ENDIF
		
		//---- Soma 1 nos nValidos e Linha
		nValidos ++	
	Next nCont
	
	//Quando o total de verbas não atinge o total máximo, seta nlin para começar o cabeçalho.
	//nLi	+= (52 - nValidos) * 10
	nLi	+= (15 - nValidos) * 10
	
	//oPrinter:Box(  nLi+5, aPos[1], nLi+65, aPos[3], "-4" )
	oPrinter:Box(  nLi+5, aPos[1], nLi+45, aPos[3], "-4" )
	
	oPrinter:SayAlign(nLi+08,005,Space(2)+If( lLpt1 .And. !Empty(DESC_MSG1), fTAcento(DESC_MSG1), DESC_MSG1 ),oFont1,196,005, , 0, 1 )   //Mensagem
	oPrinter:SayAlign(nLi+23,005,Space(2)+If( lLpt1 .And. !Empty(DESC_MSG2), fTAcento(DESC_MSG2), DESC_MSG2 ),oFont1,196,005, , 0, 1 )   //Mensagem
	oPrinter:SayAlign(nLi+38,005,Space(2)+If( lLpt1 .And. !Empty(DESC_MSG3), fTAcento(DESC_MSG3), DESC_MSG3 ),oFont1,196,005, , 0, 1 )   //Mensagem
	
	cMsgAniv := " 	                                     "	
	IF MONTH(dDataRef) = MONTH(SRA->RA_NASC)
		cMsgAniv := Space(2)+STR0038		//"F E L I Z   A N I V E R S A R I O  ! !"
	ENDIF
	
	oPrinter:SayAlign(nLi+53,005,Space(2)+cMsgAniv,oFont1,196,005, , 0, 1 )	
	
	oPrinter:Box( nLi+5, aPos[3], nLi+25, aPos[5], "-4" )
	oPrinter:Box( nLi+5, aPos[5], nLi+25, aPos[7], "-4" )
	nLi += 20
	
	oPrinter:SayAlign(nLi-10,aPos[4],Space(2)+UPPER(STR0065),oFont2N,196,005, , 0, 1 )   //"| TOTAL BRUTO    "
	oPrinter:SayAlign(nLi-10,aPos[6],Space(2)+UPPER(STR0066),oFont2N,196,005, , 0, 1 )     //" TOTAL DESCONTOS     "
	oPrinter:SayAlign(nLi-10,aPos[4],TRANSFORM(TOTVENC , cPict3)+ Space(2),oFont2,196,005, , 1, 1 )   //"| TOTAL BRUTO    "
	oPrinter:SayAlign(nLi-10,aPos[6],TRANSFORM(TOTDESC , cPict3)+ Space(2),oFont2,196,005, , 1, 1 )     //" TOTAL DESCONTOS     "
	
	oPrinter:Box( nLi+5, aPos[3], nLi+25, aPos[5], "-4" )
	oPrinter:Box( nLi+5, aPos[5], nLi+25, aPos[7], "-4" )
	nLi += 20
	
	oPrinter:SayAlign(nLi-10,aPos[4],Space(2)+Substr(STR0033,3)+ Space(2) + AllTrim(SRA->RA_BCDEPSA)+" - "+substr(fDescBco(SRA->RA_BCDEPSA,SRA->RA_FILIAL),1,25),oFont2,196,005, , 0, 1 )  	//"| CREDITO:"
	oPrinter:SayAlign(nLi-10,aPos[6],Space(2)+UPPER(STR0055)+":",oFont2N,196,005, , 0, 1 )   //"| LIQUIDO A RECEBER     "
	oPrinter:SayAlign(nLi-10,aPos[6],TRANSFORM((TOTVENC-TOTDESC) , cPict3 )+ Space(2),oFont2,196,005, , 1, 1 )   //"| LIQUIDO A RECEBER     "
	
	oPrinter:Box( nLi+5, aPos[3], nLi+25, aPos[5], "-4" )
	oPrinter:Box( nLi+5, aPos[5], nLi+25, aPos[7], "-4" )
	nLi += 20
	
	oPrinter:SayAlign(nLi-10,aPos[4],Space(2)+UPPER(STR0040)+ Space(2)+SRA->RA_CTDEPSA,oFont2,196,005, , 0, 1 )   //"| CONTA:"
		
	oPrinter:Box(  nLi+5, aPos[1], nLi+50, aPos[7], "-4" )
	nLi += 40
	oPrinter:SayAlign(nLi-25,005,IIF(!lViaEmp,"Via-Empregado","Via-Empresa"),oFont2N,540,005, , ALIGN_H_RIGHT, 1 )                         
	oPrinter:SayAlign(nLi-15,005,Space(2)+SubStr(STR0036,3),oFont2N,585,005, , ALIGN_H_LEFT, 1 )//"| Recebi o valor acima em ___/___/___ "
	oPrinter:Line(nLi-3,200,nLi-3,450,,"-4")
	
	if lViaEmp		    		
		oPrinter:EndPage()
	endif
	
	cPict3 := "@E 999,999.99"  // Restauro o valor original de cPict3, declarado na funcao R030Imp.
Return Nil

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ fEnvPDFEmail³ Autor ³ Emerson Campos     ³ Data ³09/07/2015³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Prepara o envio do email com o PDF Anexado                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³                                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function fEnvPDFEmail()
Local cEndSpool := ""
Local nI		:= 0
Local cSubject	:= " Demosntrativo de Pagamento "		//" Demosntrativo de Pagamento "
Local cMsg		:= ""
Local cPathFile	:= "" 
Local cMsgErr1	:= ""	//Erro envio
Local cMsgErr2	:= ""	//Sem email cadastrado
Local cMsgErr3	:= ""	//Opção não envia email habilitada

Private cEmailDP	:= NIL
Private cMailConta	:= NIL
Private cMailServer	:= NIL
Private cMailSenha	:= NIL
	
	// Busca parametros 
	cMailConta	:= If(cMailConta == NIL,GETMV("MV_EMCONTA"),cMailConta)		//Conta utilizada p/envio do email
	cMailServer	:= If(cMailServer == NIL,GETMV("MV_RELSERV"),cMailServer)	//Server
	cMailSenha	:= If(cMailSenha == NIL,GETMV("MV_EMSENHA"),cMailSenha)
	cEmailDP	:= If(cEmailDP == NIL,GETMV("MV_GPEMAIL"),cEmailDP)			//Email do responsável de Depto Pessoal
	
	// Verifica se existe o SMTP Server 
	If 	Empty(cMailServer)
		Help(" ",1,"SEMSMTP")//"O Servidor de SMTP nao foi configurado !!!" ,"Atencao"
		Return(.F.)
	EndIf
	
	// Verifica se existe a CONTA 
	If 	Empty(cMailConta)
		Help(" ",1,"SEMCONTA")//"A Conta do email nao foi configurado !!!" ,"Atencao"
		Return(.F.)
	EndIf
	
	// Verifica se existe a Senha
	If 	Empty(cMailSenha)
		Help(" ",1,"SEMSENHA")	//"A Senha do email nao foi configurado !!!" ,"Atencao"
		Return(.F.)
	EndIf
	
	For nI := 1 To Len(aEmail)
		cPathFile	:= "spool\"+aEmail[nI,2]+aEmail[nI,3]+aEmail[nI,4]+aEmail[nI,5]+"RecPag"

		If aEmail[nI,1,3]
			If ! Empty(AllTrim(aEmail[nI,1,2]))
				cSubject	:= " Demosntrativo de Pagamento " + " - " + MesExtenso(MONTH(SToD(aEmail[nI,4])))+"/"+STR(YEAR(StoD(aEmail[nI,4])),4)
				
				cMsg := "Sr.(a)"+chr(13)+ "  " + aEmail[nI,1,1]+","+chr(10)	//"Sr.(a)"  
				cMsg += chr(13)+chr(10)
				cMsg += chr(13)+chr(10)
				cMsg += "Segue em anexo o seu demonstrativo referente a:"+" "+MesExtenso(MONTH(SToD(aEmail[nI,4])))+"/"+STR(YEAR(StoD(aEmail[nI,4])),4)+chr(13)+chr(10) //"Segue em anexo o seu demonstrativo referente a:" Maio/2015
				cMsg += chr(13)+chr(10)
				cMsg += chr(13)+chr(10)
				cMsg += "Atenciosamente,"+chr(13)+chr(10)  //"Atenciosamente,"				
				
				// Envia e-mail p/funcionario 
				If !GPEMail(cSubject,cMsg,aEmail[nI,1,2],{cPathFile+".pdf"})
					//Falha no envio
					cMsgErr1	+= "     " + aEmail[nI,2] + " - " + aEmail[nI,3] + " - " + aEmail[nI,1,1] + chr(13) + chr(10)
				Else
					lEnvioOK := .T.
				EndIf				
			Else
				//Sem Email cadastrado
				cMsgErr2	+= "     " + aEmail[nI,2] + " - " + aEmail[nI,3] + " - " + aEmail[nI,1,1] + chr(13) + chr(10)
			EndIf
		Else
			//Marcado para não receber o email
			cMsgErr3	+= "     " + aEmail[nI,2] + " - " + aEmail[nI,3] + " - " + aEmail[nI,1,1] + chr(13) + chr(10)
		EndIf
		
		If File(cPathFile+".pdf")
			fErase(cPathFile+".pdf")
		EndIf
		
		If File(cPathFile+".rel")
			fErase(cPathFile+".rel")
		EndIf
	Next nI
	
	If ! Empty(cEmailDP)
		If ! Empty(cMsgErr1) .OR. ! Empty(cMsgErr2)  .OR. ! Empty(cMsgErr2)
			cSubject	:= "Erros ocorridos durante o envio dos demonstrativos de pagamento" //"Erros ocorridos durante o envio dos demonstrativos de pagamento"	
			cMsg := "Sr.(a)"+"," + chr(13) + chr(10)	//"Sr.(a)"  
			cMsg += chr(13) + chr(10)
			cMsg += chr(13) + chr(10)
			cMsg += "Ocorreram alguns erros durante o envio de demonstrativo de pagamento por email, veja a relação abaixo:" + chr(13) + chr(10) //"Ocorreram alguns erros durante o envio de demonstrativo de pagamento por email, veja a relação abaixo:
			cMsg += chr(13) + chr(10)
			cMsg += chr(13) + chr(10)
			If ! Empty(cMsgErr1)
				cMsg += "- "+ "Erro durante o envio da mensagem" +chr(13)+chr(10)	//- Erro durante o envio da mensagem				
				cMsg += cMsgErr1 + chr(13) + chr(10)
				cMsg += chr(13) + chr(10)
				cMsg += chr(13) + chr(10)
			EndIf
			If ! Empty(cMsgErr2)
				cMsg += "- "+ "Falta de endereço de email cadastrado para o envio:" +chr(13)+chr(10)	//- Falta de endereço de email cadastrado para o envio:
				cMsg += cMsgErr2 + chr(13) + chr(10)
				cMsg += chr(13) + chr(10)
				cMsg += chr(13) + chr(10)
			EndIf
			If ! Empty(cMsgErr3)
				cMsg += "- "+ "Marcado a opção de não receber email no caastro do funcionário:" +chr(13)+chr(10)	//- Marcado a opção de não receber email no caastro do funcionário:
				cMsg += cMsgErr3 + chr(13) + chr(10)
				cMsg += chr(13) + chr(10)
				cMsg += chr(13) + chr(10)
			EndIf
			cMsg += "Atenciosamente,"+chr(13)+chr(10)  //"Atenciosamente,"
			
			GPEMail(cSubject,cMsg,cEmailDP)
		EndIf
	EndIf 
Return Nil 

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ Scheddef    ³ Autor ³ Emerson Campos     ³ Data ³08/07/2015³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Trazer o grupo de perguntas GPER030 quando houver schedule ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³                                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function SchedDef() 
	Local aParam
	Local aOrd     := {OemToAnsi(" Matrícula         ")}
	aParam := { "R",;      // Tipo R para relatorio P para processo   
				"GPER030",;	// Pergunte do relatorio, caso nao use passar ParamDef            
				"",;  	// Alias            
   				aOrd,;   	// Array de ordens   
				""}	
				  
Return aParam  

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ limpArqPdf  ³ Autor ³ Emerson Campos     ³ Data ³08/07/2015³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Limpar os arquivos PDF que são gerados pelo schedule       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³                                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function limpArqPdf()
Local cPath	:= "\spool\" //GetSrvProfString ("ROOTPATH","")+"\spool\"
	AEVAL(DIRECTORY(cPath+"*RecPag.pdf"), { |aFile| FERASE(cPath+aFile[1]) })	
Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿
³Fun‡…o    ³fCabecZDom³ Autor ³ Jonathan Gonzalez     ³ Data ³21.07.2016³
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´
³Descri‡…o ³ IMRESSAO Cabe‡alho Form ZEBRADO                            ³
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³Sintaxe   ³ fCabecZDom()                                               ³
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³ Uso      ³ Generico                                                   ³
ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function fCabecZDom()   // Cabecalho do Recibo Zebrado
	Local aArea     := GetArea()
	Local cCodFunc  := "" //-- codigo da Funcao do funcionario
	Local cDescFunc := "" //-- Descricao da Funcao do Funcionario
	Local cCargo    := "" //-- Codigo Cargo
	Local cDescCar  := "" //-- Descripcion Cargo.
	Local cFechaPer := DTOC(Posicione("RCH", 1 , xfilial("RCH")+cProcesso+cPeriodo+cSemana+cRoteiro , "RCH_DTINI")) +;
	                    " - " + DTOC(Posicione("RCH", 1 , xfilial("RCH")+cProcesso+cPeriodo+cSemana+cRoteiro , "RCH_DTFIM"))

		/* ³ Carrega Funcao do Funcion. de acordo com a Dt Referencia     ³ */
		fBuscaFunc(dDataRef, @cCodFunc, @cDescFunc   )
		@ Li,00 PSAY Avalimp(Limite)
		LI ++
		@ LI,00 PSAY "*"+REPLICATE("=",130)+"*"

		LI ++
		@ LI,00  PSAY "|"
		@ LI,46  PSAY "RECIBO DE PAGAMENTO  "		//"RECIBO DE PAGAMENTO  "
		@ LI,131 PSAY "|"

		LI ++
		@ LI,00 PSAY "|"+REPLICATE("-",130)+"|"

		LI ++
		@ LI,00  PSAY "| Empresa   : " +  DESC_Fil		//"| Empresa   : "
		@ LI,92  PSAY " Local : " + SRA->RA_FILIAL	//" Local : "
		@ LI,131 PSAY "|"

		LI ++
		@ LI,00 PSAY "| Proceso  :" +" "+ cProcesso + SPACE(5) + "Proced.: " + cRoteiro +; //"| Proceso  :" ###  "Proced.: " ####
		             SPACE(5) + "Periodo: " + cPeriodo + SPACE(5) + "No Pago:  " + Semana + SPACE(5) + "Fecha de pago del " + cFechaPer //"Periodo: " ### "No Pago:  " ## "Fecha de pago del "
		@ LI,131 PSAY "|"

		LI ++
		@ LI,00  PSAY "| C Custo   : " + ALLTRIM(SRA->RA_CC) + " - " + ALLTRIM(DescCc(SRA->RA_CC,SRA->RA_FILIAL)) //"| C Custo   : "
		@ LI,60  PSAY "DPTO.: " + IIF(!Empty(SRA->RA_DEPTO),ALLTRIM(SRA->RA_DEPTO) + " - " + ALLTRIM(fDesc('SQB',SRA->RA_DEPTO,'QB_DESCRIC')),UPPER("DPTO.: ")) 	//"DPTO.: "
		@ LI,131 PSAY "|"

		LI ++
		ORDEMZ ++
		@ LI,00  PSAY "| Matricula : " + SRA->RA_MAT		//"| Matricula : "
		@ LI,30  PSAY "Nome  : " + If( !Empty(SRA->RA_NOMECMP),SRA->RA_NOMECMP,SRA->RA_NOME ) + "  " + "Ordem : " + StrZero(ORDEMZ,4)	//"Nome  : "  ### "Ordem : "
		@ LI,131 PSAY "|"

		LI ++
		@ LI,00  PSAY "| Funcao    : "+cCodFunc+" - "+cDescFunc											//"| Funcao    : "
		cCargo := fGetCargo(SRA->RA_MAT)
		cDescCar := Substr(fDesc("SQ3",cCargo,"SQ3->Q3_DESCSUM"),1,10)
		@ LI,60  PSAY "Cargo:" + " " + IIF(!Empty(cCargo),ALLTRIM(cCargo) + " - " + ALLTRIM( cDescCar ),UPPER("Cargo:"))  //"Cargo:"
		@ LI,131 PSAY "|"

		LI ++
		@ LI,00 PSAY "|"+REPLICATE("-",130)+"|"

		LI ++
		@ LI,000 PSAY "| P R O V E N T O S "		//"| P R O V E N T O S "
		@ LI,044 PSAY "  D E S C O N T O S"		//"  D E S C O N T O S"
		@ LI,088 PSAY "  B A S E S"		//"  B A S E S"
		@ LI,131 PSAY "|"

		LI ++
		@ LI,00 PSAY "|"+REPLICATE("-",130)+"|"
		LI++

	RestArea( aArea )
Return Nil

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o	 ³fDescBco	³ Autor ³ Ze Maria			    ³ Data ³ 23.02.95 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Retorna a Descricao de Banco ou de Agˆncia 				  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ Generico 												  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß/*/
Static Function fDescBco(cCodigo, cFil, nBytes, lNomeAg)
	Local cAlias := ALIAS()
	
	Default lNomeAg := .F.
	Default nBytes := 40
	nBytes := Min(nBytes, 40)
	
	dbSelectArea("SA6" )
	
	If (cFil != Nil .AND. cFilial == Space(FWGETTAMFILIAL)) .OR. cFil == Nil.OR. (cFil != Nil .AND. Len(Alltrim(cFilial)) < FWGETTAMFILIAL)
		cFil := cFilial
	EndIf
	
	If dbSeek(cFil + cCodigo)
		If lNomeAg
			cRet := Left(A6_NOMEAGE + Space(nBytes), nBytes)
		Else
			cRet := Left(A6_NOME + Space(nBytes), nBytes)
		EndIf
	Else
		cRet := Left("Banco Nao Cadastrado" + Space(nBytes), nBytes)//Left(STR0011 + Space(nBytes), nBytes)  //"** Nao Cadastrado **"
	EndIf
	
	dbSelectArea(cAlias )
Return cRet

********************
Static Function PerSemana() // Pesquisa datas referentes a semana.
********************
Local aAreaRCF	:= RCF->(GetArea())
Local cChaveSem	:= ""  

dbSelectArea( "RCF" )
dbSetOrder(1)

If !Empty(Semana)
	// Turno do funcionario
	cChaveSem := StrZero(Year(dDataRef),4)+StrZero(Month(dDataRef),2)+SRA->RA_TNOTRAB  
	
	If !dbSeek(xFilial("RCF") + cChaveSem + Semana, .T. )
		cChaveSem := StrZero(Year(dDataRef),4)+StrZero(Month(dDataRef),2)+"@@@"
		If !dbSeek(xFilial("RCF") + cChaveSem + Semana  )
			HELP( " ",1,"GPCALEND",  )	// "Nao existe calendario cadastrado para a competencia,  Turno ou semana."
			Return(NIL)
		Endif
	Endif
	cSem_De  := DtoC(RCF->RCF_DTINI,'DDMMYY')
	cSem_Ate := DtoC(RCF->RCF_DTFIM,'DDMMYY')
EndIf

RestArea(aAreaRCF)

Return Nil

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³fSomaPdRec³ Autor ³ R.H. - Mauro          ³ Data ³ 24.09.95 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Somar as Verbas no Array                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ fSomaPdRec(Tipo,Verba,Horas,Valor)                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function fSomaPdRec(cTipo,cPd,nHoras,nValor)

Local Desc_paga

Static lAglutPd // Sera utilizada em todas as chamadas da funcao fSomaPdRec()

If lAglutPd == Nil
	 lAglutPd := ( GetMv("MV_AGLUTPD",,"1") == "1" ) // 1-Aglutina verbas   2-Nao Aglutina
EndIf

Desc_paga := DescPd(cPd,Sra->Ra_Filial)  // mostra como pagto

If cTipo # 'B'
	//--Array para Recibo Pre-Impresso
	nPos := Ascan(aLanca,{ |X| X[2] = cPd })
	If nPos == 0 .Or. !lAglutPd
		Aadd(aLanca,{cTipo,cPd,Desc_Paga,nHoras,nValor})
	Else
		aLanca[nPos,4] += nHoras
		aLanca[nPos,5] += nValor
	Endif
Endif

//--Array para o Recibo Pre-Impresso
If cTipo = 'P'
	cArray := "aProve"
Elseif cTipo = 'D'
	cArray := "aDesco"
Elseif cTipo = 'B'
	cArray := "aBases"
Endif

nPos := Ascan(&cArray,{ |X| X[1] = cPd })
If nPos == 0 .Or. !lAglutPd
	Aadd(&cArray,{cPd+" "+Desc_Paga,nHoras,nValor })
Else
	&cArray[nPos,2] += nHoras
	&cArray[nPos,3] += nValor
EndIf

Return