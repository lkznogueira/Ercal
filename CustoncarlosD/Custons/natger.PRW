#INCLUDE "rwmake.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³natger   º Autor ³ Carlos Daniel º Data ³  07/05/19         º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Relatorio Natureza Gerencial.                              º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³  Ercal 			                                          º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function natger()


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
 
Local cDesc1       := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2       := "de acordo com os parametros informados pelo usuario."
Local cDesc3       := ""
Local cPict        := ""
Local titulo       := "Balancete Gerencial"
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
Private nomeprog   := "natger" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo      := 18
Private aReturn    := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey   := 0
Private cPerg      := "natger"
Private cbtxt      := Space(10)
Private cbcont     := 00
Private CONTFL     := 01                                                                  
Private m_pag      := 01
Private wnrel      := "natger" // Coloque aqui o nome do arquivo usado para impressao em disco      
Private cString := "Z11"

dbSelectArea("Z11")
dbSetOrder(1)
/*
U_xPutSX1(cPerg , "01" , "Filial de           " , "" , "" , "mv_ch1" , "C" , 4  , 0 , 0 , "G" , "", "SM0", "", "", "mv_par01" , "        " ,"","","", "        " ,"","","", "        " , "" , "" , "" , "" , "" , "" , "" , "" )
U_xPutSX1(cPerg , "02" , "Filial ate          " , "" , "" , "mv_ch2" , "C" , 4  , 0 , 0 , "G" , "", "SM0", "", "", "mv_par02" , "        " ,"","","", "   	  " ,"","","", "        " , "" , "" , "" , "" , "" , "" , "" , "" )
U_xPutSX1(cPerg , "03" , "Data Disp de        " , "" , "" , "mv_ch3" , "D" , 4  , 0 , 0 , "G" , "", "", "", "", "mv_par03" , "        " ,"","","", "        " ,"","","", "        " , "" , "" , "" , "" , "" , "" , "" , "" )
U_xPutSX1(cPerg , "04" , "Data Disp ate       " , "" , "" , "mv_ch4" , "D" , 4  , 0 , 0 , "G" , "", "", "", "", "mv_par04" , "        " ,"","","", "   	  " ,"","","", "        " , "" , "" , "" , "" , "" , "" , "" , "" )
u_xPutSx1(cPerg , "05" , "Exporta Excel?      " , "" , "" , "mv_ch5" , "N" , 1  , 0 , 0 , "C" , "", "", "", "" ,"mv_par05","Sim","Sim","Sim","Nao","Nao","Nao","","","","","","","","","")
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
Private cQry := Space(0) 
Private cQry1 := Space(0) 
Private cQry2 := Space(0) 
Private cQry3 := Space(0) 
Private cQry4 := Space(0) 
Private nRest 
Private cLin

cQry += "SELECT  
cQry += " Z11_CODIGO, 
cQry += " Z11_DESCRI, 
cQry += " CASE Z11_TIPO
cQry += " WHEN '1' THEN 'SINTETICA'
cQry += " WHEN '2' THEN 'ANALITICA'
cQry += " ELSE ' '
cQry += " END TIPO
cQry += " FROM "+RetSqlName("Z11") +" Z11
cQry += " WHERE Z11.D_E_L_E_T_ <> '*'
cQry += " ORDER BY Z11_CODIGO

DbUseArea(.T., "TOPCONN", TcGenQry(,, cQry), cAlias, .T., .T.)
DbGotop() 

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ SETREGUA -> Indica quantos registros serao processados para a regua ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	SetRegua(RecCount())  
	
	Cabec1 := Space(3)
	Cabec1 += Padc("CONTA" ,10)			 	  	   					+ " | "
	Cabec1 += Padc("TIPO",10)										+ " | "
	Cabec1 += Padc("DESCRICAO" ,30)		 	  	   		   	    	+ " | "
	Cabec1 += Padc("NO MÊS" ,21)	 			   	  	   			+ " | "
	Cabec1 += Padc("ATÉ O MÊS" ,21)       	   	  	   			 	+ " | "
	nPosQtd := Len(Cabec1)
	Cabec1 += Padc("ANO ANT NO MÊS" ,21)		   	  	   			+ " | " 
	Cabec1 += Padc("ANO ANT ATÉ O MÊS" ,21)		   	  	   			+ " | "   
	Cabec1 += Padc("MEDIA% NO MÊS" ,14)		   	  	   			  	+ " | "
	Cabec1 += Padc("MEDIA% ATE MÊS" ,14)		   	  	   			+ " | "
	Cabec2 := Space(0)

   	if mv_par05==1
	  Aadd(aReg,{Padc("CONTA" ,10),Padc("TIPO",10),Padc("DESCRICAO" ,30),Padc("NO MÊS" ,21),Padc("ATÉ O MÊS" ,21),Padc("ANO ANT NO MÊS" ,21),Padc("ANO ANT ATÉ O MÊS" ,21)	,Padc("MEDIA% NO MÊS" ,14),Padc("MEDIA% ATE MÊS" ,14)})
	endif


dbGoTop()
//While !EOF() 
While (cAlias)->(!EOF())  
 
	//VALOR NO MES
	cQry1 := " SELECT NVL(SUM(E5_VALOR),0) VLR_SE5 FROM "+RetSqlName("SE5") +" SE5 
	cQry1 += " WHERE SE5.D_E_L_E_T_ <> '*' AND E5_FILIAL BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+"' AND SE5.E5_RECPAG <> ' '
	cQry1 += " AND  (E5_NATUREZ between '          ' AND 'ZZZZZZZZZZ' OR  EXISTS (SELECT EV_FILIAL, EV_PREFIXO, EV_NUM, EV_PARCELA, EV_CLIFOR, EV_LOJA  FROM SEV010 SEV  WHERE E5_FILIAL  = EV_FILIAL  AND E5_PREFIXO = EV_PREFIXO AND E5_NUMERO  = EV_NUM     AND E5_PARCELA = EV_PARCELA AND E5_TIPO    = EV_TIPO    AND E5_CLIFOR  = EV_CLIFOR  AND E5_LOJA    = EV_LOJA    AND EV_NATUREZ between '          ' AND 'ZZZZZZZZZZ' AND SEV.D_E_L_E_T_ = ' '))  
	cQry1 += " AND     E5_TIPODOC NOT IN ('DC','D2','JR','J2','TL','MT','M2','CM','C2','TR','TE','ES','AP','EP','RF') 
	cQry1 += " AND  	  E5_SITUACA NOT IN ('C','E','X') 
	cQry1 += " AND     ((E5_TIPODOC = 'CD' AND E5_VENCTO <= E5_DATA) OR       (E5_TIPODOC <> 'CD')) 		  
	cQry1 += " AND E5_HISTOR NOT IN ('Baixa Automatica / Lote','Compens. Adiantamento','Baixa por Compensacao','Cancelamento da Baixa') 
	cQry1 += " AND E5_TIPODOC <> 'E2' 
	cQry1 += " AND E5_KEY = ' ' AND E5_MOTBX NOT IN ('LIQ','CEC') AND E5_DTCANBX = ' ' 
	cQry1 += " AND E5_FILORIG != ' '
	cQry1 += " AND E5_RECONC <> ' ' AND SE5.E5_DTDISPO <> ' '  
	cQry1 += " AND E5_VLMOED2 != 0	
	cQry1 += " AND TRIM('"+(cAlias)->Z11_CODIGO+"') = TRIM((SELECT SED.ED_XCOD2 FROM "+RetSqlName("SED") +" SED WHERE SED.D_E_L_E_T_ <> '*' AND ED_CODIGO = SE5.E5_NATUREZ AND SE5.E5_DTDISPO BETWEEN '"+DToS(MV_PAR03)+"' AND '"+DToS(MV_PAR04)+"'))
	
	DbUseArea(.T., "TOPCONN", TcGenQry(,, cQry1), cAlias1, .T., .T.)
	DbGotop() 
	//ATE O MES
	cQry2 := " SELECT NVL(SUM(E5_VALOR),0) VLR_SE5 FROM "+RetSqlName("SE5") +" SE5 
	cQry2 += " WHERE SE5.D_E_L_E_T_ <> '*' AND E5_FILIAL BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+"' AND SE5.E5_RECPAG <> ' ' 
	cQry2 += " AND  (E5_NATUREZ between '          ' AND 'ZZZZZZZZZZ' OR  EXISTS (SELECT EV_FILIAL, EV_PREFIXO, EV_NUM, EV_PARCELA, EV_CLIFOR, EV_LOJA  FROM SEV010 SEV  WHERE E5_FILIAL  = EV_FILIAL  AND E5_PREFIXO = EV_PREFIXO AND E5_NUMERO  = EV_NUM     AND E5_PARCELA = EV_PARCELA AND E5_TIPO    = EV_TIPO    AND E5_CLIFOR  = EV_CLIFOR  AND E5_LOJA    = EV_LOJA    AND EV_NATUREZ between '          ' AND 'ZZZZZZZZZZ' AND SEV.D_E_L_E_T_ = ' '))  
	cQry2 += " AND     E5_TIPODOC NOT IN ('DC','D2','JR','J2','TL','MT','M2','CM','C2','TR','TE','ES','AP','EP','RF') 
	cQry2 += " AND  	  E5_SITUACA NOT IN ('C','E','X') 
	cQry2 += " AND     ((E5_TIPODOC = 'CD' AND E5_VENCTO <= E5_DATA) OR       (E5_TIPODOC <> 'CD')) 		  
	cQry2 += " AND E5_HISTOR NOT IN ('Baixa Automatica / Lote','Compens. Adiantamento','Baixa por Compensacao','Cancelamento da Baixa') 
	cQry2 += " AND E5_TIPODOC <> 'E2' 
	cQry2 += " AND E5_KEY = ' ' AND E5_MOTBX NOT IN ('LIQ','CEC')  AND E5_DTCANBX = ' '  
	cQry2 += " AND E5_FILORIG != ' '
	cQry2 += " AND E5_RECONC <> ' ' AND SE5.E5_DTDISPO <> ' '
	cQry1 += " AND E5_VLMOED2 != 0	
	cQry2 += " AND TRIM('"+(cAlias)->Z11_CODIGO+"') = TRIM((SELECT SED.ED_XCOD2 FROM "+RetSqlName("SED") +" SED WHERE SED.D_E_L_E_T_ <> '*' AND ED_CODIGO = SE5.E5_NATUREZ AND SE5.E5_DTDISPO BETWEEN SUBSTR("+DToS(MV_PAR03)+",1,4)||'0101' AND '"+DToS(MV_PAR04)+"'))
	
	DbUseArea(.T., "TOPCONN", TcGenQry(,, cQry2), cAlias2, .T., .T.)
	DbGotop()
	//Ano Anterior NO MES
	cQry3 := " SELECT NVL(SUM(E5_VALOR),0) VLR_SE5 FROM "+RetSqlName("SE5") +" SE5 
	cQry3 += " WHERE SE5.D_E_L_E_T_ <> '*' AND E5_FILIAL BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+"' AND SE5.E5_RECPAG <> ' ' 
	cQry3 += " AND  (E5_NATUREZ between '          ' AND 'ZZZZZZZZZZ' OR  EXISTS (SELECT EV_FILIAL, EV_PREFIXO, EV_NUM, EV_PARCELA, EV_CLIFOR, EV_LOJA  FROM SEV010 SEV  WHERE E5_FILIAL  = EV_FILIAL  AND E5_PREFIXO = EV_PREFIXO AND E5_NUMERO  = EV_NUM     AND E5_PARCELA = EV_PARCELA AND E5_TIPO    = EV_TIPO    AND E5_CLIFOR  = EV_CLIFOR  AND E5_LOJA    = EV_LOJA    AND EV_NATUREZ between '          ' AND 'ZZZZZZZZZZ' AND SEV.D_E_L_E_T_ = ' '))  
	cQry3 += " AND     E5_TIPODOC NOT IN ('DC','D2','JR','J2','TL','MT','M2','CM','C2','TR','TE','ES','AP','EP','RF') 
	cQry3 += " AND  	  E5_SITUACA NOT IN ('C','E','X') 
	cQry3 += " AND     ((E5_TIPODOC = 'CD' AND E5_VENCTO <= E5_DATA) OR       (E5_TIPODOC <> 'CD')) 		  
	cQry3 += " AND E5_HISTOR NOT IN ('Baixa Automatica / Lote','Compens. Adiantamento','Baixa por Compensacao','Cancelamento da Baixa') 
	cQry3 += " AND E5_TIPODOC <> 'E2' 
	cQry3 += " AND E5_KEY = ' ' AND E5_MOTBX NOT IN ('LIQ','CEC')  AND E5_DTCANBX = ' '  
	cQry3 += " AND E5_FILORIG != ' '
	cQry3 += " AND E5_RECONC <> ' ' AND SE5.E5_DTDISPO <> ' '
	cQry1 += " AND E5_VLMOED2 != 0	
	cQry3 += " AND TRIM('"+(cAlias)->Z11_CODIGO+"') = TRIM((SELECT SED.ED_XCOD2 FROM "+RetSqlName("SED") +" SED WHERE SED.D_E_L_E_T_ <> '*' AND ED_CODIGO = SE5.E5_NATUREZ AND SE5.E5_DTDISPO BETWEEN SUBSTR("+DToS(MV_PAR03)+",1,4)-1||SUBSTR("+DToS(MV_PAR03)+",5,4) AND SUBSTR("+DToS(MV_PAR04)+",1,4)-1||SUBSTR("+DToS(MV_PAR04)+",5,4)))
	
	DbUseArea(.T., "TOPCONN", TcGenQry(,, cQry3), cAlias3, .T., .T.)
	DbGotop() 
	//Ano ANTERIOR ATE MES
	cQry4 := " SELECT NVL(SUM(E5_VALOR),0) VLR_SE5 FROM "+RetSqlName("SE5") +" SE5 
	cQry4 += " WHERE SE5.D_E_L_E_T_ <> '*' AND E5_FILIAL BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+"' AND SE5.E5_RECPAG <> ' ' 
	cQry4 += " AND  (E5_NATUREZ between '          ' AND 'ZZZZZZZZZZ' OR  EXISTS (SELECT EV_FILIAL, EV_PREFIXO, EV_NUM, EV_PARCELA, EV_CLIFOR, EV_LOJA  FROM SEV010 SEV  WHERE E5_FILIAL  = EV_FILIAL  AND E5_PREFIXO = EV_PREFIXO AND E5_NUMERO  = EV_NUM     AND E5_PARCELA = EV_PARCELA AND E5_TIPO    = EV_TIPO    AND E5_CLIFOR  = EV_CLIFOR  AND E5_LOJA    = EV_LOJA    AND EV_NATUREZ between '          ' AND 'ZZZZZZZZZZ' AND SEV.D_E_L_E_T_ = ' '))  
	cQry4 += " AND     E5_TIPODOC NOT IN ('DC','D2','JR','J2','TL','MT','M2','CM','C2','TR','TE','ES','AP','EP','RF') 
	cQry4 += " AND  	  E5_SITUACA NOT IN ('C','E','X') 
	cQry4 += " AND     ((E5_TIPODOC = 'CD' AND E5_VENCTO <= E5_DATA) OR       (E5_TIPODOC <> 'CD')) 		  
	cQry4 += " AND E5_HISTOR NOT IN ('Baixa Automatica / Lote','Compens. Adiantamento','Baixa por Compensacao','Cancelamento da Baixa') 
	cQry4 += " AND E5_TIPODOC <> 'E2' 
	cQry4 += " AND E5_KEY = ' ' AND E5_MOTBX NOT IN ('LIQ','CEC')  AND E5_DTCANBX = ' '  
	cQry4 += " AND E5_FILORIG != ' '
	cQry4 += " AND E5_RECONC <> ' ' AND SE5.E5_DTDISPO <> ' '   
	cQry1 += " AND E5_VLMOED2 != 0
	cQry4 += " AND TRIM('"+(cAlias)->Z11_CODIGO+"') = TRIM((SELECT SED.ED_XCOD2 FROM "+RetSqlName("SED") +" SED WHERE SED.D_E_L_E_T_ <> '*' AND ED_CODIGO = SE5.E5_NATUREZ AND SE5.E5_DTDISPO BETWEEN SUBSTR("+DToS(MV_PAR03)+",1,4)-1||'0101' AND SUBSTR("+DToS(MV_PAR04)+",1,4)-1||SUBSTR("+DToS(MV_PAR04)+",5,4)))
	
	DbUseArea(.T., "TOPCONN", TcGenQry(,, cQry4), cAlias4, .T., .T.)
	DbGotop()
	
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
	
	nVALOR 	:= round(((100*(cAlias1)->VLR_SE5)/(cAlias3)->VLR_SE5),2)   //calculo media
	nVALOR1 := round(((100*(cAlias2)->VLR_SE5)/(cAlias4)->VLR_SE5),2)   //calculo media
	//nVALOR := ROUND(nVALOR)
	nLin++   //pula pra linha debaixo 
   	cLin := Padl((cAlias)->Z11_CODIGO, 10)    	       							   	     	+  " | " //CONTA
   	cLin += Padc((cAlias)->TIPO, 10)     		   							      		  	+  " | " // ANALITICA OU SINTETICA
   	cLin += Padl((cAlias)->Z11_DESCRI, 30)      									        +  " | " // DESCRI CONTA    
   	cLin += Padl("R$"+transform((cAlias1)->VLR_SE5,"@E 999,999,999.99"),21) 				+  " | " //NO MES
   	cLin += Padl("R$"+transform((cAlias2)->VLR_SE5,"@E 999,999,999.99"),21) 				+  " | " //ATE O MES 	
   	//cLin += Padc(nVALOR, 5)      							  			    				+  " | " // MEDIA%
   	cLin += Padl("R$"+transform((cAlias3)->VLR_SE5,"@E 999,999,999.99"),21)			 		+  " | " //NO MES ANT
   	cLin += Padl("R$"+transform((cAlias4)->VLR_SE5,"@E 999,999,999.99"),21)			 		+  " | " //ATE MES ANT  
   	cLin += Padc(nVALOR, 14)      							  			    				+  " | " // MEDIA% no mes
   	cLin += Padc(nVALOR1, 14)      							  			    				+  " | " // MEDIA% ate mes
		                            
  	@nLin,03 PSAY cLin
   	nLin++  //pula pra linha debaixo
   	//ntotal += (cAlias)->ADB_TOTAL  
   	if mv_par05==1
	  Aadd(aReg,{Padl((cAlias)->Z11_CODIGO, 10),Padc((cAlias)->TIPO, 10),Padl((cAlias)->Z11_DESCRI, 30) ,Padl("R$"+transform((cAlias1)->VLR_SE5,"@E 999,999,999.99"),21),Padl("R$"+transform((cAlias2)->VLR_SE5,"@E 999,999,999.99"),21),Padl("R$"+transform((cAlias3)->VLR_SE5,"@E 999,999,999.99"),21),Padl("R$"+transform((cAlias4)->VLR_SE5,"@E 999,999,999.99"),21),Padc(nVALOR, 14),Padc(nVALOR1, 14)})
	endif

	(cAlias)->(dbSkip())
   	(cAlias1)->(dbCloseArea())
   	(cAlias2)->(dbCloseArea())
   	(cAlias3)->(dbCloseArea())
   	(cAlias4)->(dbCloseArea())
EndDo  

if mv_par05==1
  U_Arr2Excl(aReg)
endif

nLin++ 
//cLin := SPACE(45)+"RESUMOS "+" |"+Padl(qTdped,9)  +  " |"  //Qtd compra
//cLin += Padl("R$"+transform(nTValpag,"@E 999,999,999.99"),16)  +  " |"  //total pago
//cLin += Padl("R$"+transform(nTValres,"@E 999,999,999.99"),16)  +  " |"  //total rest
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



User Function Arr2Excl(aReg)
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
