/*
=====================================================================================================================================
         							ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL
=====================================================================================================================================
	Autor	|	Data	|										Motivo																
------------:-----------:-----------------------------------------------------------------------------------------------------------:
 Tiago Lucio| 10/04/2018| 	Adequa��o e  altera��es diversas de acordo com a necessidade do cliente																										
------------:-----------:-----------------------------------------------------------------------------------------------------------:
			|			| 																										
=====================================================================================================================================
*/
#include "totvs.ch"
#include "protheus.ch"
#include "topconn.ch"

/*
===============================================================================================================================
Programa----------: RGPE005
Autor-------------: Ariclenes M. Costa
Data da Criacao---: 17/01/2016
===============================================================================================================================
Descri��o---------: Relatorio Construido
===============================================================================================================================
Uso---------------: Modulo Gest�o de Pessoal
===============================================================================================================================
Parametros--------:
===============================================================================================================================
Retorno-----------:
===============================================================================================================================
Chamado(SPS)------:
===============================================================================================================================
Setor-------------: Gest�o de Pessoal
===============================================================================================================================
*/
User Function RGPE005()

	Private cPerg := "RGPE005"
	Private oReport
	Private lInverte	:= .F.
	Private cMarca	:= GetMark()
	Private nCity
	Private cTpCli
	Private _cNumPC

	SetPrvt("oDlg","oSay")

	CriaSX1(cPerg)
	Pergunte(cPerg,.T.,'Relat�rio ferias vencidas')

	sfPrint()

Return

/*
===============================================================================================================================
Programa----------: sfPrint
Autor-------------: Ariclenes M. Co
Data da Criacao---: 27/01/16
===============================================================================================================================
Descri��o---------:
===============================================================================================================================
Uso---------------: Gest�o de Pessoal
===============================================================================================================================
Parametros--------:
===============================================================================================================================
Retorno-----------:
===============================================================================================================================
*/
Static Function sfPrint()

	oReport := ReportDef()
	oReport:PrintDialog()

Return

/*
===============================================================================================================================
Programa----------: ReportDef
Autor-------------: Ariclenes M. Co
Data da Criacao---: 27/01/16
===============================================================================================================================
Descri��o---------:
===============================================================================================================================
Uso---------------: Gest�o de Pessoal
===============================================================================================================================
Parametros--------:
===============================================================================================================================
Retorno-----------:
===============================================================================================================================
*/
Static Function ReportDef()

	Private oReport,oSecZ0
	Private aTam := {}

	oReport := TReport():New("RGPE005","Relatorio ferias vencidas",,{|oReport|PrintReport(oReport)},"Relatorio ferias vencidas")

	oReport:lParamPage	:= .T.
	oReport:lHeaderVisible := .F.
	oReport:lFooterVisible := .F.
	//oReport:SetLandscape()
	oReport:nLineHeight	:= 45

Return oReport

/*
===============================================================================================================================
Programa----------: PrintReport
Autor-------------: Ariclenes M. Co
Data da Criacao---: 27/01/16
===============================================================================================================================
Descri��o---------: Responsavel por montar o relatorio
===============================================================================================================================
Uso---------------: Gest�o de Pessoal
===============================================================================================================================
Parametros--------:
===============================================================================================================================
Retorno-----------:
===============================================================================================================================
*/
Static Function PrintReport()

	Local nTamMax		:= oReport:PageWidth()- 50 //Tamanho m�ximo da p�gina
	Local nTamMid		:= (oReport:PageWidth()/2) //Metade da p�gina
	Local nWrtMid		:= nTamMid + 10 //Impress�o de dados a partir do meio da p�gina

	Local cQuery 	:= ""

	//Declaracao das Fontes
	Private oFont8 		:= TFont():New("COURIER NEW",08,08,,.F.,,,,.T.,.F.)
	Private oFont8N		:= TFont():New("COURIER NEW",08,08,,.T.,,,,.T.,.F.)
	Private oFont9 		:= TFont():New("COURIER NEW",09,09,,.F.,,,,.T.,.F.)
	Private oFont9N		:= TFont():New("COURIER NEW",09,09,,.T.,,,,.T.,.F.)
	Private oFont10 	:= TFont():New("COURIER NEW",10,10,,.F.,,,,.T.,.F.)
	Private oFont10N	:= TFont():New("COURIER NEW",10,10,,.T.,,,,.T.,.F.)
	Private oFont10NS	:= TFont():New("COURIER NEW",10,10,,.T.,,,,.T.,.T.)
	Private oFont12 	:= TFont():New("COURIER NEW",12,12,,.F.,,,,.T.,.F.)
	Private oFont12N	:= TFont():New("COURIER NEW",12,12,,.T.,,,,.T.,.F.)
	Private oFont12NS	:= TFont():New("COURIER NEW",12,12,,.T.,,,,.T.,.T.)
	Private oFont14 	:= TFont():New("COURIER NEW",14,14,,.F.,,,,.T.,.F.)
	Private oFont14N	:= TFont():New("COURIER NEW",14,14,,.T.,,,,.T.,.F.)
	Private oFont16 	:= TFont():New("COURIER NEW",16,16,,.F.,,,,.T.,.F.)
	Private oFont16N	:= TFont():New("COURIER NEW",16,16,,.T.,,,,.T.,.F.)
	Private oFont16NS	:= TFont():New("COURIER NEW",16,16,,.T.,,,,.T.,.T.)

	Private _aDados		:=	{}
	Private _nSumVerb	:=	0
	Private _cCC		:=	""

	//SR8
	cQuery := "	SELECT SRA.RA_MAT, SRA.RA_NOME, SRF.RF_DATABAS,SRF.RF_DATAFIM, SRF.RF_DFERVAT, SRF.RF_DFERAAT, SRA.RA_ADMISSA, SRA.RA_CC, SRA.RA_CODFUNC, SRA.RA_SITFOLH, SRA.RA_CATFUNC "
	cQuery += " FROM "+RETSQLNAME("SRA")+" SRA, "+RETSQLNAME("SRF")+" SRF, "+RETSQLNAME("CTT")+" CTT "
	cQuery += "	WHERE SRA.D_E_L_E_T_ <> '*'                                                                   							"
	cQuery += "		AND SRF.D_E_L_E_T_ <> '*'                                                                     							"
	cQuery += "		AND SRA.RA_FILIAL BETWEEN '"+mv_par01+"' AND '"+mv_par02+"'                                                             "
	cQuery += "		AND SRF.RF_FILIAL= SRA.RA_FILIAL                                            											"
	cQuery += "		AND SRA.RA_MAT BETWEEN '"+mv_par03+"' AND '"+mv_par04+"'																"
	cQuery += "		AND SRA.RA_CC BETWEEN '"+mv_par05+"' AND '"+mv_par06+"'																		"
	cQuery += "		AND SRA.RA_FILIAL = SRF.RF_FILIAL                                                               						"
	cQuery += "		AND SRA.RA_MAT = SRF.RF_MAT                                                                     						"
	cQuery += "		AND SRF.RF_STATUS = '1'                                                                    								"
	cQuery += "		AND (SRF.RF_DFERVAT > 0   OR  SRF.RF_DFERAAT > 0 )                                                 						" 
	cQuery += "		AND CTT.CTT_CUSTO = SRA.RA_CC                                                                                           "
	cQuery += "		AND CTT.CTT_FILIAL ='"+xFilial("CTT")+"'                                                                                "
	If mv_par11 == 1
		cQuery += "	ORDER BY SRA.RA_NOME, SRF.RF_DATABAS			                                                               						"
	Else
		cQuery += "	ORDER BY CTT.CTT_DESC01, SRA.RA_NOME, SRF.RF_DATABAS			                                                               						"
	EndIf

	If Select ("Qry") <> 0
		Qry->(dbCloseArea())
	EndIf

	cQuery := changeQuery(cQuery)

	dbUseArea(.T.,"TOPCONN",TCGenQry(,,cQuery),"Qry",.F.,.T.)

	Qry->(dbGoTop())

	oReport:Say(oReport:Row(),oReport:PageWidth() * 0.37, "RELAT�RIO F�RIAS VENCIDAS"						,oFont16N)
	oReport:SkipLine(3)

	oReport:ThinLine()

	oReport:Say(oReport:Row(),oReport:PageWidth() * 0.01, "Matr�cula"										,oFont9n)
	oReport:Say(oReport:Row(),oReport:PageWidth() * 0.08, "Nome"											,oFont9n)
	oReport:Say(oReport:Row(),oReport:PageWidth() * 0.35, "In�cio per�odo"									,oFont9n)
	oReport:Say(oReport:Row(),oReport:PageWidth() * 0.45, "Fim per�odo"									,oFont9n)
	oReport:Say(oReport:Row(),oReport:PageWidth() * 0.55, "Fer. Vencidas"									,oFont9n)
	oReport:Say(oReport:Row(),oReport:PageWidth() * 0.65, "Fer. Prop."										,oFont9n)
	oReport:Say(oReport:Row(),oReport:PageWidth() * 0.75, "Cargo"											,oFont9n)

	oReport:SkipLine(1)
	oReport:ThinLine()

	While Qry->(!Eof())
		If Qry->RA_SITFOLH $ mv_par09
			If Qry->RA_CATFUNC $ mv_par10
				oReport:SkipLine(2)
				oReport:Say(oReport:Row(),oReport:PageWidth() * 0.01, Qry->RA_MAT													,oFont9)
				oReport:Say(oReport:Row(),oReport:PageWidth() * 0.08, Qry->RA_NOME													,oFont9)
				oReport:Say(oReport:Row(),oReport:PageWidth() * 0.35, DTOC(STOD(Qry->RF_DATABAS))									,oFont9)
				oReport:Say(oReport:Row(),oReport:PageWidth() * 0.45, DTOC(STOD(Qry->RF_DATAFIM))									,oFont9)
				oReport:Say(oReport:Row(),oReport:PageWidth() * 0.55, CvalToChar(Qry->RF_DFERVAT)									,oFont9)
				oReport:Say(oReport:Row(),oReport:PageWidth() * 0.65, CValToChar(Qry->RF_DFERAAT)									,oFont9)
			//	oReport:Say(oReport:Row(),oReport:PageWidth() * 0.55, DTOC(STOD(Qry->RA_ADMISSA))									,oFont9)
			//	oReport:Say(oReport:Row(),oReport:PageWidth() * 0.65, Posicione("SRJ",1,xFilial("SRJ")+Qry->RA_CODFUNC,"RJ_DESC")	,oFont9)
				oReport:Say(oReport:Row(),oReport:PageWidth() * 0.75, Posicione("CTT",1,xFilial("CTT")+Qry->RA_CC,"CTT_DESC01") 	,oFont9)
			EndIf
		EndIf
		Qry->(dbSkip())
	EndDo

	oReport:EndPage()

Return

/*
===============================================================================================================================
Programa----------: CriaSX1
Autor-------------: Vin�cius Fernandes
Data da Criacao---: 12/08/15
===============================================================================================================================
Descri��o---------: Cria a pergunta que recebe o parametro
===============================================================================================================================
Uso---------------: Gest�o de Pessoal
===============================================================================================================================
Parametros--------:
===============================================================================================================================
Retorno-----------:
===============================================================================================================================
*/
Static Function CriaSX1(cPerg)

	//Aqui utilizo a fun��o U_xPutSx1, ela cria a pergunta na tabela de perguntas
	/*
	U_xPutSx1(cPerg, "01", "Filial De"	  			, "", "", "mv_ch1", "C", tamSx3("RA_FILIAL")[1]	, 0, 0, "G", ""				, "FWSM0"	, ""	, "", "mv_par01")
	U_xPutSx1(cPerg, "02", "Filial At�"	  			, "", "", "mv_ch2", "C", tamSx3("RA_FILIAL")[1]	, 0, 0, "G", ""				, "FWSM0"	, ""	, "", "mv_par02")
	
	
	U_xPutSx1(cPerg, "03", "Matricula De"	  			, "", "", "mv_ch3", "C", tamSx3("RA_MAT")[1]	, 0, 0, "G", ""				, "SRA"	, ""	, "", "mv_par03")
	U_xPutSx1(cPerg, "04", "Matricula At�"	  			, "", "", "mv_ch4", "C", tamSx3("RA_MAT")[1]	, 0, 0, "G", ""				, "SRA"	, ""	, "", "mv_par04")

	U_xPutSx1(cPerg, "05", "Centro de Custos De"	  	, "", "", "mv_ch5", "C", tamSx3("RA_CC")[1]		, 0, 0, "G"					, ""	, "CTT"	, "", "mv_par05")
	U_xPutSx1(cPerg, "06", "Centro de Custos At�"	  	, "", "", "mv_ch6", "C", tamSx3("RA_CC")[1]		, 0, 0, "G"					, ""	, "CTT"	, "", "mv_par06")

	U_xPutSx1(cPerg, "09", "Situacao Funcion�rio"	  	, "", "", "mv_ch9", "C", 5						, 0, 0, "G", "fSituacao"	, ""   	, "ZAK"	, "", "mv_par09")

	U_xPutSx1(cPerg, "10","Categorias funcion�rio."	, "", "","mv_ch10", "C", 15						, 0, 0, "G", "fCategoria"	, ""	, "ZAK"	, "", "mv_par10")

	U_xPutSx1(cPerg, "11", "Ordena��o"	  				, "", "", "mv_ch11", "N", 15						, 0, 1, "C", ""				, ""	, ""	, "S","mv_par11", "Nome Funcionario","","","","Centro de Custos")
*/
Return
