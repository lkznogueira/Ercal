#INCLUDE "rwmake.ch"
#INCLUDE "Protheus.ch"
#INCLUDE "Totvs.ch"
#INCLUDE "topconn.ch"
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³EMPREST   º Autor ³CARLOS DANIEL º Data ³  29/05/15         º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ RELATORIO DE ENTREGA FUTURA .                              º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ 			                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function relfut()


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	Local cDesc1       := "Este programa tem como objetivo imprimir relatorio "
	Local cDesc2       := "de acordo com os parametros informados pelo usuario."
	Local cDesc3       := ""
	//Local cPict        := ""
	Local titulo       := "Relatorio de entrega Futura"
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
	Private nomeprog   := "erc001fut" // Coloque aqui o nome do programa para impressao no cabecalho
	Private nTipo      := 18
	Private aReturn    := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
	Private nLastKey   := 0
	Private cPerg      := "erc001fut"
	//Private cbcont     := 00
	Private CONTFL     := 01
	Private m_pag      := 01
	Private wnrel      := "erc001fut" // Coloque aqui o nome do arquivo usado para impressao em disco
	Private cString := "ADB"

	dbSelectArea("ADB")
	dbSetOrder(1)

	PutSX1(cPerg , "01" , "Cliente de   	   " , "" , "" , "mv_ch1" , "C" , 6 , 0 , 0 , "G" , "", "SA1", "", "", "mv_par01" , "        " ,"","","", "        " ,"","","", "        " , "" , "" , "" , "" , "" , "" , "" , "" )
	PutSX1(cPerg , "02" , "Cliente ate  	   " , "" , "" , "mv_ch2" , "C" , 6 , 0 , 0 , "G" , "", "SA1", "", "", "mv_par02" , "        " ,"","","", "   	  " ,"","","", "        " , "" , "" , "" , "" , "" , "" , "" , "" )
	PutSX1(cPerg , "03" , "Loja de   	       " , "" , "" , "mv_ch3" , "C" , 2 , 0 , 0 , "G" , "", "", "", "", "mv_par03" , "        " ,"","","", "        " ,"","","", "        " , "" , "" , "" , "" , "" , "" , "" , "" )
	PutSX1(cPerg , "04" , "Loja ate  	       " , "" , "" , "mv_ch4" , "C" , 2 , 0 , 0 , "G" , "", "", "", "", "mv_par04" , "        " ,"","","", "   	  " ,"","","", "        " , "" , "" , "" , "" , "" , "" , "" , "" )
	PutSX1(cPerg , "05" , "Filial de           " , "" , "" , "mv_ch5" , "C" , 4  , 0 , 0 , "G" , "", "SM0", "", "", "mv_par05" , "        " ,"","","", "        " ,"","","", "        " , "" , "" , "" , "" , "" , "" , "" , "" )
	PutSX1(cPerg , "06" , "Filial ate          " , "" , "" , "mv_ch6" , "C" , 4  , 0 , 0 , "G" , "", "SM0", "", "", "mv_par06" , "        " ,"","","", "   	  " ,"","","", "        " , "" , "" , "" , "" , "" , "" , "" , "" )
	PutSX1(cPerg , "07" , "Data Base.          " , "" , "" , "mv_ch7" , "D" , 4  , 0 , 0 , "G" , "", "", "", "", "mv_par07" , "        " ,"","","", "        " ,"","","", "        " , "" , "" , "" , "" , "" , "" , "" , "" )
	PutSX1(cPerg , "08" , "Tipo Imp.	       " , "" , "" , "mv_ch8" , "N" , 1  , 0 , 1 , "C" , "", "", "", "", "mv_par08" , "(1)Futura" ,"","","", "(2)Direta" ,"","","", "        " , "" , "" , "" , "" , "" , "" , "" , "" )
	PutSX1(cPerg , "09" , "Contrato   	 	   " , "" , "" , "mv_ch9" , "C" , 6 , 0 , 0 , "G" , "", "", "", "", "mv_par09" , "        " ,"","","", "        " ,"","","", "        " , "" , "" , "" , "" , "" , "" , "" , "" )
	PutSX1(cPerg , "10" , "Contrato		  	   " , "" , "" , "mv_ch10" , "C" , 6 , 0 , 0 , "G" , "", "", "", "", "mv_par10" , "        " ,"","","", "   	  " ,"","","", "        " , "" , "" , "" , "" , "" , "" , "" , "" )
	PutSX1(cPerg , "11" , "Aceitar Vlr 0.	   " , "" , "" , "mv_ch11" , "N" , 1  , 0 , 1 , "C" , "", "", "", "", "mv_par11" , "(1)sim" ,"","","", "(2)nao" ,"","","", "        " , "" , "" , "" , "" , "" , "" , "" , "" )
    PutSX1(cPerg , "12" , "Exporta Excel?	   " , "" , "" , "mv_ch12" , "N" , 1  , 0 , 0 , "C" , "", "", "", "", "mv_par12" , "(1)sim" ,"","","", "(2)nao" ,"","","", "        " , "" , "" , "" , "" , "" , "" , "" , "" )
	//PutSx1(cPerg , "12" , "Exporta Excel?      " , "" , "" , "mv_ch12" , "N" , 1  , 0 , 0 , "C" , "", "", "", "" ,"mv_par12","Sim","Sim","Sim","Nao","Nao","Nao","","","","","","","","","")

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
//Local nNumero := "0"
//Local nOrdem  
	Local qCtr   := 0
	Local qFut   := 0
	Local qDfut  := 0
	Local qRem   := 0
	Local qDrem  := 0
	Local qRest  := 0
	Local vFut   := 0
	Local vDfut  := 0
	Local nValFut := 0
	Local vRem   := 0
	Local vDrem  := 0
	Local vTotal := 0
	Local aReg   :={}
	Local vDescRem := 0
	//Local nCount := 0
	Private cAlias := Criatrab(Nil,.F.)
	Private cAliasREM := Criatrab(Nil,.F.)
	Private cAliasDEV := Criatrab(Nil,.F.)
	Private cQry := Space(0)
	Private cQryDev := Space(0)
	Private cQryRem := Space(0)
	Private cQryMae := Space(0)
	Private nRest
	Private nValreM
	Private cLin
	Private	nValdev
	Private	cQtddev
	Private nValres
	Private nValpag
	Private vLrdesc
	Private vLrfret

	cQry := "SELECT ADB_FILIAL, ADA_FILIAL, ADA_CODCLI, ADA_XNOMC, ADA_LOJCLI, ADA_NUMCTR, ADB_CODPRO, ADB_DESPRO, ADB_QUANT, ADB_PEDCOB,"  + CRLF
	cQry += "NVL((SELECT C6_NOTA FROM "+RetSqlName("SC6") +" SC6 WHERE sc6.d_e_l_e_t_ <> '*' AND C6_NUM = ADB_PEDCOB AND C6_FILIAL = ADA_FILIAL AND C6_CLI = ADA_CODCLI AND C6_PRODUTO = ADB_CODPRO),0) AS NOTA_FUT,"  + CRLF
	cQry += "NVL((SELECT C5_DESCONT FROM "+RetSqlName("SC5") +" SC5 WHERE sc5.d_e_l_e_t_ <> '*' AND C5_NUM = ADB_PEDCOB AND C5_FILIAL = ADA_FILIAL AND C5_CLIENT = ADA_CODCLI),0) AS DESC_FUT,"  + CRLF
	cQry += "NVL((SELECT C6_QTDVEN FROM "+RetSqlName("SC6") +" SC6 WHERE sc6.d_e_l_e_t_ <> '*' AND C6_NUM = ADB_PEDCOB AND C6_FILIAL = ADA_FILIAL AND C6_CLI = ADA_CODCLI AND C6_PRODUTO = ADB_CODPRO),0) AS QTD_FUT,"  + CRLF
	cQry += "NVL((SELECT SUM(D1_QUANT) FROM "+RetSqlName("SD1") +" SD1 WHERE SD1.D_E_L_E_T_ <> '*' AND SD1.D1_EMISSAO <=  '"+DToS(MV_PAR07)+"' AND D1_NFORI = (SELECT C6_NOTA FROM "+RetSqlName("SC6") +" SC6 WHERE sc6.d_e_l_e_t_ <> '*' AND C6_NUM = ADB_PEDCOB AND C6_FILIAL = ADA_FILIAL AND C6_CLI = ADA_CODCLI AND C6_PRODUTO = ADB_CODPRO) AND D1_FILIAL = ADA_FILIAL AND SD1.D1_TIPO = 'D' AND D1_COD = ADB_CODPRO AND D1_FORNECE = ADA_CODCLI),0) AS QTD_DEV_FUT,"  + CRLF
	cQry += "NVL((SELECT SUM((D1_TOTAL-D1_VALDESC)) FROM "+RetSqlName("SD1") +" SD1 WHERE SD1.D_E_L_E_T_ <> '*' AND SD1.D1_EMISSAO <=  '"+DToS(MV_PAR07)+"' AND D1_NFORI = (SELECT C6_NOTA FROM "+RetSqlName("SC6") +" SC6 WHERE sc6.d_e_l_e_t_ <> '*' AND C6_NUM = ADB_PEDCOB AND C6_FILIAL = ADA_FILIAL AND C6_CLI = ADA_CODCLI AND C6_PRODUTO = ADB_CODPRO) AND D1_FILIAL = ADA_FILIAL AND SD1.D1_TIPO = 'D' AND D1_COD = ADB_CODPRO AND D1_FORNECE = ADA_CODCLI),0) AS VLR_DEV_FUT,"  + CRLF
	cQry += "NVL((SELECT SUM(C6_QTDVEN) FROM "+RetSqlName("SC6") +" SC6 WHERE sc6.d_e_l_e_t_ <> '*' AND C6_CONTRAT = ADB_NUMCTR AND C6_FILIAL = ADA_FILIAL AND C6_CLI = ADA_CODCLI AND C6_NUM <> ADB_PEDCOB AND C6_DATFAT <=  '"+DToS(MV_PAR07)+"' AND C6_PRODUTO = ADB_CODPRO GROUP BY C6_CONTRAT ),0) AS QTD_REMESSA,"  + CRLF
	cQry += "NVL((SELECT sum(C6_VALOR) FROM "+RetSqlName("SC6") +" SC6 WHERE sc6.d_e_l_e_t_ <> '*' AND C6_NUM = ADB_PEDCOB AND C6_FILIAL = ADA_FILIAL AND C6_CLI = ADA_CODCLI),0) AS VLR_FUT,"  + CRLF
	cQry += "ADB_TOTAL AS VLR_CTR,"  + CRLF
	cQry += "trim('C'||ADB_CODCLI||ADB_LOJCLI) AS COD_CLIENTE"  + CRLF

	cQry += "FROM "+RetSqlName("ADB") +" ADB "  + CRLF
	cQry += "INNER JOIN "+RetSqlName("ADA") +" ADA ON ADA.ADA_NUMCTR = ADB.ADB_NUMCTR AND ADA.D_E_L_E_T_ <> '*' AND ADA.ADA_FILIAL = ADB.ADB_FILIAL AND ADA.ADA_CODCLI = ADB.ADB_CODCLI "  + CRLF
	cQry += "WHERE ADB.D_E_L_E_T_ <> '*' "  + CRLF
	cQry += "AND ADB_TESCOB <> ' ' "  + CRLF
	cQry += "AND ADB_CODCLI BETWEEN  '"+MV_PAR01+"' AND  '"+MV_PAR02+"' "  + CRLF
	cQry += "AND ADB_LOJCLI BETWEEN  '"+MV_PAR03+"' AND  '"+MV_PAR04+"' "  + CRLF
	cQry += "AND ADB_FILIAL BETWEEN  '"+MV_PAR05+"' AND  '"+MV_PAR06+"' "  + CRLF
	cQry += "AND ADA_EMISSA <=  '"+DToS(MV_PAR07)+"' "  + CRLF
	cQry += "AND ADA_NUMCTR BETWEEN  '"+MV_PAR09+"' AND '"+MV_PAR10+"' "  + CRLF
	cQry += "AND ADA_STATUS <> 'A'  "  + CRLF
	cQry += "AND ADB_XTIPO IN ('55','85') "  + CRLF
	cQry += "AND NVL((SELECT C6_QTDVEN FROM "+RetSqlName("SC6") +" SC6 WHERE sc6.d_e_l_e_t_ <> '*' AND C6_NUM = ADB_PEDCOB AND C6_FILIAL = ADA_FILIAL AND C6_CLI = ADA_CODCLI AND C6_PRODUTO = ADB_CODPRO),0) <> 0  "  + CRLF
	cQry += "ORDER BY ADB_CODCLI"  + CRLF

	MemoWrite("C:\TEMP\RELFUT.txt",cQry)
	DbUseArea(.T., "TOPCONN", TcGenQry(,, cQry), cAlias, .T., .T.)
	DbGotop()
	

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ SETREGUA -> Indica quantos registros serao processados para a regua ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	IF mv_par08 == 1

		SetRegua(RecCount())

		Cabec1 += Space(3)
		Cabec1 += Padc("FILIAL" ,6)	  			   	  	   			   	    + " |" //ADA_FILIAL
		Cabec1 += Padc("COD CLI." ,10)			   		    				+ " |"
		Cabec1 += Padc("NOME CLIENTE",12)	   	   	              		    + " |"
		Cabec1 += Padc("LJ",2)	   	   	              		                + " |"
		Cabec1 += Padc("CONTRATO",7)	   	   	              		        + " |"
		Cabec1 += Padc("DESC PROD",10)	  	              		            + " |"
		Cabec1 += Padc("QTDCTR",9)	   	   	              			      	+ " |"
		Cabec1 += Padc("QTD FUT" ,9)	   	   						        + " |"
		Cabec1 += Padc("QTDEV-FUT",9)	   	   	              			    + " |"
		Cabec1 += Padc("QTD REM." ,9)	   	   						    	+ " |"		
		Cabec1 += Padc("QTDEV-REM",9)	   	   	              				+ " |"
		Cabec1 += Padc("QTDREST" ,9)	    	   						    + " |"
		Cabec1 += Padc("VLR-FUT R$" ,16)			   	  	   			    + " |"
		Cabec1 += Padc("VLRDEV FUT R$" ,16)	   	   						    + " |"
		Cabec1 += Padc("VLR REMESSA R$" ,16)				   	  	   		+ " |"
		Cabec1 += Padc("VLRDEV REMESSA R$" ,16)			   	  	   			+ " |"
		Cabec1 += Padc("TOTAL REST R$" ,16)			   	  	   			    + " |"
		nPosQtd := Len(Cabec1)
		Cabec2 := Space(0)
		If mv_par12==1
			Aadd(aReg,{Padc("Filial" ,6),Padc("Cod Cliente" ,11),Padc("Nome Cliente",12),Padc("LJ",2),Padc("Contrato" ,8),Padc("Desc Produto",12),Padc("QtdCtr" ,9),Padc("QtdFut" ,9),Padc("QTDEV-FUT",9),Padc("QTD REM." ,9),Padc("QTDEV-REM",9),Padc("QTDREST" ,9),Padc("VLR-FUT R$" ,16),Padc("VLRDEV FUT R$" ,16),Padc("VLR REMESSA R$" ,16),Padc("VLRDEV REMESSA R$" ,16),Padc("TOTAL REST R$" ,16)})
		EndIf

		dbGoTop()
//While !EOF() 
		While (cAlias)->(!EOF())
			//QUERY REMESSA
			cQryRem := " select C6_FILIAL, c6_contrat, c6_item, c6_produto,  nvl(sum(c6_qtdven),0) as qtd_remessa, TRUNC(nvl(sum(c6_valor),0),2) vlr_remessa,"  + CRLF
			cQryRem += " sum((select c5_descont from "+RetSqlName("SC5") +" sc5 where sc5.d_e_l_e_t_ <> '*' and c5_filial = c6_filial and c5_cliente = c6_cli and c5_num = sc6.c6_num )) as desREM from "+RetSqlName("SC6") +" SC6"  + CRLF
			cQryRem += " where SC6.d_e_l_e_t_ <> '*'"  + CRLF
			cQryRem += " and c6_contrat = '"+(cAlias)->ADA_NUMCTR+"'"  + CRLF
			cQryRem += " and c6_filial = '"+(cAlias)->ADB_FILIAL+"'"  + CRLF
			cQryRem += " AND C6_DATFAT <=  '"+DToS(MV_PAR07)+"'"  + CRLF
			cQryRem += " AND C6_PRODUTO <=  '"+(cAlias)->ADB_CODPRO+"'"  + CRLF
			cQryRem += "AND C6_CLI BETWEEN  '"+MV_PAR01+"' AND  '"+MV_PAR02+"' "  + CRLF
			cQryRem += "AND C6_LOJA BETWEEN  '"+MV_PAR03+"' AND  '"+MV_PAR04+"' "  + CRLF
			cQryRem += "AND C6_CF NOT IN ('5923','6923')"  + CRLF
			//cQryRem += " AND (SELECT F4_ESTOQUE FROM SF4010 SF4 WHERE sf4.d_e_l_e_t_ <> '*' AND F4_CODIGO = C6_TES) = 'S'"  + CRLF
			cQryRem += " and c6_num <> (select adb_pedcob from "+RetSqlName("ADB") +" adb where adb.d_e_l_e_t_ <> '*' and c6_contrat = adb_numctr and adb_filial = c6_filial and rownum = 1 )"  + CRLF
			cQryRem += " group by C6_FILIAL, c6_contrat, c6_item, c6_produto"  + CRLF

			DbUseArea(.T., "TOPCONN", TcGenQry(,, cQryRem), cAliasREM, .T., .T.)
			DbGotop()
			MemoWrite("C:\TEMP\cQryRem.txt",cQryRem)

			//QUERY DEVOLUCAO REMESSA
			cQryDev := " select C6_FILIAL, c6_contrat, c6_item, c6_produto,
			cQryDev += " nvl(sum((select d2_qtdedev from "+RetSqlName("SD2") +" sd2 where sd2.d_e_l_e_t_ <> '*' and d2_filial = c6_filial and d2_doc = c6_nota and sd2.d2_qtdedev <> 0) ),0) as qtd_dev_remessa,"  + CRLF
			cQryDev += " nvl(sum((select d2_qtdedev from "+RetSqlName("SD2") +" sd2 where sd2.d_e_l_e_t_ <> '*' and d2_filial = c6_filial and d2_doc = c6_nota and sd2.d2_qtdedev <> 0)*c6_prcven),0) as vlr_dev_remessa"  + CRLF
			cQryDev += " from "+RetSqlName("SC6") +" SC6"  + CRLF
			cQryDev += " where SC6.d_e_l_e_t_ <> '*'"  + CRLF
			cQryDev += " and c6_contrat = '"+(cAlias)->ADA_NUMCTR+"'"  + CRLF
			cQryDev += " and c6_filial = '"+(CALIAS)->ADB_FILIAL+"'"  + CRLF
			cQryDev += " AND C6_DATFAT <=  '"+DToS(MV_PAR07)+"'"  + CRLF
			cQryDev += " AND C6_PRODUTO <=  '"+(cAlias)->ADB_CODPRO+"'"  + CRLF
			cQryDev += "AND C6_CLI BETWEEN  '"+MV_PAR01+"' AND  '"+MV_PAR02+"' "  + CRLF
			cQryDev += "AND C6_LOJA BETWEEN  '"+MV_PAR03+"' AND  '"+MV_PAR04+"' "  + CRLF
			//cQryDev += " AND (SELECT F4_ESTOQUE FROM SF4010 SF4 WHERE sf4.d_e_l_e_t_ <> '*' AND F4_CODIGO = C6_TES) = 'S'"  + CRLF
			cQryDev += " and c6_num <> (select adb_pedcob from "+RetSqlName("ADB") +" adb where adb.d_e_l_e_t_ <> '*' and c6_contrat = adb_numctr and adb_filial = c6_filial and rownum = 1 )"  + CRLF
			cQryDev += " group by C6_FILIAL, c6_contrat, c6_item, c6_produto"  + CRLF

			DbUseArea(.T., "TOPCONN", TcGenQry(,, cQryDev), cAliasDEV, .T., .T.)
			DbGotop()
			MemoWrite("C:\TEMP\cQryDev.txt",cQryDev)
			
			dbselectarea("SC5")
			dbsetorder(1)
			dbseek((cAlias)->ADB_FILIAL+(cAlias)->ADB_PEDCOB)
			vDescRem := (cAliasREM)->desREM
			
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
			
			If (cAliasDEV)->qtd_dev_remessa > 0 //dev remessa
				nRest := (((cAliasREM)->qtd_remessa-(cAliasDEV)->qtd_dev_remessa))
				nValreM := (((cAliasREM)->vlr_remessa-vDescRem)-(cAliasDEV)->vlr_dev_remessa) //verificar e colocar saldo
			Else
				nRest := (cAliasREM)->qtd_remessa//(((cAlias)->ADB_QUANT-(cAlias1)->CARREGADO)-cQtddev)
				nValreM := ((cAliasREM)->vlr_remessa-vDescRem)//(((vContra/(cAlias)->ADB_QUANT)*nRest))
			EndIf
			//nValpag := ((vContra)-nValres)
			nValFut := ((cAlias)->VLR_FUT-(cAlias)->DESC_FUT)
			nValres := ((nValFut-(((cAliasREM)->vlr_remessa-vDescRem)-(cAliasDEV)->vlr_dev_remessa))-(cAlias)->VLR_DEV_FUT)
			QTDREST := (((cAlias)->QTD_FUT-((cAliasREM)->qtd_remessa-(cAliasDEV)->qtd_dev_remessa))-(cAlias)->QTD_DEV_FUT)
			IF mv_par11 == 1
				//cBXATI := dtoc(stod((cAlias)->E5_DATA))
				nLin++   //pula pra linha debaixo
				cLin := 0
				cLin := Padl((cAlias)->ADA_FILIAL, 6)    	       							   	     	+  " |" //FILIAL
				cLin += Padl((cAlias)->COD_CLIENTE, 10)     		   							        +  " |" // CODIGO CLIENTE
				cLin += Padl((cAlias)->ADA_XNOMC, 12)      									         	+  " |"  // NOME CLIENTE
				cLin += Padl((cAlias)->ADA_LOJCLI, 2)      									        	+  " |"  // LOJA CLIENTE
				cLin += Padl((cAlias)->ADA_NUMCTR, 7)     									      	    +  " |"  // CONTRATO
				cLin += Padl((cAlias)->ADB_QUANT, 9) 													+  " |"
				cLin += Padl((cAlias)->QTD_FUT, 9)      								     	        +  " |"  // QUANTIDADE CONTRATO
				cLin += Padl((cAlias)->QTD_DEV_FUT, 9)      								     	    +  " |"  // QUANTIDADE CONTRATO
				cLin += Padl(nRest, 9)     	 								    					 	+  " |"  //  QUANTIDADE ENTR FUT
				cLin += Padl((cAliasDEV)->qtd_dev_remessa, 9)            								+  " |"  // QUANTIDADE DEV FUT
				cLin += Padl(QTDREST, 9)                  								     	        +  " |"  // QTD REMESSA
				cLin += Padl("R$"+transform(nValFut,"@E 999,999,999.99"),16) 							+  " |" // VALOR FUT
				cLin += Padl("R$"+transform((cAlias)->VLR_DEV_FUT,"@E 999,999,999.99"),16) 				+  " |" // VALOR DEV FUT
				cLin += Padl("R$"+transform(nValreM,"@E 999,999,999.99"),16)							+  " |" //	VALOR REMESSA
				cLin += Padl("R$"+transform((cAliasDEV)->vlr_dev_remessa,"@E 999,999,999.99"),16)		+  " |" //	VALOR DV REMESSA
				cLin += Padl("R$"+transform(nValres,"@E 999,999,999.99"),16)			 		        +  " |" //	VALOR RESTANTE				

				@nLin,03 PSAY cLin
				nLin++  //pula pra linha debaixo
				//nNumero := SUBSTR((cAlias)->NUMERO,1,8)
				if mv_par12==1
	  				Aadd(aReg,{Padl((cAlias)->ADA_FILIAL, 6),Padl((cAlias)->COD_CLIENTE, 10),Padl((cAlias)->ADA_XNOMC, 12),Padl((cAlias)->ADA_LOJCLI, 2),Padl((cAlias)->ADA_NUMCTR, 7),	Padl((cAlias)->ADB_DESPRO, 10),Padl((cAlias)->ADB_QUANT, 9),Padl((cAlias)->QTD_FUT, 9),Padl((cAlias)->QTD_DEV_FUT, 9),Padl(nRest, 9),Padl((cAliasDEV)->qtd_dev_remessa, 9),Padl(QTDREST, 9),Padl("R$"+transform(nValFut,"@E 999,999,999.99"),16),Padl("R$"+transform((cAlias)->VLR_DEV_FUT,"@E 999,999,999.99"),16),Padl("R$"+transform(nValreM,"@E 999,999,999.99"),16),Padl("R$"+transform((cAliasDEV)->vlr_dev_remessa,"@E 999,999,999.99"),16),Padl("R$"+transform(nValres,"@E 999,999,999.99"),16)})
				endif

				qCtr  += (cAlias)->ADB_QUANT
				qFut  += (cAlias)->QTD_FUT
				qDfut += (cAlias)->QTD_DEV_FUT
				qRem  += nRest
				qDrem += (cAliasDEV)->qtd_dev_remessa
				qRest += QTDREST
				vFut  += nValFut
				vDfut += (cAlias)->VLR_DEV_FUT
				vRem  += nValreM
				vDrem += (cAliasDEV)->vlr_dev_remessa
				vTotal+= nValres
			ELSE
				IF nValres < -0.1 .Or. nValres > 0.1 //<> 0 //DIFERENTE ATE 6 CENTAVOS
						//cBXATI := dtoc(stod((cAlias)->E5_DATA))
						nLin++   //pula pra linha debaixo
						cLin := 0
						cLin := Padl((cAlias)->ADA_FILIAL, 6)    	       							   	     	+  " |" //FILIAL
						cLin += Padl((cAlias)->COD_CLIENTE, 10)     		   							        +  " |" // CODIGO CLIENTE
						cLin += Padl((cAlias)->ADA_XNOMC, 12)      									         	+  " |"  // NOME CLIENTE
						cLin += Padl((cAlias)->ADA_LOJCLI, 2)      									        	+  " |"  // LOJA CLIENTE
						cLin += Padl((cAlias)->ADA_NUMCTR, 7)     									      	    +  " |"  // CONTRATO
						cLin += Padl((cAlias)->ADB_DESPRO, 10)      									      	+  " |"  //DESCRICAO PRODUTO
						cLin += Padl((cAlias)->ADB_QUANT, 9) 													+  " |"
						cLin += Padl((cAlias)->QTD_FUT, 9)      								     	        +  " |"  // QUANTIDADE CONTRATO
						cLin += Padl((cAlias)->QTD_DEV_FUT, 9)      								     	    +  " |"  // QUANTIDADE CONTRATO
						cLin += Padl(nRest, 9)     	 													     	+  " |"  //  QUANTIDADE ENTR FUT
						cLin += Padl((cAliasDEV)->qtd_dev_remessa, 9)            								+  " |"  // QUANTIDADE DEV FUT
						cLin += Padl(QTDREST, 9)                  								     	        +  " |"  // QTD REMESSA
						cLin += Padl("R$"+transform(nValFut,"@E 999,999,999.99"),16) 							+  " |" // VALOR FUT
						cLin += Padl("R$"+transform((cAlias)->VLR_DEV_FUT,"@E 999,999,999.99"),16) 				+  " |" // VALOR DEV FUT
						cLin += Padl("R$"+transform(nValreM,"@E 999,999,999.99"),16)							+  " |" //	VALOR REMESSA
						cLin += Padl("R$"+transform((cAliasDEV)->vlr_dev_remessa,"@E 999,999,999.99"),16)		+  " |" //	VALOR DV REMESSA
						cLin += Padl("R$"+transform(nValres,"@E 999,999,999.99"),16)			 		        +  " |" //	VALOR RESTANTE					//cLin += Padl("R$"+transform(nValres,"@E 999,999,999.99"),16)			 		        +  " |" //	VALOR RESTANTE

						@nLin,03 PSAY cLin
						nLin++  //pula pra linha debaixo
						//inicio do exportavel indique aqui todos os campos
						if mv_par12==1
	  						Aadd(aReg,{Padl((cAlias)->ADA_FILIAL, 6),Padl((cAlias)->COD_CLIENTE, 10),Padl((cAlias)->ADA_XNOMC, 12),Padl((cAlias)->ADA_LOJCLI, 2),Padl((cAlias)->ADA_NUMCTR, 7),	Padl((cAlias)->ADB_DESPRO, 10),Padl((cAlias)->ADB_QUANT, 9),Padl((cAlias)->QTD_FUT, 9),Padl((cAlias)->QTD_DEV_FUT, 9),Padl(nRest, 9),Padl((cAliasDEV)->qtd_dev_remessa, 9),Padl(QTDREST, 9),Padl("R$"+transform(nValFut,"@E 999,999,999.99"),16),Padl("R$"+transform((cAlias)->VLR_DEV_FUT,"@E 999,999,999.99"),16),Padl("R$"+transform(nValreM,"@E 999,999,999.99"),16),Padl("R$"+transform((cAliasDEV)->vlr_dev_remessa,"@E 999,999,999.99"),16),Padl("R$"+transform(nValres,"@E 999,999,999.99"),16)})
						endif
						//nNumero := SUBSTR((cAlias)->NUMERO,1,8)
						qCtr  += (cAlias)->ADB_QUANT
						qFut  += (cAlias)->QTD_FUT
						qDfut += (cAlias)->QTD_DEV_FUT
						qRem  += nRest
						qDrem += (cAliasDEV)->qtd_dev_remessa
						qRest += QTDREST
						vFut  += nValFut
						vDfut += (cAlias)->VLR_DEV_FUT
						vRem  += nValreM
						vDrem += (cAliasDEV)->vlr_dev_remessa
						vTotal+= nValres
				ENDIF
			ENDIF
			(cAlias)->(dbSkip())
			(cAliasREM)->(dbCloseArea())
			(cAliasDEV)->(dbCloseArea())
		EndDo

		nLin++
		cLin := SPACE(49)+"RESUMOS "+" |"+Padl(qCtr,9)  +  " |"  //Qtd ctr
		cLin += Padl(qFut,9)    +  " |"  //qtd futura
		cLin += Padl(qDfut,9)   +  " |"  //qtd devolvido futura
		cLin += Padl(qRem,9)    +  " |"  //qtd remessa
		cLin += Padl(qDrem,9)   +  " |"  //qtd dev remessa
		cLin += Padl(qRest,9)   +  " |"  //qtd restante
		cLin += Padl("R$"+transform(vFut,"@E 999,999,999.99"),16)    +  " |"  //total Futura
		cLin += Padl("R$"+transform(vDfut,"@E 999,999,999.99"),16)   +  " |"  //total Dev Futura
		cLin += Padl("R$"+transform(vRem,"@E 999,999,999.99"),16)    +  " |"  //total Remessa
		cLin += Padl("R$"+transform(vDrem,"@E 999,999,999.99"),16)   +  " |"  //total Dev Remessa
		cLin += Padl("R$"+transform(vTotal,"@E 999,999,999.99"),16)  +  " |"  //total Geral
		@nLin,03 PSAY cLin

		if mv_par12==1
			Aadd(aReg,{Padc("-" ,1) ,Padc("-" ,1) ,Padc("-" ,1) ,Padc("-" ,1) ,Padc("-" ,1) ,Padc("Resumos" ,7),Padl(qCtr,9),Padl(qFut,9),Padl(qDfut,9), Padl(qRem,9),Padl(qDrem,9),Padl(qRest,9),Padl("R$"+transform(vFut,"@E 999,999,999.99"),16),Padl("R$"+transform(vDfut,"@E 999,999,999.99"),16),Padl("R$"+transform(vRem,"@E 999,999,999.99"),16),Padl("R$"+transform(vDrem,"@E 999,999,999.99"),16),Padl("R$"+transform(vTotal,"@E 999,999,999.99"),16)})
		endif

		If mv_par12==1  
			U_Arr3Exc5(aReg)
		EndIf
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
Return ()

Static Function ToProcEx(aReg)
LOCAL cDirDocs   := MsDocPath() 
//Local aStru		:= {}
Local cArquivo := CriaTrab(,.F.)
Local cPath		:= AllTrim(GetTempPath())
Local oExcelApp
Local nHandle
Local cCrLf 	:= Chr(13) + Chr(10)
Local ii, i

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
