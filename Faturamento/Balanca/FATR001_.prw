#include "TopConn.ch"
#Include "PROTHEUS.CH"  
#Include "VKEY.CH"

         
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³FATR001_  ºAutor  ³Innovare Soluções   º Data ³  12/08/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏsÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ TICKET de Pegagem de Veiculo  						     º±±
±±º          ³ 															 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/


User Function FATR001()    
	Local   cOrdem	 := ZC3->ZC3_ORDEM
	Local   _aArea	 := GetArea()
	Private nBorEsq  := 50                    
	Private nBorDir  := 1500
	Private nBorSup  := 70
	Private nBorInf  := 3360 
	Private nLi      := 070
	Private nIncHori := 0
	Private nVertAtu := 235  
	Private nVertAnt
                                                                             
	cQuery:= " SELECT ZC3_ORDEM, ZC3_CODCLI, ZC3_NOMCLI, ZC3_PLACA, ZC3_CODMOT, ZC3_MOTORI, ZC3_PESINI,ZC3_PESFIM,ZC3_PESLIQ FROM "+RetSqlName("ZC3")+" ZC3 "
	cQuery+= " WHERE ZC3.D_E_L_E_T_ <> '*' 
	cQuery+= " AND ZC3_FILIAL = '" + xFilial("ZC3") + "'"
	cQuery+= " AND ZC3_ORDEM  = '" + cOrdem + "'"

	IF SELECT("QZC3") > 1
			QZC3->(dbclosearea())
	EndIf	
                                                                 	
 	TcQuery cQuery New Alias "QZC3"  


	#translate RGB( <nRed>, <nGreen>, <nBlue> ) => ;
	              ( <nRed> + ( <nGreen> * 256 ) + ( <nBlue> * 65536 ) )

//ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ//
//                        Low Intensity colors
//ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ//

#define CLR_BLACK             0               // RGB(   0,   0,   0 )
#define CLR_BLUE        8388608               // RGB(   0,   0, 128 )
#define CLR_GREEN         32768               // RGB(   0, 128,   0 )
#define CLR_CYAN        8421376               // RGB(   0, 128, 128 )
#define CLR_RED             128               // RGB( 128,   0,   0 )
#define CLR_MAGENTA     8388736               // RGB( 128,   0, 128 )
#define CLR_BROWN         32896               // RGB( 128, 128,   0 )
#define CLR_HGRAY      12632256               // RGB( 192, 192, 192 )
#define CLR_LIGHTGRAY  CLR_HGRAY

//ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ//
//                       High Intensity Colors
//ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ//

#define CLR_GRAY        8421504               // RGB( 128, 128, 128 )
#define CLR_HBLUE      16711680               // RGB(   0,   0, 255 )
#define CLR_HGREEN        65280               // RGB(   0, 255,   0 )
#define CLR_HCYAN      16776960               // RGB(   0, 255, 255 )
#define CLR_HRED            255               // RGB( 255,   0,   0 )
#define CLR_HMAGENTA   16711935               // RGB( 255,   0, 255 )
#define CLR_YELLOW        65535               // RGB( 255, 255,   0 )
#define CLR_WHITE      16777215               // RGB( 255, 255, 255 )

oFont18n	:= TFont():New('Times New Roman',18,18,,.T.,,,,.T.,.F.)
oFont16n    := TFont():New('Times New Roman',16,16,,.T.,,,,.T.,.F.)
oFont12	    := TFont():New('Times New Roman',12,12,,.F.,,,,.T.,.F.)
oFont12n    := TFont():New('Times New Roman',12,12,,.T.,,,,.T.,.F.)
oFont10n    := TFont():New('Times New Roman',10,10,,.T.,,,,.T.,.F.)
oFont15n    := TFont():New('Times New Roman',15,15,,.T.,,,,.T.,.F.)
oFont14n    := TFont():New('Times New Roman',14,14,,.T.,,,,.T.,.F.)
oFont14     := TFont():New('Times New Roman',14,14,,.F.,,,,.T.,.F.)
oFont16     := TFont():New('Times New Roman',16,16,,.F.,,,,.T.,.F.)
oFont20N    := TFont():New('Times New Roman',20,20,,.T.,,,,.T.,.F.)

oPrint := TMSPrinter():New() 

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Define Tamanho do Papel                                              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

 #define DMPAPER_A4 9 		//Papel A4

oPrint:setPaperSize( DMPAPER_A4 )
oPrint:SetPortrait() 		//SetLandscape()
oPrint:StartPage()

RptStatus( {|lEnd| Imprime()})		

oPrint:EndPage()
oPrint:Preview() 			//-visualiza na tela
oPrint:End()
MS_FLUSH()

RestArea(_aArea)

Return()

Static Function Imprime()


Private nInterS := 0
Private nLinhas := 0
Private lFlag:=.F.
Private nLin := 0                                                                   

//Chama funcao para criar cabecalho
ImprCabec(1)                              
			 
		//##################### Inicio Quadro Ordem ############################# 
	    //  oPrint:Say(455,160,"N.Ordem",oFont12N)
		//	oPrint:Box(500,120,500+100,380) 	     	//N.Ordem
		//	oPrint:Say(530,150,QZC3->ZC3_ORDEM,oFont12) 	//
		//##################### Fim Quadro Ordem ################################ 
		
		nMenLin  := 400               
		
		//##################### Inicio Quadro Pedido ############################ 
		    oPrint:Say(1055-nMenLin,430,"Pedido",oFont12N)
			oPrint:Box(1105-nMenLin,400,1105+100-nMenLin,680) 	     	//N.Ordem
			oPrint:Say(1135-nMenLin,430,QZC3->ZC3_ORDEM,oFont12) 	//
		//##################### Fim Quadro Pedido ############################### 
				
		//##################### Inicio Quadro Cod.Cliente #######################
			oPrint:Say(1055-nMenLin,730,"Cliente",oFont12N)
	 	    oPrint:Box(1105-nMenLin,700,1105+100-nMenLin,960) 			     //Box Cliente
			oPrint:Say(1135-nMenLin,730,QZC3->ZC3_CODCLI,oFont12)     //Cliente
		//##################### Fim Quadro Cod.Cliente ##########################		
		
		//##################### Inicio Quadro Razão Social#######################
			oPrint:Say(1055-nMenLin,1010,"Razão Social",oFont12N)
	 	    oPrint:Box(1105-nMenLin,980,1105+100-nMenLin,2000) 			  //Box Razao Social
			oPrint:Say(1135-nMenLin,1010,QZC3->ZC3_NOMCLI,oFont12)  // Razao Social
		//##################### Fim Quadro Razão Social #########################	 
				                                                     
		//##################### Inicio Quadro Placa Veiculo #####################
			oPrint:Say(1240-nMenLin,430,"Placa",oFont12N)
	 	    oPrint:Box(1285-nMenLin,400,1285+100-nMenLin,680) 			  //Box Razao Social
			oPrint:Say(1315-nMenLin,430,QZC3->ZC3_PLACA,oFont12)  // Razao Social
		//##################### Fim Quadro Placa Veiculo#########################	   
				
	    //##################### Inicio Quadro Motorista ##########################
			oPrint:Say(1240-nMenLin,730,"Motorista",oFont12N)
	 	    oPrint:Box(1285-nMenLin,700,1285+100-nMenLin,960) 			      //Box Motorista
			oPrint:Say(1315-nMenLin,740,QZC3->ZC3_CODMOT,oFont12)  // Motorista
		//##################### Fim Quadro Placa Veiculo#########################	
		
		//##################### Inicio Quadro Nome Motorista#####################
			oPrint:Say(1240-nMenLin,1010,"Nome",oFont12N)
	 	    oPrint:Box(1285-nMenLin,980,1285+100-nMenLin,2000) 			  //Box Razao Social
			oPrint:Say(1315-nMenLin,1010,QZC3->ZC3_MOTORI,oFont12)  // Razao Social
		//##################### Fim Quadro Nome Motorista########################	   		
		
	    //##################### Inicio Quadro Peso Liquido #######################
		   oPrint:Say(795-nMenLin,730,"PESO LIQUIDO",oFont16N)
	 	   oPrint:Box(845-nMenLin,700,845+200-nMenLin,1700) 			  //Box Peso Liquido
		   oPrint:Say(905-nMenLin,905,cValtoChar(TRANSFORM(QZC3->ZC3_PESLIQ,"@E 99,999,999.99")) + " Kg",oFont20N)  // Peso Liquido
	    //##################### Fim Quadro Nome Motorista########################
		    
		nMenLin  := 580
		
	   //##################### Inicio Quadro Peso Inicio #######################
			oPrint:Say(1640-nMenLin,430,"PESO INICIO",oFont16N)
	 	    oPrint:Box(1700-nMenLin,400,1700+200-nMenLin,1000) 			  //Box Peso Inicio
			oPrint:Say(1800-nMenLin,600,cValtoChar(TRANSFORM(QZC3->ZC3_PESINI,"@E 99,999,999.99")) + " Kg",oFont16)  // Peso Inicio
	   //##################### Fim Quadro Placa Veiculo#########################	   
		
	   //##################### Inicio Quadro Peso Final #########################
			oPrint:Say(1640-nMenLin,1360,"PESO FINAL",oFont16N)
//			oPrint:Say(2000-nMenLin-10,1360,"Desconto",oFont10N)
	 	    oPrint:Box(1700-nMenLin,1330,1700+200-nMenLin,2000) 			      //Box Peso Final
			oPrint:Say(1800-nMenLin,1550,cValtoChar(TRANSFORM(QZC3->ZC3_PESFIM,"@E 99,999,999.99")) + " Kg",oFont16)  // Peso Final
		//##################### Fim Quadro Placa Veiculo ########################			
	 
	   //Imprime SEGUNDA PARTE	
		nMenLin  := 400               
		
		//##################### Inicio Quadro Pedido ############################ 
		    oPrint:Say(2555-nMenLin,430,"Pedido",oFont12N)
			oPrint:Box(2605-nMenLin,400,2605+100-nMenLin,680) 	     	//N.Ordem
			oPrint:Say(2635-nMenLin,430,QZC3->ZC3_ORDEM,oFont12) 	//
		//##################### Fim Quadro Pedido ############################### 
				
		//##################### Inicio Quadro Cod.Cliente #######################
			oPrint:Say(2555-nMenLin,730,"Cliente",oFont12N)
	 	    oPrint:Box(2605-nMenLin,700,2605+100-nMenLin,960) 			     //Box Cliente
			oPrint:Say(2635-nMenLin,730,QZC3->ZC3_CODCLI,oFont12)     //Cliente
		//##################### Fim Quadro Cod.Cliente ##########################		
		
		//##################### Inicio Quadro Razão Social#######################
			oPrint:Say(2555-nMenLin,1010,"Razão Social",oFont12N)
	 	    oPrint:Box(2605-nMenLin,980,2605+100-nMenLin,2000) 			  //Box Razao Social
			oPrint:Say(2635-nMenLin,1010,QZC3->ZC3_NOMCLI,oFont12)  // Razao Social
		//##################### Fim Quadro Razão Social #########################	 
				                                                     
		//##################### Inicio Quadro Placa Veiculo #####################
			oPrint:Say(2740-nMenLin,430,"Placa",oFont12N)
	 	    oPrint:Box(2785-nMenLin,400,2785+100-nMenLin,680) 			  //Box Razao Social
			oPrint:Say(2815-nMenLin,430,QZC3->ZC3_PLACA,oFont12)  // Razao Social
		//##################### Fim Quadro Placa Veiculo#########################	   
				
	    //##################### Inicio Quadro Motorista ##########################
			oPrint:Say(2740-nMenLin,730,"Motorista",oFont12N)
	 	    oPrint:Box(2785-nMenLin,700,2785+100-nMenLin,960) 			      //Box Motorista
			oPrint:Say(2815-nMenLin,740,QZC3->ZC3_CODMOT,oFont12)  // Motorista
		//##################### Fim Quadro Placa Veiculo#########################	
		
		//##################### Inicio Quadro Nome Motorista#####################
			oPrint:Say(2740-nMenLin,1010,"Nome",oFont12N)
	 	    oPrint:Box(2785-nMenLin,980,2785+100-nMenLin,2000) 			  //Box Razao Social
			oPrint:Say(2815-nMenLin,1010,QZC3->ZC3_MOTORI,oFont12)  // Razao Social
		//##################### Fim Quadro Nome Motorista########################	   		
		
	    //##################### Inicio Quadro Peso Liquido #######################
		   oPrint:Say(2295-nMenLin,730,"PESO LIQUIDO",oFont16N)
	 	   oPrint:Box(2345-nMenLin,700,2345+200-nMenLin,1700) 			  //Box Peso Liquido
		   oPrint:Say(2405-nMenLin,905,cValtoChar(TRANSFORM(QZC3->ZC3_PESLIQ,"@E 99,999,999.99")) + " Kg",oFont20N)  // Peso Liquido
	    //##################### Fim Quadro Nome Motorista########################
		    
		nMenLin  := 580
		
	   //##################### Inicio Quadro Peso Inicio #######################
			oPrint:Say(3140-nMenLin,430,"PESO INICIO",oFont16N)
	 	    oPrint:Box(3200-nMenLin,400,3200+200-nMenLin,1000) 			  //Box Peso Inicio
			oPrint:Say(3300-nMenLin,600,cValtoChar(TRANSFORM(QZC3->ZC3_PESINI,"@E 99,999,999.99")) + " Kg",oFont16)  // Peso Inicio
	   //##################### Fim Quadro Placa Veiculo#########################	   
		
	   //##################### Inicio Quadro Peso Final #########################
			oPrint:Say(3140-nMenLin,1360,"PESO FINAL",oFont16N)
//			oPrint:Say(2000-nMenLin-10,1360,"Desconto",oFont10N)
	 	    oPrint:Box(3200-nMenLin,1330,3200+200-nMenLin,2000) 			      //Box Peso Final
			oPrint:Say(3300-nMenLin,1550,cValtoChar(TRANSFORM(QZC3->ZC3_PESFIM,"@E 99,999,999.99")) + " Kg",oFont16)  // Peso Final
		//##################### Fim Quadro Placa Veiculo ########################	
Return()

// Funcao que Imprime cabecalho no relatorio
Static Function ImprCabec(opc)
//Local nPag:= 0

	oPrint:StartPage() // Inicia uma nova pagina
	cStartPath := GetPvProfString(GetEnvServer(),"StartPath","ERROR",GetAdv97())
	
	nLin:=100                                              
	                
	oPrint:Say(nLin+80,  2160, "Data",			oFont10N)
 	oPrint:Say(nLin+80,  2270, dTOc(dDataBase),	oFont10N)
 	oPrint:Say(nLin+120, 2160, "Hora", 			oFont10N)
 	oPrint:Say(nLin+120, 2270, TIME(), 			oFont10N)
 	             
	//oPrint:Box(nLin,100,nLin+250,570)  //quadro da imagem
	//oPrint:Box(nLin,570,nLin+250,1500) //quadro do titulo
   	//oPrint:Box(nLin,2650,nLin+250,1500)//quadro detalhes
	//oPrint:SayBitmap(nLin,070, cStartPath + "lgrl01.bmp", 400, 220)///Impressao da Logo  
 	nLin+=60   
	//TRATA FILIAL
	If cFilAnt = '4200'	
		oPrint:Say(nLin, 600, "ERCAL SOLUÇÕES", oFont14n)//Titulo relatorio 
	Elseif cFilAnt ='4600'
		oPrint:Say(nLin, 600, "TOP FERTILIZANTES", oFont14n)//Titulo relatorio 
	Elseif cFilAnt = '4101' .or. cFilAnt = '4104'
 		oPrint:Say(nLin, 600, "ERCAL EMPRESAS REUNIDAS DE CALCARIO LTDA", oFont14n)//Titulo relatorio 
	EndIf
 	nLin+=60
 	oPrint:Say(nLin, 1000, "TICKET PESAGEM", oFont16n)//Titulo relatorio       
 	nLin+=100
 	oPrint:Say(nLin, 1000, "ORDEM N. "+ QZC3->ZC3_ORDEM , oFont16n)// 
 	
	// SEGUNDA IMPRESSAO

	nLin:=1650                                              
	                
	oPrint:Say(nLin+80,  2160, "Data",			oFont10N)
 	oPrint:Say(nLin+80,  2270, dTOc(dDataBase),	oFont10N)
 	oPrint:Say(nLin+120, 2160, "Hora", 			oFont10N)
 	oPrint:Say(nLin+120, 2270, TIME(), 			oFont10N)

	nLin:=1650   
	//TRATA FILIAL
	If cFilAnt = '4200'	
		oPrint:Say(nLin, 600, "ERCAL SOLUÇÕES", oFont14n)//Titulo relatorio 
	Elseif cFilAnt ='4600'
		oPrint:Say(nLin, 600, "TOP FERTILIZANTES", oFont14n)//Titulo relatorio 
	Elseif cFilAnt = '4101' .or. cFilAnt = '4104'
 		oPrint:Say(nLin, 600, "ERCAL EMPRESAS REUNIDAS DE CALCARIO LTDA", oFont14n)//Titulo relatorio 
	EndIf
 	nLin+=60
 	oPrint:Say(nLin, 1000, "TICKET PESAGEM", oFont16n)//Titulo relatorio       
 	nLin+=100
 	oPrint:Say(nLin, 1000, "ORDEM N. "+ QZC3->ZC3_ORDEM , oFont16n)// 
 	
  
Return()
