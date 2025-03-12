#Include "Protheus.ch"
#Include "Folder.ch"
#Include "Colors.ch"
#Include "Font.ch"
#Include "Ctba101.ch"  
//#Include "Ctba102.ch"  
#INCLUDE "FileIO.CH"    

#DEFINE D_PRELAN	"9"

STATIC __lCusto:= .F.             
STATIC __lItem	:= .F.
STATIC __lClVL := .F.
STATIC __aMedias[99]
STATIC __aDtMedias := {}
STATIC __dData
STATIC __nValor                    
STATIC lCtbLanc
STATIC cNumManLin	
STATIC lCT101CNV	
STATIC cPictVal  
STATIC cPictVal    
STATIC nQtdEntid
Static lFWCodFil := FindFunction("FWCodFil")   
STATIC nQtdEntid
//AMARRACAO
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Program   ³CTBA101   ³ Autor ³ Pilar S. Albaladejo   ³ Data ³ 24.07.00 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Inclusao de Lancamento Contabeis - Manuais - SIGACTB       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ Ctba101(void)                                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ Nenhum                                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Generico                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpC1 = nulo                                               ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±ANALISTA          * ALTERAÇÕES                                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±Wagner Montenegro * ADICIONADO TRATAMENTO PARA ATIVIDADES COMPLEMENTARES³±±
±±       28/04/2010 * FUNÇÃO CTBValidAt("??",?)??="DB" OU "CR"            ³±±
±±                  * ?=1 P/CTBA101 OU 2 P/CTBA105                        ³±±
±±L.Trombini        * Salva a area do CTT na Funcao CONVCUSTO.            ³±±
±±       21/09/2010 *                                                     ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
user Function CTBAERC(nCallOpcx)

Local cFiltro	:= ""
Private aRotina := MenuDef()
Private cCadastro := OemToAnsi(STR0006)		// "Lan‡amentos Cont beis"
Private cLoteSub  := GetMv("MV_SUBLOTE")
Private cSubLote  := cLoteSub
Private lSubLote  := Empty(cSubLote)
Private dDataLanc
Private aCtbEntid
 /*                        
If FindFunction( "IsCtbJob" ) .And. IsCtbJob()
	DbSelectArea( "CVO" )
	CTBJobsStart()
Endif
 */
If ( !AMIIn(34) )		// Acesso somente pelo SIGACTB
	Return
EndIf

__lCusto  := CtbMovSaldo("CTT")
__lItem	  := CtbMovSaldo("CTD")
__lCLVL	  := CtbMovSaldo("CTH")

cNumManLin := CtbSoma1Li()
SetKey(VK_F12,{|a,b|AcessaPerg("CTB101",.T.)})

Pergunte("CTBAERC",.F.)

SaveInter()

dbSelectArea("CT2")
dbSetOrder(1)

If nCallOpcx <> Nil
/*	If  nCallOpcx <= Len(aRotina)
		bBlock := &( "{ |x,y,z| " + aRotina[ nCallOpcx,2 ] + "(x,y,z) }" )
		Eval( bBlock,Alias(),CT2->(Recno()),nCallOpcx)
	EndIf */
Else
	//ponto de entrada para usuario filtrar a tabela CT2 na mBrowse
   //	If ExistBlock("CTB101MB")
	   //	cFiltro := Execblock("CTB101MB",.f.,.f.)
   //	Endif

	If Empty(cFiltro)
 		mBrowse(6,1,22,75,"CT2",,,,,, CtbLegenda("CT2"))
	Else
		//mBrowse(6,1,22,75,"CT2",,,,,, CtbLegenda("CT2"),,,,,,,,cFiltro)
	EndIf
EndIf
	
dbSelectArea("CT2")
dbSetOrder(1)

SET KEY VK_F12 to

RestInter()

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Program   ³CTBA101Cal³ Autor ³ Pilar S. Albaladejo   ³ Data ³ 24.07.00 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Chama a Capa de Lote                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ Ctba101Cal(cAlias,nReg,nOpc)                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ Nenhum                                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Generico                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpC1 = Alias do arquivo                                   ³±±
±±³          ³ ExpN1 = Numero do registro                                 ³±±
±±³          ³ ExpN2 = Numero da opcao selecionada                        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
//Static Function Ctba101Cal(cAlias,nReg,nOpc) 
User Function Atuaerc(cAlias,nReg,nOpc)
Local dData                            
Local cLote
Local cDoc             
Local cMsg			:= ""
Local cSegOfi 		:= GetMv( "MV_SEGOFI" , .F. , "0" )
Local lSeqCorr		:= FindFunction("UsaSeqCor") .AND. UsaSeqCor("CT2/CTK/CT5")
Local lRet			:= .T.

Private OPCAO  //MANTER SEMPRE COMO PRIVATE POIS EH UTILIZADO NO PROC 000083 - MODULO SIGAPCO

OPCAO := nOpc

/*
ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
³Verifica se e lancamento complementar e em caso afirmativo   ³
³verifica se a operacao é valida para esse tipo de lancamento.³
³                                                             ³
³Para lancamento complementar, somente a visualizacao e       ³
³permitida.                                                   ³
ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
/*If FindFunction("CTBLCUSO") .And. CTBLCUso()
	If !(nOpc == 2 .Or. nOpc == 3)
		If Substr(CT2->CT2_ORIGEM,1,9) == "__CTBLC__"
			lRet := .F.
			cMsg := STR0074 + CRLF //"Esta operação não é permitida para lançamentos complementares."
			cMsg += STR0075 //"Se deseja realizá-la, faça-a no lançamento principal."
			MsgStop(cMsg,STR0076) //"Lançamento complementar"
		Endif
	Endif
Endif
 */
/*If lRet .And. nOpc == 5 .And. lSeqCorr .And. cSegOfi == '5'
	Help(" ",1,"CORRNOEXC")
	lRet := .F.
EndIf    */

If lRet
	lCT101CNV	:= ExistBlock( "CT101CNV" )

   /*	If cPictVal == Nil
		cPictVal  := PesqPict("CT2","CT2_VALOR")
	EndIf    */

	dbSelectArea("CTF")
	dbSetOrder(1)

	dbSelectArea("CT2")

	u_erc102Cap(cAlias,nReg,nOpc,'CTBAERC',@dData,@cLote,@cSubLote,@cDoc)

EndIf

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Program   ³CTBA101Lan³ Autor ³ Pilar S. Albaladejo   ³ Data ³ 24.07.00 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Monta Folder de Lancamento Contabil                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³Ctba101Lan(cAlias,nReg,nOpc,dData,cLote,cSubLote,cDoc,	  ³±±
±±³			 ³	CTF_LOCK,cPadrao,cLinha,oLinha,oInf,nTotInf)			  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ Nenhum                                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ SIGACTB                                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpC1 = Alias do arquivo                                   ³±±
±±³          ³ ExpN1 = Numero do Registro                                 ³±±
±±³          ³ ExpN2 = Numero da Opcao                                    ³±±
±±³          ³ ExpD1 = Data                                               ³±±
±±³          ³ ExpC2 = Numero do Lote                                     ³±±
±±³          ³ ExpC3 = Numero do Sub-Lote                                 ³±±
±±³          ³ ExpC4 = Numero do Documento                                ³±±
±±³          ³ ExpN3 = Semaforo para proximo documento                    ³±±
±±³          ³ ExpC5 = Codigo do Lancamento Padrao                        ³±±
±±³          ³ ExpC6 = Numero da Linha                                    ³±±
±±³          ³ ExpO1 = Objeto Num. da Linha                               ³±±
±±³          ³ ExpO2 = Objeto Valor Informado                             ³±±
±±³          ³ ExpN4 = Valor informado                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function Ctba101Lan(cAlias,nReg,nOpc,dData,cLote,cSubLote,cDoc,CTF_LOCK,cPadrao,;
					cLinha,oLinha,oInf,nTotInf,cCodSeq,cHistLote)	

Local nNovasEntid	:= GetNovasEnt()
Local aTitles  		:= {}
Local aTipos		:= {}
Local aTabela[10+nNovasEntid][5]
Local aOutros		:= {}
Local aColsAnt		:= {}
Local aFormat 		:= {}
Local cTexto		:= ""
Local cTipoCTB		:= CriaVar("CT2_DC")
Local cDebito		:= CriaVar("CT2_DEBITO")
Local cCredit		:= CriaVar("CT2_CREDIT")
Local cCustoDeb		:= CriaVar("CT2_CCD")
Local cCustoCrd		:= CriaVar("CT2_CCC")
Local cItemDeb		:= CriaVar("CT2_ITEMD")
Local cItemCrd		:= CriaVar("CT2_ITEMC")
Local cCLVLDeb		:= CriaVar("CT2_CLVLDB")
Local cCLVLCrd		:= CriaVar("CT2_CLVLCR")
Local cMoeda		:= CriaVar("CT2_MOEDLC")
Local cHistPad		:= CriaVar("CT2_HP")
Local cHistPadAnt	:= CriaVar("CT2_HP")
Local cVarq
Local cTpSald		:= CriaVar("CT2_TPSALD")
Local cSeqLan		:= CriaVar("CT2_SEQLAN")
Local cFrase		:= ""
Local cSayCusto		:= CtbSayApro("CTT")
Local cSayItem		:= CtbSayApro("CTD")
Local cSayClVL		:= CtbSayApro("CTH")
Local cDescDeb
Local cDescCrd
Local cDescCCC
Local cDescCCD                              
Local cDescItC
Local cDescItD
Local cDescCvD
Local cDescCvC
Local cDebitoAnt	:= CriaVar("CT2_DEBITO")
Local cCreditoAnt 	:= CriaVar("CT2_CREDIT")
Local cCustoDAnt	:= CriaVar("CT2_CCD")
Local cCustoCAnt	:= CriaVar("CT2_CCC")
Local cItemDAnt 	:= CriaVar("CT2_ITEMD")
Local cItemCAnt		:= CriaVar("CT2_ITEMC")
Local cCLVLDAnt		:= CriaVar("CT2_CLVLDB")
Local cCLVLCAnt		:= CriaVar("CT2_CLVLCR")
Local cTipoAnt		:= CriaVar("CT2_DC")
Local cTpSaldAnt	:= CriaVar("CT2_TPSALD")
Local cMoedaAnt 	:= CriaVar("CT2_MOEDLC")
Local cAliasAnt		:= ""
Local cLoteAnt		:= CriaVar("CT2_LOTE")
Local cDocAnt		:= CriaVar("CT2_DOC")
Local cSubLoteAnt	:= CriaVar("CT2_SBLOTE")
Local cTipoHist 	:= 'C'  
Local cEmpOri		:= cEmpAnt
Local cFilOri		:= cFilAnt
Local cDCD			:= CriaVar("CT2_DCD")
Local cDCC			:= CriaVar("CT2_DCC")
Local cDCDAnt		:= CriaVar("CT2_DCD")
Local cDCCAnt		:= CriaVar("CT2_DCC")
Local nRegCT2M01	:= 0

Local dDataAnt		:= CriaVar("CT2_DATA")

Local lDigita		:= Iif(nOpc==3 .Or. nOpc==4 .Or. nOpc == 6,.T.,.F.)
Local lHist		:= .F.

Local nOpca			:= 999
Local nValorCTB		:= CriaVar("CT2_VALOR")
Local nValorAnt 	:= 0
Local nOutros		:= 0
Local nCont
Local nVarLinM		:= 0

Local oDlg
Local oCombo
Local oDescDeb
Local oDescCrd
Local oDescItd
Local oDescItc
Local oDescCCD
Local oDescCCC
Local oDescCVD
Local oDescCVC
Local oMemo1
Local oMemo2
Local oGet
Local oTabela
Local oEnchoice
Local oTpSald  
Local oDCD
Local oDCC
Local	lContinua := .T.
Local oDoc
Local oLote, oSubLote 

//Variavel lFirst criada para verificar se eh a primeira vez que esta incluindo o 
//lancam. contabil. Se for a primeira vez (.T.),ira trazer 001 na linha. Se nao for 
//a primeira vez e for para repetir o lancamento anterior, ira atualizar a linha 
//e ira deixar a variavel cTipoHist em branco. 
Local lFirst 	:= .T. 
Local lFirstLin	:= .T.
Local nGravados	:= 0  
Local lSeqCorr  := .F.
Local cSeqCorr  := ""
Local lAtuCorr	:= .T.
Local aOutrEntid, nEntid, cAuxEnt, aDemaisEnt
Local nX
Local aNovasEnt	:= GetAEntidades()
Local cCpoDB
Local cCpoCR

Default cHistLote	:= ""
If nQtdEntid == NIL
	nQtdEntid := If(FindFunction("CtbQtdEntd"),CtbQtdEntd(),4) //sao 4 entidades padroes -> conta /centro custo /item contabil/ classe de valor
EndIf   

If aCtbEntid == NIL
	aCtbEntid := Array(2,nQtdEntid)  //posicao 1=debito  2=credito
EndIf 
//DEBITO
aCtbEntid[1,1] := {|| cDebito 	}
aCtbEntid[1,2] := {|| cCustoDeb	}
aCtbEntid[1,3] := {|| cItemDeb 	}
aCtbEntid[1,4] := {|| cCLVLDeb 	}
//CREDITO
aCtbEntid[2,1] := {|| cCredit 	}
aCtbEntid[2,2] := {|| cCustoCrd	}
aCtbEntid[2,3] := {|| cItemCrd 	}
aCtbEntid[2,4] := {|| cCLVLCrd 	}

For nX := 5 TO nQtdEntid
	If INCLUI
		&("M->CT2_EC"+StrZero(nX,2)+"DB") := CriaVar("CT2_EC"+StrZero(nX,2)+"DB")
		&("M->CT2_EC"+StrZero(nX,2)+"CR") := CriaVar("CT2_EC"+StrZero(nX,2)+"CR")
	Else
		&("M->CT2_EC"+StrZero(nX,2)+"DB") := &("CT2->CT2_EC"+StrZero(nX,2)+"DB")
		&("M->CT2_EC"+StrZero(nX,2)+"CR") := &("CT2->CT2_EC"+StrZero(nX,2)+"CR")
	EndIf
	aCtbEntid[1, nX] := MontaBlock("{|| M->CT2_EC"+StrZero(nX,2)+"DB } ")  //debito
	aCtbEntid[2, nX] := MontaBlock("{|| M->CT2_EC"+StrZero(nX,2)+"CR } ")  //credito
Next 

// Nao pode prosseguir no lançamento se não existem moedas cadastradas.
If __nQuantas == 0
	Help(" ",1,"NOMOEDCTO")
	Return
EndIf	

Private aCols		:= {}
Private aAlter		:= {}
Private aHeader	:= {}
Private aSvAtela 	:= {}
Private aSvAGets 	:= {}
Private aTela		:= {}
Private aGets 		:= {}
Private lNEntBloq	:= .F.

//****************************
// Controle do Correlativo   *
//****************************
lSeqCorr  := ( FindFunction( "UsaSeqCor" ) .And. UsaSeqCor() )

/*If lSeqCorr
	cSeqCorr := space(TamSx3("CT2_NODIA")[1])
EndIf */


If SuperGetMV('MV_CTBDEST', .F., '2') == '2'
	lDigita		:= Iif(nOpc==3 .Or. nOpc==4 .Or. nOpc == 7,.T.,.F.)
Else
	//lDigita		:= Iif(nOpc==3 .Or. nOpc==4 .Or. nOpc == 6 .Or. nOpc == 7,.T.,.F.)
End

__dData				:= dData
dDataLanc			:= dData

aTitles := {OemToAnsi(STR0014),OemToAnsi(STR0015),;
			OemToAnsi(STR0038),OemToAnsi(STR0016)}		// "Lan‡amento" / "Conversoes" / "Outras Informações" / "Saldos" 
// Retorna conteudo do tipo de lancamento (Combo Box)     
aTipos := CTBCBOX("CT2_DC","456")

cPictVal := Iif( cPictVal == NIL, PesqPict("CT2","CT2_VALOR"), cPictVal )            

M->CT2_MCONVER	:= CriaVar("CT2_CONVER")

// Cria e Carrega array de conversoes
CriaConv(,nOpc)

While nOpca <> 0
	lAtuCorr := .F.
	IF lSeqCorr .AND. Empty(cSeqCorr)
		IF (nOpc == 3 .Or. nOpc == 7) .AND. Val(cLinha) < 2  // a partir da segunda linha do lanc., o correlativo eh o mesmo
			cSeqCorr := CTBSqCor( CTBSubToPad(cSubLote), cCodSeq, dData  )
			lAtuCorr := .T.
		ElseIF nOpc <> 3 
			cSeqCorr := CT2->CT2_SEGOFI
			lAtuCorr := .F.
		EndIf	
	EndIf

	If nOpc == 3				// Inclusao
		If mv_par01 == 2		// Nao repete dados
			CarregaCt2(	nOpc,@cTexto,@cTipoCTB,@cDebito,@cCredit,@cCustoDeb,;
						@cCustoCrd,@cItemDeb,@cItemCrd,@cCLVLDeb,@cCLVLCrd,;
						@cMoeda,@cHistPad,@nValorCTB,@dData,@cLote,@cSubLote,;
						@cDoc,@cLinha, @cTpSald,aTipos,,@aTabela,oTabela,;
						@cSeqLan, @cDescDeb,@cDescCrd,@oLinha,cSayCusto,cSayItem,;
						cSayCLVL, @cDescCCC,@cDescCCd,@cDescItc,@cDescItd,;
						@cDescCvd,@cDescCvc,@cEmpOri,@cFilOri,@cDCD,@cDCC,, @aNovasEnt )
			aColsAnt 	:= aClone(aCols)						
		Else
			cDebitoAnt	:= cDebito
			cCreditoAnt := cCredit
			cCustoDAnt	:= cCustoDeb
			cCustoCAnt	:= cCustoCrd
			cItemDAnt	:= cItemDeb
			cItemCAnt	:= cItemCrd
			cCLVLDAnt	:= cCLVLDeb
			cCLVLCAnt	:= cCLVLCrd
			cTipoAnt	:= cTipoCTB
			nValorAnt	:= nValorCTB
			cTpSaldAnt	:= cTpSald
			cMoedaAnt 	:= cMoeda
			aColsAnt 	:= aClone(aCols)
			dDataAnt	:= dData
			cLoteAnt	:= cLote
			cDocAnt		:= cDoc
			cSubLoteAnt	:= cSubLote
			__nValor	:= 0.00                                            
			cDCDAnt		:= cDCD
			cDCCAnt		:= cDCC
		EndIf

		cAliasAnt := Alias()

		dbSelectArea("CT2")
		dbSetOrder(1)
		dbSeek(xFilial()+DTOS(dData)+cLote+cSubLote+cDoc+'ZZZ', .T.)

		If 	CT2->CT2_FILIAL == xFilial("CT2") .And. CT2->CT2_DATA == dData .And. ;
			CT2->CT2_LOTE == cLote .And. CT2->CT2_SBLOTE == cSubLote .And.;
			CT2->CT2_DOC == cDoc .And. CT2->CT2_LINHA = 'ZZZ'
			Help(" ", 1, "CTBJADOC")
			Exit
		Else
			dbSkip(-1)
			If	CT2->CT2_FILIAL == xFilial("CT2") .And. CT2->CT2_DATA == dData .And. ;
				CT2->CT2_LOTE == cLote .And. CT2->CT2_SBLOTE == cSubLote .And.;
				CT2->CT2_DOC == cDoc
				cLinha	:= Soma1(CT2->CT2_LINHA)

				// Altero para ordem 10 e procuro por SeqLan pois a ultima linha nao eh necessariamente
				// a ultima sequencia de lancamento
				dbSelectArea("CT2")
				dbSetOrder(10)
				dbSeek(xFilial()+DTOS(dData)+cLote+cSubLote+cDoc+'ZZZ', .T.)
				dbSkip(-1)
				cSeqLan	:= Soma1(CT2->CT2_SEQLAN)
				cSeqCorr := CT2->CT2_SEGOFI
				dbSetOrder(1)
			Else      
				cSeqLan	:= Soma1(cSeqLan)
				If !lFirst 
					cLinha	:= Soma1(cLinha)
					cTipoHist := ""
				Else
					lFirst := .F. 
				Endif
			Endif
		Endif

		Ct102GrCTF(dData,cLote,cSubLote,cDoc,@CTF_LOCK)
		Ctb101Doc(dData,cLote,cSubLote,@cDoc,,CTF_LOCK,nOpc)

		dbSelectArea(cAliasAnt)
	Else
		If nOpc == 4 .Or. nOpc == 5
			If !SoftLock("CT2")
				lContinua := .F.
			EndIf
		EndIf

		CarregaCt2(	nOpc,@cTexto,@cTipoCTB,@cDebito,@cCredit,@cCustoDeb,;
					@cCustoCrd,@cItemDeb,@cItemCrd,@cCLVLDeb,@cCLVLCrd,;
					@cMoeda,@cHistPad,@nValorCTB,@dData,@cLote,@cSubLote,;
					@cDoc,@cLinha,@cTpSald,aTipos,,@aTabela,oTabela,;
					@cSeqLan, @cDescDeb,@cDescCrd,@oLinha,cSayCusto,cSayItem,;
					cSayCLVL, @cDescCCC,@cDescCCd,@cDescItc,@cDescItd,@cDescCvd,;
					@cDescCvc, @cEmpOri, @cFilOri, @cDCD, @cDCC, @nRegCT2M01, @aNovasEnt )  
					
		If nOpc == 7
           //nao deve inicializar as variaveis ant para validacao simular uma inclusao
		ElseIf nOpc != 6					
			cDebitoAnt	:= cDebito
			cCreditoAnt := cCredit
			cCustoDAnt	:= cCustoDeb
			cCustoCAnt	:= cCustoCrd
			cItemDAnt	:= cItemDeb
			cItemCAnt	:= cItemCrd
			cCLVLDAnt	:= cCLVLDeb
			cCLVLCAnt	:= cCLVLCrd
			cTipoAnt	:= cTipoCTB
			nValorAnt	:= nValorCTB
			cTpSaldAnt	:= cTpSald
			cMoedaAnt 	:= cMoeda 
			dDataAnt	:= dData
			cLoteAnt	:= cLote
			cDocAnt		:= cDoc
			cSubLoteAnt	:= cSubLote                              
			cDCDAnt		:= cDCD
			cDCCAnt		:= cDCC			
		Else
			// No caso do estorno -> Carregar dados gravados no CT2, para comparacao
		  /*	// com valores anteriores
			cDebitoAnt	:= CT2->CT2_DEBITO
			cCreditoAnt := CT2->CT2_CREDIT
			cCustoDAnt	:= CT2->CT2_CCD
			cCustoCAnt	:= CT2->CT2_CCC
			cItemDAnt	:= CT2->CT2_ITEMD
			cItemCAnt	:= CT2->CT2_ITEMC
			cCLVLDAnt	:= CT2->CT2_CLVLDB
			cCLVLCAnt	:= CT2->CT2_CLVLCR
			cTipoAnt	:= CT2->CT2_DC
			nValorAnt	:= CT2->CT2_VALOR
			cTpSaldAnt	:= CT2->CT2_TPSALD
			cMoedaAnt 	:= CT2->CT2_MOEDLC
			dDataAnt	:= CT2->CT2_DATA
			cLoteAnt	:= CT2->CT2_LOTE
			cDocAnt		:= CT2->CT2_DOC
			cSubLoteAnt	:= CT2->CT2_SBLOTE
			If CtbUso("CT2_DCD")
				cDCDAnt		:= CT2->CT2_DCD
				cDCCAnt		:= CT2->CT2_DCC
			Endif    */

			// Define as novas entidades
			For nX := 1 To Len( aNovasEnt )
				aNovasEnt[nX][3]	:= Val( &("CT2->CT2_EC" + aNovasEnt[nX][1] + "DB") )
				aNovasEnt[nX][4]	:= Val( &("CT2->CT2_EC" + aNovasEnt[nX][1] + "CR") )
			Next
        EndIf
        
		aColsAnt := aClone(aCols)
	EndIf	
	
	CtAtuTab(cTpSald,cTipoCtb,cMoeda,nValorCtb,cDebito,cCredit,cCustoDeb,;
				cCustoCrd,cItemDeb,cItemCrd,cCLVLDeb,cCLVLCrd,aTabela,oTabela,cSayCusto,;
				cSayItem,cSayCLVL,dData,cLote,cSubLote,cDoc,cTipoAnt,nOpc, aNovasEnt )

	// Carrega valores antigos (para o caso de alteracao)
	SETAPILHA()           
	
	nOpcA	:= 0
	If lContinua
		DEFINE MSDIALOG oDlg TITLE OemToAnsi(STR0006) ;  // "Lan‡amento Cont bil"
							FROM 80,1 to 480,615 PIXEL OF GetWndDefault()
		
		DEFINE FONT oFnt	NAME "Arial" 		Size 05,08
		DEFINE FONT oFnt1	NAME "Arial" 		Size 10,12 BOLD  	
		DEFINE FONT oFnt2 	NAME "Courier New" 	SIZE 0,14
		
		@ 12,01 FOLDER oFolder SIZE 306,165 OF oDlg PROMPTS;
	 	aTitles[1],aTitles[2],aTitles[3],aTitles[4] PIXEL
		
		oFolder:Align 		:= CONTROL_ALIGN_ALLCLIENT
		
		// Data Carllos Daniel para Alterar
	 	@ 012,011 	MSGET dData Picture '99/99/9999' When .T. SIZE 40,08 OF oFolder:aDialogs[1] PIXEL
		// Lote				 
		@ 012,054 	MSGET oLote VAR cLote Picture "@!" When .F. SIZE 12,08 OF oFolder:aDialogs[1] PIXEL
	
		// Sub-Lote				 
		@ 012,082 	MSGET oSubLote VAR cSubLote Picture "!!!" When .F. SIZE 12,08 OF oFolder:aDialogs[1] PIXEL
				  
		// Documento	
		@ 012,107 	MSGET oDoc VAR cDoc Picture "999999" When .F. SIZE 12,08 OF oFolder:aDialogs[1] PIXEL
		
		// Tipo do Saldo	
		@ 012,145 	MSGET oTpSald VAR cTpSald F3 "SL" SIZE 12,08 OF oFolder:aDialogs[1] PIXEL Valid (!Empty(cTpSald) .And.;	
					cTpSald > "0" .And. ExistCpo("SX5", "SL" + cTpSald)) .And.;
					CtbTpSald(cTpSald,oDTpSald) .And. ;
					IIf(nOpc == 4, Ctb101Moeda(cMoeda, nOpc, dData, cTpSaldAnt),.T.) .And. ;
					Ctb101Moeda(cMoeda, nOpc, dData, cTpSald) .And. ;
					Ctb101Bloq("","","cTpSald",cTpSald,cTpSaldAnt,dData,cTipoCTB,cDebito,cCredit,cCustoDeb,cCustoCrd,;
					cItemDeb,cItemCrd,cCLVLDeb,cCLVLCrd) HASBUTTON								

		oTpSald:lReadOnly:= !lDigita
	
		@ 025,145 	SAY oDTpSald Var Upper(Tabela("SL", cTpSald, .F.)) OF oFolder:aDialogs[1];
					FONT oFnt PIXEL COLOR CLR_HBLUE
	
		// Tipo Lancto					
		@ 012,175 MSCOMBOBOX oCombo VAR cTipoCTB ITEMS aTipos When .F. SIZE 55,08 OF oFolder:aDialogs[1] PIXEL ;
		                Valid (CtbTipo(@cTipoCTB,aTipos,@aTabela,oTabela,cSayCusto,cSayItem,cSayCLVL,nOpc) .And.;
						Ctb101Bloq("","","cTipoCTB",cTipoCTB,cTipoAnt,dData,cTipoCTB,cDebito,cCredit,cCustoDeb,cCustoCrd,;
						cItemDeb,cItemCrd,cCLVLDeb,cCLVLCrd) .And. ;		  					  		
						CtAtuTab(cTpSald,cTipoCtb,cMoeda,nValorCtb,cDebito,cCredit,cCustoDeb,;
						cCustoCrd,cItemDeb,cItemCrd,cCLVLDeb,cCLVLCrd,aTabela,oTabela,cSayCusto,;
						cSayItem,cSayCLVL,dData,cLote,cSubLote,cDoc,cTipoAnt,nOpc, aNovasEnt))
	
		// Moeda Lancto Incluido When .F. para Impedir digitacao em outras moedas // lDigita
		
		@ 012,234 MSGET oMoeda VAR cMoeda When .F. SIZE 25,08 OF oFolder:aDialogs[1] PIXEL ;
						F3 "CTO" Valid (NaoVazio(cMoeda) .And. Ctb101Moeda(cMoeda, nOpc, dData, cTpSald) .And.;
						MontaConv(nValorCTB,cTipoCTB,dData,oGet,cDebito,cCredit,cMoeda,, M->CT2_MCONVER) .And.;
						CtAtuTab(cTpSald,cTipoCtb,cMoeda,nValorCtb,cDebito,cCredit,cCustoDeb,;
						cCustoCrd,cItemDeb,cItemCrd,cCLVLDeb,cCLVLCrd,aTabela,oTabela,cSayCusto,;
						cSayItem,cSayCLVL,dData,cLote,cSubLote,cDoc,cTipoAnt,nOpc, aNovasEnt)) HASBUTTON

		oMoeda:lReadOnly:= !lDigita
						
		cHistPadAnt := cHistPad					

		// Hist. Padrão
		@ 012,270 MSGET oHistPad VAR cHistPad SIZE 30,08 OF oFolder:aDialogs[1] PIXEL;
					F3 "CT8" Valid Ctb101Hist(cHistPad,@cHistPadAnt,@cTexto,@aFormat,oMemo1,oMemo2,@cTipoHist,nOpc) HASBUTTON

		oHistPad:lReadOnly:= !lDigita				

		// Conta Débito	
		@ 036,056 MSGET oDebito VAR cDebito SIZE 50,08 OF oFolder:aDialogs[1] PIXEL HASBUTTON;
						F3 "CT1" Picture "@!" Valid (ConvConta(@cDebito) .And.;
						( cDebito == cDebitoAnt .Or. ( cDebito <> cDebitoAnt .And. ValidaBloq(cDebito,dData,"CT1") .And. ValidaBloq(cDebitoAnt,dData,"CT1"))) .And.;   					
						ValidaConta(cDebito,"1",@oDescDeb) .And.;     
	   					VldStatic("CT2_DEBITO") .And.;
						CtbAmarr1(.T.) .And.;
						CtGeraHist(cDebito,@cHistPadAnt,@cTexto,@aFormat,oMemo1,oMemo2,@cTipoHist,nOpc,@cHistPad) .And.;					
						CtAtuTab(cTpSald,cTipoCtb,cMoeda,nValorCtb,cDebito,cCredit,cCustoDeb,;
						cCustoCrd,cItemDeb,cItemCrd,cCLVLDeb,cCLVLCrd,aTabela,oTabela,cSayCusto,;
						cSayItem,cSayCLVL,dData,cLote,cSubLote,cDoc,cTipoAnt,nOpc, aNovasEnt))
		
		oDebito:lReadOnly:= !lDigita									

		//Se estiver utilizando o digito verificador
	    If CtbUso("CT2_DCD")
			@ 036,120 MSGET oDCD VAR cDCD SIZE 08,08 OF oFolder:aDialogs[1] PIXEL Picture "@!" Valid (CtbVldDig(cDebito,cDCD))	
			oDCD:lReadOnly:= !lDigita									
		EndIf                                                       
						
		// Conta Crédito
		@ 060,056 MSGET oCredito VAR cCredit SIZE 50,08 OF oFolder:aDialogs[1] PIXEL HASBUTTON;
					   F3 "CT1" Picture "@!" Valid (ConvConta(@cCredit) .And.;
						( cCredit == cCreditoAnt .Or. ( cCredit <> cCreditoAnt .And. ValidaBloq(cCredit,dData,"CT1") .And. ValidaBloq(cCreditoAnt,dData,"CT1"))) .And.;      									   
						ValidaConta(cCredit,"2",,@oDescCrd)  .And.;
	   					VldStatic("CT2_CREDIT") .And.;
	   					CtbAmarr1(.F.) .And.;
						CtGeraHist(cCredit,@cHistPadAnt,@cTexto,@aFormat,oMemo1,oMemo2,@cTipoHist,nOpc,@cHistPad) .And.;					
						CtAtuTab(cTpSald,cTipoCtb,cMoeda,nValorCtb,cDebito,cCredit,cCustoDeb,;
						cCustoCrd,cItemDeb,cItemCrd,cCLVLDeb,cCLVLCrd,aTabela,oTabela,cSayCusto,;
						cSayItem,cSayCLVL,dData,cLote,cSubLote,cDoc,cTipoAnt,nOpc, aNovasEnt))
		
		oCredito:lReadOnly:= !lDigita									
						
		//Se tiver estiver utilizando o digito verificador
	    If CtbUso("CT2_DCC")
			@ 060,120 MSGET oDCC VAR cDCC SIZE 08,08 OF oFolder:aDialogs[1] PIXEL ;
					   Picture "@!" Valid (CtbVldDig(cCredit,cDCC))	
		   	oDCC:lReadOnly:= !lDigita									
		EndIf                                                       
						
		// Valor				
			@ 087,056 MSGET nValorCTB When .F. SIZE 80,08 OF oFolder:aDialogs[1] PIXEL HASBUTTON;
				   Picture cPictVal ;
				   Valid ((nValorCTB >= 0) .And. ;
				   		MontaConv(nValorCTB,cTipoCTB,dData,oGet,cDebito,cCredit,cMoeda,, M->CT2_MCONVER) .And.;
						Ctb101Bloq("","","nValorCTB",nValorCTB,nValorAnt,dData,cTipoCTB,cDebito,cCredit,cCustoDeb,cCustoCrd,;
						cItemDeb,cItemCrd,cCLVLDeb,cCLVLCrd) .And. ; 							   		
						CtAtuTab(cTpSald,cTipoCtb,cMoeda,nValorCtb,cDebito,cCredit,cCustoDeb,;
						cCustoCrd,cItemDeb,cItemCrd,cCLVLDeb,cCLVLCrd,aTabela,oTabela,cSayCusto,;
						cSayItem,cSayCLVL,dData,cLote,cSubLote,cDoc,cTipoAnt,nOpc, aNovasEnt))
	
		// Correlativo
		If lSeqCorr
			@ 098,056 MSGET cSeqCorr When .F. SIZE 80,08 OF oFolder:aDialogs[1] PIXEL;
					   Picture PesqPict("CT2","CT2_NODIA")
			nVarLinM := 4
	   EndIf
	
		// Histórico					                                               	
		If (nOpc == 3 .And. mv_par01 ==1)   //Se for inclusao com repet. de dados ou alteracao ou exclusao								
			Aadd(aFormat,cTexto)		
			oMemo2:=MsHGet():New(105+nVarLinM,001,144,45-nVarLinM,oFolder:aDialogs[1],aFormat,,.F.) 
		Else
			oMemo2:=MsHGet():New(105+nVarLinM,001,144,45-nVarLinM,oFolder:aDialogs[1],aFormat,.T.,.F.) 	
		Endif
		
		If nOpc == 6
			If ExistBlock( "CTBA101HI" )
				lHist := ExecBlock("CTBA101HI", .F., .F.)
			EndIf	
			@ 105+nVarLinM,001 GET oMemo1 VAR cTexto When .F. .or. lHist OF oFolder:aDialogs[1] MEMO SIZE 144,45-nVarLinM;
							PIXEL FONT oFnt2 COLOR CLR_BLACK,CLR_HGRAY
		Else
			@ 105+nVarLinM,001 GET oMemo1 VAR cTexto When .F. OF oFolder:aDialogs[1] MEMO SIZE 144,45-nVarLinM;
							PIXEL FONT oFnt2 COLOR CLR_BLACK,CLR_HGRAY
		EndIf
					
		oMemo1:bRClicked := {||AllwaysTrue()}  
		oMemo1:Refresh()
	
		// C Custo - Informações Gerenciais
		@ 048,177 MSGET oCustoDeb VAR cCustoDeb	When .F. SIZE 50,08 OF oFolder:aDialogs[1] PIXEL HASBUTTON;
						F3 "CTT" Picture "@!" Valid (ConvCusto(@cCustoDeb) .And.;
						VldStatic("CT2_CCD") .And.;					
						( cCustoDeb == cCustoDAnt .Or. ( cCustoDeb <> cCustoDAnt .And. ValidaBloq(cCustoDeb,dData,"CTT") .And. ValidaBloq(cCustoDAnt,dData,"CTT"))) .And.;      										
						ValidaCusto(cCustoDeb,"1",@oDescCCD) .And.;
						CtbAmarr1(.T.) .And.;
						CtAtuTab(cTpSald,cTipoCtb,cMoeda,nValorCtb,cDebito,cCredit,cCustoDeb,;
						cCustoCrd,cItemDeb,cItemCrd,cCLVLDeb,cCLVLCrd,aTabela,oTabela,cSayCusto,;
						cSayItem,cSayCLVL,dData,cLote,cSubLote,cDoc,cTipoAnt,nOpc, aNovasEnt))

		oCustoDeb:lReadOnly:= (!lDigita .and. __lCusto)
	
		@ 048,233 MSGET oCustoCrd VAR cCustoCrd When .F. SIZE 50,08 OF oFolder:aDialogs[1] PIXEL HASBUTTON;
						F3 "CTT" Picture "@!" Valid (ConvCusto(@cCustoCrd) .And.;
						VldStatic("CT2_CCC") .And.;					
						( cCustoCrd == cCustoCAnt .Or. ( cCustoCrd <> cCustoCAnt .And. ValidaBloq(cCustoCrd,dData,"CTT") .And. ValidaBloq(cCustoCAnt,dData,"CTT"))) .And.;      															
						ValidaCusto(cCustoCrd,"2",,@oDescCCC) .And.;
						CtbAmarr1(.F.) .And.; 
						CtAtuTab(cTpSald,cTipoCtb,cMoeda,nValorCtb,cDebito,cCredit,cCustoDeb,;
						cCustoCrd,cItemDeb,cItemCrd,cCLVLDeb,cCLVLCrd,aTabela,oTabela,cSayCusto,;
						cSayItem,cSayCLVL,dData,cLote,cSubLote,cDoc,cTipoAnt,nOpc, aNovasEnt))

		oCustoCrd:lReadOnly:= (!lDigita .and. __lCusto)
				
		// Item					
		@ 077,177 MSGET oItemDeb VAR cItemDeb When .F. SIZE 50,08 OF oFolder:aDialogs[1] PIXEL HASBUTTON;
						F3 "CTD" Picture "@!" Valid (ConvItem(@cItemDeb) .And.;
						VldStatic("CT2_ITEMD") .And.;					
						( cItemDeb == cItemDAnt .Or. ( cItemDeb <> cItemDAnt .And. ValidaBloq(cItemDeb,dData,"CTD") .And. ValidaBloq(cItemDAnt,dData,"CTD"))) .And.;      										
						ValidItem(cItemDeb,"1",oDescItD) .And.;
						CtbAmarr1(.T.)  .And.;
						CtAtuTab(cTpSald,cTipoCtb,cMoeda,nValorCtb,cDebito,cCredit,cCustoDeb,;
						cCustoCrd,cItemDeb,cItemCrd,cCLVLDeb,cCLVLCrd,aTabela,oTabela,cSayCusto,;
						cSayItem,cSayCLVL,dData,cLote,cSubLote,cDoc,cTipoAnt,nOpc, aNovasEnt))

		oItemDeb:lReadOnly:= (!lDigita .and. __lItem)
						
		@ 077,233 MSGET oItemCrd VAR cItemCrd When .F. SIZE 50,08 OF oFolder:aDialogs[1] PIXEL HASBUTTON;
						F3 "CTD" Picture "@!" Valid (ConvItem(@cItemCrd) .And.;
						VldStatic("CT2_ITEMC") .And.;				
						( cItemCrd == cItemCAnt .Or. ( cItemCrd <> cItemCAnt .And. ValidaBloq(cItemCrd,dData,"CTD") .And. ValidaBloq(cItemCAnt,dData,"CTD"))) .And.;      										
						ValidItem(cItemCrd,"2",,oDescItC) .And.;
						CtbAmarr1(.F.) .And.; 
						CtAtuTab(cTpSald,cTipoCtb,cMoeda,nValorCtb,cDebito,cCredit,cCustoDeb,;
						cCustoCrd,cItemDeb,cItemCrd,cCLVLDeb,cCLVLCrd,aTabela,oTabela,cSayCusto,;
						cSayItem,cSayCLVL,dData,cLote,cSubLote,cDoc,cTipoAnt,nOpc, aNovasEnt))
		oItemCrd:lReadOnly:= (!lDigita .and. __lItem)
						
		// Classe Vlr
		@ 105,177 MSGET oCLVLDeb VAR cCLVLDeb When .F. SIZE 50,08 OF oFolder:aDialogs[1] PIXEL HASBUTTON;
						F3 "CTH" Picture "@!" Valid (ConvClvl(@cCLVLDeb) .And.;			
						VldStatic("CT2_CLVLDB") .And.;					
						( cClVlDeb == cClVlDAnt .Or. ( cClVlDeb <> cClVlDAnt .And. ValidaBloq(cClVlDeb,dData,"CTH") .And. ValidaBloq(cClVlDAnt,dData,"CTH"))) .And.;      															
						ValidaCLVL(cCLVLDeb,"1",oDescCVD) .And.;
						CtbAmarr1(.T.)  .And.;
						CtAtuTab(cTpSald,cTipoCtb,cMoeda,nValorCtb,cDebito,cCredit,cCustoDeb,;
						cCustoCrd,cItemDeb,cItemCrd,cCLVLDeb,cCLVLCrd,aTabela,oTabela,cSayCusto,;
						cSayItem,cSayCLVL,dData,cLote,cSubLote,cDoc,cTipoAnt,nOpc, aNovasEnt))
		oCLVLDeb:lReadOnly:= (!lDigita .and. __lCLVL)
						
		@ 105,233 MSGET oCLVLCrd VAR cCLVLCrd When .F. SIZE 50,08 OF oFolder:aDialogs[1] PIXEL HASBUTTON;
						F3 "CTH" Picture "@!" Valid (ConvClvl(@cCLVLCrd) .And.;			
						VldStatic("CT2_CLVLCR") .And.;
						( cClVlCrd == cClVlCAnt .Or. ( cClVlCrd <> cClVlCAnt .And. ValidaBloq(cClVlCrd,dData,"CTH") .And. ValidaBloq(cClVlCAnt,dData,"CTH"))) .And.;      															
						ValidaCLVL(cCLVLCrd,"2",,oDescCVC) .And.;
						CtbAmarr1(.F.)  .And.;
						CtAtuTab(cTpSald,cTipoCtb,cMoeda,nValorCtb,cDebito,cCredit,cCustoDeb,;
						cCustoCrd,cItemDeb,cItemCrd,cCLVLDeb,cCLVLCrd,aTabela,oTabela,cSayCusto,;
						cSayItem,cSayCLVL,dData,cLote,cSubLote,cDoc,cTipoAnt,nOpc, aNovasEnt))
		oCLVLCrd:lReadOnly:= (!lDigita .and. __lCLVL)                          
		
		lNEntBloq	:= Ctb101Bloq("","","",,,dData,cTipoCTB,cDebito,cCredit,cCustoDeb,cCustoCrd,;
						cItemDeb,cItemCrd,cCLVLDeb,cCLVLCrd,.F.)				
	
		// FOLDER DE CONVERSAO DE MOEDAS
		oGet := MSGetDados():New(05,02,130,300,If(nOpc = 3, 4, nOpc),;
				"CTB101LIOK","CTB101TOK","",.F.,aAlter,,.F.,Len(aCols),,,,,oFolder:aDialogs[2])
		
		oGet:oBrowse:bLostFocus := { || CTB101TOk() }
		
		// Rodape do Folder de Conversoes
		Ct101Rodape(oFolder,dData,cLote,cSubLote,cDoc,cLinha,nValorCTB,oLote,oSubLote,;
					oDoc,oLinha,oFnt1,2)
		
		For nCont:= 1 to Len(oFolder:aDialogs)
			oFolder:aDialogs[nCont]:oFont := oDlg:oFont      
		   DEFINE SBUTTON FROM 5000,5000 TYPE 5 ACTION Allwaystrue() ENABLE OF oFolder:aDialogs[nCont]
		Next 
		
		// Linhas
		@ 000,006 TO 028, 138 OF oFolder:aDialogs[1] PIXEL
		@ 030,006 TO 085, 138 LABEL OemToAnsi(STR0029) OF oFolder:aDialogs[1] ;
					COLOR CLR_RED PIXEL
		
		@ 030,145 TO 130, 300 LABEL OemToAnsi(STR0025) OF oFolder:aDialogs[1] ;
					COLOR CLR_RED PIXEL
		
		@ 005,011 SAY OemToAnsi(STR0008) SIZE 35,08 OF oFolder:aDialogs[1] PIXEL // "Data "
		@ 005,054 SAY OemToAnsi(STR0009) SIZE 35,08 OF oFolder:aDialogs[1] PIXEL // "Lote"
		@ 005,081 SAY OemToAnsi(STR0062) SIZE 35,08 OF oFolder:aDialogs[1] PIXEL // "Sub-Lote"
		@ 005,107 SAY OemToAnsi(STR0010) SIZE 27,08 OF oFolder:aDialogs[1] PIXEL // "Documento"
		@ 005,145 SAY OemToAnsi(STR0046) SIZE 30,08 OF oFolder:aDialogs[1] PIXEL // "Tipo do Saldo" -> Real / Orcado
		@ 005,175 SAY OemToAnsi(STR0021) SIZE 30,08 OF oFolder:aDialogs[1] PIXEL // "Tipo Lcto"
		@ 005,234 SAY OemToAnsi(STR0036) SIZE 30,08 OF oFolder:aDialogs[1] PIXEL // "Moeda Lcto"
		@ 005,270 SAY OemToAnsi(STR0037) SIZE 20,08 OF oFolder:aDialogs[1] PIXEL // "Hist Padrão"
		@ 038,010 SAY OemToAnsi(STR0022) SIZE 35,08 OF oFolder:aDialogs[1] PIXEL // "Conta Débito"
		If CtbUso("CT2_DCD")
			@ 038,107 SAY STR0069 SIZE 12,08 OF oFolder:aDialogs[1] PIXEL // "Débito"	
		EndIf     
		@ 048,010 SAY oDescDeb PROMPT cDescDeb SIZE 100,12 OF oFolder:aDialogs[1] ;
					  PIXEL FONT oFnt COLOR CLR_HBLUE
		@ 062,010 SAY OemToAnsi(STR0023) SIZE 45,08 OF oFolder:aDialogs[1] PIXEL // "Conta Crédito"
		If CtbUso("CT2_DCC")
			@ 062,107 SAY STR0069 SIZE 12,08 OF oFolder:aDialogs[1] PIXEL // "Crédito"	
		EndIf	
		@ 072,010 SAY oDescCrd PROMPT cDescCrd SIZE 100,12 OF oFolder:aDialogs[1];
					  PIXEL FONT oFnt COLOR CLR_HBLUE
		@ 087,010 SAY OemToAnsi(STR0024) SIZE 35,08 OF oFolder:aDialogs[1] PIXEL // "Valor"
		
		If lSeqCorr
			@ 097,010 SAY OemToAnsi(STR0068) SIZE 35,08 OF oFolder:aDialogs[1] PIXEL // "Correlativo"
		Else 
			@ 097,010 SAY OemToAnsi(STR0028) SIZE 35,08 OF oFolder:aDialogs[1] PIXEL // "Histórico"
		EndIf	
		
		// Informações Gerenciais
		@ 038,177 SAY OemToAnsi(STR0030) SIZE 35,08 OF oFolder:aDialogs[1] PIXEL // "Débito"
		@ 038,233 SAY OemToAnsi(STR0031) SIZE 25,08 OF oFolder:aDialogs[1] PIXEL // "Crédito"
		
		// C Custo    
		If Empty(cSayCusto)
			@ 048,150 SAY OemToAnsi(STR0027) SIZE 35,08 OF oFolder:aDialogs[1] PIXEL // "C.Custo"
		Else
			@ 048,150 Say cSayCusto SIZE 35,08 OF oFolder:aDialogs[1] PIXEL
		EndIf					
		@ 059,150 SAY oDescCCD PROMPT cDescCCD SIZE 62,12 OF oFolder:aDialogs[1] ;
				  PIXEL FONT oFnt COLOR CLR_HBLUE
				  
		@ 059,233 SAY oDescCCC PROMPT cDescCCC SIZE 62,12 OF oFolder:aDialogs[1] ;
				  PIXEL FONT oFnt COLOR CLR_HBLUE
		
		// Item
		If Empty(cSayItem)
			@ 077,150 SAY OemToAnsi(STR0026) SIZE 35,08 OF oFolder:aDialogs[1] PIXEL // "Item"
		Else
			@ 077,150 SAY cSayItem SIZE 35,08 OF oFolder:aDialogs[1] PIXEL
		EndIf			
		@ 088,150 SAY oDescItD PROMPT cDescItD SIZE 62,12 OF oFolder:aDialogs[1] ;
				  PIXEL FONT oFnt COLOR CLR_HBLUE
				  
		@ 088,233 SAY oDescItC PROMPT cDescItC SIZE 62,12 OF oFolder:aDialogs[1] ;
				  PIXEL FONT oFnt COLOR CLR_HBLUE
		
		// Classe de Valor
		If Empty(cSayCLVL)
			@ 105,150 SAY OemToAnsi(STR0032) SIZE 35,08 OF oFolder:aDialogs[1] PIXEL // "Classe Valor"
		Else
			@ 105,150 SAY cSayCLVL SIZE 35,08 OF oFolder:aDialogs[1] PIXEL
		EndIf		
		
		@ 116,150 SAY oDescCVD PROMPT cDescCVD SIZE 62,12 OF oFolder:aDialogs[1] ;
				  PIXEL FONT oFnt COLOR CLR_HBLUE
				  
		@ 116,233 SAY oDescCVC PROMPT cDescCVC SIZE 62,12 OF oFolder:aDialogs[1] ;
				  PIXEL FONT oFnt COLOR CLR_HBLUE
		
		@ 135,150 Say OemToAnsi(STR0039) SIZE 100,08 OF oFolder:aDialogs[1] ;	// "Linha Lançamento"
						PIXEL FONT oFnt1 COLOR CLR_RED
		@ 135,250 Say oLinha PROMPT cLinha Picture "!!!" SIZE 100,08 OF oFolder:aDialogs[1] ;
						PIXEL FONT oFnt1 COLOR CLR_RED
						
		//Necessario porque na inclusao do lancamento nao atualizava o folder de conversao de saldos
		@ 140,216 MSGET nValorCTB SIZE 80,08 OF oFolder:aDialogs[2] PIXEL ;
						Picture cPictVal When .F.									
						
		// FOLDER OUTRAS INFORMACOES
		aTela := {}
		aGets := {}
		RegToMemory("CT2",.F.)
		aOutros := Ct101Outr(aOutros)
      
		If nOpc <> 3
			aOutrEntid := {}
			For nEntid := 1 TO nQtdEntid - 4  //4 entidades sao padrao conta / centro de custo / item / classe de valor
				aAdd(aOutrEntid, "CT2_EC"+StrZero(nEntid+4, 2)+"DB" )   //entidade 05 em diante
				aAdd(aOutrEntid, "CT2_EC"+StrZero(nEntid+4, 2)+"CR" )
			Next
			aAdd(aOutrEntid, "CT2_ATIVDE")
			aAdd(aOutrEntid, "CT2_ATIVCR")

			/* atividades */
			For nX := 1 To 9
				aAdd(aOutrEntid, "CT2_AT" + StrZero(nX,2) + "DB")
				aAdd(aOutrEntid, "CT2_AT" + StrZero(nX,2) + "CR")
			Next nX
		EndIf

		If nOpc == 6 .Or. (nOpc == 3 .And. (mv_par01 == 2 .Or. lFirstLin))
			If Len(aOutros) > 0 
				For nOutros	:= 1 to Len(aOutros)
					If Ascan(aOutrEntid, aOutros[nOutros]) == 0
						&("M->"+(aOutros[nOutros]))	:= CriaVar(aOutros[nOutros])
						If Valtype(&("M->"+(aOutros[nOutros]))) == "L"					/// SE FOR CAMPO LOGICO
							&("M->"+(aOutros[nOutros])) := .T.							/// MUDA DEFAULT PARA .T.
						Endif
					EndIf
				Next
				lFirstLin	:= .F.
			EndIf	
		EndIf
	
		If nOpc == 6  //estorno inverte as outras entidades
			For nEntid := 1 TO nQtdEntid - 4  //4 entidades sao padrao conta / centro de custo / item / classe de valor
				cAuxEnt := &("M->"+"CT2_EC"+StrZero(nEntid+4, 2)+"DB" )  //entidade 05 em diante
				&("M->"+"CT2_EC"+StrZero(nEntid+4, 2)+"DB" )  := &("M->"+"CT2_EC"+StrZero(nEntid+4, 2)+"CR" )
				&("M->"+"CT2_EC"+StrZero(nEntid+4, 2)+"CR" )  := cAuxEnt
			Next	

			cAuxEnt := M->CT2_ATIVDE
			M->CT2_ATIVDE := M->CT2_ATIVCR
			M->CT2_ATIVCR := cAuxEnt

			/* atividades */
			For nX := 1 To 9
				cCpoDB := "CT2_AT" + StrZero(nX,2) + "DB"
				cCpoCR := "CT2_AT" + StrZero(nX,2) + "CR"
				If CT2->(FieldPos(cCpoDB)) > 0 .And. CT2->(FieldPos(cCpoCR)) > 0
					cAuxEnt := &("M->"+cCpoDB )
					&("M->"+cCpoDB )  := &("M->"+cCpoCR )
					&("M->"+cCpoCR )  := cAuxEnt
				EndIf
			Next
		EndIf
		
		M->CT2_DIACTB:= cCodSeq
		Zero()
		oEnchoice:= MsMGet():New(cAlias,nReg,nOpc, , , ,aOutros,{01,01,165,310},,,,,,oFolder:aDialogs[3],,,.F.,"aSvATela")
		oEnchoice:oBox:bGotFocus   := {|| Ct_EntraEnc()}
		oEnchoice:oBox:bLostFocus  := {|| Ct_SaiEnc()} 
		oEnchoice:oBox:Align := CONTROL_ALIGN_ALLCLIENT
		aSvATela := aClone(aTela)
		aSvAGets := aClone(aGets)
	
		// FOLDER DE SALDOS
		// Rodape Folder de Saldos
		Ct101Rodape(oFolder,dData,cLote,cSubLote,cDoc,cLinha,nValorCTB,oLote,oSubLote,;
					oDoc,oLinha,oFnt1,4)
	
		@ 01, 01 Say OemToAnsi(STR0043) SIZE 100,08 OF oFolder:aDialogs[4] ;	// Saldos Acumulados
						PIXEL FONT oFnt1 COLOR CLR_RED
	
		@ 10.0,0.0 LISTBOX oTabela VAR cVarQ Fields; 
						            HEADER 	OemToAnsi(STR0042),; // "Identificador"
											OemToAnsi(STR0041),; // "Codigo"
											OemToAnsi(STR0030),; // "Debito"
											OemToAnsi(STR0031),; // "Credito"
						     				OemToAnsi(STR0040);  // "Saldo"
						            COLSIZES 50,;
									GetTextWidth(0,"BBBBBBB"),;
									GetTextWidth(0,"BBBBBBBBB"),;
									GetTextWidth(0,"BBBBBBBBB"),;
									GetTextWidth(0,"BBBBBBBBB") SIZE 300,120 NOSCROLL ;
									OF oFolder:aDialogs[4] PIXEL
	
		oTabela:SetArray(aTabela)
		oTabela:bLine := { || { 	aTabela[oTabela:nAt,1],aTabela[oTabela:nAt,2],;
									aTabela[oTabela:nAt,3],aTabela[oTabela:nAt,4],;
									aTabela[oTabela:nAt,5] }}
									
		//Necessario porque na inclusao do lancamento nao atualizava o folder de saldos.								
		@ 140,216 MSGET nValorCTB SIZE 80,08 OF oFolder:aDialogs[4] PIXEL;
						Picture cPictVal When .F.				
	                                                                                          
		ACTIVATE DIALOG oDlg ;
		ON INIT EnchoiceBar(oDlg,	{||nOpca:=1,;
										If(Ctba101OK(cTipoCTB,cMoeda,cDebito,cCredit,cCustoDeb,cCustoCrd,;
													  cItemDeb,cItemCrd,cClVLDeb,cClVLCrd,nValorCTB,@cTexto,cTpSald,nOpc,oMemo2,oMemo1,cTipoHist,;
													  dData,cLote,cSubLote,cDoc,cDCD,cDCC,nRegCT2M01,cEmpOri,cFilOri,cLinha),;
											If(!Obrigatorio(aGets,aTela),;
												nOpca:=0,;
												oDlg:End()),;
										nOpca:=0)},;
								 	{||nOpca:=0,oDlg:End()}) CENTERED
	
		SETAPILHA()
	
		If nOpca <> 1
			nOpca := 0
		Else
			If nOpc == 2
				nOpca := 0
			EndIf		
		Endif
		
		If nOpca == 1			// Confirmou Lancamento
			If nOpc == 3	.Or. nOpc ==7	// Inclusao
				cFrase := 	STR0048+STR0049
			ElseIf nOpc == 4	// Alteracao
				cFrase := 	STR0048+STR0050
			ElseIf nOpc == 5	// Exclusao
				cFrase := 	STR0048+STR0051
			ElseIf nOpc == 6	// Estorno
				cFrase := 	STR0048+STR0065+ ": "+DtoC(dDataAnt)+"-"+cLoteAnt+;
							"-"+cSubLoteAnt+"-"+cDocAnt+"-"+CT2->CT2_LINHA
			EndIf  

			If nOpc != 2
				lRet := (nOpc == 3 .AND. MV_PAR02 == 2) .OR. MsgYesNo(OemToAnsi(cFrase),OemToAnsi(STR0047))

				If lRet
					// faz a validação dos campos
		 	   		If ExistBlock( "VDCTB101GR" ) // opção de validação antes da gravação do lançamento
						lRet := ExecBlock( "VDCTB101GR" , .F. , .F. , {nOpc,dData,cLote,cSubLote,cDoc})
					EndIf
			 	Endif

				If lRet
					nGravados ++
					aDemaisEnt 	:= CtbOutrEnt(.T.)
					aEntid 		:= aDemaisEnt[1]
					aEntidAnt 	:= aDemaisEnt[2]
					
					 //grava data
					
					
					dbSelectArea("CT2")
					dbSetOrder(1)      	//DTOS(CT2->CT2_DATA)+CT2->CT2_LOTE+CT2->CT2_SBLOTE+CT2->CT2_DOC+CT2->CT2_LINHA+CT2->CT2_TPSALD+CT2->CT2_EMPORI+CT2->CT2_FILORI+CT2->CT2_MOEDLC  
					dbSeek(xFilial("CT2")+DTOS(CT2->CT2_DATA)+CT2->CT2_LOTE+CT2->CT2_SBLOTE+CT2->CT2_DOC+CT2->CT2_LINHA+CT2->CT2_TPSALD+CT2->CT2_EMPORI+CT2->CT2_FILORI+CT2->CT2_MOEDLC)     // Busca exata
					
					IF FOUND()    // Avalia o retorno da pesquisa realizada
          				RECLOCK("CT2", .F.)
 
          				IF CT2->CT2_DTCV3 == CT2->CT2_DATA
          					CT2->CT2_DTCV3 := dData	
          				ENDIF
          				CT2->CT2_DATA := dData
 
          			MSUNLOCK()     // Destrava o registro
					ENDIF  
					RETURN()
		/*
					CTBercGrv(dData,cLote,cSubLote,cDoc,@cLinha,cTipoCTB,cMoeda,;
							  cHistPad,cDebito,cCredit,cCustoDeb,cCustoCrd,cItemDeb,;
							  cItemCrd,cClVlDeb,cClVlCrd,nValorCTB,cTexto,cTpSald,;
							  @cSeqLan,nOpc,aOutros,cDebitoAnt,cCreditoAnt,cCustoDAnt,;
							  cCustoCAnt,cItemDAnt,cItemCAnt,cCLVLDAnt,cCLVLCAnt,;
							  nValorAnt,cTipoAnt,cTpSaldAnt,cMoedaAnt,aColsAnt,nTotInf,;
							  dDataAnt,cLoteAnt,cSubLoteAnt,cDocAnt,cEmpOri,cFilOri,;
							  cDCD,cDCC,cDCDAnt,cDCCAnt,cCodSeq,lSeqCorr,@cSeqCorr,aEntid,;
							  aEntidAnt,lAtuCorr,cHistLote)

                       */
					FreeUsedCode()  //libera codigos de correlativos reservados pela MayIUseCode()
				EndIf

				If nOpc != 3
					nOpca := 0
				Else
					//Verificar se a linha eh maior que o conteudo do parametro MV_NUMMAN
					If cLinha	> cNumManLin				
						nOpca := 0
					EndIf			
				EndIf 
			EndIf			

			If nOpc != 5
				//CHAMADA DA FUNCAO PARA GRAVACAO DO VALOR INFORMADO NA CAPA DO LOTE PARA O DOCUMENTO.		
				CtbGrVlInf(dData,cLote,cSubLote,cDoc,cMoeda,nTotInf,nOpc)
			EndIf
		Endif
   EndIf
EndDo

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Program   ³Ctb101Hist³ Autor ³ Pilar S. Albaladejo   ³ Data ³ 24.07.00 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Valida Historico Padrao e monta String com Historico       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³Ctb101Hist(cHistPad,cHistPadAnt,cTexto,aFormat,oMemo1,oMemo2³±±
±±³          ³cTipoHist,nOpc,lGetDB)                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ .T. / .F.	                                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Generico 	                                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpC1 = Codigo Historico Padrao                            ³±±
±±³          ³ ExpC2 = Codigo do Historico Padrao anterior                ³±±
±±³          ³ ExpC3 = Texto do Historico Contabil                        ³±±
±±³          ³ ExpA1 = Array contendo os dados p/ Historico Inteligente   ³±±
±±³          ³ ExpO1 = Objeto Memo 1                                      ³±±
±±³          ³ ExpO2 = Objeto Memo 2                                      ³±±
±±³          ³ ExpC4 = Tipo do Historico(Padrao/Inteligente)              ³±±
±±³          ³ ExpN1 = Numero da opcao escolhida.                         ³±±
±±³          ³ ExpL1 = Se e proveniente da GetDB                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function Ctb101Hist(cHistPad,cHistPadAnt,cTexto,aFormat,oMemo1,oMemo2,cTipoHist,nOpc,lGetDB)

Local aSaveArea:= GetArea()
Local lRet		:= .T.
Local nTamHist	:= Len(CriaVar("CT2_HIST"))
Local nCont
Local cTextoCT8	:= ""

DEFAULT lGetDB := .F.
If !Empty(cHistPad)
	dbSelectArea("CT8")          
	dbSetOrder(1)
	If dbSeek(xFilial()+cHistPad)
		If ! lGetDB		
			If (cHistPad != cHistPadAnt .And. nOpc == 4).Or. nOpc == 3 //So entra se for 
				cTextoCT8 := CT8->CT8_DESC			//alteracao e o hist. padrao foi alterado. 		
				cTexto	  := ""
				aFormat := {}						//ou se for inclusao. 	
				If CT8->CT8_IDENT == 'C'  
					For nCont := 1 to Len(cTextoCT8) Step nTamHist
						cTexto += Substr(CT8->CT8_DESC,nCont,nTamHist)
					Next nCont
					cTipoHist := 'C'       
				
					If ValType(oMemo2) == "O"
						oMemo2:Hide()
					Endif	
			
					If ValType(oMemo1) == "O"
						oMemo1:SetText(cTexto)
						oMemo1:Show()
						oMemo1:Refresh()
					Endif               			
				Else			                                    
					While !Eof() .And. CT8->CT8_HIST == cHistPad .And. CT8->CT8_IDENT == 'I'
						Aadd(aFormat,CT8->CT8_DESC)
						dbSkip()
					Enddo
					cTipoHist := 'I'                   
					oMemo2:Restart(aFormat)			                                            
					oMemo2:Show()
					cTexto:=oMemo2:GetText()
					If ValType(oMemo1) == "O"
						oMemo1 :Hide()
					Endif
				Endif                               		
				cHistPadAnt := cHistPad
			Endif

		Else
			If CT8->CT8_IDENT == 'C'  
				TMP->CT2_HP   := CT8->CT8_HIST
				TMP->CT2_HIST := SubStr(CT8->CT8_DESC,1,40)
			Else
				MontHistInt(CT8->CT8_HIST)
			EndIf
		EndIf

	Else
		If ! lGetDB
			Help(" ",1,"NOHISTPAD")
			lRet := .F.
		EndIf
	EndIf
Else
	If ValType(oMemo1) == "O"
		If !Empty(cHistPadAnt)
			cTexto := "" 
			cTipoHist := "C"
			oMemo1:Refresh()
			oMemo1:Show()
		EndIf	
	Endif
EndIf

RestArea(aSaveArea)

Return lRet

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Program   ³CriaConv  ³ Autor ³ Pilar S. Albaladejo   ³ Data ³ 24.07.00 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Cria aHeader e aCols para getdados de conversao            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³Criaconv()	                                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ Nenhum   	                                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Generico 	                                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ Nenhum                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function CriaConv(lMoeda1, nOpc)

Local nCont		:= 0
Local cBloq		:= ""
Local cMoeda	:= ""
Local nMaiorDec := 2
Local cMaiorPic := ""
Local lDtTxUso	:= .F.
Local nPos_ALI_WT, nPos_REC_WT

DEFAULT lMoeda1 := .F.
DEFAULT nOpc := 3

aHeader				:= {}

// Montagem da matriz aHeader									
dbSelectArea("SX3")
dbSetOrder(2)

dbSeek("CT2_MOEDLC")
AADD(aHeader,{OemToAnsi(STR0033), x3_campo, x3_picture,;
				x3_tamanho, x3_decimal, x3_valid,;
				x3_usado, x3_tipo, x3_arquivo, x3_context } )

//dbSeek("CT2_CONVER")
dbSeek("CT2_CRCONV")
AADD(aHeader,{OemToAnsi(STR0034), x3_campo, x3_picture,;
			1, x3_decimal, "CTB101CRIT() .And. ValidaCriter(M->CT2_CRCONV,'CTBAERC',M->CT2_TPSALD)",;
			x3_usado, x3_tipo, x3_arquivo, x3_context } )

dbSeek("CT2_VALOR")
cMaiorPic := SX3->X3_PICTURE

/// MONTAR A COLUNA DE VALOR DE ACORDO COM O MAIOR DECIMAL POSSIVEL
dbSeek("CT2_VALR02")
While SX3->(!Eof()) .and. Left(SX3->X3_CAMPO,8) == "CT2_VALR"
	If SX3->X3_DECIMAL > nMaiorDec
		nMaiorDec := SX3->X3_DECIMAL
		cMaiorPic := SX3->X3_PICTURE
	EndIf
	SX3->(dbSkip())
EndDo

dbSeek("CT2_VALOR")
AADD(aHeader,{OemToAnsi(STR0035), x3_campo, cMaiorPic,;
			x3_tamanho, nMaiorDec, "CTB101VLC()",;
			x3_usado, x3_tipo, x3_arquivo, x3_context } )

dbSeek("CTP_BLOQ")
AADD(aHeader,{OemToAnsi(STR0059), x3_campo, x3_picture,;
			x3_tamanho, x3_decimal, x3_valid,;
			x3_usado, x3_tipo, x3_arquivo, x3_context } )
For nCont	:= 2 to __nQuantas
	If CtbUso("CT2_DTTX"+StrZero(nCont,2))			
		lDtTxUso		:= .T.
		Exit		
	EndIf
Next   

/*If lDtTxUso
	dbSeek("CT2_DTTX02")
	AADD(aHeader,{OemToAnsi(STR0071), x3_campo, x3_picture,;
					x3_tamanho, x3_decimal, "CtbDtVenc()",;
					x3_usado, x3_tipo, x3_arquivo, x3_context } )
EndIf  */

CtbHeaderWT("CT2", aHeader)

nPos_ALI_WT := AScan(aHeader,{|x| Upper(AllTrim(x[2])) == "CT2_ALI_WT"})
nPos_REC_WT := AScan(aHeader,{|x| Upper(AllTrim(x[2])) == "CT2_REC_WT"})
nCont	:= 0 			

aAlter := {"CT2_MANUAL","CT2_CRCONV","CT2_VALOR","CT2_DTTX02"}

dbSelectArea("CTO")
dbSetOrder(1)
dbSeek(xFilial())

While !Eof() .And. xFilial() == CTO->CTO_FILIAL

	cMoeda := CTO->CTO_MOEDA

	//Nao devera mostrar a moeda 01 na tela de conversao	
	If !lMoeda1
		If cMoeda = '01'
			dbSkip()
			Loop
		EndIf
	EndIf

	cBloq  := CTO->CTO_BLOQ
	
	nCont++

	If lDtTxUso
		AADD(aCols,Array(If(nPos_ALI_WT>0,8,6)))	     
	Else
		AADD(aCols,Array(If(nPos_ALI_WT>0,7,5)))
	EndIf

	aCols[nCont][1]		:= cMoeda
	aCols[nCont][2]		:= Space(aHeader[2][4])
	aCols[nCont][3]		:= 0
	aCols[nCont][4]		:= cBloq					// Indica se moeda esta bloqueada
	If lDtTxUso	
		aCols[nCont][5]		:= dDataLanc
		If nPos_ALI_WT > 0
			aCols[nCont][8]		:= .F.
		Else			
			aCols[nCont][6]		:= .F.
		EndIf	
	Else		
		If nPos_ALI_WT > 0
			aCols[nCont][7]		:= .F.
		Else			
			aCols[nCont][5]		:= .F.
		EndIf	
	EndIf
	If nPos_ALI_WT > 0
		aCols[nCont, nPos_ALI_WT] := "CT2"
		aCols[nCont, nPos_REC_WT] := If(nOpc==3.Or.nOpc=7, 0, CT2->(Recno()))
	EndIf	
	
	dbSkip()
EndDo

If nCont == 0				// Nao montou array, porque nao achou moeda
	AADD(aCols,Array(If(nPos_ALI_WT>0,7,5)))   
	aCols[1][1]		:= Space(aHeader[1][4])
	aCols[1][2]		:= Space(aHeader[2][4])
	aCols[1][3]		:= 0
	aCols[1][4]		:= ""					// Indica se moeda esta bloqueada
	If lDtTxUso		
		aCols[1][5]		:= dDataLanc
		If nPos_ALI_WT > 0
			aCols[1][8]		:= .F.
		Else
			aCols[1][6]		:= .F.
		EndIf	
	Else
		If nPos_ALI_WT > 0
			aCols[1][7]		:= .F.	
		Else
			aCols[1][5]		:= .F.	
		EndIf
	EndIf
	If nPos_ALI_WT > 0
		aCols[1, nPos_ALI_WT] := "CT2"
		aCols[1, nPos_REC_WT] := If(nOpc==3.Or.nOpc=7, 0, CT2->(Recno()))
	EndIf	
	aAlter			:= {}
EndIf

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Program   ³MontaConv ³ Autor ³ Pilar S. Albaladejo   ³ Data ³ 24.07.00 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Monta valores convertidos para getdados de conversoes      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³MontaConv(nValor,cTipo,dData,oGet,cDebito,cCredito,cMoedaLc)³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ .T.      	                                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Generico 	                                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpN1 = Valor do Lancamento Contabil                       ³±±
±±³          ³ ExpC1 = Tipo do Lancamento Contabil                        ³±±
±±³          ³ ExpD1 = Data do Lancamento Contabil                        ³±±
±±³          ³ ExpO1 = Objeto Getdados                                    ³±±
±±³          ³ ExpC2 = Conta Debito                                       ³±±
±±³          ³ ExpC3 = Conta Credito                                      ³±±
±±³          ³ ExpC4 = Moeda do Lancamento                                ³±±
±±³          ³ lCtrLct = Indica se carrega criterio do lancamento         ³±±
±±³          ³ cCtrLct = Recebe o criterio a ser utilizado                ³±±
±±³          ³ lHelp   = Indica se pode exibir Help. Passada para a       ³±±
±±³          ³           funcao ExistCPOCt1()                             ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function MontaConv( nValor,cTipo,dData,oGet,cDebito,cCredito,cMoedaLc,lCrtLct,cCritLct,lHelp )

Local aSaveArea := GetArea()

Local cCriter	:= ""
Local cMoeda
Local nValConv	:= 0
Local nMoeda	:= 0 
Local nCont		:= 1
Local nRecCT2	:= 0
Local nQuantas	:= 0
Local aPeriodos:= {}
Local lDtTxUso	:= .F.
Local dDataTx	:= CTOD("  /  /  ")
Local cLote		:= CT2->CT2_LOTE
Local cSubLote	:= CT2->CT2_SBLOTE
Local cDoc		:= CT2->CT2_DOC
Local cLinha	:= CT2->CT2_LINHA
Local cTpSald	:= CT2->CT2_TPSALD
Local cEmpOri	:= CT2->CT2_EMPORI
Local cFilOri	:= CT2->CT2_FILORI
Local nPos_ALI_WT, nPos_REC_WT
Local lWT		:= (Type("aHeader")=="A")		// Indica que deve disponibilizar Walk-Thru 
Local aSize 	:= TamSX3("CT2_VALOR")
Local nVlMax 	:= val(repl('9',aSize[1]-IIf(aSize[2]>0,aSize[2]+1,0)))    
Local lRet 		:= .T. 
Local nPosValor := 0

DEFAULT lCrtLct := ! SuperGetMv("MV_CRITPLN", .F., .T.)
DEFAULT lHelp   := .T.

nPos_ALI_WT := Iif( lWT, AScan(aHeader,{|x| Upper(AllTrim(x[2])) == "CT2_ALI_WT"}), 0 )
nPos_REC_WT := Iif( lWT, AScan(aHeader,{|x| Upper(AllTrim(x[2])) == "CT2_REC_WT"}), 0 )

__nValor		:= nValor

If Type("aHeader") == "A"
	nPosValor := AScan(aHeader,{|x| Upper(AllTrim(x[2])) == "CT2_VALOR"})
EndIf

For nMoeda	:= 2 to __nQuantas
	If CtbUso("CT2_DTTX"+StrZero(nMoeda,2))			
		lDtTxUso		:= .T.
		Exit		
	EndIf
Next

If nValor = 0                      
	//O criterio de conversao para as outras moedas sera alterado para 5 caso nao seja taxa informada. 
	For nCont:= 1 to Len(aCols)	
		cMoeda := StrZero(nCont+1,2)
		If cMoeda = '01'	//Moeda 01 nao sera mostrado na tela de conversao
			Loop
		ElseIf(cMoeda <> '01' .And. aCols[nCont][2] <> '4')			
			aCols[nCont][3]	:= 0
		EndIf
		If oGet != Nil					//sera 5.
			oGet:oBrowse:Refresh()
		EndIf	
	Next
	Return .T.						
Else 
	aCols[nCont][2]	:= "1"			
	If oGet != Nil					
		oGet:oBrowse:Refresh()
	EndIf	
Endif

For nCont := 1 To Len(aCols)
	cMoeda	:= aCols[nCont][1]

	If Empty(cMoeda) .Or. cMoeda = '01'	// Primeira moeda nao tem conversao
		Loop
	EndIf	

	//Se for taxa informada ou nao utiliza taxa de conversao,nao atualizo o valor de conversao	
	If aCols[nCont][2] $ '45'	
		Loop
	EndIf
		                                                    
	// Verifica se moeda esta bloqueada ou se data esta bloqueada para a moeda
	// Ou se a moeda do Lancamento eh a calculada
	If 	Empty(cMoeda) .Or. cMoeda = cMoedaLc .Or.;
		(!CTBMInUse(cMoeda) .Or. !CtbDtInUse(cMoeda,dData))
		
		If cMoeda = cMoedaLc 
			If nValor <> 0
				aCols[nCont][2]	:= "1"		
			Else
				aCols[nCont][2] := "5"
			EndIf
		Else		
			aCols[nCont][2]	:= " "
		EndIf
		aCols[nCont][3]	:= 0
		aCols[nCont][4]	:= "1"					// Moeda Bloqueada
		If lDtTxUso
			aCols[nCont][6]	:= .F.		
		Else		
			aCols[nCont][5]	:= .F.
		EndIf
		If nPos_ALI_WT > 0
			aCols[nCont, nPos_ALI_WT] := "CT2"
			aCols[nCont, nPos_REC_WT] := CT2->(Recno())
		EndIf	
		Loop
	EndIf
	                                                    
	aCols[nCont][4]	:= "2"					// Moeda Nao Bloqueada
											// Atualizo caso mude a moeda sendo digitada
    If cMoeda = cMoedaLc
    	cCriter  := "1"
		nValConv := 0.00
    ElseIf ! lCrtLct .And. (cTipo == "1" .Or. cTipo == "3")	// Utilizar criterio da Conta Debito
		dbSelectArea("CT1")
		dbSetOrder(1)
		If dbSeek(xFilial()+cDebito)
			If ExistCpoCt1(cMoeda, "CT1_CVD", .F., lHelp)
				aPeriodos	:= CtbPeriodos(cMoeda,dData,dData,.F.,.F.) 														
				If !Empty(aPeriodos[1][1])                       				
					If aPeriodos[1][4] $ "1"	//Se o calendario estiver aberto				
						cCriter 	:= &("CT1->CT1_CVD"+cMoeda)
						If lDtTxUso .And. cCriter == "9"       
							If FunName() == "CTBA370"		//Se for Atualizacao de Moedas
						    	cAliasAnt	:= Alias()
						    	nRecCT2	:= CT2->(Recno())
		    					dbSelectArea("CT2")
						    	dbSetOrder(1)
								If MsSeek(xFilial()+dtos(dData)+cLote+cSubLote+cDoc+cLinha+cTpSald+cEmpOri+cFilOri+cMoeda)			                              
									aCols[nCont][5]	:= CT2->CT2_DATATX
								EndIf			                               
		    					dbGoto(nRecCT2)
					    		dbSelectArea(cAliasAnt)
			    			EndIf
						   	nValConv 	:= CtbConv(&("CT1->CT1_CVD"+cMoeda),aCols[nCont][5],cMoeda,nValor,;
							   						.T., aCols[nCont][4])
						Else						
						   	nValConv 	:= CtbConv(&("CT1->CT1_CVD"+cMoeda),dData,cMoeda,nValor,;
							   						.T., aCols[nCont][4])                            
						EndIf	
					Else
						cCriter		:= "5"					
						nValConv	:= 0.00						
					EndIf                                             
				Else 
					cCriter		:= "5"
					nValConv 	:= 0.00															
				EndIf
			EndIf
		EndIf	
	ElseIf  ! lCrtLct .And. (cTipo == "2")					// Utilizar criterio da Conta Credito
		dbSelectArea("CT1")
		dbSetOrder(1)
		If dbSeek(xFilial()+cCredito)
			If ExistCpoCt1(cMoeda, "CT1_CVC", .F., lHelp)
				aPeriodos	:= CtbPeriodos(cMoeda,dData,dData,.F.,.F.) 														
				If !Empty(aPeriodos[1][1])                       							
					If aPeriodos[1][4] $ "1"
						cCriter 	:= &("CT1->CT1_CVC"+cMoeda)
						If lDtTxUso .And. cCriter == "9"
							If FunName() == "CTBA370"		//Se for Atualizacao de Moedas
						    	cAliasAnt	:= Alias()
						    	nRecCT2	:= CT2->(Recno())
		    					dbSelectArea("CT2")
						    	dbSetOrder(1)
								If MsSeek(xFilial()+dtos(dData)+cLote+cSubLote+cDoc+cLinha+cTpSald+cEmpOri+cFilOri+cMoeda)			                              
									aCols[nCont][5]	:=  CT2->CT2_DATATX
								EndIf			                               
		    					dbGoto(nRecCT2)
					    		dbSelectArea(cAliasAnt)
			    			EndIf						
							nValConv 	:= CtbConv(&("CT1->CT1_CVC"+cMoeda),aCols[nCont][5],cMoeda,nValor,;
						   						.T., aCols[nCont][4])						
						Else						
							nValConv 	:= CtbConv(&("CT1->CT1_CVC"+cMoeda),dData,cMoeda,nValor,;
						   						.T., aCols[nCont][4])
						EndIf
					Else
						cCriter		:= "5"
						nValConv 	:= 0.00						
					EndIf
				Else 
					cCriter		:= "5"
					nValConv 	:= 0.00										
				EndIf
			EndIf
		EndIf	
	Else
		If cCritLct <> Nil
			cCriter	:= Subs(cCritLct, nCont - 1, 1)
		Else
			nValConv 	:= 0
			nOrder  	:= CT2->(IndexOrd())
			nRecno  	:= CT2->(Recno())
			cCriter		:= "1"

			For nQuantas := 1 To __nQuantas

				cVerMoeda := StrZero(nQuantas,2)
				//A moeda 01 nao sera mostrada na tela de conversao
				If cVerMoeda = '01'
					Loop
				EndIf

				dbSelectarea("CT2")
				dbSetOrder(1)
				nRegCT2		:= Recno()
				dData		:= CT2->CT2_DATA
				cLote		:= CT2->CT2_LOTE
				cSubLote    := CT2->CT2_SBLOTE
				cDoc		:= CT2->CT2_DOC
				cTpSald		:= CT2->CT2_TPSALD
				cLin		:= CT2->CT2_LINHA
				cEmpOri		:= CT2->CT2_EMPORI
				cFilOri		:= CT2->CT2_FILORI
				If MsSeek(xFilial()+dtos(dData)+cLote+cSubLote+cDoc+cLin+cTpSald+cEmpOri+cFilOri+cVerMoeda)
					cCriter += If(Empty(CT2->CT2_CRCONV), "1", CT2->CT2_CRCONV)
					If FunName() == "CTBA370" .And. lDtTxUso .And. CT2->CT2_CRCONV == "9"
						dDataTx	:= CT2->CT2_DATATX
					EndIf					
				Else	//Se nao achou, traz como moeda nao convertida (5)
					cCriter += "5"				
				EndIf
				If CT2_CRCONV = "4" .And. CT2->CT2_MOEDLC = cMoeda
					nValConv := CT2->CT2_VALOR
				Endif
	
				dbGoto(nRegCT2)
			Next nCont
			CT2->(DbSetOrder(nOrder))
			CT2->(DbGoto(nRecno))
		Endif
		If nValConv = 0
			cCriter	:= Subs(cCriter,Val(cMoeda),1)
			If FunName() == "CTBA370" .And. lDtTxUso .And. cCriter == "9"
				nValConv := CtbConv(cCriter,dDatatx,cMoeda,nValor,.T., aCols[nCont][4])						
			Else			
				nValConv := CtbConv(cCriter,dData,cMoeda,nValor,.T., aCols[nCont][4])			
			EndIf
		Endif
	EndIf	

    cCriter			:= If(Empty(cCriter), "1", cCriter)
	aCols[nCont][2]	:= cCriter

	If lCT101CNV   
		nValConv := ExecBlock("CT101CNV",.F.,.F.,{nValor,cMoeda,cCriter,cDebito,cCredito,nValConv})
	EndIf

	aCols[nCont][3]	:= nValConv
	If lDtTxUso          
		If nPos_ALI_WT > 0
			aCols[nCont][8]	:= .F.
		Else
			aCols[nCont][6]	:= .F.
		EndIf	
	Else		
		If nPos_ALI_WT > 0
			aCols[nCont][7]	:= .F.
		Else
			aCols[nCont][5]	:= .F.
		EndIf
	EndIf
	If nPos_ALI_WT > 0
		aCols[nCont, nPos_ALI_WT] := "CT2"
		aCols[nCont, nPos_REC_WT] := CT2->(Recno())
	EndIf
Next	

If nPosValor > 0
	// Valida se nenhuma moeda ou conversão ultrapassou o limite da representacao numerica do campo
	For nCont := 1 to Len(aCols)
		If Int(aCols[nCont][nPosValor]) > nVlMax
			lRet := .F.	
			Help("CTBA101ERC",1,"HELP","CT101MAXVAL",STR0077 ,1,0) //"A conversão da moeda implicará em valor fora da faixa de representação numérica."
			Exit
		EndIf
	Next nCont
EndIf

RestArea(aSaveArea)

If oGet != Nil
	oGet:oBrowse:Refresh()
EndIf	

Return  lRet

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Program   ³Ctba101OK ³ Autor ³ Pilar S. Albaladejo   ³ Data ³ 24.07.00 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Valida Folder de Lancamento Contabil                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³Ctba101Ok(cTipo,cMoeda,cDebito,cCredito,cCustoDeb,cCustoCrd,³±±
±±³          ³cItemDeb,cItemCrd,cClVLDeb,cClVLCrd,nValor,cTexto,cTpSald,  ³±±
±±³          ³nOpc,oMemo2,oMemo1,cTipoHist)                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ .T. / .F.                                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Generico                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpC1 = Tipo do Lancamento Contabil                        ³±±
±±³          ³ ExpC2 = Moeda do lancamento Contabil                       ³±±
±±³          ³ ExpC3 = Conta debito                                       ³±±
±±³          ³ ExpC4 = Conta Credito                                      ³±±
±±³          ³ ExpC5 = C Custo Debito                                     ³±±
±±³          ³ ExpC6 = C Custo Credito                                    ³±±
±±³          ³ ExpC7 = Item Debito                                        ³±±
±±³          ³ ExpC8 = Item Credito                                       ³±±
±±³          ³ ExpC9 = Classe de Valor Debito                             ³±±
±±³          ³ ExpC10= Classe de Valor Credito                            ³±±
±±³          ³ ExpC11= Conteudo do Historico                              ³±±
±±³          ³ ExpC12= Tipo do Saldo                                      ³±±
±±³          ³ ExpN2 = Numero da opcao escolhida                          ³±±
±±³          ³ ExpO1 = Objeto Memo                                        ³±±
±±³          ³ ExpO2 = Objeto Memo                                        ³±±
±±³          ³ ExpC13= Tipo do Historico inteligente                      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function Ctba101OK(cTipo,cMoeda,cDebito,cCredito,cCustoDeb,cCustoCrd,cItemDeb,cItemCrd,;
				cClVLDeb,cClVLCrd,nValor,cTexto,cTpSald,nOpc,oMemo2,oMemo1,cTipoHist,dData,;
				cLote,cSubLote,cDoc,cDCD,cDCC,nRegCT2M01,cEmpOri,cFilOri,cLinha)

Local aSaveArea := GetArea()
Local lRet		:= .T.
Local lCt101TOK	:= IIf( ExistBlock("CT101TOK"),.T.,.F. )
Local nCols
Local lSeqCorr  := .F. 
Local lCT101VLENT := ExistBlock("CT101VLENT") //P.E. para validacao das ent. contabeis na gravacao
Local lVAt := FindFunction("CTBValidAt")

//ARRAY PASSADO PARA FUNÇÃO CTBVALIDAT
Private aAtivCT1:={}
Private aAtivCTD:={}
Private aAtivCTH:={}
Private aAtivCTT:={}

DEFAULT nRegCT2M01	:= 0
DEFAULT cEmpOri		:= cEmpAnt
DEFAULT cFilOri		:= cFilAnt
DEFAULT cLinha		:= "001"

lSeqCorr  := ( FindFunction( "UsaSeqCor" ) .And. UsaSeqCor() )

If lCt101TOK
	lRet := ExecBlock( "CT101TOK" , .F. , .F. , {cTipo,cDebito,cCredito,cCustoDeb,cCustoCrd,cItemDeb,cItemCrd,cClVlDeb,cClVlCrd,cTpSald,nOpc,@cTexto } )
Endif
                                                  
If lRet
	If Empty(cTpSald)
		Help(" ",1,"NOTpSald")
		lRet := .F.
	EndIf	
EndIf	

If lRet
	If Empty(cTipo)
		Help(" ",1,"NOTIPO")
		lRet := .F.
	EndIf
EndIf

If lRet
	If Empty(cMoeda)
		Help(" ",1,"NOMOEDA")
		lRet := .f.
	EndIf	
EndIf

If lRet
	If cTipo == "1" .Or. cTipo == "3"
		If Empty(cDebito)
			Help(" ",1,"NOCONTAC")
			lRet := .F.
		EndIf     
		
		//Se o campo  digito de controle estiver em uso, faz a verificacao. 
		If lRet
			If CtbUso("CT2_DCD")
				If Empty(cDCD) 
					Help( " ", 1, "DIG-DEBITO" )
					lRet := .F.
				Else
					dbSelectArea("CT1")
					dbSetOrder(1)
					If MsSeek(xFilial()+cDebito) .And. cDCD != CT1->CT1_DC
						Help( " ", 1, "DIGITO" )
						lRet := .F.
					EndIf
				Endif			
  			EndIf			
		EndIf		
		
		// Valida Entidades Obrigatorias -> Ligacao entre Conta e demais entidades
		If lRet
		    If lVAt
		       CTBValidAt("DB",1)
		    Endif   
			If cPaisLoc $"PER#COL"
				lRet := CtbObrig(	cDebito,;
									cCustoDeb,;
									cItemDeb,;
									cCLVLDeb,;
									.T.,;
									"1",,;
									M->CT2_EC05DB,;
							   		"",;
									IIf( CT2->( FieldPos( "CT2_EC05DB" ) ) > 0, M->CT2_EC05DB, NIL ),;
									IIf( CT2->( FieldPos( "CT2_EC06DB" ) ) > 0, M->CT2_EC06DB, NIL ),;
									IIf( CT2->( FieldPos( "CT2_EC07DB" ) ) > 0, M->CT2_EC07DB, NIL ),;
									IIf( CT2->( FieldPos( "CT2_EC08DB" ) ) > 0, M->CT2_EC08DB, NIL ),;
									IIf( CT2->( FieldPos( "CT2_EC09DB" ) ) > 0, M->CT2_EC09DB, NIL ),,,;
									aAtivCT1, aAtivCTD, aAtivCTH, aAtivCTT )
			Else
				lRet := CtbObrig(	cDebito,;
									cCustoDeb,;
									cItemDeb,;
									cCLVLDeb,;
									.T.,;
									"1",,,;
							   		"",;
									IIf( CT2->( FieldPos( "CT2_EC05DB" ) ) > 0, M->CT2_EC05DB, NIL ),;
									IIf( CT2->( FieldPos( "CT2_EC06DB" ) ) > 0, M->CT2_EC06DB, NIL ),;
									IIf( CT2->( FieldPos( "CT2_EC07DB" ) ) > 0, M->CT2_EC07DB, NIL ),;
									IIf( CT2->( FieldPos( "CT2_EC08DB" ) ) > 0, M->CT2_EC08DB, NIL ),;
									IIf( CT2->( FieldPos( "CT2_EC09DB" ) ) > 0, M->CT2_EC09DB, NIL ),,,;
									aAtivCT1, aAtivCTD, aAtivCTH, aAtivCTT )
				
			Endif
		EndIf	
	Endif
	If cTipo == "2" .Or. cTipo == "3"
		If Empty(cCredito)
			Help(" ",1,"NOCONTAC")
			lRet := .F.
		EndIf          
		
		//Se o campo  digito de controle estiver em uso, faz a verificacao. 
		If lRet
			If CtbUso("CT2_DCC")
				If Empty(cDCC) 
					Help( " ", 1, "DIG-CREDIT" )
					lRet := .F.
				Else
					dbSelectArea("CT1")
					dbSetOrder(1)
					If MsSeek(xFilial()+cCredito) .And. cDCC != CT1->CT1_DC
						Help( " ", 1, "DIGITO" )
						lRet := .F.
					EndIf
				Endif			
  			EndIf			
		EndIf				

		
		// Valida Entidades Obrigatorias -> Ligacao entre Conta e demais entidades
		If lRet
		    If lVAt
		       CTBValidAt("CR",1)
		    Endif   
			If cPaisLoc $"PER#COL"
		   		lRet := CtbObrig(	cCredito,;
							   		cCustoCrd,;
							   		cItemCrd,;
							   		cCLVLCrd,;
							   		.T.,;
							   		"2",,;
							   		M->CT2_EC05CR,;
							   		"",;
									IIf( CT2->( FieldPos( "CT2_EC05CR" ) ) > 0, M->CT2_EC05CR, NIL ),;
									IIf( CT2->( FieldPos( "CT2_EC06CR" ) ) > 0, M->CT2_EC06CR, NIL ),;
									IIf( CT2->( FieldPos( "CT2_EC07CR" ) ) > 0, M->CT2_EC07CR, NIL ),;
									IIf( CT2->( FieldPos( "CT2_EC08CR" ) ) > 0, M->CT2_EC08CR, NIL ),;
									IIf( CT2->( FieldPos( "CT2_EC09CR" ) ) > 0, M->CT2_EC09CR, NIL ),,,;
									aAtivCT1, aAtivCTD, aAtivCTH, aAtivCTT )
		    Else
		    	lRet := CtbObrig(	cCredito,;
							    	cCustoCrd,;
							    	cItemCrd,;
							    	cCLVLCrd,;
							    	.T.,;
							    	"2",,;
									IIf( CT2->( FieldPos( "CT2_EC05DB" ) ) > 0, M->CT2_EC05DB, NIL ),;
							   		"",;
									IIf( CT2->( FieldPos( "CT2_EC05CR" ) ) > 0, M->CT2_EC05CR, NIL ),;
									IIf( CT2->( FieldPos( "CT2_EC06CR" ) ) > 0, M->CT2_EC06CR, NIL ),;
									IIf( CT2->( FieldPos( "CT2_EC07CR" ) ) > 0, M->CT2_EC07CR, NIL ),;
									IIf( CT2->( FieldPos( "CT2_EC08CR" ) ) > 0, M->CT2_EC08CR, NIL ),;
									IIf( CT2->( FieldPos( "CT2_EC09CR" ) ) > 0, M->CT2_EC09CR, NIL ),,,;
									aAtivCT1, aAtivCTD, aAtivCTH, aAtivCTT )
		    Endif
		EndIf	
	EndIf	
EndIf

// P.E. para validacao das entidades contabeis 
If lCT101VLENT
	lRet := ExecBlock("CT101VLENT",.F.,.F.,{cTipo,cDebito,cCredito, cCustoDeb,cCustoCrd, cItemDeb,cItemCrd, cCLVLDeb,cCLVLCrd})

	If !lRet
		Help(" ",1,"CTAEQUA123")
	Endif
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Validar Lancamentos com Contas Credito/Debito Iguais                                ³
//ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If lRet 
 	
	If (cDebito == cCredito) .And. cTipo == "3"
		If __lCusto .And. __lItem .And. __lCLVL
			If (cCustoDeb == cCustoCrd) .And. (cItemDeb == cItemCrd) .And. ;
				(cCLVLDeb == cCLVLCrd)
				Help(" ",1,"CTAEQUA123")
				lRet := .F.
			EndIf	       			
		ElseIf (__lCusto .And. __lItem) 
			If (cCustoDeb == cCustoCrd) .And. (cItemDeb == cItemCrd)
				Help(" ",1,"CTAEQUA123")			
				lRet := .F.
			EndIf			
		ElseIf (__lCusto .And. __lCLVL) 
			If (cCustoDeb == cCustoCrd) .And. (cCLVLDeb == cCLVLCrd)
				Help(" ",1,"CTAEQUA123")			
				lRet := .F.
			EndIf			
		ElseIf ( __lItem .And. __lCLVL) 
			If (cItemDeb == cItemCrd) .And. (cCLVLDeb == cCLVLCrd)
				Help(" ",1,"CTAEQUA123")			
				lRet := .F.
			EndIf			
		ElseIf __lCusto
			If (cCustoDeb == cCustoCrd)
				Help(" ",1,"CTAEQUA123")
			EndIf	
		ElseIf __lItem
			If (cItemDeb == cItemCrd)
				Help(" ",1,"CTAEQUA123")
			EndIf	
		ElseIf __lCLVL
			If (cCLVLDeb == cCLVLCrd)
				Help(" ",1,"CTAEQUA123")
			EndIf				
		EndIf
	EndIf
EndIf

If lRet
	// Valida Debito
	If cTipo == "1"
		If !Empty(cDebito) .And. (Empty(cCustoDeb) .And. !Empty(cCustoCrd))
			Help(" ",1,"NOCTADEB")
			lRet := .F.
		EndIf	
		If lRet
			If !Empty(cDebito) .And. (Empty(cItemDeb) .And. !Empty(cItemCrd))
				Help(" ",1,"NOCTADEB")
				lRet := .F.
			EndIf	
		EndIf	
		If lRet
			If !Empty(cDebito) .And. (Empty(cClVlDeb) .And. !Empty(cClVlCrd))
				Help(" ",1,"NOCTADEB")			
				lRet := .F.
			EndIf	
		EndIf			
		
		// Valida Amarracoes		
		If lRet
			lRet := CtbAmarr1(.T.) //esta funcao chama CtbAmarra() esta no fonte ctba105
		EndIf	
	
	EndIf
	
	// Valida credito
	If cTipo == "2"
		If !Empty(cCredito) .And. (Empty(cCustoCrd) .And. !Empty(cCustoDeb))
			Help(" ",1,"NOCTACRD")
			lRet := .F.
		EndIf	
		If lRet
			If !Empty(cCredito) .And. (Empty(cItemCrd) .And. !Empty(cItemDeb))
				Help(" ",1,"NOCTACRD")
				lRet := .F.
			EndIf	
		EndIf	
		If lRet
			If !Empty(cCredito) .And. (Empty(cClVlCrd) .And. !Empty(cClVlDeb))
				Help(" ",1,"NOCTACRD")			
				lRet := .F.
			EndIf	
		EndIf	
		
		// Valida Amarracoes		
		If lRet
			lRet := CtbAmarr1(.F.) //esta funcao chama CtbAmarra() esta no fonte ctba105
		EndIf	
	
	EndIf
	
EndIf
	
If lRet
	lRet := .F.
	For nCols := 1 To Len(aCols)
		If aCols[nCols][3] > 0
			lRet := .T.
			Exit
		Endif
	Next
	
	If ! lRet .And. nValor == 0
		Help(" ",1,"NOVALOR")
		lRet := .f.
	Else
		lRet := .T.
	EndIf
EndIf	

If lRet
	If Empty(cTexto) .OR. Empty( StrTran(StrTran(Alltrim(cTexto), CHR(10), ""), CHR(13), "") )
		Help(" ",1,"NOHIST")
		lRet := .F.
	EndIf
EndIf	                         

If nOpc == 3 .Or. nOpc == 4
	If lRet .And. cTpSald != D_PRELAN			// No Pre-Lancamento nao precisa verificar
		//If mv_par03 == 1			//Se verifico lancamentos tipo 1 ou 2 
			//Exibe a mensagem e nao deixa confirmar. 
			If cTipo == "1" .Or. cTipo == "2"
				Help("DEBITO/CREDITO",1,"ATENÇÃO","DEBITO/CREDITO","EXISTEM 2 LANCAMENTOS UM DEBITO E OUTRO CREDITO, FAVOR ALTERAR OUTRO TAMBEM.CASO CONTRATIO TERA INCONSISTENCIA SISTEMA" ,1,0) //"D‚bito e Cr‚dito n„o conferem !"
				lRet := .T.//CARLOS
		   //	EndIf	
		EndIf
			
		If lRet
			If GetMv("MV_CONTSB") == "N"			// Documento nao batido -> nao deixa / ou avisa
				lRet :=	Ct101ChDoc(cTipo,dData,cLote,cSubLote,cDoc,cMoeda,cTpSald,nValor)						
				If !lRet
					If GetMv("MV_CONTBAT")	== "S"		// Nao permite inclusao quando DOC nao batido
						Help(" ",1,"DOCNOBAT")
					ElseIf !IsBlind() //emite aviso pra confirmar caso exita deb e credito
						lRet := MsgYesNo(OemToAnsi("CONFIRMA REALMENTE A ALTERAÇÃO?"),OemToAnsi("ATENÇÃO"))   //"D‚bito e Cr‚dito n„o conferem !, Aceita Lan‡amento "###"Aten‡„o"			
					Else
						lRet := .T.
					EndIf
	 			EndIf			
	 		EndIf
	 	EndIf 
	EndIf	
EndIF

If lRet
	If cTipoHist == 'I'
		cTexto := oMemo2:GetText()
	Endif
Endif	
     
//Na exclusao de lancamento contabil, verificar se existe alguma entidade contabil bloqueada. 
If lRet
	If nOpc == 5 .Or. nOpc == 6
		If !CtbVldLP(dDataLanc,cLote,cSubLote,cDoc,nOpc) .Or. ! CtbValiDt(nOpc,dDataLanc,,cTpSald)
			lRet := .F.	
		EndIf
		
		If lRet
			lRet := Ctb101Bloq("","","","","",dData,cTipo,cDebito,cCredito,cCustoDeb,cCustoCrd,cItemDeb,cItemCrd,cCLVLDeb,cCLVLCrd)				
		EndIf
	EndIf
EndIf

//Na copia de lancamento contabil, verificar se existe alguma entidade contabil bloqueada. 
If lRet
	If nOpc == 7  
			lRet := Ctb101Bloq("","","","","",dData,cTipo,cDebito,cCredito,cCustoDeb,cCustoCrd,cItemDeb,cItemCrd,cCLVLDeb,cCLVLCrd)				
	EndIf
EndIf

If lRet
	nLenCols	:= Len(aCols)
	lValidCoin  := .F.

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ ///MSL - 23/10/06
	//³VALIDACAO DE BLOQUEIOS E AMARRAÇÕES (CTG, CTO, CTP). ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ ///MSL - 23/10/06	
	If nOpc == 3 .or. nOpc == 6 .or. nOpc == 7	/// Se for inclusão (estorno ou copia inclusive)
		For nCols := 0 to Len(aCols)	/// Roda todas as moedas
			If nCols == 0 	
				nVlrLan := nValor
				cCoin4  := "01"
			Else
				If nLenCols  < nCols
					Exit
				EndIf
				cCoin4 	:= aCols[nCols][1]
				nVlrLan := aCols[nCols][3]
			EndIf								

			If nVlrLan <> 0 // Se houver valor 
				// Verifica CTO e 			no CTP ausência ou bloqueios.
				If (!CTBMInUse(cCoin4) .Or. !CtbDtInUse(cCoin4,dDataLanc))
					lRet := .F.
					Help( " ", 1, "CT2_VLR"+cCoin4 )
					Exit
				Else	
					// Verifica CTG ausencia ou bloqueio de calendário.
					If !CtbDtComp(3,dDataLanc,cCoin4,,cTpSald) 
						lRet   := .F.
						Exit							
					EnDif
				EndIf						
			EndIf			
		Next			

	ElseIf nOpc == 4	/// Se for alteração

		cKeyLin	:= ""
		For nCols := 0 to Len(aCols)	/// Roda todas as moedas
			If nCols == 0 	
				nVlrLan := nValor
				cCoin4  := "01"
			Else
				If nLenCols  < nCols
					Exit
				EndIf

				cCoin4 	:= aCols[nCols][1]
				nVlrLan := aCols[nCols][3]
			EndIf								

			lValidCoin := .F.
			
			If nCols == 0	// Na moeda 01			

				If nRegCT2M01 > 0	
				
					CT2->(MsGoTo(nRegCT2M01))
					
					If nRegCT2M01 == CT2->(Recno())

						/// Se o lançamento da moeda 01 já existe
						cKeyLin := CT2->(CT2_FILIAL+DTOS(CT2_DATA)+CT2_LOTE+CT2_SBLOTE+CT2_DOC+CT2_LINHA+CT2_TPSALD+CT2_EMPORI+CT2_FILORI)

						If nVlrLan <> CT2->CT2_VALOR // e mudou o valor do lançamento
							lValidCoin := .T.
						EndIf

						If !lValidCoin
							If Len(CtbMudouL( {cTipo,cDebito,cCredito,cCustoDeb,cCustoCrd,cItemDeb,cItemCrd,cClVLDeb,cClVLCrd,cTpSald};
											 ,,CT2->(Recno()) );
								 ) > 0
								lValidCoin := .T.
							EndIf
						EndIf

					Else
						// Se o lançamento da moeda 01 não existe
						If nVlrLan <> 0
							lValidCoin := .T.
						EndIf
					EndIf
				Else	// Se o lançamento da moeda 01 não existe
					If nVlrLan <> 0
						lValidCoin := .T.
					EndIf
				EndIf
			Else		// Nas moedas de conversão 0X
				dbSelectArea("CT2")
				dbSetOrder(1)
				
				If Empty( cKeyLin )
					cKeyLin := xFilial("CT2") + DTOS(dDataLanc) + cLote + cSubLote + cDoc + cLinha + cTpSald + cEmpOri + cFilOri
				EndIf
				
				If DbSeek( cKeyLin + cCoin4 , .F. )
					If nVlrLan <> CT2->CT2_VALOR	
						lValidCoin := .T.
				   	EndIf
				   
					If !lValidCoin
						If Len( CtbMudouL( {cTipo,cDebito,cCredito,cCustoDeb,cCustoCrd,cItemDeb,cItemCrd,cClVLDeb,cClVLCrd,cTpSald};
										 ,,CT2->(Recno()));
							   ) > 0
							lValidCoin := .T.
						EndIf
					EndIf
			   
				Else
					If nVlrLan <> 0
						lValidCoin	:= .T.
					EnDif
				EndIf					
			EndIf

			If lValidCoin
				// Verifica CTO e 			no CTP ausência ou bloqueios.
				If (!CTBMInUse(cCoin4) .Or. !CtbDtInUse(cCoin4,dDataLanc))
					Help( " ", 1, "CT2_VLR"+cCoin4 )
					lRet   := .F.
					Exit
				Else	
					// Verifica CTG ausencia ou bloqueio de calendário.
					If !CtbDtComp(3,dDataLanc,cCoin4,,cTpSald) 
						lRet   := .F.
						Exit							
					EnDif
				EndIf						
			EndIf
		Next			

	ElseIf nOpc == 5	/// Se for Exclusão
		For nCols := 0 to Len(aCols)	/// Roda todas as moedas
			If nCols == 0 	
				nVlrLan := nValor
				cCoin4  := "01"
			Else
				If nLenCols  < nCols
					Exit
				EndIf
				cCoin4 	:= aCols[nCols][1]
				nVlrLan := aCols[nCols][3]
			EndIf								
            
			If nVlrLan <> 0 // Se houver valor 
				// Verifica CTO e 			no CTP ausência ou bloqueios.
				If ( ! CTBMInUse(cCoin4) .Or. ! CtbDtInUse(cCoin4,dDataLanc))
					Help( " ", 1, "CT2_VLR"+cCoin4 )
					lRet   := .F.
					Exit
				Else	
					// Verifica CTG ausencia ou bloqueio de calendário.
					If !CtbDtComp(3,dDataLanc,cCoin4,,cTpSald) 
						lRet   := .F.
						Exit							
					EnDif
				EndIf						
			EndIf
		Next			
	EndIf
EndIf         

If lRet 
	If lSeqCorr
		dbSelectArea( "CT2" )
		dbSetOrder(1)

	    cKeyLin := xFilial( "CT2" ) + DTOS(dDataLanc) + cLote + cSubLote + cDoc + cLinha + cTpSald + cEmpOri + cFilOri

	   	If DbSeek( cKeyLin )
			lRet := CTBVlSeqCr(dDataLanc,.F.,CT2->CT2_TPSALD,CT2->CT2_DIACTB)
			If !lRet
				Help(" ",1,"CORRNOEXC")
			EndIf 
	    EndIf   
	Endif
EndIf	

RestArea(aSaveArea)

Return lRet

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Program   ³Ctb101LiOK³ Autor ³ Pilar S. Albaladejo   ³ Data ³ 24.07.00 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Valida linha da getdados de conversao de Moedas            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ Ctb101LiOk()                                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ .T. / .F.                                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Generico                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ Nenhum                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function Ctb101LiOK()

Local aSaveArea := GetArea()
Local lRet		:= .T.
Local nCont		:= 0 
Local lDtTxUso	:= .F.
Local aCntCVO	:= {}
Local nOpc192	:= 0

For nCont	:= 2 to __nQuantas
	If CtbUso("CT2_DTTX"+StrZero(nCont,2))			
		lDtTxUso		:= .T.
		Exit		
	EndIf
Next   
                      
If lDtTxUso
	If !aCols[n][len(aCols[n])] .And. (! Empty(aCols[n][1]) .And.;
							aCols[n][1] <> "01") 	// Somente caso a moeda estiver preenchida
		If Empty(aCols[n][2]) .And. __nValor > 0	// Acima da moeda 01
			Help(" ",1,"NOCRITER")
			lRet := .F.
		EndIf	
		If lRet  
			If aCols[n][2] <> '5' 	
				If Empty(aCols[n][3]) .And. __nValor > 0
					Help(" ",1,"NOVALOR")
					lRet := .F.
				EndIf
			EndIf
		EndIf	
	EndIf	
Else                      
	If !aCols[n][len(aCols[n])] .And. (! Empty(aCols[n][1]) .And.;
							aCols[n][1] <> "01") 	// Somente caso a moeda estiver preenchida
		If Empty(aCols[n][2]) .And. __nValor > 0	// Acima da moeda 01
			Help(" ",1,"NOCRITER")
			lRet := .F.
		EndIf	
		If lRet  
			If aCols[n][2] <> '5' 	
				If Empty(aCols[n][3]) .And. __nValor > 0
					Help(" ",1,"NOVALOR")
					lRet := .F.
				EndIf
			EndIf
		EndIf	
	EndIf	
EndIf

If lRet	.And. IsCtbJob()
	//Na alteracao, se esta lockado e nao pelos jobs de atualizacao, nao eh permitido alterar nem excluir lancamentos
	aCntCVO := CVORecs( xFilial( "CVO" ) )
	If FindFunction( "CTBA192IsOn" ) .And. CTBA192IsOn( cEmpAnt ) .AND. aCntCVO[1] > 0
		If nOPC == 4 .Or. nOPC == 5
			If lConfirma
				Help(" ",1,"DOCNAOATU2")		
			Endif
			lRet := .F.                
		ElseIf nOPC == 3 .Or. nOPC == 6 .Or. nOPC == 7     
			nOpc192	:=	GetNewPar("MV_CTB102I",1) //1=Nao Grava ;2=Grava como PRE;3=Pergunta
			If nOpc192 == 1
				If lConfirma
					Help(" ",1,"DOCNAOATU3")		
				Endif
				lRet	:=	.F.
			ElseIf nOpc192 == 2
				lRet	:=	.T.					
			Else
				lRet	:=	MsgYesNo( STR0060, STR0059 )
			Endif
		Endif	                            
	Endif	
Endif
RestArea(aSaveArea)

Return lRet

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Program   ³Ctb101TOK ³ Autor ³ Pilar S. Albaladejo   ³ Data ³ 24.07.00 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Valida toda getdados de conversao de Moedas                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³Ctb101TOk()                                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ .T. / .F.                                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³Generico                                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ Nenhum                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function Ctb101TOK()

Local aSaveArea	:= GetArea()
Local lRet		:= .T.
Local nCont

For nCont := 1 To Len(aCols)
	If !Ctb101LiOk()
		lRet := .F.
	EndIf
Next nCont		

RestArea(aSaveArea)

Return lRet

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Program   ³Ctb101Val ³ Autor ³ Pilar S. Albaladejo   ³ Data ³ 24.07.00 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Valida valor do Lancamento Contabil                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ Ctb101Val(nValor)                                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ .T. / .F.                                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Generico                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpN1 = Valor do Lancamento Contabil                       ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function Ctb101Val(nValor)

Local aSaveArea := GetArea()
Local lRet		:= .T.

If Empty(nValor) .Or. nValor == 0
	Help(" ",1,"NOVALOR")
	lRet := .F.
EndIf	       

If lRet
	If nValor < 0
		Help(" ",1,"VALNEG")
		lRet := .F.
	EndIf
EndIF		

__nValor := nValor

RestArea(aSaveArea)

Return lRet

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Program   ³Ctb101Crit³ Autor ³ Pilar S. Albaladejo   ³ Data ³ 24.07.00 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Converte valor da getdados a partir do combo de criterio   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³Ctb101Crit()                                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ .T.                                                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³Generico                                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ Nenhum                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function Ctb101Crit()

Local aSaveArea := GetArea()
Local lRet		:= .T.
Local cCriter	:= &(ReadVar())
Local cMoeda	:= aCols[n][1]
Local nCols        
Local nCont		:= 0
Local lDtTxUso	:= .F.


For nCont	:= 2 to __nQuantas
	If CtbUso("CT2_DTTX"+StrZero(nCont,2))			
		lDtTxUso		:= .T.
		Exit		
	EndIf
Next   

If lNEntBloq
	//Verificar se existe amarracao moeda x calendario 
	If cCriter <> "5"
		If !Empty(dDataLanc)
			lRet := CtbDtComp(4,dDataLanc,cMoeda,.T.,M->CT2_TPSALD)				
		Endif
	EndIf									
	
	If lRet
		If lDtTxUso .And. cCriter == "9"
			aCols[n][3] := CtbConv(cCriter,aCols[n][5],cMoeda,__nValor,.T., aCols[n][4])	
		Else
			aCols[n][3] := CtbConv(cCriter,__dData,cMoeda,__nValor,.T., aCols[n][4])
		EndIf
	EndIf
	If cCriter $ "A/6/3"
		aCols[n][3] := CtbConv(cCriter,__dData,cMoeda,__nValor,.T., aCols[n][4])
	Endif
	M->CT2_MCONVER := "1"
	For nCols := 1 To Len(aCols)
		If nCols = N
			M->CT2_MCONVER += cCriter
		Else
			M->CT2_MCONVER += aCols[nCols][1]
		Endif
	Next
Else
	lRet	:= .F.
	Help(" ",1,"CTA_DTBLOQ")	
EndIf
           
RestArea(aSaveArea)

Return lRet

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Program   ³Ctb101VLC ³ Autor ³ Pilar S. Albaladejo   ³ Data ³ 24.07.00 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Valida Digitacao do Vlr Conv (Somente Criterio I)          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³Ctb101VlC()                                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ .T. / .F.                                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³Generico                                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ Nenhum                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function CTB101VLC()

Local lRet 		:= .T.
Local aSaveArea := GetArea()

// Bops 14876
                            
If lNEntBloq	//Se não tiver nenhuma entidade bloqueada. 
	If M->CT2_VALOR < 0 
		Help(" ",1,"POSIT")	
		lRet := .F.
	Endif

	If __nValor > 0 .And. aCols[n][2] != "4" .AND. aCols[n][2] != "A"	// Se não for informado, não pode alterar o valor
		Help(" ",1,"NOCONV")
		lRet := .F.
	EndIf
Else
	lRet	:= .F.
	Help(" ",1,"CTA_DTBLOQ")	
EndIf


RestArea(aSaveArea)

Return lRet

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Program   ³Ct101Outr ³ Autor ³ Pilar S. Albaladejo   ³ Data ³ 24.07.00 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Carrega matriz com campos de usuario que serao alterados   ³±±
±±³          ³ a partir da enchoice (folder outras informacoes)           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ Ct101Outr(aOutros)                                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ Matriz com outras informacoes                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³Generico                                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpA1 = Matriz com campos para outras informacoes          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function Ct101Outr(aOutros)

Local aSaveArea:= GetArea()
Local aCampos	:= {}
Local aFora		:= {	"CT2_CALEND","CT2_DATA","CT2_LOTE","CT2_SBLOTE", "CT2_DOC",;
						"CT2_LINHA","CT2_DC","CT2_CREDIT","CT2_DEBITO","CT2_CCC",;
						"CT2_CCD","CT2_ITEMD","CT2_ITEMC","CT2_CLVLDB",;
						"CT2_CLVLCR","CT2_MOEDAS","CT2_HP","CT2_HIST",;
						"CT2_VLR01","CT2_CRITER","CT2_AGLUT","CT2_MOEDLC",;
						"CT2_TPSALD","CT2_VALOR","CT2_CRCONV","CT2_CONVER",;
						"CT2_DCD","CT2_DCC"}
Local nCont		:= 0 
dbSelectarea("CT2")
AADD(aFora,"CT2_DTLP")
                    
//Se tiver menos de 5 moedas cadastradas, ira adicionar a matriz aFora os campos CT2_DTTX das 5
//moedas padroes.
If __nQuantas <= 5	
	For nCont	:= 2 to 5
		If CtbUso("CT2_DTTX"+StrZero(nCont,2))
			AADD(aFora,"CT2_DTTX"+StrZero(nCont,2))	
		EndIf	
	Next
Else
	For nCont	:= 2 to __nQuantas
		If CtbUso("CT2_DTTX"+StrZero(nCont,2))
			AADD(aFora,"CT2_DTTX"+StrZero(nCont,2))	
		EndIf	
	Next
EndIf

dbSelectArea("SX3")
dbSeek("CT2")

aOutros := {}
While !Eof() .And. (X3_ARQUIVO == "CT2")
	If X3USO(X3_USADO) .and. cNivel >= X3_NIVEL
		If Ascan(aFora,Trim(X3_CAMPO)) <= 0 .And.;
			(Substr(Trim(X3_CAMPO),1,7) != "CT2_VLR" .And. ;
			 Substr(Trim(X3_CAMPO),1,8) != "CT2_VALR")			
			Aadd(aCampos,Trim(X3_CAMPO))
		End			
	End		
   dbSkip()
End

RestArea(aSaveArea)

//AADD(aOutros,aCampos)
aOutros 	:= aClone(aCampos)		   			

Return aOutros

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³Ct_EntraEn³ Autor ³ Pilar S. Albaladejo   ³ Data ³ 24.07.00 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Grava variaveis de ambiente na entrada da enchoice		  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ Ct_EntraEnc()                                     		  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ Nenhum								                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Generico  ³ Generico								                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ Nenhum                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function Ct_EntraEnc()
aTela := AClone(aSvAtela)
aGets := AClone(aSvaGets)
dbSelectArea(cAlias)

Return  

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Program   ³Ct_SaiEnc ³ Autor ³ Pilar S. Albaladejo   ³ Data ³ 24.07.00 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Restaura variaveis de ambiente na saida da enchoice		  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³Ct_SaiEnc()							                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ Nenhum								                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Generico								                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ Nenhum                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function Ct_Saienc()
aSvATela	:= aClone(aTela)
aSvAGets	:= aClone(aGets)
return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Program   ³CarregaCT2³ Autor ³ Pilar S. Albaladejo   ³ Data ³ 24.07.00 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Carrega valores do Folder de Lancamentos Contabeis         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³CarregaCT2(Opc,cTexto,cTipo,cDebito,cCredito,cCustoDeb,     ³±±
±±³			 ³ cCustoCrd,cItemDeb,cItemCrd,cCLVLDeb,cCLVLCrd,cMoeda,	  ³±±
±±³			 ³ cHistPad,nValor,dData,cLote,cSubLote,cDoc,cLinha,cTpSald,  ³±±
±±³			 ³ aTipos,aTpSald,aTabela,oTabela,cSeqLan,cDescDeb,cDescCrd,  ³±±
±±³			 ³ oLinha,cSayCusto,cSayItem,cSayCLVL,cDescCCC,cDescCCd,      ³±±
±±³			 ³ cDescItc,cDescItd,cDescCvd,cDescCvc			 			  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ Nenhum                                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpN1 = Opcao do menu (Inclusao / Alteracao / Exclusao)    ³±±
±±³          ³ ExpC1 = Historico Contabil                                 ³±±
±±³          ³ ExpC2 = Tipo do Lancamento Contabil                        ³±±
±±³          ³ ExpC3 = Conta Debito                                       ³±±
±±³          ³ ExpC4 = Conta Credito                                      ³±±
±±³          ³ ExpC5 = C Custo Debito                                     ³±±
±±³          ³ ExpC6 = C Custo Credito                                    ³±±
±±³          ³ ExpC7 = Item Debito                                        ³±±
±±³          ³ ExpC8 = Item Credito                                       ³±±
±±³          ³ ExpC9 = Classe de Valor Debito                             ³±±
±±³          ³ ExpC10= Classe de Valor Credito                            ³±±
±±³          ³ ExpC11= Moeda do Lancamento Contabil                       ³±±
±±³          ³ ExpC12= Historico Padrao                                   ³±±
±±³          ³ ExpN2 = Valor do Lancamento Contabil                       ³±±
±±³          ³ ExpD1 = Data do Lancamento Contabil                        ³±±
±±³          ³ ExpC13= Lote Contabil                                      ³±±
±±³          ³ ExpC14= Sub-Lote Contabil                                  ³±±
±±³          ³ ExpC15= Documento Contabil                                 ³±±
±±³          ³ ExpC16= Linha do Lancamento                                ³±±
±±³          ³ ExpC17= Tipo saldo                                         ³±±
±±³          ³ ExpA1 = Matriz com tipos de lancamento                     ³±±
±±³          ³ ExpA2 = Matriz com Tipo do saldo                           ³±±
±±³          ³ ExpA3 = Matriz com valores de saldos                       ³±±
±±³          ³ ExpO1 = Objeto Tabela de saldos                            ³±±
±±³          ³ ExpC18= Sequencia do Lancamento contabil                   ³±±
±±³          ³ ExpC19= Descricao da conta debito  			              ³±±
±±³          ³ ExpC20= Descricao da conta credito           		      ³±±
±±³          ³ ExpO3 = Objeto da Linha do lancamento                      ³±±
±±³          ³ ExpC21= Descricao do C.Custo utilizada pelo usuario.       ³±±
±±³          ³ ExpC22= Descricao do Item utilizada pelo usuario.          ³±±
±±³          ³ ExpC23= Descricao da Classe de valor utilizada pelo usuario³±±
±±³          ³ ExpC24= Descricao do Centro de custo credito               ³±±
±±³          ³ ExpC25= Descricao do Centro de custo debito                ³±±
±±³          ³ ExpC26= Descricao do Item credito                          ³±±
±±³          ³ ExpC27= Descricao do Item debito                           ³±±
±±³          ³ ExpC28= Descricao da Classe de valor Debito                ³±±
±±³          ³ ExpC29= Descricao do Centro de valor credito               ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function CarregaCt2(nOpc,cTexto,cTipo,cDebito,cCredito,cCustoDeb,;
					cCustoCrd,cItemDeb,cItemCrd,cCLVLDeb,cCLVLCrd,;
					cMoeda,cHistPad,nValor,dData,cLote,cSubLote,cDoc,cLinha,;
					cTpSald,aTipos,aTpSald,aTabela,oTabela,cSeqLan,;
					cDescDeb,cDescCrd,oLinha,cSayCusto,cSayItem,cSayCLVL,;
					cDescCCC,cDescCCd,cDescItc,cDescItd,cDescCvd,cDescCvc,;
					cEmpOri,cFilOri,cDCD,cDCC,nRegCT2M01, aNovasEnt )
					
Local aSaveArea := GetArea()
Local nReg
Local dEstData	:= CTOD("  /  /  ")
Local cEstLote	:= ""
Local cEstSbLote:= ""
Local cEstDoc	:= ""
Local cEstLinha	:= ""              
Local cEstEmpOri:= ""
Local cEstFilOri:= ""
Local cEstTpSald:= ""
Local cEstSeqLan:= ""

Local dCpyDt	:= CT2->CT2_DATA
Local cCpyLote	:= CT2->CT2_LOTE
Local cCpySLote:= CT2->CT2_SBLOTE
Local cCpyDoc	:= CT2->CT2_DOC
Local cCpySeq	:= CT2->CT2_SEQLAN
Local	cCpySld	:= CT2->CT2_TPSALD
Local	cCpyEmp	:= CT2->CT2_EMPORI
Local	cCpyFil	:= CT2->CT2_FILORI
Local lSeqCorr	:= .F.
Local nX		:= 0

DEFAULT nRegCT2M01	:= 0
Default aNovasEnt	:= {}

//****************************
// Controle do Correlativo   *
//****************************
lSeqCorr  := ( FindFunction( "UsaSeqCor" ) .And. UsaSeqCor() )

dbSelectArea("CT2")
dbSetOrder(1)

aGETS		:= {}

If nOpc == 3					// Inclusao
   /*	cTipo		:= CriaVar("CT2_DC",.T.)
	cDebito		:= CriaVar("CT2_DEBITO")
	cCredito	:= CriaVar("CT2_CREDIT")
	cCustoDeb	:= CriaVar("CT2_CCD")
	cCustoCrd	:= CriaVar("CT2_CCC")
	cItemDeb	:= CriaVar("CT2_ITEMD")
	cItemCrd	:= CriaVar("CT2_ITEMC")
	cCLVLDeb	:= CriaVar("CT2_CLVLDB")
	cCLVLCrd	:= CriaVar("CT2_CLVLCR")
	cMoeda		:= CriaVar("CT2_MOEDLC")
	cHistPad	:= CriaVar("CT2_HP")
	cTpSald		:= CriaVar("CT2_TPSALD")
	M->CT2_MCONVER	:= CriaVar("CT2_CONVER")
	cDescDeb	:= Space(20)
	cDescCrd	:= Space(20)
	cTexto		:= ""
	nValor		:= CriaVar("CT2_VALOR")
	cEmpOri		:= cEmpAnt
	cFilOri		:= cFilAnt
	__nValor 	:= nValor		// Carrego a Static para conversoes
	
	If CtbUso("CT2_DCD")
		cDcd	:= CriaVar("CT2_DCD")
		cDcc	:= CriaVar("CT2_DCC")	
	EndIf
	
	// Monta Array com as conversoes
	MontaConv(nValor,cTipo,dData,,cDebito,cCredito,cMoeda) */
Else
	// Se posicionou em registro de continuacao de historico, devera achar
	// qual o registro principal
	cSeqLan := CT2->CT2_SEQLAN       
	cLinha	:= CT2->CT2_LINHA
	cEmpOri	:= CT2->CT2_EMPORI
	cFilOri	:= CT2->CT2_FILORI
	cTpSald	:= CT2->CT2_TPSALD
	If nOpc == 6 .Or. nOpc == 7//Se for estorno, procurar o lote/documento posicionado
   		/*dEstData	:= CT2->CT2_DATA
   		cEstLote	:= CT2->CT2_LOTE
   		cEstSbLote	:= CT2->CT2_SBLOTE
   		cEstDoc		:= CT2->CT2_DOC
   		cEstLinha	:= CT2->CT2_LINHA                                           
   		cEstTpSald	:= CT2->CT2_TPSALD
   		cEstEmpOri	:= CT2->CT2_EMPORI
   		cEstFilOri	:= CT2->CT2_FILORI    		
   		cEstSeqLan	:= CT2->CT2_SEQLAN
   		If CT2->CT2_DC == "4"  
   			dbSelectArea("CT2")
   			dbSetOrder(10)
			MsSeek(xFilial("CT2")+Dtos(dEstData)+cEstLote+cEstSbLote+cEstDoc+cEstSeqLan+cEstEmpOri+cEstFilOri+'01')
			dbSetOrder(1)   		
   		Else
	    	dbSelectArea("CT2")
    		dbSetOrder(1)
			MsSeek(xFilial("CT2")+Dtos(dEstData)+cEstLote+cEstSblote+cEstDoc+cEstLinha+cEstTpSald+cEstEmpOri+cEstFilOri+'01')
	    EndIf */
	Else
		If CT2->CT2_DC == "4"  
		   /*	dbSelectArea("CT2")
			dbSetOrder(10)
			MsSeek(xFilial("CT2")+Dtos(dData)+cLote+cSubLote+cDoc+cSeqLan+cEmpOri+cFilOri+'01')
			dbSetOrder(1) */
	    Else                               
	    	dbSelectArea("CT2")
    		dbSetOrder(1)
			MsSeek(xFilial("CT2")+Dtos(dData)+cLote+cSublote+cDoc+cLinha+cTpSald+cEmpOri+cFilOri+'01')   		
		Endif
	EndIf
    
	If CT2->(Found())	/// GUARDA O REGISTRO DO CT2 MOEDA 01, PARA VALIDACAO Ctba101OK()
		nRegCT2M01	:= CT2->(Recno())
	EndIf
	
	cTexto		:= ""

	// Define as novas entidades
	For nX := 1 To Len( aNovasEnt )
		aNovasEnt[nX][3]	:= Val( &("CT2_EC" + aNovasEnt[nX][1] + "DB") )
		aNovasEnt[nX][4]	:= Val( &("CT2_EC" + aNovasEnt[nX][1] + "CR") )
	Next

	If nOpc == 6				// Estorno de Lancamento Contabil
	   /*	If CT2->CT2_DC == "1"	// Debito eh trocado pelo credito e vice-versa
			cTipo	:= "2"
		ElseIf CT2->CT2_DC == "2"
			cTipo := "1"	
		Else
			cTipo  := "3"			
		EndIf	
		cCredito	:= CT2->CT2_DEBITO
		cDebito		:= CT2->CT2_CREDIT
		cCustoCrd	:= CT2->CT2_CCD
		cCustoDeb	:= CT2->CT2_CCC
		cItemCrd	:= CT2->CT2_ITEMD
		cItemDeb	:= CT2->CT2_ITEMC
		cCLVLCrd	:= CT2->CT2_CLVLDB
		cCLVLDeb	:= CT2->CT2_CLVLCR
		cTexto		:= 	STR0065+DTOC(CT2->CT2_DATA)+" "+;		
			  		CT2->CT2_LOTE+" "+CT2->CT2_SBLOTE+" "+CT2->CT2_DOC+" "+CT2->CT2_LINHA
		cEmpOri		:= CT2->CT2_EMPORI
		cFilOri		:= CT2->CT2_FILORI		
		If CtbUso("CT2_DCD")
			cDcd	:= CT2->CT2_DCC
			cDcc	:= CT2->CT2_DCD
		EndIf		*/
		
	Else
		cTipo		:= CT2->CT2_DC
		cDebito		:= CT2->CT2_DEBITO
		cCredito	:= CT2->CT2_CREDIT
		cCustoDeb	:= CT2->CT2_CCD
		cCustoCrd	:= CT2->CT2_CCC
		cItemDeb	:= CT2->CT2_ITEMD
		cItemCrd	:= CT2->CT2_ITEMC
		cCLVLDeb	:= CT2->CT2_CLVLDB
		cCLVLCrd	:= CT2->CT2_CLVLCR
		cEmpOri		:= CT2->CT2_EMPORI
		cFilOri		:= CT2->CT2_FILORI
	   /*	If CtbUso("CT2_DCD")
			cDCD	:= CT2->CT2_DCD
			cDCC	:= CT2->CT2_DCC
		EndIf		*/	
	EndIf	
	
	cMoeda	:= CT2->CT2_MOEDLC	
	
	If nOpc != 6
		cHistPad	:= CT2->CT2_HP
	EndIf	
	cTpSald		:= CT2->CT2_TPSALD
	nValor		:= CT2->CT2_VALOR
	cLinha		:= CT2->CT2_LINHA 
   /*	If lSeqCorr
		cSeqCorr := CT2->CT2_SEGOFI
	EndIf  */

	// Carrega descricao da Conta
	If !Empty(cDebito)
		dbSelectArea("CT1")
		dbSetOrder(1)
		dbSeek(xFilial()+cDebito)
		cDescDeb := &("CT1->CT1_DESC"+cMoeda)
	EndIf
	If !Empty(cCredito)	
		dbSelectArea("CT1")
		dbSetOrder(1)
		dbSeek(xFilial()+cCredito)
		cDescCrd := &("CT1->CT1_DESC"+cMoeda)
	EndIf   
	If !Empty(cCustoDeb)
		dbSelectArea("CTT")
		dbSetOrder(1)
		dbSeek(xFilial()+cCustoDeb)
		cDescCCD := &("CTT->CTT_DESC"+cMoeda)
	EndIf
	If !Empty(cCustoCrd)
		dbSelectArea("CTT")
		dbSetOrder(1)
		dbSeek(xFilial()+cCustoCrd)
		cDescCCC := &("CTT->CTT_DESC"+cMoeda)
	EndIf
	If !Empty(cItemDeb)
		dbSelectArea("CTD")
		dbSetOrder(1)
		dbSeek(xFilial()+cItemDeb)
		cDescItD := &("CTD->CTD_DESC"+cMoeda)
	EndIf
	If !Empty(cItemCrd)
		dbSelectArea("CTD")
		dbSetOrder(1)
		dbSeek(xFilial()+cItemCrd)
		cDescItC := &("CTD->CTD_DESC"+cMoeda)
	EndIf
	If !Empty(cClVlDeb)
		dbSelectArea("CTH")
		dbSetOrder(1)
		dbSeek(xFilial()+ccLVlDeb)
		cDescCvD := &("CTH->CTH_DESC"+cMoeda)
	EndIf
	If !Empty(cClVlCrd)
		dbSelectArea("CTH")
		dbSetOrder(1)
		dbSeek(xFilial()+cClVlCrd)
		cDescCvC := &("CTH->CTH_DESC"+cMoeda)
	EndIf

	If nOpc == 7  // Copia
	   /*	dbSelectArea("CT2")   
		dbSetOrder(10)
		// Carrega Historico
		nReg := Recno()
		If MsSeek(xFilial()+dtos(dCpyDt)+cCpyLote+cCpySLote+cCpyDoc+cCpySeq+cCpyEmp+cCPyFil+'01')
			While !Eof() .And. xFilial() == CT2->CT2_FILIAL 		.And.;
								CT2->CT2_DATA == dCpyDt 			.And.;
								CT2->CT2_LOTE == cCpyLote 			.And.;
								CT2->CT2_SBLOTE == cCpySLote 	.And.;
								CT2->CT2_DOC == cCpyDoc 			.And.;
								CT2->CT2_SEQLAN == cCpySeq		.And.; 
								CT2->CT2_TPSALD	==cCpySld		.And.;
								CT2->CT2_MOEDLC == '01'			.And.;
								CT2->CT2_EMPORI == cCpyEmp		.And.;
								CT2->CT2_FILORI	== cCPyFil						
				cTexto 	+= (CT2->CT2_HIST + CHR(13) + CHR(10))
				dbSkip()
			EndDo
		EndIf
		dbGoto(nReg) */
	Else
		dbSelectArea("CT2")   
		dbSetOrder(10)
		// Carrega Historico
		nReg := Recno()
		If MsSeek(xFilial()+dtos(dData)+cLote+cSubLote+cDoc+cSeqLan+cEmpOri+cFilOri+'01')
			While !Eof() .And. xFilial() == CT2->CT2_FILIAL 		.And.;
								CT2->CT2_DATA == dData 			.And.;
								CT2->CT2_LOTE == cLote 			.And.;
								CT2->CT2_SBLOTE == cSubLote 	.And.;
   								CT2->CT2_DOC == cDoc 			.And.;
								CT2->CT2_SEQLAN == cSeqLan		.And.; 
								CT2->CT2_TPSALD	==cTpSald		.And.;
								CT2->CT2_MOEDLC == '01'			.And.;
								CT2->CT2_EMPORI == cEmpOri		.And.;
								CT2->CT2_FILORI	== cFilOri						
				cTexto 	+= (CT2->CT2_HIST + CHR(13) + CHR(10))
				dbSkip()
			EndDo
		EndIf
		dbGoto(nReg)
		
	EndIf
	__nValor := nValor		// Carrego a Static para conversoes
	// Carrega conversoes ja gravadas
	
	CtbCarConv(cMoeda, CT2->CT2_DATA)
EndIf

RestArea(aSaveArea)

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Program   ³CtbConv   ³ Autor ³ Pilar S. Albaladejo   ³ Data ³ 24.07.00 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Converte um valor a partir do crit de conversao            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ CtbConv(cCriter,dData,cMoeda,nValor,cBloq)                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ Valor Convertido                                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Generico                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpC1 = Criterio de Conversao                              ³±±
±±³          ³ ExpD1 = Data do Lancamento Contabil                        ³±±
±±³          ³ ExpC2 = Moeda do Lancamento Contabil                       ³±±
±±³          ³ ExpN1 = Valor a ser Convertido                             ³±±
±±³          ³ ExpL1 = Identifica se deve verificar o bloqueio da moeda   ³±±
±±³          ³ ExpC3 = Tipo de bloqueio aplicado para moeda               ³±±
±±³          ³         Se nao passado utiliza CTP->CTP_BLOQ               ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function CtbConv(cCriter,dData,cMoeda,nValor,lVBloq,cBloq)
    
Local nValConv 		:= 0
Local aSaveArea	 	:= GetArea()
Local aDatas  		:= {}
Local lCtb101Cnv 	:= ExistBlock("CTB101CNV")
DEFAULT lVBloq  	:= .F.

CTO->(DbSetOrder(1))
CTO->(DbSeek(xFilial("CTO")+cMoeda))

nValor := Iif(nValor==Nil,0,nValor)

If cCriter $ "1/9"						// Diário
	dbSelectArea("CTP")
	dbSetOrder(1)
	If MsSeek(xFilial("CTP")+DTOS(dData)+cMoeda)
		cBloq := If(cBloq = Nil, CTP->CTP_BLOQ, cBloq)
		If ! lVBloq .Or. cBloq <> "1"	// Moeda não bloqueada
			If cPaisLoc == "BRA"		
				If CTO->CTO_DECIM == 2
					nValConv := Round(NoRound(nValor / CTP->CTP_TAXA, 4), 2)				
				Else
					nValConv := Round(NoRound(nValor / CTP->CTP_TAXA, CTO->CTO_DECIM), CTO->CTO_DECIM)	
				EndIf
			Else
				nValConv := Round(NoRound(nValor / CTP->CTP_TAXA, CTO->CTO_DECIM), CTO->CTO_DECIM)
			EndIf				
		EndIf	
	EndIf
ElseIf cCriter $ "2/8"					// Média Mensal
	cBloq := If(cBloq = Nil, CTP->CTP_BLOQ, cBloq)
	If ! lVBloq .Or. cBloq <> "1"		// Moeda não bloqueada
		If __aMedias[Val(cMoeda)] = Nil .Or. __dData <> dData
 			CtbMedias(dData,,cCriter)
			__dData := dData			
		Endif
		If __aMedias[Val(cMoeda)] = Nil
			nValConv := 0 // Tratamento para que quando nao houver taxa para calcular a media, deixar o campo zerado
		Else
			If cPaisLoc == "BRA"
				If CTO->CTO_DECIM == 2
					nValConv := Round(NoRound(nValor / __aMedias[Val(cMoeda)], 4), 2)
				Else
					nValConv := Round(NoRound(nValor / __aMedias[Val(cMoeda)], CTO->CTO_DECIM), CTO->CTO_DECIM)	
				EndIf
			Else
				nValConv := Round(NoRound(nValor / __aMedias[Val(cMoeda)], CTO->CTO_DECIM), CTO->CTO_DECIM)
			EndIf
		Endif	
	Endif
ElseIf	cCriter $ "3/7"					// Último Dia
	aDatas 	:= CTBPeriodos(cMoeda,dData,,, .F. )		// Retorna data inicial e final	
	dbSelectArea("CTP")
	dbSetOrder(1)                                                                      
	If MsSeek(xFilial("CTP")+DTOS(aDatas[1][2])+cMoeda)	
		cBloq := If(cBloq = Nil, CTP->CTP_BLOQ, cBloq)
		If ! lVBloq .Or. cBloq <> "1"	// Moeda não bloqueada
			If cPaisLoc == "BRA"
				If CTO->CTO_DECIM == 2
					nValConv := Round(NoRound(nValor / CTP->CTP_TAXA, 4), 2)				
				Else
					nValConv := Round(NoRound(nValor / CTP->CTP_TAXA, CTO->CTO_DECIM), CTO->CTO_DECIM)	
				EndIf
			Else
				nValConv := Round(NoRound(nValor / CTP->CTP_TAXA, CTO->CTO_DECIM), CTO->CTO_DECIM)
			EndIf	
		EndIf	
	EndIf
ElseIf cCriter == "4"	// Informada
	nValConv := 0
ElseIf cCriter == "5"
	nValConv := 0
ElseIf	cCriter == "A"
    nValConv := 0
EndIf	

RestArea(aSaveArea) 

If lCtb101Cnv
	nValConv := ExecBlock( "CTB101CNV" , .F. , .F. , {cCriter,dData,cMoeda,nValor,lVBloq,cBloq})
Endif

Return nValConv

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Program   ³CtbCarConv³ Autor ³ Pilar S. Albaladejo   ³ Data ³ 24.07.00 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Carrega matriz de conversoes na Visual. / Alteracao / Excl ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ CtbaCarConv(cMoeda, dData)                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ Nenhum                                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Generico                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpC1 = Moeda do Lancamento Contabil                       ³±±
±±³          ³ ExpD1 = Data do lancamento contabil para verificar bloqueio³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function CtbCarConv(cMoeda, dData)

Local aSaveArea := GetArea()

Local nCont
Local nContador := 0
Local nRegCT2	:= 0
Local cBloq		:= ""
Local cVerMoeda	:= ""        
Local cLote		:= ""
Local cSubLote	:= ""
Local cDoc		:= ""
Local cLin		:= ""
Local cEmpOri	:= ""
Local cFilOri	:= ""
Local cTpSald	:= ""
Local lDtTxUso	:= .F.
Local nPos_ALI_WT, nPos_REC_WT

nPos_ALI_WT := AScan(aHeader,{|x| Upper(AllTrim(x[2])) == "CT2_ALI_WT"})
nPos_REC_WT := AScan(aHeader,{|x| Upper(AllTrim(x[2])) == "CT2_REC_WT"})

M->CT2_MCONVER	:= "1"

For nCont	:= 2 to __nQuantas
	If CtbUso("CT2_DTTX"+StrZero(nCont,2))			
		lDtTxUso		:= .T.
		Exit		
	EndIf
Next   

For nCont := 1 To __nQuantas

	cVerMoeda := StrZero(nCont,2)
	//A moeda 01 nao sera mostrada na tela de conversao
	If cVerMoeda = '01'
		Loop
	EndIf

	//Verificar se a moed existe na filial corrente
	dbSelectArea("CTO")
	dbSetOrder(1) 
	If !MsSeek(xFilial()+cVerMoeda)
		Loop
	EndIf
	
	dbSelectArea("CTP")
	dbSetOrder(1)
	If MsSeek(xFilial()+DTOS(dData)+cVerMoeda)
		cBloq := CTP->CTP_BLOQ
	Else
		cBloq := "2"			// Nao bloqueda
	Endif

	nContador++

	dData		:= CT2->CT2_DATA
	cLote		:= CT2->CT2_LOTE
	cSubLote	:= CT2->CT2_SBLOTE
	cDoc		:= CT2->CT2_DOC
	cLin		:= CT2->CT2_LINHA 
	cTpSald		:= CT2->CT2_TPSALD
	cEmpOri		:= CT2->CT2_EMPORI
	cFilOri		:= CT2->CT2_FILORI		
		
	dbSelectarea("CT2")
	dbSetOrder(1)
	nRegCT2	:= Recno()
	If MsSeek(xFilial()+dtos(dData)+cLote+cSubLote+cDoc+cLin+cTpSald+cEmpOri+cFilOri+cVerMoeda)
		aCols[nContador][2]:= CT2->CT2_CRCONV 					
		aCols[nContador][3]:= CT2->CT2_VALOR
		If Empty(aCols[nContador][2])
			aCols[nContador][2] := "1"
		Endif 
	Else	//Se nao achou, traz como moeda nao convertida (5)
		aCols[nContador][2]:= "5"
		aCols[nContador][3]:= 0
	EndIf            
	
	M->CT2_MCONVER	+= aCols[nContador][2]
	
	If lDtTxUso
		aCols[nContador][5]:= CT2->CT2_DATATX
	EndIf      
	
	dbGoto(nRegCT2)

	aCols[nContador][4]:= cBloq
	If lDtTxUso
		aCols[nContador][6]:= .F.	
	Else	
		aCols[nContador][5]:= .F.
	EndIf
	
Next nCont

RestArea(aSaveArea)

Return 

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Program   ³CtbTabela ³ Autor ³ Pilar S. Albaladejo   ³ Data ³ 24.07.00 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Carrega codigos cta/cc/item da tabela de saldos            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ CtbTabela(aTabela)                                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ Nenhum                                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Generico                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpA1 = Tabela de Saldos                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function CtbTabela(aTabela)

aTabela[01][2] := Alltrim(CT2->CT2_DEBITO)
aTabela[02][2] := Alltrim(CT2->CT2_CREDIT)
aTabela[03][2] := Alltrim(CT2->CT2_CCD)
aTabela[04][2] := Alltrim(CT2->CT2_CCC)
aTabela[05][2] := Alltrim(CT2->CT2_ITEMD)
aTabela[06][2] := Alltrim(CT2->CT2_ITEMC)
aTabela[07][2] := Alltrim(CT2->CT2_CLVLDB)
aTabela[08][2] := Alltrim(CT2->CT2_CLVLCR)
aTabela[09][2] := Alltrim(CT2->CT2_LOTE) + "/" + Alltrim(CT2->CT2_SBLOTE)
aTabela[10][2] := Alltrim(CT2->CT2_DOC)

Return

/*/                                                                      
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Program   ³Ctb101Inf ³ Autor ³ Pilar S. Albaladejo   ³ Data ³ 24.07.00 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Refresh do valor informado 								  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ Ctb101Inf(dDataLanc,cLote,cSubLote,oInf,nTotInf)    		  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ .T.                                                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpD1 = Data do Lancamento Contabil                        ³±±
±±³          ³ ExpC1 = Lote do Lancamento Contabil                        ³±±
±±³          ³ ExpC2 = Sub-Lote do Lancamento Contabil                    ³±±
±±³          ³ cDoc  = Numero do Documento do Lancamento Contabil         ³±±
±±³          ³ ExpO1 = Objeto do valor Informado (Documento)              ³±±
±±³          ³ ExpN1 = Valor Total Informado                              ³±±
±±³          ³ oInfLot = Objeto do valor Informado (Lote)                 ³±±
±±³          ³ nTotLot = Valor Total Informado                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function Ctb101Inf(dDataLanc,cLote,cSubLote,cDoc,oInf,nTotInf,oInfLot,nTotInfLot)

Local aSaveArea := GetArea()

dbSelectArea("CTC")
dbSetOrder(1)
dbSeek(xFilial()+dtos(dDataLanc)+cLote+cSubLote+cDoc+'01')

If found()  
	nTotInf := CTC->CTC_INF		
Else
	nTotInf := 0
Endif           
                                        
oInf:Refresh()
If oInfLot <> Nil .And. nTotInfLot <> Nil
	dbSelectArea("CT6")
	dbSetOrder(1)
	dbSeek(xFilial()+dtos(dDataLanc)+cLote+cSubLote+'01')

	If found()  
		nTotInfLot := CT6->CT6_INF		
	Else
		nTotInfLot := 0
	Endif           
                                        
	oInfLot:Refresh()
Endif

RestArea(aSaveArea)

Return .T.

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Program   ³CtGeraHist³ Autor ³ Pilar S. Albaladejo   ³ Data ³ 07.03.01 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Gera Historico a partir da conta contabil                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ CtGeraHist(cConta,cTexto)                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ .T. / .F.                                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpC1 = Conta contabil                                     ³±±
±±³          ³ ExpC2 = Alias da Entidade                                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function CtGeraHist(cConta,cHistPadAnt,cTexto,aFormat,oMemo1,oMemo2,cTipoHist,nOpc,cHistPad)

Local aSaveArea:= GetArea()
Local lRet		:= .T.

If !Empty(cConta)
	dbSelectArea("CT1")
	dbSetOrder(1)
	If dbSeek(xFilial()+cConta)
		If !Empty(CT1->CT1_HP) .And. Empty(cHistPad)
			lRet := Ctb101Hist(CT1->CT1_HP,@cHistPadAnt,@cTexto,@aFormat,oMemo1,oMemo2,@cTipoHist,nOpc)
            if lRet .And. Empty(cHistPad)
				cHistPadAnt := cHistPad
            	cHistPad := CT1->CT1_HP
            EndIf
		EndIf	
	EndIf	
EndIf	
RestArea(aSaveArea)

Return lRet            

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Program   ³ConvCusto ³ Autor ³ Simone Mie Sato       ³ Data ³ 22.05.01 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Converte Codigo Reduzido p/Cod.Normal(Centro de Custo)     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ ConvCusto(cCusto) 			                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ .T. / .F.	                                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Generico 	                                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpC1 = Centro de Custo                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function ConvCusto(cCusto)

Local aSaveArea := GetArea()
Local aSaveCTT  := CTT->(GetArea())
Local lRet		:= .t.

If !Empty(cCusto)
	// Conta digitada sera sempre pelo codigo reduzido
	If GetMv("MV_REDUZID") == "S"
		dbSelectArea("CTT")
		dbSetOrder(3)
		If dbSeek(xFilial()+cCusto)	
			cCusto := CTT->CTT_CUSTO
			lRet := ValidaCusto(cCusto)
		EndIf
	Else
		dbSelectArea("CTT")
		dbSetOrder(3)	
		If Substr(cCUSTO,1,1)=="*"
			cCusto :=Trim(SubStr(cCusto,2))
			cCusto += Space(Len(CTT->CTT_RES)-Len(cCusto))			
			If dbSeek(xFilial()+cCusto)	
				cCusto := CTT->CTT_CUSTO
				lRet := ValidaCusto(cCusto)
			EndIf
		Endif
	EndIf
EndIf	

CTT->(RestArea(aSaveCTT))
RestArea(aSaveArea)

Return lRet           


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Program   ³ConvItem  ³ Autor ³ Simone Mie Sato       ³ Data ³ 22.05.01 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Converte Codigo Reduzido p/Cod.Normal(Item Contabil)       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ ConvItem(cItem)                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ .T. / .F.	                                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Generico 	                                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpC1 = Item Contabil                                      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function ConvItem(cItem)

Local aSaveArea := GetArea()
Local aSaveCTD  := CTD->(GetArea())
Local lRet		:= .t.

If !Empty(cItem)
	// Conta digitada sera sempre pelo codigo reduzido
	If GetMv("MV_REDUZID") == "S"
		dbSelectArea("CTD")
		dbSetOrder(3)
		If dbSeek(xFilial()+cItem)	
			cItem := CTD->CTD_ITEM
			lRet := ValidItem(cItem)
		EndIf
	Else
		dbSelectArea("CTD")
		dbSetOrder(3)	
		If Substr(cItem,1,1)=="*"
			cItem :=Trim(SubStr(cItem,2))
			cItem += Space(Len(CTD->CTD_RES)-Len(cItem))			
			If dbSeek(xFilial()+cItem)	
				cItem:= CTD->CTD_ITEM
				lRet := ValidItem(cItem)
			EndIf
		Endif
	EndIf
EndIf	

CTD->(RestArea(aSaveCTD))
RestArea(aSaveArea)

Return lRet           
		
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Program   ³ConvCLVL  ³ Autor ³ Simone Mie Sato       ³ Data ³ 22.05.01 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Converte Codigo Reduzido p/Cod.Normal(Classe de Valor)     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ ConvCLVL(cClvl)		                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ .T. / .F.	                                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Generico 	                                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpC1 = Classe de Valor                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function ConvCLVL(cClvl)

Local aSaveArea := GetArea()
Local aSaveCTH  := CTH->(GetArea())
Local lRet		:= .t.

If !Empty(cClvl)
	// Conta digitada sera sempre pelo codigo reduzido
	If GetMv("MV_REDUZID") == "S"
		dbSelectArea("CTH")
		dbSetOrder(3)
		If dbSeek(xFilial()+cClvl)	
			cClvl := CTH->CTH_CLVL
			lRet := ValidaClvl(cClvl)
		EndIf
	Else
		dbSelectArea("CTH")
		dbSetOrder(3)	
		If Substr(cClvl,1,1)=="*"
			cClvl :=Trim(SubStr(cClvl,2))
			cClvl += Space(Len(CTH->CTH_RES)-Len(cClvl))			
			If dbSeek(xFilial()+cClvl)	
				cClvl:= CTH->CTH_CLVL
				lRet := ValidaClvl(cClvl)
			EndIf
		Endif
	EndIf
EndIf	

CTH->(RestArea(aSaveCTH))
RestArea(aSaveArea)

Return lRet

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Program   ³CtAtutab  ³ Autor ³ Pilar S. Albaladejo   ³ Data ³ 29.07.00 	 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Carrega Valores p/ Tela de Saldos Contabeis                	 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³CtAtuTab(cTpSald,cTipo,cMoeda,nValor,cDebito,cCredit,cCustoDeb,³±±
±±³			 ³cCustCrd,cItemDeb,cItemCrd,cCLVLDeb,cCLVLCrd,aTabela,oTabela,  ³±±
±±³          ³cSayCusto,cSayItem,cSayCLVL,dData,cLote,cSubLote,cDoc,cTipoAnt,³±±
±±³          ³nOpc)														     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³Nenhum	                                                	 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³Generico  	                                               	 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ExpC1= Tipo de Saldo                                      	 ³±±
±±³          ³ExpC2= Tipo do Lancamento                                 	 ³±±
±±³          ³ExpC3= Moeda do Lancamento                                	 ³±±
±±³          ³ExpN1= Valor do Lancamento                                	 ³±±
±±³          ³ExpC4= Conta Debito                                       	 ³±±
±±³          ³ExpC5= Conta Credito                                      	 ³±±
±±³          ³ExpC6= Centro de Custo Debito                             	 ³±±
±±³          ³ExpC7= Centro de Custo Credito                            	 ³±±
±±³          ³ExpC8= Item Debito                                        	 ³±±
±±³          ³ExpC9= Item Credito                                       	 ³±±
±±³          ³ExpC10= Classe de Valor Debito                             	 ³±±
±±³          ³ExpC11= Classe de Valor Credito                            	 ³±±
±±³          ³ExpA1= Matriz da Tabela                                   	 ³±±
±±³          ³ExpO1= Objeto da Tabela                                   	 ³±±
±±³          ³ExpC12= Descricao do C.Custo utilizada pelo usuario        	 ³±±
±±³          ³ExpC13= Descricao do Item utilizada pelo usuario          	 ³±±
±±³          ³ExpC14= Descricao da Classe de Valor utilizada pelo usuario    ³±±
±±³          ³ExpD1 = Data do Lancamento                                     ³±±
±±³          ³ExpC15= Lote do Lancamento                                     ³±±
±±³          ³ExpC16= Sub-Lote do Lancamento                                 ³±±
±±³          ³ExpC17= Documento do Lancamento                                ³±±
±±³          ³ExpC18= Tipo do Lancamento anterior.                           ³±±
±±³          ³ExpN2 = Numero da opcao escolhida.                             ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function CtAtuTab(cTpSald,cTipo,cMoeda,nValor,cDebito,cCredit,cCustoDeb,;
				cCustoCrd,cItemDeb,cItemCrd,cCLVLDeb,cCLVLCrd,aTabela,oTabela,cSayCusto,;
				cSayItem,cSayCLVL,dData,cLote,cSubLote,cDoc,cTipoAnt,nOpc, aNovasEnt )

Local aValTab 			:= {0,0,0}						// Saldo Deb / Saldo Crd / Saldo Atual
Local aValTab1			:= {0,0,0}
Local nCont
Local nAux				:= 0   
Local lRet 		:= .T.   
Local cEntDb
Local cEntCr

Private aDtMensal := nil
Private lSldChv := .T.

// Inicializa a Tabela
aTabela[01][1]	:= OemToAnsi(STR0022)								// Conta Debito
aTabela[02][1]	:= OemToAnsi(STR0023)								// Conta Credito
aTabela[03][1]	:= Alltrim(cSayCusto) + " " + OemToAnsi(STR0030)	// C. Custo Debito
aTabela[04][1]	:= Alltrim(cSayCusto) + " " + OemToAnsi(STR0031)	// C. Custo Credito
aTabela[05][1]	:= Alltrim(cSayItem) + " " + OemToAnsi(STR0030)	// Item Debito
aTabela[06][1]	:= Alltrim(cSayItem) + " " + OemToAnsi(STR0031)	// Item Credito
aTabela[07][1]	:= Alltrim(cSayCLVL) + " " + OemToAnsi(STR0030)	// Classe Vlr Debito
aTabela[08][1]	:= Alltrim(cSayCLVL) + " " + OemToAnsi(STR0031)	// Classe Vlr Credito
aTabela[09][1]	:= OemToAnsi(STR0009) + "/" + OemToAnsi(STR0062)	// Lote/Sub-Lote
aTabela[10][1]	:= OemToAnsi(STR0010)          	      			// Documento

For nCont := 1 To Len( aTabela )
	aTabela[nCont][2] := Space(15)
	aTabela[nCont][3] := Space(20)
	aTabela[nCont][4] := Space(20)
	aTabela[nCont][5] := Space(20)
Next nCont

// Recarrega identificadores 
aTabela[01][2] := Alltrim(cDebito)
aTabela[02][2] := Alltrim(cCredit)
aTabela[03][2] := Alltrim(cCustoDeb)
aTabela[04][2] := Alltrim(cCustoCrd)
aTabela[05][2] := Alltrim(cItemDeb)
aTabela[06][2] := Alltrim(cItemCrd)
aTabela[07][2] := Alltrim(cClVLDeb)
aTabela[08][2] := Alltrim(cCLVLCrd)
aTabela[09][2] := Alltrim(cLote) + "/" + Alltrim(cSubLote)
aTabela[10][2] := Alltrim(cDoc)

// Inclui as novas entidades
For nCont := 11 To Len( aTabela ) Step 2
	nAux++
	If nAux > Len( aNovasEnt )
		Exit
	EndIf	

	aTabela[nCont][1]	:= aNovasEnt[nAux][2] + " " + STR0030 //"Debito"
	aTabela[nCont][2]	:= aNovasEnt[nAux][3]


	aTabela[nCont+1][1]	:= aNovasEnt[nAux][2] + " " + STR0031 //"Credito"
	aTabela[nCont+1][2]	:= aNovasEnt[nAux][4]

Next

// Identificador 01 -> Conta Debito
// Identificador 02 -> Conta Credito
// Identificador 03 -> C Custo Debito
// Identificador 04 -> C Custo Credito
// Identificador 05 -> Item Debito
// Identificador 06 -> Item Credito
// Identificador 07 -> Classe Valor Debito
// Identificador 08 -> Classe Valor Credito
// Identificador 09 -> Lote
// Identificador 10 -> Documento

// Refaz TODOS Valores                         
// REFAZ VALORES DE CONTAS -> IDENTIFICADORES 01 (DEBITO) E 02 (CREDITO)
/*If cTipo == "1" .And. !Empty(cDebito)
	aValores:=	SaldoCT7(cDebito,dData,cMoeda,cTpSald)
	aValTab	:=	CtAvalTab(aValores,nValor,cTipo,cTipoAnt,cMoeda,nOpc,,@lRet)
	CtCarrTab(1,aValTab,@aTabela)
	aValTab	:= {0,0,0}
	CtCarrTab(2,aValTab,@aTabela)
EndIf	   */
	
/*If cTipo == "2" .And. !Empty(cCredit)
	aValores	:=	SaldoCT7(cCredit,dData,cMoeda,cTpSald)
	aValTab		:=	CtAvalTab(aValores,nValor,cTipo,cTipoAnt,cMoeda,nOpc,,@lRet)
	CtCarrTab(2,aValTab,@aTabela)

	aValTab		:= {0,0,0}
	CtCarrTab(1,aValTab,@aTabela)
EndIf	*/

If cTipo == "3" .And. !Empty(cDebito) .And. !Empty(cCredit)
	aValores	:=	SaldoCT7(cDebito,dData,cMoeda,cTpSald)
	aValTab		:=	CtAvalTab(aValores,nValor,cTipo,cTipoAnt,cMoeda,nOpc,"1",@lRet)
	CtCarrTab(1,aValTab,@aTabela)
	aValores	:=	SaldoCT7(cCredit,dData,cMoeda,cTpSald)
	aValTab		:=	CtAvalTab(aValores,nValor,cTipo,cTipoAnt,cMoeda,nOpc,"2",@lRet)
	CtCarrTab(2,aValTab,@aTabela)
EndIf	

If cTipo == "1" .And. !Empty(cCredit)
	aValTab 	:= {0,0,0}
	CtCarrTab(2,aValTab,@aTabela)
EndIf
If cTipo == "2" .And. !Empty(cDebito)
	aValTab 	:= {0,0,0}
	CtCarrTab(1,aValTab,@aTabela)
EndIf			

If Empty(cDebito)
	aValTab 	:= {0,0,0}
	CtCarrTab(1,aValTab,@aTabela)	
EndIf

If Empty(cCredit)
	aValTab := {0,0,0}
	CtCarrTab(2,aValTab,@aTabela)
EndIf	

// REFAZ VALORES DE C CUSTO  -> IDENTIFICADORES 03 (DEBITO) E 04 (CREDITO)
/*If cTipo == "1" .And. !Empty(cCustoDeb)
	aValores := SaldoCT3(cDebito,cCustoDeb,dData,cMoeda,cTpSald)
	aValTab	:=	CtAvalTab(aValores,nValor,cTipo,cTipoAnt,cMoeda,nOpc,,@lRet)
	CtCarrTab(3,aValTab,@aTabela)
	aValTab	:= {0,0,0}
	CtCarrTab(4,aValTab,@aTabela)
EndIf	*/
	
/*If cTipo == "2" .And. !Empty(cCustoCrd)
	aValores	:=	SaldoCT3(cCredit,cCustoCrd,dData,cMoeda,cTpSald)
	aValTab	:=	CtAvalTab(aValores,nValor,cTipo,cTipoAnt,cMoeda,nOpc,,@lRet)
	CtCarrTab(4,aValTab,@aTabela)
	aValTab	:= {0,0,0}
	CtCarrTab(3,aValTab,@aTabela)
EndIf	*/

/*If cTipo == "3" .And. !Empty(cCustoDeb) .And. !Empty(cCustoCrd)
	aValores	:=	SaldoCT3(cDebito,cCustoDeb,dData,cMoeda,cTpSald)
	aValTab	:=	CtAvalTab(aValores,nValor,cTipo,cTipoAnt,cMoeda,nOpc,"3",@lRet)
	CtCarrTab(3,aValTab,@aTabela)
	aValores	:=	SaldoCT3(cCredit,cCustoCrd,dData,cMoeda,cTpSald)
	aValTab	:=	CtAvalTab(aValores,nValor,cTipo,cTipoAnt,cMoeda,nOpc,"4",@lRet)
	CtCarrTab(4,aValTab,@aTabela)
EndIf	  */

/*If cTipo == "1" .And. !Empty(cCustoCrd)
	aValTab := {0,0,0}
	CtCarrTab(4,aValTab,@aTabela)
EndIf
If cTipo == "2" .And. !Empty(cCustoDeb)
	aValTab := {0,0,0}
	CtCarrTab(3,aValTab,@aTabela)
EndIf */			

If Empty(cCustoDeb)
	aValTab := {0,0,0}
	CtCarrTab(3,aValTab,@aTabela)	
EndIf

If Empty(cCustoCrd)
	aValTab := {0,0,0}
	CtCarrTab(4,aValTab,@aTabela)
EndIf	

// REFAZ VALORES DE ITEM  -> IDENTIFICADORES 05 (DEBITO) E 06 (CREDITO)
/*If cTipo == "1" .And. !Empty(cItemDeb)
	aValores := SaldoCT4(cDebito,cCustoDeb,cItemDeb,dData,cMoeda,cTpSald)
	aValTab	:=	CtAvalTab(aValores,nValor,cTipo,cTipoAnt,cMoeda,nOpc,,@lRet)
	CtCarrTab(5,aValTab,@aTabela)
	aValTab	:= {0,0,0}
	CtCarrTab(6,aValTab,@aTabela)
EndIf	
	
If cTipo == "2" .And. !Empty(cItemCrd)
	aValores	:=	SaldoCT4(cCredit,cCustoCrd,cItemCrd,dData,cMoeda,cTpSald)
	aValTab	:=	CtAvalTab(aValores,nValor,cTipo,cTipoAnt,cMoeda,nOpc,,@lRet)
	CtCarrTab(6,aValTab,@aTabela)
	aValTab	:= {0,0,0}
	CtCarrTab(5,aValTab,@aTabela)
EndIf	

If cTipo == "3" .And. !Empty(cItemDeb) .And. !Empty(cItemCrd)
	aValores	:=	SaldoCT4(cDebito,cCustoDeb,cItemDeb,dData,cMoeda,cTpSald)
	aValTab	:=	CtAvalTab(aValores,nValor,cTipo,cTipoAnt,cMoeda,nOpc,"5",@lRet)
	CtCarrTab(5,aValTab,@aTabela)
	aValores	:=	SaldoCT4(cCredit,cCustoCrd,cItemCrd,dData,cMoeda,cTpSald)
	aValTab	:=	CtAvalTab(aValores,nValor,cTipo,cTipoAnt,cMoeda,nOpc,"6",@lRet)
	CtCarrTab(6,aValTab,@aTabela)
EndIf	

If cTipo == "1" .And. !Empty(cItemCrd)
	aValTab := {0,0,0}
	CtCarrTab(6,aValTab,@aTabela)
EndIf
If cTipo == "2" .And. !Empty(cItemDeb)
	aValTab := {0,0,0}
	CtCarrTab(5,aValTab,@aTabela)
EndIf	 */		

If Empty(cItemDeb)
	aValTab := {0,0,0}
	CtCarrTab(5,aValTab,@aTabela)	
EndIf

If Empty(cItemCrd)
	aValTab := {0,0,0}
	CtCarrTab(6,aValTab,@aTabela)
EndIf	

// REFAZ VALORES DE CLASSE DE VALOR  -> IDENTIFICADORES 07 (DEBITO) E 08 (CREDITO)
/*If cTipo == "1" .And. !Empty(cCLVLDeb)
	aValores := SaldoCTI(cDebito,cCustoDeb,cItemDeb,cCLVLDeb,dData,cMoeda,cTpSald)
	aValTab	:=	CtAvalTab(aValores,nValor,cTipo,cTipoAnt,cMoeda,nOpc,,@lRet)
	CtCarrTab(7,aValTab,@aTabela)
	aValTab	:= {0,0,0}
	CtCarrTab(8,aValTab,@aTabela)
EndIf	
	
If cTipo == "2" .And. !Empty(cCLVLCrd)
	aValores	:=	SaldoCTI(cCredit,cCustoCrd,cItemCrd,cCLVLCrd,dData,cMoeda,cTpSald)
	aValTab	:=	CtAvalTab(aValores,nValor,cTipo,cTipoAnt,cMoeda,nOpc,,@lRet)
	CtCarrTab(8,aValTab,@aTabela)
	aValTab	:= {0,0,0}
	CtCarrTab(7,aValTab,@aTabela)
EndIf	*/

If cTipo == "3" .And. !Empty(cCLVLDeb) .And. !Empty(cCLVLCrd)
	aValores	:=	SaldoCTI(cDebito,cCustoDeb,cItemDeb,cCLVLDeb,dData,cMoeda,cTpSald)
	aValTab	:=	CtAvalTab(aValores,nValor,cTipo,cTipoAnt,cMoeda,nOpc,"7",@lRet)
	CtCarrTab(7,aValTab,@aTabela)
	aValores	:=	SaldoCTI(cCredit,cCustoCrd,cItemCrd,cCLVLCrd,dData,cMoeda,cTpSald)
	aValTab	:=	CtAvalTab(aValores,nValor,cTipo,cTipoAnt,cMoeda,nOpc,"8",@lRet)
	CtCarrTab(8,aValTab,@aTabela)
EndIf	

/*If cTipo == "1" .And. !Empty(cCLVLCrd)
	aValTab := {0,0,0}
	CtCarrTab(8,aValTab,@aTabela)
EndIf
If cTipo == "2" .And. !Empty(cCLVLDeb)
	aValTab := {0,0,0}
	CtCarrTab(7,aValTab,@aTabela)
EndIf			

If Empty(cCLVLDeb)
	aValTab := {0,0,0}
	CtCarrTab(7,aValTab,@aTabela)	
EndIf

If Empty(cCLVLCrd)
	aValTab := {0,0,0}
	CtCarrTab(8,aValTab,@aTabela)
EndIf	*/

// Valores do Lote - Identificador -> 09
If (cTipo == "1" .Or. cTipo == "3")
	aValores 	:= SaldoCT6(cLote,cSubLote,dData,cMoeda,cTpSald)
	aValTab		:= CtAvalLote(aValores,"1",cMoeda,nValor,cTipoAnt,nOpc)
	//Se for partida dobrada, eh necessario guardar o valor a debito para calcular o saldo
	//Zera o Saldo para carregar somente no credito 
	If cTipo = "3" 
		aValTab1	:= aClone(aValTab)
		aValTab[3]	:= 0
	EndIf
	CtCarrTab(9,aValTab,@aTabela)
EndIf	
// Valores do Lote - Identificador -> 09
If (cTipo == "2" .Or. cTipo == "3")
	aValores		:= SaldoCT6(cLote,cSubLote,dData,cMoeda,cTpSald)
	If cTipo == "3"	
		aValTab		:= CtAvalLote(aValores,"2",cMoeda,nValor,cTipoAnt,nOpc)	
		aValTab[1]	:= aValTab1[1]
		aValTab[3]	:= aValTab[2]-aValTab1[1]			
	Else
		aValTab		:= CtAvalLote(aValores,"2",cMoeda,nValor,cTipoAnt,nOpc)
	EndIf                                                                   
	CtCarrTab(9,aValTab,@aTabela)	
EndIf

// Valores do Documento - Identificador -> 10
If (cTipo == "1" .Or. cTipo == "3")
	aValores		:= SaldoCTC(cLote,cSubLote,cDoc,dData,cMoeda,cTpSald)
	aValTab		:= CtAvalLote(aValores,"1",cMoeda,nValor,cTipoAnt,nOpc)
	//Se for partida dobrada, eh necessario guardar o valor a debito para calcular o saldo
	//Zera o Saldo para carregar somente no credito	
	If cTipo = "3"
		aValTab1	:= aClone(aValTab)
		aValTab[3] := 0	
	EndIf
	CtCarrTab(10,aValTab,@aTabela)
EndIf	
// Valores do Documento - Identificador -> 10
If (cTipo == "2" .Or. cTipo == "3")
	aValores		:= SaldoCTC(cLote,cSubLote,cDoc,dData,cMoeda,cTpSald)
	//Se for partida dobrada, eh necessario guardar o valor a debito para calcular o saldo
	If cTipo == "3"	
		aValTab		:= CtAvalLote(aValores,"2",cMoeda,nValor,cTipoAnt,nOpc)
		aValTab[1]	:= aValTab1[1]
		aValTab[3]	:= aValTab[2]-aValTab1[1]
	Else
		aValTab		:= CtAvalLote(aValores,"2",cMoeda,nValor,cTipoAnt,nOpc)	
	EndIf
	CtCarrTab(10,aValTab,@aTabela)
EndIf

// Valores das Novas Entidades
nAux := 0
For nCont := 11 To Len( aTabela ) Step 2

	nAux++
	If nAux > Len( aNovasEnt )
		Exit
	EndIf	

	aDtMensal := nil
	cEntDb := Eval(aCtbEntid[1][4+nAux])
	cEntCr := Eval(aCtbEntid[2][4+nAux])
	
	If cTipo == "1" .And. !Empty(cEntDb)
		aValores := CtbSldCubo({cEntDb},{cEntDb},dData,dData,cMoeda,cTpSald,{cFilAnt})
		aValTab	:=	CtAvalTab(aValores,nValor,cTipo,cTipoAnt,cMoeda,nOpc)
		CtCarrTab(nCont,aValTab,@aTabela)
		aValTab	:= {0,0,0}
		CtCarrTab(nCont+1,aValTab,@aTabela)
	EndIf	
	
	If cTipo == "2" .And. !Empty(cEntCr)
		aValores := CtbSldCubo({cEntCr},{cEntCr},dData,dData,cMoeda,cTpSald,{cFilAnt})
		aValTab	:=	CtAvalTab(aValores,nValor,cTipo,cTipoAnt,cMoeda,nOpc)
		CtCarrTab(nCont+1,aValTab,@aTabela)
		aValTab	:= {0,0,0}
		CtCarrTab(ncont,aValTab,@aTabela)
	EndIf	

	If cTipo == "3" .And. !Empty(cEntDb) .And. !Empty(cEntCr)
		aValores := CtbSldCubo({cEntDb},{cEntDb},dData,dData,cMoeda,cTpSald,{cFilAnt})
		aValTab	:=	CtAvalTab(aValores,nValor,cTipo,cTipoAnt,cMoeda,nOpc,"7")
		CtCarrTab(nCont,aValTab,@aTabela)
		aValores := CtbSldCubo({cEntCr},{cEntCr},dData,dData,cMoeda,cTpSald,{cFilAnt})
		aValTab	:=	CtAvalTab(aValores,nValor,cTipo,cTipoAnt,cMoeda,nOpc,"8")
		CtCarrTab(nCont+1,aValTab,@aTabela)
	EndIf	

	If cTipo == "1" .And. !Empty(cEntCr)
		aValTab := {0,0,0}
		CtCarrTab(nCont+1,aValTab,@aTabela)
	EndIf
	If cTipo == "2" .And. !Empty(cEntDB)
		aValTab := {0,0,0}
		CtCarrTab(nCont,aValTab,@aTabela)
	EndIf			

	If Empty(cEntDb)
		aValTab := {0,0,0}
		CtCarrTab(nCont,aValTab,@aTabela)	
	EndIf

	If Empty(cEntCr)
		aValTab := {0,0,0}
		CtCarrTab(nCont+1,aValTab,@aTabela)
	EndIf

Next nCont

If oTabela <> Nil
	oTabela:Refresh()
EndIf

Return lRet

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Program   ³CtCarrTab ³ Autor ³ Pilar S. Albaladejo   ³ Data ³ 24.07.00 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Fomata valores para tabela de saldos.                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³CtCarrTab(nIdent,aValores,aTabela)                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³.T. 		                                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³Generico		                                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpN1 = Identificador da linha a ser atualizada            ³±±
±±³          ³ ExpA1 = Matriz com valores da tabela                       ³±±
±±³          ³ ExpA2 = Tabela                                             ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function CtCarrTab(nIdent,aValores,aTabela)

/*If aValores[1] != 0
	aTabela[nIdent][3] := Transform(aValores[1],cPictVal)			// Debito
//Else
//	aTabela[nIdent][3] := Space(20)
EndIf	*/
If aValores[2] != 0	
	aTabela[nIdent][4] := Transform(aValores[2],cPictVal)		   // Credito
//Else
//	aTabela[nIdent][4] := Space(20)	
EndIf  /*
If aValores[3] != 0	
	aTabela[nIdent][5] := Transform(Abs(aValores[3]),cPictVal+; // Saldo
								 If(aValores[3] < 0, STR0052, If(aValores[3] > 0, STR0053,"")))
//Else
//	aTabela[nIdent][5]  := Space(20)								 
EndIf	  */								 

Return .T.

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Program   ³CtAvalTab ³ Autor ³ Pilar S. Albaladejo   ³ Data ³ 24.07.00 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Carrega Valores p/ Matriz de Saldos -> Tela Saldos         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ CtAvalTab(aValor,nValor,cTipo,cTipoAnt,cMoeda,nOpc)        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ aValTab		                                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Generico  		                                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpA1 = Matriz com os valores                              ³±±
±±³          ³ ExpN1 = Valor                                              ³±±
±±³          ³ ExpC1 = Tipo do lancamento                                 ³±±
±±³          ³ ExpC2 = Tipo do lancamento anterior                        ³±±
±±³          ³ ExpC3 = Moeda do lancamento                                ³±±
±±³          ³ ExpN2 = Numero da opcao escolhida                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function CtAvalTab(aValor,nValor,cTipo,cTipoAnt,cMoeda,nOpc,cIdent,lRet)

Local aValTab := {0,0,0}							// Debito / Credito / Atual
Local nCont
Local aSize 	:= TamSX3("CT2_VALOR")
Local nVlMax 	:= val(repl('9',aSize[1]-IIf(aSize[2]>0,aSize[2]+1,0)))    

Default lRet	:= .T.   

If nOpc == 3									// Inclusao
  /*	If cTipo == "1"
		aValTab[1]	:= aValores[4] + nValor
		aValTab[2]	:= aValores[5]
	EndIf

	If cTipo == "2"
		aValTab[1]	:= aValores[4]
		aValTab[2]	:= aValores[5] + nValor
	EndIf

	If cTipo == "3"                           
		If cIdent $ "1/3/5/7"		//Se for Debito/Lote/Documento
			aValTab[1]	:= aValores[4] + nValor
			aValTab[2]	:= aValores[5]
		ElseIf cIdent $"2/4/6/8"	//Se for Credito/Lote/Documento
			aValTab[1]	:= aValores[4]
			aValTab[2]	:= aValores[5] + nValor
		EndIf		
	EndIf */
ElseIf nOpc == 4 .OR. nOpc == 5 // Alteracao ou Exclusão
	If cTipo == cTipoAnt
		If cTipo == "1"          
			aValTab[1]	:= (aValores[4] - CT2->CT2_VALOR) + nValor
			aValTab[2]	:= aValores[5]
		EndIf
		If cTipo == "2"
			aValTab[1]	:= aValores[4]
			aValTab[2]	:= (aValores[5] - CT2->CT2_VALOR) + nValor
		EndIf
		If cTipo == "3"
			If cIdent $ "1/3/5/7"		//Se for Debito/Lote/Documento 
				aValTab[1]	:= (aValores[4] - CT2->CT2_VALOR) + nValor
				aValTab[2]	:= aValores[5]

			ElseIf cIdent $"2/4/6/8"	//Se for Credito/Lote/Documento				
				aValTab[1]	:= aValores[4]
				aValTab[2]	:= (aValores[5] - CT2->CT2_VALOR) + nValor			
			EndIf
		EndIf
	Else
		If cTipo == "2"
			If cTipoAnt == "1"					// D -> C
				aValTab[1] := aValores[4] - CT2->CT2_VALOR
				aValTab[2] := aValores[5] + nValor
			ElseIf cTipoAnt == "3"				// X -> C
				aValTab[1]	:= aValores[4]
				aValTab[2]	:= (aValores[5] - CT2->CT2_VALOR) + nValor
			EndIf
		EndIf	
		If cTipo == "1"
			If	cTipoAnt == "2"					// C -> D
				aValTab[1]	:=	aValores[4] + nValor
				aValTab[2]	:=	aValores[5] - CT2->CT2_VALOR
			ElseIf cTipoAnt == "3"
				aValTab[1]	:= (aValores[4] - CT2->CT2_VALOR) + nValor
				aValTab[2]	:=	aValores[5]
			EndIf	
		EndIf	
		If cTipo == "3"
			If cTipoAnt == "1"
				aValTab[1]	:= (aValores[4] - CT2->CT2_VALOR) + nValor
				aValTab[2]	:= aValores[5] + nValor
			ElseIf cTipoAnt == "2"
				aValTab[1]	:= aValores[4] + nValor
				aValTab[2]	:= (aValores[5]  - CT2->CT2_VALOR) + nValor
			EndIf
		EndIf
	EndIf	
Else // Visualização
	aValTab[1]	:=	aValores[4]
	aValTab[2]	:=	aValores[5]
EndIf	

aValTab[3] := aValTab[2] - aValTab[1]

If lRet
	// Valida se nenhum saldo o limite da representacao numerica do campo
	For nCont := 1 to Len(aValTab)
		If Int(aValTab[nCont]) > nVlMax
			lRet := .F.	
			Help("CTBAERC",1,"HELP","CT101MAXSAL",STR0078 ,1,0) //"A soma do valor ao saldo da entidade implicará em valor fora da faixa de representação numérica."
			Exit
		EndIf
	Next nCont
EndIf

Return aValTab

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Program   ³CtAvalLote³ Autor ³ Pilar S. Albaladejo   ³ Data ³ 24.07.00 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Carrega Valores p/ Matriz de Saldos -> Valores Lotes       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³CtAvalLote(aValores,cTipo,cMoeda,nValor,cTipoAnt,nOpc)      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ aValTab		                                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³Generico                                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ExpA1 = Matriz com os valores                               ³±±
±±³          ³ExpC1 = Tipo do lancamento                                  ³±±
±±³          ³ExpC2 = Moeda do lancamento                                 ³±±
±±³          ³ExpN1 = Valor do lancamento                                 ³±±
±±³          ³ExpC3 = Tipo anterior doi lancamento                        ³±±
±±³          ³ExpN2 = Numero da opcao escolhida                           ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function CtAvalLote(aValores,cTipo,cMoeda,nValor,cTipoAnt,nOpc)

Local aValTab := {0,0,0}

If nOpc == 3							// Inclusao
	If cTipo == "1"
		aValTab[1]	:= aValores[2] + nValor
		aValTab[2]	:= aValores[3]
	EndIf
	If cTipo == "2"
		aValTab[1]	:= aValores[2]
		aValTab[2]	:= aValores[3] + nValor
	EndIf
	If cTipo == "3"
		aValTab[1]	:= aValores[2] + nValor
		aValTab[2]	:= aValores[3] + nValor
	EndIf
Else 								// Alteracao/Visualizacao/Exclusao
	If cTipo == cTipoAnt						
		If cTipo == "1"
			aValTab[1]	:= (aValores[2] - CT2->CT2_VALOR) + nValor
			aValTab[2]	:= aValores[3]
		EndIf
		If cTipo == "2"
			aValTab[1]	:= aValores[2]
			aValTab[2]	:= (aValores[3] - CT2->CT2_VALOR) + nValor
		EndIf
		If cTipo == "3"
			aValTab[1]	:= (aValores[2] - CT2->CT2_VALOR) + nValor
			aValTab[2]	:= (aValores[3] - CT2->CT2_VALOR) + nValor			
		EndIf
	Else
		If cTipo == "2"
			If cTipoAnt == "1"					// D -> C
				aValTab[1] := aValores[2] - CT2->CT2_VALOR
				aValTab[2] := aValores[3] + nValor
			ElseIf cTipoAnt == "3"				// X -> C
				aValTab[1]	:= (aValores[2] - CT2->CT2_VALOR) 
				aValTab[2]	:= (aValores[3] - CT2->CT2_VALOR) + nValor
			EndIf
		EndIf	
		If cTipo == "1"
			If	cTipoAnt == "2"					// C -> D
				aValTab[1]	:=	aValores[2] + nValor
				aValTab[2]	:=	aValores[3] - CT2->CT2_VALOR
			ElseIf cTipoAnt == "3"				// X -> D
				aValTab[1]	:= (aValores[2] - CT2->CT2_VALOR) + nValor
				aValTab[2]	:= (aValores[3] - CT2->CT2_VALOR) 
			EndIf	
		EndIf	
		If cTipo == "3"
			If cTipoAnt == "1"
				aValTab[1]	:= (aValores[2] - CT2->CT2_VALOR) + nValor
				aValTab[2]	:= aValores[3] + nValor
			ElseIf cTipoAnt == "2"
				aValTab[1]	:= aValores[2] + nValor
				aValTab[2]	:= (aValores[3]  - CT2->CT2_VALOR) + nValor
			EndIf
		EndIf
	EndIf	
EndIf	

aValTab[3]	:= aValTab[2] - aValTab[1]

Return aValTab

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Program   ³Ct101Rodap³ Autor ³ Pilar S. Albaladejo   ³ Data ³ 24.07.00     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Rodape de Folders -> Identificador do lcto                 	  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³Ct101Rodape(oFolder,dData,cLote,cSubLote,cDoc,cLinha,nValorCtb, ³±±
±±³          ³oLote,oSublote,odoc,oLinha,oFnt1,n)                      		  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ Nenhum  	                                               		  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³Generico                                                    	  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ExpO1 = Objeto do Folder                                    	  ³±±
±±           ³ExpD1 = Data do lancamento                                   	  ³±±
±±           ³ExpC1 = Numero do lote do lancamento                        	  ³±±
±±           ³ExpC2 = Numero do Sub-lote do lancamento                        ³±±
±±           ³ExpC3 = Numero do documento do lancamento                    	  ³±±
±±           ³ExpC4 = Numero da linha                                     	  ³±±
±±           ³ExpN1 = Valor							                       	  ³±±
±±           ³ExpO2 = Objeto do lote                                      	  ³±±
±±           ³ExpO3 = Objeto do Sub-lote                                  	  ³±±
±±           ³ExpO4 = Objeto do Documento                                 	  ³±±
±±           ³ExpO5 = Objeto da Linha                                     	  ³±±
±±           ³Exp06 = Objeto da Fonte	                                  	  ³±±
±±           ³ExpN2 = Numero do folder                                  	  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function Ct101Rodape(oFolder,dData,cLote,cSubLote,cDoc,cLinha,nValorCTB,oLote,oSubLote,;
					oDoc,oLinha,oFnt1,n)					
					
// Data
@ 140,011 	MSGET dData Picture '99/99/9999' When .F. ;
	       	SIZE 35,08 OF oFolder:aDialogs[n] PIXEL
// Lote				 
@ 140,048 	MSGET oLote VAR cLote Picture "@!" When .F. ;
		  	SIZE 12,09 OF oFolder:aDialogs[n] PIXEL
	// Sub-Lote				 
@ 140,078 	MSGET oSubLote VAR cSubLote Picture "!!!" When .F.;
		  	SIZE 12,09 OF oFolder:aDialogs[n] PIXEL
// Documento	
@ 140,107 	MSGET oDoc VAR cDoc Picture "999999" When .F. ;
		   	SIZE 12,09 OF oFolder:aDialogs[n] PIXEL

// Nro Lancamento
@ 140,140	MSGET oLinha VAR cLinha Picture "999" When .F. ;
			SIZE 12,09 OF oFolder:aDialogs[n] PIXEL
			
// Valor		   				
@ 140,216 MSGET nValorCTB SIZE 80,08 OF oFolder:aDialogs[n] PIXEL;
					Picture cPictVal When .F.				

@ 133,011 SAY OemToAnsi(STR0008) SIZE 035,08 OF oFolder:aDialogs[n] PIXEL // "Data "
@ 133,048 SAY OemToAnsi(STR0009) SIZE 035,08 OF oFolder:aDialogs[n] PIXEL // "Lote"
@ 133,077 SAY OemToAnsi(STR0062) SIZE 035,08 OF oFolder:aDialogs[n] PIXEL // "Sub-Lote"
@ 133,107 SAY OemToAnsi(STR0010) SIZE 027,08 OF oFolder:aDialogs[n] PIXEL // "Documento"
@ 133,140 Say OemToAnsi(STR0039) SIZE 100,08 OF oFolder:aDialogs[n] PIXEL // "Linha Lançamento"
@ 140,190 Say OemToAnsi(STR0024) SIZE 100,08 OF oFolder:aDialogs[n] ;		// "Valor"
				PIXEL FONT oFnt1 COLOR CLR_RED
					
Return									

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Program   ³CtbTpSald ³ Autor ³ Pilar S. Albaladejo   ³ Data ³ 24.07.00 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Retorna Tipo do Saldo  a partir da matriz/combo Status 	  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³CtbTpSald(cTpSald,aTpSald)                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ .T.					                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³Generico				                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpC1 = Tipo do Saldo Lancamento Contabil (Orcado/Real)    ³±±
±±³          ³ ExpO1 = Objeto para apresentacao do tipo de saldo digitado ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function CtbTpSald(cTpSald,oTpSald)

oTpSald:cCaption := Upper(Tabela("SL", cTpSald))

Return .t.
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CtbDtVenc ºAutor  ³Simone Mie Sato     º Data ³  07/12/04   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Alterar o valor de acordo com a taxa da data de vencimento. º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºParametro1³ cSegAte   = Ate qual segm.da masc. contab.sera considerado.º±±
±±º         2³ cMascara	 = Qual a mascara a ser considerada.          	  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function CtbDtVenc(dDataVenc,nValor01,nMoeda)

Local aSaveArea	:= GetArea()

Local nValor	:= 0 
Local cConver	:= ""	 
Local dDataTx	:= &(READVAR())

If FunName() <> 'CTBAERC'
	cConver	:= TMP->CT2_CONVER
	
	If Subs(cConver,nMoeda,1) == "9"
		nValor	:= CtbConv("9",dDataVenc,StrZero(nMoeda,2),nValor01,.F.,)	
		&("TMP->CT2_VALR"+StrZero(nMoeda,2))	:= nValor		
		nValor	:= 0 
	EndIf                
Else
	If aCols[n][2] == "9"
		nValor	:= CtbConv("9",dDataTx,aCols[n][1],__nValor,.F.,)			
		aCols[n][3]	:= nValor
		nValor	:= 0                             
	EndIf
EndIf

RestArea(aSaveArea)

Return(.T.) 

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³MenuDef   ³ Autor ³ Ana Paula N. Silva     ³ Data ³01/12/06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Utilizacao de menu Funcional                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³Array com opcoes da rotina.                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³Parametros do array a Rotina:                               ³±±
±±³          ³1. Nome a aparecer no cabecalho                             ³±±
±±³          ³2. Nome da Rotina associada                                 ³±±
±±³          ³3. Reservado                                                ³±±
±±³          ³4. Tipo de Transa‡„o a ser efetuada:                        ³±±
±±³          ³		1 - Pesquisa e Posiciona em um Banco de Dados         ³±±
±±³          ³    2 - Simplesmente Mostra os Campos                       ³±±
±±³          ³    3 - Inclui registros no Bancos de Dados                 ³±±
±±³          ³    4 - Altera o registro corrente                          ³±±
±±³          ³    5 - Remove o registro corrente do Banco de Dados        ³±±
±±³          ³5. Nivel de acesso                                          ³±±
±±³          ³6. Habilita Menu Funcional                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   DATA   ³ Programador   ³Manutencao efetuada                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³               ³                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function MenuDef()
Local aRotina := { 	{STR0001 ,"AxPesqui"  , 0 , 1,,.F.},; // "Pesquisar"
								{STR0002 ,"u_Ercrej", 0 , 2},; // "Visualizar"
								{STR0003 ,"u_Ercrej", 0 , 3},; // "Incluir"
								{STR0004 ,"u_Atuaerc", 0 , 4},; // "Alterar"
								{STR0005 ,"u_Ercrej", 0 , 5},; // "Excluir"
		 						{STR0063 ,"u_Ercrej", 0 , 4},; // "Estornar"
								{STR0073,"u_Ercrej", 0 , 4} ,;//"Copiar"
								{STR0066,"CtbLegenda" , 0 , 5, ,.F.},;  //"Legenda"
								{STR0070,"u_Ercrej"	, 0 , 2} }  // "Rastrear"
If Alltrim(GetNewPar("MV_CTBAPLA","1"))	> "1"
	aAdd(aRotina,{STR0072	,"CTBShowFLG(Nil)"	, 0 , 6})  // "Log Exclusao"
EndIf

Return(aRotina)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CtbHeaderWTºAutor  ³Paulo Carnelossi    º Data ³  20/03/07  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Montar no aheader os campos ALIAS _ALI_WT / _REC_WT para    º±±
±±º          ³utilizar nas getdados que nao possa utilizar fillgetdados() º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function CtbHeaderWT(cAlias, aHeader)
Local aArea := GetARea()
Local aAreaSX3 := SX3->(GetArea())
Local cUsado

dbSelectArea("SX3")
dbSetOrder(2)
cAlias := Alltrim(cAlias)

If SX3->(DbSeek(cAlias+"_FILIAL"))
	cUsado := SX3->X3_USADO

	AADD( aHeader, { "Alias WT", cAlias+"_ALI_WT", "", 09, 0,, cUsado, "C", cAlias, "V"} )
	AADD( aHeader, { "Recno WT", cAlias+"_REC_WT", "", 09, 0,, cUsado, "N", cAlias, "V"} )
EndIf

RestArea(aAreaSX3)
RestArea(aArea)
	
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ClearCx101ºAutor  ³Renato F. Campos    º Data ³  09/03/08   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Limpa os caches utilizados pela rotina                     º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function ClearCx101()

__aDtMedias := {}

RETURN

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Program   ³CtbMedias ³ Autor ³ Pilar S. Albaladejo   ³ Data ³ 24.07.00 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Carrega __aMedias com os valores medios das cotacoes       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ CtbMedias(dData)                                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ .T.      	                                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Generico 	                                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpD1 = Data do Lancamento Contabil                        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function CtbMedias(dDataIni,dDataFim,cCriter)

Local aSaveArea := GetArea()
Local nDias		:= 0
Local nValor	:= 0
Local aAreaCTO	:= CTO->(GetArea())
Local nIx		:= 0
Local lExist	:= .F.
Local cTipoDB	:= ""
Local lQuery 	:= .F.
Local cSrvType	:= Alltrim(Upper(TCSrvType()))
Local aSx3  	:= {}

#IFDEF TOP
	cTipoDB	:= Alltrim(Upper(TCGetDB()))
	lQuery := ( TCGetDb() <> "POSTGRES"	.And. cSrvType != "AS/400" )
#ENDIF		

lOracle		:= "ORACLE"		$ cTipoDB
lPostgres	:= "POSTGRES"	$ cTipoDB
lDB2		:= "DB2"		$ cTipoDB
lInformix	:= "INFORMIX"	$ cTipoDB

// percorre o cache das datas
IF __aDtMedias <> Nil .And. Len(__aDtMedias) > 0
	FOR nIx = 1 TO Len(__aDtMedias)
	    IF dDataIni >= __aDtMedias[nIx][1] .AND. dDataIni <= __aDtMedias[nIx][2]
	    	lExist := .T.
	    	EXIT
	    ENDIF
	NEXT
ENDIF

IF lExist // se existir no cache, simplesmente retorno
	Return __aMedias
ENDIF

// Cria Arquivo Temporario
dbSelectArea("CTO")
dbSetOrder(1)
If dbSeek(xFilial())

	If Empty(dDataFim)
		aDatas 	:= CTBPeriodos(CTO->CTO_MOEDA,dDataIni,,,.F.,,cCriter)		// Retorna data inicial e final
		dDataIni:= aDatas[1][1]
		dDataFim:= aDatas[1][2]
	EndIf	
	
	If lQuery
    	If lOracle .Or. lInformix
			cQuery := "SELECT CTO_MOEDA, SUM(CTP_TAXA)/NVL(COUNT(*),1) NVALOR "
    	ElseIf  lDB2 
			cQuery := "SELECT CTO_MOEDA, SUM(CTP_TAXA)/COALESCE(COUNT(*),1) NVALOR "
    	Else
			cQuery := "SELECT CTO_MOEDA, SUM(CTP_TAXA)/ISNULL(COUNT(*),1) NVALOR "
		EndIf

		cQuery += "	FROM "+RetSqlName("CTP")+" CTP, "+RetSqlName("CTO")+" CTO "
		cQuery += " WHERE CTP_FILIAL = '"+xFilial("CTP")+"' AND "
		cQuery += " CTP_DATA>='" +DTOS(dDataIni)+"' AND "
		cQuery += " CTP_DATA<='" +DTOS(dDataFim)+"' AND "
		cQuery += " CTP_MOEDA=CTO_MOEDA AND "
		cQuery += " CTP.D_E_L_E_T_<>'*' AND "		  		
		cQuery += " CTO.D_E_L_E_T_<>'*' "		  		
		cQuery += " GROUP BY CTO_MOEDA "		  		
		cQuery := ChangeQuery(cQuery)

		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"AUXCTP",.T.,.F.)

		If Len(aSx3 := TamSx3("CTP_TAXA")) > 0
			TCSetField("AUXCTP", "NVALOR", "N", aSx3[1] + 2,aSx3[2])
		Endif

		While AUXCTP->(! Eof() )	
			__aMedias[Val(AUXCTP->CTO_MOEDA)] := AUXCTP->NVALOR
			AUXCTP->(dbSkip())
		EndDo

		dbSelectArea( "AUXCTP" )
		dbCloseArea()
	Else

		dbSelectArea("CTO")
		While CTO->( !Eof() .And. CTO_FILIAL==xFilial("CTO") ) 
			nDias	:= 0
			nValor	:= 0

			dbSelectArea("CTP")
			dbSetOrder(2)

			dbSeek(xFilial()+CTO->CTO_MOEDA+Dtos(dDataIni),.T.)
			While CTP->(!Eof() .And.CTP_FILIAL+CTP->CTP_MOEDA+DTOS(CTP_DATA)==xFilial("CTP")+CTO->CTO_MOEDA+DTOS(dDataFim))
				nValor += CTP->CTP_TAXA
				nDias++
				CTP->(dbSkip())
			EndDo	

			__aMedias[Val(CTO->CTO_MOEDA)] := nValor / nDias	

			dbSelectArea("CTO")
			dbSkip()
		EndDo
	EndIf	
	
	// adiciono os dados no cache
	Aadd( __aDtMedias, {dDataIni,dDataFim} )
EndIf

RestArea(aAreaCTO)
RestArea(aSaveArea)

Return  __aMedias

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GetNovasEntºAutor  ³Totvs              º Data ³  09/03/08   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Identifica quantas entidades novas foram criadas.          º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function GetNovasEnt()
Local aArea		:= GetArea()
Local aAreaCT0	:= CT0->( GetArea() )
Local nQtdNovas	:= 0

DbSelectArea( "CT0" )
CT0->( DbSetOrder( 1 ) )
CT0->( dbSeek(xFilial("CT0") ) )
Do While CT0->CT0_FILIAL==xFilial("CT0") .And. !CT0->(Eof())
	// Desconsidera as 4 entidades padrao
	If Val( CT0->CT0_ID ) > 4
		nQtdNovas++
	EndIf
	
	CT0->( DbSkip() )
EndDo

// Considera debito e credito para cada entidade criada
nQtdNovas *= 2

RestArea( aAreaCT0 )
RestArea( aArea )

Return nQtdNovas

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GetAEntidadesºAutor  ³Totvs            º Data ³  02/12/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Retorna um array com as novas entidades                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function GetAEntidades()
Local aArea		:= GetArea()
Local aAreaCT0	:= CT0->( GetArea() )
Local aReturn	:= {}

DbSelectArea( "CT0" )
CT0->( DbSetOrder( 1 ) )
CT0->( dbSeek(xFilial("CT0")) )
Do While CT0->CT0_FILIAL==xFilial("CT0") .And. !CT0->(Eof())
	// Desconsidera as 4 entidades do padrao
	If Val( CT0->CT0_ID ) > 4
		aAdd( aReturn, { 	CT0->CT0_ID,;
							AllTrim( CT0->CT0_DESC ),;
							0,;
							0 } )
	EndIf
	
	CT0->( DbSkip() )
EndDo

RestArea( aAreaCT0 )
RestArea( aArea )

Return aReturn  

//Carlos Tratativa Ctba102Cap 

User Function erc102Cap(cAlias,nReg,nOpc,cProg,dDataLanc,cLote,cSubLote,cDoc)

Local cPadrao 
Local oDlg
Local oDoc
Local oLote  
Local oSubLote  
Local oInf, oInfLot, oHistLote
Local oLinha
Local oCodSeq

Local cCodSeq	:= ""
Local CTF_LOCK	:= 0
Local aAreaCT2	:= CT2->(GetArea())
Local lContinua := .F.
Local cAliasAnt := ""                                                             
Local cLinha 	:= ""         
Local cTitulo	:= ""
Local nTotInf 	:=nTotInfLot := 0
Local lDigita	:= .F.
Local nPosAut	:= 0
Local aCT102ACAP := {}

Local l102Inclui	:= .F.
Local l102Visual	:= .F.
Local l102Altera	:= .F.
Local l102Exclui	:= .F.
Local l102Estorno	:= .F.
Local l102Copia	:= .F.
Local lSeqCorr := FindFunction("UsaSeqCor") .AND. UsaSeqCor("CT2/CTK/CT5") // Controle do Correlativo

Local lUseDocHis	:= (cPaisLoc == "ARG") .And. X3USADO("CTC_DOCHIS")
Local cHistLote		:= space(80)
Local aAreaCTF		:= {}

Private nSaida		:= 0
Private aTotRdpe	:= {{0,0,0,0},{0,0,0,0}}

cPictVal := Iif( cPictVal == NIL, PesqPict("CT2","CT2_VALOR"), cPictVal )
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define a funcao utilizada ( Incl.,Alt.,Visual.,Exclu.)  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Do Case
	Case nOpc == 2
		//l102Visual := .T.
	Case nOpc == 3
		//l102Inclui	:= .T.
		//lDigita		:= .T.
	Case nOpc ==  4
		l102Altera	:= .T.
	Case nOpc ==  5
		//l102Exclui	:= .T.
	   //	l102Visual	:= .T.
	Case nOpc == 6
		//l102Estorno := .T.
	   //	lDigita		:= .T.		
	Case nOpc == 7
		//l102Copia	:= .T.
	   //	lDigita		:= .T.		
EndCase


dDataLanc	:= dDataBase
cLote		:= CriaVar("CT2_LOTE")
cSubLote	:= If(lSubLote, CriaVar("CT2_SBLOTE"), cLoteSub )
cDoc		:= CriaVar("CT2_DOC")
cPadrao		:= CriaVar("CT2_LP")

/*If lSeqCorr
	cCodSeq		:= CtbRdia()
EndIf    */

If l102Inclui .Or. l102Estorno .Or. l102Copia
  /*
	// BOPS 127818 - Problema com o Tamanho do sublote
    If ! Empty( cSubLote ) .AND. Len( alltrim( cSubLote )) < 3
    	cSubLote := StrZero( cSubLote , 3 )
    Endif

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Ponto de entrada para preenchimento do lote/sublote     ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If ExistBlock("CT102ACAP")

		aCT102ACAP := ExecBlock( "CT102ACAP", .F., .F. )

		If ValType(aCT102ACAP) == "A" .and. Len(aCT102ACAP) > 0

			If !Empty(aCT102ACAP[1])
				cLote := aCT102ACAP[1]
			Endif

			If Len(aCT102ACAP) > 1
				If !Empty(aCT102ACAP[2])
					cSubLote := aCT102ACAP[2]
				Endif
			Endif
		Endif
	Endif    */    
Else
	If Type( 'lCt102Auto' ) == "U" .Or. ! lCt102Auto
		dDataLanc	:= CT2->CT2_DATA
		cLote		:= CT2->CT2_LOTE
		cSubLote	:= CT2->CT2_SBLOTE
		cDoc		:= CT2->CT2_DOC
		cPadrao		:= CT2->CT2_LP
		If lSeqCorr
			cCodSeq := CT2->CT2_DIACTB
		EndIf
		If cPaisLoc == "ARG" .And. X3USADO("CTC_DOCHIS")
			cHistLote := CTBA102HCL()
		EndIf
		
	EndIf	   
Endif

If l102Altera .Or. l102Visual .Or. l102Exclui
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Carrega os totais da tela          ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea("CT6")
	dbSetOrder(1)

	If MsSeek( xFilial() + dtos(dDataLanc) + cLote+cSubLote+'01')
	   //	nTotInfLot := CT6->CT6_INF		
	Else
		nTotInfLot := 0
	Endif           
		
	dbSelectArea("CTC")
	dbSetOrder(1)
	If MsSeek(xFilial()+dtos(dDataLanc)+cLote+cSubLote+cDoc+'01')
	   //	nTotInf := CTC->CTC_INF		
	Else
		nTotInf := 0
	Endif           
EndIf

__lCusto	:= CtbMovSaldo("CTT")
__lItem		:= CtbMovSaldo("CTD")
__lCLVL		:= CtbMovSaldo("CTH")

AjustaSx1()

If Type( 'lCt102Auto' ) == 'U' .or. ! lCt102Auto 
	//Se for exclusão de lançamentos contábeis. 
	If l102Exclui .And. FunName() = "CTBA102"
		If MsgNoYes("Deseja realizar a exclus?o por lote?","Atencao")	//Atencao "Deseja realizar a exclus?o por lote?"  
			If Pergunte("CTB102",.T.)			
				//Ct102ExcLt(nOpc,dDataLanc,cLote,cSubLote,cDoc,nTotInf)           		
				Ct102EstLt(nOpc,dDataLanc,cLote,cSubLote,cDoc,nTotInf)           		
			EndIf
			Return
	    EndIF
	EndIf
Endif

If (l102Altera .Or. l102Inclui .Or. l102Estorno .Or. l102Copia .Or. l102Exclui) 

	//Se for estorno de lançamento,pergunta se quer estornar por lote. 
	If l102Estorno .And. FunName() = "CTBA102"
		If MsgNoYes(STR0070,STR0060)	//Atencao "Deseja realizar o estorno por lote?"		
			If Pergunte("CTB102",.T.)
			   
				dDataLanc := If(mv_par09==1,dDataLanc,mv_par10)
				cLote := If(Empty(mv_par11), cLote, mv_par11)
				cSubLote := If(Empty(mv_par12), cSubLote, mv_par12)
				cDoc := If(Empty(mv_par13), cDoc, mv_par13)
				If c102CapOk(dDataLanc,cLote,cSubLote,cDoc)  //se lote / sublote nao for informado avisa usuario e retorna
					Ct102EstLt(nOpc,dDataLanc,cLote,cSubLote,cDoc,nTotInf)
				EndIf
			EndIf
			Return
		EndIf
	EndIf
         
 

	// se não for inclusão
	// verifica se existe algum usuario concorrente
	If ! l102Inclui .And. ! Ctb102Smlt( Dtos( dDataLanc	) + cLote + cSubLote + cDoc )
		MsgAlert( "STR0095" ) // 'Documento em uso por outro usuario!'
		RETURN
	Endif

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Montagem da tela da capa do lote   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If cProg == "CTBAERC"
		cTitulo := OemToAnsi(STR0030)
	Else
		cTitulo := OemToAnsi(STR0007)
	EndIf	
	
	If Type( 'lCt102Auto' ) == 'U' .or. ! lCt102Auto 

  		If ! l102Exclui
			DEFINE MSDIALOG oDlg TITLE cTitulo FROM 33,25 TO If(lUseDocHis,320,260),If(lUseDocHis,569,369) PIXEL  //"Capa de Lote - Lan‡amentos Cont beis"

			@ 001,005 TO 032, 140 OF oDlg PIXEL
			@ 035,005 TO 066, 140 OF oDlg PIXEL

			@ 004,008 	SAY OemToAnsi(STR0008) SIZE 55, 7 OF oDlg PIXEL  //"Data Lan‡amento"
			@ 014,008 	MSGET oDataLanc VAR dDataLanc Picture "99/99/99" When .T. Valid NaoVazio(dDataLanc) .And. ;
								CtbValiDt(nOpc,dDataLanc) .And.;
								If(Empty(cLote),C050Next(dDataLanc,@cLote,@cSubLote,@cDoc,oLote,oSubLote,oDoc,@CTF_LOCK,nOpc,1),.T.) .And.;
								CtbMedias(dDataLanc) ;
								SIZE 50, 11 OF oDlg PIXEL HASBUTTON       					
								
			If lSeqCorr
				@ 004,068   SAY OemToAnsi("Cod. Diario") SIZE 37, 7 OF oDlg PIXEL
			   	@ 014,068   MSGET oCodSeq VAR cCodSeq Pict "!!" Valid VldCodSeq( cCodSeq );
				            F3 "CVL" SIZE 34, 11 OF oDlg PIXEL HASBUTTON When CtbWdia()
			Endif

			@ 038,008 	SAY OemToAnsi(STR0009) SIZE 18, 7 OF oDlg PIXEL  //"Lote"
			@ 048,008 	MSGET oLote VAR cLote Picture "@!" When .F. ;
							Valid NaoVazio(cLote) .And.;
							C102ProxDoc(dDataLanc,cLote,@cSubLote,@cDoc,@oLote,@oSubLote,@oDoc,@CTF_LOCK)  .And.;
							Ctb101Inf(dDataLanc,cLote,cSubLote,cDoc,oInf,@nTotInf,oInfLot,@nTotInfLot);
							SIZE 32, 11 OF oDlg PIXEL
			
			@ 038,041   SAY OemToAnsi(STR0028) SIZE 25, 7 OF oDlg PIXEL  //"Sub-Lote"
			@ 048,041   MSGET oSubLote VAR cSubLote Picture "!!!"  F3 "SB";
							WHEN lDigita .And. lSubLote;
							VALID NaoVazio(cSubLote) .And.;
								  C102ProxDoc(dDataLanc,cLote,@cSubLote,@cDoc,@oLote,@oSubLote,@oDoc,@CTF_LOCK)  .And.;
								  Ctb101Inf(dDataLanc,cLote,cSubLote,cDoc,oInf,@nTotInf,oInfLot,@nTotInfLot);
							SIZE 20, 11 OF oDlg PIXEL
			
			@ 038,068   SAY OemToAnsi(STR0010) SIZE 34, 7 OF oDlg PIXEL //"Documento"
			@ 048,068   MSGET oDoc VAR cDoc Picture "999999" ;
								When lDigita;            					
								Valid NaoVazio(cDoc) .And.;
								Ctb101Doc(dDataLanc,cLote,cSubLote,@cDoc,oDoc,@CTF_LOCK,nOpc) .And.;
								Ctb101Inf(dDataLanc,cLote,cSubLote,cDoc,oInf,@nTotInf,oInfLot,@nTotInfLot);
								SIZE 34, 11 OF oDlg PIXEL
								
			If cProg != 'CTBAERC'				
				@ 038,104   SAY OemToAnsi(STR0011) SIZE 37, 7 OF oDlg PIXEL  //"Lcto Padr„o"
			   	@ 048,104   MSGET oPadrao VAR cPadrao Pict "!!!" Valid ValidaLP(cPadrao) .And. CapValLP( cPadrao ) ;
				            F3 "CT5" SIZE 34, 11 OF oDlg PIXEL HASBUTTON When .F.
			Endif
			
			@ 074,005 	SAY OemToAnsi(STR0034) SIZE 60, 7 OF oDlg PIXEL 	//"Total Informado Docto"
			@ 070,080 	MSGET oInf VAR nTotInf  Picture cPictVal;
			    			When (l102Inclui .Or. l102Altera .Or. l102Estorno .Or. l102Copia);
				    				SIZE 80, 11 OF oDlg PIXEL HASBUTTON                 	 
							
			@ 089,005 	SAY OemToAnsi(STR0025) SIZE 60, 7 OF oDlg PIXEL	//"Total Informado Lote"
			@ 085,080 	MSGET oInfLot VAR nTotInfLot Picture cPictVal;
			    			When .F. SIZE 80, 11 OF oDlg PIXEL HASBUTTON                 	 
			
			If lUseDocHis
				@ 105,005 	SAY OemToAnsi("STR0104") SIZE 60, 7 OF oDlg PIXEL	//"Historico"
				@ 115,005	MSGET oHistLote VAR cHistLote  SIZE 260, 020  OF oDlg PIXEL				
			EndIf
									
			DEFINE SBUTTON FROM 05, 142 TYPE 1 ACTION (lContinua := .T.,;
								Iif(lDigita,Iif(Ct102GrCTF(dDataLanc,cLote,cSubLote,cDoc,@CTF_LOCK) .And.;
									Ctb101Lote(dDataLanc,cLote,cSubLote,@cDoc,oDoc,CTF_LOCK) .And.;
									Ctb101Doc(dDataLanc,cLote,cSubLote,@cDoc,oDoc,CTF_LOCK,nOpc) .And.;
									c102CapOk(dDataLanc,cLote,cSubLote,cDoc) .And.;
									VldCaplote(dDataLanc,cLote,cSubLote,cDoc,nOpc) .And.;
									CtbProxLin(dDataLanc,cLote,cSubLote,cDoc,@cLinha,@oLinha),;
									oDlg:End(),lContinua := .F.),;
									Iif(VldCaplote(dDataLanc,cLote,cSubLote,cDoc,nOpc) .and. ;
									CtbVldLP(dDataLanc,cLote,cSubLote,cDoc,nOpc) .And.;						
									CtbTmpBloq(dDataLanc,cLote,cSubLote,cDoc,nOpc,cProg) .and.;
									CtbValiDt(nOpc,dDataLanc),;
									oDlg:End(),lContinua := .F.))) ENABLE OF oDlg
			                                                                             
			DEFINE SBUTTON FROM 19, 142 TYPE 2 ACTION (lContinua := .F.,oDlg:End()) ENABLE OF oDlg
				
			ACTIVATE MSDIALOg oDlg CENTERED
		Else
			// caso for exclusão, passa direto sem a capa do lote
			lContinua := .T.		
		Endif
	Else
		Private aValidGet 	:= {}
		
		nPosAut := Ascan(aAutoCab,{|x|Upper(Alltrim(x[1])) == "DDATALANC"})
		If nPosAut # 0
			dDataLanc	:= aAutoCab[nPosAut,2]
			Aadd(aValidGet,{"dDataLanc", aAutoCab[nPosAut,2],;
				"NaoVazio(dDataLanc) .And. CtbValiDt("+lTrim(Str(nOpc))+",dDataLanc)",.T.})
		EndIf			
	
		nPosAut := Ascan(aAutoCab,{|x|Upper(Alltrim(x[1])) == "CLOTE"})
 		If nPosAut # 0
			Aadd(aValidGet,{"cLote", aAutoCab[nPosAut,2],"NaoVazio(cLote) ",.T.})
		EndIf	
		
		nPosAut := Ascan(aAutoCab,{|x|Upper(Alltrim(x[1])) == "CSUBLOTE"})
		If nPosAut # 0
			Aadd(aValidGet,{"cSubLote", aAutoCab[nPosAut,2],"NaoVazio(cSubLote) ",.T.})
	    EndIf
	    
		nPosAut := Ascan(aAutoCab,{|x|Upper(Alltrim(x[1])) == "CDOC"})
		If nPosAut # 0	
			Aadd(aValidGet,{"cDoc", aAutoCab[nPosAut,2],"NaoVazio(cDoc)",.T.})
		EndIf
	
		nPosAut := Ascan(aAutoCab,{|x|Upper(Alltrim(x[1])) == "CPADRAO"})
		If nPosAut # 0	
			cPadrao	:= aAutoCab[nPosAut,2]
			Aadd(aValidGet,{"cPadrao", aAutoCab[nPosAut,2],"ValidaLP(cPadrao) .And. CapValLP( cPadrao )",.T.})
		EndIf
	
		nPosAut := Ascan(aAutoCab,{|x|Upper(Alltrim(x[1])) == "CCODSEQ"})
		If nPosAut # 0	
			cPadrao	:= aAutoCab[nPosAut,2]
			Aadd(aValidGet,{"cCodSeq", aAutoCab[nPosAut,2], "VldCodSeq( cCodSeq )",.T.})
		EndIf

		nPosAut := Ascan(aAutoCab,{|x|Upper(Alltrim(x[1])) == "NTOTINF"})
		If nPosAut # 0	
			nTotInf	:= aAutoCab[nPosAut,2]
			Aadd(aValidGet,{"nTotInf", aAutoCab[nPosAut,2],".T.",.T.})
		EndIf
	
		nPosAut := Ascan(aAutoCab,{|x|Upper(Alltrim(x[1])) == "NTOTINFLOT"})
		If nPosAut # 0	
			nTotInfLot := aAutoCab[nPosAut,2]
			Aadd(aValidGet,{"nTotInfLot", aAutoCab[nPosAut,2],".T.",.T.})
		EndIf
	
		If CT2->(MsVldGAuto(aValidGet)) // Consiste os gets
			cLote 	 := Padr(cLote	  , TamSx3("CT2_LOTE"  )[1])//correcao do tamanho do campos.
			cSubLote := Padr(cSublote , TamSx3("CT2_SBLOTE")[1])
			cDoc	 := Padr(cDoc	  , TamSx3("CT2_DOC"   )[1])
	
			If nOpc == 3
				If Empty(cLote)
					C050Next(dDataLanc,@cLote,@cSubLote,@cDoc,oLote,oSubLote,oDoc,@CTF_LOCK,nOpc,1)
				Endif

				CtbMedias(dDataLanc) 
			    
			    If Empty( cLote ) .or. Empty( cSubLote ) .or. Empty( cDoc )   // verifico se alguma informação do lote não foi informado.
					C102ProxDoc(dDataLanc,cLote,@cSubLote,@cDoc,@oLote,@oSubLote,@oDoc,@CTF_LOCK)
				Endif
			EndIf			
	
			If Ctb101Doc(dDataLanc,cLote,cSubLote,@cDoc,oDoc,@CTF_LOCK,nOpc)
				If lDigita 
					If (Ct102GrCTF(dDataLanc,cLote,cSubLote,cDoc,@CTF_LOCK) .And.;
						Ctb101Lote(dDataLanc,cLote,cSubLote,@cDoc,oDoc,CTF_LOCK) .And.;
						Ctb101Doc(dDataLanc,cLote,cSubLote,@cDoc,oDoc,CTF_LOCK,nOpc) .And.;
						c102CapOk(dDataLanc,cLote,cSubLote,cDoc) .And.;
						VldCaplote(dDataLanc,cLote,cSubLote,cDoc,nOpc).And.;
						CtbProxLin(dDataLanc,cLote,cSubLote,cDoc,@cLinha,))
			
						lContinua := .T.
			
					EndIf					
					
				Else
					If (VldCaplote(dDataLanc,cLote,cSubLote,cDoc,nOpc) .and. ;
					CtbVldLP(dDataLanc,cLote,cSubLote,cDoc,nOpc) .And.;						
					CtbValiDt(nOpc,dDataLanc))
						
						lContinua := .T.
						
					EndIf
				EndIf		
			Else
				lContinua := .F.
			EndIf
		Else
			lContinua := .F.
		EndIf		
	EndIf	
Else
	lContinua := .T.
EndIf
/*
If !lContinua
	aAreaCTF := getArea()
	dbSelectArea("CTF")
	dbSetOrder(1)
	If msSeek(xFilial("CTF")+Dtos(dDataLanc)+cLote+cSubLote+cDoc)
		CtbDestrava(CTF->CTF_DATA,CTF->CTF_LOTE,CTF->CTF_SBLOTE,CTF->CTF_DOC,CTF->(recno()))
	Endif
	RestARea(aAreaCTF)
Endif        */

If lContinua
	RestArea(aAreaCT2)
	If cProg == 'CTBA102'
		//Ctba102Lan(nOpc,dDataLanc,cLote,cSubLote,cDoc,cAlias,nReg,@CTF_LOCK,;
				   //cPadrao,nTotInf,cCodSeq,STRTRAN(cHistLote, chr(13)+chr(10), " "))
	Elseif cProg == 'CTBAERC'
		Ctba101Lan(cAlias,nReg,nOpc,dDataLanc,cLote,cSubLote,cDoc,@CTF_LOCK,;
				   cPadrao,@cLinha,oLinha,oInf,nTotInf,cCodSeq,STRTRAN(cHistLote, chr(13)+chr(10), " "))
	Endif
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Destrava Todos os Registros                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
MsUnLockAll()

IF ! l102Inclui
	Ct102SmltF( Dtos( dDataLanc	) + cLote + cSubLote + cDoc  ) // libera o documento para que o proximo possa usar
ENDIF

FreeUsedCode()

If l102Altera .Or. l102Visual 
	RestArea(aAreaCT2)
EndIf

If l102Inclui .And. lContinua
	dbSelectArea("CT2")
	dbSetOrder(1)
	dbGoTop()
    MsSeek( xFilial( "CT2" ) + Dtos(dDataLanc) + cLote + cSubLote + cDoc )
EndIf

Return

//Ajusta SX1   - Carlos Daniel

Static Function AjustaSx1()
Local aHelpPor	:={}
Local aHelpEng	:={}
Local aHelpSpa	:={}

                        
Aadd ( aHelpPor, "Informe a Data Inicial"    )
Aadd( AHelpEng, "teste" )
Aadd (AHelpSpa, "teste" )

     Putsx1Help("P.CTB10201.",aHelpPor,aHelpEng,aHelpSpa)
     
 aHelpPor	:={}
 aHelpEng	:={}
 aHelpSpa	:={}

                        
Aadd ( aHelpPor, "Informe a data Final."    )
Aadd( AHelpEng, "teste" )
Aadd (AHelpSpa, "teste" )

     Putsx1Help("P.CTB10202.",aHelpPor,aHelpEng,aHelpSpa)
     
 
aHelpPor	:={}
aHelpEng	:={}
aHelpSpa	:={}
      
Aadd ( aHelpPor, "Informe o lote inicial."    )
Aadd( AHelpEng, "teste" )
Aadd (AHelpSpa, "teste" )

     Putsx1Help("P.CTB10203.",aHelpPor,aHelpEng,aHelpSpa)

aHelpPor	:={}
aHelpEng	:={}
 aHelpSpa	:={}
      
Aadd ( aHelpPor, "Informe o lote final."    )
Aadd( AHelpEng, "teste" )
Aadd (AHelpSpa, "teste" )

     Putsx1Help("P.CTB10204.",aHelpPor,aHelpEng,aHelpSpa)
     
     
aHelpPor	:={}
aHelpEng	:={}
aHelpSpa	:={}     
     
Aadd ( aHelpPor, "Informe o Sublote inicial."    )
Aadd( AHelpEng, "teste" )
Aadd (AHelpSpa, "teste" )

     Putsx1Help("P.CTB10205.",aHelpPor,aHelpEng,aHelpSpa)

aHelpPor	:={}
aHelpEng	:={}
aHelpSpa	:={}
     
Aadd ( aHelpPor, "Informe o Sublote Final."    )
Aadd( AHelpEng, "teste" )
Aadd (AHelpSpa, "teste" )

     Putsx1Help("P.CTB10206.",aHelpPor,aHelpEng,aHelpSpa) 

aHelpPor	:={}
aHelpEng	:={}
aHelpSpa	:={}
     
Aadd ( aHelpPor, "Informe 0 número do documento inicial."    )
Aadd( AHelpEng, "teste" )
Aadd (AHelpSpa, "teste" )

     Putsx1Help("P.CTB10207.",aHelpPor,aHelpEng,aHelpSpa)
     
aHelpPor	:={}
aHelpEng	:={}
aHelpSpa	:={}

Aadd ( aHelpPor, "Informe 0 número do documento Final."    )
Aadd( AHelpEng, "Informe 0 número do documento Final." )
Aadd (AHelpSpa, "Informe 0 número do documento Final." )

     Putsx1Help("P.CTB10208.",aHelpPor,aHelpEng,aHelpSpa)

aHelpPor	:={}
aHelpEng	:={}
aHelpSpa	:={}
     
Aadd ( aHelpPor, "geração de lançamento na data do lançamento original."    )
Aadd( AHelpEng, "geração de lançamento na data do lançamento original." )
Aadd (AHelpSpa, "geração de lançamento na data do lançamento original." )

     Putsx1Help("P.CTB10209.",aHelpPor,aHelpEng,aHelpSpa)

aHelpPor	:={}
aHelpEng	:={}
aHelpSpa	:={}
     
Aadd ( aHelpPor, "Informe a data do lançamento do estorno."    )
Aadd( AHelpEng, "Informe a data do lançamento do estorno." )
Aadd (AHelpSpa, "Informe a data do lançamento do estorno." )

     Putsx1Help("P.CTB10210.",aHelpPor,aHelpEng,aHelpSpa)
  
  
 aHelpPor	:={}
 aHelpEng	:={}
 aHelpSpa	:={}
     
Aadd ( aHelpPor, "Informe o número do lote desejado para o estorno."    )
Aadd( AHelpEng, "Informe o número do lote desejado para o estorno." )
Aadd (AHelpSpa, "Informe o número do lote desejado para o estorno." )

     Putsx1Help("P.CTB10211.",aHelpPor,aHelpEng,aHelpSpa)                 
   
 
 aHelpPor	:={}
 aHelpEng	:={}
 aHelpSpa	:={}
            
Aadd ( aHelpPor, "Informe o número do sublote desejado para o estorno.  "    )
Aadd( AHelpEng, "Informe o número do sublote desejado para o estorno.  " )
Aadd (AHelpSpa, "Informe o número do sublote desejado para o estorno.  " )

     Putsx1Help("P.CTB10212.",aHelpPor,aHelpEng,aHelpSpa)
 
 aHelpPor	:={}
 aHelpEng	:={}
 aHelpSpa	:={}
     
Aadd ( aHelpPor, "Informe o número do documento inicial desejado para o estorno.  "    )
Aadd( AHelpEng, "Informe o número do documento inicial desejado para o estorno.  " )
Aadd (AHelpSpa, "Informe o número do documento inicial desejado para o estorno.  " )

     Putsx1Help("P.CTB10213.",aHelpPor,aHelpEng,aHelpSpa)
 
 aHelpPor	:={}
 aHelpEng	:={}
 aHelpSpa	:={}
     
Aadd ( aHelpPor, "Informe se deseja imprimir relatório com inconsistências.    "    )
Aadd( AHelpEng, "Informe se deseja imprimir relatório com inconsistências.    " )
Aadd (AHelpSpa, "Informe se deseja imprimir relatório com inconsistências.    " )

     Putsx1Help("P.CTB10214.",aHelpPor,aHelpEng,aHelpSpa)  
     
return  
//caso escolha outra opção menu
User Function Ercrej()

MsgAlert("Para esta Função favor acessar Lancamento Contabeis!")

return  