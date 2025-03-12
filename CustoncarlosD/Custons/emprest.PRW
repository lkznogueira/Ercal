#INCLUDE "rwmake.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³EMPREST   º Autor ³CARLOS DANIEL º Data ³  29/05/15         º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ RESUMO EMPRESTIMOS/APLICACAP.                              º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ 			                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function EMPREST()


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
 
Local cDesc1       := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2       := "de acordo com os parametros informados pelo usuario."
Local cDesc3       := ""
Local cPict        := ""
Local titulo       := "Resumo Emprestimo/Aplicação"
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
Private nomeprog   := "EMPREST" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo      := 18
Private aReturn    := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey   := 0
Private cPerg      := "EMPREST"
Private cbtxt      := Space(10)
Private cbcont     := 00
Private CONTFL     := 01
Private m_pag      := 01
Private wnrel      := "EMPREST" // Coloque aqui o nome do arquivo usado para impressao em disco      
Private cString := "SEH"

dbSelectArea("SEH")
dbSetOrder(1)
/*
U_xPutSX1(cPerg , "01" , "Numero de   	   " , "" , "" , "mv_ch1" , "C" , 10 , 0 , 0 , "G" , "", "", "", "", "mv_par01" , "        " ,"","","", "        " ,"","","", "        " , "" , "" , "" , "" , "" , "" , "" , "" )
U_xPutSX1(cPerg , "02" , "Numero ate  	   " , "" , "" , "mv_ch2" , "C" , 10 , 0 , 0 , "G" , "", "", "", "", "mv_par02" , "        " ,"","","", "   	  " ,"","","", "        " , "" , "" , "" , "" , "" , "" , "" , "" )
U_xPutSX1(cPerg , "03" , "Filial de       " , "" , "" , "mv_ch3" , "C" , 4  , 0 , 0 , "G" , "", "SM0", "", "", "mv_par03" , "        " ,"","","", "        " ,"","","", "        " , "" , "" , "" , "" , "" , "" , "" , "" )
U_xPutSX1(cPerg , "04" , "Filial ate      " , "" , "" , "mv_ch4" , "C" , 4  , 0 , 0 , "G" , "", "SM0", "", "", "mv_par04" , "        " ,"","","", "   	  " ,"","","", "        " , "" , "" , "" , "" , "" , "" , "" , "" )
U_xPutSX1(cPerg , "05" , "Data In.        " , "" , "" , "mv_ch5" , "D" , 4  , 0 , 0 , "G" , "", "", "", "", "mv_par05" , "        " ,"","","", "        " ,"","","", "        " , "" , "" , "" , "" , "" , "" , "" , "" )
U_xPutSX1(cPerg , "06" , "Data Fin.       " , "" , "" , "mv_ch6" , "D" , 4  , 0 , 0 , "G" , "", "", "", "", "mv_par06" , "        " ,"","","", "   	  " ,"","","", "        " , "" , "" , "" , "" , "" , "" , "" , "" )
U_xPutSX1(cPerg , "07" , "Data Baix de    " , "" , "" , "mv_ch7" , "D" , 4  , 0 , 0 , "G" , "", "", "", "", "mv_par07" , "        " ,"","","", "        " ,"","","", "        " , "" , "" , "" , "" , "" , "" , "" , "" )
U_xPutSX1(cPerg , "08" , "Data Baix ate   " , "" , "" , "mv_ch8" , "D" , 4  , 0 , 0 , "G" , "", "", "", "", "mv_par08" , "        " ,"","","", "   	  " ,"","","", "        " , "" , "" , "" , "" , "" , "" , "" , "" )
U_xPutSX1(cPerg , "09" , "Tipo Imp.	   " , "" , "" , "mv_ch9" , "N" , 1  , 0 , 1 , "C" , "", "", "", "", "mv_par09" , "(1)Analitico" ,"","","", "(2)Sintetico" ,"","","", "        " , "" , "" , "" , "" , "" , "" , "" , "" )
U_xPutSX1(cPerg , "10" , "Situaçao        " , "" , "" , "mv_ch10" , "N" , 1  , 0 , 1 , "C" , "", "", "", "", "mv_par10" , "(1)Emprestimo" ,"","","", "(2)Aplicação" ,"","","", "        " , "" , "" , "" , "" , "" , "" , "" , "" )
u_xPutSx1(cPerg , "11" , "Exporta Excel?      " , "" , "" , "mv_ch11" , "N" , 1  , 0 , 0 , "C" , "", "", "", "" ,"mv_par11","Sim","Sim","Sim","Nao","Nao","Nao","","","","","","","","","")
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
Local ntotal := 0
Local nNumero := "0"
Local ntotalz := 0
Local nOrdem
Local _cCalc := ""
Local _cAqui := ""
Local _cMes1 := ""
Local _cAcul := ""
Local cTxdep := "" 
LOCAL nValo             //colocada para calculo geral
LOCAL nValor := 0 //para calculo geral  
LOCAL nBaixa := 0  
LOCAL nBaixas := 0  
LOCAL cAquis := 0 
LOCAL ntotals := 0
Private cAlias := Criatrab(Nil,.F.)
Private cQry := Space(0)     
Private cAliasTrb := "TOTBAL"

IF mv_par09 == 1   

	cQry += " SELECT E5_FILORIG AS FILIAL, E5_DOCUMEN AS NUMERO, E5_DATA, E5_VALOR AS VALOR, E5_HISTOR AS HISTORICO, E5_TIPODOC AS TIPO,
	cQry += " (SELECT trim(EH_NBANCO) FROM "+RetSqlName("SEH") +" SEH WHERE SUBSTR(E5_DOCUMEN, 1, LENGTH(EH_NUMERO)) = EH_NUMERO AND SEH.D_E_L_E_T_ <> '*' ) AS NBANCO,
	cQry += " (SELECT trim(EH_XBANCO) FROM "+RetSqlName("SEH") +" SEH WHERE SUBSTR(E5_DOCUMEN, 1, LENGTH(EH_NUMERO)) = EH_NUMERO AND SEH.D_E_L_E_T_ <> '*' ) AS XBANCO 
	cQry += " FROM "+RetSqlName("SE5") +" SE5
	cQry += " WHERE D_E_L_E_T_ <> '*'
	cQry += " AND E5_FILORIG BETWEEN  '"+MV_PAR03+"' AND  '"+MV_PAR04+"'
	cQry += " AND E5_DOCUMEN BETWEEN '"+MV_PAR01+"' AND  '"+MV_PAR02+"'
	cQry += " AND E5_DATA BETWEEN '"+DToS(MV_PAR07)+"' AND '"+DToS(MV_PAR08)+"'
	IF mv_par10 == 1
		cQry += " AND E5_TIPODOC IN ('EP','PE')
	Else
		cQry += " AND E5_TIPODOC IN ('AP','RF')
	EndIF
	cQry += " order by e5_DOCUMEN 
	DbUseArea(.T., "TOPCONN", TcGenQry(,, cQry), cAlias, .T., .T.)
	DbGotop() 

ELSE 

	cQry += " SELECT EH_FILIAL AS FILIAL, EH_NUMERO AS NUMERO, EH_XBANCO, EH_NBANCO, EH_DATA, EH_VALOR AS VALOR, EH_VALREG AS VALORB, EH_VALCRED, EH_VALREG2, EH_SALDO AS SALDO, EH_APLEMP AS TIPO, EH_STATUS,
	cQry += " ((SELECT SUM(E5_VALOR) FROM "+RetSqlName("SE5") +" SE5 WHERE SUBSTR(E5_DOCUMEN, 1, LENGTH(EH_NUMERO)) = EH_NUMERO AND D_E_L_E_T_ <> '*' AND E5_TIPODOC IN ('AP','RF','EP','PE'))-EH_VALOR) AS VLRPAGO
	cQry += " FROM "+RetSqlName("SEH") +" SEH
	cQry += " WHERE EH_NUMERO BETWEEN '"+MV_PAR01+"' AND  '"+MV_PAR02+"'
	cQry += " AND EH_FILIAL BETWEEN '"+MV_PAR03+"' AND  '"+MV_PAR04+"'
	cQry += " AND EH_DATA  BETWEEN '"+DToS(MV_PAR05)+"' AND '"+DToS(MV_PAR06)+"' 
	IF mv_par10 == 1
		cQry += " AND EH_APLEMP = 'EMP' 
	Else
		cQry += " AND EH_APLEMP = 'APL' 
	EndIF
	cQry += " AND D_E_L_E_T_ <> '*'
	cQry += " ORDER BY EH_NUMERO
	DbUseArea(.T., "TOPCONN", TcGenQry(,, cQry), cAlias, .T., .T.)
	DbGotop()
ENDIF
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ SETREGUA -> Indica quantos registros serao processados para a regua ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
IF mv_par09 == 1

SetRegua(RecCount())

	Cabec1 += Space(3)
	Cabec1 += Padc("FILIAL" ,6)	  			   	  	   			   	    + " | "  
	Cabec1 += Padc("NUMERO" ,14)			   		    				+ " | "  
	Cabec1 += Padc("ITEM CONTABIL",13)	   	   	              		    + " | "  
	Cabec1 += Padc("BENEFICIARIO",30)	   	   	              		    + " | "  
	Cabec1 += Padc("TIPO",16)	   	   	              					+ " | "   
	Cabec1 += Padc("VALOR EMP/APL" ,16)	   	   							+ " | " 
	Cabec1 += Padc("VLR BAIXADO" ,16)			   	  	   			    + " | "
	//Cabec1 += Padc("SALDO" ,16)	  			   	  	   			   	    + " | "  
	nPosQtd := Len(Cabec1)
	Cabec1 += Padc("DATA EMISSÃO",len(dtoc(stod((cAlias)->E5_DATA))))   + " | "
	//Cabec1 += Padc("STATUS",10) 										+ " | "
	Cabec2 := Space(0) 
	
	if mv_par11==1
	  Aadd(aReg,{Padc("FILIAL" ,6),Padc("NUMERO",14),Padc("ITEM CONTABIL" ,13),Padc("BENIFICIARIO" ,30),Padc("TIPO" ,16),Padc("VALOR EMP/APL" ,16),Padc("VLR BAIXADO" ,16)	,Padc("DATA EMISSAO" ,len(dtoc(stod((cAlias)->E5_DATA))))})
	endif

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
	IF nNumero <>  SUBSTR((cAlias)->NUMERO,1,8)
		IF !nNumero == '0'
  			cLin := SPACE(83)+"TOTAL R$"+" | "+Padr(transform(nValor,"@E 999,999,999.99"),16)  +  " | "  //total bx
  			nValor := 0
  			cLin += Padl("R$"+transform(nValo,"@E 999,999,999.99"),16)   					   +  " | " // SALDO	
  			@nLin,03 PSAY cLin
			nLin++  //pula pra linha debaixo
		EndIF	
	EndIF                                     
	                                              		
	IF (cAlias)->TIPO == 'EP' .or. (cAlias)->TIPO == 'AP' 

		cBXATI := dtoc(stod((cAlias)->E5_DATA))
		nLin++   //pula pra linha debaixo
		cLin := Padl((cAlias)->FILIAL, 6)    	       							   		+  " | "
		cLin += Padl((cAlias)->NUMERO, 14)     		   									+  " | "	
   		cLin += Padl((cAlias)->XBANCO, 13)      										+  " | "  //ITEM CONTABIL
   		cLin += Padl((cAlias)->NBANCO, 30)      										+  " | "  //DESC ITEM
   		IF (cAlias)->TIPO == 'EP' 
	 		cLin += Padl("("+(cAlias)->TIPO+")"+"EMPRESTIMO",16)      	     			+  " | "  //TIPO
   		ELSE
	  		cLin += Padl("("+(cAlias)->TIPO+") "+"APLICAÇÃO",16)      	     			+  " | "  //TIPO
   		ENDIF
		cLin += Padl("R$"+transform((cAlias)->VALOR,"@E 999,999,999.99"),16) 		    +  " | " // VALOR 
		cLin += Padl("R$"+transform(00000000000,"@E 999,999,999.99"),16) 		    	+  " | " // VALOR BAIXA 
		//cLin += Padl("R$"+transform(00000000000,"@E 999,999,999.99"),16)           		+  " | " // SALDO
		cLin += dtoc(stod((cAlias)->E5_DATA))	                                        +  " | " //DATA COMPRA 
		cAqui := 0	 
   		nValo := (cAlias)->VALOR 
   		ntotal += (cAlias)->VALOR 
	@nLin,03 PSAY cLin
	nLin++  //pula pra linha debaixo
	ELSE
		IF (cAlias)->TIPO == 'PE' .and. nNumero $  SUBSTR((cAlias)->NUMERO,1,8) .or. (cAlias)->TIPO == 'RF' .and. nNumero $  SUBSTR((cAlias)->NUMERO,1,8)
		
	   		cLin := Padl((cAlias)->FILIAL, 6) 								   	        	+  " | "
			cLin += Padl((cAlias)->NUMERO, 14)     	   							    		+  " | "	
   			cLin += Padl((cAlias)->XBANCO, 13)      										+  " | "  //ITEM CONTABIL
   			cLin += Padl((cAlias)->NBANCO, 30)      										+  " | "  //DESC ITEM
   			IF (cAlias)->TIPO == 'PE' 
	 			cLin += Padl("("+(cAlias)->TIPO+")"+"PAGTO.EMPRESTIMO",16)      	     	+  " | "  //TIPO
   			ELSE
	  	   		cLin += Padl("("+(cAlias)->TIPO+") "+"RESG. APLICAÇÃO",16)      	     	+  " | "  //TIPO
   	   		ENDIF
	   		cLin += Padl("R$"+transform(00000000000,"@E 999,999,999.99"),16) 		    	+  " | " // VALOR 
	   		cLin += Padl("R$"+transform((cAlias)->VALOR,"@E 999,999,999.99"),16) 		   	+  " | " // VALOR BAIXA 
			//cLin += Padl("R$"+transform((nValo-(cAlias)->VALOR),"@E 999,999,999.99"),16)   	+  " | " // SALDO
	   		cLin += dtoc(stod((cAlias)->E5_DATA))
  			cAqui := (cAlias)->VALOR   
  			nValo 	:= (nValo-(cAlias)->VALOR)
  			nValor  += cAqui
  			ntotalz += cAqui 
  			
  			@nLin,03 PSAY cLin
  			nLin++ 			
	    
   		EndIF  
  	EndIF
  	nNumero := SUBSTR((cAlias)->NUMERO,1,8) 
  	if mv_par11==1
   		Aadd(aReg,{(cAliasTrb)->CONTA,(cAliasTrb)->TIPO,(cAliasTrb)->DESCR,Padl("R$"+transform((cAliasTrb)->NOMES,"@E 999,999,999.99"),21),Padl("R$"+transform((cAliasTrb)->ATEMES,"@E 999,999,999.99"),21),Padl("R$"+transform((cAliasTrb)->ANOMES,"@E 999,999,999.99"),21),Padl("R$"+transform((cAliasTrb)->AATEMES,"@E 999,999,999.99"),21),Padc(transform(nVALOR,"@E 9,999.99") , 14),Padc(transform(nVALOR1,"@E 9,999.99") , 14)})
	endif
	(cAlias)->(dbSkip())
EndDo  

nLin++ 
cLin := SPACE(77)+"TOTAL GERAL R$"+" | "+Padr(transform(ntotal,"@E 999,999,999.99"),16)  +  " | "  //total Geral Emprestimos
cLin += Padr(transform(ntotalz,"@E 999,999,999.99"),16)  +  " | "  //total Geral Baixa
//cLin += Padr(transform(ntotalz,"@E 999,999,999.99"),16)  +  " | "  //total Geral Saldo 
  
if mv_par11==1
  U_Arr1Excl(aReg)
endif

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

ELSEIF mv_par09 == 2
	
	SetRegua(RecCount())

	Cabec1 += Space(3)
	Cabec1 += Padc("FILIAL" ,6)	  			   	  	   			   	    + " | "  
	Cabec1 += Padc("NUMERO" ,len((cAlias)->NUMERO))			   		    + " | "  
	Cabec1 += Padc("ITEM CONTABIL",13)	   	   	              		    + " | "  
	Cabec1 += Padc("BENEFICIARIO",30)	   	   	              		    + " | "  
	Cabec1 += Padc("TIPO",15)	   	   	              					+ " | "   
	Cabec1 += Padc("VALOR" ,16)			   	   							+ " | " 
	Cabec1 += Padc("VLR BAIXADO" ,16)			   	  	   			    + " | "
	Cabec1 += Padc("SALDO" ,16)	  			   	  	   			   	    + " | "  
	nPosQtd := Len(Cabec1)
	Cabec1 += Padc("DATA EMISSÃO",len(dtoc(stod((cAlias)->EH_DATA))))   + " | "
	Cabec1 += Padc("STATUS",10) 										+ " | "
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
   		cAqui := (cAlias)->SALDO

		cLin := Padl((cAlias)->FILIAL,6)    	       									+  " | "
   		cLin += transform((cAlias)->NUMERO, PesqPict("SEH","EH_NUMERO"))     		    +  " | "	
   		cLin += Padl((cAlias)->EH_XBANCO, 13)      										+  " | "  //ITEM CONTABIL
   		cLin += Padl((cAlias)->EH_NBANCO, 30)      										+  " | "  //DESC ITEM
   		IF (cAlias)->TIPO == 'EMP' 
	 		cLin += Padl("("+(cAlias)->TIPO+")"+"EMPRESTIMO",15)      	     			+  " | "  //TIPO
   		ELSE
	  		cLin += Padl("("+(cAlias)->TIPO+") "+"APLICAÇÃO",15)      	     			+  " | "  //TIPO
   		ENDIF
   		cLin += Padl("R$"+transform((cAlias)->VALOR,"@E 999,999,999.99"),16) 		    +  " | " // VALOR 
   		cLin += Padl("R$"+transform((cAlias)->VLRPAGO,"@E 999,999,999.99"),16) 			+  " | " // VALOR 
   		cLin += Padl("R$"+transform(cAqui,"@E 999,999,999.99"),16) 	   					+  " | " // VALOR SALDO   
   		cLin += dtoc(stod((cAlias)->EH_DATA))	                                        +  " | " //DATA  
   		IF (cAlias)->EH_STATUS == 'B' 
			cLin += Padl("("+(cAlias)->EH_STATUS+")"+"BAIXADO",10)      	     		+  " | " //Status 
   		ELSE
	 		cLin += Padl("("+(cAlias)->EH_STATUS+") "+"ABERTO",10)      	     		+  " | " //Status
   		ENDIF

   		@nLin,03 PSAY cLin
		nLin++
   		(cAlias)->(dbSkip())
	EndDo

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
