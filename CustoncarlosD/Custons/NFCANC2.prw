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

User Function NFCANC2()
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local cDesc1       := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2       := "de acordo com os parametros informados pelo usuario."
Local cDesc3       := ""
Local cPict        := ""
Local titulo       := "Relação NF-e Fiscal"
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
Private nomeprog   := "NFCAN" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo      := 18
Private aReturn    := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey   := 0
Private cPerg      := "NFC6"
Private cbtxt      := Space(10)
Private cbcont     := 00
Private CONTFL     := 01
Private m_pag      := 01
Private wnrel      := "NFCA" // Coloque aqui o nome do arquivo usado para impressao em disco
Private cString := "SF3"

dbSelectArea("SF3")
dbSetOrder(1)

PutSX1(cPerg , "01" , "Nota Fiscal de            " , "" , "" , "mv_ch1" , "C" , 9 , 0 , 0 , "G" , "", "", "", "", "mv_par01" , "        " ,"","","", "        " ,"","","", "        " , "" , "" , "" , "" , "" , "" , "" , "" )
PutSX1(cPerg , "02" , "Nota Fiscal ate           " , "" , "" , "mv_ch2" , "C" , 9 , 0 , 0 , "G" , "", "", "", "", "mv_par02" , "        " ,"","","", "   	  " ,"","","", "        " , "" , "" , "" , "" , "" , "" , "" , "" )
PutSX1(cPerg , "03" , "Filial de                 " , "" , "" , "mv_ch3" , "C" , 4  , 0 , 0 , "G" , "", "SM0", "", "", "mv_par03" , "        " ,"","","", "        " ,"","","", "        " , "" , "" , "" , "" , "" , "" , "" , "" )
PutSX1(cPerg , "04" , "Filial ate                " , "" , "" , "mv_ch4" , "C" , 4  , 0 , 0 , "G" , "", "SM0", "", "", "mv_par04" , "        " ,"","","", "   	  " ,"","","", "        " , "" , "" , "" , "" , "" , "" , "" , "" )
PutSX1(cPerg , "05" , "Estado de                 " , "" , "" , "mv_ch5" , "C" , 2  , 0 , 0 , "G" , "", "", "", "", "mv_par05" , "        " ,"","","", "        " ,"","","", "        " , "" , "" , "" , "" , "" , "" , "" , "" )
PutSX1(cPerg , "06" , "Estado ate                " , "" , "" , "mv_ch6" , "C" , 2  , 0 , 0 , "G" , "", "", "", "", "mv_par06" , "        " ,"","","", "   	  " ,"","","", "        " , "" , "" , "" , "" , "" , "" , "" , "" )
PutSX1(cPerg , "07" , "1=NF-e/2=Produtos		 " , "" , "" , "mv_ch7" , "C" , 1  , 0 , 0 , "G" , "", "", "", "", "mv_par07" , "        " ,"","","", "   	  " ,"","","", "        " , "" , "" , "" , "" , "" , "" , "" , "" )
PutSX1(cPerg , "08" , "Emissão de                " , "" , "" , "mv_ch8" , "D" , 4  , 0 , 0 , "G" , "", "", "", "", "mv_par08" , "        " ,"","","", "        " ,"","","", "        " , "" , "" , "" , "" , "" , "" , "" , "" )
PutSX1(cPerg , "09" , "Emissão ate 	             " , "" , "" , "mv_ch09" , "D" , 4  , 0 , 0 , "G" , "", "", "", "", "mv_par09" , "        " ,"","","", "   	  " ,"","","", "        " , "" , "" , "" , "" , "" , "" , "" , "" )

pergunte(cPerg,.T.)

If nLastKey == 27
	Return
Endif

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
Local icmsra := 0
Local icmsrt := 0
Local nOrdem
Local _cCalc := ""
Local _cAqui := ""
Local _cMes1 := ""
Local _cAcul := ""
Local cTxdep := "" 
local nValo             //colocada para calculo geral
local nValor       := 0 //para calculo geral 

Private cAlias := Criatrab(Nil,.F.)
Private cQry := Space(0)

IF mv_par07 == "1"
	cQry += " SELECT *
	cQry += " FROM "+RetSqlName("SF3") +" SF3
	cQry += " WHERE SF3.F3_FILIAL BETWEEN '"+MV_PAR03+"' AND  '"+MV_PAR04+"'
	cQry += " AND SF3.F3_NFISCAL BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+"'
	cQry += " AND SF3.F3_SERIE BETWEEN '"+MV_PAR05+"' AND '"+MV_PAR06+"'
	cQry += " AND SF3.F3_ESTADO BETWEEN '"+MV_PAR05+"' AND '"+MV_PAR06+"' 
	cQry += " AND SF3.F3_CFO > '4999'
	cQry += " AND SF3.F3_OBSERV NOT LIKE '%CANCELADA%'
	cQry += " AND SF3.F3_EMISSAO BETWEEN '"+DToS(MV_PAR08)+"' AND '"+DToS(MV_PAR09)+"' 
	cQry += " AND SF3.D_E_L_E_T_<> '*'
	cQry += " ORDER BY SF3.F3_SERIE, SF3.F3_NFISCAL   
	DbUseArea(.T., "TOPCONN", TcGenQry(,, cQry), cAlias, .T., .T.)
	DbGotop() 

ELSE 

	cQry += " SELECT * SD2.D2_FILIAL, SD2.D2_COD, SB1.B1_DESC, SD2.D2_TOTAL, SD2.D2_TES, SD2.D2_CF, SD2.D2_DOC, SD2.D_E_L_E_T_
	cQry += " FROM "+RetSqlName("SD2") +" SD2  
	CqRY += " INNER JOIN "+RetSqlName("SB1") +" SB1 on SB1.B1_COD = SD2.D2_COD and SD2.D_E_L_E_T_ <>'*' 
	cQry += " WHERE SD2.D2_FILIAL BETWEEN '"+MV_PAR03+"' AND  '"+MV_PAR04+"'
	cQry += " AND SF3.F3_NFISCAL BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+"'
	cQry += " AND SF3.F3_SERIE BETWEEN '"+MV_PAR05+"' AND '"+MV_PAR06+"'
	cQry += " AND SF3.F3_ESTADO BETWEEN '"+MV_PAR05+"' AND '"+MV_PAR06+"' 
	cQry += " AND SF3.F3_CFO > '4999'
	cQry += " AND SF3.F3_EMISSAO BETWEEN '"+DToS(MV_PAR08)+"' AND '"+DToS(MV_PAR09)+"' 
	cQry += " AND SF3.D_E_L_E_T_<> '*'
	cQry += " ORDER BY SF3.F3_SERIE, SF3.F3_NFISCAL   
	DbUseArea(.T., "TOPCONN", TcGenQry(,, cQry), cAlias, .T., .T.)
	DbGotop() 
ENDIF
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ SETREGUA -> Indica quantos registros serao processados para a regua ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
IF mv_par07 == "1"  //IGUAL ANALITICO

SetRegua(RecCount())

Cabec1 += Space(3)
Cabec1 += Padc("NF FISCAL" ,len((cAlias)->F3_NFISCAL))		   		+ "/"  
Cabec1 += Padc("SERIE" ,len((cAlias)->F3_SERIE))			   		+ " --> " 
Cabec1 += Padc("VLR CONTABIL",16)						   	   		+ " | "//VALOR CONTABIL
Cabec1 += Padc("BASE CALC.",16)							   	   		+ " | "//BASE C ICMS 
Cabec1 += Padc("VLR. ICMS" ,16)							       		+ " | "//VLR ICMS 
Cabec1 += Padc("BASE ICMS RET" ,16)						     		+ " | "//BASE CALC ICMS RET 
Cabec1 += Padc("ICMS RET APURACAO" ,16)						  		+ " | "//ICMS RETIDO  
Cabec1 += Padc("ICMS RET ANTECIPADO" ,16)   				   		+ " | "//ICMS RETIDO 
nPosQtd := Len(Cabec1)
Cabec1 += Padc("STATUS" ,14)						               	+ " | "//STATUS 
Cabec1 += Padc("CFOP" ,4)						               		+ " | " //CFOP
Cabec1 += Padc("ESTADO" ,3)						                 	+ " | "//ESTADO 
Cabec1 += Padc("EMISSÃO",len(dtoc(stod((cAlias)->F3_EMISSAO))))     + " | "//DT EMISSAO
Cabec1 += Padc("FILIAL" ,6)						                 	+ " | "//FILIAL 
Cabec2 := Space(0)

dbGoTop()
While !EOF()

	If lAbortPrint
		@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
		Exit
	Endif
	
	If nLin > 55 // Salto de Página. Neste caso o formulario tem 55 linhas...
		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		nLin := 8
	Endif
	
	cLin := transform((cAlias)->F3_NFISCAL, PesqPict("SF3","F3_NFISCAL"))    		+  "/"
	cLin += transform((cAlias)->F3_SERIE, PesqPict("SF3","F3_SERIE"))     	    	+  " --> "
	cLin += Padl("R$"+transform((cAlias)->F3_VALCONT,"@E 99,999,999.99"),16)    	+  " | "
	cLin += Padl("R$"+transform((cAlias)->F3_BASEICM,"@E 99,999,999.99"),16)    	+  " | "
	cLin += Padl("R$"+transform((cAlias)->F3_VALICM,"@E 99,999,999.99"),16)    		+  " | "
	cLin += Padl("R$"+transform((cAlias)->F3_BASERET,"@E 99,999,999.99"),16)    	+  " | "
	IF (cAlias)->F3_ESTADO == 'MG'
		cLin += Padl("R$"+transform((cAlias)->F3_ICMSRET,"@E 99,999,999.99"),16)    +  " | "  
	ELSE
		cLin += Padl(" R$         0,00",16) 										+  " | "
	ENDIF
	IF (cAlias)->F3_ESTADO <> 'MG'
		cLin += Padl("R$"+transform((cAlias)->F3_ICMSRET,"@E 99,999,999.99"),16)    +  " | "  
	ELSE
		cLin += Padl(" R$         0,00",16) 										+  " | "
	ENDIF
	cLin += Padc(transform((cAlias)->F3_OBSERV, PesqPict("SF3","F3_OBSERV")),14)   	+  " | "
	cLin += transform((cAlias)->F3_CFO, PesqPict("SF3","F3_CFO"))		   	    	+  " | "
	cLin +=  Padc(transform((cAlias)->F3_ESTADO, PesqPict("SF3","F3_ESTADO")),3)   	+  " | "
   	cLin += dtoc(stod((cAlias)->F3_EMISSAO))	                                    +  " | " //DATA COMPRA 
	cLin +=  Padc(transform((cAlias)->F3_FILIAL, PesqPict("SF3","F3_FILIAL")),6)   	+  " | "
   //	cLin +=  Padc(cValtoChar(cTxdep),8)		   		     			            +  " | "//TX depreciacao //cValtoChar(cTxdep)
	@nLin,03 PSAY cLin
	nLin++
	ntotal += (cAlias)->F3_VALCONT
	ntotam += (cAlias)->F3_BASEICM 
	ntotaa += (cAlias)->F3_VALICM  
	ntotalz += (cAlias)->F3_BASERET
 	icmsra += IIF ((cAlias)->F3_ESTADO == "MG",  (cAlias)->F3_ICMSRET,0)   //ROCCO
	icmsrt += IIF ((cAlias)->F3_ESTADO <> "MG",  (cAlias)->F3_ICMSRET,0)   //ROCCO
	(cAlias)->(dbSkip())
EndDo

	nLin++
	@nLin,03 PSAY Padc("VALOR TOTAL --> ",17)
	@nLin,21 PSAY Padl("R$"+transform(ntotal,"@E 99,999,999.99"),16)    	+  " | " //VLr Contabil
	@nLin,41 PSAY Padl("R$"+transform(ntotam,"@E 99,999,999.99"),16)    	+  " | "//Base ICMS     
	@nLin,59 PSAY Padl("R$"+transform(ntotaa,"@E 99,999,999.99"),16)    	+  " | "//VLR ICMS
	@nLin,78 PSAY Padl("R$"+transform(ntotalz,"@E 99,999,999.99"),16)    	+  " | "//Base ICMS RET  
	@nLin,98 PSAY Padl("R$"+transform(icmsra,"@E 99,999,999.99"),16)    	+  " | "//ICMS ret Apuracao
	@nLin,116 PSAY Padl("R$"+transform(icmsrt,"@E 99,999,999.99"),16)    	+  " | "//Icms Ret Antecipado  


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

//RESUMO POR PRODUTO Carlos Daniel
ELSEIF mv_par07 == "2" 

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

	cAqui := (cAlias)->AQUISI
	cMes1 := (cAlias)->MENSAL
	cAcul := (cAlias)->ACUMU
	cCalc := (cAqui - cAcul)

	nValor += cMes1 
	cLin := Padc(transform((cAlias)->GRUPO, PesqPict("(cAlias)","GRUPO")),8)    +  " | " //GRUPO
	cLin += Padl((cAlias)->DESCRIC,40)  										+  " | " //DESCRICAO 
	cLin += Padl("R$"+transform(cAqui,"@E 99,999,999.99"),20) 					+  " | " //AQUISICAO/SALDO ANTERIOR
	cLin += Padl("R$"+transform(0.00,"@E 99,999,999.99"),16) 					+  " | " //BAIXAS/ALIEN
	cLin += Padl("R$"+transform(0.00,"@E 99,999,999.99"),17) 					+  " | " //TRANSFERENCIAS 
	cLin += Padl("R$"+transform(cMes1,"@E 99,999,999.99"),19) 					+  " | " //DEP MES
	cLin += Padl("R$"+transform(cAqui,"@E 99,999,999.99"),25) 					+  " | " //SALDO ATUAL
   	cLin += Padl("R$"+transform(cAcul,"@E 99,999,999.99"),18) 					+  " | " //DEP ACUMULADA 	
 	cLin += Padl("R$"+transform(cCalc,"@E 99,999,999.99"),21) 					+  " | " //SALDO RESIDUAL

	@nLin,03 PSAY cLin
	nLin++
	ntotal += cCalc
	ntotam += cMes1 
	ntotaa += cAcul  
	ntotalz += cAqui
	(cAlias)->(dbSkip())
EndDo

	nLin++
	@nLin,03 PSAY Padr("Total Saldo Anterior"+Space(3)+"="+transform(ntotalz,"@E 99,999,999.99"),16)   //aquisicao
	nLin++
	@nLin,03 PSAY Padr("Total Dep Mensal"+Space(3)+"="+transform(ntotam,"@E 99,999,999.99"),16)    //dep mes
	nLin++ 
	@nLin,03 PSAY Padr("Total Saldo Atual"+Space(3)+"="+transform(ntotalz,"@E 99,999,999.99"),200)    //saldo atual
   	nLin++ 
	@nLin,03 PSAY Padr("Total Dep Acumulada"+Space(3)+"="+transform(ntotaa,"@E 99,999,999.99"),200)    //dep acumulada 
   	nLin++ 
	@nLin,03 PSAY Padr("Total Saldo Residual"+Space(3)+"="+transform(ntotal,"@E 99,999,999.99"),200)    //Saldo Residual


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