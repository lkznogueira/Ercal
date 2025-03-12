#INCLUDE "rwmake.ch"
#INCLUDE "protheus.ch"
#INCLUDE "topconn.ch"

/*/

Autor: Unknow
Data: Unknow
Descrição: Rotina para limpeza de flag

/*/

User Function LIMPFLG
Local oButton1
Local oButton2
Local oSay1
PRivate oComboBo
Private nComboBo := ""


Private oDlg

DEFINE MSDIALOG oDlg TITLE "Limpa Flag Contabilização" FROM 000, 000  TO 250, 400 COLORS 0, 16777215 PIXEL

@ 017, 009 SAY oSay1 PROMPT "Modulo: " SIZE 024, 012 OF oDlg COLORS 0, 16777215 PIXEL
@ 018, 036 MSCOMBOBOX oComboBo VAR nComboBo ITEMS {" ","Compras","Faturamento","Contas a Pagar", "Contas a Receber", "Movimento Bancario", "Aplicacao/Emprestimo"} SIZE 100, 010 OF oDlg COLORS 0, 16777215 PIXEL //WHEN lLComTip

@ 087, 012 BUTTON oButton1 PROMPT "Cancelar" Action (oDlg:End()) SIZE 041, 013 OF oDlg PIXEL
@ 087, 142 BUTTON oButton2 PROMPT "Confirmar" ACTION (Eval({|| SELMOD()})) SIZE 041, 013 OF oDlg PIXEL

ACTIVATE MSDIALOG oDlg CENTERED

return


/*/

Autor: Unknow
Data: Unknow
Descrição: Rotina que irá trazer os itens que serão trabalhados.

/*/

Static Function SELMOD()  

Local _lSEZ := .F. 
Private cOpcMenu := '' 
Private cCadastro
Private cDelFunc
Private aRotina := { {"Pesquisar","AxPesqui",0,1} ,;
					 {"Visualizar","AxVisual",0,2} ,;  
					 {"Legenda","U_Legen()",0,3} ,;
					 {"Limpar Flag","U_LMPFLG(nComboBo)",0,4} }


While Empty(Alltrim(nComboBo))
	Alert("Modulo não selecionado!")
	return
EndDo

IF Alltrim(nComboBo) == "Compras"
	dbSelectArea("SF1")
	dbSetOrder(1)
	mBrowse( 6,1,22,75,"SF1",,,,,,{{"Empty(F1_DTLANC)","BR_VERDE"},{"!Empty(F1_DTLANC)","BR_VERMELHO"}} ,,,,,,.T.,.T.,,,,)
	
ElseIF Alltrim(nComboBo) == "Faturamento"
	dbSelectArea("SF2")
	dbSetOrder(1)
	mBrowse( 6,1,22,75,"SF2",,,,,,{{"Empty(F2_DTLANC)","BR_VERDE"},{"!Empty(F2_DTLANC)","BR_VERMELHO"}} ,,,,,,.T.,.T.,,,,)
	
ElseIF Alltrim(nComboBo) == "Contas a Receber"
	dbSelectArea("SE1")
	dbSetOrder(1)
	mBrowse( 6,1,22,75,"SE1",,,,,,{{"Empty(E1_LA)","BR_VERDE"},{"!Empty(E1_LA)","BR_VERMELHO"}} ,,,,,,.T.,.T.,,,,)
	
ElseIF Alltrim(nComboBo) == "Contas a Pagar"
	dbSelectArea("SE2")
	dbSetOrder(1)
	mBrowse( 6,1,22,75,"SE2",,,,,,{{"Empty(E2_LA)","BR_VERDE"},{"!Empty(E2_LA)","BR_VERMELHO"}} ,,,,,,.T.,.T.,,,,)
ElseIF Alltrim(nComboBo) == "Movimento Bancario"
	dbSelectArea("SE5")
	dbSetOrder(1)
	mBrowse( 6,1,22,75,"SE5",,,,,,{{"Empty(E5_LA)","BR_VERDE"},{"!Empty(E5_LA)","BR_VERMELHO"}} ,,,,,,.T.,.T.,,,,)    
ElseIF Alltrim(nComboBo) == "Aplicacao/Emprestimo"
	dbSelectArea("ZE6")
	dbSetOrder(1)
	mBrowse( 6,1,22,75,"ZE6",,,,,,{{"Empty(ZE6_LA)","BR_VERDE"},{"!Empty(ZE6_LA)","BR_VERMELHO"}} ,,,,,,.T.,.T.,,,,)	
EndIF                                                                                                              


return

/*/

Autor: Unknow
Data: Unknow
Descrição: Rotina que executa a limpeza do flag

/*/

User Function LMPFLG(nComboBo)

IF Alltrim(nComboBo) == "Compras"
	
	RecLock("SF1",.F.)
	SF1->F1_DTLANC = STOD('        ')
	MsUnlock()
	
ElseIF Alltrim(nComboBo) == "Faturamento"
	RecLock("SF2",.F.)
	SF2->F2_DTLANC = STOD('        ')
	MsUnlock()
	
ElseIF Alltrim(nComboBo) == "Contas a Receber"
	RecLock("SE1",.F.)
	SE1->E1_LA = ' '
	MsUnlock()
	
ElseIF Alltrim(nComboBo) == "Contas a Pagar"
	RecLock("SE2",.F.)
	SE2->E2_LA = ' '
	MsUnlock()
	IF SE2->E2_MULTNAT == '1' ///Rateio Multi Natureza (SEV)   
		dbSelectArea("SEV")
		SEV->(dbSetOrder(1)) ////EV_FILIAL+EV_PREFIXO+EV_NUM+EV_PARCELA+EV_TIPO+EV_CLIFOR+EV_LOJA+EV_NATUREZ 
		WHILE SEV->(dbSeek(SE2->(E2_MSFIL+E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO+E2_FORNECE+E2_LOJA)))
			IF SEV->EV_IDENT == '1'   ////SOMENTE AS INCLUSOES.     
				RecLock("SEV",.F.)
					SEV->EV_LA = ' '
				MsUnlock()
			EndIF           
			IF SEV->EV_RATEICC == '1'   
				_lSEZ:= .T.
			EndIF
			SEV->(DBSKIP())
		ENDDO        
		IF _lSEZ    ///Distribuicao CC por Multi Natureza
	   		dbSelectArea("SEZ")
	   		SEZ->(dbSetOrder(1)) ////EZ_FILIAL+EZ_PREFIXO+EZ_NUM+EZ_PARCELA+EZ_TIPO+EZ_CLIFOR+EZ_LOJA+EZ_NATUREZ+EZ_CCUSTO 
			WHILE SEZ->(dbSeek(SE2->(E2_MSFIL+E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO+E2_FORNECE+E2_LOJA)))
				IF SEZ->EZ_IDENT == '1'
					RecLock("SEZ",.F.)
						SEZ->EZ_LA = ' '
					MsUnlock() 
				EndIF
				SEZ->(dbSkip())
			EndDo	   	
	   	EndIF
	EndIF
ElseIF Alltrim(nComboBo) == "Movimento Bancario"
	RecLock("SE5",.F.)
	SE5->E5_LA = ' '
	MsUnlock() 
	IF SE5->E5_RECPAG == 'P' .and. Alltrim(SE5->E5_TIPODOC) <> 'ES' 
		dbSelectArea("SE2") 
		IF Alltrim(Posicione("SE2",1,SE5->(E5_MSFIL+E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+E5_CLIFOR+E5_LOJA), "E2_MULTNAT")) == "1"
			//IF SE2->E2_MULTNAT == "1" ///Rateio Multi Natureza (SEV)   
				dbSelectArea("SEV")
				SEV->(dbSetOrder(1)) ////EV_FILIAL+EV_PREFIXO+EV_NUM+EV_PARCELA+EV_TIPO+EV_CLIFOR+EV_LOJA+EV_NATUREZ 
				WHILE SEV->(dbSeek(SE2->(E2_MSFIL+E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO+E2_FORNECE+E2_LOJA)))
					IF SEV->EV_IDENT == "2"   ////SOMENTE AS BAIXAS.     
						RecLock("SEV",.F.)
							SEV->EV_LA = ' '
						MsUnlock()
					EndIF           
					IF SEV->EV_RATEICC == "1"   
						_lSEZ:= .T.
					EndIF
					SEV->(DBSKIP())
				ENDDO        
				IF _lSEZ    ///Distribuicao CC por Multi Natureza
			   		dbSelectArea("SEZ")
			   		SEZ->(dbSetOrder(1)) ////EZ_FILIAL+EZ_PREFIXO+EZ_NUM+EZ_PARCELA+EZ_TIPO+EZ_CLIFOR+EZ_LOJA+EZ_NATUREZ+EZ_CCUSTO 
					WHILE SEZ->(dbSeek(SE2->(E2_MSFIL+E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO+E2_FORNECE+E2_LOJA)))
						IF SEZ->EZ_IDENT == "1"
							RecLock("SEZ",.F.)
								SEZ->EZ_LA = ' '
							MsUnlock() 
						EndIF 
						SEZ->(dbSkip())
		   			EndDo	  	
			   	EndIF
			//EndIF
		EndIF
	EndIF
ElseIF Alltrim(nComboBo) == "Aplicacao/Emprestimo"
	RecLock("ZE6",.F.)
	ZE6->ZE6_LA = ' '
	MsUnlock() 			
	
EndIF  
	SE2->(dbCloseArea())
	Alert("Finalizado!")   	
return


/*/

Autor: Unknow
Data: Unknow
Descrição: Rotina de legenda

/*/


User Function Legen()
Local _aLegenda := {}

Aadd(_aLegenda, {"BR_VERMELHO" ,"Marcado (flag)"})
Aadd(_aLegenda, {"BR_VERDE"    ,"Desmarcado (flag)"})

BrwLegenda(cCadastro, "Legenda", _aLegenda)

Return(.T.) 