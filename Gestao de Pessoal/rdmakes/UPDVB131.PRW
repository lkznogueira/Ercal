#INCLUDE "PROTHEUS.CH"

User Function UPDVB131()

Local aButtons  := {}
Local aSays     := {}
Local cMsg      := ""
Local lContinua := .F.
Local nOpcA     := 0
Local aErros	:= {}
Local cMsgHelp	:= ""
Local cLink		:= 'https://tdn.totvs.com/x/OFFvHw'

Private aCodFol := {}
Private aLog    := {}
Private aTitle  := {}
Private cPerg   := "UPDVB131"

//Carrega o array aCodFol para verificar o cadastro de verbas x Ids de c�lculo
Fp_CodFol(@aCodFol, cFilAnt, .F., .F.)

//Verifica se existe o cadastro da verba de Id 1628 e se a verba foi preenchida
If Len(aCodFol) >= 1628
	lContinua := !Empty( aCodFol[1628,1] )
EndIf 

//Se n�o existir cadastro da verba para o Id 1628, aborta o processamento da rotina
// VERIFICA SE ENCONTROU O GRUPO DE PERGUNTAS
If lContinua  .And. GetRpoRelease() != "12.1.017" .And. !SX1->(DbSeek('UPDVB131'))
	cMsg :=  + CRLF + OemToAnsi("N�o foi encontrado o grupo de perguntas: ") + Alltrim(cPerg)
	
	cMsgHelp := ""
	cMsgHelp += + CRLF + OemToAnsi("Antes de prosseguir ser� necess�rio criar o grupo de perguntas. Para isso, siga as instru��es contidos no link abaixo:")
	cMsgHelp += + CRLF + cLink + CRLF

	aAdd(aErros, cMsgHelp)
	
	Help(,, 'NOPERGUNT',, cMsg, 1, 0,,,,,, {aErros})
			
	Return()
ElseIf !lContinua
	cMsg := OemToAnsi( "Para executar essa rotina � obrigat�rio o cadastro das novas verbas do c�lculo da 1� parcela do 13� sal�rio" ) + CRLF
	cMsg += OemToAnsi( "conforme explicado na documenta��o dispon�vel em: http://tdn.totvs.com/pages/viewpage.action?pageId=403745443" )
	MsgInfo( cMsg )
	Return()
EndIf

//Cria as perguntas no dicion�rio SX1 para filtro do processamento
If GetRpoRelease() <= "12.1.017"
	fCriaSX1()
EndIf

aAdd(aSays,OemToAnsi( "Este programa tem como objetivo atualizar as verbas geradas no c�lculo da 1� parcela" ))
aAdd(aSays,OemToAnsi( "do 13� sal�rio no movimento acumulado (tabela SRD) para as novas verbas criadas para" ))
aAdd(aSays,OemToAnsi( "separa��o dos adicionais e m�dias." ))
aAdd(aSays,OemToAnsi( "Verifique a documenta��o: http://tdn.totvs.com/pages/viewpage.action?pageId=403745443" ))
aAdd(aSays,OemToAnsi( "e http://tdn.totvs.com/pages/viewpage.action?pageId=425435514" ))
aAdd(aSays,OemToAnsi( "" ))
aAdd(aSays,OemToAnsi( "Obs.: para a gera��o das verbas no movimento mensal (tabelas SRC) dever� ser efetuado"))
aAdd(aSays,OemToAnsi( "o rec�lculo da 1� parcela do 13� sal�rio."))

aAdd(aButtons, { 5,.T.,{|| Pergunte(cPerg,.T. ) } } )
aAdd(aButtons, { 1,.T.,{|o| nOpcA := 1,IF(gpconfOK(), FechaBatch(), nOpcA := 0 ) }} )
aAdd(aButtons, { 2,.T.,{|o| FechaBatch() }} )

//Abre a tela de processamento
FormBatch( "Atualiza��o da 1� Parcela do 13� Sal�rio", aSays, aButtons )

//Efetua o processamento de gera��o
If nOpcA == 1
    Aadd( aTitle, OemToAnsi( "Funcion�rios que tiveram verbas alteradas:" ) )
    Aadd( aLog, {} )
    ProcGpe( {|lEnd| fProcessa()},,,.T. )
    fMakeLog(aLog,aTitle,,,"UPDVB131",OemToAnsi("Log de Ocorr�ncias"),"M","P",,.F.)
EndIf

Return

/*/{Protheus.doc} fProcessa
Fun��o que efetua o processamento para a gera��o do Id 1562
/*/
Static Function fProcessa()

Local cAliasQry := GetNextAlias()
Local cFilOld   := cFilAnt
Local cRot131	:= fGetCalcRot("5")
Local cQuery    := ""
Local cWhere    := ""
Local lNovo     := .F.

Pergunte( cPerg, .F. )
MakeSqlExpr( cPerg )

//Filial
If !Empty(mv_par01)
    cWhere += mv_par01
EndIf

//Matricula
If !Empty(mv_par02)
	cWhere += Iif(!Empty(cWhere)," AND ","")
	cWhere += mv_par02
EndIf

//Periodo inicial
cWhere += Iif(!Empty(cWhere)," AND ","")
cWhere += "RD_DATARQ >= '" + mv_par03 + "' "

//Periodo final
cWhere += "AND RD_DATARQ <= '" + mv_par04 + "' "

cWhere += "AND RD_ROTEIR = '" + cRot131 + "' "

//Prepara a vari�vel para uso no BeginSql
cWhere := "%" + cWhere + "%"

//Processa a query e cria a tabela tempor�ria com os resultados
BeginSql alias cAliasQry
	SELECT DISTINCT SRD.RD_FILIAL, SRD.RD_MAT
    FROM %table:SRD% SRD
	WHERE %exp:cWhere% AND
            SRD.%notDel%
EndSql 

While (cAliasQry)->( !EoF() )
    //Carrega o array aCodFol para verificar o cadastro de verbas x Ids de c�lculo
    If (cAliasQry)->RD_FILIAL != cFilOld
        cFilOld := (cAliasQry)->RD_FILIAL
        RstaCodFol()
        Fp_CodFol(@aCodFol, (cAliasQry)->RD_FILIAL, .F., .F.)  
    EndIf
    
    //--Exclui registros existentes na SRC
    cQuery := "UPDATE " + RetSqlName("SRD") + " "
    cQuery += "SET RD_PD = (CASE WHEN RD_PD = '" + aCodFol[0123, 1] + "' THEN '" + aCodFol[1628, 1]  + "' "
    cQuery +=                       "WHEN RD_PD = '" + aCodFol[0124, 1] + "' THEN '" + aCodFol[1629, 1]  + "' "
    cQuery +=                       "WHEN RD_PD = '" + aCodFol[1288, 1] + "' THEN '" + aCodFol[1630, 1]  + "' "
    cQuery +=                       "WHEN RD_PD = '" + aCodFol[1289, 1] + "' THEN '" + aCodFol[1631, 1]  + "' "
    cQuery +=                       "WHEN RD_PD = '" + aCodFol[1290, 1] + "' THEN '" + aCodFol[1632, 1]  + "' "
    cQuery +=                       "WHEN RD_PD = '" + aCodFol[1291, 1] + "' THEN '" + aCodFol[1633, 1]  + "' "
    cQuery +=                       "WHEN RD_PD = '" + aCodFol[1292, 1] + "' THEN '" + aCodFol[1634, 1]  + "' "
    cQuery +=                       "WHEN RD_PD = '" + aCodFol[1293, 1] + "' THEN '" + aCodFol[1635, 1]  + "' "
    cQuery +=                       "WHEN RD_PD = '" + aCodFol[1294, 1] + "' THEN '" + aCodFol[1636, 1]  + "' "
    cQuery +=                       "WHEN RD_PD = '" + aCodFol[1295, 1] + "' THEN '" + aCodFol[1637, 1]  + "' "
    cQuery +=                       "WHEN RD_PD = '" + aCodFol[1436, 1] + "' THEN '" + aCodFol[1639, 1]  + "' "
    cQuery +=                       "WHEN RD_PD = '" + aCodFol[1437, 1] + "' THEN '" + aCodFol[1640, 1]  + "' "
    cQuery +=                       "WHEN RD_PD = '" + aCodFol[1438, 1] + "' THEN '" + aCodFol[1641, 1]  + "' "
    cQuery +=                       "WHEN RD_PD = '" + aCodFol[1439, 1] + "' THEN '" + aCodFol[1642, 1]  + "' "
    cQuery +=                       "WHEN RD_PD = '" + aCodFol[1440, 1] + "' THEN '" + aCodFol[1643, 1]  + "' "
    cQuery +=                       "WHEN RD_PD = '" + aCodFol[1441, 1] + "' THEN '" + aCodFol[1644, 1]  + "' "
    cQuery +=                       "WHEN RD_PD = '" + aCodFol[1442, 1] + "' THEN '" + aCodFol[1645, 1]  + "' "
    cQuery +=                       "WHEN RD_PD = '" + aCodFol[1443, 1] + "' THEN '" + aCodFol[1646, 1]  + "' "
    cQuery +=                       "WHEN RD_PD = '" + aCodFol[1444, 1] + "' THEN '" + aCodFol[1647, 1]  + "' "
    cQuery +=                       "WHEN RD_PD = '" + aCodFol[1445, 1] + "' THEN '" + aCodFol[1648, 1]  + "' "
    cQuery +=                       "WHEN RD_PD = '" + aCodFol[0181, 1] + "' THEN '" + aCodFol[1649, 1]  + "' "
    cQuery +=                       "WHEN RD_PD = '" + aCodFol[0182, 1] + "' THEN '" + aCodFol[1650, 1]  + "' "
    cQuery +=                       "WHEN RD_PD = '" + aCodFol[1651, 1] + "' THEN '" + aCodFol[1653, 1]  + "' "
    cQuery +=                       "WHEN RD_PD = '" + aCodFol[1652, 1] + "' THEN '" + aCodFol[1654, 1]  + "' "
    cQuery +=                       "ELSE RD_PD END) "
    cQuery += "WHERE RD_FILIAL = '" + (cAliasQry)->RD_FILIAL + "' AND "
    cQuery +=       "RD_MAT = '" + (cAliasQry)->RD_MAT + "' AND "
    cQuery +=       "RD_DATARQ >= '" + mv_par03 + "' AND "
    cQuery +=       "RD_DATARQ <= '" + mv_par04 + "' AND "
    cQuery +=       "RD_ROTEIR = '" + cRot131 + "' AND "
    cQuery +=       "D_E_L_E_T_ = ' '"

    TcSqlExec( cQuery )

    TcRefresh( InitSqlName("SRD") )

    //Adiciona no log de ocorr�ncias
    aAdd( aLog[1], "Filial: " + (cAliasQry)->RD_FILIAL + "  -  Matr�cula: " + (cAliasQry)->RD_MAT )
    
    //Pula para o pr�ximo registro
    (cAliasQry)->( dbSkip() )
EndDo

//Fecha a tabela tempor�ria da query
(cAliasQry)->( dbCloseArea() )

Return

/*/{Protheus.doc} fCriaSX1
Fun��o que cria as perguntas que ser�o utilizdas na rotina
/*/
Static Function fCriaSX1()

Local aHelpPor := {}

AAdd( aHelpPor, "Informe o per�odo inicial para a" )
AAdd( aHelpPor, "gera��o da verba de base." )
EngHLP117( "P"+".UPDVB13103.", aHelpPor, aHelpPor, aHelpPor )

aHelpPor := {}
AAdd( aHelpPor, "Informe o per�odo final para a" )
AAdd( aHelpPor, "gera��o da verba de base." )
EngHLP117( "P"+".UPDVB13104.", aHelpPor, aHelpPor, aHelpPor )

//			<cGrupo>	, <cOrdem>	, <cPergunt>				, <cPerSpa>	, <cPerEng>		, <cVar>	,<cTipo>	,<nTamanho>	,<nDecimal>		, <nPresel>		,<cGSC>	,<cValid>							,<cF3>		,<cGrpSxg>	,<cPyme>	,<cVar01>			,<cDef01> 		,<cDefSpa1>		,<cDefEng1>		,<cCnt01>		,<cDef02>				,<cDefSpa2>				,<cDefEng2>			,<cDef03>	, <cDefSpa3>	,<cDefEng3>		, <cDef04>	,<cDefSpa4>		, <cDefEng4>	,<cDef05>		, <cDefSpa5>	, <cDefEng5>	, <aHelpPor>, <aHelpEng>	, <aHelpSpa>	, <cHelp> )
EngSX1117( cPerg 	    , "01" 		,"Filial ?"			 		, ""		, ""		 	, "MV_CH1" 	, "C" 		, 99		,0				, 0	   			, "R" 	, ""								, "XM0" 	, ""		, "S" 		, "MV_PAR01" 		, "" 	   		, "" 			, "" 			, "RD_FILIAL"	, "" 					, ""					, "" 	 			, "" 		, "" 			, "" 			, "" 		, ""	 		, ""	  	 	, ""			, "" 		 	, ""	  		, {}	   	, {}   			, {} 			, ".RHFILDE."	)
EngSX1117( cPerg 	    , "02" 		,"Matr�cula ?"	 			, "" 		, ""			, "MV_CH2"	, "C" 		, 99   		,0	  			, 0	  	 		, "R" 	, ""								, "SRA" 	, "" 		, "S" 		, "MV_PAR02" 		, "" 	  		, "" 			, "" 			, "RD_MAT"		, "" 					, ""					, "" 	 			, "" 		, "" 			, "" 			, "" 	 	, ""	  		, ""	   		, ""		  	, "" 		 	, ""	  		, {}	   	, {} 			, {} 			, ".RHMATD."	)
EngSX1117( cPerg 	    , "03"		,"Per�odo inicial? (AAAAMM)", ""		, ""	        , 'MV_CH3'	, 'C'		, 6			,0				, 0				, 'G'	, 'NaoVazio()'						, ""		, ""		, "S"		, "MV_PAR03"		, "" 	   		, ""			, "" 	   		, ""			, "" 					, "" 					, "" 	 			, ""	  	, ""	   		, ""		  	, "" 		, ""	  		, ""	   		, "" 			, "" 			, ""	  		, {}	   	, {} 			, {} 			, ".UPDVB13103."	)
EngSX1117( cPerg 	    , "04"		,"Per�odo final? (AAAAMM)"	, ""		, ""	        , 'MV_CH4'	, 'C'		, 6			,0				, 0				, 'G'	, 'NaoVazio()'						, ""		, ""		, "S"		, "MV_PAR04"		, "" 			, ""			, "" 	   		, ""			, "" 					, "" 					, "" 	 			, ""	  	, ""	   		, ""		  	, "" 		, ""	  		, ""	   		, "" 			, "" 			, ""	  		, {}	   	, {} 			, {} 			, ".UPDVB13104."	)

Return