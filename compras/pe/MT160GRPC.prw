#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "TBICONN.CH"
#DEFINE CRLF CHR(13)+CHR(10)

/*
_____________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦Programa  ¦ MT160GRPC    ¦ Autor ¦ Carlos Daniel     ¦ Data ¦ 24/11/20 ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Descriçào ¦ Ponto de Entrada que responsavel por gravar campos pedido  ¦¦¦
¦¦¦          ¦ de vendas feito para atender ercal             . 		  ¦¦¦
¦¦¦          ¦                                                            ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Uso       ¦ Ercal Empresas Reunidas                              ¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
*/

User Function MT160GRPC()

If (Type("cForma") == "U")
	u_aBtela()
else
	SC7->C7_XFORMA  := cForma
EndIf
    SC1->(dbsetorder(1))
    SC1->(dbgotop())
    if SC1->(dbseek(xFilial("SC1")+SC8->C8_NUMSC))                   
		SC7->C7_XNATURE	:= SC1->C1_XNATURE
		SC7->C7_XDESNAT := SC1->C1_XDESNAT
		SC7->C7_XLOCAL  := SC1->C1_XLOCAL
//		SC7->C7_XFORMA  := cForma
	endif
Return

User Function aBtela()

local oButton1, oButton2
local oGroup1
local oSay1
local oGet1
local cGet1 := Space(9)
	
private oDlg
private aArea := GetArea()

define msdialog oDlg title "Escolha Forma Pagamento" from 000,000 to 200,500 colors 0,16777215 pixel
		
	@002,003 group oGroup1 to 095,246 prompt " Forma Pagamento " of oDlg color 0,16777215 pixel
	@015,008 say oSay1 prompt "FORMA" size 025,007 of oDlg colors 0,16777215 pixel
	@014,053 msget oGet1 var cGet1 size 045,010 of oDlg colors 0,16777215 F3 "99" pixel
			
	@050,167 button oButton1 prompt "Salvar" size 037,012 of oDlg action Salvar(cGet1) pixel
	@050,208 button oButton2 prompt "Cancelar" size 037,012 of oDlg action oDlg:End() pixel
activate msdialog oDlg centered

If (Type("cForma") == "U")
	Return
EndIF

Return (cForma)

static function Salvar(cGet1)
Public cForma
if !empty(cGet1)
	cForma := TRIM(cGet1)
	SC7->C7_XFORMA  := TRIM(cGet1)
	RestArea(aArea)
	oDlg:End()
	return (cForma)
else
	cForma := ' '
	RestArea(aArea)
	oDlg:End()
	return (cForma)
EndIf

Return
