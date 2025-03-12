#INCLUDE "PROTHEUS.CH"

/*/{Protheus.doc} conciliation
description
@type class
@version  
@author Raphael Ferreira - oficina5
@since 27/10/2021
/*/
class conciliation

	data _lRet
	data _oConnectionNoSmart

	data _cFunc
	data _aTab
	data _aConect

	data _aDataBank
	data _aDataFile
	data _nOpc
	data _aLog
	data _aLogLanc
	data _cProc
	data _lRecImp

	data _cFileLayut
	data _aFilesExtr
	data _cDirBack
	data _cDirIn

	data _aDelFile

	//sendMail
	data _oMail

	method new() constructor

	method importFiles()

	method recImp()

	method conciliationMoviment()

	method toMoveFiles()

endClass

/*/{Protheus.doc} conciliation::new
description
@type method
@version  
@author Raphael Ferreira - oficina5
@since 27/10/2021
@return variant, return_description
/*/
method new() class conciliation

	::_lRet                 :=  .T.
	//::_oConnectionNoSmart   :=  schedulle():new()
	::_nOpc                 :=  3
	::_aLog                 :=  {}
	::_aLogLanc             :=  {}

    /*
    if ::_oConnectionNoSmart:setConnectionNoSmartClient("automaticConciliation", {"SE1"}, {"99","01"})

        ::_lRet := .T.

    endIf
    */

return ::_lRet


/*/{Protheus.doc} conciliation::importFiles
description
@type method
@version  
@author Raphael Ferreira - oficina5
@since 27/10/2021
@return variant, return_description
/*/
method importFiles() class conciliation

	local _aArea    :=  getArea()
	local _cQry     :=  GetNextAlias()
	local _cDirIn   :=  ""              //directory import extrat
	local _cFileC   :=  ""              //file configure
	local _afindFile:=  {}              //files search
	local _nFindFile:=  0
	local _aFileBank:=  {}
	local _aDataBank:=  {}
	local _nFileBank:=  0

	if Select(_cQry) > 0
		dbCloseArea()
		dbSelectArea(_cQry)
	endIf

	if Select("SEE") > 0
		dbCloseArea()
		dbSelectArea("SEE")
	endIf

	if Select("SIF") > 0
		dbCloseArea()
		dbSelectArea("SIF")
	endIf
	SIF->(dbSetOrder(1))

	if Select("SIG") > 0
		dbCloseArea()
		dbSelectArea("SIG")
	endIf
	SIG->(dbSetOrder(1))

	if Select("SEE") > 0
		dbCloseArea()
		dbSelectArea("SIG")
	endIf
	SEE->(dbSetOrder(1))

	if Select("ZA1") > 0
		dbCloseArea()
		dbSelectArea("ZA1")
	endIf

	BeginSql Alias _cQry
            
        SELECT SEE.R_E_C_N_O_ AS Recno FROM %table:SEE% SEE
            WHERE   SEE.%notDel%
            AND     SEE.EE_XARQCON  <>  ''
            AND     SEE.EE_XDIREXT  <>  ''
            AND     SEE.EE_XDIRBKE  <>  ''
            //AND     SEE.EE_XMAICON  <>  ''
            AND     SEE.EE_XAUTCON 	=	'T'
    
	EndSql

	while (_cQry)->(!Eof())

		//position parameters bank
		SEE->(dbGoto((_cQry)->(Recno)))
		if SEE->(!Eof())

			//equal companies
			if substr(cFilAnt,1,_nTamEmp) == alltrim(SEE->EE_FILIAL)

				_cDirIn :=  SEE->EE_XDIREXT
				_cFileC :=  SEE->EE_XARQCON

				//valid configure file
				if file(_cFileC)

					//search files in directory extrat
					_afindFile  :=  Directory(AllTrim(_cDirIn) + "*.*")

					//search files on bank parameter
					for _nFindFile:=1 to len(_afindFile)

						_aDataBank := u_returnBank({SEE->EE_CODIGO, SEE->EE_AGENCIA, SEE->EE_CONTA, SEE->EE_SUBCTA},{_cFileC, alltrim(_cDirIn) + _afindFile[_nFindFile][1]})

						if len(_aDataBank) > 0

							if (alltrim(SEE->EE_CODIGO) $ _aDataBank[1]) .and. (alltrim(SEE->EE_AGENCIA) $ _aDataBank[2]) .and. (alltrim(SEE->EE_CONTA) $ _aDataBank[3])

								aadd(_aFileBank, alltrim(_cDirIn) + _afindFile[_nFindFile][1])

							endIf

						endif

						_aDataBank := {}

					next _nFindFile

					for _nFileBank:=1 to len(_aFileBank)

						//cFilAnt := alltrim(SEE->EE_FILIAL)

						//_cProc := StaticCall(FINA473, F473ProxNum, "SIF")
						_cProc := U_MFIN001A("SIF")

						if ZA1->(recLock("ZA1", .T.))

							//general
							ZA1->ZA1_FILIAL :=  alltrim(cFilAnt) //+ cEmpAnte
							ZA1->ZA1_ID     :=  GetSxeNum("ZA1","ZA1_ID","ZA1_ID" + cEmpAnt)
							ZA1->ZA1_DATA   :=  date()
							ZA1->ZA1_HORA   :=  time()
							ZA1->ZA1_STAT   :=  "1"
							ZA1->ZA1_PROC   :=  _cProc

							//bank
							ZA1->ZA1_BANC   :=  SEE->EE_CODIGO
							ZA1->ZA1_AGEN   :=  SEE->EE_AGENCIA
							ZA1->ZA1_CONT   :=  SEE->EE_CONTA + SEE->EE_DVCTA
							ZA1->ZA1_SUBC   :=  SEE->EE_SUBCTA
							ZA1->ZA1_DESC   :=  'automatic conciliation'

							//files
							ZA1->ZA1_LAYO   :=  _cFileC
							ZA1->ZA1_EXTR   :=  _aFileBank[_nFileBank]
							ZA1->ZA1_DELETE :=  .F.
							ZA1->ZA1_BACKUP :=  SEE->EE_XDIRBKE

							//mail
							ZA1->ZA1_MAIL   :=  SEE->EE_XMAICON
							ZA1->ZA1_ENVMAI :=  .F.

							ConfirmSx8()
							ZA1->(msUnlock())

						endIf

					next _nFileBank

					_cProc      := ""
					_aFileBank  := {}

				else

					//env mail error
					_cMsgMail := "<b>Arquivo layout não existe no diretório informado!</b></br>"
					_cMsgMail += "</br><b>Empresa :</b>"  +   ALLTRIM(SM0->M0_CODIGO) + " - " + SM0->M0_FILIAL + " " + SM0->M0_NOME
					_cMsgMail += "</br><b>diretório informado no campo EE_XARQCON : </b> " + _cFileC
					_cMsgMail += "</br><b>banco :</b>    "   + SEE->EE_CODIGO + " - " + posicione("SA6",1, xFilial("SA6") + SEE->EE_CODIGO + SEE->EE_AGENCIA + SEE->EE_CONTA, "A6_NOME")
					_cMsgMail += "</br><b>agência :</b>  "   + SEE->EE_AGENCIA
					_cMsgMail += "</br><b>conta : </b>   "   + SEE->EE_CONTA + "</br></br>"

					::_oMail := mail():new()
					::_oMail:sendMail(SEE->EE_XMAICON , "[PROTHEUS] - "+substr(alltrim(SM0->M0_CODFIL),1,_nTamEmp)+" - Rotina automática de conciliação bancária", _cMsgMail , {})
					FreeObj(::_oMail)

				endIf

			endIf

		endIf

		(_cQry)->(dbSkip())

	endDo

	if Select(_cQry) > 0
		dbSelectArea(_cQry)
		dbCloseArea()
	endIf

	if Select("SEE") > 0
		dbSelectArea("SEE")
		dbCloseArea()
	endIf

	if Select("SIF") > 0
		dbSelectArea("SIF")
		dbCloseArea()
	endIf

	if Select("SIG") > 0
		dbSelectArea("SIG")
		dbCloseArea()
	endIf

	if Select("SEE") > 0
		dbSelectArea("SIG")
		dbCloseArea()
	endIf

	if Select("ZA1") > 0
		dbSelectArea("ZA1")
		dbCloseArea()
	endIf

	restArea(_aArea)

return

/*/{Protheus.doc} conciliation::recImp
description
@type method
@version  
@author Raphael Ferreira - oficina5
@since 27/10/2021
@return variant, return_description
/*/
method recImp() class conciliation

	local _aArea        :=  getArea()
	local _cQry         :=  GetNextAlias()
	local _lRecImp      :=  .F.
	local _aDataBank    :=  {}
	local _aDataFile    :=  {}
	local _nOpc         :=  3
	local _aLog         :=  {}
	local _aLogLanc     :=  {}

	BeginSql Alias _cQry
            
        SELECT ZA1.R_E_C_N_O_ AS Recno FROM %table:ZA1% ZA1
            WHERE 	ZA1.%notDel%
            AND 	ZA1.ZA1_STAT  = '1'

	EndSql

	dbSelectArea(_cQry)
	dbSelectArea("ZA1")

	while (_cQry)->(!Eof())

		ZA1->(DBgoTo((_cQry)->(Recno)))
		if ZA1->(!Eof())

			cFilAnt := ZA1->ZA1_FILIAL

			_aDataBank  :=  {ZA1->ZA1_PROC, ZA1->ZA1_BANC, ZA1->ZA1_AGEN, ZA1->ZA1_CONT, ZA1->ZA1_SUBC, ZA1->ZA1_DESC}
			_aDataFile  :=  {ZA1->ZA1_LAYO, ZA1->ZA1_EXTR}
			_nOpc       :=  3

			//_lRecImp := StaticCall(FINA473 , F473ImpExt , _aDataBank , _aDataFile , _nOpc , @_aLog , @_aLogLanc)
			_lRecImp := F473ImpExt(_aDataBank , _aDataFile , _nOpc , @_aLog , @_aLogLanc)

			//rec return ZA1
			if  ZA1->(recLock("ZA1", .F.))

				if _lRecImp
					ZA1->ZA1_STAT   :=  "2"
					ZA1->ZA1_RET    :=  "SIF e SIG gerados com sucesso!"
				else

					ZA1->ZA1_STAT   :=  "3"
					if      len(_aLog) > 0
						ZA1->ZA1_RET    :=  _aLog[1][2]
					elseif  len(_aLogLanc) > 0
						ZA1->ZA1_RET    :=  _aLogLanc[1][2]
					endIf

				endIf

				_aLog       :=  {}
				_aLogLanc   :=  {}

				ZA1->(msUnlock())

				if !_lRecImp

					_cMsgMail := "<b>Erro ao gerar SIF e SIG!</b>"
					_cMsgMail += "</br></br><b> Empresa    :</b>"  +   ALLTRIM(SM0->M0_CODIGO) + " - " + SM0->M0_FILIAL + " " + SM0->M0_NOME
					_cMsgMail += "</br><b> Arquivo layout  : </b>"+ZA1->ZA1_LAYO
					_cMsgMail += "</br><b> Arquivo extrato : </b>"+ZA1->ZA1_EXTR
					_cMsgMail += "</br><b>banco:</b>    "   + ZA1->ZA1_BANC + " - " + posicione("SA6",1, xFilial("SA6") + ZA1->ZA1_BANC + ZA1->ZA1_AGEN + ZA1->ZA1_CONT, "A6_NOME")
					_cMsgMail += "</br><b>agência:</b>  "   + ZA1->ZA1_AGEN
					_cMsgMail += "</br><b>conta:</b>    "   + ZA1->ZA1_CONT + "</br></br>"

					_cMsgMail += "</br><b>ERRO : </b> "+ZA1->ZA1_RET+" </br></br>"

					if alltrim(ZA1->ZA1_RET) <> "Este arquivo de extrato não possui lançamentos."

						::_oMail := mail():new()
						if ::_oMail:sendMail(ZA1->ZA1_MAIL , "[PROTHEUS] - "+substr(alltrim(SM0->M0_CODFIL),1,_nTamEmp)+" - Rotina automática de conciliação bancária", _cMsgMail , {})
							if  ZA1->(recLock("ZA1", .F.))
								ZA1->ZA1_ENVMAI := .T.
								ZA1->(msUnlock())
							endIf
						endIf
						FreeObj(::_oMail)

					endIf

				endIf

			endIf

			_lRecImp := .F.

		endIf

		(_cQry)->(dbSkip())

	endDo

	if Select("ZA1") > 0
		dbSelectArea("ZA1")
		dbCloseArea()
	endIf

	if Select(_cQry) > 0
		dbSelectArea(_cQry)
		dbCloseArea()
	endIf

	restArea(_aArea)

return

/*/{Protheus.doc} conciliation::conciliationMoviment
description
@type method
@version  
@author Raphael Ferreira - oficina5
@since 27/10/2021
@param _cProcess, variant, param_description
@return variant, return_description
/*/
method conciliationMoviment(_cProcess) class conciliation

	local _aArea    :=  getArea()
	local _cQry2    :=  GetNextAlias()
	local _cQry3    :=  GetNextAlias()
	local _cRecPag  :=  ""
	local _aFileDel :=  {}
	local _aNotCon  :=  {}
	local _nMsg     :=  0
	local _nCountSIG:=  0
	local _nCountSE5:=  0
	local _nCountMov:=  0
	local _cMail    :=  ""
	local _cIdProc  :=  ""
	local _nContNot :=  0

	local _cArqCfg    :=  ""
	local _cArqImp    :=  ""
	local _cBanco     :=  ""
	local _cFilial    :=  ""
	local _cAgencia   :=  ""
	local _cConta     :=  ""

	dbSelectArea("SE5")
	dbSelectArea("SIF")
	dbSelectArea("SIF")

	if Select(_cQry2) > 0
		dbSelectArea(_cQry2)
		dbCloseArea()
	endIf

	BeginSql Alias _cQry2

        SELECT SIG.R_E_C_N_O_ AS RecSIG, SIF.R_E_C_N_O_ AS RecSIF, ZA1.R_E_C_N_O_ AS RecZA1 FROM %table:SIG% SIG, %table:ZA1% ZA1, %table:SIF% SIF 
            WHERE	SIG.D_E_L_E_T_  <>  '*' AND ZA1.D_E_L_E_T_  <> '*' AND SIF.D_E_L_E_T_  <>  '*' 
            AND 	SIG.IG_STATUS   =   '1'
            AND     SIG.IG_FILIAL   =   %Exp:alltrim(xFilial("SIG"))% 
            AND     SIG.IG_IDPROC   =   ZA1.ZA1_PROC
            AND     SIG.IG_IDPROC   =   SIF.IF_IDPROC
            AND     SIG.IG_XVERCON  =   "F"
            AND     SIF.IF_FILIAL   =   SIG.IG_FILIAL
            AND     SIG.IG_FILIAL   =   ZA1.ZA1_FILIAL
            AND     ZA1.ZA1_STAT    =   '2' 
            ORDER BY SIG.IG_IDPROC

	endSql

	dbSelectArea(_cQry2)

	_nCountSIG := Contar((_cQry2),"!Eof()")
	(_cQry2)->(DbGoTop())

	//begin Transaction

	while (_cQry2)->(!Eof())

		ZA1->(DBgoTo((_cQry2)->(RecZA1)))
		if ZA1->(!Eof())

			SIF->(DBgoTo((_cQry2)->(RecSIF)))
			if SIF->(!Eof())

				SIG->(DBgoTo((_cQry2)->(RecSIG)))
				if SIG->(!Eof())

					_nContNot   +=  1

					if _nContNot == 1
						_cIdProc    :=  ZA1->ZA1_PROC
						_cMail      :=  ZA1->ZA1_MAIL

						_cArqCfg    :=  SIF->IF_ARQCFG
						_cArqImp    :=  SIF->IF_ARQIMP
						_cBanco     :=  SIF->IF_BANCO
						_cFilial    :=  SIF->IF_FILIAL
						_cBanco     :=  SIF->IF_BANCO
						_cAgencia   :=  SIG->IG_AGEEXT
						_cConta     :=  SIG->IG_CONEXT
					endIf

					//delete file
					if ascan(_aFileDel, alltrim(SIF->IF_ARQIMP)) == 0
						aadd(_aFileDel, alltrim(SIF->IF_ARQIMP))
					endIf

					_cRecPag := if(SIG->IG_CARTER=="1","R","P")

					if Select(_cQry3) > 0
						dbSelectArea(_cQry3)
						dbCloseArea()
					endIf

/*
					BeginSql Alias _cQry3

                            SELECT SE5.R_E_C_N_O_ AS Recno FROM %table:SE5% SE5 
                                WHERE 	SE5.D_E_L_E_T_ <>   '*'
                                AND 	SE5.E5_FILIAL   =   %Exp:alltrim(SIG->IG_FILIAL)%
                                AND 	SE5.E5_BANCO    =   %Exp:SIF->IF_BANCO%
                                AND 	SE5.E5_AGENCIA  =   %Exp:SIG->IG_AGEEXT%
                                AND 	SE5.E5_CONTA    =   %Exp:SIG->IG_CONEXT%
                                AND 	SE5.E5_RECPAG   =   %Exp:_cRecPag%
                                AND 	SE5.E5_VALOR    =   %Exp:SIG->IG_VLREXT%
                                AND     SE5.E5_SEQCON   =   ''
                                AND     SE5.E5_RECONC   =   ''
                                AND     SE5.E5_DTDISPO  =   %Exp:SIG->IG_DTEXTR%
                                AND     SE5.E5_RECONC  <>  'x'
								AND     ROWNUM          = 1

					endSql */

					BeginSql Alias _cQry3

                            SELECT SE5.R_E_C_N_O_ AS Recno FROM %table:SE5% SE5 
                                WHERE 	SE5.D_E_L_E_T_ <>   '*'
								AND 	SE5.E5_BANCO    =   %Exp:SIF->IF_BANCO%
                                AND 	SE5.E5_AGENCIA  =   %Exp:SIG->IG_AGEEXT%
                                AND 	SE5.E5_CONTA    =   %Exp:SIG->IG_CONEXT%
                                AND 	SE5.E5_RECPAG   =   %Exp:_cRecPag%
                                AND 	SE5.E5_VALOR    =   %Exp:SIG->IG_VLREXT%
                                AND     SE5.E5_SEQCON   =   ''
                                AND     SE5.E5_RECONC   =   ''
                                AND     SE5.E5_DTDISPO  =   %Exp:SIG->IG_DTEXTR%
                                AND     SE5.E5_RECONC  <>  'x'
								AND     ROWNUM          = 1

					endSql
					CONOUT("********* INICIO DEBUG ***********")
					CONOUT(GETLASTQUERY()[2])
					dbSelectArea(_cQry3)

					_nCountMov := Contar((_cQry3),"!Eof()")
					(_cQry3)->(DbGoTop())

					while (_cQry3)->(!Eof())

						SE5->(DBgoTo((_cQry3)->(Recno)))

						if SE5->(!Eof())

							CONOUT(SE5->E5_FILIAL + " - " + SE5->E5_DOCUMEN + " - " + SE5->E5_PREFIXO + " - " + SE5->E5_NUMERO + " - " + SE5->E5_PARCELA + " - ")

							if  SE5->(recLock("SE5", .F. ))

								SE5->E5_SEQCON  :=  SIG->IG_SEQMOV
								SE5->E5_RECONC  :=  "x"

								SE5->(msUnlock())

								_nCountSE5 += 1

							endIf

						endIf

						(_cQry3)->(dbSkip())

					endDo

					if _nCountMov == 0

						aadd(_aNotCon, {SIG->IG_ITEM, SIG->IG_VLREXT, SIG->IG_HISTEXT})

					endIf

					_nCountMov := 0

				endIf

				if _nCountSE5 > 0

					if  SIG->(recLock("SIG", .F. ))

						SIG->IG_STATUS  :=  '3'                         //reconciled reg
						SIG->IG_FILORIG :=  alltrim(SIG->IG_FILIAL)
						SIG->IG_DTMOVI  :=  SIG->IG_DTEXTR
						SIG->IG_AGEMOV  :=  SE5->E5_AGENCIA
						SIG->IG_CONMOV  :=  SE5->E5_CONTA
						SIG->IG_VLRMOV  :=  SE5->E5_VALOR
						SIG->IG_HISMOV  :=  SE5->E5_HISTOR
						SIG->IG_NATMOV  :=  SE5->E5_NATUREZ
						SIG->IG_XVERCON := .T.

					endIf

					SIG->(msUnlock())

					if  SIF->(recLock("SIF", .F. ))

						if _nCountSE5 > 0
							SIF->IF_STATUS  :=  '3'                     //reconciled file
						endIf

						SIF->(msUnlock())

					endIf

				else

					if  SIG->(recLock("SIG", .F. ))

						SIG->IG_XVERCON := .T.

					endIf

					SIG->(msUnlock())

				endIf

			endIf

		endIf

		(_cQry2)->(dbSkip())
		if (_cQry2)->(!Eof())
			ZA1->(DBgoTo((_cQry2)->(RecZA1)))
		endIf

		if len(_aNotCon) > 0

			if (ZA1->ZA1_PROC <> _cIdProc) .or. (_cQry2)->(Eof())

				_cMsgMail := "<b>Não foi possível realizar conciliação automática</b></br>"
				_cMsgMail += "</br><b>empresa          :</b> "  +   ALLTRIM(SM0->M0_CODIGO) + " - " + SM0->M0_FILIAL + " " + SM0->M0_NOME
				_cMsgMail += "</br><b>arquivo layout   :</b> "  +   _cArqCfg
				_cMsgMail += "</br><b>arquivo extrato  :</b> "  +   _cArqImp
				_cMsgMail += "</br><b>banco            :</b> "  +   _cBanco + " - " + posicione("SA6",1, SUBSTR(_cFilial,1,3) + "  " + _cBanco + _cAgencia + _cConta, "A6_NOME")
				_cMsgMail += "</br><b>agência          :</b> "  +   _cAgencia
				_cMsgMail += "</br><b>conta            :</b> "  +   _cConta
				_cMsgMail += "</br><b>carteira         :</b> "  +   if(_cRecPag=="R", "Recebimento", "Pagamento")
				_cMsgMail += "</br><b>processo         :</b> "  +   _cIdProc
				_cMsgMail += "</br><b>Valores:</b></br>"
				for _nMsg:=1 to len(_aNotCon)
					_cMsgMail += "</br><b>item :</b> "  + _aNotCon[_nMsg][1] + "<b> valor : </b> " + TRANSFORM(_aNotCon[_nMsg][2], "@E 999,999.99") + "<b> - histórico : </b>" + _aNotCon[_nMsg][3] + "</br>"
				next _nMsg
				_cMsgMail += "</br></br>"

				::_oMail := mail():new()
				::_oMail:sendMail(_cMail  , "[PROTHEUS] - "+substr(alltrim(SM0->M0_CODFIL),1,_nTamEmp)+" - Rotina automática de conciliação bancária", _cMsgMail , {})
				FreeObj(::_oMail)

				_aNotCon    := {}

				_nContNot   :=  0

				_cMail      :=  ""

			endIf

		endIf

		_cRecPag    :=  ""
		_nCountSE5  :=  0
		_nCountMov  :=  0

	endDo

	//end Transaction

	_nCountSIG  :=  0

	if Select("SE5") > 0
		dbSelectArea("SE5")
		dbCloseArea()
	endIf

	if Select("SIF") > 0
		dbSelectArea("SIF")
		dbCloseArea()
	endIf

	if Select("SIG") > 0
		dbSelectArea("SIF")
		dbCloseArea()
	endIf

	restArea(_aArea)

return _aFileDel

/*/{Protheus.doc} conciliation::toMoveFiles
description
@type method
@version  
@author Raphael Ferreira - oficina5
@since 27/10/2021
@param _cDirExt, variant, param_description
@param _aDelFile, variant, param_description
@return variant, return_description
/*/
method toMoveFiles(_cDirExt, _aDelFile) class conciliation

	local _aArea        :=  getArea()
	local _cQry         :=  GetNextAlias()
	local _cDrive
	local _cDir
	local _cNome
	local _cExt
	local _cDirDel      :=  ""
	local _cDirBack     :=  ""

	if Select(_cQry) > 0
		dbSelectArea(_cQry)
		dbCloseArea()
	endIf

	BeginSql Alias _cQry
            
        SELECT ZA1.R_E_C_N_O_ AS Recno FROM %table:ZA1% ZA1
            WHERE 	ZA1.%notDel%
            AND     ZA1.ZA1_DELETE  =   'F'

	EndSql

	dbSelectArea("ZA1")
	dbSetOrder(1)

	dbSelectArea(_cQry)

	while (_cQry)->(!Eof())

		ZA1->(DBgoTo((_cQry)->(Recno)))
		if ZA1->(!Eof())

			_cDirBack := alltrim(ZA1->ZA1_BACKUP)

			if !file(_cDirBack)

				if !makeDir( _cDirBack )

					conOut("create dir : " + _cDirBack )

				endIf

			endIf

			_cDirDel := alltrim(ZA1->ZA1_EXTR)

			if file(_cDirDel)

				SplitPath(_cDirDel, @_cDrive, @_cDir, @_cNome, @_cExt )

				if __CopyFile(alltrim(_cDirDel), alltrim(_cDirBack) + _cNome)

					if FERASE(_cDirDel) == 0

						conOut("delet file : " + _cDirDel)

						if  ZA1->(recLock("ZA1",.F.))
							ZA1->ZA1_DELETE := .T.
							ZA1->(msUnlock())
						endIf

					endif

				endIf

			else

				if  ZA1->(recLock("ZA1",.F.))
					ZA1->ZA1_DELETE := .T.
					ZA1->(msUnlock())
				endIf

			endIf

		endIf

		(_cQry)->(dbSkip())

	endDo

	if Select("ZA1") > 0
		dbSelectArea("ZA1")
		dbCloseArea()
	endIf

	if Select(_cQry) > 0
		dbSelectArea(_cQry)
		dbCloseArea()
	endIf

	restArea(_aArea)

return
