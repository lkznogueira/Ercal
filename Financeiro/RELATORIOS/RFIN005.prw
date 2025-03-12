#include "protheus.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RFIN005   ºAutor  ³Jeovane             º Data ³  01/09/08   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Relatorio imprime disponibilidades, buscando de todas as   º±±
±±º          ³ empresas                                                   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ SIGAFIN - CIF                                             º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

user function RFIN005()
local aArea         := getArea()
Local i
private cPerg       := "RFIN005"
private nLinha      := 0
private nSalto      := 40
private nColDireita := 2220
//private aResumo     := {}
private aSaldo1     := {}
private aSalto2     := {}


Tamanho  := "M"
titulo   := "Relatorio Diario de Disponibilidade"
cDesc1   := "Este programa destina-se a impressao do Relatorio Diario de Disponibilidade."
cDesc2   := ""
cDesc3   := ""
wnrel    := "DISPONIBILIDADE DIARIA"
lEnd     := .F.
aReturn  := {"Zebrado", 1,"Administracao", 2, 2, 1, "",1 }
nLastKey := 0
cString  := "SA6"

validPerg()

PERGUNTE(cPerg,.T.)



cTipoFont := "Arial"
//cTipoFont := "Courier New"

oFont6     := TFont():New(cTipoFont,9,06,.T.,.F.,5,.T.,5,.T.,.F.)
oFont7     := TFont():New(cTipoFont,9,07,.T.,.F.,5,.T.,5,.T.,.F.)
oFont8C    := TFont():New("Courier New",9,08,.T.,.F.,5,.T.,5,.T.,.F.)
oFont8     := TFont():New(cTipoFont,9,08,.T.,.F.,5,.T.,5,.T.,.F.)
oFont10    := TFont():New(cTipoFont,9,10,.T.,.T.,5,.T.,5,.T.,.F.)
oFont10C   := TFont():New("Courier New",9,10,.F.,.T.,5,.T.,5,.T.,.F.)
oFont10n   := TFont():New(cTipoFont,9,10,.T.,.F.,5,.T.,5,.T.,.F.)
oFont12    := TFont():New(cTipoFont,9,12,.T.,.T.,5,.T.,5,.T.,.F.)
oFont12n   := TFont():New(cTipoFont,9,12,.T.,.F.,5,.T.,5,.T.,.F.)
oFont14    := TFont():New(cTipoFont,9,14,.T.,.T.,5,.T.,5,.T.,.F.)
oFont16    := TFont():New(cTipoFont,9,16,.T.,.T.,5,.T.,5,.T.,.F.)
oFont16n   := TFont():New(cTipoFont,9,16,.T.,.F.,5,.T.,5,.T.,.F.)
oFont14n   := TFont():New(cTipoFont,9,14,.T.,.F.,5,.T.,5,.T.,.F.)
oFont24    := TFont():New(cTipoFont,9,24,.T.,.T.,5,.T.,5,.T.,.F.)


oPrint     := TMSPrinter():New("RELATORIO DIARIO DE DISPONIBILIDADE")

//oPrint:Setup()
oPrint:SetPortrait()			// ou SetLandscape()
oPrint:SetPaperSize(9)			// Seta para papel A4


novaPag()


//Imprime Saldo Anterior
aSaldo1 := getSaldo(mv_par01-1)
aSaldo2 := getSaldo(mv_par01)
aSaldo  := updSaldo(aSaldo1,aSaldo2) //Atualiza Coluna Saldo Anterior
printSaldo(aSaldo,"SALDO ANTERIOR")

/*nLinha += nSalto
oPrint:Say (nLinha,0860,"RESUMO MOVIMENTACAO DIARIA",oFont12)
nLinha += nSalto*2
nAux  := nLinha
oPrint:Line(nLinha,0050,nLinha,nColDireita,oFont12n)
oPrint:Say (nLinha,0060,"BANCO" ,oFont12)
oPrint:Say (nLinha,0770,"CIF" ,oFont12)
oPrint:Say (nLinha,1040,"TANGARA" ,oFont12)
oPrint:Say (nLinha,1410,"VIGON" ,oFont12)
oPrint:Say (nLinha,1730,"FLAVIO" ,oFont12)
oPrint:Say (nLinha,2010,"F.CUNHA" ,oFont12)
oPrint:Line(nLinha,0050,nLinha,nColDireita,oFont12n)
nAux  := nLinha
nLinha += nSalto



//Pega Resumo de movimentacao do dia
aResumo := getResumo(mv_par01) //Busca Resumo Receber e a Pagar
nCol    := 320
aTot    := {0,0,0,0,0}
for i := 1 to len(aResumo)
for j := 1 to len(aResumo[i])
if j == 1
oPrint:Say (nLinha,0060,aResumo[i,j],oFont12n)
else
oPrint:Say (nLinha,(nCol*j),transform(aResumo[i,j],"@E 999,999,999.99") ,oFont10C)
aTot[j-1] += aResumo[i,j]
endif
oPrint:Line(nLinha,0050,nLinha,nColDireita,oFont12)
if nLinha >= 3000
oPrint:EndPage()
novaPag()
endif
next j
nLinha += nSalto
next i


//Imprime Totais
oPrint:Line(nLinha,0050,nLinha,nColDireita,oFont12n)
//nLinha += nSalto
oPrint:Say (nLinha,0060,"TOTAIS",oFont12)
oPrint:Say (nLinha,640,transform(aTot[1],"@E 999,999,999.99") ,oFont10C)
oPrint:Say (nLinha,0960,transform(aTot[2],"@E 999,999,999.99") ,oFont10C)
oPrint:Say (nLinha,1280,transform(aTot[3],"@E 999,999,999.99") ,oFont10C)
oPrint:Say (nLinha,1600,transform(aTot[4],"@E 999,999,999.99") ,oFont10C)
oPrint:Say (nLinha,1920,transform(aTot[5],"@E 999,999,999.99") ,oFont10C)
nLinha += nSalto
oPrint:Line(nLinha,0050,nLinha,nColDireita,oFont12n)

//Imprime Linhas verticais
oPrint:Line(nAux,470,nLinha,470,oFont12)
oPrint:Line(nAux,900,nLinha,900,oFont12)
oPrint:Line(nAux,1210,nLinha,1210,oFont12)
oPrint:Line(nAux,1560,nLinha,1560,oFont12)
oPrint:Line(nAux,1870,nLinha,1870,oFont12)

nLinha += nSalto

*/


//Imprime Movimentacao  Receber
aMov := getMovRec(MV_PAR01)
oPrint:Say (nLinha,0840,"RECEBIMENTOS E/OU CREDITOS",oFont12)
nLinha += nSalto*2
nAux := nLinha
oPrint:Line(nLinha,0050,nLinha,nColDireita,oFont12n)
oPrint:Say (nLinha,0060,"FONTE",oFont12)
oPrint:Say (nLinha,1000,"NATUREZA",oFont12)
oPrint:Say (nLinha,1700,"EMPRESA",oFont12)
oPrint:Say (nLinha,2050,"VALOR",oFont12)

nLinha += nSalto
oPrint:Line(nLinha,0050,nLinha,nColDireita,oFont12)


nTot := 0
for i := 1 to len(aMov)
	if aMov[i,4] == "R"
		if !empty(aMov[i,1])
			oPrint:Say (nLinha,0060,substr(aMov[i,1],1,42),oFont12n)  //Se caso houver cliente
		else
			oPrint:Say (nLinha,0060,substr(aMov[i,6],1,42),oFont12n) //historico
		endif
		oPrint:Say (nLinha,1000,Posicione("SED",1,xFilial("SED")+aMov[i,7],"ED_DESCRIC"),oFont12n)
		oPrint:Say (nLinha,1700,aMov[i,2],oFont12n)
		oPrint:Say (nLinha,1920,transform(aMov[i,3],"@E 999,999,999.99"),oFont10C)
		nTot += aMov[i,3]
		nLinha += nSalto
		oPrint:Line(nLinha,0050,nLinha,nColDireita,oFont12n)
		if nLinha >= 3000
			//Imprime Linhas verticais
			oPrint:Line(nAux,0980,nLinha,0980,oFont12)
			oPrint:Line(nAux,1680,nLinha,1680,oFont12)
			oPrint:Line(nAux,1900,nLinha,1900,oFont12)
			nAux := 115
			oPrint:EndPage()
			novaPag()
		endif
		
	endif
next i

//Imprime Totalizador
oPrint:Say (nLinha,0060,"TOTAL",oFont12)
oPrint:Say (nLinha,1920,transform(nTot,"@E 999,999,999.99"),oFont10C)
//nTot += aMov[i,3]
nLinha += nSalto
oPrint:Line(nLinha,0050,nLinha,nColDireita,oFont12n)

//Imprime Linhas verticais
oPrint:Line(nAux,0980,nLinha,0980,oFont12)
oPrint:Line(nAux,1680,nLinha,1680,oFont12)
oPrint:Line(nAux,1900,nLinha,1900,oFont12)


//Imprime Movimentacao  Pagar
aMov := getMovPag(MV_PAR01)
nLinha += nSalto
oPrint:Say (nLinha,0840,"PAGAMENTOS A FORNECEDORES",oFont12)
nLinha += nSalto*2
nAux := nLinha
oPrint:Line(nLinha,0050,nLinha,nColDireita,oFont12n)
oPrint:Say (nLinha,0060,"FAVORECIDO",oFont12)
oPrint:Say (nLinha,1000,"NATUREZA",oFont12)
oPrint:Say (nLinha,1700,"EMPRESA",oFont12)
oPrint:Say (nLinha,2050,"VALOR",oFont12)



nLinha += nSalto
oPrint:Line(nLinha,0050,nLinha,nColDireita,oFont12)


nTot := 0
for i := 1 to len(aMov)
	if aMov[i,4] == "P"
		oPrint:Say (nLinha,0060,substr(aMov[i,1],1,42),oFont12n)
		oPrint:Say (nLinha,1000,Posicione("SED",1,xFilial("SED")+aMov[i,6],"ED_DESCRIC"),oFont12n)
		oPrint:Say (nLinha,1700,aMov[i,2],oFont12n)
		oPrint:Say (nLinha,1920,transform(aMov[i,3],"@E 999,999,999.99"),oFont10C)
		nTot += aMov[i,3]
		nLinha += nSalto
		oPrint:Line(nLinha,0050,nLinha,nColDireita,oFont12)
		if nLinha >= 3000
			//Imprime Linhas verticais
			oPrint:Line(nAux,0980,nLinha,0980,oFont12)
			oPrint:Line(nAux,1680,nLinha,1680,oFont12)
			oPrint:Line(nAux,1900,nLinha,1900,oFont12)
			nAux := 115
			oPrint:EndPage()
			novaPag()
		endif
	endif
next i
//Imprime Totalizador
oPrint:Say (nLinha,0060,"TOTAL",oFont12)
oPrint:Say (nLinha,1920,transform(nTot,"@E 999,999,999.99"),oFont10C)
nLinha += nSalto
oPrint:Line(nLinha,0050,nLinha,nColDireita,oFont12n)

//Imprime Linhas verticais
oPrint:Line(nAux,0980,nLinha,0980,oFont12)
oPrint:Line(nAux,1680,nLinha,1680,oFont12)
oPrint:Line(nAux,1900,nLinha,1900,oFont12)





//Imprime outros pagamentos - sem Fornecedor ligados
aMov := getMovOut(MV_PAR01)
nLinha += nSalto
oPrint:Say (nLinha,0900,"OUTROS PAGAMENTOS",oFont12)
nLinha += nSalto*2
nAux := nLinha
oPrint:Line(nLinha,0050,nLinha,nColDireita,oFont12n)
oPrint:Say (nLinha,0060,"HISTORICO",oFont12)
oPrint:Say (nLinha,1000,"NATUREZA",oFont12)
oPrint:Say (nLinha,1700,"EMPRESA",oFont12)
oPrint:Say (nLinha,2050,"VALOR",oFont12)
nLinha += nSalto
oPrint:Line(nLinha,0050,nLinha,nColDireita,oFont12)

nTot := 0
for i := 1 to len(aMov)
	oPrint:Say (nLinha,0060,substr(aMov[i,1],1,42),oFont12n)
	oPrint:Say (nLinha,1000,Posicione("SED",1,xFilial("SED")+aMov[i,4],"ED_DESCRIC"),oFont12n)
	oPrint:Say (nLinha,1700,aMov[i,2],oFont12n)
	oPrint:Say (nLinha,1920,transform(aMov[i,3],"@E 999,999,999.99"),oFont10C)
	nTot += aMov[i,3]
	nLinha += nSalto
	oPrint:Line(nLinha,0050,nLinha,nColDireita,oFont12)
	if nLinha >= 3000
		//Imprime Linhas verticais
			oPrint:Line(nAux,0980,nLinha,0980,oFont12)
			oPrint:Line(nAux,1680,nLinha,1680,oFont12)
			oPrint:Line(nAux,1900,nLinha,1900,oFont12)
		nAux := 115
		oPrint:EndPage()
		novaPag()
	endif
next i
//Imprime Totalizador
oPrint:Say (nLinha,0060,"TOTAL",oFont12)
oPrint:Say (nLinha,1920,transform(nTot,"@E 999,999,999.99"),oFont10C)
nLinha += nSalto
oPrint:Line(nLinha,0050,nLinha,nColDireita,oFont12n)


//Imprime Linhas verticais
			oPrint:Line(nAux,0980,nLinha,0980,oFont12)
			oPrint:Line(nAux,1680,nLinha,1680,oFont12)
			oPrint:Line(nAux,1900,nLinha,1900,oFont12)


oPrint:EndPage()	// Finaliza a Pagina.



oPrint:Preview()	// Visualiza antes de Imprimir.

return

static function ValidPerg()

Local _sAlias := Alias()
Local aRegs := {}
Local i,j

dbSelectArea("SX1")
dbSetOrder(1)

cPerg := PADR(cPerg,10)

//(sx1) Grupo/Ordem/Pergunta/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid/Var01/Def01/Cnt01/Var02/Def02/Cnt02/Var03/Def03/Cnt03/Var04/Def04/Cnt04/Var05/Def05/Cnt05
aAdd(aRegs,{cPerg,"01","Data:              ","","","mv_ch1" ,"D", 8,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","",""})
//aAdd(aRegs,{cPerg,"02","Imprimir Tipos:    ","","","mv_ch2" ,"C", 25,0,0,"R","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","",""})
//aAdd(aRegs,{cPerg,"03","Nao Imprimir Tipos:","","","mv_ch3" ,"C", 25,0,0,"R","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","",""})


For i:=1 to Len(aRegs)
	If !dbSeek(cPerg+space(10-len(cPerg))+aRegs[i,2])
		RecLock("SX1",.T.)
		For j:=1 to FCount()
			If j <= Len(aRegs[i])
				FieldPut(j,aRegs[i,j])
			Endif
		Next
		MsUnlock()
	Endif
Next
return



static function getMovRec(dData)
local aRet := {}
local cQuery := ""
local aArea := getArea()
local cFiltro := ""

//Imprime somente E5_TIPODOC = VL
//cFiltro += " AND A.E5_TIPODOC IN ('VL','CH') "
/*if !empty(mv_par02)
cFiltro += " AND A.E5_TIPODOC IN " +   formatin(mv_par02,";")
elseif !empty(mv_par03)
cFiltro += " AND A.E5_TIPODOC NOT IN " +   formatin(mv_par03,";")
endif
*/

//Filtra para nao imprimir liquidacoes e nem transferencia de controle de mutuo
cFiltro += " AND A.E5_MOTBX <> 'LIQ' AND A.E5_TIPODOC <> 'BA' AND A.E5_MOEDA <> 'CM' "


cQuery += " SELECT B.A1_NOME,'CIF    ' AS EMPRESA,A.E5_VALOR,A.E5_RECPAG,A.E5_DTDISPO,A.E5_HISTOR,A.E5_NATUREZ "
cQuery += " FROM SE5010 A LEFT JOIN SA1010 B ON A.E5_CLIFOR = B.A1_COD AND A.E5_LOJA = B.A1_LOJA AND B.D_E_L_E_T_ <> '*' "
cQuery += " WHERE A.E5_SITUACA <> 'C' AND A.D_E_L_E_T_ <> '*'  AND A.E5_RECPAG = 'R' AND A.E5_BANCO <> ' ' "
cQuery += " AND A.E5_DTDISPO = '" + dtos(dData)+ "'" + cFiltro
cQuery += " UNION ALL  "
cQuery += " SELECT B.A1_NOME,'TANGARA' AS EMPRESA,A.E5_VALOR,A.E5_RECPAG,A.E5_DTDISPO,A.E5_HISTOR,A.E5_NATUREZ "
cQuery += " FROM SE5020 A LEFT JOIN SA1010 B ON A.E5_CLIFOR = B.A1_COD AND A.E5_LOJA = B.A1_LOJA AND B.D_E_L_E_T_ <> '*' "
cQuery += " WHERE A.E5_SITUACA <> 'C' AND A.D_E_L_E_T_ <> '*' AND A.E5_RECPAG = 'R' AND A.E5_BANCO <> ' ' "
cQuery += " AND A.E5_DTDISPO = '" + dtos(dData)+ "'" + cFiltro
cQuery += " UNION ALL "
cQuery += " SELECT B.A1_NOME,'VIGON' AS EMPRESA,A.E5_VALOR,A.E5_RECPAG,A.E5_DTDISPO,A.E5_HISTOR,A.E5_NATUREZ "
cQuery += " FROM SE5030 A LEFT JOIN SA1010 B ON A.E5_CLIFOR = B.A1_COD AND A.E5_LOJA = B.A1_LOJA AND B.D_E_L_E_T_ <> '*' "
cQuery += " WHERE A.E5_SITUACA <> 'C' AND A.D_E_L_E_T_ <> '*'  AND A.E5_RECPAG = 'R' AND A.E5_BANCO <> ' '"
cQuery += " AND A.E5_DTDISPO = '" + dtos(dData)+ "'"  + cFiltro
cQuery += " UNION ALL  "
cQuery += " SELECT B.A1_NOME,'FLAVIO' AS EMPRESA,A.E5_VALOR,A.E5_RECPAG,A.E5_DTDISPO,A.E5_HISTOR,A.E5_NATUREZ "
cQuery += " FROM SE5040 A LEFT JOIN SA1010 B ON A.E5_CLIFOR = B.A1_COD AND A.E5_LOJA = B.A1_LOJA  AND B.D_E_L_E_T_ <> '*' "
cQuery += " WHERE A.E5_SITUACA <> 'C' AND A.D_E_L_E_T_ <> '*'  AND A.E5_RECPAG = 'R' AND A.E5_BANCO <> ' ' "
cQuery += " AND A.E5_DTDISPO = '" + dtos(dData)+ "'" + cFiltro
cQuery += " UNION ALL  "
cQuery += " SELECT B.A1_NOME,'F.CUNHA' AS EMPRESA,A.E5_VALOR,A.E5_RECPAG,A.E5_DTDISPO,A.E5_HISTOR,A.E5_NATUREZ "
cQuery += " FROM SE5050 A LEFT JOIN SA1010 B ON A.E5_CLIFOR = B.A1_COD AND A.E5_LOJA = B.A1_LOJA AND B.D_E_L_E_T_ <> '*'  "
cQuery += " WHERE A.E5_SITUACA <> 'C' AND A.D_E_L_E_T_ <> '*' AND A.E5_RECPAG = 'R' AND A.E5_BANCO <> ' ' "
cQuery += " AND A.E5_DTDISPO = '" + dtos(dData)+ "'" + cFiltro
cQuery += " ORDER BY 4 "

if Select("TRB1") > 0
	dbSelectArea("TRB1")
	dbCloseArea("TRB1")
endif

dbUseArea(.T.,"TOPCONN",TCGenQry(,,ALLTRIM(Upper(cQuery))),'TRB1',.F.,.T.)

while TRB1->(!eof())
	aadd(aRet,{TRB1->A1_NOME,TRB1->EMPRESA,TRB1->E5_VALOR,TRB1->E5_RECPAG,TRB1->E5_DTDISPO,TRB1->E5_HISTOR,TRB1->E5_NATUREZ})
	TRB1->(dbSkip())
Enddo

DbCloseArea("TRB1")

return aRet


static function getMovPag(dData)
local aRet := {}
local cQuery := ""
local aArea := getArea()
local cFiltro := " "

//cFiltro += " AND A.E5_TIPODOC  IN ( 'VL' ,'CH')
/*if !empty(mv_par02)
cFiltro += " AND A.E5_TIPODOC IN " +   formatin(mv_par02,";")
elseif !empty(mv_par03)
cFiltro += " AND A.E5_TIPODOC NOT IN " +   formatin(mv_par03,";")
endif
*/

cFiltro += " AND A.E5_MOTBX <> 'LIQ' AND A.E5_TIPODOC <> 'BA' AND A.E5_MOEDA <> 'CM' "

cQuery += " SELECT B.A2_NOME,'CIF    ' AS EMPRESA,A.E5_VALOR,A.E5_RECPAG,A.E5_DTDISPO,A.E5_NATUREZ "
cQuery += " FROM SE5010 A JOIN SA2010 B ON A.E5_CLIFOR = B.A2_COD AND A.E5_LOJA = B.A2_LOJA
cQuery += " WHERE A.E5_SITUACA <> 'C' AND A.D_E_L_E_T_ <> '*'  AND B.D_E_L_E_T_ <> '*'  AND A.E5_RECPAG = 'P' AND A.E5_BANCO <> ' ' "
cQuery += " AND A.E5_DTDISPO = '" + dtos(dData)+ "'" + cFiltro
cQuery += " UNION ALL  "
cQuery += " SELECT B.A2_NOME,'TANGARA' AS EMPRESA,A.E5_VALOR,A.E5_RECPAG,A.E5_DTDISPO,A.E5_NATUREZ "
cQuery += " FROM SE5020 A JOIN SA2010 B ON A.E5_CLIFOR = B.A2_COD AND A.E5_LOJA = B.A2_LOJA "
cQuery += " WHERE A.E5_SITUACA <> 'C' AND A.D_E_L_E_T_ <> '*' AND B.D_E_L_E_T_ <> '*'  AND A.E5_RECPAG = 'P' AND A.E5_BANCO <> ' ' "
cQuery += " AND A.E5_DTDISPO = '" + dtos(dData)+ "'" + cFiltro
cQuery += " UNION ALL "
cQuery += " SELECT B.A2_NOME,'VIGON' AS EMPRESA,A.E5_VALOR,A.E5_RECPAG,A.E5_DTDISPO,A.E5_NATUREZ "
cQuery += " FROM SE5030 A JOIN SA2010 B ON A.E5_CLIFOR = B.A2_COD AND A.E5_LOJA = B.A2_LOJA
cQuery += " WHERE A.E5_SITUACA <> 'C' AND A.D_E_L_E_T_ <> '*' AND B.D_E_L_E_T_ <> '*' AND A.E5_RECPAG = 'P' AND A.E5_BANCO <> ' '"
cQuery += " AND A.E5_DTDISPO = '" + dtos(dData)+ "'" + cFiltro
cQuery += " UNION ALL  "
cQuery += " SELECT B.A2_NOME,'FLAVIO' AS EMPRESA,A.E5_VALOR,A.E5_RECPAG,A.E5_DTDISPO,A.E5_NATUREZ "
cQuery += " FROM SE5040 A JOIN SA2010 B ON A.E5_CLIFOR = B.A2_COD AND A.E5_LOJA = B.A2_LOJA
cQuery += " WHERE A.E5_SITUACA <> 'C' AND A.D_E_L_E_T_ <> '*' AND B.D_E_L_E_T_ <> '*' AND A.E5_RECPAG = 'P' AND A.E5_BANCO <> ' ' "
cQuery += " AND A.E5_DTDISPO = '" + dtos(dData)+ "'" + cFiltro
cQuery += " UNION ALL  "
cQuery += " SELECT B.A2_NOME,'F.CUNHA' AS EMPRESA,A.E5_VALOR,A.E5_RECPAG,A.E5_DTDISPO,A.E5_NATUREZ "
cQuery += " FROM SE5050 A JOIN SA2010 B ON A.E5_CLIFOR = B.A2_COD AND A.E5_LOJA = B.A2_LOJA
cQuery += " WHERE A.E5_SITUACA <> 'C' AND A.D_E_L_E_T_ <> '*' AND B.D_E_L_E_T_ <> '*' AND A.E5_RECPAG = 'P' AND A.E5_BANCO <> ' ' "
cQuery += " AND A.E5_DTDISPO = '" + dtos(dData)+ "'"  + cFiltro
cQuery += " ORDER BY 4 "

if Select("TRB1") > 0
	dbSelectArea("TRB1")
	dbCloseArea("TRB1")
endif

dbUseArea(.T.,"TOPCONN",TCGenQry(,,ALLTRIM(Upper(cQuery))),'TRB1',.F.,.T.)

while TRB1->(!eof())
	aadd(aRet,{TRB1->A2_NOME,TRB1->EMPRESA,TRB1->E5_VALOR,TRB1->E5_RECPAG,TRB1->E5_DTDISPO,TRB1->E5_NATUREZ})
	TRB1->(dbSkip())
Enddo

DbCloseArea("TRB1")

return aRet


static function getMovOut(dData)
local aRet := {}
local cQuery := ""
local aArea := getArea()
local cFiltro := " "

//cFiltro += " AND A.E5_TIPODOC  IN ( 'VL' ,'CH')
/*if !empty(mv_par02)
cFiltro += " AND A.E5_TIPODOC IN " +   formatin(mv_par02,";")
elseif !empty(mv_par03)
cFiltro += " AND A.E5_TIPODOC NOT IN " +   formatin(mv_par03,";")
endif
*/

cFiltro += " AND A.E5_MOTBX <> 'LIQ' AND A.E5_TIPODOC <> 'BA' AND A.E5_MOEDA <> 'CM' "


cQuery += " SELECT A.E5_HISTOR,'CIF    ' AS EMPRESA,A.E5_VALOR,A.E5_NATUREZ FROM SE5010 A "
cQuery += " WHERE A.E5_SITUACA <> 'C' AND A.D_E_L_E_T_ <> '*'  AND A.E5_RECPAG = 'P' AND A.E5_BANCO <> ' ' AND A.E5_CLIFOR = ' ' "
cQuery += " AND A.E5_DTDISPO = '" + dtos(dData)+ "' " + cFiltro
cQuery += " UNION ALL  "
cQuery += " SELECT A.E5_HISTOR,'TANGARA' AS EMPRESA,A.E5_VALOR,A.E5_NATUREZ FROM SE5020 A "
cQuery += " WHERE A.E5_SITUACA <> 'C' AND A.D_E_L_E_T_ <> '*'  AND A.E5_RECPAG = 'P' AND A.E5_BANCO <> ' ' AND A.E5_CLIFOR = ' ' "
cQuery += " AND A.E5_DTDISPO = '" + dtos(dData)+ "' " + cFiltro
cQuery += " UNION ALL "
cQuery += " SELECT A.E5_HISTOR,'VIGON  ' AS EMPRESA,A.E5_VALOR,A.E5_NATUREZ FROM SE5030 A"
cQuery += " WHERE A.E5_SITUACA <> 'C' AND A.D_E_L_E_T_ <> '*'  AND A.E5_RECPAG = 'P' AND A.E5_BANCO <> ' ' AND A.E5_CLIFOR = ' ' "
cQuery += " AND A.E5_DTDISPO = '" + dtos(dData)+ "'" + cFiltro
cQuery += " UNION ALL  "
cQuery += " SELECT A.E5_HISTOR,'FLAVIO ' AS EMPRESA,A.E5_VALOR,A.E5_NATUREZ FROM SE5040 A"
cQuery += " WHERE A.E5_SITUACA <> 'C' AND A.D_E_L_E_T_ <> '*'  AND A.E5_RECPAG = 'P' AND A.E5_BANCO <> ' ' AND A.E5_CLIFOR = ' ' "
cQuery += "  AND A.E5_DTDISPO = '" + dtos(dData)+ "'" + cFiltro
cQuery += " UNION ALL  "
cQuery += " SELECT A.E5_HISTOR,'F. CUNHA' AS EMPRESA,A.E5_VALOR,A.E5_NATUREZ FROM SE5050 A"
cQuery += " WHERE A.E5_SITUACA <> 'C' AND A.D_E_L_E_T_ <> '*'  AND A.E5_RECPAG = 'P' AND A.E5_BANCO <> ' ' AND A.E5_CLIFOR = ' ' "
cQuery += " AND A.E5_DTDISPO = '" + dtos(dData)+ "'" + cFiltro
cQuery += " ORDER BY 2 "

if Select("TRB1") > 0
	dbSelectArea("TRB1")
	dbCloseArea("TRB1")
endif

dbUseArea(.T.,"TOPCONN",TCGenQry(,,ALLTRIM(Upper(cQuery))),'TRB1',.F.,.T.)

while TRB1->(!eof())
	aadd(aRet,{TRB1->E5_HISTOR,TRB1->EMPRESA,TRB1->E5_VALOR,TRB1->E5_NATUREZ})
	TRB1->(dbSkip())
Enddo

DbCloseArea("TRB1")

return aRet

static function novaPag()
oPrint:StartPage()
nLinha := 35
oPrint:Line(nLinha,0050,nLinha,nColDireita,oFont12)
oPrint:Box(nLinha,0050,3200,nColDireita,oFont12)
oPrint:Say (nLinha,0590,"RELATORIO DIARIO DE DISPONIBILIDADES DE " + Dtoc(MV_PAR01),oFont14)
nLinha += nSalto*2
//oPrint:Line(nLinha,0050,nLinha,nColDireita,oFont12)
return



static function getResumo(dData)
local aTmp := {}
local aRet := {}
local cQuery := ""
local aArea := getArea()
local cFiltro := " "
Local i

//cFiltro += " AND A.E5_TIPODOC  IN ( 'VL' ,'CH')

/*if !empty(mv_par02)
cFiltro += " AND A.E5_TIPODOC IN " +   formatin(mv_par02,";")
elseif !empty(mv_par03)
cFiltro += " AND A.E5_TIPODOC NOT IN " +   formatin(mv_par03,";")
endif
*/


cFiltro += " AND A.E5_MOTBX <> 'LIQ' AND A.E5_TIPODOC <> 'BA' AND A.E5_MOEDA <> 'CM' "

cQuery += "SELECT '001' AS EMPRESA,A.E5_BANCO,A.E5_AGENCIA,A.E5_CONTA,C.A6_NREDUZ, "
cQuery += "SUM(CASE A.E5_RECPAG WHEN 'R' THEN A.E5_VALOR WHEN 'P' THEN A.E5_VALOR * -1 END) AS SALDO "
cQuery += "FROM SE5010 A JOIN SA6010 C ON A.E5_BANCO = C.A6_COD  AND A.E5_AGENCIA = C.A6_AGENCIA AND A.E5_CONTA = C.A6_NUMCON "
cQuery += "WHERE E5_DTDISPO = '" + dtos(dData)+ "'  AND A.E5_BANCO <> ' '  AND ((A.E5_RECPAG = 'P') OR (A.E5_CLIFOR <> ' ') ) "
cQuery += "AND A.D_E_L_E_T_ <> '*' AND C.A6_BLOCKED <> 1 AND C.D_E_L_E_T_ <> '*' AND A.E5_SITUACA <> 'C' " + cFiltro
cQuery += "GROUP BY A.E5_BANCO,A.E5_AGENCIA,A.E5_CONTA,C.A6_NREDUZ "
cQuery += "UNION ALL "
cQuery += "SELECT '002' AS EMPRESA,A.E5_BANCO,A.E5_AGENCIA,A.E5_CONTA,C.A6_NREDUZ, "
cQuery += "SUM(CASE A.E5_RECPAG WHEN 'R' THEN A.E5_VALOR WHEN 'P' THEN A.E5_VALOR * -1 END) AS SALDO "
cQuery += "FROM SE5020 A JOIN SA6020 C ON A.E5_BANCO = C.A6_COD  AND A.E5_AGENCIA = C.A6_AGENCIA AND A.E5_CONTA = C.A6_NUMCON "
cQuery += "WHERE E5_DTDISPO = '" + dtos(dData)+ "' AND A.E5_BANCO <> ' ' AND ((A.E5_RECPAG = 'P') OR (A.E5_CLIFOR <> ' ') ) "
cQuery += "AND A.D_E_L_E_T_ <> '*' AND C.A6_BLOCKED <> 1 AND C.D_E_L_E_T_ <> '*' AND A.E5_SITUACA <> 'C' " + cFiltro
cQuery += "GROUP BY A.E5_BANCO,A.E5_AGENCIA,A.E5_CONTA,C.A6_NREDUZ "
cQuery += "UNION ALL "
cQuery += "SELECT '003' AS EMPRESA,A.E5_BANCO,A.E5_AGENCIA,A.E5_CONTA,C.A6_NREDUZ, "
cQuery += "SUM(CASE A.E5_RECPAG WHEN 'R' THEN A.E5_VALOR WHEN 'P' THEN A.E5_VALOR * -1 END) AS SALDO "
cQuery += "FROM SE5030 A JOIN SA6030 C ON A.E5_BANCO = C.A6_COD  AND A.E5_AGENCIA = C.A6_AGENCIA AND A.E5_CONTA = C.A6_NUMCON "
cQuery += "WHERE E5_DTDISPO = '" + dtos(dData)+ "' AND A.E5_BANCO <> ' ' AND ((A.E5_RECPAG = 'P') OR (A.E5_CLIFOR <> ' ') ) "
cQuery += "AND A.D_E_L_E_T_ <> '*' AND C.A6_BLOCKED <> 1 AND C.D_E_L_E_T_ <> '*' AND A.E5_SITUACA <> 'C' " + cFiltro
cQuery += "GROUP BY A.E5_BANCO,A.E5_AGENCIA,A.E5_CONTA,C.A6_NREDUZ "
cQuery += "UNION ALL "
cQuery += "SELECT '004' AS EMPRESA,A.E5_BANCO,A.E5_AGENCIA,A.E5_CONTA,C.A6_NREDUZ, "
cQuery += "SUM(CASE A.E5_RECPAG WHEN 'R' THEN A.E5_VALOR WHEN 'P' THEN A.E5_VALOR * -1 END) AS SALDO "
cQuery += "FROM SE5040 A JOIN SA6040 C ON A.E5_BANCO = C.A6_COD  AND A.E5_AGENCIA = C.A6_AGENCIA AND A.E5_CONTA = C.A6_NUMCON "
cQuery += "WHERE E5_DTDISPO = '" + dtos(dData)+ "' AND A.E5_BANCO <> ' ' AND ((A.E5_RECPAG = 'P') OR (A.E5_CLIFOR <> ' ') ) "
cQuery += "AND A.D_E_L_E_T_ <> '*' AND C.A6_BLOCKED <> 1 AND C.D_E_L_E_T_ <> '*' AND A.E5_SITUACA <> 'C' " + cFiltro
cQuery += "GROUP BY A.E5_BANCO,A.E5_AGENCIA,A.E5_CONTA,C.A6_NREDUZ "
cQuery += "UNION ALL "
cQuery += "SELECT '005' AS EMPRESA,A.E5_BANCO,A.E5_AGENCIA,A.E5_CONTA,C.A6_NREDUZ, "
cQuery += "SUM(CASE A.E5_RECPAG WHEN 'R' THEN A.E5_VALOR WHEN 'P' THEN A.E5_VALOR * -1 END) AS SALDO "
cQuery += "FROM SE5050 A JOIN SA6050 C ON A.E5_BANCO = C.A6_COD  AND A.E5_AGENCIA = C.A6_AGENCIA AND A.E5_CONTA = C.A6_NUMCON "
cQuery += "WHERE E5_DTDISPO = '" + dtos(dData)+ "' AND A.E5_BANCO <> ' ' AND ((A.E5_RECPAG = 'P') OR (A.E5_CLIFOR <> ' ') ) "
cQuery += "AND A.D_E_L_E_T_ <> '*' AND C.A6_BLOCKED <> 1  AND C.D_E_L_E_T_ <> '*' AND A.E5_SITUACA <> 'C' " + cFiltro
cQuery += "GROUP BY A.E5_BANCO,A.E5_AGENCIA,A.E5_CONTA,C.A6_NREDUZ "



if Select("TRB2") > 0
	dbSelectArea("TRB2")
	dbCloseArea("TRB2")
endif

dbUseArea(.T.,"TOPCONN",TCGenQry(,,ALLTRIM(Upper(cQuery))),'TRB2',.F.,.T.)

while TRB2->(!eof())
	aadd(aTmp,{TRB2->E5_BANCO,TRB2->SALDO,TRB2->A6_NREDUZ,TRB2->EMPRESA})
	TRB2->(dbSkip())
Enddo

DbCloseArea("TRB2")

//aRet = NOME,CIF,TANGARA,FLAVIO,VIGON,RESUMO
for i := 1 to len(aTmp)
	do case
		case aTmp[i,4] == "001"
			aadd(aRet,{aTmp[i,3],aTmp[i,2],0,0,0,0})
		case aTmp[i,4] == "002"
			aadd(aRet,{aTmp[i,3],0,aTmp[i,2],0,0,0})
		case aTmp[i,4] == "003"
			aadd(aRet,{aTmp[i,3],0,0,aTmp[i,2],0,0})
		case aTmp[i,4] == "004"
			aadd(aRet,{aTmp[i,3],0,0,0,aTmp[i,2],0})
		case aTmp[i,4] == "005"
			aadd(aRet,{aTmp[i,3],0,0,0,0,aTmp[i,2]})
	endcase
next i

restArea(aArea)
return aRet


//Busca Saldo Bancario - SE8
static function getSaldo(dData)
local aTmp := {}
local aRet := {}
local cQuery := ""
local aArea := getArea()
Local i


cQuery += " SELECT 'CIF     ' AS EMPRESA,B.A6_NREDUZ,A.E8_BANCO,A.E8_AGENCIA,A.E8_CONTA, "
cQuery += " SUM(A.E8_SALATUA) AS SALDO,SUM(A.E8_SALRECO) AS SLDRECO,SUM(B.A6_LIMCRED)AS LIMITE "
cQuery += " FROM SE8010 A JOIN SA6010 B ON A.E8_BANCO = B.A6_COD AND A.E8_AGENCIA = B.A6_AGENCIA AND A.E8_CONTA = B.A6_NUMCON "
cQuery += " WHERE E8_DTSALAT = (SELECT MAX(D.E8_DTSALAT) FROM SE8010 D WHERE D.E8_DTSALAT <= '" + dtos(dData)+ "' AND D.E8_BANCO = A.E8_BANCO "
cQuery += " AND D.E8_AGENCIA = A.E8_AGENCIA AND D.E8_CONTA = A.E8_CONTA AND D.D_E_L_E_T_ <> '*') AND A.D_E_L_E_T_ <> '*' AND B.D_E_L_E_T_ <> '*' AND B.A6_BLOCKED <> 1 "
cQuery += " GROUP BY B.A6_NREDUZ,A.E8_BANCO,A.E8_AGENCIA,A.E8_CONTA "
cQuery += " UNION ALL "
cQuery += " SELECT 'TANGARA ' AS EMPRESA, B.A6_NREDUZ,A.E8_BANCO,A.E8_AGENCIA,A.E8_CONTA, "
cQuery += " SUM(A.E8_SALATUA) AS SALDO,SUM(A.E8_SALRECO) AS SLDRECO,SUM(B.A6_LIMCRED)AS LIMITE "
cQuery += " FROM SE8020 A JOIN SA6020 B ON A.E8_BANCO = B.A6_COD AND A.E8_AGENCIA = B.A6_AGENCIA AND A.E8_CONTA = B.A6_NUMCON "
cQuery += " WHERE E8_DTSALAT = (SELECT MAX(D.E8_DTSALAT) FROM SE8020 D WHERE D.E8_DTSALAT <= '" + dtos(dData)+ "' AND D.E8_BANCO = A.E8_BANCO "
cQuery += " AND D.E8_AGENCIA = A.E8_AGENCIA AND D.E8_CONTA = A.E8_CONTA AND D.D_E_L_E_T_ <> '*') AND A.D_E_L_E_T_ <> '*' AND B.D_E_L_E_T_ <> '*' AND B.A6_BLOCKED <> 1 "
cQuery += " GROUP BY B.A6_NREDUZ,A.E8_BANCO,A.E8_AGENCIA,A.E8_CONTA "
cQuery += " UNION ALL "
cQuery += " SELECT 'VIGON   ' AS EMPRESA, B.A6_NREDUZ,A.E8_BANCO,A.E8_AGENCIA,A.E8_CONTA, "
cQuery += " SUM(A.E8_SALATUA) AS SALDO,SUM(A.E8_SALRECO) AS SLDRECO,SUM(B.A6_LIMCRED)AS LIMITE "
cQuery += " FROM SE8030 A JOIN SA6030 B ON A.E8_BANCO = B.A6_COD AND A.E8_AGENCIA = B.A6_AGENCIA AND A.E8_CONTA = B.A6_NUMCON "
cQuery += " WHERE E8_DTSALAT = (SELECT MAX(D.E8_DTSALAT) FROM SE8030 D WHERE D.E8_DTSALAT <= '" + dtos(dData)+ "' AND D.E8_BANCO = A.E8_BANCO "
cQuery += " AND D.E8_AGENCIA = A.E8_AGENCIA AND D.E8_CONTA = A.E8_CONTA AND D.D_E_L_E_T_ <> '*') AND A.D_E_L_E_T_ <> '*' AND B.D_E_L_E_T_ <> '*'  AND B.A6_BLOCKED <> 1 "
cQuery += " GROUP BY B.A6_NREDUZ,A.E8_BANCO,A.E8_AGENCIA,A.E8_CONTA "
cQuery += " UNION ALL "
cQuery += " SELECT 'FLAVIO  ' AS EMPRESA, B.A6_NREDUZ,A.E8_BANCO,A.E8_AGENCIA,A.E8_CONTA, "
cQuery += " SUM(A.E8_SALATUA) AS SALDO,SUM(A.E8_SALRECO) AS SLDRECO,SUM(B.A6_LIMCRED)AS LIMITE "
cQuery += " FROM SE8040 A JOIN SA6040 B ON A.E8_BANCO = B.A6_COD AND A.E8_AGENCIA = B.A6_AGENCIA AND A.E8_CONTA = B.A6_NUMCON "
cQuery += " WHERE E8_DTSALAT = (SELECT MAX(D.E8_DTSALAT) FROM SE8040 D WHERE D.E8_DTSALAT <= '" + dtos(dData)+ "' AND D.E8_BANCO = A.E8_BANCO "
cQuery += " AND D.E8_AGENCIA = A.E8_AGENCIA AND D.E8_CONTA = A.E8_CONTA AND D.D_E_L_E_T_ <> '*') AND A.D_E_L_E_T_ <> '*' AND B.D_E_L_E_T_ <> '*' AND B.A6_BLOCKED <> 1 "
cQuery += " GROUP BY B.A6_NREDUZ,A.E8_BANCO,A.E8_AGENCIA,A.E8_CONTA "
cQuery += " UNION ALL "
cQuery += " SELECT 'F CUNHA' AS EMPRESA,B.A6_NREDUZ,A.E8_BANCO,A.E8_AGENCIA,A.E8_CONTA, "
cQuery += " SUM(A.E8_SALATUA) AS SALDO,SUM(A.E8_SALRECO) AS SLDRECO,SUM(B.A6_LIMCRED)AS LIMITE "
cQuery += " FROM SE8050 A JOIN SA6050 B ON A.E8_BANCO = B.A6_COD AND A.E8_AGENCIA = B.A6_AGENCIA AND A.E8_CONTA = B.A6_NUMCON "
cQuery += " WHERE E8_DTSALAT = (SELECT MAX(D.E8_DTSALAT) FROM SE8050 D WHERE D.E8_DTSALAT <= '" + dtos(dData)+ "' AND D.E8_BANCO = A.E8_BANCO "
cQuery += " AND D.E8_AGENCIA = A.E8_AGENCIA AND D.E8_CONTA = A.E8_CONTA AND D.D_E_L_E_T_ <> '*') AND A.D_E_L_E_T_ <> '*' AND B.D_E_L_E_T_ <> '*' AND B.A6_BLOCKED <> 1 "
cQuery += " GROUP BY B.A6_NREDUZ,A.E8_BANCO,A.E8_AGENCIA,A.E8_CONTA "

if Select("TRB2") > 0
	dbSelectArea("TRB2")
	dbCloseArea("TRB2")
endif

dbUseArea(.T.,"TOPCONN",TCGenQry(,,ALLTRIM(Upper(cQuery))),'TRB2',.F.,.T.)

while TRB2->(!eof())
	
	aadd(aRet,{TRB2->EMPRESA,TRB2->E8_BANCO,TRB2->E8_AGENCIA,TRB2->E8_CONTA,TRB2->SALDO,TRB2->SLDRECO,TRB2->LIMITE,TRB2->A6_NREDUZ,0})
	
	TRB2->(dbSkip())
Enddo

DbCloseArea("TRB2")

restArea(aArea)
return aRet


static function printSaldo(aSaldo)
Local i
nLinha += nSalto
oPrint:Say (nLinha,1030,"SALDOS BANCARIOS",oFont12)
nLinha += nSalto*2
nAux := nLinha
oPrint:Line(nLinha,0050,nLinha,nColDireita,oFont12n)
oPrint:Say (nLinha,0060,"EMPRESA" ,oFont12)
oPrint:Say (nLinha,0390,"BANCO" ,oFont12)
oPrint:Say (nLinha,0780,"SALDO ANTERIOR" ,oFont12)
oPrint:Say (nLinha,1330,"SALDO" ,oFont12)
oPrint:Say (nLinha,1710,"LIMITES" ,oFont12)
oPrint:Say (nLinha,1910,"CONCILIADO" ,oFont12)
nLinha += nSalto


aTot := {0,0,0,0}
for i := 1 to len(aSaldo)
	oPrint:Say (nLinha,0060,aSaldo[i,1]  ,oFont12n) //Empresa
	oPrint:Say (nLinha,0390,aSaldo[i,8],oFont12n) //Banco
	oPrint:Say (nLinha,0840,transform(aSaldo[i,9],"@E 999,999,999.99") ,oFont10C) //Saldo Anterior
	aTot[1] += aSaldo[i,9]
	
	oPrint:Say (nLinha,1200,transform(aSaldo[i,5],"@E 999,999,999.99") ,oFont10C) //Saldo
	aTot[2] += aSaldo[i,5]
	
	oPrint:Say (nLinha,1600,transform(aSaldo[i,7],"@E 999,999,999.99") ,oFont10C) //Limite
	aTot[3] += aSaldo[i,7]
	
	oPrint:Say (nLinha,1920,transform(aSaldo[i,6],"@E 999,999,999.99") ,oFont10C) //Saldo Reconciliado
	aTot[4] += aSaldo[i,6]
	
	oPrint:Line(nLinha,0050,nLinha,nColDireita,oFont12n)
	nLinha += nSalto
next i

//Imprime Totais
oPrint:Line(nLinha,0050,nLinha,nColDireita,oFont12n)
//nLinha += nSalto
oPrint:Say (nLinha,0060,"TOTAIS",oFont12)
oPrint:Say (nLinha,0840,transform(aTot[1],"@E 999,999,999.99") ,oFont10C)
oPrint:Say (nLinha,1200,transform(aTot[2],"@E 999,999,999.99") ,oFont10C)
oPrint:Say (nLinha,1600,transform(aTot[3],"@E 999,999,999.99") ,oFont10C)
oPrint:Say (nLinha,1920,transform(aTot[4],"@E 999,999,999.99") ,oFont10C)
nLinha += nSalto
oPrint:Line(nLinha,0050,nLinha,nColDireita,oFont12n)


//Imprime Linhas verticais
oPrint:Line(nAux,370,nLinha,370,oFont12)
oPrint:Line(nAux,740,nLinha,740,oFont12)
oPrint:Line(nAux,1110,nLinha,1110,oFont12)
oPrint:Line(nAux,1480,nLinha,1480,oFont12)
oPrint:Line(nAux,1870,nLinha,1870,oFont12)
nLinha += nSalto


return

static function updSaldo(aSaldo1,aSaldo2)
Local i
//Atualiza Saldo
for i := 1 to len(aSaldo2)
	nIndex := ascan(aSaldo1,{|x| x[1] == aSaldo2[i,1] .and. x[2] ==  aSaldo2[i,2] .and. x[3] == aSaldo2[i,3] .and. x[4] == aSaldo2[i,4] })
	if nIndex > 0
		aSaldo2[i,9] += aSaldo1[nIndex,5]
		
	endif
next i
return aSaldo2


static function getNomFilial(cEmp,cFil)
local cRet := ""
cEmpOri := 	cEmpAnt
cFilOri := 	cFilAnt
dbSelectArea("SM0")
SM0->(dbSeek(cEmp+cFil))
cRet := substr(SM0->M0_FILIAL,1,10)


cEmpAnt := cEmpOri
cFilAnt := cFilOri

return cRet



