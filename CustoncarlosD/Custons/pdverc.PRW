#INCLUDE "rwmake.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �pdverc    � Autor �Carlos Daniel    � Data �  19/11/14      ���
�������������������������������������������������������������������������͹��
���Descricao � pdv                        .                               ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Ercal			                                          ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function pdverc()


//���������������������������������������������������������������������Ŀ
//� Declaracao de Variaveis                                             �
//�����������������������������������������������������������������������
 
Local cDesc1       := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2       := "de acordo com os parametros informados pelo usuario."
Local cDesc3       := ""
Local cPict        := ""
Local titulo       := "Rela��o PDV"
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
Private nomeprog   := "pdverc" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo      := 18
Private aReturn    := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey   := 0
Private cPerg      := "pdv"
Private cbtxt      := Space(10)
Private cbcont     := 00
Private CONTFL     := 01
Private m_pag      := 01
Private wnrel      := "pdverc" // Coloque aqui o nome do arquivo usado para impressao em disco      
Private cString := "SE1"

dbSelectArea("SE1")
dbSetOrder(1)

PutSX1(cPerg , "01" , "Filial de                 " , "" , "" , "mv_ch1" , "C" , 4  , 0 , 0 , "G" , "", "SM0", "", "", "mv_par01" , "        " ,"","","", "        " ,"","","", "        " , "" , "" , "" , "" , "" , "" , "" , "" )
PutSX1(cPerg , "02" , "Filial ate                " , "" , "" , "mv_ch2" , "C" , 4  , 0 , 0 , "G" , "", "SM0", "", "", "mv_par02" , "        " ,"","","", "   	  " ,"","","", "        " , "" , "" , "" , "" , "" , "" , "" , "" )
PutSX1(cPerg , "03" , "Data Base.               " , "" , "" , "mv_ch3" , "D" , 4  , 0 , 0 , "G" , "", "", "", "", "mv_par03" , "        " ,"","","", "        " ,"","","", "        " , "" , "" , "" , "" , "" , "" , "" , "" )
PutSX1(cPerg , "04" , "Vencidos de.               " , "" , "" , "mv_ch4" , "D" , 4  , 0 , 0 , "G" , "", "", "", "", "mv_par04" , "        " ,"","","", "        " ,"","","", "        " , "" , "" , "" , "" , "" , "" , "" , "" )
PutSX1(cPerg , "05" , "vencidos Ate.               " , "" , "" , "mv_ch5" , "D" , 4  , 0 , 0 , "G" , "", "", "", "", "mv_par05" , "        " ,"","","", "        " ,"","","", "        " , "" , "" , "" , "" , "" , "" , "" , "" )

//PutSX1(cPerg , "04" , "1=Anal/2=Sint			 " , "" , "" , "mv_ch4" , "C" , 1  , 0 , 0 , "G" , "", "", "", "", "mv_par04" , "        " ,"","","", "   	  " ,"","","", "        " , "" , "" , "" , "" , "" , "" , "" , "" )

pergunte(cPerg,.T.)

//���������������������������������������������������������������������Ŀ
//� Monta a interface padrao com o usuario...                           �
//�����������������������������������������������������������������������

wnrel := SetPrint(cString,NomeProg,"",@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
	Return
Endif

nTipo := If(aReturn[4]==1,15,18)

//���������������������������������������������������������������������Ŀ
//� Processamento. RPTSTATUS monta janela com a regua de processamento. �
//�����������������������������������������������������������������������

RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)
Return

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Fun��o    �RUNREPORT � Autor � AP6 IDE            � Data �  29/05/12   ���
�������������������������������������������������������������������������͹��
���Descri��o � Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS ���
���          � monta a janela com a regua de processamento.               ���
�������������������������������������������������������������������������͹��
���Uso       � Programa principal                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
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

	cQry += " SELECT SE10.E1_NUM, SE10.E1_PARCELA, SE10.E1_TIPO, SE10.E1_CLIENTE, SE10.E1_VENCREA," 
	cQry += " (SELECT TRIM(SUM(E1_SALDO)) FROM "+RetSqlName("SE1") +" SE11 WHERE SE10.E1_FILIAL = SE11.E1_FILIAL AND SE10.E1_NUM = SE11.E1_NUM AND SE10.E1_PARCELA = SE11.E1_PARCELA AND SE10.E1_CLIENTE = SE11.E1_CLIENTE AND SE11.E1_FILIAL BETWEEN '"+MV_PAR01+"' AND  '"+MV_PAR02+"'" 
	cQry += " AND SE11.E1_VENCREA < to_char(add_months(to_date('"+dtos(MV_PAR03)+"', 'yyyymmdd'), -6),'yyyymmdd') AND (SE11.E1_BAIXA > '"+dtos(MV_PAR03)+"' OR SE11.E1_SALDO <> 0)" 
	cQry += " AND SE11.D_E_L_E_T_ <> '*' AND SE11.E1_VALOR <= 5000) cl_6_MESES,"
	cQry += " (SELECT TRIM(SUM(E1_SALDO)) FROM "+RetSqlName("SE1") +" SE11 WHERE SE10.E1_FILIAL = SE11.E1_FILIAL AND SE10.E1_NUM = SE11.E1_NUM AND SE10.E1_PARCELA = SE11.E1_PARCELA AND SE10.E1_CLIENTE = SE11.E1_CLIENTE AND "
	cQry += " SE11.E1_FILIAL BETWEEN '"+MV_PAR01+"' AND  '"+MV_PAR02+"' AND SE11.E1_VENCREA < to_char(add_months(to_date('"+dtos(MV_PAR03)+"', 'yyyymmdd'), -12),'yyyymmdd') AND (SE11.E1_BAIXA > '"+dtos(MV_PAR03)+"' OR SE11.E1_SALDO <> 0)" 
	cQry += " AND SE11.D_E_L_E_T_ <> '*' AND SE11.E1_VALOR BETWEEN 5000 and 30000) cl_1_ano,
	cQry += " (SELECT TRIM(SUM(E1_SALDO)) FROM "+RetSqlName("SE1") +" SE11 WHERE SE10.E1_FILIAL = SE11.E1_FILIAL AND SE10.E1_NUM = SE11.E1_NUM AND SE10.E1_PARCELA = SE11.E1_PARCELA AND SE10.E1_CLIENTE = SE11.E1_CLIENTE AND SE11.E1_FILIAL BETWEEN '"+MV_PAR01+"' AND  '"+MV_PAR02+"'"  
	cQry += " AND SE11.E1_VENCREA < to_char(add_months(to_date('"+dtos(MV_PAR03)+"', 'yyyymmdd'), -12),'yyyymmdd') AND (SE11.E1_BAIXA > '"+dtos(MV_PAR03)+"' OR SE11.E1_SALDO <> 0)" 
	cQry += " AND SE11.D_E_L_E_T_ <> '*' AND SE11.E1_VALOR > 30000) cl_1_anop,"
	cQry += " SE10.E1_BAIXA"
	cQry += " FROM "+RetSqlName("SE1") +" SE10"
	cQry += " WHERE SE10.D_E_L_E_T_ != '*' "
	cQry += " AND (SE10.E1_BAIXA > '"+dtos(MV_PAR03)+"' OR SE10.E1_SALDO <> 0)"
	cQry += " AND SE10.E1_VENCREA < to_char(add_months(to_date('"+dtos(MV_PAR03)+"', 'yyyymmdd'), -6),'yyyymmdd')" 
	cQry += " AND E1_TIPO NOT IN ('RA','NCC') 
    cQry += " ORDER BY SE10.E1_VENCREA"
	
	 
	DbUseArea(.T., "TOPCONN", TcGenQry(,, cQry), cAlias, .T., .T.) 
	DbGotop()
	
//���������������������������������������������������������������������Ŀ
//� SETREGUA -> Indica quantos registros serao processados para a regua �
//�����������������������������������������������������������������������

SetRegua(RecCount())

Cabec1 += Space(3)
Cabec1 += Padc("Numero" ,len((cAlias)->E1_NUM))			   		+ " | "  
Cabec1 += Padc("Tipo" ,len((cAlias)->E1_TIPO))			   		+ " | " 
Cabec1 += Padc("Cod Cliente",len((cAlias)->E1_CLIENTE))  	    + " | " 
Cabec1 += Padc("Vencimento",len(dtoc(stod((cAlias)->E1_VENCREA))))+ " | "
Cabec1 += Padc("+ 6 Meses" ,16)	  			   	  	   			   	+ " | " 
Cabec1 += Padc("+ 1 Ano" ,16)	  			   	  	   			   	+ " | " 
Cabec1 += Padc("+ 1 Ano/Protesto" ,16)	  			   	  	   	    + " | "  
Cabec1 += Padc("DT baixa",len((cAlias)->E1_BAIXA))	   	   		+ " | "
nPosQtd := Len(Cabec1)

Cabec2 := Space(0)

dbGoTop()
While !EOF()
	
	//���������������������������������������������������������������������Ŀ
	//� Verifica o cancelamento pelo usuario...                             �
	//�����������������������������������������������������������������������
	
	If lAbortPrint
		@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
		Exit
	Endif
	
	//���������������������������������������������������������������������Ŀ
	//� Impressao do cabecalho do relatorio. . .                            �
	//�����������������������������������������������������������������������
	
	If nLin > 55 // Salto de P�gina. Neste caso o formulario tem 55 linhas...
		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		nLin := 8
	Endif

	cBXATI := dtoc(stod((cAlias)->E1_BAIXA))
	cAqui := val((cAlias)->cl_6_MESES)
	cMes1 := val((cAlias)->cl_1_ano)
	cAcul := val((cAlias)->cl_1_anop)
	
	cLin := transform((cAlias)->E1_NUM, PesqPict("SE1","E1_NUM"))    	        	+  " | "
	cLin += transform((cAlias)->E1_TIPO, PesqPict("SE1","E1_TIPO"))     	    	+  " | "
	cLin += transform((cAlias)->E1_CLIENTE, PesqPict("SE1","E1_CLIENTE"))       	+  " | "
	cLin += dtoc(stod((cAlias)->E1_VENCREA))	                                    +  " | " 
	cLin += Padl("R$"+transform(cAqui,"@E 99,999,999.99"),16) 				     	+  " | " 
	cLin += Padl("R$"+transform(cMes1,"@E 99,999,999.99"),16) 				     	+  " | " 
	cLin += Padl("R$"+transform(cAcul,"@E 99,999,999.99"),16) 				     	+  " | "   	
   	cLin += dtoc(stod((cAlias)->E1_BAIXA))	                                        +  " | " 

	@nLin,03 PSAY cLin
	nLin++
	ntotal += ((cMes1+cAcul)+cAqui)
	ntotam += cMes1 
	ntotaa += cAcul  
	ntotalz += cAqui
	(cAlias)->(dbSkip())
EndDo

	nLin++
	@nLin,03 PSAY Padr("Total + 6 Meses R$"+transform(ntotalz,"@E 99,999,999.99"),200)//+"R$"+transform(cMes1,"@E 99,999,999.99")+"R$"+transform(ntotal,"@E 99,999,999.99")
   	nLin++
	@nLin,03 PSAY Padr("Total + 1 Ano R$"+transform(ntotam,"@E 99,999,999.99"),200) 
    nLin++ 
    @nLin,03 PSAY Padr("Total + 1 Ano Protestado R$"+transform(ntotaa,"@E 99,999,999.99"),200)
   	nLin++ 
   	@nLin,03 PSAY Padr("Total Geral R$"+transform(ntotal,"@E 99,999,999.99"),200) 


//���������������������������������������������������������������������Ŀ
//� Finaliza a execucao do relatorio...                                 �
//�����������������������������������������������������������������������

SET DEVICE TO SCREEN

//���������������������������������������������������������������������Ŀ
//� Se impressao em disco, chama o gerenciador de impressao...          �
//�����������������������������������������������������������������������

If aReturn[5]==1
	dbCommitAll()
	SET PRINTER TO
	OurSpool(wnrel)
Endif

MS_FLUSH()

Return()  