#include "rwmake.ch"
#include "topconn.ch"
#include "Protheus.ch"
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออออหออออออออัอออออออออออออออออออออออออออออออออออออหอออออออออัออออออออออออออปฑฑ
ฑฑบPrograma  ณ  RPON003   บ Autor                                        บ  Data   ณ   13/12/13   บฑฑ
ฑฑฬออออออออออุออออออออออออสออออออออฯอออออออออออออออออออออออออออออออออออออสอออออออออฯออออออออออออออนฑฑ
ฑฑบDescricao ณ Personaliza็ใo do banco de horas.                                                  บฑฑ
ฑฑบ          ณ Se o resultado do banco de horas for POSITIVO                                      บฑฑ
ฑฑบ          ณ      Apaga as verbas de provento e desnconto da tabela SPB.                        บฑฑ
ฑฑบ          ณ      Gera o verba provento com SALDO BANCO DE HORAS na tabela SPB.                 บฑฑ
ฑฑบ          ณ                                                                                    บฑฑ
ฑฑบ          ณ Se o resultado do banco de horas for NEGATIVO                                      บฑฑ
ฑฑบ          ณ      Apaga as verbas de provento e desconto da tabela SPB.                         บฑฑ
ฑฑบ          ณ                                                                                    บฑฑ
ฑฑบ          ณ Se o resultado for ZERO.                                                           บฑฑ
ฑฑบ          ณ      Apaga as verbas de provento e desconto da tabela SPB.                         บฑฑ
ฑฑบ          ณ                                                                                    บฑฑ
ฑฑฬออออออออออัออออออออออออหออออออออัอออออออออออออออออออออออออออออออออออออหอออออออออัออออออออออออออปฑฑ
ฑฑบAlteracao ณ  RPON003   บ Autor  ณ Frederico O. C. Jr                  บ  Data   ณ   28/12/09   บฑฑ
ฑฑฬออออออออออุออออออออออออสออออออออฯอออออออออออออออออออออออออออออออออออออสอออออออออฯออออออออออออออนฑฑ
ฑฑบDescricao ณ Alteracao para considerar a filial do funcionario                                  บฑฑ
ฑฑบ          ณ Alteracao para considerar verbas distintas entre as filiais                        บฑฑ
ฑฑบ          ณ                                                                                    บฑฑ
ฑฑบ          ณ Acertos no tratamento do fonte                                                     บฑฑ
ฑฑบ          ณ                                                                                    บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP10                                                                               บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
	User Function RPON003
	Local _nHoras		:= 0
	Local _cCodVbP		:= ""
	Local _cCodVbD		:= ""
	Local _cCodEvt		:= ""
	Local _cQuery		:= ""
	
	Private cPerg		:= "BCH001"
	
//	U_FDocElet("PON","RPON003","U_RPON003","Personaliza็ใo do banco de horas","12/05/2008")
	
	ValidPerg(cPerg)                                                  
	
	if !Pergunte(cPerg)
		return
	endif

	// Cria tabela temporแria.
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
		
		_cCodVbP	:= SuperGetMv("MV_XVERBAP", .T., "Parametro com a Verba de Provento nใo cadastrado!", TRB->RA_FILIAL)
		_cCodVbD	:= SuperGetMv("MV_XVERBAD", .T., "Parametro com a Verba de Desconto nใo cadastrado!", TRB->RA_FILIAL)
		_cCodEvt	:= SuperGetMv("MV_XEVENTO", .T., "Parametro com o c๓digo do Evento nใo cadastrado!" , TRB->RA_FILIAL)
		
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
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออออหออออออออัอออออออออออออออออออออออออออออออออออออหอออออออออัออออออออออออออปฑฑ
ฑฑบPrograma  ณ BCHRetorna บ Autor  ณ   Cleiton Campos                    บ  Data   ณ   12/05/08   บฑฑ
ฑฑฬออออออออออุออออออออออออสออออออออฯอออออออออออออออออออออออออออออออออออออสอออออออออฯออออออออออออออนฑฑ
ฑฑบDescricao ณ Retorna a quantidade de horas para a verba.                                        บฑฑ
ฑฑบ          ณ                                                                                    บฑฑ
ฑฑฬออออออออออัออออออออออออหออออออออัอออออออออออออออออออออออออออออออออออออหอออออออออัออออออออออออออปฑฑ
ฑฑบAlteracao ณ BCHRetorna บ Autor  ณ Frederico O. C. Jr                  บ  Data   ณ   28/12/09   บฑฑ
ฑฑฬออออออออออุออออออออออออสออออออออฯอออออออออออออออออออออออออออออออออออออสอออออออออฯออออออออออออออนฑฑ
ฑฑบDescricao ณ Alteracao para considerar a filial do funcionario                                  บฑฑ
ฑฑบ          ณ                                                                                    บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP10                                                                               บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
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
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออออหออออออออัอออออออออออออออออออออออออออออออออออออหอออออออออัออออออออออออออปฑฑ
ฑฑบPrograma  ณApagaVerbas บ Autor  ณ   Cleiton Campos                    บ  Data   ณ   12/05/08   บฑฑ
ฑฑฬออออออออออุออออออออออออสออออออออฯอออออออออออออออออออออออออออออออออออออสอออออออออฯออออออออออออออนฑฑ
ฑฑบDescricao ณ Elimina as verbas 254 e 470 do banco de horas.                                     บฑฑ
ฑฑบ          ณ                                                                                    บฑฑ
ฑฑฬออออออออออัออออออออออออหออออออออัอออออออออออออออออออออออออออออออออออออหอออออออออัออออออออออออออปฑฑ
ฑฑบAlteracao ณApagaVerbas บ Autor  ณ Frederico O. C. Jr                  บ  Data   ณ   28/12/09   บฑฑ
ฑฑฬออออออออออุออออออออออออสออออออออฯอออออออออออออออออออออออออออออออออออออสอออออออออฯออออออออออออออนฑฑ
ฑฑบDescricao ณ Alteracao para considerar a filial do funcionario                                  บฑฑ
ฑฑบ          ณ Alteracao para considerar verbas distintas entre filiais                           บฑฑ
ฑฑบ          ณ                                                                                    บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP10                                                                               บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
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
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออออหออออออออัอออออออออออออออออออออออออออออออออออออหอออออออออัออออออออออออออปฑฑ
ฑฑบPrograma  ณ GeraVerba  บ Autor  ณ                                     บ  Data   ณ   13/12/13   บฑฑ
ฑฑฬออออออออออุออออออออออออสออออออออฯอออออออออออออออออออออออออออออออออออออสอออออออออฯออออออออออออออนฑฑ
ฑฑบDescricao ณ Gera a verba 254 - SALDO BANCO DE HORAS com o saldo de horas.                      บฑฑ
ฑฑบ          ณ                                                                                    บฑฑ
ฑฑฬออออออออออัออออออออออออหออออออออัอออออออออออออออออออออออออออออออออออออหอออออออออัออออออออออออออปฑฑ
ฑฑบAlteracao ณ GeraVerba  บ Autor  ณ Frederico O. C. Jr                  บ  Data   ณ   28/12/09   บฑฑ
ฑฑฬออออออออออุออออออออออออสออออออออฯอออออออออออออออออออออออออออออออออออออสอออออออออฯออออออออออออออนฑฑ
ฑฑบDescricao ณ Alteracao para considerar a filial do funcionario                                  บฑฑ
ฑฑบ          ณ Alteracao para considerar verbas distintas entre filiais                           บฑฑ
ฑฑบ          ณ                                                                                    บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP10                                                                               บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
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
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออออหออออออออัอออออออออออออออออออออออออออออออออออออหอออออออออัออออออออออออออปฑฑ
ฑฑบPrograma  ณ GeraEvento บ Autor  ณ   Cleiton Campos                    บ  Data   ณ   12/05/08   บฑฑ
ฑฑฬออออออออออุออออออออออออสออออออออฯอออออออออออออออออออออออออออออออออออออสอออออออออฯออออออออออออออนฑฑ
ฑฑบDescricao ณ Gera o evento 052.                                                                 บฑฑ
ฑฑบ          ณ                                                                                    บฑฑ
ฑฑฬออออออออออัออออออออออออหออออออออัอออออออออออออออออออออออออออออออออออออหอออออออออัออออออออออออออปฑฑ
ฑฑบAlteracao ณ GeraVerba  บ Autor  ณ Frederico O. C. Jr                  บ  Data   ณ   28/12/09   บฑฑ
ฑฑฬออออออออออุออออออออออออสออออออออฯอออออออออออออออออออออออออออออออออออออสอออออออออฯออออออออออออออนฑฑ
ฑฑบDescricao ณ Alteracao para considerar a filial do funcionario                                  บฑฑ
ฑฑบ          ณ Alteracao para considerar verbas distintas entre filiais                           บฑฑ
ฑฑบ          ณ                                                                                    บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP10                                                                               บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
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
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณValidPerg บAutor  ณCleiton Campos      บ Data ณ  27/07/06   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณValidar perguntas de usuario.                               บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณValidPerg บAutor  ณFrederico O. C. Jr  บ Data ณ  28/12/09   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบAlteracao ณ Inclusao do tratamento da filial do funcionario            บฑฑ
ฑฑบ          ณ Inclusao de help nos parametros                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ MP10                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function ValidPerg()

	Local aHelpPor := {}

	//Filial
	Aadd( aHelpPor, 'Informe ou Selecione o C๓digo da Filial do Funcionแrio ')
	PutSx1(cPerg,"01","Filial De ?"				,"","","mv_ch1","C",04,0,0,"G","","SM0","","","mv_par01","","","","","","","","","","","","","","","","",aHelpPor,aHelpPor,aHelpPor)
	PutSx1(cPerg,"02","Filial Ate ?"			,"","","mv_ch2","C",04,0,0,"G","","SM0","","","mv_par02","","","","","","","","","","","","","","","","",aHelpPor,aHelpPor,aHelpPor)

	aHelpPor := {}
	Aadd( aHelpPor, 'Informe ou Selecione o C๓digo da Matricula do Funcionแrio ')
	PutSx1(cPerg,"03","Funcionแrio de ?"		,"","","mv_ch3","C",06,0,0,"G","","SRA","","","mv_par03","","","","","","","","","","","","","","","","",aHelpPor,aHelpPor,aHelpPor)
	PutSx1(cPerg,"04","Funcionแrio Ate ?"  		,"","","mv_ch4","C",06,0,0,"C","","SRA","","","mv_par04","","","","","","","","","","","","","","","","",aHelpPor,aHelpPor,aHelpPor)

	aHelpPor := {}
	Aadd( aHelpPor, 'Informe a Data Inicial do Desconto ')
	PutSx1(cPerg,"05","Desconto Dt.Inicial ?"	,"","","mv_ch5","D",08,0,0,"G","","   ","","","mv_par05","","","","","","","","","","","","","","","","",aHelpPor,aHelpPor,aHelpPor)

Return
