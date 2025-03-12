#INCLUDE "rwmake.ch"
#INCLUDE "Protheus.ch"
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRELVEND    บ Autor ณ Carlos Daniel     บ Data ณ  29/05/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Rela็ใo dos bens ativo fixo.                               บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ 			                                          		  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User Function RELVEN()


//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Declaracao de Variaveis                                             ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
 
Local cDesc1       := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2       := "de acordo com os parametros informados pelo usuario."
Local cDesc3       := ""
Local cPict        := ""
Local titulo       := "RESUMO DE VENDAS POR VENDEDOR"
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
Private nomeprog   := "RELVEN" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo      := 18
Private aReturn    := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey   := 0
Private cPerg      := "RELVEN"
Private cbtxt      := Space(10)
Private cbcont     := 00
Private CONTFL     := 01
Private m_pag      := 01
Private wnrel      := "RELVEN" // Coloque aqui o nome do arquivo usado para impressao em disco      
Private cString := "SD2"

dbSelectArea("SD2")
dbSetOrder(1)

PutSX1(cPerg , "01" , "Vendedor de           " , "" , "" , "mv_ch1" , "C" , 6 , 0 , 0 , "G" , "", "SA3", "", "", "mv_par01" , "        " ,"","","", "        " ,"","","", "        " , "" , "" , "" , "" , "" , "" , "" , "" )
PutSX1(cPerg , "02" , "Vendedor ate          " , "" , "" , "mv_ch2" , "C" , 6 , 0 , 0 , "G" , "", "SA3", "", "", "mv_par02" , "        " ,"","","", "   	  " ,"","","", "        " , "" , "" , "" , "" , "" , "" , "" , "" )
PutSX1(cPerg , "03" , "Filial de             " , "" , "" , "mv_ch3" , "C" , 4  , 0 , 0 , "G" , "", "SM0", "", "", "mv_par03" , "        " ,"","","", "        " ,"","","", "        " , "" , "" , "" , "" , "" , "" , "" , "" )
PutSX1(cPerg , "04" , "Filial ate            " , "" , "" , "mv_ch4" , "C" , 4  , 0 , 0 , "G" , "", "SM0", "", "", "mv_par04" , "        " ,"","","", "   	  " ,"","","", "        " , "" , "" , "" , "" , "" , "" , "" , "" )
PutSX1(cPerg , "05" , "Produto de            " , "" , "" , "mv_ch5" , "C" , 6  , 0 , 0 , "G" , "", "MDTSB1", "", "", "mv_par05" , "        " ,"","","", "        " ,"","","", "        " , "" , "" , "" , "" , "" , "" , "" , "" )
PutSX1(cPerg , "06" , "Produto ate           " , "" , "" , "mv_ch6" , "C" , 6  , 0 , 0 , "G" , "", "MDTSB1", "", "", "mv_par06" , "        " ,"","","", "   	  " ,"","","", "        " , "" , "" , "" , "" , "" , "" , "" , "" )
PutSX1(cPerg , "07" , "Gera Financeiro		 " , "" , "" , "mv_ch7" , "C" , 14  , 0 , 1 , "C" , "", "", "", "", "mv_par07" , "GERA FINANCEIRO" ,"","","", "NรO GERA" ,"","","", "AMBOS" , "" , "" , "" , "" , "" , "" , "" , "" )
PutSX1(cPerg , "08" , "Gera Estoque			 " , "" , "" , "mv_ch8" , "C" , 14  , 0 , 1 , "C" , "", "", "", "", "mv_par08" , "GERA MOVIMENTO"  ,"","","", "NรO GERA" ,"","","", "AMBOS" , "" , "" , "" , "" , "" , "" , "" , "" )
PutSX1(cPerg , "09" , "Emissao de            " , "" , "" , "mv_ch9" , "D" , 4  , 0 , 0 , "G" , "", "", "", "", "mv_par09" , "        " ,"","","", "        " ,"","","", "        " , "" , "" , "" , "" , "" , "" , "" , "" )
PutSX1(cPerg , "10" , "Emissao ate           " , "" , "" , "mv_ch10" , "D" , 4  , 0 , 0 , "G" , "", "", "", "", "mv_par10" , "        " ,"","","", "   	  " ,"","","", "        " , "" , "" , "" , "" , "" , "" , "" , "" )

pergunte(cPerg,.T.)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Monta a interface padrao com o usuario...                           ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

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
Local ntotal := 0
Local ntotam := 0
Local ntotaa := 0 
Local ntotalz := 0
Local nOrdem
Local _cCalc := ""
Local _cAqui := ""
Local _cMes1 := ""
Local _cAcul := ""
Local cTxdep := "" 
LOCAL nValo             //colocada para calculo geral
LOCAL nValor       := 0 //para calculo geral  
LOCAL nBaixa := 0  
LOCAL nBaixas := 0  
LOCAL cAquis := 0 
LOCAL ntotals := 0
Private cAlias := Criatrab(Nil,.F.)
Private cQry := Space(0)

cQry += "SELECT 
cQry += "        CASE SUBSTR(SD2.D2_FILIAL, 1, 2)
cQry += "            WHEN '41' THEN 'ERCAL'
cQry += "            WHEN '42' THEN 'TRIANGULO'
cQry += "            ELSE ''
cQry += "         END EMPRESA,
cQry += "SD2.D2_DOC AS NOTA_FISCAL,
cQry += "SD2.D2_COD AS PRODUTO,
cQry += "(SELECT TRIM(B1_DESC) FROM SB1010 SB1 WHERE SD2.D2_COD = SB1.B1_COD AND SB1.D_E_L_E_T_ != '*') AS DESC_PROD,
cQry += "SD2.D2_QUANT AS QUANTIDADE,
cQry += "SD2.D2_UM AS UNIDADE,
cQry += "SD2.D2_TOTAL AS VLR_TOTAL,
cQry += "SD2.D2_TES AS TES,
cQry += "D2_CLIENTE AS CLIENTE,
cQry += "(SELECT TRIM(A1_NOME) FROM SA1010 SA1 WHERE A1_COD = D2_CLIENTE AND SA1.D_E_L_E_T_ != '*' AND A1_LOJA = D2_LOJA) AS NOME_CLI,
cQry += "(SELECT TRIM(A1_NREDUZ) FROM SA1010 SA1 WHERE A1_COD = D2_CLIENTE AND SA1.D_E_L_E_T_ != '*' AND A1_LOJA = D2_LOJA) AS FAZENDA,
cQry += "D2_LOJA,
cQry += "(SELECT TRIM(F2_VEND1) FROM "+RetSqlName("SF2") +" SF2 WHERE SD2.D2_DOC = SF2.F2_DOC AND SF2.D_E_L_E_T_ != '*' AND SD2.D2_SERIE = SF2.F2_SERIE) AS AGENTE,
cQry += "(SELECT TRIM(A3_NOME) FROM SA3010 SA3 WHERE A3_COD = (SELECT TRIM(F2_VEND1) FROM "+RetSqlName("SF2") +" SF2 WHERE SD2.D2_DOC = SF2.F2_DOC AND SF2.D_E_L_E_T_ != '*' AND SD2.D2_SERIE = SF2.F2_SERIE) AND SA3.D_E_L_E_T_ != '*') AS NOME,
cQry += "(SELECT TRIM(F4_DUPLIC) FROM SF4010 SF4 WHERE SD2.D2_TES = SF4.F4_CODIGO AND SF4.D_E_L_E_T_ != '*') AS GERA_FINAN,
cQry += "(SELECT TRIM(F4_ESTOQUE) FROM SF4010 SF4 WHERE SD2.D2_TES = SF4.F4_CODIGO AND SF4.D_E_L_E_T_ != '*') AS MOV_ESTOQUE
cQry += "FROM "+RetSqlName("SD2") +" SD2 
cQry += "WHERE SD2.D_E_L_E_T_ != '*'
cQry += "AND D2_EMISSAO BETWEEN '"+DToS(MV_PAR09)+"' AND '"+DToS(MV_PAR10)+"'
cQry += "AND (SELECT TRIM(F2_VEND1) FROM "+RetSqlName("SF2") +" SF2 WHERE SD2.D2_DOC = SF2.F2_DOC AND SF2.D_E_L_E_T_ != '*' AND SD2.D2_SERIE = SF2.F2_SERIE) BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+"'
IF MV_PAR07 == 'GERA FINANCEIRO'
	cQry += "AND (SELECT TRIM(F4_DUPLIC) FROM SF4010 SF4 WHERE SD2.D2_TES = SF4.F4_CODIGO AND SF4.D_E_L_E_T_ != '*') = 'S'
ELSEIF MV_PAR07 = 'NรO GERA'
	cQry += "AND (SELECT TRIM(F4_DUPLIC) FROM SF4010 SF4 WHERE SD2.D2_TES = SF4.F4_CODIGO AND SF4.D_E_L_E_T_ != '*') = 'N'
ELSEIF MV_PAR07 = 'AMBOS'
	cQry += "AND (SELECT TRIM(F4_DUPLIC) FROM SF4010 SF4 WHERE SD2.D2_TES = SF4.F4_CODIGO AND SF4.D_E_L_E_T_ != '*') IN ('S','N')
ENDIF
IF MV_PAR07 == 'GERA MOVIMENTO'
	cQry += "AND (SELECT TRIM(F4_ESTOQUE) FROM SF4010 SF4 WHERE SD2.D2_TES = SF4.F4_CODIGO AND SF4.D_E_L_E_T_ != '*') = 'S'
ELSEIF MV_PAR07 = 'NรO GERA'
	cQry += "AND (SELECT TRIM(F4_ESTOQUE) FROM SF4010 SF4 WHERE SD2.D2_TES = SF4.F4_CODIGO AND SF4.D_E_L_E_T_ != '*') = 'N'
ELSEIF MV_PAR07 = 'AMBOS'
	cQry += "AND (SELECT TRIM(F4_ESTOQUE) FROM SF4010 SF4 WHERE SD2.D2_TES = SF4.F4_CODIGO AND SF4.D_E_L_E_T_ != '*') IN ('S','N')
ENDIF
cQry += "AND D2_FILIAL BETWEEN '"+MV_PAR03+"' AND  '"+MV_PAR04+"'     
DbUseArea(.T., "TOPCONN", TcGenQry(,, cQry), cAlias, .T., .T.)
DbGotop()

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ SETREGUA -> Indica quantos registros serao processados para a regua ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

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
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Verifica o cancelamento pelo usuario...                             ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	
	If lAbortPrint
		@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
		Exit
	Endif
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Impressao do cabecalho do relatorio. . .                            ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	
	If nLin > 55 // Salto de Pแgina. Neste caso o formulario tem 55 linhas...
		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		nLin := 8
	Endif
	cId := (cAlias)->N1_CBASE+(cAlias)->N1_ITEM
	cBXATI := dtoc(stod((cAlias)->N1_BAIXA))
	cAqui := (cAlias)->N1_VLAQUIS
	cMes1 := (cAlias)->N3_VRDMES1
	cAcul := (cAlias)->N3_VRDACM1
	cCalc := ""
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
	
	cCalc := (cAqui - cAcul)  	
   	  	
   	cLin += Padl("R$"+transform(cCalc,"@E 99,999,999.99"),16) 					+  " | " //calculo do valor aquisicao - acumulado
   	cLin += dtoc(stod((cAlias)->N1_AQUISIC))	                                +  " | " //DATA COMPRA
	cLin += cBXATI	                               							    +  " | " //DATA BAIXA
	cLin +=  Padc(cValtoChar(cTxdep),8)		   		     			        	+  " | "//TX depreciacao //cValtoChar(cTxdep)
	@nLin,03 PSAY cLin
	nLin++
	ntotal += cCalc
	ntotam += cMes1 
	ntotaa += cAcul  
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