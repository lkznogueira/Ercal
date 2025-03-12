#INCLUDE 'Protheus.ch'
#INCLUDE 'TOPConn.ch'
#INCLUDE 'Rwmake.ch'
#include "TbiConn.ch"
#include "TbiCode.ch"
#DEFINE ENTER Chr(13)+Chr(10)

/*���������������������������������������������������������������������������������
�����������������������������������������������������������������������������������
�������������������������������������������������������������������������������Ŀ��
���Programa  |libcontr     �Autor � Carlos Daniel              |Data � 25/05/23 ���
�������������������������������������������������������������������������������Ĵ��
���Descri?ao | Esse programa tem fun��o de liberar contrato de parceria         ���
���			 |                                                  				���
�������������������������������������������������������������������������������Ĵ��
���Retorno   �  Nil                                                             ���
�������������������������������������������������������������������������������Ĵ��
��� Uso      �                                                                  ���
��������������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������������
���������������������������������������������������������������������������������*/

User Function libcontr() 
Private cIdent
MsgRun(("Aguarde..."+Space(1)+"Criando Interface"),"Aguarde...",{|| MontaTel() } )


Return Nil

Static Function SelCor(clStatus)

Local olCor := NIL

Do Case
	// STATUS = PROCESSADA PELO PROTHEUS
	Case clStatus == 'P'
		olCor:=LoadBitmap(GetResources(),'BR_VERMELHO')
	Case clStatus == 'R' //REJEITADO NA RECEITA
		olCor:=LoadBitmap(GetResources(),'BR_PRETO')
		// STATUS = LIBERADO PARA PRE-NOTA
	OtherWise
		olCor:=LoadBitmap(GetResources(),'BR_VERDE')
EndCase
Return olCor

/*���������������������������������������������������������������������������������
�����������������������������������������������������������������������������������
�������������������������������������������������������������������������������Ŀ��
���Fun??o    | MontHdr    �Autor  �Carlos Daniel       |Data  �25/05/23         ���
�������������������������������������������������������������������������������Ĵ��
���Descri??o |Funcao monta o aHeader do browse principal com os itens da ADA    ���
�������������������������������������������������������������������������������Ĵ��
���Retorno   � alHdRet = Array com o nome dos campos selecionados no dicionario ���
�������������������������������������������������������������������������������Ĵ��
��� Uso      � MontaTel	                                                        ���
��������������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������������
���������������������������������������������������������������������������������*/
Static Function MontHdr()//nao usa mais
// monta nomes dos campos dentro da sx3 Ercal
Local alHdRet := {}

aAdd(alHdRet,"ADA_FILIAL")
//aAdd(alHdRet,"ADA_CODCLI")
dbSelectArea("SX3")
DbSetOrder(1)
dbGoTop()
SX3->(DbSeek("ADA"))

While !EOF() .AND. SX3->X3_ARQUIVO == "ADA"
	If ( X3USO(SX3->X3_USADO) .And. cNivel >= SX3->X3_NIVEL )
		Aadd(alHdRet,SX3->X3_CAMPO)
	EndIf
	DbSkip()
EndDo
//aAdd(alHdRet,"ADA_FILIAL")

Return alHdRet

/*���������������������������������������������������������������������������������
�����������������������������������������������������������������������������������
�������������������������������������������������������������������������������Ŀ��
���Fun??o    | CarItens(alHdr,alParam)�Autor|Carlos Daniel    |Data� 25/05/23���
�������������������������������������������������������������������������������Ĵ��
���Descri??o | Funcao verifica os itens a carregar no browse perante os campos  ���
���          | e parametro.							                            ���
���          | Adciona os registro em um array (alRet) que e usado como retorno ���
�������������������������������������������������������������������������������Ĵ��
���Parametros�alHdr   := Array com os campos do browse                          ���
���          |alParam := Array com os possiveis parametros, sendo as posicoes   ���
���          | [1]-{1 , " " } // 1 - Liberado para pre-nota      			    ���
���          | [2]-{2 , "P" } // 2 - Processada pelo Protheus				    ���
�������������������������������������������������������������������������������Ĵ��
���Retorno   � alRet = Array contendo os registros                              ���
�������������������������������������������������������������������������������Ĵ��
��� Uso      � AtuBrw	                                                        ���
��������������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������������
���������������������������������������������������������������������������������*/

Static Function CarItens(_alHdr,alParam)
//tras itens que tem filtro
Local alRet     := {}
Local cQuery	:= ""
Local cLimit    := "100"
If cFilAnt == '4600'
	cLimit    := "0"
EndIf
//aadd(alHdRet, { TMP->ADA_FILIAL, TMP->ADA_NUMCTR, TMP->ADA_CODCLI, TMP->ADA_LOJCLI, TMP->ADA_XNOMC, TMP->CGC, TMP->PENDENCIA, TMP->CREDITO, TMP->ADB_CODPRO, TMP->ADB_QUANT, TMP->ADB_PRCVEN, TMP->ADB_TOTAL, StoD(TMP->ADA_EMISSA), .F.})
cQuery := "select ADA_FILIAL, ADA_NUMCTR, ADA_CODCLI, ADA_LOJCLI, ADA_XNOMC,"
cQuery += " (SELECT E4_DESCRI FROM SE4010 SE4 WHERE se4.d_e_l_e_t_ <> '*' AND ADA_CONDPG = E4_CODIGO) AS CONDPG,"
cQuery += " (SELECT A1_CGC FROM SA1010 SA1 WHERE sa1.d_e_l_e_t_ <> '*' AND A1_COD = ADA_CODCLI AND A1_LOJA = ADA_LOJCLI) AS CGC,"
cQuery += " (SELECT SUM(E1_SALDO) FROM "+ RetSqlName("SE1") + " SE1 WHERE SE1.d_e_l_e_t_ <> '*' AND e1_saldo > 0 AND e1_cliente = ADA_CODCLI AND E1_TIPO NOT IN ('RA','NCC') )PENDENCIA,"
cQuery += " (SELECT SUM(E1_SALDO) FROM "+ RetSqlName("SE1") + " SE1 WHERE SE1.d_e_l_e_t_ <> '*' AND e1_saldo > 0 AND e1_cliente = ADA_CODCLI AND E1_TIPO IN ('RA','NCC') )CREDITO,"
cQuery += " CASE "
cQuery += " WHEN (SELECT E1_XNEG FROM "+ RetSqlName("SE1") + " SE1 WHERE se1.d_e_l_e_t_ <> '*' AND ADA_CODCLI = E1_CLIENTE AND E1_SALDO > 0 and e1_xneg = '1' and rownum = 1 ) = '1' THEN 'SIM'" 
cQuery += " ELSE 'N�O'"
cQuery += " END AS RENEGOCIADO,"
cQuery += " ADB_CODPRO, ADB_QUANT, ADB_PRCVEN, ADB_TOTAL, ADA_EMISSA"
cQuery += " from " + RetSqlName("ADA") + " ADA, "+ RetSqlName("ADB") + " ADB"
cQuery += " where ADA_NUMCTR = ADB_NUMCTR"
cQuery += " AND ADA_FILIAL = ADB_FILIAL"
cQuery += " AND ADB_ITEM = '01'"
cQuery += " AND ADA_FILIAL = '"+xfilial("ADA")+"'"
cQuery += " And ADA_EMISSA >= '20230101' "
cQuery += " And ADA_MSBLQL = '1'"
cQuery += " And ADA_XLIBFI <> '1'"
cQuery += " AND (ADB_QUANT > "+cLimit+" OR (SELECT E1_XNEG FROM "+ RetSqlName("SE1") + " SE1 WHERE se1.d_e_l_e_t_ <> '*' AND ADA_CODCLI = E1_CLIENTE AND E1_SALDO > 0 and e1_xneg = '1' and rownum = 1) = '1')"
cQuery += " and ADA.d_e_l_e_t_ <> '*'"
cQuery += " and ADB.d_e_l_e_t_ <> '*'"

      MemoWrite("C:\TEMP\cQuery.txt",cQuery)

			If select("TMP") <> 0
			   TMP->(DbcloseArea())
			Endif
			dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"TMP",.T.,.T.)

      If TMP->(eof())

        MsgAlert("N�o h� Contratos a serem Aprovados.","Aten��o !!!")
		aadd(alRet, { " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ",.F.})
    
      EndIf

	TMP->(DbGoTop())
      //aNewCols        := {}
	while !TMP->(eof()) 
        aadd(alRet, { TMP->RENEGOCIADO, TMP->ADA_NUMCTR, TMP->ADA_CODCLI, TMP->ADA_LOJCLI, TMP->ADA_XNOMC, TMP->CGC, TMP->ADB_CODPRO, TMP->ADB_QUANT, TMP->ADB_PRCVEN, TMP->ADB_TOTAL, TMP->CONDPG, StoD(TMP->ADA_EMISSA), TMP->ADA_FILIAL, .F.})
        TMP->(dbskip())
    enddo

Return alRet


/*���������������������������������������������������������������������������������
�����������������������������������������������������������������������������������
�������������������������������������������������������������������������������Ŀ��
���Fun??o    | MontaTel   �Autor � Carlos Daniel               |Data � 25/05/23 ���
�������������������������������������������������������������������������������Ĵ��
�������������������������������������������������������������������������������Ĵ��
���Parametros� clRaiz = Diretorio/Local arquivos raiz                           ���
���          | clDest = Diretorio/Local arquivos lidos                          ���
�������������������������������������������������������������������������������Ĵ��
���Retorno   � NIL                                                              ���
��������������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������������
���������������������������������������������������������������������������������*/
Static Function MontaTel()
Local alSize    	:= MsAdvSize()
Local cTCFilterEX	:= "TCFilterEX"
Local alHdCps 		:= {}
Local alHdSize      := {}
Local alCpos        := {}
Local alItBx        := {}
Local alParam       := {}
Local alCpHd        := {"RENEGOCIADO","ADA_NUMCTR","ADA_CODCLI","ADA_LOJCLI","ADA_XNOMC","A1_CGC","ADB_CODPRO","ADB_QUANT","ADB_PRCVEN","ADB_TOTAL","ADA_CONDPG","ADA_EMISSA","ADA_FILIAL"}//MontHdr() // PEGA titulo
Local clLine        := ""
Local clLegenda     := ""
Local nlTl1     	:= alSize[1]//0
Local nlTl2    		:= alSize[2] //30
Local nlTl3    		:= alSize[1]+450
Local nlTl4     	:= alSize[2]+790
Local nlCont        := 0
Local nlPosCFil     := 0
Local nlPosCCtr     := 0
Local nlPosCCli      := 0
Local nlPosCLjc      := 0
Local olLBox    	:= NIL
Local olBtLeg       := NIL
Local olBtPos       := NIL
Private _opDlgPcp	:= NIL
Private opBtVis     := NIL
Private opBtImp     := NIL
Private opBtPed     := NIL
Private opBtEst		:= NIL
Private cIdEnt
Private lChkBoxClass


//�������������������������������������������������������Ŀ
//� Array alParam recebe parametros para filtro           �
//���������������������������������������������������������
aAdd(alParam,{1 , " " }) // 1 - Liberado 
aAdd(alParam,{2 , "P" }) // 2 - Processada pelo Protheus
// tras dados sx3 campo
//�������������������������������������������������������Ŀ
//� Monta o Header com os titulos do TWBrowse             �
//���������������������������������������������������������
dbSelectArea("SX3")
dbSetOrder(2)
For nlCont	:= 1 to Len(alCpHd)
	If MsSeek(alCpHd[nlCont]) .or. alCpHd[nlCont] == "RENEGOCIADO"
		If alCpHd[nlCont] == "RENEGOCIADO" // entrou aqui primeiro RENEGOCIADO
			AADD(alHdCps,"NEG")
			AADD(alHdSize,3)
		Else
			AADD(alHdCps,AllTrim(X3Titulo())) // cai aqui 
			AADD(alHdSize,Iif(nlCont==1,200,CalcFieldSize(SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_PICTURE,X3Titulo())))
		EndIf
		AADD(alCpos,{AllTrim(X3Titulo()),SX3->X3_CAMPO,SX3->X3_TIPO,SX3->X3_CONTEXT,SX3->X3_PICTURE})
	EndIf
	
Next nlCont

//�������������������������������������������������������Ŀ
//� Verifica as posicoes/ordens dos campos no array       �
//���������������������������������������������������������
nlPosCFil := Ascan(alCpos,{|x|Alltrim(X[2])=="ADA_FILIAL"})
nlPosCCtr := Ascan(alCpos,{|x|Alltrim(X[2])=="ADA_NUMCTR"})
nlPosCCli  := Ascan(alCpos,{|x|Alltrim(X[2])=="ADA_CODCLI"})
nlPosCLjc  := Ascan(alCpos,{|x|Alltrim(X[2])=="ADA_LOJCLI"})
//nlPosCHNF := Ascan(alCpos,{|x|Alltrim(X[2])=="ADA_LOJCLI"})


//�������������������������������������������������������������������������Ŀ
//� Colunas da ListBox/TWBrowse                                				�
//���������������������������������������������������������������������������
clLine := "{|| {"
For nlCont:=1 To Len(alCpos) // tem que entrar em cada registro
	clLine += "alItBx[olLBox:nAt,"+AllTrim(Str(nlCont))+"]"+IIf(nlCont<Len(alCpos),",","")
Next nX
clLine += "}}" //verifica se logou em cada registro


// ����������������Ŀ
// | Monta Legenda  |
// ������������������
clLegenda := "BrwLegenda('Nf-e Dispon�veis','Legenda' ,{{'BR_VERDE'    ,'Apto a gerar Pr� nota'}";
+" ,{'BR_VERMELHO' ,'Documento Gerado'}";
+" ,{'BR_PRETO' ,'Cancelado Receita'}";
+" })"

//cIdEnt := GetIdEnt()
//cIdEnt := U_ACOMP006()

nlTl1 := 0.00
nlTl2 := 0.00
nlTl3 := 500
nlTl4 := 1200

DEFINE MSDIALOG _opDlgPcp TITLE "Contratos n�o Liberados" From nlTl1,nlTl2 to nlTl3,nlTl4 PIXEL

// ������������Ŀ
// |  BOTOES    |
// ��������������

// Selec. Pedido
opBtPed := TButton():New(nlTl1+210,alSize[2],"LIBERAR",_opDlgPcp,{|| BlqCtr(	alItBx[olLBox:nAt,nlPosCFil] ,;		// | Filial
alItBx[olLBox:nAt,nlPosCCtr] ,;			// | Contrato
alItBx[olLBox:nAt,nlPosCCli ] ,;			// | Cliente
alItBx[olLBox:nAt,nlPosCLjc])} ;			// | Loja
,050,014,,,,.T.  )

// Atualizar tela
olBtLeg := TButton():New(nlTl1+210,alSize[2]+447,"Atualizar Tela",_opDlgPcp, {|| (olLBox:=AtuBrw(olLBox,alItBx,clLine,alCpos,alParam)) } ,050,014,,,,.T.  )

//Consulta posicao cliente
olBtPos := TButton():New(nlTl1+210,alSize[2]+390,"Consultar",_opDlgPcp,{|| cCons(	alItBx[olLBox:nAt,nlPosCCli ] ,;			// | Cliente
alItBx[olLBox:nAt,nlPosCLjc])} ;			// | Loja
,050,014,,,,.T.  )

// Sair / Fechar
@ (nlTl1+210),(alSize[2]+505) BUTTON "Sair" SIZE 60,14 OF _opDlgPcp PIXEL ACTION Eval({|| DbSelectArea("ADA"), &cTCFilterEX.("",1), _opDlgPcp:END()})

// ��������������������Ŀ
// | TW BROWSE - NOTAS  |
// ����������������������
&cTCFilterEX.("",1)// veio ate aqui Ercal
olLBox := TwBrowse():New(nlTl1+05,nlTl2+05,nlTl3+093,nlTl4-1010,,alHdCps,alHdSize,_opDlgPcp,,,,,{|| Iif(!Empty(olLBox:aArray),Eval(opBtVis:BACTION),) } ,,,,,,,.F.,,.T.,,.F.,,,)
olLBox := AtuBrw(olLBox,alItBx,clLine,alCpos,alParam)
//olLBox:BChange:= Iif(!Empty(olLBox:aArray), {|| AtuBtn(olLBox:aArray[olLBox:nAt,1]) } , {|| olLBox:Refresh()  } )

ACTIVATE DIALOG _opDlgPcp CENTERED //finalizou aqui Ercal

Return NIL

/*���������������������������������������������������������������������������������
�����������������������������������������������������������������������������������
�������������������������������������������������������������������������������Ŀ��
���Fun??o    | AtuBtn     �Autor � Carlos Daniel                 |Data � 25/05/23 ���
�������������������������������������������������������������������������������Ĵ��
���Descri?ao | Atualiza botoes na mudanca de registro. Se o status for          ���
���          | P = Processada Desabilita os botoes de Selecionar Pedido, 		���
���			 | Ver. Schema e Importar.											���
�������������������������������������������������������������������������������Ĵ��
���Parametros� clStatus = Status do registro selecioado                         ���
�������������������������������������������������������������������������������Ĵ��
���Retorno   � NIL                                                              ���
�������������������������������������������������������������������������������Ĵ��
��� Uso      � MontaTel	                                                        ���
��������������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������������
���������������������������������������������������������������������������������*/
Static Function AtuBtn(clStatus)//nao usa

If (clStatus$"P")
	opBtPed:Disable()
	opBtImp:Disable()
Else
	opBtPed:Enable()
	opBtImp:Enable()
EndIf
Return Nil
/*���������������������������������������������������������������������������������
�����������������������������������������������������������������������������������
�������������������������������������������������������������������������������Ŀ��
���Fun??o    | AtuBrw     �Autor � Carlos Daniel                 |Data � 25/05/23 ���
�������������������������������������������������������������������������������Ĵ��
���Descri?ao | Atualiza a tela apos gerar pre nota                              ���
�������������������������������������������������������������������������������Ĵ��
���Parametros� olLBox  = Objeto do TwBrowse (ListBOx)                           ���
���          | alItBx  = Array contendo os itens do ListBox                     ���
���          | clLine  = String do BLoco de Codigo bLine                        ���
���          | alCpos  = Campos exibidos no ListBox                             ���
���          | alParam = Array com informacoes do filtro                        ���
���          |           [ 1 ] - Parametro escolhido                            ���
���          |           [ 2 ] - String para sua representacao Exemplo: "T"     ���
�������������������������������������������������������������������������������Ĵ��
���Retorno   � olLBox = ListBox atualizado                                      ���
�������������������������������������������������������������������������������Ĵ��
��� Uso      � FiltraBrw, MontaTel                                              ���
��������������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������������
���������������������������������������������������������������������������������*/
Static Function AtuBrw(olLBox,alItBx,clLine,alCpos,alParam)
//�������������������������������������������������������Ŀ
//� Carrega o array com as informacoes dos registros      �
//���������������������������������������������������������
alItBx:=CarItens(alCpos, alParam) //chegou aqui busca itens Ercal

olLBox:SetArray(alItBx)
olLBox:bLine := Iif(!Empty(alItBx),&clLine, {|| Array(Len(alCpos))} )
If EmpTy(olLBox:aArray)
	opBtPed:Disable()
	opBtVis:Disable()
	opBtImp:Disable()
EndIf

Return olLBox

/*���������������������������������������������������������������������������������
�����������������������������������������������������������������������������������
�������������������������������������������������������������������������������Ŀ��
���Fun??o    | BlqCtr    �Autor � Carlos Daniel               |Data � 25/05/23 ���
�������������������������������������������������������������������������������Ĵ��
���Descri?ao | Monta tela para selecao do pedido                                ���
�������������������������������������������������������������������������������Ĵ��
���Parametros� clCodFor  = Cod. Fornec./Cli.                                    ���
���          | clLoja    = Loja                                                 ���
���          | clNota    = Num. Nota                                            ���
���          | clSerie   = Serie da Nota                                        ���
�������������������������������������������������������������������������������Ĵ��
���Retorno   � NIL                                                              ���
�������������������������������������������������������������������������������Ĵ��
��� Uso      � MontaTel	                                                        ���
��������������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������������
���������������������������������������������������������������������������������*/
Static Function BlqCtr(cFil,cContr,cCli,cLoja)
Local nOpc := 2

dbSelectArea("ADA")
ADA->(dbSetOrder(1))
ADA->(dbSeek(xFilial("ADA")+cContr))

SA1->(dbSetOrder(1))
SA1->(dbSeek(xFilial("SA1")+cCli+M->cLoja))

nOpc := Aviso("LIBERA CONTRATO", 'Aten��o � o Contrato: '+ cContr + ' e o Cliente :'+ cCli + ;
				' Deseja Liberar este Contrato?', {"Sim","N�o","Cancelar"})
				
if nOpc == 1

	Begin Transaction
		If !Empty(cContr)
			RecLock("ADA")
			ADA->ADA_XLIBFI := "1"
			MsUnLock()
		EndIf
	End Transaction	

EndIf

ADA->(dbCloseArea())
SA1->(dbCloseArea())

Return Nil

//Gatilho Valida se esta bloqueado Financeiro Ercal
User Function GatFin()

Local cStatus := M->ADA_MSBLQL
Local cLiber  := M->ADA_XLIBFI
Local cLimit  := ACOLS[1][5]

If cStatus == "2" .AND. cLimit > 100
	If cLiber == "2" 
		MsgAlert("O Contrato precisa ser desbloqueado pelo setor financeiro")
		cStatus := "1"
	EndIf
EndIf
oGetDad:oBrowse:Refresh()
GetDRefresh()
Return(cStatus)
//cONSULTA POSICAO TITULO
Static Function cCons(cCodCli, cLojCli)
    Local aArea     := FWGetArea()
    Default cCodCli := ""
    Default cLojCli := ""
 
    DbSelectArea("SA1")
    SA1->(DbSetOrder(1)) // A1_FILIAL + A1_COD + A1_LOJA
 
    //Se conseguir posicionar no cliente
    If SA1->(MsSeek(FWxFilial("SA1") + cCodCli + cLojCli))
        Finc010(2)
    EndIf
	FWRestArea(aArea)
Return
