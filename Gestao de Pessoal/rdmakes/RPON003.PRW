#include "rwmake.ch"
#include "topconn.ch"
#include "Protheus.ch"
/*/
�����������������������������������������������������������������������������������������������������
�����������������������������������������������������������������������������������������������������
�������������������������������������������������������������������������������������������������ͻ��
���Programa  �  RPON003   � Autor                                        �  Data   �   13/12/13   ���
�������������������������������������������������������������������������������������������������͹��
���Descricao � Personaliza��o do banco de horas.                                                  ���
���          � Se o resultado do banco de horas for POSITIVO                                      ���
���          �      Apaga as verbas de provento e desnconto da tabela SPB.                        ���
���          �      Gera o verba provento com SALDO BANCO DE HORAS na tabela SPB.                 ���
���          �                                                                                    ���
���          � Se o resultado do banco de horas for NEGATIVO                                      ���
���          �      Apaga as verbas de provento e desconto da tabela SPB.                         ���
���          �                                                                                    ���
���          � Se o resultado for ZERO.                                                           ���
���          �      Apaga as verbas de provento e desconto da tabela SPB.                         ���
���          �                                                                                    ���
�������������������������������������������������������������������������������������������������ͻ��
���Alteracao �  RPON003   � Autor  � Frederico O. C. Jr                  �  Data   �   28/12/09   ���
�������������������������������������������������������������������������������������������������͹��
���Descricao � Alteracao para considerar a filial do funcionario                                  ���
���          � Alteracao para considerar verbas distintas entre as filiais                        ���
���          �                                                                                    ���
���          � Acertos no tratamento do fonte                                                     ���
���          �                                                                                    ���
�������������������������������������������������������������������������������������������������͹��
���Uso       � AP10                                                                               ���
�������������������������������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������������������������������
�����������������������������������������������������������������������������������������������������
/*/
	User Function RPON003
	Local _nHoras		:= 0
	Local _cCodVbP		:= ""
	Local _cCodVbD		:= ""
	Local _cCodEvt		:= ""
	Local _cQuery		:= ""
	
	Private cPerg		:= "BCH001"
	
//	U_FDocElet("PON","RPON003","U_RPON003","Personaliza��o do banco de horas","12/05/2008")
	
	ValidPerg(cPerg)                                                  
	
	if !Pergunte(cPerg)
		return
	endif

	// Cria tabela tempor�ria.
	_cQuery += " SELECT RA_FILIAL, RA_MAT"
	_cQuery += " FROM " + RetSqlName("SRA")
	_cQuery += " WHERE RA_FILIAL BETWEEN '" + mv_par01 + "' AND '" + mv_par02 + "'"
	_cQuery += "   AND RA_MAT BETWEEN '" + mv_par03 + "' AND '" + mv_par04 + "'"
//	_cQuery += "   AND RA_SITFOLH <> 'D'"
	_cQuery += "   AND " + RetSqlName("SRA") + ".D_E_L_E_T_ = ' '"
	
	if Select("TRB") > 0
		dbSelectArea("TRB")
		dbCloseArea("TRB")
	endif
	TcQuery _cQuery New Alias "TRB"

	dbSelectArea("TRB")
	dbGoTop()
	While !TRB->(EOF())
	
		_nHoras := 0
		
		_cCodVbP	:= SuperGetMv("MV_XVERBAP", .T., "Parametro com a Verba de Provento n�o cadastrado!", TRB->RA_FILIAL)
		_cCodVbD	:= SuperGetMv("MV_XVERBAD", .T., "Parametro com a Verba de Desconto n�o cadastrado!", TRB->RA_FILIAL)
		_cCodEvt	:= SuperGetMv("MV_XEVENTO", .T., "Parametro com o c�digo do Evento n�o cadastrado!" , TRB->RA_FILIAL)
		
		// Retorna total de horas da verba 254 - Banco de Horas (provento)
		_nHoras += BCHRetorna(TRB->RA_FILIAL, TRB->RA_MAT, _cCodVbP)
		
		// Retorna total de horas da verba 470 - Banco de Horas (desconto)
		_nHoras -= BCHRetorna(TRB->RA_FILIAL, TRB->RA_MAT, _cCodVbD)
		
		// Apagas as verbas de provento e desconto
		ApagaVerbas(TRB->RA_FILIAL, TRB->RA_MAT, _cCodVbP, _cCodVbD)
		
		If _nHoras > 0
			// Gera verba de provento com o saldo do banco de horas
			GeraVerba( TRB->RA_FILIAL, TRB->RA_MAT, _cCodVbP, _nHoras)
		ElseIf _nHoras < 0
			// Gera evento com o saldo negativo do banco de horas
			// GeraEvento(TRB->RA_FILIAL, TRB->RA_MAT, MV_PAR05, _cCodEvt, _nHoras)
		EndIf
		
		dbSelectArea("TRB")
		dbSkip()
		
	EndDo
	dbSelectArea("TRB")
	dbCloseArea("TRB")

Return

/*/
�����������������������������������������������������������������������������������������������������
�����������������������������������������������������������������������������������������������������
�������������������������������������������������������������������������������������������������ͻ��
���Programa  � BCHRetorna � Autor  �   Cleiton Campos                    �  Data   �   12/05/08   ���
�������������������������������������������������������������������������������������������������͹��
���Descricao � Retorna a quantidade de horas para a verba.                                        ���
���          �                                                                                    ���
�������������������������������������������������������������������������������������������������ͻ��
���Alteracao � BCHRetorna � Autor  � Frederico O. C. Jr                  �  Data   �   28/12/09   ���
�������������������������������������������������������������������������������������������������͹��
���Descricao � Alteracao para considerar a filial do funcionario                                  ���
���          �                                                                                    ���
�������������������������������������������������������������������������������������������������͹��
���Uso       � AP10                                                                               ���
�������������������������������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������������������������������
�����������������������������������������������������������������������������������������������������
/*/
Static Function BCHRetorna(_cFilial, _cMat, _cCdVerba)

	Local _nRetorno := 0
	
	dbSelectArea("SPB")
	dbSetOrder(1)
	if ( dbSeek(_cFilial + _cMat + _cCdVerba) )
		_nRetorno := SPB->PB_HORAS
	EndIf
	
Return(_nRetorno)

/*/
�����������������������������������������������������������������������������������������������������
�����������������������������������������������������������������������������������������������������
�������������������������������������������������������������������������������������������������ͻ��
���Programa  �ApagaVerbas � Autor  �   Cleiton Campos                    �  Data   �   12/05/08   ���
�������������������������������������������������������������������������������������������������͹��
���Descricao � Elimina as verbas 254 e 470 do banco de horas.                                     ���
���          �                                                                                    ���
�������������������������������������������������������������������������������������������������ͻ��
���Alteracao �ApagaVerbas � Autor  � Frederico O. C. Jr                  �  Data   �   28/12/09   ���
�������������������������������������������������������������������������������������������������͹��
���Descricao � Alteracao para considerar a filial do funcionario                                  ���
���          � Alteracao para considerar verbas distintas entre filiais                           ���
���          �                                                                                    ���
�������������������������������������������������������������������������������������������������͹��
���Uso       � AP10                                                                               ���
�������������������������������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������������������������������
�����������������������������������������������������������������������������������������������������
/*/
Static Function ApagaVerbas(_cFilial, _cMat, _cVerbaP, _cVerbaD)

	dbSelectArea("SPB")
	dbSetOrder(1)

	if ( dbSeek(_cFilial + _cMat + _cVerbaP) )
		RecLock("SPB",.F.)
			dbdelete()
		MSUnlock()
	EndIf
	
	if ( dbSeek(_cFilial + _cMat + _cVerbaD) )
		RecLock("SPB",.F.)
			dbdelete()
		MSUnlock()
	EndIf

Return

/*/
�����������������������������������������������������������������������������������������������������
�����������������������������������������������������������������������������������������������������
�������������������������������������������������������������������������������������������������ͻ��
���Programa  � GeraVerba  � Autor  �                                     �  Data   �   13/12/13   ���
�������������������������������������������������������������������������������������������������͹��
���Descricao � Gera a verba 254 - SALDO BANCO DE HORAS com o saldo de horas.                      ���
���          �                                                                                    ���
�������������������������������������������������������������������������������������������������ͻ��
���Alteracao � GeraVerba  � Autor  � Frederico O. C. Jr                  �  Data   �   28/12/09   ���
�������������������������������������������������������������������������������������������������͹��
���Descricao � Alteracao para considerar a filial do funcionario                                  ���
���          � Alteracao para considerar verbas distintas entre filiais                           ���
���          �                                                                                    ���
�������������������������������������������������������������������������������������������������͹��
���Uso       � AP10                                                                               ���
�������������������������������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������������������������������
�����������������������������������������������������������������������������������������������������
/*/
Static Function GeraVerba(_cFilial, _cMat, _cVerba, _nHoras)

	Local _cCCusto		:= Posicione("SRA", 1, _cFilial + _cMat, "RA_CC")

	Private lMsErroAuto	:= .F.
	
	DbSelectArea("SPB")
	RecLock("SPB",.T.)
		SPB->PB_FILIAL		:= _cFilial
		SPB->PB_MAT			:= _cMat
		SPB->PB_PD			:= _cVerba
		SPB->PB_TIPO1		:= "H"
		SPB->PB_HORAS		:= _nHoras
		SPB->PB_VALOR		:= 0
		SPB->PB_DATA		:= dDataBase
		SPB->PB_CC			:= _cCCusto
		SPB->PB_PARCELA		:= 0
		SPB->PB_TIPO2		:= "M"
	MsUnLock()
	
Return

/*/
�����������������������������������������������������������������������������������������������������
�����������������������������������������������������������������������������������������������������
�������������������������������������������������������������������������������������������������ͻ��
���Programa  � GeraEvento � Autor  �   Cleiton Campos                    �  Data   �   12/05/08   ���
�������������������������������������������������������������������������������������������������͹��
���Descricao � Gera o evento 052.                                                                 ���
���          �                                                                                    ���
�������������������������������������������������������������������������������������������������ͻ��
���Alteracao � GeraVerba  � Autor  � Frederico O. C. Jr                  �  Data   �   28/12/09   ���
�������������������������������������������������������������������������������������������������͹��
���Descricao � Alteracao para considerar a filial do funcionario                                  ���
���          � Alteracao para considerar verbas distintas entre filiais                           ���
���          �                                                                                    ���
�������������������������������������������������������������������������������������������������͹��
���Uso       � AP10                                                                               ���
�������������������������������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������������������������������
�����������������������������������������������������������������������������������������������������
/*
Static Function GeraEvento(_cFilial, _cMat, _dData, _cEvento, _nHoras)

	Local _nResultHs	:= Int(Abs(_nHoras)) + (((Abs(_nHoras) - Int(abs(_nHoras))) * 60) / 100)
	Local _cCCusto		:= Posicione("SRA", 1, _cFilial + _cMat, "RA_CC")

	Private lMsErroAuto := .F.
	
	dbSelectArea("SPI")
	RecLock("SPI",.T.)
		SPI->PI_FILIAL	:= _cFilial
		SPI->PI_MAT		:= _cMat
		SPI->PI_DATA	:= _dData
		SPI->PI_PD		:= _cEvento
		SPI->PI_CC		:= _cCCusto
		SPI->PI_QUANT	:= _nResultHs
		SPI->PI_QUANTV	:= 0
		SPI->PI_FLAG	:= "G"
		//SPI->PI_STATUS	// EM BRANCO
		//SPI->PI_DTBAIX	// EM BRANCO
	MsUnlock()

Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �ValidPerg �Autor  �Cleiton Campos      � Data �  27/07/06   ���
�������������������������������������������������������������������������͹��
���Desc.     �Validar perguntas de usuario.                               ���
���          �                                                            ���
�������������������������������������������������������������������������ͻ��
���Programa  �ValidPerg �Autor  �Frederico O. C. Jr  � Data �  28/12/09   ���
�������������������������������������������������������������������������͹��
���Alteracao � Inclusao do tratamento da filial do funcionario            ���
���          � Inclusao de help nos parametros                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � MP10                                                       ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function ValidPerg()

	Local aHelpPor := {}

	//Filial
	Aadd( aHelpPor, 'Informe ou Selecione o C�digo da Filial do Funcion�rio ')
	PutSx1(cPerg,"01","Filial De ?"				,"","","mv_ch1","C",04,0,0,"G","","SM0","","","mv_par01","","","","","","","","","","","","","","","","",aHelpPor,aHelpPor,aHelpPor)
	PutSx1(cPerg,"02","Filial Ate ?"			,"","","mv_ch2","C",04,0,0,"G","","SM0","","","mv_par02","","","","","","","","","","","","","","","","",aHelpPor,aHelpPor,aHelpPor)

	aHelpPor := {}
	Aadd( aHelpPor, 'Informe ou Selecione o C�digo da Matricula do Funcion�rio ')
	PutSx1(cPerg,"03","Funcion�rio de ?"		,"","","mv_ch3","C",06,0,0,"G","","SRA","","","mv_par03","","","","","","","","","","","","","","","","",aHelpPor,aHelpPor,aHelpPor)
	PutSx1(cPerg,"04","Funcion�rio Ate ?"  		,"","","mv_ch4","C",06,0,0,"C","","SRA","","","mv_par04","","","","","","","","","","","","","","","","",aHelpPor,aHelpPor,aHelpPor)

	aHelpPor := {}
	Aadd( aHelpPor, 'Informe a Data Inicial do Desconto ')
	PutSx1(cPerg,"05","Desconto Dt.Inicial ?"	,"","","mv_ch5","D",08,0,0,"G","","   ","","","mv_par05","","","","","","","","","","","","","","","","",aHelpPor,aHelpPor,aHelpPor)

Return
