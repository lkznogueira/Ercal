#include "protheus.ch"
#include "rwmake.ch"
#include "topconn.ch"
#include "report.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RFIN004   ºAutor  ³Jeovane             º Data ³  15/07/08   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Relacao de Saldos bancarios - mostra o saldo disponivel     º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ SIGAFIN - CIF                                              º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User function RFIN004()

Local oReport
Local oBreak 
Local oSection
Private oSE8,oSE8A
Private cPerg := "RFIN004"
Private QRYSE8


ValidPerg()
pergunte(cPerg,.F.)



DEFINE REPORT oReport NAME "RFIN004" TITLE "RESUMO DE SALDOS BANCÁRIOS " PARAMETER cPerg ACTION {|oReport| PrintReport(oReport)}


oReport:SetTotalInLine(.F.)
oReport:HideParamPage()


//oReport:SetLandscape()  Muda relatorio para paisagem
DEFINE SECTION oSE8 OF oReport TITLE "Banco" TABLES "SA6"
DEFINE CELL NAME "E8_DTSALAT"       OF oSE8 ALIAS "SE8" TITLE "Data"  

//oBreak := TRBreak():New(oSection,oSection:Cell("A6_COD"),"Bancos")

DEFINE SECTION oSE8A OF oSE8 TITLE "Bancos" TABLES "SE8"    
DEFINE CELL NAME "EMPRESA" 		    OF oSE8A ALIAS "SA6" TITLE "Empresa"  //BLOCK{||QRYSE8->EMPRESA}
DEFINE CELL NAME "NOMEFIL"          OF oSE8A ALIAS "SE8" TITLE "Nome"  BLOCK{|| getDesc(QRYSE8->EMPRESA , QRYSE8->E8_FILIAL) } SIZE 40
DEFINE CELL NAME "A6_COD" 		    OF oSE8A ALIAS "SA6" TITLE "Cod"
DEFINE CELL NAME "A6_NOME"          OF oSE8A ALIAS "SA6" TITLE "Banco"
DEFINE CELL NAME "E8_AGENCIA" 	    OF oSE8A ALIAS "SE8" TITLE "Agencia"
DEFINE CELL NAME "E8_CONTA"   	    OF oSE8A ALIAS "SE8" TITLE "Conta"
DEFINE CELL NAME "E8_SALATUA"  	    OF oSE8A ALIAS "SE8" TITLE "Saldo" PICTURE "@E 999,999,999.99" SIZE 14 
DEFINE CELL NAME "A6_LIMCRED" 	    OF oSE8A ALIAS "SA6" TITLE "Limite" PICTURE "@E 999,999,999.99" SIZE 14 
DEFINE CELL NAME "TOTAL" 	        OF oSE8A ALIAS "SE8" TITLE "Total" PICTURE "@E 999,999,999.99" SIZE 14 BLOCK{|| QRYSE8->E8_SALATUA+QRYSE8->A6_LIMCRED}



oSE8A:SetTotalInLine(.F.)
oSE8A:SetTotalText("Sub-Total")

oSE8A:CELL("TOTAL"):SetHeaderAlign("RIGHT")

//oSE8:SetLineCondition({|| QRYSE8->EMPRESA >= MV_PAR01 .AND. QRYSE8->EMPRESA <= MV_PAR03 })
oSE8A:SetLineCondition({|| QRYSE8->EMPRESA >= MV_PAR01 .AND. QRYSE8->EMPRESA <= MV_PAR03 })

DEFINE FUNCTION FROM oSE8A:Cell("E8_SALATUA")   FUNCTION SUM
DEFINE FUNCTION FROM oSE8A:Cell("A6_LIMCRED")   FUNCTION SUM
DEFINE FUNCTION FROM oSE8A:Cell("TOTAL")        FUNCTION SUM


oReport:PrintDialog()
Return

/*************************************/
Static Function PrintReport(oReport)
/************************************/ 

Local cFiltro := "%"
Local cFiltro1 := "%"
Local cFiltro2 := "%"
Local cFiltro3 := "%"
Local cFiltro4 := "%"
Local cFiltroEmp := "%"
//Define o filtro de acordo com os parametros digitados

//filtro Loja
if ((!empty(mv_par02)) .and. (!empty(mv_par04)))
 	cFiltro += " AND B.E8_FILIAL BETWEEN '" + mv_par02 + "' AND '" + mv_par04 + "'"
endif

//filtro data
if (!empty(mv_par07))
	cFiltro1 += " AND B.E8_DTSALAT = " + "(SELECT MAX(E8_DTSALAT) FROM SE8010 WHERE E8_DTSALAT <= '"+ dtos(mv_par07)+ "')"
endif  

if (!empty(mv_par07))
        cFiltro2 += " AND B.E8_DTSALAT = " + "(SELECT MAX(E8_DTSALAT) FROM SE8020 WHERE E8_DTSALAT <= '"+ dtos(mv_par07)+ "')"
endif

if (!empty(mv_par07))
	cFiltro3 += " AND B.E8_DTSALAT = " + "(SELECT MAX(E8_DTSALAT) FROM SE8030 WHERE E8_DTSALAT <= '"+ dtos(mv_par07)+ "')"
endif

if (!empty(mv_par07))
	cFiltro4 += " AND B.E8_DTSALAT = " + "(SELECT MAX(E8_DTSALAT) FROM SE8040 WHERE E8_DTSALAT <= '"+ dtos(mv_par07)+ "')"
endif



//filtro Banco
if ((!empty(mv_par05)) .and. (!empty(mv_par06)))
 	cFiltro += " AND B.E8_BANCO BETWEEN '" + mv_par05 + "' AND '" + mv_par06 + "'"
endif

cFiltro += " %"
cFiltro1 += " %"
cFiltro2 += " %"
cFiltro3 += " %"
cFiltro4 += " %"

//Define Query para Relatorio 
BEGIN REPORT QUERY oReport:Section(1)
BeginSql alias "QRYSE8"   	
	SELECT 
		'01' AS 'EMPRESA',B.E8_FILIAL,A.A6_COD,A.A6_NOME,B.E8_DTSALAT,B.E8_AGENCIA,B.E8_CONTA,
		B.E8_SALATUA,A.A6_LIMCRED
	FROM 
		SA6010 A
		JOIN SE8010 B ON B.E8_BANCO = A.A6_COD 
		AND B.E8_AGENCIA = A.A6_AGENCIA AND B.E8_CONTA = A.A6_NUMCON	
	WHERE
		A.%notDel%
		%Exp:cFiltro1%
	    AND B.%notDel%	   	    
	    %Exp:cFiltro%
	   
	UNION ALL 
	SELECT 
		'02' AS 'EMPRESA',B.E8_FILIAL,A.A6_COD,A.A6_NOME,B.E8_DTSALAT,B.E8_AGENCIA,B.E8_CONTA,
		B.E8_SALATUA,A.A6_LIMCRED
	FROM 
		SA6020 A
		JOIN SE8020 B ON B.E8_BANCO = A.A6_COD 
		AND B.E8_AGENCIA = A.A6_AGENCIA AND B.E8_CONTA = A.A6_NUMCON	
	WHERE
	    A.%notDel%
            %Exp:cFiltro2%
	    AND B.%notDel%	   	    
	    %Exp:cFiltro%
		
	UNION ALL 
	SELECT 
		'03' AS 'EMPRESA',B.E8_FILIAL,A.A6_COD,A.A6_NOME,B.E8_DTSALAT,B.E8_AGENCIA,B.E8_CONTA,
		B.E8_SALATUA,A.A6_LIMCRED
	FROM 
		SA6030 A
		JOIN SE8030 B ON B.E8_BANCO = A.A6_COD 
		AND B.E8_AGENCIA = A.A6_AGENCIA AND B.E8_CONTA = A.A6_NUMCON	
	WHERE
		A.%notDel%
		%Exp:cFiltro3%
	    AND B.%notDel%	   	    
	    %Exp:cFiltro%
	
	UNION ALL 
	SELECT 
		'04' AS 'EMPRESA',B.E8_FILIAL,A.A6_COD,A.A6_NOME,B.E8_DTSALAT,B.E8_AGENCIA,B.E8_CONTA,
		B.E8_SALATUA,A.A6_LIMCRED
	FROM 
		SA6040 A
		JOIN SE8040 B ON B.E8_BANCO = A.A6_COD 
		AND B.E8_AGENCIA = A.A6_AGENCIA AND B.E8_CONTA = A.A6_NUMCON	
	WHERE
		A.%notDel%
		%Exp:cFiltro4%
	    AND B.%notDel%	   	    
	    %Exp:cFiltro%		
	
     ORDER BY 
       3     
	
EndSql
END REPORT QUERY oReport:Section(1)


oReport:Section(1):Section(1):SetParentQuery()

oReport:Section(1):Section(1):SetParentFilter({|cParam| DTOS(QRYSE8->E8_DTSALAT) == cParam },{|| DTOS(QRYSE8->E8_DTSALAT) },{|cParam| QRYSE8->EMPRESA + QRYSE8->E8_FILIAL == cParam },{|| QRYSE8->EMPRESA + QRYSE8->E8_FILIAL})

oReport:Section(1):Print(.T.)

return

/**************************/
Static Function ValidPerg()
/**************************/


Local _sAlias := Alias()
Local aRegs := {}
Local i,j

dbSelectArea("SX1")
dbSetOrder(1)

cPerg := PADR(cPerg,10)

//(sx1) Grupo/Ordem/Pergunta/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid/Var01/Def01/Cnt01/Var02/Def02/Cnt02/Var03/Def03/Cnt03/Var04/Def04/Cnt04/Var05/Def05/Cnt05
aAdd(aRegs,{cPerg,"01","Da Empresa              ","","","mv_ch1" ,"C", 2,0,0,"G","", "mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","RM0",""})
aAdd(aRegs,{cPerg,"02","Da Filial               ","","","mv_ch2" ,"C", 2,0,0,"G","", "mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"03","Ate Empresa             ","","","mv_ch3" ,"C", 2,0,0,"G","", "mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","RM0",""})
aAdd(aRegs,{cPerg,"04","Ate Filial              ","","","mv_ch4" ,"C", 2,0,0,"G","", "mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"05","Do Banco                ","","","mv_ch5" ,"C", 3,0,0,"G","", "mv_par05","","","","","","","","","","","","","","","","","","","","","","","","","SA6",""})
aAdd(aRegs,{cPerg,"06","Ate Banco               ","","","mv_ch6" ,"C", 3,0,0,"G","", "mv_par06","","","","","","","","","","","","","","","","","","","","","","","","","SA6",""})
aAdd(aRegs,{cPerg,"07","Data da Disponibilidade:","","","mv_ch7" ,"D", 8,0,0,"G","", "mv_par07","","","","","","","","","","","","","","","","","","","","","","","","","",""})


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

/********************************/
Static function getDesc(cEmp,cFil)
/********************************/

Local aArea := getArea()
Local cRet := ""

	dbSelectArea("SM0")
	dbSetOrder(1)
	dbSeek(cEmp+cFil)

	cRet := SM0->M0_NOMECOM

  restArea(aArea)

Return cRet

