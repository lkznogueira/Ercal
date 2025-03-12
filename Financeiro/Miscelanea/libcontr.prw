#INCLUDE 'Protheus.ch'
#INCLUDE 'TOPConn.ch'
#INCLUDE 'Rwmake.ch'
#include "TbiConn.ch"
#include "TbiCode.ch"
#DEFINE ENTER Chr(13)+Chr(10)

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  |libcontr     ³Autor ³ Carlos Daniel              |Data ³ 25/05/23 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri?ao | Esse programa tem função de liberar contrato de parceria         ³±±
±±³			 |                                                  				³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³  Nil                                                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Ercal/Britacal                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ*/

User Function libcontr() 
Private cIdent
Private cEdit1 := Date()
Private cEdit2 := Date()

u_dDatap(cEdit1,cEdit2)

MsgRun(("Aguarde..."+Space(1)+"Criando Interface"),"Aguarde...",{|| MontaTel() } )

Return Nil

Static Function SelCor(clStatus)

Local olCor := NIL

Do Case
	// STATUS = PROCESSADA PELO PROTHEUS
	Case clStatus == '1' .or. clStatus == ' '
		olCor:=LoadBitmap(GetResources(),'BR_VERDE')
	Case clStatus == '2' 
		olCor:=LoadBitmap(GetResources(),'BR_PRETO')
	OtherWise
		olCor:=LoadBitmap(GetResources(),'BR_VERMELHO')
EndCase
Return olCor 

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun??o    | MontHdr    ³Autor  ³Carlos Daniel       |Data  ³25/05/23         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri??o |Funcao monta o aHeader do browse principal com os itens da ADA    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ alHdRet = Array com o nome dos campos selecionados no dicionario ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MontaTel	                                                        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ*/
Static Function MontHdr()//nao usa mais
// monta nomes dos campos dentro da sx3 Ercal
Local alHdRet := {}

aAdd(alHdRet,"ADA_FILIAL")
//aAdd(alHdRet,"ADA_CODCLI")
dbSelectArea("SX3")
DbSetOrder(1)
dbGoTop()
SX3->(DbSeek("ADA"))

While !EOF() .AND. SX3->X3_ARQUIVO == "ADA"
	If ( X3USO(SX3->X3_USADO) .And. cNivel >= SX3->X3_NIVEL )
		Aadd(alHdRet,SX3->X3_CAMPO)
	EndIf
	DbSkip()
EndDo
//aAdd(alHdRet,"ADA_FILIAL")

Return alHdRet

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÂÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun??o    | CarItens(alHdr,alParam)³Autor|Carlos Daniel    |Data³ 25/05/23³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÁÄÄÄÄÄÄÄÄÄ´±±
±±³Descri??o | Funcao verifica os itens a carregar no browse perante os campos  ³±±
±±³          | e parametro.							                            ³±±
±±³          | Adciona os registro em um array (alRet) que e usado como retorno ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³alHdr   := Array com os campos do browse                          ³±±
±±³          |alParam := Array com os possiveis parametros, sendo as posicoes   ³±±
±±³          | [1]-{1 , " " } // 1 - Liberado				      			    ³±±
±±³          | [2]-{2 , "P" } // 2 - Processada pelo Protheus				    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ alRet = Array contendo os registros                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ AtuBrw	                                                        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ*/

Static Function CarItens(_alHdr,alParam)
//tras itens que tem filtro
Local alRet     := {}
Local cQuery	:= ""
Local cLimit   //limite liberar contrato
If cFilAnt == '4600'
	cLimit    := "0"
ElseIf cEmpAnt == '50'
	cLimit    := "0"
Else
	cLimit    := "100"
EndIf
//aadd(alHdRet, { TMP->ADA_FILIAL, TMP->ADA_NUMCTR, TMP->ADA_CODCLI, TMP->ADA_LOJCLI, TMP->ADA_XNOMC, TMP->CGC, TMP->PENDENCIA, TMP->CREDITO, TMP->ADB_CODPRO, TMP->ADB_QUANT, TMP->ADB_PRCVEN, TMP->ADB_TOTAL, StoD(TMP->ADA_EMISSA), .F.})
If cEmpAnt == '50'
	cQuery := "select ADA_FILIAL, ADA_NUMCTR, ADA_CODCLI, ADA_XLIBFI, ADA_LOJCLI, ADA_XNOMC,ADA_XUSERL,"
	cQuery += "CASE ADA_XDTAPR  WHEN ' ' THEN ' ' ELSE to_char((to_date(ADA_XDTAPR,'yyyymmdd')), 'dd/mm/YYYY') END ADA_XDTAPR,"
	cQuery += " (SELECT E4_DESCRI FROM "+ RetSqlName("SE4") + "  SE4 WHERE se4.d_e_l_e_t_ <> '*' AND ADA_CONDPG = E4_CODIGO) AS CONDPG,"
	cQuery += " (SELECT A1_CGC FROM SA1500 SA1 WHERE sa1.d_e_l_e_t_ <> '*' AND A1_COD = ADA_CODCLI AND A1_LOJA = ADA_LOJCLI) AS CGC,"
	cQuery += " (SELECT SUM(E1_SALDO) FROM "+ RetSqlName("SE1") + " SE1 WHERE SE1.d_e_l_e_t_ <> '*' AND e1_saldo > 0 AND e1_cliente = ADA_CODCLI AND E1_TIPO NOT IN ('RA','NCC') )PENDENCIA,"
	cQuery += " (SELECT SUM(E1_SALDO) FROM "+ RetSqlName("SE1") + " SE1 WHERE SE1.d_e_l_e_t_ <> '*' AND e1_saldo > 0 AND e1_cliente = ADA_CODCLI AND E1_TIPO IN ('RA','NCC') )CREDITO,"
	cQuery += " CASE"
	cQuery += " WHEN"
	cQuery += " (SELECT E1_XNEG"
	cQuery += " FROM SE1500 SE1"
	cQuery += " WHERE se1.d_e_l_e_t_ <> '*'"
	cQuery += " AND  E1_CLIENTE = ADA_CODCLI"
	cQuery += " AND E1_SALDO > 0"
	//cQuery += " and e1_xneg = '1'"
	cQuery += " group by e1_xneg, e1_cliente)"
	//(SELECT E1_XNEG FROM "+ RetSqlName("SE1") + " SE1 WHERE se1.d_e_l_e_t_ <> '*' AND ADA_CODCLI = E1_CLIENTE AND E1_SALDO > 0 and e1_xneg = '1' and rownum = 1 ) 
	cQuery += " = '1' THEN 'SIM'" 
	cQuery += " ELSE 'NÃO'"
	cQuery += " END AS RENEGOCIADO,"
	cQuery += " ADB_CODPRO, ADB_QUANT, ADB_PRCVEN, ADB_TOTAL, ADA_EMISSA"
	cQuery += " from " + RetSqlName("ADA") + " ADA, "+ RetSqlName("ADB") + " ADB"
	cQuery += " where ADA_NUMCTR = ADB_NUMCTR"
	cQuery += " AND ADA_FILIAL = ADB_FILIAL"
	cQuery += " AND ADB_ITEM = '01'"
	cQuery += " AND ADA_FILIAL = '"+xfilial("ADA")+"'"
	cQuery += " And ADA_EMISSA BETWEEN '"+dToS(cedit1)+"' AND '"+dToS(cedit2)+"' "
	//cQuery += " And ADA_MSBLQL = '1'"
	//cQuery += " And ADA_XLIBFI <> '1'"
	cQuery += " AND ADB_TOTAL > "+cLimit+""
	cQuery += " and ADA.d_e_l_e_t_ <> '*'"
	cQuery += " and ADB.d_e_l_e_t_ <> '*'"
Else
	cQuery := "select ADA_FILIAL, ADA_NUMCTR, ADA_CODCLI, ADA_XLIBFI, ADA_LOJCLI, ADA_XUSERL,"
	cQuery += "CASE ADA_XDTAPR  WHEN ' ' THEN ' ' ELSE to_char((to_date(ADA_XDTAPR,'yyyymmdd')), 'dd/mm/YYYY') END ADA_XDTAPR,ADA_XNOMC,"
	cQuery += " (SELECT E4_DESCRI FROM SE4010 SE4 WHERE se4.d_e_l_e_t_ <> '*' AND ADA_CONDPG = E4_CODIGO) AS CONDPG,"
	cQuery += " (SELECT A1_CGC FROM SA1010 SA1 WHERE sa1.d_e_l_e_t_ <> '*' AND A1_COD = ADA_CODCLI AND A1_LOJA = ADA_LOJCLI) AS CGC,"
	cQuery += " (SELECT SUM(E1_SALDO) FROM "+ RetSqlName("SE1") + " SE1 WHERE SE1.d_e_l_e_t_ <> '*' AND e1_saldo > 0 AND e1_cliente = ADA_CODCLI AND E1_TIPO NOT IN ('RA','NCC') )PENDENCIA,"
	cQuery += " (SELECT SUM(E1_SALDO) FROM "+ RetSqlName("SE1") + " SE1 WHERE SE1.d_e_l_e_t_ <> '*' AND e1_saldo > 0 AND e1_cliente = ADA_CODCLI AND E1_TIPO IN ('RA','NCC') )CREDITO,"
	cQuery += " CASE"
	cQuery += " WHEN"
	cQuery += " (SELECT E1_XNEG"
	cQuery += " FROM SE1010 SE1"
	cQuery += " WHERE se1.d_e_l_e_t_ <> '*'"
	cQuery += " AND  E1_CLIENTE = ADA_CODCLI"
	cQuery += " AND E1_SALDO > 0 and rownum = 1"
	//cQuery += " and e1_xneg = '1'"
	cQuery += " union"
	cQuery += " SELECT E1_XNEG"
	cQuery += " FROM SE1020 SE1"
	cQuery += " WHERE se1.d_e_l_e_t_ <> '*'"
	cQuery += " AND  E1_CLIENTE = ADA_CODCLI"
	cQuery += " AND E1_SALDO > 0 and rownum = 1"
	//cQuery += " and e1_xneg = '1'"
	cQuery += " union"
	cQuery += " SELECT E1_XNEG"
	cQuery += " FROM SE1060 SE1"
	cQuery += " WHERE se1.d_e_l_e_t_ <> '*'"
	cQuery += " AND  E1_CLIENTE = ADA_CODCLI"
	cQuery += " AND E1_SALDO > 0 and rownum = 1"
	//cQuery += " and e1_xneg = '1'"
	cQuery += " group by e1_xneg, e1_cliente)"
	//(SELECT E1_XNEG FROM "+ RetSqlName("SE1") + " SE1 WHERE se1.d_e_l_e_t_ <> '*' AND ADA_CODCLI = E1_CLIENTE AND E1_SALDO > 0 and e1_xneg = '1' and rownum = 1 ) 
	cQuery += " = '1' THEN 'SIM'" 
	cQuery += " ELSE 'NÃO'"
	cQuery += " END AS RENEGOCIADO,"
	cQuery += " ADB_CODPRO, ADB_QUANT, ADB_PRCVEN, ADB_TOTAL, ADA_EMISSA"
	cQuery += " from " + RetSqlName("ADA") + " ADA, "+ RetSqlName("ADB") + " ADB"
	cQuery += " where ADA_NUMCTR = ADB_NUMCTR"
	cQuery += " AND ADA_FILIAL = ADB_FILIAL"
	cQuery += " AND ADB_ITEM = '01'"
	cQuery += " AND ADA_FILIAL = '"+xfilial("ADA")+"'"
	//cQuery += " And ADA_EMISSA BETWEEN '"+dToS(cedit1)+"' AND '"+dToS(cedit2)+"' "
	//cQuery += " And ADA_MSBLQL = '1'"
	//cQuery += " And ADA_XLIBFI <> '1'"
	cQuery += " AND (ADB_QUANT > "+cLimit+" OR 
	//(SELECT E1_XNEG FROM "+ RetSqlName("SE1") + " SE1 WHERE se1.d_e_l_e_t_ <> '*' AND ADA_CODCLI = E1_CLIENTE AND E1_SALDO > 0 and e1_xneg = '1' and rownum = 1) 
	cQuery += " (SELECT E1_XNEG"
	cQuery += " FROM SE1010 SE1"
	cQuery += " WHERE se1.d_e_l_e_t_ <> '*'"
	cQuery += " AND  E1_CLIENTE = ADA_CODCLI"
	cQuery += " AND E1_SALDO > 0"
	cQuery += " and e1_xneg = '1'"
	cQuery += " union"
	cQuery += " SELECT E1_XNEG"
	cQuery += " FROM SE1020 SE1"
	cQuery += " WHERE se1.d_e_l_e_t_ <> '*'"
	cQuery += " AND  E1_CLIENTE = ADA_CODCLI"
	cQuery += " AND E1_SALDO > 0"
	cQuery += " and e1_xneg = '1'"
	cQuery += " union"
	cQuery += " SELECT E1_XNEG"
	cQuery += " FROM SE1060 SE1"
	cQuery += " WHERE se1.d_e_l_e_t_ <> '*'"
	cQuery += " AND  E1_CLIENTE = ADA_CODCLI"
	cQuery += " AND E1_SALDO > 0"
	cQuery += " and e1_xneg = '1'"
	cQuery += " group by e1_xneg, e1_cliente) = '1')"
	cQuery += " and ADA.ADA_EMISSA BETWEEN '"+dToS(cedit1)+"' AND '"+dToS(cedit2)+"'"
	cQuery += " and ADA.d_e_l_e_t_ <> '*'"
	cQuery += " and ADB.d_e_l_e_t_ <> '*'"
EndIf
MemoWrite("C:\TEMP\cQuery.txt",cQuery)

If select("TMP") <> 0
	TMP->(DbcloseArea())
Endif
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"TMP",.T.,.T.)

If TMP->(eof())

    MsgAlert("Não foram encontrados contratos com este filtro.","Atenção !!!")
	aadd(alRet, {" ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " "," "," "})
EndIf

TMP->(DbGoTop())
    //aNewCols        := {}
while !TMP->(eof()) 
    aadd(alRet, {TMP->ADA_XLIBFI,TMP->RENEGOCIADO, TMP->ADA_NUMCTR, TMP->ADA_CODCLI, TMP->ADA_LOJCLI, TMP->ADA_XNOMC, TMP->CGC, TMP->ADB_CODPRO, TMP->ADB_QUANT, TMP->ADB_PRCVEN, TMP->ADB_TOTAL, TMP->CONDPG, StoD(TMP->ADA_EMISSA), trim(TMP->ADA_XUSERL),trim(TMP->ADA_XDTAPR)})
    TMP->(dbskip())
enddo

Return alRet


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun??o    | MontaTel   ³Autor ³ Carlos Daniel               |Data ³ 25/05/23 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ clRaiz = Diretorio/Local arquivos raiz                           ³±±
±±³          | clDest = Diretorio/Local arquivos lidos                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ NIL                                                              ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ*/
Static Function MontaTel()
Local alSize    	:= MsAdvSize()
Local cTCFilterEX	:= "TCFilterEX"
Local alHdCps 		:= {}
Local alHdSize      := {}
Local alCpos        := {}
Local alItBx        := {}
Local alParam       := {}
Local alCpHd        := {"Status","RENEGOCIADO","ADA_NUMCTR","ADA_CODCLI","ADA_LOJCLI","ADA_XNOMC","A1_CGC","ADB_CODPRO","ADB_QUANT","ADB_PRCVEN","ADB_TOTAL","ADA_CONDPG","ADA_EMISSA","ADA_XUSERL","ADA_XDTAPR"}//MontHdr() // PEGA titulo
Local clLine        := ""
Local clLegenda     := ""
Local nlTl1     	:= alSize[1]//0
Local nlTl2    		:= alSize[2] //30
Local nlTl3    		:= alSize[1]+450
Local nlTl4     	:= alSize[2]+790
Local nlCont        := 0
//Local nlPosCFil     := 0
Local nlPosCCtr     := 0
Local nlPosCCli      := 0
Local nlPosCLjc      := 0
Local olLBox    	:= NIL
Local olBtLeg       := NIL
Local olBtAnex      := NIL
Local olBtPos       := NIL
//Local cContra
Private _opDlgPcp	:= NIL
Private opBtVis     := NIL
Private opBtImp     := NIL
Private opBtPed     := NIL
Private opBtEst		:= NIL
Private cIdEnt
Private lChkBoxClass


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Array alParam recebe parametros para filtro           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aAdd(alParam,{1 , " " }) // 1 - Liberado 
aAdd(alParam,{2 , "P" }) // 2 - Processada pelo Protheus
// tras dados sx3 campo
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta o Header com os titulos do TWBrowse             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("SX3")
dbSetOrder(2)
For nlCont	:= 1 to Len(alCpHd)
	If MsSeek(alCpHd[nlCont]) .or. alCpHd[nlCont] == "RENEGOCIADO" .or. alCpHd[nlCont] == "Status"
		If alCpHd[nlCont] == "Status"
			AADD(alHdCps,"Status")
			AADD(alHdSize,1)
		ElseIf alCpHd[nlCont] == "RENEGOCIADO" // entrou aqui primeiro RENEGOCIADO
			AADD(alHdCps,"NEG")
			AADD(alHdSize,3)
		Else
			AADD(alHdCps,AllTrim(X3Titulo())) // cai aqui 
			AADD(alHdSize,Iif(nlCont==1,200,CalcFieldSize(SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_PICTURE,X3Titulo())))
		EndIf
		AADD(alCpos,{AllTrim(X3Titulo()),SX3->X3_CAMPO,SX3->X3_TIPO,SX3->X3_CONTEXT,SX3->X3_PICTURE})
	EndIf
	
Next nlCont

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as posicoes/ordens dos campos no array       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//nlPosCFil := Ascan(alCpos,{|x|Alltrim(X[2])=="ADA_FILIAL"}) //0
nlPosCCtr := Ascan(alCpos,{|x|Alltrim(X[2])=="ADA_NUMCTR"}) //3
nlPosCCli  := Ascan(alCpos,{|x|Alltrim(X[2])=="ADA_CODCLI"}) //4
nlPosCLjc  := Ascan(alCpos,{|x|Alltrim(X[2])=="ADA_LOJCLI"}) //5
//nlPosCHNF := Ascan(alCpos,{|x|Alltrim(X[2])=="ADA_LOJCLI"})


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Colunas da ListBox/TWBrowse                                				³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//clLine := "{|| {"
//status := ADA_LOJCLI
clLine := "{|| {SelCor(alItBx[olLBox:nAt,1]) ,"
For nlCont:=1 To Len(alCpos) // tem que entrar em cada registro
	If nlCont <> 1
		clLine += "alItBx[olLBox:nAt,"+AllTrim(Str(nlCont))+"]"+IIf(nlCont<Len(alCpos),",","")
	EndIf
Next nX
clLine += "}}" //verifica se logou em cada registro


// ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
// | Monta Legenda  |
// ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
clLegenda := "BrwLegenda('NULO1','Legenda' ,{{'BR_VERDE'    ,'APROVADO'}";
+" ,{'BR_VERMELHO' ,'NULO2'}";
+" ,{'BR_PRETO' ,'BLOQUEADO'}";
+" })"

//cIdEnt := GetIdEnt()
//cIdEnt := U_ACOMP006()

nlTl1 := 0.00
nlTl2 := 0.00
nlTl3 := 500 //altura tela
nlTl4 := 1450 //largura tela

DEFINE MSDIALOG _opDlgPcp TITLE "Contratos não Liberados" From nlTl1,nlTl2 to nlTl3,nlTl4 PIXEL

// ÚÄÄÄÄÄÄÄÄÄÄÄÄ¿
// |  BOTOES    |
// ÀÄÄÄÄÄÄÄÄÄÄÄÄÙ
//cContra := ADA->ADA_NUMCTR
// Selec. Pedido
opBtPed := TButton():New(nlTl1+210,alSize[2],"LIBERAR",_opDlgPcp,{||BlqCtr(alItBx[olLBox:nAt,nlPosCCtr] ,;				// | Contrato
alItBx[olLBox:nAt,nlPosCCli ] ,;			// | Cliente
alItBx[olLBox:nAt,nlPosCLjc]),;				//loja
(olLBox:=AtuBrw(olLBox,alItBx,clLine,alCpos,alParam))} ;//atualiza browser
,050,014,,,,.T.  )

olBtAnex := TButton():New(nlTl1+210,alSize[2]+447,"Anexos",_opDlgPcp, {|| U_aNex(alItBx[olLBox:nAt,nlPosCCtr]) } ,050,014,,,,.T.  )

//Consulta posicao cliente
olBtPos := TButton():New(nlTl1+210,alSize[2]+504,"Consultar",_opDlgPcp,{|| cCons(	alItBx[olLBox:nAt,nlPosCCli ] ,;			// | Cliente
alItBx[olLBox:nAt,nlPosCLjc])} ;			// | Loja
,050,014,,,,.T.  )

// Atualizar tela
olBtLeg := TButton():New(nlTl1+210,alSize[2]+561,"Atualizar Tela",_opDlgPcp, {|| (olLBox:=AtuBrw(olLBox,alItBx,clLine,alCpos,alParam)) } ,050,014,,,,.T.  )
// Visualizar Anexos
// Sair / Fechar
@ (nlTl1+210),(alSize[2]+618) BUTTON "Sair" SIZE 60,14 OF _opDlgPcp PIXEL ACTION Eval({|| DbSelectArea("ADA"), &cTCFilterEX.("",1), _opDlgPcp:END()})

// ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
// | TW BROWSE - CONTRA  |
// ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
&cTCFilterEX.("",1)
//olLBox := TwBrowse():New(nlTl1+05,nlTl2+05,nlTl3+093,nlTl4-1010,,alHdCps,alHdSize,_opDlgPcp,,,,,{|| U_aNex(alItBx[olLBox:nAt,nlPosCCtr]) } ,,,,,,,.F.,,.T.,,.F.,,,)
olLBox := TwBrowse():New(nlTl1+05,nlTl2+05,nlTl4+090,190,,alHdCps,alHdSize,_opDlgPcp,,,,,{|| U_aNex(alItBx[olLBox:nAt,nlPosCCtr]) } ,,,,,,,.F.,,.T.,,.F.,,,)
olLBox := AtuBrw(olLBox,alItBx,clLine,alCpos,alParam)
//olLBox:BChange:= Iif(!Empty(olLBox:aArray), {|| AtuBtn(olLBox:aArray[olLBox:nAt,1]) } , {|| olLBox:Refresh()  } )

ACTIVATE DIALOG _opDlgPcp CENTERED //finalizou aqui Ercal

Return NIL

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun??o    | AtuBtn     ³Autor ³ Carlos Daniel                 |Data ³ 25/05/23 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri?ao | Atualiza botoes na mudanca de registro. Se o status for          ³±±
±±³          | P = Processada Desabilita os botoes de Selecionar Pedido, 		³±±
±±³			 | Ver. Schema e Importar.											³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ clStatus = Status do registro selecioado                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ NIL                                                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MontaTel	                                                        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ*/
Static Function AtuBtn(clStatus)//nao usa

If (clStatus$"P")
	opBtPed:Disable()
	opBtImp:Disable()
Else
	opBtPed:Enable()
	opBtImp:Enable()
EndIf
Return Nil
/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun??o    | AtuBrw     ³Autor ³ Carlos Daniel                 |Data ³ 25/05/23 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri?ao | Atualiza a tela apos gerar pre nota                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ olLBox  = Objeto do TwBrowse (ListBOx)                           ³±±
±±³          | alItBx  = Array contendo os itens do ListBox                     ³±±
±±³          | clLine  = String do BLoco de Codigo bLine                        ³±±
±±³          | alCpos  = Campos exibidos no ListBox                             ³±±
±±³          | alParam = Array com informacoes do filtro                        ³±±
±±³          |           [ 1 ] - Parametro escolhido                            ³±±
±±³          |           [ 2 ] - String para sua representacao Exemplo: "T"     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ olLBox = ListBox atualizado                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ FiltraBrw, MontaTel                                              ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ*/
Static Function AtuBrw(olLBox,alItBx,clLine,alCpos,alParam)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Carrega o array com as informacoes dos registros      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
alItBx:=CarItens(alCpos, alParam) //chegou aqui busca itens Ercal

olLBox:SetArray(alItBx)
olLBox:bLine := Iif(!Empty(alItBx),&clLine, {|| Array(Len(alCpos))} )
If EmpTy(olLBox:aArray)
	opBtPed:Disable()
	opBtVis:Disable()
	opBtImp:Disable()
EndIf

Return olLBox

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun??o    | BlqCtr    ³Autor ³ Carlos Daniel               |Data ³ 25/05/23 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri?ao | Monta tela para selecao do pedido                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ clCodFor  = Cod. Fornec./Cli.                                    ³±±
±±³          | clLoja    = Loja                                                 ³±±
±±³          | clNota    = Num. Nota                                            ³±±
±±³          | clSerie   = Serie da Nota                                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ NIL                                                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MontaTel	                                                        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ*/
Static Function BlqCtr(cContr,cCli,cLoja)
Local nOpc := 2
Local lCnt
Local cBanco
Local cConpg
Local cUsra  := RetCodUsr()

dbSelectArea("ADA")
ADA->(dbSetOrder(1))
ADA->(dbSeek(xFilial("ADA")+cContr))

dbSelectArea("ADB")
ADB->(dbSetOrder(1))
ADB->(dbSeek(xFilial("ADB")+cContr))

SA1->(dbSetOrder(1))
SA1->(dbSeek(xFilial("SA1")+cCli+M->cLoja))

//Ajuste Aprovação CTR
DbSelectArea("ZZA")
ZZA->(dbSetOrder(1))
ZZA->(dbSeek(xFilial("ZZA")+cUsra))

	cBanco := trim(ADA->ADA_XBANCO)
	cConpg := trim(ADA->ADA_CONDPG)
	//lCnt := u_xBlqCtr(cBanco,cConpg)
	//validacao se for rotina de liberacao ctr verifica a permissao 
	If cEmpAnt == '50'
		If ZZA->ZZA_PERFIL == "F" .OR. ZZA->ZZA_PERFIL == "G" .OR. ZZA->ZZA_PERFIL == "B" .OR. ZZA->ZZA_PERFIL == "V"
			If (ZZA->ZZA_PERFIL == "B" .OR. ZZA->ZZA_PERFIL == "V" .OR. ZZA->ZZA_PERFIL == "G") .AND. (cBanco == "023" .OR. cBanco == "024" .OR. cBanco == "025" .OR. cBanco == "026")
				If cConpg == "000"
					lCnt := .T.
				ElseIf ZZA->ZZA_PERFIL == "G"
					lCnt := .T.
				Else
					lCnt  := .F.
				Alert("Apenas Contratos com Condição de Pagamento AVISTA podem ser aprovados nesse perfil.")
				EndIf
			ElseIf (cBanco == "027" .OR. cBanco == "022") 
				If ZZA->ZZA_PERFIL == "G"
					lCnt := .T.
				ElseIf ZZA->ZZA_PERFIL == "F" .AND. cConpg == "000"
					lCnt := .T.
				Else
					lCnt := .F.
					Alert("Apenas Perfil Gestor pode aprovar Contrato diferente de Avista.")
				EndIf
			ElseIf ZZA->ZZA_PERFIL == "G" .AND. (cBanco == "027" .OR. cBanco == "022" .OR. cBanco == "020" .OR. cBanco == "021" .OR. cBanco == "011")
				lCnt := .T. 
			Else
				lCnt  := .F.
				Alert("Usuario sem Perfil de Aprovador de Contratos.")
			EndIf
		EndIf
		//se for sem permissao mais perfil for Faturamento e valor - limite libera
		If !lCnt
			If ADB->ADB_TOTAL <= 3500 .AND. ZZA->ZZA_PERFIL == "V"
				nOpc := 1
				Alert("Liberado pois valor não utrapassa os R$3.500,00")
			Else
				//Alert("Usuario sem permissão para aprovar este Contrato.")
				nOpc := 2
			EndIf
		ELSE
			If ADA->ADA_XLIBFI <> '1'
				nOpc := Aviso("LIBERA CONTRATO", 'Atenção é o Contrato: '+ cContr + ' e o Cliente :'+ cCli + ;
								' Deseja Liberar este Contrato?', {"Sim","Não","Cancelar"})
			Else
				MsgAlert("Contrato ja Liberado anteriormente. ") 
				nOpc := 2
			EndIf
		Endif

	Else //SE FOR ERCAL ENTRA AQUI
		If ADA->ADA_XLIBFI <> '1'
			nOpc := Aviso("LIBERA CONTRATO", 'Atenção é o Contrato: '+ cContr + ' e o Cliente :'+ cCli + ;
							' Deseja Liberar este Contrato?', {"Sim","Não","Cancelar"})
		Else
			MsgAlert("Contrato ja Liberado anteriormente. ") 
			nOpc := 2
		EndIf
	EndIf
	if nOpc == 1
		Begin Transaction
			If !Empty(cContr)
				RecLock("ADA")
				ADA->ADA_XLIBFI := "1"
				ADA->ADA_XUSERL := AllTrim(UsrRetName(RetCodUsr()))
				ADA->ADA_XDTAPR := Date()
				If ZZA->ZZA_PERFIL == "V"
					ADA->ADA_MSBLQL := "2"
				EndIf
				//grava os dados aprovador
				MsUnLock()
			EndIf
		End Transaction	
	EndIf

ADA->(dbCloseArea())
ADB->(dbCloseArea())
SA1->(dbCloseArea())
ZZA->(DbCloseArea())

Return Nil

//Gatilho Valida se esta bloqueado Financeiro Ercal
User Function GatFin()

Local cStatus := M->ADA_MSBLQL
Local cLiber  := M->ADA_XLIBFI
Local cLimit  := ACOLS[1][5]
Local cUsr    := RetCodUsr()
If !EmpTy(ACOLS[1][7])
	If cEmpAnt == '50' //Se Britacal
		IF cStatus == "2" .AND. cLiber == "2"
			IF trim(M->ADA_CONDPG) <> "000" .AND. !(trim(M->ADA_XBANCO) == "023" .OR. trim(M->ADA_XBANCO) == "024" .OR. trim(M->ADA_XBANCO) == "025" .OR. trim(M->ADA_XBANCO) == "026")
				If ACOLS[1][7] > 3500 
					MsgAlert("Contrato ainda Bloqueado por regra Financeira")
					cStatus := "1"
				ElseIf ACOLS[1][7] <= 3500 .AND. !(cUsr == "000334" .OR. cUsr == "000312")
					MsgAlert("Contrato ainda Bloqueado por regra Financeira")
					cStatus := "1"
				EndIf
			ElseIf ACOLS[1][7] <= 3500 .AND. !(cUsr == "000334" .OR. cUsr == "000312")
				IF trim(M->ADA_CONDPG) <> "000" .AND. !(trim(M->ADA_XBANCO) == "023" .OR. trim(M->ADA_XBANCO) == "024" .OR. trim(M->ADA_XBANCO) == "025" .OR. trim(M->ADA_XBANCO) == "026")
					MsgAlert("Apenas Contratos AVISTA podem ser aprovados sem regra")
					cStatus := "1"
				EndIf
			EndIf
		EndIf
	Else
		If cStatus == "2" .AND. cLimit > 100
			If cLiber == "2" 
				MsgAlert("Contrato ainda Bloqueado por regra Financeira")
				cStatus := "1"
			EndIf
		EndIf
	EndIf

Else
	MsgAlert("Contrato sem VALOR, favor liberar apos inserir os PRODUTO")
	cStatus := "1"
EndIf
oGetDad:oBrowse:Refresh()
GetDRefresh()
Return(cStatus)
//cONSULTA POSICAO TITULO
Static Function cCons(cCodCli, cLojCli)
    Local aArea     := FWGetArea()
    Default cCodCli := ""
    Default cLojCli := ""
 
    DbSelectArea("SA1")
    SA1->(DbSetOrder(1)) // A1_FILIAL + A1_COD + A1_LOJA
 
    //Se conseguir posicionar no cliente
    If SA1->(MsSeek(FWxFilial("SA1") + cCodCli + cLojCli))
        Finc010(2)
    EndIf
	FWRestArea(aArea)
Return
 
User Function aNex(cContra)
    Local aArea      := FWGetArea()
    //Local cContra    := M->ADA_NUMCTR
    //Local cLoja      := "01"
 
    //Abre a tabela de Contratos
    DbSelectArea("ADA")
    ADA->(DbSetOrder(1)) // Filial + Contrato
 
    //Se conseguir posicionar no Contrato, abre o banco de conhecimento dele
    If ADA->(MsSeek(FWxFilial('ADA') + cContra))
        MsDocument('ADA', ADA->(RecNo()), 4)
    EndIf
 
    FWRestArea(aArea)
Return
//custo para alterar Parametro Balanca principal ou secundaria
User Function dDatap(cEdit1,cEdit2)  
// Variaveis Locais da Funcao                             
Local oEdit1
Local oEdit2
Local dData1 := cEdit1
Local dData2 := cEdit2
Private _oDlg				// Dialog Principal
//cEdit1	 := Date()
//cEdit2	 := Date()

DEFINE MSDIALOG _oDlg TITLE "DATA LIBERACAO" FROM C(350),C(575) TO C(487),C(721) PIXEL

@ C(007),C(007) Say "Data Incial" Size C(055),C(008) COLOR CLR_BLACK PIXEL OF _oDlg
@ C(015),C(007) MsGet oEdit1 Var dData1 Picture "99/99/9999" Size C(060),C(009) COLOR CLR_BLACK PIXEL OF _oDlg HASBUTTON
@ C(030),C(007) Say "Data Final" Size C(055),C(008) COLOR CLR_BLACK PIXEL OF _oDlg
@ C(037),C(007) MsGet oEdit2 Var dData2 Picture "99/99/9999" Size C(060),C(009) COLOR CLR_BLACK PIXEL OF _oDlg HASBUTTON  
DEFINE SBUTTON FROM C(055),C(007) TYPE 1 ENABLE OF _oDlg ACTION _bOk(dData1,dData2)
DEFINE SBUTTON FROM C(055),C(040) TYPE 2 ENABLE OF _oDlg ACTION _oDlg:End()
ACTIVATE MSDIALOG _oDlg CENTERED
Return(.T.)

//**************************
Static Function _bOk(dData1,dData2)
//**************************
_oDlg:End()
cEdit1 := dData1
cEdit2 := dData2
Return()

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa   ³   C()   ³ Autores ³ Norbert/Ernani/Mansano ³ Data ³10/05/2005³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao  ³ Funcao responsavel por manter o Layout independente da       ³±±
±±³           ³ resolucao horizontal do Monitor do Usuario.                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function C(nTam)
Local nHRes	:=	oMainWnd:nClientWidth	// Resolucao horizontal do monitor
If nHRes == 640	// Resolucao 640x480 (soh o Ocean e o Classic aceitam 640)
	nTam *= 0.8
ElseIf (nHRes == 798).Or.(nHRes == 800)	// Resolucao 800x600
	nTam *= 1
Else	// Resolucao 1024x768 e acima
	nTam *= 1.28
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Tratamento para tema "Flat"³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If "MP8" $ oApp:cVersion
	If (Alltrim(GetTheme()) == "FLAT") .Or. SetMdiChild()
		nTam *= 0.90
	EndIf
EndIf
Return Int(nTam)
