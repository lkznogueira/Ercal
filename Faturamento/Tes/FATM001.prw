#include "protheus.ch"
#include "topconn.ch"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �FATM001  �Autor  �INOVARE              � Data �  24/10/13   ���
�������������������������������������������������������������������������͹��
���Desc.     �  Funcao para retornar a TES INTELIGENTE                    ���
���          �  no contrato de parceria                                   ���
�������������������������������������������������������������������������͹��
���ALTERADO  � CARLOS DANIEL                                              ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function FATM001(lCobr)       
                                                                      	

Local _cCod := aCols[1,2] 
Local cOper := M->ADB_XTIPO
LOCAL cEmpAnt := SM0->M0_CODIGO
PRIVATE _cTES := ''

Default lCobr := .F.

//valida caso o codigo do produto nao tenha sido informado
IF !Empty(_cCod) .OR. _cCod <> NIl
    if !lCobr
		_cTES:= MaTesInt(2,cOper,M->ADA_CODCLI,M->ADA_LOJCLI,"C",_cCod,NIL)
		If cEmpAnt == '50'
			If M->ADA_MSBLQL == "2" .AND. M->ADA_XLIBFI == "2"
				M->ADA_MSBLQL := "1"
				MsgAlert("Contrato Bloqueado, Falta aprova��o Financeira na rotina APROVA CTR")
			EndIf
			U_TesDesc()// chama rotina para AJUSTE DE ICMS DEPOIS DE DIGITAR TIPO OPERACAO CONTRATO
		EndIf
	else  //Venda
		if	cOper == '55' //REMESSA ENTREGA FUTURA 
			If cEmpAnt <> '50' 
				_cTES := '527'
			Else
				_cTES := MaTesInt(2,'02',M->ADA_CODCLI,M->ADA_LOJCLI,"C",_cCod,NIL)	
			EndIf
		elseif cOper == '82' //REMESSA VENDA A ORDEM
			_cTES := MaTesInt(2,'80',M->ADA_CODCLI,M->ADA_LOJCLI,"C",_cCod,NIL)		                                            
		elseif cOper == '85' //REMESSA VENDA A ORDEM entrega futura
			If cEmpAnt <> '50' 
				_cTES := '527'
			Else
				_cTES := MaTesInt(2,'02',M->ADA_CODCLI,M->ADA_LOJCLI,"C",_cCod,NIL)	
			EndIf                                           
		endif 	 
	endif
ELSE
	 MsgAlert('Favor Escolher Produto')
ENDIF

Return _cTES
