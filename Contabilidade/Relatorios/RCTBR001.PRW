#INCLUDE "PROTHEUS.CH"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ RCTBR001 ³ Autor ³ Claudio Ferreira      ³ Data ³ 20/05/10 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Impressao do Plano de Contas x Conta Referencial           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ SIGACTB                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/                         

User Function RCTBR001()
//³ Define Variaveis                                             ³
LOCAL wnrel
LOCAL cString:="CT1"

LOCAL aOrd	 := {} 
LOCAL cDesc1 := OemToAnsi("Este programa ir  imprimir o Plano de Contas.")  //"Este programa ir  imprimir o Plano de Contas."
LOCAL cDesc2 := OemToAnsi("Ser  impresso de acordo com os parƒmetros solicitados pelo")  //"Ser  impresso de acordo com os parƒmetros solicitados pelo"
LOCAL cDesc3 := OemToAnsi("usu rio.")  //"usu rio."
Local Tamanho:="M"

PRIVATE aReturn := { OemToAnsi("Zebrado"), 1,OemToAnsi("Administracao"), 2, 2, 1, "",1 }  //"Zebrado"###"Administracao"
PRIVATE nomeprog:="RCTBR001"
PRIVATE aLinha  := { },nLastKey := 0
PRIVATE cPerg   :="RCTBR001"
PRIVATE titulo:= OemToAnsi("Listagem do Plano de Contas")  //"Listagem do Plano de Contas"
PRIVATE cabec1 := OemToAnsi("CONTA                          D E N O M I N A C A O                   CLASSE      TIPO CTA.  CTA REF.")
PRIVATE cabec2 := " "
PRIVATE cCancel:= OemToAnsi("***** CANCELADO PELO OPERADOR *****")  //"***** CANCELADO PELO OPERADOR *****"

li       := 80
m_pag    := 1           


ValidPerg()          // Cria pergunta
pergunte(cPerg,.f.)            

wnrel:="RCTBR001"            //Nome Default do relatorio em Disco
wnrel:=SetPrint(cString,wnrel,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,,Tamanho)

If nLastKey == 27
	Set Filter To
	Return
Endif

SetDefault(aReturn,cString)


If nLastKey == 27
	Set Filter To
	Return
Endif

RptStatus({|lEnd| RCTBR001Imp(@lEnd,wnRel,cString)})

Return

Static Function RCTBR001Imp(lEnd,WnRel,cString)
LOCAL tamanho:="M"
LOCAL limite := 132
LOCAL cClasse
Local cMascara
Local cSeparador 	:= ""

cMascara := GetMv("MV_MASCARA")

cEntidade:= mv_par01

dbSelectArea("CT1")
dbSetOrder( 1 )
DBSeek(xFilial('CT1'))

SetRegua(RecCount())   						// Total de elementos da regua

dbSelectArea("CT1")
dbSetOrder(1)
cCondicao:=	" !Eof() .and. CT1->CT1_FILIAL=xFilial('CT1') "

m_pag:=1

While &cCondicao
	If lEnd 	
		@Prow()+1,001 PSAY cCancel
		Exit
	EndIF
     
	IncRegua()

		
    IF li > 75
		li:=cabec(titulo,cabec1,cabec2,nomeprog,tamanho,;
		Iif(aReturn[4]==1,GetMv("MV_COMP"),GetMv("MV_NORM")))
    EndIF

	cCodigo:=	Alltrim(CT1_CONTA)
	cDesc := &('CT1->CT1_DESC01')

//    0           1        2          3        4         5         6         7         8         9        10        11        12
//0123456789.123456789.123456789.123456789.123456789.123456789.123456789.123456789.123456789.123456789.123456789.123456789.123456789.12
//CONTA                          D E N O M I N A C A O                      CLASSE      TIPO CTA.  CTA REF.

	if empty(MV_PAR04)
	    cCodPla:=Posicione('CVD',1,xFilial('CVD')+CT1->CT1_CONTA+cEntidade,"CVD_CODPLA") 
	else 
		cCodPla:=MV_PAR04
	endif  
	cCtaRef:=Posicione('CVD',4,xFilial('CVD')+cEntidade+cCodPla+CT1->CT1_CONTA,"CVD_CTAREF") 
	dCtaRef:=Posicione('CVN',2,xFilial('CVN')+cCodPla+cCtaRef,"CVN_DSCCTA") 
	dDtVig:=Posicione('CVN',2,xFilial('CVN')+cCodPla+cCtaRef,"CVN_DTVIGF") 
    lVenc:=!empty(dDtVig).and.year(dDtVig)<year(ddatabase)-1
    if ((mv_par02=2 .or. empty(cCtaRef) .or. lVenc) .and. CT1->CT1_CLASSE == "2" )  .or. (CT1->CT1_CLASSE == "1" .and. mv_par03=1) 
        if empty(cCtaRef) .and. CT1->CT1_CLASSE == "2" 
          dCtaRef:='>>> Não associada <<<'
        endif
        if empty(dCtaRef) .and. CT1->CT1_CLASSE == "2" 
          dCtaRef:='>>> Inválida <<<'
        endif 
        if lVenc .and. CT1->CT1_CLASSE == "2" 
          dCtaRef:='>>> Vencida <<<'
        endif        
		li++
     	EntidadeCTB(CT1->CT1_CONTA,li,000,030,.F.,cMascara,cSeparador)
    	@li, 031 PSAY Substr(cDesc,1,35)
	    @li, 071 PSAY If (CT1->CT1_CLASSE == "1", "Sintética", "Analitica")
     	@li, 083 PSAY IF (CT1->CT1_NORMAL == "1", "Debito", "Credito")
	    @li, 092 PSAY Substr(cCtaRef,1,16)+' '+Substr(dCtaRef,1,24)
	Endif 
	dbSelectArea("CT1")   
	dbSkip( )
EndDo



dbSelectarea( "CT1" )
dbSetOrder( 1 )

Set Filter To
If aReturn[5] = 1
	Set Printer To
	Commit
	ourspool(wnrel)
Endif
MS_FLUSH()

Return

Static Function ValidPerg()
_sAlias	:=	Alias()
dbSelectArea("SX1")
dbSetOrder(1)
cPerg 	:=	PADR(cPerg,10)
//                                                                                     -SA1-
putSx1(cPerg,"01","Entidade    ?","."     ,"."       ,"mv_ch1","C",02,0,0,"G","","GP","","","mv_par01","","","","","","","","","","","","","","","","")
PutSx1(cPerg,"02","Somente não associadas?","",""    ,"mv_ch2","N",01,0,0,"C","","","",""  ,"mv_par02","Sim","Sim","Sim","Nao","Nao","Nao","","","","","","","","","")
PutSx1(cPerg,"03","Imprime Sinteticas?","",""        ,"mv_ch3","N",01,0,0,"C","","","",""  ,"mv_par03","Sim","Sim","Sim","Nao","Nao","Nao","","","","","","","","","")
PutSx1(cPerg,"04","Plano?","",""        ,"mv_ch4","C",06,0,0,"G","","CVN1","",""  ,"mv_par04","","","","","","","","","","","","","","","")

dbSelectArea(_sAlias)

Return

