/*______________________________________________________________________
   ¦Autor     ¦ Carlos Daniel                       ¦ Data ¦ 19/10/23 ¦
   +----------+-------------------------------------------------------¦
   ¦Descrição ¦ Cria Automaticamente Provisorio                      ¦
  ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
#include "protheus.ch"
#include "topconn.ch"

user function criapr()
	local oButton1, oButton2
	local oGroup1, oGroup2
	local oSay1, oSay2, oSay4, oSay5, oSay6, oSay7, oSay8
	local oGet1, oGet2, oGet3, oGet4, oGet5, oGet6, oGet7, oGet8
	local cGet1 := 0
	local cGet2 := Space(70)
	local cGet3 := 0
	local cGet4 := CTOD("  /  /    ")
	local cGet5 := Space(20)
	local cGet6 := CTOD("  /  /    ")
    //Local cGet7 := "033"
    
    //Local cGet9 := "13000003"
    Local cNum  := " "
	Private cGet8 := SPACE(8)
	//local lValid := .T.
	private oDlg
	private aArea := GetArea()
	//valida se existe o pedido
	If FunName() == "MATA121"
		cNum  := SC7->C7_NUM
		//cGet8 := SPACE(8)
		//posicionando no produto
		DbSelectArea("SB1")
		SB1->(DbSetOrder(1))
		SB1->(DbSeek(xFilial("SB1")+SC7->C7_PRODUTO))
		//IF SB1->B1_GRUPO $ '0056/0056/0057/0058/0059/0060/0061/0066'
			//cGet8 := "02010115"
		//EndIf
		if Empty(cNum)
	   		MsgAlert("Nao foi selecionado nenhum pedido de compra para Incluir o PR.")			
	    	return
    	endif
		dbSelectArea("SE2")
		dbSetOrder(1)
		dbSeek(xFilial()+"PRC"+"PR"+cNum)
		//valida se ja existe PR no financeiro
    	if !Empty(trim(SE2->E2_NUM))
	   	 	MsgAlert("Existe titulo no financeiro ja cadastrado, favor verificar com Financeiro")			
	    	return
    	endif

		if Select("TMP") <> 0
			TMP->(DbCloseArea())
		endif
	
		cQry := "select SUM((c7_total+c7_frete+c7_seguro+c7_despesa)) as valor from "+RetSqlName("SC7")+" where C7_NUM = '"+SC7->C7_NUM+"' and D_E_L_E_T_ <> '*' AND c7_fornece = '"+SC7->c7_fornece+"' and C7_FILIAL = '"+xFilial("SC7")+"'"
	
		tcquery cQry new alias "TMP"
	
		DbSelectArea("TMP")
		TMP->(DbGoTop())
	
    		dbSelectArea("SA2")                // * Cadastro de Fornecedores
			dbSetOrder(1)
			dbSeek(xFilial("SA2")+SC7->c7_fornece+SC7->c7_loja)

			cGet1 := TMP->valor
        	cGet3 := TMP->valor
			cGet2 := SA2->A2_NOME 
			cGet4 := Date()+30
			cGet5 := SA2->A2_NREDUZ
        	cGet6 := Date()
        	
	Else
	// se for Contrato Entra aqui
		cNum  := ADA->ADA_NUMCTR
		//cGet8 := "220101"
		//posicionando no produto
		DbSelectArea("SB1")
		SB1->(DbSetOrder(1))
		SB1->(DbSeek(xFilial("SB1")+ADB->ADB_CODPRO))
		IF SB1->B1_GRUPO $ '0056/0056/0057/0058/0059/0060/0061/0066'
			cGet8 := "01010903"
		ELSEIF SB1->B1_GRUPO = '0062'
			cGet8 := "01010901"
		ELSEIF SB1->B1_GRUPO = '0063'
			cGet8 := "01010902"
		ELSEIF SB1->B1_GRUPO = '0085'
			cGet8 := "01010910"
		ELSEIF SB1->B1_GRUPO = '0106'
			cGet8 := "01010902"
		Else
			cGet8 := SPACE(8)
		EndIf
		if Empty(cNum)
	    	MsgAlert("Nao foi selecionado nenhum pedido de compra para Incluir o PR.")			
	    	return
    	endif
		dbSelectArea("SE1")
		dbSetOrder(1)
		dbSeek(xFilial()+"PRC"+"PR"+cNum)
		//valida se ja existe PR no financeiro
    	if !Empty(trim(SE1->E1_NUM))
	    	MsgAlert("Existe titulo no financeiro ja cadastrado, favor verificar com Financeiro")			
	    	return
    	endif

		if Select("TMP") <> 0
			TMP->(DbCloseArea())
		endif
	
		cQry := "select sum(ADB_TOTAL) as valor from "+RetSqlName("ADB")+" ADB where ADB.D_E_L_E_T_ <> '*' AND adb_numctr = '"+ADA->ADA_NUMCTR+"' and ADB_FILIAL = '"+xFilial("ADB")+"'"

		tcquery cQry new alias "TMP"
	
		DbSelectArea("TMP")
		TMP->(DbGoTop())
	
    		dbSelectArea("SA1")                // * Cadastro de Fornecedores
			dbSetOrder(1)
			dbSeek(xFilial("SA1")+ADA->ADA_CODCLI+ADA->ADA_LOJCLI)

			cGet1 := TMP->valor
			cGet2 := SA1->A1_NOME 
			cGet3 := TMP->valor
			cGet4 := Date()+30
			cGet5 := SA1->A1_NREDUZ
        	cGet6 := Date()
        	
	EndIf
	
		define msdialog oDlg title "Cria Titulo PR" from 000,000 to 340,500 colors 0,16777215 pixel
			@002,003 group oGroup1 to 047,246 prompt " Informacoes PC " of oDlg color 0,16777215 pixel
			@015,008 say oSay1 prompt "VALOR" size 045,007 of oDlg colors 0,16777215 pixel
			@014,053 msget oGet1 var cGet1 Picture "@E 999,999,999.99" size 045,010 of oDlg colors 0,16777215 when .F. pixel
			@015,102 say oSay6 prompt "N. FANTASIA" size 039,007 of oDlg colors 0,16777215 pixel
			@014,142 msget oGet5 var cGet5 size 097,010 of oDlg colors 0,16777215 when .F. pixel
			@032,008 say oSay2 prompt "RAZAO SOCIAL" size 045,007 of oDlg colors 0,16777215 pixel
			@030,053 msget oGet2 var cGet2 size 187,010 of oDlg colors 0,16777215 when .F. pixel
//dados titulo			
			@050,003 group oGroup2 to 095,246 prompt " Titulo PR " of oDlg color 0,16777215 pixel
			@062,008 say oSay4 prompt "Valor" size 025,007 of oDlg colors 0,16777215 pixel
			@060,053 msget oGet3 var cGet3 Picture "@E 999,999,999.99" size 060,010 of oDlg colors 0,16777215 pixel
			@062,120 say oSay7 prompt "Emissao" size 039,007 of oDlg colors 0,16777215 pixel
			@060,155 msget oGet6 var cGet6 Picture "99/99/9999" size 060,010 of oDlg colors 0,16777215 when .F. pixel
			@078,008 say oSay5 prompt "Pagamento:" size 045,007 of oDlg colors 0,16777215 pixel
			@077,053 msget oGet4 var cGet4 Picture "99/99/9999" size 060,010 of oDlg colors 0,16777215  pixel
			@078,120 say oSay8 prompt "Natureza:" size 045,007 of oDlg colors 0,16777215 pixel
			@077,155 msget oGet8 var cGet8 size 060,010 of oDlg colors 0,16777215 F3 "SED" pixel

			@151,167 button oButton1 prompt "Incluir" size 037,012 of oDlg action Incpr(cGet3,cGet6,cGet4,cGet1,cGet8) pixel
			@151,208 button oButton2 prompt "Cancelar" size 037,012 of oDlg action oDlg:End() pixel
		activate msdialog oDlg centered
    TMP->(DbCloseArea())
return

static function Incpr(vAlor,dEmissao,dVencto,nValor,cGet8)
LOCAL aArray := {}	
Local cNum   := " "
//Local cGet8
PRIVATE lMsErroAuto := .F.
//valida valor nao pode ser maior que o Pedido
If FunName() == "MATA121"
	cNum   := SC7->C7_NUM
	//cGet8 := SC7->C7_XNATURE
Else
	cNum   := ADA->ADA_NUMCTR
	//cGet8 := ADA->ADA_XNATUR
EndIf

If vAlor > nValor
	MsgAlert("Valor informado é SUPERIOR negociação, não é Permitido!")
	RestArea(aArea)
	oDlg:End()
	return
EndIf

If FunName() == "MATA121"
//valida se esta aprovado
   
	If SC7->C7_QUJE>=SC7->C7_QUANT .AND. Empty(SC7->C7_RESIDUO) .AND.Empty(SC7->C7_CONTRA) .AND. SC7->C7_CONAPRO<>"B"
		MsgAlert("Pedido ja Encerrado não possivel gerar PR.")
		RestArea(aArea)
		oDlg:End()
		return
	ElseIf SC7->C7_ACCPROC<>"1" .And.  SC7->C7_CONAPRO=="B" .And. SC7->C7_QUJE < SC7->C7_QUANT .AND. Empty(SC7->C7_RESIDUO)
		MsgAlert("Pedido não aprovado, apenas pedidos aprovados podem ser gerado PR.")
		RestArea(aArea)
		oDlg:End()
		return
	ElseIf !Empty(SC7->C7_CONTRA).And.Empty(SC7->C7_RESIDUO)
		MsgAlert("Pedido Gerado por Contrato não precisa PR.")
		RestArea(aArea)
		oDlg:End()
		return
	ElseIf !Empty(SC7->C7_RESIDUO)
		MsgAlert("Pedido com residuo eliminado não pode ser gerado PR.")
		RestArea(aArea)
		oDlg:End()
		return
	ElseIf Empty(cGet8)
		MsgAlert("Pedido sem Natureza, Preencher a Natureza Financeira.")
		RestArea(aArea)
		oDlg:End()
		return
	EndIf
  
	aArray := {}
	aAdd(aArray, {"E2_FILIAL",  FWxFilial("SE2"),           Nil})
	aAdd(aArray, {"E2_NUM",     "PR"+cNum,                  Nil})
	aAdd(aArray, {"E2_PREFIXO", "PRC",                      Nil})
	aAdd(aArray, {"E2_TIPO",    "PR",                       Nil})
	aAdd(aArray, {"E2_NATUREZ", cGet8,           			Nil})
	aAdd(aArray, {"E2_FORNECE", SC7->C7_FORNECE,            Nil})
	aAdd(aArray, {"E2_LOJA",    SC7->C7_LOJA,               Nil})
	aAdd(aArray, {"E2_EMISSAO", dEmissao,                   Nil})
	aAdd(aArray, {"E2_VENCTO",  dVencto,                    Nil})
	aAdd(aArray, {"E2_VALOR",   vAlor,                      Nil})
	aAdd(aArray, {"E2_HIST", "GERADO PELO PC "+cNum,        Nil})
	aAdd(aArray, {"E2_CCD",     SC7->C7_CC,                 Nil})
	//quando incluir PA tem que ter adicao abaixo para vincular bancos
	//aAdd(aArray, {"AUTBANCO",   cBc,                        Nil})
	//aAdd(aArray, {"AUTAGENCIA", cAg,                        Nil})
	//aAdd(aArray, {"AUTCONTA",   cCc,                        Nil})		

	SC7->(DbGoTop())
		
	if SC7->(MsSeek(xFilial("SC7")+cNum,.F.))
    	//Inicia o controle de transação
    	Begin Transaction
    	//Chama a rotina automática

    	MSExecAuto({|x,y| FINA050(x,y)}, aArray, 3)

    	//Se houve erro, mostra o erro ao usuário e desarma a transação
    	If lMsErroAuto
        	MostraErro()
        	DisarmTransaction()
    	Else
        	MsgAlert("Título Provisorio: "+"PR"+cNum+", incluído com sucesso!")
    	Endif
    	//Finaliza a transação
    	ConfirmSx8()
    	End Transaction

	endif

Else
	If ADA->ADA_STATUS == "C" .OR. ADA->ADA_STATUS == "E" .OR. ADA->ADA_STATUS == "D"
		MsgAlert("Apenas Contrato Aberto e ou aprovado são permitidos.")
		RestArea(aArea)
		oDlg:End()
		return
	ElseIf Empty(cGet8)
		MsgAlert("Contrato sem Natureza, Preencher a Natureza Financeira.")
		RestArea(aArea)
		oDlg:End()
		return
	EndIf
  
	aArray := { { "E1_FILIAL"   , ADA->ADA_FILIAL   , NIL },;
            	{ "E1_PREFIXO"  , "PRC"             , NIL },;
            	{ "E1_NUM"      , "PR"+cNum         , NIL },;
            	{ "E1_TIPO"     , "PR"              , NIL },;
            	{ "E1_NATUREZ"  , cGet8			    , NIL },;
            	{ "E1_CLIENTE"  , ADA->ADA_CODCLI   , NIL },;
            	{ "E1_LOJA"     , ADA->ADA_LOJCLI   , NIL },;
            	{ "E1_EMISSAO"  , dEmissao          , NIL },;
            	{ "E1_VENCTO"   , dVencto           , NIL },;
            	{ "E1_HIST"    , "GERADO PELO CTR "+cNum, NIL },;
            	{ "E1_VALOR"    , vAlor             , NIL }}

	ADA->(DbGoTop())
		
	if ADA->(MsSeek(xFilial("ADA")+cNum,.F.))
    //Inicia o controle de transação
    	Begin Transaction
    //Chama a rotina automática

    	MSExecAuto({|x,y| FINA040(x,y)}, aArray, 3)

    //Se houve erro, mostra o erro ao usuário e desarma a transação
    	If lMsErroAuto
        	MostraErro()
        	DisarmTransaction()
    	Else
        	MsgAlert("Título Provisorio: "+"PR"+cNum+", incluído com sucesso!")
    	Endif
    //Finaliza a transação
    	ConfirmSx8()
    	End Transaction

	endif
EndIf
RestArea(aArea)
oDlg:End()

return
