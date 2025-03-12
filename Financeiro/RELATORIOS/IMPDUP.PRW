#INCLUDE "RWMAKE.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TBICONN.CH"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณIMPDUP    บAutor  ณCarlos Daniel       บ Data ณ  16/03/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ  Impressใo de Duplicata                                    บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ ERCAL                                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function IMPDUP()

///////////////////////////////////////////////////////////////////////
///Variaveis de fontes                                             ////
///////////////////////////////////////////////////////////////////////   
Private oFont6		:= TFONT():New("ARIAL",7,6,.T.,.F.,5,.T.,5,.T.,.F.) ///Fonte 6 Normal
Private oFont8		:= TFONT():New("ARIAL",9,8,.T.,.F.,5,.T.,5,.T.,.F.) ///Fonte 8 Normal
Private oFont8N 	:= TFONT():New("ARIAL",9,8,,.T.,,,,.T.,.F.) ///Fonte 8 Negrito
Private oFont10 	:= TFONT():New("ARIAL",9,10,.T.,.F.,5,.T.,5,.T.,.F.) ///Fonte 10 Normal
Private oFont10S	:= TFONT():New("ARIAL",9,10,.T.,.F.,5,.T.,5,.T.,.T.) ///Fonte 10 Sublinhando
Private oFont10N 	:= TFONT():New("ARIAL",9,10,,.T.,,,,.T.,.F.) ///Fonte 10 Negrito
Private oFont10NS 	:= TFONT():New("ARIAL",9,10,,.T.,,,,.T.,.T.) ///Fonte 10 Negrito Sublinhado
Private oFont11		:= TFONT():New("ARIAL",11,11,,.F.,,,,.T.,.F.) ///Fonte 11 Normal
Private oFont11NS	:= TFONT():New("ARIAL",11,11,,.T.,,,,.T.,.T.) ///Fonte 11 Negrito e Sublinhado
Private oFont11N	:= TFONT():New("ARIAL",11,11,,.T.,,,,.T.,.F.) ///Fonte 11 Negrito
Private oFont12		:= TFONT():New("ARIAL",12,12,,.F.,,,,.T.,.F.) ///Fonte 12 Normal
Private oFont12NS	:= TFONT():New("ARIAL",12,12,,.T.,,,,.T.,.T.) ///Fonte 12 Negrito e Sublinhado
Private oFont12N	:= TFONT():New("ARIAL",12,12,,.T.,,,,.T.,.F.) ///Fonte 12 Negrito
Private oFont13 	:= TFONT():New("ARIAL",13,13,,.F.,,,,.T.,.F.) ///Fonte 13 Normal 
Private oFont13N	:= TFONT():New("ARIAL",13,13,,.T.,,,,.T.,.F.) ///Fonte 13 Negrito
Private oFont14 	:= TFONT():New("ARIAL",14,14,,.F.,,,,.T.,.F.) ///Fonte 14 Normal 
Private oFont14N	:= TFONT():New("ARIAL",14,14,,.T.,,,,.T.,.F.) ///Fonte 14 Negrito
Private oFont16 	:= TFONT():New("ARIAL",16,16,,.F.,,,,.T.,.F.) ///Fonte 16 Normal
Private oFont16N	:= TFONT():New("ARIAL",16,16,,.T.,,,,.T.,.F.) ///Fonte 16 Negrito
Private oFont16NS	:= TFONT():New("ARIAL",16,16,,.T.,,,,.T.,.T.) ///Fonte 16 Negrito e Sublinhado
Private oFont22N	:= TFONT():New("ARIAL",22,22,,.T.,,,,.T.,.F.) ///Fonte 22 Negrito
Private cStartPath
Private nLin 		:= 50
Private oPrint		:= TMSPRINTER():New("")
Private nPag		:= 1
Private oBrush1 	:= TBrush():New( , CLR_HGRAY )     //CLR_HGRAY
Private _cNFE		:= ''//alltrim(SC5->C5_NOTA) 
Private _cFilial	:= ''//SC5->C5_FILIAL
Private EOL  := Chr(13)+Chr(10) 
Private nLinha 		:= 180 
Private nCnpj  
Private cTexto
//dados pergunta
Private cPerg      := "duplii"  

//inicia tela perguntas.

PutSX1(cPerg , "01" , "Duplicata de              " , "" , "" , "mv_ch1" , "C" , 9  , 0 , 0 , "G" , "", "", "", "", "mv_par01" , "        " ,"","","", "        " ,"","","", "        " , "" , "" , "" , "" , "" , "" , "" , "" )
PutSX1(cPerg , "02" , "Duplicata ate             " , "" , "" , "mv_ch2" , "C" , 9  , 0 , 0 , "G" , "", "", "", "", "mv_par02" , "        " ,"","","", "   	  " ,"","","", "        " , "" , "" , "" , "" , "" , "" , "" , "" )
PutSX1(cPerg , "03" , "Filial de                 " , "" , "" , "mv_ch3" , "C" , 4  , 0 , 0 , "G" , "", "SM0", "", "", "mv_par03" , "        " ,"","","", "        " ,"","","", "        " , "" , "" , "" , "" , "" , "" , "" , "" )
PutSX1(cPerg , "04" , "Filial ate                " , "" , "" , "mv_ch4" , "C" , 4  , 0 , 0 , "G" , "", "SM0", "", "", "mv_par04" , "        " ,"","","", "   	  " ,"","","", "        " , "" , "" , "" , "" , "" , "" , "" , "" )

pergunte(cPerg,.T.)


//Tamanho do Papel A4
#define DMPAPER_A4 9

//Orientacao do papel (Retrato ou Paisagem)
//TMSPrinter(): SetPaperSize ()
//oPrint:SetLandscape() ///Define a orientacao da impressao como paisagem
oPrint:SetPortrait()///Define a orientacao da impressao como retrato

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ0ฟ
//ณMonta Query com itens para separa็ใoณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ0ู
cQry:=EOL+ "SELECT E1_NUM                                                                                   "
cQry+=EOL+ ",E1_FILIAL                                                                                      " 
cQry+=EOL+ ",E1_VALOR                                                                                       "
cQry+=EOL+ ",E1_CLIENTE                                                                                     "  
cQry+=EOL+ ",E1_LOJA                                                                                        "    //loja   Carlos DAniel
cQry+=EOL+ ",E1_PARCELA                                                                                     "
cQry+=EOL+ ",E1_VENCTO                                                                                      "
cQry+=EOL+ ",E1_VEND1                                                                                       "
cQry+=EOL+ ",E1_PEDIDO                                                                                      "
cQry+=EOL+ ",E1_FATURA                                                                                      "  
cQry+=EOL+ ",E1_PREFIXO                                                                                     " 
cQry+=EOL+ ",E1_EMISSAO                                                                                     "
cQry+=EOL+ "FROM  "+RetSqlName("SE1")+"  SE1                                                                "
cQry+=EOL+ "WHERE E1_FILIAL BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+"'                                       "
cQry+=EOL+ "AND SE1.D_E_L_E_T_ != '*'                                                                       "
cQry+=EOL+ "AND E1_NUM BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+"'    								        "
cQry+=EOL+ "ORDER BY E1_PARCELA                                                                             "
		
cQry := ChangeQuery(cQry)

If Select("QRY") > 0 
    QRY->(dbCloseArea()) 
EndIf

TCQUERY cQry NEW ALIAS "QRY" 
_cNota := alltrim(QRY->E1_NUM)

//QUERY SE5
cQry:=EOL+ "SELECT E5_NUMERO                                                                                "
cQry+=EOL+ ",E5_VALOR                                                                                       "  
cQry+=EOL+ ",E5_PREFIXO                                                                                     "
cQry+=EOL+ ",E5_CLIENTE                                                                                     "
cQry+=EOL+ ",E5_LOJA                                                                                        "  //Carlos Daniel
cQry+=EOL+ ",E5_PARCELA                                                                                     "
cQry+=EOL+ ",E5_DATA                                                                                        "
cQry+=EOL+ ",E5_FATURA                                                                                      "  
cQry+=EOL+ "FROM  "+RetSqlName("SE5")+"  SE5                                                                "
cQry+=EOL+ "WHERE SE5.D_E_L_E_T_ != '*'                                                                     "
cQry+=EOL+ "AND E5_FILORIG BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+"'									    "
cQry+=EOL+ "AND E5_FATURA BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+"'										    "
cQry+=EOL+ "ORDER BY E5_NUMERO                                                                           	"
					
cQry := ChangeQuery(cQry)

If Select("QRYFAT") > 0 
	QRYFAT->(dbCloseArea()) 
EndIf

TCQUERY cQry NEW ALIAS "QRYFAT"  
	 

If Empty(QRY->E1_NUM)    
	MsgAlert("Nota sem titulo financeiro! ","Aten็ใo")
	oPrint:EndPage()
	Return 
EndIf 

While QRY->(!EOF()) 
	//Monta o Cabe็alho
   //	Cabec()         
//	nLin+=50
	//nLin+=200 
	//_cNota := QRY->E1_NUM

	While QRY->(!EOF()) .and. _cNota == _cNota  

		If !Empty( QRYFAT->E5_FATURA )
		
			While QRYFAT->(!EOF()) //.and.
			
			Cabec()
			
				//Imprimir fatura aki 
			oPrint:Say(nLinha, 120,  DtoC(StoD(QRYFAT->E5_DATA)), oFont8N) //Data de topo
			oPrint:Say(nLinha, 330,  QRYFAT->E5_NUMERO, oFont8N)//numero nota topo
			oPrint:Say(nLinha, 910,  "R$ "+Transform(QRYFAT->E5_VALOR,"@E 9,999,999.99"), oFont8N)//valor nota topo 
			oPrint:Say(nLinha, 638,   AllTrim(Posicione("SC6",4,xFilial("SC6")+QRYFAT->E5_NUMERO+QRYFAT->E5_PREFIXO,"C6_QTDVEN")), oFont8N)  //QUANTIDADE VENDA TOPO
			nLinha += 40
			
				QRYFAT->( dbSkip() )
			EndDo
	
		Else
	
			Cabec() 
			//se fatura for vazio imprime  
			If Empty( QRYFAT->E5_FATURA )
				oPrint:Say(nLinha, 120,  DtoC(StoD(QRY->E1_EMISSAO)), oFont8N) //Data EMISSAO de topo
				oPrint:Say(nLinha, 330,  QRY->E1_NUM, oFont8N)//numero nota topo
				oPrint:Say(nLinha, 910,  "R$ "+Transform(QRY->E1_VALOR,"@E 9,999,999.99"), oFont8N)//valor nota topo 
				oPrint:Say(nLinha, 638,   AllTrim(Posicione("SC6",4,xFilial("SC6")+QRY->E1_NUM+QRY->E1_PREFIXO,"C6_QTDVEN")), oFont8N)  //QUANTIDADE VENDA TOPO
			 endif
			 
			oPrint:Say(1500, 073,  QRY->E1_FILIAL, oFont8N)  //FILIAL            
			Do Case  //data extenso
				Case  substr(QRY->E1_EMISSAO,5,2) = '01'
					oPrint:Say(1500, 230,  "JANEIRO", oFont8N) 
				Case  substr(QRY->E1_EMISSAO,5,2) = '02'
					oPrint:Say(1500, 230,  "FEVEREIRO", oFont8N) 
				Case  substr(QRY->E1_EMISSAO,5,2) = '03'
					oPrint:Say(1500, 230,  "MARCO", oFont8N) 
				Case  substr(QRY->E1_EMISSAO,5,2) = '04'
					oPrint:Say(1500, 230,  "ABRIL", oFont8N) 	
				Case  substr(QRY->E1_EMISSAO,5,2) = '05'
					oPrint:Say(1500, 230,  "MAIO", oFont8N) 
				Case  substr(QRY->E1_EMISSAO,5,2) = '06'
					oPrint:Say(1500, 230,  "JUNIO", oFont8N) 
				Case  substr(QRY->E1_EMISSAO,5,2) = '07'
					oPrint:Say(1500, 230,  "JULHO", oFont8N) 
				Case  substr(QRY->E1_EMISSAO,5,2) = '08'
					oPrint:Say(1500, 230,  "AGOSTO", oFont8N) 
				Case  substr(QRY->E1_EMISSAO,5,2) = '09'
					oPrint:Say(1500, 230,  "SETEMBRO", oFont8N) 	
				Case  substr(QRY->E1_EMISSAO,5,2) = '10'
					oPrint:Say(1460, 230,  "OUTUBRO", oFont8N) 
				Case  substr(QRY->E1_EMISSAO,5,2) = '11' 
					oPrint:Say(1500, 230,  "NOVEMBRO", oFont8N)
				Case  substr(QRY->E1_EMISSAO,5,2) = '12' 
					oPrint:Say(1500, 230,  "DEZEMBRO", oFont8N)
			EndCase   
			oPrint:Say(1500, 610,  QRY->E1_PEDIDO, oFont8N)//numero PEDIDO meio
			oPrint:Say(1500, 925,  QRY->E1_VEND1, oFont8N)//AGENTE   
			oPrint:Say(1500, 1975,  "R$ "+Transform(QRY->E1_VALOR,"@E 9,999,999.99"), oFont8N)//valor total meio
					
			oPrint:Say(1945, 1600,  DtoC(StoD(QRY->E1_EMISSAO)), oFont10N) //Data de Emissใo
			oPrint:Say(2080, 350,  QRY->E1_NUM, oFont10N) //Numero da Nota Fiscal ou do Titulo
			oPrint:Say(2080, 700,  "R$ "+Transform(QRY->E1_VALOR,"@E 9,999,999.99"), oFont10N) //Valor do titulo
			IF (QRY->E1_PARCELA = " ")                                                   
			oPrint:Say(2080, 1050, AllTrim(QRY->E1_NUM)+"-ฺnica", oFont10N) //Parcela do titulo		
			ELSE
			oPrint:Say(2080, 1050,  AllTrim(QRY->E1_NUM) + "-" + QRY->E1_PARCELA, oFont10N) //Parcela do titulo		
			ENDIF
			oPrint:Say(2080, 1600,  DtoC(StoD(QRY->E1_VENCTO)), oFont10N) //Vencimento do titulo (nใo ้ vencimento real) alterado a pedido do Sr. Roberto dia 21/02/13.
			oPrint:Say(2400, 600,  QRY->E1_CLIENTE+" - "+Posicione("SA1",1,xFilial("SA1")+QRY->E1_CLIENTE+QRY->E1_LOJA,"A1_NOME"), oFont10N) //Nome do Destinatario
			oPrint:Say(2450, 600,  AllTrim(Posicione("SA1",1,xFilial("SA1")+QRY->E1_CLIENTE+QRY->E1_LOJA,"A1_ENDCOB"))+" - "+AllTrim(Posicione("SA1",1,xFilial("SA1")+QRY->E1_CLIENTE+QRY->E1_LOJA,"A1_BAIRROC")), oFont10N) //Endere็o do Destinatario
			_cEST := Posicione("SA1",1,xFilial("SA1")+QRY->E1_CLIENTE+QRY->E1_LOJA,"A1_ESTC")  //Posicione("SA1",1,xFilial("SA1")+E1_CLIENTE+E1_LOJA,"A1_NOME")  //carlos
			oPrint:Say(2500, 1350, Posicione("SX5",1,xFilial("SX5")+"12"+_cEST,"X5_DESCRI")) 
			//oPrint:Say(950, 1350,  AllTrim(Posicione("SA1",1,xFilial("SA1")+SE1->E1_CLIENTE,"A1_EST")), oFont10N) //Estado do Destinatario
			_cCEP := Posicione("SA1",1,xFilial("SA1")+QRY->E1_CLIENTE+QRY->E1_LOJA,"A1_CEPC")
			oPrint:Say(2500, 2000,  Transform(Posicione("SA1",1,xFilial("SA1")+QRY->E1_CLIENTE+QRY->E1_LOJA,"A1_CEPC"),"@R 99999-999"), oFont10N) //Cep do Destinatario
			oPrint:Say(2500, 600,  AllTrim(Posicione("SA1",1,xFilial("SA1")+QRY->E1_CLIENTE+QRY->E1_LOJA,"A1_MUNC")), oFont10N) //Municipio do Destinatario
			oPrint:Say(2550, 800, " UBERLANDIA - MG", oFont10N) //Cidade de Protesto
			nCnpj := Len(AllTrim(Posicione("SA1",1,xFilial("SA1")+QRY->E1_CLIENTE+QRY->E1_LOJA,"A1_CGC")))
			IF nCnpj > 11
				oPrint:Say(2600, 800,  Transform(AllTrim(Posicione("SA1",1,xFilial("SA1")+QRY->E1_CLIENTE+QRY->E1_LOJA,"A1_CGC")),"@R 99.999.999/9999-99"), oFont10N) //CNPJ do Destinatario 
			Else
				oPrint:Say(2600, 800,  Transform(AllTrim(Posicione("SA1",1,xFilial("SA1")+QRY->E1_CLIENTE+QRY->E1_LOJA,"A1_CGC")),"@R 999.999.999-99"), oFont10N) //CNPJ do Destinatario
			EndIF 
			
			oPrint:Say(2650, 800,  AllTrim(Posicione("SA1",1,xFilial("SA1")+QRY->E1_CLIENTE+QRY->E1_LOJA,"A1_INSCR")), oFont10N) //Insc Estadual do Destinatario
			
			oPrint:Say(2830, 550,  EXTENSO(QRY->E1_VALOR), oFont10N) //Valor do titulo por extenso		
			QRY->(DBSKIP()) 
			nPag++
			Rod()
	
		Endif
			
	EndDo

//	Cabec()
  
EndDo
	
//Visualiza a impressao
oPrint:Preview() 

QRY->(DbCloseArea())

Return   
		
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCabec     บAutor  CARLOS DANIEL        บ Data ณ  15/03/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function Cabec()

PRIVATE oPrn    := NIL
PRIVATE oFont1  := NIL
PRIVATE oFont2  := NIL
PRIVATE oFont3  := NIL
PRIVATE oFont4  := NIL
PRIVATE oFont5  := NIL
//PRIVATE oFont6  := NIL
 		
nLin := 50
oPrint:StartPage() // Inicia uma nova pagina
cStartPath := GetPvProfString(GetEnvServer(),"StartPath","ERROR",GetAdv97())
cStartPath += If(Right(cStartPath, 1) <> "\", "\", "")
oPrint:SayBitmap(1750, 70, cStartPath + "lgrl01.bmp", 400, 200)// Impressao da Logo
//oPrint:Say(nLin+55, 50, "                                                                                                 TอTULO NUM.: "+QRY->E1_NUM, oFont10)
//oPrint:Say(nLin+10, 2100, "Pแgina: " + cValToChar(nPag), oFont10)
//oPrint:Say(nLin+50, 2100, Time(), oFont10)
//oPrint:Say(nLin+85, 2100, DTOC(dDatabase), oFont10)

//Criando o box geral
//linhainicio,colunainicio,linhafinal,colunafinal   
oPrint:Box(0100,0050,1430,1145)   //Dados Titulos 1 
oPrint:Box(0100,0050,0150,1145)   //Dados Titulos  total
oPrint:Line (0100,286,1430,286) // linha 1  
oPrint:Line (0100,572,1430,572) // linha 2
oPrint:Line (0100,858,1430,858) // linha 3  
//oPrint:Box(0100,286,0150,572)   //Dados Titulos nota  
//oPrint:Box(0100,572,0150,858)   //quantidade tonelada
//oPrint:Box(0100,858,0150,1145)   //valor da nota

oPrint:Box(0100,1150,1430,2300)   //Dados Titulos  2
oPrint:Box(0100,1150,0150,2300)   //Dados emissao afins 
oPrint:Line (0100,1436,1430,1436) // linha 1  
oPrint:Line (0100,1722,1430,1722) // linha 2
oPrint:Line (0100,2008,1430,2008) // linha 3  
//oPrint:Box(0100,1436,0150,1722)   //Dados Titulos nota  
//oPrint:Box(0100,1722,0150,2008)   //quantidade tonelada
//oPrint:Box(0100,2008,0150,2300)   //valor da nota

oPrint:Box(1450,0050,1600,200)   //filial   
oPrint:Box(1450,205,1600,550)   //Referencia mes
oPrint:Box(1450,555,1600,900)   //pedido 
oPrint:Box(1450,905,1600,1070)   //cod agente   
oPrint:Box(1450,1075,1600,1475)   //proco unitario 
oPrint:Box(1450,1490,1600,1590)   //total 
oPrint:Box(1450,1595,1600,1945)   //tonelada 
oPrint:Box(1450,1950,1600,2300)   //tonelada

oPrint:Box(1620,0050,3200,2300)   // caixa total duplicata inferior
oPrint:Box(1620,0050,2000,1250)
oPrint:Box(1620,1250,2000,2300)
oPrint:Box(2000,0300,2150,1850)   // Cria BOX retangular em volta dos campos de fatura corpo total
oPrint:FillRect( {2000,0300,2050,1850}, oBrush1 )// Cria BOX retangular em volta dos campos de fatura parte cima (cinza)
oPrint:Box(2100,1900,2350,2300)   // Cria BOX retangular a direira escrito DUPLICATA             
oPrint:Box(2370,300,2700,2300)   // Cria BOX em volta dos dados do destinatแrio
oPrint:Box(2750,300,2950,500)   // Cria BOX em volta do cabe็alho do valor por extenso
oPrint:FillRect( {2750,0500,2950,2300}, oBrush1 )   // Cria BOX em volta do valor por extenso
oPrint:Line (2000,550,2150,550)  //Linha separando o numero da fatura
oPrint:Line (2000,1050,2150,1050)  //Linha separando o numero da fatura
oPrint:Line (2000,1500,2150,1500)  //Linha separando o numero da fatura
       
		oPrint:Say(110, 070,  "DATA DA EMISSAO" , oFont6)
		oPrint:Say(110, 350,  "NOTA FISCAL" , oFont6)
		oPrint:Say(110, 638,  "TONELADAS" , oFont6) 
		oPrint:Say(110, 925,  "VALOR NOTA" , oFont6) 
		       
		oPrint:Say(110, 1159,  "DATA DA EMISSAO" , oFont6)
		oPrint:Say(110, 1465,  "NOTA FISCAL" , oFont6)
		oPrint:Say(110, 1755,  "TONELADAS" , oFont6) 
		oPrint:Say(110, 2035,  "VALOR NOTA" , oFont6)   
		
		oPrint:Say(nLin+1402, 073,  "FILIAL" , oFont6)
		oPrint:Say(nLin+1402, 230,  "MES REFERENCIA" , oFont6)
		oPrint:Say(nLin+1402, 610,  "PEDIDO" , oFont6)
		oPrint:Say(nLin+1402, 925,  "AGENTE" , oFont6)
		oPrint:Say(nLin+1402, 1105,  "PRECO UNITARIO" , oFont6) 
		oPrint:Say(nLin+1450, 1509,  "TOTAL" , oFont8)
		oPrint:Say(nLin+1402, 1625,  "TONELADAS" , oFont6) 
		oPrint:Say(nLin+1402, 1975,  "R$" , oFont6)
		
		oPrint:Say(nLin+1650, 500,  AllTrim(Upper(SM0->M0_NOMECOM)) , oFont8N)
		oPrint:Say(nLin+1750, 500,  AllTrim(SM0->M0_ENDCOB) , oFont8)
		oPrint:Say(nLin+1800, 500,  Capital(AllTrim(SM0->M0_CIDCOB))+'/'+AllTrim(SM0->M0_ESTCOB)+ '  -  CEP: ' + AllTrim(TransForm(SM0->M0_CEPCOB,'@R 99.999-999')) , oFont8)		
		oPrint:Say(nLin+1850, 500,  " Telefone: (34) 3230-3300  -  Fax: (34) 3230-3300",oFont8)
		oPrint:Say(nLin+1900, 500,  "          E-mail: ercal@ercal.com.br" , oFont8)	                        
		oPrint:Say(nLin+1620, 1300,  "                         D U P L I C A T A" , oFont14N)
		oPrint:Say(nLin+1700, 1300,  "INDUSTRIA: "+AllTrim(SM0->M0_ENDENT) , oFont8)
		oPrint:Say(nLin+1750, 1300,  Capital(AllTrim(SM0->M0_CIDCOB))+'/'+AllTrim(SM0->M0_ESTCOB)+ '  -  CEP: ' + AllTrim(TransForm(SM0->M0_CEPCOB,'@R 99.999-999')) , oFont8)
		oPrint:Say(nLin+1800, 1300,  "INSCRIวรO NO CNPJ:"+TransForm(SM0->M0_CGC,'@R 99.999.999/9999-99') , oFont8)
		oPrint:Say(nLin+1850, 1300,  "INSCRIวรO ESTADUAL Nบ:"+SM0->M0_INSC , oFont8)		
		oPrint:Say(nLin+1900, 1300,  "DATA DE EMISSรO: " , oFont8)		
		oPrint:Say(2015, 0350,"FATURA Nบ " , oFont8)
		oPrint:Say(2015, 0580,"FATURA - DUPLICATA / VALOR R$ " , oFont8)
		oPrint:Say(2015, 1100,"DUPLICATA/Nบ DE ORDEM " , oFont8)
		oPrint:Say(2015, 1600,"VENCIMENTO    " , oFont8)
		oPrint:Say(2150, 1950,"       PARA USO DA " , oFont8)
		oPrint:Say(2200, 1915,"INSTITUIวรO FINANCEIRA" , oFont8)
		oPrint:Say(2250, 1950,"DUPLICATA" , oFont14N)  
		/*
		cTexto := "Texto para visualiza็ใo"
		nPos   := 1

		For nPos:= 1 To Len(cTexto)
		//          @ nLinha, nColuna   cTexto        SIZE nLargura,nAltura UNIDADE OF oObjetoRef
    		oPrint:Say(nLin,350,SubStr(cTexto,nPos,1),oFont6,2500,15,500)
    		nLin += 15
		Next nPos
		  */                   
		oPrint:Say(2200, 300,"DESCONTO DE" , oFont8)
		oPrint:Say(2200, 750,"% SOBRE R$" , oFont8)
		oPrint:Say(2200, 1300,"ATษ" , oFont8)
	   	oPrint:Line (2200, 200, 2980, 200)
		oPrint:Say(2300, 300,"CONDIวีES ESPECIAIS" , oFont8)
		oPrint:Say(2400, 350,"DESTINATมRIO: " , oFont8)		
		oPrint:Say(2450, 350,"ENDEREวO: " , oFont8)				
		oPrint:Say(2500, 350,"MUNICอPIO: " , oFont8)				
		oPrint:Say(2500, 1200,"ESTADO: " , oFont8)				
		oPrint:Say(2500, 1900,"CEP: " , oFont8)	
	   /*	IF Substr(FwCodFil(),1,2) =='41'  //filial			
			oPrint:Say(2550, 350,"PRAวA DE PAGAMENTO: UBERLANDIA - MG" , oFont8) 
		ELSEIF Substr(FwCodFil(),1,2) =='42'
			oPrint:Say(2550, 350,"PRAวA DE PAGAMENTO: UBERABA - MG" , oFont8) 
		ENDIF  */
		oPrint:Say(2550, 350,"PRAวA DE PAGAMENTO:" , oFont8)						
		oPrint:Say(2600, 350,"INSCR. NO C.N.P.J. (M.F.) Nบ: " , oFont8)						
		oPrint:Say(2650, 350,"INSCR. ESTADUAL Nบ: " , oFont8)						
		oPrint:Say(2770, 350, "VALOR" , oFont8N)	
		oPrint:Say(2820, 350, "  POR" , oFont8N)	
		oPrint:Say(2870, 345, "EXTENSO" , oFont8N)	
		oPrint:Say(2980, 350, "RECONHEวO(EMOS)  A  EXATIDรO  DESTA  DUPLICATA  DE  VENDA  MERCANTIL,  NA  IMPORTยNCIA  ACIMA,  QUE  PAGAREI(EMOS)  ภ " , oFont8)	
		oPrint:Say(3030, 350, AllTrim(Upper(SM0->M0_NOMECOM))+", OU ภ SUA ORDEM NA PRAวA E VENCIMENTO INDICADOS." , oFont8)	
		oPrint:Say(3100, 350, "_______/_______/_______                                              ____________________________________________________" , oFont10)			
		oPrint:Say(3150, 450, "DATA DO ACEITE" , oFont8)			
		oPrint:Say(3150, 1600, "ASSINATURA DO SACADO" , oFont8)			

Return                    

Static Function Rod()

oPrint:EndPage() // Termina a pagina

Return 