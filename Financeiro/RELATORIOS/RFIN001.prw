#include "protheus.ch"
#include "rwmake.ch"
#include "topconn.ch"
#include "report.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RFIN001   ºAutor  ³Jeovane             º Data ³  15/07/08   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Relacao de titulos emitidos - contas a pagar                º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ SIGAFIN - CIF                                              º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

user function RFIN001()

Local oReport
Private oSE2,oSE2A
Private cPerg := "RFIN001"
Private QRYSE2


ValidPerg()
pergunte(cPerg,.F.)



DEFINE REPORT oReport NAME "RFIN001" TITLE "RELAÇÃO DE TÍTULOS A PAGAR " PARAMETER cPerg ACTION {|oReport| PrintReport(oReport)}


oReport:SetTotalInLine(.F.)
oReport:HideParamPage()


oReport:SetLandscape() //Seta Relatorio Paisagem
DEFINE SECTION oSE2 OF oReport TITLE "Fornecedor" TABLES "SA2"
DEFINE CELL NAME "EMPRESA" 		    OF oSE2 ALIAS "SA2" TITLE "Empresa"
DEFINE CELL NAME "E2_FILIAL"        OF oSE2 ALIAS "SA2" TITLE "Filial"
DEFINE CELL NAME "NOMEFIL"          OF oSE2 ALIAS "SA2" TITLE "Nome"  BLOCK{|| getDesc(QRYSE2->EMPRESA , QRYSE2->E2_FILIAL) } SIZE 40



DEFINE SECTION oSE2A OF oSE2 TITLE "Titulos" TABLES "SE2","SA2","SED"
DEFINE CELL NAME "A2_COD" 	       OF oSE2A ALIAS "SE2" TITLE "Cod"
DEFINE CELL NAME "E2_LOJA"   	    OF oSE2A ALIAS "SE2" TITLE "Loja"
DEFINE CELL NAME "A2_NOME"   	    OF oSE2A ALIAS "SE2" TITLE "Nome"
DEFINE CELL NAME "E2_PREFIXO" 	    OF oSE2A ALIAS "SE2" TITLE "Pref"
DEFINE CELL NAME "E2_NUM" 	        OF oSE2A ALIAS "SE2" TITLE "Numero"
DEFINE CELL NAME "E2_PARCELA" 	    OF oSE2A ALIAS "SE2" TITLE "Par"
DEFINE CELL NAME "E2_TIPO"   	    OF oSE2A ALIAS "SE2" TITLE "Tipo"
DEFINE CELL NAME "ED_DESCRIC"  	    OF oSE2A ALIAS "SE2" TITLE "Natureza"
DEFINE CELL NAME "E2_EMIS1" 		OF oSE2A ALIAS "SE2" TITLE "Emissao"
DEFINE CELL NAME "E2_VENCREA" 		OF oSE2A ALIAS "SE2" TITLE "Vencimento"
DEFINE CELL NAME "E2_OBSERV"   		OF oSE2A ALIAS "SE2" TITLE "Observacao"
//DEFINE CELL NAME "E2_SALDO" 		OF oSE2A ALIAS "SE2" TITLE "Saldo"     PICTURE "@E 999,999,999.99" SIZE 14
DEFINE CELL NAME "E2_VALOR" 		OF oSE2A ALIAS "SE2" TITLE "Vr.Titulo"     PICTURE "@E 999,999,999.99" SIZE 14
DEFINE CELL NAME "PAGO"     		OF oSE2A ALIAS "SE2" TITLE "Vr. Pago"  BLOCK{|| QRYSE2->E2_VALOR - QRYSE2->E2_SALDO} PICTURE "@E 999,999,999.99" SIZE 14

oSE2A:SetTotalInLine(.F.)
oSE2A:SetTotalText("Sub-Total")

oSE2:SetLineCondition({|| QRYSE2->EMPRESA >= MV_PAR01 .AND. QRYSE2->EMPRESA <= MV_PAR03 })
oSE2A:SetLineCondition({|| QRYSE2->EMPRESA >= MV_PAR01 .AND. QRYSE2->EMPRESA <= MV_PAR03 })

DEFINE FUNCTION FROM oSE2A:Cell("E2_VALOR")   FUNCTION SUM
//DEFINE FUNCTION FROM oSE2A:Cell("E2_SALDO")   FUNCTION SUM
DEFINE FUNCTION FROM oSE2A:Cell("PAGO")       FUNCTION SUM

oReport:PrintDialog()
Return


Static Function PrintReport(oReport)

Local cFiltro := "%"
Local cFiltroEmp := "%"
//Define o filtro de acordo com os parametros digitados

//filtro empresa
//if ((!empty(mv_par01)) .and. (!empty(mv_par03)))
//  	cFiltro += " AND EMPRESA BETWEEN '" + mv_par01 + "' AND '" + mv_par03 + "'"
//endif

//filtro Loja
if ((!empty(mv_par02)) .and. (!empty(mv_par04)))
 	cFiltro += " AND A.E2_FILIAL BETWEEN '" + mv_par02 + "' AND '" + mv_par04 + "'"
endif

//filtro prefixo
if ((!empty(mv_par05)) .and. (!empty(mv_par06)))
	cFiltro += " AND A.E2_PREFIXO BETWEEN '" + mv_par05 + "' AND '" + mv_par06 + "'"
endif

//filtro titulo
if ((!empty(mv_par07)) .and. (!empty(mv_par08)))
	cFiltro += " AND A.E2_NUM BETWEEN '" + mv_par07 + "' AND '" + mv_par08 + "'"
endif

//filtro natureza
if ((!empty(mv_par09)) .and. (!empty(mv_par10)))
	cFiltro += " AND B.ED_CODIGO BETWEEN '" + mv_par09 + "' AND '" + mv_par10 + "'"
endif 
//filtro emissao
if ((!empty(mv_par11)) .and. (!empty(mv_par12)))
	cFiltro += " AND A.E2_EMISSAO BETWEEN '" + dtos(mv_par11) + "' AND '" + dtos(mv_par12)  + "'"
endif
//filtro vencimento
if ((!empty(mv_par13)) .and. (!empty(mv_par14)))
	cFiltro += " AND A.E2_VENCREA BETWEEN '" + dtos(mv_par13) + "' AND '" + dtos(mv_par14) + "'"
endif

//filtro fornecedor
if ((!empty(mv_par15)) .and. (!empty(mv_par17)))
	cFiltro += " AND A.E2_FORNECE BETWEEN '" + mv_par15 + "' AND '" + mv_par17 + "'"
endif

//filtro Loja
if ((!empty(mv_par16)) .and. (!empty(mv_par18)))
	cFiltro += " AND A.E2_LOJA BETWEEN '" + mv_par16 + "' AND '" + mv_par18 + "'"
endif


if !empty(mv_par19)
	cFiltro += " AND A.E2_TIPO IN " +   formatin(mv_par19,";")
elseif !empty(mv_par20)
	cFiltro += " AND A.E2_TIPO NOT IN " +   formatin(mv_par20,";")
endif

if mv_par21 == 1
	cFiltro += " AND A.E2_SALDO =  A.E2_VALOR "
elseif mv_par21 == 2
	cFiltro += " AND A.E2_SALDO <>  A.E2_VALOR "
endif

cFiltro += " %"

//Define Query para Relatorio 
BEGIN REPORT QUERY oReport:Section(1)
BeginSql alias "QRYSE2"   	
	SELECT 
		'01' AS 'EMPRESA',A.E2_FILIAL, A.E2_PREFIXO,A.E2_NUM,A.E2_TIPO,A.E2_EMISSAO,A.E2_VENCREA,
		A.E2_VALOR,A.E2_SALDO,A.E2_HIST,A.E2_EMIS1,A.E2_NATUREZ,B.ED_DESCRIC,A.E2_OBSERV,A.E2_PARCELA,
		A.E2_FORNECE,A.E2_NOMFOR,C.A2_COD,C.A2_NOME,C.A2_LOJA
	FROM 
		SE2010 A 			
		JOIN SED010 B ON A.E2_NATUREZ = B.ED_CODIGO
		JOIN SA2010 C ON A.E2_FORNECE = C.A2_COD AND A.E2_LOJA = C.A2_LOJA
	WHERE
		A.%notDel%
	    AND B.%notDel%	   
  	    AND C.%notDel%
	    %Exp:cFiltro%
	   
	UNION ALL 
	SELECT 
		'02' AS 'EMPRESA',A.E2_FILIAL, A.E2_PREFIXO,A.E2_NUM,A.E2_TIPO,A.E2_EMISSAO,A.E2_VENCREA,
		A.E2_VALOR,A.E2_SALDO,A.E2_HIST,A.E2_EMIS1,A.E2_NATUREZ,B.ED_DESCRIC,A.E2_OBSERV,A.E2_PARCELA,
		A.E2_FORNECE,A.E2_NOMFOR,C.A2_COD,C.A2_NOME,C.A2_LOJA
	FROM 
		SE2020 A 			
		JOIN SED010 B ON A.E2_NATUREZ = B.ED_CODIGO
		JOIN SA2010 C ON A.E2_FORNECE = C.A2_COD AND A.E2_LOJA = C.A2_LOJA
	WHERE
	    A.%notDel%
	    AND B.%notDel%		   
   	    AND C.%notDel%
	    %Exp:cFiltro%
		
	UNION ALL 
	SELECT 
		'03' AS 'EMPRESA',A.E2_FILIAL, A.E2_PREFIXO,A.E2_NUM,A.E2_TIPO,A.E2_EMISSAO,A.E2_VENCREA,
		A.E2_VALOR,A.E2_SALDO,A.E2_HIST,A.E2_EMIS1,A.E2_NATUREZ,B.ED_DESCRIC,A.E2_OBSERV,A.E2_PARCELA,
		A.E2_FORNECE,A.E2_NOMFOR,C.A2_COD,C.A2_NOME,C.A2_LOJA
	FROM 
		SE2030 A 			
		JOIN SED010 B ON A.E2_NATUREZ = B.ED_CODIGO
		JOIN SA2010 C ON A.E2_FORNECE = C.A2_COD AND A.E2_LOJA = C.A2_LOJA
	WHERE
	    A.%notDel%
	    AND B.%notDel%		   	    		 		    
	    AND C.%notDel%
	    %Exp:cFiltro%
	
	UNION ALL 
	SELECT 
		'04' AS 'EMPRESA',A.E2_FILIAL, A.E2_PREFIXO,A.E2_NUM,A.E2_TIPO,A.E2_EMISSAO,A.E2_VENCREA,
	  	A.E2_VALOR,A.E2_SALDO,A.E2_HIST,A.E2_EMIS1,A.E2_NATUREZ,B.ED_DESCRIC,A.E2_OBSERV,A.E2_PARCELA,
	  	A.E2_FORNECE,A.E2_NOMFOR,C.A2_COD,C.A2_NOME,C.A2_LOJA
	FROM 
		SE2040 A 			
		JOIN SED010 B ON A.E2_NATUREZ = B.ED_CODIGO
		JOIN SA2010 C ON A.E2_FORNECE = C.A2_COD AND A.E2_LOJA = C.A2_LOJA
	WHERE
	   A.%notDel%
	   AND B.%notDel%		   
       AND C.%notDel%
	   %Exp:cFiltro% 
	
	UNION ALL   
	SELECT 
		'05' AS 'EMPRESA',A.E2_FILIAL, A.E2_PREFIXO,A.E2_NUM,A.E2_TIPO,A.E2_EMISSAO,A.E2_VENCREA,
	  	A.E2_VALOR,A.E2_SALDO,A.E2_HIST,A.E2_EMIS1,A.E2_NATUREZ,B.ED_DESCRIC,A.E2_OBSERV,A.E2_PARCELA,
	  	A.E2_FORNECE,A.E2_NOMFOR,C.A2_COD,C.A2_NOME,C.A2_LOJA
	FROM 
		SE2050 A 			
		JOIN SED010 B ON A.E2_NATUREZ = B.ED_CODIGO
		JOIN SA2010 C ON A.E2_FORNECE = C.A2_COD AND A.E2_LOJA = C.A2_LOJA
	WHERE
	   A.%notDel%
	   AND B.%notDel%		   
       AND C.%notDel%
	   %Exp:cFiltro%
	
	ORDER BY 
	1,2,7
EndSql
END REPORT QUERY oReport:Section(1)


oReport:Section(1):Section(1):SetParentQuery()
oReport:Section(1):Section(1):SetParentFilter({|cParam| QRYSE2->EMPRESA + QRYSE2->E2_FILIAL == cParam },{|| QRYSE2->EMPRESA + QRYSE2->E2_FILIAL})

oReport:Section(1):Print(.T.)

return


Static Function ValidPerg()

Local _sAlias := Alias()
Local aRegs := {}
Local i,j

dbSelectArea("SX1")
dbSetOrder(1)

cPerg := PADR(cPerg,10)

//(sx1) Grupo/Ordem/Pergunta/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid/Var01/Def01/Cnt01/Var02/Def02/Cnt02/Var03/Def03/Cnt03/Var04/Def04/Cnt04/Var05/Def05/Cnt05
aAdd(aRegs,{cPerg,"01","Da Empresa         ","","","mv_ch1" ,"C", 2,0,0,"G","", "mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","RM0",""})
aAdd(aRegs,{cPerg,"02","Da Filial          ","","","mv_ch2" ,"C", 2,0,0,"G","", "mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"03","Ate Empresa        ","","","mv_ch3" ,"C", 2,0,0,"G","", "mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","RM0",""})
aAdd(aRegs,{cPerg,"04","Ate Filial         ","","","mv_ch4" ,"C", 2,0,0,"G","", "mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"05","Do Prefixo         ","","","mv_ch5" ,"C", 3,0,0,"G","", "mv_par05","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"06","Ate o Prefixo      ","","","mv_ch6" ,"C", 3,0,0,"G","", "mv_par06","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"07","Do Titulo          ","","","mv_ch7" ,"C", 9,0,0,"G","", "mv_par07","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"08","Ate o Titulo       ","","","mv_ch8" ,"C", 9,0,0,"G","", "mv_par08","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"09","Da Natureza        ","","","mv_ch9" ,"C", 10,0,0,"G","" ,"mv_par09","","","","","","","","","","","","","","","","","","","","","","","","","SED",""})
aAdd(aRegs,{cPerg,"10","Ate a natureza     ","","","mv_ch10" ,"C", 10,0,0,"G","","mv_par10","","","","","","","","","","","","","","","","","","","","","","","","","SED",""})
aAdd(aRegs,{cPerg,"11","De Emissao:        ","","","mv_ch11" ,"D", 8,0,0,"G","","mv_par11","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"12","Ate Emissao:       ","","","mv_ch12" ,"D", 8,0,0,"G","","mv_par12","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"13","De Vencimento:     ","","","mv_ch13" ,"D", 8,0,0,"G","","mv_par13","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"14","Ate Vencimento:    ","","","mv_ch14" ,"D", 8,0,0,"G","","mv_par14","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"15","Do Fornecedor      ","","","mv_ch15" ,"C", 6,0,0,"G","","mv_par15","","","","","","","","","","","","","","","","","","","","","","","","","FOR",""})
aAdd(aRegs,{cPerg,"16","Loja               ","","","mv_ch16" ,"C", 2,0,0,"G","","mv_par16","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"17","Ate Fornecedor     ","","","mv_ch17" ,"C", 6,0,0,"G","","mv_par17","","","","","","","","","","","","","","","","","","","","","","","","","FOR",""})
aAdd(aRegs,{cPerg,"18","Loja               ","","","mv_ch18" ,"C", 2,0,0,"G","","mv_par18","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"19","Imprimir Tipos:    ","","","mv_ch19" ,"C", 25,0,0,"R","","mv_par19","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"20","Nao Imprimir Tipos:","","","mv_ch20" ,"C", 25,0,0,"R","","mv_par20","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"21","Imprimir           ","","","mv_ch21" ,"C", 1,0,0,"C","","mv_par21","Aberto","","","","","Recebido","","","","","Todos","","","","","","","","","","","","","","",""})

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


static function getDesc(cEmp,cFil)
local aArea := getArea()
local cRet := ""

dbSelectArea("SM0")
dbSetOrder(1)
dbSeek(cEmp+cFil)

cRet := SM0->M0_NOMECOM





restArea(aArea)
return cRet



