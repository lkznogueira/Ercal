#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "TBICONN.CH"
#DEFINE CRLF CHR(13)+CHR(10)

/*
_____________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦Programa  ¦ MT110TEL    ¦ Autor ¦ Totvs              ¦ Data ¦ 13/08/13 ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Descriçào ¦ Implementacao do P. de Entrada MT110TEL. Usado no MATA110  ¦¦¦
¦¦¦          ¦ esse Ponto de Entrada Ira permitir incluir informacoes     ¦¦¦
¦¦¦          ¦ no Cabecalho da SC. Trabalha em conjunto com o Ponto       ¦¦¦
¦¦¦          ¦ de Entrada MT110GET.                                       ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Uso       ¦ Mineração Montividiu                                       ¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
*/

User Function MT110TEL()
		
	Local oC1XDESNAT //Sangelles
    Local OC1XNOMCC  //Sangelles

	//C1_XNATURE e C1_XDESNAT
	Local bXNATUREVld	:= { || ( __ReadVar := "M->C1_XNATURE" , M->C1_XNATURE := cC1XNATURE , IF( !empty(M->C1_XNATURE) , cC1XDESNAT := POSICIONE("SED",1,xFilial("SED")+M->C1_XNATURE,"ED_DESCRIC") , cC1XDESNAT := "" ) ,IF( CheckSX3( "C1_XNATURE" , @cC1XNATURE ) , ( oC1XDESNAT:SetFocus() , .T. ) , .F. ) )  }
	Local bXDESNATVld	:= { || ( __ReadVar := "M->C1_XDESNAT" , M->C1_XDESNAT := cC1XDESNAT , CheckSX3( "C1_XDESNAT" , @cC1XDESNAT ) ) }
	
	//C1_CC e C1_XNOMCC
	Local bCCVld	    := { || ( __ReadVar := "M->C1_CC" , M->C1_CC := cC1CC , IF( !empty(M->C1_CC) , cC1XNOMCC := POSICIONE("CTT",1,xFilial("CTT")+M->C1_CC,"CTT_DESC01") , cC1XNOMCC := "" ) ,IF( CheckSX3( "C1_CC" , @cC1CC ) , ( oC1XNOMCC:SetFocus() , .T. ) , .F. ) )  }
	Local bXNOMCCVld	:= { || ( __ReadVar := "M->C1_XNOMCC" , M->C1_XNOMCC := cC1XNOMCC , CheckSX3( "C1_XNOMCC" , @cC1XNOMCC ) ) }
	
	Local bXNATUREWhen	:= { || INCLUI .or. ALTERA } //{ || INCLUI .and. !( M->C1_XNATURE ) } 
	Local bXDESNATWhen	:= { || INCLUI .and. ALTERA } //{ || IF( !( M->C1_XNATURE ) , cC1XDESNAT := Ctod("//") , .T. ) , INCLUI .and. M->C1_XNATURE .and. Empty( M->C1_XDESNAT ) }
	
	Local bCCWhen	    := { || INCLUI .or. ALTERA }
	Local bXNOMCCWhen	:= { || INCLUI .and. ALTERA }
	
	Local oDlg
	Local aPosGet
	Local nOpcx
	Local nReg

	Public cC1XNATURE  := SPACE(10)
	Public cC1XDESNAT  := SPACE(50)
		
	Public cC1CC       := SPACE(9)
	Public cC1XNOMCC   := SPACE(60)

	oDlg		:= ParamIxb[1]
	aPosGet		:= ParamIxb[2]
	nOpcx		:= ParamIxb[3]
	nReg		:= Paramixb[4]

    If nOpcx <> 3
		cC1XNATURE  := SC1->C1_XNATURE
		cC1XDESNAT  := SC1->C1_XDESNAT
		
		cC1CC       := SC1->C1_CC
		cC1XNOMCC   := POSICIONE("CTT",1,xFilial("CTT")+SC1->C1_CC,"CTT_DESC01")
	Endif
    /**                                               
    * 25/07/2016
    * ALTERAÇAO PARA TESTAR POSIÇAO DO CABEÇALHO DA SC
    
	@ 40,aPosGet[1,1] SAY GetSx3Cache( "C1_XNATURE" , "X3_TITULO" ) 										OF oDlg PIXEL SIZE 045,009
	@ 39,aPosGet[1,2] MSGET oC1XNATURE VAR cC1XNATURE F3 CpoRetF3("C1_XNATURE") Picture PesqPict("SC1","C1_XNATURE") VALID Eval(bXNATUREVld).AND.(IIF(SED->ED_TIPO=='2',.T.,EVAL({||alert("Natureza somente analitica"),.F.})))	WHEN Eval( bXNATUREWhen )	OF oDlg PIXEL SIZE 040,010

	@ 40,aPosGet[1,3] SAY GetSx3Cache( "C1_XDESNAT" , "X3_TITULO" ) 										OF oDlg PIXEL SIZE 045,009
	@ 39,aPosGet[1,4] MSGET oC1XDESNAT VAR cC1XDESNAT VALID Eval( bXDESNATVld ) WHEN Eval( bXDESNATWhen )	OF oDlg PIXEL SIZE 140,010
	
	//soma 14 posições 40+14 = 54
	@ 54,aPosGet[1,1] SAY GetSx3Cache( "C1_CC"     , "X3_TITULO" ) 										OF oDlg PIXEL SIZE 045,009
	@ 53,aPosGet[1,2] MSGET oC1CC VAR cC1CC F3 CpoRetF3("C1_CC") Picture PesqPict("SC1","C1_CC") VALID Eval( bCCVld )	WHEN Eval( bCCWhen )	OF oDlg PIXEL SIZE 040,010

	@ 54,aPosGet[1,3] SAY GetSx3Cache( "C1_XNOMCC" , "X3_TITULO" ) 										OF oDlg PIXEL SIZE 045,009
	@ 53,aPosGet[1,4] MSGET oC1XNOMCC VAR cC1XNOMCC VALID Eval( bXNOMCCVld ) WHEN Eval( bXNOMCCWhen )	OF oDlg PIXEL SIZE 140,010
	*/
	
	
	if oApp:cVersion < "12"
		@ 40,aPosGet[1,1] SAY GetSx3Cache( "C1_XNATURE" , "X3_TITULO" ) 										OF oDlg PIXEL SIZE 45,9
		@ 39,aPosGet[1,2] MSGET oC1XNATURE VAR cC1XNATURE F3 CpoRetF3("C1_XNATURE") Picture PesqPict("SC1","C1_XNATURE") VALID Eval(bXNATUREVld).AND.(IIF(SED->ED_TIPO=='2',.T.,EVAL({||alert("Natureza somente analitica"),.F.})))	WHEN Eval( bXNATUREWhen )	OF oDlg PIXEL SIZE 40,10

		@ 40,aPosGet[1,3] SAY GetSx3Cache( "C1_XDESNAT" , "X3_TITULO" ) 										OF oDlg PIXEL SIZE 45,9
		@ 39,aPosGet[1,4] MSGET oC1XDESNAT VAR cC1XDESNAT VALID Eval( bXDESNATVld ) WHEN Eval( bXDESNATWhen )	OF oDlg PIXEL SIZE 140,010
	
		//soma 14 posições 40+14 = 54
		@ 54,aPosGet[1,1] SAY GetSx3Cache( "C1_CC"     , "X3_TITULO" ) 										OF oDlg PIXEL SIZE 45,9
		@ 53,aPosGet[1,2] MSGET oC1CC VAR cC1CC F3 CpoRetF3("C1_CC") Picture PesqPict("SC1","C1_CC") VALID Eval( bCCVld )	WHEN Eval( bCCWhen )	OF oDlg PIXEL SIZE 10,08

		@ 54,aPosGet[1,3] SAY GetSx3Cache( "C1_XNOMCC" , "X3_TITULO" ) 										OF oDlg PIXEL SIZE 45,9
		@ 53,aPosGet[1,4] MSGET oC1XNOMCC VAR cC1XNOMCC VALID Eval( bXNOMCCVld ) WHEN Eval( bXNOMCCWhen )	OF oDlg PIXEL SIZE 140,010

    else
		@ 40+28,aPosGet[1,1] SAY GetSx3Cache( "C1_XNATURE" , "X3_TITULO" ) 										OF oDlg PIXEL SIZE 45,9
		@ 39+28,aPosGet[1,2] MSGET oC1XNATURE VAR cC1XNATURE F3 CpoRetF3("C1_XNATURE") Picture PesqPict("SC1","C1_XNATURE") VALID Eval(bXNATUREVld).AND.(IIF(SED->ED_TIPO=='2',.T.,EVAL({||alert("Natureza somente analitica"),.F.})))	WHEN Eval( bXNATUREWhen )	OF oDlg PIXEL SIZE 40,10

		@ 40+28,aPosGet[1,3] SAY GetSx3Cache( "C1_XDESNAT" , "X3_TITULO" ) 										OF oDlg PIXEL SIZE 45,9
		@ 39+28,aPosGet[1,4] MSGET oC1XDESNAT VAR cC1XDESNAT VALID Eval( bXDESNATVld ) WHEN Eval( bXDESNATWhen )	OF oDlg PIXEL SIZE 140,010
	
		//soma 14 posições 40+14 = 54
		@ 54+28,aPosGet[1,1] SAY GetSx3Cache( "C1_CC"     , "X3_TITULO" ) 										OF oDlg PIXEL SIZE 45,9
		@ 53+28,aPosGet[1,2] MSGET oC1CC VAR cC1CC F3 CpoRetF3("C1_CC") Picture PesqPict("SC1","C1_CC") VALID Eval( bCCVld )	WHEN Eval( bCCWhen )	OF oDlg PIXEL SIZE 10,08

		@ 54+28,aPosGet[1,3] SAY GetSx3Cache( "C1_XNOMCC" , "X3_TITULO" ) 										OF oDlg PIXEL SIZE 45,9
		@ 53+28,aPosGet[1,4] MSGET oC1XNOMCC VAR cC1XNOMCC VALID Eval( bXNOMCCVld ) WHEN Eval( bXNOMCCWhen )	OF oDlg PIXEL SIZE 140,010

    endif
Return( .T. )