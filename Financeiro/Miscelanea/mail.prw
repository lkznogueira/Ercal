#INCLUDE "PROTHEUS.CH"
#include "TOTVS.CH"

/*/{Protheus.doc} mail
description
@type class
@version  
@author oficina5
@since 28/10/2021
/*/
class mail

	data _cServer
	data _cAccount
	data _cPassword
	data _lAutentica
	data _cMailHid
	data _lOK
	data _oMail
	data _nPos
	data _oMessage
	data _nRet
	data _nErro

	data _cDest
	data _cAss
	data _cMsg
	data _aFile

	method new() constructor

	method sendMail()

endClass

/*/{Protheus.doc} mail::new
description
@type method
@version  
@author oficina5
@since 28/10/2021
@return variant, return_description
/*/
method new() class mail

	::_cDest :=  ""
	::_cAss  :=  ""
	::_cMsg  :=  ""
	::_aFile :=  {}

return

/*/{Protheus.doc} mail::sendMail
description
@type method
@version  
@author oficina5
@since 28/10/2021
@param _cDest, variant, param_description
@param _cAss, variant, param_description
@param _cMsg, variant, param_description
@param _aFile, variant, param_description
@return variant, return_description
/*/
method sendMail(_cDest, _cAss, _cMsg, _aFile) class mail

	local _aMail    :=  {}
	local _cMail    :=  ""
	local _nPos     :=  0
	local _nMail1   :=  1
	local _nMail2   :=  1
	local _cBkMail  :=  _cDest
	local _lRet     :=  .F.

	if !empty(_cDest)

		for _nMail1:=1 to len(_cDest)

			_nPos := AT(";",_cDest)

			if _nPos > 0
				_cMail := substr(_cDest,1,_nPos-1)
				_cDest := substr(_cDest,_nPos+1, len(_cDest))
				aadd(_aMail, _cMail)
			else
				aadd(_aMail, _cDest)
				exit
			endIf

		next _nMail

	else

		conOut("[autCon] - Email destino não informado no campo EE_XMAICON -  " + dToc(date()) + " - " + time())
		return

	endIf

	for _nMail2:=1 to len(_aMail)

		if !isEmail(_aMail[_nMail2])

			conOut("[autCon] - Email informado no campo EE_XMAICON é inválido -  " + dToc(date()) + " - " + time())
			return

		endIf

	next _nMail2

	_lRet :=  GPEMail(_cAss,_cMsg,_cBkMail,_aFile)

return _lRet


