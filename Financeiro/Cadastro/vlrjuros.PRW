#INCLUDE "FINR280.CH"
#INCLUDE "PROTHEUS.CH"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ FINR280  ³ Autor ³ Carlos Daniel         ³ Data ³ 29.11.15 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Relacao dos Juros Recebidos                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe e ³ vlrjuros                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
user Function vlrjuros()

Local oReport

Return u_vlrjuR3() // Executa versão anterior do fonte

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ ReportDef³ Autor ³ Carlos Daniel         ³ Data ³ 29/06/06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Definicao do layout do Relatorio									  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ ReportDef(void)                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function ReportDef()
Local cPerg      := "FIN280"  // Nome do grupo de perguntas
Local oReport  
Local oSection1
Local cAliasQry1 := "SE5" //GetNextAlias()
Local aTam1, aTam2, aTam3
Local nMoedaBco := 1

Pergunte(cPerg, .F.)

oReport := TReport():New("vlrjuros",STR0005,cPerg,;
{|oReport| ReportPrint(oReport,@cAliasQry1)},STR0001+' '+STR0002)


aTam1 := TamSX3("E1_CLIENTE")
aTam2 := TamSX3("E1_LOJA")
nTamCli :=	aTam1[1] + aTam2[1] + 1
aTam1 := TamSX3("E5_PREFIXO")
aTam2 := TamSX3("E5_NUMERO")
aTam3 := TamSX3("E5_PARCELA")
nTamTit :=	aTam1[1] + aTam2[1] + aTam3[1] + 2

oSection1 := TRSection():New(oReport,STR0010,{"SE5","SE1","SA1","SED","SA6"},)
TRCell():New(oSection1,"E5_BANCO" 	,"SE5",STR0011,,,.F.,{|| (cAliasQry1)->E5_BANCO})		//"BANCO"
TRCell():New(oSection1,"CLIENLOJA" 	,     ,STR0012,,nTamCli,.F.,/*{|| 	SE1->E1_CLIENTE+' '+SE1->E1_LOJA }*/)	//"CODIGO"
TRCell():New(oSection1,"A1_NREDUZ" 	,"SA1",STR0013,,,.F.,{|| SA1->A1_NREDUZ})	//"CLIENTE"
TRCell():New(oSection1,"E1_NUM"   	,"SE5",STR0014,,nTamTit,.F.,{|| (cAliasQry1)->E5_PREFIXO+"-"+(cAliasQry1)->E5_NUMERO+"-"+(cAliasQry1)->E5_PARCELA})		//"No.TITULO"
TRCell():New(oSection1,"E1_VENCTO"	,"SE1",STR0015,,,.F.,{|| SE1->E1_VENCTO })		//"VENCTO"
TRCell():New(oSection1,"ATRASO"   	,		,STR0016,,5,.F.,{||})	//"ATRASO"
TRCell():New(oSection1,"E5_DATA"  	,"SE5",STR0017,,,.F.,{|| (cAliasQry1)->E5_DATA })		//"PAGTO"
TRCell():New(oSection1,"E1_VLCRUZ"	, "SE1",STR0018,TM(SE1->E1_VLCRUZ,14,MsDecimais(1)),,.F.,/*{||}*/)
TRCell():New(oSection1,"E1_VALJUR"	,"SE1",STR0019,TM(SE1->E1_VLCRUZ,14,MsDecimais(1)),,.F.,{|| nMoedaBco := If(cPaisLoc#"BRA",Max(SA6->A6_MOEDA,1),1),;		//"VALOR JUROS"
																											 xMoeda((cAliasQry1)->E5_VALOR, nMoedaBco, mv_par05, (cAliasQry1)->E5_DATA, MsDecimais(mv_par05)+1) })		

#IFNDEF TOP
	TRPosition():New ( oSection1, "SE1" , 1 ,{|| xfilial("SE1")+SE5->(E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO) } , .T. ) 
	TRPosition():New ( oSection1, "SA1" , 1 ,{|| xfilial("SA1")+SE1->(E1_CLIENTE+E1_LOJA) } , .T. ) 
	TRPosition():New ( oSection1, "SA6" , 1 ,{|| xfilial("SA6")+SA6->(E5_BANCO+E5_AGENCIA+E5_CONTA) } , .T. ) 
#ELSE
	oSection1:SetLineCondition({|| mv_par06 == 1 .OR. mv_par05==Max(SA6->A6_MOEDA,1) })
#ENDIF

                                                      
oReport:SetTotalText(STR0008)
TRFunction():New(oSection1:Cell("E1_VALJUR"),"TOTAL","SUM",,,,,.F.,.T.)
oReport:SetTotalInLine(.F.)
oSection1:SetTotalInLine(.F.)

Return oReport                                                                              

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ReportPrint³ Autor ³Carlos Daniel          ³ Data ³26/06/2006³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³A funcao estatica ReportDef devera ser criada para todos os  ³±±
±±³          ³relatorios que poderao ser agendados pelo usuario.           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³Nenhum                                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ExpO1: Objeto Report do Relatório                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   DATA   ³ Programador   ³Manutencao efetuada                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³               ³                                             ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function ReportPrint(oReport,cAliasQry1)
Local oSection1  := oReport:Section(1)
Local cCond1	:=	""
Local cCond2	:=	""
Local nMoedaBCO:= 1


dbSelectArea("SE5")
dbSetOrder(1)
  
	oReport:SetMeter(RecCount())
	dbSeek(cFilial+DtoS(mv_par01),.T.)
	cCond1:= '!Eof() .And. E5_FILIAL == "'+cFilial+'" .And. '+;
		'Dtos(E5_DATA) <= "'+Dtos(mv_par02)+'"'
	
	cCond2:= 'E5_RECPAG != "P" .and. E5_SITUACA != "C" .And. '+;
			'(E5_TIPODOC == "JR" .or. E5_TIPODOC == "J2") .And. '+;
			'Dtos(E5_DTDIGIT) >= "'+dtos(mv_par03)+'" .and. '+;
			'Dtos(E5_DTDIGIT) <= "'+dtos(mv_par04)+'"'

	oSection1:Init()
	While &cCond1
        // Pega moeda do banco e calcula o valor na moeda
		oReport:IncMeter()
		If oReport:Cancel()
			Exit
		EndIf
		nMoedaBCO	:=	1
		If cPaisLoc	# "BRA"
			SA6->(DbSetOrder(1))
			SA6->(DbSeek(xFilial()+SE5->E5_BANCO+SE5->E5_AGENCIA+SE5->E5_CONTA))
			nMoedaBco := Max(SA6->A6_MOEDA,1)
		Endif

        // Desconsidera movimentos de outras moedas
		If mv_par06 == 2 .And. nMoedaBco != mv_par05 
		   SE5->(dbSkip())
		   Loop
		EndIf                      
		
//		oSection1:Cell("E1_VLCRUZ"):SetValue(Fr280Valor(
		IF &cCond2
			Fr280Vlr(oSection1,(cAliasQry1)->E5_CLIFOR,(cAliasQry1)->E5_LOJA,(cAliasQry1)->E5_PREFIXO,(cAliasQry1)->E5_NUMERO,(cAliasQry1)->E5_PARCELA,(cAliasQry1)->E5_TIPO,(cAliasQry1)->E5_DATA)
			oSection1:PrintLine()
		Endif		
		SE5->(DbSkip())
	Enddo
//#ENDIF	
oSection1:Finish()
Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ vlrjuR3³   Autor ³ Carlos Daniel         ³ Data ³ 04.11.15 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Relacao dos Juros Recebidos                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe e ³ vlrjuR3                                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function vlrjuR3()
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
LOCAL cDesc1 := OemToAnsi(STR0001)  //"Este programa ir  emitir a rela‡„o dos juros recebidos a partir"
LOCAL cDesc2 := OemToAnsi(STR0002)  //"da data da baixa."
LOCAL cDesc3 :=""
LOCAL cString:= "SE5"
LOCAL wnrel
LOCAL Tamanho:="G"

PRIVATE aReturn := { OemToAnsi(STR0003), 1,OemToAnsi(STR0004), 2, 2, 1, "",1 }  //"Zebrado"###"Administracao"
PRIVATE nomeprog:="vlrjuros"
PRIVATE aLinha  := { },nLastKey := 0
PRIVATE cPerg   :="FIN280"  //verificar
PRIVATE titulo
PRIVATE cabec1
PRIVATE cabec2

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Definicao dos cabecalhos                                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
titulo := OemToAnsi(STR0005)  //"Relacao dos Juros Recebidos"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
pergunte("FIN280",.F.)    //carlos

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros                         ³
//³ mv_par01            // Da Data De Baixa                      ³
//³ mv_par02            // Ate a Data de Baixa                   ³
//³ mv_par03            // Da data de digitacao de               ³
//³ mv_par04            // Ate a Data de digitacao               ³
//³ mv_par05            // Qual moeda                            ³
//³ mv_par06            // Outras moedas                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Envia controle para a funcao SETPRINT                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
wnrel:="vlrjuros"            //Nome Default do relatorio em Disco
wnrel:=SetPrint(cString,wnrel,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,"",,Tamanho)
If nLastKey = 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey = 27
	Return
Endif

RptStatus({|lEnd| u_jUrimp(@lEnd,wnRel,cString)},Titulo)

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ jUrimp ³ Autor ³ Carlos Daniel           ³ Data ³ 18.06.15 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Relacao dos Juros Recebidos                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe e ³ jUrimp(lEnd,wnRel,cString)                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ lEnd    - A‡Æo do Codeblock                                ³±±
±±³          ³ wnRel   - T¡tulo do relat¢rio                              ³±±
±±³          ³ cString - Mensagem                                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
//Static Function FA280Imp(lEnd,wnRel,cString) 
User Function jUrimp(lEnd,wnRel,cString)
Local lPanelFin := If (FindFunction("IsPanelFin"),IsPanelFin(),.F.)
LOCAL CbCont,CbTxt
LOCAL tamanho:= "G"
LOCAL nTotJuros :=0
Local cCond1,cCond2
#IFDEF TOP
	Local aStru := SE5->(DbStruct())
	Local ni
	Local cOrder,cQuery
#ENDIF	
Local cFilterUser := aReturn[7]
Local aColu	:= {}
Local aTam  := TamSX3("E1_CLIENTE")
Local nDecs := MsDecimais(mv_par05)
Local nValor, nMoedaBco := 1  
Local nFilial := ''

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Definicao dos cabecalhos                                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cabec1 := IIF(aTam[1] > 6,OemToAnsi(STR0009),OemToAnsi(STR0006))  //"BANCO  CODIGO                     CLIENTE                      No.TITULO           VENCTO      ATRASO  PAGTO                VALOR     VALOR JUROS"###"BANCO  CODIGO    CLIENTE                       No.TITULO          VENCTO    ATRASO PAGTO                VALOR      VALOR JUROS"
cabec2 := ""

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para Impressao do Cabecalho e Rodape    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cbtxt    := SPACE(10)
cbcont   := 0
li       := 80
m_pag    := 1

dbSelectArea("SE5")
dbSetOrder(1)
SetRegua(RecCount())

#IFDEF TOP

	cOrder := SqlOrder(IndexKey())

	If TcSrvType() !="AS/400"
		cQuery := "SELECT * "
		cQuery += " FROM " + RetSqlName("SE5")
		cQuery += " WHERE D_E_L_E_T_ <> '*' "
		cQuery += " AND E5_DATA between '" + DTOS(mv_par01)  + "' AND '" + DTOS(mv_par02) + "'"
		cQuery += " AND E5_RECPAG <> 'P' AND E5_SITUACA <> 'C'"
		cQuery += " AND ( E5_TIPODOC = 'JR' OR E5_TIPODOC = 'J2' ) "
		cQuery += " AND E5_DTDIGIT between '" + DTOS(mv_par03)  + "' AND '" + DTOS(mv_par04) + "'"
		cQuery += " ORDER BY " + cOrder
		cQuery := ChangeQuery(cQuery)
	
		dbSelectArea("SE5")
		dbCloseArea()
		dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), 'SE5', .T., .T.)
		For ni := 1 to Len(aStru)
			If aStru[ni,2] != 'C'
				TCSetField('SE5', aStru[ni,1], aStru[ni,2],aStru[ni,3],aStru[ni,4])
			Endif
		Next
		cCond1:='!Eof()'
		cCond2:='!Eof()'
	Else
#ENDIF
	dbSeek(cFilial+DtoS(mv_par01),.T.)
	cCond1:= '!Eof() .And. E5_FILIAL == "'+cFilial+'" .And. '+;
		'Dtos(E5_DATA) <= "'+Dtos(mv_par02)+'"'
	
	cCond2:= 'E5_RECPAG != "P" .and. E5_SITUACA != "C" .And. '+;
			'(E5_TIPODOC == "JR" .or. E5_TIPODOC == "J2") .And. '+;
			'Dtos(E5_DTDIGIT) >= "'+dtos(mv_par03)+'" .and. '+;
			'Dtos(E5_DTDIGIT) <= "'+dtos(mv_par04)+'"'
#IFDEF TOP
	Endif 
#ENDIF

aColu := IIF (aTam[1] > 6,;
					{000,007,034,063,083,098,103,115,131,142},;
					{000,007,018,047,067,082,087,099,115,131})

While &cCond1
	
	IF lEnd
		@Prow()+1,001 PSAY OemToAnsi(STR0007)  //"CANCELADO PELO OPERADOR"
		Exit
	End
	
	IncRegua()
	
	IF &cCond2
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Considera filtro do usuario                                  ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If !Empty(cFilterUser).and.!(&cFilterUser)
			SE5->(dbSkip())
			Loop
		Endif
		                                           		
        // Pega moeda do banco e calcula o valor na moeda
		If cPaisLoc	# "BRA"
			SA6->(DbSetOrder(1))
			SA6->(DbSeek(xFilial()+SE5->E5_BANCO+SE5->E5_AGENCIA+SE5->E5_CONTA))
			nMoedaBco := Max(SA6->A6_MOEDA,1)
		Endif

        // Desconsidera movimentos de outras moedas
		If mv_par06 = 2 .And. nMoedaBco != mv_par05 
		   SE5->(dbSkip())
		   Loop
		EndIf                      
             
		nValor := xMoeda(SE5->E5_VALOR, nMoedaBco, mv_par05, SE5->E5_DATA, nDecs+1)
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Localiza o titulo                                            ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		SE1->(dbSeek(xfilial("SE1")+SE5->E5_PREFIXO+SE5->E5_NUMERO+SE5->E5_PARCELA+SE5->E5_TIPO))
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Localiza o cliente                                           ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		dbSelectArea("SA1")   
		DbSetOrder(1)                  
		If !lPanelFin
			SA1->(dbSeek(xFilial("SA1")+SE1->E1_CLIENTE+SE1->E1_LOJA))
		Else
			SA1->(dbSeek(xFilial("SA1")+E1_CLIENTE+E1_LOJA))
		Endif	
		
		dbSelectArea("SE5")

		IF li > 58
			cabec(titulo,cabec1,cabec2,nomeprog,tamanho,IIF(aReturn[4]==1,15,18))
		End
		nFilial := SE5->E5_FILIAL
		@li , aColu[1] PSAY E5_BANCO
		@li , aColu[2] PSAY If(lPanelFin, E1_CLIENTE+" "+E1_LOJA,SE1->E1_CLIENTE+" "+SE1->E1_LOJA)
		@li , aColu[3] PSAY Substr(SA1->A1_NOME,1,20)
		@li , aColu[4] PSAY E5_PREFIXO+"-"+E5_NUMERO+"-"+E5_PARCELA
		@li , aColu[5] PSAY If(lPanelFin,E1_VENCTO,SE1->E1_VENCTO) 
		
		@li , aColu[6] PSAY If(lPanelFin,(E5_DATA-E1_VENCTO),(E5_DATA-SE1->E1_VENCTO)) Picture "999"
		
		@li , aColu[7] PSAY E5_DATA
		If lPanelFin
			@li , aColu[8] PSAY xMoeda(E1_VLCRUZ , E1_MOEDA, mv_par05, SE5->E5_DATA, nDecs+1)	Picture TM(E1_VLCRUZ,14,MsDecimais(1))
		Else
			@li , aColu[8] PSAY xMoeda(SE1->E1_VLCRUZ , SE1->E1_MOEDA, mv_par05, SE5->E5_DATA, nDecs+1)	Picture TM(SE1->E1_VLCRUZ,14,MsDecimais(1))
		Endif
		@li , aColu[9] PSAY nValor	            Picture PesqPict("SE5","E5_VALOR",14,mv_par05)   
		@li , aColu[10] PSAY nFilial
		nTotJuros += nValor
		li++
	Endif
	
	SE5->(dbSkip())
Enddo

IF nTotJuros != 0
	li+=2
	IF li > 58
		cabec(titulo,cabec1,cabec2,nomeprog,tamanho,IIF(aReturn[4]==1,15,18))
	Endif
	@li,001 PSAY OemToAnsi(STR0008)  //"Total de Juros Recebidos no Periodo : "
	@li,aColu[9] PSAY nTotJuros Picture PesqPict("SE5","E5_VALOR",14,mv_par05)
EndIF

IF li != 80
	roda(cbcont,cbtxt,"M")
EndIF

Set Device To Screen

#IFNDEF TOP
	dbSelectArea("SE5")
	dbClearFil()
	dbSetOrder(1)
#ELSE
	if TcSrvType() != "AS/400"
		dbSelectArea("SE5")
		dbCloseArea()
		ChKFile("SE5")
		dbSelectArea("SE5")
		dbSetOrder(1)
	else
		dbSelectArea("SE5")
		dbClearFil()
		dbSetOrder(1)
	endif
#ENDIF

If aReturn[5] = 1
	Set Printer To
	dbCommitall()
	ourspool(wnrel)
End

MS_FLUSH()

Return

Static Function Fr280Vlr(oSection1,cCli,cLoja,cPref,cNum,cParc,cTipo,dDataBx)
Local aArea:= getArea()
Local aAreaSE1 := SE1->(getArea()) 
Local aAreaSA1 := SA1->(getArea()) 
Local oSection := oSection1
DbSelectArea("SE1")
DbSetOrder(2)                  
If Dbseek(xFilial("SE1") + cCli+cLoja+cPref+cNum+cParc+cTipo)
	oSection:Cell("E1_VLCRUZ"):SetValue(xMoeda(SE1->E1_VLCRUZ, SE1->E1_MOEDA, mv_par05, dDataBx, MsDecimais(mv_par05)+1))
	
	oSection:Cell("CLIENLOJA"):SetValue(SE1->E1_CLIENTE+' '+SE1->E1_LOJA)
	oSection:Cell("E1_VENCTO"):SetValue(SE1->E1_VENCTO)
	oSection:Cell("ATRASO"):SetValue(dDataBx - SE1->E1_VENCTO)	//"ATRASO"
	
	DbSelectArea("SA1")
	DbSetOrder(1)                  
	If Dbseek(xFilial("SA1") + cCli+cLoja)
		oSection:Cell("A1_NREDUZ"):SetValue(SA1->A1_NREDUZ)
	EndIf
EndIf
SE1->(RestArea(aAreaSE1))
SA1->(RestArea(aAreaSA1))

RestArea(aArea)
Return