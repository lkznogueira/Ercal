#INCLUDE "rwmake.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณtranSp    บ Autor ณ Carlos Daniel       บ Data ณ  29/05/14  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Relatorio de viagens       .                               บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Ercal/Britacal                                             บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User Function tranSp()   

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Declaracao de Variaveis                                             ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

Local cDesc1       := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2       := "de acordo com os parametros informados pelo usuario."
Local cDesc3       := ""
Local cPict        := ""
Local titulo       := "Rela็ใo Transportes"
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
Private nomeprog   := "tranSp" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo      := 18
Private aReturn    := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey   := 0
Private cPerg      := "tranSp"
Private cbtxt      := Space(10)
Private cbcont     := 00
Private CONTFL     := 01
Private m_pag      := 01
Private wnrel      := "tranSp" // Coloque aqui o nome do arquivo usado para impressao em disco
Private cString := "SD2"
 
dbSelectArea("SD2")
dbSetOrder(1)

PutSX1(cPerg , "01" , "FILIAL DE                 " , "" , "" , "mv_ch1" , "C" , 4 , 0 , 0 , "G" , "", "SM0", "", "", "mv_par01" , "        " ,"","","", "        " ,"","","", "        " , "" , "" , "" , "" , "" , "" , "" , "" )
PutSX1(cPerg , "02" , "FILIAL ATE                " , "" , "" , "mv_ch2" , "C" , 4 , 0 , 0 , "G" , "", "SM0", "", "", "mv_par02" , "        " ,"","","", "   	  " ,"","","", "        " , "" , "" , "" , "" , "" , "" , "" , "" )
PutSX1(cPerg , "03" , "PLACA DE                  " , "" , "" , "mv_ch3" , "C" , 7  , 0 , 0 , "G" , "", "DA302", "", "", "mv_par03" , "        " ,"","","", "        " ,"","","", "        " , "" , "" , "" , "" , "" , "" , "" , "" )
PutSX1(cPerg , "04" , "PLACA ATE                 " , "" , "" , "mv_ch4" , "C" , 7  , 0 , 0 , "G" , "", "DA302", "", "", "mv_par04" , "        " ,"","","", "   	  " ,"","","", "        " , "" , "" , "" , "" , "" , "" , "" , "" )
PutSX1(cPerg , "05" , "DATA DE                   " , "" , "" , "mv_ch5" , "D" , 4  , 0 , 0 , "G" , "", "", "", "", "mv_par05" , "        " ,"","","", "        " ,"","","", "        " , "" , "" , "" , "" , "" , "" , "" , "" )
PutSX1(cPerg , "06" , "DATA ATE    	             " , "" , "" , "mv_ch6" , "D" , 4  , 0 , 0 , "G" , "", "", "", "", "mv_par06" , "        " ,"","","", "   	  " ,"","","", "        " , "" , "" , "" , "" , "" , "" , "" , "" )
PutSX1(cPerg , "07" , "CLIENTE DE                " , "" , "" , "mv_ch7" , "C" , 6 , 0 , 0 , "G" , "", "SA1", "", "", "mv_par07" , "        " ,"","","", "        " ,"","","", "        " , "" , "" , "" , "" , "" , "" , "" , "" )
PutSX1(cPerg , "08" , "CLIENTE ATE               " , "" , "" , "mv_ch8" , "C" , 6 , 0 , 0 , "G" , "", "SA1", "", "", "mv_par08" , "        " ,"","","", "   	  " ,"","","", "        " , "" , "" , "" , "" , "" , "" , "" , "" )
PutSX1(cPerg , "09" , "CIF/FOB				     " , "" , "" , "mv_ch9" , "N" , 1 , 0 , 1 , "C" , "", "", "", "", "mv_par09" , "(1)CIF" ,"","","", "(2)FOB" ,"","","", "        " , "" , "" , "" , "" , "" , "" , "" , "" )

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
Local _cCalc := ""
Local _cAqui := ""
Local _cMes1 := ""
Local _cAcul := ""
Local cTxdep := "" 
local nValo             //colocada para calculo geral
local nValor       := 0 //para calculo geral 

Private cAlias := Criatrab(Nil,.F.)
Private cQry := Space(0)

cQry += " SELECT d2_filial, d2_doc, d2_serie, d2_pedido, d2_tes, d2_cod, (select b1_desc from sb1010 sb1 where sb1.d_e_l_e_t_ <> '*' and b1_cod = d2_cod) b1_desc, d2_emissao, d2_quant, 
cQry += " CASE WHEN (SELECT ADA_XORDEM FROM "+RetSqlName("ADA") +" ADA WHERE ada.d_e_l_e_t_ <> '*' AND ADA_FILIAL = D2_FILIAL AND ADA_NUMCTR = C6_CONTRAT) = '1'
cQry += "    THEN TRIM((SELECT ADA_XPED FROM "+RetSqlName("ADA") +" ADA WHERE ada.d_e_l_e_t_ <> '*' AND ADA_FILIAL = D2_FILIAL AND ADA_NUMCTR = C6_CONTRAT))
cQry += "    ELSE c6_contrat END AS CONTRATO,
cQry += " CASE WHEN (SELECT ADA_XORDEM FROM "+RetSqlName("ADA") +" ADA WHERE ada.d_e_l_e_t_ <> '*' AND ADA_FILIAL = D2_FILIAL AND ADA_NUMCTR = C6_CONTRAT) = '1'
cQry += "         THEN (SELECT SD.D2_PRCVEN FROM SD2020 SD WHERE SD.d_e_l_e_t_ <> '*' AND SD.D2_DOC = TRIM((SELECT ADA_XNFORI FROM "+RetSqlName("ADA") +" ADA WHERE ada.d_e_l_e_t_ <> '*' AND ADA_FILIAL = C6_FILIAL AND ADA_NUMCTR = C6_CONTRAT)) AND SD.D2_FILIAL = '4200')
cQry += "         ELSE d2_prcven END AS d2_prcven,
cQry += " (d2_quant*CASE WHEN (SELECT ADA_XORDEM FROM "+RetSqlName("ADA") +" ADA WHERE ada.d_e_l_e_t_ <> '*' AND ADA_FILIAL = D2_FILIAL AND ADA_NUMCTR = C6_CONTRAT) = '1'
cQry += "         THEN (SELECT SD.D2_PRCVEN FROM SD2020 SD WHERE SD.d_e_l_e_t_ <> '*' AND SD.D2_DOC = TRIM((SELECT ADA_XNFORI FROM "+RetSqlName("ADA") +" ADA WHERE ada.d_e_l_e_t_ <> '*' AND ADA_FILIAL = C6_FILIAL AND ADA_NUMCTR = C6_CONTRAT)) AND SD.D2_FILIAL = '4200')
cQry += "         ELSE d2_prcven END) AS d2_total,
cQry += " round((((SELECT ADA_Xdesp FROM "+RetSqlName("ADA") +" ADA WHERE ada.d_e_l_e_t_ <> '*' and rownum = 1 AND ADA_FILIAL = D2_FILIAL AND ADA_NUMCTR = (SELECT C5_CONTRA FROM "+RetSqlName("SC5") +" SC5 WHERE sc5.d_e_l_e_t_ <> '*' AND C5_FILIAL = D2_FILIAL AND C5_NUM = D2_PEDIDO AND C5_CLIENTE = D2_CLIENTE))/round(((SELECT ADB_QUANT FROM "+RetSqlName("ADB") +" ADB WHERE ADB.d_e_l_e_t_ <> '*' and rownum = 1 AND ADB_FILIAL = D2_FILIAL AND ADB_NUMCTR = (SELECT C5_CONTRA FROM "+RetSqlName("SC5") +" SC5 WHERE sc5.d_e_l_e_t_ <> '*' AND C5_FILIAL = D2_FILIAL AND C5_NUM = D2_PEDIDO AND C5_CLIENTE = D2_CLIENTE))),2))*D2_QUANT),2) as valor_frete,
cQry += " (select da3_placa from "+RetSqlName("DA3") +" da3 where da3.d_e_l_e_t_ <> '*' and DA3.DA3_COD = (SELECT SF2.F2_VEICUL1 FROM "+RetSqlName("SF2") +" SF2 WHERE SF2.D_E_L_E_T_ <> '*' AND F2_DOC = D2_DOC AND F2_FILIAL = D2_FILIAL and f2_cliente = d2_cliente)) da3_placa, 
cQry += " CASE WHEN (SELECT ADA_XORDEM FROM "+RetSqlName("ADA") +" ADA WHERE ada.d_e_l_e_t_ <> '*' AND ADA_FILIAL = D2_FILIAL AND ADA_NUMCTR = (SELECT C5_CONTRA FROM "+RetSqlName("SC5") +" SC5 WHERE sc5.d_e_l_e_t_ <> '*' AND C5_FILIAL = D2_FILIAL AND C5_NUM = D2_PEDIDO AND C5_CLIENTE = D2_CLIENTE)) = '1'
cQry += " THEN TRIM((SELECT ADA_XCLIOR FROM "+RetSqlName("ADA") +" ADA WHERE ada.d_e_l_e_t_ <> '*' AND ADA_FILIAL = D2_FILIAL AND ADA_NUMCTR = (SELECT C5_CONTRA FROM "+RetSqlName("SC5") +" SC5 WHERE sc5.d_e_l_e_t_ <> '*' AND C5_FILIAL = D2_FILIAL AND C5_NUM = D2_PEDIDO AND C5_CLIENTE = D2_CLIENTE)))
cQry += " ELSE d2_cliente END AS D2_CLIENTE,
cQry += " CASE WHEN (SELECT ADA_XORDEM FROM "+RetSqlName("ADA") +" ADA WHERE ada.d_e_l_e_t_ <> '*' AND ADA_FILIAL = D2_FILIAL AND ADA_NUMCTR = (SELECT C5_CONTRA FROM "+RetSqlName("SC5") +" SC5 WHERE sc5.d_e_l_e_t_ <> '*' AND C5_FILIAL = D2_FILIAL AND C5_NUM = D2_PEDIDO AND C5_CLIENTE = D2_CLIENTE)) = '1'
cQry += " THEN TRIM((SELECT ADA_XLOJOR FROM "+RetSqlName("ADA") +" ADA WHERE ada.d_e_l_e_t_ <> '*' AND ADA_FILIAL = D2_FILIAL AND ADA_NUMCTR = (SELECT C5_CONTRA FROM "+RetSqlName("SC5") +" SC5 WHERE sc5.d_e_l_e_t_ <> '*' AND C5_FILIAL = D2_FILIAL AND C5_NUM = D2_PEDIDO AND C5_CLIENTE = D2_CLIENTE)))
cQry += " ELSE D2_LOJA END AS LOJA
cQry += " FROM "+RetSqlName("SD2") +" SD2, "+RetSqlName("SC6") +" SC6
cQry += " WHERE SD2.D2_EMISSAO BETWEEN '"+DToS(MV_PAR05)+"' AND '"+DToS(MV_PAR06)+"'
cQry += " AND D2_FILIAL = C6_FILIAL
//cQry += " AND D2_DOC = C6_NOTA
cQry += " AND D2_CLIENTE = C6_CLI
cQry += " AND D2_PEDIDO = C6_NUM
cQry += " AND sc6.d_e_l_e_t_ <> '*'
cQry += " AND D2_FILIAL BETWEEN '"+MV_PAR01+"' AND  '"+MV_PAR02+"'
cQry += " AND (select da3_placa from "+RetSqlName("DA3") +" da3 where da3.d_e_l_e_t_ <> '*' and DA3.DA3_COD = (SELECT SF2.F2_VEICUL1 FROM "+RetSqlName("SF2") +" SF2 WHERE SF2.D_E_L_E_T_ <> '*' AND F2_DOC = D2_DOC AND F2_FILIAL = D2_FILIAL and f2_cliente = d2_cliente)) BETWEEN '"+MV_PAR03+"' AND  '"+MV_PAR04+"'  
cQry += " AND D2_TES <> '527' 
cQry += " AND (SELECT TRIM(F4_ESTOQUE) FROM SF4010 SF4 WHERE SD2.D2_TES = SF4.F4_CODIGO AND SF4.D_E_L_E_T_ != '*') = 'S'
//cQry += " AND D2_CLIENTE BETWEEN '"+MV_PAR07+"' AND '"+MV_PAR08+"'
If MV_PAR09 == 1
	cQry += " AND (SELECT SF2.F2_TPFRETE FROM "+RetSqlName("SF2") +" SF2 WHERE SF2.D_E_L_E_T_ <> '*' AND F2_DOC = D2_DOC AND F2_FILIAL = D2_FILIAL and f2_cliente = d2_cliente) = 'C'
elseif MV_PAR09 == 2
	 cQry += " AND (SELECT SF2.F2_TPFRETE FROM "+RetSqlName("SF2") +" SF2 WHERE SF2.D_E_L_E_T_ <> '*' AND F2_DOC = D2_DOC AND F2_FILIAL = D2_FILIAL and f2_cliente = d2_cliente) = 'F'
Endif
cQry += " AND CASE WHEN (SELECT ADA_XORDEM FROM "+RetSqlName("ADA") +" ADA WHERE ada.d_e_l_e_t_ <> '*' AND ADA_FILIAL = D2_FILIAL AND ADA_NUMCTR = (SELECT C5_CONTRA FROM "+RetSqlName("SC5") +" SC5 WHERE sc5.d_e_l_e_t_ <> '*' AND C5_FILIAL = D2_FILIAL AND C5_NUM = D2_PEDIDO AND C5_CLIENTE = D2_CLIENTE)) = '1'
cQry += " THEN TRIM((SELECT ADA_XCLIOR FROM "+RetSqlName("ADA") +" ADA WHERE ada.d_e_l_e_t_ <> '*' AND ADA_FILIAL = D2_FILIAL AND ADA_NUMCTR = (SELECT C5_CONTRA FROM "+RetSqlName("SC5") +" SC5 WHERE sc5.d_e_l_e_t_ <> '*' AND C5_FILIAL = D2_FILIAL AND C5_NUM = D2_PEDIDO AND C5_CLIENTE = D2_CLIENTE)))
cQry += " ELSE d2_cliente
cQry += " END BETWEEN '"+MV_PAR07+"' AND '"+MV_PAR08+"'
cQry += " ORDER BY SD2.D2_EMISSAO  
MemoWrite("C:\TEMP\relviagem.txt",cQry)
DbUseArea(.T., "TOPCONN", TcGenQry(,, cQry), cAlias, .T., .T.)
DbGotop() 
	
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ SETREGUA -> Indica quantos registros serao processados para a regua ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

SetRegua(RecCount())

Cabec1 += Space(3)
Cabec1 += Padc("NF FISCAL" ,len((cAlias)->D2_DOC)) 			   		+ "/"  
Cabec1 += Padc("SERIE" ,len((cAlias)->D2_SERIE))			   		+ " | " 
Cabec1 += Padc("PEDIDO",6)								   	   		+ " | "//PEDIDO
Cabec1 += Padc("CONTRA",8)										   	+ " | "//CONTRATO
Cabec1 += Padc("TES",3)									   	   		+ " | "//TES
Cabec1 += Padc("PRODUTO" ,6)								       	+ " | "//PRODUTO
Cabec1 += Padc("DES. PRODUTO" ,30)							       	+ " | "//PRODUTO
Cabec1 += Padc("EMISSAO" ,10)						     			+ " | "//EMISSAO 
Cabec1 += Padc("QUANTIDADE" ,11)						  			+ " | "//QUANT 
Cabec1 += Padc("VLR FRETE" ,14)  			 				   		+ " | "//VLR UNI 
Cabec1 += Padc("VLR TOTAL" ,14)  			 				   		+ " | "//TOTAL
nPosQtd := Len(Cabec1)
Cabec1 += Padc("PLACA" ,8)						              	   	+ " | "//PLACA 
Cabec1 += Padc("FILIAL" ,8)						              	   	+ " | "//FILIAL 
Cabec1 += Padc("CLIENTE" ,8)						              	+ " | "//COD CLIENTE
Cabec1 += Padc("NOME" ,30)							              	+ " | "//COD CLIENTE
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
	DbSelectArea("SA1")
	SA1->(DbSetOrder(1))
	SA1->(DbSeek(xFilial("SA1")+(cAlias)->D2_CLIENTE+(cAlias)->LOJA))

	cLin := transform((cAlias)->D2_DOC, PesqPict("SD2","D2_DOC"))  			  		+  "/"
	cLin += transform((cAlias)->D2_SERIE, PesqPict("SD2","D2_SERIE"))     	    	+  " | " 
	cLin += Padc(transform((cAlias)->D2_PEDIDO, PesqPict("SD2","D2_PEDIDO")),6)  	+  " | " 
	cLin += Padc(transform((cAlias)->CONTRATO, PesqPict("SD2","D2_PEDIDO")),8)  	+  " | " 
	cLin += Padc(transform((cAlias)->D2_TES, PesqPict("SD2","D2_TES")),3)     		+  " | " 
	cLin += Padc(transform((cAlias)->D2_COD, PesqPict("SD2","D2_COD")),6)     		+  " | " 
	cLin += Padc(transform((cAlias)->B1_DESC, PesqPict("SB1","B1_DESC")),30)  		+  " | " 
	cLin += dtoc(stod((cAlias)->D2_EMISSAO))	                                    +  " | " //DATA
	cLin += Padc(transform((cAlias)->D2_QUANT, PesqPict("SD2","D2_QUANT")),11)    	+  " | " 
	cLin += Padl("R$"+transform((cAlias)->valor_frete,"@E 999,999.99"),14) 		   	+  " | "
	cLin += Padl("R$"+transform((cAlias)->D2_TOTAL,"@E 999,999.99"),14)  		  	+  " | "
	cLin += Padc(transform((cAlias)->DA3_PLACA, PesqPict("DA3","DA3_PLACA")),8)   	+  " | "
	cLin += Padc(transform((cAlias)->D2_FILIAL, PesqPict("SD2","D2_FILIAL")),8)   	+  " | "
	cLin += Padc(transform((cAlias)->D2_CLIENTE, PesqPict("SD2","D2_CLIENTE")),8)   +  " | "
	cLin += Padl(SA1->A1_NOME, 30)													+  " | "
   //	cLin +=  Padc(cValtoChar(cTxdep),8)		   		     			            +  " | "
	@nLin,03 PSAY cLin
	nLin++
	nQuant += (cAlias)->D2_QUANT
	nPrcv  += (cAlias)->valor_frete 
	ntotaa += (cAlias)->D2_TOTAL 

	(cAlias)->(dbSkip())

EndDo

	nLin++
	@nLin,97 PSAY Padl(transform(nQuant,"@E 999,999.99"),12) 		   	+  " | "
	@nLin,113 PSAY Padl("R$"+transform(nPrcv,"@E 999,999.99"),14)  	  	+  " | "     
	@nLin,133 PSAY Padl("R$"+transform(ntotaa,"@E 99,999,999.99"),16)   +  " | " 

	//if SELECT("SA1") > 0 
	//	DBCLOSEAREA("SA1")	
	//endif  
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
