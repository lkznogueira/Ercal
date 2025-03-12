/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ MNTA420A ºAutor  ³Carlos Daniel       º Data ³  19/03/2021 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ PONTO DE ENTRADA QUE PERMITE CRIACAO DE BOTAO ESPECIFICO   º±±
±±º          ³ NO BROWSE DA ROTINA MNTA420                                º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP12 - MANUTENCAO                                          º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

#include "colors.ch"
#include "protheus.ch"
#include "topconn.ch"                   

User Function MNTA420A()


	aAdd(aRotina,{"Sol. Compras","Processa({||U_MNT420SC()},'Solicitação de Compras')",0,3})

	//If AllTrim(UPPER(cUserName))$"ALTEVIRMS/JOAOFR"
		aAdd(aRotina,{"Alt. Data"   ,"U_MNT420AD()",0,3})
		aAdd(aRotina,{"Alt. Natureza"   ,"U_ALTNATU()",0,3})
	//EndIf


Return

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ TRAZ UMA TELA COM AS SCS DA OS SELECIONADA ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

User Function MNT420SC()
Local nAltura    := 300
Local nLargura   := 500
Private aHeader  := {}
Private aCols    := {}

	aAdd(aHeader,{"Num SC"      , "C1_NUM"     , "@!"          , 06,00, ".F."  ,"","C","SC1"})  
	aAdd(aHeader,{"Produto"     , "C1_PRODUTO" , "@!"     	   , 15,00, ".F."  ,"","C","SC1"})  
	aAdd(aHeader,{"Desc."       , "C1_DESCRI"  , "@!"      	   , 40,00, ".F."  ,"","C","SC1"})  
	aAdd(aHeader,{"Quant."      , "C1_QUANT"   , "@E 9,999,999", 09,00, ".F."  ,"","N","SC1"})  
	aAdd(aHeader,{"Entregue"    , "C1_QUJE"    , "@E 9,999,999", 09,00, ".F."  ,"","N","SC1"})
	aAdd(aHeader,{"Natureza"    , "C1_XNATURE" , "@!"          , 30,00, ".F."  ,"","C","SC7"})
	aAdd(aHeader,{"Pedido"      , "C7_NUM"     , "@!"          , 06,00, ".F."  ,"","C","SC7"})
	aAdd(aHeader,{"Dt. Entrega" , "C7_DATPRF"  , "99/99/99"    , 08,00, ".F."  ,"","D","SC7"})
	

	cQuery := " SELECT C1.C1_NUM, C1.C1_PRODUTO, C1.C1_DESCRI, C1.C1_QUANT, C1.C1_QUJE, C1.C1_XNATURE, "
	cQuery += " (CASE WHEN (select C7.C7_NUM from "+RetSqlName("SC7")+" C7  where c7.d_e_l_e_t_ <> '*' and c7_numsc = c1_num and c7_filial = c1_filial and c7_itemsc = c1_item) IS NULL THEN ' '" 
    cQuery += "       ELSE (select C7.C7_NUM from "+RetSqlName("SC7")+" C7  where c7.d_e_l_e_t_ <> '*' and c7_numsc = c1_num and c7_filial = c1_filial and c7_itemsc = c1_item)"
    cQuery += "       END) AS C7_NUM,"
    cQuery += " (CASE WHEN (select C7.C7_DATPRF from "+RetSqlName("SC7")+" C7  where c7.d_e_l_e_t_ <> '*' and c7_numsc = c1_num and c7_filial = c1_filial and c7_itemsc = c1_item) IS NULL THEN ' '" 
    cQuery += "       ELSE (select C7.C7_DATPRF from "+RetSqlName("SC7")+" C7  where c7.d_e_l_e_t_ <> '*' and c7_numsc = c1_num and c7_filial = c1_filial and c7_itemsc = c1_item)"
    cQuery += "       END) AS C7_DATPRF FROM "+RetSqlName("SC1")+" C1"
	cQuery += " WHERE C1_OP = '"+STJ->TJ_ORDEM+'OS001'+"'"
	cQuery += " AND C1.C1_FILIAL = '"+xFilial("SC1")+"'"
	cQuery += " AND C1.D_E_L_E_T_ = ' '"
	
	TCQUERY cQuery NEW ALIAS "TRA1"
	
	TRA1->(DbGoTop())
	
	If Empty(TRA1->C1_NUM)
		Alert("Não existe S.C. para esta O.S.!")
		TRA1->(DBCLOSEAREA())
		Return
	EndIf
	
	WHILE TRA1->(!eof())
		aAdd(aCols,{TRA1->C1_NUM,TRA1->C1_PRODUTO,SUBSTR(TRA1->C1_DESCRI,1,40),TRA1->C1_QUANT,TRA1->C1_QUJE,SUBSTR(TRA1->C1_XNATURE,1,40),TRA1->C7_NUM, STOD(C7_DATPRF),.F.})
		TRA1->(DbSkip())
	ENDDO

	oDlg := MsDialog():New(0,0,nAltura,nLargura,"Solicitação de Compra",,,,,CLR_BLACK,CLR_WHITE,,,.T.)
	
	oSay := tSay():New(10,10 ,{||"OS: "+STJ->TJ_ORDEM}  ,oDlg,,,,,,.T.,,)	

    // cria o getDados
	oGeTD := MsGetDados():New( 25               ,; //superior 
	                           5                ,; //esquerda
	                           (nAltura/2)-27       ,; //inferior
	                           (nLargura/2)-5       ,; //direita 	   
	                           4                ,; // nOpc
	                           "AllwaysTrue"    ,; // CLINHAOK
	                           "AllwaysTrue"    ,; // CTUDOOK
	                           ""               ,; // CINICPOS
	                           .F.              ,; // LDELETA
	                           .F.              ,; // aAlter
	                           nil              ,; // uPar1
	                           .F.              ,; // LEMPTY
	                           Len(aCols)       ,; // nMax
	                           nil              ,; // cCampoOk
	                           "AllwaysTrue()"  ,; // CSUPERDEL
	                           nil              ,; // uPar2
	                           "AllwaysTrue()"  ,; // CDELOK
	                           oDlg              ; // oWnd 
	                          )
	
	oGroup := tGroup():New((nAltura/2)-22,5,(nAltura/2)-20,(nLargura/2)-5,,oDlg,,,.T.)
	
    oBtn1 := tButton():New((nAltura/2)-15,(nLargura/2)-45,"Ok",oDlg,{||oDlg:End()},40,10,,,,.T.)
	
	oDlg:Activate(,,,.T.,{||.T.},,{||})

	TRA1->(DBCLOSEAREA())	

Return	
              
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ ABRE UMA TELA PARA ALTERACAO DA DATA ORIGINAL DA OS ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
User Function MNT420AD()
Private dDtOrigi  := STJ->TJ_DTORIGI

    oFont1 := TFont():New("Arial",,18,,.t.,,,,,.f.)
	
	oDlg := MsDialog():New(0,0,100,200,"Altera Data Original",,,,,CLR_BLACK,CLR_WHITE,,,.T.)

	oSay1 := TSay():New(10,10,{||"Ordem"},oDlg,,,,,,.T.,,)
	oSay2 := TSay():New(10,50,{||STJ->TJ_ORDEM},oDlg,,oFont1,,,,.T.,,)

	oSay3 := TSay():New(22,10,{||"Dt Original"},oDlg,,,,,,.T.,CLR_HBLUE,)
	oGet1 := tGet():New(20,50,{|u| if(Pcount() > 0, dDtOrigi := u,dDtOrigi)},oDlg,40,8,"@!",{||.T.},;
		,,,,,.T.,,,{|| .T.},,,,,,,"dDtOrigi")

    oBtn1 := tButton():New(34,50,"Ok",oDlg,{||fGrvData()},40,10,,,,.T.)
	
	oDlg:Activate(,,,.T.,{||.T.},,{||})

Return

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ GRAVA A DATA ORIGINAL NA TABELA STJ ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Static Function fGrvData()

	//If AllTrim(UPPER(cUserName))$"Administrador"
		RecLock("STJ",.F.)
			STJ->TJ_DTORIGI := dDtOrigi
        MsUnLock("STJ")
	//Else
		Alert("Data Original Alterada com Sucesso!")
    //EndIf

	oDlg:End()
	
Return

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ ABRE UMA TELA PARA ALTERACAO DA DATA ORIGINAL DA OS ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
User Function ALTNATU()
Private nAturez  := ' '
Private nSc  := ' '
Private nPc  := ' '
 

	cQuery := " SELECT C1.C1_NUM, C1.C1_PRODUTO, C1.C1_DESCRI, C1.C1_QUANT, C1.C1_QUJE, C1.C1_XNATURE, "
	cQuery += " (CASE WHEN (select C7.C7_NUM from "+RetSqlName("SC7")+" C7  where c7.d_e_l_e_t_ <> '*' and c7_numsc = c1_num and c7_filial = c1_filial and c7_itemsc = c1_item) IS NULL THEN ' '" 
    cQuery += "       ELSE (select C7.C7_NUM from "+RetSqlName("SC7")+" C7  where c7.d_e_l_e_t_ <> '*' and c7_numsc = c1_num and c7_filial = c1_filial and c7_itemsc = c1_item)"
    cQuery += "       END) AS C7_NUM,"
    cQuery += " (CASE WHEN (select C7.C7_DATPRF from "+RetSqlName("SC7")+" C7  where c7.d_e_l_e_t_ <> '*' and c7_numsc = c1_num and c7_filial = c1_filial and c7_itemsc = c1_item) IS NULL THEN ' '" 
    cQuery += "       ELSE (select C7.C7_DATPRF from "+RetSqlName("SC7")+" C7  where c7.d_e_l_e_t_ <> '*' and c7_numsc = c1_num and c7_filial = c1_filial and c7_itemsc = c1_item)"
    cQuery += "       END) AS C7_DATPRF FROM "+RetSqlName("SC1")+" C1"
	cQuery += " WHERE C1_OP = '"+STJ->TJ_ORDEM+'OS001'+"'"
	cQuery += " AND C1.C1_FILIAL = '"+xFilial("SC1")+"'"
	cQuery += " AND C1.D_E_L_E_T_ = ' '"
	
	TCQUERY cQuery NEW ALIAS "TRA1"
	
	TRA1->(DbGoTop())
	
	If Empty(TRA1->C1_NUM)
		Alert("Não existe S.C.!")
		TRA1->(DBCLOSEAREA())
		Return
	EndIf
	
	nAturez  := TRA1->C1_XNATURE
	nSc      := TRA1->C1_NUM
	nPc      := TRA1->C7_NUM
	
    oFont1 := TFont():New("Arial",,18,,.t.,,,,,.f.)
	
	oDlg := MsDialog():New(0,0,100,200,"Altera Natureza SC;PC",,,,,CLR_BLACK,CLR_WHITE,,,.T.)

	oSay1 := TSay():New(10,10,{||"SC"},oDlg,,,,,,.T.,,)
	oSay2 := TSay():New(10,50,{||nSc},oDlg,,oFont1,,,,.T.,,)

	oSay3 := TSay():New(22,10,{||"Natureza"},oDlg,,,,,,.T.,CLR_HBLUE,)
	oGet1 := tGet():New(20,50,{|u| if(Pcount() > 0, nAturez := u,nAturez)},oDlg,40,8,"@!",{||.T.},;
		,,,,,.T.,,,{|| .T.},,,,,,,"nAturez")

    oBtn1 := tButton():New(34,50,"Ok",oDlg,{||fGrvNatu()},40,10,,,,.T.)
	
	oDlg:Activate(,,,.T.,{||.T.},,{||})
	TRA1->(DBCLOSEAREA())

Return

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ INCLUI NATUREZA NA SC1			    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Static Function fGrvNatu()
DbSelectArea("SC1")
DbSetOrder(1)
SC1->(DbGoTop())
If SC1->(DbSeek(xFilial("SC1")+nSc))
	RecLock("SC1",.F.)
	SC1->C1_XNATURE := nAturez
    MsUnLock("SC1")
    If nPc <> ' '
    	dbSelectArea("SC7")
    	dbSetOrder(1)
    	dbSeek(xFilial("SC7")+nPc+"0001")
    	RecLock("SC7",.F.)
    	SC7->C7_XNATURE := nAturez
    	MsUnLock("SC7")
    	MsgInfo("Natureza Alterada com Sucesso na SC e no PC!","AVISO")
    Else
    	MsgInfo("Natureza Alterada com Sucesso na SC!","AVISO")
    EndIf
Else
	Alert("Nao foi possivel alterar a Natureza!")
EndIf
	//If AllTrim(UPPER(cUserName))$"Administrador"
		//RecLock("SC1",.F.)
		//	SC1->C1_XNATURE := nAturez
       // MsUnLock("SC1")
	//Else
//Alert("Natureza Alterada com Sucesso!")
    //EndIf

oDlg:End()
	
Return
