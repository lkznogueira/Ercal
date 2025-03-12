#Include 'Protheus.ch'
#Include 'FWMVCDEF.ch'
#Include 'RestFul.CH'
#Include 'Totvs.CH'


*****************************************************************************
*+-------------------------------------------------------------------------+*
*|Funcao      | PE_CONN001  | Autor | Jader Berto (Connect Zap)            +*
*+------------+------------------------------------------------------------+*
*|Data        | 13.08.2019                                                 |*
*+------------+------------------------------------------------------------+*
*|Descricao   | Ponto de Entrada ao enviar mensagem WhatsApp	 	       |*
*+------------+------------------------------------------------------------+*
*|Partida     | MSGZAP          									       |*
*|            | 				 	 	                                   |*
*+------------+------------------------------------------------------------+*
*| OBS.: Este fonte pode ser alterado conforme necessidade.                |*
*+-------------------------------------------------------------------------+*
*****************************************************************************

User Function PE_CONN001()
Local lEnviou    := PARAMIXB[1]    
Local cCelular   := PARAMIXB[2]
Local cMsg       := PARAMIXB[3]
Local cAnexo     := PARAMIXB[4]


Return
