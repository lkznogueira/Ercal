#INCLUDE "rwmake.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³EMPREST   º Autor ³CARLOS DANIEL º Data ³  29/05/15         º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ RELATORIO DE ENTREGA FUTURA .                              º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³  ERCAL	                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function RICMST()


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
 
Local cDesc1       := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2       := "de acordo com os parametros informados pelo usuario."
Local cDesc3       := ""
Local cPict        := ""
Local titulo       := "Relatorio de Notas Icms ST"
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
Private nomeprog   := "RICMST" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo      := 18
Private aReturn    := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey   := 0
Private cPerg      := "erc002st"
Private cbtxt      := Space(10)
Private cbcont     := 00
Private CONTFL     := 01                                                                  
Private m_pag      := 01
Private wnrel      := "erc002st" // Coloque aqui o nome do arquivo usado para impressao em disco      
Private cString := "SD2"

dbSelectArea("SD2")
dbSetOrder(1)
/*
u_xPutSx1(cPerg , "01" , "Produto de        " , "" , "" , "mv_ch1" , "C" , 6 , 0 , 0 , "G" , "", "SB1", "", "", "mv_par01" , "        " ,"","","", "        " ,"","","", "        " , "" , "" , "" , "" , "" , "" , "" , "" )
u_xPutSx1(cPerg , "02" , "Produto ate		 " , "" , "" , "mv_ch2" , "C" , 6 , 0 , 0 , "G" , "", "SB1", "", "", "mv_par02" , "        " ,"","","", "   	  " ,"","","", "        " , "" , "" , "" , "" , "" , "" , "" , "" )
u_xPutSx1(cPerg , "03" , "Filial de         " , "" , "" , "mv_ch3" , "C" , 4  , 0 , 0 , "G" , "", "SM0", "", "", "mv_par03" , "        " ,"","","", "        " ,"","","", "        " , "" , "" , "" , "" , "" , "" , "" , "" )
u_xPutSx1(cPerg , "04" , "Filial ate        " , "" , "" , "mv_ch4" , "C" , 4  , 0 , 0 , "G" , "", "SM0", "", "", "mv_par04" , "        " ,"","","", "   	  " ,"","","", "        " , "" , "" , "" , "" , "" , "" , "" , "" )
u_xPutSx1(cPerg , "05" , "Cliente de        " , "" , "" , "mv_ch5" , "C" , 6  , 0 , 0 , "G" , "", "SA1", "", "", "mv_par05" , "        " ,"","","", "        " ,"","","", "        " , "" , "" , "" , "" , "" , "" , "" , "" )
u_xPutSx1(cPerg , "06" , "Cliente ate       " , "" , "" , "mv_ch6" , "C" , 6  , 0 , 0 , "G" , "", "SA1", "", "", "mv_par06" , "        " ,"","","", "   	  " ,"","","", "        " , "" , "" , "" , "" , "" , "" , "" , "" )
u_xPutSx1(cPerg , "07" , "CFOP de           " , "" , "" , "mv_ch7" , "C" , 4  , 0 , 0 , "G" , "", "", "", "", "mv_par07" , "        " ,"","","", "        " ,"","","", "        " , "" , "" , "" , "" , "" , "" , "" , "" )
u_xPutSx1(cPerg , "08" , "CFOP ate          " , "" , "" , "mv_ch8" , "C" , 4  , 0 , 0 , "G" , "", "", "", "", "mv_par08" , "        " ,"","","", "   	  " ,"","","", "        " , "" , "" , "" , "" , "" , "" , "" , "" )
u_xPutSx1(cPerg , "09" , "Emissão de.   	 " , "" , "" , "mv_ch9" , "D" , 4  , 0 , 0 , "G" , "", "", "", "", "mv_par09" , "        " ,"","","", "        " ,"","","", "        " , "" , "" , "" , "" , "" , "" , "" , "" )
u_xPutSx1(cPerg , "10" , "Emissão Ate.      " , "" , "" , "mv_ch10" , "D" , 4  , 0 , 0 , "G" , "", "", "", "", "mv_par10" , "        " ,"","","", "   	  " ,"","","", "        " , "" , "" , "" , "" , "" , "" , "" , "" )
u_xPutSx1(cPerg , "11" , "Tipo Rel.		 " , "" , "" , "mv_ch11" , "N" , 1  , 0 , 0 , "C" , "", "", "", "", "mv_par11" , "Analitico" ,"","","", "Sintético" ,"","","", "        " , "" , "" , "" , "" , "" , "" , "" , "" )
u_xPutSx1(cPerg , "12" , "Exporta Excel?      " , "" , "" , "mv_ch12" , "N" , 1  , 0 , 0 , "C" , "", "", "", "" ,"mv_par12","Sim","Sim","Sim","Nao","Nao","Nao","","","","","","","","","")
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
Local aReg:={}
Local ntotal := 0
Local ntotam := 0
Local ntotaa := 0
Local ntotalz := 0 
Local aQuant := 0
Local nOrdem
LOCAL vFrete
LOCAL dEmis 
LOCAL vBase 
LOCAL vIcm 	
LOCAL vIcmsT
LOCAL vTotal
LOCAL nValo             //colocada para calculo geral
LOCAL nValor       := 0 //para calculo geral
LOCAL nBaixa := 0
LOCAL nBaixas := 0
LOCAL cAquis := 0
LOCAL ntotals := 0 

Private cAlias := Criatrab(Nil,.F.)
Private cAlias1 := Criatrab(Nil,.F.)
Private cAlias2 := Criatrab(Nil,.F.)
Private cQry := Space(0) 
Private nRest 
Private cLin
Private	nValdev
Private	cQtddev  
Private nValres 
Private nValpag
Private vLrdesc
Private vLrfret 
Private aQuant2 := 0
IF mv_par11 == 1
	cQry += " SELECT D2_FILIAL, D2_QUANT, D2_DOC, D2_SERIE, D2_COD, D2_EMISSAO, D2_BASEICM, D2_VALICM,  D2_ICMSRET, D2_VALFRE, D2_CF, D2_TOTAL,
	cQry += " (SELECT B1_DESC FROM SB1010 SB1 WHERE SB1.D_E_L_E_T_ <> '*' AND SB1.B1_COD = D2_COD) AS DESCRICAO  
	cQry += " FROM "+RetSqlName("SD2") +" SD2
	cQry += " WHERE D_E_L_E_T_ <> '*'
	cQry += " AND D2_FILIAL BETWEEN '"+MV_PAR03+"' AND  '"+MV_PAR04+"'
	cQry += " AND D2_EMISSAO BETWEEN '"+dtos(MV_PAR09)+"' AND '"+dtos(MV_PAR10)+"' 
	cQry += " AND D2_COD BETWEEN '"+MV_PAR01+"' AND  '"+MV_PAR02+"'
	cQry += " AND D2_CLIENTE BETWEEN '"+MV_PAR05+"' AND  '"+MV_PAR06+"'
	cQry += " AND D2_CF BETWEEN '"+MV_PAR07+"' AND  '"+MV_PAR08+"'  
	cQry += " ORDER BY D2_EMISSAO 
ELSE
	cQry += " SELECT D2_CF, SUM(D2_QUANT) AS QUANT, SUM(D2_VALICM)AS ICM, SUM(D2_ICMSRET) AS RET, SUM(D2_VALFRE) AS FRETE, SUM(D2_TOTAL) AS TOTAL
	cQry += " FROM "+RetSqlName("SD2") +" SD2
	cQry += " WHERE D_E_L_E_T_ <> '*'
	cQry += " AND D2_FILIAL BETWEEN '"+MV_PAR03+"' AND  '"+MV_PAR04+"'
	cQry += " AND D2_EMISSAO BETWEEN '"+dtos(MV_PAR09)+"' AND '"+dtos(MV_PAR10)+"' 
	cQry += " AND D2_COD BETWEEN '"+MV_PAR01+"' AND  '"+MV_PAR02+"'
	cQry += " AND D2_CLIENTE BETWEEN '"+MV_PAR05+"' AND  '"+MV_PAR06+"'
	cQry += " AND D2_CF BETWEEN '"+MV_PAR07+"' AND  '"+MV_PAR08+"'   
	cQry += " GROUP BY D2_CF
	cQry += " ORDER BY D2_CF 	
ENDIF
DbUseArea(.T., "TOPCONN", TcGenQry(,, cQry), cAlias, .T., .T.)                      
DbGotop() 

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ SETREGUA -> Indica quantos registros serao processados para a regua ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
IF mv_par11 == 1

	SetRegua(RecCount())

	Cabec1 += Space(3)
	Cabec1 += Padc("FILIAL" ,len((cAlias)->D2_FILIAL))			   		+ " | "
	Cabec1 += Padc("NOTA" ,len((cAlias)->D2_DOC))			   			+ " | "
	Cabec1 += Padc("SERIE",len((cAlias)->D2_SERIE))  			   	   	+ " | "
	Cabec1 += Padc("PRODUTO",7)	 					  	   	  			+ " | "
	Cabec1 += Padc("DESCRIÇÃO" ,28)			   	  	   					+ " | "
	Cabec1 += Padc("EMISSÃO",len(dtoc(stod((cAlias)->D2_EMISSAO))))		+ " | " 
	Cabec1 += Padc("QUANTIDADE" ,10)			   	  	   				+ " | "
	Cabec1 += Padc("BASE ICMS" ,16)			   	  	   					+ " | "
	Cabec1 += Padc("VALOR ICMS" ,16)	  			   	  	   			+ " | "
	Cabec1 += Padc("VALOR ICMS ST" ,16)			   	  	   			    + " | "
	Cabec1 += Padc("FRETE" ,16)	 				   	  	   				+ " | "  
	Cabec1 += Padc("CFOP",len((cAlias)->D2_CF))	   	   	 	 			+ " | "
	nPosQtd := Len(Cabec1)
	Cabec1 += Padc("TOTAL ITEM" ,16)			   	  	   				+ " | "
	Cabec2 := Space(0)
if mv_par12==1
	Aadd(aReg,{Padc("FILIAL" ,len((cAlias)->D2_FILIAL)),Padc("NOTA" ,len((cAlias)->D2_DOC)),Padc("SERIE",len((cAlias)->D2_SERIE)),Padc("PRODUTO",7),Padc("DESCRIÇÃO" ,28),Padc("EMISSÃO",len(dtoc(stod((cAlias)->D2_EMISSAO)))),Padc("QUANTIDADE" ,10),Padc("BASE ICMS" ,16),Padc("VALOR ICMS" ,16),Padc("VALOR ICMS ST" ,16),Padc("FRETE" ,16),Padc("CFOP",len((cAlias)->D2_CF)),Padc("TOTAL ITEM" ,16)})
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
	
	If nLin > 60 // Salto de Página. Neste caso o formulario tem 55 linhas...
		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)                                                                      
		nLin := 8
	Endif  
	vFrete 	:= (cAlias)->D2_VALFRE
	dEmis 	:= dtoc(stod((cAlias)->D2_EMISSAO))
	vBase 	:= (cAlias)->D2_BASEICM
	vIcm 	:= (cAlias)->D2_VALICM 
	vIcmsT 	:= (cAlias)->D2_ICMSRET  
	vTotal 	:= (cAlias)->D2_TOTAL 
	aQuant  := (cAlias)->D2_QUANT 
	
	cLin := transform((cAlias)->D2_FILIAL, PesqPict("SD2","D2_FILIAL"))    		+  " | "
	cLin += transform((cAlias)->D2_DOC, PesqPict("SD2","D2_DOC"))     	  		+  " | "
	cLin += transform((cAlias)->D2_SERIE, PesqPict("SD2","D2_SERIE"))       	+  " | "
	cLin += Padl((cAlias)->D2_COD ,7)  			                                +  " | " 
	cLin += Padl((cAlias)->DESCRICAO ,28)		                                +  " | " 
	cLin += dtoc(stod((cAlias)->D2_EMISSAO))	                                +  " | " //DATA 
	cLin += Padl(aQuant ,10)   					                                +  " | " 
	cLin += Padl("R$"+transform(vBase,"@E 99,999,999.99"),16) 					+  " | "  
	cLin += Padl("R$"+transform(vIcm,"@E 99,999,999.99"),16) 					+  " | " 
	cLin += Padl("R$"+transform(vIcmsT,"@E 99,999,999.99"),16) 					+  " | "
	cLin += Padl("R$"+transform(vFrete,"@E 99,999,999.99"),16) 					+  " | " 
	cLin += transform((cAlias)->D2_CF, PesqPict("SD2","D2_CF")) 	   	 		+  " | " 
	cLin += Padl("R$"+transform(vTotal,"@E 99,999,999.99"),16) 					+  " | " 
	@nLin,03 PSAY cLin
	nLin++ 
	//inicio do exportavel indique aqui todos os campos
	if mv_par12==1
	  Aadd(aReg,{transform((cAlias)->D2_FILIAL, PesqPict("SD2","D2_FILIAL")) ,transform((cAlias)->D2_DOC, PesqPict("SD2","D2_DOC")),transform((cAlias)->D2_SERIE, PesqPict("SD2","D2_SERIE")),Padl((cAlias)->D2_COD ,7) ,Padl((cAlias)->DESCRICAO ,28),dtoc(stod((cAlias)->D2_EMISSAO)),Padl(aQuant ,10) ,Padl("R$"+transform(vBase,"@E 99,999,999.99"),16),Padl("R$"+transform(vIcm,"@E 99,999,999.99"),16),Padl("R$"+transform(vIcmsT,"@E 99,999,999.99"),16),Padl("R$"+transform(vFrete,"@E 99,999,999.99"),16),transform((cAlias)->D2_CF, PesqPict("SD2","D2_CF")),Padl("R$"+transform(vTotal,"@E 99,999,999.99"),16) })
	endif

	aQuant2 += aQuant
	ntotal += vIcm
	ntotam += vIcmsT
	ntotaa += vFrete
	ntotalz += vTotal
	(cAlias)->(dbSkip())
EndDo  

nLin++ 
cLin := SPACE(68)+"RESUMOS "+" | " 
cLin += Padl(aQuant2,10)  									 +  " | " +SPACE(16)+" | "
cLin += Padl("R$"+transform(ntotal,"@E 999,999,999.99"),16)  +  " | "                                         
cLin += Padl("R$"+transform(ntotam,"@E 999,999,999.99"),16)  +  " | " 
cLin += Padl("R$"+transform(ntotaa,"@E 999,999,999.99"),16)  +  " | "+SPACE(5)+" | "  
cLin += Padl("R$"+transform(ntotalz,"@E 999,999,999.99"),16) +  " | "  
@nLin,03 PSAY cLin

if mv_par12==1
	Aadd(aReg,{Padc("-" ,1) ,Padc("-" ,1) ,Padc("-" ,1) ,Padc("-" ,1) ,Padc("-" ,1) ,Padc("Resumos" ,7),Padl(aQuant2,10),Padc("-" ,16),Padl("R$"+transform(ntotal,"@E 999,999,999.99"),16), Padl("R$"+transform(ntotam,"@E 999,999,999.99"),16),Padl("R$"+transform(ntotaa,"@E 999,999,999.99"),16),Padc("-" ,1),Padl("R$"+transform(ntotalz,"@E 999,999,999.99"),16)})
endif

if mv_par12==1  
U_Arr3Exc5(aReg)
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
	
ELSE   
 
	SetRegua(RecCount())

	Cabec1 += Space(3)
	Cabec1 += Padc("CFOP" ,5)								   			+ " | "
	Cabec1 += Padc("VALOR ICMS" ,16)	  			   	  	   			+ " | "
	Cabec1 += Padc("VALOR ICMS ST" ,16)			   	  	   			    + " | "
	Cabec1 += Padc("FRETE" ,16)	 				   	  	   				+ " | "  
	nPosQtd := Len(Cabec1)
	Cabec1 += Padc("TOTAL ITEM" ,16)			   	  	   				+ " | " 
	Cabec1 += Padc("QUANTIDADE" ,10)									+ " | "
	Cabec2 := Space(0) 
	if mv_par12==1
		Aadd(aReg,{Padc("CFOP" ,5),Padc("VALOR ICMS" ,16),Padc("VALOR ICMS ST" ,16),Padc("FRETE" ,16),Padc("TOTAL ITEM" ,16),Padc("QUANTIDADE" ,10)})
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
	
	If nLin > 60 // Salto de Página. Neste caso o formulario tem 55 linhas...
		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)                                                                      
		nLin := 8
	Endif  
	vFrete 	:= (cAlias)->FRETE
	vIcm 	:= (cAlias)->ICM
	vIcmsT 	:= (cAlias)->RET  
	vTotal 	:= (cAlias)->TOTAL  
	aQuant  := (cAlias)->QUANT
	
	cLin := transform((cAlias)->D2_CF, PesqPict("SD2","D2_CF"))   		 		+  " | "
	cLin += Padl("R$"+transform(vIcm,"@E 99,999,999.99"),16) 					+  " | " 
	cLin += Padl("R$"+transform(vIcmsT,"@E 99,999,999.99"),16) 					+  " | "
	cLin += Padl("R$"+transform(vFrete,"@E 99,999,999.99"),16) 					+  " | " 
	cLin += Padl("R$"+transform(vTotal,"@E 99,999,999.99"),16) 					+  " | " 
	cLin += Padl(aQuant,10) 													+  " | " 
	
	@nLin,03 PSAY cLin
	nLin++
	if mv_par12==1
	  Aadd(aReg,{transform((cAlias)->D2_CF, PesqPict("SD2","D2_CF")),Padl("R$"+transform(vIcm,"@E 99,999,999.99"),16),Padl("R$"+transform(vIcmsT,"@E 99,999,999.99"),16),Padl("R$"+transform(vFrete,"@E 99,999,999.99"),16),Padl("R$"+transform(vTotal,"@E 99,999,999.99"),16),Padl(aQuant,10)})
	endif
	ntotal += vIcm
	ntotam += vIcmsT
	ntotaa += vFrete
	ntotalz += vTotal 
	aQuant2 += aQuant
	(cAlias)->(dbSkip())
EndDo  

nLin++ 
cLin := SPACE(5)+" | " 
cLin += Padl("R$"+transform(ntotal,"@E 999,999,999.99"),16)  +  " | "                                         
cLin += Padl("R$"+transform(ntotam,"@E 999,999,999.99"),16)  +  " | " 
cLin += Padl("R$"+transform(ntotaa,"@E 999,999,999.99"),16)  +  " | "  
cLin += Padl("R$"+transform(ntotalz,"@E 999,999,999.99"),16) +  " | "  
cLin += Padl(aQuant2,10) 									 +  " | "  
@nLin,03 PSAY cLin

if mv_par12==1
	Aadd(aReg,{Padc("-" ,1),Padl("R$"+transform(ntotal,"@E 999,999,999.99"),16), Padl("R$"+transform(ntotam,"@E 999,999,999.99"),16),Padl("R$"+transform(ntotaa,"@E 999,999,999.99"),16),Padl("R$"+transform(ntotalz,"@E 999,999,999.99"),16),Padl(aQuant2,10)})
endif

if mv_par12==1  
U_Arr3Exc5(aReg)
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
ENDIF
Return()
//funcao ecxel
User Function Arr3Exc5(aReg)
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
