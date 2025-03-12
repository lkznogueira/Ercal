#include "TbiConn.ch"
#include "TOTVS.CH"

/*/{Protheus.doc} MFIN001
@description
@type function
@version  
@author Raphael Ferreira - oficina5
@since 27/10/2021
@param aConection, array, param_description
@return variant, return_description
/*/
user function MFIN001(aConection)

	private _lAuto    :=  GetRemoteType() == -1

	conout("[MFIN001] - " + DTOC(date()) + Time())

	if _lAuto
		if aConection != Nil
			RPCSetType(3)
			RPCSetEnv(aConection[1],aConection[2],,,"FIN",,{"ZA1"})
			//RPCSetEnv("PF","J4JOR01",,,"FIN",,{"ZA1"})
			CONOUT("INICIO FILIAL "+cfilant)
		endIF
	endIf

	private _nTamEmp := 2// getNewPar("MV_XTEMP", 3)
	private bProcess := {|op| oProcess := op, mainProcess() }

	if _lAuto
		Eval(bProcess)
		//fcorrfil()
		fatusald()
	else

		//cfilant := substr(cfilant,1,_nTamEmp) + "01" //fix

		if !msgyesno("Empresa + Filial processamento  <b>" + cfilant + "</b>. Deseja continuar?", "Conciliação automática!")
			return
		endIf

		tNewProcess():New("MFIN001",;
			"concilicação automática",;
			bProcess,;
			"Esta rotina tem o objetivo realizar a conciliação bancária automática",;
			Nil,;
			Nil,;
			.T.,;
			5  ,;
			"" ,;
			.T. )
	endIf

	conout("[MFIN001 - Final] - " + DTOC(date()) + Time())

	if GetRemoteType() == -1
		if aConection != Nil
			RpcClearEnv()
		endIF
	endIf

return

/*/{Protheus.doc} MFIN001A
description
@type function
@version  
@author Raphael
@since 05/09/2022
@param cTab, character, param_description
@return variant, return_description
/*/
User Function MFIN001A(cTab)

	Local cNovaChave := ""
	Local aArea      := GetArea()
	Local cCampo     := ""
	Local cChave	 := ""
	Local nIndex     := 0
	Local lRet		 := .T.

	If cTab == "SIF"
		SIF->(dbSetOrder(1))//IF_FILIAL+IF_IDPROC
		cCampo := "IF_IDPROC"
		nIndex := 1
	ElseIf cTab == "SIG"
		SIG->(dbSetOrder(2))//IG_FILIAL+IG_SEQMOV
		cCampo := "IG_SEQMOV"
		cChave := "IG_SEQMOV"+cEmpAnt
		nIndex := 2
	Else
		MsgAlert("Alias inválido: " + cTab, "MFIN001A" )
		lRet	:= .F.
	EndIf

	If lRet
		While .T.
			(cTab)->(dbSetOrder(nIndex))
			cNovaChave := GetSXEnum(cTab,cCampo,cChave,nIndex)
			ConfirmSX8()
			If cTab == "SIF"
				If (cTab)->(!dbSeek(xFilial(cTab) + cNovaChave) )
					Exit
				EndIf
			Else
				If (cTab)->(!dbSeek(cNovaChave) )
					Exit
				EndIf
			EndIf
		EndDo
	EndIf

	RestArea(aArea)

Return(cNovaChave)

/*/{Protheus.doc} mainProcess
description
@type function
@version  
@author Raphael Ferreira - oficina5
@since 27/10/2021
@return variant, return_description
/*/
static function mainProcess()

	private _aDirDel        :=  {}
	private _oConciliaton   :=  conciliation():new()

	fProcIni("Realizando importação dos arquivos!", 4)

	conout("[MFIN001 - Importando arquivos] - " + DTOC(date()) + Time())
	fProcess("Importando arquivos!")
	//import extrat and layout files
	_oConciliaton:importFiles()

	conout("[MFIN001 - Gravando SIF e SIG!] - " + DTOC(date()) + Time())
	fProcess("Gravando SIF e SIG!")
	//rec in SIF and SIG tables
	_oConciliaton:recImp()


	conout("[MFIN001 - Conciliando movimento bancário!] - " + DTOC(date()) + Time())
	fProcess("Conciliando movimento bancário!")
	//conciliantion moviment in SE5
	_oConciliaton:conciliationMoviment()

	conout("[MFIN001 - Movendo arquivos para backup!] - " + DTOC(date()) + Time())
	fProcess("Movendo arquivos para backup!")
	//moviment file for backup diretory
	_oConciliaton:toMoveFiles()

	conout("[MFIN001 - Finalizando!] - " + DTOC(date()) + Time())
	fProcess("Finalizando!")
	FreeObj(_oConciliaton)

return

static function fProcIni(cProc, nProc)

	if oProcess != NIL
		oProcess:SetRegua1(nProc)
		oProcess:IncRegua1(cProc)
		SysRefresh()
	endIf

return

/*/{Protheus.doc} fProcess
description
@type function
@version  
@author Raphael Ferreira - oficina5
@since 27/10/2021
@param cProcess, character, param_description
@param nProcess, numeric, param_description
@return variant, return_description
/*/
static function fProcess(cProcess, nProcess)

	default nProcess := 0

	if oProcess != NIL
		oProcess:SetRegua2(nProcess)
		oProcess:IncRegua2(cProcess)
		SysRefresh()
	endIf

return

/*/{Protheus.doc} fcorrfil
description
@type function
@version  
@author Raphael Ferreira - oficina5
@since 27/10/2021
@return variant, return_description
/*/
Static Function fcorrfil()

	Local _cAlias:= GetNextAlias()

	Conout("--Inicio Correção filiais SIF SIG--")
	BeginSql alias _cAlias
        Select 
            SIF.R_E_C_N_O_ RECFI,
            SIG.R_E_C_N_O_ RECGI,
            A6_FILIAL FILIAL, IF_FILIAL
        from 
            %table:SIF% SIF
        join 
            %table:SIG% SIG ON 
            IG_FILIAL = IF_FILIAL AND IG_IDPROC = IF_IDPROC AND
            SIG.D_E_L_E_T_<>'*' 
        JOIN 
            %table:SA6% SA6 ON
            A6_COD = IF_BANCO AND A6_AGENCIA = IG_AGEEXT AND 
            A6_NUMCON = IG_CONEXT AND SA6.D_E_L_E_T_<>'*'
        WHERE 
            SIF.D_E_L_E_T_<>'*'
        AND TRIM(IF_FILIAL)<>TRIM(A6_FILIAL)
	EndSql

	while (_cAlias)->(!eof())
		dbselectarea("SIF")
		dbGoto((_cAlias)->RECFI)
		dbselectarea("SIG")
		dbGoto((_cAlias)->RECGI)
		if SIF->(Recno()) == (_cAlias)->RECFI
			Reclock("SIF",.F.)
			SIF->IF_FILIAL:= (_cAlias)->FILIAL
			Msunlock()
		endif
		if SIG->(Recno()) == (_cAlias)->RECGI
			Reclock("SIG",.F.)
			SIG->IG_FILIAL := (_cAlias)->FILIAL
			SIG->IG_FILORIG:= (_cAlias)->FILIAL
			Msunlock()
		endif
		(_cAlias)->(dbskip())
	enddo
	Conout("--Fim Correção filiais SIF SIG--")
	(_cAlias)->(dbclosearea())

Return(Nil)

/*/{Protheus.doc} fatusald
description
@type function
@version  
@author Raphael Ferreira - oficina5
@since 27/10/2021
@return variant, return_description
/*/
Static Function fatusald()
	Local _cAlias := GetNextAlias()
	local nHundle := 0
	Local _nLInha := 1

	if CEMPANT=="PF"
		beginsql alias _cAlias
            Select DISTINCT 
                SIF.R_E_C_N_O_ RECSIF , 
                RTRIM(RTRIM(EE_XDIRBKE)+LTRIM(RTRIM(REPLACE(IF_ARQIMP,RTRIM(EE_XDIREXT),'')))) ARQUIVO
            from 
                %table:SIF% SIF (NOLOCK)
            join 
                %table:SIG% SIG (NOLOCK) ON 
                IG_FILIAL = IF_FILIAL AND IG_IDPROC = IF_IDPROC AND
                SIG.D_E_L_E_T_<>'*' 
            join 
                %table:SEE% SEE (NOLOCK) ON 
                EE_FILIAL =  IF_FILIAL   AND EE_CODIGO = IF_BANCO AND EE_CONTA = IG_CONEXT  AND EE_AGENCIA = IG_AGEEXT 
                AND SEE.D_E_L_E_T_<>'*'
            WHERE 
                SIF.D_E_L_E_T_<>'*'
            AND     SEE.EE_XARQCON  <>  ''
            AND     SEE.EE_XDIREXT  <>  ''
            AND     SEE.EE_XDIRBKE  <>  ''
//            AND     SEE.EE_XMAICON  <>  ''
            AND     SEE.EE_XAUTCON   = 'T'
            AND IF_XSALDO=0
		endsql
	ELSE
		beginsql alias _cAlias
            Select DISTINCT 
                SIF.R_E_C_N_O_ RECSIF , 
                RTRIM(RTRIM(EE_XDIRBKE) || LTRIM(RTRIM(REPLACE(IF_ARQIMP,RTRIM(EE_XDIREXT),'')))) ARQUIVO
            from 
                %table:SIF% SIF (NOLOCK)
            join 
                %table:SIG% SIG (NOLOCK) ON 
                IG_FILIAL = IF_FILIAL AND IG_IDPROC = IF_IDPROC AND
                SIG.D_E_L_E_T_<>'*' 
            join 
                %table:SEE% SEE (NOLOCK) ON 
                EE_FILIAL = IF_FILIAL AND EE_CODIGO = IF_BANCO AND EE_CONTA = IG_CONEXT  AND EE_AGENCIA = IG_AGEEXT 
                AND SEE.D_E_L_E_T_<>'*'
            WHERE 
                SIF.D_E_L_E_T_<>'*'
            AND     SEE.EE_XARQCON  <>  ''
            AND     SEE.EE_XDIREXT  <>  ''
            AND     SEE.EE_XDIRBKE  <>  ''
            //AND     SEE.EE_XMAICON  <>  ''
            AND     SEE.EE_XAUTCON   = 'T'
            AND IF_XSALDO=0
		endsql
	ENDIF
	while (_cAlias)->(!eof())

		cArquivo := rtrim((_cAlias)->ARQUIVO)

		if file(cArquivo)
			nHundle:= FT_FUSE(cArquivo)
			if nHundle == -1
				console("Erro na abertura do arquivo")
			else
				FT_FGOTOP()
				While !FT_FEof()

					if _nLInha == FT_FLASTREC()-1
						if substr(FT_FREADLN(),169,1)=="D"
							_nValor := -1*(val(substr(FT_FREADLN(),151,18))/100)
						else
							_nValor := val(substr(FT_FREADLN(),151,18))/100
						endif
					endif
					FT_FSKIP()
					_nLInha++
				EndDo
				FT_FUSE()
				DbselectArea("SIF")
				SIF->(DBGOTO((_cAlias)->RECSIF))
				Reclock("SIF",.F.)
				SIF->IF_XSALDO := _nValor
				MsUnLock()
			endif
		endif
		(_cAlias)->(DbSkip())
		cArquivo:=""
		_nValor :=0
		_nLInha :=1
	enddo

Return(Nil)
