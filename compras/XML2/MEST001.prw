#INCLUDE 'Protheus.ch'
#INCLUDE 'TOPConn.ch'
#INCLUDE 'Rwmake.ch'
#include "TbiConn.ch"
#include "TbiCode.ch"
#DEFINE ENTER Chr(13)+Chr(10)

/*���������������������������������������������������������������������������������
�����������������������������������������������������������������������������������
�������������������������������������������������������������������������������Ŀ��
���Programa  |MEST001     �Autor � Totvs TM                    |Data � 07/08/13 ���
�������������������������������������������������������������������������������Ĵ��
���Descri?ao | Esse arquivo cont�m fun�oes respons�veis pelo funcionamento da   ���
���          | op��o de importa��o de XML de Nota Fiscal Eletronica             ���
���			 |                                                  				���
�������������������������������������������������������������������������������Ĵ��
���Retorno   �  Nil                                                             ���
�������������������������������������������������������������������������������Ĵ��
��� Uso      �                                                                  ���
��������������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������������
���������������������������������������������������������������������������������*/

User Function MEST001() 
Local clPar     := "MTA140I"
Private cIniFile	:= GetADV97()
Private cStartPath 	:= "\xml\IMPORTADOS\"
//Private cStartLido	:= Trim(cStartPath)+"IMPORTADOS\"
Private c2StartPath	:= Trim(cStartPath)+AllTrim(SM0->M0_CGC)+"\"     		//CNPJ
Private c3StartPath	:= Trim(c2StartPath)+AllTrim(Str(Year(Date())))+"\"		//ANO    
Private c5StartPath := Trim(c3StartPath)+AllTrim(Str(Month(Date())))+"\"    //MES
Private cStartError	:= Trim(c5StartPath)+"ERRO\"           					//ERROS
Private cIdent

CHKFILE("SDS")
CHKFILE("SDV")
CHKFILE("SDT")

//U_MEST003()
U_MEST002()    

//CRIA DIRETORIOS
//MakeDir(GetPvProfString(GetEnvServer(),"StartPath","ERROR", cIniFile )+'NFE\')
//MakeDir(Trim(cStartPath)) //CRIA DIRETOTIO ENTRADA
MakeDir(cStartPath) //CRIA DIRETORIO ARQUIVOS IMPORTADOS
MakeDir(c2StartPath) //CRIA DIRETOTIO CNPJ
MakeDir(c3StartPath) //CRIA DIRETOTIO ANO              
//MakeDir(c4StartPath) //CRIA DIRETOTIO DIA 
MakeDir(c5StartPath) //CRIA DIRETOTIO MES  
MakeDir(cStartError) //CRIA DIRETORIO ERRO

If Pergunte(clPar,.T.,"")
	MsgRun(("Aguarde..."+Space(1)+"Criando Interface"),"Aguarde...",{|| MontaBrw() } )
EndIf
//Restaura grupo de perguntas da rotina MATA140.
Pergunte("MTA140",.F.)

Return Nil


/*���������������������������������������������������������������������������������
�����������������������������������������������������������������������������������
�������������������������������������������������������������������������������Ŀ��
���Fun??o    | SelCor     �Autor  �Fabricio Antunes       �Data  �30/01/12      ���
�������������������������������������������������������������������������������Ĵ��
���Descri??o |Funcao retorna objeto com cor do farol                            ���
�������������������������������������������������������������������������������Ĵ��
���Parametros�clStatus = Status do registro (SDT->DT_STATUS)                    ���
�������������������������������������������������������������������������������Ĵ��
���Retorno   �olCor = LoadBitmap(GetResources(),'COR')                          ���
�������������������������������������������������������������������������������Ĵ��
��� Uso      �	MontaBrw                                                        ���
��������������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������������
���������������������������������������������������������������������������������*/
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
���Fun??o    | MontHdr    �Autor  �Fabricio Antunes       |Data  �30/01/12      ���
�������������������������������������������������������������������������������Ĵ��
���Descri??o |Funcao monta o aHeader do browse principal com os itens da SDS    ���
�������������������������������������������������������������������������������Ĵ��
���Retorno   � alHdRet = Array com o nome dos campos selecionados no dicionario ���
�������������������������������������������������������������������������������Ĵ��
��� Uso      � MontaBrw	                                                        ���
��������������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������������
���������������������������������������������������������������������������������*/
Static Function MontHdr()

Local alHdRet := {}

aAdd(alHdRet,"DS_STATUS")
dbSelectArea("SX3")
DbSetOrder(1)
dbGoTop()
SX3->(DbSeek("SDS"))

While !EOF() .AND. SX3->X3_ARQUIVO == "SDS"
	If (SX3->X3_BROWSE=="S") .AND. (cNivel>=SX3->X3_NIVEL) .AND. (!(ALLTRIM(SX3->X3_CAMPO) $ "DS_FILIAL/DS_STATUS"))
		Aadd(alHdRet,SX3->X3_CAMPO)
	EndIf
	DbSkip()
EndDo
aAdd(alHdRet,"DS_CHAVENF")

Return alHdRet

/*���������������������������������������������������������������������������������
�����������������������������������������������������������������������������������
�������������������������������������������������������������������������������Ŀ��
���Fun??o    | CarItens(alHdr,alParam)�Autor|Fabricio Antunes    |Data� 30/01/12���
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

	Local alRet     := {}
	Local cArqInd   := ""
	Local cChaveInd := ""
	Local cQuery	:= ""
	Local nlK       := 0
	Local nIndice	:= 0

	Pergunte("MTA140I",.f.)
	dbSelectArea("SDS")
	dbSetOrder(1)        

	cArqInd   := CriaTrab(, .F.)
	cChaveInd := IndexKey()      

	cQuery += 'DS_FILIAL ="'+xFilial("SDS")+'"  '
	if !Empty(mv_par01) .and. !Empty(mv_par02)         
		cQuery += '.And. DS_DOC >= "'+mv_par01+'" .And. DS_DOC <="'+mv_par02+'" '
	endif     
	if !Empty(mv_par03) .and. !Empty(mv_par04)         
		cQuery += '.And. DS_SERIE >= "'+mv_par03+'" .And. DS_SERIE <="'+mv_par04+'" '
	endif    
	if !Empty(mv_par05) .and. !Empty(mv_par06)         
		cQuery += '.And. DS_FORNEC >= "'+mv_par05+'" .And. DS_FORNEC <="'+mv_par06+'" '
	endif
	if !Empty(mv_par07) .and. !Empty(mv_par08)         
		cQuery += '.And. DTOS(DS_EMISSA) >= "'+dtos(mv_par07)+'" .And. DTOS(DS_EMISSA) <= "'+dtos(mv_par08)+'" '
	endif  
	if !Empty(mv_par09) .and. !Empty(mv_par10)         
		cQuery += '.And. DTOS(DS_DATAIMP) >= "'+dtos(mv_par09)+'" .And. DTOS(DS_DATAIMP) <= "'+dtos(mv_par10)+'" '
	endif            
	if mv_par11 == 2
		cQuery += '.And. DS_USERPRE <= "0" '
	endif

	IndRegua("SDS", cArqInd, cChaveInd, , cQuery, "Criando indice de trabalho" ) //"Criando indice de trabalho"
	nIndice := RetIndex("SDS") + 1
	#IFNDEF TOP
		dbSetIndex(cArqInd + OrdBagExt())
	#ENDIF
	dbSetOrder(nIndice)
	SDS->(MsSeek(xFilial("SDS")))
											   
	While SDS->(!EOF())
		IF SDS->DS_FILIAL = xFilial("SDS")  //Alterado Fabricio para somente trazer os xmls da filial corrente
			AADD(alRet,Array(Len(_alHdr)))
			For nlk:=1 to Len(_alHdr)
				If _alHdr[nlk,4]=="V"
					alRet[Len(alRet),nlk]:=CriaVar(_alHdr[nlk,2])
				Else
					alRet[Len(alRet),nlk]:=FieldGet(FieldPos(_alHdr[nlk,2]))
				EndIf
			Next nlk
		EndIf
		SDS->(dbSKip())
	End

	SDS->(DbClearFil())
	RetIndex("SDS")

Return alRet


/*���������������������������������������������������������������������������������
�����������������������������������������������������������������������������������
�������������������������������������������������������������������������������Ŀ��
���Fun??o    | MontaBrw   �Autor � Fabricio Antunes            |Data � 30/01/12 ���
�������������������������������������������������������������������������������Ĵ��
���Descri?ao | Monta o Browse principal que exibi os schemas importados         ���
�������������������������������������������������������������������������������Ĵ��
���Parametros� clRaiz = Diretorio/Local arquivos raiz                           ���
���          | clDest = Diretorio/Local arquivos lidos                          ���
�������������������������������������������������������������������������������Ĵ��
���Retorno   � NIL                                                              ���
�������������������������������������������������������������������������������Ĵ��
��� Uso      � A140XMLNFe	                                                    ���
��������������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������������
���������������������������������������������������������������������������������*/
Static Function MontaBrw()
Local alSize    	:= MsAdvSize()
Local alHdCps 		:= {}
Local alHdSize      := {}
Local alCpos        := {}
Local alItBx        := {}
Local alParam       := {}
Local alCpHd        := MontHdr()
Local clLine        := ""
Local clLegenda     := ""
Local clFilBrw 		:= ""
Local cTCFilterEX	:= "TCFilterEX"
Local nlTl1     	:= alSize[1]//0
Local nlTl2    		:= alSize[2] //30
Local nlTl3    		:= alSize[1]+450
Local nlTl4     	:= alSize[2]+790
Local nlCont        := 0
Local nlPosCFor     := 0
Local nlPosLoja     := 0
Local nlPosNum      := 0
Local nlPosSer      := 0
Local nlPosCHNF		:= 0
Local olLBox    	:= NIL
Local olBtLeg       := NIL
Local olBtFiltro    := NIL
Local olBtImpM		:= NIL
Local oChkBoxClass
Local oGetChvNfe
Local cGetChvNfe := space( len(SF2->F2_CHVNFE) )
Local oSayChvNFe

Private _opDlgPcp	:= NIL
Private opBtVis     := NIL
Private opBtImp     := NIL
Private opBtPed     := NIL
Private opBtEst		:= NIL
Private cIdEnt
Private cNivelUser	:= GetNewPar("MV_XNVCLAS",1)
Private lChkBoxClass

if cNivelUser <= cNivel
	lChkBoxClass := SuperGetMV("MV_XCLASS",.F.,.T.)
else
	lChkBoxClass := .F.
endif

//�������������������������������������������������������Ŀ
//� Array alParam recebe parametros para filtro           �
//���������������������������������������������������������
aAdd(alParam,{1 , " " }) // 1 - Liberado para pre-nota
aAdd(alParam,{2 , "P" }) // 2 - Processada pelo Protheus

//�������������������������������������������������������Ŀ
//� Monta o Header com os titulos do TWBrowse             �
//���������������������������������������������������������
dbSelectArea("SX3")
dbSetOrder(2)
For nlCont	:= 1 to Len(alCpHd)
	If MsSeek(alCpHd[nlCont])
		If alCpHd[nlCont] == "DS_STATUS"
			AADD(alHdCps," ")
			AADD(alHdSize,1)
		Else
			AADD(alHdCps,AllTrim(X3Titulo()))
			AADD(alHdSize,Iif(nlCont==1,200,CalcFieldSize(SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_PICTURE,X3Titulo())))
		EndIf
		AADD(alCpos,{AllTrim(X3Titulo()),SX3->X3_CAMPO,SX3->X3_TIPO,SX3->X3_CONTEXT,SX3->X3_PICTURE})
	EndIf
	
Next nlCont

//�������������������������������������������������������Ŀ
//� Verifica as posicoes/ordens dos campos no array       �
//���������������������������������������������������������
nlPosCFor := Ascan(alCpos,{|x|Alltrim(X[2])=="DS_FORNEC"})
nlPosLoja := Ascan(alCpos,{|x|Alltrim(X[2])=="DS_LOJA"})
nlPosNum  := Ascan(alCpos,{|x|Alltrim(X[2])=="DS_DOC"})
nlPosSer  := Ascan(alCpos,{|x|Alltrim(X[2])=="DS_SERIE"})
nlPosCHNF := Ascan(alCpos,{|x|Alltrim(X[2])=="DS_CHAVENF"})


//�������������������������������������������������������������������������Ŀ
//� Colunas da ListBox/TWBrowse                                				�
//���������������������������������������������������������������������������
clLine := "{|| {SelCor(alItBx[olLBox:nAt,1]) ,"
For nlCont:=2 To Len(alCpos)
	clLine += "alItBx[olLBox:nAt,"+AllTrim(Str(nlCont))+"]"+IIf(nlCont<Len(alCpos),",","")
Next nX
clLine += "}}"


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

DEFINE MSDIALOG _opDlgPcp TITLE "Nf-e Dispon�veis" From nlTl1,nlTl2 to nlTl3,nlTl4 PIXEL
//DEFINE MSDIALOG _opDlgPcp TITLE "Nf-e Dispon�veis" From 000,000 to nlTl3,nlTl4 PIXEL
// Label Vincular Pedido de Compra / Gerar Pr�-Nota
//@ nlTl1+198,alSize[2]+005 To nlTl1+230,alSize[2] + 175 LABEL " Vincular Pedido de Compra / Gerar Pr�-Nota " OF _opDlgPcp PIXEL
@ nlTl1+198,alSize[2]+005 To nlTl1+230,alSize[2] + 175 LABEL " Vincular Pedido de Compra / Gerar Pr�-Nota " OF _opDlgPcp PIXEL

// Importa��o do XML
@ nlTl1+198,alSize[2]+180 To nlTl1+230,alSize[2] + 460 LABEL " Importa��o do XML " OF _opDlgPcp PIXEL

// ������������Ŀ
// |  BOTOES    |
// ��������������

// Selec. Pedido
opBtPed := TButton():New(nlTl1+210,alSize[2]+010,"Pedido de Compra",_opDlgPcp,{|| SelePed(	alItBx[olLBox:nAt,nlPosCFor] ,;		// | Cod. Fornecedor
alItBx[olLBox:nAt,nlPosLoja] ,;			// | Loja
alItBx[olLBox:nAt,nlPosNum ] ,;			// | Numero Doc.
alItBx[olLBox:nAt,nlPosSer])} ;			// | Serie
,050,014,,,,.T.  )

// Gerar Pre Nota
opBtImp := TButton():New(nlTl1+210,alSize[2]+065,"Gerar Pre Nota",_opDlgPcp,{|| (ExecTela(	3, ;								// | Opcao
alItBx[olLBox:nAt,nlPosCFor],;     		// | Cod. Fornec./Cli.
alItBx[olLBox:nAt,nlPosLoja],;   		// | Loja
alItBx[olLBox:nAt,nlPosNum],;    	   	// | Num. Nota Fiscal
alItBx[olLBox:nAt,nlPosSer]) ,; 		// | Serie
(olLBox:=AtuBrw(olLBox,alItBx,clLine,alCpos,alParam)),;
(olLBox:Refresh()),(olLBox:bGoTop),;
(Iif(!Empty(olLBox:aArray),AtuBtn(olLBox:aArray[olLBox:nAt,1]),)))};
,050,014,,,,.T.  )

// Excluir Pre Nota (Estornar)
opBtEst := TButton():New(nlTl1+210,alSize[2]+120,"Estornar",_opDlgPcp,{|| (ExclDocEntrada(olLBox,alCpos),(olLBox:=AtuBrw(olLBox,alItBx,clLine,alCpos,alParam)),(olLBox:Refresh()),(olLBox:bGoTop),(Iif(!Empty(olLBox:aArray),AtuBtn(olLBox:aArray[olLBox:nAt,1]),)))},050,014,,,,.T.  )

//  Importa XML via SEFAZ
@ (nlTl1+210),alSize[2]+185 BUTTON "DownLoad XML" SIZE 50,14 OF _opDlgPcp PIXEL ACTION DownLoadXML()

// Importa��o manual
olBtImpM := TButton():New(nlTl1+210,alSize[2]+240,"Imp. Manual",_opDlgPcp, {|| ImpManual(),(olLBox:=AtuBrw(olLBox,alItBx,clLine,alCpos,alParam)) } ,050,014,,,,.T.  )

//  Consulta NF-e
@ (nlTl1+210),(alSize[2]+295) BUTTON "Cons.NFE" SIZE 050,14 OF _opDlgPcp PIXEL ACTION (iif(!Empty(olLBox:aArray),ConsNFeChave(alItBx[olLBox:nAt,nlPosCHNF],cIdEnt),))

//  Consulta Amarra��o
@ (nlTl1+210),(alSize[2]+350) BUTTON "Cons.Amar" SIZE 050,14 OF _opDlgPcp PIXEL ACTION MATA061()//MATA370()

// Atualizar tela
olBtLeg := TButton():New(nlTl1+210,alSize[2]+405,"Atualizar Tela",_opDlgPcp, {|| (olLBox:=AtuBrw(olLBox,alItBx,clLine,alCpos,alParam)) } ,050,014,,,,.T.  )

// Visualizar
opBtVis := TButton():New(nlTl1+200,alSize[2]+465,"Visualizar",_opDlgPcp,{|| (ExecTela(	2,; 								// | Opcao
alItBx[olLBox:nAt,nlPosCFor],;			// | Cod. Fornec./Cli.
alItBx[olLBox:nAt,nlPosLoja],;	  		// | Loja
alItBx[olLBox:nAt,nlPosNum],;	   		// | Num. Nota Fiscal
alItBx[olLBox:nAt,nlPosSer])   ) };		// | Serie
,060,014,,,,.T.  )

// Filtro
olBtFiltro := TButton():New(nlTl1+200,alSize[2]+535,"Filtrar",_opDlgPcp, {|| FiltraBrw(olLBox,alItBx,clLine,alCpos,alParam, @clFilBrw) } ,060,014,,,,.T.  )

// Legenda
olBtLeg := TButton():New(nlTl1+218,alSize[2]+465,"Legenda",_opDlgPcp, {|| &clLegenda } ,060,014,,,,.T.  )

// Sair / Fechar
@ (nlTl1+218),(alSize[2]+535) BUTTON "Sair" SIZE 60,14 OF _opDlgPcp PIXEL ACTION Eval({|| DbSelectArea("SDS"), &cTCFilterEX.("",1), _opDlgPcp:END()})

// Auto Classifica��o Pr�-Nota
if cNivelUser <= cNivel
	@ (nlTl1+235), alSize[2]+005 CHECKBOX oChkBoxClass VAR lChkBoxClass PROMPT "Classifica NF-e?" SIZE 050, 015 OF _opDlgPcp COLORS 0, 16777215 MESSAGE "Permite classificar, ap�s gera��o da Pr�-Nota" PIXEL
endif

//Consulta R�pida da Chave / Numero do Documento
@ (nlTl1+235), alSize[2]+180 SAY oSayChvNFe PROMPT "Filtrar pela Chave NF-e:" 	SIZE 070, 007 OF _opDlgPcp COLORS 0, 16777215 PIXEL
@ (nlTl1+233), alSize[2]+240 MSGET oGetChvNfe VAR cGetChvNfe 		SIZE 171, 010 OF _opDlgPcp PICTURE "@X" VALID vChvNfe(@cGetChvNFe,olLBox,alItBx,clLine,alCpos,alParam, @clFilBrw) COLORS 0, 16777215 PIXEL

// ��������������������Ŀ
// | TW BROWSE - NOTAS  |
// ����������������������
&cTCFilterEX.("",1)
olLBox := TwBrowse():New(nlTl1+05,nlTl2+05,nlTl3+093,nlTl4-1010,,alHdCps,alHdSize,_opDlgPcp,,,,,{|| Iif(!Empty(olLBox:aArray),Eval(opBtVis:BACTION),) } ,,,,,,,.F.,,.T.,,.F.,,,)
olLBox := AtuBrw(olLBox,alItBx,clLine,alCpos,alParam)
olLBox:BChange:= Iif(!Empty(olLBox:aArray), {|| AtuBtn(olLBox:aArray[olLBox:nAt,1]) } , {|| olLBox:Refresh()  } )

ACTIVATE DIALOG _opDlgPcp CENTERED

Return NIL

Static Function vChvNfe(cGetChvNFe,olLBox,alItBx,clLine,alCpos,alParam, clFilBrw)
Local cTCFilterEX 	:= "TCFilterEX"
Local aArea			:= GetArea()

do case
	case Empty(cGetChvNFe) .or. Len( AllTrim(cGetChvNFe) ) < 44
		cGetChvNFe := space( len(SF2->F2_CHVNFE) )
		Return .T.
endcase

clFilBrw := " DS_CHAVENF == '" + cGetChvNFe + "' "

DbSelectArea("SDS")
&cTCFilterEX.(clFilBrw,1)

AtuBrw(olLBox,alItBx,clLine,alCpos,alParam)
olLBox:Refresh()

RestArea(aArea)
Return .T.


/*���������������������������������������������������������������������������������
�����������������������������������������������������������������������������������
�������������������������������������������������������������������������������Ŀ��
���Fun??o    | ImpManual  �Autor � Fabricio Antunes 				   |Data � 30/01/12 ���
�������������������������������������������������������������������������������Ĵ��
���Descri?ao | Realiza a importacao manual do arquivo selecionado pelo usuario  ���
���          | utilizando a rotina automatica de importacao da NF-e		        ���
�������������������������������������������������������������������������������Ĵ��
���Retorno   � NIL                                                              ���
�������������������������������������������������������������������������������Ĵ��
��� Uso      � MontaBrw		                                                    ���
��������������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������������
���������������������������������������������������������������������������������*/
Static Function ImpManual()

Local cPathR := cGetFile("*.xml","XML File",1,"C:\",.T.,GETF_LOCALHARD,.T.,.T.)
Local cFile := cPathR

If !Empty(cPathR)
	While At("\",cFile) > 0
		cFile := Substr(cFile,At("\",cFile)+1)
	End
	
	If !":\" $ cPathR //-- Arquivo do servidor
		Copy File &(cPathR) TO &(cStartPath +cFile)
	Else //-- Arquivo do client
		CpyT2S(cPathR,cStartPath)
	EndIf
	
	//-- Chama funcao de import
	MsAguarde({|| U_ReadXML(cFile,.F.)},"Aguarde","Importando dados do arquivo XML...",.F.)
	
EndIf

Return( Nil )


/*���������������������������������������������������������������������������������
�����������������������������������������������������������������������������������
�������������������������������������������������������������������������������Ŀ��
���Fun??o    | FiltraBrw  �Autor �Fabricio Antunes                  |Data � 30/01/12 ���
�������������������������������������������������������������������������������Ĵ��
���Descri?ao | Atualiza botoes na mudanca de registro. Se o status for          ���
���          | P = Processada Desabilita os botoes de Selecionar Pedido, 		���
���			 | Ver. Schema e Importar.											���
�������������������������������������������������������������������������������Ĵ��
���Parametros� clStatus = Status do registro selecioado                         ���
�������������������������������������������������������������������������������Ĵ��
���Retorno   � NIL                                                              ���
�������������������������������������������������������������������������������Ĵ��
��� Uso      � MontaBrw	                                                        ���
��������������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������������
���������������������������������������������������������������������������������*/
Static Function FiltraBrw(olLBox,alItBx,clLine,alCpos,alParam,clFilBrw )
Local cTCFilterEX 	:= "TCFilterEX"
Local aArea			:= GetArea()
clFilBrw := BuildExpr("SDS",,clFilBrw)

DbSelectArea("SDS")
&cTCFilterEX.(clFilBrw,1)

AtuBrw(olLBox,alItBx,clLine,alCpos,alParam)

RestArea(aArea)
Return Nil
/*���������������������������������������������������������������������������������
�����������������������������������������������������������������������������������
�������������������������������������������������������������������������������Ŀ��
���Fun??o    | AtuBtn     �Autor � Fabricio Antunes                 |Data � 30/01/12 ���
�������������������������������������������������������������������������������Ĵ��
���Descri?ao | Atualiza botoes na mudanca de registro. Se o status for          ���
���          | P = Processada Desabilita os botoes de Selecionar Pedido, 		���
���			 | Ver. Schema e Importar.											���
�������������������������������������������������������������������������������Ĵ��
���Parametros� clStatus = Status do registro selecioado                         ���
�������������������������������������������������������������������������������Ĵ��
���Retorno   � NIL                                                              ���
�������������������������������������������������������������������������������Ĵ��
��� Uso      � MontaBrw	                                                        ���
��������������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������������
���������������������������������������������������������������������������������*/
Static Function AtuBtn(clStatus)

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
���Fun??o    | AtuBrw     �Autor � Fabricio Antunes                 |Data � 30/01/12 ���
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
��� Uso      � FiltraBrw, MontaBrw                                              ���
��������������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������������
���������������������������������������������������������������������������������*/
Static Function AtuBrw(olLBox,alItBx,clLine,alCpos,alParam)
//�������������������������������������������������������Ŀ
//� Carrega o array com as informacoes dos registros      �
//���������������������������������������������������������
alItBx:=CarItens(alCpos, alParam)
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
���Fun??o    | SelePed    �Autor � Fabricio Antunes                 |Data � 30/01/12 ���
�������������������������������������������������������������������������������Ĵ��
���Descri?ao | Monta tela para selecao do pedido de compra                      ���
�������������������������������������������������������������������������������Ĵ��
���Parametros� clCodFor  = Cod. Fornec./Cli.                                    ���
���          | clLoja    = Loja                                                 ���
���          | clNota    = Num. Nota                                            ���
���          | clSerie   = Serie da Nota                                        ���
�������������������������������������������������������������������������������Ĵ��
���Retorno   � NIL                                                              ���
�������������������������������������������������������������������������������Ĵ��
��� Uso      � MontaBrw	                                                        ���
��������������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������������
���������������������������������������������������������������������������������*/
Static Function SelePed(clCodFor,clLoja,clNota,clSerie)

Local nlCont        := 0
Local clDescProd    := ""
Local clTipo        := ""
Local alNome        := {}
Local alRetRef      := {}
Local olBtSch       := NIL
Local olBDsfz       := NIL
Local olFont        := TFont ():New(,,-11,.T.,.T.,5,.T.,5,.F.,.F.)
Local alSize    	:= MsAdvSize()
Local nlTl1     	:= alSize[1]
Local nlTl2    		:= alSize[2]
Local nlTl3    		:= alSize[1]+300
Local nlTl4     	:= alSize[2]+520
Local alCabec       := {"DT_ITEM","DT_COD","DT_PRODFOR","B1_DESC"}
Local alHdIt        := {}
Local alTamHd       := {}
Private _opBoxIt    := NIL
Private _opSPeDlg	:= NIL
Private alItens       := {}

dbSelectArea("SX3")
SX3->(dbSetOrder(2))
For nlCont	:= 1 to Len(alCabec)
	If MsSeek(alCabec[nlCont])
		AADD(alHdIt,AllTrim(X3Titulo()))
		AADD(alTamHd,CalcFieldSize(SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_PICTURE,X3Titulo()) )
	EndIf
Next

// ��������������������������������������������������Ŀ
// | POSICIONA PARA BUSCAR NOME DO FORNECEDOR/CLIENTE |
// ����������������������������������������������������
dbSelectArea("SDS")
SDS->(dbSetOrder(1))
SDS->(dbSeek(xFilial("SDS")+clNota+clSerie+clCodFor+clLoja))
If SDS->DS_TIPO == 'N'
	dbSelectArea("SA2")
	dbSetOrder(1)
	aAdd(alNome,{"SA2","A2_NOME","Fornecedor"})
	clTipo:="F"
Else
	Aviso("Aten��o","Tipo de Nota Fiscal n�o permitida",{"Ok"})
	Return
EndIf
&(alNome[1,1])->(dbGoTop())

//DEFINE MSDIALOG _opSPeDlg TITLE "Selecionar Pedido" From 000,000 to nlTl3,nlTl4 PIXEL aqui
DEFINE MSDIALOG _opSPeDlg TITLE "Selecionar Pedido" From nlTl1,nlTl2 to nlTl3,nlTl4 PIXEL
//DEFINE MSDIALOG oObjetoDLG TITLE cTitulo FROM nLinIni,nColIni TO nLinFim,nColFim OF oObjetoRef UNIDADE

// Box
@(nlTl1+10),nlTl2 to (nlTl1+35),(nlTl2+237) PIXEL OF _opSPeDlg
@(nlTl1+14),(nlTl2+005) Say "Nota Fiscal:"+clNota Font olFont Pixel Of _opSPeDlg
@(nlTl1+14),(nlTl2+180) Say "Serie :"+clSerie Font olFont Pixel Of _opSPeDlg
@(nlTl1+23),(nlTl2+005) Say alNome[1,3]+clCodFor+" - "+ Posicione(alNome[1,1],1,(xFilial(alNome[1,1])+clCodFor+clLoja),alNome[1,2])      Font olFont Pixel Of _opSPeDlg

// ������������������Ŀ
// | CARREGA OS ITENS |
// ��������������������
dbSelectArea("SDT")
SDT->(dbSetOrder(2))
If SDT->(dbSeek(xFilial("SDT")+PadR(clCodFor,TamSx3("DT_FORNEC")[1])+PadR(clLoja,TamSx3("DT_LOJA")[1])+PadR(clNota,TamSx3("DT_DOC")[1])+PadR(clSerie,TamSx3("DT_SERIE")[1]) ))
	dbSelectArea("SB1")
	SB1->(dbSetOrder(1))
	While SDT->(!EOF()) .AND. (SDT->DT_FORNEC==clCodFor) .AND. (SDT->DT_LOJA==clLoja) .AND. (SDT->DT_DOC==clNota) .AND. (SDT->DT_SERIE==clSerie)
		clDescProd:= Iif(!Empty(SDT->DT_COD),Posicione("SB1",1,(xFilial("SB1")+PadR(SDT->DT_COD,TamSX3("B1_COD")[1])),"B1_DESC"),SDT->DT_DESCFOR)
		aAdd(alItens,{SDT->DT_ITEM , SDT->DT_COD, SDT->DT_PRODFOR ,clDescProd })
		clDescProd:=""
		SDT->(dbSkip())
	EndDo
EndIf

// ���������������������������Ŀ
// | TW BROWSE - ITENS DA NOTA |
// �����������������������������	 //larg   //alt
_opBoxIt := TwBrowse():New(nlTl1+40,nlTl2,nlTl4-295,nlTl3-217,,alHdIt,alTamHd,_opSPeDlg,,,,,,,,,,,,.F.,,.T.,,.F.,,,)
_opBoxIt:SetArray(alItens)
_opBoxIt:bLine := {|| {alItens[_opBoxIt:nAt,1],alItens[_opBoxIt:nAt,2],alItens[_opBoxIt:nAt,3], alItens[_opBoxIt:nAt,4]} }

// ������������Ŀ
// |  BOTOES    |
// ��������������
olBtSch  := TButton():New(nlTl1+132,nlTl2,"Selecionar Pedidos",_opSPeDlg,{||  MsgRun("Aguarde","Selecionando Registros..." ,{|| ProcPCxNFe(clCodFor,clLoja,clNota,clSerie,alItens,alItens[_opBoxIt:nrowpos,1], SDS->DS_TIPO) })    } ,055,012,,,,.T.  )

// ����������������������������������������������������������������������������������������������������������Ŀ
// | Botao: "Desfazer amarracao do produto" ; Permite ao usuario refazer a amarracao Prod. X Prod. Fornec.    |
// | Caso usuario escolha "SIM" na pergunta de confirmacao, sao executados os 4 passoas descritos abaixo      |
// ������������������������������������������������������������������������������������������������������������
olBDsfz  := TButton():New(nlTl1+132,nlTl2+065,"Desfazer amarra��o do produto",_opSPeDlg, {|| Iif(Aviso("Deseja desfazer a amarra��o?",("Ao clicar em <SIM> "+CRLF+"A amarra��o do pedido ser� exclu�da."),{"Sim","N�o"})==1   											,;  // Condicao
( ( DelSDV((clCodFor+clLoja+clNota+clSerie),alItens[_opBoxIt:nrowpos,2])  						) 	,;  // -----------| - Deleta registros tabela amarracao pedido de compra - SDV
( GPrdxPrdF(clCodFor,clLoja,clNota,clSerie,alItens[_opBoxIt:nrowpos,3],"",SDS->DS_TIPO) 		)	,;  //    Opcao   | - Altera / Limpa campo DT_COD
( alRetRef:=RPrdxPrdF(clCodFor,clLoja,clNota,clSerie,alItens[_opBoxIt:nrowpos,3],,SDS->DS_TIPO) ) 	,;  //     SIM    | - Atualiza SDT com nova amarracao do usuario
( (alItens[_opBoxIt:nrowpos,2]:=alRetRef[1]),(alItens[_opBoxIt:nrowpos,4]:=alRetRef[2]) 		)  ),;  // -----------| - Atualiza browse
(	/* Opcao caso usuario escolha NAO. Nada faz / Nao usado */  									)  )}; 	// Opcao NAO
,095,012,,,,.T.  )

DEFINE SBUTTON FROM nlTl1+134,nlTl2+212 TYPE 1 ACTION(_opSPeDlg:End()) ENABLE Of _opSPeDlg
_opSPeDlg:Activate(,,,.T.,,,)

SDT->(dbCloseArea())
SB1->(dbCloseArea())
&(alNome[1,1])->(dbCloseArea())
Return Nil

/*���������������������������������������������������������������������������������
�����������������������������������������������������������������������������������
�������������������������������������������������������������������������������Ŀ��
���Fun??o    | DelSDV     �Autor � Fabricio Antunes                 |Data � 30/01/12 ���
�������������������������������������������������������������������������������Ĵ��
���Descri?ao | Deleta os registros na tabela de rela��o de pedidos quando o     ���
���          | amarracao do produto e desfeita                                 ���
�������������������������������������������������������������������������������Ĵ��
���Parametros� clChave  = Forn.+Loja+Nota+Serie.                                ���
���          � clProd   = Codigo do produto                                     ���
�������������������������������������������������������������������������������Ĵ��
���Retorno   � NIL                                                              ���
�������������������������������������������������������������������������������Ĵ��
��� Uso      � SelePed                                                          ���
��������������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������������
���������������������������������������������������������������������������������*/
Static Function DelSDV(clChave,clProd)

Local alArea := GetArea()

dbSelectArea("SDV")
SDV->(dbSetOrder(1))
SDV->(dbGoTop())
If SDV->(dbSeek(xFilial("SDV")+clChave))
	While SDV->(!EOF()) .AND. (clChave==(SDV->DV_FORNEC+SDV->DV_LOJA+SDV->DV_DOC+SDV->DV_SERIE))
		If (clProd==SDV->DV_PROD)
			If  RecLock("SDV",.F.)
				SDV->(DbDelete())
				MsUnlock("SDV")
			EndIf
		EndIf
		SDV->(dbSkip())
	EndDo
EndIf
SDV->(dbCloseArea())

RestArea(alArea)

Return Nil



/*���������������������������������������������������������������������������������
�����������������������������������������������������������������������������������
�������������������������������������������������������������������������������Ŀ��
���Fun??o    | RPrdxPrdF  �Autor � Fabricio Antunes                 |Data � 30/01/12 ���
�������������������������������������������������������������������������������Ĵ��
���Descri?ao | Refaz a amarracao de produto X prod. fornecedor                  ���
�������������������������������������������������������������������������������Ĵ��
���Parametros� clCodFor  = Cod. Fornec./Cli.                                    ���
���          | clLoja    = Loja                                                 ���
���          | clNota    = Num. Nota                                            ���
���          | clSerie   = Serie da Nota                                        ���
���          | clProdFor = cod. produto identificacao do fornecedor / cliente   ���
���          | clPar     = NIL                                                  ���
���          | cTipo     = Tipo da nota - Entrada ou devolucao                  ���
�������������������������������������������������������������������������������Ĵ��
���Retorno   � alRet  = [1] - Cod. produto  / [2] - Descricao do produto        ���
�������������������������������������������������������������������������������Ĵ��
��� Uso      � SelePed                                                          ���
��������������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������������
���������������������������������������������������������������������������������*/
Static Function RPrdxPrdF(clCodFor,clLoja,clNota,clSerie,clProdFor,clPar,cTipo)

Local llRetCons := .F.
Local alRet     := {"",""}
Local alArea    := GetArea()

If (llRetCons:=ConPad1(,,,"SB1",,,.F.)) // Consulta Padrao
	alRet[1] := SB1->B1_COD
	alRet[2] := SB1->B1_DESC
	GPrdxPrdF(clCodFor,clLoja,clNota,clSerie,clProdFor,SB1->B1_COD,cTipo)
Else
	alRet[2] := Posicione("SDT",2,(xFilial("SDT")+clCodFor+clLoja+clNota+clSerie+clProdFor),"DT_DESCFOR")
EndIf

RestArea(alArea)

Return alRet

Return alRet

/*���������������������������������������������������������������������������������
�����������������������������������������������������������������������������������
�������������������������������������������������������������������������������Ŀ��
���Fun??o    | ProcPCxNFe �Autor � Fabricio Antunes                 |Data � 30/01/12 ���
�������������������������������������������������������������������������������Ĵ��
���Descri?ao | Funcao procura possiveis pedidos de compra relacionados a NF     ���
�������������������������������������������������������������������������������Ĵ��
���Parametros� clCodFor  = Cod. Fornec./Cli.                                    ���
���          | clLoja    = Loja                                                 ���
���          | clNota    = Num. Nota                                            ���
���          | clSerie   = Serie da Nota                                        ���
���          | alItens   = array contendo os itens da nota fiscal               ���
���          | clItem    = Item selecionado                                     ���
���          | cTipo     = Tipo da nota - Entrada ou devolucao                  ���
�������������������������������������������������������������������������������Ĵ��
���Retorno   � alItens  = array com os itens atualizados                        ���
�������������������������������������������������������������������������������Ĵ��
��� Uso      � SelePed	                                                        ���
��������������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������������
���������������������������������������������������������������������������������*/
Static Function ProcPCxNFe(clCodFor,clLoja,clNota,clSerie,alItens,clItem,cTipo)

Local nlPos   	:= Ascan(alItens,{|x|X[1]==clItem})
Local alItem1 	:= {}
Local llretCons := .F.
Local nlVarVal  := 0.01 // Variacao de valores para busca do pedido
Local clArqSQL  := GetNextAlias()
Local clQuery 	:= ""
Local cCodProdEmp := ""
Local lEmpGrupo  := .F. // Empresa do Grupo .T. = Sim / .F. = N�o

// ��������������������������������������������������������������������������Ŀ
// | VERIFICA SE O FORNECEDOR FAZ PARTE DO CADASTRO DE EMPRESAS NO SIGAMAT    |
// ����������������������������������������������������������������������������
SA2->(DbSetOrder(1))
If SA2->(DbSeek(xFilial("SA2")+clCodFor+clLoja))
	If Len(PesqCGC(SA2->A2_CGC))!=0
		lEmpGrupo := .T.
	EndIf
EndIf

// ��������������������������������������������������������������������������Ŀ
// | CASO NAO TENHA O COD. DO PRODUTO PREENCHIDO, POSSIBILITA QUE O USUARIO   |
// | DEFINA QUAL O PRODUTO CORRESPONDENTE AO COD. PROD. DO FORNECEDOR         |
// ����������������������������������������������������������������������������
dbSelectArea("SDT")
If SDT->(dbSeek(xFilial("SDT")+clCodFor+clLoja+clNota+clSerie))
	While SDT->(!EOF()) .AND. (SDT->DT_FORNEC==clCodFor)
		If AllTrim(SDT->DT_PRODFOR) == AllTrim(alItens[nlPos,3])
			If lEmpGrupo // Se for Empresa do Grupo utiliza proprio codigo XML
				cCodProdEmp := SDT->DT_PRODFOR
			Else
				cCodProdEmp := SDT->DT_COD
			EndIf
			If Empty(cCodProdEmp)
				// ����������������������������������������������������Ŀ
				// | PROCURA RELACIONAMENTO DO PRODUTO NA TABELA SA5/SA7|
				// ������������������������������������������������������
				cCodProdEmp := PrdxForCli(clCodFor, clLoja, SDT->DT_PRODFOR, cTipo)
				If Empty(cCodProdEmp)
					MsgAlert("O produto do fornecedor est� sem amarra��o, favor efeturar a amarra��o!")
					/*If MsgYesNo("O produto da Nota est� sem amarra��o no sistema, c�digo "+Space(1)+AllTrim(SDT->DT_PRODFOR)+"."+CRLF+"Deseja selecionar um produto?"  )
						If (llRetCons:=ConPad1(,,,"SB1",,,.F.))
							cCodProdEmp := SB1->B1_COD
							GPrdxPrdF(clCodFor, clLoja, clNota, clSerie, SDT->DT_PRODFOR, cCodProdEmp, cTipo)
							
							_opBoxIt:aArray[_opBoxIt:nrowpos,2] := cCodProdEmp
							_opBoxIt:aArray[_opBoxIt:nrowpos,4] := SB1->B1_DESC
						EndIf
					EndIf */
				Else
					GPrdxPrdF(clCodFor, clLoja, clNota, clSerie, SDT->DT_PRODFOR, cCodProdEmp, cTipo)
					
					_opBoxIt:aArray[_opBoxIt:nrowpos,2] := cCodProdEmp
					_opBoxIt:aArray[_opBoxIt:nrowpos,4] := SB1->B1_DESC
				EndIf
			EndIf
			
			// �������������������������������������������������������Ŀ
			// | CARREGA ARRAY QUE CONTERA AS INFORMACOES PARA A QUERY |
			// ���������������������������������������������������������
			aAdd(alItem1,SDT->DT_COD)       // COD. PRODUTO
			aAdd(alItem1,SDT->DT_PRODFOR)   // COD. PROD. FORNECEDOR
			aAdd(alItem1,SDT->DT_QUANT)     // QUANT. ITEM NA NF
			aAdd(alItem1,SDT->DT_VUNIT)     // VALOR UNITARIO
			Exit
		EndIf
		SDT->(dbSkip())
	EndDo
EndIf

If !Empty(cCodProdEmp)
	#IFDEF TOP
		
		// ����������������Ŀ
		// |  MONTA QUERY   |
		// ������������������
		// Where / Condicao
		clWhere:=""
		clWhere+=" WHERE C7_FILIAL = '" + xFilial("SC7") + "' "
		If ( TcSrvType()=="AS/400" )
			clWhere+=" AND SC7.@DELETED@  <> '*'
		Else
			clWhere+=" AND SC7.D_E_L_E_T_ <> '*'
		EndIf
		clWhere+=" AND C7_FORNECE = '" + clCodFor + "' "
		clWhere+=" AND C7_LOJA = '" + clLoja + "' "
		//		clWhere+=" AND C7_PRECO BETWEEN '" + AllTrim(Str(alItem1[4]-nlVarVal)) + "' AND '" + AllTrim(Str(alItem1[4]+nlVarVal)) + "' "
		clWhere+=" AND C7_PRODUTO = '" + alItem1[1] + "' "
		clWhere+=" AND C7_QTDACLA < C7_QUANT "
		clWhere+=" AND C7_ENCER = ' '  "
		clWhere+=" AND C7_QUJE < C7_QUANT "
		
		// Query
		clQuery:=""
		clQuery+=" SELECT "
		clQuery+=" ( "
		clQuery+="	 SELECT COUNT(*) "
		clQuery+="	 FROM " + RetSqlName("SC7") + " SC7 "
		clQuery+=clWhere
		clQuery+=" ) "
		clQuery+=" AS CONT "
		clQuery+="  , C7_NUM "
		clQuery+=" 	, C7_ITEM "
		clQuery+=" 	, C7_QUANT "
		clQuery+=" 	, C7_PRECO "
		clQuery+=" 	, C7_TOTAL "
		clQuery+=" 	, C7_QTDACLA "
		clQuery+=" 	, C7_EMISSAO "
		clQuery+=" FROM " + RetSqlName("SC7") + " SC7 "
		clQuery+=clWhere
		dbUseArea(.T., "TOPCONN", TCGenQry(,,clQuery),clArqSQL, .T., .T.)
		
		dbSelectArea(clArqSQL)
		&(clArqSQL)->(dbGoTop())
		
		// ����������������������������������Ŀ
		// |  VERIFICA SE ECONTROU PEDIDOS    |
		// ������������������������������������
		If &(clArqSQL)->(!EOF()) // -> ENCONTROU PEDIDOS
			MarkBrwPC(clArqSQL,alItem1,clCodFor,clLoja,clNota,clSerie)
		Else
			Aviso("Aten��o",("Item n�o encontrado "+STRZero(Val(clItem),TamSX3("DT_ITEM")[1])+" na Nota "+clNota),{"Ok"})
		EndIf
		&(clArqSQL)->(dbCloseArea())
	#ENDIF
EndIf
Return alItens

/*���������������������������������������������������������������������������������
�����������������������������������������������������������������������������������
�������������������������������������������������������������������������������Ŀ��
���Fun??o    | MarkBrwPC  �Autor � Fabricio Antunes                 |Data � 30/01/12 ���
�������������������������������������������������������������������������������Ĵ��
���Descri?ao | Funcao responsavel por criat MsSelect/MarkBrowse para que o      ���
���          | usuario escolha os pedidos de compra referentes aos itens na NF  ���
�������������������������������������������������������������������������������Ĵ��
���Parametros� clArqSQL  = String com o nome da Tabela SQL                      ���
���          | alItem1   = Dados do item da nota fiscal                         ���
���          |          [1] - Cod. Produto                                      ���
���          |          [2] - Cod. Produto FOrnecedor                           ���
���          |          [3] - Quant. do item na Nf                              ���
���          |          [4] - Valor unitario                                    ���
���          | clCodFor  = Cod. Fornec./Cli.                                    ���
���          | clLoja    = Loja                                                 ���
���          | clNota    = Num. Nota                                            ���
���          | clSerie   = Serie da Nota                                        ���
�������������������������������������������������������������������������������Ĵ��
���Retorno   � NIL                                                              ���
�������������������������������������������������������������������������������Ĵ��
��� Uso      � ProcPCxNFe                                                       ���
��������������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������������
���������������������������������������������������������������������������������*/
Static Function MarkBrwPC(clArqSQL,alItem1,clCodFor,clLoja,clNota,clSerie)
Local clQZ4         := 0
Local olFont        := TFont ():New(,,-11,.T.,.T.,5,.T.,5,.F.,.F.)
Local alSize    	:= MsAdvSize()
Local nlTl1     	:= alSize[1]
Local nlTl2    		:= alSize[2]
Local nlTl3    		:= alSize[1]+300
Local nlTl4     	:= alSize[2]+520
Local clPed         := ""
Local clItmPC       := ""
Local alEstru       := {}
Local llInvert      := .F.
Local alCampos      := {}
Local clTabTmp      := ""
Local clTMPMark     := ""
Local clTMPQtd      := 0
Local alTamSDV      := {TAMSX3("DV_FORNEC")[1],TAMSX3("DV_LOJA")[1],TAMSX3("DV_DOC")[1],TAMSX3("DV_SERIE")[1],TAMSX3("DV_PROD")[1],TAMSX3("DV_NUMPED")[1],TAMSX3("DV_ITEMPC")[1]}
Local olSayQtd      := NIL
Local olMsSel01     := NIL
Local clMarca       := GetMark() // Essa vari�vel n�o pode ter outro conteudo
Private opDlgMPed   := NIL

// Foi necessario criar essas variaveis para que fosse possivel usar a funcao padrao do sistema A120Pedido()
Private INCLUI      := .F.
Private ALTERA      := .F.
Private nTipoPed    := 1
Private cCadastro   := "Sele��o dos Pedidos de Compra"
Private l120Auto    := .F.

// ����������������������������������������������������������������Ŀ
// |  VERIFICA SE ALGUMA NOTA JA PREENCHE QUANTIDADE DESSE PRODUTO  |
// ������������������������������������������������������������������
dbselectArea("SDV")
SDV->(dbSetOrder(1))
SDV->(dbGoTop())

// ������������������������������������Ŀ
// |  ESTRUTURA PARA TABELA TEMPORARIA  |
// ��������������������������������������
alEstru := {}
aadd(alEstru,{"MMARK",     "C",  LEn(clMarca),           0                     })
aadd(alEstru,{"PED ",      "C",  TamSx3("C7_NUM")[1],    0                     })
aadd(alEstru,{"ITEM",      "C",  TamSx3("C7_ITEM")[1],   0                     })
aadd(alEstru,{"DDATA",     "D",  8                   ,   0                     })
aadd(alEstru,{"QTDDISP" ,  "N",  TamSx3("C7_QUANT")[1],  TamSx3("C7_QUANT")[2] })
aadd(alEstru,{"QTDREF" ,   "N",  TamSx3("C7_QUANT")[1],  TamSx3("C7_QUANT")[2] })

// ������������������������Ŀ
// |  CAMPOS PARA MSSELECT  |
// ��������������������������
alCampos := {}
aAdd(alCampos,{"MMARK"    , , ""   	       ,""                      	})
aAdd(alCampos,{"PED"      , , "Pedido"      ,PesqPict("SC7","C7_NUM")  	})
aAdd(alCampos,{"ITEM"     , , "Item"      ,PesqPict("SC7","C7_ITEM")   })
aAdd(alCampos,{"DDATA"    , , "Data"      ,                            })
aAdd(alCampos,{"QTDDISP"  , , "Qtd.Disp." ,PesqPict("SC7","C7_QUANT")  })
aAdd(alCampos,{"QTDREF"   , , "Qtd.Infor" ,PesqPict("SC7","C7_QUANT")  })

// Cria e seleciona a tabela tempor�ria
//clTabTmp := CriaTrab(alEstru,.T.)
//dbUseArea(.T.,,clTabTmp,"TMP",.F.,.F.)

If Select("TMP") <> 0
	("TMP")->( DBCloseArea() )
EndIf

oTable := FWTemporaryTable():New("TMP")
oTable:SetFields(alEstru)
oTable:AddIndex("1", {"MMARK","PED","ITEM"} )
oTable:Create()

dbSelectArea("TMP")

// �����������������������������������������������Ŀ
// |  TRANSFERE OS DADOS PARA A TABELA TEMPORARIA  |
// �������������������������������������������������
dbSelectArea(clArqSql)
&(clArqSql+"->(dbGoTop())")
While &(clArqSql+"->(!EOF())")
	clPed 			:= &(clArqSql+"->C7_NUM")
	clItmPc 		:= &(clArqSql+"->C7_ITEM")
	clTMPMark       := ""
	clTMPQtd        := 0
	// �������������������������������������������������������������������Ŀ
	// |  VERIFICA REGISTRO NA TABELA SDV E TRAZ PREENCHIDA CASO ENCONTRE  |
	// ���������������������������������������������������������������������
	dbselectArea("SDV")
	SDV->(dbSetOrder(1))
	SDV->(dbGoTop())
	If SDV->(dbSeek(xFilial("SDV")+PadR(clCodFor,alTamSDV[1])+PadR(clLoja,alTamSDV[2])+PadR(clNota,alTamSDV[3])+PadR(clSerie,alTamSDV[4])+PadR(alItem1[1],alTamSDV[5])+PadR(clPed,alTamSDV[6])+PadR(clItmPc,alTamSDV[7])))
		clTMPMark     := clMarca
		clTMPQtd      := SDV->DV_QUANT
	EndIf
	
	dbselectArea("TMP")
	If RecLock("TMP",.T.)
		TMP->PED     	:= clPed
		TMP->ITEM    	:= clItmPc
		TMP->DDATA  	:= StoD(&(clArqSql+"->C7_EMISSAO"))
		TMP->QTDDISP 	:= (&(clArqSql+"->C7_QUANT") - (&(clArqSql+"->C7_QTDACLA")+ clQZ4))
		TMP->MMARK   	:= clTMPMark
		TMP->QTDREF    	:= clTMPQtd
		TMP->(MsUnLock())
	EndIf
	
	dbSelectArea(clArqSql)
	&(clArqSql)->(dbSkip())
EndDo

TMP->(dbGoTop())

DEFINE MSDIALOG opDlgMPed TITLE "Sele��o dos Pedidos de Compra" From nlTl1,nlTl2 to nlTl3,nlTl4 PIXEL

// ���������������������Ŀ
// |  CABECALHO DA TELA  |
// �����������������������
@(nlTl1+10),nlTl2 to (nlTl1+35),(nlTl2+237) PIXEL OF opDlgMPed
@(nlTl1+14),(nlTl2+005) Say AllTrim(alItem1[2]) + " / " + AllTrim(alItem1[1]) + " - " + Posicione("SB1",1,(xFilial("SB1")+PadR(alItem1[1],TamSX3("B1_COD")[1])),"B1_DESC")   Font olFont Pixel Of opDlgMPed
@(nlTl1+23),(nlTl2+005) Say "Item "   + AllTrim(STR(alItem1[3]))      Font olFont Pixel Of opDlgMPed

olSayQtd := tSay():New((nlTl1+23),(nlTl2+130),{|| "Qtd.Nota Fiscal " + AllTrim(STR(DigQtdeIt(0,alItem1[3],"C")[1])) },opDlgMPed,,olFont,,,,.T.,,,100,20)

// ������������������������Ŀ
// |  MARKBROWSE / MSSELECT |
// ��������������������������
olMsSel01 :=  MsSelect():New('TMP','MMARK',"",alCampos,@llInvert,@clMarca,{(nlTl1+40),(nlTl2),(nlTl3-175),(nlTl4-283)},,opDlgMPed)
olMsSel01:oBrowse:lColDrag    := .T.
olMsSel01:bMark := {|| (MarcaReg(clMarca,alItem1[3]), olMsSel01:oBrowse:Refresh(), opDlgMPed:Refresh(), olSayQtd:cCaption:= "Qtd. Sem Pedido de Compra" + AllTrim(STR(DigQtdeIt(0,alItem1[3],"C")[1])) )  }


// ������������Ŀ
// |  BOTOES    |
// ��������������
obTVisPe := TButton():New(nlTl1+132,nlTl2,"Visualizar Pedido",opDlgMPed,{|| MsgRun("Pedido "+Space(1)+TMP->PED+"Sendo Localizado","Aguarde...", {|| A120Pedido("SC7",PosSC7( TMP->PED ),2) })   } ,055,012,,,,.T.  )
DEFINE SBUTTON FROM nlTl1+134,nlTl2+178 TYPE 1 ACTION(eVal( {|| (MarkBrwOk(clCodFor,clLoja,clNota,clSerie,alItem1[1],alTamSDV) , opDlgMPed:End())  } )) ENABLE Of opDlgMPed
DEFINE SBUTTON FROM nlTl1+134,nlTl2+212 TYPE 2 ACTION(opDlgMPed:End()) ENABLE Of opDlgMPed

ACTIVATE DIALOG opDlgMPed CENTERED

// ������������������������������������Ŀ
// | FECHA E DELETA ARQ. TAB. TEMP.     |
// ��������������������������������������
TMP->(dbCloseArea())
//If File( AllTrim(clTabTmp)+GetDBExtension())
//	Ferase(AllTrim(clTabTmp)+GetDBExtension())
//EndIf

oTable:Delete()

Return Nil


/*���������������������������������������������������������������������������������
�����������������������������������������������������������������������������������
�������������������������������������������������������������������������������Ŀ��
���Fun??o    | MarkBrwOk  �Autor � Fabricio Antunes                 |Data � 30/01/12 ���
�������������������������������������������������������������������������������Ĵ��
���Descri?ao | Executada no botao "OK" do MarkBrowse de selecao de ped. Comp.   ���
���          | deleta e/ou grava os registros na tabelza PED. COMP. X NFE (SDV) ���
�������������������������������������������������������������������������������Ĵ��
���Parametros� clCodFor   = Cod. Fornec./Cli.                                   ���
���          | clLoja     = Loja                                                ���
���          | clNota     = Num. Nota                                           ���
���          | clSerie    = Serie da Nota                                       ���
���          | clCodProd  = Codigo do produto                                   ���
���          | alTamSDV   = Array com os tamanhos dos campos usados no dbSeek   ���
���          |              [1] - Tam. Campo DV_FORNEC                          ���
���          |              [2] - Tam. Campo DV_LOJA                            ���
���          |              [3] - Tam. Campo DV_DOC                             ���
���          |              [4] - Tam. Campo DV_SERIE                           ���
���          |              [5] - Tam. Campo DV_PROD                            ���
���          |              [6] - Tam. Campo DV_NUMPED                          ���
���          |              [7] - Tam. Campo DV_ITEMPC                          ���
�������������������������������������������������������������������������������Ĵ��
���Retorno   � NIL                                                              ���
�������������������������������������������������������������������������������Ĵ��
��� Uso      � MarkBrwPC	                                                    ���
��������������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������������
���������������������������������������������������������������������������������*/
Static Function MarkBrwOk(clCodFor,clLoja,clNota,clSerie,clCodProd,alTamSDV)

Local clNumPed := ""
Local clItemPc := ""

dbSelectArea("SDV")
SDV->(dbSetOrder(1))

TMP->(dbGoTop())
While TMP->(!EOF())//AQUI
	
	SDV->(dbGoTop())
	clNumPed  := PadR(TMP->PED,TamSX3("C7_NUM")[1])
	clItemPC  := PadR(TMP->ITEM,TamSX3("C7_ITEM")[1])
	dbSelectArea("SDV")
	SDV->(dbSetOrder(1))
	
	// �������������������������������Ŀ
	// | EXCLUI O REGISTRO DA TABELA   |
	// ���������������������������������
	If dbSeek(xFilial("SDV")+PadR(clCodFor,alTamSDV[1])+PadR(clLoja,alTamSDV[2])+PadR(clNota,alTamSDV[3])+PadR(clSerie,alTamSDV[4])+PadR(clCodProd,alTamSDV[5])+PadR(clNumPed,alTamSDV[6])+PadR(clItemPC,alTamSDV[7]))
		If RecLock("SDV",.F.)
			SDV->(DbDelete())
			SDV->(MsUnlock())
		EndIf
	EndIf
	
	// ����������������������������������Ŀ
	// | GRAVA NA SDV SE ESTIVER MARCADO  |
	// ������������������������������������
	If !Empty(TMP->MMARK)
		Begin Transaction
		If RecLock("SDV",.T.)
			SDV->DV_FILIAL     	:= xFilial("SDV")
			SDV->DV_DOC        	:= clNota
			SDV->DV_SERIE      	:= clSerie
			SDV->DV_FORNEC      := clCodFor
			SDV->DV_LOJA   	    := clLoja
			SDV->DV_PROD  	    := clCodProd
			SDV->DV_NUMPED     	:= TMP->PED
			SDV->DV_ITEMPC		:= TMP->ITEM
			SDV->DV_QUANT		:= TMP->QTDREF
			dbCommit()
			SDV->(MsUnlock())
		EndIf
		End Transaction
	EndIf
	dbSelectArea("TMP")
	TMP->(dbSkip())
EndDo

SDV->(dbCloseArea())

Return NIL


/*���������������������������������������������������������������������������������
�����������������������������������������������������������������������������������
�������������������������������������������������������������������������������Ŀ��
���Fun??o    | MarcaReg	  �Autor � Fabricio Antunes            |Data � 30/01/12 ���
�������������������������������������������������������������������������������Ĵ��
���Descri?ao | Executada quando o registro e marcado                            ���
�������������������������������������������������������������������������������Ĵ��
���Parametros� clMarca   = String retornada do GETMark()                        ���
���          | nlQtdTot  = Qtd. total / maxima permitida                        ���
�������������������������������������������������������������������������������Ĵ��
���Retorno   � NIL                                                              ���
�������������������������������������������������������������������������������Ĵ��
��� Uso      � MarkBrwPC                                                        ���
��������������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������������
���������������������������������������������������������������������������������*/
Static Function MarcaReg(clMarca,nlQtdTot)

// �������������������������������������������Ŀ
// | PREENCHE COM VALOR DIGITADO PELO USUARIO  |
// ���������������������������������������������
If RecLock("TMP",.F.)
	REPLACE TMP->QTDREF with DigValIt(TMP->QTDREF,TMP->QTDDISP,nlQtdTot)
	MsUnLock()
EndIf

// �������������������������������������������������������Ŀ
// | VERIFICA SE O VALOR E ZERO. SE SIM DESMARCA REGISTRO  |
// ���������������������������������������������������������
If Empty(TMP->QTDREF)
	If RecLock("TMP",.F.)
		REPLACE TMP->MMARK with ""
		MsUnLock()
	EndIF
Else
	If RecLock("TMP",.F.)
		REPLACE TMP->MMARK with clMarca
		MsUnLock()
	EndIF
EndIf

Return Nil

/*���������������������������������������������������������������������������������
�����������������������������������������������������������������������������������
�������������������������������������������������������������������������������Ŀ��
���Fun??o    |DigValIt	  �Autor � Fabricio Antunes            |Data � 30/01/12 ���
�������������������������������������������������������������������������������Ĵ��
���Descri?ao | Funcao cria telinha para que o usuario digite numa get o valor   ���
���          | (unidades) do item da nota fiscal correspondente ao pedido selec.���
�������������������������������������������������������������������������������Ĵ��
���Parametros� nlValGet   = quantidade ja preenchido                            ���
���          | nlValDisp  = quantidade maxima disponivel                        ���
���          | nlQtdTot   = quantidade total                                    ���
�������������������������������������������������������������������������������Ĵ��
���Retorno   � Se variavel llOk == .T., retorna valor digitado 'nlValGet'       ���
���          | senao retorna  nlValAnt = valor anterior                         ���
�������������������������������������������������������������������������������Ĵ��
��� Uso      � MarcaReg		                                                    ���
��������������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������������
���������������������������������������������������������������������������������*/
Static Function DigValIt(nlValGet,nlValDisp,nlQtdTot)

Local nlValAnt  	:= nlValGet
Local alSize   		:= MsAdvSize()
Local llOk     		:= .F.
Local olGetVal  	:= Nil
Private _opdlgGet 	:= Nil

DEFINE MSDIALOG _opdlgGet TITLE "Quantidade" From alSize[1],alSize[2] to (alSize[1]+080),(alSize[2]+195) PIXEL

olGetVal :=TGet():New((alSize[1]+10),(alSize[2]+15),{|u| if(PCount()>0,nlValGet:=u,nlValGet)}, _opdlgGet ,50,10,PesqPict("SC7","C7_QUANT") , {|| ValorNFxPC(nlValGet, nlValDisp, nlQtdTot ) },,,,,,.T.,,,,,,,.F.,,,"nlValGet")
DEFINE SBUTTON FROM (alSize[1]+28),(alSize[2]+57) TYPE 1 ACTION(eVal( {|| ( (llOk:=.T.),_opdlgGet:End())  } )) ENABLE Of _opdlgGet

ACTIVATE DIALOG _opdlgGet CENTERED

Return ( Iif(llOk,nlValGet,nlValAnt) )

/*�����������������������������������������������������������������������������������
�������������������������������������������������������������������������������������
���������������������������������������������������������������������������������Ŀ��
���Fun??o    |ValorNFxPC    �Autor � Fabricio Antunes                 |Data � 30/01/12 ���
���������������������������������������������������������������������������������Ĵ��
���Descri?ao | Valida o valor informado do item da nota fiscal correspondente     ���
���          | ao pedido selecionado. 											  ���
���������������������������������������������������������������������������������Ĵ��
���Parametros� nlValGet   = quantidade ja preenchido                              ���
���          | nlValDisp  = quantidade maxima disponivel                          ���
���          | nlQtdTot   = quantidade total                                      ���
���������������������������������������������������������������������������������Ĵ��
���Retorno   � L�gico	 														  ���
���������������������������������������������������������������������������������Ĵ��
��� Uso      � DigValIt		                                                      ���
����������������������������������������������������������������������������������ٱ�
�������������������������������������������������������������������������������������
�����������������������������������������������������������������������������������*/
Static Function ValorNFxPC(nlValGet, nlValDisp, nlQtdTot )
Local lRet := .F.

If (nlValGet<=nlValDisp) .AND. (DigQtdeIt(nlValGet,nlQtdTot,"V")[2] ) .And. Positivo(nlValGet)
	lRet := .T.
Else
	Aviso("Aten��o","O valor informado do Itema da nota" + CHR(13)+CHR(10) + "n�o corresponde ao pedido selecionado" ,{"Ok"})
	lRet := .F.
EndIf

Return lRet
/*���������������������������������������������������������������������������������
�����������������������������������������������������������������������������������
�������������������������������������������������������������������������������Ŀ��
���Fun??o    | DigQtdeIt  �Autor � Fabricio Antunes                 |Data � 30/01/12 ���
�������������������������������������������������������������������������������Ĵ��
���Descri?ao | Funcao cria telinha para que o usuario digite numa get o valor   ���
���          | (unidades) do item da nota fiscal correspondente ao pedido selec.���
�������������������������������������������������������������������������������Ĵ��
���Parametros� nlValGet   = quantidade ja preenchido                            ���
���          | nlQtdTot   = quantidade total                                    ���
���          | clFin      = Finalidade da funcao. Podendo receber "C" ou "V"    ���
���          | Se recebe "V" (verificar), valida se ainda � possivel selecionar ���
���          | valores referente ao item da nota. Valida o maximo.              ���
���          | Se "C" apenas calcula a quant. ja informada ( alRet[1] )         ���
�������������������������������������������������������������������������������Ĵ��
���Retorno   � alRet = array 2 posicoes                                         ���
���          |         [1] - soma dos valores jah preenchidos para o iten       ���
���          |         [2] - booleana - Se .F., nao possivel mais indicar valor ���
�������������������������������������������������������������������������������Ĵ��
��� Uso      � MarkBrwPC, ValorNFxPC                                            ���
��������������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������������
���������������������������������������������������������������������������������*/
Static Function DigQtdeIt(nlValGet,nlQtdTot,clFin)

Local alRet 	:= {0,.T.}
Local nlReg 	:= TMP->(Recno())

TMP->(dbGoTop())
While  TMP->(!EOF())
	If (clFin=="V")
		If (TMP->(Recno()) <> nlReg)
			alRet[1]+=TMP->QTDREF
		EndIf
	Else
		alRet[1]+=TMP->QTDREF
	EndIf
	TMP->(dbSkip())
EndDo
TMP->(dbGoTop())

TMP->(dbGoTo(nlReg))
If (clFin=="V")
	If ((alRet[1]+nlValGet) > nlQtdTot)
		alRet[2] := !alRet[2]
	EndIf
Else
	alRet[1] := (nlQtdTot-alRet[1])
EndIf
Return alRet

/*���������������������������������������������������������������������������������
�����������������������������������������������������������������������������������
�������������������������������������������������������������������������������Ŀ��
���Fun??o    |  PosSC7    �Autor � Fabricio Antunes                 |Data � 30/01/12 ���
�������������������������������������������������������������������������������Ĵ��
���Descri?ao | Funcao para posicionar a Tabela SC7 no pedido escolhido          ���
���          | retorna o recno que sera passado como parametro na funcao padrao ���
���          | do sistema A120Pedido()                                          ���
�������������������������������������������������������������������������������Ĵ��
���Parametros� clPed = Numero do pedido de compra                               ���
�������������������������������������������������������������������������������Ĵ��
���Retorno   � nlRet = SC7->(Recno())                                           ���
�������������������������������������������������������������������������������Ĵ��
��� Uso      � MarkBrwPC	                                                    ���
��������������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������������
���������������������������������������������������������������������������������*/
Static Function PosSC7(clPed)

Local nlRet := 0

dbSelectArea("SC7")
dbSetOrder(1)
SC7->(dbGoTop())
If dbSeek(xFilial("SC7")+PadR(clPed,TamSx3("C7_NUM")[1]) )
	nlRet := SC7->(Recno())
EndIf
Return nlRet


/*���������������������������������������������������������������������������������
�����������������������������������������������������������������������������������
�������������������������������������������������������������������������������Ŀ��
���Fun??o    | ExecTela   �Autor � Fabricio Antunes            |Data � 30/01/12 ���
�������������������������������������������������������������������������������Ĵ��
���Descri?ao | Funcao que monta aCols, aHeader para tela e executa rotina aut.  ���
�������������������������������������������������������������������������������Ĵ��
���Parametros� nlOpc     := Opcao escolhida (2-Visu / 3-Gerar)                  ���
���          | clCodFor  := Cod. Fornecedor/Cliente                             ���
���          | clLoja    := Loja                                                ���
���          | clNota    := Num. Nota                                           ���
���          | clSerie   := Serie                                               ���
���          | olLBox    := Objeto                                              ���
�������������������������������������������������������������������������������Ĵ��
���Retorno   � Nil                                                              ���
�������������������������������������������������������������������������������Ĵ��
��� Uso      � MontaBrw	                                                        ���
��������������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������������
���������������������������������������������������������������������������������*/
Static Function ExecTela(nlOpc,clCodFor,clLoja,clNota,clSerie,olLBox)

Local nlUsado       := 0
Local alDTVirt      := {}
Local alDTVisu      := {}
Local alRecDT       := {}
Local alSF1         := {}
Local alSD1         := {}
Local alSize        := MsAdvSize(.T.)
Local clKey         := ""
Local clTab1	    := "SDS"
Local clTab2	    := "SDT"
Local clAwysT       := "AllwaysTrue()"
Local alCpoEnch     := {}
Local alHeaderDT    := {}
Local llPedCom      := .F.
Local llD1Imp       := .F.
Private lMsErroAuto := .F.
Private aCols 	    := {}
Private aHeader     := GdMontaHeader(	@nlUsado     	 ,; //01 -> Por Referencia contera o numero de campos em Uso
@alDTVirt                ,; //02 -> Por Referencia contera os Campos do Cabecalho da GetDados que sao Virtuais
@alDTVisu                ,; //03 -> Por Referencia contera os Campos do Cabecalho da GetDados que sao Visuais
clTab2                   ,; //04 -> Opcional, Alias do Arquivo Para Montagem do aHeader
{"DT_FILIAL"} 			 ,; //05 -> Opcional, Campos que nao Deverao constar no aHeader
.F.                      ,; //06 -> Opcional, Carregar Todos os Campos
.F.                      ,; //07 -> Nao Carrega os Campos Virtuais
.F.                      ,; //08 -> Carregar Coluna Fantasma e/ou BitMap ( Logico ou Array )
NIL                      ,; //09 -> Inverte a Condicao de aNotFields carregando apenas os campos ai definidos
.T.                      ,; //10 -> Verifica se Deve Checar se o campo eh usado
.T.                      ,;
.F.                      ,;
.F.                      ,;
)

//���������������������������������������������������������Ŀ
//� POSICIONA A TABELA SDS / CARREGA VARIAVEIS DE MEMORIA   �
//�����������������������������������������������������������
dbSelectArea(clTab1)
dbSetOrder(1)
&(clTab1+"->(dbGoTop())")
dbSeek(xFilial(clTab1)+clNota+clSerie+clCodFor+clLoja)
RegToMemory("SDS",.F.)


//�������������������������������Ŀ
//� CAMPOS USADOS PARA ENCHOICE   �
//���������������������������������
dbSelectArea("SX3")
SX3->(dbSetOrder(1))
SX3->(dbGoTop())
SX3->(dbSeek("SDS"))
alCpoEnch:={}
Do While !Eof().And.(SX3->X3_ARQUIVO=="SDS")
	V_CPO:=ALLTRIM(X3_CAMPO)
	If X3USO(SX3->X3_USADO).And.cNivel>=SX3->X3_NIVEL
		Aadd(alCpoEnch,V_CPO)
	Endif
	DbSkip()
End Do

//���������������Ŀ
//� MONTA ACOLS   �
//�����������������
dbSelectArea("SDT")
SDT->(dbSetOrder(1))
SDT->(dbGoTop())
alRecDT := {}
alHeaderDT:=aClone(aHeader)
clKey := xFilial("SDS")+M->DS_CNPJ+clCodFor+clLoja+clNota+clSerie
aCols := GdMontaCols(	@alHeaderDT		,; 	//01 -> Array com os Campos do Cabecalho da GetDados
@nlUsado		,;	//02 -> Numero de Campos em Uso
@alDTVirt		,;	//03 -> [@]Array com os Campos Virtuais
@alDTVisu   	,;	//04 -> [@]Array com os Campos Visuais
clTab2			,;	//05 -> Opcional, Alias do Arquivo Carga dos Itens do aCols
NIL				,;	//06 -> Opcional, Campos que nao Deverao constar no aHeader
@alRecDT		,;	//07 -> [@]Array unidimensional contendo os Recnos
clTab1			,;	//08 -> Alias do Arquivo Pai
clKey  			,;	//09 -> Chave para o Posicionamento no Alias Filho
NIL				,;	//10 -> Bloco para condicao de Loop While
NIL				,;	//11 -> Bloco para Skip no Loop While
.F.				,;	//12 -> Se Havera o Elemento de Delecao no aCols
.F.				,;	//13 -> Se cria variaveis Publicas
.T.				,;	//14 -> Se Sera considerado o Inicializador Padrao
NIL				,;	//15 -> Lado para o inicializador padrao
NIL				,;	//16 -> Opcional, Carregar Todos os Campos
.F.				,;	//17 -> Opcional, Nao Carregar os Campos Virtuais
NIL				,;	//18 -> Opcional, Utilizacao de Query para Selecao de Dados
NIL				,;	//19 -> Opcional, Se deve Executar bKey  ( Apenas Quando TOP )
NIL				,;	//20 -> Opcional, Se deve Executar bSkip ( Apenas Quando TOP )
.F.				,;	//21 -> Carregar Coluna Fantasma
NIL				,;	//22 -> Inverte a Condicao de aNotFields carregando apenas os campos ai definidos
.T.				,;	//23 -> Verifica se Deve Checar se o campo eh usado
.T.				,;	//24 -> Verifica se Deve Checar o nivel do usuario
NIL				,;	//25 -> Verifica se Deve Carregar o Elemento Vazio no aCols
NIL				,;	//26 -> [@]Array que contera as chaves conforme recnos
NIL				,;	//27 -> [@]Se devera efetuar o Lock dos Registros
NIL				,;	//28 -> [@]Se devera obter a Exclusividade nas chaves dos registros
NIL				,;	//29 -> Numero maximo de Locks a ser efetuado
.F.				,;	//30 -> Utiliza Numeracao na GhostCol
NIL				,;	//31
2		    	 ;	//32 -> nOpc
)

//�����������������������Ŀ
//� MONTA TELA MODELO 3   �
//�������������������������
If Mod3XML(	nlOpc,;                  								  		// 01 -> Opcao
	"Nf-e Dispon�veis",;                  								  		// 02 -> Titulo da Tela
	clTab1,;                  								  		// 03 -> Tabela para Enchoice
	clTab2,;               									 		// 04 -> Tabela para GetDados
	alCpoEnch,;                 							  		// 05 -> Campos Enchoice
	clAwysT,;                 								  		// 06 -> CampoOk
	clAwysT,;                  								 		// 07 -> LinhaOk
	nlOpc,;                 										// 08 -> Opcao Enchoice
	nlOpc,;                  										// 09 -> Opcao GetDados
	clAwysT,;                  										// 10 -> TdOk
	.T.,;                  											// 11 -> Se carrega Campos Virtuais
	alCpoEnch,;                  									// 12 -> Campos alterar
	GetRodape(clCodFor,clLoja,clNota,clSerie,clTab1) )  ;   		// 13 -> Array com as informacoes do Radape
	.AND. VldCpoProd(clCodFor,clLoja,clNota,clSerie,SDS->DS_TIPO)
	
	//�������������������Ŀ
	//� GERA A PRE-NOTA   �
	//���������������������
	Begin Transaction
	//����������������������������������������������������������Ŀ
	//� ALIMENTA VETORES PARA A ROTINA AUTOMATICA (MSExecAuto)   �
	//������������������������������������������������������������
	alSF1:=F1Imp(clCodFor,clLoja,clNota,clSerie,clTab1)
	MsgRun("Aguarde...",,{|| iif(!Empty(alSD1:=D1Imp(clCodFor,clLoja,clNota,clSerie,clTab2)),llD1Imp:=.T.,llD1Imp:=.F.  ) } )
	MsgRun("Aguarde...",,{|| llPedCom := VldQtdPC(alSD1) } )  
	If llD1Imp .AND. llPedCom
		lMsErroAuto := .F.
		MsgRun("Aguarde gerando Pr�-Nota de Entrada...",,{|| MSExecAuto({|x,y,z| MATA140(x,y,z)},alSF1,alSD1,3 )})
		
		If !lMsErroAuto
			//����������������������������������������������������Ŀ
			//� APOS EXECUTADA A ROTINA AUTOMATICA                 �
			//� ATUALIZA REGISTRO ( STATUS, DATA IMPORTACAO ...)   �
			//������������������������������������������������������
			dbSelectArea(clTab1)
			dbSetOrder(1)
			&(clTab1)->(dbGoTop())
			If dbSeek(xFilial(clTab1)+clNota+clSerie+clCodFor+clLoja)
				If RecLock(clTab1,.F.)
					Replace DS_USERPRE  With cUserName
					Replace DS_DATAPRE  With dDataBase
					Replace DS_HORAPRE  With Time()
					Replace DS_STATUS   With 'P' // P = PROCESSADA PELO PROTHEUS
					&(clTab1)->(MsUnLock())
					Aviso("Aten��o", "Pr�-Nota gerada com Sucesso!" ,{"Ok"})
				EndIf
			EndIf
		Else
			DisarmTransaction()
			lMsErroAuto := .F.
			MostraErro()
		EndIf
	EndIf
	End Transaction
EndIf
Return Nil

/*���������������������������������������������������������������������������������
�����������������������������������������������������������������������������������
�������������������������������������������������������������������������������Ŀ��
���Fun??o    | VldQtdPC   �Autor � Fabricio Antunes            |Data � 30/01/12 ���
�������������������������������������������������������������������������������Ĵ��
���Descri?ao | Essa funcao executada quando gera pre nota. Se retornar True     ���
���          | gera a rotina automatica.                                        ���
���          | Funcao verifica se a quant. do pedido de compra escolhido condiz ���
���          | com a quant. disponivel do pedido de compra (SC7) atualizado     ���
�������������������������������������������������������������������������������Ĵ��
���Parametros� alItns := Array com os itens (D1) para rotina automatica         ���
�������������������������������������������������������������������������������Ĵ��
���Retorno   � llRet = Se .T. = OK                                              ���
�������������������������������������������������������������������������������Ĵ��
��� Uso      � ExecTela                                                         ���
��������������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������������
���������������������������������������������������������������������������������*/
Static Function VldQtdPC(alItns)

Local llRet     := .T.
Local nlK       := 0
Local llErro    := .F.
Local nlPedPos  := 0
Local nlItnPos  := 0
Local nlQtdPos  := 0
Local nlForPos  := 0
Local nlLojPos  := 0
Local nlNotPos  := 0
Local nlSerPos  := 0
Local nlCodPos  := 0

//����������������������������������������������������������������������������������������������Ŀ
//� LACO PERCORRE O ARRAY DOS ITENS E FAZ VERIFICACAO SE O ITEM TIVER PED. DE COMPRA PREENCHIDO  �
//������������������������������������������������������������������������������������������������
For nlK:=1 to Len(alItns)
	If ((nlPedPos:=Ascan(alItns[nlK],{|x|X[1]=="D1_PEDIDO"}))>0) .AND. ((nlItnPos:=Ascan(alItns[nlK],{|x|X[1]=="D1_ITEMPC"}))>0)
		//�������������������������������������������Ŀ
		//� VERIFICA AS POSICOES DOS CAMPOS NO ARRAY  �
		//���������������������������������������������
		nlQtdPos := Ascan(alItns[nlK],{|x|X[1]=="D1_QUANT"})
		nlForPos := Ascan(alItns[nlK],{|x|X[1]=="D1_FORNECE"})
		nlLojPos := Ascan(alItns[nlK],{|x|X[1]=="D1_LOJA"})
		nlNotPos := Ascan(alItns[nlK],{|x|X[1]=="D1_DOC"})
		nlSerPos := Ascan(alItns[nlK],{|x|X[1]=="D1_SERIE"})
		nlCodPos := Ascan(alItns[nlK],{|x|X[1]=="D1_COD"})
		//�������������������������������������������������������������������������������Ŀ
		//� VERIFICA SE NA TABELA DE PED. DE COMPRAS EXISTE REALMENTE A QUANT. DISPONIVEL �
		//� SE FOR TIVER DIFERENCA PARA MAIS, EXCLUI DA SDV                               �
		//���������������������������������������������������������������������������������
		dbSelectArea("SC7")
		dbSetOrder(1)
		SC7->(dbGoTop())
		If SC7->(dbSeek(xFilial("SC7")+PadR(alItns[nlK,nlPedPos,2],TamSx3("C7_NUM")[1])+ PadR(alItns[nlK,nlItnPos,2],TamSx3("C7_ITEM")[1])))
			If (alItns[nlK,nlQtdPos,2] > (SC7->C7_QUANT-SC7->C7_QTDACLA) )
				dbSelectArea("SDV")
				dbSetOrder(1)
				SDV->(dbGoTop()) // dbSeek - > Fornecedor+Loja+Nota Num.+Serie+Cod. Produto+Num. Pedido+Item PC
				If SDV->(dbSeek(xFilial("SDV")+alItns[nlK,nlForPos,2]+alItns[nlK,nlLojPos,2]+alItns[nlK,nlNotPos,2]+alItns[nlK,nlSerPos,2]+alItns[nlK,nlCodPos,2]+alItns[nlK,nlPedPos,2]+alItns[nlK,nlItnPos,2] ))
					If RecLock("SDV",.F.)
						SDV->(DbDelete())
						SDV->(MsUnlock())
					EndIf
					llErro:=.T.
				EndIf
			EndIf
		EndIf
	EndIf
Next nlK
//�������������������������Ŀ
//� EXIBE MENSAGEM DE ERRO  �
//���������������������������
If llErro
	Aviso("Aten��o","Erro ao importar a Pr�-Nota",{"Ok"})
	llRet:=.F.
EndIf

Return llRet


/*���������������������������������������������������������������������������������
�����������������������������������������������������������������������������������
�������������������������������������������������������������������������������Ŀ��
���Fun??o    | VldCpoProd �Autor � Fabricio Antunes                 |Data � 30/01/12 ���
�������������������������������������������������������������������������������Ĵ��
���Descri?ao | Verifica se o campo Produto esta preenchido. Caso nao esteja exec���
���          | funcao para que o usuario escolha qual produto se corresponde    ���
�������������������������������������������������������������������������������Ĵ��
���Parametros� clCodFor  := Cod. Fornecedor/Cliente                             ���
���          | clLoja    := Loja                                                ���
���          | clNota    := Num. Nota                                           ���
���          | clSerie   := Serie                                               ���
���          | clTipo    := N = Nota fiscal Normal / B ou D = Benef./Devolucao  ���
�������������������������������������������������������������������������������Ĵ��
���Retorno   � llRet = Se .T. = OK                                              ���
�������������������������������������������������������������������������������Ĵ��
��� Uso      � ExecTela                                                         ���
��������������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������������
���������������������������������������������������������������������������������*/
Static Function VldCpoProd(clCodFor,clLoja,clNota,clSerie, clTipo)

Local llRet     := .T.
Local nlK       := 0
Local nlPosCmp  := Ascan(aHeader,{|x|Alltrim(X[2])=="DT_COD"})

For nlK:=1 to Len(aCols)
	If Empty(aCols[nlK,nlPosCmp])
		llRet:=EscolhaPrd(clCodFor,clLoja,clNota,clSerie,clTipo,nlK,nlPosCmp)
		Exit
	EndIf
Next nlK

Return llRet


/*���������������������������������������������������������������������������������
�����������������������������������������������������������������������������������
�������������������������������������������������������������������������������Ŀ��
���Fun??o    | EscolhaPrd �Autor � Fabricio Antunes                 |Data � 30/01/12 ���
�������������������������������������������������������������������������������Ĵ��
���Descri?ao | Monta a tela com os produtos sem cod. para que usuario escolha   ���
�������������������������������������������������������������������������������Ĵ��
���Parametros� clCodFor  := Cod. Fornecedor/Cliente                             ���
���          | clLoja    := Loja                                                ���
���          | clNota    := Num. Nota                                           ���
���          | clSerie   := Serie                                               ���
���          | clTipo    := N = Nota fiscal Normal / B ou D = Benef./Devolucao  ���
���          | nlK       := Primeira posicao do acols encontrada sem Cod. Prod. ���
���          | nlPosCmp  := Posicao no aHeader do campo "DT_COD"                ���
�������������������������������������������������������������������������������Ĵ��
���Retorno   � llProcPrd = Se .T. = OK                                          ���
�������������������������������������������������������������������������������Ĵ��
��� Uso      � VldCpoProd                                                       ���
��������������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������������
���������������������������������������������������������������������������������*/
Static Function EscolhaPrd(clCodFor,clLoja,clNota,clSerie, clTipo, nlK, nlPosCmp)

Local llProcPrd     :=.F.
Local alSize    	:= MsAdvSize()
Local nlTl1     	:= alSize[1]
Local nlTl2    		:= alSize[2]
Local nlTl3    		:= alSize[1]+300
Local nlTl4     	:= alSize[2]+680
Local olFont        := TFont ():New(,,-11,.T.,.T.,5,.T.,5,.F.,.F.)
Local llRetCons     := .F.
Local alHeaderTw    := {("Cod Produto"+Iif(AllTrim(clTipo)=="N"," Fornecdor"," Cliente" )),"Desc Fornec","Produto","Descri��o"}
Local alTamHeader   := {60,100,60,100}
Local alRegs        := {}
Local olLisBox      := NIL
Local olBtInf       := NIL
Local alAlias       := Iif(AllTrim(clTipo)=="N",{"SA2","A2_NOME"},{"SA1","A1_NOME"})
Local nlCodPos      := Ascan(aHeader,{|x|Alltrim(X[2])=="DT_PRODFOR"})
Local nlDesPos		:= Ascan(aHeader,{|x|Alltrim(X[2])=="DT_DESCFOR"})
Local nlCont        := 0
Private _opPPrDlg  	:= NIL

// ����������������������Ŀ
// | SELECIONA REGISTROS  |
// ������������������������
For nlCont:=nlK to Len(aCols)
	If Empty(aCols[nlCont,nlPosCmp])
		aAdd(alRegs,{(aCols[nlCont,nlCodPos]),"","",nlCont,(aCols[nlCont,nlDesPos])})
	EndIf
Next nlCont

// ��������������������Ŀ
// | TELA - INTERFACE   |
// ����������������������

DEFINE MSDIALOG _opPPrDlg TITLE "Sele��o Produtos" From nlTl1,nlTl2 to nlTl3,nlTl4 PIXEL

// Box
@(nlTl1+10),nlTl2 to (nlTl1+35),(nlTl2+237) PIXEL OF _opPPrDlg
@(nlTl1+14),(nlTl2+005) Say "Fornecedor: " + clCodFor + " - " + Posicione(alAlias[1],1,(xFilial(alAlias[1])+clCodFor+clLoja),alAlias[2])   Font olFont Pixel Of _opPPrDlg
@(nlTl1+23),(nlTl2+005) Say "Itens sem C�digo Relacionado" Font olFont Pixel Of _opPPrDlg

// ���������������������������Ŀ
// | TW BROWSE - ITENS DA NOTA |
// �����������������������������	     //larg       //alt
olLisBox := TwBrowse():New(nlTl1+40,nlTl2,nlTl4-295,nlTl3-217,,alHeaderTw,alTamHeader,_opPPrDlg,,,,,,,,,,,,.F.,,.T.,,.F.,,,)
olLisBox:SetArray(alRegs)
olLisBox:bLine := {|| {alRegs[olLisBox:nAt,1],alRegs[olLisBox:nAt,5],alRegs[olLisBox:nAt,2],alRegs[olLisBox:nAt,3]} }

// ������������Ŀ
// |  BOTOES    |
// ��������������
olBtInf  := TButton():New(nlTl1+132,nlTl2,"Produto" ,_opPPrDlg,{|| (llRetCons:=ConPad1(,,,"SB1",,,.F.)),(Iif(llRetCons, ((alRegs[olLisBox:nAt,2]:=SB1->B1_COD),(alRegs[olLisBox:nAt,3]:=SB1->B1_DESC)) ,  ) )    } ,065,012,,,,.T.  )
DEFINE SBUTTON FROM nlTl1+134,nlTl2+178 TYPE 1 ACTION (eVal( {|| llProcPrd:=PrcPrdOK(alRegs),  Iif((llProcPrd==.T.),(AtuSDT(alRegs,nlPosCmp,clCodFor,clLoja,clNota,clSerie, clTipo),_opPPrDlg:End()),Aviso("Aten��o" ,"Produto n�o encontrado" ,{"Ok" }))   } )) ENABLE Of _opPPrDlg
DEFINE SBUTTON FROM nlTl1+134,nlTl2+212 TYPE 2 ACTION (eVal( {|| Iif(MsgyESnO("Deseja sair?"),_opPPrDlg:End(),) } )) ENABLE Of _opPPrDlg

ACTIVATE DIALOG _opPPrDlg CENTERED

Return llProcPrd


/*���������������������������������������������������������������������������������
�����������������������������������������������������������������������������������
�������������������������������������������������������������������������������Ŀ��
���Fun??o    |AtuSDT	  �Autor � Fabricio Antunes                 |Data � 30/01/12 ���
�������������������������������������������������������������������������������Ĵ��
���Descri?ao | Funcao atualiza aCols e tabela SDT pela escolha do usuario       ���
�������������������������������������������������������������������������������Ĵ��
���Parametros� alRegs    := Array com os registros                              ���
���          | nlPosCmp  := Posicao no aHeader do Campo DT_COD                  ���
���          | clCodFor  := Cod. Fornecedor/Cliente                             ���
���          | clLoja    := Loja                                                ���
���          | clNota    := Num. Nota                                           ���
���          | clSerie   := Serie                                               ���
�������������������������������������������������������������������������������Ĵ��
���Retorno   � Nil                                                              ���
�������������������������������������������������������������������������������Ĵ��
��� Uso      � EscolhaPrd                                                       ���
��������������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������������
���������������������������������������������������������������������������������*/
Static Function AtuSDT(alRegs,nlPosCmp,clCodForCli,clLoja,clNota,clSerie, clTipo)

Local nlK         := 0
Local nlPosDes 	  := Ascan(aHeader,{|x|Alltrim(X[2])=="DT_DESC"})
Local cProdForCli := ""
Local aArea		  := GetArea()

For nlK:=1 to Len(alRegs)
	// ��������������������Ŀ
	// | ATUALIZA ACOLS     |
	// ����������������������
	aCols[alRegs[nlK,Len(alRegs[nlK])-1],nlPosCmp] := alRegs[nlK,2]
	aCols[alRegs[nlK,Len(alRegs[nlK])-1],nlPosDes] := alRegs[nlK,3]
	
	cProdForCli := PadR(AllTrim(alRegs[nlK,1]),TamSx3("DT_PRODFOR")[1])
	cProdEmp	:= PadR(AllTrim(alRegs[nlK,2]),TamSX3("B1_COD")[1]		)
	
	// ����������������������������������������������������������Ŀ
	// | ATUALIZA RELACIONAMENTO PRODUTO X FORNECEDOR E TABELA SDT|
	// ������������������������������������������������������������
	GPrdxPrdF(clCodForCli, clLoja, clNota, clSerie, cProdForCli, cProdEmp, clTipo,aCols[nlK][1])
Next nlK     
RestArea(aArea)
Return Nil

/*���������������������������������������������������������������������������������
�����������������������������������������������������������������������������������
�������������������������������������������������������������������������������Ŀ��
���Fun??o    | PrcPrdOK   �Autor � Fabricio Antunes                 |Data � 30/01/12 ���
�������������������������������������������������������������������������������Ĵ��
���Descri?ao | Validacao do botao OK na tela de selecao de prod. correspondente ���
�������������������������������������������������������������������������������Ĵ��
���Parametros� alRegs     := Array com os itens                                 ���
�������������������������������������������������������������������������������Ĵ��
���Retorno   � Nil                                                              ���
�������������������������������������������������������������������������������Ĵ��
��� Uso      � EscolhaPrd                                                       ���
��������������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������������
���������������������������������������������������������������������������������*/
Static Function PrcPrdOK(alRegs)

Local llPrcPrdOk := .T.
Local nlT        := 0

For nlT:=1 to Len(alRegs)
	If Empty(alRegs[nlT,2])
		llPrcPrdOk := !llPrcPrdOk
		Exit
	EndIf
Next nlT
Return llPrcPrdOk


/*���������������������������������������������������������������������������������
�����������������������������������������������������������������������������������
�������������������������������������������������������������������������������Ŀ��
���Fun??o    |  GetRodape �Autor � Fabricio Antunes                 |Data � 30/01/12 ���
�������������������������������������������������������������������������������Ĵ��
���Descri?ao | Funcao que busca as inforamcoes do rodape da tela mod. 3         ���
�������������������������������������������������������������������������������Ĵ��
���Parametros� clCodFor  := Cod. Fornecedor/Cliente                             ���
���          | clLoja    := Loja                                                ���
���          | clNota    := Num. Nota                                           ���
���          | clSerie   := Serie                                               ���
���          | clTab1    := Tabela SDS                                          ���
�������������������������������������������������������������������������������Ĵ��
���Retorno   � Array alNFe				                                        ���
�������������������������������������������������������������������������������Ĵ��
��� Uso      � ExecTela	                                                        ���
��������������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������������
���������������������������������������������������������������������������������*/
Static Function GetRodape(clCodFor,clLoja,clNota,clSerie,clTab1)

Local alNFe 	:= {}

dbSelectArea(clTab1)
dbSetOrder(1)
&(clTab1)->(dbGoTop())
If dbSeek(xFilial(clTab1)+clNota+clSerie+clCodFor+clLoja)
	aAdd(alNFe, &(clTab1+"->DS_STATUS"  ))
	aAdd(alNFe, &(clTab1+"->DS_ARQUIVO" ))
	aAdd(alNFe, &(clTab1+"->DS_USERIMP" ))
	aAdd(alNFe, &(clTab1+"->DS_DATAIMP" ))
	aAdd(alNFe, &(clTab1+"->DS_HORAIMP" ))
EndIf


Return alNFe



/*���������������������������������������������������������������������������������
�����������������������������������������������������������������������������������
�������������������������������������������������������������������������������Ŀ��
���Fun??o    |  Mod3XML   �Autor � Fabricio Antunes                 |Data � 30/01/12 ���
�������������������������������������������������������������������������������Ĵ��
���Descri?ao | Rotina principal para importar Schema XML                        ���
�������������������������������������������������������������������������������Ĵ��
���Parametros� nlOpc       := Opcao do Uusario (2-Visualizar/3-Gerar Pre Nota)  ���
���          | clTitle     := Titulo da Tela                                    ���
���          | clTab1      := Alias da Enchoice                                 ���
���          | clTab2      := Alias da GetDados                                 ���
���          | alCpoEnch   := Cmpos da Enchoice                                 ���
���          | clAwysT     := cLinhaOk                                          ���
���          | clAwysT     := cTudoOk                                           ���
���          | nlOpc1      := Opcao Enchoice                                    ���
���          | nlOpc2      := Opcao GetDados                                    ���
���          | clAwysT     := cFieldOk                                          ���
���          | llVirtual   := llVirtual (Campos Virtuais)                       ���
���          | alCpoEnch   := Campos Alteracao enchoice                         ���
���          | alInfRod    := Array com as informacoes do radpe 			    ���
�������������������������������������������������������������������������������Ĵ��
���Retorno   � llRet                                                            ���
�������������������������������������������������������������������������������Ĵ��
��� Uso      � ExecTela	                                                        ���
��������������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������������
���������������������������������������������������������������������������������*/
Static Function Mod3XML(nlOpc,clTitle,clTab1,clTab2,alCpoEnch,clAwysT,clAwysT,nlOpc1,nlOpc2,clAwysT,llVirtual,alAltEnch,alInfRod)

Local alAdvSz    := MsAdvSize()
Local alRNfe     := alInfRod
Local olFld      := NIL
Local llRet 	 := .F.
Local olFont     := TFont ():New(,,-11,.T.,.F.,5,.T.,5,.F.,.F.)
Local olFont2    := TFont ():New(,,-11,.T.,.T.,5,.T.,5,.F.,.F.)
Local clPicture  := "@E 999,999,999.99"
Local olEnch     := NIL
Local olGetDd    := NIL
Local olGetStats := NIL
Local olGetArq   := NIL
Local olGetUser  := NIL
Local olGetData  := NIL
Local olGetHora  := NIL
Local clGStatus  := "  " //Iif( Empty(Upper(alRNfe[1])),"???","???")
Local clGNomArq  := alRNfe[2]
Local clGUser    := alRNfe[3]
Local dlGData    := alRNfe[4]
Local clGHora    := alRNfe[5]
Local nPosDesc	 := 0
Local nPosProd	 := 0
Local cDescProd	 := ""
Local nLoop
Local nLoops
Private aTrocaF3  := {}
Private _opMoD3lg := NIL

DEFINE MSDIALOG _opMoD3lg TITLE clTitle From alAdvSz[1],alAdvSz[2] to (alAdvSz[1]+450),(alAdvSz[2]+690) PIXEL

olFld      := TFolder():New((alAdvSz[1]+151),(alAdvSz[2]-6),{"Arquivos XML carregados"},{},_opMoD3lg,,,,.T.,.F., 334 , 068  )

// AJUSTA TELA PARA TEMA P10
If (Alltrim(GetTheme()) == "TEMAP10") .Or. SetMdiChild()
	_opMoD3lg:nHeight+=025
EndIf


// Muda Consulta padrao do cmapo DS_FORNEC para tabela de Clientes - SA1
IF AllTrim(SDS->DS_TIPO)<>"N"
	Aadd(aTrocaF3,{"DS_FORNEC", "SA1"} )
EndIf

// ���������������������������������������������������������Ŀ
// � Monta enchoice e getDados 			  				  �
// �����������������������������������������������������������
RegToMemory(clTab1,.F.)
olEnch := Msmget():New(clTab1,&(clTab1)->(Recno()),2,,,,alCpoEnch,{15,5,80,340},,3,,,,_opMoD3lg,,.T.,,,,,,,,.T.)

If !(Type("aHeader") == "U") .AND. !(Type("aCols") == "U") .AND. ((nPosDesc := GDFieldPos("DT_DESC", aHeader))>0) .AND. ((nPosProd := GDFieldPos("DT_COD", aHeader))>0)
	
	nLoops := Len( aCols  )
	For nLoop := 1 To nLoops
		cDescProd := Posicione("SB1",1,xFilial("SB1")+aCols[nLoop][nPosProd],"B1_DESC")
		GdFieldPut( "DT_DESC" , cDescProd , nLoop , aHeader , aCols )
	Next nLoop
	
EndIf

olGetDd := MsGetDados():New(84,5,150,340,2,clAwysT,clAwysT,"",.T.,,,,,clAwysT)

// ����������������������Ŀ
// � Monta Rodape         �
// ������������������������

// ---- NOTA FISCAL ELETRONICA
// Status
@(alAdvSz[1]+010),(alAdvSz[2]+08) Say "Status" Font olFont Pixel Of olFld:aDialogs[1]
olGetStats := TGet():New((alAdvSz[1]+08),(alAdvSz[2]+045),{|u| if(PCount()>0,clGStatus:=u,clGStatus)}, olFld:aDialogs[1] ,110,10,"@!",,,,,,,.T.,,,,,,,.T.,,,"clGStatus")
// Arquivo
@(alAdvSz[1]+025),(alAdvSz[2]+08) Say "Arquivo" Font olFont Pixel Of olFld:aDialogs[1]
olGetArq := TGet():New((alAdvSz[1]+23),(alAdvSz[2]+045),{|u| if(PCount()>0,clGNomArq:=u,clGNomArq)}, olFld:aDialogs[1] ,110,10,"@!",,,,,,,.T.,,,,,,,.T.,,,"clGNomArq")
// Usuario Import
@(alAdvSz[1]+010),(alAdvSz[2]+170) Say "Usuario Import" Font olFont Pixel Of olFld:aDialogs[1]
olGetUser := TGet():New((alAdvSz[1]+08),(alAdvSz[2]+240),{|u| if(PCount()>0,clGUser:=u,clGUser)}, olFld:aDialogs[1] ,70,10,,,,,,,,.T.,,,,,,,.T.,,,"clGUser")
// Data Import
@(alAdvSz[1]+025),(alAdvSz[2]+170) Say "Data Import" Font olFont Pixel Of olFld:aDialogs[1]
olGetData := TGet():New((alAdvSz[1]+23),(alAdvSz[2]+240),{|u| if(PCount()>0,dlGData:=u,dlGData)}, olFld:aDialogs[1] ,50,10,,,,,,,,.T.,,,,,,,.T.,,,"dlGData")
// Hora Import
@(alAdvSz[1]+040),(alAdvSz[2]+170) Say "Hora Import" Font olFont Pixel Of olFld:aDialogs[1]
olGetHora := TGet():New((alAdvSz[1]+38),(alAdvSz[2]+240),{|u| if(PCount()>0,clGHora:=u,clGHora)}, olFld:aDialogs[1] ,40,10,,,,,,,,.T.,,,,,,,.T.,,,"clGHora")

ACTIVATE DIALOG _opMoD3lg ON INIT(EnchoiceBar(_opMoD3lg,  {|| (Iif((nlOpc==3),llRet:=.T.,),_opMoD3lg:End()) } , {|| _opMoD3lg:End()},  ,  )) CENTERED

Return llRet

/*���������������������������������������������������������������������������������
�����������������������������������������������������������������������������������
�������������������������������������������������������������������������������Ŀ��
���Fun??o    |  D1Imp     �Autor � Fabricio Antunes                 |Data � 30/01/12 ���
�������������������������������������������������������������������������������Ĵ��
���Descri?ao | Carrega Array com os itens da nota fiscal para rotina automatica ���
�������������������������������������������������������������������������������Ĵ��
���Parametros� clCodFor = Cod. Fornecedor                                       ���
���          | clLoja   = Loja                                                  ���
���          | clNota   = Num. NOta                                             ���
���          | clSerie  = Serie                                                 ���
���          | clTab    = Tabela de itens - SDT                                 ���
�������������������������������������������������������������������������������Ĵ��
���Retorno   � alRet = array com os dados para execucao da rotina automatica    ���
�������������������������������������������������������������������������������Ĵ��
��� Uso      � ExecTela	                                                        ���
��������������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������������
���������������������������������������������������������������������������������*/
Static Function D1Imp(clCodFor,clLoja,clNota,clSerie,clTab)

Local alItens	 := {}
Local alRet      := {}
Local nlQtd      := 0
Local nlCont	 := 0
Local alBaseImp  := {}
Local alAliqImp  := {}

Local alTamSDV   := {TAMSX3("DV_FORNEC")[1],TAMSX3("DV_LOJA")[1],TAMSX3("DV_DOC")[1],TAMSX3("DV_SERIE")[1],TAMSX3("DV_PROD")[1],TAMSX3("DV_NUMPED")[1],TAMSX3("DV_ITEMPC")[1]}
Local nlPosProd  := Ascan(aHeader,{|x|Alltrim(X[2])=="DT_PRODFOR"})

For nlCont:=1 to Len(aCols)
	dbSelectarea(clTab)
	dbSetOrder(2)
	&(clTab)->(dbGoTop())
	alBaseImp := {}
	alAliqImp := {}
	If dbSeek(xFilial(clTab)+clCodFor+clLoja+clNota+clSerie+aCols[nlCont,nlPosProd])
		nlQtd := SDT->DT_QUANT
		
		
		dbSelectArea("SDV")
		SDV->(dbSetOrder(1))
		SDV->(dbGoTop())
		If dbSeek(xFilial("SDV")+PadR(clCodFor,alTamSDV[1])+PadR(clLoja,alTamSDV[2])+PadR(clNota,alTamSDV[3])+PadR(clSerie,alTamSDV[4])+PadR(SDT->DT_COD,alTamSDV[5]))
			While SDV->(!EOF()) .AND. (SDV->DV_PROD==SDT->DT_COD) .AND. (SDV->DV_FORNEC==SDT->DT_FORNEC) .AND. (SDV->DV_LOJA==SDT->DT_LOJA) .AND. (SDV->DV_DOC==SDT->DT_DOC) .AND. (SDV->DV_SERIE==SDT->DT_SERIE)
				alItens:={}
				aAdd(alItens,{"D1_FILIAL"   , SDT->DT_FILIAL          ,NIL})  // INF. PED.
				aAdd(alItens,{"D1_DOC"      , SDT->DT_DOC             ,NIL})
				aAdd(alItens,{"D1_SERIE"    , SDT->DT_SERIE           ,NIL})
				aAdd(alItens,{"D1_FORNECE"  , SDT->DT_FORNEC          ,NIL})
				aAdd(alItens,{"D1_LOJA"     , SDT->DT_LOJA            ,NIL})
				aAdd(alItens,{"D1_ITEM"     , StrZero(Len(alRet)+1,4) ,NIL})
				aAdd(alItens,{"D1_COD"      , SDT->DT_COD             ,NIL})				
				aAdd(alItens,{"D1_XDESCRI"  , Posicione("SB1",1,xFilial("SB1")+SDT->DT_COD,"B1_DESC"),NIL})
				aAdd(alItens,{"D1_XPOSPI"   , Posicione("SB1",1,xFilial("SB1")+SDT->DT_COD,"B1_POSIPI"),NIL})  
				aAdd(alItens,{"D1_UM"       , Posicione("SB1",1,xFilial("SB1")+SDT->DT_COD,"B1_UM"),NIL})
				aAdd(alItens,{"D1_LOCAL"    , Posicione("SB1",1,xFilial("SB1")+SDT->DT_COD,"B1_LOCPAD"),NIL}) 
				aAdd(alItens,{"D1_QUANT"    , SDV->DV_QUANT           ,NIL})
				aAdd(alItens,{"D1_VUNIT"    , SDT->DT_VUNIT           ,NIL})
				aAdd(alItens,{"D1_TOTAL"    , (SDT->DT_VUNIT*SDV->DV_QUANT )        ,NIL})
				aAdd(alItens,{"D1_DESC"  	, SDT->DT_VALDESC      	  ,NIL})//DESCONTO ITEM 
		   		aAdd(alItens,{"D1_IPI"  	, SDT->DT_IPI       	  ,NIL})//IPI 
		   		aAdd(alItens,{"D1_VALICM"  	, SDT->DT_VALICM      	  ,NIL})//VLR ICM
		   		aAdd(alItens,{"D1_PICM"  	, SDT->DT_PICM      	  ,NIL})//ICM
		   		aAdd(alItens,{"D1_SEGURO"  	, SDT->DT_SEGURO      	  ,NIL})//SEGURO
		   		aAdd(alItens,{"D1_VALFRE"  	, SDT->DT_VALFRE      	  ,NIL})//VLR FRETE
				aAdd(alRet,alItens)
				nlQtd := (nlQtd - SDV->DV_QUANT)
				SDV->(dbSkip())
			EndDo
		EndIf
		
		If nlQtd > 0
			alItens:={}
			aAdd(alItens,{"D1_FILIAL"   , SDT->DT_FILIAL          ,NIL})  // INF. PED.
			aAdd(alItens,{"D1_DOC"      , SDT->DT_DOC             ,NIL})
			aAdd(alItens,{"D1_SERIE"    , SDT->DT_SERIE           ,NIL})
			aAdd(alItens,{"D1_FORNECE"  , SDT->DT_FORNEC          ,NIL})
			aAdd(alItens,{"D1_LOJA"     , SDT->DT_LOJA            ,NIL})
			aAdd(alItens,{"D1_ITEM"     , StrZero(Len(alRet)+1,4) ,NIL})
			aAdd(alItens,{"D1_COD"      , SDT->DT_COD             ,NIL})
			aAdd(alItens,{"D1_XDESCRI"  , Posicione("SB1",1,xFilial("SB1")+SDT->DT_COD,"B1_DESC"),NIL})
			aAdd(alItens,{"D1_XPOSPI"   , Posicione("SB1",1,xFilial("SB1")+SDT->DT_COD,"B1_POSIPI"),NIL})  
			aAdd(alItens,{"D1_UM"       , Posicione("SB1",1,xFilial("SB1")+SDT->DT_COD,"B1_UM"),NIL})
			aAdd(alItens,{"D1_LOCAL"    , Posicione("SB1",1,xFilial("SB1")+SDT->DT_COD,"B1_LOCPAD"),NIL})			
			aAdd(alItens,{"D1_QUANT"    , nlQtd                   ,NIL})
			aAdd(alItens,{"D1_VUNIT"    , SDT->DT_VUNIT           ,NIL})
			aAdd(alItens,{"D1_TOTAL"    , (SDT->DT_VUNIT*nlQtd)   ,NIL})   
			aAdd(alItens,{"D1_DESC"  	, SDT->DT_VALDESC      	  ,NIL})//DESCONTO ITEM 
			aAdd(alItens,{"D1_IPI"  	, SDT->DT_IPI       	  ,NIL})//IPI 
			aAdd(alItens,{"D1_VALICM"  	, SDT->DT_VALICM      	  ,NIL})//VLR ICM
			aAdd(alItens,{"D1_PICM"  	, SDT->DT_PICM      	  ,NIL})//ICM
			aAdd(alRet,alItens)
		EndIf
	EndIf
Next nlCont

Return alRet

/*���������������������������������������������������������������������������������
�����������������������������������������������������������������������������������
�������������������������������������������������������������������������������Ŀ��
���Fun??o    | F1Imp   	  �Autor � Fabricio Antunes                 |Data � 30/01/12 ���
�������������������������������������������������������������������������������Ĵ��
���Descri?ao | Carrega Array com o cabecalho da nota fiscal para rotina automat.���
�������������������������������������������������������������������������������Ĵ��
���Parametros� clCodFor = Cod. Fornecedor                                       ���
���          | clLoja   = Loja                                                  ���
���          | clNota   = Num. NOta                                             ���
���          | clSerie  = Serie                                                 ���
���          | clTab    = Tabela de cabecalho - SDS                             ���
�������������������������������������������������������������������������������Ĵ��
���Retorno   � alCabec = array com os dados para execucao da rotina automatica  ���
�������������������������������������������������������������������������������Ĵ��
��� Uso      � ExecTela	                                                        ���
��������������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������������
���������������������������������������������������������������������������������*/
Static Function F1Imp(clCodFor,clLoja,clNota,clSerie,clTab)

Local alCabec:={}

dbSelectArea(clTab)
dbSetOrder(1)
&(clTab)->(dbGoTop())
If dbSeek(xFilial(clTab)+clNota+clSerie+clCodFor+clLoja)
	aAdd(alCabec,{"F1_FILIAL"      ,SDS->DS_FILIAL          ,Nil})
	aAdd(alCabec,{"F1_TIPO"        ,SDS->DS_TIPO            ,Nil})
	aAdd(alCabec,{"F1_FORMUL"      ,SDS->DS_FORMUL          ,Nil})
	aAdd(alCabec,{"F1_DOC"         ,SDS->DS_DOC             ,Nil})
	aAdd(alCabec,{"F1_SERIE"       ,SDS->DS_SERIE           ,Nil})
	aAdd(alCabec,{"F1_EMISSAO"     ,SDS->DS_EMISSA		    ,Nil})
	aAdd(alCabec,{"F1_FORNECE"     ,SDS->DS_FORNEC          ,Nil})
	aAdd(alCabec,{"F1_LOJA"        ,SDS->DS_LOJA            ,Nil})
	aAdd(alCabec,{"F1_ESPECIE"     ,SDS->DS_ESPECI          ,Nil})
	aAdd(alCabec,{"F1_DTDIGIT"     ,SDS->DS_DATAIMP			,Nil})
	aAdd(alCabec,{"F1_EST"         ,SDS->DS_EST				,Nil})
	aAdd(alCabec,{"F1_HORA"        ,SubStr(Time(),1,5)		,Nil})
	aAdd(alCabec,{"F1_CHVNFE"      ,SDS->DS_CHAVENF			,Nil})
	aAdd(alCabec,{"F1_FRETE"   	   ,SDS->DS_FRETE			,Nil})
	aAdd(alCabec,{"F1_SEGURO "     ,SDS->DS_SEGURO			,Nil})
	aAdd(alCabec,{"F1_DESPESA"     ,SDS->DS_DESPESA			,Nil})
	aAdd(alCabec,{"F1_DESCONT"     ,SDS->DS_DESCONT         ,Nil}) 
	aAdd(alCabec,{"F1_VALICM"      ,SDS->DS_VALICM          ,Nil})     //VALOR ICM
	aAdd(alCabec,{"F1_BASEICM"     ,SDS->DS_BASEICM         ,Nil})   //BASE ICM 
	aAdd(alCabec,{"F1_VALPIS"      ,SDS->DS_VALPIS          ,Nil}) 
	aAdd(alCabec,{"F1_VALCOFI"     ,SDS->DS_VALCOFI         ,Nil})
	aAdd(alCabec,{"F1_VALIPI"      ,SDS->DS_VALIPI          ,Nil})
EndIf
&(clTab)->(dbCloseArea())

Return alCabec

/*���������������������������������������������������������������������������������
�����������������������������������������������������������������������������������
�������������������������������������������������������������������������������Ŀ��
���Rotina    | XmlRetNome �Autor � Fabricio Antunes                 |Data � 30/01/12 ���
�������������������������������������������������������������������������������Ĵ��
���Descri?ao | Rotina chamada no inicializador padr�o do campo DS_NOME (virtual)���
���          | posiciona na tabela correta (Fornecedor/Cliente) e retorna nome  ���
�������������������������������������������������������������������������������Ĵ��
���Parametros� clCodFor = Cod. Fornecedor                                       ���
���          | clLoja   = Loja                                                  ���
���          | clTipo   = Tipo da Nota (NORMAL/DEVOLUCAO/BENEFICIAMNETO)        ���
�������������������������������������������������������������������������������Ĵ��
���Retorno   � clNomeRet = Nome do fornecedor ou cliente                        ���
�������������������������������������������������������������������������������Ĵ��
��� Uso      � GENERICO		                                                    ���
��������������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������������
���������������������������������������������������������������������������������*/
Static Function XmlRetNome(clForCli,clLoja,clTipo)
Local clNomeRet := ""
Local clAlias   := Iif((AllTrim(clTipo)<>"N"),"SA1","SA2")
clNomeRet := POSICIONE(clAlias,1,(XFILIAL(clAlias)+clForCli+clLoja),(Right(clAlias,2)+"_NOME") )
Return clNomeRet

/*���������������������������������������������������������������������������������
�����������������������������������������������������������������������������������
�������������������������������������������������������������������������������Ŀ��
���Rotina    |GPrdxPrdF   �Autor � Fabricio Antunes                 |Data � 30/01/12 ���
�������������������������������������������������������������������������������Ĵ��
���Descri?ao | Grava relacinamento Produto x Produto do Pornecedor				���
�������������������������������������������������������������������������������Ĵ��
���Parametros� ExpC1 = Cod. Fornecedor|Cliente                                  ���
���			 � ExpC2 = Loja Fornecedor|Cliente                                  ���
���			 � ExpC3 = Nota Fiscal		                                        ���
���			 � ExpC4 = Serie da Nota                                            ���
���			 � ExpC5 = Produto Clinte/Fornecedor                                ���
���			 � ExpC6 = Cod. Produto		                                        ���
�������������������������������������������������������������������������������Ĵ��
���Retorno   � Nil										                        ���
�������������������������������������������������������������������������������Ĵ��
��� Uso      � SelePed, RPrdxPrdF, ProcPCxNFe, AtuSDT							���
��������������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������������
���������������������������������������������������������������������������������*/
Static Function GPrdxPrdF(clCodForCli, clLoja, clNota, clSerie, cProdForCli, cProdEmp)
Local aArea		:= GetArea()
// ����������������������������������������������Ŀ
// | GRAVA RELACIONAMENTO PARA PROXIMA IMPORTACAO |
// ������������������������������������������������
dbSelectArea("SDT")
SDT->(dbSetOrder(2))
If SDT->(dbSeek(xFilial("SDT")+clCodForCli+clLoja+clNota+clSerie+cProdForCli ))
	If RecLock("SDT",.F.)
		Replace DT_COD With cProdEmp
		SDT->(MsUnLock())
	EndIf
EndIf

RestArea( aArea )
Return Nil

/*������������������������������������������������������������������������������������������
��������������������������������������������������������������������������������������������
����������������������������������������������������������������������������������������Ŀ��
���Rotina    | PrdxForCli		   �Autor � Fabricio Antunes                 |Data � 30/01/12 ���
����������������������������������������������������������������������������������������Ĵ��
���Descri?ao | Valida se existe amarra��o entre Produto x Fornecedor/Cliente	   	     ���
����������������������������������������������������������������������������������������Ĵ��
���Parametros� ExpC1 = Cod. Fornecedor|Cliente                                 			 ���
���			 � ExpC2 = Loja Fornecedor|Cliente                                    		 ���
���			 � ExpC3 = Cod. Produto		                                          		 ���
���			 � ExpC4 = Tipo da Nota		                                          		 ���
����������������������������������������������������������������������������������������Ĵ��
���Retorno   � cProdEmp = Produto relacionado ao Forncedor/Cliente                		 ���
����������������������������������������������������������������������������������������Ĵ��
��� Uso      � ProcPCxNFe                                                        	     ���
�����������������������������������������������������������������������������������������ٱ�
��������������������������������������������������������������������������������������������
�������������������������������������������������������������������������������������������*/
Static Function PrdxForCli(clCodForCli, clLoja, clCodProd,clTipo)
Local cWAlias 	:= ""
Local cProdEmp	:= ""
Local nOrd		:= 1

If clTipo<>"N"
	cWAlias := "SA7"
	nOrd := RetOrder("SA7", "A7_FILIAL+A7_CLIENTE+A7_LOJA+A7_PRODUTO")
Else
	cWAlias := "SA5"
	nOrd	:= RetOrder("SA5", "A5_FILIAL+A5_FORNECE+A5_LOJA+A5_PRODUTO")
EndIf

DbSelectArea(cWAlias)
(cWAlias)->(DbSetOrder( nOrd ))

If ( (cWAlias)->(dbSeek(xFilial(cWAlias)+clCodForCli+clLoja+clCodProd )) )
	If cWAlias == "SA5"
		cProdEmp := SA5->A5_PRODUTO
	Else
		cProdEmp := SA7->A7_PRODUTO
	EndIf
EndIf
Return cProdEmp



/*���������������������������������������������������������������������������������
�����������������������������������������������������������������������������������
�������������������������������������������������������������������������������Ŀ��
���Fun??o    |  PesqCGC   �Autor � Fabricio Antunes                 |Data � 30/01/12 ���
�������������������������������������������������������������������������������Ĵ��
���Descri?ao | Funcao pesquisa no SM0 para qual empresa/filial � destinado a NFe���
�������������������������������������������������������������������������������Ĵ��
���Parametros� clCGC = CNPJ informado no arquivo XML                            ���
�������������������������������������������������������������������������������Ĵ��
���Retorno   � alRet = Array de 2 posicoes                                      ���
���          | 		[ 1 ] = COD. EMPRESA                                        ���
���          | 		[ 2 ] = COD. FILIAL                                         ���
�������������������������������������������������������������������������������Ĵ��
��� Uso      � Generico                                                         ���
��������������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������������
���������������������������������������������������������������������������������*/
Static Function PesqCGC(clCGC)
Local alAreaSM0
Local aCodEmpFil:= {}

//RpcSetType(3)
//RpcSetEnv("01","01")

dbSelectArea("SM0")
alAreaSM0 := SM0->(GetArea())
dbGoTop()
Do While !eof() .and. !Empty(clCGC)
	If SM0->M0_CGC = clCGC
		aAdd(aCodEmpFil, {SM0->M0_CODIGO, SM0->M0_CODFIL})
		exit
	Endif
	dbSkip()
Enddo
RestArea(alAreaSM0)
Return aCodEmpFil
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �  ReadXML �Autor  �Fabricio Antunes    � Data �  30/01/12   ���
�������������������������������������������������������������������������͹��
���Descricao � Funcao para leitura de XMLs de NFe no diretorio de download���
���			 � e geracao da pre-nota de entrada.						  ���
�������������������������������������������������������������������������͹��
���Uso       � GENERICO			                                          ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function ReadXML(cFile,lJob)

Local cProduto	:= CriaVar("B1_COD")
Local cDesc		:= CriaVar("B1_DESC")
Local cProdutoOLD := CriaVar("B1_COD")
Local cXML      := ""
Local cError    := ""
Local cWarning  := ""
Local cCGC	    := ""
Local cTipoNF   := ""
Local cTabEmit  := ""
Local cDoc	    := ""
Local cSerie    := ""
Local cCodigo   := ""
Local cLoja	    := ""
Local cCampo1   := ""
Local cCampo2   := ""
Local cCampo3   := ""
Local cCampo4   := ""
Local cCampo5   := ""
Local cQuery    := ""
Local cNFECFAP  := SuperGetMV("MV_NFECFAP",.F.,"")
Local lFound    := .F.
Local lProces   := .T.
Local lCFOPEsp  := .T.
Local nX		:= 0
Local nY		:= 0
Local oFullXML  := NIL
Local oAuxXML   := NIL
Local oXML	    := NIL
Local aItens    := {}
Local aHeadSDS  := {}
Local aItemSDT  := {}
Local oDlg     
Local lStatus := .F.
Local cProduto2 := CriaVar("B1_COD")
Local _nConv	:= 1

Local oDesc
Local oProduto2
Local oProdutoOLD
Local oFont1 := TFont():New("MS Sans Serif",,022,,.T.,,,,,.F.,.F.)
Local oSay1
Local oSay2
Local oSay3
Local oSay4
Local oSay5
Local oSButton1
Static oDlg

Private cEmailAdm 	:= "carlosds@ercal.com.br"
Private cEmailErro  := "carlosds@ercal.com.br"
Private aButton		:={}
Private aTexto		:={}
Private lMsErroAuto 	:= .F. 

//Default lJob := .T.

AADD( aButton, { 1,.T.,{|| FechaBatch() }} )


If !File(cStartPath +cFile)
	If lJob
		ConOut(Replicate("=",80))
		ConOut("ReadXML Error:")
		ConOut("Arquivo: " +cFile)
		ConOut("Ocorrencia: Arquivo inexistente.")
		ConOut(Replicate("=",80))
	Else
		Aviso("Error","Arquivo " +cFile +" inexistente.",{"OK"},2,"ReadXML")
	EndIf
	lProces := .F.
Else
	cXML := ead(cStartPath +cFile)
	
	//-- Nao processa conhecimentos de transporte
	If "</CTE>" $ Upper(cXML)
		FErase(cStartPath+cFile)
		lProces := .F.
	EndIf
	
	//-- Nao processa XML de outra empresa/filial
   //	If lProces .And. !(Substr(SM0->M0_CGC,0,8) $ cXML)   
   If lProces .And. !(Substr(SM0->M0_CGC,0,14) $ cXML)//verificar aqui erro cnpj de outra filial
		lProces := .F.
	EndIf
EndIf

If lProces
	oFullXML := XmlParserFile(cStartPath + cFile,"_",@cError,@cWarning)
	
	//-- Erro na sintaxe do XML
	If Empty(oFullXML) .Or. !Empty(cError)
		If lJob
			ConOut(Replicate("=",80))
			ConOut("ReadXML Error:")
			ConOut("Arquivo: " +cFile)
			ConOut("Ocorrencia: " +cError)
			ConOut(Replicate("=",80))
		Else
			Aviso("Erro",cError,{"OK"},2,"ReadXML")
		EndIf
		
		//-- Move arquivo para pasta dos erros
		cArqTXT := cStartPath+cFile
		//copia o arquivo antes da transacao
		cNomNovArq  := cStartError+cFile
		If MsErase(cNomNovArq)
			__CopyFile(cArqTXT,cNomNovArq)
			FErase(cStartPath+cFile)
		EndIf
		lProces := .F.
	Else
		oXML    := oFullXML
		oAuxXML := oXML
		
		//-- Resgata o no inicial da NF-e
		While !lFound
			oAuxXML := XmlChildEx(oAuxXML,"_NFE")
			If !(lFound := oAuxXML # NIL)
				For nX := 1 To XmlChildCount(oXML)
					oAuxXML  := XmlChildEx(XmlGetchild(oXML,nX),"_NFE")
					lFound := oAuxXML:_InfNfe # Nil
					If lFound
						oXML := oAuxXML
						Exit
					EndIf
				Next nX
			EndIf
			
			If lFound
				oXML := oAuxXML
				Exit
			EndIf
		EndDo
		//VERIFICAR PARA QUAL FILIAL SERA IMPORTADO
		If Type("oXML:_INFNFE:_DEST:_CNPJ") <> "U"
			cCNPJInf := oXML:_INFNFE:_DEST:_CNPJ:TEXT  
			cIEInf   := oXML:_INFNFE:_DEST:_IE:TEXT 
		ELse
			cCNPJInf := " "//oXML:_INFNFE:_DEST:_CPF:TEXT   //VALIDAR
			cCNPJInf := oXML:_INFNFE:_DEST:_CNPJ:TEXT  
			cIEInf   := oXML:_INFNFE:_DEST:_IE:TEXT 
		EndIF
		
		If lJob
			dbSelectArea("SM0")
			dbSetOrder(1)
			dbGoTop()
			While !Eof()
				If SM0->M0_CGC == cCNPJInf .and. StrTran(M0_INSC,{".","-","/"}) == cIEInf
					cFilAnt := SM0->M0_CODFIL
					cEmpAnt := SM0->M0_CODIGO
					Exit                                                                    
					
				EndIf
				dbSkip()
			End
		Else
			If SM0->M0_CGC # cCNPJInf .and. SM0->M0_INSC == cIEInf
				MsgAlert("O arquivo que est� tentando ser importado n�o pertence a esta filial!","Aten��o - MEST001")
				Return
			EndIf
		EndIf
		//-- Verifica se este ID ja foi processado
		DbSelectArea("SDS")
		SDS->(DbSetOrder(2))
		lFound := SDS->(DbSeek(xFilial("SDS")+Right(AllTrim(oXML:_InfNfe:_Id:Text),44)))//Filial + Chave de acesso
		
		//PEGA A IDENT
		
		//VERIFICA O STATUS NA RECEITA FEDERAL E EM CASO DE REJEICAO NAO IMPORTA
		//lStatus := ConsNFeChave(Right(AllTrim(oXML:_InfNfe:_Id:Text),44),cIdEnt,lJob)
		lStatus:=.F.
		If lStatus
			If !lJob
				MsgStop("NFe com problemas, rotina Cancelada!","MEST001")
				Return
			Else
				//ENVIA E-MAIL
				Alert(" Importacao XML NFe entrada com Erros, verifique pasta XML com erro na pasta de erros do cnpj)")
				Return
			EndIf
		EndIf
		
		If lFound
			If lJob
				cEmailErro :="ReadXML Error:"+ENTER
				cEmailErro +="Arquivo: " +cFile+ENTER
				cEmailErro +="Ocorrencia: ID de NFe ja registrado na NF " +SDS->(DS_DOC+"/"+DS_SERIE)+" do fornecedor " +SDS->(DS_FORNEC+"/"+DS_LOJA) +"."+ENTER
				aTexto:={"ReadXML Error:","Arquivo: " +cFile, "Ocorrencia: ID de NFe ja registrado na NF " +SDS->(DS_DOC+"/"+DS_SERIE)+" do fornecedor " +SDS->(DS_FORNEC+"/"+DS_LOJA) +"."}
				//ENVIA E-MAIL
				//Alert(" Importacao XML NFe entrada com Erros, verifique pasta XLM com erro na pasta de erros da system\nfe\entrada)
     			
     			FORMBATCH("Erro de importacao", aTexto, aButton) 
     			
				ConOut(Replicate("=",80))
				ConOut("ReadXML Error:")
				ConOut("Arquivo: " +cFile)
				ConOut("Ocorrencia: ID de NFe ja registrado na NF " +SDS->(DS_DOC+"/"+DS_SERIE);
				+" do fornecedor " +SDS->(DS_FORNEC+"/"+DS_LOJA) +".")
				ConOut(Replicate("=",80))
			Else
				//Aviso("Erro","ID de NFe ja registrado na NF " +SDS->(DS_DOC+"/"+DS_SERIE);
				//+" do fornecedor " +SDS->(DS_FORNEC+"/"+DS_LOJA) +".",{"OK"},2,"ReadXML")
			EndIf
			
			//-- Move arquivo para pasta dos erros
			cArqTXT := cStartPath+cFile
			//copia o arquivo antes da transacao
			cNomNovArq  := cStartError+cFile
			If MsErase(cNomNovArq)
				__CopyFile(cArqTXT,cNomNovArq)
				FErase(cStartPath+cFile)
			EndIf
			
			lProces := .F.
		EndIf
		
		//-- Se ID valido
		//-- Extrai tag _InfNfe:_Det
		If lProces
			If ValType(oXML:_InfNfe:_Det) == "O"
				aItens := {oXML:_InfNfe:_Det}
			ElseIf ValType(oXML:_InfNfe:_Det) == "U"
				If lJob
					cEmailErro :="ReadXML Error:"+ENTER
					cEmailErro +="Arquivo: " +cFile+ENTER
					cEmailErro +="Ocorrencia: tag _InfNfe:_Det nao localizada."+ENTER
					//ENVIA E-MAIL
					Alert(" Importacao XML NFe entrada com Erros, verifique pasta XLM com erro na pasta de erros da DATA\XML\IMPORTADAS\CNPJ\ERRO")
					aTexto:={"ReadXML Error:","Arquivo: " +cFile, "Ocorrencia: tag _InfNfe:_Det nao localizada."}
					FORMBATCH("Erro de importacao", aTexto, aButton) 
					
					ConOut(Replicate("=",80))
					ConOut("ReadXML Error:")
					ConOut("Arquivo: " +cFile)
					ConOut("Ocorrencia: tag _InfNfe:_Det nao localizada.")
					ConOut(Replicate("=",80))
				Else
				   //	Aviso("Erro","Tag _InfNfe:_Det nao localizada.",{"OK"},2,"ReadXML")
				EndIf
				
				//-- Move arquivo para pasta dos erros
				cArqTXT := cStartPath+cFile
				//copia o arquivo antes da transacao
				cNomNovArq  := cStartError+cFile
				If MsErase(cNomNovArq)
					__CopyFile(cArqTXT,cNomNovArq)
					FErase(cStartPath+cFile)
				EndIf
				
				lProces := .F.
			Else
				aItens := oXML:_InfNfe:_Det
			EndIf
		EndIf
		
		//-- Se tag _InfNfe:_Det valida
		//-- Extrai CGC do fornecedor/cliente
		If lProces
			If AllTrim(oXML:_InfNfe:_Ide:_finNFe:Text) == "1"
				cTipoNF := "N"
			ElseIf AllTrim(oXML:_InfNfe:_Ide:_finNFe:Text) == "2"
				cTipoNF := "D"
			Else
				cTipoNF := "B"
			EndIf
			
			If ValType(oXML:_INFNFE:_EMIT:_CNPJ) <> "U"
				cCGC := oXML:_INFNFE:_EMIT:_CNPJ:Text
			ElseIf ValType(oXML:_INFNFE:_EMIT:_CPF) <> "U"
				cCGC := oXML:_INFNFE:_EMIT:_CPF:Text
			Else
				If lJob
					cEmailErro :="ReadXML Error:"+ENTER
					cEmailErro +="Arquivo: " +cFile+ENTER
					cEmailErro +="Ocorrencia: tag _CNPJ/_CPF ausente."+ENTER
					//ENVIA E-MAIL
					//Alert(" Importacao XML NFe entrada com Erros, verifique pasta XLM com erro na pasta de erros da system\nfe\entrada)
					
					aTexto:={"ReadXML Error:","Arquivo: " +cFile, "Ocorrencia: tag _CNPJ/_CPF ausente."}
					FORMBATCH("Erro de importacao", aTexto, aButton) 					
					
					ConOut(Replicate("=",80))
					ConOut("ReadXML Error:")
					ConOut("Arquivo: " +cFile)
					ConOut("Ocorrencia: tag _CNPJ/_CPF ausente.")
					ConOut(Replicate("=",80))
				Else
					//Aviso("Erro","Tag _CNPJ/_CPF ausente.",{"OK"},2,"ReadXML")
				EndIf
				
				//-- Move arquivo para pasta dos erros
				cArqTXT := cStartPath+cFile
				//copia o arquivo antes da transacao
				cNomNovArq  := cStartError+cFile
				If MsErase(cNomNovArq)
					__CopyFile(cArqTXT,cNomNovArq)
					FErase(cStartPath+cFile)
				EndIf
				
				lProces := .F.
			EndIf
		EndIf
		
		//-- Se tag CGC valida
		//-- Busca fornecedor/cliente na base
		If lProces
			cTabEmit := If(cTipoNF == "N","SA2","SA1")
			//			(cTabEmit)->(dbSetOrder(3))
			_cQuery := "SELECT "+(Substr(cTabEmit,2,2))+"_COD AS CODIGO, "+(Substr(cTabEmit,2,2))+"_LOJA AS LOJA "
			_cQuery += "FROM "+RetSqlName(cTabEmit)+" WHERE D_E_L_E_T_ <> '*' AND "+(Substr(cTabEmit,2,2))+"_CGC = '"+cCGC+"' "
			_cQuery += "AND "+(Substr(cTabEmit,2,2))+"_MSBLQL <> '1' "
			dbUseArea(.T., "TOPCONN", TCGenQry(,,_cQuery),"TCGC", .T., .T.)
			dbSelectArea("TCGC")
			TCGC->(dbGotop())
			
			If !TCGC->(Eof())//(cTabEmit)->(dbSeek(xFilial(cTabEmit)+cCGC))
				cCodigo := TCGC->CODIGO //(cTabEmit)->&(Substr(cTabEmit,2,2)+"_COD")
				cLoja   := TCGC->LOJA  //(cTabEmit)->&(Substr(cTabEmit,2,2)+"_LOJA")
			Else
				If lJob
					cEmailErro :="ReadXML Error:"+ENTER
					cEmailErro +="Arquivo: " +cFile+ENTER
					cEmailErro +="Ocorrencia: " +If(cTipoNF == "N","fornecedor","cliente") +" de CNJP/CPF numero " +cCGC +" inexistente na base."+ENTER
										
					aTexto:={"ReadXML Error:","Arquivo: " +cFile, "Ocorrencia: " +If(cTipoNF == "N","fornecedor","cliente") +" de CNJP/CPF numero " +cCGC +" inexistente na base."}
					FORMBATCH("Erro de importacao", aTexto, aButton)
					
					ConOut(Replicate("=",80))
					ConOut("ReadXML Error:")
					ConOut("Arquivo: " +cFile)
					ConOut("Ocorrencia: " +If(cTipoNF == "N","fornecedor","cliente") +" de CNJP/CPF numero " +cCGC +" inexistente na base.")
					ConOut(Replicate("=",80))                                           
				Else
					Aviso("Erro",If(cTipoNF == "N","Fornecedor","Cliente") +" de CNJP/CPF numero " +cCGC +" inexistente na base. FAVOR CADASTRAR E IMPORTAR MANUAL",{"OK"},2,"ReadXML")
				EndIf
				
				//-- Move arquivo para pasta dos erros
				cArqTXT := cStartPath+cFile
				//copia o arquivo antes da transacao
				cNomNovArq  := cStartError+cFile
				If MsErase(cNomNovArq)                    
					__CopyFile(cArqTXT,cNomNovArq)
					FErase(cStartPath+cFile)
				EndIf
				
				lProces := .F.
			EndIf
			DBCloseArea("TCGC")
		EndIf
		
		//-- Se fornecedor/cliente validado
		//-- Processa cabe�alho e itens
		If lProces
			cCampo1 := If(cTipoNF # "N","A7_PRODUTO","A5_PRODUTO")
			cCampo2 := If(cTipoNF # "N","A7_FILIAL","A5_FILIAL")
			cCampo3 := If(cTipoNF # "N","A7_CLIENTE","A5_FORNECE")
			cCampo4 := If(cTipoNF # "N","A7_LOJA","A5_LOJA")
			cCampo5 := If(cTipoNF # "N","A7_CODCLI","A5_CODPRF")
			
			cDoc   := StrZero(Val(AllTrim(oXML:_InfNfe:_Ide:_nNF:Text)),TamSx3("F1_DOC")[1])
			cSerie := PadR(oXML:_InfNfe:_Ide:_Serie:Text,TamSX3("F1_SERIE")[1])
			
			//������������������������������������Ŀ
			//� Grava os Dados do Cabecalho - SDS  �
			//��������������������������������������
			DbSelectArea("SDS")
			AADD(aHeadSDS,{{"DS_FILIAL"	,xFilial("SDS")																	     	},; //Filial
			{"DS_CNPJ"		,cCGC																				},; //CGC
			{"DS_DOC"		,cDoc 																				},; //Numero do Documento
			{"DS_SERIE"		,cSerie 																			},; //Serie
			{"DS_FORNEC"	,cCodigo																			},; //Fornecedor
			{"DS_LOJA"		,cLoja 																				},; //Loja do Fornecedor  
			{"DS_EMISSA"	,StoD(StrTran(AllTrim(oXML:_InfNfe:_Ide:_DhEmi:Text),"-",""))			   			},; //Data de Emiss�o
			{"DS_EST"		,oXML:_INFNFE:_EMIT:_ENDEREMIT:_UF:TEXT												},; //Estado de emissao da NF
			{"DS_TIPO"		,cTipoNF 																	 		},; //Tipo da Nota
			{"DS_FORMUL"	,"N" 																		 		},; //Formulario proprio
			{"DS_DTDIGI"	,dDataBase 																	 		},; //Dtda de digita�ao
			{"DS_ESPECI"	,"SPED"																		  		},; //Especie
			{"DS_ARQUIVO"	,AllTrim(cFile)																   		},; //Arquivo importado
			{"DS_STATUS"	," "																		   		},; //Status
			{"DS_CHAVENF"	,Iif(ValType("opNF:_InfNfe:_Id")<>"U",Right(AllTrim(oXML:_InfNfe:_Id:Text),44),"")},; //Chave de Acesso da NF
			{"DS_VERSAO"	,Iif(ValType("opNF:_InfNfe:_versao")<>"U",oXML:_InfNfe:_versao:text ,"")			},; //Vers�o
			{"DS_USERIMP"	,Iif(!Empty(cUserName),cUserName,"JOB" ) 											},; //Usuario na importacao
			{"DS_DATAIMP"	,dDataBase																			},; //Data importacao do XML
			{"DS_HORAIMP"	,SubStr(Time(),1,5)																	}}) //Hora importacao XML
			
			
			For nX := 1 To Len(aItens)
				cProduto := AllTrim(aItens[nX]:_Prod:_cProd:Text)
			   	cDesc	 := AllTrim(aItens[nX]:_Prod:_xProd:Text)
			   	
				cQuery := "SELECT " +cCampo1 +" FROM " +RetSqlName(If(cTipoNF # "N","SA7","SA5"))
				cQuery += " WHERE D_E_L_E_T_ <> '*' AND "
				cQuery += cCampo2 +" = '" +xFilial(If(cTipoNF # "N","SA7","SA5")) +"' AND "
				cQuery += cCampo3 +" = '" +cCodigo +"' AND "
				cQuery += cCampo4 +" = '" +cLoja +"' AND "
				cQuery += cCampo5 +" = '" +cProduto +"'"
				
				If Select("TRB") > 0
					TRB->(dbCloseArea())
				EndIf
				
				TcQuery cQuery new Alias "TRB"
			
				If !TRB->(EOF())
					cProduto2	:= TRB->(&cCampo1)  
					//_nConv 	  := TRB->A5_C_SEGUN     
				ELSEIF SUBSTR(ALLTRIM(cCodigo),1,1) == "L"
					cProduto2	:= aItens[nX]:_PROD:_CPROD:TEXT
				Else  
					cProduto2 := ''
					/*If lJob
						ConOut(Replicate("=",80))
						ConOut("ReadXML Error:")
						ConOut("Arquivo: " +cFile)
						ConOut("Ocorrencia: " +If(cTipoNF == "N","fornecedor ","cliente ") +cCodigo +"/" +cLoja;
						+" sem cadastro de Produto X " +If(cTipoNF == "N","Fornecedor","Cliente");
						+" para o codigo " +cProduto +".")
						ConOut(Replicate("=",80))
					Else  */
					   //RETIRADO AMARRACAO INICIAL PARA FICAR SOMENTE A FINAL	     
						/*Aviso("Erro",If(cTipoNF == "N","Fornecedor ","Cliente ") +cCodigo +"/" +cLoja;
						+" sem cadastro de Produto X " +If(cTipoNF == "N","Fornecedor","Cliente");
						+" para o c�digo " +cProduto +".",{"OK"},2,"ReadXML")
						
						//MsgAlert('Atencao Produto '+cProduto+' n�o Encontrado na Amarra��o Prod. x Fornecedor, Deseja incluir?' )
							cProdutoOld	:= cProduto+Space(15-Len(cProduto)) 
							cProduto2 	:= Space(15)       
							_nConv 		:= 1
						   /*	@ 65,153 To 229,435 Dialog oDlg Title OemToAnsi("Inclus�o Amarra��o")
							@ 9,9 Say OemToAnsi("Produto") Size 99,8
							@ 28,9 Get cProduto2 Picture "@!" F3 "SB1" VALID Existcpo("SB1",cProduto2) Size 59,10  
							@ 9,70 Say OemToAnsi("Descri��o") Size 99,8
							@ 28,70 Get cDesc Picture "@E"  Size 59,10
							@ 62,39 BMPBUTTON TYPE 1 ACTION Close(oDlg)
							
							DEFINE MSDIALOG oDlg TITLE OemToAnsi("Amarra��o de Produtos") FROM 000, 000  TO 300, 500 COLORS 0, 16777215 PIXEL
						
							    @ 007, 043 SAY oSay1 PROMPT OemToAnsi("Amarra��o Produto X Fornecedor") SIZE 167, 015 OF oDlg FONT oFont1 COLORS 16711680, 16777215 PIXEL
							    @ 027, 014 SAY oSay2 PROMPT OemToAnsi("Favor informar o codigo do produto Protheus que corresponde ao produto abaixo do fornecedor.") SIZE 225, 018 OF oDlg COLORS 0, 16777215 PIXEL
							    @ 060, 014 MSGET cProdutoOLD VAR cProdutoOLD SIZE 060, 010 OF oDlg   PIXEL COLOR CLR_BLACK
							    @ 060, 083 MSGET cDesc 		 VAR cDesc 		 SIZE 152, 010 OF oDlg 	  PIXEL COLOR CLR_BLACK
							    @ 097, 016 MsGet oProduto2	 VAR cProduto2   Size 060, 010 VALID Existcpo("SB1",cProduto2) F3 "SB1" OF oDlg Pixel COLOR CLR_BLACK
							    @ 052, 014 SAY oSay3 PROMPT "Codigo Fornecedor:" SIZE 051, 007 OF oDlg COLORS 0, 16777215 PIXEL
							    @ 050, 083 SAY oSay4 PROMPT "Descri��o Fornecedor" SIZE 060, 007 OF oDlg COLORS 0, 16777215 PIXEL
							    @ 087, 016 SAY oSay5 PROMPT "Codigo Protheus" SIZE 025, 007 OF oDlg COLORS 0, 16777215 PIXEL
						    	DEFINE SBUTTON oSButton1 FROM 122, 107 TYPE 01 OF oDlg ENABLE ACTION IIF(!Empty(cProduto2),Close(oDlg),Alert("Selecione um Produto"))
						
  							ACTIVATE MSDIALOG oDlg CENTERED
							
							If !Empty(cProduto2)
								
								If cTipoNF # "N"
									dbSelectArea("SA7")
									RecLock("SA7",.T.)
									A7_FILIAL 	:= xFilial("SA7")
									A7_CLIENTE 	:= cCodigo
									A7_LOJA 	:= cLoja
									A7_CODCLI   := cProduto
									A7_PRODUTO  := cProduto2
									MsUnlock()
								Else
									dbSelectArea("SA5")
									RecLock("SA5",.T.)
									A5_FILIAL 	:= xFilial("SA5")
									A5_FORNECE 	:= cCodigo
									A5_LOJA 	:= cLoja
									A5_NOME		:= Posicione("SA2",1,xFilial("SA2")+cCodigo,"A2_NOME")
									A5_CODPRF	:= cProduto
									A5_PRODUTO  := cProduto2
									A5_NOMPROD  := Posicione("SB1",1,xFilial("SB1")+cProduto2,"B1_DESC") 
									//A5_C_SEGUN  := _nConv
									MsUnlock()
								Endif
							
						   	Else
								
								MsgAlert("As amarra��es desta nota deverao ser efetuadas posteriormente para gera��o da pr� nota de entrada")
								Exit
							EndIf
							
						/*Else
							//-- Move arquivo para pasta dos erros
							cArqTXT := cStartPath+cFile
							//copia o arquivo antes da transacao
							cNomNovArq  := cStartError+cFile
							If MsErase(cNomNovArq)
								__CopyFile(cArqTXT,cNomNovArq)
								FErase(cStartPath+cFile)
							EndIf
							
							lProces := .F.
							Exit
						EndIf   */
					//EndIf
				EndIf
				
				TRB->(dbCloseArea())
				
				//����������������������������Ŀ
				//� Dados dos Itens - SDT	   �
				//������������������������������
				DbSelectArea("SDT")
				//������������������������Ŀ
				//�  DADOS DO PRODUTO      �
				//��������������������������
				AADD(aItemSDT,{{"DT_FILIAL" 	,xFilial("SDT")														},; //Filial
				{"DT_CNPJ"		,cCGC																},; //CGC
				{"DT_COD"		,cProduto2															},; //Codigo do produto
				{"DT_PRODFOR"	,aItens[nX]:_PROD:_CPROD:TEXT										},; //Cdgo do pduto do Fornecedor
				{"DT_DESCFOR"	,aItens[nX]:_PROD:_XPROD:TEXT										},; //Dcao do pduto do Fornecedor
				{"DT_ITEM"   	,PadL(aItens[nX]:_nItem:Text,TamSX3("D1_ITEM")[1],"0")				},; //Item
				{"DT_QUANT"  	,(Val(aItens[nX]:_Prod:_qCom:Text) * _nConv )							},; //Qtde
				{"DT_VUNIT"		,Round((Val(aItens[nX]:_Prod:_vUnCom:Text))/(_nConv),TamSX3("C7_PRECO")[2])	},; //Vlor Unit�rio
				{"DT_FORNEC"	,cCodigo															},; //Forncedor
				{"DT_LOJA"   	,cLoja																},; //Lja
				{"DT_DOC"    	,cDoc																},; //DocmTo
				{"DT_SERIE"		,cSerie							   									},; //Serie
				{"DT_TOTAL"		,Val(aItens[nX]:_Prod:_vProd:Text)									}}) //Vlor Total
			Next nX
			
			If !Empty(aItemSDT) .And. !Empty(aHeadSDS)
				//������������������������������������������������������������Ŀ
				//�Grava os dados do cabe�alho e itens da nota importada do XML�
				//��������������������������������������������������������������
				Begin Transaction
				
				aHeadSDS:=aHeadSDS[1]
				//--Grava cabe�alho
				RecLock("SDS",.T.)
				For nX:=1	To Len(aHeadSDS)
					SDS->&(aHeadSDS[nX][1]):= aHeadSDS[nX][2]
				Next
				dbCommit()
				MsUnlock()
				//--Grava Itens
				For nX:=1 To Len(aItemSDT)
					RecLock("SDT",.T.)
					For nY:=1 To Len(aItemSDT[nX])
						SDT->&(aItemSDT[nX][nY][1]):= aItemSDT[nX][nY][2]
					Next
					dbCommit()
					MsUnlock()
				Next
				
				cArqTXT := cStartPath+cFile
				//copia o arquivo antes da transacao
				cNomNovArq  := c5StartPath+cFile
				If MsErase(cNomNovArq)
					__CopyFile(cArqTXT,cNomNovArq)
					FErase(cStartPath+cFile)
				EndIf
				
				End Transaction
			Else
				//-- Move arquivo para pasta dos erros
				cArqTXT := cStartPath+cFile
				//copia o arquivo antes da transacao
				cNomNovArq  := cStartError+cFile
				If MsErase(cNomNovArq)
					__CopyFile(cArqTXT,cNomNovArq)
					FErase(cStartPath+cFile)
				EndIf
			EndIf
			
		EndIf
	EndIf
EndIf

Return lProces

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MEST001  �Autor  �Microsiga           � Data �  01/30/12   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function ConsNFeChave(cChaveNFe,cIdEnt,lWeb)

Local cURL     := PadR(GetNewPar("MV_SPEDURL","http://"),250)
Local cMensagem:= ""
Local oWS
Local lErro := .F.


If ValType(lWeb) == 'U'
	lWeb := .F.
EndIf

oWs:= WsNFeSBra():New()
oWs:cUserToken   := "TOTVS"
oWs:cID_ENT    := cIdEnt
ows:cCHVNFE		 := cChaveNFe
oWs:_URL         := AllTrim(cURL)+"/NFeSBRA.apw"

If oWs:ConsultaChaveNFE()
	cMensagem := ""
	If !Empty(oWs:oWSCONSULTACHAVENFERESULT:cVERSAO)
		cMensagem += "Vers�o da Mensagem"+": "+oWs:oWSCONSULTACHAVENFERESULT:cVERSAO+CRLF
	EndIf
	cMensagem += "Ambiente"+": "+IIf(oWs:oWSCONSULTACHAVENFERESULT:nAMBIENTE==1,"Produ��o","Homologa��o")+CRLF //"Produ��o"###"Homologa��o"
	cMensagem += "Cod.Ret.NFe"+": "+oWs:oWSCONSULTACHAVENFERESULT:cCODRETNFE+CRLF
	cMensagem += "Msg.Ret.NFe"+": "+oWs:oWSCONSULTACHAVENFERESULT:cMSGRETNFE+CRLF
	If !Empty(oWs:oWSCONSULTACHAVENFERESULT:cPROTOCOLO)
		cMensagem += "Protocolo"+": "+oWs:oWSCONSULTACHAVENFERESULT:cPROTOCOLO+CRLF
	EndIf
	//QUANDO NAO ESTIVER OK NAO IMPORTA, CODIGO DIFERENTE DE 100
	If oWs:oWSCONSULTACHAVENFERESULT:cCODRETNFE # "100"
		lErro := .T.
	EndIf
	
	If !lWeb
		Aviso("Consulta NF",cMensagem,{"Ok"},3)
	Else
		Return({lErro,cMensagem})
	EndIf
Else
	Aviso("SPED",IIf(Empty(GetWscError(3)),GetWscError(1),GetWscError(3)),{"Ok"},3)
EndIf
Return(lErro)                    

Static Function ExclDocEntrada(oDados, alCpos)
//�������������������������������������������������������Ŀ
//� Verifica as posicoes/ordens dos campos no array       �
//���������������������������������������������������������
Local nlPosCFor := Ascan(alCpos,{|x|Alltrim(X[2])=="DS_FORNEC"})
Local nlPosLoja := Ascan(alCpos,{|x|Alltrim(X[2])=="DS_LOJA"})
Local nlPosNum  := Ascan(alCpos,{|x|Alltrim(X[2])=="DS_DOC"})
Local nlPosSer  := Ascan(alCpos,{|x|Alltrim(X[2])=="DS_SERIE"})
Local nlPosCHNF := Ascan(alCpos,{|x|Alltrim(X[2])=="DS_CHAVENF"})
Local nPos 		:= oDados:nAt

PRIVATE L140EXCLUI := .T.
PRIVATE aRotina	:= {	{,"AxPesqui"		, 0 , 1, 0, .F.},; //
{ "Visualizar","A140NFiscal"	, 0 , 2, 0, .F.},; //
{ "Incluir"	,"A140NFiscal"	, 0 , 3, 0, nil},; //
{ "Alterar"	,"A140NFiscal"	, 0 , 4, 0, nil},; //
{ "Excluir"	,"A140NFiscal"	, 0 , 5, 0, nil},; //
{ "Imprimir","A140Impri"  	, 0 , 4, 0, nil},; //
{ "Estorna Classificacao"	,"A140EstCla" 	, 0 , 5, 0, nil},; //
{ "Legenda"	,"A103Legenda"	, 0 , 2, 0, .F.}} 	//

//tratamento para n�o gerar erro, quando o array vazio
if Empty(oDados:aArray)
	return .T.
endif

SDS->( DbSetOrder(1), DbSeek( xFilial("SDS") + ;
oDados:aArray[nPos][nlPosNum] + ;
oDados:aArray[nPos][nlPosSer] + ;
oDados:aArray[nPos][nlPosCFor] + ;
oDados:aArray[nPos][nlPosLoja] ) )


Pergunte("MTA140",.F.)

if SF1->( DbSetOrder(1), DbSeek( xFilial("SF1") + SDS->DS_DOC + SDS->DS_SERIE + SDS->DS_FORNEC + SDS->DS_LOJA ) )
	
	SD1->( DbSetOrder(1), DbSeek( xFilial("SD1") + SDS->DS_DOC + SDS->DS_SERIE + SDS->DS_FORNEC + SDS->DS_LOJA ) )
	SA2->( DbSetOrder(1), DbSeek( xFilial("SA2") + SF1->F1_FORNECE + SF1->F1_LOJA ) )
	SF1->( A140NFiscal("SF1", SF1->( Recno() ), 5, ,.T. ) )	//Nota J� Classificada
	
elseif Aviso("XML","Deseja excluir o XML importado?",{"Sim","N�o"}) == 1	// Entao e para excluir o XML importado?
	dbSelectArea("SDV")
	SDV->( dbSetOrder(1) )
	SDV->( dbSeek(xFilial("SDV") + PadR(oDados:aArray[nPos][nlPosCFor],TamSX3("DV_FORNEC")[1]) + PadR(oDados:aArray[nPos][nlPosLoja],TamSx3("DV_LOJA")[1]) + oDados:aArray[nPos][nlPosNum]  + oDados:aArray[nPos][nlPosSer] ) )
	
	while SDV->(DV_FILIAL+DV_FORNEC+DV_LOJA+DV_DOC+DV_SERIE) == (xFilial("SDV") + PadR(oDados:aArray[nPos][nlPosCFor],TamSX3("DV_FORNEC")[1]) + PadR(oDados:aArray[nPos][nlPosLoja],TamSx3("DV_LOJA")[1]) + oDados:aArray[nPos][nlPosNum]  + oDados:aArray[nPos][nlPosSer])
		
		RecLock("SDV")
		SDV->( DbDelete() )
		SDV->( DbUnLock() )
		
		SDV->( DbSkip() )
		
	enddo
	
	SDT->( DbSetOrder(3)) //DT_FILIAL+DT_FORNEC+DT_LOJA+DT_DOC+DT_SERIE
	SDT->( DbSeek(xFilial("SDT") + oDados:aArray[nPos][nlPosCFor] + oDados:aArray[nPos][nlPosLoja] + oDados:aArray[nPos][nlPosNum]  + oDados:aArray[nPos][nlPosSer] ))
	
	While SDT->(!Eof()) .AND. SDT->(DT_FILIAL+DT_FORNEC+DT_LOJA+DT_DOC+DT_SERIE) == (xFilial("SDT") + oDados:aArray[nPos][nlPosCFor] + oDados:aArray[nPos][nlPosLoja] + oDados:aArray[nPos][nlPosNum]  + oDados:aArray[nPos][nlPosSer])
		
		RecLock("SDT",.F.)
		SDT->( DbDelete() )
		SDT->( DbUnLock() )
		
		SDT->( DbSkip() )
		
	enddo
	
	RecLock("SDS",.F.)
	SDS->( DbDelete() )
	SDS->( DbUnLock() )
	
endif

Return .T.   

Static Function DownLoadXML()

Local cIniName:= GetRemoteIniName()
Local lUnix:= IsSrvUnix()
Local nPos:= Rat( IIf(lUnix,"/","\"),cIniName )
Local cPathRmt
if nPos!=0
	cPathRmt:= Substr( cIniName,1,nPos-1 )
endif

WinExec(cPathRmt + "\xml\DanfeToXML.exe")
Return .T.      

//User Function cRiadir()

