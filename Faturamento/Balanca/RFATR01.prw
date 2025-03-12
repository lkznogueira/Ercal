#INCLUDE "Protheus.ch"
#INCLUDE "topconn.ch"
#INCLUDE "rwmake.ch"                                                                                         

/*
________________________________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-------------------------------------------------------------------------------------------+¦¦
¦¦¦Programa  ¦ RFATR01 ¦ Autor ¦ Innovare Solucoes   ¦ Data ¦ 10/09/13                        ¦¦¦
¦¦+----------+--------------------------------------------------------------------------------¦¦¦
¦¦¦Descriçào ¦                                                                                ¦¦¦
¦¦¦          ¦ Relatorio de Ordem de Carregamento                                             ¦¦¦
¦¦¦Retorno   ¦                                                                                ¦¦¦                                                                       
¦¦+----------+------------------------------------------------------------------------------- ¦¦¦
¦¦¦ Uso      ¦ Montividiu                                                                     ¦¦¦
¦¦+----------+--------------------------------------------------------------------------------¦¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
*/

User Function RFATR01()
	
	Local cQuery := ""
	Local cEOL   := Chr(13) + Chr(10)
	Local nCont := 0 
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ'ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Variaveis de Tipos de fontes que podem ser utilizadas no relatório   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	Private oFont6		:= TFONT():New("ARIAL",7,6,.T.,.F.,5,.T.,5,.T.,.F.) ///Fonte 6 Normal
	Private oFont6N 	:= TFONT():New("ARIAL",7,6,,.T.,,,,.T.,.F.) ///Fonte 6 Negrito
	Private oFont8		:= TFONT():New("ARIAL",9,8,.T.,.F.,5,.T.,5,.T.,.F.) ///Fonte 8 Normal
	Private oFont8N 	:= TFONT():New("ARIAL",8,8,,.T.,,,,.T.,.F.) ///Fonte 8 Negrito
	Private oFont10 	:= TFONT():New("ARIAL",9,10,.T.,.F.,5,.T.,5,.T.,.F.) ///Fonte 10 Normal
	Private oFont10S	:= TFONT():New("ARIAL",9,10,.T.,.F.,5,.T.,5,.T.,.T.) ///Fonte 10 Sublinhando
	Private oFont10N 	:= TFONT():New("ARIAL",9,10,,.T.,,,,.T.,.F.) ///Fonte 10 Negrito
	Private oFont12		:= TFONT():New("ARIAL",12,12,,.F.,,,,.T.,.F.) ///Fonte 12 Normal
	Private oFont12NS	:= TFONT():New("ARIAL",12,12,,.T.,,,,.T.,.T.) ///Fonte 12 Negrito e Sublinhado
	Private oFont12N	:= TFONT():New("ARIAL",12,12,,.T.,,,,.T.,.F.) ///Fonte 12 Negrito 
	Private oFont14		:= TFONT():New("ARIAL",14,14,,.F.,,,,.T.,.F.) ///Fonte 14 Normal
	Private oFont14NS	:= TFONT():New("ARIAL",14,14,,.T.,,,,.T.,.T.) ///Fonte 14 Negrito e Sublinhado
	Private oFont14N	:= TFONT():New("ARIAL",14,14,,.T.,,,,.T.,.F.) ///Fonte 14 Negrito
	Private oFont16 	:= TFONT():New("ARIAL",16,16,,.F.,,,,.T.,.F.) ///Fonte 16 Normal
	Private oFont16N	:= TFONT():New("ARIAL",16,16,,.T.,,,,.T.,.F.) ///Fonte 16 Negrito
	Private oFont16NS	:= TFONT():New("ARIAL",16,16,,.T.,,,,.T.,.T.) ///Fonte 16 Negrito e Sublinhado
	Private oFont20N	:= TFONT():New("ARIAL",20,20,,.T.,,,,.T.,.F.) ///Fonte 20 Negrito
	Private oFont22N	:= TFONT():New("ARIAL",22,22,,.T.,,,,.T.,.F.) ///Fonte 22 Negrito
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Variveis para impressão                                              ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	Private cStartPath
	Private nLin 		:= 50
	Private oPrint		:= TMSPRINTER():New("")
	Private nPag		:= 1 
	Private cPerg := "RESTR002"
    
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Define Tamanho do Papel                                              ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	#define DMPAPER_A4 9 //Papel A4
	oPrint:setPaperSize( DMPAPER_A4 )
	
	//TMSPrinter(): SetPaperSize ()
	
	    	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄvÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Orientacao do papel (Retrato ou Paisagem)                            ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	oPrint:SetPortrait()///Define a orientacao da impressao como retrato
	// oPrint:SetLandscape() ///Define a orientacao da impressao como paisagem
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Monta Query com os dados que serao impressos no relatorio            ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
cQuery := " SELECT ZC3_FILIAL,ZC3_ORDEM,ZC4_CONTRA,ZC3_CODCLI,ZC3_LOJA,ZC3_NOMCLI,ZC3_PLACA,ZC3_DTRETI,ZC3_HORA, " +cEOL
cQuery += " ZC3_CODMOT,ZC3_MOTORI, ZC3_PESINI,ZC3_PESFIM,ZC3_PESLIQ, " +cEOL
cQuery += " ZC4_PRODUT,ZC4_DESCRI,ZC4_QTDE,ZC4_PALET QTDE_EMB,ZC4_EMBAL " +cEOL

cQuery += " FROM "+RetSQLName("ZC3")+" Z3 INNER JOIN "+RetSQLName("ZC4")+" Z4 ON Z3.ZC3_ORDEM = Z4.ZC4_ORDEM AND Z3.ZC3_FILIAL = Z4.ZC4_FILIAL " +cEOL
cQuery += " WHERE Z3.D_E_L_E_T_ <> '*' " +cEOL 
cQuery += "   AND Z4.D_E_L_E_T_ <> '*' " +cEOL
cQuery += "   AND ZC3_FILIAL = '"+xFilial("ZC3")+"' " +cEOL
cQuery += "   AND ZC3_ORDEM  = '"+ZC3->ZC3_ORDEM+"' " +cEOL
cQuery += "   ORDER BY ZC4_PRODUT " +cEOL
                
cQuery := Changequery(cQuery)

IF SELECT ("QZC4") > 1
	QZC4->(DbCloseArea())
ENDIF     
  
TcQuery cQuery New Alias "QZC4" // Cria uma nova ar	ea com o resultado do query   
	           	
	QZC4->(DBGoTop()) 
	Cabecalho()
	     
	nLin := 370
	oPrint:Say(nLin,153,"Data:",								oFont8N)
    oPrint:Say(nLin,225,SubsTr(QZC4->ZC3_DTRETI,7,2)+ "/" +SubsTr(QZC4->ZC3_DTRETI,5,2)+ "/" +SubsTr(QZC4->ZC3_DTRETI,1,4),								oFont8)	                                                                                `
    
    oPrint:Say(nLin,670,"Hora:",oFont8N)	                                                                                `
    oPrint:Say(nLin,745,QZC4->ZC3_HORA,								oFont8)	                                                                                `
	
	oPrint:Say(nLin,1050,"Placa:",								oFont8N)	 
	oPrint:Say(nLin,1135,QZC4->ZC3_PLACA,								oFont8)	                                                                                `

	SaltLin(50)
	
    oPrint:Say(nLin,153,"Motorista:",								oFont8N)
    oPrint:Say(nLin,290,QZC4->ZC3_CODMOT,								oFont8)	                                                                                `
    
    oPrint:Say(nLin,670,"No.Motorista:",                            oFont8N)	                                                                                `
    oPrint:Say(nLin,860,QZC4->ZC3_MOTORI,								oFont8)	                                                                                `
	
	SaltLin(50)
	
	oPrint:Say(nLin,153,"Cod.Cliente:",                                 oFont8N)	 
	oPrint:Say(nLin,335,QZC4->ZC3_CODCLI,								oFont8)	                                                                                `
	
	oPrint:Say(nLin,670,"Loja:",								oFont8N)	 
	oPrint:Say(nLin,740,QZC4->ZC3_LOJA,								oFont8)	                                                                                `                         
	
	oPrint:Say(nLin,1050,"No Cliente:",								oFont8N)	 
	oPrint:Say(nLin,1200,QZC4->ZC3_NOMCLI,								oFont8)	                                                                                `                         
                        	
    SaltLin(50)
    
    oPrint:Say(nLin,153,"Peso Inicial:",                                 oFont8N)	 
	oPrint:Say(nLin,250,TRANSFORM(QZC4->ZC3_PESINI,"@E 999,999,999.99"),								oFont8)	                                                                                `
	
	oPrint:Say(nLin,670,"Peso Final:",								oFont8N)	 
	oPrint:Say(nLin,770,TRANSFORM(QZC4->ZC3_PESFIM,"@E 999,999,999.99"),								oFont8)	                                                                                `                         
	
	oPrint:Say(nLin,1050,"Peso Líquido:",								oFont8N)	 
	oPrint:Say(nLin,1150,TRANSFORM(QZC4->ZC3_PESLIQ,"@E 999,999,999.99"),								oFont8)	                                                                                `                         

    
	
	SaltLin(70)
	oPrint:Say(nLin,153,"Itens do Contrato:",                                 oFont10N)
	SaltLin(50)
		
	oPrint:Box(nLin,153,nLin+50,350) //Quadro de Produtos                                              
	oPrint:Say(nLin,157,"Item",								oFont8N)
	
	oPrint:Box(nLin,350,nLin+50,600)                                               
	oPrint:Say(nLin,357,"Contrato",								oFont8N)    
	
	
	oPrint:Box(nLin,600,nLin+50,850)                                               
	oPrint:Say(nLin,607,"Cod.Produto",								oFont8N)
	
 	oPrint:Box(nLin,850,nLin+50,1600)                                               
	oPrint:Say(nLin,857,"Descrição",								oFont8N)
			    	 
	oPrint:Box(nLin,1600,nLin+50,1850)                                              
	oPrint:Say(nLin,1607,"Embalagem",								oFont8N)
	
	oPrint:Box(nLin,1850,nLin+50,2090)                                               
	oPrint:Say(nLin,1857,"Qtde.Embalagem",					oFont8N)
	
	oPrint:Box(nLin,2090,nLin+50,2310) //Quadro de Produtos                                              
	oPrint:Say(nLin,2097,"Qtde.Carregada",					oFont8N)
	
	SaltLin(50)
	
		While !QZC4->(EOF())   
		                      
              
			 //###################### Inicio Quadro Item###########################################################
			
				oPrint:Box(nLin,153,nLin+50,350)                                              
				oPrint:Say(nLin,157,StrZero(nCont,3),								oFont8)
			
			 //###################### Fim Quadro Item############################################################## 
		 			 	
		 	 //###################### Inicio Quadro Contrato##################################################
			
				oPrint:Box(nLin,350,nLin+50,600)                                               
				oPrint:Say(nLin,357,QZC4->ZC4_CONTRA,								oFont8)
			
			 //###################### Fim Quadro Contrato############################################################
			  
			 //###################### Inicio Quadro PRODUTO##################################################
			
				oPrint:Box(nLin,600,nLin+50,850)                                               
				oPrint:Say(nLin,607,QZC4->ZC4_PRODUT,								oFont8)
			
			 //###################### Fim Quadro Contrato############################################################
		 	 
		 	 //########################### Inicio Quadro Descrição##################################################
			
				oPrint:Box(nLin,850,nLin+50,1600)                                               
				oPrint:Say(nLin,857,SubStr(QZC4->ZC4_DESCRI,1,20),								oFont8)
			
			 //##################### Fim Quadro Descrição###########################################################
			
			 //########################### Inicio Quadro Embalagem#########################################
			
				oPrint:Box(nLin,1600,nLin+50,1850)                                              
				oPrint:Say(nLin,1607,QZC4->ZC4_EMBAL,								oFont8)
			
			 //##################### Fim Quadro Contratos Embalagem##################################################
			
			 //########################### Inicio Quadro QTDE EMBALAGEM##############################################
			
				oPrint:Box(nLin,1850,nLin+50,2090)                                               
				oPrint:Say(nLin,1857,TRANSFORM(QZC4->QTDE_EMB,"@E 999,999,999.99"),					oFont8)
			
			 //##################### Fim Quadro Saldo Estoque######################################################
		
	
			//########################### Inicio Quadro QTDE CARREGADA (MANUAL)####################################
			
				oPrint:Box(nLin,2090,nLin+50,2310) //Quadro de Produtos                                              
			
			 //##################### Fim Quadro QTDE CARREGADA (MANUAL)###########################################################
			
			nCont++
			
			SaltLin(50)
		
		QZC4->(DbSkip())	
	EndDo
	  		        
  	            
	QZC4->(DBCloseArea())

	Rod()
	
	///////////////////////////////////////////////////////////////////////////////////////
	////Visualiza a impressao
	///////////////////////////////////////////////////////////////////////////////////////  
	oPrint:Preview()
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ºDesc.     ³ Funcao que monta o cabeçalho do relatorio                  º±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function Cabecalho()      
	
	
	oPrint:StartPage() // Inicia uma nova pagina
	cStartPath := GetPvProfString(GetEnvServer(),"StartPath","ERROR",GetAdv97())
	//cStartPath += If(Right(cStartPath, 1) <> "\", "\", "")
	nLin:=100                                              
	                             
	oPrint:Box(nLin,140,nLin+250,560)  //quadro da imagem
	oPrint:Box(nLin,560,nLin+250,2020) //quadro do titulo
   	oPrint:Box(nLin,2020,nLin+250,2310)//quadro detalhes
	oPrint:SayBitmap(nLin+20, 160, cStartPath + "lgrl01.bmp", 400, 220)///Impressao da Logo  
 	oPrint:Say(nLin+100, 1000, "Ordem de Carregamento", oFont16N)//Titulo relatorio 
 	
 	
 	oPrint:Say(nLin+20,  2050, QZC4->ZC3_ORDEM,			oFont10N)
 	oPrint:Say(nLin+90,  2050, "Data:",				oFont8N)
 	oPrint:Say(nLin+90,  2150, dTOc(dDataBase),	oFont8N)
 	oPrint:Say(nLin+130, 2050, "Hora:", 				oFont8N)
 	oPrint:Say(nLin+130, 2150, TIME(), 			oFont8N)
    oPrint:Say(nLin+200, 2050, "Página:", 			oFont8N)
    oPrint:Say(nLin+200, 2150, strzero(nPag++,3),	oFont8N)
 	                     
 	SaltLin(335)//Soma o tamanho referente ao tamanho dos retangulos
Return 
               
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ºDesc.     ³ Funcao que monta o rodape do Relatorio                     º±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/                                                                           

Static Function Rod()
	cStartPath := GetPvProfString(GetEnvServer(),"StartPath","ERROR",GetAdv97())
	cStartPath += If(Right(cStartPath, 1) <> "\", "\", "")
		
	nLinRod := 3200
	oPrint:Line (nLinRod, 150, nLinRod, 2310)
	nLinRod +=  20
	oPrint:SayBitmap(nLinRod, 150, cStartPath + "logo_totvs.gif", 228, 050)///Impressao da Logo
	oPrint:Say(nLinRod, 1000, "Microsiga Protheus", oFont10N)
	nLinRod += 50
	oPrint:Line (nLinRod, 150, nLinRod, 2310)
	    
	oPrint:EndPage()//fnaliza pagina
Return
/*       
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ºDesc.     ³ Funcao que muda de pagina                                  º±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/             
Static Function SaltLin(nQtdLin)
	nLin := nLin + nQtdLin     
 	if nLin >= 3100
  		Rod()  
  		Cabecalho()
  		oPrint:Box(nLin,153,nLin+50,350) //Quadro de Produtos                                              
		oPrint:Say(nLin,157,"Item",								oFont8N)
		
		oPrint:Box(nLin,350,nLin+50,600)                                               
		oPrint:Say(nLin,357,"Contrato",								oFont8N)    
		
		
		oPrint:Box(nLin,600,nLin+50,850)                                               
		oPrint:Say(nLin,607,"Cod.Produto",								oFont8N)
		
	 	oPrint:Box(nLin,850,nLin+50,1600)                                               
		oPrint:Say(nLin,857,"Descrição",								oFont8N)
				    	 
		oPrint:Box(nLin,1600,nLin+50,1850)                                              
		oPrint:Say(nLin,1607,"Embalagem",								oFont8N)
		
		oPrint:Box(nLin,1850,nLin+50,2090)                                               
		oPrint:Say(nLin,1857,"Qtde.Embalagem",					oFont8N)
		
		oPrint:Box(nLin,2090,nLin+50,2310) //Quadro de Produtos                                              
		oPrint:Say(nLin,2097,"Qtde.Carregada",					oFont8N)
		
		nLin+= 50
		
 	endIf
return
      
