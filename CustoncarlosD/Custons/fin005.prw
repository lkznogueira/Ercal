#INCLUDE "rwmake.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³fin005    º Autor ³Carlos Daniel    º Data ³  19/11/14      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Programa tem objetivo imprimir relatorio financeiro        º±±
±±º          ³ Clientes em atraso no mes e data base.                     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Ercal			                                          º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function fin005()


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
 
Local cDesc1       := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2       := "de acordo com os parametros informados pelo usuario."
Local cDesc3       := ""
Local cPict        := ""
Local titulo       := "RESUMO FINANCEIRO - "
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
Private nomeprog   := "fin005" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo      := 18
Private aReturn    := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey   := 0
Private cPerg      := "fin005"
Private cbtxt      := Space(10)
Private cbcont     := 00
Private CONTFL     := 01
Private m_pag      := 01
Private wnrel      := "fin005" // Coloque aqui o nome do arquivo usado para impressao em disco      
Private cString := "SE2"

dbSelectArea("SE2")
dbSetOrder(1)

PutSX1(cPerg , "01" , "Filial de                 " , "" , "" , "mv_ch1" , "C" , 4  , 0 , 0 , "G" , "", "SM0", "", "", "mv_par01" , "        " ,"","","", "        " ,"","","", "        " , "" , "" , "" , "" , "" , "" , "" , "" )
PutSX1(cPerg , "02" , "Filial ate                " , "" , "" , "mv_ch2" , "C" , 4  , 0 , 0 , "G" , "", "SM0", "", "", "mv_par02" , "        " ,"","","", "   	  " ,"","","", "        " , "" , "" , "" , "" , "" , "" , "" , "" )
PutSX1(cPerg , "03" , "Data Base.               " , "" , "" , "mv_ch3" , "D" , 4  , 0 , 0 , "G" , "", "", "", "", "mv_par03" , "        " ,"","","", "        " ,"","","", "        " , "" , "" , "" , "" , "" , "" , "" , "" )
//PutSX1(cPerg , "04" , "Vencidos de.               " , "" , "" , "mv_ch4" , "D" , 4  , 0 , 0 , "G" , "", "", "", "", "mv_par04" , "        " ,"","","", "        " ,"","","", "        " , "" , "" , "" , "" , "" , "" , "" , "" )
//PutSX1(cPerg , "05" , "vencidos Ate.               " , "" , "" , "mv_ch5" , "D" , 4  , 0 , 0 , "G" , "", "", "", "", "mv_par05" , "        " ,"","","", "        " ,"","","", "        " , "" , "" , "" , "" , "" , "" , "" , "" )
PutSX1(cPerg , "04" , "1=Fornec/2=Client			 " , "" , "" , "mv_ch4" , "C" , 1  , 0 , 0 , "G" , "", "", "", "", "mv_par04" , "        " ,"","","", "   	  " ,"","","", "        " , "" , "" , "" , "" , "" , "" , "" , "" )

pergunte(cPerg,.T.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta a interface padrao com o usuario...                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
IF mv_par04 == "1" 
	titulo += "FORNECEDOR A PAGAR"
ELSE
	titulo += "CLIENTE A RECEBER"
ENDIF

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
local nValo             //colocada para calculo geral
local nValor := 0 //para calculo geral
Private cAlias := Criatrab(Nil,.F.) 
Private cAliaB := Criatrab(Nil,.F.) 
Private cAliaC := Criatrab(Nil,.F.)
Private cQry := Space(0)     
 
IF mv_par04 == "1" 
	cQry += " SELECT SE2.E2_NUM, SE2.E2_TIPO, SE2.E2_PREFIXO, SE2.E2_FORNECE, 
	cQry += " (select trim(a2_nome) from "+RetSqlName("SA2") +" sa2 where SA2.a2_cod = SE2.E2_FORNECE and SA2.a2_loja = SE2.E2_loja and sa2.d_e_l_e_t_ <> '*') as Nome,
	cQry += " SE2.E2_VENCREA, 
	cQry += " SE2.E2_BAIXA,
	cQry += " SE2.E2_VALOR,
	cQry += " (SELECT SE5.E5_VALOR FROM "+RetSqlName("SE5")+" SE5 WHERE SE5.E5_NUMERO = SE2.E2_NUM AND SE5.E5_FORNECE = SE2.E2_FORNECE AND SE5.E5_PREFIXO = SE2.E2_PREFIXO AND SE5.E5_PARCELA = SE2.E2_PARCELA AND SE5.D_E_L_E_T_ != '*' AND E5_MOTBX IN ('NOR','DEB') AND SE5.E5_DATA = SE2.E2_BAIXA 
	cQry += " AND SE5.E5_TIPODOC NOT IN ('DC','D2','JR','J2','TL','MT','M2','CM','C2','TR','TE') AND SE5.E5_SITUACA NOT IN ('C','E','X') AND E5_TIPO NOT IN ('INS','TX','FOL','RPA','RES','PA','RC','FER') ) AS E5_VALOR,
	cQry += " (SELECT SE5.E5_DATA FROM "+RetSqlName("SE5")+" SE5 WHERE SE5.E5_NUMERO = SE2.E2_NUM AND SE5.E5_FORNECE = SE2.E2_FORNECE AND SE5.E5_PREFIXO = SE2.E2_PREFIXO AND SE5.E5_PARCELA = SE2.E2_PARCELA AND SE5.D_E_L_E_T_ != '*' AND E5_MOTBX IN ('NOR','DEB') AND SE5.E5_DATA = SE2.E2_BAIXA 
	cQry += " AND SE5.E5_TIPODOC NOT IN ('DC','D2','JR','J2','TL','MT','M2','CM','C2','TR','TE') AND SE5.E5_SITUACA NOT IN ('C','E','X') AND E5_TIPO NOT IN ('INS','TX','FOL','RPA','RES','PA','RC','FER') ) AS E5_DATA,
	cQry += " SE2.E2_SALDO
	cQry += " FROM "+RetSqlName("SE2") +" SE2
	cQry += " WHERE SE2.D_E_L_E_T_ != '*'  
	cQry += " AND SE2.E2_FILIAL BETWEEN '"+MV_PAR01+"' AND  '"+MV_PAR02+"'
	cQry += " AND (SE2.E2_BAIXA > '"+dtos(MV_PAR03)+"' OR SE2.E2_BAIXA = ' ') 
	cQry += " AND SE2.E2_EMISSAO BETWEEN '19000101' AND '"+dtos(MV_PAR03)+"'
	cQry += " AND SE2.E2_TIPO NOT IN ('INS','TX','FOL','RPA','RES','PA','RC','FER')
	cQry += " ORDER BY SE2.E2_VENCREA 
ELSE

	cQry += " SELECT SE1.E1_NUM, SE1.E1_TIPO, SE1.E1_PREFIXO, SE1.E1_CLIENTE, 
	cQry += " (select trim(a1_nome) from "+RetSqlName("SA1") +" sa1 where SA1.a1_cod = SE1.E1_CLIENTE and SA1.a1_loja = SE1.E1_loja and sa1.d_e_l_e_t_ <> '*') as Nome,
	cQry += " SE1.E1_VENCREA, 
	cQry += " SE1.E1_BAIXA,
	cQry += " SE1.E1_VALOR,
	cQry += " (SELECT SE5.E5_VALOR FROM "+RetSqlName("SE5")+" SE5 WHERE SE5.E5_NUMERO = SE1.E1_NUM AND SE5.E5_CLIENTE = SE1.E1_CLIENTE AND SE5.E5_PREFIXO = SE1.E1_PREFIXO AND SE5.E5_PARCELA = SE1.E1_PARCELA AND SE5.D_E_L_E_T_ != '*' AND E5_MOTBX IN ('NOR','DEB','CMP') AND SE5.E5_DATA = SE1.E1_BAIXA 
	cQry += " AND SE5.E5_TIPODOC NOT IN ('DC','D2','JR','J2','TL','MT','M2','CM','C2','TR','TE') AND SE5.E5_SITUACA NOT IN ('C','E','X') AND E5_TIPO NOT IN ('INS','TX','FOL','RPA','RES','PA','RC','FER') AND SE5.E5_SEQ ='01' ) AS E5_VALOR,
	cQry += " (SELECT SE5.E5_DATA FROM "+RetSqlName("SE5")+" SE5 WHERE SE5.E5_NUMERO = SE1.E1_NUM AND SE5.E5_CLIENTE = SE1.E1_CLIENTE AND SE5.E5_PREFIXO = SE1.E1_PREFIXO AND SE5.E5_PARCELA = SE1.E1_PARCELA AND SE5.D_E_L_E_T_ != '*' AND E5_MOTBX IN ('NOR','DEB','CMP') AND SE5.E5_DATA = SE1.E1_BAIXA 
	cQry += " AND SE5.E5_TIPODOC NOT IN ('DC','D2','JR','J2','TL','MT','M2','CM','C2','TR','TE') AND SE5.E5_SITUACA NOT IN ('C','E','X') AND E5_TIPO NOT IN ('INS','TX','FOL','RPA','RES','PA','RC','FER') AND SE5.E5_SEQ ='01' ) AS E5_DATA,
	cQry += " SE1.E1_SALDO
	cQry += " FROM "+RetSqlName("SE1") +" SE1
	cQry += " WHERE SE1.D_E_L_E_T_ != '*'  
	cQry += " AND SE1.E1_FILIAL BETWEEN '"+MV_PAR01+"' AND  '"+MV_PAR02+"'
	cQry += " AND (SE1.E1_BAIXA > '"+dtos(MV_PAR03)+"' OR SE1.E1_BAIXA = ' ') 
	cQry += " AND SE1.E1_EMISSAO BETWEEN '19000101' AND '"+dtos(MV_PAR03)+"'
	cQry += " AND SE1.E1_TIPO NOT IN ('INS','TX','FOL','RPA','RES','PA','RC','FER')
	cQry += " ORDER BY SE1.E1_VENCREA

ENDIF
		 
	DbUseArea(.T., "TOPCONN", TcGenQry(,, cQry), cAlias, .T., .T.) 
	DbGotop()
	
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ SETREGUA -> Indica quantos registros serao processados para a regua ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ 
IF mv_par04 == "1" 

SetRegua(RecCount())

Cabec1 += Space(3)
Cabec1 += Padc("Numero" ,len((cAlias)->E2_NUM))			   		+ " | "  
Cabec1 += Padc("Tipo" ,len((cAlias)->E2_TIPO))			   		+ " | " 
Cabec1 += Padc("Prefixo" ,len((cAlias)->E2_PREFIXO))		   	+ " | " 
Cabec1 += Padc("Cod Fornecedor",len((cAlias)->E2_FORNECE))  	    + " | "
Cabec1 += Padc("Nome Fornecedor",len((cAlias)->NOME))  	  			+ " | "  
Cabec1 += Padc("Vencimento",len(dtoc(stod((cAlias)->E2_VENCREA))))+ " | "
//Cabec1 += Padc("+ 1 Ano/Protesto" ,16)	  			   	  	  + " | "  
//Cabec1 += Padc("DT baixa",len((cAlias)->E2_BAIXA))	   	   		+ " | "  
Cabec1 += Padc("SALDO DEVEDOR" ,16)	 		    		   	  	+ " | "
Cabec1 += Padc("Baixado Posterior Data" ,16)	 		        + " | "
Cabec1 += Padc("DT baixa",len((cAlias)->E2_BAIXA))	   	   		+ " | "      
nPosQtd := Len(Cabec1)

Cabec2 := Space(0)

dbGoTop()
While !EOF()
	
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

	cBXATI := dtoc(stod((cAlias)->E2_BAIXA))
	cAqui := (cAlias)->E2_VALOR
	cMes1 := (cAlias)->E5_VALOR
	//cAcul := val((cAlias)->cl_1_anop)
	
	cLin := transform((cAlias)->E2_NUM, PesqPict("SE2","E2_NUM"))    	        	+  " | "
	cLin += transform((cAlias)->E2_TIPO, PesqPict("SE2","E2_TIPO"))     	    	+  " | "
	cLin += transform((cAlias)->E2_PREFIXO, PesqPict("SE2","E2_PREFIXO"))     	    +  " | "
	cLin += transform((cAlias)->E2_FORNECE, PesqPict("SE2","E2_FORNECE"))       	+  " | " 
	cLin += transform((cAlias)->NOME, PesqPict("SA2","A2_NOME"))       				+  " | "
	cLin += dtoc(stod((cAlias)->E2_VENCREA))	                                    +  " | " 
    //cLin += Padl("R$"+transform(cMes1,"@E 99,999,999.99"),16) 				    +  " | " 
	//cLin += Padl("R$"+transform(cAcul,"@E 99,999,999.99"),16) 				    +  " | "   	
   	//cLin += dtoc(stod((cAlias)->E2_BAIXA))	                                    +  " | " 
   	cLin += Padl("R$"+transform(cAqui,"@E 99,999,999.99"),16) 				     	+  " | " 
   	cLin += Padl("R$"+transform(cMes1,"@E 99,999,999.99"),16) 				     	+  " | " 
   	cLin += dtoc(stod((cAlias)->E2_BAIXA))	 	                                    +  " | " 
	@nLin,03 PSAY cLin
	nLin++
   //	ntotal += ((cMes1+cAcul)+cAqui)
	ntotam += cMes1 
	//ntotaa += cAcul  
	ntotalz += cAqui
	(cAlias)->(dbSkip())
EndDo

	nLin++
	@nLin,03 PSAY Padr("TOTAL  R$"+transform(ntotalz,"@E 99,999,999.99"),200)
   	nLin++
	@nLin,03 PSAY Padr("BAIXADO PERIODO R$"+transform(ntotam,"@E 99,999,999.99"),200) 
    //nLin++ 
    //@nLin,03 PSAY Padr("Total + 1 Ano Protestado R$"+transform(ntotaa,"@E 99,999,999.99"),200)
   	//nLin++ 
   	//@nLin,03 PSAY Padr("Total Geral R$"+transform(ntotal,"@E 99,999,999.99"),200) 


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

//CLIENTE
SetRegua(RecCount())

Cabec1 += Space(3)
Cabec1 += Padc("Numero" ,len((cAlias)->E1_NUM))			   		+ " | "  
Cabec1 += Padc("Tipo" ,len((cAlias)->E1_TIPO))			   		+ " | " 
Cabec1 += Padc("Prefixo" ,len((cAlias)->E1_PREFIXO))		   	+ " | " 
Cabec1 += Padc("Cod Cliente",len((cAlias)->E1_cliente))  	    + " | "
Cabec1 += Padc("Nome Cliente",len((cAlias)->NOME))  	  			+ " | "  
Cabec1 += Padc("Vencimento",len(dtoc(stod((cAlias)->E1_VENCREA))))+ " | "
Cabec1 += Padc("SALDO DEVEDOR" ,16)	 		    		   	  	+ " | "
Cabec1 += Padc("Baixado Posterior Data" ,16)	 		        + " | "
Cabec1 += Padc("DT baixa",len((cAlias)->E1_BAIXA))	   	   		+ " | "      
nPosQtd := Len(Cabec1)

Cabec2 := Space(0)

dbGoTop()
While !EOF()
	
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

	cBXATI := dtoc(stod((cAlias)->E1_BAIXA))
	cAqui := (cAlias)->E1_VALOR
	cMes1 := (cAlias)->E5_VALOR
	//cAcul := val((cAlias)->cl_1_anop)
	
	cLin := transform((cAlias)->E1_NUM, PesqPict("SE1","E1_NUM"))    	        	+  " | "
	cLin += transform((cAlias)->E1_TIPO, PesqPict("SE1","E1_TIPO"))     	    	+  " | "
	cLin += transform((cAlias)->E1_PREFIXO, PesqPict("SE1","E1_PREFIXO"))     	    +  " | "
	cLin += transform((cAlias)->E1_CLIENTE, PesqPict("SE1","E1_cliente"))       	+  " | " 
	cLin += transform((cAlias)->NOME, PesqPict("SA1","A1_NOME"))       				+  " | "
	cLin += dtoc(stod((cAlias)->E1_VENCREA))	                                    +  " | " 
   	cLin += Padl("R$"+transform(cAqui,"@E 99,999,999.99"),16) 				     	+  " | " 
   	cLin += Padl("R$"+transform(cMes1,"@E 99,999,999.99"),16) 				     	+  " | " 
   	cLin += dtoc(stod((cAlias)->E1_BAIXA))	 	                                    +  " | " 
	@nLin,03 PSAY cLin
	nLin++

	ntotam += cMes1 
	ntotalz += cAqui
	(cAlias)->(dbSkip())
EndDo

	nLin++
	@nLin,03 PSAY Padr("TOTAL  R$"+transform(ntotalz,"@E 99,999,999.99"),200)
   	nLin++
	@nLin,03 PSAY Padr("BAIXADO PERIODO R$"+transform(ntotam,"@E 99,999,999.99"),200) 

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

ENDIF  