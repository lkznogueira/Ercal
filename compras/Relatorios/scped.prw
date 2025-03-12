#INCLUDE 'Protheus.ch'
#INCLUDE 'TOPConn.ch'                                                                                                              
#INCLUDE 'Rwmake.ch'
#include "TbiConn.ch"
#include "TbiCode.ch"   

User Function scped() //U_exemplo1()
    Local aaCampos  	:= {"CODIGO"} //Variável contendo o campo editável no Grid
    Local aBotoes	:= {}         //Variável onde será incluido o botão para a legenda
    Private oLista                    //Declarando o objeto do browser
    Private aCabecalho  := {}         //Variavel que montará o aHeader do grid
    Private aColsEx 	:= {}         //Variável que receberá os dados
 
    //Declarando os objetos de cores para usar na coluna de status do grid
    Private oVerde  	:= LoadBitmap( GetResources(), "BR_VERDE")
    Private oAzul  	    := LoadBitmap( GetResources(), "BR_AZUL")
    Private oVermelho	:= LoadBitmap( GetResources(), "BR_VERMELHO")
    Private oAmarelo	:= LoadBitmap( GetResources(), "BR_AMARELO")
    Private oCinza      := LoadBitmap( GetResources(), "BR_CINZA")
 
    DEFINE MSDIALOG oDlg TITLE "Pedidos Vinculados" FROM 000, 000  TO 300, 700  PIXEL
        //chamar a função que cria a estrutura do aHeader
        CriaCabec()
 
        //Monta o browser com inclusão, remoção e atualização
        oLista := MsNewGetDados():New( 053, 078, 415, 775, GD_INSERT+GD_DELETE+GD_UPDATE, "AllwaysTrue", "AllwaysTrue", "AllwaysTrue", aACampos,1, 999, "AllwaysTrue", "", "AllwaysTrue", oDlg, aCabecalho, aColsEx)
 
        //Carregar os itens que irão compor o conteudo do grid
        Carregar()
 
        //Alinho o grid para ocupar todo o meu formulário
        oLista:oBrowse:Align := CONTROL_ALIGN_ALLCLIENT
 
        
        oLista:oBrowse:SetFocus()
 
        //Crio o menu que irá aparece no botão Ações relacionadas
        aadd(aBotoes,{"NG_ICO_LEGENDA", {||Legenda()},"Legenda","Legenda"})
 
        EnchoiceBar(oDlg, {|| oDlg:End() }, {|| oDlg:End() },,aBotoes)
 
    ACTIVATE MSDIALOG oDlg CENTERED
Return
    Static Function CriaCabec()
    Aadd(aCabecalho, {;
                  "",;//X3Titulo()
                  "IMAGEM",;  //X3_CAMPO
                  "@BMP",;		//X3_PICTURE
                  3,;			//X3_TAMANHO
                  0,;			//X3_DECIMAL
                  ".F.",;		//X3_VALID
                  "",;			//X3_USADO
                  "C",;			//X3_TIPO
                  "",; 			//X3_F3
                  "V",;			//X3_CONTEXT
                  "",;			//X3_CBOX
                  "",;			//X3_RELACAO
                  "",;			//X3_WHEN
                  "V"})			//
    Aadd(aCabecalho, {;
                  "Item",;//X3Titulo()
                  "ITEM",;  //X3_CAMPO
                  "@!",;		//X3_PICTURE
                  5,;			//X3_TAMANHO
                  0,;			//X3_DECIMAL
                  "",;			//X3_VALID
                  "",;			//X3_USADO
                  "C",;			//X3_TIPO
                  "",; 			//X3_F3
                  "R",;			//X3_CONTEXT
                  "",;			//X3_CBOX
                  "",;			//X3_RELACAO
                  ""})			//X3_WHEN
    Aadd(aCabecalho, {;
                  "Produto",;//X3Titulo()
                  "PRODUTO",;  //X3_CAMPO
                  "@!",;		//X3_PICTURE
                  5,;			//X3_TAMANHO
                  0,;			//X3_DECIMAL
                  "",;			//X3_VALID
                  "",;			//X3_USADO
                  "C",;			//X3_TIPO
                  "",; 			//X3_F3
                  "R",;			//X3_CONTEXT
                  "",;			//X3_CBOX
                  "",;			//X3_RELACAO
                  ""})			//X3_WHEN
    Aadd(aCabecalho, {;
                  "Pedido Compras",;	//X3Titulo()
                  "PEDIDO COMPRAS",;  	//X3_CAMPO
                  "@!",;		//X3_PICTURE
                  10,;			//X3_TAMANHO
                  0,;			//X3_DECIMAL
                  "",;			//X3_VALID
                  "",;			//X3_USADO
                  "C",;			//X3_TIPO
                  "SB1",;		//X3_F3
                  "R",;			//X3_CONTEXT
                  "",;			//X3_CBOX
                  "",;			//X3_RELACAO
                  ""})			//X3_WHEN
    Aadd(aCabecalho, {;
                  "Data Entrega",;	//X3Titulo()
                  "DATA ENTREGA",;  	//X3_CAMPO
                  "@!",;		//X3_PICTURE
                  50,;			//X3_TAMANHO
                  0,;			//X3_DECIMAL
                  "",;			//X3_VALID
                  "",;			//X3_USADO
                  "C",;			//X3_TIPO
                  "",;			//X3_F3
                  "R",;			//X3_CONTEXT
                  "",;			//X3_CBOX
                  "",;			//X3_RELACAO
                  ""})			//X3_WHEN
 
Return
Static Function Carregar()
    Local aItens := {}
    Local i
    Local cQry := ""
    Local dData := CTOD( "" ) 

If Select("BIN") > 0
     DbSelectArea("BIN")
     BIN->(DbCloseArea())
Endif

cQry := " SELECT c1.c1_item, C1.C1_NUM, C1.C1_PRODUTO, C1.C1_DESCRI, C1.C1_QUANT, C1.C1_QUJE, C1.C1_XNATURE," 
cQry += " (CASE WHEN (select C7.C7_NUM from "+RetSqlName("SC7") +" C7  where c7.d_e_l_e_t_ <> '*' and c7_numsc = c1_num and c7_filial = c1_filial and c7_itemsc = c1_item) IS NULL THEN ' '"
cQry += "       ELSE (select C7.C7_NUM from "+RetSqlName("SC7") +" C7  where c7.d_e_l_e_t_ <> '*' and c7_numsc = c1_num and c7_filial = c1_filial and c7_itemsc = c1_item)"
cQry += "       END) AS C7_NUM,"
cQry += " (CASE WHEN (select C7.C7_DATPRF from "+RetSqlName("SC7") +" C7  where c7.d_e_l_e_t_ <> '*' and c7_numsc = c1_num and c7_filial = c1_filial and c7_itemsc = c1_item) IS NULL THEN ' '"
cQry += "       ELSE (select C7.C7_DATPRF from "+RetSqlName("SC7") +" C7  where c7.d_e_l_e_t_ <> '*' and c7_numsc = c1_num and c7_filial = c1_filial and c7_itemsc = c1_item)"
cQry += "       END) AS C7_DATPRF,"
cQry += "       (select C7.C7_QUJE from "+RetSqlName("SC7") +" C7  where c7.d_e_l_e_t_ <> '*' and c7_numsc = c1_num and c7_filial = c1_filial and c7_itemsc = c1_item) AS C7_QUJE,"
cQry += "       (select C7.C7_QTDACLA from "+RetSqlName("SC7") +" C7  where c7.d_e_l_e_t_ <> '*' and c7_numsc = c1_num and c7_filial = c1_filial and c7_itemsc = c1_item) AS C7_QTDACLA,"
cQry += "       (select C7.C7_RESIDUO from "+RetSqlName("SC7") +" C7  where c7.d_e_l_e_t_ <> '*' and c7_numsc = c1_num and c7_filial = c1_filial and c7_itemsc = c1_item) AS C7_RESIDUO,"
cQry += "       (select C7.C7_CONTRA from "+RetSqlName("SC7") +" C7  where c7.d_e_l_e_t_ <> '*' and c7_numsc = c1_num and c7_filial = c1_filial and c7_itemsc = c1_item) AS C7_CONTRA,"
cQry += "       (select C7.C7_CONAPRO from "+RetSqlName("SC7") +" C7  where c7.d_e_l_e_t_ <> '*' and c7_numsc = c1_num and c7_filial = c1_filial and c7_itemsc = c1_item) AS C7_CONAPRO,"
cQry += "       (select C7.C7_QUANT from "+RetSqlName("SC7") +" C7  where c7.d_e_l_e_t_ <> '*' and c7_numsc = c1_num and c7_filial = c1_filial and c7_itemsc = c1_item) AS C7_QUANT,"
cQry += "       (select C7.C7_ACCPROC from "+RetSqlName("SC7") +" C7  where c7.d_e_l_e_t_ <> '*' and c7_numsc = c1_num and c7_filial = c1_filial and c7_itemsc = c1_item) AS C7_ACCPROC"
cQry += "       FROM "+RetSqlName("SC1") +" C1"
cQry += " WHERE C1.C1_FILIAL = '" + xFilial("SC1") + "'"
cQry += " AND C1.D_E_L_E_T_ = ' '"
cQry += " and c1_num = '" + SC1->C1_NUM + "'"
cQry += " order by c1.c1_item"
TcQuery cQry New Alias "BIN"

BIN->(DbGoTop())

dData := BIN->C7_DATPRF
dData := dtoc(stod(dData))

While !BIN->(Eof())
     aadd(aItens,{BIN->c1_item,BIN->c1_produto,BIN->c7_num,dData})
     BIN->(DbSkip())
Enddo

For i := 1 to len(aItens)
     if(BIN->C7_QUJE<>0.And.BIN->C7_QUJE<BIN->C7_QUANT.AND. Empty(BIN->C7_RESIDUO).AND.Empty(BIN->C7_CONTRA).AND. BIN->C7_CONAPRO<>"B")
          aadd(aColsEx,{oAmarelo,aItens[i,1],aItens[i,2],aItens[i,3],aItens[i,4],.F.})
     Elseif(BIN->C7_QUJE>=BIN->C7_QUANT.AND. Empty(BIN->C7_RESIDUO).AND.Empty(BIN->C7_CONTRA).AND. BIN->C7_CONAPRO<>"B")
         aadd(aColsEx,{oVermelho,aItens[i,1],aItens[i,2],aItens[i,3],aItens[i,4],.F.})
     Elseif(BIN->C7_ACCPROC<>"1" .And.  BIN->C7_CONAPRO=="B".And.BIN->C7_QUJE < BIN->C7_QUANT.AND. Empty(BIN->C7_RESIDUO))
          aadd(aColsEx,{oAzul,aItens[i,1],aItens[i,2],aItens[i,3],aItens[i,4],.F.})
     Elseif(BIN->C7_QUJE==0 .And. BIN->C7_QTDACLA==0.And.Empty(BIN->C7_RESIDUO).AND.Empty(BIN->C7_CONTRA).AND. BIN->C7_CONAPRO<>"B")
         aadd(aColsEx,{oVerde,aItens[i,1],aItens[i,2],aItens[i,3],aItens[i,4],.F.})
     Else 
         aadd(aColsEx,{oCinza,aItens[i,1],aItens[i,2],aItens[i,3],aItens[i,4],.F.})
     Endif
Next
oLista:SetArray(aColsEx,.T.)
oLista:Refresh()
//DbCloseArea("BIN")
 
Return
Static function Legenda()
    Local aLegenda := {}
    AADD(aLegenda,{"BR_AMARELO"     ,"   PC Parcialmente Atendido" })
    AADD(aLegenda,{"BR_AZUL"    	,"   PC Bloqueado" })
    AADD(aLegenda,{"BR_VERDE"    	,"   PC Pendente" })
    AADD(aLegenda,{"BR_VERMELHO" 	,"   PC Atendido" })
    AADD(aLegenda,{"BR_CINZA" 	    ,"   Sem PC" })

 
    BrwLegenda("Legenda", "Legenda", aLegenda)
Return Nil
