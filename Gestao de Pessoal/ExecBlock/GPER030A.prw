#INCLUDE "GPER030.CH"
#INCLUDE "PROTHEUS.CH"
#IFNDEF CRLF
	#DEFINE CRLF ( chr(13)+chr(10) )
#ENDIF
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � GPER030  � Autor � R.H. - JANIA BRAUDES  � Data � 27.02.13 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Emissao de Recibos de Pagamento - Acrescentando modo grafico���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   � GPER030(void)                                              ���
�������������������������������������������������������������������������Ĵ��
���Parametros�                                                            ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Generico                                                   ���
�������������������������������������������������������������������������Ĵ��
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������*/

User Function GPER030(lTerminal,cFilTerminal,cMatTerminal,cMesAnoRef,nRecTipo,cSemanaTerminal)

//��������������������������������������������������������������Ŀ
//� Define Variaveis Locais (Basicas)                            �
//����������������������������������������������������������������
Local cString :="SRA"        											// alias do arquivo principal (Base)
Local aOrd    := {STR0001,STR0002,STR0003,STR0004,STR0005} 			    //"Matricula"###"C.Custo"###"Nome"###"Chapa"###"C.Custo + Nome"
Local cDesc1  := STR0006												//"Emiss�o de Recibos de Pagamento."
Local cDesc2  := STR0007												//"Ser� impresso de acordo com os parametros solicitados pelo"
Local cDesc3  := STR0008												//"usu�rio."
Local aDriver := ReadDriver()
//��������������������������������������������������������������Ŀ
//� Define Variaveis Locais (Programa)                           �
//����������������������������������������������������������������
Local nExtra,cIndCond,cIndRc
Local Baseaux := "S", cDemit := "N"
Local cHtml   := ""

//��������������������������������������������������������������Ŀ
//� Define o numero da linha de impress�o como 0                 �
//����������������������������������������������������������������
SetPrc(0,0)

//��������������������������������������������������������������Ŀ
//� Define Variaveis Private(Basicas)                            �
//����������������������������������������������������������������
Private aReturn  := {STR0009, 1,STR0010, 2, 2, 1, "",1 }	//"Zebrado"###"Administra��o"
Private nomeprog :="GPER030"
Private aLinha   := { },nLastKey := 0
Private cPerg    :="GPR030"
Private cSem_De  := "  /  /    "
Private cSem_Ate := "  /  /    "
Private nAteLim , nBaseFgts , nFgts , nBaseIr , nBaseIrFe
Private cCompac  := aDriver[1]
Private cNormal  := aDriver[2]

//��������������������������������������������������������������Ŀ
//� Define Variaveis Private(Programa)                           �
//����������������������������������������������������������������
Private aLanca 	  := {}
Private aProve 	  := {}
Private aDesco 	  := {}
Private aBases 	  := {}
Private aInfo  	  := {}
Private aCodFol	  := {}
Private li     	  := _PROW()
Private Titulo 	  := STR0011		//"EMISS�O DE RECIBOS DE PAGAMENTOS"
Private lEnvioOk  := .F.
Private lRetCanc  := .t.

//��������������������������������������������������������������Ŀ
//� Envia controle para a funcao SETPRINT                        �
//����������������������������������������������������������������
wnrel:="GPER030"            //Nome Default do relatorio em Disco

//��������������������������������������������������������������Ŀ
//� Verifica se o programa foi chamado do terminal - TCF         �
//����������������������������������������������������������������
lTerminal := If( lTerminal == Nil, .F., lTerminal )

IF !( lTerminal )
	wnrel:=SetPrint(cString,wnrel,cPerg,Titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd)
EndIF

//��������������������������������������������������������������Ŀ
//� Define a Ordem do Relatorio                                  �
//����������������������������������������������������������������
nOrdem := IF( !( lTerminal ), aReturn[8] , 1 )

//��������������������������������������������������������������Ŀ
//� Verifica as perguntas selecionadas                           �
//����������������������������������������������������������������
Pergunte("GPR030",.F.)

//��������������������������������������������������������������Ŀ
//� Carregando variaveis mv_par?? para Variaveis do Sistema.     �
//����������������������������������������������������������������
cSemanaTerminal := IF( Empty( cSemanaTerminal ) , Space( Len( SRC->RC_SEMANA ) ) , cSemanaTerminal )
dDataRef   := IF( !( lTerminal ), mv_par01 , Stod(Substr(cMesAnoRef,-4)+SubStr(cMesAnoRef,1,2)+"01"))//Data de Referencia para a impressao
nTipRel    := IF( !( lTerminal ), mv_par02 , 3)	//Tipo de Recibo (Pre/Zebrado/EMail/Grafica)
Esc        := IF( !( lTerminal ), mv_par03 , nRecTipo			)	//Emitir Recibos(Adto/Folha/1�/2�/V.Extra)
Semana     := IF( !( lTerminal ), mv_par04 , cSemanaTerminal	)	//Numero da Semana
cFilDe     := IF( !( lTerminal ),mv_par05,cFilTerminal			)	//Filial De
cFilAte    := IF( !( lTerminal ),mv_par06,cFilTerminal			)	//Filial Ate
cCcDe      := IF( !( lTerminal ),mv_par07,SRA->RA_CC			)	//Centro de Custo De
cCcAte     := IF( !( lTerminal ),mv_par08,SRA->RA_CC		   	)	//Centro de Custo Ate
cMatDe     := IF( !( lTerminal ),mv_par09,cMatTerminal			)	//Matricula Des
cMatAte    := IF( !( lTerminal ),mv_par10,cMatTerminal			)	//Matricula Ate
cNomDe     := IF( !( lTerminal ),mv_par11,SRA->RA_NOME			)	//Nome De
cNomAte    := IF( !( lTerminal ),mv_par12,SRA->RA_NOME			)	//Nome Ate
ChapaDe    := IF( !( lTerminal ),mv_par13,SRA->RA_CHAPA 		)	//Chapa De
ChapaAte   := IF( !( lTerminal ),mv_par14,SRA->RA_CHAPA 		)	//Chapa Ate
Mensag1    := mv_par15										 	    //Mensagem 1
Mensag2    := mv_par16											    //Mensagem 2
Mensag3    := mv_par17											    //Mensagem 3
cSituacao  := IF( !( lTerminal ),mv_par18, fSituacao( NIL , .F. ) )	//Situacoes a Imprimir
cCategoria := IF( !( lTerminal ),mv_par19, fCategoria( NIL , .F. ))	//Categorias a Imprimir
cBaseAux   := If(mv_par20 == 1,"S","N")							    //Imprimir Bases
nDuas      := If(mv_par21 == "N",1,2)							    //quantas vezes � para imprimir o mesmo contra-Cheque

If aReturn[5] == 1 .and. nTipRel == 1
	li	:=  0
EndIf

IF !( lTerminal )
	cMesAnoRef := StrZero(Month(dDataRef),2) + StrZero(Year(dDataRef),4)
	//��������������������������������������������������������������Ŀ
	//� Inicializa Impressao                                         �
	//����������������������������������������������������������������
	If ! fInicia(cString,nTipRel)
		Return
	Endif
EndIF

IF nTipRel==3
	IF lTerminal
		cHtml := R030Imp(.F.,wnRel,cString,cMesAnoRef,lTerminal)
	Else
		ProcGPE({|lEnd| R030IMP(@lEnd,wnRel,cString,cMesAnoRef,.f.)},,,.T.)  // Chamada do Processamento
	EndIF
Else
	RptStatus({|lEnd| R030Imp(@lEnd,wnRel,cString,cMesAnoRef,.f.)},Titulo)  // Chamada do Relatorio
EndIF

Return( IF( lTerminal , cHtml , NIL ) )

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � R030IMP  � Autor � R.H. - Ze Maria       � Data � 14.03.95 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Processamento Para emissao do Recibo                       ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   � R030Imp(lEnd,WnRel,cString,cMesAnoRef,lTerminal)			  ���
�������������������������������������������������������������������������Ĵ��
���Parametros�                                                            ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Generico                                                   ���
�������������������������������������������������������������������������Ĵ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������*/
Static Function R030Imp(lEnd,WnRel,cString,cMesAnoRef,lTerminal)

//��������������������������������������������������������������Ŀ
//� Define Variaveis Locais (Basicas)                            �
//����������������������������������������������������������������
Local lIgual                 //Vari�vel de retorno na compara�ao do SRC
Local cArqNew                //Vari�vel de retorno caso SRC # SX3
Local aOrdBag     	:= {}
Local cMesArqRef  	:= If(Esc == 4,"13"+Right(cMesAnoRef,4),cMesAnoRef)
Local cArqMov     	:= ""
Local aCodBenef   	:= {}
Local cAcessaSR1  	:= &("{ || " + ChkRH("GPER030","SR1","2") + "}")
Local cAcessaSRA  	:= &("{ || " + ChkRH("GPER030 ","SRA","2") + "}")
Local cAcessaSRC  	:= &("{ || " + ChkRH("GPER030","SRC","2") + "}")
Local cAcessaSRI  	:= &("{ || " + ChkRH("GPER030","SRI","2") + "}")
Local cNroHoras   	:= &("{ || If(SRC->RC_QTDSEM > 0, SRC->RC_QTDSEM, SRC->RC_HORAS) }")
Local cHtml		  	   := ""
Local nHoras      	:= 0
Local nMes, nAno
Local nX
Local cMesCorrente   := getmv("MV_FOLMES")
Local dDataLibRh
Local nTcfDadt		   := if(lTerminal,getmv("MV_TCFDADT"),0)		// indica o dia a partir do qual esta liberada a consulta ao TCF
Local nTcfDfol		   := if(lTerminal,getmv("MV_TCFDFOL"),0)		// indica a quantidade de dias a somar ou diminuir no ultimo dia do mes corrente para liberar a consulta do TCF
Local nTcfD131		   := if(lTerminal,getmv("MV_TCFD131"),0)		// indica o dia a partir do qual esta liberada a consulta ao TCF
Local nTcfD132		   := if(lTerminal,getmv("MV_TCFD132"),0)		// indica o dia a partir do qual esta liberada a consulta ao TCF
Local nTcfDext		   := if(lTerminal,getmv("MV_TCFDEXT"),0)		// indica o dia a partir do qual esta liberada a consulta ao TCF
Local aDriver     	:= LEDriver()
Local nContr      	:= 0 
Local nContrT     	:= 0

//Fonte A serem Utilizada
If nTipRel == 4
	Private _oFont8   := TFont():New("Arial", 09, 08,   ,.F., ,   , ,    , .F.)
	Private _oFont8b  := TFont():New("Arial", 09, 08,.t.,.t., ,   , ,    , .F.)
	Private _oFont10  := TFont():New("Arial", 09, 10,.T.,.F., 5,.T., 5, .T., .F.)
	Private _oFont10b := TFont():New("Arial", 09, 10,.T.,.t., 5,.T., 5, .T., .F.)
	Private _oFont12  := TFont():New("Arial", 09, 12,.T.,.F., 5,.T., 5, .T., .F.)
	Private _oFont14  := TFont():New("Arial", 09, 14,.T.,.T., 5,.T., 5, .T., .F.)
	Private _oFont16  := TFont():New("Arial", 09, 16,.T.,.F., 5,.T., 5, .T., .F.)
	Private _oBrush   := TBrush():New("",4)
	Private _oPrint   := TMSPrinter():New( "Recibo Laser" )
	Private _cont     := 3500
	Private  lFirst   := .t.
	Private _pag      := 0
	Private _cFig     := " " // Variavel do logo
	Private nLinhas   := 19  // Numero de Linhas do Miolo do Recibo
	
	If SUBSTR(SM0->M0_CODFIL,1,2) <> "05"
		_cFig := "\system\logogpe.jpg"
	Endif
EndIf

Private tamanho   	:= "M"
Private limite		:= 132
Private cAliasMov 	:= ""
Private cDtPago   	:= ""
Private cPict1	   	:=	"@E 999,999,999.99"
Private cPict2    	:= "@E 99,999,999.99"
Private cPict3    	:=	"@E 999,999.99"

If MsDecimais(1) == 0
	cPict1	:=	"@E 99,999,999,999"
	cPict2 	:=	"@E 9,999,999,999"
	cPict3 	:=	"@E 99,999,999"
Endif

If cPaisLoc $ "URU|ARG"
	If Esc == 3
		cMesArqRef := "13" + Right(cMesAnoRef,4)
	ElseIf Esc == 4
		cMesArqRef := "23" + Right(cMesAnoRef,4)
	Else
		cMesArqRef := cMesAnoRef
	Endif
Else
	If Esc == 4
		cMesArqRef := "13" + Right(cMesAnoRef,4)
	Else
		cMesArqRef := cMesAnoRef
	Endif
Endif

//��������������������������������������������������������������Ŀ
//| Verifica se existe o arquivo de fechamento do mes informado  |
//����������������������������������������������������������������
If !OpenSrc( cMesArqRef, @cAliasMov, @aOrdBag, @cArqMov, @dDataRef , NIL ,lTerminal )
	Return( IF( lTerminal <> NIL .And. lTerminal , cHtml , NIL ) )
Endif

//��������������������������������������������������������������Ŀ
//| Verifica se o Mes solicitado esta liberado para consulta no  |
//| terminal de consulta do funcionario.                         |
//����������������������������������������������������������������
If lTerminal
	
	If !empty(cMesCorrente)
		cMesCorrente := substr(cMesCorrente,-2)+substr(cMesCorrente,1,4)
	endif
	
	If	cMesCorrente == cMesArqRef .or. ;
		left(cMesArqRef,2) == "13" .or. ;
		right(cMesCorrente,4)+left(cMesCorrente,2) == mesano(ddataref)
		If Esc == 1 .and. day(date()) < nTCFDADT .and. !empty(nTCFDADT)
			Return( IF( lTerminal <> NIL .And. lTerminal , cHtml , NIL ) )
		ElseIf Esc == 2 .and. !empty(nTCFDFOL)
			dDataLibRh := fMontaDtTcf(cMesCorrente)
			If date() < dDataLibRH
				Return( IF( lTerminal <> NIL .And. lTerminal , cHtml , NIL ) )
			Endif
		ElseIf Esc == 3 .and. day(date()) < nTCFD131 .and. !empty(nTCFD131)
			Return( IF( lTerminal <> NIL .And. lTerminal , cHtml , NIL ) )
		ElseIf Esc == 4 .and. day(date()) < nTCFD132 .and. !empty(nTCFD132)
			Return( IF( lTerminal <> NIL .And. lTerminal , cHtml , NIL ) )
		ElseIf Esc == 5 .and. day(date()) < nTCFDEXT .and. !empty(nTCFDEXT)
			Return( IF( lTerminal <> NIL .And. lTerminal , cHtml , NIL ) )
		endif
	Endif
Endif
If cPaisLoc == "ARG"
	nMes := Month(dDataRef) - 1
	nAno := Year(dDataRef)
	If nMes == 0
		nMes := 1
		nAno := nAno - 1
	Endif
	If nMes < 0
		nMes := 12 - ( nMes * -1 )
		nAno := nAno - 1
	Endif
	If Esc == 1 .or. Esc == 2
		cAnoMesAnt := StrZero(nAno,4)+StrZero(nMes,2)
	ElseIf Esc == 3 .or. Esc == 4
		cAnoMesAnt := Right(cMesAnoRef,4)-1	+"13"
	Endif
Endif

//��������������������������������������������������������������Ŀ
//� Selecionando a Ordem de impressao escolhida no parametro.    �
//����������������������������������������������������������������
dbSelectArea( "SRA")
IF !( lTerminal )
	If nOrdem == 1
		dbSetOrder(1)
	ElseIf nOrdem == 2
		dbSetOrder(2)
	ElseIf nOrdem == 3
		dbSetOrder(3)
	Elseif nOrdem == 4
		cArqNtx  := CriaTrab(NIL,.f.)
		cIndCond :="RA_Filial + RA_Chapa + RA_Mat"
		IndRegua("SRA",cArqNtx,cIndCond,,,STR0012)		//"Selecionando Registros..."
	ElseIf nOrdem == 5
		dbSetOrder(8)
	Endif
	
	dbGoTop()
	
	If nTipRel == 2
		@ LI,00 PSAY AvalImp(Limite)
	Endif
EndIF

//��������������������������������������������������������������Ŀ
//� Selecionando o Primeiro Registro e montando Filtro.          �
//����������������������������������������������������������������
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
Endif

dbSelectArea("SRA")
//��������������������������������������������������������������Ŀ
//� Carrega Regua Processamento                                  �
//����������������������������������������������������������������
IF nTipRel # 3
	SetRegua(RecCount())	// Total de elementos da regua
Else
	IF !( lTerminal )
		GPProcRegua(RecCount())// Total de elementos da regua
	EndIF
EndIF

TOTVENC   := TOTDESC:= FLAG:= CHAVE := 0
Desc_Fil  := Desc_End := DESC_CC:= DESC_FUNC:= ""
Desc_Comp := Desc_Est := Desc_Cid:= ""
DESC_MSG1 := DESC_MSG2:= DESC_MSG3:= Space(01)
cFilialAnt:= "  "
Vez       := 0
OrdemZ    := 0

While SRA->( !Eof() .And. &cInicio <= cFim )
	
	//��������������������������������������������������������������Ŀ
	//� Movimenta Regua Processamento                                �
	//����������������������������������������������������������������
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
		//��������������������������������������������������������������Ŀ
		//� Consiste Parametrizacao do Intervalo de Impressao            �
		//����������������������������������������������������������������
		If (SRA->RA_CHAPA < ChapaDe) .Or. (SRA->Ra_CHAPa > ChapaAte) .Or. ;
			(SRA->RA_NOME < cNomDe)    .Or. (SRA->Ra_NOME > cNomAte)    .Or. ;
			(SRA->RA_MAT < cMatDe)     .Or. (SRA->Ra_MAT > cMatAte)     .Or. ;
			(SRA->RA_CC < cCcDe)       .Or. (SRA->Ra_CC > cCcAte)
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
	
	//��������������������������������Ŀ
	//� Verifica Data Demissao         �
	//����������������������������������
	cSitFunc := SRA->RA_SITFOLH
	dDtPesqAf:= CTOD("01/" + Left(cMesAnoRef,2) + "/" + Right(cMesAnoRef,4),"DDMMYY")
	
	If cSitFunc == "D" .And. (!Empty(SRA->RA_DEMISSA) .And. MesAno(SRA->RA_DEMISSA) > MesAno(dDtPesqAf))
		cSitFunc := " "
	Endif
	
	IF !( lTerminal )
		
		//��������������������������������������������������������������Ŀ
		//� Consiste situacao e categoria dos funcionarios			     |
		//����������������������������������������������������������������
		If !( cSitFunc $ cSituacao ) .OR.  ! ( SRA->RA_CATFUNC $ cCategoria )
			dbSkip()
			Loop
		Endif
		If cSitFunc $ "D" .And. Mesano(SRA->RA_DEMISSA) # Mesano(dDataRef)
			dbSkip()
			Loop
		Endif
		
		//��������������������������������������������������������������Ŀ
		//� Consiste controle de acessos e filiais validas				 |
		//����������������������������������������������������������������
		If !(SRA->RA_FILIAL $ fValidFil()) .Or. !Eval(cAcessaSRA)
			dbSkip()
			Loop
		EndIf
		
	EndIF
	
	If SRA->RA_Filial # cFilialAnt
		If ! Fp_CodFol(@aCodFol,Sra->Ra_Filial) .Or. ! fInfo(@aInfo,Sra->Ra_Filial)
			Exit
		Endif
		Desc_Fil := aInfo[3]
		Desc_End := Alltrim(aInfo[4])                // Dados da Filial
		Desc_CGC := "CNPJ: " + Transform(aInfo[8], "@R 99.999.999/9999-99") //CGC aInfo[8]
		Desc_IE :=  "I.E.: " + Transform(ainfo[9], "@R 999.999.999.999") // IE
		DESC_MSG1:= DESC_MSG2:= DESC_MSG3:= Space(01)
		Desc_Est := Alltrim(Substr(fDesc("SX5","12"+aInfo[6],"X5DESCRI()"),1,12))
		Desc_Comp:= Alltrim(aInfo[14])        			// Complemento Cobranca
		Desc_Cid := Alltrim(aInfo[05])
		Desc_CEP := "CEP: " + Transform(ainfo[7], "@R 99999-999") // CEP
		Desc_Bairro := Alltrim(aInfo[13])
		
		// MENSAGENS
		If MENSAG1 # SPACE(1)
			If FPHIST82(SRA->RA_FILIAL,"06",SRA->RA_FILIAL+MENSAG1)
				DESC_MSG1 := Left(SRX->RX_TXT,30)
			ElseIf FPHIST82(SRA->RA_FILIAL,"06","  "+MENSAG1)
				DESC_MSG1 := Left(SRX->RX_TXT,30)
			Endif
		Endif
		
		If MENSAG2 # SPACE(1)
			If FPHIST82(SRA->RA_FILIAL,"06",SRA->RA_FILIAL+MENSAG2)
				DESC_MSG2 := Left(SRX->RX_TXT,30)
			ElseIf FPHIST82(SRA->RA_FILIAL,"06","  "+MENSAG2)
				DESC_MSG2 := Left(SRX->RX_TXT,30)
			Endif
		Endif
		
		If MENSAG3 # SPACE(1)
			If FPHIST82(SRA->RA_FILIAL,"06",SRA->RA_FILIAL+MENSAG3)
				DESC_MSG3 := Left(SRX->RX_TXT,30)
			ElseIf FPHIST82(SRA->RA_FILIAL,"06","  "+MENSAG3)
				DESC_MSG3 := Left(SRX->RX_TXT,30)
			Endif
		Endif
		dbSelectArea("SRA")
		cFilialAnt := SRA->RA_FILIAL
	Endif
	
	Totvenc := Totdesc := 0
	
	If Esc == 1 .OR. Esc == 2
		dbSelectArea("SRC")
		dbSetOrder(1)
		If dbSeek(SRA->RA_FILIAL + SRA->RA_MAT)
			While !Eof() .And. SRC->RC_FILIAL+SRC->RC_MAT == SRA->RA_FILIAL+SRA->RA_MAT
				If SRC->RC_SEMANA # Semana
					dbSkip()
					Loop
				Endif
				If !Eval(cAcessaSRC)
					dbSkip()
					Loop
				EndIf
				If (Esc == 1) .And. (Src->Rc_Pd == aCodFol[7,1])      // Desconto de Adto
					fSomaPdRec("P",aCodFol[6,1],Eval(cNroHoras),SRC->RC_VALOR)
					TOTVENC += Src->Rc_Valor
				Elseif (Esc == 1) .And. (Src->Rc_Pd == aCodFol[12,1])
					fSomaPdRec("D",aCodFol[9,1],Eval(cNroHoras),SRC->RC_VALOR)
					TOTDESC += SRC->RC_VALOR
				Elseif (Esc == 1) .And. (Src->Rc_Pd == aCodFol[8,1])
					fSomaPdRec("P",aCodFol[8,1],Eval(cNroHoras),SRC->RC_VALOR)
					TOTVENC += SRC->RC_VALOR
				Else
					If PosSrv( Src->Rc_Pd , SRA->RA_FILIAL , "RV_TIPOCOD" ) == "1"
						If (Esc # 1) .Or. (Esc == 1 .And. SRV->RV_ADIANTA == "S")
							If cPaisLoc == "PAR" .and. Eval(cNroHoras) == 30
								LocGHabRea(Ctod("01/"+SubStr(DTOC(dDataRef),4)), Ctod(StrZero(F_ULTDIA(dDataRef),2)+"/"+Strzero(Month(dDataRef),2)+"/"+right(str(Year(dDataRef)),2),"ddmmyy"),@nHoras)
							Else
								nHoras := Eval(cNroHoras)
							Endif
							fSomaPdRec("P",SRC->RC_PD,nHoras,SRC->RC_VALOR)
							TOTVENC += Src->Rc_Valor
						Endif
					Elseif SRV->RV_TIPOCOD == "2"
						If (Esc # 1) .Or. (Esc == 1 .And. SRV->RV_ADIANTA == "S")
							fSomaPdRec("D",SRC->RC_PD,Eval(cNroHoras),SRC->RC_VALOR)
							TOTDESC += Src->Rc_Valor
						Endif
					Elseif SRV->RV_TIPOCOD == "3"
						If (Esc # 1) .Or. (Esc == 1 .And. SRV->RV_ADIANTA == "S")
							fSomaPdRec("B",SRC->RC_PD,Eval(cNroHoras),SRC->RC_VALOR)
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
	Elseif Esc == 3 .And. !(cPaisLoc $ "URU|ARG")
		//��������������������������������������������������������������Ŀ
		//� Busca os codigos de pensao definidos no cadastro beneficiario�
		//����������������������������������������������������������������
		fBusCadBenef(@aCodBenef, "131",{aCodfol[172,1]})
		dbSelectArea("SRC")
		dbSetOrder(1)
		If dbSeek(SRA->RA_FILIAL + SRA->RA_MAT)
			While !Eof() .And. SRA->RA_FILIAL + SRA->RA_MAT == SRC->RC_FILIAL + SRC->RC_MAT
				If !Eval(cAcessaSRC)
					dbSkip()
					Loop
				EndIf
				If SRC->RC_PD == aCodFol[22,1]
					fSomaPdRec("P",SRC->RC_PD,Eval(cNroHoras),SRC->RC_VALOR)
					TOTVENC += SRC->RC_VALOR
				Elseif Ascan(aCodBenef, { |x| x[1] == SRC->RC_PD }) > 0
					fSomaPdRec("D",SRC->RC_PD,Eval(cNroHoras),SRC->RC_VALOR)
					TOTDESC += SRC->RC_VALOR
				Elseif SRC->RC_PD == aCodFol[108,1] .Or. SRC->RC_PD == aCodFol[109,1] .Or. SRC->RC_PD == aCodFol[173,1]
					fSomaPdRec("B",SRC->RC_PD,Eval(cNroHoras),SRC->RC_VALOR)
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
	Elseif Esc == 4 .or. If(cPaisLoc $ "URU|ARG", Esc ==3,.F.)
		dbSelectArea("SRI")
		dbSetOrder(2)
		If dbSeek(SRA->RA_FILIAL + SRA->RA_CC + SRA->RA_MAT)
			While !Eof() .And. SRA->RA_FILIAL + SRA->RA_CC + SRA->RA_MAT == SRI->RI_FILIAL + SRI->RI_CC + SRI->RI_MAT
				If !Eval(cAcessaSRI)
					dbSkip()
					Loop
				EndIf
				If PosSrv( SRI->RI_PD , SRA->RA_FILIAL , "RV_TIPOCOD" ) == "1"
					fSomaPdRec("P",SRI->RI_PD,SRI->RI_HORAS,SRI->RI_VALOR)
					TOTVENC = TOTVENC + SRI->RI_VALOR
				Elseif SRV->RV_TIPOCOD == "2"
					fSomaPdRec("D",SRI->RI_PD,SRI->RI_HORAS,SRI->RI_VALOR)
					TOTDESC = TOTDESC + SRI->RI_VALOR
				Elseif SRV->RV_TIPOCOD == "3"
					fSomaPdRec("B",SRI->RI_PD,SRI->RI_HORAS,SRI->RI_VALOR)
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
				Elseif SRV->RV_TIPOCOD == "3"
					fSomaPdRec("B",SR1->R1_PD,SR1->R1_HORAS,SR1->R1_VALOR)
				Endif
				dbskip()
			Enddo
		Endif
	Endif
	If cPaisLoc == "ARG"
		dbSelectArea("SRD")
		If dbSeek(SRA->RA_FILIAL + SRA->RA_MAT)
			While !Eof() .And. (SRA->RA_FILIAL+SRA->RA_MAT == SRD->RD_FILIAL+SRD->RD_MAT)
				If (SRA->RA_FILIAL+SRA->RA_MAT == SRD->RD_FILIAL+SRD->RD_MAT).And. SRD->RD_DATARQ == cAnoMesAnt
					If Esc == 1 .Or. Esc == 2
						cDtPago := dtoc(SRD->RD_DATPGT)
					ElseIf Esc == 3
						If SRD->RD_TIPO2 == "P"
							cDtPago := dtoc(SRD->RD_DATPGT)
						Endif
					ElseIf Esc == 4
						If SRD->RD_TIPO2 == "S"
							cDtPago := dtoc(SRD->RD_DATPGT)
						Endif
					Endif
				Endif
				dbSkip()
			Enddo
		Endif
	Endif
	dbSelectArea("SRA")
	
	If TOTVENC = 0 .And. TOTDESC = 0
		dbSkip()
		Loop
	Endif
	
	If Vez == 0  .And.  Esc == 2 //--> Verifica se for FOLHA.
		PerSemana() // Carrega Datas referentes a Semana.
	EndIf
	
	If nTipRel == 1 .and. !( lTerminal )
		fImpressao()   // Impressao do Recibo de Pagamento
		IF !( lTerminal )
			If Vez = 0  .and. nTipRel # 3  .and. aReturn[5] # 1
				//��������������������������������������������������������������Ŀ
				//� Descarrega teste de impressao                                �
				//����������������������������������������������������������������
				fImpTeste(cString)
				If !lRetCanc
					Exit
				Endif
				TotDesc := TotVenc := 0
				If mv_par01 = 2
					Loop
				Endif
			ENDIF
		EndIF
	ElseIf nTipRel == 2 .and. !( lTerminal )
		
		For nX := 1 to If(cPaisLoc <> "ARG",2,2)
			// Salta linha e espa�o para cortar
			if nx == 2
				Li += 2
				@ LI,00 PSAY "*"+REPLICATE("-",130)+"*"
				Li += 2
			EndIf
			fImpreZebr()
		Next nX
		
		ASize(AProve,0)
		ASize(ADesco,0)
		ASize(aBases,0)
	ElseIf nTipRel == 3 .or. lTerminal
		cHtml := fSendDPgto(lTerminal)   //Monta o corpo do e-mail e envia-o
	ElseIf nTipRel == 4
		For nx := 1 to nDuas // quantas vezes ser� impresso o mesmo funcion�rio
			fImpGrf() // Imprime Holerit Grafico
		Next
	Endif
	
	dbSelectArea("SRA")
	SRA->( dbSkip() )
	TOTDESC := TOTVENC := 0
	
EndDo

//��������������������������������������������������������������Ŀ
//� Seleciona arq. defaut do Siga caso Imp. Mov. Anteriores      �
//����������������������������������������������������������������
If !Empty( cAliasMov )
	fFimArqMov( cAliasMov , aOrdBag , cArqMov )
EndIf

If nTipRel == 4 .and. !lfirst
	_oPrint:EndPage()     // Finaliza a p�gina
	_oPrint:Preview()     // Visualiza antes de imprimir
EndIf

IF !( lTerminal ) .and. nTipRel <> 4
	
	//��������������������������������������������������������������Ŀ
	//� Termino do relatorio                                         �
	//����������������������������������������������������������������
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
	
	Set Device To Screen
	
	If lEnvioOK
		APMSGINFO(STR0042)
	ElseIf nTipRel== 3
		APMSGINFO(STR0043)
	EndIf
	SeTPgEject(.F.)
	nlin:= 0
	If aReturn[5] = 1 .and. nTipRel # 3
		Set Printer To
		Commit
		ourspool(wnrel)
	Endif
	MS_FLUSH()
EndIF

Return( cHtml )

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �fImpressao� Autor � R.H. - Ze Maria       � Data � 14.03.95 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � IMRESSAO DO RECIBO FORMULARIO CONTINUO                     ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   � fImpressao()                                               ���
�������������������������������������������������������������������������Ĵ��
���Parametros�                                                            ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Generico                                                   ���
�������������������������������������������������������������������������Ĵ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������*/
Static Function fImpressao()
Local nConta  := 0
Local nContr  := 0
Local nContrT :=0
Private nLinhas:=16              // Numero de Linhas do Miolo do Recibo

Ordem_Rel := 1

If cPaisLoc == "ARG"
	fCabecArg()
Else
	fCabec()
Endif

For nConta = 1 To Len(aLanca)
	fLanca(nConta)
	nContr ++
	nContrT ++
	If nContr = nLinhas .And. nContrT < Len(aLanca)
		nContr:=0
		Ordem_Rel ++
		fContinua()
		If cPaisLoc == "ARG"
			fCabecArg()
		Else
			fCabec()
		Endif
	Endif
Next nConta
Li:=Li-2 //HOJE  -1
Li+=(nLinhas-nContr)
If cPaisLoc == "ARG"
	@ ++LI,01 PSAY TRANS(TOTVENC,cPict1)
	@ LI,44 PSAY TRANS(TOTDESC,cPict1)
	@ LI,88 PSAY TRANS((TOTVENC-TOTDESC),cPict1)
	Li +=2
	@ Li,01 PSAY MesExtenso(MONTH(dDataRef)) + " de "+ STR(YEAR(dDataRef),4)
	@ ++Li,01 PSAY EXTENSO(TOTVENC-TOTDESC,,,)+REPLICATE("*",130-LEN(EXTENSO(TOTVENC-TOTDESC,,,)))
	@ ++Li,01 PSAY StrZero(Day(dDataRef),2) + " de " + MesExtenso(MONTH(dDataRef)) + " de "+STR(YEAR(dDataRef),4)
	@ ++Li,01 PSAY TRANS((TOTVENC-TOTDESC),cPict1)
Else
	fRodape()
Endif

Return Nil


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �fImpreZebr� Autor � R.H. - Ze Maria       � Data � 14.03.95 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � IMRESSAO DO RECIBO FORMULARIO ZEBRADO                      ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   � fImpreZebr()                                               ���
�������������������������������������������������������������������������Ĵ��
���Parametros�                                                            ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Generico                                                   ���
�������������������������������������������������������������������������Ĵ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������*/
Static Function fImpreZebr()
Local nConta    := nContr := nContrT:=0

If li >= 70
	li := 0
Endif

If cPaisLoc == "ARG"
	fCabecZAr()
Else
	fCabecZ()
Endif

fLancaZ(nConta)
Return Nil

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �fCabec    � Autor � R.H. - Ze Maria       � Data � 14.03.95 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � IMRESSAO Cabe�alho Form Continuo                           ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   � fCabec()                                                   ���
�������������������������������������������������������������������������Ĵ��
���Parametros�                                                            ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Generico                                                   ���
�������������������������������������������������������������������������Ĵ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������*/
Static Function fCabec()   		// Cabecalho do Recibo

Local cCodFunc		:= ""		//-- codigo da Funcao do funcionario
Local cDescFunc	:= ""		//-- Descricao da Funcao do Funcionario

/*
��������������������������������������������������������������Ŀ
� Carrega Funcao do Funcion. de acordo com a Dt Referencia     �
����������������������������������������������������������������*/
fBuscaFunc(dDataRef, @cCodFunc, @cDescFunc   )

AcDescFunc := Alltrim(Posicione("SRJ", 1, xFilial("SRJ") + alltrim(cCodFunc), "RJ_DESC"))

// Verifica se for a primeir impress�o envia o comando de compactar a impressora

@ LI,00 PSAY &cCompac
//LI ++

@ LI,02 PSAY DESC_Fil
//LI ++
//@ LI,02 PSAY DESC_END
LI ++
@ LI,02 PSAY Transform(aInfo[8], "@R 99.999.999/9999-99") // DESC_CGC
LI ++

cDescCC := AllTrim(DescCc(SRA->RA_CC,SRA->RA_FILIAL)) + " - " + Alltrim(aInfo[1])
@ LI,002 PSAY cDescCC
If Esc == 1  //Adiantamento Salarial
	@ LI,090 PSAY "Adto Salarial"
ElseIf Esc == 2 // Folha Mensal
	@ LI,090 PSAY "Mensal"
ElseIf Esc == 3 // 1� Parcela do 13o Sal�rio
	@ LI,090 PSAY "1a. Parcela 13o Salario"
ElseIf Esc == 4 // 13o. Sal�rio 2o.Parc.
	@ LI,090 PSAY "2a. Parcela 13o Salario"
Endif

If !Empty(Semana) .And. Semana # '99' .And.  Upper(SRA->RA_TIPOPGT) == 'S'
	@ Li,37 pSay STR0013 + Semana + ' (' + cSem_De + STR0014 + ;	//'Semana '###' a '
	cSem_Ate + ')'
Else
	@ LI,55 PSAY MesExtenso(MONTH(dDataRef))+"/"+STR(YEAR(dDataRef),4)
EndIf

LI +=2 //3 HOJE
@ LI, 01 PSAY SRA->RA_MAT
@ LI, 11 PSAY Left(SRA->RA_NOME,50)
@ LI, 65 PSAY "Funcao: " +  Alltrim(cCodFunc) + " - " + AcDescFunc
// @ LI,103 PSAY ORDEM_REL PICTURE "9999"

//@ LI,37 PSAY fCodCBO(SRA->RA_FILIAL,cCodFunc ,dDataRef)
//@ LI,44 PSAY SRA->RA_Filial
//@ LI,54 PSAY SRA->RA_CC
// LI ++
//cDet := STR0015       + cCodFunc						//-- Funcao
//cDet += cDescFunc     + ' '
//cDet += DescCc(SRA->RA_CC,SRA->RA_FILIAL) + ' '
//cDet += STR0016 + SRA->RA_CHAPA					//'CHAPA: '
// @ Li,01 pSay cDet

Li += 4 //HOJE 3
Return Nil

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �fCabecz   � Autor � R.H. - Ze Maria       � Data � 14.03.95 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � IMRESSAO Cabe�alho Form ZEBRADO                            ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   � fCabecz()                                                  ���
�������������������������������������������������������������������������Ĵ��
���Parametros�                                                            ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Generico                                                   ���
�������������������������������������������������������������������������Ĵ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������*/
Static Function fCabecZ()   // Cabecalho do Recibo Zebrado

Local cCodFunc		:= ""		//-- codigo da Funcao do funcionario
Local cDescFunc	:= ""		//-- Descricao da Funcao do Funcionario
Local OBMP
/*
����������������������������������������������������������������Ŀ
� Carrega Funcao do Funcion. de acordo com a Dt Referencia       �
������������������������������������������������������������������
*/
fBuscaFunc(dDataRef, @cCodFunc, @cDescFunc   )

@ Li,00 PSAY Avalimp(Limite)
LI ++
@ LI,00 PSAY "*"+REPLICATE("=",130)+"*"

LI ++
@ LI,00  PSAY  "|"
@ LI,46  PSAY STR0017		//"RECIBO DE PAGAMENTO  "
@ LI,131 PSAY "|"

LI ++
@ LI,00 PSAY "|"+REPLICATE("-",130)+"|"

LI ++
@ LI,00  PSAY STR0018 +  DESC_Fil		//"| Empresa   : "
@ LI,92  PSAY STR0019 + SRA->RA_FILIAL	//" Local : "
@ LI,131 PSAY "|"

LI ++
@ LI,00 PSAY STR0020 + SRA->RA_CC + " - " + Posicione("CTT",1,xFilial("CTT") + SRA->RA_CC, "CTT_DESC01") // DescCc(SRA->RA_CC,SRA->RA_FILIAL)	//"| C Custo   : "
If !Empty(Semana) .And. Semana # "99" .And.  Upper(SRA->RA_TIPOPGT) == "S"
	@ Li,92 pSay STR0021 + Semana + " (" + cSem_De + STR0022 + ;   //'Sem.'###' a '
	cSem_Ate + ")"
Else
	@ LI,92 PSAY MesExtenso(MONTH(dDataRef))+"/"+STR(YEAR(dDataRef),4)
EndIf
@ LI,131 PSAY "|"

LI ++
ORDEMZ ++
@ LI,00  PSAY STR0023 + SRA->RA_MAT		//"| Matricula : "
@ LI,30  PSAY STR0024 + SRA->RA_NOME	//"Nome  : "
@ LI,92  PSAY STR0025						//"Ordem : "
@ LI,100 PSAY StrZero(ORDEMZ,4) Picture "9999"

@ LI,131 PSAY "|"

LI ++
@ LI,00  PSAY STR0026+cCodFunc+" - "+cDescFunc											//"| Funcao    : "

@ LI,131 PSAY "|"

LI ++
@ LI,00 PSAY "|"+REPLICATE("-",130)+"|"

LI ++
@ LI,000 PSAY STR0027		//"| P R O V E N T O S "
@ LI,044 PSAY STR0028		//"  D E S C O N T O S"
@ LI,088 PSAY STR0029		//"  B A S E S"
@ LI,131 PSAY "|"

LI ++
@ LI,00 PSAY "|"+REPLICATE("-",130)+"|"
LI++
Return Nil

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �fCabecArg �Autor  �Silvia Taguti       � Data �  02/12/03   ���
�������������������������������������������������������������������������͹��
���Desc.     �Impressao do Cabecalho - Argentina                          ���
���          �Pre Impresso                                                ���
�������������������������������������������������������������������������͹��
���Uso       � AP6                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function fCabecArg()
Local cCodFunc		:= ""		//-- codigo da Funcao do funcionario
Local cDescFunc		:= ""		//-- Descricao da Funcao do Funcionario
Local cCargo		:= ""		//-- Codigo do Cargo do funcionario

/*��������������������������������������������������������������Ŀ
� Carrega Funcao do Funcion. de acordo com a Dt Referencia     �
����������������������������������������������������������������*/
fBuscaFunc(dDataRef, @cCodFunc, @cDescFunc   )

@ ++LI,01 PSAY DESC_Fil
@ ++LI,01 PSAY Alltrim(Desc_End)+" "+Alltrim(Desc_Comp)+" "+Desc_Cid
@ ++LI,01 PSAY DESC_CGC
@ ++LI,01 PSAY cDtPago
//@ LI,20 PSAY STR0072
@ LI,40 PSAY Alltrim(SRA->RA_BCDEPSAL) + "-" + DescBco(SRA->RA_BCDEPSAL,SRA->RA_FILIAL)
Li +=2
@ Li,01 PSAY SRA->RA_NOME
@ Li,45 PSAY SRA->RA_CIC
@ ++Li,01 PSAY SRA->RA_ADMISSA
@ Li,12 PSAY Substr(cDescFunc,1,15)
cCargo := fGetCargo(SRA->RA_MAT)
@ Li,30 PSAY Substr(fDesc("SQ3",cCargo,"SQ3->Q3_DESCSUM"),1,10)
Li += 2

Return Nil


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �fCabecZAr �Autor  �Microsiga           � Data �  02/12/03   ���
�������������������������������������������������������������������������͹��
���Desc.     � Impressao do Cabecalho - Argentina                         ���
���          � Zebrado                                                    ���
�������������������������������������������������������������������������͹��
���Uso       � AP6                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function fCabecZAr()
Local cCodFunc		:= ""		//-- codigo da Funcao do funcionario
Local cDescFunc		:= ""		//-- Descricao da Funcao do Funcionario
Local cCargo		:= ""		//-- Codigo do Cargo do Funcionario

/*��������������������������������������������������������������Ŀ
� Carrega Funcao do Funcion. de acordo com a Dt Referencia     �
����������������������������������������������������������������*/
fBuscaFunc(dDataRef, @cCodFunc, @cDescFunc   )


@ ++LI,00 PSAY "*"+REPLICATE("=",130)+"*"

@ ++LI,00  PSAY  "|"
@ LI,46  PSAY "RECIBO DE PAGAMENTO  "
@ LI,131 PSAY "|"

@ ++LI,00 PSAY "|"+REPLICATE("-",130)+"|"

@ ++LI,00  PSAY "| Empregador   : " + DESC_Fil		//"| Empregador   : "
@ LI,131 PSAY "|"

@ ++LI,00  PSAY " Domicilio : " + Alltrim(Desc_End)+" "+Alltrim(Desc_Comp)+"-"+Desc_Est	//" Domicilio : "
@ LI,131 PSAY "|"

@ ++Li,00 PSAY "CNPJ: " + DESC_CGC
@ LI,131 PSAY "|"

@ ++LI,00 PSAY "Data Pagto: " + cDtPago
// @ LI,35 PSAY STR0072
@ LI,70 PSAY "Ag. Conta: " + Alltrim(SRA->RA_BCDEPSAL) + "-" + DescBco(SRA->RA_BCDEPSAL,SRA->RA_FILIAL)
@ LI,131 PSAY "|"
@ ++LI,00 PSAY "|"+REPLICATE("-",130)+"|"
@ ++Li,00 PSAY "Nome: " + SRA->RA_NOME
@ Li,45 PSAY "CPF: " + SRA->RA_CIC
@ LI,130 PSAY "|"

@ ++Li,00 PSAY "Admiss�o: " + DTOC(SRA->RA_ADMISSA)
@ Li,30  PSAY "Fun��o: " + Substr(cDescFunc ,1,15)
cCargo := fGetCargo(SRA->RA_MAT)
@ Li,80 PSAY "Cargo: " + Substr(fDesc("SQ3",cCargo,"SQ3->Q3_DESCSUM"),1,6)
@ LI,131 PSAY "|"
LI ++
@ LI,00 PSAY "|"+REPLICATE("-",130)+"|"

LI ++
@ LI,000 PSAY "| H A B E R E S "
@ LI,046 PSAY "  D E D U C C I O N E S"
@ LI,090 PSAY STR0029		//"  B A S E S
@ LI,131 PSAY "|"

LI ++
@ LI,00 PSAY "|"+REPLICATE("-",130)+"|"
LI++

Return Nil

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �fLanca    � Autor � R.H. - Ze Maria       � Data � 14.03.95 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Impressao das Verbas (Lancamentos) Form. Continuo          ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   � fLanca()                                                   ���
�������������������������������������������������������������������������Ĵ��
���Parametros�                                                            ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Generico                                                   ���
�������������������������������������������������������������������������Ĵ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������*/
Static Function fLanca(nConta)   // Impressao dos Lancamentos

Local cString := Transform(aLanca[nConta,5],cPict2)
Local nCol := If(aLanca[nConta,1]="P", 75, If(aLanca[nConta,1]="D", 95, 61))

@ LI,01 PSAY aLanca[nConta,2]
@ LI,07 PSAY aLanca[nConta,3]  //LI,05  HOJE

If aLanca[nConta,1] # "B"        // So Imprime se nao for base
	@ LI,61 PSAY TRANSFORM(aLanca[nConta,4],"999.99")
Endif

@ LI,nCol PSAY cString
Li ++

Return Nil

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �fLancaZ   � Autor � R.H. - Ze Maria       � Data � 14.03.95 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Impressao das Verbas (Lancamentos) Zebrado                 ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   � fLancaZ()                                                  ���
�������������������������������������������������������������������������Ĵ��
���Parametros�                                                            ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Generico                                                   ���
�������������������������������������������������������������������������Ĵ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������*/
Static Function fLancaZ(nConta)   // Impressao dos Lancamentos

Local nTermina  := 0
Local nCont     := 0
Local nCont1    := 0
Local nValidos  := 0

nTermina := Max(Max(LEN(aProve),LEN(aDesco)),LEN(aBases))

For nCont := 1 To nTermina
	@ LI,00 PSAY "|"
	IF nCont <= LEN(aProve)
		@ LI,02 PSAY aProve[nCont,1]+TRANSFORM(aProve[nCont,2],'999.99')+TRANSFORM(aProve[nCont,3],cPict3)
	ENDIF
	@ LI,44 PSAY "|"
	IF nCont <= LEN(aDesco)
		@ LI,46 PSAY aDesco[nCont,1]+TRANSFORM(aDesco[nCont,2],'999.99')+TRANSFORM(aDesco[nCont,3],cPict3)
	ENDIF
	@ LI,88 PSAY "|"
	IF nCont <= LEN(aBases)
		@ LI,90 PSAY aBases[nCont,1]+TRANSFORM(aBases[nCont,2],'999.99')+TRANSFORM(aBases[nCont,3],cPict3)
	ENDIF
	@ LI,131 PSAY "|"
	
	//---- Soma 1 nos nValidos e Linha
	nValidos ++
	Li ++
	
	If nValidos = If(cPaisLoc <> "ARG",14,10)
		@ LI,00 PSAY "|"+REPLICATE("-",130)+"|"
		LI ++
		@ LI,00 PSAY "|"
		@ LI,05 PSAY STR0030			// "CONTINUA !!!"
		//		@ LI,76 PSAY "|"+&cCompac
		LI ++
		@ LI,00 PSAY "*"+REPLICATE("=",130)+"*"
		LI += 8
		If li >= 60
			li := 0
		Endif
		If cPaisLoc == "ARG"
			fCabecZAr()
		Else
			fCabecZ()
		Endif
		nValidos := 0
	ENDIF
Next nCont

For nCont1 := nValidos+1 To If(cPaisLoc <> "ARG",14,10)
	@ Li,00  PSAY "|"
	@ Li,44  PSAY "|"
	@ Li,88  PSAY "|"
	@ Li,131 PSAY "|"
	Li++
Next nCont1

If cPaisLoc <> "ARG"
	@ LI,00 PSAY "|"+REPLICATE("-",130)+"|"
	LI ++
	@ LI,000 PSAY "|"
	@ LI,005 PSAY DESC_MSG1
	@ LI,044 PSAY STR0031+SPACE(10)+TRANS(TOTVENC,cPict1)	//"| TOTAL BRUTO     "
	@ LI,088 PSAY "|"+STR0032+SPACE(07)+TRANS(TOTDESC,cPict1)	//" TOTAL DESCONTOS     "
	@ LI,131 PSAY "|"
	LI ++
	@ LI,000 PSAY "|"
	@ LI,005 PSAY DESC_MSG2
	@ LI,044 PSAY "|"+REPLICATE("-",86)+"|"
	
	LI ++
	@ LI,000 PSAY "|"
	@ LI,005 PSAY DESC_MSG3
	@ LI,044 PSAY STR0033+SRA->RA_BCDEPSA + "- Nao Cadastrado "  // DescBco(SRA->RA_BCDEPSAL,SRA->RA_FILIAL)	//"| CREDITO:"
	@ LI,088 PSAY STR0034+SPACE(05)+TRANS((TOTVENC-TOTDESC),cPict1)			//"| LIQUIDO A RECEBER     "
	@ LI,131 PSAY "|"
	
	LI ++
	@ LI,000 PSAY "|"+REPLICATE("-",130)+"|"
	
	LI ++
	@ LI,000 PSAY "|"
	@ LI,034 PSAY STR0035 + SRA->RA_CTDEPSAL		//"| CONTA:"
	@ LI,088 PSAY "|"
	@ LI,131 PSAY "|"
	
	LI ++
	@ LI,000 PSAY "|"+REPLICATE("-",130)+"|"
	
	LI ++
	@ LI,00  PSAY STR0036 + Replicate("_",40)		//"| Recebi o valor acima em ___/___/___ "
	@ li,131 PSAY "|"
	
	LI ++
	@ LI,00 PSAY "*"+REPLICATE("=",130)+"*"
Else
	fRodapeAr()
Endif

Li += 1

//Quebrar pagina
If LI > 70
	LI := 0
EndIf
Return Nil

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �fContinua � Autor � R.H. - Ze Maria       � Data � 14.03.95 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Impressap da Continuacao do Recibo                         ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   � fContinua()                                                ���
�������������������������������������������������������������������������Ĵ��
���Parametros�                                                            ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Generico                                                   ���
�������������������������������������������������������������������������Ĵ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������*/
Static Function fContinua()    // Continuacao do Recibo

Li+=1
@ LI,05 PSAY STR0037		//"CONTINUA !!!"
Li+= 8

Return Nil


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �fRodape   � Autor � R.H. - Ze Maria       � Data � 14.03.95 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Impressao do Rodape                                        ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   � fRodape()                                                  ���
�������������������������������������������������������������������������Ĵ��
���Parametros�                                                            ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Generico                                                   ���
�������������������������������������������������������������������������Ĵ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������*/
Static Function fRodape()    // Rodape do Recibo

LI ++
@ LI,02 PSAY DESC_MSG1

LI ++
@ LI, 02 PSAY DESC_MSG2
@ LI, 75 PSAY TOTVENC PICTURE cPict1
@ LI, 95 PSAY TOTDESC PICTURE cPict1

LI ++
@ LI,02 PSAY DESC_MSG3

LI ++
If MONTH(dDataRef) = MONTH(SRA->RA_NASC)
	@ LI, 02 PSAY STR0038		//"F E L I Z   A N I V E R S A R I O  ! !"
ENDIF
@ LI, 95 PSAY TOTVENC - TOTDESC PICTURE cPict1

LI +=2
If !Empty( cAliasMov )
	nValSal := 0
	nValSal := fBuscaSal(dDataRef)
	If nValSal ==0
		nValSal := SRA->RA_SALARIO
	EndIf
Else
	nValSal := SRA->RA_SALARIO
EndIf
@ LI,05 PSAY Transform(nValSal,cPict2)

If Esc = 1  // Bases de Adiantamento
	If cBaseAux = "S" .And. nBaseIr # 0
		@ LI,89 PSAY nBaseIr PICTURE cPict1
	Endif
ElseIf Esc = 2 .Or. Esc = 4  // Bases de Folha e 13o. 2o.Parc.
	If cBaseAux = "S"
		@ LI,23 PSAY Transform(nAteLim,cPict1)
		If nBaseFgts # 0
			@ LI,46 PSAY nBaseFgts PICTURE cPict1
		Endif
		If nFgts # 0
			@ LI,66 PSAY nFgts PICTURE cPict2
		Endif
		If nBaseIr # 0
			@ LI,89 PSAY nBaseIr PICTURE cPict1
		Endif
		@ LI,103 PSAY Transform(nBaseIrfE,cPict1)
	Endif
ElseIf Esc = 3 // Bases de FGTS e FGTS Depositado da 1� Parcela
	If cBaseAux = "S"
		If nBaseFgts # 0
			@ LI,46 PSAY nBaseFgts PICTURE cPict1
		Endif
		If nFgts # 0
			@ LI,66 PSAY nFgts PICTURE cPict2
		Endif
	Endif
Endif

@ LI,Pcol() Psay &cCompac

Li ++
Li ++ //HOJE
IF SRA->RA_BCDEPSAL # SPACE(8)
	Desc_Bco := DescBco(Sra->Ra_BcDepSal,Sra->Ra_Filial)
	@ LI,01 PSAY "CRED:"
	@ LI,06 PSAY Transform(SRA->RA_BCDEPSAL, "@R 999/99999 ")
	//	@ LI,14 PSAY "-"
	//	@ LI,15 PSAY DESC_BCO
	@ LI,50 PSAY STR0040 + SRA->RA_CTDEPSAL	//"CONTA:"
ENDIF
LI += 3
@ LI,05 PSAY " "
Return Nil


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �fRodapeAr �Autor  �Silvia Taguti       � Data �  02/12/03   ���
�������������������������������������������������������������������������͹��
���Desc.     � Impressao Rodape-Argentina                                 ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP6                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function fRodapeAr()

@ LI,00 PSAY "|"+REPLICATE("-",130)+"|"
@ ++LI,00 PSAY "| " + "Total Vecto.: " + TRANS(TOTVENC,cPict1)
@ LI,44 PSAY "Total Desc.: " +TRANS(TOTDESC,cPict1)
@ LI,88 PSAY "Liquido: " +TRANS((TOTVENC-TOTDESC),cPict1)
@ LI,131 PSAY "|"
@ ++LI,00 PSAY "|" + REPLICATE("-",130)+"|"
Li ++
@ Li,00 PSAY "Data: " + MesExtenso(MONTH(dDataRef)) + " / " + STR(YEAR(dDataRef),4)
@ LI,131 PSAY "|"
@ ++LI,00 PSAY "|" + REPLICATE("-",130) + "|"
@ ++Li,00 PSAY "extenso" +EXTENSO(TOTVENC-TOTDESC,,,"-")+REPLICATE("*",95-LEN(EXTENSO(TOTVENC-TOTDESC,,,"-")))
@ LI,131 PSAY "|"
//@ ++Li,00 PSAY STR0082
@ LI,131 PSAY "|"
//@ ++Li,00 PSAY STR0083
@ LI,131 PSAY "|"
@ ++Li,00 PSAY "|"
@ LI,131 PSAY "|"
//@ ++Li,00 PSAY STR0084 + StrZero(Day(dDataRef),2) + STR0080 + MesExtenso(MONTH(dDataRef)) + STR0080+STR(YEAR(dDataRef),4)
@ Li,070 PSAY + REPLICATE("_",40)
@ LI,131 PSAY "|"
@ ++Li,00 PSAY "Liquido: " + TRANS((TOTVENC-TOTDESC),cPict1)
@ LI,131 PSAY "|"
//@ ++Li,00 PSAY STR0086
@ LI,131 PSAY "|"
@ ++Li,00 PSAY "|"
@ LI,131 PSAY "|"
@ ++LI,00 PSAY "*"+REPLICATE("-",130)+"*"
Return Nil

***************************************************************************************
Static Function PerSemana() // Pesquisa datas referentes a semana.
***************************************************************************************
Local cChaveSem	:= ""

dbSelectArea( "RCF" )

If !Empty(Semana)
	
	cChaveSem := StrZero(Year(dDataRef),4)+StrZero(Month(dDataRef),2)+SRA->RA_TNOTRAB
	
	If !dbSeek(xFilial("RCF") + cChaveSem + Semana, .T. )
		cChaveSem := StrZero(Year(dDataRef),4)+StrZero(Month(dDataRef),2)+"   "
		If !dbSeek(xFilial("RCF") + cChaveSem + Semana  )
			HELP( " ",1,"GPCALEND",  )						//--Nao existe periodo cadastrado
			Return(NIL)
		Endif
	Endif
	cSem_De  := DtoC(RCF->RCF_DTINI,'DDMMYY')
	cSem_Ate := DtoC(RCF->RCF_DTFIM,'DDMMYY')
EndIf

Return Nil

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �fSomaPdRec� Autor � R.H. - Mauro          � Data � 24.09.95 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Somar as Verbas no Array                                   ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   � fSomaPdRec(Tipo,Verba,Horas,Valor)                         ���
�������������������������������������������������������������������������Ĵ��
���Parametros�                                                            ���
�������������������������������������������������������������������������Ĵ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������*/
Static Function fSomaPdRec(cTipo,cPd,nHoras,nValor)

Local Desc_paga

Desc_paga := DescPd(cPd,Sra->Ra_Filial)  // mostra como pagto

If cTipo # 'B'
	//--Array para Recibo Pre-Impresso
	nPos := Ascan(aLanca,{ |X| X[2] = cPd })
	If nPos == 0
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
If nPos == 0
	Aadd(&cArray,{cPd+" "+Desc_Paga,nHoras,nValor })
Else
	&cArray[nPos,2] += nHoras
	&cArray[nPos,3] += nValor
Endif
Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �fSendDPgto| Autor � R.H.-Natie            � Data � 15.08.01 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Envio de E-mail -Demonstrativo de Pagamento                ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   �                                                            ���
�������������������������������������������������������������������������Ĵ��
���Parametros�                                                            ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Especifico :Envio Demonstrativo de Pagto atraves de eMail  ���
�������������������������������������������������������������������������Ĵ��
���         ATUALIZACOES SOFRIDAS DESDE A CONSTRU�AO INICIAL.             ���
�������������������������������������������������������������������������Ĵ��
���Programador � Data   � BOPS �  Motivo da Alteracao                     ���
�������������������������������������������������������������������������Ĵ��
���            �        �      �                                          ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������*/
Static Function fSendDPgto(lTerminal)

Local aSvArea		:= GetArea()
Local aGetArea		:= {}
Local cEmail		:= If(SRA->RA_RECMAIL=="S",SRA->RA_EMAIL,"    ")
Local cHtml			:= ""
Local cSubject		:= STR0044	//" DEMONSTRATIVO DE PAGAMENTO "
Local cMesComp		:= IF( Month(dDataRef) + 1 > 12 , 01 , Month(dDataRef) )
Local cTipo			:= ""
Local cReferencia	:= ""
Local cVerbaLiq		:= ""
Local dDataPagto	:= Ctod("//")
Local nZebrado		:= 0.00
Local nResto		:= 0.00
Local nProv
Local nDesco
Local cCodFunc		:= ""		//-- codigo da Funcao do funcionario
Local cDescFunc		:= ""		//-- Descricao da Funcao do Funcionario

Private cMailConta	:= NIL
Private cMailServer	:= NIL
Private cMailSenha	:= NIL

lTerminal := IF( lTerminal == NIL .or. ValType( lTerminal ) != "L" , .F. , lTerminal )

IF Esc == 1
	aGetArea	:= SRC->( GetArea() )
	cTipo		:= STR0060 // "Adiantamento"
	cVerbaLiq	:= PosSrv( "007ADT" , xFilial("SRA") , "RV_COD" , RetOrdem("SRV","RV_FILIAL+RV_CODFOL") , .F. )
	SRC->( dbSetOrder( RetOrdem("SRC","RC_FILIAL+RC_MAT+RC_PD+RC_CC+RC_SEMANA+RC_SEQ") ) )
	IF SRC->( dbSeek( SRA->( RA_FILIAL + RA_MAT ) + cVerbaLiq ) )
		While SRC->( !Eof() .and. RC_FILIAL + RC_MAT == SRA->( RA_FILIAL + RA_MAT ) )
			IF Empty( Semana ) .or. ( SRC->RC_SEMANA == Semana )
				dDataPagto := SRC->RC_DATA
				Exit
			EndIF
			SRC->( dbSkip() )
		End While
	EndIF
	RestArea( aGetArea )
ElseIF Esc == 2
	aGetArea	:= SRC->( GetArea() )
	cTipo := STR0061	//"Folha"
	cVerbaLiq	:= PosSrv( "047CAL" , xFilial("SRA") , "RV_COD" , RetOrdem("SRV","RV_FILIAL+RV_CODFOL") , .F. )
	SRC->( dbSetOrder( RetOrdem("SRC","RC_FILIAL+RC_MAT+RC_PD+RC_CC+RC_SEMANA+RC_SEQ") ) )
	IF SRC->( dbSeek( SRA->( RA_FILIAL + RA_MAT ) + cVerbaLiq ) )
		While SRC->( !Eof() .and. RC_FILIAL + RC_MAT == SRA->( RA_FILIAL + RA_MAT ) )
			IF Empty( Semana ) .or. ( SRC->RC_SEMANA == Semana )
				dDataPagto := SRC->RC_DATA
				Exit
			EndIF
			SRC->( dbSkip() )
		End While
	EndIF
	RestArea( aGetArea )
ElseIF Esc == 3
	aGetArea	:= SRC->( GetArea() )
	cTipo := STR0062 //"1a. Parcela do 13o."
	cVerbaLiq	:= PosSrv( "022C13" , xFilial("SRA") , "RV_COD" , RetOrdem("SRV","RV_FILIAL+RV_CODFOL") , .F. )
	SRC->( dbSetOrder( RetOrdem("SRC","RC_FILIAL+RC_MAT+RC_PD+RC_CC+RC_SEMANA+RC_SEQ") ) )
	IF SRC->( dbSeek( SRA->( RA_FILIAL + RA_MAT ) + cVerbaLiq ) )
		While SRC->( !Eof() .and. RC_FILIAL + RC_MAT == SRA->( RA_FILIAL + RA_MAT ) )
			IF Empty( Semana ) .or. ( SRC->RC_SEMANA == Semana )
				dDataPagto := SRC->RC_DATA
				Exit
			EndIF
			SRC->( dbSkip() )
		End While
	EndIF
	RestArea( aGetArea )
ElseIF Esc == 4
	aGetArea	:= SRI->( GetArea() )
	cTipo := STR0063 //"2a. Parcela do 13o."
	cVerbaLiq	:= PosSrv( "021C13" , xFilial("SRA") , "RV_COD" , RetOrdem("SRV","RV_FILIAL+RV_CODFOL") , .F. )
	SRI->( dbSetOrder( RetOrdem("SRI","RI_FILIAL+RI_MAT+RI_PD") ) )
	IF SRI->( dbSeek( SRA->( RA_FILIAL + RA_MAT ) + cVerbaLiq ) )
		dDataPagto := SRC->RC_DATA
	EndIF
ElseIF Esc == 5
	cTipo		:= STR0064 //"Valores Extras"
	cVerbaLiq	:= ""
EndIF

IF !( lTerminal )
	
	//��������������������������������������������������������������Ŀ
	//� Busca parametros                                             �
	//����������������������������������������������������������������
	cMailConta	:=If(cMailConta == NIL,GETMV("MV_EMCONTA"),cMailConta)             //Conta utilizada p/envio do email
	cMailServer	:=If(cMailServer == NIL,GETMV("MV_RELSERV"),cMailServer)           //Server
	cMailSenha	:=If(cMailSenha == NIL,GETMV("MV_EMSENHA"),cMailSenha)
	
	If Empty(cEmail)
		Return
	Endif
	
	//��������������������������������������������������������������Ŀ
	//� Verifica se existe o SMTP Server                             �
	//����������������������������������������������������������������
	If 	Empty(cMailServer)
		Help(" ",1,"SEMSMTP")//"O Servidor de SMTP nao foi configurado !!!" ,"Atencao"
		Return(.F.)
	EndIf
	
	//��������������������������������������������������������������Ŀ
	//� Verifica se existe a CONTA                                   �
	//����������������������������������������������������������������
	If 	Empty(cMailServer)
		Help(" ",1,"SEMCONTA")//"A Conta do email nao foi configurado !!!" ,"Atencao"
		Return(.F.)
	EndIf
	
	//��������������������������������������������������������������Ŀ
	//� Verifica se existe a Senha                                   �
	//����������������������������������������������������������������
	If 	Empty(cMailServer)
		Help(" ",1,"SEMSENHA")	//"A Senha do email nao foi configurado !!!" ,"Atencao"
		Return(.F.)
	EndIf
	
EndIF

IF ( !Empty(Semana) .and. ( Semana # "99" ) .and. ( Upper(SRA->RA_TIPOPGT) == "S" ) )
	/*
	��������������������������������������������������������������Ŀ
	� Carrega Datas Referente a semana                             �
	����������������������������������������������������������������*/
	PerSemana()
	cReferencia := STR0045 + Semana + " (" + cSem_De + STR0046 +	cSem_Ate + ")" //"Semana  "###" a "
Else
	cReferencia	:= AllTrim( MesExtenso(Month(dDataRef))+"/"+STR(YEAR(dDataRef),4) ) + " - ( " + cTipo + " )"
EndIF

cHtml +=	'<html>'
cHtml +=		'<head>'
IF !( lTerminal )
	
	cHtml += 		'<title>DEMONSTRATIVO DE PAGAMENTO</title>'
	cHtml +=			'<style>'
	cHtml +=				'th { text-align:left; background-color:#4B87C2; line-height:01; line-width:400; border-left:0px solid  #FF9B06; border-right:0px solid #FF9B06; border-bottom:0px solid #FF9B06 ; border-top:0px solid #FF9B06 }'
	cHtml +=				'.tdPrinc { text-align:left; line-height:1; line-width:340 ; border-left:0px solid #FF9B06; border-right:0px solid #FF9B06; border-bottom:0px solid #FF9B06 ; border-top:0px solid #FF9B06 > }'
	cHtml +=				'.td18_94_AlignR { text-align:right ; line-height:1; line-width:94 }'
	cHtml +=				'.td18_95_AlignR { text-align:right ; line-height:1; line-width:95 }'
	cHtml +=				'.td26_94_AlignR { text-align:right ; line-height:1; line-width:94 }'
	cHtml +=				'.td26_95_AlignR { text-align:right ; line-height:1; line-width:95 }'
	cHtml += 				'.td26_18_AlignL { lext-align:left ; line-height:1; line:width:18 ; border-left:0px solid #FF9B06; border-right:0px solid #FF9B06; border-bottom:0px solid #FF9B06 ; border-top:0px solid #FF9B06 bgcolor=#6F9ECE" }'
	cHtml +=    			'.pStyle1 { line-height:100% ; margin-top:15 ; margin-bottom:0 }'
	cHtml +=			'</style>'
	cHtml +=	'</head>'
	cHtml +=		'<body bgcolor="#FFFFFF"  topmargin="0" leftmargin="0">'
	cHtml +=			'<center>'
	cHtml +=				'<table  border="1" cellpadding="0" cellspacing="0" bordercolor="#FF9B06" bgcolor="#000082" width=598 height="637">'
	cHtml +=    				'<td width="598" height="181" bgcolor="FFFFFF">'
	cHtml += 					'<center>'
	cHtml += 					'<font color="#000000">'
	cHtml +=					'<b>'
	cHtml += 					'<h4 size="03">'
	cHtml +=					'<br>'
	cHtml += 						STR0044 // " DEMONSTRATIVO DE PAGAMENTO "
	cHtml += 					'<br>'
	
Else
	
	cHtml += 		'<title>RH Online</title>' + CRLF
	cHtml += 		'<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">' + CRLF
	cHtml += 		'<link rel="stylesheet" href="css/rhonline.css" type="text/css">' + CRLF
	cHtml += 	'</head>' + CRLF
	cHtml += 	'<body bgcolor="#FFFFFF" text="#000000">' + CRLF
	cHtml += 		'<Table width="515" border="0" cellspacing="0" cellpadding="0">' + CRLF
	
	//Cabecalho
	cHtml += 			CabecHtml( cReferencia , dDataPagto , dDataRef )
	
	//Separador
	cHtml +=			"<TABLE border='0' cellpadding='0' cellspacing='0' style='border-collapse: collapse' bordercolor='#FFFFFF' bordercolordark='#FFFFFF'bordercolorlight='#FFFFFF' width='100%' id='AutoNumber1'>" + CRLF
	cHtml +=				"<TBODY>" + CRLF
	cHtml +=					"<TR>" + CRLF
	cHtml +=						"<TD vAlign=top width='100%' height=10>" + CRLF
	cHtml +=						"</TD>" + CRLF
	cHtml +=	 				"</TR>" + CRLF
	cHtml +=				"</TBODY>" + CRLF
	cHtml +=			"</TABLE>" + CRLF
	
	cHtml +=			"<TABLE border='1' cellpadding='0' cellspacing='0' style='border-collapse: collapse' bordercolor='#111111' width='100%' id='AutoNumber1'>" + CRLF
	cHtml +=				"<TBODY>" + CRLF
EndIF

If !Empty(Semana) .And. Semana # "99" .And.  Upper(SRA->RA_TIPOPGT) == "S"
	IF !( lTerminal )
		cHtml += cReferencia
	EndIF
Else
	IF !( lTerminal )
		cHtml += cReferencia
	EndIF
EndIf

/*��������������������������������������������������������������Ŀ
� Carrega Funcao do Funcion. de acordo com a Dt Referencia     �
����������������������������������������������������������������*/
fBuscaFunc(dDataRef, @cCodFunc, @cDescFunc   )

IF !( lTerminal )
	
	cHtml += '</b></h4></font></center>'
	cHtml += '<hr whidth = 100% align=right color="#FF812D">'
	//��������������������������������������������������������������Ŀ
	//� Dados do funcionario                                         �
	//����������������������������������������������������������������
	cHtml += '<!Dados do Funcionario>'
	cHtml += '<p align=left  style="margin-top: 0">'
	cHtml +=   '<font color="#000082" face="Courier New"><i><b>'
	cHtml +=  	'&nbsp;&nbsp;&nbsp' + SRA->RA_NOME + "-" + SRA->RA_MAT+'</i><br>'
	cHtml += 	'&nbsp;&nbsp;&nbsp' + STR0048 + cCodFunc + "  "+cDescFunc	+'<br>' //"Funcao    - "
	cHtml +=  	'&nbsp;&nbsp;&nbsp' + STR0047 + SRA->RA_CC + " - " + DescCc(SRA->RA_CC,SRA->RA_FILIAL) +'<br>' //"C.Custo   - "
	cHtml +=    '&nbsp;&nbsp;&nbsp' + STR0049 + SRA->RA_BCDEPSAL+"-"+DescBco(SRA->RA_BCDEPSAL,SRA->RA_FILIAL)+ '&nbsp;'+  SRA->RA_CTDEPSAL //"Bco/Conta - "
	cHtml += '</b></p></font>'
	cHtml += '<!Proventos e Desconto>'
	cHtml += '<div align="center">'
	cHtml += '<Center>'
	cHtml += '<Table bgcolor="#6F9ECE" border="0" cellpadding ="1" cellspacing="0" width="553" height="296">'
	cHtml += '<TBody><Tr>'
	cHtml +=	'<font face="Arial" size="02" color="#000082"><b>'
	cHtml += 	'<th>' + STR0050 + '</th>' //"Cod  Descricao "
	cHtml += 	'<th>' + STR0051 + '</th>' //"Referencia"
	cHtml += 	'<th>' + STR0052 + '</th>' //"Valores"
	cHtml += 	'</b></font></tr>'
	cHtml += '<font color=#000082 face="Courier new"  size=2">'
	
	//��������������������������������������������������������������Ŀ
	//� Espacos Entre os Cabecalho e os Proventos/Descontos          �
	//����������������������������������������������������������������
	cHtml += 	'<tr>'
	cHtml += 		'<td class="tdPrinc"></td>'
	cHtml += 		'<td class="td18_94_AlignR">&nbsp;&nbsp</td>'
	cHtml += 		'<td class="td18_95_AlignR">&nbsp;&nbsp</td>'
	cHtml += 		'<td class="td18_18_AlignL"></td>'
	cHtml += 	'</tr>'
	
Else
	
	//Cabecalho dos valores
	cHtml +=					"<TABLE border='0' cellpadding='0' cellspacing='0' style='border-collapse: collapse' bordercolor='#FFFFFF' bordercolordark='#FFFFFF'bordercolorlight='#FFFFFF' width='100%' id='AutoNumber1'>" + CRLF
	cHtml +=						"<TBODY>" + CRLF
	cHtml += 							'<tr align="center">' + CRLF
	cHtml += 								'<td width="45" height="1">' + CRLF
	cHtml += 									'<span class="etiquetas"><div align="Left">'+ STR0068 + '</span></div>' + CRLF //C&oacute;digo
	cHtml += 								'</td>' + CRLF
	cHtml += 								'<td width="219" valign="top">' + CRLF
	cHtml += 									'<span class="etiquetas"><div align="left">' + STR0069 + '</span></div>' + CRLF //Descri&ccedil;&atilde;o
	cHtml += 								'</td>' + CRLF
	cHtml += 								'<td width="127" valign="top">' + CRLF
	cHtml += 									'<span class="etiquetas"><div align="right">' + "Refer&ecirc;ncia"  + '</span></div>' + CRLF //Refer&ecirc;ncia
	cHtml += 								'</td>' + CRLF
	cHtml += 								'<td width="127" valign="top">' + CRLF
	cHtml += 									'<span class="etiquetas"><div align="right">' + STR0052 + '</span></div>' + CRLF //Valores
	cHtml += 								'<td width="107" valign="top">' + CRLF
	cHtml += 									'<span class="etiquetas"><div align="right"> (+/-) </span></div>' + CRLF
	cHtml += 								'</td>' + CRLF
	cHtml += 							'</tr>' + CRLF
	cHtml +=						"</TBODY>" + CRLF
	cHtml += 					'</TABLE>' + CRLF
	
	//Separador
	cHtml +=					"<TABLE border='0' cellpadding='0' cellspacing='0' style='border-collapse: collapse' bordercolor='#FFFFFF' bordercolordark='#FFFFFF'bordercolorlight='#FFFFFF' width='100%' id='AutoNumber1'>" + CRLF
	cHtml +=						"<TBODY>" + CRLF
	cHtml +=							"<TR>" + CRLF
	cHtml +=								"<TD vAlign=top width='100%' height=05>" + CRLF
	cHtml +=								"</TD>" + CRLF
	cHtml +=	 						"</TR>" + CRLF
	cHtml +=						"</TBODY>" + CRLF
	cHtml +=					"</TABLE>" + CRLF
	
	cHtml +=					"<TABLE border='0' cellpadding='0' cellspacing='0' style='border-collapse: collapse' bordercolor='#FFFFFF' bordercolordark='#FFFFFF'bordercolorlight='#FFFFFF' width='100%' id='AutoNumber1'>" + CRLF
	cHtml +=						"<TBODY>" + CRLF
	cHtml +=							"<TR>" + CRLF
	
EndIF

//��������������������������������������������������������������Ŀ
//� Proventos                                                    �
//����������������������������������������������������������������
For nProv:=1 To Len( aProve )
	
	nResto := ( ++nZebrado % 2 )
	
	IF !( lTerminal )
		
		cHtml += '<tr>'
		cHtml += 	'<td class="tdPrinc">' + aProve[nProv,1] + '</td>'
		cHtml += 	'<td class="td18_94_AlignR">' + Transform(aProve[nProv,2],'999.99')+'</td>'
		cHtml += 	'<td class="td18_95_AlignR">' + Transform(aProve[nProv,3],cPict3) + '</td>'
		cHtml +=    '<td class="td18_18_AlignL"></td>'
		cHtml += '</tr>'
		
	Else
		
		cHtml += 							'<tr>' + CRLF
		IF nResto > 0.00
			cHtml += 							'<td width="45" vAlign=top height="1" bgcolor="#FAFBFC">'
		Else
			cHtml += 							'<td width="45" vAlign=top height="1">' + CRLF
		EndIF
		cHtml += 									'<div align="left"><span class="dados">'  + Substr( aProve[nProv,1] , 1 , 3 ) + '</span></div>' + CRLF
		cHtml += 								'</td>' + CRLF
		IF nResto > 0.00
			cHtml += 							'<td width="219" valign="top" bgcolor="#FAFBFC">' + CRLF
		Else
			cHtml += 							'<td width="219" vAlign=top="top">' + CRLF
		EndIF
		cHtml += 									'<div align="Left"><span class="dados">'  + Capital( AllTrim( Substr( aProve[nProv,1] , 4 ) ) ) + '</span></div>' + CRLF
		cHtml += 								'</td>' + CRLF
		IF nResto > 0.00
			cHtml += 							'<td width="127" valign="top" bgcolor="#FAFBFC">' + CRLF
		Else
			cHtml += 							'<td width="127" valign="top">' + CRLF
		EndIF
		cHtml += 									'<div align="right"><span class="dados">' + Transform(aProve[nProv,2],'999.99') + '</span></div>' + CRLF
		cHtml += 								'</td>' + CRLF
		IF nResto > 0.00
			cHtml += 							'<td width="127" valign="top" bgcolor="#FAFBFC">' + CRLF
		Else
			cHtml += 							'<td width="127" valign="top">' + CRLF
		EndIF
		cHtml += 									'<div align="right"><span class="dados">' + Transform(aProve[nProv,3],cPict3) + '</span></div>' + CRLF
		cHtml += 								'</td>' + CRLF
		IF nResto > 0.00
			cHtml += 							'<td width="107" valign="top" bgcolor="#FAFBFC">' + CRLF
		Else
			cHtml += 							'<td width="107" valign="top">' + CRLF
		EndIF
		cHtml += 									'<div align="right"><span class="dados"> (+) </span></div>' + CRLF
		cHtml += 								'</td>' + CRLF
		cHtml += 							'</tr>' + CRLF
	EndIF
Next nProv

IF ( lTerminal )
	cHtml +=							"</TR>" + CRLF
	cHtml +=							"<TR>" + CRLF
EndIF

//��������������������������������������������������������������Ŀ
//� Descontos                                                    �
//����������������������������������������������������������������
For nDesco := 1 to Len(aDesco)
	
	nResto := ( ++nZebrado % 2 )
	
	IF !( lTerminal )
		
		cHtml += '<tr>'
		cHtml += 	'<td class="tdPrinc">' + aDesco[nDesco,1] + '</td>'
		cHtml += 	'<td class="td18_94_AlignR">' + Transform(aDesco[nDesco,2],'999.99') + '</td>'
		cHtml += 	'<td class="td18_95_AlignR">' + Transform(aDesco[nDesco,3],cPict3) + '</td>'
		cHtml += 	'<td class="td18_18_AlignL">-</td>'
		cHtml += '</tr>'
		
	Else
		
		cHtml += 							'<tr>' + CRLF
		IF nResto > 0.00
			cHtml += 							'<td width="45" align="center" height="19" bgcolor="#FAFBFC">'
		Else
			cHtml += 							'<td width="45" align="center" height="19">' + CRLF
		EndIF
		cHtml += 									'<div align="left"><span class="dados">'  + Substr( aDesco[nDesco,1] , 1 , 3 ) + '</span></div>' + CRLF
		cHtml += 								'</td>' + CRLF
		IF nResto > 0.00
			cHtml += 							'<td width="219" valign="top" bgcolor="#FAFBFC">' + CRLF
		Else
			cHtml += 							'<td width="219" valign="top">' + CRLF
		EndIF
		cHtml += 									'<div align="Left"><span class="dados">'  + Capital( AllTrim( Substr( aDesco[nDesco,1] , 4 ) ) ) + '</span></div>' + CRLF
		cHtml += 								'</td>' + CRLF
		IF nResto > 0.00
			cHtml += 							'<td width="127" valign="top" bgcolor="#FAFBFC">' + CRLF
		Else
			cHtml += 							'<td width="127" valign="top">' + CRLF
		EndIF
		cHtml += 									'<div align="right"><span class="dados">' + Transform(aDesco[nDesco,2],'999.99') + '</span></div>' + CRLF
		cHtml += 								'</td>' + CRLF
		IF nResto > 0.00
			cHtml += 							'<td width="127" valign="top" bgcolor="#FAFBFC">' + CRLF
		Else
			cHtml += 							'<td width="127" valign="top">' + CRLF
		EndIF
		cHtml += 									'<div align="right"><span class="dados">' + Transform(aDesco[nDesco,3],cPict3) + '</span></div>' + CRLF
		cHtml += 								'</td>' + CRLF
		IF nResto > 0.00
			cHtml += 							'<td width="107" valign="top" bgcolor="#FAFBFC">' + CRLF
		Else
			cHtml += 							'<td width="107" valign="top">' + CRLF
		EndIF
		cHtml += 									'<div align="right"><span class="dados"> (-) </span></div>' + CRLF
		cHtml += 								'</td>' + CRLF
		cHtml += 							'</tr>' + CRLF
	EndIF
Next nDesco

IF ( lTerminal )
	
	cHtml +=							"</TR>" + CRLF
	cHtml +=						"</TBODY>" + CRLF
	cHtml +=					"</TABLE>" + CRLF
	
	//Separador
	cHtml +=					"<TABLE border='0' cellpadding='0' cellspacing='0' style='border-collapse: collapse' bordercolor='#FFFFFF' bordercolordark='#FFFFFF'bordercolorlight='#FFFFFF' width='100%' id='AutoNumber1'>" + CRLF
	cHtml +=						"<TBODY>" + CRLF
	cHtml +=							"<TR>" + CRLF
	cHtml +=								"<TD vAlign=top width='100%' height=05>" + CRLF
	cHtml +=								"</TD>" + CRLF
	cHtml +=	 						"</TR>" + CRLF
	cHtml +=						"</TBODY>" + CRLF
	cHtml +=					"</TABLE>" + CRLF
	
	cHtml +=					"<TABLE border='0' cellpadding='0' cellspacing='0' style='border-collapse: collapse' bordercolor='#FFFFFF' bordercolordark='#FFFFFF'bordercolorlight='#FFFFFF' width='100%' id='AutoNumber1'>" + CRLF
	cHtml +=						"<TBODY>" + CRLF
	cHtml +=							"<TR>" + CRLF
	
EndIF

IF !( lTerminal )
	
	//��������������������������������������������������������������Ŀ
	//� Espacos Entre os Proventos e Descontos e os Totais           �
	//����������������������������������������������������������������
	cHtml += 	'<tr>'
	cHtml += 		'<td class="tdPrinc"></td>'
	cHtml += 		'<td class="td18_94_AlignR">&nbsp;&nbsp</td>'
	cHtml += 		'<td class="td18_95_AlignR">&nbsp;&nbsp</td>'
	cHtml += 		'<td class="td18_18_AlignL"></td>'
	cHtml += 	'</tr>'
	
	//��������������������������������������������������������������Ŀ
	//� Totais                                                       �
	//����������������������������������������������������������������
	cHtml += '<!Totais >'
	cHtml +=	'<b><i>'
	cHtml += 	'<tr>'
	cHtml += 		'<td class="tdPrinc">' + STR0053 + '</td>' //"Total Bruto "
	cHtml += 		'<td class="td18_94_AlignR"></td>'
	cHtml += 		'<td class="td18_95_AlignR">' + Transform(TOTVENC,cPict3) + '</td>'
	cHtml += 		'<td class="td18_18_AlignL"></td>'
	cHtml +=	'</tr>'
	cHtml += 	'<tr>'
	cHtml += 		'<td class="tdPrinc">' + STR0054 + '</td>' //"Total Descontos "
	cHtml += 		'<td class="td18_94_AlignR"></Td>'
	cHtml += 		'<td class="td18_95_AlignR">' + Transform(TOTDESC,cPict3) + '</td>'
	cHtml += 		'<td class="td18_18_AlignL">-</td>'
	cHtml += 	'</tr>'
	cHtml += 	'<tr>'
	cHtml += 		'<td class="tdPrinc">' + STR0055 + '</td>' //"Liquido a Receber "
	cHtml += 		'<td class="td18_94_AlignR"></td>'
	cHtml += 		'<td align=right height="18" width="95" Style="border-left:0px solid #FF812D; border-right:0px solid #FF9B06; border-bottom:0px solid #FF9B06 ; border-top:1px solid #FF9B06 bgcolor=#4B87C2">'
	cHtml +=        Transform((TOTVENC-TOTDESC),cPict3) +'</td>'
	cHtml += 	'</tr>'
	cHtml += '<!Bases>'
	cHtml += 	'<tr>'
	
Else
	
	//Total de Proventos
	cHtml += 							'<tr>' + CRLF
	cHtml += 								'<td width="219" valign="top" bgcolor="#FAFBFC">' + CRLF
	cHtml += 									'<div align="left" class="etiquetas"> ' + STR0065 + '</div>' + CRLF //"Total Bruto: "
	cHtml += 								'</td>' + CRLF
	cHtml += 								'<td width="45" valign="top" bgcolor="#FAFBFC">' + CRLF
	cHtml += 									'<div align="left" class="etiquetas"> </div>' + CRLF
	cHtml += 								'</td>' + CRLF
	cHtml += 								'<td width="127" valign="top" bgcolor="#FAFBFC">' + CRLF
	cHtml += 									'<div align="left" class="etiquetas"> </div>' + CRLF
	cHtml += 								'</td>' + CRLF
	cHtml += 								'<td width="127" valign="top" bgcolor="#FAFBFC">' + CRLF
	cHtml += 									'<div align="right"><span class="dados">' + Transform(TOTVENC,cPict3) + '</span></div>' + CRLF
	cHtml += 								'</td>' + CRLF
	cHtml += 								'<td width="107" valign="top" bgcolor="#FAFBFC">' + CRLF
	cHtml += 									'<div align="right"><span class="dados"> (+) </span></div>' + CRLF
	cHtml += 								'</td>' + CRLF
	cHtml += 							'</tr>' + CRLF
	
	//Total de Descontos
	cHtml += 							'<tr>' + CRLF
	cHtml += 								'<td width="219" valign="top">' + CRLF
	cHtml += 									'<div align="left" class="etiquetas"> ' + STR0066 + '</div>' + CRLF //"Total de Descontos: "
	cHtml += 								'</td>' + CRLF
	cHtml += 								'<td width="45" valign="top">' + CRLF
	cHtml += 									'<div align="left" class="etiquetas"> </div>' + CRLF
	cHtml += 								'</td>' + CRLF
	cHtml += 								'<td width="127" valign="top">' + CRLF
	cHtml += 									'<div align="left" class="etiquetas"> </div>' + CRLF
	cHtml += 								'</td>' + CRLF
	cHtml += 								'<td width="127" valign="top">' + CRLF
	cHtml += 									'<div align="right"><span class="dados">' + Transform(TOTDESC,cPict3) + '</span></div>' + CRLF
	cHtml += 								'</td>' + CRLF
	cHtml += 								'<td width="107" valign="top">' + CRLF
	cHtml += 									'<div align="right"><span class="dados"> (-) </span></div>' + CRLF
	cHtml += 								'</td>' + CRLF
	cHtml += 							'</tr>' + CRLF
	
	
	//Liquido
	cHtml += 							'<tr>' + CRLF
	cHtml += 								'<td width="219" valign="top" bgcolor="#FAFBFC">' + CRLF
	cHtml += 									'<div align="left" class="etiquetas">' + STR0067  + '</div>' + CRLF //"L&iacute;quido a Receber: "
	cHtml += 								'</td>' + CRLF
	cHtml += 								'<td width="45" valign="top" bgcolor="#FAFBFC">' + CRLF
	cHtml += 									'<div align="left" class="etiquetas"> </div>' + CRLF
	cHtml += 								'</td>' + CRLF
	cHtml += 								'<td width="127" valign="top" bgcolor="#FAFBFC">' + CRLF
	cHtml += 									'<div align="left" class="etiquetas"> </div>' + CRLF
	cHtml += 								'</td>' + CRLF
	cHtml += 								'<td width="127" valign="top" bgcolor="#FAFBFC">' + CRLF
	cHtml += 									'<div align="right"><span class="dados">' + Transform((TOTVENC-TOTDESC),cPict3) + '</span></div>' + CRLF
	cHtml += 								'</td>' + CRLF
	cHtml += 								'<td width="107" valign="top" bgcolor="#FAFBFC">' + CRLF
	cHtml += 									'<div align="right"><span class="dados"> (=) </span></div>' + CRLF
	cHtml += 								'</td>' + CRLF
	cHtml += 							'</tr>' + CRLF
	
	cHtml +=							"</TR>" + CRLF
	cHtml +=						"</TBODY>" + CRLF
	cHtml +=					"</TABLE>" + CRLF
	
	//Separador
	cHtml +=					"<TABLE border='0' cellpadding='0' cellspacing='0' style='border-collapse: collapse' bordercolor='#FFFFFF' bordercolordark='#FFFFFF'bordercolorlight='#FFFFFF' width='100%' id='AutoNumber1'>" + CRLF
	cHtml +=						"<TBODY>" + CRLF
	cHtml +=							"<TR>" + CRLF
	cHtml +=								"<TD vAlign=top width='100%' height=10>" + CRLF
	cHtml +=								"</TD>" + CRLF
	cHtml +=	 						"</TR>" + CRLF
	cHtml +=						"</TBODY>" + CRLF
	cHtml +=					"</TABLE>" + CRLF
	
	cHtml +=					"<TABLE border='0' cellpadding='0' cellspacing='0' style='border-collapse: collapse' bordercolor='#FFFFFF' bordercolordark='#FFFFFF'bordercolorlight='#FFFFFF' width='100%' id='AutoNumber1'>" + CRLF
	cHtml +=						"<TBODY>" + CRLF
	cHtml +=							"<TR>" + CRLF
	
EndIF

//��������������������������������������������������������������Ŀ
//� Espacos Entre os Totais e as Bases                           �
//����������������������������������������������������������������
IF !( lTerminal )
	cHtml += 	'<tr>'
	cHtml += 		'<td class="tdPrinc"></td>'
	cHtml += 		'<td class="td18_94_AlignR">&nbsp;&nbsp</td>'
	cHtml += 		'<td class="td18_95_AlignR">&nbsp;&nbsp</td>'
	cHtml += 		'<td class="td18_18_AlignL"></td>'
	cHtml += 	'</tr>'
Else
	cHtml += '<table width="498" border="0" cellspacing="0" cellpadding="0">' + CRLF
EndIF

//��������������������������������������������������������������Ŀ
//� Base de Adiantamento                                         �
//����������������������������������������������������������������
If Esc = 1
	If cBaseAux = "S" .And. nBaseIr # 0
		IF !( lTerminal )
			cHtml +=	'<tr>'
			cHtml +=		'<td class="tdPrinc"><p class="pStyle1"><font color=#000082 face="Courier new" size=2><i>'+STR0058+'</i></p></td></font>' //"Base IR Adiantamento"
			cHtml +=		'<td class="td26_94_AlignR"><p></td>'
			cHtml +=		'<td class="td26_95_AlignR"><p>'+ Transform(nBaseIr,cPict1)+'</td>'
			cHtml +=		'<td class="td26_18_AlignL"><p></td>'
			cHtml += 	'</tr>'
		Else
			cHtml += '<tr>'
			cHtml += '<td width="304" class="etiquetas">' + STR0058 + ' + </td>' + CRLF
			cHtml += '<td width="103" class="dados"><div align="center">' + Transform(nBaseIr,cPict3) + '</div></td>' + CRLF
			cHtml += '<td width="91"  class="dados"><div align="center">' + Transform(0.00   ,cPict3) + '</div></td>' + CRLF
			cHtml += '</tr>'
		EndIF
	Endif
	//��������������������������������������������������������������Ŀ
	//� Base de Folha e de 13o 20 Parc.                              �
	//����������������������������������������������������������������
ElseIf Esc = 2 .Or. Esc = 4
	
	IF cBaseAux = "S"
		
		IF !( lTerminal )
			
			cHtml += '<tr>'
			cHtml +=	'<td class="tdPrinc">'
			cHtml +=    '<p class="pStyle1">'+ STR0056 +'</p></td>'//"Base FGTS/Valor FGTS"
			cHtml +=	'<td class="td26_94_AlignR">' + Transform(nBaseFgts,cPict3)+'</td>'
			cHtml +=	'<td class="td26_95_AlignR">' + Transform(nFgts    ,cPict3)+'</td>'
			cHtml += '</tr>'
			cHtml += '<tr>'
			cHtml +=	'<td class="tdPrinc">'
			cHtml +=    '<p class="pStyle1">'+ STR0057 +'</p></td>'//"Base IRRF Folha/Ferias"
			cHtml +=	'<td class="td26_94_AlignR">' + Transform(nBaseIr,cPict3)+'</td>'
			cHtml +=	'<td class="td26_95_AlignR">' + Transform(nBaseIrfe,cPict3)+'</td>'
			cHtml += '</tr>'
			
		Else
			
			cHtml += 								"<tr>"
			cHtml += 									"<td width=219' bgcolor='#FAFBFC' class='etiquetas'>"
			cHtml +=										STR0056 + CRLF //"Base FGTS/Valor FGTS"
			cHtml +=									"</td>" + CRLF
			cHtml += 									"<td width='45' bgcolor='#FAFBFC' class='dados'>" + CRLF
			cHtml += 										'<div align="left" class="etiquetas"> </div>' + CRLF
			cHtml +=									"</td>" + CRLF
			cHtml += 									"<td width='127' bgcolor='#FAFBFC' class='dados'>" + CRLF
			cHtml +=										"<div align='right'>" + Transform(nBaseFgts,cPict3) + "</div>" + CRLF
			cHtml +=									"</td>" + CRLF
			cHtml += 									"<td width='127'  bgcolor='#FAFBFC' class='dados'>" + CRLF
			cHtml +=										"<div align='right'>" + Transform(nFgts    ,cPict3) + "</div>" + CRLF
			cHtml +=									'</td>' + CRLF
			cHtml += 									"<td width='107' valign='top' bgcolor='#FAFBFC'>" + CRLF
			cHtml += 										"<div align='right'><span class='dados'></span></div>" + CRLF
			cHtml += 									"</td>" + CRLF
			cHtml += 								"</tr>" + CRLF
			
			cHtml += 								"<tr>" + CRLF
			cHtml += 									"<td width='219' class='etiquetas'>"
			cHtml +=										STR0057 + CRLF //"Base IRRF Folha/Ferias"
			cHtml += 									"</td>" + CRLF
			cHtml += 									"<td width='45' class='dados'>" + CRLF
			cHtml += 										'<div align="left" class="etiquetas"> </div>' + CRLF
			cHtml +=									"</td>" + CRLF
			cHtml += 									"<td width='127' class='dados'>" + CRLF
			cHtml +=											"<div align='right'>" + Transform(nBaseIr,cPict3) + "</div>" + CRLF
			cHtml += 									"</td>" + CRLF
			cHtml += 									"<td width='127'  class='dados'>"  + CRLF
			cHtml += 										"<div align='right'>" + Transform(nBaseIrFe,cPict3) + "</div>" + CRLF
			cHtml += 									"</td>" + CRLF
			cHtml += 									"<td width='107' class='dados'>" + CRLF
			cHtml +=									"</td>" + CRLF
			cHtml += 								'</tr>'
			
			cHtml += 								"<tr>" + CRLF
			cHtml += 									"<td width='219' class='etiquetas' bgcolor='#FAFBFC' >"
			cHtml +=									"Base INSS" + CRLF //"Base INSS"
			cHtml += 									"</td>" + CRLF
			cHtml += 									"<td width='45' class='dados'>" + CRLF
			cHtml += 										'<div align="left" class="etiquetas" bgcolor="#FAFBFC"> </div>' + CRLF
			cHtml +=									"</td>" + CRLF
			cHtml += 									"<td width='127' class='dados' bgcolor='#FAFBFC' >" + CRLF
			cHtml +=											"<div align='right'>" + Transform(nAteLim,cPict3) + "</div>" + CRLF
			cHtml += 									"</td>" + CRLF
			cHtml += 									"<td width='127'  class='dados' bgcolor='#FAFBFC' >"  + CRLF
			cHtml += 										"<div align='right'></div>" + CRLF
			cHtml += 									"</td>" + CRLF
			cHtml += 									"<td width='107' class='dados' bgcolor='#FAFBFC' >" + CRLF
			cHtml +=									"</td>" + CRLF
			cHtml += 								'</tr>'
			
		EndIF
		
	EndIF
	//��������������������������������������������������������������Ŀ
	//� Bases de FGTS e FGTS Depositado da 1� Parcela                �
	//����������������������������������������������������������������
ElseIf Esc = 3
	
	If cBaseAux = "S"
		
		IF !( lTerminal )
			
			cHtml += 	'<tr>'
			cHtml += 		'<td class="tdPrinc">'
			cHtml +=		'<p class="pStyle1">'+ STR0056 +'</td>' //"Base FGTS / Valor FGTS"
			cHtml += 		'<td class="td26_94_AlignL">' + Transform(nBaseFgts,cPict1) +'</td>'
			cHtml += 		'<td class="td26_95_AlignL">' + Transform(nFgts,cPict2)+'</td>'
			cHtml +=		'<td align=right height="26" width="95"  style="border-left: 0px solid #FF9B06; border-right:0px solid #FF9B06; border-bottom:1px solid #FF9B06 ; border-top: 0px solid #FF9B06 bgcolor=#6F9ECE"></td>'
			cHtml += 	'</tr>'
			
		Else
			
			cHtml += 								"<tr>"
			cHtml += 									"<td width=219' bgcolor='#FAFBFC' class='etiquetas'>"
			cHtml +=										STR0056 + CRLF //"Base FGTS/Valor FGTS"
			cHtml +=									"</td>" + CRLF
			cHtml += 									"<td width='45' bgcolor='#FAFBFC' class='dados'>" + CRLF
			cHtml += 										'<div align="left" class="etiquetas"> </div>' + CRLF
			cHtml +=									"</td>" + CRLF
			cHtml += 									"<td width='127' bgcolor='#FAFBFC' class='dados'>" + CRLF
			cHtml +=										"<div align='right'>" + Transform(nBaseFgts,cPict3) + "</div>" + CRLF
			cHtml +=									"</td>" + CRLF
			cHtml += 									"<td width='127'  bgcolor='#FAFBFC' class='dados'>" + CRLF
			cHtml +=										"<div align='right'>" + Transform(nFgts    ,cPict3) + "</div>" + CRLF
			cHtml +=									'</td>' + CRLF
			cHtml += 									"<td width='107' valign='top' bgcolor='#FAFBFC'>" + CRLF
			cHtml += 										"<div align='right'><span class='dados'></span></div>" + CRLF
			cHtml += 									"</td>" + CRLF
			cHtml += 								"</tr>" + CRLF
			
		EndIF
		
	Endif
	
EndIF

IF !( lTerminal )
	
	cHtml += '</font></i></b>'
	cHtml += '</TBody>'
	cHtml += '</table>'
	cHtml += '</center>'
	cHtml += '</div>'
	cHtml += '<hr whidth = 100% align=right color="#FF812D">'
	//��������������������������������������������������������������Ŀ
	//� Espaco para Observacoes/mensagens                            �
	//����������������������������������������������������������������
	cHtml += '<!Mensagem>'
	cHtml += '<Table bgColor=#6F9ECE border=0 cellPadding=0 cellSpacing=0 height=100 width=598>'
	cHtml += 	'<TBody>'
	cHtml +=	'<tr>'
	cHtml +=	'<td align=left height=18 width=574 style="border-left:1px solid #FF9B06; border-right:1px solid #FF9B06; border-bottom: 0px solid #FF9B06 ; border-top:1px solid #FF9B06 bgcolor=#6F9ECE"><i><font face="Arial" size="2" color="#000082">'+DESC_MSG1+ '</font></td></tr>'
	cHtml +=	'<tr>'
	cHtml +=	'<td align=left height=18 width=574 style="border-left:1px solid #FF9B06; border-right:1px solid #FF9B06; border-bottom: 0px solid #FF9B06 ; border-top: 0px solid #FF9B06 bgcolor=#6F9ECE"><i><font face="Arial" size="2" color="#000082">'+DESC_MSG2+ '</font></td></tr>'
	cHtml +=	'<tr>'
	cHtml += 	'<td align=left height=18 width=574 style="border-left:1px solid #FF9B06; border-right:1px solid #FF9B06; border-bottom:1px solid #FF9B06 ; border-top: 0px solid #FF9B06 bgcolor=#6F9ECE"><i><font face="Arial" size="2" color="#000082">'+DESC_MSG3+ '</font></td></tr>'
	IF cMesComp == Month(SRA->RA_NASC)
		cHtml += '<TD align=left height=18 width=574 bgcolor="#FFFFFF"><EM><B><CODE>      <font face="Arial" size="4" color="#000082">'
		cHtml += '<MARQUEE align="middle" bgcolor="#FFFFFF">' + STR0059	+ '</marquee><code></b></font></td></tr>' //"F E L I Z &nbsp;&nbsp  A N I V E R S A R I O !!!! "
	EndIF
	cHtml += '</TBody>'
	cHtml += '</Table>'
	cHtml += '</table>'
	cHtml += '</body>'
	cHtml += '</html>'
	
Else
	
	cHtml +=							"</TR>" + CRLF
	cHtml +=						"</TBODY>" + CRLF
	cHtml +=					"</TABLE>" + CRLF
	
	cHtml +=				"</TBODY>" + CRLF
	cHtml +=			"</TABLE>" + CRLF
	
	//Separador
	cHtml +=			"<TABLE border='0' cellpadding='0' cellspacing='0' style='border-collapse: collapse' bordercolor='#FFFFFF' bordercolordark='#FFFFFF'bordercolorlight='#FFFFFF' width='100%' id='AutoNumber1'>" + CRLF
	cHtml +=				"<TBODY>" + CRLF
	cHtml +=					"<TR>" + CRLF
	cHtml +=						"<TD vAlign=top width='100%' height=10>" + CRLF
	cHtml +=						"</TD>" + CRLF
	cHtml +=			 		"</TR>" + CRLF
	cHtml +=				"</TBODY>" + CRLF
	cHtml +=			"</TABLE>" + CRLF
	
	//Rodape
	cHtml += 			RodaHtml()
	
	cHtml += 		'</TABLE>' + CRLF
	cHtml += 		'<p align="right"><a href="javascript:self.print()"><img src="imagens/imprimir.gif" width="90" height="28" hspace="20" border="0"></a></p>' + CRLF
	cHtml += 	'</body>' + CRLF
	cHtml += '</html>' + CRLF
	
EndIF

//��������������������������������������������������������������Ŀ
//� Envia e-mail p/funcionario                                   �
//����������������������������������������������������������������
IF !( lTerminal )
	lEnvioOK := GPEMail(cSubject,cHtml,cEMail)
EndIF

RestArea( aSvArea )

Return( IF( lTerminal , cHtml , NIL ) )

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �fImpTeste �Autor  �R.H. - Natie        � Data �  11/29/01   ���
�������������������������������������������������������������������������͹��
���Desc.     �Testa impressao de Formulario Teste                         ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP5                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static function fImpTeste(cString,nTipoRel)

//--Comando para nao saltar folha apos o MsFlush.
SetPgEject(.F.)

@ PROW(),PCOL() PSAY ""
//��������������������������������������������������������������Ŀ
//� Descarrega teste de impressao                                �
//����������������������������������������������������������������
MS_Flush()
fInicia(cString,nTipoRel)

//����������������������������������������������������������������������������������Ŀ
//� Define o Li com a a linha de impress�o correten para n�o saltar linhas no teste  �
//������������������������������������������������������������������������������������
li := _Prow()

If nTipoRel == 2
	@ LI,00 PSAY AvalImp(Limite)
Endif

lRetCanc	:= Pergunte("GPR30A",.T.)
Vez := If(mv_par01 = 1,1,0)

Return Vez

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �fInicia   �Autor  �Natie               � Data �  04/12/01   ���
�������������������������������������������������������������������������͹��
���Desc.     �Inicializa parametros para impressao                        ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP5                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function  fInicia(cString,nTipoRel)


If LastKey() = 27 .Or. nLastKey = 27
	Return  .F.
Endif

If nTipoRel # 3  .and. nTipoRel <> 4
	SetDefault(aReturn,cString)
Endif

If LastKey() = 27 .OR. nLastKey = 27
	Return .F.
Endif

Return .T.

/*
�����������������������������������������������������������������������Ŀ
�Fun��o	   �CabecHtml  		�Autor�Marinaldo de Jesus � Data �18/09/2003�
�����������������������������������������������������������������������Ĵ
�Descri��o �Retorna Cabecalho HTML para o RHOnLine                      �
�����������������������������������������������������������������������Ĵ
�Sintaxe   �<Vide Parametros Formais>									�
�����������������������������������������������������������������������Ĵ
�Parametros�<Vide Parametros Formais>									�
�����������������������������������������������������������������������Ĵ
�Retorno   �cHtml  														�
�����������������������������������������������������������������������Ĵ
�Uso	   �GPER030       										    	�
�������������������������������������������������������������������������*/
Static Function CabecHtml( cReferencia , dDataPagto , dDataRef )

Local cHtml 		:= ""
Local cLogoEmp		:= RetLogoEmp()
Local nSalario		:= 0
Local cCodFunc		:= ""		//-- codigo da Funcao do funcionario
Local cDescFunc		:= ""		//-- Descricao da Funcao do Funcionario

IF !Empty( cAliasMov )
	nSalario := fBuscaSal( dDataRef )
	IF ( nSalario == 0 )
		nSalario := SRA->RA_SALARIO
	EndIf
Else
	nSalario := SRA->RA_SALARIO
EndIF

DEFAULT cReferencia	:= ""

/*��������������������������������������������������������������Ŀ
� Carrega Funcao do Funcion. de acordo com a Dt Referencia     �
����������������������������������������������������������������*/
fBuscaFunc(dDataRef, @cCodFunc, @cDescFunc  )

//Logo e Titulo
cHtml +=	"<TABLE border='2' cellpadding='0' cellspacing='0' style='border-collapse: collapse' bordercolor='#111111' bordercolordark='#FFFFFF'bordercolorlight='#FFFFFF' width='100%' id='AutoNumber1'>" + CRLF
cHtml +=		"<TBODY class='fundo'>"
cHtml +=			"<img src='" + cLogoEmp +"' width='206' height='030' align=left hspace=30>" + CRLF
cHtml +=					"<b>" + CRLF
cHtml += 						"<span class='titulo_opcao'>" + Capital( STR0044 ) + "</span>" + CRLF //DEMONSTRATIVO DE PAGAMENTO
cHtml +=					"</b>" + CRLF
cHtml +=		"</TBODY>" + CRLF
cHtml +=	"</TABLE>" + CRLF

//Empresa
cHtml +=	"<TABLE border='2' cellpadding='0' cellspacing='0' style='border-collapse: collapse' bordercolor='#111111' width='100%' id='AutoNumber1'>" + CRLF
cHtml +=		"<TBODY>" + CRLF
cHtml +=			"<TR>" + CRLF
cHtml +=				"<TD vAlign=top width='100%' height=1>" + CRLF
cHtml +=					"<P align=left>" + CRLF
cHtml +=						"<span class='etiquetas'>" + "Empresa: " + CRLF //"Empresa: "
cHtml += 						"</span>" + CRLF
cHtml +=	        			 "<span class='dados'>" + CRLF
cHtml +=								Capital( AllTrim( Desc_Fil ) ) + CRLF
cHtml += 						"</span>" + CRLF
cHtml +=					"</P>" + CRLF
cHtml +=				"</TD>" + CRLF
cHtml +=	 		"</TR>" + CRLF
cHtml +=		"</TBODY>" + CRLF
cHtml +=	"</TABLE>" + CRLF

//Separador
cHtml +=	"<TABLE border='0' cellpadding='0' cellspacing='0' style='border-collapse: collapse' bordercolor='#FFFFFF' bordercolordark='#FFFFFF'bordercolorlight='#FFFFFF' width='100%' id='AutoNumber1'>" + CRLF
cHtml +=		"<TBODY>" + CRLF
cHtml +=			"<TR>" + CRLF
cHtml +=				"<TD vAlign=top width='100%' height=1>" + CRLF
cHtml +=				"</TD>" + CRLF
cHtml +=	 		"</TR>" + CRLF
cHtml +=		"</TBODY>" + CRLF
cHtml +=	"</TABLE>" + CRLF

//Endereco e CNPJ
cHtml +=	"<TABLE border='2' cellpadding='0' cellspacing='0' style='border-collapse: collapse' bordercolor='#111111' width='100%' id='AutoNumber1'>" + CRLF
cHtml +=		"<TBODY>" + CRLF
cHtml +=			"<TR>" + CRLF
cHtml +=				"<TD vAlign=top width='65%' height=1>" + CRLF
cHtml +=					"<P align=left>" + CRLF
cHtml +=						"<span class='etiquetas'>" + "Endere�o: " + CRLF //"Endere�o:"
cHtml +=						"</span>" + CRLF
cHtml +=						"<span class='dados'>"
cHtml +=								Capital( AllTrim( Desc_End ) ) + "</span>" + CRLF
cHtml +=						"</span>" + CRLF
cHtml +=					"</P>" + CRLF
cHtml +=				"</TD>" + CRLF
cHtml +=				"<TD vAlign=top width='35%' height=1>" + CRLF
cHtml +=					"<P align=left>" + CRLF
cHtml +=						"<span class='etiquetas'>" + "CNPJ:" + CRLF	//"CNPJ:"
cHtml +=						"</span>" + CRLF
cHtml +=						"<span class='dados'>" + CRLF
cHtml +=								Transform( Desc_CGC , "@R 99.999.999/9999-99") + CRLF
cHtml +=						"</span>" + CRLF
cHtml +=					"</P>" + CRLF
cHtml +=				"</TD>" + CRLF
cHtml +=			"</TR>" + CRLF
cHtml +=		"</TBODY>" + CRLF
cHtml +=	"</TABLE>" + CRLF

//Separador
cHtml +=	"<TABLE border='0' cellpadding='0' cellspacing='0' style='border-collapse: collapse' bordercolor='#FFFFFF' bordercolordark='#FFFFFF'bordercolorlight='#FFFFFF' width='100%' id='AutoNumber1'>" + CRLF
cHtml +=		"<TBODY>" + CRLF
cHtml +=			"<TR>" + CRLF
cHtml +=				"<TD vAlign=top width='100%' height=1>" + CRLF
cHtml +=				"</TD>" + CRLF
cHtml +=	 		"</TR>" + CRLF
cHtml +=		"</TBODY>" + CRLF
cHtml +=	"</TABLE>" + CRLF

//Data do Credito e Conta Corrente
cHtml +=	"<TABLE border='2' cellpadding='0' cellspacing='0' style='border-collapse: collapse' bordercolor='#111111' width='100%' id='AutoNumber1'>" + CRLF
cHtml +=		"<TBODY>" + CRLF
cHtml +=				"<TD vAlign=top width='40%' height=1>" + CRLF
cHtml +=					"<P align=left>" + CRLF
cHtml +=						"<span class='etiquetas'>" + "Cr�dito em:" + CRLF //"Cr�dito em:"
cHtml +=						"</span>" + CRLF
cHtml +=						"<span class='dados'>" + CRLF
cHtml +=								Dtoc(dDataPagto) + CRLF
cHtml +=						"</span>" + CRLF
cHtml +=					"</P>" + CRLF
cHtml +=				"</TD>" + CRLF
cHtml +=				"<TD vAlign=top width='60%' height=1>" + CRLF
cHtml +=					"<P align=left>" + CRLF
cHtml +=						"<span class='etiquetas'>" + "Banco/Ag�ncia/Conta:" + CRLF //"Banco/Ag�ncia/Conta:"
cHtml +=						"</span>" + CRLF
cHtml +=						"<span class='dados'>" + CRLF
cHtml +=								AllTrim( Transform( SRA->RA_BCDEPSA , "@R 999/999999" ) ) + "/" + SRA->RA_CTDEPSA + CRLF
cHtml +=						"</span>" + CRLF
cHtml +=					"</P>" + CRLF
cHtml +=				"</TD>" + CRLF
cHtml +=			"</TR>" + CRLF
cHtml +=		"</TBODY>" + CRLF
cHtml +=	"</TABLE>" + CRLF

//Separador
cHtml +=	"<TABLE border='0' cellpadding='0' cellspacing='0' style='border-collapse: collapse' bordercolor='#FFFFFF' bordercolordark='#FFFFFF'bordercolorlight='#FFFFFF' width='100%' id='AutoNumber1'>" + CRLF
cHtml +=		"<TBODY>" + CRLF
cHtml +=			"<TR>" + CRLF
cHtml +=				"<TD vAlign=top width='100%' height=1>" + CRLF
cHtml +=				"</TD>" + CRLF
cHtml +=	 		"</TR>" + CRLF
cHtml +=		"</TBODY>" + CRLF
cHtml +=	"</TABLE>" + CRLF

//Referencia
cHtml +=	"<TABLE border='2' cellpadding='0' cellspacing='0' style='border-collapse: collapse' bordercolor='#111111' width='100%' id='AutoNumber1'>" + CRLF
cHtml +=		"<TBODY>" + CRLF
cHtml +=			"<TR>" + CRLF
cHtml +=				"<TD vAlign=top width='100%' height=1>" + CRLF
cHtml +=					"<P align=left>" + CRLF
cHtml +=						"<span class='etiquetas'>" +  "Refer�ncia:" + CRLF //"Refer�ncia:"
cHtml += 						"</span>" + CRLF
cHtml +=						"<span class='dados'>" + CRLF
cHtml +=								cReferencia + CRLF
cHtml += 						"</span>" + CRLF
cHtml +=					"</P>" + CRLF
cHtml +=				"</TD>" + CRLF
cHtml +=	 		"</TR>" + CRLF
cHtml +=		"</TBODY>" + CRLF
cHtml +=	"</TABLE>" + CRLF

//Separador
cHtml +=	"<TABLE border='0' cellpadding='0' cellspacing='0' style='border-collapse: collapse' bordercolor='#FFFFFF' bordercolordark='#FFFFFF'bordercolorlight='#FFFFFF' width='100%' id='AutoNumber1'>" + CRLF
cHtml +=		"<TBODY>" + CRLF
cHtml +=			"<TR>" + CRLF
cHtml +=				"<TD vAlign=top width='100%' height=5>" + CRLF
cHtml +=				"</TD>" + CRLF
cHtml +=	 		"</TR>" + CRLF
cHtml +=		"</TBODY>" + CRLF
cHtml +=	"</TABLE>" + CRLF

//Nome e Matricula
cHtml +=	"<TABLE border='2' cellpadding='0' cellspacing='0' style='border-collapse: collapse' bordercolor='#111111' width='100%' id='AutoNumber1'>" + CRLF
cHtml +=		"<TBODY>" + CRLF
cHtml +=			"<TR>" + CRLF
cHtml +=				"<TD vAlign=top width='75%' height=1>" + CRLF
cHtml +=					"<P align=left>" + CRLF
cHtml +=						"<span class='etiquetas'>" + "Nome:"  + CRLF // Nome:
cHtml += 						"</span>" + CRLF
cHtml +=						"<span class='dados'>" + CRLF
cHtml +=								Capital( AllTrim( SRA->RA_NOME ) ) + CRLF
cHtml += 						"</span>" + CRLF
cHtml +=					"</P>" + CRLF
cHtml +=				"</TD>" + CRLF
cHtml +=				"<TD vAlign=top width='25%' height=1>" + CRLF
cHtml +=					"<P align=left>" + CRLF
cHtml +=						"<span class='etiquetas'>" + "Matricula:" + CRLF //"Matricula:"
cHtml += 						"</span>" + CRLF
cHtml +=						"<span class='dados'>" + CRLF
cHtml +=								SRA->RA_MAT + CRLF
cHtml += 						"</span>" + CRLF
cHtml +=					"</P>" + CRLF
cHtml +=				"</TD>" + CRLF
cHtml +=			"</TR>" + CRLF
cHtml +=		"</TBODY>" + CRLF
cHtml +=	"</TABLE>" + CRLF

//Separador
cHtml +=	"<TABLE border='0' cellpadding='0' cellspacing='0' style='border-collapse: collapse' bordercolor='#FFFFFF' bordercolordark='#FFFFFF'bordercolorlight='#FFFFFF' width='100%' id='AutoNumber1'>" + CRLF
cHtml +=		"<TBODY>" + CRLF
cHtml +=			"<TR>" + CRLF
cHtml +=				"<TD vAlign=top width='100%' height=1>" + CRLF
cHtml +=				"</TD>" + CRLF
cHtml +=	 		"</TR>" + CRLF
cHtml +=		"</TBODY>" + CRLF
cHtml +=	"</TABLE>" + CRLF

//CTPS, Serie e CPF
cHtml +=	"<TABLE border='2' cellpadding='0' cellspacing='0' style='border-collapse: collapse' bordercolor='#111111' width='100%' id='AutoNumber1'>" + CRLF
cHtml +=		"<TBODY>" + CRLF
cHtml +=			"<TR>" + CRLF
cHtml +=				"<TD vAlign=top width='100' height=1>" + CRLF
cHtml +=					"<P align=left>" + CRLF
cHtml +=						"<span class='etiquetas'>" + "CTPS:" + CRLF	//"CTPS:"
cHtml += 						"</span>" + CRLF
cHtml +=						"<span class='dados'>" + CRLF
cHtml +=							SRA->RA_NUMCP + CRLF
cHtml += 						"</span>" + CRLF
cHtml +=					"</P>" + CRLF
cHtml +=				"</TD>" + CRLF
cHtml +=				"<TD vAlign=top width='100' height=1>" + CRLF
cHtml +=					"<P align=left>" + CRLF
cHtml +=						"<span class='etiquetas'>" + "S�rie:" + CRLF //"S�rie:"
cHtml += 						"</span>" + CRLF
cHtml +=						"<span class='dados'>" + CRLF
cHtml +=								SRA->RA_SERCP + CRLF
cHtml += 						"</span>" + CRLF
cHtml +=					"</P>" + CRLF
cHtml +=				"</TD>" + CRLF
cHtml +=				"<TD vAlign=top width='172' height=1>" + CRLF
cHtml +=					"<P align=left>" + CRLF
cHtml +=						"<span class='etiquetas'>" + "CPF:" + CRLF //"CPF:"
cHtml += 						"</span>" + CRLF
cHtml +=						"<span class='dados'>" + CRLF
cHtml +=								Transform( SRA->RA_CIC , "@R 999.999.999-99" ) + CRLF
cHtml += 						"</span>" + CRLF
cHtml +=					"</P>" + CRLF
cHtml +=				"</TD>" + CRLF
cHtml +=	 		"</TR>" + CRLF
cHtml +=		"</TBODY>" + CRLF
cHtml +=	"</TABLE>" + CRLF

//Separador
cHtml +=	"<TABLE border='0' cellpadding='0' cellspacing='0' style='border-collapse: collapse' bordercolor='#FFFFFF' bordercolordark='#FFFFFF'bordercolorlight='#FFFFFF' width='100%' id='AutoNumber1'>" + CRLF
cHtml +=		"<TBODY>" + CRLF
cHtml +=			"<TR>" + CRLF
cHtml +=				"<TD vAlign=top width='100%' height=1>" + CRLF
cHtml +=				"</TD>" + CRLF
cHtml +=	 		"</TR>" + CRLF
cHtml +=		"</TBODY>" + CRLF
cHtml +=	"</TABLE>" + CRLF

cHtml +=	"<TABLE border='2' cellpadding='0' cellspacing='0' style='border-collapse: collapse' bordercolor='#111111' width='100%' id='AutoNumber1'>" + CRLF
cHtml +=		"</TBODY>" + CRLF
cHtml +=			"<TR>" + CRLF
cHtml +=				"<TD vAlign=top width='60%' height=1>" + CRLF
cHtml +=					"<P align=left>" + CRLF
cHtml +=						"<span class='etiquetas'>" + "Funcao"  + CRLF //Funcao
cHtml += 						"</span>" + CRLF
cHtml +=						"<span class='dados'>" + CRLF
cHtml +=								Capital( AllTrim( cDescFunc ) ) + CRLF
cHtml += 						"</span>" + CRLF
cHtml +=					"</P>" + CRLF
cHtml +=				"</TD>" + CRLF
cHtml +=				"<TD vAlign=top width='40%' height=1>" + CRLF
cHtml +=					"<P align=left>" + CRLF
cHtml +=						"<span class='etiquetas'>" + "Sal�rio Nominal:" + CRLF //Sal�rio Nominal:
cHtml += 						"</span>" + CRLF
cHtml +=						"<span class='dados'>" + CRLF
cHtml +=								Transform( nSalario , cPict1 ) + CRLF
cHtml += 						"</span>" + CRLF
cHtml +=					"</P>" + CRLF
cHtml +=				"</TD>" + CRLF
cHtml +=			"</TR>" + CRLF
cHtml +=		"</TBODY>" + CRLF
cHtml +=	"</TABLE>" + CRLF

//Separador
cHtml +=	"<TABLE border='0' cellpadding='0' cellspacing='0' style='border-collapse: collapse' bordercolor='#FFFFFF' bordercolordark='#FFFFFF'bordercolorlight='#FFFFFF' width='100%' id='AutoNumber1'>" + CRLF
cHtml +=		"<TBODY>" + CRLF
cHtml +=			"<TR>" + CRLF
cHtml +=				"<TD vAlign=top width='100%' height=1>" + CRLF
cHtml +=				"</TD>" + CRLF
cHtml +=	 		"</TR>" + CRLF
cHtml +=		"</TBODY>" + CRLF
cHtml +=	"</TABLE>" + CRLF

//Centro de Custo
cHtml +=	"<TABLE border='2' cellpadding='0' cellspacing='0' style='border-collapse: collapse' bordercolor='#111111' width='100%' id='AutoNumber1'>" + CRLF
cHtml +=		"<TBODY>" + CRLF
cHtml +=			"<TR>" + CRLF
cHtml +=				"<TD vAlign=top width='100%' height=1>" + CRLF
cHtml +=					"<P align=left>" + CRLF
cHtml +=						"<span class='etiquetas'>" + "Centro de Custo:" + CRLF //Centro de Custo:
cHtml += 						"</span>" + CRLF
cHtml +=						"<span class='dados'>" + CRLF
cHtml +=								AllTrim( SRA->RA_CC ) + " - " + Capital( AllTrim(fDesc("SI3",SRA->RA_CC,"I3_DESC",TamSx3("I3_DESC")[1]) ) ) + CRLF
cHtml += 						"</span>" + CRLF
cHtml +=					"</P>" + CRLF
cHtml +=				"</TD>" + CRLF
cHtml +=			"</TR>" + CRLF
cHtml +=		"</TBODY>" + CRLF
cHtml +=	"</TABLE>" + CRLF

//Separador
cHtml +=	"<TABLE border='0' cellpadding='0' cellspacing='0' style='border-collapse: collapse' bordercolor='#FFFFFF' bordercolordark='#FFFFFF'bordercolorlight='#FFFFFF' width='100%' id='AutoNumber1'>" + CRLF
cHtml +=		"<TBODY>" + CRLF
cHtml +=			"<TR>" + CRLF
cHtml +=				"<TD vAlign=top width='100%' height=1>" + CRLF
cHtml +=				"</TD>" + CRLF
cHtml +=	 		"</TR>" + CRLF
cHtml +=		"</TBODY>" + CRLF
cHtml +=	"</TABLE>" + CRLF

//Admissao
cHtml +=	"<TABLE border='2' cellpadding='0' cellspacing='0' style='border-collapse: collapse' bordercolor='#111111' width='100%' id='AutoNumber1'>" + CRLF
cHtml +=		"<TBODY>" + CRLF
cHtml +=			"<TR>" + CRLF
cHtml +=				"<TD vAlign=top width='329' height=1>" + CRLF
cHtml +=					"<P align=left>" + CRLF
cHtml +=						"<span class='etiquetas'>" + "Admiss�o:" + CRLF //"Admiss�o:"
cHtml += 						"</span>" + CRLF
cHtml +=						"<span class='dados'>" + CRLF
cHtml +=								Dtoc( SRA->RA_ADMISSA ) + CRLF
cHtml +=						"</span>" + CRLF
cHtml +=					"</P>" + CRLF
cHtml +=				"</TD>" + CRLF
cHtml +=				"<TD vAlign=top width='231' height=1>" + CRLF
cHtml +=					"<P align=left>" + CRLF
cHtml +=						"<span class='etiquetas'>" + "Dependente(s) IR:" + CRLF //"Dependente(s) IR:"
cHtml += 						"</span>" + CRLF
cHtml +=						"<span class='dados'>" + CRLF
cHtml +=								SRA->RA_DEPIR + CRLF
cHtml += 						"</span>" + CRLF
cHtml +=					"</P>" + CRLF
cHtml +=				"</TD>" + CRLF
cHtml +=				"<TD vAlign=top width='390' height=1>" + CRLF
cHtml +=					"<P align=left>" + CRLF
cHtml +=						"<span class='etiquetas'>" + "Dependente(s) Sal�rio Fam�lia:" + CRLF //"Dependente(s) Sal�rio Fam�lia:"
cHtml += 						"</span>" + CRLF
cHtml +=						"<span class='dados'>" + CRLF
cHtml +=								SRA->RA_DEPSF + CRLF
cHtml += 						"</span>" + CRLF
cHtml +=					"</P>" + CRLF
cHtml +=				"</TD>" + CRLF
cHtml +=			"</TR>" + CRLF
cHtml +=		"</TBODY>" + CRLF
cHtml +=	"</TABLE>" + CRLF

Return( cHtml )

/*
�����������������������������������������������������������������������Ŀ
�Fun��o	   �RodaHtml  		�Autor�Marinaldo de Jesus � Data �18/09/2003�
�����������������������������������������������������������������������Ĵ
�Descri��o �Retorna Rodape HTML para o RHOnLine                         �
�����������������������������������������������������������������������Ĵ
�Sintaxe   �<Vide Parametros Formais>									�
�����������������������������������������������������������������������Ĵ
�Parametros�<Vide Parametros Formais>									�
�����������������������������������������������������������������������Ĵ
�Retorno   �cHtml  														�
�����������������������������������������������������������������������Ĵ
�Uso	   �GPER030       										    	�
�������������������������������������������������������������������������*/
Static Function RodaHtml()

Local cHtml	:= ""

cHtml +=	"<TABLE border='2' cellpadding='0' cellspacing='0' style='border-collapse: collapse' bordercolor='#111111' width='100%' id='AutoNumber1'>" + CRLF
cHtml +=		"<TBODY>" + CRLF
cHtml +=			"<TR>" + CRLF
cHtml +=				"<TD vAlign=top height=1>" + CRLF
cHtml +=					"<P align=center>" + CRLF
cHtml += 							"V�lido como Comprovante Mensal de Rendimentos" + CRLF //'"V�lido como Comprovante Mensal de Rendimentos"'
cHtml +=						"<br>" + CRLF
cHtml += 							"( Artigo no. 41 e 464 da CLT, Portaria MTPS/GM 3.626 de 13/11/1991 )" + CRLF //"( Artigo no. 41 e 464 da CLT, Portaria MTPS/GM 3.626 de 13/11/1991 )"
cHtml +=					"</P>" + CRLF
cHtml +=				"</TD>" + CRLF
cHtml +=			"</TR>" + CRLF
cHtml +=		"</TBODY>" + CRLF
cHtml +=	"</TABLE>" + CRLF

Return( cHtml )

/*
�����������������������������������������������������������������������Ŀ
�Fun��o	   �fMontaDtTcf 	�Autor�Ricardo Duarte     � Data �13/08/2004�
�����������������������������������������������������������������������Ĵ
�Descri��o �Retorna a data valida para a consulta do Terminal Consulta  �
�          �do Funcionario                                         		�
�����������������������������������������������������������������������Ĵ
�Sintaxe   �<Vide Parametros Formais>									�
�����������������������������������������������������������������������Ĵ
�Parametros�<Vide Parametros Formais>									�
�����������������������������������������������������������������������Ĵ
�Retorno   �cHtml  														�
�����������������������������������������������������������������������Ĵ
�Uso	   �GPER030       										    	�
�������������������������������������������������������������������������*/
Static Function fMontaDtTcf(cMesAno)

Local dDataValida
Local nDia := getmv("MV_TCFDFOL")

dDataValida := stod(right(cMesAno,4)+left(cMesAno,2)+"01")
dDataValida := stod(right(cMesAno,4)+left(cMesAno,2)+strzero(f_UltDia(dDataValida),2))+nDia
return(dDataValida)

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �fImpGrf   � Autor � Microsiga             � Data � 27.05.07 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � IMRESSAO DO RECIBO FORMULARIO Grafico                      ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   � fImpGrf()                                                  ���
�������������������������������������������������������������������������Ĵ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������*/
Static Function fImpGrf()

Local nConta  := 0
Local nContr  := 0
Local nContrT := 0
nLinhas       := 19              // Numero de Linhas do Miolo do Recibo

If lFirst
	_oPrint:SetPortrait()         // ou SetLandscape()
	lFirst  := .f.
endIf

If _cont >= 3000
	_cont:= 0
	_oPrint:StartPage()           // Inicia uma nova p�gina
Else
	_oPrint:Say( 1580, 0010, replicate("-", 240), _oFont10)
Endif

// Imprime Cabecalho
fCabecGrf()
nLin := 450

For nConta = 1 To Len(aLanca)
	fLanGrf(nConta)
	nContr ++
	nContrT ++
	If nContr = nLinhas .And. nContrT < Len(aLanca)
		nContr:=0
		_oPrint:Say(_cont+0100, 0600, " *** CONTINUA *** ", _oFont14) //Nome da Empresa CONTUFLEX
		_cont := 1550
		fCabecGrf()
		nLin := 450
	Endif
Next nConta

// Imprime o rodap�
fRodaGrf()
_cont += 1550

If _cont  > 3000
	_oPrint:EndPage()     // Finaliza a p�gina
EndIf

Return Nil

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �fImpGrf   � Autor � Microsiga           � Data � 27.05.07   ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   � fCabecGrf()                                                ���
�������������������������������������������������������������������������Ĵ��
���Fun��o para impress�o do Cabe�alho                                     ���
�������������������������������������������������������������������������Ĵ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������*/
Static Function fCabecGrf()

Local cCodFunc		:= ""		//-- codigo da Funcao do funcionario
Local cDescFunc	:= ""		//-- Descricao da Funcao do Funcionario

/*��������������������������������������������������������������Ŀ
� Carrega Funcao do Funcion. de acordo com a Dt Referencia     �
����������������������������������������������������������������*/
fBuscaFunc(dDataRef, @cCodFunc, @cDescFunc   )

//cDescFunc := Alltrim(Posicione("SRJ", 1, xFilial("SRJ") + cCodFunc, "RJ_DESC"))
cDescFunc := Alltrim(Posicione("SRJ", 1, xFilial("SRJ") + ALLTRIM(SRA->RA_CODFUNC), "RJ_DESC"))

//Cabe�alho do holerite dados da empresa
_cont+=40                                                 //Margem Para Cabecalho
//Linha 1
_oPrint:Say(_cont+010, 0600, Desc_Fil, _oFont14) //Nome da Empresa  /_aEmp[1]
//Linha 2
_oPrint:Say(_cont+080, 0600, Desc_End + "  -  "+ Desc_Bairro , _oFont10) //Endere�o da Empresa // _aEmp[2]
//Linha 3
_oPrint:Say(_cont+120, 0600, 	Desc_Cid + " - " + Desc_Est + "  -  "+ Desc_CEP , _oFont10) //Cidade da empresa / /_aEmp[3]
//Linha 4
_oPrint:Say(_cont+160, 0600, Desc_CGC , _oFont10) //Cnpj // _aEmp[5]
//Linha 5
_oPrint:Say(_cont+160, 1100, Desc_IE, _oFont10) //IE _aEmp[6]

//Imagem logo do lado Esquerdo do holerite
_oPrint:SayBitmap(_cont+010, 0120, _cfig, 200, 200)

//Titulo do Holerite e a base do mes
//Quadrante Box que ira receber o titulo
_oPrint:Box(_cont+0220, 0100, _cont+0290, 2300)
//Titulo
_reltipo := " Recibo de Pagamento de Sal�rio"
_oPrint:Say(_cont+0230, 0600,_reltipo, _oFont16)
//Mes e ano de Base de Pagamento
_oPrint:Say(_cont+0230, 1900,MesExtenso(MONTH(dDataRef))+"/"+STR(YEAR(dDataRef),4), _oFont16)

//Dados do Funcionario
//Quadrante Box que ira receber os dados do funcionarios
_oPrint:Box(_cont+0300, 0100, _cont+0380, 2300)

//Linha 1
_oPrint:Say(_cont+0310, 0115, SRA->RA_MAT + " - " + SRA->RA_NOME, _oFont8b)//codigo
_oPrint:Say(_cont+0310, 1400, "Centro de Custo: " , _oFont8)//cto Custo
_oPrint:Say(_cont+0310, 1650, Alltrim(SRA->RA_CC) + " - " + Alltrim(Posicione("CTT",1,xFilial("CTT") + SRA->RA_CC,"CTT_DESC01")), _oFont8)//cto custo

//Linha 2
_oPrint:Say(_cont+0345, 0115, "Fun��o:"                    , _oFont8)//Titulo Funcao
_oPrint:Say(_cont+0345, 0235, Alltrim(cCodFunc) +" - "+ Alltrim(cDescFunc), _oFont8)//Campo Codigo da Funcao
_oPrint:Say(_cont+0345, 0650,  "C.B.O.: " + Alltrim(Posicione("SRJ",1,xFilial("SRJ") + SRA->RA_CODFUNC, "RJ_CODCBO") ), _oFont8)//Campo descricao da Funcao
_oPrint:Say(_cont+0345, 1400, "Data Admiss�o:"          , _oFont8)//Titulo Data Admissao
_oPrint:Say(_cont+0345, 1650, dtoc(SRA->RA_ADMISSA) , _oFont8)//Campo Data Admissao

//Titulo dos Dados do Holerite
//Quadrante Box que ira receber os dados do Holerite
_oPrint:Box(_cont+0390, 0100, _cont+1380, 2300)
//Divisao Linha e Titulo Codigo
_oPrint:Line(_cont+0450, 0100, _cont+0450, 2300)
_oPrint:Say(_cont+0400, 0115, "C�d."            , _oFont8b)
//Divisao Linha e Titulo Descricao
_oPrint:Line(_cont+0390, 0250, _cont+1080, 0250)
_oPrint:Say(_cont+0400, 0650, "Descri��o"    , _oFont8b)
//Divisao Linha e Titulo Referencia
_oPrint:Line(_cont+0390, 1135, _cont+1080, 1135)
_oPrint:Say(_cont+0400, 1150, "Refer�ncia"    , _oFont8b)
//Divisao Linha e Titulo Vencimento
_oPrint:Line(_cont+0390, 1300, _cont+1380, 1300)
_oPrint:Say(_cont+0400, 1450, "Vencimentos", _oFont8b)
//Divisao Linha e Titulo Descontos
_oPrint:Line(_cont+0390, 1800, _cont+1380, 1800)
_oPrint:Say(_cont+0400, 1950, "Descontos"   , _oFont8b)

Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �fLanGrf   � Autor � Microsiga           � Data � 27.05.07   ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   � fLanGrf()                                                  ���
�������������������������������������������������������������������������Ĵ��
���Fun��o para impress�o do Detalhe                                       ���
�������������������������������������������������������������������������Ĵ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������*/
Static Function fLanGrf(nConta)

Local	cString := Transform(aLanca[nConta,5],cPict2)
Local 	nCol := If(aLanca[nConta,1]="P",1600,If(aLanca[nConta,1]="D",2000,27))

_oPrint:Say(_cont+nLin, 0115, aLanca[nConta,2], _oFont8) //Nome da Empresa
_oPrint:Say(_cont+nLin, 0300, aLanca[nConta,3], _oFont8) //Nome da Empresa
If aLanca[nConta,1] # "B"        // So Imprime se nao for base
	_oPrint:Say(_cont+nLin, 1170, TRANSFORM(aLanca[nConta,4],"999.99"), _oFont8) //Nome da Empresa
Endif
_oPrint:Say(_cont+nLin, nCol, cString, _oFont8) //Nome da Empresa CONTUFLEX
nLin += 40
Return


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �fRodaGrf  � Autor � Microsiga             � Data � 27.05.07 ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   � fRodaGrf()                                                 ���
�������������������������������������������������������������������������Ĵ��
���Fun��o para impress�o do Rodap� do Holerit                             ���
�������������������������������������������������������������������������Ĵ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������*/
Static Function fRodaGrf()

//Divisao linha para mensagens e os totais
_oPrint:Line(_cont+1080, 0100, _cont+1080, 2300)
_oPrint:Say(_cont+1090, 1450, "Total de Vencimentos", _oFont8b)
_oPrint:Say(_cont+1090, 1950, "Total de Descontos"   , _oFont8b)

//Divisao linha para Valor Liquido
_oPrint:Line(_cont+1180,1300, _cont+1180, 2300)
_oPrint:Say(_cont+1205, 1315, "Valor Liquido      ==>"   , _oFont10b)

//Quadrante BOX e Imprime os Titulos dos Totais de Base
_oPrint:Box(_cont+1280, 0100, _cont+1380, 2300)
_oPrint:Say(_cont+1295, 0150, "Sal�rio-Base"   , _oFont8b)
_oPrint:Say(_cont+1295, 0500, "Sal. Contr. INSS" , _oFont8b)
_oPrint:Say(_cont+1295, 1000, "Base C�lc. FGTS"  , _oFont8b)
_oPrint:Say(_cont+1295, 1310, "F.G.T.S. do M�s"  , _oFont8b)
_oPrint:Say(_cont+1295, 1590, "Base C�lc. IRRF"  , _oFont8b)
//	_oPrint:Say(_cont+1295, 2000, "Faixa IRRF"   , _oFont8b)

//Quadrante Box e Imprime a Mensagem de Creito automatico.
_oPrint:Box(_cont+1390, 0100, _cont+1500, 2300)
_oPrint:Say(_cont+1395, 0150, "***************** - CREDITO AUTOMATICO EM CONTA CORRENTE - ************"   , _oFont8b)
_oPrint:Say(_cont+1450, 0150, "_____ / _____ / ________ "   , _oFont10)
_oPrint:Say(_cont+1450, 1000, "Assinatura:  " + Replicate("_", 40)  , _oFont10)

// Impressao das Mensagens
_oPrint:Say(_cont+1080, 0115, DESC_MSG1, _oFont8) //Mensagem 1
_oPrint:Say(_cont+1120, 0115, DESC_MSG2, _oFont8) //Mensagem 2
_oPrint:Say(_cont+1160, 0115, DESC_MSG3, _oFont8) //Mensagem 3

If Month(dDataRef) == Month(SRA->RA_NASC)
	_oPrint:Say(_cont+1200, 0115, "F E L I Z   A N I V E R S A R I O ! !", _oFont8)
EndIf

//Mensagens da conta corrente
If SRA->RA_BCDEPSAL # SPACE(8)
	Desc_Bco := "Banco Brasil "
	_oPrint:Say(_cont+1240, 0115, "Credito: "+Transform(Sra->Ra_BcDepSal,"@R 999/99999") +" - " +DESC_BCO+" Conta: " + SRA->RA_CTDEPSAL, _oFont8)
EndIf

//Impressao dos Totais Do campo Vencimentos
If TOTVENC <= 9.99
	_oPrint:Say(_cont+1130, 1660,TRANSFORM(TOTVENC,cPict1), _oFont8)
Endif

//Impressao dos Totais Do campo Vencimentos
If TOTVENC <= 99.99 .and. TOTVENC > 9.99
	_oPrint:Say(_cont+1130, 1650,TRANSFORM(TOTVENC,cPict1), _oFont8)
Endif

If TOTVENC <= 999.99 .and. TOTVENC > 99.99
	_oPrint:Say(_cont+1130, 1640,TRANSFORM(TOTVENC,cPict1), _oFont8)
Endif

If TOTVENC <= 999999.99 .and. TOTVENC > 999.99
	_oPrint:Say(_cont+1130, 1630,TRANSFORM(TOTVENC,cPict1), _oFont8)
Endif

//Impressao dos Totais Do campo Descontos
If TOTDESC <= 9.99
	_oPrint:Say(_cont+1130, 2160,TRANSFORM(TOTDESC,cPict1), _oFont8)
Endif

If TOTDESC <= 99.99 .and. TOTDESC > 9.99
	_oPrint:Say(_cont+1130, 2150,TRANSFORM(TOTDESC,cPict1), _oFont8)
Endif

If TOTDESC <= 999.99 .and. TOTDESC > 99.99
	_oPrint:Say(_cont+1130, 2140,TRANSFORM(TOTDESC,cPict1), _oFont8)
Endif

If TOTDESC <= 9999.99 .and. TOTDESC > 999.99
	_oPrint:Say(_cont+1130, 2130,TRANSFORM(TOTDESC,cPict1), _oFont8)
Endif

//Impressao dos Totais do Campo Valor Liquido
If (TOTVENC-TOTDESC) <= 9.99
	_oPrint:Say(_cont+1205, 2160,TRANSFORM((TOTVENC-TOTDESC),cPict1), _oFont8)
Endif

If (TOTVENC-TOTDESC) <= 99.99 .and. (TOTVENC-TOTDESC) > 9.99
	_oPrint:Say(_cont+1205, 2150,TRANSFORM((TOTVENC-TOTDESC),cPict1), _oFont8)
Endif

If (TOTVENC-TOTDESC) <= 999.99 .and. (TOTVENC-TOTDESC) > 99.99
	_oPrint:Say(_cont+1205, 2140,TRANSFORM((TOTVENC-TOTDESC),cPict1), _oFont8)
Endif

If (TOTVENC-TOTDESC) <= 999999.99 .and. (TOTVENC-TOTDESC) > 999.99
	_oPrint:Say(_cont+1205, 2130,TRANSFORM((TOTVENC-TOTDESC),cPict1), _oFont8)
Endif

//Imprime Salario Base
If !Empty( cAliasMov )
	nValSal := 0
	nValSal := fBuscaSal(dDataRef)
	If nValSal ==0
		nValSal := SRA->RA_SALARIO
	EndIf
Else
	nValSal := SRA->RA_SALARIO
EndIf
_oPrint:Say(_cont+1325, 0150, Transform(nValSal,cPict2) , _oFont8)

If Esc = 1  // Bases de Adiantamento
	If cBaseAux = "S" .And. nBaseIr # 0
		_oPrint:Say(_cont+1325, 1600, TRANSFORM(nBaseIr,cPict1) , _oFont8)
	Endif
ElseIf Esc = 2 .Or. Esc = 4  // Bases de Folha e 13o. 2o.Parc.
	If cBaseAux = "S"
		_oPrint:Say(_cont+1325, 0500,Transform(nAteLim,cPict1) , _oFont8)
		If nBaseFgts # 0
			_oPrint:Say(_cont+1325, 1000, TRANSFORM(nBaseFgts,cPict1) , _oFont8)
		Endif
		If nFgts # 0
			_oPrint:Say(_cont+1325, 1300,TRANSFORM(nFgts,cPict2) , _oFont8)
		Endif
		If nBaseIr # 0
			_oPrint:Say(_cont+1325, 1600,TRANSFORM(nBaseIr,cPict1) , _oFont8)
		Endif
		//		_oPrint:Say(_cont+1325, 2000, Transform(nBaseIrfE,cPict1) , _oFont8)
	Endif
ElseIf Esc = 3 // Bases de FGTS e FGTS Depositado da 1� Parcela
	If cBaseAux = "S"
		If nBaseFgts # 0
			_oPrint:Say(_cont+1325, 0800,TRANSFORM(nBaseFgts,cPict1), _oFont8)
		Endif
		If nFgts # 0
			_oPrint:Say(_cont+1325, 1300, TRANSFORM(nFgts,cPict2) , _oFont8)
		Endif
	Endif
Endif

Return()
