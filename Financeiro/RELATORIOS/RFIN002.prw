#include "protheus.ch"
#include "rwmake.ch"
#include "topconn.ch"
#include "report.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RFIN002   ºAutor  ³Jeovane             º Data ³  15/07/08   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Relacao de titulos emitidos - contas a receber              º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ SIGAFIN - CIf                                              º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function RFIN002()

Local oReport

Private oSE1
Private oSE1A
Private QRYSE1
Private cPerg := "RFIN002"
Private cMsg1 := ""

ValidPerg()
Pergunte(cPerg,.T.)
getName()

DEFINE REPORT oReport NAME "RFIN002" TITLE cMsg1 PARAMETER "" ACTION {|oReport| PrintReport(oReport) }

oReport:SetTotalInLine(.F.)
oReport:HideParamPage()
oReport:SetLandscape()

DEFINE SECTION oSE1 OF oReport TITLE "Cliente" TABLES "SA2"
DEFINE CELL NAME "EMPRESA" 		    OF oSE1 ALIAS "SA2" TITLE "Empresa"
DEFINE CELL NAME "E1_FILIAL"        OF oSE1 ALIAS "SA2" TITLE "Filial"
DEFINE CELL NAME "NOMEFIL"          OF oSE1 ALIAS "SA2" TITLE "Nome"  BLOCK{|| getDesc(QRYSE1->EMPRESA , QRYSE1->E1_FILIAL) } SIZE 40

DEFINE SECTION oSE1A OF oSE1 TITLE "Titulos" TABLES "SE1","SA2","SED"
DEFINE CELL NAME "E1_CLIENTE" 	    OF oSE1A ALIAS "SE1" TITLE "Cod"
DEFINE CELL NAME "E1_LOJA"   	    OF oSE1A ALIAS "SE1" TITLE "Loja"
DEFINE CELL NAME "A1_NOME"   	    OF oSE1A ALIAS "SE1" TITLE "Nome"
DEFINE CELL NAME "E1_PREFIXO" 	    OF oSE1A ALIAS "SE1" TITLE "Pref"
DEFINE CELL NAME "E1_NUM" 	        OF oSE1A ALIAS "SE1" TITLE "Numero"
DEFINE CELL NAME "E1_PARCELA" 	    OF oSE1A ALIAS "SE1" TITLE "Par"
DEFINE CELL NAME "E1_TIPO"   	    OF oSE1A ALIAS "SE1" TITLE "Tipo"
DEFINE CELL NAME "ED_DESCRIC"  	    OF oSE1A ALIAS "SE1" TITLE "Natureza"
DEFINE CELL NAME "E1_EMIS1" 		OF oSE1A ALIAS "SE1" TITLE "Emissao"
DEFINE CELL NAME "E1_VENCREA" 		OF oSE1A ALIAS "SE1" TITLE "Vencimento"
DEFINE CELL NAME "E1_FORMPAG" 		OF oSE1A ALIAS "SE1" TITLE "F.Pag"
DEFINE CELL NAME "E1_OBSERV"   		OF oSE1A ALIAS "SE1" TITLE "Observacao"
//DEFINE CELL NAME "E1_SALDO" 		OF oSE1A ALIAS "SE1" TITLE "Saldo"     PICTURE "@E 999,999,999.99" SIZE 14

DEFINE CELL NAME "E1_VALOR" 		OF oSE1A ALIAS "SE1" TITLE "Vr. Titulo"   BLOCK{|| If(alltrim(QRYSE1->E1_TIPO)$MVRECANT+","+MV_CRNEG,QRYSE1->E1_VALOR*-1,QRYSE1->E1_VALOR) } PICTURE PesqPict("SE1","E1_VALOR")
DEFINE CELL NAME "PAGO"     		OF oSE1A ALIAS "SE1" TITLE "Vr. Recebido" BLOCK{|| If(alltrim(QRYSE1->E1_TIPO)$MVRECANT+","+MV_CRNEG,(QRYSE1->E1_VALOR - QRYSE1->E1_SALDO)*-1,(QRYSE1->E1_VALOR - QRYSE1->E1_SALDO))} PICTURE  PesqPict("SE1","E1_VALOR")

oSE1A:SetTotalInLine(.F.)
oSE1A:SetTotalText("Sub-Total")

oSE1:SetLineCondition({|| QRYSE1->EMPRESA >= MV_PAR01 .AND. QRYSE1->EMPRESA <= MV_PAR03 })
oSE1A:SetLineCondition({|| QRYSE1->EMPRESA >= MV_PAR01 .AND. QRYSE1->EMPRESA <= MV_PAR03 })

DEFINE FUNCTION FROM oSE1A:Cell("E1_VALOR")   FUNCTION SUM
//DEFINE FUNCTION FROM oSE1A:Cell("E1_SALDO")   FUNCTION SUM
DEFINE FUNCTION FROM oSE1A:Cell("PAGO")       FUNCTION SUM

oReport:PrintDialog()
Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao	 ³PrintRepor³ Autor ³ TOTVS            	    ³ Data ³ 24.06.99 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³                   										  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function PrintReport(oReport)

Local cFiltro := "%"
Local cFiltroEmp := "%"
//Define o filtro de acordo com os parametros digitados

//filtro empresa
//If ((!empty(mv_par01)) .and. (!empty(mv_par03)))
//  	cFiltro += " AND EMPRESA BETWEEN '" + mv_par01 + "' AND '" + mv_par03 + "'"
//EndIf

//filtro Loja
If ((!empty(mv_par02)) .and. (!empty(mv_par04)))
 	cFiltro += " AND A.E1_FILIAL BETWEEN '" + mv_par02 + "' AND '" + mv_par04 + "'"
EndIf

//filtro prefixo
If ((!empty(mv_par05)) .and. (!empty(mv_par06)))
	cFiltro += " AND A.E1_PREFIXO BETWEEN '" + mv_par05 + "' AND '" + mv_par06 + "'"
EndIf

//filtro titulo
If ((!empty(mv_par07)) .and. (!empty(mv_par08)))
	cFiltro += " AND A.E1_NUM BETWEEN '" + mv_par07 + "' AND '" + mv_par08 + "'"
EndIf

//filtro natureza
If ((!empty(mv_par09)) .and. (!empty(mv_par10)))
	cFiltro += " AND B.ED_CODIGO BETWEEN '" + mv_par09 + "' AND '" + mv_par10 + "'"
EndIf 
//filtro emissao
If ((!empty(mv_par11)) .and. (!empty(mv_par12)))
	cFiltro += " AND A.E1_EMISSAO BETWEEN '" + dtos(mv_par11) + "' AND '" + dtos(mv_par12)  + "'"
EndIf
//filtro vencimento
If ((!empty(mv_par13)) .and. (!empty(mv_par14)))
	cFiltro += " AND A.E1_VENCREA BETWEEN '" + dtos(mv_par13) + "' AND '" + dtos(mv_par14) + "'"
EndIf

//filtro cliente
If ((!empty(mv_par15)) .and. (!empty(mv_par17)))
	cFiltro += " AND A.E1_CLIENTE BETWEEN '" + mv_par15 + "' AND '" + mv_par17 + "'"
EndIf

//filtro Loja
If ((!empty(mv_par16)) .and. (!empty(mv_par18)))
	cFiltro += " AND A.E1_LOJA BETWEEN '" + mv_par16 + "' AND '" + mv_par18 + "'"
EndIf   


If !empty(mv_par19)
	cFiltro += " AND A.E1_TIPO IN " +   formatin(mv_par19,";")
ElseIf !empty(mv_par20)
	cFiltro += " AND A.E1_TIPO NOT IN " +   formatin(mv_par20,";")
EndIf

If mv_par21 == 1//ABERTO
	//cFiltro += " AND A.E1_SALDO =  A.E1_VALOR "
	//Alterado em 19/02/10 para considerar as baixas parciais
	cFiltro += " AND A.E1_SALDO <=  A.E1_VALOR"
	cFiltro += " AND A.E1_SALDO > 0 "
ElseIf mv_par21 == 2//RECEBIDO
	cFiltro += " AND A.E1_SALDO <>  A.E1_VALOR "
EndIf

cFiltro += " %"

//Define Query para Relatorio 
BEGIN REPORT QUERY oReport:Section(1)
BeginSql alias "QRYSE1"   	
	SELECT 
		'01' AS 'EMPRESA',A.E1_FILIAL, A.E1_PREFIXO,A.E1_NUM,A.E1_TIPO,A.E1_EMISSAO,A.E1_VENCREA,
		A.E1_VALOR,A.E1_SALDO,A.E1_HIST,A.E1_EMIS1,A.E1_NATUREZ,B.ED_DESCRIC,A.E1_OBSERV,A.E1_FORMPAG,
		A.E1_PARCELA,A.E1_CLIENTE,A.E1_NOMCLI,C.A1_NOME
	FROM 
		SE1010 A 			
		JOIN SED010 B ON A.E1_NATUREZ = B.ED_CODIGO
		JOIN SA1010 C ON A.E1_CLIENTE = C.A1_COD AND A.E1_LOJA = C.A1_LOJA
	WHERE
		A.%notDel%
	    AND B.%notDel%	 
   	    AND C.%notDel%  	    
	    %Exp:cFiltro%
	    
	UNION ALL 
	SELECT 
		'02' AS 'EMPRESA',A.E1_FILIAL, A.E1_PREFIXO,A.E1_NUM,A.E1_TIPO,A.E1_EMISSAO,A.E1_VENCREA,
		A.E1_VALOR,A.E1_SALDO,A.E1_HIST,A.E1_EMIS1,A.E1_NATUREZ,B.ED_DESCRIC,A.E1_OBSERV,A.E1_FORMPAG,
		A.E1_PARCELA,A.E1_CLIENTE,A.E1_NOMCLI,C.A1_NOME
	FROM 
		SE1020 A 			
		JOIN SED010 B ON A.E1_NATUREZ = B.ED_CODIGO
		JOIN SA1010 C ON A.E1_CLIENTE = C.A1_COD AND A.E1_LOJA = C.A1_LOJA
	WHERE
	    A.%notDel%
	    AND B.%notDel% 
   	    AND C.%notDel%		   	 		   
	    %Exp:cFiltro%
		
	UNION ALL 
	SELECT 
		'03' AS 'EMPRESA',A.E1_FILIAL, A.E1_PREFIXO,A.E1_NUM,A.E1_TIPO,A.E1_EMISSAO,A.E1_VENCREA,
		A.E1_VALOR,A.E1_SALDO,A.E1_HIST,A.E1_EMIS1,A.E1_NATUREZ,B.ED_DESCRIC,A.E1_OBSERV,A.E1_FORMPAG,
		A.E1_PARCELA,A.E1_CLIENTE,A.E1_NOMCLI,C.A1_NOME
	FROM 
		SE1030 A 			
		JOIN SED010 B ON A.E1_NATUREZ = B.ED_CODIGO
		JOIN SA1010 C ON A.E1_CLIENTE = C.A1_COD AND A.E1_LOJA = C.A1_LOJA
	WHERE
	    A.%notDel%
	    AND B.%notDel% 
   	    AND C.%notDel%		   
	    %Exp:cFiltro%
	
	UNION ALL 
	SELECT 
		'04' AS 'EMPRESA',A.E1_FILIAL, A.E1_PREFIXO,A.E1_NUM,A.E1_TIPO,A.E1_EMISSAO,A.E1_VENCREA,
	  	A.E1_VALOR,A.E1_SALDO,A.E1_HIST,A.E1_EMIS1,A.E1_NATUREZ,B.ED_DESCRIC,A.E1_OBSERV,A.E1_FORMPAG,
	  	A.E1_PARCELA,A.E1_CLIENTE,A.E1_NOMCLI,C.A1_NOME
	FROM 
		SE1040 A 			
		JOIN SED010 B ON A.E1_NATUREZ = B.ED_CODIGO
		JOIN SA1010 C ON A.E1_CLIENTE = C.A1_COD AND A.E1_LOJA = C.A1_LOJA
	WHERE
	   A.%notDel%
	   AND B.%notDel%
  	   AND C.%notDel%		   
	   %Exp:cFiltro%
			
	UNION ALL
	SELECT 
		'05' AS 'EMPRESA',A.E1_FILIAL, A.E1_PREFIXO,A.E1_NUM,A.E1_TIPO,A.E1_EMISSAO,A.E1_VENCREA,
	  	A.E1_VALOR,A.E1_SALDO,A.E1_HIST,A.E1_EMIS1,A.E1_NATUREZ,B.ED_DESCRIC,A.E1_OBSERV,A.E1_FORMPAG,
	  	A.E1_PARCELA,A.E1_CLIENTE,A.E1_NOMCLI,C.A1_NOME
	FROM 
		SE1050 A 			
		JOIN SED010 B ON A.E1_NATUREZ = B.ED_CODIGO
		JOIN SA1010 C ON A.E1_CLIENTE = C.A1_COD AND A.E1_LOJA = C.A1_LOJA
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
oReport:Section(1):Section(1):SetParentFilter({|cParam| QRYSE1->EMPRESA + QRYSE1->E1_FILIAL == cParam },{|| QRYSE1->EMPRESA + QRYSE1->E1_FILIAL})

oReport:Section(1):Print(.T.)

Return


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao	 ³ ValidPerg³ Autor ³ TOTVS            	    ³ Data ³ 24.06.99 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³                   										  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
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
aAdd(aRegs,{cPerg,"15","Do Cliente         ","","","mv_ch15" ,"C", 6,0,0,"G","","mv_par15","","","","","","","","","","","","","","","","","","","","","","","","","CLI",""})
aAdd(aRegs,{cPerg,"16","Loja               ","","","mv_ch16" ,"C", 2,0,0,"G","","mv_par16","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"17","Ate Cliente        ","","","mv_ch17" ,"C", 6,0,0,"G","","mv_par17","","","","","","","","","","","","","","","","","","","","","","","","","CLI",""})
aAdd(aRegs,{cPerg,"18","Loja               ","","","mv_ch18" ,"C", 2,0,0,"G","","mv_par18","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"19","Imprimir Tipos:    ","","","mv_ch19" ,"C", 25,0,0,"R","","mv_par19","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"20","Nao Imprimir Tipos:","","","mv_ch20" ,"C", 25,0,0,"R","","mv_par20","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"21","Imprimir           ","","","mv_ch21" ,"C", 1,0,0,"C","","mv_par21","Aberto","","","","","Recebido","","","","","Todos","","","","","","","","","","","","","","",""})


For i:=1 To Len(aRegs)
	If !dbSeek(cPerg+space(10-len(cPerg))+aRegs[i,2])
		RecLock("SX1",.T.)
		For j:=1 to FCount()
			If j <= Len(aRegs[i])
				FieldPut(j,aRegs[i,j])
			EndIf
		Next
		MsUnlock()
	EndIf
Next
Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao	 ³ getDesc  ³ Autor ³ TOTVS            	    ³ Data ³ 24.06.99 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³                   										  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function getDesc(cEmp,cFil)

Local aArea := getArea()
Local cRet := ""

dbSelectArea("SM0")
dbSetOrder(1)
dbSeek(cEmp+cFil)

cRet := SM0->M0_NOMECOM

restArea(aArea)
Return cRet

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao	 ³SayValor  ³ Autor ³ J£lio Wittwer    	    ³ Data ³ 24.06.99 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³Retorna String de valor entre () caso Valor < 0			  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ FINR340.PRX												  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function SayValor(nNum,nTam,lInvert,nDecs)

Local cPicture,cRetorno
cPicture := tm(nNum,nTam,nDecs)
cRetorno := Transform(nNum,cPicture)

If nNum<0 .or. lInvert
	cPicture := tm(nNum,nTam-2,nDecs)
	cRetorno := Transform(nNum,cPicture)
   cRetorno := Right(Space(10)+"("+Alltrim(StrTran(cRetorno,"-",""))+")",nTam+1)
EndIf

Return cRetorno

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao	 ³ getDesc  ³ Autor ³ TOTVS            	    ³ Data ³ 24.06.99 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³                   										  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/   
Static Function getName()

If mv_par21 == 1//ABERTO
	cMsg1 := "RELAÇÃO DE TÍTULOS A RECEBER "
ElseIf mv_par21 == 2//RECEBIDO
	cMsg1 := "RELAÇÃO DE TÍTULOS RECEBIDOS "
Else//TODOS
	cMsg1 := "RELAÇÃO DE TÍTULOS A RECEBER E RECEBIDOS "
EndIf

Return