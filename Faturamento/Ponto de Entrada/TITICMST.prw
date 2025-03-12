#INCLUDE 'PROTHEUS.CH'
#include "TBICONN.CH"
#include "RWMAKE.CH"             
#include "TOPCONN.CH"
//ponto de entrada para ajustar data vencimento titulo 
//Carlos Daniel da Silva
User Function TITICMST()
Local cOrigem := PARAMIXB[1]
Local cTipoImp := PARAMIXB[2] 
Private dVENCTO := DATE()
Private oDlg
Private oVEnc
Private dVEnc := ctoD("  /  /    ")
Private oButton1
Private oGroup1
Private oSay1
If  AllTrim(cOrigem)=='MATA953' //Apuracao de ICMS
	cTipoImp := SF6->F6_TIPOIMP  
	If AllTrim(cTipoImp)=='3'
		 //msgalert('ST')          
		 DEFINE MSDIALOG oDlg TITLE "Informações complementares" FROM 000, 000  TO 100, 400 COLORS 0, 16777215 PIXEL
	    @ 002, 006 GROUP oGroup1 TO 045, 191 LABEL "DIGITE O VENCIMENTO PARA TITULO ST" OF oDlg COLOR 0, 16777215 PIXEL
    	@ 020, 011 SAY oSay1 PROMPT "Vencimento: " SIZE 035, 008 OF oDlg COLORS 0, 16777215 PIXEL
	    @ 018, 042 MSGET oVEnc VAR dVEnc SIZE 054, 010 OF oDlg COLORS 0, 16777215 PIXEL
    	@ 014, 117 BUTTON oButton1 PROMPT "Ok" SIZE 052, 016 Action (oDlg:End())  OF oDlg PIXEL
		  ACTIVATE MSDIALOG oDlg CENTERED   
		  SE2->E2_NUM := SE2->(Soma1(E2_NUM,Len(E2_NUM)))
		  SE2->E2_VENCTO 	:= DataValida(dVENCTO,.T.)
		  SE2->E2_VENCREA 	:= DataValida(dVENCTO,.T.)
	elseif AllTrim(cTipoImp) == '1'
		msgAlert('ICMS')   
	EndIf
endif 
Return {SE2->E2_NUM,SE2->E2_VENCTO}