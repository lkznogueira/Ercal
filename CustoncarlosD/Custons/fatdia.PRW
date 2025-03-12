#INCLUDE "rwmake.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³fatdia   º Autor ³ Carlos Daniel º Data ³  07/05/19         º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Relatorio Faturamento Diario.                              º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³  Ercal 			                                          º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function fatdia()


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
 
Local cDesc1       := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2       := "de acordo com os parametros informados pelo usuario."
Local cDesc3       := ""
Local cPict        := ""
Local titulo       := "Resumo de Estoque"
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
Private nomeprog   := "fatdia" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo      := 18
Private aReturn    := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey   := 0
Private cPerg      := "fatdia"
Private cbtxt      := Space(10)
Private cbcont     := 00
Private CONTFL     := 01                                                                  
Private m_pag      := 01
Private wnrel      := "fatdia" // Coloque aqui o nome do arquivo usado para impressao em disco      
Private cString := "Z13"

dbSelectArea("Z13")
dbSetOrder(1)
/*
U_xPutSX1(cPerg , "01" , "Filial de           " , "" , "" , "mv_ch1" , "C" , 4  , 0 , 0 , "G" , "", "SM0", "", "", "mv_par01" , "        " ,"","","", "        " ,"","","", "        " , "" , "" , "" , "" , "" , "" , "" , "" )
U_xPutSX1(cPerg , "02" , "Filial ate          " , "" , "" , "mv_ch2" , "C" , 4  , 0 , 0 , "G" , "", "SM0", "", "", "mv_par02" , "        " ,"","","", "   	  " ,"","","", "        " , "" , "" , "" , "" , "" , "" , "" , "" )
U_xPutSX1(cPerg , "03" , "Data FIM            " , "" , "" , "mv_ch3" , "D" , 4  , 0 , 0 , "G" , "", "", "", "", "mv_par03" , "        " ,"","","", "        " ,"","","", "        " , "" , "" , "" , "" , "" , "" , "" , "" )
U_xPutSX1(cPerg , "04" , "Produto  de         " , "" , "" , "mv_ch4" , "C" , 10  , 0 , 0 , "G" , "", "SB1", "", "", "mv_par04" , "        " ,"","","", "   	  " ,"","","", "        " , "" , "" , "" , "" , "" , "" , "" , "" )
U_xPutSX1(cPerg , "05" , "Produto  ate        " , "" , "" , "mv_ch5" , "C" , 10  , 0 , 0 , "G" , "", "SB1", "", "", "mv_par05" , "        " ,"","","", "   	  " ,"","","", "        " , "" , "" , "" , "" , "" , "" , "" , "" )
u_xPutSx1(cPerg , "06" , "Exporta Excel?      " , "" , "" , "mv_ch6" , "N" , 1  , 0 , 0 , "C" , "", "", "", "" ,"mv_par06","Sim","Sim","Sim","Nao","Nao","Nao","","","","","","","","","")
*/
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

Local nVALOR
Local aReg:={}
Private cAlias := Criatrab(Nil,.F.)   
Private cAlias1 := Criatrab(Nil,.F.) 
Private cAlias2 := Criatrab(Nil,.F.)
Private cAlias3 := Criatrab(Nil,.F.)
Private cAlias4 := Criatrab(Nil,.F.)
Private cAlias5 := Criatrab(Nil,.F.)
Private cQry := Space(0) 
Private cQry1 := Space(0) 
Private cQry2 := Space(0) 
Private cQry3 := Space(0) 
Private cQry4 := Space(0)  
Private cQry5 := Space(0)  
Private nRest 
Private cLin 
Private dFim := DToS(MV_PAR03) 
Private aCampos:={}
Private aIndice:={} 
//Private cAliasTrb := "TOTBAL"

//Saldo Inicial
cQry2 := " SELECT 
cQry2 += " Z13_FILIAL AS FILIAL,
cQry2 += " Z13_PRODUT AS PRODUTO,
cQry2 += " Z13_QUANT AS QTD_OF  
cQry2 += " FROM "+RetSqlName("Z13") +" Z13
cQry2 += " WHERE Z13.d_e_l_e_t_ <> '*' 
cQry2 += " AND Z13_FILIAL  BETWEEN '"+MV_PAR01+"' AND  '"+MV_PAR02+"'  
cQry2 += " AND Z13_PRODUT  BETWEEN '"+MV_PAR04+"' AND  '"+MV_PAR05+"'   
cQry2 += " ORDER BY Z13_FILIAL, Z13_PRODUT   

DbUseArea(.T., "TOPCONN", TcGenQry(,, cQry2), cAlias2, .T., .T.)
DbGotop()  


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ SETREGUA -> Indica quantos registros serao processados para a regua ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetRegua(RecCount())  
	
Cabec1 := Space(3)
Cabec1 += Padc("Filial" ,6)			 	  	   					+ " | "
Cabec1 += Padc("Produto",10)									+ " | "
Cabec1 += Padc("Descrição" ,30)		 	  	   		   	    	+ " | "

nPosQtd := Len(Cabec1)
Cabec1 += Padc("Saldo INC" ,21)		 	  	  	   				+ " | " 
Cabec1 += Padc("Produzido" ,21)		   	  	   			 		+ " | " 
Cabec1 += Padc("Transferido" ,21)		   	  	   			 	+ " | " 
Cabec1 += Padc("Saidas ex" ,21)			   	  	   				+ " | "  
Cabec1 += Padc("Saidas ofc" ,21)			   	  	   			+ " | "
Cabec1 += Padc("Saldo" ,21)			   	  	   		   			+ " | " 
Cabec1 += Padc("Data Fim" ,11)		   	  	   					+ " | "   
Cabec2 := Space(0)

if mv_par06==1
	Aadd(aReg,{Padc("Filial" ,10),Padc("Produto",10),Padc("Descrição" ,30),Padc("Saldo INC" ,21),Padc("Produzido" ,21),Padc("Transferido",21),Padc("Saidas EX" ,21),Padc("Saidas ofc" ,21),Padc("Saldo" ,21),Padc("Data FIM" ,21)})
endif

dbGoTop()
//While !EOF() 
While (cAlias2)->(!EOF())  

	//Saida EXT 
	cQry := " SELECT  
	cQry += " Z12_FILIAL,
	cQry += " Z12_PRODUT,
	cQry += " (SELECT B1_DESC FROM SB1010 SB1 WHERE sb1.d_e_l_e_t_ <> '*' AND Z12_PRODUT = B1_COD) DESCR, 
	cQry += " SUM(Z12_QUANT) AS QTD_EX 
	cQry += " FROM "+RetSqlName("Z12") +" Z12 
	cQry += " WHERE d_e_l_e_t_ <> '*'
	cQry += " AND Z12_EMISSA BETWEEN '20181231' AND '"+DToS(MV_PAR03)+"'
	cQry += " AND Z12_FILIAL = '"+(cAlias2)->FILIAL+"'  
	cQry += " AND Z12_PRODUT = '"+(cAlias2)->PRODUTO+"'
	cQry += " GROUP BY Z12_FILIAL, Z12_PRODUT
	cQry += " ORDER BY Z12_FILIAL, Z12_PRODUT
	DbUseArea(.T., "TOPCONN", TcGenQry(,, cQry), cAlias, .T., .T.)
	DbGotop()    

	//Saida OFC
	cQry1 := " SELECT 
	cQry1 += " D2_FILIAL AS FILIAL,
	cQry1 += " D2_COD AS PRODUTO, 
	cQry1 += " (SELECT B1_DESC FROM SB1010 SB1 WHERE sb1.d_e_l_e_t_ <> '*' AND D2_COD = B1_COD) DESCR,
	cQry1 += " SUM(D2_QUANT) QTD_OF
	cQry1 += " FROM "+RetSqlName("SD2") +" SD2
	cQry1 += " WHERE SD2.d_e_l_e_t_ <> '*' 
	cQry1 += " AND D2_FILIAL = '"+(cAlias2)->FILIAL+"'
	cQry1 += " AND D2_EMISSAO BETWEEN '20181231' AND '"+DToS(MV_PAR03)+"'
	cQry1 += " AND D2_COD = '"+(cAlias2)->PRODUTO+"'
	cQry1 += " AND D2_TIPO = 'N'
	cQry1 += " AND D2_TP = 'PA'  
	cQry1 += " AND D2_CF IN ('5101','5116','6101','5107','6107','6116','5949','6949','5401','6401')   							
	cQry1 += " GROUP BY D2_FILIAL, D2_COD
	cQry1 += " ORDER BY D2_FILIAL, D2_COD
	DbUseArea(.T., "TOPCONN", TcGenQry(,, cQry1), cAlias1, .T., .T.)
	DbGotop() 

	//Produção Saldo
	cQry3 := " SELECT 
	cQry3 += " Z10_FILIAL AS FILIAL,
	cQry3 += " Z10_COD AS PRODUTO,
	cQry3 += " SUM(Z10_QUANT) AS QTD_OF  
	cQry3 += " FROM "+RetSqlName("Z10") +" Z10
	cQry3 += " WHERE Z10.d_e_l_e_t_ <> '*' 
	cQry3 += " AND Z10_FILIAL = '"+(cAlias2)->FILIAL+"'
	cQry3 += " AND Z10_EMISSA BETWEEN '20181231' AND '"+DToS(MV_PAR03)+"' 
	cQry3 += " AND Z10_COD = '"+(cAlias2)->PRODUTO+"'
	cQry3 += " GROUP BY Z10_FILIAL, Z10_COD 
	cQry3 += " ORDER BY Z10_FILIAL, Z10_COD
	DbUseArea(.T., "TOPCONN", TcGenQry(,, cQry3), cAlias3, .T., .T.)
	DbGotop() 
	//transferencia
	cQry4 := " SELECT D3_FILIAL, D3_COD, SUM(D3_QUANT) AS QTD_OF from "+RetSqlName("SD3") +" SAIDA
   	//cQry3 += " INNER JOIN SD3010 ENTRADA ON (SAIDA.D3_FILIAL=ENTRADA.D3_FILIAL AND SAIDA.D3_DOC=ENTRADA.D3_DOC AND SAIDA.D3_NUMSEQ=ENTRADA.D3_NUMSEQ)
	cQry4 += " where D3_CF='DE4' 
  	//cQry3 += " AND ENTRADA.D3_CF='RE4'
	//cQry3 += " AND SAIDA.D3_LOCAL='02' 
	cQry4 += " AND D3_FILIAL = '"+(cAlias2)->FILIAL+"'
	cQry4 += " AND SAIDA.D_E_L_E_T_ <> '*' 
	cQry4 += " AND D3_COD = '"+(cAlias2)->PRODUTO+"'
	cQry4 += " AND D3_EMISSAO BETWEEN '20181231' AND '"+DToS(MV_PAR03)+"'
	cQry4 += " GROUP BY D3_FILIAL, D3_COD	  
	DbUseArea(.T., "TOPCONN", TcGenQry(,, cQry4), cAlias4, .T., .T.)
	DbGotop() 
	
	//Produção - pedra saidas
	cQry5 := " SELECT 
	cQry5 += " Z10_FILIAL AS FILIAL,
	cQry5 += " SUM(Z10_QUANT) AS QTD_OF  
	cQry5 += " FROM "+RetSqlName("Z10") +" Z10
	cQry5 += " WHERE Z10.d_e_l_e_t_ <> '*' 
	cQry5 += " AND Z10_FILIAL = '"+(cAlias2)->FILIAL+"'
	cQry5 += " AND Z10_EMISSA BETWEEN '20181231' AND '"+DToS(MV_PAR03)+"' 
	cQry5 += " AND Z10_COD not in ('000162','000163')
	cQry5 += " GROUP BY Z10_FILIAL 
	cQry5 += " ORDER BY Z10_FILIAL
	DbUseArea(.T., "TOPCONN", TcGenQry(,, cQry5), cAlias5, .T., .T.)
	DbGotop()

//Imprime o Relatório  
		
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

	cQuant := (((cAlias2)->QTD_OF+(cAlias3)->QTD_OF)-((cAlias)->QTD_EX+(cAlias1)->QTD_OF)) 
	cQuant += (cAlias4)->QTD_OF  
	
	iF trim((cAlias2)->PRODUTO) == '000162'
		nSaid  := ((cAlias1)->QTD_OF+(cAlias5)->QTD_OF) 
		nSald  := (cQuant-nSaid)
	Else
		nSaid  := (cAlias1)->QTD_OF    
		nSald  := cQuant
	endIF
	
	//nVALOR := ROUND(nVALOR)
	nLin++   //pula pra linha debaixo 
   	cLin := Padl((cAlias2)->FILIAL, 6)    	       							   	    		+  " | " //Filial
   	cLin += Padc((cAlias2)->PRODUTO, 10)     		   							        	+  " | " // Produto
   	cLin += Padl(Posicione("SB1",1,xFilial("SB1")+(cAlias2)->PRODUTO,"B1_DESC"), 30)      	+  " | " // Descricao    	  
   	cLin += Padl(transform((cAlias2)->QTD_OF,"@E 999,999,999.99"),21) 			  			+  " | " //Saldo Inicial
   	cLin += Padl(transform((cAlias3)->QTD_OF,"@E 999,999,999.99"),21) 			 			+  " | " //Produzido 
   	cLin += Padl(transform((cAlias4)->QTD_OF,"@E 999,999,999.99"),21) 			 			+  " | " //transferencia 	
   	cLin += Padl(transform((cAlias)->QTD_EX,"@E 999,999,999.99"),21)			 	   		+  " | " //Saida EX
   	cLin += Padl(transform(nSaid,"@E 999,999,999.99"),21)		   				 	   		+  " | " //Saida OFC  
    cLin += Padl(transform(nSald,"@E 999,999,999.99"),21)			 				 		+  " | " //Saldo 
    //cLin += dtoc(stod((cAlias)->Z12_EMISSA))	                          			    	+  " | " //DATA 
    cLin += dtoc(stod(dFim))					 									   		+  " | " //Data FIM 
		                            
  	@nLin,03 PSAY cLin
   	nLin++  //pula pra linha debaixo
   	//ntotal += (cAlias)->ADB_TOTAL  
   	if mv_par06==1
	  Aadd(aReg,{Padl((cAlias2)->FILIAL, 10),Padc((cAlias2)->PRODUTO, 10),Padl(Posicione("SB1",1,xFilial("SB1")+(cAlias2)->PRODUTO,"B1_DESC"), 30) ,Padl(transform((cAlias2)->QTD_OF,"@E 999,999,999.99"),21),Padl(transform((cAlias3)->QTD_OF,"@E 999,999,999.99"),21),Padl(transform((cAlias4)->QTD_OF,"@E 999,999,999.99"),21),Padl(transform((cAlias)->QTD_EX,"@E 999,999,999.99"),21),Padl(transform(nSaid,"@E 999,999,999.99"),21),Padl(transform(nSald,"@E 999,999,999.99"),21),dtoc(stod(dFim))})
	endif

	(cAlias)->(dbCloseArea())
   	(cAlias1)->(dbCloseArea())
   	(cAlias3)->(dbCloseArea())              
   	(cAlias4)->(dbCloseArea())
   	(cAlias5)->(dbCloseArea())  
   	(cAlias2)->(dbSkip())

EndDo 

(cAlias2)->(dbCloseArea())
if mv_par06==1
  Arr3Excl(aReg)
endif

nLin++ 
@nLin,03 PSAY cLin
   
    
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


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±³Fun‡„o	 ³ TrbToExcel ³ Autor ³ Claudio Ferreira    ³ Data ³ 05/07/18 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Exporta TRB                                                 ±±
±±³                                                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ TBC-GO                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function Arr3Excl(aReg)
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
