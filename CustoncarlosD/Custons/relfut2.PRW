#INCLUDE "rwmake.ch"

/*/ primeira versao
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณrelfut2  บ Autor ณCARLOS DANIEL บ Data ณ  29/05/15          บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ RELATORIO DE ENTREGA FUTURA .                              บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ 			                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User Function relfut2()


//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Declaracao de Variaveis                                             ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

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
	Private nomeprog   := "erc002fut" // Coloque aqui o nome do programa para impressao no cabecalho
	Private nTipo      := 18
	Private aReturn    := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
	Private nLastKey   := 0
	Private cPerg      := "erc002fut"
	//Private cbcont     := 00
	Private CONTFL     := 01
	Private m_pag      := 01
	Private wnrel      := "erc002fut" // Coloque aqui o nome do arquivo usado para impressao em disco
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
	PutSX1(cPerg , "09" , "Contrato Vend   	   " , "" , "" , "mv_ch9" , "C" , 6 , 0 , 0 , "G" , "", "", "", "", "mv_par09" , "        " ,"","","", "        " ,"","","", "        " , "" , "" , "" , "" , "" , "" , "" , "" )
	PutSX1(cPerg , "10" , "Contrato Vend  	   " , "" , "" , "mv_ch10" , "C" , 6 , 0 , 0 , "G" , "", "", "", "", "mv_par10" , "        " ,"","","", "   	  " ,"","","", "        " , "" , "" , "" , "" , "" , "" , "" , "" )
	PutSX1(cPerg , "11" , "Aceitar Vlr 0.	   " , "" , "" , "mv_ch11" , "N" , 1  , 0 , 1 , "C" , "", "", "", "", "mv_par11" , "(1)sim" ,"","","", "(2)nao" ,"","","", "        " , "" , "" , "" , "" , "" , "" , "" , "" )

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
//Local nNumero := "0"
//Local nOrdem  
	Local ntotal := 0
	Local vLrdes := 0
	Local vLrfre := 0
	Local nTValdev := 0
	Local nTValres := 0
	Local nTValpag := 0
	Local qTdped := 0
	Local qTdent := 0
	Local qTddev := 0
	Local qTdrest := 0
	Local vContra := 0
	//Local nCount := 0
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

	cQry += " SELECT * FROM "+RetSqlName("ADB") +" ADB
	cQry += " INNER JOIN "+RetSqlName("ADA") +" ADA ON ADA.ADA_NUMCTR = ADB.ADB_NUMCTR AND ADA.D_E_L_E_T_ <> '*'
	cQry += " AND ADA.ADA_FILIAL = ADB.ADB_FILIAL AND ADA.ADA_CODCLI = ADB.ADB_CODCLI
	cQry += " WHERE ADB.D_E_L_E_T_ <> '*'
	IF mv_par08 == 1  //PARA FUTURA ENTRA AQUI
		cQry += " AND ADB_TESCOB <> ' '
	ELSE   //PARA REMESSA/VENDA DIRETA AQUI
		cQry += " AND ADB_TESCOB = ' '
	ENDIF
	cQry += " AND ADB_CODCLI BETWEEN  '"+MV_PAR01+"' AND  '"+MV_PAR02+"'
	cQry += " AND ADB_LOJCLI BETWEEN  '"+MV_PAR03+"' AND  '"+MV_PAR04+"'
	cQry += " AND ADB_FILIAL BETWEEN  '"+MV_PAR05+"' AND  '"+MV_PAR06+"'
	cQry += " AND ADA_EMISSA <=  '"+DToS(MV_PAR07)+"'
	cQry += " AND ADA_XPED BETWEEN  '"+MV_PAR09+"' AND '"+MV_PAR10+"'
	cQry += " AND ADA_STATUS <> 'A' "
	cQry += " AND (SELECT SB1.B1_GRUPO FROM SB1010 SB1 WHERE sb1.d_e_l_e_t_ <> '*' AND ADB.ADB_CODPRO = SB1.B1_COD) <> '0082'
	cQry += " ORDER BY ADB_CODCLI
	DbUseArea(.T., "TOPCONN", TcGenQry(,, cQry), cAlias, .T., .T.)
	DbGotop()

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ SETREGUA -> Indica quantos registros serao processados para a regua ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	IF mv_par08 == 1

		SetRegua(RecCount())

		Cabec1 += Space(3)
		Cabec1 += Padc("FILIAL" ,6)	  			   	  	   			   	    + " |"
		Cabec1 += Padc("COD CLI." ,6)			   		    				+ " |"
		Cabec1 += Padc("NOME CLIENTE",12)	   	   	              		    + " |"
		Cabec1 += Padc("LJ",2)	   	   	              		                + " |"
		Cabec1 += Padc("PRODUTO",7)	   	   	              		            + " |"
		Cabec1 += Padc("DESCRICAO",10)	  	              		            + " |"
		Cabec1 += Padc("QTDPED",9)	   	   	              			      	+ " |"
		Cabec1 += Padc("QTDENT" ,9)	   	   						        	+ " |"
		Cabec1 += Padc("QTDEV",7)	   	   	              			      	+ " |"
		Cabec1 += Padc("QTDREST" ,9)	    	   						    + " |"
		Cabec1 += Padc("VLRVEND R$" ,16)			   	  	   			    + " |"
		Cabec1 += Padc("VLRDEV R$" ,16)	   	   						        + " |"
		Cabec1 += Padc("DESC ICMS - R$" ,16)			   	  	   			+ " |"
		Cabec1 += Padc("VLRFRET + R$" ,16)			   	  	   			    + " |"
		Cabec1 += Padc("VLRPG R$" ,16)			   	  	   			    	+ " |"
		Cabec1 += Padc("VLRREST R$" ,16)			   	  	   			    + " |"
		nPosQtd := Len(Cabec1)
		//Cabec1 += Padc("DATA EMISSรO",len(dtoc(stod((cAlias)->E5_DATA)))) + " | "
		Cabec1 += Padc("PEDIDO",6) 								   			+ " |"
		Cabec2 := Space(0)

		dbGoTop()
//While !EOF() 
		While (cAlias)->(!EOF())
			cQry := " SELECT C6_FILIAL, C6_CONTRAT, SUM(C6_QTDVEN) - SUM(NVL((SELECT D1_QUANT FROM "+RetSqlName("SD1") +" SD1 WHERE SD1.D1_FILIAL = C6_FILIAL 
			cQry += " AND SD1.D1_NFORI = C6_NOTA AND SD1.D1_SERIORI = C6_SERIE AND SD1.D1_TIPO = 'D' 
			cQry += " AND SD1.D1_EMISSAO <=  '"+DToS(MV_PAR07)+"' AND SD1.D_E_L_E_T_ <> '*' AND C6_NOTA <> '      ' AND ROWNUM = 1),0)) AS CARREGADO,
			cQry += " SUM(NVL((SELECT D1_QUANT FROM "+RetSqlName("SD1") +" SD1 WHERE SD1.D1_FILIAL = C6_FILIAL 
			cQry += " AND SD1.D1_NFORI = C6_NOTA AND SD1.D1_SERIORI = C6_SERIE AND SD1.D1_TIPO = 'D' 
			cQry += " AND SD1.D1_EMISSAO <=  '"+DToS(MV_PAR07)+"' AND SD1.D_E_L_E_T_ <> '*' AND C6_NOTA <> '      ' AND ROWNUM = 1),0)) AS QTD_DEV,
			cQry += " SUM(NVL((SELECT D1_TOTAL FROM "+RetSqlName("SD1") +" SD1 WHERE SD1.D1_FILIAL = C6_FILIAL 
			cQry += " AND SD1.D1_NFORI = C6_NOTA AND SD1.D1_SERIORI = C6_SERIE AND SD1.D1_TIPO = 'D' 
			cQry += " AND SD1.D1_EMISSAO <=  '"+DToS(MV_PAR07)+"' AND SD1.D_E_L_E_T_ <> '*' AND C6_NOTA <> '      ' AND ROWNUM = 1),0)) AS VLR_DEV
			cQry += " FROM "+RetSqlName("SC6") +" SC6
			cQry += " WHERE C6_CONTRAT = '"+(cAlias)->ADA_NUMCTR+"'
			cQry += " AND C6_TES not in  ('527','650')
			cQry += " AND C6_FILIAL = '"+(CALIAS)->ADB_FILIAL+"'
			cQry += " AND C6_DATFAT <=  '"+DToS(MV_PAR07)+"'
			cQry += " AND D_E_L_E_T_ <> '*'
			cQry += " AND (SELECT F4_ESTOQUE FROM SF4010 SF4 WHERE sf4.d_e_l_e_t_ <> '*' AND F4_CODIGO = C6_TES) = 'S'
			cQry += " AND (SELECT SB1.B1_GRUPO FROM SB1010 SB1 WHERE sb1.d_e_l_e_t_ <> '*' AND SC6.C6_PRODUTO = SB1.B1_COD) <> '0082'
			cQry += " GROUP BY C6_FILIAL, C6_CONTRAT
			DbUseArea(.T., "TOPCONN", TcGenQry(,, cQry), cAlias1, .T., .T.)
			DbGotop()

			dbselectarea("SC5")
			dbsetorder(1)
			dbseek((cALIAS)->ADB_FILIAL+(cAlias)->ADB_PEDCOB)
			

			cQry := " SELECT sum(d1_TOTAL) AS D1TOTAL, SUM(D1_QUANT) AS D1QUANT, SUM(D1_VALFRE) AS D1FRETE  FROM "+RetSqlName("SD1") +" SD1
			cQry += " WHERE SD1.D1_FILIAL = '"+(cALIAS)->ADB_FILIAL+"'
				//verifica se existe a nota
			If SC5->C5_NOTA <> "         "
				cQry += " AND SD1.D1_NFORI = '"+SC5->C5_NOTA+"'
			else
				cQry += " AND SD1.D1_NFORI = '0'
			EndIf
			cQry += " AND SD1.D1_SERIORI = '"+SC5->C5_SERIE+"'
			cQry += " AND SD1.D1_TIPO = 'D'
			cQry += " AND SD1.D1_EMISSAO <=  '"+DToS(MV_PAR07)+"'
			cQry += " AND SD1.D_E_L_E_T_ <> '*'
			DbUseArea(.T., "TOPCONN", TcGenQry(,, cQry), cAlias2, .T., .T.)
			DbGotop()
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
			dbselectarea("SD2")
			dbsetorder(8)
			dbseek(xfilial("SD2")+(cAlias)->ADB_PEDCOB+'01')

			If (cAlias)->ADB_PEDCOB <> ' '
				vLrdesc := SC5->C5_descont //desconto verificar
			EndIf
	 /*
	dbselectarea("SE1") 
	dbsetorder(1)                                                                                                                                  
	dbSeek(xfilial("SE1")+SD2->D2_SERIE+SD2->D2_DOC) 
	
	IF DToS(SE1->E1_BAIXA) <= DToS(MV_PAR07)
		nValres := (SE1->E1_VALOR-SE1->E1_SALDO)
	ELSE
		nValres := SE1->E1_VALOR
	ENDIF
	 */
			IF !Empty((cAlias2)->D1QUANT) //(cAlias2)->D1_DOC <> ' '
				nValdev := (cAlias2)->D1TOTAL
				cQtddev := (cAlias2)->D1QUANT
				//vLrdesc := SD2->D2_DESCON//(cAlias2)->D1_VALDESC
				vLrfret := (cAlias2)->D1FRETE
			ELSE
				nValdev := 0+(cAlias1)->VLR_DEV
				cQtddev := 0+(cAlias1)->QTD_DEV
				//vLrdesc := SD2->D2_DESCON// 0 alterado
				vLrfret := 0
			ENDIF
			//vLrdesc := SD2->D2_DESCON //desconto
			vContra := (((cAlias)->ADB_TOTAL)-vLrdesc)
			If (cAlias1)->QTD_DEV > 0
				nRest := (((cAlias)->ADB_QUANT-(cAlias1)->CARREGADO))
				nValres := (((vContra/(cAlias)->ADB_QUANT)*nRest))
			Else
				nRest := (((cAlias)->ADB_QUANT-(cAlias1)->CARREGADO)-cQtddev)
				nValres := (((vContra/(cAlias)->ADB_QUANT)*nRest))
			EndIf
			nValpag := ((vContra)-nValres)

			IF mv_par11 == 1
				//cBXATI := dtoc(stod((cAlias)->E5_DATA))
				nLin++   //pula pra linha debaixo
				cLin := 0
				cLin := Padl((cAlias)->ADA_FILIAL, 6)    	       							   	     	+  " |" //FILIAL
				cLin += Padl((cAlias)->ADA_CODCLI, 6)     		   							        	+  " |" // CODIGO CLIENTE
				cLin += Padl((cAlias)->ADA_XNOMC, 12)      									         	+  " |"  // NOME CLIENTE
				cLin += Padl((cAlias)->ADA_LOJCLI, 2)      									        	+  " |"  // LOJA CLIENTE
				cLin += Padl((cAlias)->ADB_CODPRO, 7)      									      	    +  " |"  // PRODUTO
				cLin += Padl((cAlias)->ADB_DESPRO, 10)      									      	+  " |"  //DESCRICAO PRODUTO
				//cLin += Padl("R$"+transform((cAlias)->ADB_PRCVEN,"@E 999,999,999.99"),16) 		    +  " |" // PREวO VENDA UNITARIO
				cLin += Padl((cAlias)->ADB_QUANT, 9)      								     	        +  " |"  // QUANTIDADE VENDIDA
				cLin += Padl((cAlias1)->CARREGADO, 9)     	 								     	    +  " |"  //  QUANTIDADE ENTREGUE
				cLin += Padl(cQtddev, 7)            								     	            +  " |"  // QUANTIDADE DEVOLVIDA
				cLin += Padl(nRest, 9)                  								     	        +  " |"  // QTD RESTANTE ENTREGAR
				//cLin += Padl("R$"+transform((cAlias)->ADB_TOTAL,"@E 999,999,999.99"),16) 	
				cLin += Padl("R$"+transform(vContra,"@E 999,999,999.99"),16) 							+  " |" // VALOR VENDA
				cLin += Padl("R$"+transform(nValdev,"@E 999,999,999.99"),16) 					        +  " |" // VALOR DEVOLVIDO
				cLin += Padl("R$"+transform(vLrdesc,"@E 999,999,999.99"),16)			 		        +  " |" //	VALOR DESCONTO
				cLin += Padl("R$"+transform(vLrfret,"@E 999,999,999.99"),16)			 		        +  " |" //	VALOR FRETE
				cLin += Padl("R$"+transform(nValpag,"@E 999,999,999.99"),16)			 		        +  " |" //	VALOR pago
				cLin += Padl("R$"+transform(nValres,"@E 999,999,999.99"),16)			 		        +  " |" //	VALOR RESTANTE
				cLin += Padl((cAlias)->ADA_NUMCTR, 6)      								     	        +  " |"  //  PEDIDO VENDEDOR
				//cLin += dtoc(stod((cAlias)->E5_DATA))	                                            +  " | " //DATA COMPRA

				@nLin,03 PSAY cLin
				nLin++  //pula pra linha debaixo
				//nNumero := SUBSTR((cAlias)->NUMERO,1,8)
				ntotal += vContra
				vLrdes := vLrdesc 
				vLrfre := vLrfret
				nTValdev += nValdev
				nTValres += nValres
				nTValpag += nValpag
				qTdped += (cAlias)->ADB_QUANT
				qTdent += (cAlias1)->CARREGADO
				qTddev += cQtddev
				qTdrest += nRest

			ELSE
				IF nValres <> 0
					//cBXATI := dtoc(stod((cAlias)->E5_DATA))
					nLin++   //pula pra linha debaixo
					cLin := 0
					cLin := Padl((cAlias)->ADA_FILIAL, 6)    	       							   	     	+  " |" //FILIAL
					cLin += Padl((cAlias)->ADA_CODCLI, 6)     		   							        	+  " |" // CODIGO CLIENTE
					cLin += Padl((cAlias)->ADA_XNOMC, 12)      									         	+  " |"  // NOME CLIENTE
					cLin += Padl((cAlias)->ADA_LOJCLI, 2)      									        	+  " |"  // LOJA CLIENTE
					cLin += Padl((cAlias)->ADB_CODPRO, 7)      									      	    +  " |"  // PRODUTO
					cLin += Padl((cAlias)->ADB_DESPRO, 10)      									      	+  " |"  //DESCRICAO PRODUTO
					//cLin += Padl("R$"+transform((cAlias)->ADB_PRCVEN,"@E 999,999,999.99"),16) 		    +  " |" // PREวO VENDA UNITARIO
					cLin += Padl((cAlias)->ADB_QUANT, 9)      								     	        +  " |"  // QUANTIDADE VENDIDA
					cLin += Padl((cAlias1)->CARREGADO, 9)     	 								     	    +  " |"  //  QUANTIDADE ENTREGUE
					cLin += Padl(cQtddev, 7)            								     	            +  " |"  // QUANTIDADE DEVOLVIDA
					cLin += Padl(nRest, 9)                  								     	        +  " |"  // QTD RESTANTE ENTREGAR
					cLin += Padl("R$"+transform((cAlias)->ADB_TOTAL,"@E 999,999,999.99"),16) 				+  " |" // VALOR VENDA
					cLin += Padl("R$"+transform(nValdev,"@E 999,999,999.99"),16) 					        +  " |" // VALOR DEVOLVIDO
					cLin += Padl("R$"+transform(vLrdesc,"@E 999,999,999.99"),16)			 		        +  " |" //	VALOR DESCONTO
					cLin += Padl("R$"+transform(vLrfret,"@E 999,999,999.99"),16)			 		        +  " |" //	VALOR FRETE
					cLin += Padl("R$"+transform(nValpag,"@E 999,999,999.99"),16)			 		        +  " |" //	VALOR pago
					cLin += Padl("R$"+transform(nValres,"@E 999,999,999.99"),16)			 		        +  " |" //	VALOR RESTANTE
					cLin += Padl((cAlias)->ADA_NUMCTR, 6)      								     	        +  " |"  //  PEDIDO VENDEDOR
					//cLin += dtoc(stod((cAlias)->E5_DATA))	                                            +  " | " //DATA COMPRA

					@nLin,03 PSAY cLin
					nLin++  //pula pra linha debaixo
					//nNumero := SUBSTR((cAlias)->NUMERO,1,8)
					ntotal += vContra
					vLrdes := vLrdesc
					vLrfre := vLrfret
					nTValdev += nValdev
					nTValres += nValres
					nTValpag += nValpag
					qTdped += (cAlias)->ADB_QUANT
					qTdent += (cAlias1)->CARREGADO
					qTddev += cQtddev
					qTdrest += nRest
				ENDIF
			ENDIF
			(cAlias)->(dbSkip())
			(cAlias1)->(dbCloseArea())
			(cAlias2)->(dbCloseArea())
		EndDo

		nLin++
		cLin := SPACE(45)+"RESUMOS "+" |"+Padl(qTdped,9)  +  " |"  //Qtd compra
		cLin += Padl(qTdent,9)  +  " |"  //qtd entregue
		cLin += Padl(qTddev,7)  +  " |"  //qtd devolvido
		cLin += Padl(qTdrest,9)  +  " |"  //qtd restante
		cLin += Padl("R$"+transform(ntotal,"@E 999,999,999.99"),16)    +  " |"  //total val dev
		cLin += Padl("R$"+transform(nTValdev,"@E 999,999,999.99"),16)  +  " |"  //total val dev
		cLin += Padl("R$"+transform(vLrdes,"@E 999,999,999.99"),16)  +  " |"  //total val dev
		cLin += Padl("R$"+transform(vLrfre,"@E 999,999,999.99"),16)  +  " |"  //total val dev
		cLin += Padl("R$"+transform(nTValpag,"@E 999,999,999.99"),16)  +  " |"  //total pago
		cLin += Padl("R$"+transform(nTValres,"@E 999,999,999.99"),16)  +  " |"  //total rest
		@nLin,03 PSAY cLin


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

	ELSE
		Return()
	ENDIF
