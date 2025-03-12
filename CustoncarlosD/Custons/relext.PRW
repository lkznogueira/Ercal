#INCLUDE "rwmake.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³relext    º Autor ³ Carlos Daniel º Data ³  07/05/19        º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Relação de Faturamento     .                               º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³  Ercal 			                                          º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function relext()


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Local cDesc1       := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2       := "de acordo com os parametros informados pelo usuario."
Local cDesc3       := ""
Local cPict        := ""
Local titulo       := "Relação Faturamento"
Local nLin         := 80

Local Cabec1       := ""
Local Cabec2       := ""
Local imprime      := .T.
Local aOrd 		   := {}
Private lEnd       := .F.
Private lAbortPrint:= .F.
Private CbTxt      := ""
Private limite     := 120
Private tamanho    := "G"
Private nomeprog   := "relext" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo      := 18
Private aReturn    := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey   := 0
Private cPerg      := "relext"
Private cbtxt      := Space(10)
Private cbcont     := 00
Private CONTFL     := 01
Private m_pag      := 01
Private wnrel      := "relext" // Coloque aqui o nome do arquivo usado para impressao em disco
Private cString := "Z12"

dbSelectArea("Z12")
dbSetOrder(1)

//U_xPutSX1(cPerg , "01" , "Produto de          " , "" , "" , "mv_ch1" , "C" , 6  , 0 , 0 , "G" , "", "SB1", "", "", "mv_par01" , "        " ,"","","", "        " ,"","","", "        " , "" , "" , "" , "" , "" , "" , "" , "" )
//U_xPutSX1(cPerg , "02" , "Produto Ate         " , "" , "" , "mv_ch2" , "C" , 6  , 0 , 0 , "G" , "", "SB1", "", "", "mv_par02" , "        " ,"","","", "   	  " ,"","","", "        " , "" , "" , "" , "" , "" , "" , "" , "" )
//U_xPutSX1(cPerg , "03" , "Filial de           " , "" , "" , "mv_ch3" , "C" , 4  , 0 , 0 , "G" , "", "SM0", "", "", "mv_par03" , "        " ,"","","", "        " ,"","","", "        " , "" , "" , "" , "" , "" , "" , "" , "" )
//U_xPutSX1(cPerg , "04" , "Filial ate          " , "" , "" , "mv_ch4" , "C" , 4  , 0 , 0 , "G" , "", "SM0", "", "", "mv_par04" , "        " ,"","","", "   	  " ,"","","", "        " , "" , "" , "" , "" , "" , "" , "" , "" )
//U_xPutSX1(cPerg , "05" , "Faturamento de      " , "" , "" , "mv_ch5" , "D" , 4  , 0 , 0 , "G" , "", "", "", "", "mv_par05" , "        " ,"","","", "        " ,"","","", "        " , "" , "" , "" , "" , "" , "" , "" , "" )
//U_xPutSX1(cPerg , "06" , "Faturamento ate     " , "" , "" , "mv_ch6" , "D" , 4  , 0 , 0 , "G" , "", "", "", "", "mv_par06" , "        " ,"","","", "   	  " ,"","","", "        " , "" , "" , "" , "" , "" , "" , "" , "" )
//u_xPutSx1(cPerg , "07" , "Exporta Excel?      " , "" , "" , "mv_ch7" , "N" , 1  , 0 , 0 , "C" , "", "", "", "" ,"mv_par07","Sim","Sim","Sim","Nao","Nao","Nao","","","","","","","","","")

pergunte(cPerg,.T.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta a interface padrao com o usuario...                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

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
Local aReg:={}
Private cQuant := 0
Private cFret  := 0
Private cFreta := 0
Private cTotal := 0
Private nOrdem
Private nQuant := 0
Private nFret  := 0
Private nFreta := 0 
Private nTotal := 0 
Private cQuant1 := 0
Private cFret1  := 0
Private cFreta1 := 0
Private cTotal1 := 0
Private nOrdem1
Private nQuant1 := 0
Private nFret1  := 0
Private nFreta1 := 0 
Private nTotal1 := 0 
Private nQuant2 := 0 
Private nQuant4 := 0
Private nFret2  := 0 
Private nFret4  := 0
Private nFreta2 := 0
Private nFreta4 := 0  
Private nTotal2 := 0 
Private nTotal4 := 0 
Private cQuant2 := 0
Private cQuant4 := 0
Private cFret2  := 0
Private cFret4  := 0
Private cFreta2 := 0
Private cFreta4 := 0
Private cTotal2 := 0
Private cTotal4 := 0
Private nQuant3 := 0
Private nFret3  := 0
Private nFreta3 := 0 
Private nTotal3 := 0 
Private cQuant3 := 0
Private cFret3  := 0
Private cFreta3 := 0
Private cTotal3 := 0

Private cAlias := Criatrab(Nil,.F.)  
Private cAlias1 := Criatrab(Nil,.F.)  
Private cAlias2 := Criatrab(Nil,.F.)  
Private cAlias3 := Criatrab(Nil,.F.)
Private cAlias4 := Criatrab(Nil,.F.)
Private cQry  := Space(0) 
Private cQry1 := Space(0)  
Private cQry2 := Space(0)
Private cQry3 := Space(0)
Private cQry4 := Space(0)
//ITENS EXT
cQry += " SELECT  
cQry += " Z12_FILIAL,
cQry += " Z12_PRODUT,
cQry += " Z12_EMISSA,
cQry += " (SELECT B1_DESC FROM SB1010 SB1 WHERE sb1.d_e_l_e_t_ <> '*' AND Z12_PRODUT = B1_COD) DESCR, 
cQry += " 'EX' TP, 
cQry += " SUM(Z12_QUANT) AS QTD_EX, 
cQry += " SUM(Z12_FRETE) AS FRETE_EX, 
cQry += " SUM(Z12_FRETET) AS FRETAUT_EX, 
cQry += " SUM(Z12_VALOR) AS VLR_EX
cQry += " FROM "+RetSqlName("Z12") +" Z12 
cQry += " WHERE d_e_l_e_t_ <> '*'
cQry += " AND Z12_EMISSA BETWEEN '"+DToS(MV_PAR05)+"' AND '"+DToS(MV_PAR06)+"'
cQry += " AND Z12_FILIAL BETWEEN '"+MV_PAR03+"' AND  '"+MV_PAR04+"'
cQry += " GROUP BY Z12_FILIAL, Z12_PRODUT, Z12_EMISSA
cQry += " ORDER BY DESCR
DbUseArea(.T., "TOPCONN", TcGenQry(,, cQry), cAlias, .T., .T.)
DbGotop()
//ITENS OFC
cQry1 += " SELECT 
cQry1 += " D2_FILIAL,
cQry1 += " D2_COD,
cQry1 += " D2_EMISSAO,  
cQry1 += " (SELECT B1_DESC FROM SB1010 SB1 WHERE sb1.d_e_l_e_t_ <> '*' AND D2_COD = B1_COD) DESCR,
cQry1 += " 'OF' TP,
cQry1 += " SUM(D2_QUANT) QTD_OF,
cQry1 += " SUM(C5_XDESP)  FRETE_OF,
cQry1 += " SUM(F2_FRETAUT) FRETAUT_OF,
cQry1 += " SUM(D2_TOTAL) VLR_OF
cQry1 += " FROM "+RetSqlName("SD2") +" SD2
cQry1 += " INNER JOIN "+RetSqlName("SF2") +" SF2 ON SF2.d_e_l_e_t_ <> '*' AND D2_DOC = F2_DOC AND D2_FILIAL = F2_FILIAL AND D2_CLIENTE = F2_CLIENTE AND D2_TIPO = F2_TIPO
cQry1 += " INNER JOIN "+RetSqlName("SC5") +" SC5 ON SC5.D_E_L_E_T_ <> '*' AND C5_NOTA = D2_DOC AND C5_SERIE = D2_SERIE AND C5_CLIENTE = D2_CLIENTE AND C5_FILIAL = D2_FILIAL
cQry1 += " WHERE SD2.d_e_l_e_t_ <> '*' 
cQry1 += " AND D2_FILIAL  BETWEEN '"+MV_PAR03+"' AND  '"+MV_PAR04+"'
cQry1 += " AND D2_EMISSAO BETWEEN '"+DToS(MV_PAR05)+"' AND '"+DToS(MV_PAR06)+"'
cQry1 += " AND D2_TIPO = 'N'
cQry1 += " AND D2_TP  in ('PA','PI')  
cQry1 += " AND D2_CF IN ('5101','6101','5922','6922','5107','6107','5401','6401','5933','6933')   
cQry1 += " GROUP BY D2_FILIAL, D2_COD, D2_EMISSAO
cQry1 += " ORDER BY DESCR
DbUseArea(.T., "TOPCONN", TcGenQry(,, cQry1), cAlias1, .T., .T.)
DbGotop()
//TRANSFERENCIA ENTRE EMPRESAS CALCARIO
cQry2 += " SELECT 
cQry2 += " D2_FILIAL,
cQry2 += " D2_COD,
cQry2 += " D2_EMISSAO,  
cQry2 += " (SELECT B1_DESC FROM SB1010 SB1 WHERE sb1.d_e_l_e_t_ <> '*' AND D2_COD = B1_COD) DESCR,
cQry2 += " 'OF' TP,
cQry2 += " SUM(D2_QUANT) QTD_OF,
cQry2 += " SUM(C5_XDESP)  FRETE_OF,
cQry2 += " SUM(F2_FRETAUT) FRETAUT_OF,
cQry2 += " SUM(D2_TOTAL) VLR_OF
cQry2 += " FROM "+RetSqlName("SD2") +" SD2
cQry2 += " INNER JOIN "+RetSqlName("SF2") +" SF2 ON SF2.d_e_l_e_t_ <> '*' AND D2_DOC = F2_DOC AND D2_FILIAL = F2_FILIAL AND D2_CLIENTE = F2_CLIENTE AND D2_TIPO = F2_TIPO
cQry2 += " INNER JOIN "+RetSqlName("SC5") +" SC5 ON SC5.D_E_L_E_T_ <> '*' AND C5_NOTA = D2_DOC AND C5_SERIE = D2_SERIE AND C5_CLIENTE = D2_CLIENTE AND C5_FILIAL = D2_FILIAL
cQry2 += " WHERE SD2.d_e_l_e_t_ <> '*' 
cQry2 += " AND D2_FILIAL  BETWEEN '"+MV_PAR03+"' AND  '"+MV_PAR04+"'
cQry2 += " AND D2_EMISSAO BETWEEN '"+DToS(MV_PAR05)+"' AND '"+DToS(MV_PAR06)+"'
cQry2 += " AND D2_TIPO = 'N'
cQry2 += " AND D2_TP in ('PA','PI') 
cQry2 += " AND (SELECT B1_GRUPO FROM SB1010 SB1 WHERE sb1.d_e_l_e_t_ <> '*' AND D2_COD = B1_COD) <> '0106'  
cQry2 += " AND D2_CF IN ('5101','6101','5922','6922','5107','6107','5401','6401','5933','6933')
cQry2 += " AND SD2.D2_CLIENTE IN ('020830','002451','002453','002966','002968')
cQry2 += " GROUP BY D2_FILIAL, D2_COD, D2_EMISSAO
cQry2 += " ORDER BY DESCR
DbUseArea(.T., "TOPCONN", TcGenQry(,, cQry2), cAlias2, .T., .T.)
DbGotop()    
//ITENS OFC DEV
cQry3 += " SELECT 
cQry3 += " D1_FILIAL,
cQry3 += " D1_COD,
cQry3 += " D1_EMISSAO,  
cQry3 += " (SELECT B1_DESC FROM SB1010 SB1 WHERE sb1.d_e_l_e_t_ <> '*' AND D1_COD = B1_COD) DESCR,
cQry3 += " 'OF-DV' TP,
cQry3 += " SUM(D1_QUANT) QTD_OF,
cQry3 += " SUM(D1_TOTAL) VLR_OF
cQry3 += " FROM "+RetSqlName("SD1") +" SD1
cQry3 += " INNER JOIN "+RetSqlName("SF1") +" SF1 ON SF1.d_e_l_e_t_ <> '*' AND D1_DOC = F1_DOC AND D1_FILIAL = F1_FILIAL AND D1_FORNECE = F1_FORNECE AND D1_TIPO = F1_TIPO
cQry3 += " WHERE SD1.d_e_l_e_t_ <> '*' 
cQry3 += " AND D1_FILIAL  BETWEEN '"+MV_PAR03+"' AND  '"+MV_PAR04+"'
cQry3 += " AND D1_EMISSAO BETWEEN '"+DToS(MV_PAR05)+"' AND '"+DToS(MV_PAR06)+"'
cQry3 += " AND D1_TIPO = 'D'  
cQry3 += " GROUP BY D1_FILIAL, D1_COD, D1_EMISSAO
cQry3 += " ORDER BY DESCR
DbUseArea(.T., "TOPCONN", TcGenQry(,, cQry3), cAlias3, .T., .T.)
DbGotop() 
//TRANSFERENCIA ENTRE EMPRESAS FERTILIZANTES
cQry4 += " SELECT 
cQry4 += " D2_FILIAL,
cQry4 += " D2_COD,
cQry4 += " D2_EMISSAO,  
cQry4 += " (SELECT B1_DESC FROM SB1010 SB1 WHERE sb1.d_e_l_e_t_ <> '*' AND D2_COD = B1_COD) DESCR,
cQry4 += " 'OF' TP,
cQry4 += " SUM(D2_QUANT) QTD_OF,
cQry4 += " SUM(C5_XDESP)  FRETE_OF,
cQry4 += " SUM(F2_FRETAUT) FRETAUT_OF,
cQry4 += " SUM(D2_TOTAL) VLR_OF
cQry4 += " FROM "+RetSqlName("SD2") +" SD2
cQry4 += " INNER JOIN "+RetSqlName("SF2") +" SF2 ON SF2.d_e_l_e_t_ <> '*' AND D2_DOC = F2_DOC AND D2_FILIAL = F2_FILIAL AND D2_CLIENTE = F2_CLIENTE AND D2_TIPO = F2_TIPO
cQry4 += " INNER JOIN "+RetSqlName("SC5") +" SC5 ON SC5.D_E_L_E_T_ <> '*' AND C5_NOTA = D2_DOC AND C5_SERIE = D2_SERIE AND C5_CLIENTE = D2_CLIENTE AND C5_FILIAL = D2_FILIAL
cQry4 += " WHERE SD2.d_e_l_e_t_ <> '*' 
cQry4 += " AND D2_FILIAL  BETWEEN '"+MV_PAR03+"' AND  '"+MV_PAR04+"'
cQry4 += " AND D2_EMISSAO BETWEEN '"+DToS(MV_PAR05)+"' AND '"+DToS(MV_PAR06)+"'
cQry4 += " AND D2_TIPO = 'N'
cQry4 += " AND D2_TP in ('PA','PI') 
cQry4 += " AND (SELECT B1_GRUPO FROM SB1010 SB1 WHERE sb1.d_e_l_e_t_ <> '*' AND D2_COD = B1_COD) = '0106'   
cQry4 += " AND D2_CF IN ('5101','6101','5922','6922','5107','6107','5401','6401','5933','6933')
cQry4 += " AND SD2.D2_CLIENTE IN ('020830','002451','002453','002966','002968')
cQry4 += " GROUP BY D2_FILIAL, D2_COD, D2_EMISSAO
cQry4 += " ORDER BY DESCR
DbUseArea(.T., "TOPCONN", TcGenQry(,, cQry4), cAlias4, .T., .T.)
DbGotop()  
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ SETREGUA -> Indica quantos registros serao processados para a regua ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
SetRegua(RecCount())

Cabec1 += Space(3)
Cabec1 += Padc("PRODUTO" ,8)			   	   						+ " | "
Cabec1 += Padc("Descrição",40)										+ " | "
Cabec1 += Padc("Quantidade" ,20)		 	  	   		   	    	+ " | "
Cabec1 += Padc("Frete Embutido" ,21)	 			   	  	        + " | "
Cabec1 += Padc("FretAut" ,21)       	   	  	   			 		+ " | "
nPosQtd := Len(Cabec1)
Cabec1 += Padc("TOTAL" ,21)		   	  	   			  				+ " | "
Cabec1 += Padc("TIPO" ,5)		   	  	   			  				+ " | " 
Cabec1 += Padc("EMISSÃO" ,11)		   	  	   			  		    + " | " 
Cabec1 += Padc("FILIAL" ,5)		   	  	   			  			    + " | " 
Cabec2 := Space(0)   

if mv_par07==1
	Aadd(aReg,{Padc("Produto" ,8),Padc("Descrição",40),Padc("Quantidade" ,20),Padc("Frete Embutido" ,21),Padc("Frete Autonomo" ,21),Padc("Total",21),Padc("Tipo" ,5),Padc("Emissão" ,11),Padc("Filial" ,5)})
endif

dbGoTop()
//While !EOF()    
While (cAlias)->(!EOF())
	
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

	cQuant := 	(cAlias)->QTD_EX
 	cFret  := 	(cAlias)->FRETE_EX
  	cFreta :=   (cAlias)->FRETAUT_EX  
   	cTotal :=   (cAlias)->VLR_EX

	cLin := Padc(transform((cAlias)->Z12_PRODUT, PesqPict("Z12","Z12_PRODUT")),8) 	   			+  " | " //PRODUTO
	cLin += Padl((cAlias)->DESCR,40)  									  			   			+  " | " //DESCRICAO
	cLin += Padl(transform((cAlias)->QTD_EX,"@E 999,999,999.99"),20) 	  						+  " | " //quantidade
	cLin += Padl("R$"+transform((cAlias)->FRETE_EX,"@E 999,999,999.99"),21) 	 				+  " | " //
	cLin += Padl("R$"+transform((cAlias)->FRETAUT_EX,"@E 999,999,999.99"),21) 					+  " | " //
	cLin += Padl("R$"+transform((cAlias)->VLR_EX,"@E 999,999,999.99"),21) 	  					+  " | " //
	cLin += Padl((cAlias)->TP,5)  									   				   	  		+  " | " //  
	cLin += dtoc(stod((cAlias)->Z12_EMISSA))	                          					    +  " | " //DATA  
	cLin += Padc(transform((cAlias)->Z12_FILIAL, PesqPict("Z12","Z12_FILIAL")),5) 	   			+  "   | " //
	
	@nLin,03 PSAY cLin
	nLin++ 
	
	if mv_par07==1
	  Aadd(aReg,{Padc((cAlias)->Z12_PRODUT, 8),Padc((cAlias)->DESCR, 40),Padl(transform((cAlias)->QTD_EX,"@E 999,999,999.99"),20) ,Padl("R$"+transform((cAlias)->FRETE_EX,"@E 999,999,999.99"),21) ,Padl("R$"+transform((cAlias)->FRETAUT_EX,"@E 999,999,999.99"),21),Padl("R$"+transform((cAlias)->VLR_EX,"@E 999,999,999.99"),21),Padl((cAlias)->TP,5) ,dtoc(stod((cAlias)->Z12_EMISSA)),Padc((cAlias)->Z12_FILIAL, 5)})
	endif
	
 	nQuant += 	cQuant
 	nFret  += 	cFret
 	nFreta +=   cFreta 
 	nTotal +=   cTotal
 	
	(cAlias)->(dbSkip())
   //	(cAlias1)->(dbSkip())
EndDo

nLin++ 
cLin := SPACE(43)+"TOTAIS "+"  |" 
cLin += Padl(transform(nQuant,"@E 999,999,999.99"),21)  	 +  " | " 
cLin += Padl("R$"+transform(nFret,"@E 999,999,999.99"),21)   +  " | "                                         
cLin += Padl("R$"+transform(nFreta,"@E 999,999,999.99"),21)  +  " | " 
cLin += Padl("R$"+transform(nTotal,"@E 999,999,999.99"),21)  +  " | "  
@nLin,03 PSAY cLin  
nLin++ 
nLin++                       
//Segunda Etapa

dbGoTop()
While (cAlias1)->(!EOF())
	
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

	cQuant1 := 	(cAlias1)->QTD_OF
   	cFret1  := 	(cAlias1)->FRETE_OF
   	cFreta1 :=   (cAlias1)->FRETAUT_OF  
   	cTotal1 :=   (cAlias1)->VLR_OF 
   	
   	cQuant2 := 	ROUND((cAlias2)->QTD_OF,2)
   	cFret2  := 	ROUND((cAlias2)->FRETE_OF,2)
   	cFreta2 :=   ROUND((cAlias2)->FRETAUT_OF,2) 
   	cTotal2 :=   ROUND((cAlias2)->VLR_OF,2) 
   	
   	cQuant3 := 	(cAlias3)->QTD_OF
   	cFret3  := 	0
   	cFreta3 :=  0  
   	cTotal3 :=  (cAlias3)->VLR_OF 
   	
   	cQuant4 := 	ROUND((cAlias4)->QTD_OF,2)
   	cFret4  := 	ROUND((cAlias4)->FRETE_OF,2)
   	cFreta4 :=   ROUND((cAlias4)->FRETAUT_OF,2) 
   	cTotal4 :=   ROUND((cAlias4)->VLR_OF,2) 

	cLin := Padc(transform((cAlias1)->D2_COD, PesqPict("SD2","D2_COD")),8) 	   					+  " | " //PRODUTO
	cLin += Padl((cAlias1)->DESCR,40)  									  			   			+  " | " //DESCRICAO
	cLin += Padl(transform((cAlias1)->QTD_OF,"@E 999,999,999.99"),20) 	  						+  " | " //quantidade
	cLin += Padl("R$"+transform((cAlias1)->FRETE_OF,"@E 999,999,999.99"),21) 	 				+  " | " //
	cLin += Padl("R$"+transform((cAlias1)->FRETAUT_OF,"@E 999,999,999.99"),21) 					+  " | " //
	cLin += Padl("R$"+transform((cAlias1)->VLR_OF,"@E 999,999,999.99"),21) 	  					+  " | " //
	cLin += Padl((cAlias1)->TP,5)  											  			   	  	+  " | " //
	cLin += dtoc(stod((cAlias1)->D2_EMISSAO))	                             					+  " | " //DATA 
	cLin += Padc(transform((cAlias1)->D2_FILIAL, PesqPict("SD2","D2_FILIAL")),5) 	   			+  "   | " //FILIAL
	
	@nLin,03 PSAY cLin
	nLin++
	if mv_par07==1
		Aadd(aReg,{Padl((cAlias)->Z12_PRODUT, 8),Padc((cAlias)->DESCR, 40),Padl(transform((cAlias)->QTD_EX,"@E 999,999,999.99"),20) ,Padl("R$"+transform((cAlias)->FRETE_EX,"@E 999,999,999.99"),21) ,Padl("R$"+transform((cAlias)->FRETAUT_EX,"@E 999,999,999.99"),21),Padl("R$"+transform((cAlias)->VLR_EX,"@E 999,999,999.99"),21),Padl((cAlias)->TP,5) ,dtoc(stod((cAlias)->Z12_EMISSA)),Padc((cAlias)->Z12_FILIAL, 5)})
	endif
 	nQuant1 += 	cQuant1
 	nFret1  += 	cFret1
 	nFreta1 +=   cFreta1 
 	nTotal1 +=   cTotal1
 	
  	nQuant2 += 	ROUND(cQuant2,2)
 	nFret2  += 	ROUND(cFret2,2)
 	nFreta2 +=  ROUND(cFreta2,2) 
 	nTotal2 +=  ROUND(cTotal2,2) 
 	
  	nQuant3 += 	cQuant3
 	nFret3  += 	cFret3
 	nFreta3 +=  cFreta3 
 	nTotal3 +=  cTotal3 
 	
   	nQuant4 += 	ROUND(cQuant4,2)
 	nFret4  += 	ROUND(cFret4,2)
 	nFreta4 +=  ROUND(cFreta4,2) 
 	nTotal4 +=  ROUND(cTotal4,2) 
 	
   //	(cAlias)->(dbSkip())
	(cAlias1)->(dbSkip())
	(cAlias2)->(dbSkip())
	(cAlias3)->(dbSkip())
	(cAlias4)->(dbSkip())
EndDo

nLin++ 
cLin := SPACE(43)+"TOTAIS "+"  |" 
cLin += Padl(transform(nQuant1,"@E 999,999,999.99"),21)  	  +  " | " 
cLin += Padl("R$"+transform(nFret1,"@E 999,999,999.99"),21)   +  " | "                                         
cLin += Padl("R$"+transform(nFreta1,"@E 999,999,999.99"),21)  +  " | " 
cLin += Padl("R$"+transform(nTotal1,"@E 999,999,999.99"),21)  +  " | "  
@nLin,03 PSAY cLin  
nLin++  
if mv_par07==1
	Aadd(aReg,{"TOTAIS ",Padl(transform(nQuant1,"@E 999,999,999.99"),21),Padl("R$"+transform(nFret1,"@E 999,999,999.99"),21),Padl("R$"+transform(nFreta1,"@E 999,999,999.99"),21) ,Padl("R$"+transform(nTotal1,"@E 999,999,999.99"),21)})
endif 
//RESUMO DOS CALCULOS  
nLin++ 
nLin++ 
nLin++ 
cLin := SPACE(17)+"   " 
cLin += Padl("Quantidade",21)  	 +  " | " 
cLin += Padl("Frete Embutido",21)   +  " | "                                         
cLin += Padl("FretAut",21)  +  " | " 
cLin += Padl("Total",21)  +  " | "  
@nLin,03 PSAY cLin  
nLin++ 
if mv_par07==1
	Aadd(aReg,{Padl("Quantidade",21),Padl("Frete Embutido",21),Padl("FretAut",21),Padl("Total",21)})
endif 
cLin := SPACE(5)+"TOTAL EX -  "+"|  " 
cLin += Padl(transform(nQuant,"@E 999,999,999.99"),21)  	 +  " | " 
cLin += Padl("R$"+transform(nFret,"@E 999,999,999.99"),21)   +  " | "                                         
cLin += Padl("R$"+transform(nFreta,"@E 999,999,999.99"),21)  +  " | " 
cLin += Padl("R$"+transform(nTotal,"@E 999,999,999.99"),21)  +  " | "  
@nLin,03 PSAY cLin  
nLin++   
if mv_par07==1
	Aadd(aReg,{"TOTAIS EX - ",Padl(transform(nQuant,"@E 999,999,999.99"),21),Padl("R$"+transform(nFret,"@E 999,999,999.99"),21),Padl("R$"+transform(nFreta,"@E 999,999,999.99"),21) ,Padl("R$"+transform(nTotal,"@E 999,999,999.99"),21)})
endif 
cLin := SPACE(5)+"TOTAL OF    "+"| +" 
cLin += Padl(transform(nQuant1,"@E 999,999,999.99"),21)  	 +  " | " 
cLin += Padl("R$"+transform(nFret1,"@E 999,999,999.99"),21)   +  " | "                                         
cLin += Padl("R$"+transform(nFreta1,"@E 999,999,999.99"),21)  +  " | " 
cLin += Padl("R$"+transform(nTotal1,"@E 999,999,999.99"),21)  +  " | "  
@nLin,03 PSAY cLin  
nLin++    
if mv_par07==1
	Aadd(aReg,{"TOTAIS OF",Padl(transform(nQuant1,"@E 999,999,999.99"),21),Padl("R$"+transform(nFret1,"@E 999,999,999.99"),21),Padl("R$"+transform(nFreta1,"@E 999,999,999.99"),21) ,Padl("R$"+transform(nTotal1,"@E 999,999,999.99"),21)})
endif 
cLin := SPACE(5)+"TRANS CALC  "+"| -" 
cLin += Padl(transform(nQuant2,"@E 999,999,999.99"),21)  	 +  " | " 
cLin += Padl("R$"+transform(nFret2,"@E 999,999,999.99"),21)   +  " | "                                         
cLin += Padl("R$"+transform(nFreta2,"@E 999,999,999.99"),21)  +  " | " 
cLin += Padl("R$"+transform(nTotal2,"@E 999,999,999.99"),21)  +  " | "  
@nLin,03 PSAY cLin 
nLin++  
if mv_par07==1
	Aadd(aReg,{"Trans Calc ",Padl(transform(nQuant2,"@E 999,999,999.99"),21),Padl("R$"+transform(nFret2,"@E 999,999,999.99"),21),Padl("R$"+transform(nFreta2,"@E 999,999,999.99"),21) ,Padl("R$"+transform(nTotal2,"@E 999,999,999.99"),21)})
endif 
cLin := SPACE(5)+"TRANSF FERT "+"| -" 
cLin += Padl(transform(nQuant4,"@E 999,999,999.99"),21)  	 +  " | " 
cLin += Padl("R$"+transform(nFret4,"@E 999,999,999.99"),21)   +  " | "                                         
cLin += Padl("R$"+transform(nFreta4,"@E 999,999,999.99"),21)  +  " | " 
cLin += Padl("R$"+transform(nTotal4,"@E 999,999,999.99"),21)  +  " | "  
@nLin,03 PSAY cLin   
nLin++ 
if mv_par07==1
	Aadd(aReg,{"TOTAIS FERT ",Padl(transform(nQuant4,"@E 999,999,999.99"),21),Padl("R$"+transform(nFret4,"@E 999,999,999.99"),21),Padl("R$"+transform(nFreta4,"@E 999,999,999.99"),21) ,Padl("R$"+transform(nTotal4,"@E 999,999,999.99"),21)})
endif 
cLin := SPACE(5)+"DEVOLUCOES  "+"| -" 
cLin += Padl(transform(nQuant3,"@E 999,999,999.99"),21)  	 +  " | " 
cLin += Padl("R$"+transform(nFret3,"@E 999,999,999.99"),21)   +  " | "                                         
cLin += Padl("R$"+transform(nFreta3,"@E 999,999,999.99"),21)  +  " | " 
cLin += Padl("R$"+transform(nTotal3,"@E 999,999,999.99"),21)  +  " | "  
@nLin,03 PSAY cLin  
nLin++  
nLin++  
if mv_par07==1
	Aadd(aReg,{"Devolucoes ",Padl(transform(nQuant3,"@E 999,999,999.99"),21),Padl("R$"+transform(nFret3,"@E 999,999,999.99"),21),Padl("R$"+transform(nFreta3,"@E 999,999,999.99"),21) ,Padl("R$"+transform(nTotal3,"@E 999,999,999.99"),21)})
endif 
cLin := SPACE(5)+"TOTAL GERAL "+"| =" 
cLin += Padl(transform(((nQuant+nQuant1)-(nQuant3+nQuant2+nQuant4)),"@E 999,999,999.99"),21)  	 +  " | " 
cLin += Padl("R$"+transform(((nFret+nFret1)-(nFret3+nFret2+nFret4)),"@E 999,999,999.99"),21)   +  " | "                                         
cLin += Padl("R$"+transform(((nFreta+nFreta1)-(nFreta3+nFreta2+nFreta4)),"@E 999,999,999.99"),21)  +  " | " 
cLin += Padl("R$"+transform(((nTotal+nTotal1)-(nTotal3+nTotal2+nTotal4)),"@E 999,999,999.99"),21)  +  " | "  
@nLin,03 PSAY cLin  
nLin++ 
if mv_par07==1
	Aadd(aReg,{"Total Geral ",Padl(transform(((nQuant+nQuant1)-(nQuant3+nQuant2+nQuant4)),"@E 999,999,999.99"),21),Padl("R$"+transform(((nFret+nFret1)-(nFret3+nFret2+nFret4)),"@E 999,999,999.99"),21),Padl("R$"+transform(nFreta3,"@E 999,999,999.99"),21) ,Padl("R$"+transform(((nFreta+nFreta1)-(nFreta3+nFreta2+nFreta4)),"@E 999,999,999.99"),21),Padl("R$"+transform(((nTotal+nTotal1)-(nTotal3+nTotal2+nTotal4)),"@E 999,999,999.99"),21)})
endif 

 
if mv_par07==1
  U_Arr3Excl(aReg)
endif
   

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


User Function Arr3Excl(aReg)
// Alert(TRB->(DBInfo(10)))
Processa( { || ToProcEx(aReg) } )
Return

Static Function ToProcEx(aReg)
LOCAL cDirDocs   := MsDocPath() 
Local aStru		:= {}
Local cArquivo := CriaTrab(,.F.)
Local cPath		:= AllTrim(GetTempPath())
Local oExcelApp
Local nHandle
Local cCrLf 	:= Chr(13) + Chr(10)
Local nX, ii, i

if Len(aReg)=0
  MsgAlert( 'Não há dados para exportar!' )
  Return
endif

nHandle := MsfCreate(cDirDocs+"\"+cArquivo+".CSV",0)

If nHandle > 0
	
	// Grava o cabecalho do arquivo
	IncProc("Aguarde! Gerando arquivo de integração com Excel...") // 

    for i:=1 to len(aReg) 
		IncProc("Aguarde! Gerando arquivo de integração com Excel...")
		for ii:=1 to len(aReg[i]) 
		    fWrite(nHandle, aReg[i][ii] + ";" )
		next ii
		fWrite(nHandle, cCrLf ) // Pula linha
     next i
	
	IncProc("Aguarde! Abrindo o arquivo..." ) //
	
	fClose(nHandle)
	CpyS2T( cDirDocs+"\"+cArquivo+".CSV" , cPath, .T. )
	
	If ! ApOleClient( 'MsExcel' ) 
		MsgAlert( 'MsExcel nao instalado' ) //
		Return
	EndIf
	
	oExcelApp := MsExcel():New()
	oExcelApp:WorkBooks:Open( cPath+cArquivo+".CSV" ) // Abre uma planilha
	oExcelApp:SetVisible(.T.)
Else
	MsgAlert( "Falha na criação do arquivo" ) // 
Endif	

Return
