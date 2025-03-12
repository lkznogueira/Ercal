#include "Protheus.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³TMCalFre  ºAutor  ³Adeilton/Athos      º Data ³  13/03/18   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ PE para manipulação do cálculo do CTRC                     º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function TMCALFRE()

//Recupera o array contendo os campos passado através do Ponto de Entrada
Local aParam := PARAMIXB

//Array utilizado para passar os components a serem calculados e seus respectivos valores
Local aRet := {}

//-- Parametros passados para o ponto de entrada PARAMIXB
//-- [01] = Vetor com a composicao do frete
//-- [02 ate 17] = Base de calculo
//-- [18] = Codigo do cliente devedor (pode estar em branco quando calculado pelo generico ou sem ajuste)
//-- [19] = Loja do cliente devedor (pode estar em branco quando calculado pelo generico ou sem ajuste)
//-- [20] = Codigo da regiao de origem
//-- [21] = Codigo da regiao de destino
//-- [22] = Codigo do produto
//-- [23] = Codigo do servico de negociacao
//-- [24] = Tabela de Frete
//-- [25] = Tipo da Tabela de Frete
//-- [26] = Sequencia da Tabela de Frete
//-- [27] = Dias de Armazenagem
//-- [28] = Notas Fiscais (aNfCTRC)
//-- [29] = Numero do Lote
//-- [30] = Codigo do cliente devedor original
//-- [31] = Loja do cliente devedor original

Local nOpca:=0
Local _nValFrete:=0
Local _nCount:=1
Local nFracao := 1000
Local _cPrgInst:=FunName()

//If (Alltrim(_cPrgInst) == 'TMSA200')
If  MsgYesNo('Deseja informar Valor Frete destinatario diferente:?')
	DEFINE MSDIALOG oDlg TITLE "Valor para cálculo do frete." FROM 09,0 TO 17,38
	
	DEFINE FONT oBold NAME 'Arial'	SIZE  0,-13 BOLD
	@ 03, 10 SAY "Valor Frete destinatario diferente:" SIZE 160, 16 OF oDlg PIXEL
	
	@ 21, 53 MSGET oGet1 VAR _nValFrete Picture "@E 999,999,999.9999" SIZE 060, 10 OF oDlg PIXEL
	//@ 30, 53 MSGET oGet1 VAR _nValDes Picture PesqPict("DTC","DTC_VALOR") SIZE 060, 10 OF oDlg PIXEL
	
	DEFINE SBUTTON oBut1 FROM 50, 65	TYPE 1 ACTION ( nOpca := 1,oDlg:End() ) ENABLE OF oDlg
	DEFINE SBUTTON oBut2 FROM 50, 97	TYPE 2 ACTION ( nOpca := 0,oDlg:End() ) ENABLE OF oDlg
	
	ACTIVATE MSDIALOG oDlg CENTERED
	If !empty(aParam[24])
		If nOpca == 1
				//[01][01][02]
		aParam[01][_nCount][02]:=_nValFrete*(aParam[04]/nFracao)
		aAdd(aRet,{aParam[01][_nCount][03],aParam[01][_nCount][02]})
		_nCount+=_nCount
		//aParam[01][02][02]:=_nValDes
		EndIf
	EndIf
EndIf

If  MsgYesNo('Deseja informar Valor Frete fixo do frete')
	DEFINE MSDIALOG oDlg TITLE "Valor para cálculo do frete." FROM 09,0 TO 17,38
	
	DEFINE FONT oBold NAME 'Arial'	SIZE  0,-13 BOLD
	@ 03, 10 SAY "Valor Frete fixo:" SIZE 160, 16 OF oDlg PIXEL
	
	@ 21, 53 MSGET oGet1 VAR _nValFrete Picture "@E 999,999,999.9999" SIZE 060, 10 OF oDlg PIXEL
	//@ 30, 53 MSGET oGet1 VAR _nValDes Picture PesqPict("DTC","DTC_VALOR") SIZE 060, 10 OF oDlg PIXEL
	
	DEFINE SBUTTON oBut1 FROM 50, 65	TYPE 1 ACTION ( nOpca := 1,oDlg:End() ) ENABLE OF oDlg
	DEFINE SBUTTON oBut2 FROM 50, 97	TYPE 2 ACTION ( nOpca := 0,oDlg:End() ) ENABLE OF oDlg
	
	ACTIVATE MSDIALOG oDlg CENTERED
	If !empty(aParam[24])
		If nOpca == 1
				//[01][01][02]
		aParam[01][_nCount][02]:=_nValFrete
		aAdd(aRet,{aParam[01][_nCount][03],aParam[01][_nCount][02]})
		_nCount+=_nCount
		//aParam[01][02][02]:=_nValDes
		EndIf
	EndIf
EndIf
//If Len(aParam[01]) > 0
//For _nCount := 1 To Len(aParam[01])
//aAdd(aRet,{aParam[01][_nCount][03],aParam[01][_nCount][02]})
//Next _nCount
//EndIf
//EndIf
Return aRet
