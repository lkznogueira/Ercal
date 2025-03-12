#INCLUDE "rwmake.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³jurvl    º Autor ³		     º Data ³  29/11/15   		  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Relação dos juros.                            			  º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ 			                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function jurvl()


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
 
Local cDesc1       := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2       := "de acordo com os parametros informados pelo usuario."
Local cDesc3       := ""
Local cPict        := ""
Local titulo       := "Relação Juros"
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
Private nomeprog   := "jurvl" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo      := 18
Private aReturn    := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey   := 0
Private cPerg      := "jurvll"
Private cbtxt      := Space(10)
Private cbcont     := 00
Private CONTFL     := 01
Private m_pag      := 01
Private wnrel      := "jurvl" // Coloque aqui o nome do arquivo usado para impressao em disco      
Private cString := "SE5"

dbSelectArea("SE5")
dbSetOrder(1)

//U_xPutSX1(cPerg , "01" , "DATA DE          		 " , "" , "" , "mv_ch1" , "D" , 4 , 0 , 0 , "G" , "", "", "", "", "mv_par01" , "        " ,"","","", "        " ,"","","", "        " , "" , "" , "" , "" , "" , "" , "" , "" )
//U_xPutSX1(cPerg , "02" , "DATA ATE         		 " , "" , "" , "mv_ch2" , "D" , 4 , 0 , 0 , "G" , "", "", "", "", "mv_par02" , "        " ,"","","", "   	  " ,"","","", "        " , "" , "" , "" , "" , "" , "" , "" , "" )
//U_xPutSX1(cPerg , "03" , "Modo Imp.	             " , "" , "" , "mv_ch3" , "N" , 1  , 0 , 1 , "C" , "", "", "", "", "mv_par03" , "(1)Pagos" ,"","","", "(2)Recebidos" ,"","","(3)Ambos", "   " , "" , "" , "" , "" , "" , "" , "" , "" )
//u_xPutSx1(cPerg , "04" , "Exporta Excel?         " , "" , "" , "mv_ch4" , "N" , 1  , 0 , 0 , "C" , "", "", "", "" ,"mv_par04","Sim","Sim","Sim","Nao","Nao","Nao","","","","","","","","","")

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
Local nJurpgt := 0
Local nEmpju := 0
Local nJurpg := 0 
Local nJurrbt := 0
Local nJurrb := 0
Local nDesobt := 0 
Local nDesob := 0
Local nDesfot := 0
Local nDesfo := 0
Local nOrdem := 0 
Local nJurEMP := 0
Local aReg:={}
Private cAlias := Criatrab(Nil,.F.)
Private cQry := Space(0)

cQry += " SELECT 
cQry += " E5_NUMERO,
cQry += " E5_VALOR,
cQry += " E5_HISTOR, 
cQry += " E5_CLIFOR,
cQry += " E5_BENEF,
cQry += " E5_DATA,
cQry += " E5_RECPAG,
cQry += " E5_NATUREZ,
cQry += " E5_FILORIG,
cQry += " (SELECT sum(EH_VALJUR) FROM "+RetSqlName("SEH") +"  SEH WHERE SUBSTR(E5_DOCUMEN, 1, LENGTH(EH_NUMERO)) = EH_NUMERO AND SEH.D_E_L_E_T_ <> '*' ) AS VLJUR
cQry += " FROM "+RetSqlName("SE5") +" SE5 
cQry += " WHERE  D_E_L_E_T_ <> '*' 
cQry += " AND E5_DATA BETWEEN '"+DToS(MV_PAR01)+"' AND '"+DToS(MV_PAR02)+"'
IF mv_par03 == 1
	cQry += " AND E5_RECPAG = 'P'
ELSEIF mv_par03 == 2
	cQry += " AND E5_RECPAG = 'R' 
ENDIF
//cQry += " AND E5_AGENCIA <> ' '	  //removido
cQry += " AND E5_SITUACA <> 'C' 
cQry += " AND (E5_HISTOR LIKE '%Resg%' OR E5_HISTOR LIKE '%Juros%' OR E5_HISTOR LIKE '%Desconto%' OR E5_HISTOR LIKE '%DESCONTO%' OR E5_HISTOR LIKE '%JURO%' ) 
cQry += " ORDER BY  E5_FILIAL,E5_DATA,E5_BANCO,E5_AGENCIA,E5_CONTA,E5_NUMCHEQ  
DbUseArea(.T., "TOPCONN", TcGenQry(,, cQry), cAlias, .T., .T.)
DbGotop() 

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ SETREGUA -> Indica quantos registros serao processados para a regua ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetRegua(RecCount())

Cabec1 += Space(3) 
Cabec1 += Padc("CODIGO" ,6)	  			   	  	   			   	    + " | "
Cabec1 += Padc("CLIENTE" ,30)	  			   	  	   			   	+ " | " 
Cabec1 += Padc("TITULO" ,9)	  			   	  	   		   			+ " | "    
Cabec1 += Padc("DATA VENCTO ",len(dtoc(stod((cAlias)->E5_DATA))))  	+ " | " 
Cabec1 += Padc("DATA PGTO ",len(dtoc(stod((cAlias)->E5_DATA))))  	+ " | "
Cabec1 += Padc("JUROS APLIC" ,16)	  			   	  	   			+ " | " 
Cabec1 += Padc("JUROS PAGOS" ,16)	  			   	  	   			+ " | " 
Cabec1 += Padc("JUROS RECEBIDOS" ,16)	  			   	  	   		+ " | "
Cabec1 += Padc("DESCONTO OBTIDO" ,16)	  			   	  	   		+ " | "
Cabec1 += Padc("DESCONTO FORNECIDO" ,16)	  			   	  	   	+ " | "  
Cabec1 += Padc("NATUREZA" ,16)	  			   	  	   				+ " | "    
nPosQtd := Len(Cabec1)
Cabec1 += Padc("TIPO (P=PAGAR R=RECEBER)" ,4)			   	  	    + " | "
Cabec1 += Padc("FILIAL" ,6)			   	  	   			   	  		+ " | "
Cabec2 := Space(0)

if mv_par04==1
	Aadd(aReg,{Padc("CODIGO" ,6),Padc("CLIENTE",40),Padc("TITULO" ,9),Padc("DATA VENCTO" ,15),Padc("DATA PGTO" ,15),Padc("JUROS APLIC",16),Padc("JUROS PAGOS" ,16),Padc("JUROS RECEBIDOS" ,16),Padc("DESCONTOS OBTIDOS" ,16),Padc("DESCONTO FORNECIDO" ,20),Padc("NATUREZA" ,16),Padc("TIPO (P=PAGAR R=RECEBER)" ,25),Padc("FILIAL" ,4)})
endif

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
	nEmpju := (cAlias)->VLJUR 
	
	cLin := transform((cAlias)->E5_CLIFOR, PesqPict("SE5","E5_CLIFOR"))    		+  " | "
	cLin += Padc(transform((cAlias)->E5_BENEF, PesqPict("SE5","E5_BENEF")),30)  +  " | " 
	cLin += transform((cAlias)->E5_NUMERO, PesqPict("SE5","E5_NUMERO"))       	+  " | "
	cLin += dtoc(stod((cAlias)->E5_DATA))		                                +  " | " //DATA
	cLin += dtoc(stod((cAlias)->E5_DATA))		                                +  " | " //DATA 
	cLin += Padl("R$"+transform(nEmpju,"@E 999,999,999.99"),16)  				+  " | "//juros emprestimos/aplicacao	
	
	IF (cAlias)->E5_RECPAG == 'P' .AND. 'Juros' $ (cAlias)->E5_HISTOR .OR. 'JURO' $ (cAlias)->E5_HISTOR
		nJurpg := (cAlias)->E5_VALOR
		nJurrb := 0
		nDesob := 0 
		nDesfo := 0
		cLin += Padl("R$"+transform(nJurpg,"@E 999,999,999.99"),16) 				+  " | " 
		cLin += Padl("R$"+transform(nJurrb,"@E 999,999,999.99"),16) 				+  " | " 	
		cLin += Padl("R$"+transform(nDesob,"@E 999,999,999.99"),16) 				+  " | " 	
   		cLin += Padl("R$"+transform(nDesfo,"@E 99,999,999.99"),16) 					+  " | " 
	ELSEIF (cAlias)->E5_RECPAG == 'P' .AND. 'Desconto' $ (cAlias)->E5_HISTOR .OR. 'DESCONTO' $ (cAlias)->E5_HISTOR
		nJurpg := 0
		nJurrb := 0
		nDesob := (cAlias)->E5_VALOR 
		nDesfo := 0
		cLin += Padl("R$"+transform(nJurpg,"@E 999,999,999.99"),16) 				+  " | " 
		cLin += Padl("R$"+transform(nJurrb,"@E 999,999,999.99"),16) 				+  " | " 	
		cLin += Padl("R$"+transform(nDesob,"@E 999,999,999.99"),16) 				+  " | " 	
   		cLin += Padl("R$"+transform(nDesfo,"@E 99,999,999.99"),16) 					+  " | " 
  	ELSEIF (cAlias)->E5_RECPAG == 'R' .AND. 'Juros' $ (cAlias)->E5_HISTOR .OR. 'JURO' $ (cAlias)->E5_HISTOR
		nJurpg := 0
		nJurrb := (cAlias)->E5_VALOR
		nDesob := 0 
		nDesfo := 0
		cLin += Padl("R$"+transform(nJurpg,"@E 999,999,999.99"),16) 				+  " | " 
		cLin += Padl("R$"+transform(nJurrb,"@E 999,999,999.99"),16) 				+  " | " 	
		cLin += Padl("R$"+transform(nDesob,"@E 999,999,999.99"),16) 				+  " | " 	
   		cLin += Padl("R$"+transform(nDesfo,"@E 99,999,999.99"),16) 					+  " | " 
	ELSEIF (cAlias)->E5_RECPAG == 'R' .AND. 'Desconto' $ (cAlias)->E5_HISTOR .OR. 'DESCONTO' $ (cAlias)->E5_HISTOR
		nJurpg := 0
		nJurrb := 0
		nDesob := 0 
		nDesfo := (cAlias)->E5_VALOR
		cLin += Padl("R$"+transform(nJurpg,"@E 999,999,999.99"),16) 				+  " | " 
		cLin += Padl("R$"+transform(nJurrb,"@E 999,999,999.99"),16) 				+  " | " 	
		cLin += Padl("R$"+transform(nDesob,"@E 999,999,999.99"),16) 				+  " | " 	
   		cLin += Padl("R$"+transform(nDesfo,"@E 99,999,999.99"),16) 					+  " | " 
   	ELSEIF 'Resg' $ (cAlias)->E5_HISTOR 
   		nJurpg := 0
		nJurrb := 0
		nDesob := 0 
		nDesfo := 0
		cLin += Padl("R$"+transform(nJurpg,"@E 999,999,999.99"),16) 				+  " | " 
		cLin += Padl("R$"+transform(nJurrb,"@E 999,999,999.99"),16) 				+  " | " 	
		cLin += Padl("R$"+transform(nDesob,"@E 999,999,999.99"),16) 				+  " | " 	
   		cLin += Padl("R$"+transform(nDesfo,"@E 99,999,999.99"),16) 					+  " | "  
		
	ENDIF
	cLin += Padc(transform((cAlias)->E5_NATUREZ, PesqPict("SE5","E5_NATUREZ")),16)  +  " | "
    cLin += Padc(transform((cAlias)->E5_RECPAG, PesqPict("SE5","E5_RECPAG")),4)     +  " | "  
    cLin += Padc(transform((cAlias)->E5_FILORIG, PesqPict("SE5","E5_FILORIG")),6)   +  " | " 

	@nLin,03 PSAY cLin
	nLin++  
	
	if mv_par04==1
	  Aadd(aReg,{Padl((cAlias)->E5_CLIFOR, 6),Padc((cAlias)->E5_BENEF, 40),Padl((cAlias)->E5_NUMERO, 9),dtoc(stod((cAlias)->E5_DATA)),dtoc(stod((cAlias)->E5_DATA)),Padl(transform(nEmpju,"@E 999,999,999.99"),16),Padl(transform(nJurpg,"@E 999,999,999.99"),16),Padl(transform(nJurrb,"@E 999,999,999.99"),16),Padl(transform(nDesob,"@E 999,999,999.99"),16),Padl(transform(nDesfo,"@E 999,999,999.99"),20),Padl((cAlias)->E5_NATUREZ,16),Padc((cAlias)->E5_RECPAG, 25),Padl((cAlias)->E5_FILORIG,6)})
	endif 
	
	nJurEMP += nEmpju
	nJurpgt += nJurpg 
	nJurrbt += nJurrb
	nDesobt += nDesob
	nDesfot += nDesfo

	(cAlias)->(dbSkip())
EndDo
if mv_par04==1
  U_Arr4Excl(aReg)
endif     
nLin++ 
cLin := SPACE(69)+"RESUMOS "+" | " 
cLin += Padl("R$"+transform(nJurEMP,"@E 999,999,999.99"),16)  +  " | "                                         
cLin += Padl("R$"+transform(nJurpgt,"@E 999,999,999.99"),16)  +  " | " 
cLin += Padl("R$"+transform(nJurrbt,"@E 999,999,999.99"),16)  +  " | "  
cLin += Padl("R$"+transform(nDesobt,"@E 999,999,999.99"),16)  +  " | "  
cLin += Padl("R$"+transform(nDesfot,"@E 999,999,999.99"),16)  +  " | " 
@nLin,03 PSAY cLin


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
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±³Fun‡„o	 ³ TrbToExcel ³ Autor ³ Claudio Ferreira    ³ Data ³ 05/07/18 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Exporta TRB                                                 ±±
±±³                                                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ TBC-GO                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/



User Function Arr4Excl(aReg)
// Alert(TRB->(DBInfo(10)))
Processa( { || ToProcEx(aReg) } )
Return

Static Function ToProcEx(aReg)
LOCAL cDirDocs   := MsDocPath() 
Local aStru		:= {}
Local cArquivo := CriaTrab(,.F.)
Local cPath		:= AllTrim(GetTempPath())
Local oExcelApp
Local nHandle
Local cCrLf 	:= Chr(13) + Chr(10)
Local nX, ii, i

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
