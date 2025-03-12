#include "Protheus.ch"


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ RGPE001  ³ Autor ³ Ariclenes M. Costa    ³ Data ³ 11/05/15 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Emissao de Recibos de Pagamento                            ³±±
±±³Sintaxe   ³ RGPER01(void)                                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³         ATUALIZACOES SOFRIDAS DESDE A CONSTRU€AO INICIAL.             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Programador ³ Data   ³ BOPS ³  Motivo da Alteracao                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

User Function RGPE001B()                                                                       
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis Locais (Basicas)                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local cString:="SRA"        // alias do arquivo principal (Base)
Local aOrd   := {"Matricula","C.Custo + Matr.","Nome","C.Custo + Nome"} 
Local cDesc1 := "Emiss„o de Recibos de Pagamento."
Local cDesc2 := "Ser  impresso de acordo com os parametros solicitados pelo"
Local cDesc3 := "usuario."

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis Locais (Programa)                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local nExtra,cIndCond,cIndRc
Local Baseaux := "S", cDemit := "N"
Public _oPrint

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define o numero da linha de impressão como 0                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//SetPrc(0,0)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis Private(Basicas)                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Private aReturn  := {"Zebrado", 1,"Administracao", 2, 2, 1, "",1 }	//"Zebrado"###"Administra‡„o"
Private nomeprog := "RGPE001A"
Private aLinha   := { },nLastKey := 2
Private cPerg    := "RGPE001A"
Private cSem_De  := "  /  /    "
Private cSem_Ate := "  /  /    "
Private nAteLim , nBaseFgts , nFgts , nBaseIr , nBaseIrFe
Private cCompac , cNormal
Private aDriver

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis Private(Programa)                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Private aFunc := {}
Private aProve := {}
Private aDesco := {}
Private aBases := {}
Private aInfo  := {}
Private aCodFol:= {}
Private li     := _PROW()
Private Titulo := "EMISSAO DE RECIBOS DE PAGAMENTOS"
Private nTamanho	:= "M"
Private limite		:= 132

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Envia controle para a funcao SETPRINT                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
fValidSX1()
Pergunte("RGPE001d",.T.)

wnrel:="RGPER01"            //Nome Default do relatorio em Disco

wnrel:=SetPrint(cString,wnrel   ,cPerg,Titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,   ,nTamanho )
// el:=SetPrint(cString,NomeProg,""  ,@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define a Ordem do Relatorio                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nOrdem :=  aReturn[8]

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Carregando variaveis mv_par?? para Variaveis do Sistema.     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dDataRef   := mv_par01
nTipRel    := 1
Esc        := mv_par02
cFilDe     := mv_par03	//Filial De
cFilAte    := mv_par04	//Filial Ate
cCcDe      := mv_par05			//Centro de Custo De
cCcAte     := mv_par06				//Centro de Custo Ate
cMatDe     := mv_par07				//Matricula Des
cMatAte    := mv_par08			//Matricula Ate
cNomDe     := mv_par09				//Nome De
cNomAte    := mv_par10				//Nome Ate
Mensag11   := substr(mv_par11,1,1)										 	//Mensagem 1
Mensag12   := substr(mv_par11,2,1)										 	//Mensagem 1
Mensag21   := substr(mv_par12,1,1)											//Mensagem 2
Mensag22   := substr(mv_par12,2,1)										 	//Mensagem 1
Mensag31   := substr(mv_par13,1,1)											//Mensagem 3
Mensag32   := substr(mv_par13,2,1)										 	//Mensagem 1
Mensag4   := mv_par14											//Mensagem 3
Mensag5   := mv_par15											//Mensagem 3

cSituacao  := mv_par16	//Situacoes a Imprimir
cCategoria := mv_par17	//Categorias a Imprimir
cBaseAux   := If(mv_par18 == 1,"S","N")							//Imprimir Bases

If aReturn[5] == 1 .and. nTipRel == 1
	li	:=  0
EndIf


cMesAnoRef := StrZero(Month(dDataRef),2) + StrZero(Year(dDataRef),4)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Inicializa Impressao                                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If !fInicia(cString,nTipRel)
	Return
Endif


//MsgRun("Gerando relatório, aguarde...", "", {|| CursorWait(), R030IMPL(@lEnd,wnRel,cString,cMesAnoRef), CursorArrow()})

RptStatus({|lEnd| R030ImpL(@lEnd,wnRel,cString,cMesAnoRef)},Titulo)  // Chamada do Relatorio

Return(  NIL )

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ R030IMP  ³ Autor ³ Ariclenes M. Co³         Data ³ 11/05/15 ³±±
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
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function R030ImpL(lEnd,WnRel,cString,cMesAnoRef)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis Locais (Basicas)                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local lIgual                 //Vari vel de retorno na compara‡ao do SRC
Local cArqNew                //Vari vel de retorno caso SRC # SX3
Local aOrdBag     := {}
Local cMesArqRef  := If(Esc == 4,"13"+Right(cMesAnoRef,4),cMesAnoRef)
Local cArqMov     := ""
Local aCodBenef   := {}
Local cNroHoras   := &("{ || If(SRC->RC_QTDSEM > 0, SRC->RC_QTDSEM, SRC->RC_HORAS) }")
Local nHoras      := 0
Local nMes, nAno
Public cCodFunc	  := ""		//-- codigo da Funcao do funcionario
Public cDescFunc  := ""		//-- Descricao da Funcao do Funcionario
Public _n         := 1

Private cAliasMov := ""
Private cDtPago
Private cPict1	:=	"@E 999,999,999.99"
Private cPict2 := 	"@E 99,999,999.99"
Private cPict3 :=	"@E 999,999.99"
If MsDecimais(1) == 0
	cPict1	:=	"@E 99,999,999,999"
	cPict2 	:=	"@E 9,999,999,999"
	cPict3 	:=	"@E 99,999,999"
Endif

If Esc == 4
	cMesArqRef := "13" + Right(cMesAnoRef,4)
Else
	cMesArqRef := cMesAnoRef
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//| Verifica se existe o arquivo de fechamento do mes informado  |
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If !OpenSrc( cMesArqRef, @cAliasMov, @aOrdBag, @cArqMov, @dDataRef , NIL  )
	Return(  NIL  )
Endif


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Selecionando a Ordem de impressao escolhida no parametro.    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea( "SRA")
If nOrdem == 1      // RA_FILIAL+RA_MAT
	dbSetOrder(1)
ElseIf nOrdem == 2  // RA_FILIAL+RA_CC+RA_MAT
	dbSetOrder(2)
ElseIf nOrdem == 3  // RA_FILIAL+RA_NOME+RA_MAT
	dbSetOrder(3)
ElseIf nOrdem == 4  // RA_FILIAL+RA_CC + RA_NOME
	dbSetOrder(8)
Endif

dbGoTop()


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Selecionando o Primeiro Registro e montando Filtro.          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If nOrdem == 1
	cInicio := "SRA->RA_FILIAL + SRA->RA_MAT"
	dbSeek(cFilDe + cMatDe,.T.)
	cFim    := cFilAte + cMatAte
ElseIf nOrdem == 2
	dbSeek(cFilDe + cCcDe + cMatDe,.T.)
	cInicio  := "SRA->RA_FILIAL + SRA->RA_CC + SRA->RA_MAT"
	cFim     := cFilAte + cCcAte + cMatAte
ElseIf nOrdem == 3
	dbSeek(cFilDe + cNomDe + cMatDe,.T.)
	cInicio := "SRA->RA_FILIAL + SRA->RA_NOME + SRA->RA_MAT"
	cFim    := cFilAte + cNomAte + cMatAte
ElseIf nOrdem == 4
	dbSeek(cFilDe + cCcDe + cNomDe,.T.)
	cInicio  := "SRA->RA_FILIAL + SRA->RA_CC + SRA->RA_NOME"
	cFim     := cFilAte + cCcAte + cNomAte
Endif

dbSelectArea("SRA")
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Carrega Regua Processamento                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
SetRegua(RecCount())	// Total de elementos da regua

aFunc  :={}         // Zera Lancamentos
aProve :={}         // Zera Lancamentos
aDesco :={}         // Zera Lancamentos
aBases :={}         // Zera Lancamentos
aImpos :={}         // Zera Lancamentos
DESC_MSG:={}
FLAG:= CHAVE := 0

Desc_Fil   := Desc_End := DESC_CC:= DESC_FUNC:= ""
DESC_MSG1  := DESC_MSG2:= DESC_MSG3:= Space(01)
DESC_MSG4  := DESC_MSG5:= Space(62)
cFilialAnt := "  "
Vez        := 0
OrdemZ     := 0

While SRA->( !Eof() .And. &cInicio <= cFim )
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Movimenta Regua Processamento                                ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	IncRegua()  // Anda a regua
	
	If lEnd
		@Prow()+1,0 PSAY cCancel
		Exit
	Endif
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Consiste Parametrizacao do Intervalo de Impressao            ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If 	(SRA->RA_NOME < cNomDe)    .Or. (SRA->Ra_NOME > cNomAte)    .Or. ;
		(SRA->RA_MAT < cMatDe)     .Or. (SRA->Ra_MAT > cMatAte)     .Or. ;
		(SRA->RA_CC < cCcDe)       .Or. (SRA->Ra_CC > cCcAte)
		SRA->(dbSkip(1))
		Loop
	EndIf
	
	nAteLim := nBaseFgts := nFgts := nBaseIr := nBaseIrFe := 0.00
	
	Ordem_rel := 1     // Ordem dos Recibos
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica Data Demissao         ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cSitFunc := SRA->RA_SITFOLH
	dDtPesqAf:= CTOD("01/" + Left(cMesAnoRef,2) + "/" + Right(cMesAnoRef,4))
	If cSitFunc == "D" .And. (!Empty(SRA->RA_DEMISSA) .And. MesAno(SRA->RA_DEMISSA) > MesAno(dDtPesqAf))
		cSitFunc := " "
	Endif
	
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Consiste situacao e categoria dos funcionarios			     |
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If !( cSitFunc $ cSituacao ) .OR.  ! ( SRA->RA_CATFUNC $ cCategoria )
		dbSkip()
		Loop
	Endif
	If cSitFunc $ "D" .And. Mesano(SRA->RA_DEMISSA) # Mesano(dDataRef)
		dbSkip()
		Loop
	Endif
	
	fBuscaFunc(dDataRef, @cCodFunc, @cDescFunc   )
	
	aAdd(aFunc,{SRA->RA_MAT,;
	Left(SRA->RA_NOME,28),;
	fCodCBO(SRA->RA_FILIAL,cCodFunc ,dDataRef),;
	SRA->RA_CC,;
	Posicione("CTT",1,SRA->RA_FILIAL+SRA->RA_CC,"CTT_DESC01"),;
	SRA->RA_Filial ,;
	TRANSFORM(strzero(ORDEM_REL,3),"9999"),;
	cCodFunc,;
	cDescFunc,;
	SRA->RA_SALARIO,;
	MONTH(SRA->RA_NASC),;
	Substr(Sra->Ra_BcDepSal,1,3),;
	SRA->RA_BCDEPSAL,;
	SRA->RA_CTDEPSAL,;
	})
	
	If SRA->RA_Filial # cFilialAnt
		If ! Fp_CodFol(@aCodFol,Sra->Ra_Filial) .Or. ! fInfo(@aInfo,Sra->Ra_Filial)
			Exit
		Endif
		Desc_Fil := aInfo[3]
		Desc_End := aInfo[4]                // Dados da Filial
		Desc_CGC := aInfo[8]
		DESC_MSG1:= DESC_MSG2:= DESC_MSG3:= Space(01)
		DESC_MSG4:=DESC_MSG5:=Space(62)
		
		// MENSAGENS
		
		dbSelectArea("SRA")
		cFilialAnt := SRA->RA_FILIAL
	Endif
	aAdd(DESC_MSG,{DESC_MSG1,DESC_MSG2,DESC_MSG3,DESC_MSG4,DESC_MSG5})
	
	dbSelectArea("SRA")
	
	
	If nTipRel == 1
		If Vez = 0  .and. nTipRel # 3  .and. aReturn[5] # 1
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Descarrega teste de impressao                                ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			//_TOTDESC := 0
			//_TOTVENC := 0
			//If mv_par01 = 2
			//	Loop
			//Endif
		ENDIF
	Endif
	dbSelectArea("SRA")
	SRA->( dbSkip() )
	_TOTDESC := 0
	_TOTVENC := 0
	_n++
EndDo

fImpressaoL()   // Impressao do Recibo de Pagamento


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Seleciona arq. defaut do Siga caso Imp. Mov. Anteriores      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If !Empty( cAliasMov )
	fFimArqMov( cAliasMov , aOrdBag , cArqMov )
EndIf


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Termino do relatorio                                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("SRC")
dbSetOrder(1)          // Retorno a ordem 1
dbSelectArea("SRI")
dbSetOrder(1)          // Retorno a ordem 1
dbSelectArea("SRA")
SET FILTER TO
RetIndex("SRA")

If !(Type("cArqNtx") == "U")
	fErase(cArqNtx + OrdBagExt())
Endif


Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³fImpressao³ Autor ³ Ariclenes M. Costa    ³ Data ³ 11/05/15 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ IMRESSAO DO RECIBO                                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ fImpressao()                                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function fImpressaoL()

Local nConta  := nContr := nContrT:=0
Local aDriver := LEDriver()
Local _i            := 0
Local _aPos1        := {2000, 1900, 2100, 2300}
Local _aPos2        := {2270, 1900, 2340, 2300}
Local _aBmp := {}
Local _aEmp := {}
Local cLogo := "hol"+cEmpAnt+".png"
Local _oFont8   := Nil
Local _oFont10  := Nil
Local _oFont12  := Nil
Local _oFont16  := Nil
Local _oFont16n := Nil
Local _oFont24  := Nil
Local _oBrush   := Nil
Local cString   := ""
Local nCol := 0
Local _lmesmo := .F.
Local _cont:= 0
Local _pag := 0
Local i, l, j, nConta, z, y

Private TOTVENC := {}
Private TOTDESC := {}
Private aLanca  := {}
Private aImpos  := {}
Private nLinhas:=30              // Numero de Linhas do Miolo do Recibo
Private cCompac := aDriver[1]
Private cNormal := aDriver[2]
Private _tipofol :=""
Private _aBenAli	:=	{}
Private _aDesc		:=	{}
Private _nTam		:=	0
Private _alanc		:=	{}


aAdd(_aBmp, "\txt\logo" + cEmpAnt + ".bmp")	//Logo da empresa

aAdd(_aEmp, SM0->M0_NOMECOM)	//Nome da Empresa
aAdd(_aEmp, alltrim(SM0->M0_ENDCOB) + ", " +AllTrim(SM0->M0_BAIRCOB) )	//Endereço
aAdd(_aEmp, AllTrim(SM0->M0_CIDCOB) + "-" + SM0->M0_ESTCOB) //
aAdd(_aEmp, "PABX/FAX: 55 " + SUBSTR(SM0->M0_TEL,3,2)+" "+SUBSTR(SM0->M0_TEL,5,4)+" "+SUBSTR(SM0->M0_TEL,9,4)+" / 55 "+ SUBSTR(SM0->M0_FAX,3,2)+" "+SUBSTR(SM0->M0_FAX,5,4)+" "+SUBSTR(SM0->M0_FAX,9,4)) //Telefones
aAdd(_aEmp, "CNPJ : " + Transform(SM0->M0_CGC, "@R 99.999.999/9999-99")) //CGC
aAdd(_aEmp, "I.E.: " + Transform(SM0->M0_INSC, "@R 999.999.999.999")) // IE

Ordem_Rel := 1

_oPrint := TMSPrinter():New( "Recibo Laser" )
_oPrint:SetPortrait() // ou SetLandscape()

//Parâmetros de TFont.New()
//1.Nome da Fonte (Windows)
//3.Tamanho em Pixels
//5.Bold (T/F)

//_oFont8   := TFont():New("Arial", 09, 08,   ,.F.,  ,   ,  ,    , .F.)
_oFont8   := TFont():New("Courier", 09, 12,   ,.F.,  ,   ,  ,    , .F.)
_oFont8n   := TFont():New("Courier", 09, 12,.T.,.T.,  ,   ,  ,    , .F.)
_oFont10  := TFont():New("Courier", 09, 14,.T.,.F., 5,.T., 5, .T., .F.)
_oFont10n  := TFont():New("Courier", 09, 14,.T.,.T., 5,.T., 5, .T., .F.)
_oFont12  := TFont():New("Courier", 09, 16,.T.,.F., 5,.T., 5, .T., .F.)
_oFont16  := TFont():New("Courier", 09, 18,.T.,.F., 5,.T., 5, .T., .F.)
_oFont16n := TFont():New("Courier", 09, 18,.T.,.T., 5,.T., 5, .T., .F.)
_oFont24  := TFont():New("Courier", 09, 24,.T.,.T., 5,.T., 5, .T., .F.)                                       
_oFontCP  := TFont():New("Arial", 09, 09,.T.,.T., 5,.T., 5, .T., .F.)

_oBrush := TBrush():New("",4)

DEFINE PEN oPenCP WIDTH 3 COLOR CLR_GRAY

For _I := 1 TO Len(aFunc)
	
	aLanca   := {}         // Zera Lancamentos
	TOTVENC  := {}
	TOTDESC  := {}
	aImpos   := {}
	_aDesc		:=	{}
	_alanc		:=	{}
	_nTam		:=	0
	
	llanca(aFunc[_I][1],aFunc[_I][4])
	
	
	z    :=0
	_nctaz := 1
	
	_MaxLin  := 11   // QUANTIDADE MÁXIMA DE LINHAS IMPRESSAS NOS LANÇAMENTOS
	
	nDivisao   :=  (Len(aLanca) / _MaxLin)
	
	If Int(nDivisao) <> nDivisao // Calculo de numeros paginas necessarios para mostrar TODOS os lançamentos
		_pag := Int(nDivisao)+1
	Else
		_pag := nDivisao
	Endif
	
	_StopLanc := 0
	
	For y:=1 to _pag
		
		_cont:= -50
		_oPrint:StartPage()   // Inicia uma nova página
		
		//Imprime duas vezes na mesma pagina
		For z:= 1 to 2
		
			_aLanc	:=	{}
			_adesc	:=	{}
	
			/*ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			³ Carrega Funcao do Funcion. de acordo com a Dt Referencia     ³
			ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
			
			fBuscaFunc(dDataRef, @cCodFunc, @cDescFunc   )
			
			_oPrint:Box(_cont+0170,0130, _cont+0420, 2250)  // PRIMEIRO Box
			_oPrint:Say(_cont+180, 0400, _aEmp[1], _oFont10n) //nome da empresa
			_oPrint:sayBitmap(_cont+0175, 0135,cLogo, 0240, 0230) 
			
			Do Case
				Case MV_PAR02 = 1
					_tipoFol:= "Adiantamento"
				Case MV_PAR02 = 2
					_tipoFol:= "Folha"
				Case MV_PAR02 = 3
					_tipoFol:= "13 Salario Parcela 1"
				Case MV_PAR02 = 4
					_tipoFol:= "13 Salario Parcela 2"
				Case MV_PAR02 = 5
					_tipoFol:= "Valores extras"
			EndCase
			_oPrint:Say(_cont+180, 1680, "Recibo de Pagamento "/* + _tipoFol*/, _oFont10n)
			_oPrint:Say(_cont+220, 0400, alltrim(_aEmp[2])/* + "- " +alltrim(_aEmp[3])*/, _oFont8) // endereco da empresa
			_oPrint:Say(_cont+260, 0400, alltrim(_aEmp[3]), _oFont8) // Bairro e Cidade
			_oPrint:Say(_cont+220, 1800, MesExtenso(MONTH(dDataRef)) + "/"+ STR(YEAR(dDataRef),4), _oFont8) // Mes da Folha
			_oPrint:Say(_cont+300, 0400, _aEmp[5], _oFont8) // CNPJ
			_oPrint:Say(_cont+340, 0400, _aEmp[6], _oFont8) // IE
			_oPrint:Say(_cont+380, 0400, _aEmp[4], _oFont8) // TELEFONE
			//_oPrint:Say(_cont+380, 1800, "Data: " + DTOC(Date()), _oFont8n) // TELEFONE
			
			_oPrint:Box(_cont+0450, 0130, _cont+535, 2250)  // SEGUNDO Box
			
			_oPrint:Say(_cont+0440, 0145, "Código", _oFont8n)
			_oPrint:Say(_cont+0440, 0430, "Nome do Funcionário", _oFont8n)
			_oPrint:Say(_cont+0440, 1245, "CBO", _oFont8n)
			_oPrint:Say(_cont+0440, 1450, "Função", _oFont8)
			//_oPrint:Say(_cont+0440, 1500, "Seção", _oFont8n)
			//_oPrint:Say(_cont+0440, 1605, "Emp.", _oFont8n)
			//_oPrint:Say(_cont+0440, 1790, "Fl.", _oFont8n)
			
			//Bem Alimentos
		
			
			
			_oPrint:Say(_cont+0480, 0145, aFunc[_I][1], _oFont8n)//codigo
			_oPrint:Say(_cont+0480, 0430, aFunc[_I][2], _oFont8n)//nome do funcionario
			_oPrint:Say(_cont+0480, 1245, aFunc[_I][3], _oFont8n)//cbo
			_oPrint:Say(_cont+0480, 1450, aFunc[_I][9], _oFont8n)//funcao
			//_oPrint:Say(_cont+0480, 1606, alltrim(aFunc[_I][5]), _oFont8)//descricao do cto custo
			//Função que busca seção/Departamento do Funcionário
			//Validar com Denise
			//Autor: Ariclenes M. Costa 24/10/2013
			//_oPrint:Say(_cont+0480, 1500, alltrim(/*U_BuscaSec(aFunc[_I][4])*/"Definir"), _oFont8n)//Seção
			//_oPrint:Say(_cont+0480, 1605, aFunc[_I][6], _oFont8)//empresa
			//_oPrint:Say(_cont+0480, 1790, strzero(y,3) , _oFont8)//folha
			
		
			
			_oPrint:Box(_cont+560, 0130, _cont+1700, 2250)         // Box dos lançamentos
			_oPrint:Line(_cont+0450, 0130, _cont+0450, 2250)        // Horizontal do cabecalho dos lançamentos
			_oPrint:Say(_cont+0570, 0145, "Cód."            , _oFont8n)
			_oPrint:Line(_cont+0570, 0250, _cont+1100, 0250)        // Vertical 1
			_oPrint:Say(_cont+0570, 0655, "Descrição"    , _oFont8n)
			_oPrint:Line(_cont+0570, 1155, _cont+1100, 1155)        // Vertical 2
			_oPrint:Say(_cont+0570, 1162, "Ref."    , _oFont8n)
			_oPrint:Line(_cont+0570, 1315, _cont+1250, 1315)        // Vertical 3
			_oPrint:Say(_cont+0570, 1450, "Vencimentos", _oFont8n)
			_oPrint:Line(_cont+0570, 1800, _cont+1160, 1800)        // Vertical 4
			_oPrint:Say(_cont+0570, 1950, "Descontos"   , _oFont8n)
			
			_w := 1
			_ncont := 0
			If  z == 1
				If _StopLanc == 0
					_nctaz  := 1              // começa imprimindo desde o PRIMEIRO lançamento
				Else
					_nCtaz  := _StopLanc
				Endif
			Endif
			
			//Bem alimento
			//Ordena por proventos/desconto
			ASORT(aLanca, , , { | x,y | x[1]+x[2] < y[1]+y[2] } )
			//aSort(aLanca,,,{|x,y| x[1]+x[11]+StrZero(x[7],5) > y[1]+y[11]+StrZero(y[7],5)})
			//ASORT(aLanca, , , { | x,y | x[1]>y[1]} , { | x,y | x[2]>y[2]} )
			//ASORT(aLanca, , , { | x,y | x[1]>y[1]} , { | x,y | x[2]<y[2]} ) 
			_nTam := Len(aLanca)
			
						
			For i=1 To _nTam
				If aLanca[i][1] == 'D'
					AADD(_aDesc,{aLanca[i][1],aLanca[i][2],aLanca[i][3],aLanca[i][4],aLanca[i][5],aLanca[i][6],aLanca[i][7]})
				Else
					AADD(_alanc,{aLanca[i][1],aLanca[i][2],aLanca[i][3],aLanca[i][4],aLanca[i][5],aLanca[i][6],aLanca[i][7]})					
				EndIf	
			Next
			
			aLanca	:=	{}
			
			For l=1 To Len(_alanc)
				AADD(aLanca,{_alanc[l][1],_alanc[l][2],_alanc[l][3],_alanc[l][4],_alanc[l][5],_alanc[l][6],_alanc[l][7]})
			Next
			
			For j=1 To Len(_aDesc)
				AADD(aLanca,{_aDesc[j][1],_aDesc[j][2],_aDesc[j][3],_aDesc[j][4],_aDesc[j][5],_aDesc[j][6],_aDesc[j][7]})
			Next
			
		   
		
			
			For nConta := _nctaz To Len(aLanca)
			
			
				If nConta <= iif(y >= 2,(nlinhas+_nctaz),nlinhas)
					_w := _w + 40
					cString := Transform(aLanca[nConta,5],cPict2)
					nCol    := If(aLanca[nConta,1]="P",1330,If(aLanca[nConta,1]="D",1830,0255))
					_oPrint:Say(_cont+0570+_w, 0155, aLanca[nConta,2] , _oFont8)
					_oPrint:Say(_cont+0570+_w, 0255, aLanca[nConta,3] , _oFont8)
					
					If aLanca[nConta,1] # "B"        // So Imprime se nao for base
						If aLanca[nConta,4] <= 9.99
							_oPrint:Say(_cont+0570+_w, 1160, TRANSFORM(aLanca[nConta,4],"999.99"), _oFont8)
						Endif
						If aLanca[nConta,4] <= 99.99 .and. aLanca[nConta,4] > 9.99
							_oPrint:Say(_cont+0570+_w, 1160, TRANSFORM(aLanca[nConta,4],"999.99"), _oFont8)
						Endif
						If aLanca[nConta,4] <= 999.99 .and. aLanca[nConta,4] > 99.99
							_oPrint:Say(_cont+0570+_w, 1160, TRANSFORM(aLanca[nConta,4],"999.99"), _oFont8)
						Endif
					Endif
					If aLanca[nConta,5] <= 9.99
						//_oPrint:Say(_cont+0460+_w, nCol-20, cString            , _oFont8)
						_oPrint:Say(_cont+0570+_w, nCol, cString            , _oFont8)
					Endif
					If aLanca[nConta,5] <= 99.99 .and. aLanca[nConta,5] > 9.99
						//_oPrint:Say(_cont+0460+_w, nCol-30, cString            , _oFont8)
						_oPrint:Say(_cont+0570+_w, nCol, cString            , _oFont8)
					Endif
					If aLanca[nConta,5] <= 999.99 .and. aLanca[nConta,5] > 99.99
						//_oPrint:Say(_cont+0460+_w, nCol-40, cString            , _oFont8)
						_oPrint:Say(_cont+0570+_w, nCol, cString            , _oFont8)
					Endif
					If aLanca[nConta,5] <= 9999.99 .and. aLanca[nConta,5] > 999.99
						//_oPrint:Say(_cont+0460+_w, nCol-50, cString            , _oFont8)
						_oPrint:Say(_cont+0570+_w, nCol, cString            , _oFont8)
					Endif
					If aLanca[nConta,5] <= 99999.99 .and. aLanca[nConta,5] > 9999.99
						//_oPrint:Say(_cont+0460+_w, nCol-60, cString            , _oFont8)
						_oPrint:Say(_cont+0570+_w, nCol, cString            , _oFont8)
					Endif
					
					nContr ++
					nContrT ++
					
					_ncont++
					//   --------------------------------------------------------------------------------------------------
					//                                 Tratamento da QUEBRA de PÁGINA
					//   --------------------------------------------------------------------------------------------------
					If _ncont == _MaxLin
						If Len(aLanca) > _ncont
							_w := _w + 40
							_oPrint:Say(_cont+0580+_w, 0255, "CONTINUA !!!", _oFont8)   //400
							_StopLanc := nConta + 1
						endif
						exit
					Endif
					
				Endif
				
			Next nConta
			
			If !_lmesmo .or. (y >= 2 .and. _lmesmo)
				//Mensagens
				
				_oPrint:Say(_cont+1290, 0145, DESC_MSG[_I][1], _oFont8)
				_oPrint:Say(_cont+1310, 0145, DESC_MSG[_I][2], _oFont8)
				_oPrint:Say(_cont+1320, 0145, DESC_MSG[_I][3], _oFont8)
				IF MONTH(dDataRef) = aFunc[_I][11]
					_oPrint:Say(_cont+1640, 0215, "F E L I Z   A N I V E R S A R I O  ! !", _oFont12)
					_oPrint:Say(_cont+1470, 0145, DESC_MSG[_I][4], _oFont8)
					_oPrint:Say(_cont+1495, 0145, DESC_MSG[_I][5], _oFont8)
					
				ELSE
					_oPrint:Say(_cont+1470, 0145, DESC_MSG[_I][4], _oFont8)
					_oPrint:Say(_cont+1495, 0145, DESC_MSG[_I][5], _oFont8)
				ENDIF
				
				//Mensagens da conta corrente
				
				IF SRA->RA_BCDEPSAL # SPACE(8)
					If aFunc[_I][12] = "237"
						Desc_Bco := "Banco Bradesco  "
					Else
						If aFunc[_I][12] = "341"
							Desc_Bco := "Banco Itaú  "
						Endif
					Endif
					Desc_Bco := ALLTRIM(DescBco(Sra->Ra_BcDepSal,Sra->Ra_Filial))
					//_oPrint:Say(_cont+1200, 0145, "Crédito: "+aFunc[_I][13]+" Banco: "+DESC_BCO+"   Conta: " + aFunc[_I][14], _oFont8)
					
					_oPrint:Say(_cont+1110, 0145, "Desc. Banco: "+DESC_BCO+"", _oFont8)
					_oPrint:Say(_cont+1150, 0145, "Bco\Agenc: "+aFunc[_I][13], _oFont8)
					_oPrint:Say(_cont+1190, 0145, "Conta: "+aFunc[_I][14], _oFont8)
					/*
					_oPrint:Say(_cont+1340, 0145, "Função", _oFont8)
					_oPrint:Say(_cont+1340, 0265, aFunc[_I][8], _oFont8)
					_oPrint:Say(_cont+1340, 0365, "Descrição da Função", _oFont8)
					_oPrint:Say(_cont+1340, 0765, aFunc[_I][9], _oFont8)
					//dados adicionais
					_ctps:=Posicione("SRA",1,xFilial()+aFunc[_I][1],"RA_PIS")
					_cpf:=Posicione("SRA",1,xFilial()+aFunc[_I][1],"RA_CIC")
					_rg:=Posicione("SRA",1,xFilial()+aFunc[_I][1],"RA_RG")
					_dtNas:=Posicione("SRA",1,xFilial()+aFunc[_I][1],"RA_NASC")
					_oPrint:Say(_cont+1380, 0160, "CTPS: " +_ctps , _oFont8)
					_oPrint:Say(_cont+1380, 0400, "CPF: " +_cpf, _oFont8)
					//_oPrint:Say(_cont+1380, 0650, "DATA NASC." + DtoC(_dtNas), _oFont8)
					_oPrint:Say(_cont+1380, 1000, "RG." +_rg, _oFont8)
					*/
					
				ENDIF
				
				_oPrint:Line(_cont+1100, 0130, _cont+1100, 2250) // linha horizontal no final dos lançamentos
				
				//_oPrint:Say(_cont+1320, 1350, "Total de Vencimentos", _oFont8)
				//_oPrint:Say(_cont+1320, 0850, "Total de Vencimentos", _oFont8)
				//_oPrint:Say(_cont+1320, 1900, "Total de Descontos"   , _oFont8)
				//_oPrint:Say(_cont+1320, 1400, "Total de Descontos"   , _oFont8)
				_oPrint:Line(_cont+1160, 1310, _cont+1160, 2250)  // linha horizontal antes do Valor liquido
				//_oPrint:Line(_cont+1710, 1300, _cont+1710, 2250)
				//_oPrint:Say(_cont+1400, 1315, "Valor Liquido      ==>"   , _oFont10)
				_oPrint:Say(_cont+1200, 1320, "Valor Liquido: "   , _oFont8n)
				
				
				//  =================> PROVENTOS
				
				lMostraTot := .t.
				
				If y < _pag
					lMostraTot := .f.
				Endif
				
				If TOTVENC[1][2] <= 9.99 .and. lMostraTot
					_oPrint:Say(_cont+1110, 1350,TRANSFORM(TOTVENC[1][2],cPict1), _oFont8)
				Endif
				If TOTVENC[1][2] <= 99.99 .and. TOTVENC[1][2] > 9.99 .and. lMostraTot
					_oPrint:Say(_cont+1110, 1350,TRANSFORM(TOTVENC[1][2],cPict1), _oFont8)
				Endif
				If TOTVENC[1][2] <= 999.99 .and. TOTVENC[1][2] > 99.99 .and. lMostraTot
					_oPrint:Say(_cont+1110, 1350,TRANSFORM(TOTVENC[1][2],cPict1), _oFont8)
				Endif
				If TOTVENC[1][2] <= 9999.99 .and. TOTVENC[1][2] > 999.99 .and. lMostraTot
					_oPrint:Say(_cont+1110, 1350,TRANSFORM(TOTVENC[1][2],cPict1), _oFont8)
				Endif
				If TOTVENC[1][2] <= 99999.99 .and. TOTVENC[1][2] > 9999.99 .and. lMostraTot
					_oPrint:Say(_cont+1110, 1350,TRANSFORM(TOTVENC[1][2],cPict1), _oFont8)
				Endif
				
				If !lMostraTot
					_oPrint:Say(_cont+1110, 1350,"##############", _oFont8)
				Endif
				
				//  =================> DESCONTOS
				
				If TOTDESC[1][2] <= 9.99 .and. lMostraTot
					_oPrint:Say(_cont+1110, 1800,TRANSFORM(TOTDESC[1][2],cPict1), _oFont8)
				Endif
				If TOTDESC[1][2] <= 99.99 .and. TOTDESC[1][2] > 9.99 .and. lMostraTot
					_oPrint:Say(_cont+1110, 1800,TRANSFORM(TOTDESC[1][2],cPict1), _oFont8)
				Endif
				If TOTDESC[1][2] <= 999.99 .and. TOTDESC[1][2] > 99.99 .and. lMostraTot
					_oPrint:Say(_cont+1110, 1800,TRANSFORM(TOTDESC[1][2],cPict1), _oFont8)
				Endif
				If TOTDESC[1][2] <= 9999.99 .and. TOTDESC[1][2] > 999.99 .and. lMostraTot
					_oPrint:Say(_cont+1110, 1800,TRANSFORM(TOTDESC[1][2],cPict1), _oFont8)
				Endif
				If TOTDESC[1][2] <= 99999.99 .and. TOTDESC[1][2] > 9999.99 .and. lMostraTot
					_oPrint:Say(_cont+1110, 1800,TRANSFORM(TOTDESC[1][2],cPict1), _oFont8)
				Endif
				
				If !lMostraTot
					_oPrint:Say(_cont+1110, 1860,"##############", _oFont8)
				Endif
				
				//  =================> LIQUIDO
				
				If (TOTVENC[1][2]-TOTDESC[1][2]) >=0
					If (TOTVENC[1][2]-TOTDESC[1][2]) <= 9.99  .and. lMostraTot
						_oPrint:Say(_cont+1200, 1800,TRANSFORM((TOTVENC[1][2]-TOTDESC[1][2]),cPict1), _oFont8)
					Endif
					If (TOTVENC[1][2]-TOTDESC[1][2]) <= 99.99 .and. (TOTVENC[1][2]-TOTDESC[1][2]) > 9.99 .and. lMostraTot
						_oPrint:Say(_cont+1200, 1800,TRANSFORM((TOTVENC[1][2]-TOTDESC[1][2]),cPict1), _oFont8)
					Endif
					If (TOTVENC[1][2]-TOTDESC[1][2]) <= 999.99 .and. (TOTVENC[1][2]-TOTDESC[1][2]) > 99.99  .and. lMostraTot
						_oPrint:Say(_cont+1200, 1800,TRANSFORM((TOTVENC[1][2]-TOTDESC[1][2]),cPict1), _oFont8)
					Endif
					If (TOTVENC[1][2]-TOTDESC[1][2]) <= 99999.99 .and. (TOTVENC[1][2]-TOTDESC[1][2]) > 999.99 .and. lMostraTot //?BenAlimentos
						_oPrint:Say(_cont+1200, 1800,TRANSFORM((TOTVENC[1][2]-TOTDESC[1][2]),cPict1), _oFont8)
					Endif
				Else
					If (TOTVENC[1][2]-TOTDESC[1][2]) <= -9.99 .and. lMostraTot
						_oPrint:Say(_cont+1200, 1800,TRANSFORM((TOTVENC[1][2]-TOTDESC[1][2]),cPict1), _oFont8)
					Endif
					If (TOTVENC[1][2]-TOTDESC[1][2]) <= -99.99 .and. (TOTVENC[1][2]-TOTDESC[1][2]) > 9.99 .and. lMostraTot
						_oPrint:Say(_cont+1200, 1800,TRANSFORM((TOTVENC[1][2]-TOTDESC[1][2]),cPict1), _oFont8)
					Endif
					If (TOTVENC[1][2]-TOTDESC[1][2]) <= -999.99 .and. (TOTVENC[1][2]-TOTDESC[1][2]) > 99.99 .and. lMostraTot
						_oPrint:Say(_cont+1200, 1800,TRANSFORM((TOTVENC[1][2]-TOTDESC[1][2]),cPict1), _oFont8)
					Endif
					If (TOTVENC[1][2]-TOTDESC[1][2]) <= -9999.99 .and. (TOTVENC[1][2]-TOTDESC[1][2]) > 999.99 .and. lMostraTot
						_oPrint:Say(_cont+1200, 1800,TRANSFORM((TOTVENC[1][2]-TOTDESC[1][2]),cPict1), _oFont8)
					Endif
				Endif
				
				If !lMostraTot
					_oPrint:Say(_cont+1200, 1900,"##############", _oFont8)
				Endif
				
				// _oPrint:Box(_cont+1250, 0130, _cont+1400, 2250)  // Box de demonstração do  Salário Base, FGTs, etc.
				_oPrint:Box(_cont+1250, 0130, _cont+1350, 2250)  // Box de demonstração do  Salário Base, FGTs, etc.
				
				_oPrint:Say(_cont+1260, 0150, "Salário-Base"   , _oFont8n)
				_oPrint:Say(_cont+1260, 0500, "Sal.Contr.INSS"   , _oFont8n)
				_oPrint:Say(_cont+1260, 0920, "Base Cálc.FGTS"   , _oFont8n)
				_oPrint:Say(_cont+1260, 1310, "FGTS Mês"   , _oFont8n)
				_oPrint:Say(_cont+1260, 1600, "Base Cálc.IRRF"   , _oFont8n)
				//_oPrint:Say(_cont+1260, 1990, "Faixa IRRF"   , _oFont8n)  Ben Alimentos
				_oPrint:Say(_cont+1260, 1990, "IR.", _oFont8n)//Dependentes IR
				_oPrint:Say(_cont+1260, 2070, "Sal.F", _oFont8n)//Dependentes Salario Familia
				
				//Bem Alimentos
				_oPrint:Say(_cont+1300, 1990, SRA->RA_DEPIR, _oFont8n)//Dependentes IR
				_oPrint:Say(_cont+1300, 2090, SRA->RA_DEPSF, _oFont8n)//Dependentes Salario Familia
				
				If !Empty( cAliasMov )
					nValSal := 0
					nValSal := fBuscaSal(dDataRef)
					If nValSal ==0
						nValSal := aFunc[_I][10]
					EndIf
				Else
					nValSal := aFunc[_I][10]
				EndIf
				_oPrint:Say(_cont+1300, 0130, Transform(nValSal,cPict2) , _oFont8)
				
				If Esc = 1  // Bases de Adiantamento
					If cBaseAux = "S" .And. aImpos[1][1] # 0
						_oPrint:Say(_cont+1300, 1600, TRANSFORM(aImpos[1][1],cPict1) , _oFont8)
					Endif
				ElseIf Esc = 2 .Or. Esc = 4  // Bases de Folha e 13o. 2o.Parc.
					If cBaseAux = "S"
						_oPrint:Say(_cont+1300, 0480,Transform(aImpos[1][2],cPict1) , _oFont8)
						If aImpos[1][3] # 0
							_oPrint:Say(_cont+1300, 0800, TRANSFORM(aImpos[1][3],cPict1) , _oFont8)
						Endif
						If aImpos[1][4] # 0
							_oPrint:Say(_cont+1300, 1200,TRANSFORM(aImpos[1][4],cPict2) , _oFont8)
						Endif
						If aImpos[1][1] # 0
							_oPrint:Say(_cont+1300, 1600,TRANSFORM(aImpos[1][1],cPict1) , _oFont8)
						Endif
						//_oPrint:Say(_cont+1300, 1900, Transform(aImpos[1][5],cPict1) , _oFont8) Ben Alimentos
					Endif
				ElseIf Esc = 3 // Bases de FGTS e FGTS Depositado da 1¦ Parcela
					If cBaseAux = "S"
						If aImpos[1][3] # 0
							_oPrint:Say(_cont+1300, 0800,TRANSFORM(aImpos[1][3],cPict1), _oFont8)
						Endif
						If aImpos[1][4] # 0
							_oPrint:Say(_cont+1300, 1200, TRANSFORM(aImpos[1][4],cPict2) , _oFont8)
						Endif
					Endif
				Endif
				
				// _oPrint:Box(_cont+1800, 0130, _cont+1900, 2250)
				_oPrint:Say(_cont+1400, 0200, "Confirmo o demonstrativo acima e recebi o líquido mencionado "  , _oFont8)
				_oPrint:Say(_cont+1525, 1220, "_____________________________"   , _oFont10)
				_oPrint:Say(_cont+1575, 0220, "                  Data                     "  , _oFont10)
				_oPrint:Say(_cont+1525, 0320, " ________/________/________  ", _oFont10)
				_oPrint:Say(_cont+1575, 1270, aFunc[_I][2]   , _oFont10)
				
			Endif
			_lmesmo	:= .F.
			
			/*
			If z==1
			For i := 100 to 2300 step 50
			//					_oPrint:Line(1540, i, 1540, i + 30)
			Next i
			_cont  := 1590
			Endif
			nContr := 0
			*/
			_cont  := 1610
		Next   z
		
		
		_oPrint:EndPage()     // Finaliza a página
		/*
		If MV_PAR19 == 1
		_oPrint:StartPage()   // Inicia uma nova página
		
		_nctaz := 1
		
		If cEmpAnt == "36"
		for nD := 1 to 1200 step 60
		_oPrint:Say(nd+0100, 0100, Replicate("APC",36), _oFont10)
		_oPrint:Say(nd+0120, 0100, Replicate("PCA",36), _oFont10)
		_oPrint:Say(nd+0140, 0100, Replicate("CAP",36), _oFont10)
		next
		
		for nD := 1200 to 1480 step 60
		_oPrint:Say(nd+0100, 0100, Replicate("APC",6), _oFont10)
		_oPrint:Say(nd+0120, 0100, Replicate("PCA",6), _oFont10)
		_oPrint:Say(nd+0140, 0100, Replicate("CAP",6), _oFont10)
		next
		Else
		for nD := 1 to 1200 step 60
		_oPrint:Say(nd+0100, 0100, Replicate("CJCONTROLE",11), _oFont10)
		_oPrint:Say(nd+0120, 0100, Replicate("ONTROLECJC",11), _oFont10)
		_oPrint:Say(nd+0140, 0100, Replicate("ROLECJCONT",11), _oFont10)
		next
		
		for nD := 1200 to 1480 step 60
		_oPrint:Say(nd+0100, 0100, Replicate("CJCONTROLE",2), _oFont10)
		_oPrint:Say(nd+0120, 0100, Replicate("ONTROLECJC",2), _oFont10)
		_oPrint:Say(nd+0140, 0100, Replicate("ROLECJCONT",2), _oFont10)
		next
		Endif
		
		//_oPrint:Say(_cont+1350, 0615, "Empresa..............: " + _aEmp[1], _oFontCP)
		_oPrint:Say(_cont+1400, 0615, "Centro de Custo..: " + aFunc[_I][4] + "  " + aFunc[_I][5], _oFontCP)
		_oPrint:Say(_cont+1450, 0615, "Periodo...............: " + MesExtenso(MONTH(dDataRef))+"/"+STR(YEAR(dDataRef),4), _oFontCP)
		_oPrint:Say(_cont+1500, 0615, "Funcionário.........: " + aFunc[_I][1] + "  " + aFunc[_I][2], _oFontCP)
		//			_oPrint:Say(_cont+0700, 0365, "Descrição do Cto. Custo :", _oFont10)
		
		
		//_oPrint:Say(_cont+1350, 0910, _aEmp[1], _oFontCP)   // empresa
		//_oPrint:Say(_cont+1400, 0910, aFunc[_I][4], _oFontCP)//cto custo
		//_oPrint:Say(_cont+1400, 1060, aFunc[_I][5], _oFontCP)//descricao do cto custo
		//_oPrint:Say(_cont+1450, 0910,MesExtenso(MONTH(dDataRef))+"/"+STR(YEAR(dDataRef),4), _oFontCP)
		//_oPrint:Say(_cont+1500, 0910, aFunc[_I][1], _oFontCP)//codigo
		//_oPrint:Say(_cont+1500, 1060, aFunc[_I][2], _oFontCP)//nome do funcionario
		
		If cEmpAnt == "36"
		
		for nD := 1200 to 1480 step 60
		_oPrint:Say(nd+0100, 1700, Replicate("APC",10), _oFont10)
		_oPrint:Say(nd+0120, 1700, Replicate("PCA",10), _oFont10)
		_oPrint:Say(nd+0140, 1700, Replicate("CAP",10), _oFont10)
		next
		
		for nD := 1500 to 2800 step 60
		_oPrint:Say(nd+0100, 100, Replicate("APC",36), _oFont10)
		_oPrint:Say(nd+0120, 100, Replicate("PCA",36), _oFont10)
		_oPrint:Say(nd+0140, 100, Replicate("CAP",36), _oFont10)
		next
		Else
		for nD := 1200 to 1480 step 60
		_oPrint:Say(nd+0100, 1760, Replicate("CJCONTROLE",3), _oFont10)
		_oPrint:Say(nd+0120, 1760, Replicate("ONTROLECJC",3), _oFont10)
		_oPrint:Say(nd+0140, 1760, Replicate("ROLECJCONT",3), _oFont10)
		next
		
		for nD := 1500 to 2800 step 60
		_oPrint:Say(nd+0100, 0100, Replicate("CJCONTROLE",11), _oFont10)
		_oPrint:Say(nd+0120, 0100, Replicate("ONTROLECJC",11), _oFont10)
		_oPrint:Say(nd+0140, 0100, Replicate("ROLECJCONT",11), _oFont10)
		next
		
		endif
		
		_oPrint:EndPage()     // Finaliza a página
		Endif
		*/
	Next
Next
_oPrint:Preview()     // Visualiza antes de imprimir

Return Nil

Static Function llanca(_codmat,_codcc)

Local cNroHoras   := &("{ || If(SRC->RC_QTDSEM > 0, SRC->RC_QTDSEM, SRC->RC_HORAS) }")

nAteLim := nBaseFgts := nFgts := nBaseIr := nBaseIrFe := 0.00
_TOTVENC := 0
_TOTDESC := 0
Esc      := mv_par02

dbSelectArea("SRA")
DbSetOrder(1)
dbgotop()
dbSeek(xFilial("SRA")+_codmat)


If Esc == 1 .OR. Esc == 2  // adto ou folha
	dbSelectArea("SRC")
	dbSetOrder(1)
	If dbSeek(xFilial("SRA")+_codmat)
		While !Eof() .And. SRC->RC_FILIAL+SRC->RC_MAT == SRA->RA_FILIAL+SRA->RA_MAT
			If (Esc == 1) .And. (Src->Rc_Pd == aCodFol[7,1])      // Desconto de Adto
				fSomaPd("P",aCodFol[6,1],Eval(cNroHoras),SRC->RC_VALOR,SRC->RC_MAT)
				_TOTVENC+=Src->Rc_Valor
			Elseif (Esc == 1) .And. (Src->Rc_Pd == aCodFol[12,1])
				fSomaPd("D",aCodFol[9,1],Eval(cNroHoras),SRC->RC_VALOR,SRC->RC_MAT)
				_TOTDESC+=SRC->RC_VALOR
			Elseif (Esc == 1) .And. (Src->Rc_Pd == aCodFol[8,1])
				fSomaPd("P",aCodFol[8,1],Eval(cNroHoras),SRC->RC_VALOR,SRC->RC_MAT)
				_TOTVENC+=Src->Rc_Valor
			Else
				If PosSrv( Src->Rc_Pd , SRA->RA_FILIAL , "RV_TIPOCOD" ) == "1"
					If (Esc # 1) .Or. (Esc == 1 .And. SRV->RV_ADIANTA == "S")
						If cPaisLoc == "PAR" .and. Eval(cNroHoras) == 30
							LocGHabRea(Ctod("01/"+SubStr(DTOC(dDataRef),4)), Ctod(StrZero(F_ULTDIA(dDataRef),2)+"/"+Strzero(Month(dDataRef),2)+"/"+right(str(Year(dDataRef)),2)),@nHoras)
						Else
							nHoras := Eval(cNroHoras)
						Endif
						fSomaPd("P",SRC->RC_PD,nHoras,SRC->RC_VALOR,SRC->RC_MAT)
						_TOTVENC+=Src->Rc_Valor
					Endif
				Elseif SRV->RV_TIPOCOD == "2"
					If (Esc # 1) .Or. (Esc == 1 .And. SRV->RV_ADIANTA == "S")
						fSomaPd("D",SRC->RC_PD,Eval(cNroHoras),SRC->RC_VALOR,SRC->RC_MAT)
						_TOTDESC+=Src->Rc_Valor
					Endif
				Elseif SRV->RV_TIPOCOD == "3"
					If (Esc # 1) .Or. (Esc == 1 .And. SRV->RV_ADIANTA == "S")
						fSomaPd("B",SRC->RC_PD,Eval(cNroHoras),SRC->RC_VALOR,SRC->RC_MAT)
					Endif
				Endif
			Endif
			If ESC = 1
				If SRC->RC_PD == aCodFol[10,1]
					nBaseIr := SRC->RC_VALOR
				Endif
			ElseIf SRC->RC_PD == aCodFol[13,1]
				nAteLim += SRC->RC_VALOR
			Elseif SRC->RC_PD$ aCodFol[108,1]+'*'+aCodFol[17,1]
				nBaseFgts += SRC->RC_VALOR
			Elseif SRC->RC_PD$ aCodFol[109,1]+'*'+aCodFol[18,1]
				nFgts += SRC->RC_VALOR
			Elseif SRC->RC_PD == aCodFol[15,1]
				nBaseIr += SRC->RC_VALOR
			Elseif SRC->RC_PD == aCodFol[16,1]
				nBaseIrFe += SRC->RC_VALOR
			Endif
			dbSelectArea("SRC")
			dbSkip()
		Enddo
	Endif
Elseif Esc == 3
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Busca os codigos de pensao definidos no cadastro beneficiario³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	fBusCadBenef(@aCodBenef, "131",{aCodfol[172,1]})
	dbSelectArea("SRC")
	dbSetOrder(1)
	If dbSeek(xFilial("SRA")+_codmat)
		While !Eof() .And. SRA->RA_FILIAL + SRA->RA_MAT == SRC->RC_FILIAL + SRC->RC_MAT
			If SRC->RC_PD == aCodFol[22,1]
				fSomaPd("P",SRC->RC_PD,Eval(cNroHoras),SRC->RC_VALOR,SRC->RC_MAT)
				_TOTVENC+=Src->Rc_Valor
			Elseif Ascan(aCodBenef, { |x| x[1] == SRC->RC_PD }) > 0
				fSomaPd("D",SRC->RC_PD,Eval(cNroHoras),SRC->RC_VALOR,SRC->RC_MAT)
				_TOTDESC+=SRC->RC_VALOR
			Elseif SRC->RC_PD == aCodFol[108,1] .Or. SRC->RC_PD == aCodFol[109,1] .Or. SRC->RC_PD == aCodFol[173,1]
				fSomaPd("B",SRC->RC_PD,Eval(cNroHoras),SRC->RC_VALOR,SRC->RC_MAT)
			Endif
			
			If SRC->RC_PD == aCodFol[108,1]
				nBaseFgts := SRC->RC_VALOR
			Elseif SRC->RC_PD == aCodFol[109,1]
				nFgts     := SRC->RC_VALOR
			Endif
			dbSelectArea("SRC")
			dbSkip()
		Enddo
	Endif
Elseif Esc == 4
	dbSelectArea("SRI")
	dbSetOrder(2)
	If dbSeek(xFilial("SRA")+_codcc+_codmat)
		While !Eof() .And. SRA->RA_FILIAL + SRA->RA_CC + SRA->RA_MAT == SRI->RI_FILIAL + SRI->RI_CC + SRI->RI_MAT
			If PosSrv( SRI->RI_PD , SRA->RA_FILIAL , "RV_TIPOCOD" ) == "1"
				fSomaPd("P",SRI->RI_PD,SRI->RI_HORAS,SRI->RI_VALOR,SRI->RI_MAT)
				_TOTVENC = _TOTVENC + SRI->RI_VALOR
			Elseif SRV->RV_TIPOCOD == "2"
				fSomaPd("D",SRI->RI_PD,SRI->RI_HORAS,SRI->RI_VALOR,SRI->RI_MAT)
				_TOTDESC = _TOTDESC + SRI->RI_VALOR
			Elseif SRV->RV_TIPOCOD == "3"
				fSomaPd("B",SRI->RI_PD,SRI->RI_HORAS,SRI->RI_VALOR,SRI->RI_MAT)
			Endif
			
			If SRI->RI_PD == aCodFol[19,1]
				nAteLim += SRI->RI_VALOR
			Elseif SRI->RI_PD$ aCodFol[108,1]
				nBaseFgts += SRI->RI_VALOR
			Elseif SRI->RI_PD$ aCodFol[109,1]
				nFgts += SRI->RI_VALOR
			Elseif SRI->RI_PD == aCodFol[27,1]
				nBaseIr += SRI->RI_VALOR
			Endif
			dbSkip()
		Enddo
	Endif
Elseif Esc == 5
	dbSelectArea("SR1")
	dbSetOrder(1)
	If dbSeek(xFilial("SRA")+_codmat)
		While !Eof() .And. SRA->RA_FILIAL + SRA->RA_MAT ==	SR1->R1_FILIAL + SR1->R1_MAT
			If PosSrv( SR1->R1_PD , SRA->RA_FILIAL , "RV_TIPOCOD" ) == "1"
				fSomaPd("P",SR1->R1_PD,SR1->R1_HORAS,SR1->R1_VALOR,SR1->R1_MAT)
				_TOTVENC = _TOTVENC + SR1->R1_VALOR
			Elseif SRV->RV_TIPOCOD == "2"
				fSomaPd("D",SR1->R1_PD,SR1->R1_HORAS,SR1->R1_VALOR,SR1->R1_MAT)
				_TOTDESC = _TOTDESC + SR1->R1_VALOR
			Elseif SRV->RV_TIPOCOD == "3"
				fSomaPd("B",SR1->R1_PD,SR1->R1_HORAS,SR1->R1_VALOR,SR1->R1_MAT)
			Endif
			dbskip()
		Enddo
	Endif
Endif

dbSelectArea("SRA")

//If _TOTVENC = 0 .And. _TOTDESC = 0
//		dbSkip()
//		Loop
//Endif

aAdd(TOTVENC,{_n, _TOTVENC})
aAdd(TOTDESC,{_n, _TOTDESC})

aAdd(aImpos,{nBaseIr,;
nAteLim,;
nBaseFgts,;
nFgts,;
nBaseIrFe})


Return



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³fSomaPd   ³ Autor ³ R.H. -           ³ Data ³ 23.12.12 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Somar as Verbas no Array                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ fSomaPd(Tipo,Verba,Horas,Valor)                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function fSomaPd(cTipo,cPd,nHoras,nValor,cMat)

Local Desc_paga

Desc_paga := DescPd(cPd,Sra->Ra_Filial)  // mostra como pagto

If cTipo # 'B'
	//--Array para Recibo Pre-Impresso
	nPos := Ascan(aLanca,{ |X| X[2] = cPd })
	If nPos == 0
		Aadd(aLanca,{cTipo,cPd,Desc_Paga,nHoras,nValor,cMat,_n})
	Else
		aLanca[nPos,4] += nHoras
		aLanca[nPos,5] += nValor
	Endif
Endif

/*//--Array para o Recibo Pre-Impresso
If cTipo = 'P'
	cArray := "aProve"
Elseif cTipo = 'D'
	cArray := "aDesco"
Elseif cTipo = 'B'
	cArray := "aBases"
Endif

nPos := Ascan(&cArray,{ |X| X[1] = cPd })
If nPos == 0
	Aadd(&cArray,_n,{cPd+" "+Desc_Paga,nHoras,nValor })
Else
	&cArray[_n,nPos,2] += nHoras
	&cArray[_n,nPos,3] += nValor
Endif
*/
Return

*-------------------------------------------------------
Static Function Transforma(dData) //Transforma as datas no formato DD/MM/AAAA
*-------------------------------------------------------
Return(StrZero(Day(dData),2) +"/"+ StrZero(Month(dData),2) +"/"+ Right(Str(Year(dData)),4))


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³fInicia   ºAutor  ³Ariclenes M. Costa  º Data ³  11/05/15   º±±
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

aDriver := LEDriver()

If LastKey() = 27 .Or. nLastKey = 27
	Return  .F.
Endif

SetDefault(aReturn,cString)

If LastKey() = 27 .OR. nLastKey = 27
	Return .F.
Endif

Return .T.

Static Function fValidSX1()

aPergs := {}



Aadd(aPergs,{"Data de Referencia     ?", "", "","mv_ch1", "D", 8, 0, 0, "G", "naovazio","mv_par01", ""			,"", "", "","" ,"", "","","","", "", "","","", "", "","","", "", "","",""})
Aadd(aPergs,{ "Imprimir Recibos      ?", "", "","mv_ch2", "N", 1, 0, 0, "C", ""        ,"mv_par02","Adto.","","","","","Folha","","","","","1a.Parc.","","","","","2a.Parc.","","","","","Val.Extras","","","","",""})
Aadd(aPergs,{ "De Filial             ?", "", "","mv_ch3", "C", 4, 0, 0, "G", "","mv_par03", "","", "","","","", "","","","", "","","","", "","","","", "", "","","","","","XM0"})
Aadd(aPergs,{ "Ate Filial            ?", "", "","mv_ch4", "C", 4, 0, 0, "G", "","mv_par04", "","", "","","","", "","","","", "","","","", "","","","", "", "","","","","","XM0"})
Aadd(aPergs,{ "De Centro de Custo    ?", "", "","mv_ch5", "C", 9, 0, 0, "G", "","mv_par05", "","", "","","","", "","","","", "","","","", "","","","", "", "","","","","","CTT"})
Aadd(aPergs,{ "Ate Centro de Custo   ?", "", "","mv_ch6", "C", 9, 0, 0, "G", "","mv_par06", "","", "","","","", "","","","", "","","","", "","","","", "", "","","","","","CTT"})
Aadd(aPergs,{ "De Matricula          ?", "", "","mv_ch7", "C", 6, 0, 0, "G", "","mv_par07", "","", "","","","", "","","","", "","","","", "","","","", "", "","","","","","SRA"})
Aadd(aPergs,{ "Ate Matricula         ?", "", "","mv_ch8", "C", 6, 0, 0, "G", "","mv_par08", "","", "","","","", "","","","", "","","","", "","","","", "", "","","","","","SRA"})
Aadd(aPergs,{ "De Nome               ?", "", "","mv_ch9", "C", 30, 0, 0, "G", "","mv_par09", "","", "","","","", "","","","", "","","","", "","","","", "", "","",""})
Aadd(aPergs,{ "Ate Nome              ?", "", "","mv_chA", "C", 30, 0, 0, "G", "","mv_par10", "","", "","","","", "","","","", "","","","", "","","","", "", "","",""})
Aadd(aPergs,{ "Mensagem 1            ?", "", "","mv_chB", "C", 2, 0, 0, "G", ""         ,"mv_par11", "","", "","","","", "","","","", "","","","", "","","","", "", "","",""})
Aadd(aPergs,{ "Mensagem 2            ?", "", "","mv_chC", "C", 2, 0, 0, "G", ""         ,"mv_par12", "","", "","","","", "","","","", "","","","", "","","","", "", "","",""})
Aadd(aPergs,{ "Mensagem 3            ?", "", "","mv_chD", "C", 2, 0, 0, "G", ""         ,"mv_par13", "","", "","","","", "","","","", "","","","", "","","","", "", "","",""})
Aadd(aPergs,{ "Mensagem 4            ?", "", "","mv_chE", "C", 62, 0, 0, "G", ""        ,"mv_par14", "","", "","","","", "","","","", "","","","", "","","","", "", "","",""})
Aadd(aPergs,{ "Mensagem 5            ?", "", "","mv_chF", "C", 62, 0, 0, "G", ""        ,"mv_par15", "","", "","","","", "","","","", "","","","", "","","","", "", "","",""})
Aadd(aPergs,{ "Situacoes a Imp.      ?", "", "","mv_chG", "C", 5, 0, 0, "G", "fSituacao","mv_par16", "","", "","","","", "","","","", "","","","", "","","","", "", "","",""})
Aadd(aPergs,{ "Categorias a Imp.     ?", "", "","mv_chH", "C", 15, 0, 0, "G", "fCategoria","mv_par17", "","", "","","","", "","","","", "","","","", "","","","", "", "","",""})
Aadd(aPergs,{ "imprime Bases         ?", "", "","mv_chI", "C", 1, 0, 0, "C", ""         , "mv_par18", "Sim","Si","Yes","","","Nao","No","No","","","","","","","","","","","","","","","","","",""})
// Aadd(aPergs,{ "Imprime Segunda Folha ?", "", "","mv_chJ", "C", 1, 0, 0, "C", ""         , "mv_par19", "Sim","Si","Yes","","","Nao","No","No","","","","","","","","","","","","","","","","","",""})

AjustaSx1("RGPE001d",aPergs)
Return
 
//Função que busca seção/Departamento do Funcionário
//Validar com Denise
//Autor: Ariclenes M. Costa 24/10/2013
User Function 1BuscaSec(_cc)
	
	Private _cSecao := ""

	DBSelectarea("SQB")
	DbSetorder(4)
	DbSeek(xFilial("SQB")+_cc)
	
	_cSecao := SQB->QB_DESCRIC
	
Return _cSecao