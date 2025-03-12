#include "rwmake.ch"
#Include "SigaWin.ch"

/*
__________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦Programa  ¦ CTBVAL   ¦ Utilizador ¦ Claudio Ferreira  ¦ Data ¦ 04/06/12¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Descriçào ¦ Rotinas de Validação Contábil                              ¦¦¦
¦¦¦          ¦                                                            ¦¦¦
¦¦¦          ¦ 															  ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦ Uso      ¦ TOTVS-GO                                                   ¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
*/

/*
__________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦Programa  ¦ ValCCNF  ¦ Utilizador ¦ Claudio Ferreira  ¦ Data ¦ 04/06/12¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Descriçào ¦ Valida digitação do C.Custo no Doc de Entrada              ¦¦¦
¦¦¦          ¦                                                            ¦¦¦
¦¦¦          ¦ Utilizado no PE MT100TOK                          		  ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦ Uso      ¦ TOTVS-GO                                                   ¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
*/

User Function ValCCNF(aCols,aBackColsSDE)
Local lOk:=.t.
Local i,ii
Local nPosTES  := GDFieldPos("D1_TES")
Local nPosCC   := GDFieldPos("D1_CC")
Local lValSDE   :=.f.


if Len(aBackColsSDE)>0
	For i:=1 to Len(aBackColsSDE)
		if Posicione('SF4',1,xFilial('SF4')+aCols[i][nPosTES],'F4_ESTOQUE')='N' .and. Posicione('SF4',1,xFilial('SF4')+aCols[i][nPosTES],'F4_DUPLIC')='S' .and. Posicione('SF4',1,xFilial('SF4')+aCols[i][nPosTES],'F4_ATUATF')<>'S' .and. Posicione('SF4',1,xFilial('SF4')+aCols[i][nPosTES],'F4_REFATAN')<>'1'
			For ii:=1 to Len(aBackColsSDE[i][2])
				if empty(aBackColsSDE[i][2][ii][3])//Centro de Custo
					lOk:=.f.
				endif
				lValSDE   :=.t.
			Next ii
		endif
	Next i
	if !lOk
		msgbox("Informe os Centros de Custo no Rateio")
	endif
endif
if lOk .and. !lValSDE
	For i:=1 to Len(aCols)
		if !aCols[i,Len(aHeader) + 1] .and. Posicione('SF4',1,xFilial('SF4')+aCols[i][nPosTES],'F4_ESTOQUE')='N' .and. Posicione('SF4',1,xFilial('SF4')+aCols[i][nPosTES],'F4_DUPLIC')='S' .and. Posicione('SF4',1,xFilial('SF4')+aCols[i][nPosTES],'F4_ATUATF')<>'S' .and. Posicione('SF4',1,xFilial('SF4')+aCols[i][nPosTES],'F4_REFATAN')<>'1'
			if empty(aCols[i][nPosCC])//Centro de Custo
				lOk:=.f.
			endif
		endif
	Next i
	if !lOk
		msgbox("Informe os Centros de Custo dos Itens ou Selecione um Rateio CC")
	endif
endif

Return lOk

/*
__________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦Programa  ¦ LPLSG    ¦ Utilizador ¦ Claudio Ferreira  ¦ Data ¦ 18/06/12¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Descriçào ¦ Retorna se o LP é ou não uma contabilização de Leasing/    ¦¦¦
¦¦¦          ¦ Financiamento                                              ¦¦¦
¦¦¦          ¦ Utilizado nos LP´s                                 		  ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦ Uso      ¦ TOTVS-GO                                                   ¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
*/

User Function LPLSG(nOpn)
Local lOk:=.f.
if     nOPn=1 //SE2
	lOk:=Alltrim(SE2->E2_NATUREZ)$(SuperGetMV("MV_XNATLSG",.F.,"")+'/'+SuperGetMV("MV_XNATFIN",.F.,""))
elseif nOPn=2 //SE5
	lOk:=(Alltrim(SE5->E5_NATUREZ)$(SuperGetMV("MV_XNATLSG",.F.,"")+'/'+SuperGetMV("MV_XNATFIN",.F.,""))) .AND. (!Alltrim(SE5->E5_NATUREZ)$(SuperGetMV("MV_XNATJUR",.F.,"")))
elseif nOPn=3 //SE5 - Juros e Encargos
	lOk:=(Alltrim(SE5->E5_NATUREZ)$(SuperGetMV("MV_XNATLSG",.F.,"")+'/'+SuperGetMV("MV_XNATFIN",.F.,""))) .AND. (Alltrim(SE5->E5_NATUREZ)$(SuperGetMV("MV_XNATJUR",.F.,"")))
elseif nOPn=4 //SE5 - Principal+Juros e Encargos
	lOk:=(Alltrim(SE5->E5_NATUREZ)$(SuperGetMV("MV_XNATLSG",.F.,"")+'/'+SuperGetMV("MV_XNATFIN",.F.,"")+'/'+SuperGetMV("MV_XNATJUR",.F.,"")))
endif
Return lOk

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CTBRECON  ºAutor  ³Claudio Ferreira    º Data ³  20/12/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Contabilização da conciliação bancária                     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ TBC                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function CTBRECON
Local cArquivo
Local cPadrao
Local lHead		:= .F.					// Ja montou o cabecalho?
Local lPadrao
Local nTotal	:=0
Local nHdlPrv	:=0
Local cLote     :='008850'
Local OldDataBase:=dDataBase
Local lDigita:=SuperGetMV("MV_XVLCREC",.F.,.F.)
Local cAliasTab:="TRB"

if Type('CALIASTRB')=="C"  //Compatibilização para novo TRB
	cAliasTab:=CALIASTRB
endif

DbSelectArea(cAliasTab)
dbGoTop()
While ! Eof()
	dbSelectArea("SE5")
	dbGoTo( (cAliasTab)->E5_RECNO )
	dbSelectArea( "SA6" )
	dbSetOrder(1)
	dbSeek(xFilial("SA6")+SE5->E5_BANCO+SE5->E5_AGENCIA+SE5->E5_CONTA)
	//Tratar posicionamento
	if (SE5->E5_TIPODOC <> "ES" .AND. SE5->E5_RECPAG == "R") .or. (SE5->E5_TIPODOC == "ES" .AND. SE5->E5_RECPAG == "P")
		//SA1
		SA1->( dbSetOrder( 1 ) )
		SA1->( MsSeek( xFilial( "SA1" ) + SE5->( E5_CLIFOR + E5_LOJA ) ) )
	else
		//SA2
		SA2->( dbSetOrder( 1 ) )
		SA2->( MsSeek( xFilial( "SA2" ) + SE5->( E5_CLIFOR + E5_LOJA ) ) )
	endif
	dbSelectArea("SE5")
	IF !lHead
		lHead := .T.
		nHdlPrv:=HeadProva(cLote,"RFIN380",Substr(cUsuario,7,6),@cArquivo)
	End
	//Verifico se nao estava reconciliado anteriormente
	cReconAnt := SE5->E5_RECONC
	lEstorna:=.f.
	If cReconAnt='x' .and. (SE5->E5_DTDISPO # (cAliasTab)->E5_DTDISPO .or. Empty((cAliasTab)->E5_OK))
		lEstorna:=.t.
		dOldDispo:=SE5->E5_DTDISPO
		if nTotal>0
			RodaProva(nHdlPrv,nTotal)
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Envia para Lan‡amento Cont bil                      ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			lAglut 	:=.T.
			cA100Incl(cArquivo,nHdlPrv,3,cLote,lDigita,lAglut)
			nTotal:=0
		endif
		//Inicia o estorno
		nHdlPrv:=HeadProva(cLote,"RFIN380",Substr(cUsuario,7,6),@cArquivo)
		cPadrao	:= '002'
		lPadrao	:= VerPadrao(cPadrao)
		dDataBase:=dOldDispo
		IF lPadrao
			nTotal += DetProva(nHdlPrv,cPadrao,"RFIN380",cLote)
		EndIf
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Envia para Lan‡amento Cont bil                      ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		lAglut 	:=.T.
		cA100Incl(cArquivo,nHdlPrv,3,cLote,lDigita,lAglut)
		lHead := .F.
		nTotal:=0
		dDataBase:=(cAliasTab)->E5_DTDISPO
	End
	IF !lHead
		lHead := .T.
		nHdlPrv:=HeadProva(cLote,"RFIN380",Substr(cUsuario,7,6),@cArquivo)
	End
	dDataBase:=(cAliasTab)->E5_DTDISPO
	If !Empty((cAliasTab)->E5_OK) .and. (Empty(cReconAnt).or.lEstorna)
		cPadrao	:= '001'
		lPadrao	:= VerPadrao(cPadrao)
		IF lPadrao
			nTotal += DetProva(nHdlPrv,cPadrao,"RFIN380",cLote)
		EndIf
	Endif
	DbSelectArea(cAliasTab)
	dbSkip()
	if dDataBase<>(cAliasTab)->E5_DTDISPO
		RodaProva(nHdlPrv,nTotal)
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Envia para Lan‡amento Cont bil                      ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		lAglut 	:=.T.
		cA100Incl(cArquivo,nHdlPrv,3,cLote,lDigita,lAglut)
		lHead := .F.
		nTotal:=0
	endif
	
Enddo
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Grava Rodape                                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If lHead
	RodaProva(nHdlPrv,nTotal)
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Envia para Lan‡amento Cont bil                      ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	lAglut  := .T.
	cA100Incl(cArquivo,nHdlPrv,3,cLote,lDigita,lAglut)
Endif
dbGoTop()
dDataBase:=OldDataBase
Return

/*
__________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦Programa  ¦ ValImob  ¦ Utilizador ¦ Claudio Ferreira  ¦ Data ¦ 29/04/13¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Descriçào ¦ Valida digitação do Produto x TES no Doc de Entrada        ¦¦¦
¦¦¦          ¦ Exibe msg alertando que o Prod tem conta Imob e a TES não  ¦¦¦
¦¦¦          ¦ controla Ativo Fixo. Desativada pelo parametro MV_XVALATF  ¦¦¦
¦¦¦          ¦ Utilizado no PE MT100TOK                          		  ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦ Uso      ¦ TOTVS-GO                                                   ¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
*/

User Function ValImob(aCols)
Local lOk := .t.
Local i,ii
Local nPosTES  := GDFieldPos("D1_TES")
Local nPosCOD   := GDFieldPos("D1_COD")

If SB1->(FieldPos("B1_XCTAI"))> 0
	For i:=1 to Len(aCols)
		if !aCols[i,Len(aHeader) + 1] .and. Posicione('SF4',1,xFilial('SF4')+aCols[i][nPosTES],'F4_ATUATF')='N' .and. !Empty(Posicione('SB1',1,xFilial('SB1')+aCols[i][nPosCOD],'B1_XCTAI'))
			lOk:=.f.
		endif
	Next i
Endif
if !lOk
	if msgyesno("Um ou mais produtos possuem conta Imobilizado e a TES informada não lança Ativo Fixo."+Chr(13)+Chr(10)+"Por gentileza confirme com a contabilidade o lançamento deste Item!"+Chr(13)+Chr(10)+"Aceita?")
		lOk:=.t.
	Endif
endif

Return lOk


/*
DbSelectArea("SX3")
//Se o usuario tem acesso ao campo e esta em uso incluir o campo em primeiro lugar
//para permitir mudar o valor por pagar. Bruno
DbSetOrder(2)
DbSeek("E2_PAGAR")
If Found() .And. X3Uso(x3_usado)  .And. cNivel >= X3_NIVEL
*/

/*
__________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦Programa  ¦ RetVlPCFr¦ Utilizador ¦ Claudio Ferreira  ¦ Data ¦ 10/03/15¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Descriçào ¦ Retorna o valor da parcela do PC Fração                    ¦¦¦
¦¦¦          ¦                                                            ¦¦¦
¦¦¦          ¦                                                            ¦¦¦
¦¦¦          ¦                                                   		  ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦ Uso      ¦ CTB ATF - TOTVS-GO                                         ¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
*/

User Function RetVlPCFr(_cBase,_cItem,_cTp)
Local _cArea := GetArea()
Local nQtdParc := 0
Local _nParCalc:= 0
Local _nPar    := 0
Local _nRet    := 0

cQry := "Select  COUNT(*) PARCELAS "
cQry +=  " FROM "+RetSqlName("SN4")
cQry += " WHERE N4_FILIAL  = '" + xFilial("SN4") + "'"
cQry += "  AND D_E_L_E_T_ <> '*'"
cQry += "  AND N4_CBASE     = '" + _cBase + "'"
cQry += "  AND N4_ITEM = '" + _cItem + "'"
cQry += "  AND N4_OCORR = '06'"
cQry += "  AND N4_TIPOCNT = '4'"
cQry += "  AND N4_CALCPIS = '3'"
cQry := ChangeQuery(cQry)
dbUseArea(.T., "TOPCONN", TCGenQry(,,cQry), 'QRY', .F., .T.)
QRY->(dbGoTop())

nQtdParc := SN1->N1_MESCPIS

if nQtdParc=0 
  nQtdParc := 48
endif

_nParCalc:=DateDiffMonth( FirstDay(SN3->N3_AQUISIC)-1 , SN4->N4_DATA ) 
_nPar := QRY->PARCELAS
_nPar:=Max(_nPar,_nParCalc)

if _nPar<=nQtdParc
	if _cTp = 'PIS'
		_nRet:=((SN3->N3_VORIG1/nQtdParc)*(SN1->N1_ALIQPIS/100))
	elseif _cTp = 'COF'
		_nRet:=((SN3->N3_VORIG1/nQtdParc)*(SN1->N1_ALIQCOF/100))
	elseif _cTp = 'PAR'
		_nRet:=_nPar
	endif
endif

QRY->(dbCloseArea())

DbSelectArea(_cArea)

Return _nRet
 