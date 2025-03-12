#INCLUDE "rwmake.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณaPurIcm    บ Autor ณ	   Carlos Daniel บ Data ณ  07/12/17   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Apuracao ICMS cst.                                         บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Ercal			                                          บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User Function cstIcm()
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Declaracao de Variaveis                                             ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

Local cDesc1       := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2       := "de acordo com os parametros informados pelo usuario."
Local cDesc3       := ""
Local cPict        := ""
Local titulo       := " ERCAL RELATORIO DE ESTORNO ICMS CST/40"
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
Private nomeprog   := "cstIcm" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo      := 18
Private aReturn    := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey   := 0
Private cPerg      := "cstIcm"
Private cbtxt      := Space(10)
Private cbcont     := 00
Private CONTFL     := 01
Private m_pag      := 01
Private wnrel      := "cstIcm" // Coloque aqui o nome do arquivo usado para impressao em disco

Private cString := "SF3"

dbSelectArea("SF3")
dbSetOrder(1)

PutSX1(cPerg , "01" , "FILIAL DE                 " , "" , "" , "mv_ch1" , "C" , 4 , 0 , 0 , "G" , "", "SM0", "", "", "mv_par01" , "        " ,"","","", "        " ,"","","", "        " , "" , "" , "" , "" , "" , "" , "" , "" )
PutSX1(cPerg , "02" , "FILIAL ATE                " , "" , "" , "mv_ch2" , "C" , 4 , 0 , 0 , "G" , "", "SM0", "", "", "mv_par02" , "        " ,"","","", "   	  " ,"","","", "        " , "" , "" , "" , "" , "" , "" , "" , "" )
PutSX1(cPerg , "03" , "DATA DE                   " , "" , "" , "mv_ch3" , "D" , 4  , 0 , 0 , "G" , "", "", "", "", "mv_par03" , "        " ,"","","", "        " ,"","","", "        " , "" , "" , "" , "" , "" , "" , "" , "" )
PutSX1(cPerg , "04" , "DATA ATE    	             " , "" , "" , "mv_ch4" , "D" , 4  , 0 , 0 , "G" , "", "", "", "", "mv_par04" , "        " ,"","","", "   	  " ,"","","", "        " , "" , "" , "" , "" , "" , "" , "" , "" )

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

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Processamento. RPTSTATUS monta janela com a regua de processamento. ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)
Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuno    ณRUNREPORT บ Autor ณ AP6 IDE            บ Data ณ  29/05/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescrio ณ Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS บฑฑ
ฑฑบ          ณ monta a janela com a regua de processamento.               บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Programa principal                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)  

Local nQuant := 0
Local nPrcv := 0
Local ntotaa := 0 
Local ntotalz := 0
Local icmsra := 0
Local icmsrt := 0
Local nOrdem
Local nSaid := ""
Local nbase := ""
Local nPorc := "" 
Local nGera := ""
Local cTxdep := "" 
local nValo             //colocada para calculo geral
local nValor       := 0 //para calculo geral 

Private cAlias := Criatrab(Nil,.F.)
Private cQry := Space(0)

cQry := " SELECT F3_FILIAL, 
cQry += " (SELECT SUM(F3_VALCONT) FROM "+RetSqlName("SF3") +" 
cQry += "     WHERE F3_CFO > '4999' 
cQry += "     AND F3_EMISSAO BETWEEN '"+dtos(MV_PAR03)+"' AND '"+dtos(MV_PAR04)+"' 
cQry += "     AND F3_FILIAL BETWEEN '"+MV_PAR01+"' AND  '"+MV_PAR02+"' 
cQry += "     AND D_E_L_E_T_ !='*' 
cQry += "     AND (F3_OBSERV = ' ' OR F3_OBSERV LIKE '%DEVOL%' OR F3_OBSERV LIKE '%COMPL%') 
cQry += "     GROUP BY F3_FILIAL) VLR_CONTABIL_A,
cQry += " (SELECT SUM(F3_VALCONT) FROM "+RetSqlName("SF3") +" 
cQry += "     WHERE F3_CFO IN (5908,6908,5411,6411,5922,6922,5551,6551,5949,6949,'5201','6201','5915','6915') 
cQry += "     AND F3_EMISSAO BETWEEN '"+dtos(MV_PAR03)+"' AND '"+dtos(MV_PAR04)+"' 
cQry += "     AND F3_CFO > '4999' 
cQry += "     AND F3_FILIAL BETWEEN '"+MV_PAR01+"' AND  '"+MV_PAR02+"' 
cQry += "     AND D_E_L_E_T_ !='*'
cQry += "     AND (F3_OBSERV = ' ' OR F3_OBSERV LIKE '%DEVOL%' OR F3_OBSERV LIKE '%COMPL%') 
cQry += "     GROUP BY F3_FILIAL) EXCLUSAO_CFO_B,
cQry += " (SELECT SUM(F3_ISENICM) FROM "+RetSqlName("SF3") +" 
cQry += "     WHERE F3_CFO > '4999' 
cQry += "     AND F3_FILIAL BETWEEN '"+MV_PAR01+"' AND  '"+MV_PAR02+"' 
cQry += "     AND (F3_OBSERV = ' ' OR F3_OBSERV LIKE '%DEVOL%' OR F3_OBSERV LIKE '%COMPL%')
cQry += "     AND D_E_L_E_T_ !='*'
cQry += "     AND F3_EMISSAO BETWEEN '"+dtos(MV_PAR03)+"' AND '"+dtos(MV_PAR04)+"'
cQry += "     GROUP BY F3_FILIAL) Isentas_D,
cQry += " (SELECT SUM(SD2.D2_VALBRUT) FROM "+RetSqlName("SD2") +" SD2
cQry += "     WHERE SD2.D_E_L_E_T_ <> '*' 
cQry += "     AND TRIM((SELECT F4_SITTRIB FROM SF4010 SF4 WHERE F4_CODIGO = SD2.D2_TES AND SF4.D_E_L_E_T_ <> '*')) = '40' 
//cQry += "     AND SD2.D2_ITEM = '01'  
cQry += "     AND SD2.D2_FILIAL BETWEEN '"+MV_PAR01+"' AND  '"+MV_PAR02+"' 
cQry += "     AND SD2.D2_EMISSAO BETWEEN '"+dtos(MV_PAR03)+"' AND '"+dtos(MV_PAR04)+"' 
cQry += "     group by D2_FILIAL) AS CST040
cQry += " FROM "+RetSqlName("SF3") +" SF3
cQry += " WHERE D_E_L_E_T_ !='*'
cQry += " AND F3_FILIAL BETWEEN '"+MV_PAR01+"' AND  '"+MV_PAR02+"'
cQry += " GROUP BY F3_FILIAL
DbUseArea(.T., "TOPCONN", TcGenQry(,, cQry), cAlias, .T., .T.)
DbGotop() 
	
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ SETREGUA -> Indica quantos registros serao processados para a regua ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

SetRegua(RecCount())

Cabec1 += Space(3)
Cabec1 += Padc("FILIAL" ,8)						 			   			+ " | "  
Cabec1 += Padc("VLR CTB SAIDA -" ,16) 	 								+ " | " //VALOR CONTABIL
Cabec1 += Padc("Exclusoes CFOP =",16)								   	+ " | "
Cabec1 += Padc("Total Saidas -",16)    					   	   	   		+ " | "
Cabec1 += Padc("Isentas CST/040 =" ,16)						       		+ " | "   
Cabec1 += Padc("Aproveitamento." ,16)						       		+ " | "
Cabec1 += Padc("Aprov Credito%" ,16)					     	   		+ " | "
Cabec1 += Padc("Percentual%" ,16)						  		   		+ " | "   
Cabec1 += Padc("Resumo N/Trib -",16)								   	+ " | " 
Cabec1 += Padc("Resumo CST/040",16)								  	 	+ " | "
  
nPosQtd := Len(Cabec1)
Cabec2 := Space(0)

dbGoTop()
While !EOF()

	If lAbortPrint
		@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
		Exit
	Endif
	
	If nLin > 55 // Salto de Pแgina. Neste caso o formulario tem 55 linhas...
		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		nLin := 8
	Endif 
	
	nSaid := (((cAlias)->VLR_CONTABIL_A - (cAlias)->EXCLUSAO_CFO_B)) 
	nIsen := (cAlias)->CST040   //((cAlias)->Isentas_D-(cAlias)->CST040)
	nbase := (nSaid - nIsen)
	nPorc := ((nbase / nSaid) * 100)  
	nGera := (100 - nPorc)
	
	cLin := Padl(transform((cAlias)->F3_FILIAL, PesqPict("SF3","F3_FILIAL")),8)		+  " | "
	cLin += Padl("R$"+transform((cAlias)->VLR_CONTABIL_A,"@E 99,999,999.99"),16) 	+  " | "
	cLin += Padl("R$"+transform((cAlias)->EXCLUSAO_CFO_B,"@E 99,999,999.99"),16) 	+  " | "
	cLin += Padl("R$"+transform(nSaid,"@E 99,999,999.99"),16)  	  					+  " | " 
	cLin += Padl("R$"+transform(nIsen,"@E 99,999,999.99"),16)  						+  " | " 
	cLin += Padl("R$"+transform(nbase,"@E 99,999,999.99"),16)  	   					+  " | "
	cLin += Padl("R$"+transform(nPorc,"@E 99,999,999.99"),16)  	 				 	+  " | "
	cLin += Padl("R$"+transform(nGera,"@E 99,999,999.99"),16)  	  					+  " | "
	cLin += Padl("R$"+transform((cAlias)->Isentas_D,"@E 99,999,999.99"),16)  		+  " | " 
	cLin += Padl("R$"+transform((cAlias)->CST040,"@E 99,999,999.99"),16)   			+  " | "		
	@nLin,03 PSAY cLin
	nLin++
	nQuant += 0
	nPrcv  += 0 
	ntotaa += 0 

	(cAlias)->(dbSkip())
EndDo

	nLin++
   	//@nLin,89 PSAY Padl(transform(nQuant,"@E 99,999,999.99"),16) 		   	+  " | "
	//@nLin,108 PSAY Padl("R$"+transform(nPrcv,"@E 99,999,999.99"),16)  	  	+  " | "     
	//@nLin,127 PSAY Padl("R$"+transform(ntotaa,"@E 99,999,999.99"),16)    	+  " | " 


//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Finaliza a execucao do relatorio...                                 ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

SET DEVICE TO SCREEN

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Se impressao em disco, chama o gerenciador de impressao...          ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

If aReturn[5]==1
	dbCommitAll()
	SET PRINTER TO
	OurSpool(wnrel)
Endif

MS_FLUSH()

Return()  