#INCLUDE "rwmake.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RELATI    º Autor ³		     º Data ³  29/05/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Relação dos bens ativo fixo.                               º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ 			                                          º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function RELATI()


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Local cDesc1       := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2       := "de acordo com os parametros informados pelo usuario."
Local cDesc3       := ""
//Local cPict        := ""
Local titulo       := "Relação Ativo Fixo"
Local nLin         := 80

Local Cabec1       := ""
Local Cabec2       := ""
//Local imprime      := .T.
Local aOrd 		   := {}
Private lEnd       := .F.
Private lAbortPrint:= .F.
Private CbTxt      := ""
Private limite     := 120
Private tamanho    := "G"
Private nomeprog   := "RELATI" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo      := 18
Private aReturn    := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey   := 0
Private cPerg      := "RELATI"
//Private cbtxt      := Space(10)
Private cbcont     := 00
Private CONTFL     := 01
Private m_pag      := 01
Private wnrel      := "RELATI" // Coloque aqui o nome do arquivo usado para impressao em disco
Private cString := "SN1"

dbSelectArea("SN1")
dbSetOrder(1)
/*
U_xPutSX1(cPerg , "01" , "Codigo Ativo de           " , "" , "" , "mv_ch1" , "C" , 10 , 0 , 0 , "G" , "", "XXSN1", "", "", "mv_par01" , "        " ,"","","", "        " ,"","","", "        " , "" , "" , "" , "" , "" , "" , "" , "" )
U_xPutSX1(cPerg , "02" , "Codigo Ativo ate          " , "" , "" , "mv_ch2" , "C" , 10 , 0 , 0 , "G" , "", "XXSN1", "", "", "mv_par02" , "        " ,"","","", "   	  " ,"","","", "        " , "" , "" , "" , "" , "" , "" , "" , "" )
U_xPutSX1(cPerg , "03" , "Filial de                 " , "" , "" , "mv_ch3" , "C" , 4  , 0 , 0 , "G" , "", "SM0", "", "", "mv_par03" , "        " ,"","","", "        " ,"","","", "        " , "" , "" , "" , "" , "" , "" , "" , "" )
U_xPutSX1(cPerg , "04" , "Filial ate                " , "" , "" , "mv_ch4" , "C" , 4  , 0 , 0 , "G" , "", "SM0", "", "", "mv_par04" , "        " ,"","","", "   	  " ,"","","", "        " , "" , "" , "" , "" , "" , "" , "" , "" )
U_xPutSX1(cPerg , "05" , "Grupo de                  " , "" , "" , "mv_ch5" , "C" , 4  , 0 , 0 , "G" , "", "SNG", "", "", "mv_par05" , "        " ,"","","", "        " ,"","","", "        " , "" , "" , "" , "" , "" , "" , "" , "" )
U_xPutSX1(cPerg , "06" , "Grupo ate                 " , "" , "" , "mv_ch6" , "C" , 4  , 0 , 0 , "G" , "", "SNG", "", "", "mv_par06" , "        " ,"","","", "   	  " ,"","","", "        " , "" , "" , "" , "" , "" , "" , "" , "" )
//PutSX1(cPerg , "07" , "Tipo Ativo.	             " , "" , "" , "mv_ch7" , "N" , 2  , 0 , 2 , "C" , "", "", "", "", "mv_par07" , "01" ,"","","", "10" ,"","","", "        " , "" , "" , "" , "" , "" , "" , "" , "" )
U_xPutSX1(cPerg , "07" , "Tipo Ativo				 " , "" , "" , "mv_ch7" , "C" , 2  , 0 , 0 , "G" , "", "", "", "", "mv_par07" , "        " ,"","","", "   	  " ,"","","", "        " , "" , "" , "" , "" , "" , "" , "" , "" )
U_xPutSX1(cPerg , "08" , "Analitico/Sintético		 " , "" , "" , "mv_ch8" , "N" , 1  , 0 , 0 , "C" , "", "", "", "", "mv_par08" , "Analitico" ,"","","", "Sintético" ,"","","", "        " , "" , "" , "" , "" , "" , "" , "" , "" )
//PutSX1(cPerg , "08" , "Modo Imp.	             " , "" , "" , "mv_ch8" , "N" , 1  , 0 , 1 , "C" , "", "", "", "", "mv_par08" , "(1)Analitico" ,"","","", "(2)Sintetico" ,"","","", "        " , "" , "" , "" , "" , "" , "" , "" , "" )
U_xPutSX1(cPerg , "09" , "Data Aquis. Inc.          " , "" , "" , "mv_ch9" , "D" , 4  , 0 , 0 , "G" , "", "", "", "", "mv_par09" , "        " ,"","","", "        " ,"","","", "        " , "" , "" , "" , "" , "" , "" , "" , "" )
U_xPutSX1(cPerg , "10" , "Data Aquis. Fin.          " , "" , "" , "mv_ch10" , "D" , 4  , 0 , 0 , "G" , "", "", "", "", "mv_par10" , "        " ,"","","", "   	  " ,"","","", "        " , "" , "" , "" , "" , "" , "" , "" , "" )
*/
pergunte(cPerg,.T.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta a interface padrao com o usuario...                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
IF mv_par07 == '1' //Transforma par07 em tipo ativo 01 ou 10
	mv_par07 = '01'
ELSEIF mv_par07 == '2'
	mv_par07 = '10'
ENDIF


wnrel := SetPrint(cString,NomeProg,"",@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
	Return
Endif

nTipo := If(aReturn[4]==1,15,18)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Processamento. RPTSTATUS monta janela com a regua de processamento. ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)
Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³RUNREPORT º Autor ³ AP6 IDE            º Data ³  29/05/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS º±±
±±º          ³ monta a janela com a regua de processamento.               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Programa principal                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)
Local ntotal := 0
Local ntotam := 0
Local ntotaa := 0
Local ntotalz := 0
//Local nOrdem
//Local _cCalc := ""
//Local _cAqui := ""
//Local _cMes1 := ""
//Local _cAcul := ""
Local cTxdep := ""
//LOCAL nValo             //colocada para calculo geral
LOCAL nValor       := 0 //para calculo geral
LOCAL nBaixa := 0
LOCAL nBaixas := 0
LOCAL cAquis := 0
LOCAL ntotals := 0
Private cAlias := Criatrab(Nil,.F.)
Private cQry := Space(0)

IF mv_par08 == 1  //Analitico
	cQry += " SELECT N3_TIPO, N1_VLAQUIS, N1_AQUISIC, N1_ITEM, N1_CBASE, N1_DESCRIC, N1_CHAPA, N1_GRUPO, N3_TXDEPR1, N3_VRDMES1,N3_VORIG1,N3_VRCDA1, N3_VRDACM1, N3_HISTOR, N1_BAIXA, N3_DTBAIXA
	cQry += " FROM "+RetSqlName("SN1") +" SN1
	cQry += " INNER JOIN "+RetSqlName("SN3") +" SN3 ON N1_CBASE = N3_CBASE AND N1_ITEM = N3_ITEM AND N1_FILIAL = N3_FILIAL
	cQry += " WHERE N1_FILIAL BETWEEN '"+MV_PAR03+"' AND  '"+MV_PAR04+"'
	cQry += " AND N1_CBASE BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+"'
	cQry += " AND N1_GRUPO BETWEEN '"+MV_PAR05+"' AND '"+MV_PAR06+"'
	cQry += " AND N3_TIPO = '"+MV_PAR07+"'
	cQry += " AND N1_STATUS = '1'
	cQry += " AND N1_AQUISIC BETWEEN '"+DToS(MV_PAR09)+"' AND '"+DToS(MV_PAR10)+"'
	cQry += " AND SN1.D_E_L_E_T_<> '*' AND SN3.D_E_L_E_T_ <> '*'
	cQry += " ORDER BY N1_CBASE, N1_ITEM
	DbUseArea(.T., "TOPCONN", TcGenQry(,, cQry), cAlias, .T., .T.)
	DbGotop()
	
ELSE  // Sintetico
	
	cQry += " SELECT N1_GRUPO AS GRUPO, NG_DESCRIC AS DESCRIC, SUM(N1_VLAQUIS) AS AQUISI,
	cQry += " SUM((SELECT SUM(N3_VRDACM1) FROM "+RetSqlName("SN3") +" SN31 WHERE SN31.N3_CBASE = SN1.N1_CBASE AND SN1.N1_FILIAL = SN31.N3_FILIAL AND SN31.N3_ITEM = N1_ITEM AND SN1.D_E_L_E_T_ = SN31.D_E_L_E_T_ AND (SN31.N3_DTBAIXA > '"+DToS(MV_PAR10)+"' OR SN31.N3_DTBAIXA = ' ') )) AS ACUMU, SUM(N3_VRDMES1) AS MENSAL, SUM(N3_VRCDA1) AS BASE,
	cQry += " SUM((SELECT sum(N4_VLROC1) FROM "+RetSqlName("SN4") +" SN4 WHERE SN4.N4_CBASE = SN1.N1_CBASE AND SN1.N1_ITEM = SN4.N4_ITEM AND SN4.D_E_L_E_T_ <> '*' AND N4_TIPO = '"+MV_PAR07+"' AND SN4.N4_TIPOCNT = '1' AND SN4.N4_OCORR = '01')) AS VENDA
	cQry += " FROM "+RetSqlName("SN1") +" SN1
	cQry += " INNER JOIN "+RetSqlName("SNG") +" SNG ON SNG.NG_GRUPO = SN1.N1_GRUPO
	cQry += " INNER JOIN "+RetSqlName("SN3") +" SN3 ON SN3.N3_CBASE = SN1.N1_CBASE AND SN1.N1_FILIAL = SN3.N3_FILIAL AND N3_ITEM = N1_ITEM AND SN1.D_E_L_E_T_ = SN3.D_E_L_E_T_
	cQry += " WHERE SN1.D_E_L_E_T_<> '*' AND SN3.D_E_L_E_T_ <> '*' AND SNG.D_E_L_E_T_ <> '*'
	cQry += " AND N1_FILIAL BETWEEN '"+MV_PAR03+"' AND  '"+MV_PAR04+"'
	cQry += " AND N1_GRUPO BETWEEN '"+MV_PAR05+"' AND '"+MV_PAR06+"'
	cQry += " AND N3_TIPO = '"+MV_PAR07+"'
	cQry += " AND N1_STATUS = '1'
	cQry += " AND SN1.N1_AQUISIC BETWEEN '"+DToS(MV_PAR09)+"' AND '"+DToS(MV_PAR10)+"'
	cQry += " GROUP BY N1_GRUPO, NG_DESCRIC
	DbUseArea(.T., "TOPCONN", TcGenQry(,, cQry), cAlias, .T., .T.)
	DbGotop()
ENDIF
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ SETREGUA -> Indica quantos registros serao processados para a regua ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
IF mv_par08 == 1 //Analitico
	
	SetRegua(RecCount())
	
	Cabec1 += Space(3)
	Cabec1 += Padc("CODIGO" ,len((cAlias)->N1_CBASE))			   		+ " | "
	Cabec1 += Padc("CHAPA" ,len((cAlias)->N1_CHAPA))			   		+ " | "
	Cabec1 += Padc("ITEM",len((cAlias)->N1_ITEM))  			   	   		+ " | "
	Cabec1 += Padc("DESCRICAO",len((cAlias)->N1_DESCRIC))	   	   		+ " | "
	Cabec1 += Padc("GRUPO" ,5)			   	   							+ " | "
	Cabec1 += Padc("TIPO BEM" ,5)			   	  	   					+ " | "
	Cabec1 += Padc("VL DO BEM" ,16)	  			   	  	   			   	+ " | "
	Cabec1 += Padc("DP MES" ,16)			   	  	   			     	+ " | "
	Cabec1 += Padc("DP ACUMULADA" ,16)			   	  	   				+ " | "
	nPosQtd := Len(Cabec1)
	Cabec1 += Padc("SALDO DO BEM" ,16)			   	  	   				+ " | "
	Cabec1 += Padc("DT AQUISICAO",len(dtoc(stod((cAlias)->N1_AQUISIC))))+ " | "
	Cabec1 += Padc("DATA BAIXA",len(dtoc(stod((cAlias)->N1_BAIXA)))) 	+ " | "
	Cabec1 += Padc("Tx.Depr" ,8)			   	  	   			   		+ " | "
	Cabec2 := Space(0)
	
	dbGoTop()
	While !EOF()
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Verifica o cancelamento pelo usuario...                             ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		
		If lAbortPrint
			@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
			Exit
		Endif
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Impressao do cabecalho do relatorio. . .                            ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		
		If nLin > 55 // Salto de Página. Neste caso o formulario tem 55 linhas...
			//Cabec(Cabec1)
			Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
			nLin := 8
		Endif
		cId := (cAlias)->N1_CBASE+(cAlias)->N1_ITEM
		cBXATI := dtoc(stod((cAlias)->N1_BAIXA))
		cAqui := (cAlias)->N1_VLAQUIS
		cMes1 := (cAlias)->N3_VRDMES1   
		cAcul := (cAlias)->N3_VRDACM1 
		nBaixa := 0
		cCalc := (cAqui - cAcul)
		if stod((cAlias)->N1_BAIXA)<=MV_PAR10 .AND. !EMPTY(stod((cAlias)->N1_BAIXA))
			nBaixa := (cAlias)->N3_VORIG1
			//if (cAlias)->N3_VRDACM1<>(cAlias)->N3_VORIG1
			  cAcul := 0
			//endif  
		endif 
		If !EMPTY(stod((cAlias)->N1_BAIXA))
			cCalc := 0
		EndIf

		cTxdep := (cAlias)->N3_TXDEPR1
		
		cLin := transform((cAlias)->N1_CBASE, PesqPict("SN1","N1_CBASE"))    		+  " | "
		cLin += transform((cAlias)->N1_CHAPA, PesqPict("SN1","N1_CHAPA"))     		+  " | "
		cLin += transform((cAlias)->N1_ITEM, PesqPict("SN1","N1_ITEM"))       		+  " | "
		cLin += transform((cAlias)->N1_DESCRIC, PesqPict("SN1","N1_DESCRIC")) 		+  " | "
		cLin += Padc(transform((cAlias)->N1_GRUPO, PesqPict("SN1","N1_GRUPO")),5)   +  " | "
		cLin += Padc(transform((cAlias)->N3_TIPO, PesqPict("(cAlias)","N3_TIPO")),5) +  " | "
		cLin += Padl("R$"+transform(cAqui,"@E 999,999,999.99"),16) 					+  " | " // vlr aquisicao
		cLin += Padl("R$"+transform(cMes1,"@E 999,999,999.99"),16) 					+  " | " //depreciacao mes
		cLin += Padl("R$"+transform(cAcul,"@E 999,999,999.99"),16) 					+  " | " //depreciacao acumulada
		
		cLin += Padl("R$"+transform(cCalc,"@E 99,999,999.99"),16) 					+  " | " //calculo do valor aquisicao - acumulado
		cLin += dtoc(stod((cAlias)->N1_AQUISIC))	                                +  " | " //DATA COMPRA
		cLin += cBXATI	                               							    +  " | " //DATA BAIXA
		cLin +=  Padc(cValtoChar(cTxdep),8)		   		     			        	+  " | "//TX depreciacao //cValtoChar(cTxdep)
		@nLin,03 PSAY cLin
		nLin++
		ntotal += cCalc// - (cAlias)->N3_VRCDA1 //Adicionado para correção de erro de base
		ntotam += cMes1
		ntotaa += cAcul// + (cAlias)->N3_VRCDA1 //Adicionado para correção de erro de base
		ntotalz += cAqui
		(cAlias)->(dbSkip())
	EndDo
	
	nLin++
	@nLin,03 PSAY Padr("VALOR TOTAL DEP MENSAL R$"+transform(ntotam,"@E 999,999,999.99"),200)
	nLin++
	@nLin,03 PSAY Padr("VALOR TOTAL DEP ACUMULADOS R$"+transform(ntotaa,"@E 999,999,999.99"),200)
	nLin++
	@nLin,03 PSAY Padr("VALOR TOTAL SALDO R$"+transform(ntotal,"@E 999,999,999.99"),200)
	nLin++
	@nLin,03 PSAY Padr("VALOS TOTAL ATIVOS R$"+transform(ntotalz,"@E 999,999,999.99"),200)
	
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Finaliza a execucao do relatorio...                                 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	SET DEVICE TO SCREEN
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Se impressao em disco, chama o gerenciador de impressao...          ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	If aReturn[5]==1
		dbCommitAll()
		SET PRINTER TO
		OurSpool(wnrel)
	Endif
	
	MS_FLUSH()
	
	Return()
	
ELSEIF mv_par08 == 2  // Sintetico
	
	SetRegua(RecCount())
	
	Cabec1 += Space(3)
	Cabec1 += Padc("Grupo" ,8)			   	   							+ " | "
	Cabec1 += Padc("Descrição",40)										+ " | "
	Cabec1 += Padc("Saldo Ant(+)Aquis" ,20)			   	  	   	    	+ " | "
	Cabec1 += Padc("(-)Baixas/Alien." ,16)	  			   	  	   		+ " | "
	Cabec1 += Padc("(+/-)Transf." ,17)			   	  	   			    + " | "
	Cabec1 += Padc("Dep Mes" ,19)		     	   	  	   				+ " | "
	Cabec1 += Padc("Saldo Atual" ,25)       	   	  	   				+ " | "
	nPosQtd := Len(Cabec1)
	Cabec1 += Padc("(-)Dep.Acum" ,18)			   	  	   			   	+ " | "
	Cabec1 += Padc("(=)Saldo Residual" ,21)		   	  	   				+ " | "
	Cabec2 := Space(0)
	
	dbGoTop()
	While !EOF()
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Verifica o cancelamento pelo usuario...                             ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		
		If lAbortPrint
			@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
			Exit
		Endif
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Impressao do cabecalho do relatorio. . .                            ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		
		If nLin > 55 // Salto de Página. Neste caso o formulario tem 55 linhas...
			Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
			nLin := 8
		Endif
		
		cAquis := (cAlias)->AQUISI 
		cMes1 := (cAlias)->MENSAL
		cAcul := (cAlias)->ACUMU// + (cAlias)->BASE
		nBaixa := (cAlias)->VENDA
		cAqui := ((cAlias)->AQUISI-nBaixa)// + (cAlias)->BASE //Adicionado para correção de erro de base
		cCalc := (cAqui - cAcul)  	
		
		nValor += cMes1
		cLin := Padc(transform((cAlias)->GRUPO, PesqPict("SN1","N1_GRUPO")),8)    +  " | " //GRUPO
		cLin += Padl((cAlias)->DESCRIC,40)  										+  " | " //DESCRICAO
		cLin += Padl("R$"+transform(cAquis,"@E 999,999,999.99"),20) 					+  " | " //AQUISICAO/SALDO ANTERIOR
		cLin += Padl("R$"+transform(nBaixa,"@E 999,999,999.99"),16) 				+  " | " //BAIXAS/ALIEN
		cLin += Padl("R$"+transform(0.00,"@E 999,999,999.99"),17) 					+  " | " //TRANSFERENCIAS
		cLin += Padl("R$"+transform(cMes1,"@E 999,999,999.99"),19) 					+  " | " //DEP MES
		cLin += Padl("R$"+transform(cAqui,"@E 999,999,999.99"),25) 					+  " | " //SALDO ATUAL
		cLin += Padl("R$"+transform(cAcul,"@E 999,999,999.99"),18) 					+  " | " //DEP ACUMULADA
		cLin += Padl("R$"+transform(cCalc,"@E 999,999,999.99"),21) 					+  " | " //SALDO RESIDUAL
		
		@nLin,03 PSAY cLin
		nLin++
		ntotal += cCalc
		ntotam += cMes1
		ntotaa += cAcul 
		ntotalz += cAqui 
		ntotals += cAquis
		nBaixas  += nBaixa
		(cAlias)->(dbSkip())
	EndDo
	
	nLin++
	@nLin,03 PSAY Padr("Total Saldo Anterior"+Space(3)+"="+transform(ntotals,"@E 99,999,999,999.99"),200)   //aquisicao
	nLin++
	@nLin,03 PSAY Padr("Baixas/Alienação"+Space(3)+"="+transform(nBaixas,"@E 99,999,999,999.99"),200)   //baixas
	nLin++
	@nLin,03 PSAY Padr("Total Dep Mensal"+Space(3)+"="+transform(ntotam,"@E 99,999,999,999.99"),200)    //dep mes
	nLin++
	@nLin,03 PSAY Padr("Total Saldo Atual"+Space(3)+"="+transform(ntotalz,"@E 99,999,999,999.99"),200)    //saldo atual
	nLin++
	@nLin,03 PSAY Padr("Total Dep Acumulada"+Space(3)+"="+transform(ntotaa,"@E 99,999,999,999.99"),200)    //dep acumulada
	nLin++
	@nLin,03 PSAY Padr("Total Saldo Residual"+Space(3)+"="+transform(ntotal,"@E 99,999,999,999.99"),200)    //Saldo Residual
	
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Finaliza a execucao do relatorio...                                 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	SET DEVICE TO SCREEN
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Se impressao em disco, chama o gerenciador de impressao...          ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	If aReturn[5]==1
		dbCommitAll()
		SET PRINTER TO
		OurSpool(wnrel)
	Endif
	
	MS_FLUSH()
	
	Return()
	
ELSE
	Return()
ENDIF
