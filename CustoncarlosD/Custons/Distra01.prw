#INCLUDE "PROTHEUS.CH"
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³Distra01  ³ Autor ³CARLOS DANIEL          ³ Data ³03.12.2013³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³DISTRATO CONTRATO DE PARCERIA                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³Nenhum                                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ExpC1: Alias do arquivo                                     ³±±
±±³          ³ExpN2: Registro do Arquivo                                  ³±±
±±³          ³ExpN3: Opcao da MBrowse                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   DATA   ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³               ³                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function Distra01(cAlias,nReg,nOpcx)

Local aArea     := GetArea()
Local aStruADB  := {}
Local aSize     := {}
Local aObjects  := {}
Local aInfo     := {}
Local aPosGet   := {}
Local aPosObj   := {}
Local aRegADB   := {}
Local nX        := 0
Local nUsado    := 0
Local nGetLin   := 0
Local nOpcA     := 0
Local nSaveSx8  := GetSx8Len()
Local cCadastro := 'STR0007' //"Contrato de Parceria - Venda"
Local cQuery    := ""
Local cAliasADB := "ADB"
Local cAliasADA := "ADA"
Local cStatus	:= ""
Local lQuery    := .F.
Local lAlter    := .F.
Local lCopia    := .F.
Local lVisual   := .F.
Local lEncerra	:= .T.
Local lContinua := .T.                              
Local lCanDel   := (SuperGetMv("MV_DELCTR",.F.,"2") == "2")
Local lDeleta   := .T.
Local lEncerOk	:= .F.
Local oDlg
Local oGetD
Local oSAY1
Local oSAY2
Local oSAY3
Local oSAY4
Local lParcial := .T.

PRIVATE aTELA[0][0]
PRIVATE aGETS[0]
PRIVATE aHeader := {}
PRIVATE aCols   := {}
PRIVATE N       := 1

If lEncerra .And. (cAliasADA)->ADA_STATUS <> "B" .and. (cAliasADA)->ADA_STATUS <> "C" //Verifica se o status do contrato permite o encerramento.
	Alert("Somente contratos com o status C Parcialmente Entregue") 
	Return()//lContinua := .F.                      
EndIf

If lEncerra .And. ADA->ADA_STATUS == "B" .OR. (cAliasADA)->ADA_STATUS == "C" .And. lParcial 
	lEncerOk := .T.
	If MsgYesNo('Deseja realmente efetuar distrato do contrato'+" "+(cAliasADA)->ADA_NUMCTR+" ?"+'SIM = Distrato do contrato / NÃO = Cancelamento da operacao')  //pergunta se deseja deletar
			lContinua := .F.
	Else 
			Alert("Operação Cancelada") 
			Return()                      
	EndIF
ELSE  
	Alert("Existe algum erro de compatibilidade .. entrar contato com TI da ERCAL para Ajuste") 
	Return()
EndIf
				
dbSelectArea("ADB")
dbSetOrder(1)
#IFDEF TOP
	If aScan(aHeader,{|x| x[8] == "M"})==0
		lQuery    := .T.
		aStruADB  := ADB->(dbStruct())
		cAliasADB := "ADB"

		cQuery := "SELECT ADB.*,ADB.R_E_C_N_O_ ADBRECNO "
		cQuery += "FROM "+RetSqlName("ADB")+" ADB "
		cQuery += "WHERE ADB.ADB_FILIAL='"+xFilial("ADB")+"' AND "
		cQuery += "ADB.ADB_NUMCTR='"+ADA->ADA_NUMCTR+"' AND "
		cQuery += "ADB.D_E_L_E_T_=' ' "
		cQuery += "ORDER BY "+SqlOrder(ADB->(IndexKey()))

		cQuery := ChangeQuery(cQuery)

		dbSelectArea("ADB")
		dbCloseArea()

		dbUseArea(.T.,cAliasADB,TcGenQry(,,cQuery),cAliasADB,.T.,.T.)
        
		For nX := 1 To Len(aStruADB)
			If aStruADB[nX][2]<>"C"
				TcSetField(cAliasADB,aStruADB[nX][1],aStruADB[nX][2],aStruADB[nX][3],aStruADB[nX][4])
			EndIf
		Next nX
	Else
#ENDIF
	MsSeek(xFilial("ADB")+ADA->ADA_NUMCTR)
	#IFDEF TOP
	EndIf
	#ENDIF 
IF MsgYesNo('Deseja Criar o Titulo de Credito ao Cliente(NCC)?')  //cria titulo NCC
	u_iFIN001()
ENDIF
If lQuery
	dbSelectArea(cAliasADB)
	dbCloseArea()
	ChkFile("ADB",.F.)
EndIf
Begin Transaction
	If lEncerOk
		RecLock("ADA")
		cStatus := "E"
		(cAliasADA)->ADA_STATUS := cStatus
		MsUnLock()
	EndIf
End Transaction	
While (GetSx8Len() > nSaveSx8)
	RollBackSx8()
EndDo
MsUnLockAll()
RestArea(aArea)
Return(.T.)     

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³iFIN001   ³ Autor ³CARLOS DANIEL          ³ Data ³03.12.2013³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³DISTRATO CONTRATO DE PARCERIA                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³Rotina automatica para criar contas receber NCC             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ExpC1: Alias do arquivo                                     ³±±
±±³          ³ExpN2: Registro do Arquivo                                  ³±±
±±³          ³ExpN3: Opcao da MBrowse                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   DATA   ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³               ³                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
USER FUNCTION iFIN001()   //Cria NCC
LOCAL aArray := {}
LOCAL vRest := ADB->ADB_PRCVEN * (ADB->ADB_QUANT - ADB->ADB_QTDEMP) 
LOCAL cNUM  := ADB->ADB_NUMCTR
LOCAL cNATU := ADA->ADA_XNATUR
LOCAL cCLI  := ADB->ADB_CODCLI
LOCAL dBase := dDataBase
PRIVATE lMsErroAuto := .F.
 
aArray := { { "E1_PREFIXO"  , "CRT"             , NIL },;
            { "E1_NUM"      , cNUM              , NIL },;
            { "E1_TIPO"     , "NCC"             , NIL },;
            { "E1_NATUREZ"  , cNATU             , NIL },;
            { "E1_CLIENTE"  , cCLI              , NIL },;
            { "E1_EMISSAO"  , dBase             , NIL },;
            { "E1_VENCTO"   , dBase             , NIL },;
            { "E1_HIST"     , "DISTRATO DE CONTRATO", NIL },;
            { "E1_VALOR"    , vRest              , NIL }}
 
MsExecAuto( { |x,y| FINA040(x,y)} , aArray, 3)  // 3 - Inclusao, 4 - Alteração, 5 - Exclusão
If lMsErroAuto
    MostraErro()
	return()
Else
    MsgAlert("Título incluído com sucesso!")
Endif
 
Return