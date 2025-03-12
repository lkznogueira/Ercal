#include "protheus.ch"
#include "Topconn.ch"
#INCLUDE "SPEDNFE.ch"
#INCLUDE "APWIZARD.CH"
#INCLUDE "FILEIO.CH"
#INCLUDE "RPTDEF.CH"
#INCLUDE "FWPrintSetup.ch"
#INCLUDE "COLORS.CH"
#INCLUDE "FONT.CH"

#DEFINE BUFFER_LEITURA	32
#DEFINE PORTASERIAL  'S'
#DEFINE PORTATCPIP   'T'
#DEFINE MSECONDS_WAIT 		1000
#DEFINE TRIES_TO_CONNECT 	3
#DEFINE TRIES_TO_READ    	3

//#define PD_ISTOTVSPRINTER 		:= 01
//#define PD_DISABLEDESTINATION	:= 02
//#define PD_DISABLEORIENTATION	:= 04
//#define PD_DISABLEPAPERSIZE		:= 08
//#define PD_DISABLEPREVIEW		:= 16

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFAT002     บAutor  Gontijo Consultoria   บ Data ณ  29/07/13 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Tela para Visualiza็ใo de Ordens de Carregamentos          บฑฑ
ฑฑบ          ณ Novo Modelo Pesagem Balan็a                                บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ        ERCAL/BRITACAL                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿ 
*/

User Function FAT010()
	Local cAlias := "ZC3"
	Private cCadastro := "Ordem de Carregamento"
	Private aRotina   := {}
	Private aCores 	  := {}
	Private cArq
	Private cArq1
	Private lInverte  := .F.
	Private cMark     := GetMark()
	Private cMarkP    := GetMark()
	Private oMark
	Private oMarkP

	//Dbselectarea("EMP")

	AADD(aRotina, { "Pesquisar" 			, "AxPesqui"  		, 0, 1 })
	AADD(aRotina, { "Visualizar"			, "U_FAT010A(3)"    , 0, 2 })
	AAdd(aRotina, { "Incluir"				, "U_RFATA001(1)"	, 0 ,3 })
	AADD(aRotina, { "Excluir"   			, "U_FAT010F()"  	, 0, 4 })
	AADD(aRotina, { "Ticket Pesagem"		, "U_FATR001()"  	, 0, 5 })
	AADD(aRotina, { "Legenda" 				, "U_LegendaF()"  	, 0, 6 })      //AADD(aRotina, { "Faturar Ordem" , "u_FAT006()"  , 0, 8 })
	AADD(aRotina, { "Ordem de Carregamento" , "U_RFATR01()"  	, 0, 7 })
	AADD(aRotina, { "Rel.Saldo Contrato"	, "u_xFATR030()"		, 0	,8 })

	AADD(aCores, {'ZC3->ZC3_STATUS == "1"'	,'BR_AMARELO'   })	// Aguardando Carregamento
	AADD(aCores, {'ZC3->ZC3_STATUS == "2"'	,'BR_LARANJA'	}) 	// Aguardando Pesagem Final
	AADD(aCores, {'ZC3->ZC3_STATUS == "3"'	,'BR_AZUL'		})  // Aguardando Faturamento
	AADD(aCores, {'ZC3->ZC3_STATUS == "4"'	,'BR_VERMELHO'	})  // Pedido com Bloqueio
	AADD(aCores, {'ZC3->ZC3_STATUS == "5"'	,'BR_VERDE'		})	// Ordem Faturada

	dbSelectArea(cAlias)
	ZC3->(dbSetOrder(1))

	//F9 chama a rotina de legenda
	SetKey(VK_F9,{||LegendaF()})

	mBrowse( 6,1,22,75,cAlias,,,,,,aCores,,,,,,.T.,.T.)

Return()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณLegenda  บAutor  ณMicrosiga           บ Data ณ  08/09/13    บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Legenda                                                    บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Montividiu                                                 บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function LegendaF()
	Local cCadastro:= "Status Ordem de Carregamento"

	aCores1  := {{'BR_AMARELO',"Aguardando Carregamento" },;
		{'BR_LARANJA',"Aguardando Pesagem Final"},;
		{'BR_AZUL',"Aguardando Faturamento"},;
		{'BR_VERMELHO',"Pedido(s)com Bloqueio"},;
		{'BR_VERDE',"Ordem Faturada"}}

	BrwLegenda(cCadastro,"Ordem de Carregamento",acores1)

Return Nil

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRFATA001  บAutor  ณMicrosiga           บ Data ณ  06/25/17   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณPainel Integra็ใo com Balan็a Toledo.                       บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Montividiu                                                 บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function RFATA001()
	//Local aButtons := {}
	Local oBitmap1,oBitmap2,oBitmap3,oBitmap4,oButton1,oButton2,oButton3,oButton4
	Local oGroup1,oGroup2,oGroup3
	Local oSay5,oSay6,oSay7,oSay8,oSay9,oSay10,oSay11,oSay12,oSay13,oSay14,oSay15
	//Local oGet1
	//Local cGet1    := space(5)
	//Local oGet2
	//Local cGet2    := space(30)
	Local cBalEnt  := SuperGetMV("MV_BAL01",.F.,1)
	Local cBalSaid := SuperGetMV("MV_BAL02",.F.,2)
	//Local lCancel  := .F.
	//Local lbok     := .F.

	Loc	:= 0

	Public BFILTRABRW:= {|| .T.} //carlos Daniel verificar posicao sf2
	Public aFilBrw := {'SF2','.T.'}

	Private  cxOrdem        := Space(10)
	Private  dxData		    := Space(10)
	Private  cxHora         := Space(10)
	Private  oxCliente
	Private  cxCliente 		:= Space(50)
	Private  oxMotorista
	Private  cxMotorista 	:= Space(30)
	Private  oxPedido
	Private  cxNomCli       := Space(30)
	Private  cxPedido 		:= Space(10)
	Private  cxNomTrans     := Space(30)
	Private  oxNomTrans
	Private  oxNomMot
	Private  cxNomeMot	    := Space(30)
	Private  oxNomCli
	Private  oxLojaCli
	Private  cxLojaCli      := Space(2)
	Private  oxPlaca
	Private  cxPlaca 		:= Space(10)
	Private  oxTranspor
	Private  cxTranspor 	:= Space(30)
	Private  oxVeiculo
	Private  cxVeiculo 		:= Space(30)

	Private nxPesoIni 		:= 0
	Private nxPesoFim 		:= 0
	Private nxPesoLiq 		:= 0
	Private cMensagem 	:= "Status: Aguardando Selecionar o Contrato"
	Private oMensagem

	Private oxPesoIni
	Private oxPesoFim
	Private oxPesoLiq

	Private lExclPv		:= .F.
	Private lPesIni 	:= .F.
	Private lPesFim 	:= .F.
	Private lNFE    	:= .F.
	Private lDANFE   	:= .F.
	Private lTRNFE   	:= .F.
	Private lMTNFE   	:= .F.
	Private lDesconto   := .F.
	Private lMDFE		:= .F.

	Private nxVlFrete       := 0
	Private cxNota        := Space(9)
	Private cxNotaTrian    := Space(9)
	Private cxPedTriang		:= ""
	Private cxSerie        := ""
	Private nxVlFreau       := 0
	Private nxVlDesp        := 0
	Private oxPesoInf
	Private nxPesoInf		:= 0
	Private oxPesoCtr
	Private nxPesoCtr		:= 0
	Private oxDescont
	Private nxDescont       := 0

	Private oSay1
	Private oSay2
	Private oSay3
	Private oSay4

	Private oDlgTela


	cStartPath := GetPvProfString(GetEnvServer(),"StartPath","ERROR",GetAdv97())
	cStartPath += If(Right(cStartPath, 1) <> "\", "\", "")

	aSize := MsAdvSize(.F.)   //lEnchoiceBar = Parametro logico, indica se a tela possui Enchoice Bar
	aObjects := {}
	AAdd( aObjects, { 100 , 100 , .T. , .T. , .F. } )
	AAdd( aObjects, { 100 , 100 , .T. , .T. , .F. } )

	aInfo := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 5 , 5 , 5 , 5 }

	aPosObj := MsObjSize( aInfo, aObjects, .T. , .F. )


	DEFINE MSDIALOG oDlgTela TITLE "SISTEMA DE PESAGEM" FROM aSize[7], aSize[1]  TO aSize[6], aSize[5] COLORS 0, 16777215 PIXEL

	@ 002, aPosObj[1,2]+6 GROUP oGroup1 TO 076, aPosObj[1,4]-5 PROMPT "Dados do Pedido/Contrato" OF oDlgTela COLOR 0, 16777215 PIXEL

	Define Font oFont8 Name 'Courier New' BOLD Size 0, -25

	@ 007,450 TO 040,550 LABEL 'Peso Total Informado / Kg' OF oDlgTela PIXEL
	@ 017,450 SAY oxPesoInf PROMPT nxPesoInf SIZE 100, 15 Picture "@E 99,999,999.99" OF oDlgTela PIXEL Font oFont8 Color CLR_HRED

	@ 007,560 TO 040,660 LABEL 'Peso Total Contrato / Kg' OF oDlgTela PIXEL
	@ 017,560 SAY oxPesoCtr PROMPT nxPesoCtr SIZE 100, 15 Picture "@E 99,999,999.99" OF oDlgTela PIXEL Font oFont8 Color CLR_HRED

	@ 013, 013 SAY oSay1 PROMPT "Ordem" SIZE 025, 007 OF oDlgTela COLORS 0, 16777215 PIXEL
	@ 013, 107 SAY oSay2 PROMPT "Data " SIZE 025, 007 OF oDlgTela COLORS 0, 16777215 PIXEL
	@ 013, 200 SAY oSay3 PROMPT "Hora"  SIZE 025, 007 OF oDlgTela COLORS 0, 16777215 PIXEL

	@ 012, 041 MSGET oOrdem VAR cxOrdem  When .F.  SIZE 060, 010 OF oDlgTela COLORS 0, 16777215 PIXEL
	@ 012, 135 MSGET oData  VAR dxData   When .F.  SIZE 060, 010 OF oDlgTela COLORS 0, 16777215 PIXEL
	@ 012, 221 MSGET oHora  VAR cxHora   When .F.  SIZE 060, 010 OF oDlgTela COLORS 0, 16777215 PIXEL

	@ 027, 013 SAY oSay4 PROMPT "Cliente" SIZE 030, 007 OF oDlgTela COLORS 0, 16777215 PIXEL
	@ 027, 041 MSGET oxCliente VAR cxCliente When .F. SIZE 060, 010 OF oDlgTela COLORS 0, 16777215 PIXEL
	@ 027, 107 SAY oSay5 PROMPT "Loja" SIZE 019, 007 OF oDlgTela COLORS 0, 16777215 PIXEL
	@ 027, 135 MSGET oxLojaCli VAR cxLojaCli When .F. SIZE 036, 010 OF oDlgTela COLORS 0, 16777215 PIXEL
	@ 027, 200 SAY oSay6 PROMPT "Nome" SIZE 025, 007 OF oDlgTela COLORS 0, 16777215 PIXEL
	@ 027, 221 MSGET oxNomCli VAR cxNomCli When .F. SIZE 203, 010 OF oDlgTela COLORS 0, 16777215 PIXEL

	//@ 042, 013 SAY oSay7 PROMPT "Placa" SIZE 024, 007 OF oDlgTela COLORS 0, 16777215 PIXEL
	//@ 042, 041 MSGET oxPlaca VAR cxPlaca When .F. SIZE 060, 010 OF oDlgTela COLORS 0, 16777215 PIXEL
	@ 042, 013 SAY oSay8 PROMPT "Motorista" SIZE 025, 007 OF oDlgTela COLORS 0, 16777215 PIXEL
	@ 042, 041 MSGET oxMotorista VAR cxMotorista When .F. SIZE 060, 010 OF oDlgTela COLORS 0, 16777215 PIXEL
	@ 042, 107 SAY oSay9 PROMPT "Nome" SIZE 025, 007 OF oDlgTela COLORS 0, 16777215 PIXEL
	@ 042, 135 MSGET oxNomMot VAR cxNomeMot When .F. SIZE 203, 010 OF oDlgTela COLORS 0, 16777215 PIXEL

	@ 057, 013 SAY oSay10 PROMPT "Transp." SIZE 025, 007 OF oDlgTela COLORS 0, 16777215 PIXEL
	@ 056, 041 MSGET oxTranspor VAR cxTranspor When .F. SIZE 060, 010 OF oDlgTela COLORS 0, 16777215 PIXEL
	@ 057, 107 SAY oSay11 PROMPT "Nome" SIZE 025, 007 OF oDlgTela COLORS 0, 16777215 PIXEL
	@ 056, 135 MSGET oxNomTrans VAR cxNomTrans When .F. SIZE 156, 010 OF oDlgTela COLORS 0, 16777215 PIXEL

	@ 057, 300 SAY oSay12 PROMPT "Frete" SIZE 025, 007 OF oDlgTela COLORS 0, 16777215 PIXEL
	@ 056, 315 MSGET oxVlFrete VAR nxVlFrete Picture "@E 99,999,999.99" When .F. SIZE 060, 010 OF oDlgTela COLORS 0, 16777215 PIXEL

	@ 057, 389 SAY oSay13 PROMPT "Frete Aut" SIZE 034, 007 OF oDlgTela COLORS 0, 16777215 PIXEL
	@ 056, 416 MSGET oxVlFreau VAR nxVlFreau Picture "@E 99,999,999.99" When .F. SIZE 060, 010 OF oDlgTela COLORS 0, 16777215 PIXEL

	@ 057, 490 SAY oSay12 PROMPT "Desp.Fret" SIZE 025, 007 OF oDlgTela COLORS 0, 16777215 PIXEL
	@ 056, 520 MSGET oxVlDesp VAR nxVlDesp Picture "@E 99,999,999.99" When .F. SIZE 060, 010 OF oDlgTela COLORS 0, 16777215 PIXEL

	@ 057, 590 SAY oSay14 PROMPT "Desc Carregamento" SIZE 100, 007 OF oDlgTela COLORS 0, 16777215 PIXEL
	//@ 056, 595 MSGET oxDescont VAR nxDescont Picture "@E 99,999,999.99" WHEN lDesconto SIZE 060, 010 OF oDlgTela COLORS 0, 16777215 PIXEL  Valid ( BuscaPeso(3) )
	@ 056, 645 MSGET oxDescont VAR nxDescont Picture "@E 99,999,999.99" WHEN .F. SIZE 060, 010 OF oDlgTela COLORS 0, 16777215 PIXEL

	Define Font oFont3 BOLD Name 'Courier New' Size 0, -25
	Define Font oFont4 BOLD Name 'Arial' Size 0, -20 
	Define Font oFont5 BOLD Name 'Courier New' Size 0, -15
	Define Font oFont6 BOLD Name 'Arial' Size 0, -50
	oFont  := TFont():New('Courier new',,-40,.T.)
	oFont2 := TFont():New('Courier new',,-20,.T.)

	@ 076, aPosObj[1,2]+6 GROUP oGroup2 TO 140, aPosObj[1,4]-5 PROMPT "Dados da Pesagem" OF oDlgTela COLOR 0, 16777215 PIXEL

	// Cria Fonte para visualiza็ใo
	@ 080, 074 SAY oSay7  PROMPT "PESAGEM INICIAL" 	SIZE 100, 007 OF oDlgTela PIXEL Font oFont5 Color CLR_BLUE
	@ 080, 262 SAY oSay8  PROMPT "PESAGEM FINAL" 	SIZE 100, 007 OF oDlgTela PIXEL Font oFont5 Color CLR_BLUE
	@ 080, 455 SAY oSay9  PROMPT "PESO LIQUIDO" 	SIZE 100, 007 OF oDlgTela PIXEL Font oFont5 Color CLR_BLUE
	@ 110, 390 SAY oSay10 PROMPT "=" 				SIZE 010, 007 OF oDlgTela PIXEL Font oFont5 Color CLR_BLUE
	@ 080, 645 SAY oSay15  PROMPT "PLACA" 			SIZE 100, 007 OF oDlgTela PIXEL Font oFont5 Color CLR_BLUE

	@ 143, aPosObj[1,2]+6 GROUP oGroup3 TO 260, aPosObj[1,4]-5 OF oDlgTela COLOR 0, 16777215 PIXEL

	//Incluir Ordem de Carregamento "Pedido, Placa e Motorista"
	@ 155, 017 BUTTON oButton1  PROMPT "Selecionar Ordem Carregamento" 								SIZE 80, 025 OF oDlgTela PIXEL  Action ( MsgRun("Consultando Carregamentos ","Aguarde...", {||	SeleCarreg()	}) )
	@ 155, 100 BUTTON oButton2  PROMPT "Efetuar Pesagem Inicial" 			When lPesIni 			SIZE 80, 025 OF oDlgTela PIXEL  Action ( MsgRun("Efetuando Pesagem Inicial ","Aguarde...", {||	BuscaPeso(1,cBalEnt,cBalSaid)	}) )
	@ 155, 183 BUTTON oButton3  PROMPT "Efetuar Pesagem Final" 				When lPesFim			SIZE 80, 025 OF oDlgTela PIXEL  Action ( MsgRun("Efetuando Pesagem Final   ","Aguarde...", {||	BuscaPeso(2,cBalEnt,cBalSaid)	}) )
	@ 155, 266 BUTTON oButton4  PROMPT "Faturar Nota Fiscal Eletr๔nica" 	When lNFE 				SIZE 80, 025 OF oDlgTela PIXEL  Action ( MsgRun("Faturando Nota Fiscal     ","Aguarde...", {|| fOpcao(6)		}) )
	@ 155, 432 BUTTON oButton12 PROMPT "Transmitir NFE" 					When lTRNFE 			SIZE 80, 025 OF oDlgTela PIXEL  Action ( MsgRun("Transmitindo Nota Fiscal  ","Aguarde...", {|| eventoNFE("Transmissao") }) )
	@ 155, 515 BUTTON oButton12 PROMPT "Monitor/Faixa"  					When lDANFE .Or. lNFE	SIZE 80, 025 OF oDlgTela PIXEL  Action ( MsgRun("Monitorando Nota Fiscal   ","Aguarde...", {|| SpedNFe1Mnt()}) )
	@ 155, 598 BUTTON oButton12 PROMPT "Imprimir DANFE" 					When lDANFE 			SIZE 80, 025 OF oDlgTela PIXEL  Action ( MsgRun("Pesquisando Nota Fiscal   ","Aguarde...", {|| fOpcao(7)		}) )

	@ 200, 432 BUTTON oButton2  PROMPT "Incluir MDFe"						When lMDFE	 			SIZE 80, 025 OF oDlgTela PIXEL  Action ( MsgRun("Abrindo rotina MDFe"		,"Aguarde...", {||	SPEDMDFE()	}) )
	@ 200, 515 BUTTON oButton2  PROMPT "Excluir NFE/PV"						When lExclPv 			SIZE 80, 025 OF oDlgTela PIXEL  Action ( MsgRun("Excluindo Doc.Saida "		,"Aguarde...", {||	eventoNFE("Excluir")	}) )


	oButton1:SetCSS( getCSS('TBUTTON_01') )
	oButton2:SetCSS( getCSS('TBUTTON_01') )
	oButton3:SetCSS( getCSS('TBUTTON_01') )
	oButton4:SetCSS( getCSS('TBUTTON_01') )
	oButton12:SetCSS( getCSS('TBUTTON_01') )

	@ 245, 017 BUTTON oButton13 PROMPT "Incluir Carregamento" 		SIZE 075, 012 OF oDlgTela PIXEL  Action ( U_FAT010A(1) )  //Estorna Pesagem Final	  	  - Somente Visualizar. -- Que nใo tem Placa - Motorista
	@ 230, 017 BUTTON oButton07 PROMPT "Visualizar Carregamento" 	SIZE 075, 012 OF oDlgTela PIXEL  Action ( iif(!Empty(cxOrdem),fOpcao(5),"Selecione uma Ordem de Carregamento!") )
	If trim(cFilAnt) == '1009'
		@ 230, 123 BUTTON oButton14 PROMPT "Alterar Balancas" 		SIZE 075, 012 OF oDlgTela PIXEL  Action ( U_mVbal() )  //Estorna Pesagem Final	  	  - Somente Visualizar. -- Que nใo tem Placa - Motorista
	EndIf
	@ 245, 123 BUTTON oButton14 PROMPT "Estornar Pesag.Final" 		SIZE 075, 012 OF oDlgTela PIXEL  Action ( BuscaPeso(4) )  //Cadastros  Pendentes	  	  - Somente Visualizar. -- Que nใo tem Placa - Motorista
	@ 245, 203 BUTTON oButton11 PROMPT "Manutencao Carregamento" 	SIZE 075, 012 OF oDlgTela PIXEL  Action ( fOpcao(4) )  //manutencao carregamento	  - Somente Visualizar.
	@ 245, 283 BUTTON oButton10 PROMPT "Contrato Parceria" 			SIZE 075, 012 OF oDlgTela PIXEL  Action ( FATA400() )  //Contrato Parceria. - Alterando Somente Quantidade.
	@ 245, 363 BUTTON oButton9  PROMPT "Pedido de Venda" 			SIZE 075, 012 OF oDlgTela PIXEL  Action ( MATA410() )  //Pedidode Venda
	@ 245, 443 BUTTON oButton5  PROMPT "Rel Ordem Carregamento" 	SIZE 075, 012 OF oDlgTela PIXEL  Action ( fOpcao(1) )  //Relatorio Ordem Carregamento
	@ 245, 523 BUTTON oButton6  PROMPT "Rel Ticket Pesagem"			SIZE 075, 012 OF oDlgTela PIXEL  Action ( fOpcao(2) )  //Relatorio Ticket Pesagem
	@ 245, 605 BUTTON oButton8  PROMPT "Fechar" 					SIZE 055, 012 OF oDlgTela PIXEL  Action ( OdlgTela:End() )
	//oButton13:SetCss( CSS_BOTAO )
	oButton13:SetCSS( getCSS('TBUTTON_02') )
	@ 100, 045 SAY oxPesoIni  PROMPT nxPesoIni 				SIZE 200, 20   Picture "@E 99,999,999.99" OF oDlgTela PIXEL Font oFont3 Color CLR_HRED
	@ 100, 225 SAY oxPesoFim  PROMPT nxPesoFim 		   		SIZE 200, 20   Picture "@E 99,999,999.99" OF oDlgTela PIXEL Font oFont3 Color CLR_HRED
	@ 100, 415 SAY oxPesoLiq  PROMPT nxPesoLiq 		   		SIZE 200, 20   Picture "@E 99,999,999.99" OF oDlgTela PIXEL Font oFont3 Color CLR_HRED
	@ 106, 600 SAY oxPlaca	   PROMPT cxPlaca    		   		SIZE 200, 30   Picture "@!" 			  OF oDlgTela PIXEL Font oFont6 Color CLR_HRED
	@ 210, 015 SAY oMensagem  PROMPT cMensagem 				SIZE 400, 400  OF oDlgTela PIXEL Font oFont4 Color CLR_BLUE

	@ 090, 046 BITMAP oBitmap1 SIZE 170, 067 OF oDlgTela FILENAME cStartPath + "\peso1.bmp" NOBORDER PIXEL
	@ 090, 225 BITMAP oBitmap2 SIZE 170, 067 OF oDlgTela FILENAME cStartPath + "\peso1.bmp" NOBORDER PIXEL
	@ 090, 415 BITMAP oBitmap3 SIZE 170, 067 OF oDlgTela FILENAME cStartPath + "\peso1.bmp" NOBORDER PIXEL
	@ 090, 590 BITMAP oBitmap4 SIZE 170, 067 OF oDlgTela FILENAME cStartPath + "\placa.bmp" NOBORDER PIXEL
	ACTIVATE MSDIALOG oDlgTela CENTERED


Return()

/*/{Protheus.doc} FAT010 
Transmiti a NF-e
@author Lucas Nogueira
@type function
@since 01/2025 
/*/
Static Function eventoNFE(_cAcao,_lYesNo)

	Local cXPedOld		:= cxPedido
	Local cXNotOld		:= cxNota
	Local cXSerOld		:= cxSerie
	Local cXCliOld		:= cxCliente
	Local cXLojaOld		:= cxLojaCli

	Local cPedTriang	:= ""

	Private aIndArq		:= {}
	Private cCondicao  	:= ""
	Private lAutomato	:= .T.

	Default _cAcao		:= "Transmissao"
	Default _lYesNo		:= .T.

	If _lYesNo
		cxPedido 	:= AvKey(cxPedido,"C5_NUM")
		cxNota 		:= AvKey(cxNota,"F2_DOC")
		cxSerie		:= AvKey(cxSerie,"F2_SERIE")
		cxCliente 	:= AvKey(cxCliente,"A1_COD")
		cxLojaCli 	:= AvKey(cxLojaCli,"A1_LOJA")

		DbSelectArea("SC5")
		SC5->(DbSetOrder(1))
		SC5->(DbSeek(FwXFilial("SC5") + cxPedido))

		If _cAcao <> "Transmissao" .And. FWAlertYesNo('Confirma a EXCLUSรO da NOTA FISCAL Triangular?', 'ATENวรO')
			//ฆ+---------------------------------------------------------+ฆ
			//ฆฆExecuta o mesmo fonte para a opera็ใo Triangular
			//ฆ+---------------------------------------------------------+ฆ
			If "MODELO_NF" $ SC5->C5_MENNOTA .And. " PV: " $ SC5->C5_MENNOTA
				cPedTriang := Substr(SC5->C5_MENNOTA, At("PV: ", SC5->C5_MENNOTA) + 4,6)

				If SC5->(DbSeek(FwXFilial("SC5") + cPedTriang))
					eventoNFE(_cAcao,.F.)
				EndIf
			EndIf
		EndIf

		cxPedido 	:= AvKey(cXPedOld,"C5_NUM")
		cxNota 		:= AvKey(cXNotOld,"F2_DOC")
		cxSerie		:= AvKey(cXSerOld,"F2_SERIE")
		cxCliente 	:= AvKey(cXCliOld,"A1_COD")
		cxLojaCli 	:= AvKey(cXLojaOld,"A1_LOJA")

		DbSelectArea("SC5")
		SC5->(DbSetOrder(1))
		SC5->(DbSeek(FwXFilial("SC5") + cxPedido))

	Else
		DbSelectArea("SD2")
		SD2->(DbSetOrder(8))
		If SD2->(DbSeek(xFilial("SD2") + SC5->C5_NUM + '01'))
			cxNota  	:= SD2->D2_DOC
			cxSerie 	:= SD2->D2_SERIE
			cxCliente	:= SD2->D2_CLIENTE
			cxLojaCli	:= SD2->D2_LOJA
		EndIf

		cxPedido 	:= AvKey(SC5->C5_NUM,"C5_NUM")
		cxNota 		:= AvKey(cxNota,"F2_DOC")
		cxSerie		:= AvKey(cxSerie,"F2_SERIE")
		cxCliente 	:= AvKey(cxCliente,"A1_COD")
		cxLojaCli 	:= AvKey(cxLojaCli,"A1_LOJA")
	EndIf

	If Select("SF2") > 0
		SF2->(DbCloseArea())
	EndIf

	If _lYesNo .And. _cAcao <> "Transmissao"
		_lYesNo := FWAlertYesNo('Confirma a EXCLUSรO da NOTA FISCAL?', 'ATENวรO')
	Else
		_lYesNo := .T.
	EndIf

	If _cAcao == "Transmissao" .Or. _lYesNo
		If !Empty(cxNota) .And. !Empty(cxSerie)
			If Select("SF2") > 0
				SF2->(DbCloseArea())
			EndIf

			DbSelectArea("SF2")
			SF2->(DbSetOrder(1)) // F2_FILIAL + F2_DOC + F2_SERIE + F2_CLIENTE + F2_LOJA
			If SF2->(DbSeek(FwXFilial("SF2") + cxNota + cxSerie + cxCliente + cxLojaCli))

				cCondicao := "F2_FILIAL=='"+xFilial("SF2")+"'"
				cCondicao += ".AND.F2_SDOC=='"+SF2->F2_DOC+"'"

				aFilBrw		:=	{'SF2',SF2->F2_DOC}
				bFiltraBrw 	:= {|| FilBrowse("SF2",@aIndArq,@cCondicao) }


				If _cAcao == "Transmissao"
					SpedNFeRemessa()

				ElseIf _cAcao == "Excluir"
					Ma521Mbrow("SF2",1,1,.T.,.F.,.F.,.F.)
				EndIf

				aFilBrw		:=  {'SF2',.T.}
				bFiltraBrw	:= {|| .T. }
			EndIf
		EndIf

		If _cAcao == "Excluir"
			If !Empty(cxPedido)
				excluirPV()
			EndIf
		EndIf
	EndIf

	If !_lYesNo
		cxPedido 	:= AvKey(cXPedOld,"C5_NUM")
		cxNota 		:= AvKey(cXNotOld,"F2_DOC")
		cxSerie		:= AvKey(cXSerOld,"F2_SERIE")
		cxCliente 	:= AvKey(cXCliOld,"A1_COD")
		cxLojaCli 	:= AvKey(cXLojaOld,"A1_LOJA")
	EndIf

Return()

/*/{Protheus.doc} FAT010 
Excluir P.V.
@author Lucas Nogueira
@type function
@since 01/2025 
/*/
Static Function excluirPV()
	local aCabec 		:= {}

	local lFaturado 	:= .F.
	Local lLiberado 	:= .F.
	local lPodeExcluir 	:= .T.
	Local lTriang		:= .F.

	cxPedido := AvKey(cxPedido,"C5_NUM")

	If !Empty(cxPedido)
		DbSelectArea("SC5")
		SC5->(DbSetOrder(1))
		If SC5->(DbSeek(FwXFilial("SC5") + cxPedido))
			If !Empty(SC5->C5_NOTA)
				Return()
			EndIf
		EndIf
	Else
		Return()
	EndIf

	// avalia os itens, de modo a eliminar resํduos caso haja faturamento
	DbSelectArea("SC6")
	SC6->( dbGoTop() )
	If SC6->(DbSeek( xFilial("SC6") + cxPedido ) )
		While !SC6->(EOF()) .AND. SC6->C6_FILIAL == xFilial("SC6") .AND. SC6->C6_NUM == SC5->C5_NUM

			MaAvalSC6("SC6",4,"SC5",Nil,Nil,Nil,Nil,Nil,Nil)

			lFaturado := (SC6->C6_QTDENT > 0)
			lLiberado := (SC6->C6_QTDEMP > 0)

			If lLiberado .OR. lFaturado
				lPodeExcluir := .F.
			EndIf

			If !lPodeExcluir .AND. !lLiberado
				MaResDoFat()
			EndIf

			SC6->( dbSkip() )
		EndDo

		If lPodeExcluir

			//Valida opera็ใo TRiangular
			If "MODELO_NF" $ SC5->C5_MENNOTA .And. "PV" $ SC5->C5_MENNOTA // 3 NF (Cliente Final)
				lTriang := .F.
			Else
				lTriang := .T.
			EndIf

			aAdd( aCabec, {"C5_NUM"         , SC5->C5_NUM         , Nil} )
			aAdd( aCabec, {"C5_TIPO"     	, SC5->C5_TIPO        , Nil} )
			aAdd( aCabec, {"C5_CLIENTE"     , SC5->C5_CLIENTE     , Nil} )
			aAdd( aCabec, {"C5_LOJACLI"     , SC5->C5_LOJACLI     , Nil} )
			aAdd( aCabec, {"C5_LOJAENT"     , SC5->C5_LOJAENT     , Nil} )
			aAdd( aCabec, {"C5_CONDPAG"     , SC5->C5_CONDPAG     , Nil} )

			lMsErroAuto := .F.

			MATA410(aCabec, {} , 5)

			If lMsErroAuto
				MostraErro()
			Else
				If !lTriang
					RecLock("ZC3",.F.)
					ZC3->ZC3_STATUS := "3"  // Aguardando Faturamento
					ZC3->ZC3_PEDIDO	:= ""
					ZC3->(MsUnlock())

					DbSelecTArea("ZC4")
					ZC4->(DbSetOrder(1)) //ORDEM
					If ZC4->(DbSeek(xFilial("ZC4")+ZC3->ZC3_ORDEM))
						RecLock("ZC4",.F.)
						ZC4->ZC4_PEDIDO := ""
						ZC4->(MsUnlock())
					EndIf

					BotonTela(ZC3->ZC3_STATUS)
					cMensagem   := RetnStatus(ZC3->ZC3_STATUS)

					oDlgTela:Refresh()

					FWAlertSuccess('Pedido de Venda Excluido com Sucesso!', 'Pedido de Venda')
				EndIf
			EndIf
		Else
			If !Empty(SC5->C5_NOTA) .Or. (SC5->C5_LIBEROK == "E")
				Alert("Resํduos do pedido "+cxPedido+" foram eliminados. O pedido foi encerrado!")
			EndIf
		EndIf
	EndIf

Return()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFAT010    บAutor  ณGontijo Consultoria บ Data ณ  07/28/17   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Busca Peso da Balan็a.                                     บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Montividiu                                                 บฑฑ
ฑฑบObs.:																  บฑฑ
ฑฑบ nXOpc  = 1 Peso Inicial												  บฑฑ
ฑฑบ nXOpc  = 2 Peso Final												  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function BuscaPeso(nXOpc,cBalEnt,cBalSaid)
	Local cTitulo  := 'Lendo Pesagem da Balanca'
	Local cMsg     := 'Peso ... '
	Local vcStatus := ''
	Private nPeso  := Space(10)

	if !Empty(cxOrdem)

		if nXOpc  == 1 .OR. nXOpc == 2
			Processa({|| nPeso := FAT0510A(nXOpc,cBalEnt,cBalSaid) }, cTitulo,cMsg)

			vcStatus := ZC3->ZC3_STATUS

			if nPeso > 0
				if nXOpc == 1  //PESO INICIAL
					nxPesoIni := nPeso
					GRAVAPESO(nxPesoIni,nxPesoFim,cxOrdem,nXOpc) //Processo Gravar Ordem de Carregamento e Alterar Status  FAT010D

				Elseif nXOpc == 2 //PESO FINAL
					nxPesoFim := nPeso

					if nxPesoFim > 0

						If (nxPesoFim - nxPesoIni) > 80000
							MsgAlert("Peso Liquido nใo pode ser Maior que 80 Toneladas !!!")
							Return()
						EndIf

						GRAVAPESO(nxPesoIni,nxPesoFim,cxOrdem,nXOpc)
						U_MANCTR(4,2)     //Gatilha Manutencao do Carregamento CARLOS ENTRA TELA PESAGEM FINAL

						//Inicio - Cesar J Santos - 01/06/2023
						If nxPesoFim == 0 .and. nxPesoLiq == 0

							Reclock("ZC3",.F.)
							ZC3->ZC3_PESFIM   := 0
							ZC3->ZC3_DESCONTO := 0
							ZC3->ZC3_PESLIQ   := 0
							ZC3->ZC3_DTFIM	  := DATE() 	// Data Final Carregamento
							ZC3->ZC3_HRFIM 	  := TIME() 	// Hora Final Carregamento
							ZC3->ZC3_STATUS   := "2" 		// Muda Status para Carregamento Finalizado ou Aguardando Pesagem Final
							ZC3->( Msunlock() )

						EndIf
						//Fim - Cesar J Santos - 01/06/2023
					EndIf
				EndIf
			EndIf

		EndIf

		if nXOpc == 3 //;.AND. nxDescont > 0
			GRAVAPESO(nxPesoIni,nxPesoFim,cxOrdem,nXOpc)
		EndIf

		if nXOpc == 4 //Estorna Pesagem Final
			if ZC3->ZC3_STATUS = "3"
				if MsgYesNo("Deseja Estornar a Pesagem Final ? ", "Pesagem")

					Reclock("ZC3",.F.)
					ZC3->ZC3_PESFIM   := 0
					ZC3->ZC3_DESCONTO := 0
					ZC3->ZC3_PESLIQ   := 0
					ZC3->ZC3_DTFIM	  := DATE() 	// Data Final Carregamento
					ZC3->ZC3_HRFIM 	  := TIME() 	// Hora Final Carregamento
					ZC3->ZC3_STATUS   := "2" 		// Muda Status para Carregamento Finalizado ou Aguardando Pesagem Final
					ZC3->( Msunlock() )

					MsgAlert("Pesagem Final Estornada com Sucesso!!!")

				EndIf
			Else
				MsgAlert("Ainda nใo Foi Feita Pesagem Final !!! Verifique!!!")
			EndIf
		EndIf

		nxPesoIni    := ZC3->ZC3_PESINI
		nxPesoFim    := ZC3->ZC3_PESFIM
		nxPesoLiq    := ZC3->ZC3_PESLIQ
		nxDescont    := ZC3->ZC3_DESCONTO

		OxPesoIni:Refresh()
		OxPesoFim:Refresh()
		OxPesoLiq:Refresh()
		OxDescont:Refresh()

		BotonTela(ZC3->ZC3_STATUS)
		cMensagem   := RetnStatus(ZC3->ZC3_STATUS)

	Else
		//MsgAlert("Opera็ใo Nใo Realiza Selecione uma Ordem de Carregamento!!")
	EndIf

Return()

/*/{Protheus.doc} FAT010 
GravaPeso
@author  
@type function
@since  
/*/
Static Function GRAVAPESO(nxPesoIni,nxPesoFim,cxOrdem,nXOpc)

	if cxOrdem = ZC3->ZC3_ORDEM

		cStatus:= ZC3->ZC3_STATUS

		if nxPesoFim = 0 .AND. nXOpc == 2 .AND. ZC3->ZC3_STATUS == "2"
			Alert("Peso Final da Ordem de Carregamento deve ser Informado para finalizar o processo !")
			Return .F.
		EndIf

		if nxPesoFim < nxPesoIni .AND. nXOpc == 2
			Alert("Peso Final Nใo Pode ser Menor do Que Peso Inicial !")
			Return .F.
		EndIf

		if (nxPesoFim) = 0 .AND. nXOpc == 3
			Alert("Nใo ่ Possivel Realizar Desconto sem Valor Final")
			Return .F.
		EndIf

		if (nxPesoFim) > 0 .AND. nXOpc == 3 .AND. ZC3->ZC3_STATUS > "3"
			Alert("Nใo ่ Possivel Realizar Desconto Com Ordem Faturada")
			Return .F.
		EndIf

		Begin Transaction

			if NxOPC = 1 //Peso Inicial
				Reclock("ZC3",.F.)
				ZC3->ZC3_PESINI  := nxPesoIni
				ZC3->ZC3_STATUS := iif(cStatus == "1","2","3") // Muda Status para Carregamento Finalizado ou Aguardando Pesagem Final
				ZC3->( Msunlock() )
			Elseif NxOPC = 2

				nxPesoLiq := (nxPesoFim - nxPesoIni)

				Reclock("ZC3",.F.)
				ZC3->ZC3_PESFIM    := nxPesoFim // aqui da erro
				ZC3->ZC3_DESCONTO  := nxDescont
				//ZC3->ZC3_PESLIQ  := nPesoLiq
				ZC3->ZC3_PESLIQ    := nxPesoLiq-nxDescont
				ZC3->ZC3_DTFIM	   := DATE() // Data Final Carregamento
				ZC3->ZC3_HRFIM 	   := TIME()  // Hora Final Carregamento
				ZC3->ZC3_STATUS    := iif(cStatus == "1","2","3") // Muda Status para Carregamento Finalizado ou Aguardando Pesagem Final
				ZC3->( Msunlock() )

			Elseif NxOPC = 3

				nxPesoLiq := (nxPesoFim - nxPesoIni)

				Reclock("ZC3",.F.)
				ZC3->ZC3_PESFIM   := nxPesoFim
				ZC3->ZC3_DESCONTO := nxDescont
				ZC3->ZC3_PESLIQ   := (nxPesoLiq - nxDescont)  //- Desconto
				ZC3->( Msunlock() )

			EndIf

		End Transaction

	EndIf


Return()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFAT010    บAutor  ณGontijo COnsultoria บ Data ณ  07/29/17   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFun็ใo Para Realizar Pesagem Inicial / Final.            	  บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Montividiu                                                 บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function FAT0510A(nXOpc,cBalEnt,cBalSaid)
	//Local nHandle  :=  0
	//Local cTexto   :=  Space(15)
	//Local aAmostra :=  {}
	//Local nVezes   :=  0
	Local lRet	   := .F.
	Local bEstab   := .F.
	Local nPeso	   :=  Space(10)
	//Local nVazio   :=  0
	//Local x

	// Vars de Conexao com Tsokect ( TCPIP) - Gontijo
	Local oSocket
	Local nSockResp  := 0
	Local nSockRead  := 0
	/*
	Local cBuffer	 := '32'
	Local cPrtaIPSer := "4000"
	Local cIpServer  := "192.168.3.199"
	Local cTimeOut   := "7200"
	*/
	Local cTpBal	 := GetMV('MV_BALTP')
	Local cConecBal	 := GetMV('MV_CONEBAL')
	//Local cBuffer	 := GetMV('MV_BALBUF')
	Local cPrtaIPSer := GetMV('MV_BALPRT')
	Local cIpServer  := GetMV('MV_BALIP')
	Local cTimeOut   := GetMV('MV_BALTIM') //comunicacao exemplo 7200 or 4800
	Local cBalPr
	Local cBal01     := cBalEnt//SuperGetMv("MV_BAL01",.F.,"") //ENTRADA
	Local cBal02     := cBalSaid//SuperGetMV("MV_BAL02",.F.,"") //SAIDA

	Local nFor01	:= 0

	Local lBalanca := .T.

	// --End Vars de Comunica็ใo TCPIP - Gontijo
	ProcRegua(5000)//(10000)
	//Verifica a sequencia das balan็as de pesagem.
	//caso 2 balancas regra de ordem
	If cEmpAnt == '50' .and. cFilAnt == '1009'

		If nXOpc == 1 .and. cBal01 == "1"

			cIpServer  	:=	"10.15.2.20"
			cBalPr   	:= cBal01

		ElseIf nXOpc == 1 .and. cBal01 == "2"

			cIpServer  	:=	"10.15.2.21"
			cBalPr   	:= cBal01

		ElseIF nXOpc == 2 .and. cBal02 == "1"

			cIpServer  	:=	"10.15.2.20"
			cBalPr   	:= cBal02

		ElseIf nXOpc == 2 .and. cBal02 == "2"

			cIpServer  	:=	"10.15.2.21"
			cBalPr   	:= cBal02
		EndIf

	EndIf
	//--End Vars de Comunica็ใo TCPIP - Gontijo

	ProcRegua(5000)//(10000)
	//Teste conexใo balan็a IP

	If FwIsAdmin()
		lBalanca := FWAlertYesNo("Deseja puxar o valor da balan็a?")
	EndIf

	If lBalanca
		If AllTrim(cTpBal) == 'TCP'

			oSocket 	:= tSocketClient():New()   //Criando a Clase

			For nFor01 := 1 to TRIES_TO_CONNECT   // tenta conectar N vezes
				nSockResp := oSocket:Connect( val(cPrtaIPSer),Alltrim(cIpServer),Val( cTimeOut ) )

				//Verificando se a conexao foi efetuada com sucesso
				IF !( oSocket:IsConnected() )  //ntSocketConnected == 0 OK
					Alert("Nใo foi possivel conectar a balan็a.")

				ElseIF nSockResp == 0   // Conexใo Ok
					Exit
				EndIf
			Next

			IF nSockResp == 0 // Indica que Estแ conectado // Enviando um Get Para Capturar o Peso
				Sleep(500)

				For nFor01 := 1 To TRIES_TO_READ
					nPeso := ""
					nSockRead = oSocket:Receive( @nPeso,  Val( cTimeout ) )

					IF( nSockRead > 0 )
						If cEmpAnt == '50'
							If cFilAnt = '1001'
								nPeso := SubStr(nPeso,2,6)//SubStr(nPeso,5,6)

							ElseIf cFilAnt = '1002' //ok
								nPeso := SubStr(nPeso,2,6)//SubStr(nPeso,5,6)

							ElseIf cFilAnt = '1004'
								nPeso := SubStr(nPeso,2,6)//SubStr(nPeso,5,6)

							ElseIf cFilAnt = '1009' //0k
								If cBalPr == "1"
									nPeso := SubStr(nPeso,2,6)//SubStr(nPeso,9,6)
								Elseif  cBalPr == "2"
									nPeso := SubStr(nPeso,9,6)//SubStr(nPeso,9,6)
								EndIf

							ElseIf cFilAnt = '2000' //OK
								nPeso := SubStr(nPeso,4,6)//SubStr(nPeso,5,6)

							ElseIf cFilAnt = '3000' //ok
								nPeso := SubStr(nPeso,9,6)//SubStr(nPeso,5,6)

							ElseIf cFilAnt = '4000' //OK
								nPeso := SubStr(nPeso,2,6)//SubStr(nPeso,5,6)
							Else
								nPeso := SubStr(nPeso,8,7)

							EndIf
						EndIf
						Exit

					Else
						nPeso := "0"
					EndIf
				Next nFor01
			Else
				Alert("Nใo foi possivel obter o peso da balan็a")
			EndIf

			oSocket:CloseConnection()
			//iif(empty(nPeso),nPeso := cValtoChar(nPeso),nPeso := Val(nPeso))
			nPeso := Val(nPeso) //Ajustar esta vindo caracter

			//Fim teste conexใo balan็a IP
		Else
			//colocar aqui funcao para fonte teste
			cCOM 	:= AllTrim(cConecBal)
			cPorta 	:= SubStr(cCOM,1,4)
			cBaudRate	:= SubStr(cCOM,6,4)
			cParity		:= SubStr(cCOM,11,1)
			cData		:= SubStr(cCOM,13,1)
			cStop		:= SubStr(cCOM,15,1)
			cTimeOut	:= "10000"
			nRetorno    := ApesaB(cPorta, cBaudRate, cParity, cData, cStop, cTimeOut)
			If nRetorno != 0
				nPeso := nRetorno
				lRet   := .T.
				bEstab := .T.
			Else
				nPeso := 0
			EndIf
			//fim validacao padrao totvs teste peso

	/* //deletado para teste padrao totvs
		While !lRet		

			cCOM := AllTrim(cConecBal)//"COM7:9600,N,8,2" // teste elba 4800

			//For็a o fechamento e abertura da porta novamente
			WaitRun("NET USE "+SubStr(cCOM,1,4)+": /DELETE")
			WaitRun("NET USE "+SubStr(cCOM,1,4)+" ")	

			if MSOpenPort(@nHandle,cCOM)    
						
				if nVezes > 10//Quantas vezes pega peso antes era 50 alterado Carlos Daniel
					Exit 
				EndIf 
			
				MSRead(nHandle, @nPeso)    // Capturando os dados
				MsClosePort(nHandle)	 

				//For็a o fechamento e abertura da porta novamente
				WaitRun("NET USE "+SubStr(cCOM,1,4)+": /DELETE")
				WaitRun("NET USE "+SubStr(cCOM,1,4)+" ")							

				If cFilAnt == '4101'

					nPeso:= SubStr(nPeso,8,7)

				ElseIf cFilAnt = '4104'
				
					nPeso:= SubStr(nPeso,6,5)

				ElseIf cFilAnt = '4200'
				
					nPeso:= SubStr(nPeso,6,5)

				ElseIf cFilAnt = '4207'
				
					nPeso:= SubStr(nPeso,6,5)
				
				Else 

					nPeso:= SubStr(nPeso,8,7)

				EndIf
									
				nVezes ++ // Numero de leituras realizadas
							
				//--- Verifica se variavel foi preenchida             
				if Empty(nPeso)
									
					If nVazio < 50 // numero de tentativas de leitura com retorno vazio
						nVazio++
					Else
						MsgInfo(" Nใo foi possivel obter Peso da Balan็a: "+cCOM+", Favor informar o Peso Manualmente !") 
						nxPesoIni := 0
						oPesoIni :Refresh()
						Exit					          	     	                          
					EndIf                                       

				EndIf		          	 
								
				//--- nPeso	:=Val(SubStr(cTexto,1,5))                                 
				nPeso := Val(nPeso)
				
				if nPeso != 0
					aadd(aAmostra,{nPeso})                                      					          
				EndIf

				IncProc("Estabilizando Peso: " + cValtoChar(nPeso))
											
				//--- Verifica estabiliza็ใo do Peso se amostragem for maior que 4
				if len(aAmostra) < 4
					Loop
				Else     					            
					//--- Verifica a Estabilidade da Pesagem
					For x := 2 to len(aAmostra)
						if aAmostra[x,1] != aAmostra[1,1]
							bEstab := .F.
							aAmostra:= {} // apaga amostras para nova compara็ใo
							Exit 						               
						ElseIf x == len(aAmostra) 	
							lRet:= .T. 
							bEstab := .T.
						EndIf
					Next x 			        
				EndIf	
						
				//add sem amostra valida se peso foi capturado carlos custom
				
				//If nPeso != 0
					//lRet   := .T. 
					//bEstab := .T.
				//Else
					//xmaghelpfis("Aten็ใo"," Nใo foi possivel comunicar com a balan็a: "+cCOM,"Remova Porta USB e tente novamente")                
					//nPeso:= 0
					//Exit
				//EndIf	
						
				MsClosePort(nHandle)
			Else    
				xmaghelpfis("Aten็ใo"," Nใo foi possivel comunicar com a balan็a: "+cCOM,"Verifique se a Porta USB esta correta")                
				nPeso:= 0
				Exit 
			EndIf    		    
		Enddo           
	*/
		EndIf
	Else
		nPeso := 0
	EndIf

	If nPeso == 0 //.and. cnivel > 5 // Nao solicita o peso p/ nivel > 5 cairo 22-11-19

		If MsgYesNo("Deseja Informar o Peso Manual ? !", "Pesagem")
			If FwIsAdmin() .Or. fDigSenha()
				nPeso := PesoManual(nXOpc)
			EndIf
		EndIf

	EndIf

Return(nPeso)

/*/{Protheus.doc} FAT010 
PEso Manual
@author  
@type function
@since  
/*/
Static Function PesoManual(nXOpc)
	Private zoButton1
	Private zoButton2
	Private zoGet1
	Private znPeso1 := 0
	Private zoGroup1
	Private zoSay1
	Private oDlgPesMan

	Define Font oFont10 Name 'Courier New' //Size 0, 0

	DEFINE MSDIALOG oDlgPesMan TITLE "Tela de Pesagem Manual : " FROM 000, 000  TO 190, 370 COLORS 0, 16777215 PIXEL

	@ 002, 002 GROUP 	zoGroup1 TO 074, 183 PROMPT "Rotina Pesagem Manual " OF oDlgPesMan COLOR 0, 16777215 PIXEL
	@ 010, 020 SAY 		zoSay1 PROMPT "Digite o Peso "+iif(nXOpc = 1,"Inicial","Final")+" Manual : " SIZE 110, 015 OF oDlgPesMan PIXEL Font oFont10 Color CLR_HRED
	@ 040, 020 MSGET 	zoGet1 VAR znPeso1 	Picture "@E 99,999,999.99" 	SIZE 060, 010 OF oDlgPesMan COLORS 0, 16777215 PIXEL
	@ 076, 099 BUTTON 	zoButton1 PROMPT "Confirmar" 	SIZE 037, 012 OF oDlgPesMan PIXEL Action(ValPesoMan(znPeso1)) // retirar
	@ 076, 144 BUTTON 	zoButton2 PROMPT "Cancelar" 	SIZE 037, 012 OF oDlgPesMan PIXEL Action(znPeso1 := 0,oDlgPesMan:End())

	ACTIVATE MSDIALOG oDlgPesMan CENTERED

Return(znPeso1)

Static Function ValPesoMan(znPeso1)
	Local _lRet := .F.

	if znPeso1 = 0
		MsgAlert("Nใo e Permitido Incluir Peso Zerado")
		_lRet := .F.
	Else
		_lRet := .T.
		oDlgPesMan:End()
		Return(_lRet)
	EndIf

Return(_lRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFAT010    บAutor  ณGontijo Consultoria บ Data ณ  07/28/17   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Determina A็ใo dos Bot๕es.                                 บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Montividiu                                                 บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function fOpcao(opNopc)
	Private oWBrowse1
	Private aWBrowse1 := {}
	Private oMsnewGe1
	Private __cOrdem  := cxOrdem
	Private __cStatus := ''

	//if !Empty(cxOrdem)
	//	MsgAlert("Selecione a Ordem de Carregamento:")
	//EndIf

	DbSelectArea("ZC3")
	ZC3->(DbGoTop())
	ZC3->(DbSetOrder(1))
	If ZC3->(DbSeek(xFilial("ZC3")+cxOrdem))
		__cOrdem  := cxOrdem
		__cStatus := ZC3_STATUS
	EndIf

	If opNopc == 3
		if MsgYesNo("Deseja Monitorar Transmissใo Notas Fiscais? !", "Protheus ")
			SPEDNFE()
			Return()
		EndIf
	EndIf

	If !Empty(cxOrdem)

		//Status - FAT010A
		//nxOPC = 1 = Inclusใo
		//nxOPC = 2 = Altera็ใo
		//NXOPC = 4 = Manuten็ใo
		//NXOPC = 3 = Visualizar

		Do Case
		Case opNopc == 8	//Cadastro Placa / Motorista
			//Alert("OK")

		Case opNopc == 7	  //Imprime Danfe
			BuscaNotaF(cxOrdem)

		Case opNopc == 6	//Exec Auto Pedido de Venda - Faturar Carregamento - Transmitir Automatico - Imprimir DANFE.
			If __cStatus == '3'
				FaturaOrdem(ZC3->ZC3_ORDEM)

			ElseIf __cStatus == '5'
				//Transmite Nota Fiscal ou Emite DANFE.
			EndIf

			BuscaCarga(cxOrdem,opNopc)

		Case opNopc == 5     //Visualizar Carregamento
			U_FAT010A(3)

		Case opNopc == 4     //Manuten็ใo Carregamento
			//	Alert("Manuten็ใo de Carregamento")
			U_MANCTR(4,1)

		Case opNopc == 1     //Ordem de Carregamento
			U_RFATR01()

		Case opNopc == 2		//Ticket Pesagem
			U_FATR001()

		EndCase
	Else
		MsgAlert("Selecione uma Ordem de Carregamento!")
	EndIf

Return()

/*/{Protheus.doc} FAT010 
Busca Nota Fiscal DANFE
@author  
@type function
@since 01/2025 
/*/
Static Function BuscaNotaF(cxOrdem)
	Local oButton20
	Local oButton21
	Local oGroup1

	Private oWBrowse6
	Private aWBrowse6 := {}
	Private oMsnewGe6

	Private oDanfe

	//Valida MDFe
	If !vldMDFE(.T.)
		Return()
	EndIf

	DEFINE MSDIALOG oDanfe TITLE "Impressใo Nota Fiscal (DANFE)" FROM 000, 000  TO 300, 900 COLORS 0, 16777215 PIXEL

	@ 004, 003 GROUP oGroup1 TO 128, 449 PROMPT "Escolha a Nota Fiscal:" OF oDanfe COLOR 0, 16777215 PIXEL
	@ 133, 320 BUTTON oButton20 PROMPT "Imprimir DANFE" SIZE 080, 012 OF oDanfe PIXEL	Action(U_ImpDanfe(oMsnewGe6:ACOLS[oMsnewGe6:NAT][6],oMsnewGe6:ACOLS[oMsnewGe6:NAT][7],oMsnewGe6:ACOLS[oMsnewGe6:NAT][8],oMsnewGe6:ACOLS[oMsnewGe6:NAT][9],oMsnewGe6:ACOLS[oMsnewGe6:NAT][10],oMsnewGe6:ACOLS[oMsnewGe6:NAT][11]))
	@ 133, 410 BUTTON oButton21 PROMPT "Fechar" SIZE 037, 012 OF oDanfe PIXEL Action(oDanfe:End())

	oMsnewGe6 := fMSNewGe6(cxOrdem)

	ACTIVATE MSDIALOG oDanfe CENTERED

Return()

/*/{Protheus.doc} FAT010 

@author  
@type function
@since 01/2025 
/*/
Static Function fMSNewGe6(cxOrdem)
	Local nX
	Local aHeaderEx    := {}
	Local aColsEx 	   := {}
	Local aFieldFill   := {}
	Local aFields 	   := {"ZC3_FILIAL","ZC3_ORDEM","ZC3_CODCLI","ZC3_NOMCLI","C6_NUM","F2_DOC","F2_SERIE","F2_CLIENTE","F2_LOJA","F2_FORMUL","F2_TIPO"}
	Local aAlterFields := {}

	For nX := 1 to Len(aFields)

		Aadd(aHeaderEx, {	GetSx3Cache(aFields[nX],"X3_TITULO"),;
			GetSx3Cache(aFields[nX],"X3_CAMPO"),;
			GetSx3Cache(aFields[nX],"X3_PICTURE"),;
			GetSx3Cache(aFields[nX],"X3_TAMANHO"),;
			GetSx3Cache(aFields[nX],"X3_DECIMAL"),;
			,;
			GetSx3Cache(aFields[nX],"X3_USADO"),;
			GetSx3Cache(aFields[nX],"X3_TIPO"),;
			GetSx3Cache(aFields[nX],"X3_F3"),;
			GetSx3Cache(aFields[nX],"X3_CONTEXT"),;
			GetSx3Cache(aFields[nX],"X3_CBOX"),;
			GetSx3Cache(aFields[nX],"X3_RELACAO")})
	Next nX

	If Select("QRYSF2")>0
		QRYSF2->(dbCloseArea())
	EndIf

	cQry := " SELECT DISTINCT(ZC3_FILIAL),ZC3_ORDEM,ZC3_CODCLI,ZC3_NOMCLI,ZC4_PEDIDO,C6_NUM,F2_DOC,F2_SERIE,F2_CLIENTE,F2_LOJA,F2_FORMUL,F2_TIPO " + CRLF
	cQry += " FROM "+RetSqlName("ZC3")+" ZC3 " + CRLF
	cQry += "   	 INNER JOIN "+RetSqlName("ZC4")+" ZC4  ON (ZC3_FILIAL = ZC4_FILIAL AND ZC3_ORDEM = ZC4_ORDEM AND ZC4.D_E_L_E_T_ = ' ' ) " + CRLF
	cQry += "   	 INNER JOIN "+RetSqlName("SC6")+" SC6  ON (ZC3_FILIAL = C6_FILIAL AND (ZC4_PEDIDO = C6_NUM  " + CRLF

	If !Empty(cxPedTriang)
		cQry += " OR C6_NUM = '" + Alltrim(cxPedTriang)  + "' " + CRLF
	EndIf

	cQry += " ) AND SC6.D_E_L_E_T_ = ' ' ) " + CRLF
	cQry += "		 INNER JOIN "+RetSqlName("SF2")+" SF2  ON (F2_DOC = C6_NOTA AND C6_SERIE = F2_SERIE AND SF2.D_E_L_E_T_ = ' ' ) " + CRLF
	cQry += " WHERE ZC3.D_E_L_E_T_ = ' ' " + CRLF
	cQry += " 	AND ZC4_PEDIDO <> ' ' "  + CRLF
	cQry += " 	AND ZC3_ORDEM = '" + Alltrim(cxOrdem) + "'   " + CRLF

	cQry := ChangeQuery(cQry)
	TcQuery cQry New Alias "QRYSF2" // Cria uma nova area com o resultado do query

	While QRYSF2->(!Eof())

		aFieldFill := {}

		Aadd(aFieldFill,QRYSF2->ZC3_FILIAL)
		Aadd(aFieldFill,QRYSF2->ZC3_ORDEM)
		Aadd(aFieldFill,QRYSF2->ZC3_CODCLI)
		Aadd(aFieldFill,QRYSF2->ZC3_NOMCLI)
		Aadd(aFieldFill,QRYSF2->C6_NUM)
		Aadd(aFieldFill,QRYSF2->F2_DOC)
		Aadd(aFieldFill,QRYSF2->F2_SERIE)
		Aadd(aFieldFill,QRYSF2->F2_CLIENTE)
		Aadd(aFieldFill,QRYSF2->F2_LOJA)
		Aadd(aFieldFill,QRYSF2->F2_FORMUL)
		Aadd(aFieldFill,QRYSF2->F2_TIPO)
		Aadd(aFieldFill, .F.)

		Aadd(aColsEx,aFieldFill)

		QRYSF2->(DbSkip())
	EndDo

	If Empty(aColsEx)
		For nX := 1 to Len(aFields)
			Aadd(aFieldFill,"")
		Next nX
		Aadd(aFieldFill,.F.)
		Aadd(aColsEx,aFieldFill)
	EndIf

	oMSNewGe6 :=  MsNewGetDados():New( 012, 007, 124, 443, , "AllwaysTrue", "AllwaysTrue", "+Field1+Field2", aAlterFields,, 999, "AllwaysTrue", "", "AllwaysTrue", oDanfe, aHeaderEx, aColsEx)

Return(oMSNewGe6)

/*/{Protheus.doc} FAT010 
Impressใo DANFE
@author  
@type function
@since 01/2025 
/*/
User Function ImpDanfe(cNota,cSerie,x_CLIENTE,x_LOJA,x_FORMUL,x_TIPO)
	Local aIndArq       := {}

	cCondicao 	:= " F2_FILIAL=='"+xFilial("SF2")+"' "
	aFilBrw		:=	{'SF2',cCondicao}
	bFiltraBrw  := {|| FilBrowse("SF2",@aIndArq,@cCondicao) }
	Eval(bFiltraBrw)

	SpedDanfe()

Return()

/*/
	ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
	ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
	ฑฑฺฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฟฑฑ
	ฑฑณPrograma  ณSpedDanfe ณ Autor ณEduardo Riera          ณ Data ณ27.06.2007ณฑฑ
	ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤดฑฑ
	ฑฑณDescri…o ณRotina de chamada do WS de impressao da DANFE               ณฑฑ
	ฑฑณ          ณ                                                            ณฑฑ
	ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
	ฑฑณRetorno   ณNenhum                                                      ณฑฑ
	ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
	ฑฑณParametrosณNenhum                                                      ณฑฑ
	ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
	ฑฑณ   DATA   ณ Programador   ณManutencao efetuada                         ณฑฑ
	ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
	ฑฑณ          ณ               ณ                                            ณฑฑ
	ฑฑภฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
	ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
	฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
User Function xSpedDanfe(cNota,cSerie,x_CLIENTE,x_LOJA,x_FORMUL,x_TIPO)

	Local cIdEnt := ""
	Local aIndArq   := {}
	Local oDanfe
	//Local nHRes  := 0
	//Local nVRes  := 0
	Local cFilePrint := ""
	Local oSetup
	Local aDevice  := {}
	Local cSession     := GetPrinterSession()
	Local nRet := 0
	//Local lUsaColab	:= UsaColaboracao("1")

	If findfunction("U_DANFE_V")
		nRet := U_Danfe_v()
	Elseif findfunction("U_DANFE_VI") // Incluido esta valida็ใo pois o cliente informou que nใo utiliza o DANFEII
		nRet := U_Danfe_vi()
	EndIf

	AADD(aDevice,"DISCO") // 1
	AADD(aDevice,"SPOOL") // 2
	AADD(aDevice,"EMAIL") // 3
	AADD(aDevice,"EXCEL") // 4
	AADD(aDevice,"HTML" ) // 5
	AADD(aDevice,"PDF"  ) // 6

	cIdEnt := GetIdEnt()

	cFilePrint := "DANFE_"+cIdEnt+Dtos(MSDate())+StrTran(Time(),":","")

	nLocal       	:= 1//If(fwGetProfString(cSession,"LOCAL","SERVER",.T.)=="SERVER",1,2 )
	nOrientation 	:= 2//If(fwGetProfString(cSession,"ORIENTATION","PORTRAIT",.T.)=="PORTRAIT",1,2)
	cDevice     	:= "PDF" //If(Empty(fwGetProfString(cSession,"PRINTTYPE","SPOOL",.T.)),"PDF",fwGetProfString(cSession,"PRINTTYPE","SPOOL",.T.))
	nPrintType      := aScan(aDevice,{|x| x == cDevice })

	If .T. //IsReady(,,,lUsaColab)
		dbSelectArea("SF2")
		RetIndex("SF2")
		dbClearFilter()
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณObtem o codigo da entidade                                              ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		If nRet >= 20100824

			lAdjustToLegacy := .F. // Inibe legado de resolu็ใo com a TMSPrinter
			oDanfe := FWMSPrinter():New(cFilePrint, IMP_PDF , lAdjustToLegacy, /*cPathInServer*/, .T.)

			// ----------------------------------------------
			// Cria e exibe tela de Setup Customizavel
			// OBS: Utilizar include "FWPrintSetup.ch"
			// ----------------------------------------------
			//nFlags := PD_ISTOTVSPRINTER+ PD_DISABLEORIENTATION + PD_DISABLEPAPERSIZE + PD_DISABLEPREVIEW + PD_DISABLEMARGIN
			nFlags := PD_ISTOTVSPRINTER + PD_DISABLEPAPERSIZE + PD_DISABLEPREVIEW + PD_DISABLEMARGIN
			If ( !oDanfe:lInJob )
				oSetup := FWPrintSetup():New(nFlags, "DANFE")
				// ----------------------------------------------
				// Define saida
				// ----------------------------------------------
				oSetup:SetPropert(PD_PRINTTYPE   , nPrintType)
				oSetup:SetPropert(PD_ORIENTATION , nOrientation)
				oSetup:SetPropert(PD_DESTINATION , nLocal)
				oSetup:SetPropert(PD_MARGIN      , {60,60,60,60})
				oSetup:SetPropert(PD_PAPERSIZE   , 2)

				//	If ExistBlock( "SPNFESETUP" )
				//	Execblock( "SPNFESETUP" , .F. , .F. , {oDanfe, oSetup} )
				//	EndIf
				//EndIf

				// ----------------------------------------------
				// Pressionado botใo OK na tela de Setup
				// ----------------------------------------------
				If oSetup:Activate() == PD_OK // PD_OK =1
					//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
					//ณSalva os Parametros no Profile             ณ
					//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

					fwWriteProfString( cSession, "LOCAL"      , If(oSetup:GetProperty(PD_DESTINATION)==1 ,"SERVER"    ,"CLIENT"    ), .T. )
					fwWriteProfString( cSession, "PRINTTYPE"  , If(oSetup:GetProperty(PD_PRINTTYPE)==2   ,"SPOOL"     ,"PDF"       ), .T. )
					fwWriteProfString( cSession, "ORIENTATION", If(oSetup:GetProperty(PD_ORIENTATION)==1 ,"PORTRAIT"  ,"LANDSCAPE" ), .T. )

					// Configura o objeto de impressใo com o que foi configurado na interface.
					oDanfe:setCopies( val( oSetup:cQtdCopia ) )

					If oSetup:GetProperty(PD_ORIENTATION) == 1
						//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
						//ณDanfe Retrato DANFEII.PRW                  ณ
						//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
						u_PrtNfeSef(cIdEnt,,,oDanfe, oSetup, cFilePrint)
					Else
						//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
						//ณDanfe Paisagem DANFEIII.PRW                ณ
						//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
						u_DANFE_P1(cIdEnt,,,oDanfe, oSetup)
					EndIf

				Else
					MsgInfo("Relat๓rio cancelado pelo usuแrio.")
					Pergunte("NFSIGW",.F.)
					bFiltraBrw := {|| FilBrowse(aFilBrw[1],@aIndArq,@aFilBrw[2])}
					Eval(bFiltraBrw)
					Return

				EndIf

			Else
				u_PrtNfeSef(cIdEnt)
			EndIf

			Pergunte("NFSIGW",.F.)
			bFiltraBrw := {|| FilBrowse(aFilBrw[1],@aIndArq,@aFilBrw[2])}
			Eval(bFiltraBrw)

		EndIf
	EndIf

	oDanfe := Nil
	oSetup := Nil

Return()

/*/
	ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
	ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
	ฑฑฺฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฟฑฑ
	ฑฑณPrograma  ณGetIdEnt  ณ Autor ณEduardo Riera          ณ Data ณ18.06.2007ณฑฑ
	ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤดฑฑ
	ฑฑณDescri…o ณObtem o codigo da entidade apos enviar o post para o Totvs  ณฑฑ
	ฑฑณ          ณService                                                     ณฑฑ
	ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
	ฑฑณRetorno   ณExpC1: Codigo da entidade no Totvs Services                 ณฑฑ
	ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
	ฑฑณParametrosณNenhum                                                      ณฑฑ
	ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
	ฑฑณ   DATA   ณ Programador   ณManutencao efetuada                         ณฑฑ
	ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
	ฑฑณ          ณ               ณ                                            ณฑฑ
	ฑฑภฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
	ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
	฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
Static Function GetIdEnt()

	Local aArea  := GetArea()
	Local cIdEnt := ""
	Local cURL   := PadR(GetNewPar("MV_SPEDURL","http://"),250)
	Local oWs
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณObtem o codigo da entidade                                              ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	oWS := WsSPEDAdm():New()
	oWS:cUSERTOKEN := "TOTVS"

	oWS:oWSEMPRESA:cCNPJ       := IIF(SM0->M0_TPINSC==2 .Or. Empty(SM0->M0_TPINSC),SM0->M0_CGC,"")
	oWS:oWSEMPRESA:cCPF        := IIF(SM0->M0_TPINSC==3,SM0->M0_CGC,"")
	oWS:oWSEMPRESA:cIE         := SM0->M0_INSC
	oWS:oWSEMPRESA:cIM         := SM0->M0_INSCM
	oWS:oWSEMPRESA:cNOME       := SM0->M0_NOMECOM
	oWS:oWSEMPRESA:cFANTASIA   := SM0->M0_NOME
	oWS:oWSEMPRESA:cENDERECO   := FisGetEnd(SM0->M0_ENDENT)[1]
	oWS:oWSEMPRESA:cNUM        := FisGetEnd(SM0->M0_ENDENT)[3]
	oWS:oWSEMPRESA:cCOMPL      := FisGetEnd(SM0->M0_ENDENT)[4]
	oWS:oWSEMPRESA:cUF         := SM0->M0_ESTENT
	oWS:oWSEMPRESA:cCEP        := SM0->M0_CEPENT
	oWS:oWSEMPRESA:cCOD_MUN    := SM0->M0_CODMUN
	oWS:oWSEMPRESA:cCOD_PAIS   := "1058"
	oWS:oWSEMPRESA:cBAIRRO     := SM0->M0_BAIRENT
	oWS:oWSEMPRESA:cMUN        := SM0->M0_CIDENT
	oWS:oWSEMPRESA:cCEP_CP     := Nil
	oWS:oWSEMPRESA:cCP         := Nil
	oWS:oWSEMPRESA:cDDD        := Str(FisGetTel(SM0->M0_TEL)[2],3)
	oWS:oWSEMPRESA:cFONE       := AllTrim(Str(FisGetTel(SM0->M0_TEL)[3],15))
	oWS:oWSEMPRESA:cFAX        := AllTrim(Str(FisGetTel(SM0->M0_FAX)[3],15))
	oWS:oWSEMPRESA:cEMAIL      := UsrRetMail(RetCodUsr())
	oWS:oWSEMPRESA:cNIRE       := SM0->M0_NIRE
	oWS:oWSEMPRESA:dDTRE       := SM0->M0_DTRE
	oWS:oWSEMPRESA:cNIT        := IIF(SM0->M0_TPINSC==1,SM0->M0_CGC,"")
	oWS:oWSEMPRESA:cINDSITESP  := ""
	oWS:oWSEMPRESA:cID_MATRIZ  := ""
	oWS:oWSOUTRASINSCRICOES:oWSInscricao := SPEDADM_ARRAYOFSPED_GENERICSTRUCT():New()
	oWS:_URL := AllTrim(cURL)+"/SPEDADM.apw"
	If oWs:ADMEMPRESAS()
		cIdEnt  := oWs:cADMEMPRESASRESULT
	Else
		Aviso("SPED",IIf(Empty(GetWscError(3)),GetWscError(1),GetWscError(3)),{''},3)
	EndIf

	RestArea(aArea)
Return(cIdEnt)


/*/{Protheus.doc} FAT010 

@author  
@type function
@since 01/2025 
/*/
// Static Function Teste()

// 	DbSelectArea("SF2")
// 	SF2->(DbSetOrder(1))
// 	IF SF2->(MsSeek(xFilial("SF2")+cNota+cSerie+x_CLIENTE+x_LOJA))
// 	//if SF2->(DbSeek(xFilial("SF2")+cNota+cSerie+x_CLIENTE+x_LOJA+x_FORMUL+x_TIPO))
// 	//
// 	//	SX1->( DbSetOrder(1), DbSeek("NFSIGW") )
// 	//	while !SX1->( Eof() ) .and. AllTrim(SX1->X1_GRUPO) == "NFSIGW"
// 	//		
// 	//		RecLock("SX1")
// 	//		Do Case
// 	//			case Upper(AllTrim(SX1->X1_VARIAVL)) == "MV_CH1"	// Da Nota Fiscal ?
// 	//				SX1->X1_CNT01 := Substr(SF2->F2_DOC,4,9)
// 	//				MV_PAR01 := SX1->X1_CNT01
// 	//			case Upper(AllTrim(SX1->X1_VARIAVL)) == "MV_CH2"	// Ate a Nota Fiscal ?
// 	//				SX1->X1_CNT01 := Substr(SF2->F2_DOC,4,9)
// 	//				MV_PAR02 := SX1->X1_CNT01
// 	//			case Upper(AllTrim(SX1->X1_VARIAVL)) == "MV_CH3"	// Da Serie ?
// 	//				SX1->X1_CNT01 := Left(SF2->F2_SERIE,3)
// 	//				MV_PAR03 := SX1->X1_CNT01
// 	//			case Upper(AllTrim(SX1->X1_VARIAVL)) == "MV_CH4"	// Tipo de Operacao ? (1)Entrada / (2)Saida
// 	//				SX1->X1_CNT01 := "2"
// 	//				MV_PAR04 := 2
// 	//			case Upper(AllTrim(SX1->X1_VARIAVL)) == "MV_CH5"	// Imprime no verso?
// 	//				SX1->X1_CNT01 := "2"
// 	//				MV_PAR05 := 2
// 	//			case Upper(AllTrim(SX1->X1_VARIAVL)) == "MV_CH6"
// 	//				SX1->X1_CNT01 := "2"
// 	//				MV_PAR06 := 2
// 	//		Endcase
// 	//		
// 	//		SX1->( DbUnLock() )
// 	//		SX1->( DbCommit() )
// 	//		SX1->( DbSkip() )
// 	//	Enddo                 
// 	// EndIf

// 		//--- Cria o Objeto de Impressao da Danfe padrao
// 		//_cDef1Printer := SuperGetMV("MV_XIMP1", .F., "HP LaserJet Professional P1606dn")	//Impressora de Danfe
// 		//cFilePrint 	  := "DANFE"+ _aEmpresas[_ixe,01] + Str( Year( date() ),4) + StrZero( Month( date() ), 2) + ;
// 			//StrZero( Day( date() ),2) + Left(Time(),2) + Substr(Time(),4,2) + Right(Time(),2)

// 		_cDef1Printer := "teste"

// 		nFlags:= PD_ISTOTVSPRINTER+ PD_DISABLEORIENTATION + PD_DISABLEPAPERSIZE + PD_DISABLEPREVIEW + PD_DISABLEMARGIN

// 		oSetup:= FWPrintSetup():New(nFlags,"IMPRESSAO AUTOMATICA BOLETO/DANFE")

// 		oBjNfe:= FWMSPrinter():New(cFilePrint /*Nome Arq*/, IMP_SPOOL /*IMP_SPOOL/IMP_PDF*/, .F. /*3-Legado*/,;
// 	/*4-Dir. Salvar*/, .F. /*5-Nใo Exibe Setup*/, /*6-Classe TReport*/,;
// 			oSetup /*7-oPrintSetup*/, _cDef1Printer  /*8-Impressora For็ada*/,;
// 			.F. /*lServer*/,.F./*lPDFAsPNG*/,/*lRaw*/,/*lViewPDF*/,/*nQtdCopy*/2)

// 		oBjNfe:SetResolution(78) //Tamanho estipulado para a Danfe
// 		oBjNfe:SetPortrait()
// 		oBjNfe:SetPaperSize(DMPAPER_A4)
// 		oBjNfe:nDevice := IMP_SPOOL

// 		//WriteProfString(GetPrinterSession(),"DEFAULT", _cDef1Printer /*oSetup:aOptions[PD_VALUETYPE]*/, .T.)

// 		//if empty(oBjNfe:cPrinter)
// 		//	oBjNfe:cPrinter := _cDef1Printer /*oSetup:aOptions[PD_VALUETYPE]*/
// 		//EndIf

// 		U_PrtNfeSef(cEmpant, "", "", oBjNfe, oSetup, cFilePrint,.F.,.T.) //Emite Primeira Via

// 		FreeObj(oSetup)
// 		oDanfe := Nil
// 		oSetup := Nil
// 	EndIf
// Return()


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFAT010    บAutor  ณGontijo Consultoria บ Data ณ  07/28/17   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Seleciona Carregamento.                                    บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Montividiu                                                 บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function SeleCarreg()
	//Local oButton1
	Local oButton2
	Local oButton3
	Local oComboBo1
	Local nComboBo1 := 2
	Local oGet1
	Local cGet1 := dDataBase //Data De
	Local oGet2
	Local cGet2 := dDataBase //Data Ate
	Local oGet3
	Local cGet3 := Space(6) //Codigo Cliente
	Local oGet4
	Local cGet4 := Space(30) //Nome Cliente
	Local oGet5
	Local cGet5 := Space(7) //Placa
	Local oGroup1
	Local oGroup2
	Local oSay1
	Local oSay2
	Local oSay3
	Local oSay4
	Local oSay5
	Local oSay6

	Private oWBrowse1
	Private aWBrowse1 := {}
	Private oMsnewGe1

	Private oDlgCar

	DEFINE MSDIALOG oDlgCar TITLE "Selecionar Ordem Carregamento:" FROM 000, 000  TO 530, 950 COLORS 0, 16777215 PIXEL

	@ 064, 004 GROUP oGroup1 TO 246, 472 PROMPT "Carregamentos em Andamentos : " OF oDlgCar COLOR 0, 16777215 PIXEL

	@ 001, 004 GROUP oGroup2 TO 060, 472 PROMPT "Filtro " OF oDlgCar COLOR 0, 16777215 PIXEL

	@ 012, 011 SAY oSay1 PROMPT "Data De" SIZE 025, 007 OF oDlgCar COLORS 0, 16777215 PIXEL
	@ 012, 107 SAY oSay2 PROMPT "Data Ate" SIZE 025, 007 OF oDlgCar COLORS 0, 16777215 PIXEL
	@ 011, 040 MSGET oGet1 VAR cGet1 SIZE 060, 010 OF oDlgCar COLORS 0, 16777215 PIXEL
	@ 010, 135 MSGET oGet2 VAR cGet2 SIZE 060, 010 OF oDlgCar COLORS 0, 16777215 PIXEL
	@ 026, 012 SAY oSay3 PROMPT "Cliente" SIZE 025, 007 OF oDlgCar COLORS 0, 16777215 PIXEL
	@ 026, 040 MSGET oGet3 VAR cGet3 F3 "SA1"  SIZE 060, 010 OF oDlgCar COLORS 0, 16777215 PIXEL Valid( cGet4 := POSICIONE("SA1",1,xFILIAL("SA1")+cGet3,"A1_NOME") )
	@ 027, 107 SAY oSay4 PROMPT "Nome" SIZE 025, 007 OF oDlgCar COLORS 0, 16777215 PIXEL
	@ 026, 135 MSGET oGet4 VAR cGet4 SIZE 164, 010 OF oDlgCar COLORS 0, 16777215 PIXEL
	@ 041, 011 SAY oSay5 PROMPT "Placa" SIZE 025, 007 OF oDlgCar COLORS 0, 16777215 PIXEL
	@ 040, 040 MSGET oGet5 VAR cGet5 F3 "XDA3" Valid ( ExistCpo("DA3",cGet5,3) .OR. !Vazio(cGet5))  SIZE 060, 010 OF oDlgCar COLORS 0, 16777215 PIXEL

	@ 011, 300 SAY oSay6 PROMPT "Filtrar Status " SIZE 042, 007 OF oDlgCar COLORS 0, 16777215 PIXEL

	@ 010, 360 MSCOMBOBOX oComboBo1 VAR nComboBo1 ITEMS {"Aguardando Carregamento","Aguardando Pesagem Final","Aguardando Faturamento","Todos"} SIZE 110, 010 OF oDlgCar COLORS 0, 16777215 PIXEL

	oMsnewGe1 := fMSNewGe1()

	@ 044, 423 BUTTON oButton5 PROMPT "Pesquisar" SIZE 042, 012 OF oDlgCar PIXEL Action( MsgRun("Pesquisando Carregamentos ","Aguarde...", {||	PesqCarreg(2,cGet1,cGet2,cGet3,cGet4,cGet5,oComboBo1)	}) )

	@ 248, 110 BUTTON oButton6 PROMPT "Excluir Ordem Carregamento"        SIZE 097, 012 OF oDlgCar PIXEL  	Action( ExcOrdem(oMSNewGe1:acols[oMSNewGe1:NAT][aScan(oMSNewGe1:aheader,{|x| Upper(alltrim(x[2]))=="ZC3_ORDEM"})]), PesqCarreg(2,cGet1,cGet2,cGet3,cGet4,cGet5,oComboBo1) ) //Incluir Nova Ordem de Carregamento
	//@ 248, 003 BUTTON oButton1 PROMPT "Incluir Nova Ordem Carregamento"   SIZE 097, 012 OF oDlgCar PIXEL  	Action( U_FAT010A(1) ) //Incluir Nova Ordem de Carregamento
	@ 248, 348 BUTTON oButton2 PROMPT "Selecionar Carregamento" 		  SIZE 075, 012 OF oDlgCar PIXEL	Action( BuscaCarga(oMSNewGe1:acols[oMSNewGe1:NAT][aScan(oMSNewGe1:aheader,{|x| Upper(alltrim(x[2]))=="ZC3_ORDEM"})],1),oDlgCar:End() )
	@ 248, 432 BUTTON oButton3 PROMPT "Cancelar" SIZE 037, 012 OF oDlgCar PIXEL Action (oDlgCar:End() )

	ACTIVATE MSDIALOG oDlgCar CENTERED

Return()

// Static Function SelecPenden()
// 	Local oButton1
// 	Local oButton2
// 	Local oButton3
// 	Local oComboBo1
// 	Local nComboBo1 := 2
// 	Local oGet1
// 	Local cGet1 := dDataBase //Data De
// 	Local oGet2
// 	Local cGet2 := dDataBase //Data Ate
// 	Local oGet3
// 	Local cGet3 := Space(6) //Codigo Cliente
// 	Local oGet4
// 	Local cGet4 := Space(30) //Nome Cliente
// 	Local oGet5
// 	Local cGet5 := Space(7) //Placa
// 	Local oGroup1
// 	Local oGroup2
// 	Local oSay1
// 	Local oSay2
// 	Local oSay3
// 	Local oSay4
// 	Local oSay5
// 	Local oSay6

// 	Private oWBrowse5
// 	Private aWBrowse5 := {}
// 	Private oMsnewGe5

// 	Private oDlgPEN

// 	DEFINE MSDIALOG oDlgPEN TITLE "Ordem Carregamento Pendentes:" FROM 000, 000  TO 530, 950 COLORS 0, 16777215 PIXEL

// 	@ 004, 004 GROUP oGroup1 TO 246, 472 PROMPT "Carregamentos em Andamentos Cadastros Basicos: " OF oDlgCar COLOR 0, 16777215 PIXEL

// 	oMsnewGe5 := fMSNewGe5()
// 	//110
// 	//   @ 248, 005 BUTTON oButton6 PROMPT "Excluir Ordem Carregamento"        SIZE 097, 012 OF oDlgPEN PIXEL    Action( U_ExcOrdem(oMSNewGe1:acols[oMSNewGe1:NAT][aScan(oMSNewGe1:aheader,{|x| Upper(alltrim(x[2]))=="ZC3_ORDEM"})]), PesqCarreg(2,cGet1,cGet2,cGet3,cGet4,cGet5,oComboBo1) )  //Incluir Nova Ordem de Carregamento
// 	@ 248, 005 BUTTON oButton1 PROMPT "Realizar Cadastros"   			  SIZE 097, 012 OF oDlgPEN PIXEL    Action(U_IncCad() ) //Incluir Nova Ordem de Carregamento
// 	@ 248, 432 BUTTON oButton3 PROMPT "Cancelar" 						  SIZE 037, 012 OF oDlgPEN PIXEL 	Action(oDlgPEN:End() )

// 	ACTIVATE MSDIALOG oDlgPEN CENTERED

// Return()

Static Function fMSNewGe5()
	Local nX
	Local aHeaderEx    := {}
	Local aColsEx      := {}
	Local aFieldFill   := {}
	Local aFields      := {"ZC3_ORDEM","ZC3_PLACA","ZC3_DTRETI","ZC3_HORA","ZC3_CODCLI","ZC3_LOJA","ZC3_NOMCLI","ZC3_STATUS","ZC3_CODMOT","ZC3_MOTORI","ZC3_PESINI","ZC3_PESFIM"}
	Local aAlterFields := {}

	Private oMSNewGe1

	//	DbSelectArea("SX3")
	//	SX3->(DbSetOrder(2))
	//	For nX := 1 to Len(aFields)
	//	  If SX3->(DbSeek(aFields[nX]))
	//	    Aadd(aHeaderEx, {AllTrim(X3Titulo()),SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,/*SX3->X3_VALID*/,;
		//	                     SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_F3,SX3->X3_CONTEXT,SX3->X3_CBOX,SX3->X3_RELACAO})
	//	  EndIf
	//	Next nX

	For nX := 1 to Len(aFields)

		Aadd(aHeaderEx, {	GetSx3Cache(aFields[nX],"X3_TITULO"),;
			GetSx3Cache(aFields[nX],"X3_CAMPO"),;
			GetSx3Cache(aFields[nX],"X3_PICTURE"),;
			GetSx3Cache(aFields[nX],"X3_TAMANHO"),;
			GetSx3Cache(aFields[nX],"X3_DECIMAL"),;
			,;
			GetSx3Cache(aFields[nX],"X3_USADO"),;
			GetSx3Cache(aFields[nX],"X3_TIPO"),;
			GetSx3Cache(aFields[nX],"X3_F3"),;
			GetSx3Cache(aFields[nX],"X3_CONTEXT"),;
			GetSx3Cache(aFields[nX],"X3_CBOX"),;
			GetSx3Cache(aFields[nX],"X3_RELACAO")})

	Next nX

	cQry:= "    SELECT * FROM " + RETSQLNAME("ZC3") + " ZC3 "
	cQry+= "  	WHERE ZC3_FILIAL  = '" + xFILIAL("ZC3") + "' "
	cQry+= "  	AND ZC3_STATUS NOT IN ('5') "
	cQry+= "  	ORDER BY ZC3_ORDEM "

	If Select("TMPPEN") > 1
		TMPPEN->( DbCloseArea() )
	EndIf

	TcQuery cQry New Alias "TMPPEN"

	nContador := 0

	TMPPEN->(DbGoTop())
	While !TMPPEN->(eof())

		aFieldFill := {}

		xBusPlac := TMPPEN->ZC3_PLACA
		xBusMot  := TMPPEN->ZC3_CODMOT

		DbSelectArea("DA4")
		DA4->(DbSetOrder(1))
		if !DA4->(DbSeek(xFilial("DA4")+xBusMot))
			DbSelectArea("DA3")
			DA3->(DbSetOrder(3))
			if !DA3->(DbSeek(xFilial("DA3")+xBusPlac))

				Aadd(aFieldFill,TMPPEN->ZC3_ORDEM)
				Aadd(aFieldFill,TMPPEN->ZC3_PLACA)
				Aadd(aFieldFill,STOD(TMPPEN->ZC3_DTRETI))
				Aadd(aFieldFill,TMPPEN->ZC3_HORA)
				Aadd(aFieldFill,TMPPEN->ZC3_CODCLI)
				Aadd(aFieldFill,TMPPEN->ZC3_LOJA)
				Aadd(aFieldFill,TMPPEN->ZC3_NOMCLI)
				Aadd(aFieldFill,TMPPEN->ZC3_STATUS)
				Aadd(aFieldFill,TMPPEN->ZC3_CODMOT)
				Aadd(aFieldFill,TMPPEN->ZC3_MOTORI)
				Aadd(aFieldFill,TMPPEN->ZC3_PESINI)
				Aadd(aFieldFill,TMPPEN->ZC3_PESFIM)
				Aadd(aFieldFill, .F.)
				Aadd(aColsEx,aFieldFill)

				nContador++

			EndIf
		EndIf
		TMPPEN->(dbSkip())
	EndDo

	if nContador   = 0
		Aadd(aFieldFill,"")
		Aadd(aFieldFill,"")
		Aadd(aFieldFill,ddatabase)
		Aadd(aFieldFill,"")
		Aadd(aFieldFill,"")
		Aadd(aFieldFill,"")
		Aadd(aFieldFill,"")
		Aadd(aFieldFill,"")
		Aadd(aFieldFill,"")
		Aadd(aFieldFill,"")
		Aadd(aFieldFill,"")
		Aadd(aFieldFill,"")
		Aadd(aFieldFill, .F.)
		Aadd(aColsEx,aFieldFill)
	EndIf

	oMSNewGe5 := MsNewGetDados():New( 015, 008, 243, 468, , "AllwaysTrue", "AllwaysTrue", "+Field1+Field2", aAlterFields,, 999, "AllwaysTrue", "", "AllwaysTrue", oDlgCar, aHeaderEx, aColsEx)

Return(oMSNewGe5)

/*/{Protheus.doc} FAT010 

@type function
/*/
Static Function BuscaCarga(cNumOrdem,_xcNopc)

	Local cPedTriang	:= ""

	DbSelectArea("ZC3")
	ZC3->(DbGoTop())
	ZC3->(DbSetOrder(1))
	if ZC3->(DbSeek(xFilial("ZC3")+cNumOrdem))

		cxOrdem 	:= ZC3->ZC3_ORDEM
		dxData 	    := ZC3->ZC3_DTRETI
		cxHora      := ZC3->ZC3_HORA
		cxCliente   := ZC3->ZC3_CODCLI
		cxLojaCli   := ZC3->ZC3_LOJA
		cxNomCli	:= ZC3->ZC3_NOMCLI
		cxPlaca		:= ZC3->ZC3_PLACA
		cxMotorista	:= ZC3->ZC3_CODMOT
		cxNomeMot	:= ZC3->ZC3_MOTORI
		cxTranspor	:= ZC3->ZC3_TRANSP
		cxNomTrans	:= POSICIONE("SA4",1,xFILIAL("SA4")+cxTranspor,"A4_NOME") // CARLOS NOME TRANSPORTADORA
		nxVlFrete	:= ZC3->ZC3_VLRFRE // CARREGA DADOS PARA TELA
		nxVlFreau   := ZC3->ZC3_FRETAU
		nxVlDesp    := ZC3->ZC3_DESPTR
		cxPedido	:= ZC3->ZC3_PEDIDO

		DbSelectArea("SC5")
		SC5->(DbSetOrder(1))
		If SC5->(DbSeek(FwXFilial("SC5") + cxPedido))
			//Valida NF do Ped.Triangular
			If "MODELO_NF" $ SC5->C5_MENNOTA .And. " PV: " $ SC5->C5_MENNOTA
				cPedTriang := Substr(SC5->C5_MENNOTA, At("PV: ", SC5->C5_MENNOTA) + 4,6)

				If !Empty(cPedTriang)
					dbselectarea("SD2")
					dbsetorder(8)
					If dbseek(xfilial("SD2")+cPedTriang+'01')
						cxNotaTrian := SD2->D2_DOC
						cxPedTriang := cPedTriang
					EndIf
				EndIf
			EndIf
		EndIf

		If !Empty(cxPedido)
			dbselectarea("SD2")
			dbsetorder(8)
			If dbseek(xfilial("SD2")+ZC3->ZC3_PEDIDO+'01')
				cxNota  	:= SD2->D2_DOC
				cxSerie 	:= SD2->D2_SERIE
			EndIf
		EndIf

		//cxGuiaSt    := ZC3->ZC3_PEDIDO
		nxDescont    := ZC3->ZC3_DESCONTO
		nxPesoIni    := ZC3->ZC3_PESINI
		nxPesoFim    := ZC3->ZC3_PESFIM
		nxPesoLiq    := ZC3->ZC3_PESLIQ//-ZC3->ZC3_DESCONTO

		cMensagem   := RetnStatus(ZC3->ZC3_STATUS)

		BotonTela(ZC3->ZC3_STATUS) //Controla Bot๕es da Tela.

		//Busca Quantidade TOTAL DO PESO em Todos Produtos
		if Select("QRZC4") > 1
			QRZC4->( DbCloseArea() )
		EndIf

		cQryZC4:= " SELECT ZC4_CONTRA,ZC4_PRODUT,ZC4_DESCRI,ZC4_MENOTA,ZC4_EMBAL,ZC4_PALET,ZC4_QTDE,ZC4_ORDEM,ZC3_STATUS FROM " + RETSQLNAME("ZC4")+ " ZC4,"+ RETSQLNAME("ZC3") + " ZC3"
		cQryZC4+= " WHERE ZC4.D_E_L_E_T_ = ' ' AND ZC3.D_E_L_E_T_ = ' ' "
		cQryZC4+= " AND ZC3_FILIAL = ZC4_FILIAL"
		cQryZC4+= " AND ZC3_ORDEM = ZC4_ORDEM"
		cQryZC4+= " AND ZC4_FILIAL = '" + xFILIAL("ZC4") + "'"
		cQryZC4+= " AND ZC4_ORDEM  = '" + cNumOrdem + "'"
		cQryZC4+= " ORDER BY ZC4_CONTRA "

		if Select("QRZC4") > 1
			QRZC4->( DbCloseArea() )
		EndIf

		TcQuery cQryZC4 New Alias "QRZC4"

		nXPesoInf := 0

		QRZC4->( DbGoTop() )
		while !QRZC4->( Eof() )

			cUm			:= POSICIONE("SB1",1,xFILIAL("SB1")+QRZC4->ZC4_PRODUT,"B1_UM")
			nProPesoLiq	:= 0 //POSICIONE("SB1",1,xFILIAL("SB1")+QRZC4->ZC4_PRODUT,"B1_PESO") -- Altera็ใo para atender Ercal

			if cUm == 'TN' .and. nProPesoLiq = 0
				nxPesoInf+= QRZC4->ZC4_QTDE * 1000
				//nxPesoCtr+=
			Else
				nxPesoInf += nxPesoLiq
			EndIf

			QRZC4->( DbSkip() )
		Enddo

		cQuery:= " SELECT (ADB_QUANT - ADB_QTDEMP) SALDO , ZC4_PRODUT, ADA_XMENOT FROM " + RETSQLNAME("ADA") + " ADA," +  RETSQLNAME("ADB") + " ADB," +  RETSQLNAME("ZC3") + " ZC3," +  RETSQLNAME("ZC4") + " ZC4"
		cQuery+= " WHERE ADA.D_E_L_E_T_ = ' ' AND ADB.D_E_L_E_T_ = ' ' "
		cQuery+= " AND ZC4.D_E_L_E_T_ = ' '   AND ZC3.D_E_L_E_T_ = ' ' "
		cQuery+= " AND ZC3_FILIAL = ZC4_FILIAL"
		cQuery+= " AND ZC3_ORDEM  = ZC4_ORDEM"
		cQuery+= " AND ZC4_FILIAL = '" + xFILIAL("ZC4") + "'"
		cQuery+= " AND ZC4_ORDEM  = '" + cNumOrdem + "'"
		cQuery+= " AND ZC4_CONTRA = ADA_NUMCTR "
		cQuery+= " AND ZC4_CONTRA = ADB_NUMCTR "
		cQuery+= " AND ADA_FILIAL = ADB_FILIAL "
		cQuery+= " AND ADA_NUMCTR = ADB_NUMCTR"
		//cQuery+= " AND ADA_CODCLI = ADB_CODCLI"
		//cQuery+= " AND ADA_LOJCLI = ADB_LOJCLI"
		cQuery+= " AND ADB_QTDEMP < ADB_QUANT"
		cQuery+= " AND ADA_STATUS IN ('B','C') "	// Contrato em Aberto ou Contrato Parcialmente Entregue
		cQuery+= " AND ADA_MSBLQL  = '2'	"			// Somente Contratos Liberados
		//cQuery+= " AND ADA_XLIBMS  != 'B'	"			// Somente Contratos Liberados MS / Cairo 26/06/20
		cQuery+= " AND ADA_FILIAL = '" + xFILIAL("ADA") + "'"
		//	cQuery+= " AND ADA_CODCLI = '" + cCodCli + "'"
		//	cQuery+= " AND ADA_LOJCLI = '" + cLoja   + "'"
		cQuery+= " ORDER BY ADA_NUMCTR,ADA_EMISSA"

		If Select("QDBA") > 1
			QDBA->( dbclosearea() )
		EndIf

		TcQuery cQuery New Alias "QDBA"

		nXPesoCtr := 0

		QRZC4->( DbGoTop() )
		While !QRZC4->( Eof() )

			cUm			:= POSICIONE("SB1",1,xFILIAL("SB1")+QRZC4->ZC4_PRODUT,"B1_UM")
			nProPesoLiq	:= 0 //POSICIONE("SB1",1,xFILIAL("SB1")+QRZC4->ZC4_PRODUT,"B1_PESO") --Altera็ใo para atender Ercal

			if cUm == 'TN' .and. nProPesoLiq = 0
				nxPesoCtr+= QDBA->SALDO * 1000
			Else
				nxPesoCtr += QDBA->SALDO
			EndIf

			QRZC4->( DbSkip() )
		Enddo

		//oxPesoInf:Refresh()
		If Select("QDBA") > 1
			QDBA->( dbclosearea() )
		EndIf
		If Select("QRZC4") > 1
			QRZC4->( DbCloseArea() )
		EndIf

		vldMDFE()

		if _xcNopc = 1 .or. _xcNopc = 4

			oOrdem:Refresh()
			oData:Refresh()
			oHora:Refresh()
			oxCliente:Refresh()
			oxLojaCli:Refresh()
			oxNomCli:Refresh()
			oxPlaca:Refresh()
			oxMotorista:Refresh()
			oxNomMot:Refresh()
			oxTranspor:Refresh()
			oxNomTrans:Refresh()
			oxVlFrete:Refresh()
			//oxVlDesp:Refresh()
			oxVlFreau:Refresh()
			//oxGuiaSt:Refresh()
			oxDescont:Refresh()
			oxPesoIni:Refresh()
			oxPesoFim:Refresh()
			oxPesoLiq:Refresh()
			oMensagem:Refresh()
			oxPesoInf:Refresh()
			oxPesoCtr:Refresh()

			OxPesoIni:Refresh()
			OxPesoFim:Refresh()
			OxPesoLiq:Refresh()
			OxDescont:Refresh()

			oDlgTela:Refresh() //Ajustar Aqui Adriano Reis Alterar Tela quando Incluir um novo .

		EndIf
	EndIf

Return()

/*/{Protheus.doc} FAT010 

@type function
/*/
Static Function fMSNewGe1()
	Local nX
	Local aHeaderEx := {}
	Local aColsEx := {}
	Local aFieldFill := {}
	Local aFields := {"ZC3_ORDEM","ZC3_PLACA","ZC3_DTRETI","ZC3_HORA","ZC3_CODCLI","ZC3_LOJA","ZC3_NOMCLI","ZC3_STATUS","ZC3_CODMOT","ZC3_MOTORI","ZC3_PESINI","ZC3_PESFIM"}
	Local aAlterFields := {}

	Private oMSNewGe1

	For nX := 1 to Len(aFields)

		Aadd(aHeaderEx, {	GetSx3Cache(aFields[nX],"X3_TITULO"),;
			GetSx3Cache(aFields[nX],"X3_CAMPO"),;
			GetSx3Cache(aFields[nX],"X3_PICTURE"),;
			GetSx3Cache(aFields[nX],"X3_TAMANHO"),;
			GetSx3Cache(aFields[nX],"X3_DECIMAL"),;
			,;
			GetSx3Cache(aFields[nX],"X3_USADO"),;
			GetSx3Cache(aFields[nX],"X3_TIPO"),;
			GetSx3Cache(aFields[nX],"X3_F3"),;
			GetSx3Cache(aFields[nX],"X3_CONTEXT"),;
			GetSx3Cache(aFields[nX],"X3_CBOX"),;
			GetSx3Cache(aFields[nX],"X3_RELACAO")})

		Aadd(aFieldFill, CriaVar(aFields[nX]))

	Next nX

	Aadd(aFieldFill, .F.)

	Aadd(aColsEx, aFieldFill)

	oMSNewGe1 := MsNewGetDados():New( 080, 008, 243, 468, , "AllwaysTrue", "AllwaysTrue", "+Field1+Field2", aAlterFields,, 999, "AllwaysTrue", "", "AllwaysTrue", oDlgCar, aHeaderEx, aColsEx)

Return(oMSNewGe1)

/*/{Protheus.doc} FAT010 

@type function
/*/
Static Function PesqCarreg(Nopc,cDatade,cDataAte,cCodCli,cNomeCli,cPlaca,cStatus)

	cQry:= "  SELECT * FROM " + RETSQLNAME("ZC3") + " ZC3 "//," + RETSQLNAME("ZC4") + " ZC4"
	cQry+= "  WHERE ZC3.D_E_L_E_T_ = ' ' "//AND ZC4.D_E_L_E_T_ = ' ' "
	cQry+= "  	AND ZC3_FILIAL  = '" + xFILIAL("ZC3") + "'"

	if !Empty(cDatade) .AND. !Empty(cDataAte)
		cQry+= "  	AND ZC3_DTRETI  BETWEEN '"+DTOS(cDatade)+"' AND '"+DTOS(cDataAte)+"' "
	EndIf
	if !Empty(cCodCli)
		cQry+= "  	AND ZC3_CODCLI  Like '%" + Alltrim(cCodCli) + "%'"
	EndIf
	if !Empty(cNomeCli)
		cQry+= "  	AND ZC3_NOMCLI  Like '%" + Alltrim(cNomeCli) + "%'"
	EndIf
	if !Empty(cPlaca)
		cQry+= "  	AND ZC3_PLACA	  = '" + cPlaca + "'"
	EndIf

	cCodStat := cValtoChar(cStatus:NAT)

	if cCodStat $ '1/2/3'
		cQry+= "  	AND ZC3_STATUS	  = '" + cCodStat + "'"
	ElseIf cCodStat = '4' //Todos
		cQry+= "  	AND ZC3_STATUS IN ('1','2','3','5') "
	EndIf

	cQry+= "  	ORDER BY ZC3_ORDEM "

	If Select("QZC4") > 1
		QZC4->( DbCloseArea() )
	EndIf

	TcQuery cQry New Alias "QZC4"

	nContador := 0

	oMSNewGe1:ACOLS := {}
	aCols 	:= {}

	QZC4->(DbGoTop())
	While !QZC4->(eof())

		aAdd(aCols,{QZC4->ZC3_ORDEM;
			,QZC4->ZC3_PLACA;
			,STOD(QZC4->ZC3_DTRETI);
			,QZC4->ZC3_HORA;
			,QZC4->ZC3_CODCLI;
			,QZC4->ZC3_LOJA;
			,QZC4->ZC3_NOMCLI;
			,QZC4->ZC3_STATUS;
			,QZC4->ZC3_CODMOT;
			,QZC4->ZC3_MOTORI;
			,QZC4->ZC3_PESINI;
			,QZC4->ZC3_PESFIM;
			,.F.})
		nContador++
		QZC4->(dbSkip())
	EndDo

	if nContador   = 0
		aAdd(aCols,{"","","","","","","","","","","",.F.})
	EndIf

	oMSNewGe1:SetArray(aCols)
	oMSNewGe1:Refresh(.T.)

Return()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFAT010    บAutor  ณGontijo Consultoria บ Data ณ  07/28/17   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Gerenciamento Botใo da Tela por Status.                    บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Montividiu                                                 บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function BotonTela(cStatus)
	Local cRetorno := ''
	if cStatus = '1'
		cRetorno   := 'STATUS: Aguardando Carregamento'
		lpesini    := .T.
		lpesfim    := .F.
		lnfe       := .F.
		lDesconto  := .F.
		lDANFE     := .F.
		lTRNFE	   := .F.
		lMTNFE	   := .F.
		lExclPv	   := .F.
		lMDFE	   := .F.
	Elseif cStatus = '2'
		cRetorno   := 'STATUS: Aguardando Pesagem Final'
		lpesini    := .F.
		lpesfim    := .T.
		lnfe       := .F.
		lDesconto  := .T.
		lDanfe     := .F.
		lTRNFE	   := .F.
		lMTNFE	   := .F.
		lExclPv	   := .F.
		lMDFE	   := .F.
	Elseif cStatus = '3'
		cRetorno   := 'STATUS: Aguardando Faturamento'
		lpesini    := .F.
		lpesfim    := .F.
		lnfe       := .T.
		lDesconto  := .T.
		lDanfe     := .F.
		lTRNFE	   := .F.
		lMTNFE	   := .F.
		lExclPv	   := .F.
		lMDFE	   := .F.
	Elseif cStatus = '4'
		cRetorno   := 'STATUS: Pedido com Bloqueio '
		lpesini    := .F.
		lpesfim    := .F.
		lnfe       := .F.
		lDesconto  := .F.
		lDanfe     := .F.
		lTRNFE	   := .F.
		lMTNFE	   := .F.
		lExclPv	   := .F.
		lMDFE	   := .F.
	Elseif cStatus = '5'
		cRetorno   := 'STATUS: FATURADO. ' + cxNota + IIF(!Empty(cxNotaTrian), " (Remessa Simbolica)" + CHR(13)+CHR(10) + Space(38) + cxNotaTrian + " (Remessa Por Conta e Ordem)", '')
		lpesini    := .F.
		lpesfim    := .F.
		lnfe       := .F.
		lDesconto  := .F.
		lDANFE     := .T.
		lTRNFE	   := .T.
		lMTNFE	   := .T.
		lExclPv	   := .T.
	EndIf
Return()

/*/{Protheus.doc} FAT010 

@type function
@since 03/2025 
/*/
Static Function RetnStatus(cStatus)
	cRetorno := ''

	if cStatus = '1'
		cRetorno   := 'STATUS: Aguardando Carregamento'

	Elseif cStatus = '2'
		cRetorno   := 'STATUS: Aguardando Pesagem Final'

	Elseif cStatus = '3'
		cRetorno   := 'STATUS: Aguardando Faturamento'

	Elseif cStatus = '4'
		cRetorno   := 'STATUS: Pedido com Bloqueio '

	Elseif cStatus = '5'
		cRetorno   := 'STATUS: FATURADO. ' + cxNota + IIF(!Empty(cxNotaTrian), " (Remessa Simbolica)" + CHR(13)+CHR(10) + Space(38) + cxNotaTrian + " (Remessa Por Conta e Ordem)", '')

	EndIf

Return(cRetorno)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFAT010A    บAutor  ณInnovare Solu็๕es  บ Data ณ  08/01/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Monta a tela principal da Ordem de Carregamento            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ FAT010                                                     บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/                          

//nxOPC = 1 = Inclusใo
//nxOPC = 2 = Altera็ใo
//NXOPC = 4 = Manuten็ใo 
//NXOPC = 3 = Visualizar
User Function FAT010A(nXOpc)
	//Local aButtons := {}
	Private nPesoIni  := 0
	Private nPesoFim  := 0
	Private _Query	  := ""
	Private cData	  := Date() // Data da Ordem
	Private cHora	  := Time() // Hora da Pesagem Incial
	Private cNrOrdem  := iif(nXOpc == 1,GETSX8NUM("ZC3","ZC3_ORDEM"),"")
	Private nPesoLiq  := 0
	Private nPesoInf  := 0
	Private nPesoDist := 0
	Private aContr	  := {}
	Private aHeader   := {}
	Private aCols	  := {}
	Private cPlaca    := Space(7)
	Private cMotora   := Space(6)
	Private cNome     := ""
	Private cCliente  := Space(06)
	Private cRazao    := ""
	Private cLoja     := Space(2)
	Private oPesoInf
	Private oPesoDist
	Private oLoja
	Private oNome
	Private oRazao
	Private oCliente
	Private oMotora
	Private oPlaca
	Private oBrw
	Private oDlg
	Private oData
	Private oHora
	Private oNrOrdem
	Private oPesoIni
	Private oPesoFim
	Private cStatus
	Private nLnAjt   := 0
	Private cTransp  := Space(11)
	Private oTransp


	Private oObs
	Private cObs  := Space(250)
	Private oDesp
	Private nDesp  := 0
	Private oVlrFau
	Private nVlrFau  := 0
	Private oVlrFre
	Private nVlrFre  := 0

	Private cArq
	Private cArq1
	Private lInverte := .F.
	Private cMark    := GetMark()
	Private oMark
	Private cMarkP   := GetMark()
	Private oMarkP

	Private oDescon
	Private nDescon := 0
	Private cLote := Space(6)
	Private oLote
	Private lFlagWhen := .F.
//cObs  := ADA->ADA_XMENOT //carlos Daniel
// Valida se registro que esta tentando editar esta com Status Finalizado
	if nXopc == 2 // Altera็ใO

		cStatus:= Posicione("ZC3",1,xFilial("ZC3") + ZC3->ZC3_ORDEM,"ZC3_STATUS")
		if cStatus > "2"
			Alert("Este Carregamento nใo pode ser Alterado !","Aten็ใo")
			Return .F.
		EndIf

	Elseif nXopc == 4 // Manut. Ordem de Carregamento

	/*    cStatus:= Posicione("ZC3",1,xFILIAL("ZC3")+ ZC3->ZC3_ORDEM,"ZC3_STATUS")
	if cStatus != "1"
	Alert("Manuten็ใo Nใo Disponivel para o Status Atual desta Ordem de Carregamento !","Aten็ใo")
	Return .F.
	EndIf
	*/
	Elseif nXopc == 3 // Visualizar Carregamento

		cCliente  :=  ZC3->ZC3_CODCLI//cxCliente Ercal
		cLoja     :=  ZC3->ZC3_LOJA//cxLojaCli Ercal

	EndIf

	// Cria tela para Inclusใo de Ordem de Carregamento
	DEFINE MSDIALOG oDlg FROM 002,003 TO 500 /*555*/,1100 TITLE 'Ordem de Carregamento' Pixel //Style DS_MODALFRAME

	Define Font oFont Name 'Courier New' Size 0, -12
	Define Font oFont1 Name 'Courier New' Size 0, -20

	nLnAjt := 5

	@ 02+nLnAjt,007 TO 120+nLnAjt,360 LABEL 'Ordem de Carregamento' OF oDlg PIXEL
	@ 07+nLnAjt,220 TO 040+nLnAjt,345 LABEL 'Peso Total Informado / Kg' OF oDlg PIXEL

	@ 10+nLnAjt,010 Say "Data " Font oFont Pixel of oDlg
	@ 10+nLnAjt,055 Msget oData Var cData Size 50,10 Pixel of oDlg When .F.

	@ 10+nLnAjt,130 Say "Hora " Font oFont Pixel of oDlg
	@ 10+nLnAjt,150 Msget oHora Var cHora Size 50,10 Pixel of oDlg When .F.

	@ 20+nLnAjt,250 SAY oPesoInf PROMPT nPesoInf SIZE 100, 15 Picture "@E 99,999,999.99" OF oDlg PIXEL Font oFont1 Color CLR_HRED
	@ 32+nLnAjt,010 Say "Ordem " Font oFont Pixel of oDlg
	@ 32+nLnAjt,055 Msget oNrOrdem Var cNrOrdem When .F.  Size 50,10 Pixel of oDlg

	@ 32+nLnAjt,130 Say "Placa " Font oFont Pixel of oDlg
	@ 32+nLnAjt,150 Msget oPlaca Var cPlaca F3 "XDA3"  Size 50,10 Pixel of oDlg Valid (IIF(  ValPlaca(cPlaca) .OR. !Vazio(cPlaca) ,  (cMotora := POSICIONE("DA4",1,XFILIAL("DA4")+DA3->DA3_MOTORI,"DA4_COD" ) ,cNome := POSICIONE("DA4",1,XFILIAL("DA4")+DA3->DA3_MOTORI,"DA4_NOME")) ,.T.) )

	@ 47+nLnAjt,10 Say "Motorista " Font oFont Pixel of oDlg
	@ 47+nLnAjt,55 Msget oMotora Var cMotora F3 "DA4" Valid (ExistCpo("DA4",,1) .OR. !Vazio(cMotora)) Size 50,10 Pixel of oDlg

	oMotora:bLostFocus := {||IIF(!Empty(cMotora), (cNome:= SUBSTR(DA4->DA4_NOME,1,40),cTransp :=DA4->DA4_XTRANS ),"")}

/*
@ 32+nLnAjt,130 Say "Placa " Font oFont Pixel of oDlg
@ 32+nLnAjt,150 Msget oPlaca Var cPlaca F3 "XDA3"  Size 50,10 Pixel of oDlg Valid(ValPlaca(cPlaca))    //@ 32+nLnAjt,150 Msget oPlaca Var cPlaca F3 "XDA3" Valid ( IIF(ExistCpo("DA3",cPlaca,3) .OR. !Vazio(cPlaca) , (cMotora := POSICIONE("DA4",1,XFILIAL("DA4")+DA3->DA3_MOTORI,"DA4_COD") ,cNome := POSICIONE("DA4",1,XFILIAL("DA4")+DA3->DA3_MOTORI,"DA4_NOME")) ,.F.) ) Size 50,10 Pixel of oDlg  
@ 47+nLnAjt,10 Say "Motorista " Font oFont Pixel of oDlg
@ 47+nLnAjt,55 Msget oMotora Var cMotora F3 "DA4" Size 50,10 Pixel of oDlg  Valid(ValMotor(cPlaca))  //Valid (ExistCpo("DA4",,1) .OR. !Vazio(cMotora))  //@ 47+nLnAjt,55 Msget oMotora Var cMotora F3 "DA4" Valid (ExistCpo("DA4",,1) .OR. !Vazio(cMotora)) Size 50,10 Pixel of oDlg   
//oMotora:bLostFocus := {||IIF(!Empty(cMotora), (cNome:= SUBSTR(DA4->DA4_NOME,1,40),cTransp :=DA4->DA4_XTRANS ),"")}
*/

	@ 47+nLnAjt,130 Say "Nome Motorista " Font oFont Pixel of oDlg
	@ 47+nLnAjt,195 Msget oNome Var cNome  When .F. Size 150,10 Pixel of oDlg

	@ 62+nLnAjt,10 Say "Cliente " Font oFont Pixel of oDlg
	@ 62+nLnAjt,55 Msget oCliente Var cCliente F3 "SA1" Valid {|| iif( ExistCpo("SA1",,1), (cLoja:=SA1->A1_LOJA, .T.), (cLoja:=Space( len(SA1->A1_LOJA) ),.F.) )} Size 50,10 Pixel of oDlg
	oCliente:bLostFocus := {||IIF(!Empty(cCliente),u_FAT010B(cCliente,cLoja,nXOpc),"")}

	@ 62+nLnAjt,130 Say "Loja " Font oFont Pixel of oDlg
	@ 62+nLnAjt,150 Msget oLoja Var cLoja Size 20,10 Pixel of oDlg
	oLoja:bLostFocus := {||IIF(!Empty(cCliente),u_FAT010B(cCliente,cLoja,nXOpc),"")}

	@ 62+nLnAjt,180 Say "Cliente " Font oFont Pixel of oDlg
	@ 62+nLnAjt,220 Msget oRazao Var cRazao Size 125,10 When .F. Pixel of oDlg

	@ 77+nLnAjt,10 Say "Transp." Font oFont Pixel of oDlg
	@ 77+nLnAjt,55 Msget oTransp Var cTransp F3 "SA4" Valid ( ExistCpo("SA4",,1) .OR. Vazio(cTransp)) Size 50,10 Pixel of oDlg  //when .f.

	@ 77+nLnAjt,130 Say "Frete Aut " Font oFont Pixel of oDlg
	@ 77+nLnAjt,175 Msget oVlrFau Var nVlrFau Picture "@E 9,999,999.99" Size 50,10 Pixel of oDlg

	@ 77+nLnAjt,240 Say "Frete " Font oFont Pixel of oDlg
	@ 77+nLnAjt,295 Msget oVlrFre Var nVlrFre When .F. Picture "@E 9,999,999.99" Size 50,10 Pixel of oDlg
//@ 77+nLnAjt,295 Msget oGuiaST Var nGuiaST Picture "@E 9,999,999.99" Size 50,10 Pixel of oDlg
//@ 77+nLnAjt,295 Msget oGuiaST Var cGuiaST Picture "@!" Size 50,10 Pixel of oDlg 

//campo observacao nfe  
	@ 106+nLnAjt,010 Say "Obs. Contrato " Font oFont Pixel of oDlg
	@ 106+nLnAjt,055 Msget oObs Var cObs Picture "@!" Size 135,10 when .f. Pixel of oDlg
//Campo referente ao lote
	@ 106+nLnAjt,240 Say "Lote" Font oFont Pixel of oDlg
	@ 106+nLnAjt,295 Msget oLote Var cLote Picture "@!" Size 06,10  when lFlagWhen Pixel of oDlg

//despesa transporte interna
	@ 91+nLnAjt,240 Say "Desp transp " Font oFont Pixel of oDlg
	@ 91+nLnAjt,295 Msget oDesp Var nDesp When .F. Picture "@E 9,999,999.99" Size 50,10 Pixel of oDlg

	if Empty(cCliente)
		SetKey(VK_F7,{||iif(nXOpc == 1,nPesoIni:=u_FAT0510(1,nPesoIni,nPesoFim),nPesoFim:=u_FAT0510(2,nPesoIni,nPesoFim)),})
		// Chama Fun็ใo para Montar MsSelect dos Contratos de Parceria
		u_FAT010B(cCliente,cLoja,nXOpc)
	EndIf

	if Empty(cCliente) .or. nXOpc == 2
		// Chama Fun็ใo para Montar MsNewGetDados dos mic referentes aos itens do contratos
		u_FAT010C(aContr,nXOpc,1)
	EndIf

	IF nXOpc == 3 //Visualiza Carregamento
		SetKey(VK_F7,{||iif(nXOpc == 1,nPesoIni:=u_FAT0510(1,nPesoIni,nPesoFim),nPesoFim:=u_FAT0510(2,nPesoIni,nPesoFim)),})
		u_FAT010B(Alltrim(cCliente),Alltrim(cLoja),nXOpc)
		u_FAT010C(aContr,nXOpc,1)
		clote := ZC3->ZC3_XLOTE
	EndIf
	//verificar se tinha algo Carlos Daniel
	if nXOpc == 1
//  oPesoFim:Disable()
//  oPesoFim:Refresh()
	EndIf
	fNopc := 0

//nxOPC = 1 = Inclusใo
//nxOPC = 2 = Altera็ใo
//NXOPC = 4 = Manuten็ใo 
//NXOPC = 3 = Visualizar

	if nXOpc = 1
		@ 220+nLnAjt,450 BUTTON oButton2 PROMPT "Incluir"  	  SIZE 045, 012 OF oDlg PIXEL  	Action (fNopc := 1 ,GravaCarga(oBrw:aCols,nPesoIni,nPesoFim,aContr,nXOpc)  )
		@ 220+nLnAjt,500 BUTTON oButton3 PROMPT "Cancelar" SIZE 045, 012 OF oDlg PIXEL  	Action (fNopc := 2 ,oDlg:End())
	Elseif nXOpc = 2
		@ 220+nLnAjt,450 BUTTON oButton2 PROMPT "Alterar"  	  SIZE 045, 012 OF oDlg PIXEL  	Action (fNopc := 1 ,GravaCarga(oBrw:aCols,nPesoIni,nPesoFim,aContr,nXOpc),oDlg:End()  )
		@ 220+nLnAjt,500 BUTTON oButton3 PROMPT "Cancelar" SIZE 045, 012 OF oDlg PIXEL  	Action (fNopc := 2 ,oDlg:End())
	Elseif nXOpc = 4
		@ 220+nLnAjt,420 BUTTON oButton2 PROMPT "Confirmar Manuten็ใo"  SIZE 060, 012 OF oDlg PIXEL    Action (fNopc := 1 ,GravaCarga(oBrw:aCols,nPesoIni,nPesoFim,aContr,nXOpc),oDlg:End()  )
		@ 220+nLnAjt,500 BUTTON oButton3 PROMPT "Cancelar" SIZE 045, 012 OF oDlg PIXEL  			   Action (fNopc := 2 ,oDlg:End())
	Elseif nXOpc = 3
//	 u_FAT010B(cCliente,cLoja,nXOpc)
//	 u_FAT010C(aContr,nXOpc,1)	
//	@ 220+nLnAjt,450 BUTTON oButton2 PROMPT "Visualizar"  SIZE 045, 012 OF oDlg PIXEL  	Action (fNopc := 1 ,oDlg:End())
		@ 220+nLnAjt,500 BUTTON oButton3 PROMPT "Cancelar" SIZE 045, 012 OF oDlg PIXEL  Action (fNopc := 2 ,oDlg:End())
	EndIf

//Aadd(aButtons,{"BMPINCLUIR" ,{||iif(nXOpc == 1,nPesoIni:=u_FAT0510(1,nPesoIni,nPesoFim),nPesoFim:=u_FAT0510(2,nPesoIni,nPesoFim)),}, "Pesagem","Pesagem"})
	Activate MsDialog oDlg Centered //ON INIT EnchoiceBar(oDlg,{|| IIF(nXOpc == 3, oDlg:End(),u_FAT010D(oBrw:aCols,nPesoIni,nPesoFim,aContr,nXOpc))},{|| RollBackSX8(),oDlg:End()},,aButtons)

//Fecha a Area e elimina os arquivos de apoio criados em disco.        

	if Select("QADA") > 1
		QADA->( DbCloseArea() )
	EndIf

//iif(File(cArq + GetDBExtension()),FErase(cArq  + GetDBExtension()) ,Nil)  // QADA

	if fNopc = 1 .AND. ( nXOpc = 1 .OR. nXOpc = 4 ) //Caso Clique em Confirmar ้ Seja Incluir ou Manuten็ใo


	Else //Caso Clique em Cancelar
		RollBackSX8() //ConfirmSX8()

		if Select("QADA")> 1
			QADA->( DbCloseArea() )
		EndIf

	EndIf

Return()

Static Function ValPlaca(cPlaca)
	lRet := .T.

	if !Empty(cPlaca)
		DbSelectArea("DA3")
		DA3->(DbSetOrder(3))
		if DA3->(DbSeek(xFilial("DA3")+cPlaca))
			cPlaca  := DA3->DA3_PLACA
			cMotora := POSICIONE("DA4",1,XFILIAL("DA4")+DA3->DA3_MOTORI,"DA4_COD" )
			cNome   := POSICIONE("DA4",1,XFILIAL("DA4")+DA3->DA3_MOTORI,"DA4_NOME")
		Else
			cPlaca := cPlaca
			MsgAlert("Placa Nใo Cadastrada , Verifique!!!")
		EndIf
	Else
		MsgAlert("Placa Nใo Cadastrada , Verifique!!!")
	EndIf

Return(lRet)

Static Function ValMotor()
	lRet := .T.
//preenche com dados do cadastro de motorista
	if !Empty(cMotora)
		DbSelectArea("DA4")
		DA4->(DbSetOrder(1))
		if DA4->(DbSeek(xFilial("DA4")+cMotora))
			cMotora := DA4->DA4_COD
			cNome   := DA4->DA4_NOME
			cTransp := DA4->DA4_XTRANS
		Else
			cMotora := cMotora
			MsgAlert("Motorista Nใo Cadastrado , Verifique!!!")
		EndIf
	Else
		MsgAlert("Motorista Nใo Cadastrado , Verifique!!!")
	EndIf

Return(lRet)

Static Function GravaCarga(aDados,nPesoIni,nPesoFim,aContr,nXOpc)

	if  nXOpc = 1 //Grava Inclusใo de Carregamento
		//	nPesoIni := 0 //	nPesoFim := 0

		if u_FAT010D(aDados,nPesoIni,nPesoFim,aContr,nXOpc) //Processo Gravar Ordem de Carregamento e Alterar Status
			oDlg:End()       	 //Fecha Rotina Inclui Carga

			if  nXOpc = 1   	 //Somente quando ้ Inclusใo

				//oDlgCar:End()	 //Fecha Sele็ใo de Carga

			EndIf
			BuscaCarga(ZC3->ZC3_ORDEM,nXOpc)	//Adiciona Carga na Rotina Principal
		EndIf
	EndIf

Return()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFAT010    บAutor  ณInnovare Solu็๕es   บ Data ณ  08/01/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Busca Contratos disponiveis para o cliente selecionado     บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ FAT010                                                     บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/                               
User Function FAT010B(cCodCli,cLojaCli,nXOpc)
	Local _stru   := {}
	Local aCpoBro := {}
	Local cQuery:= ""
	Local nExiste:= 0
	Local i := 0
	Private cMennota := " "

	if !Empty(cCodCli) .and. nXOpc == 1
		DbSelectArea("SA1")
		SA1->(DbSetOrder(1))
		SA1->(DbSeek(xFilial("SA1")+cCodCli+cLojaCli))

		cLojaCli := SA1->A1_LOJA
		cLoja := SA1->A1_LOJA
		cRazao:= SUBSTR(SA1->A1_NOME,1,40)

		oLoja:Refresh()
		oRazao:Refresh()

		cQuery:= " SELECT DISTINCT ADA_NUMCTR,ADA_EMISSA, ADA_XMENOT FROM " + RETSQLNAME("ADA") + " ADA," +  RETSQLNAME("ADB") + " ADB"
		cQuery+= " WHERE ADA.D_E_L_E_T_ = ' ' AND ADB.D_E_L_E_T_ = ' '"
		cQuery+= " AND ADA_FILIAL = ADB_FILIAL "
		cQuery+= " AND ADA_NUMCTR = ADB_NUMCTR"
		//cQuery+= " AND ADA_CODCLI = ADB_CODCLI"
		//cQuery+= " AND ADA_LOJCLI = ADB_LOJCLI"
		cQuery+= " AND ADB_QTDEMP < ADB_QUANT"
		cQuery+= " AND ADA_STATUS IN ('B','C') "	// Contrato em Aberto ou Contrato Parcialmente Entregue
		cQuery+= " AND ADA_MSBLQL  = '2'	"			// Somente Contratos Liberados
		//cQuery+= " AND ADA_XLIBMS  != 'B'	"			// Somente Contratos Liberados MS / Cairo 26/06/20
		cQuery+= " AND ADA_FILIAL = '" + xFILIAL("ADA") + "'"
		cQuery+= " AND ADA_CODCLI = '" + cCodCli + "'"
		cQuery+= " AND ADA_LOJCLI = '" + cLojaCli   + "'"
		cQuery+= " ORDER BY ADA_NUMCTR,ADA_EMISSA"

		if Select("QDBA") > 1
			QDBA->( dbclosearea() )
		EndIf

		TcQuery cQuery New Alias "QDBA"
	EndIf

	AADD(_stru,{"OKDA"     	,"C" , 2   ,0 })
	AADD(_stru,{"CONTRATO"  ,"C" , 21  ,0 })
	AADD(_stru,{"EMISSAO"   ,"D" , 10  ,0 })

//cArq:= Criatrab(_stru,.T.)
//if Select("QADA")> 1
//	QADA->( DbCloseArea() )
//EndIf	
//DbUseArea(.t.,,carq,"QADA")  

	if Select("QADA")> 1
		QADA->( DbCloseArea() )
	EndIf

	oTable := FWTemporaryTable():New("QADA")
	oTable:SetFields(_stru)
	oTable:AddIndex("1", {"OKDA","CONTRATO","EMISSAO"} )
	oTable:Create()

//Define quais colunas (campos da TTRB) serao exibidas na 

	aCpoBro	:= {{ "OKDA"		,, "Mark"		  ,"@!" },;
		{ "CONTRATO"	,, "Contrato"     ,"@!" },;
		{ "EMISSAO"  	,, "Emissใo"      ,"@!" }}

//Alimenta o arquivo de apoio com os registros

	If !Empty(cCodcli) .AND. nXOpc == 1  // Inclusao

		QADA->( DbGotop() )
		While  !QDBA->( Eof() )

			RecLock("QADA",.T.)
			QADA->CONTRATO:=  QDBA->ADA_NUMCTR
			QADA->EMISSAO :=  STOD(QDBA->ADA_EMISSA)
			cMennota := QDBA->ADA_XMENOT
			QADA->( MsunLock() )

			QDBA->( DbSkip() )
		Enddo

	Elseif nXOpc != 1 // Alterar ou Visualizar
		for i:= 1 to len(aCols)
			// Valida se Contrato ja existe na tabela temporaria
			While !QADA->( Eof() )
				if AllTrim(QADA->CONTRATO) == AllTrim(aCols[i,2])
					nExiste++
					Exit
				EndIf
				QADA->( DbSkip() )
			enddo

			if nExiste == 0
				RecLock("QADA",.T.)
				QADA->CONTRATO:=  aCols[i,2]
				QADA->EMISSAO :=  POSICIONE("ADA",1,xFILIAL("ADA")+aCols[i,2],"ADA_EMISSA")
				QADA->OKDA := cMark
				QADA->( MsunLock() )
			EndIf
		Next i

		QADA->( DBGOTOP() )
	EndIf

	if nXOpc = 4  //Manuten็ใo da Ordem de Carregamento
		@ 002+nLnAjt+40,366 TO 120+nLnAjt+40,550 LABEL 'Contratos' OF oDlg PIXEL
	Else
		@ 002+nLnAjt   ,366 TO 120+nLnAjt,550    LABEL 'Contratos' OF oDlg PIXEL
	EndIf

	if Empty(oMark)
		if nXOpc = 4  //Manuten็ใo da Ordem de Carregamento
			oMark:= MsSelect():New("QADA","OKDA","",aCpoBro,@lInverte,@cMark,{010+nLnAjt+40,370,117+nLnAjt,545},,,,,)
		Else
			oMark:= MsSelect():New("QADA","OKDA","",aCpoBro,@lInverte,@cMark,{010+nLnAjt   ,370,117+nLnAjt,545},,,,,)
		EndIf
	EndIf
	oMark:bMark:={|| Disp() } //Exibe a Dialog

	QADA->( DbGoTop() )
	oMark:oBrowse:Refresh()
//Colocar refresh aqui

Return()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFAT010C    บAutor  ณInnovare Solu็๕es  บ Data ณ  08/01/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Carrega os Itens da Ordem de Carregamento de Acordo com    บฑฑ
ฑฑบ          ณ Contratos Selecionados.                                    บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ FAT010                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function FAT010C(aContr,nXOpc,nzOPC)
	Local nItem:= 0
	Local nOpc := GD_DELETE+GD_UPDATE
	Local linha:=0, nova:=0
	Local aAlter:= {"ZC4_QTDE","ZC4_MENOTA"} //CARLOS DANIEL
	Local i := 0
	Local nY := 0

	if len(aContr) >= 1

		aCols:= {}
		nPesoInf:= 0

		for nY:= 1 to Len(aContr)

			_Query:= " SELECT ADB_NUMCTR,ADB_CODPRO,ADB_DESPRO,SUM(ADB_QUANT - ADB_QTDEMP) SALDO, ADA.ADA_XMENOT FROM " + RETSQLNAME("ADB")+" ADB, " +RetSqlName("ADA")+" ADA"
			_Query+= " WHERE ADB.D_E_L_E_T_ = ' ' "
			_Query+= " AND ADA.D_E_L_E_T_ = ' ' "
			_Query+= " AND ADA.ADA_NUMCTR = ADB.ADB_NUMCTR "
			_Query+= " AND ADA.ADA_FILIAL = ADB.ADB_FILIAL "
			_Query+= " AND ADB_QTDEMP < ADB_QUANT "
			_Query+= " AND ADB_FILIAL = '" + xFILIAL("ADB") + "'"
			_Query+= " AND ADB_NUMCTR = '" + aContr[nY,1] + "'"
			_Query+= " GROUP BY ADB_NUMCTR,ADB_CODPRO,ADB_DESPRO, ADA.ADA_XMENOT "
			_Query+= " ORDER BY ADB_CODPRO,ADB_NUMCTR "

			if Select("QADB") > 1
				QADB->( DbCloseArea() )
			EndIf

			TcQuery _Query New Alias "QADB"

			While !QADB->( EOF() )

				// Salta registro se o saldo do produto for 0
				if QADB->SALDO == 0

					QADB->( DbSkip() )

				Else
					nova := len(aCols)+1

					AADD(aCols,Array((Len(aHeader)+1)))


					For i:= 1 to Len(aHeader)
						aCols[nova][i] := CriaVar(aHeader[i][2])
					Next i

					aCols[nova][Len(aHeader)+1] := .F.

					linha:= len(aCols)
					nItem++
					cUm :=POSICIONE("SB1",1,xFILIAL("SB1")+QADB->ADB_CODPRO,"B1_UM")
					nPesoLiq := 0 //POSICIONE("SB1",1,xFILIAL("SB1")+QADB->ADB_CODPRO,"B1_PESO") --Altera็ใo para atender ERCAL Ao selecionar contrato ja cai aqui.
					//Alterado Carlos Daniel Atualiza Mensagem Contrato grid
					dbSelectArea("ADA")
					ADA->(dbSetOrder(1))
					ADA->(dbSeek(xFilial("ADA")+QADB->ADB_NUMCTR))

					cobs:= QADB->ADA_XMENOT
					oObs:Refresh()
					If ADA->ADA_XFRETE <> 0 // verifica que tipo de frete
						nVlrFre := QADB->SALDO*ADA->ADA_XDESPU//ADA->ADA_XDESPU
						oVlrFre:Refresh()
						nDesp := 0
						oDesp :Refresh()
					ElseiF ADA->ADA_XDESP <> 0
						//nVlrFau := QADB->SALDO*ADA->ADA_XDESPU//ADA->ADA_XDESPU
						//oVlrFau :Refresh()
						nDesp := QADB->SALDO*ADA->ADA_XDESPU//ADA->ADA_XDESPU
						oDesp :Refresh()
						nVlrFre := 0//ADA->ADA_XDESPU
						oVlrFre:Refresh()
					Else
						nVlrFre := 0
						oVlrFre:Refresh()
						nDesp := 0
						oDesp :Refresh()
					EndIf

					if AllTrim(cUm) == "TN" .and. nPesoLiq == 0
						nPesoInf += QADB->SALDO * 1000 // Atualiza Peso Informado
					else
						nPesoInf += nPesoLiq
					EndIf
					IF AllTrim(QADB->ADB_CODPRO) == "001950" .OR. AllTrim(QADB->ADB_CODPRO) == "051191" .OR. AllTrim(QADB->ADB_CODPRO) == "000400"  // aLTERAR PARA PRODUTOS DO OFICIAL
						lFlagWhen := .T.
						cLote := Substr(Replace(Dtoc(Date()), "/", ""), 3, 6)
					ELSE
						lFlagWhen := .F.
					EndIf
					aCols[linha,Ascan(aHeader,{|x| Upper(AllTrim(x[2]))=="ZC4_ITEM"})]  := nItem
					aCols[linha,Ascan(aHeader,{|x| Upper(AllTrim(x[2]))=="ZC4_CONTRA"})]:= QADB->ADB_NUMCTR
					aCols[linha,Ascan(aHeader,{|x| Upper(AllTrim(x[2]))=="ZC4_PRODUT"})]:= QADB->ADB_CODPRO
					aCols[linha,Ascan(aHeader,{|x| Upper(AllTrim(x[2]))=="ZC4_DESCRI"})]:= QADB->ADB_DESPRO
					aCols[linha,Ascan(aHeader,{|x| Upper(AllTrim(x[2]))=="ZC4_QTDE"})]  := QADB->SALDO // Quantidade em toneladas
					aCols[linha,Ascan(aHeader,{|x| Upper(AllTrim(x[2]))=="ZC4_MENOTA"})] := QADB->ADA_XMENOT // MENSAGEM NOTA
				EndIf

				QADB->( DbSkip() )

			enddo

		next nY

		oBrw:SetArray(aCols)
		oBrw:Refresh(.T.)
		oPesoInf:Refresh()
		//oVlrFre:Refresh()
		//oDesp :Refresh()

		QADA->( DbGotop() )
		oMark:oBrowse:Refresh()

	EndIf

	if Len(aCols) == 0
		nPesoInf:= 0
		oPesoInf:Refresh()
	EndIf

	if Len(aContr) == 0 .and. Empty(oBrw)

		//Chama fun็ใo para montar aHeader e aCols
		MontaEst()

		@ 122+nLnAjt,007 TO 215+nLnAjt,550 LABEL 'Itens Contratos' OF oDlg PIXEL

		oBrw:= MsNewGetDados():New( 130+nLnAjt, 010, 210+nLnAjt, 545,nOpc,"AllwaysTrue" , "AllwaysTrue","" , aAlter, , 999, "AllwaysTrue", "",, oDlg  ,aHeader, aCols)
		//	oBrw:oBrowse:lUseDefaultColors := .F. // Desabilita cor padrao das linhas
		oBrw:bDelOk:={||u_DeletOKF()}

		if nXOpc == 1
			oMark:oBrowse:Refresh()
		Else // Chama fun็ใo para carregar dados quando opcao for editar
			u_FAT010E(nzOPC)

			//if nXOpc == 4 //Manuten็ใo de Pesagem
			oMark:oBrowse:Enable()
			//EndIf

		EndIf
	EndIf

Return()
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณDisp      บAutor  ณInnovare Solu็๕es   บ Data ณ  08/01/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Fun็ใo auxiliar para marcar e desmarcar a Check da         บฑฑ
ฑฑบ          ณ  MsSelect                                                  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function Disp()
	Local aReg:= {}

	RecLock("QADA",.F.)

	If Marked("OKDA")
		QADA->OKDA := cMark
	Else
		QADA->OKDA := ""
	EndIf

	MSUNLOCK()

	oMark:oBrowse:Refresh()

// Adiciona Contratos Marcados na MsSelect no Array
	QADA->(DbGotop())
	While QADA->(!EOF())

		If !Empty(QADA->OKDA)
			AADD(aReg,{QADA->CONTRATO})
		EndIf

		QADA->(Dbskip())
	Enddo

// Se nenhum Contrato foi marcada apaga o que estiver no aCols
	if Len(aReg) == 0
		aCols:= {}
	EndIf

	QADA->(DbGotop())
	oMark:oBrowse:Refresh()
	oBrw:SetArray(aCols)
	oBrw:Refresh(.T.)

//Chama Fun็ใo que atualiza a GetDados dos Produtos

	u_FAT010C(aReg)

Return()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMontaEst	บAutor  ณInnovare Solu็๕es   บ Data ณ  31/07/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Monta Estrutura do aHeader e aCols                         บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ FAT010                                                     บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function MontaEst()
	Local nX := 0
	Local aFieldFill := {}
	Local aFields := {"ZC4_ITEM","ZC4_CONTRA","ZC4_PRODUT","ZC4_DESCRI","ZC4_MENOTA","ZC4_QTDE"} //carlos tela baixo

//	SX3->( DbSetOrder(2) )
//	for nX:=1 to len(aFields)
//	
//		if SX3->( DbSeek(aFields[nX]) )
//			Aadd(aHeader, {AllTrim(X3Titulo()),SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,'',;
//						SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_F3,SX3->X3_CONTEXT,SX3->X3_CBOX,SX3->X3_RELACAO})
//		EndIf
//		if nX == 4 //ajuste carlos definir tamanho campo descricao
//			aHeader[4][4] = 30
//		EndIf
//	next nX

	For nX := 1 to Len(aFields)

		Aadd(aHeader, {	GetSx3Cache(aFields[nX],"X3_TITULO"),;
			GetSx3Cache(aFields[nX],"X3_CAMPO"),;
			GetSx3Cache(aFields[nX],"X3_PICTURE"),;
			GetSx3Cache(aFields[nX],"X3_TAMANHO"),;
			GetSx3Cache(aFields[nX],"X3_DECIMAL"),;
			'',;
			GetSx3Cache(aFields[nX],"X3_USADO"),;
			GetSx3Cache(aFields[nX],"X3_TIPO"),;
			GetSx3Cache(aFields[nX],"X3_F3"),;
			GetSx3Cache(aFields[nX],"X3_CONTEXT"),;
			GetSx3Cache(aFields[nX],"X3_CBOX"),;
			GetSx3Cache(aFields[nX],"X3_RELACAO")})

		if nX == 4 //ajuste carlos definir tamanho campo descricao
			aHeader[4][4] = 30
		EndIf

	Next nX

	For nX := 1 to Len(aFields)
//		If SX3->( DbSeek(aFields[nX]) )
		Aadd(aFieldFill, CriaVar(aFields[nX]))
//		EndIf
	Next nX

	Aadd(aFieldFill, .F.)
	Aadd(aCols, aFieldFill)
Return()


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFAT010D   บAutor  ณInnovare Solu็๕es   บ Data ณ  08/01/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Fun็ใo Executada ao Clicar em Confirmar para gravar os     บฑฑ
ฑฑบ          ณ Dados da Orderm de Carregamento                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ FAT010                                                     บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function FAT010D(aDados,nPesoIni,nPesoFim,aContr,nXOpc)
	Local cQry 			:= ""
	Local cContratos	:= ""
	Local aMarcado		:= {}
	Local _GravaOk		:= .T.
	Local nQtde 		:= 0
	Local lContrICM
	Local i, x, nj

//Posiciona as tabelas
	SA1->(dbSetOrder(1))
	SA1->(DbSeek( xFilial("SA1")+cCliente+iif(Empty(cLoja),"",cLoja) ) )

	SA4->(dbSetOrder(1))
	SA4->(MsSeek(xFilial("SA4")+cTransp))

	lContrICM := !(IIf(Empty(SA1->A1_INSCR) .Or. "ISENT"$SA1->A1_INSCR .Or. "RG"$SA1->A1_INSCR .Or. ( SA1->(FieldPos("A1_CONTRIB"))>0 .And. SA1->A1_CONTRIB == "2"),.T.,.F.))

	cStatus	  := Posicione("ZC3",1,xFILIAL("ZC3")+ cNrOrdem,"ZC3_STATUS")

	if Empty(nPesoFim) .AND. nXOpc == 2 .AND. cStatus == "2"
		Alert("Peso Final da Ordem de Carregamento deve ser Informado para finalizar o processo !")
		Return .F.
	EndIf

//if Len(aDados) == 0 .OR. Empty(aDados[1,2])
//	Alert("Ordem de Carregamento nใo pode ser gerada sem Produto, informe ao menos um Contrato com Produto Disponivel !","Aten็ใo")
//	QADA->( DbGoTop() )
//	Return .F.

	IF .T.

		if Len(aDados) != 0
			// Valida se todas a linhas estao deletas para nao permitir inclusใo sem produto
			For x:= 1 to len(aDados)
				if aDados[x,len(aHeader)+1] == .T.
					nQtde++
				EndIf
			Next x

			if nQtde == Len(aCols)
				Alert("Ordem de Carregamento nใo pode ser gerada sem Produto, informe ao menos um Contrato com Produto Disponivel !","Aten็ใo")
				//	QADA->( DbGoTop() )
				//	Return .F.
			EndIf
		EndIf

		if nXOpc == 1

			//if Empty(nPesoIni)
			//	Alert("O Campo Peso Inicial ้ de Preenchimento Obrigat๓rio","Aten็ใo")
			//	Return .F.
			if Empty(cPlaca)
				Alert("O Campo Placa ้ de Preenchimento Obrigat๓rio","Aten็ใo")
				Return .F.
			Elseif Empty(cMotora)
				Alert("O Campo Motorista ้ de Preenchimento Obrigat๓rio","Aten็ใo")
				Return .F.
			Elseif Empty(cTransp)
				Alert("O Campo Transportadora ้ de Preenchimento Obrigat๓rio","Aten็ใo")
				Return .F.
			EndIf
			//Valida Frete

			lRet	:= .t.
			cMsg	:= ""

			If nVlrFau > 0
				//validacao de frete
				if POSICIONE("SA1",1,xFILIAL("SA1")+ADA->ADA_CODCLI+ADA->ADA_LOJCLI,"A1_EST") == SuperGetMV("MV_ESTADO")
					//cMsg:="Cliente Minas Gerais, nใo informe o Frete Autonomo"
					//lRet := .F.
					//nVlrFau := 0
					//if add carlos daniel
					if MsgYesNo("Cliente do estado: "+POSICIONE("SA1",1,xFILIAL("SA1")+ADA->ADA_CODCLI+ADA->ADA_LOJCLI,"A1_EST") +" , nใo tem Frete Autonomo, deseja zerar o Frete Autonomo? ", "FRETE AUTONOMO")
						//lRet := .F.
						nVlrFau := 0
						//Return .F.
					Else
						lRet := .T.
					EndIf
				Elseif cTransp='000004' .OR. cTransp='000010' .OR. cTransp='000011' .OR. cTransp='000423' // se for transportador proprio nao informa frete aut
					if MsgYesNo("Transp Ercal, ele realmente tem Frete Autonomo ? deseja retirar frete autonomo? ", "FRETE AUTONOMO")
						//cMsg :="Retirar Informa็ใo do Campo Frete Autonomo?"
						//lRet := .f.
						nVlrFau := 0
					else
						lRet := .T.
					EndIf
				EndIf

			Else
				if !cTransp='000004' .OR. !cTransp='000010' .OR. !cTransp='000011' .OR. !cTransp='000423'
					if POSICIONE("SA1",1,xFILIAL("SA1")+ADA->ADA_CODCLI,"A1_EST") <> SuperGetMV("MV_ESTADO")
						if MsgYesNo("Este Contrato tem Frete Autonomo ? ", "FRETE AUTONOMO")
							cMsg :="Informe o Valor do Frete Autonomo"
							lRet := .F.
						Else
							nVlrFau := 0
							lRet := .T.
						EndIf
					EndIf
				EndIf
			EndIf
			if !lRet
				Alert(cMsg,"Aten็ใo")
				Return .F.
			EndIf

			QADA->( DbGoTop() )
			While QADA->(!EOF())

				if !Empty(QADA->OKDA)
					AADD(aMarcado,{QADA->CONTRATO})
				EndIf

				QADA->( DbSkip() )
			Enddo

			For i:=1 to len(aMarcado)
				If i != Len(aMarcado)
					cContratos :=  "'" + aMarcado[i,1] + "'" + ","
				Else
					cContratos +=  "'" + aMarcado[i,1] + "'"
				EndIf
			Next i

			if !Empty(cContratos)
				//--- Verifica se existe exite carregamento em aberto para o Cliente + Contrato + placa informados
				cQry:= "  SELECT ZC3_ORDEM, ZC3_PLACA,ZC4_CONTRA, ZC3_STATUS FROM " + RETSQLNAME("ZC3") + " ZC3," + RETSQLNAME("ZC4") + " ZC4"
				cQry+= "  WHERE ZC3.D_E_L_E_T_ = ' ' AND ZC4.D_E_L_E_T_ = ' ' "
				cQry+= "  AND ZC3_FILIAL = ZC4_FILIAL "
				cQry+= "  AND ZC3_ORDEM = ZC4_ORDEM "
				cQry+= "  AND ZC3_FILIAL  = '" + xFILIAL("ZC3") + "'"
				cQry+= "  AND ZC3_CODCLI  = '" + Alltrim(cCliente) + "'"
				cQry+= "  AND ZC4_CONTRA  IN (" + cContratos + " ) "   //Contrato
				cQry+= "  AND ZC3_PLACA	  = '" + cPlaca + "'"
				cQry+= "  AND ZC3_STATUS IN ('1','2') "

				if Select("QZC4") > 1
					QZC4->( DbCloseArea() )
				EndIf
				TcQuery cQry New Alias "QZC4"

				//Count To nLinhas  //Contar linhas da QZC4
				nLinhas := QZC4->( LastRec() )

				if nLinhas > 0
					Alert("Existe Carregamento em Aberto para Contrato e Veiculo Informado !","Aten็ใo")
					QADA->( DbGoTop() )
					Return .F.
				EndIf
			EndIf

			IF(!Empty(cLote))
				If MsgYesNo("Aten็ใo este Lote do produto estแ correto : " + cLote)
					cLote := M->CLOTE
				Else
					Return .F.
				EndIf
			EndIf

			if U_VaLinhaF(.T.) .and.MsgYesNo("Confirma Grava็ใo da Ordem de Carregamento !", "Protheus ")

				//--- Erro no P12 quando usa o F3 ele altera o conteudo do campo cNrOrdem!!!
				if len( Alltrim( cNrOrdem ) ) < 10
					RollBackSX8()
					cNrOrdem := GETSX8NUM("ZC3","ZC3_ORDEM")
				EndIf

				Begin Transaction

					Reclock("ZC3",.T.)
					ZC3->ZC3_FILIAL := xFilial("ZC3")
					ZC3->ZC3_DTRETI := cData
					ZC3->ZC3_HORA	:= cHora
					ZC3->ZC3_ORDEM	:= cNrOrdem
					ZC3->ZC3_PLACA	:= cPlaca
					ZC3->ZC3_CODMOT := cMotora
					ZC3->ZC3_MOTORI	:= cNome
					ZC3->ZC3_CODCLI := cCliente
					ZC3->ZC3_LOJA	:= cLoja
					ZC3->ZC3_NOMCLI   := cRazao
					ZC3->ZC3_PESINI   := nPesoIni
					ZC3->ZC3_PESFIM   := nPesoFim
					ZC3->ZC3_DESCONTO := nDescon
					ZC3->ZC3_PESLIQ   := nPesoLiq-nDescon
					ZC3->ZC3_STATUS   := "1"
					ZC3->ZC3_TRANSP	  := cTransp

					ZC3->ZC3_VLRFRE	  := nVlrFre
					ZC3->ZC3_FRETAU	  := nVlrFau
					ZC3->ZC3_DESPTR	  := nDesp
					ZC3->ZC3_XLOTE	  := cLote
					ZC3->( Msunlock() )

				End Transaction

				For nj:= 1 to Len(aDados)
					if aDados[nj,len(aHeader)+1] == .F. // Grava somente os Itens nao deletados

						Begin Transaction

							Reclock("ZC4",.T.)
							ZC4->ZC4_FILIAL  := xFilial("ZC4")
							ZC4->ZC4_ORDEM   := cNrOrdem
							ZC4->ZC4_CONTRA  := aDados[nj,2]
							ZC4->ZC4_PRODUT  := aDados[nj,3]
							ZC4->ZC4_DESCRI  := aDados[nj,4]
							ZC4->ZC4_MENOTA	 := aDados[nj,5]//coloca itens tabela baixa carlos
							ZC4->ZC4_QTDE    := aDados[nj,6]
							ZC4->( Msunlock() )

						End Transaction
					EndIf
				Next nj

				oDlg:End()
				ConfirmSX8()

			Else
				QADA->( DbGoTop() )
				Return .F.
			EndIf

		Elseif nXOpc == 2 .OR. nXOpc == 4 // Altera็ใo ou Manut. Ordem

			//--- Chama funcao para validar peso
			_GravaOk:= u_ValPesoF(.T.,nPesoIni,nPesoFim,1)

			if _GravaOk

				//Cabecalho Ordem de Carregamento
				//DbSelectArea("ZC3")

				ZC3->(DbSetOrder(1) )
				ZC3->(DbSeek(xFilial("ZC3")+cNrOrdem ) )
				cStatus:= ZC3->ZC3_STATUS

				Begin Transaction

			/*    
			//Comentado 
			if !nXOpc = 4
				Reclock("ZC3")
				
				ZC3->ZC3_PESFIM := nPesoFim
				ZC3->ZC3_PESLIQ := nPesoLiq
				ZC3->ZC3_DTFIM	:= DATE() // Data Final Carregamento
				ZC3->ZC3_HRFIM 	:= TIME()  // Hora Final Carregamento
				ZC3->ZC3_STATUS := iif(cStatus == "1","2","3") // Muda Status para Carregamento Finalizado ou Aguardando Pesagem Final
				
				ZC3->( Msunlock() )
			EndIf
			*/
					if nXOpc = 4  //Manuten็ใo
						Reclock("ZC3")
						ZC3->ZC3_DESCONTO := nDescon
						ZC3->( Msunlock() )
					EndIf

				End Transaction

				//Itens Ordem de Carregamen	to
				//DbSelectArea("ZC4")
				ZC4->( DbSetOrder(2) )
				ZC4->( DbGotop() )

				For nj:= 1 to Len(aDados)

					if ZC4->(DbSeek(xFILIAL("ZC4")+cNrOrdem+aDados[nj,2]+aDados[nj,3])) // Posiciona no registro com Filial + Ordem + Contrato

						if oBrw:aCols[nj,len(aHeader)+1] == .F. // Altera item nao deletado

							Begin Transaction

								Reclock("ZC4")

								//ZC4->ZC4_EMBAL	  := aDados[nj,5]
								ZC4->ZC4_MENOTA   := aDados[nj,5]
								ZC4->ZC4_QTDE     := aDados[nj,6]

								ZC4->( Msunlock() )

							End Transaction

						Else
							//--- deleta os itens que foram excluidos da getdados
							Begin Transaction

								Reclock("ZC4")
								ZC4->( dbDelete() )
								ZC4->( Msunlock() )

							End Transaction
						EndIf
					EndIf

				Next nj

				Msginfo("Inclusใo Realizada com Sucesso !")
				if nXOpc == 4
					oDlgman:End()
				Else
					oDlg:End()
				EndIf
			EndIf
		Else
			Return .F.
		EndIf
		oDlg:End()
	EndIf

Return .T.

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณVaLinha    บAutor  ณInnovare Solu็๕es  บ Data ณ  08/01/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Fun็ใo executada no momento da edi็ใo do Campo ZC4_QTDE    บฑฑ
ฑฑบ          ณ  da MsNewGetDados para validar se a quantidade informada   บฑฑ
ฑฑบ			 ณ	nใo ้ maior que o saldo disponivel no Contrato de parceriaบฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ FAT010                                                     บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function VaLinhaF(lGrava)
	Private cMensnfe := " "
	Default lGrava:=.f.
	if !Empty(oBrw)

		//Valida se a Nota Mใo foi emitida - Cesar J. Santos - 23/06/2023
		cTesCob := Posicione("ADB",3,xFilial("ADB")+oBrw:aCols[oBrw:nAT,2]+oBrw:aCols[oBrw:nAT,3],"ADB_TESCOB")   //Filial + Contrato + Produto
		if !empty(cTesCob)
			if Empty(ADB->ADB_PEDCOB) .or. Empty(Posicione("SC5",1,xFilial("SC5")+ADB->ADB_PEDCOB,"C5_NOTA"))
				Alert("Nใo foi emitida a Nota de Cobran็a do Contrato !","Aten็ใo")
				Return .F.
			EndIf
		EndIf

		if lGrava

			Return .T.

		EndIf

		cQtdePrd := Posicione("ADB",3,xFilial("ADB")+oBrw:aCols[oBrw:nAT,2]+oBrw:aCols[oBrw:nAT,3],"ADB_QUANT")   //Filial + Contrato + Produto
		cMensnfe := POSICIONE("ADA",1,xFILIAL("ADA")+oBrw:aCols[oBrw:nAT,2],"ADA_XMENOT")
		if !Empty(M->ZC4_MENOTA)
			if  M->ZC4_MENOTA != cMensnfe
				//oPesoInf:Refresh()
				oBrw:aCols[oBrw:nAT,5] := M->ZC4_MENOTA
				//Alert("MENSAGEM NOTA ษ " +cMensnfe+ " !","Aten็ใo")
				oBrw:Refresh()
			Else
				Alert("Quantidade Informada nใo pode ser Maior que o Saldo disponivel no Contrato !","Aten็ใo")
				Return .F.
			EndIf
		EndIf
		if !Empty(M->ZC4_QTDE)
			if  M->ZC4_QTDE > cQtdePrd     // Valida se Quantidade informada ้ Maior que a quantidade do Contrato
				Alert("Quantidade Informada nใo pode ser Maior que o Saldo disponivel no Contrato !","Aten็ใo")
				Return .F.
			Else
				// Chama funcao para atualizar o Peso informado carlos colocar se nao tiver M->ZC4_QTDE sai
				u_ValPesoF(.F.,nPesoIni,nPesoFim,2)
				oPesoInf:Refresh()
			EndIf
		EndIf
		// Calcula Peso Informado
	EndIf
Return .T.


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFAT010E    บAutor  ณInnovare Solu็oes  บ Data ณ  08/01/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Carrega Dados quando opcao de editar ou Visualizar         บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function FAT010E(nzOPC)
	Local cQryZC4:= ""
	Local nItem := 0
	Local i := 0

	cData	 := ZC3->ZC3_DTRETI
	cCliente := ZC3->ZC3_CODCLI
	cLoja	 := ZC3->ZC3_LOJA
	cHora    := ZC3->ZC3_HORA
	cNrOrdem := ZC3->ZC3_ORDEM
	cPlaca   := ZC3->ZC3_PLACA
	cMotora  := ZC3->ZC3_CODMOT
	cNome    := ZC3->ZC3_MOTORI
	cRazao   := ZC3->ZC3_NOMCLI
	nPesoIni := ZC3->ZC3_PESINI
	nPesoFim := ZC3->ZC3_PESFIM
	nPesoLiq := ZC3->ZC3_PESLIQ
	cTransp  := ZC3->ZC3_TRANSP

	//Claudio
	nVlrFre  := ZC3->ZC3_VLRFRE
	nVlrFau	 := ZC3->ZC3_FRETAU
	nDesp	 := ZC3->ZC3_DESPTR
	cLote    := ZC3->ZC3_XLOTE

	oCliente:Disable()
	oNrOrdem:Disable()
	oPlaca:Disable()
	oMotora:Disable()
	//oVlrFre:Disable()
	//oVlrFau:Disable()
	//oDesp:Disable()

	oCliente:Refresh()
	oNrOrdem:Refresh()
	oPlaca:Refresh()
	oMotora:Refresh()
	//oPesoIni:Refresh()
	//oPesoLiq:Refresh()


	OxPesoIni:Refresh()
	OxPesoFim:Refresh()
	OxPesoLiq:Refresh()
	OxDescont:Refresh()

	oMark:oBrowse:Disable()

	cQryZC4:= " SELECT ZC4_CONTRA,ZC4_PRODUT,ZC4_DESCRI,ZC4_MENOTA,ZC4_EMBAL,ZC4_PALET,ZC4_QTDE,ZC4_ORDEM,ZC3_STATUS FROM " + RETSQLNAME("ZC4")+ " ZC4,"+ RETSQLNAME("ZC3") + " ZC3"
	cQryZC4+= " WHERE ZC4.D_E_L_E_T_ = ' ' AND ZC3.D_E_L_E_T_ = ' ' "
	cQryZC4+= " AND ZC3_FILIAL = ZC4_FILIAL"
	cQryZC4+= " AND ZC3_ORDEM = ZC4_ORDEM"
	cQryZC4+= " AND ZC4_FILIAL = '" + xFILIAL("ZC4") + "'"
	cQryZC4+= " AND ZC4_ORDEM  = '" + cNrOrdem + "'"
	cQryZC4+= " ORDER BY ZC4_CONTRA "

	if Select("QRZC4") > 1
		QRZC4->( DbCloseArea() )
	EndIf
	TcQuery cQryZC4 New Alias "QRZC4"

//iif(QRZC4->ZC3_STATUS == "1",oPesoFim:Disable(),oPesoFim:Enable())	

//oPesoFim:Refresh()	
	aCols:={}

	QRZC4->( DbGoTop() )
	nPesoInf:= 0

	while !QRZC4->( Eof() )

		nova := len(aCols)+1

		AADD(aCols,Array((Len(aHeader)+1)))

		for i:= 1 to Len(aHeader)
			aCols[nova][i] := CriaVar(aHeader[i][2])
		next i

		aCols[nova][Len(aHeader)+1] := .F.

		linha:= len(aCols)
		nItem++
		cUm:=POSICIONE("SB1",1,xFILIAL("SB1")+QRZC4->ZC4_PRODUT,"B1_UM")
		nPesoLiq:=0//POSICIONE("SB1",1,xFILIAL("SB1")+QRZC4->ZC4_PRODUT,"B1_PESO")

		IF nzOPC = 2
			nPesoInf  := 0
		Else

			If cUm=='TN' .and. nPesoLiq=0
				nPesoInf+= QRZC4->ZC4_QTDE * 1000
			Else
				nPesoInf += nPesoLiq
			EndIf

		EndIf

		aCols[linha,Ascan(aHeader,{|x| Upper(AllTrim(x[2]))=="ZC4_ITEM"})]  := nItem
		aCols[linha,Ascan(aHeader,{|x| Upper(AllTrim(x[2]))=="ZC4_CONTRA"})]:= QRZC4->ZC4_CONTRA
		aCols[linha,Ascan(aHeader,{|x| Upper(AllTrim(x[2]))=="ZC4_PRODUT"})]:= QRZC4->ZC4_PRODUT
		aCols[linha,Ascan(aHeader,{|x| Upper(AllTrim(x[2]))=="ZC4_DESCRI"})]:= QRZC4->ZC4_DESCRI
		aCols[linha,Ascan(aHeader,{|x| Upper(AllTrim(x[2]))=="ZC4_MENOTA"})] := QRZC4->ZC4_MENOTA //itens parte baixo carlos
		//aCols[linha,Ascan(aHeader,{|x| Upper(AllTrim(x[2]))=="ZC4_PALET"})] := QRZC4->ZC4_PALET

		IF nzOPC = 2
			aCols[linha,Ascan(aHeader,{|x| Upper(AllTrim(x[2]))=="ZC4_QTDE"})]  := 0
		Else
			aCols[linha,Ascan(aHeader,{|x| Upper(AllTrim(x[2]))=="ZC4_QTDE"})]  := QRZC4->ZC4_QTDE
		EndIf

		oBrw:SetArray(aCols)
		oBrw:Refresh(.T.)
		oPesoInf:Refresh()

		QRZC4->( DbSkip() )

	Enddo

	if !Empty(aCols[1,2])// .AND. nzOPC <> 4
		u_FAT010B(cCliente,cLoja,2)
	EndIf

Return()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณValPeso   บAutor  ณInnovare Solucoes   บ Data ณ  08/06/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Funcao que faz Calculo e valida็ใo do Peso Liquido e       บฑฑ
ฑฑบ          ณ atualizacao do Peso total infomado                         บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function ValPesoF(lConfirma,nPesoIni,nPesoFim,nOpc)
	//Local nPalet   := 0
	Local nPosQtde := aScan(aHeader,{ |x| Upper(AllTrim(x[2])) == "ZC4_QTDE" })
	Local nPosProd := aScan(aHeader,{ |x| Upper(AllTrim(x[2])) == "ZC4_PRODUT" })
	Loca i := 0

	if !lConfirma  // Chamada somente para atualizar peso informado
		nPesoInf := 0

		For i:=1 to Len(oBrw:aCols)

			if oBrw:aCols[i,len(aHeader)+1] == .F.
				if nOpc != 3
					if i == n
						cUm      := POSICIONE("SB1",1,xFILIAL("SB1")+oBrw:aCols[i,nPosProd],"B1_UM")
						nPesoLiq :=0//POSICIONE("SB1",1,xFILIAL("SB1")+oBrw:aCols[i,nPosProd],"B1_PESO") Cesar J. Santos - 09/06/2023

						//Posicona aqui quando seleciono a qtd no contrato.
						if AllTrim(cUm) == "TN" .and. nPesoLiq == 0
							nPesoInf+= M->ZC4_QTDE * 1000
							nVlrFre := ADA->ADA_XDESPU
							If ADA->ADA_XFRETE <> 0
								nVlrFre := M->ZC4_QTDE * nVlrFre //FRETE DE ACORDO COM QUANTIDADE
								nDesp := 0
							ElseIf nDesp <> 0
								nDesp := M->ZC4_QTDE * nVlrFre //FRETE DE ACORDO COM QUANTIDADE
								nVlrFre := 0
							Else
								nDesp := 0
								nVlrFre := 0
							EndIf
						else
							nPesoInf += nPesoLiq
							nPesoInf+= M->ZC4_QTDE * 1000
							nVlrFre := ADA->ADA_XDESPU
							If ADA->ADA_XFRETE <> 0
								nVlrFre := M->ZC4_QTDE * nVlrFre //FRETE DE ACORDO COM QUANTIDADE
								nDesp := 0
							ElseIf nDesp <> 0
								nDesp := M->ZC4_QTDE * nVlrFre //FRETE DE ACORDO COM QUANTIDADE
								nVlrFre := 0
							Else
								nDesp := 0
								nVlrFre := 0
							EndIf
						EndIf

						BuscaDist()

					else

						cUm :=POSICIONE("SB1",1,xFILIAL("SB1")+oBrw:aCols[i,nPosProd],"B1_UM")
						nPesoLiq :=0//POSICIONE("SB1",1,xFILIAL("SB1")+oBrw:aCols[i,nPosProd],"B1_PESO") Cesar J. Santos - 09/06/2023
						if AllTrim(cUm) = "TN" .and. nPesoLiq = 0
							nPesoInf+= oBrw:aCols[i,nPosQtde] * 1000
						Else
							nPesoInf += nPesoLiq
						EndIf
					EndIf

					oPesoInf:Refresh()
					oVlrFre:Refresh()//ATUALIZA VALOR FRETE DE ACORDO COM QUANTIDADE
					oDesp:Refresh()
				/*
				if oBrw:aCols[i,5] != ""  .and. nOpc == 3 // Chamada de gatilho
					
					if 	oBrw:aCols[i,5] == "PM" // Palet Madeira
						nPalet+= GETMV("MV_XPLTMAD") * 	oBrw:aCols[i,6]  // Peso Palet Madeira * Qtde Palet do produto
						
					elseif 	oBrw:aCols[i,5] == "PF" // Palet Ferro	
						nPalet+=  GETMV("MV_XPLTFER") * 	oBrw:aCols[i,6]  // Peso Palet Ferro * Qtde Palet do produto					
					else // Container      
						nPalet+=  GETMV("MV_XCONTAI") * 	oBrw:aCols[i,6] // Peso Container * Qtde de Container
					EndIf
						                                                
					//nPesoLiq := (nPesoFim - nPesoIni) - nPalet
					//oPesoLiq:Refresh()
					   
					Return oBrw:aCols[i,6]

				EndIf
				*/
				EndIf

			EndIf

		Next i

	elseif lConfirma // chamada da funcao no momento da confirma็ใo de inclusao ou altera็ใo

		for i:= 1 to Len(aCols)
		/*
		//--- Soma Peso das Embalagens para descontar no peso	                    
		if oBrw:aCols[i,len(aHeader)+1] == .F. .OR. oBrw:aCols[i,5] != ""
			   
			if 	oBrw:aCols[i,5] == "PM" // Palet Madeira
				nPalet+= GETMV("MV_XPLTMAD") * 	oBrw:aCols[i,6]  // Peso Palet Madeira * Qtde Palet do produto		
			elseif 	oBrw:aCols[i,5] == "PF" // Palet Ferro	
				nPalet+=  GETMV("MV_XPLTFER") * 	oBrw:aCols[i,6]  // Peso Palet Ferro * Qtde Palet do produto
			else // Container      
				nPalet+=  GETMV("MV_XCONTAI") * 	oBrw:aCols[i,6] // Peso Container * Qtde de Container
			EndIf

		EndIf	
		*/
		Next i

		//-- Peso veํculo carregado - Peso Veํculo vazio - Peso Embagens
		//nPesoLiq := (nPesoFim - nPesoIni) - nPalet
		//oPesoLiq:Refresh()

		//--- Valida se Peso final nใo ้ menor que peso Inicial
		if nPesoFim < nPesoIni .AND. cStatus == "2"
			Alert("Peso Final nใo pode ser menor que o Peso Inicial, Verifique Pesagem !","Aten็ใo")
			Return .F.
		EndIf

		if abs(nPesoInf - nPesoLiq) > GetMv("MV_XTOLEBA") .AND. cStatus == "2"  // Parametro Tolerancia de peso
			xmaghelpfis("Aten็ใo"," A diferen็a do Peso Informado e superior a Varia็ใo Mแxima Permitida !","Solicite a Confer๊ncia do(s) Peso(s) informado(s) para o(s) Produto(s) selecionado(s) !")
			Return .F.
		Else
			Return .T.
		EndIf

	EndIf

Return .F.


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  DeletOK    บAutor  ณInnovare Solu็๕es   บ Data ณ  08/07/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Atualiza Peso total Informado se linha for excluida		  บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function DeletOKF()

	if oBrw:aCols[n,Len(aHeader)+1] == .F.
		lDelete:= .T.
	Else
		lDelete:= .F.
	EndIf

	if lDelete
		nPesoInf:=  nPesoInf - (oBrw:aCols[n,7]*1000) //Cesar J. Santos - 09/06/2023
	Else
		nPesoInf:=  nPesoInf + (oBrw:aCols[n,7]*1000) //Cesar J. Santos - 09/06/2023
	EndIf

	oPesoInf:Refresh()
Return .T.

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFAT010F   บAutor  ณInnovare Solu็๕es   บ Data ณ  08/07/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณExclui Ordem de Carregamento.                               บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Montividiu                                                 บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function FAT010F()
	Local cNumOrd:= ZC3->ZC3_ORDEM

//--- Nao permite excluir ordem de carregamento ja faturada
	if ZC3->ZC3_STATUS == "5"  // Status de Ordem de Carregamento que ja foi faturada
		Alert("Ordem de Carregamento jแ Faturada nao podem ser excluida !")
		Return .F.
	EndIf

	if MsgYesNo("Confirma Exclusใo da Ordem de Carregamento N." + cNumOrd + " ?", "Protheus "+oApp:cVersion )

		//--- Cabecalho Ordem de Carregamento
		//DbSelectArea("ZC3")
		ZC3->(DbSetOrder(1) )
		if ZC3->(DbSeek( xFilial("ZC3")+cNumOrd ))
			//--- deleta os Cabecalho da Ordem de Carregamento
			Begin Transaction
				Reclock("ZC3")
				ZC3->( dbDelete() )
				ZC3->( Msunlock() )
			End Transaction
		EndIf

		//--- Itens Ordem de Carregamento
		//	DbSelectArea("ZC4")
		ZC4->( DbSetOrder(1) )
		ZC4->( DbSeek( xFilial("ZC4") + cNumOrd ) )
		While ZC4->(!EOF()) .AND. cNumOrd == ZC4->ZC4_ORDEM
			//--- deleta os itens que foram excluidos da getdados
			Begin Transaction
				Reclock("ZC4")
				ZC4->( dbDelete() )
				ZC4->( Msunlock() )
			End Transaction
			ZC4->( DbSkip() )
		Enddo
	Else
		Return .F.
	EndIf

Return(.T.)

/*/
	ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
	ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
	ฑฑฺฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฟฑฑ
	ฑฑณFuno    ณ FAT0510 ณ Autor ณ Innovare Solu็๕es       ณ Data ณ 08.08.13 ณฑฑ
	ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤดฑฑ
	ฑฑณDescrio ณ Executa Leitura de Pesos de Entrada Balan็a Toledo         ณฑฑ
	ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
	ฑฑณ Uso      ณ Expedi็ใo - Faturamento - Unidades c/balanca               ณฑฑ
	ฑฑภฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
	ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
	฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
User Function FAT0510(nXOpc,nPesoIni,nPesoFim)
	Local cTitulo  := 'Lendo Pesagem da Balanca'
	Local cMsg     := 'Peso ... '

	Private cPeso := Space(10)

	if Type("oDlg") != "U"   // Verifica se a variavel ja existe
		Processa({||cPeso:= FAT0510A(nXOpc)}, cTitulo,cMsg)
	else
		Return .F.
	EndIf

Return(cPeso)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFAT010    บAutor  ณMicrosiga           บ Data ณ  08/09/17   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFatura Ordem de Carregamento                                บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Montividiu                                                 บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function FaturaOrdem(ZC3Ordem)
	//Local nX     		:= 0
	//Local nY     		:= 0
	Local cQuery 		:= Space(0)
	//Local cQryC9 		:= Space(0) //cQryC9 := cContrato := ""
	Local nCont 		:= 1
	Local cTransp 		:= ""
	//Local nlin	 		:= 0
	Local cProdutos 	:= ""
	Local nDespf 		:= 0
	Local vFrete		:= 0
	Local vXdesp        := 0

	Local aArea    := GetArea()
	Local aAreaSB1 := SB1->(GetArea())
	Local aAreaZC3 := ZC3->(GetArea())
	Local aAreaZC4 := ZC4->(GetArea())
	Local aAreaSC5 := SC5->(GetArea())
	Local aAreaSC6 := SC6->(GetArea())
	Local aAreaSD2 := SD2->(GetArea())
	Local aAreaSF2 := SF2->(GetArea())
	//Local cPARC1 := 0
	//Local cPARC2 := 0
	//Local cPARC3 := 0
	//Local cPARC4 := 0
	Local nPedC  := " "
	Local nItemC := " "
	//Local cNparc := 0
	Local nVlrDesc		:= 0
	Local nVlrUnit		:= 0

	Private lMsErroAuto := .F.
	Private lGeraNf 	:= .T.//SuperGetMV("MV_XAUTONF",.F.,.T.)
	Private aCabec 		:= {}
	Private aLinha 		:= {}
	Private cPedidos 	:= ""
	Private nVolume 	:= 0
	Private cEspecie 	:= Space(10)
	Private xaNotas     := {}
	Private cContrato := "" // alterado carlos

	If ZC3->ZC3_STATUS <> '3'
		MsgAlert("Ordem de Carregamento nใo estแ apta a ser faturada, somente as Ordens com status aguardando faturamento podem ser faturadas!","Aten็ใo!")
		Return .F.
	EndIf

	DbSelectArea("DA4")
	DA4->(DbSetOrder(1))
	if !DA4->(DbSeek(xFilial("DA4")+ZC3->ZC3_CODMOT))
		MsgAlert("Motorista Nใo Cadastrado , Verifique!!!","Aten็ใo!")
		Return .F.
	EndIf

	DbSelectArea("DA3")
	DA3->(DbSetOrder(3))
	if !DA3->(DbSeek(xFilial("DA3")+ZC3->ZC3_PLACA))
		MsgAlert("Placa Nใo Cadastrada , Verifique!!!","Aten็ใo!")
		Return .F.
	EndIf

	// Valida se filial e Calbras e solicita informar Volume e Especie, demais filiais carremento somente Granel.
	if cFilant == "0104"
		GetVolEsp() // Chama funcao para usuario informar quantidade de volumes e Especie da Nota Fiscal
	Else
		nVolume 	:= 1
		cEspecie    := "Granel"
	EndIf

	cQuery := " SELECT ZC4_FILIAL,ADB_ITEM,ZC4_ORDEM,ZC4_CONTRA,ZC3_CODCLI, ZC3_LOJA,ZC3_PLACA,ZC3_PESFIM,ZC3_PESLIQ,ZC3_CODMOT,ADA_CONDPG, ADA_XNATUR,ADA_VEND1,ADA_VEND2,ADA_VEND3,ADA_VEND4,ADA_VEND5, ADA_TPFRET, "
	cQuery += " ADA_COMIS1,ADA_COMIS2,ADA_COMIS3,ADA_COMIS4,ADA_COMIS5,ADB_CODPRO,ADA_XNUMBL ,ZC4_PRODUT,ADB_PRCVEN VLRUNITARIO, TRIM(ADA_XMENOT) ADA_XMENOT, ADB_TOTAL VLRTOTAL,ADB_TES, ADA_MARCA, ADA_XPED, ADA_XBANCO, "
	cQuery += " ADB_TESCOB,ZC4_CONTRA,ZC4_QTDE,ADB_VALDES,ADB_DESC,ADA_FORMPG,ZC4_MENOTA, ADA_XFRETE, ADA_XDESP, ADA_XDESPU, ADA_XPARC1, ADA_XPARC2, ADA_XPARC3, ADA_XPARC4, ADA_XDATA1, ADA_XDATA2, ADA_XDATA3, ADA_E_PED, ADA_XDATA4 FROM "+RetSQLName("ZC4")+" Z4 "
	cQuery += " INNER JOIN "+RetSQLName("ZC3")+" Z3 ON ZC4_ORDEM = ZC3_ORDEM "
	cQuery += " INNER JOIN "+RetSQLName("ADA")+" ADA ON ZC4_CONTRA = ADA_NUMCTR "
	cQuery += " LEFT  JOIN "+RetSQLName("ADB")+" ADB ON ADA.ADA_NUMCTR = ADB.ADB_NUMCTR "
	cQuery += " WHERE "
	cQuery += " Z3.D_E_L_E_T_ <> '*' "
	cQuery += " AND Z4.D_E_L_E_T_ <> '*' "
	cQuery += " AND ADA.D_E_L_E_T_ <> '*' "
	cQuery += " AND ADB.D_E_L_E_T_ <> '*' "
	cQuery += " AND Z4.ZC4_FILIAL = Z3.ZC3_FILIAL "
	cQuery += " AND Z4.ZC4_FILIAL = ADA.ADA_FILIAL "
	cQuery += " AND ADA.ADA_FILIAL = ADB.ADB_FILIAL "
	cQuery += " AND ADB.ADB_CODPRO = Z4.ZC4_PRODUT "
	cQuery += " AND ZC4_FILIAL = '"+ XFILIAL("ZC4") + "'"
	cQuery += " AND ZC4_ORDEM  = '"+ZC3->ZC3_ORDEM+"' "
	cQuery += " AND ADB.ADB_CODPRO = Z4.ZC4_PRODUT "
	cQuery += " ORDER BY Z4.ZC4_CONTRA,ADB.ADB_ITEM "

	If Select("QZC4") > 1
		QZC4->(DBCloseArea())
	EndIf

	TcQuery cQuery New Alias "QZC4"

	QZC4->(DbGotop())
	cContrato  := QZC4->ZC4_CONTRA
	lGrApenas1 := .T.

	While QZC4->(!EOF())
		If cContrato == QZC4->ZC4_CONTRA
			If nCont == 1

				cTransp   := ZC3->ZC3_TRANSP //POSICIONE("DA4",1, XFILIAL("DA4")+QZC4->ZC3_CODMOT,"DA4_XTRANS")//PRECISA ESTAR COM TRANSPORTADORA VINCULADA AO CADASTRO MOTORISTA
				cCondPag  := ALLTRIM(Posicione("SE4",1, XFILIAL("SE4")+QZC4->ADA_CONDPG,"E4_CODIGO"))
				cCodPlaca := Posicione("DA3",3,XFILIAL("DA3")+QZC4->ZC3_PLACA,"DA3_COD")
				nDespf 	  := (QZC4->ZC4_QTDE*QZC4->ADA_XDESPU)
				vFrete 	  := QZC4->ADA_XFRETE //VER FRETE REMOVER SE FOR ERRADO
				vXdesp    := QZC4->ADA_XDESP
				//add Carlos Daniel desconsidera 022 quando nao gerar financeiro
				SF4->( dbSetOrder(1))
				If SF4->( dbSeek(xFilial("SF4") + QZC4->ADB_TES ))
					If SF4->F4_DUPLIC == 'N' .and. cCondPag == '022'
						cCondPag := Iif(cCondPag == '022','001' ,cCondPag )

					ElseIf SF4->F4_DUPLIC == 'S' .and. cCondPag == '022'
						MsgInfo("Problema na gera็ใo das Parcelas para tipo de Condi็ใo Pagamento: " + cCondPag +  " Favor Gerar Manualmente ou Entrar contato com TI")
					EndIf
				EndIf

				AADD(aCabec,{"C5_FILIAL" 	,QZC4->ZC4_FILIAL	,Nil})
				AADD(aCabec,{"C5_TIPO" 		,"N"				,Nil})
				AADD(aCabec,{"C5_CLIENTE"	,QZC4->ZC3_CODCLI	,Nil})
				AADD(aCabec,{"C5_LOJACLI"	,QZC4->ZC3_LOJA		,Nil})
				AADD(aCabec,{"C5_TRANSP"	,cTransp			,Nil})
				AADD(aCabec,{"C5_CONDPAG"	,cCondPag			,Nil})
				AADD(aCabec,{"C5_NATUREZ"	,QZC4->ADA_XNATUR	,Nil})
				AADD(aCabec,{"C5_VEND1"		,QZC4->ADA_VEND1	,Nil})
				AADD(aCabec,{"C5_COMIS1"	,QZC4->ADA_COMIS1	,Nil})
				AADD(aCabec,{"C5_TPFRETE"	,if(!Empty(QZC4->ADA_TPFRET),QZC4->ADA_TPFRET,'F'),Nil})
				AADD(aCabec,{"C5_CONTRA"	,QZC4->ZC4_CONTRA	,Nil})
				AADD(aCabec,{"C5_XPLACA"	,QZC4->ZC3_PLACA	,Nil})
				AADD(aCabec,{"C5_VOLUME1"	,nVolume			,Nil})
				AADD(aCabec,{"C5_ESPECI1"	,cEspecie			,Nil})
				AADD(aCabec,{"C5_MENNOTA"	,QZC4->ZC4_MENOTA	,Nil})
				AADD(aCabec,{"C5_XDESPU"	,QZC4->ADA_XDESPU	,Nil})  //DESPESA TRANSPORTE UNITARIA
				AADD(aCabec,{"C5_XPED"		,QZC4->ADA_XPED		,Nil})  //NUMERO DO PEDIDO BLOCO
				AADD(aCabec,{"C5_XBANCO"	,QZC4->ADA_XBANCO	,Nil})  //FORMA DE PAGAMENTO
				AADD(aCabec,{"C5_XMARCA"	,QZC4->ADA_MARCA	,Nil})  //MARCA DO produto
				AADD(aCabec,{"C5_PESOL"  	,QZC4->ZC3_PESLIQ	,Nil})
				AADD(aCabec,{"C5_PBRUTO" 	,QZC4->ZC3_PESFIM	,Nil})  //QZC4->ZC3_PESFIM Peso Bruto nใo deve conter a Tara Clแudio 30.07.19
				AADD(aCabec,{"C5_TPCARGA"	,"2"				,Nil})
				AADD(aCabec,{"C5_XFORPG" 	,QZC4->ADA_FORMPG	,Nil})
				AADD(aCabec,{"C5_FRETAUT" 	,ZC3->ZC3_FRETAU	,Nil})
				AADD(aCabec,{"C5_FRETE" 	,ZC3->ZC3_VLRFRE	,Nil})
				AADD(aCabec,{"C5_XDESP" 	,ZC3->ZC3_DESPTR	,Nil}) // VERIFICAR AQUI DESPESA E NAO AUTONO
				AADD(aCabec,{"C5_XLOTE" 	,ZC3->ZC3_XLOTE 	,Nil})

			EndIf
			If QZC4->ADA_E_PED <> ' '
				nPedC  := QZC4->ADA_E_PED
				nItemC := "0001"
			Else
				nPedC  := " "
				nItemC := " "
			EndIf

			dbSelectArea("ADA")
			ADA->(dbSetOrder(1))
			ADA->(dbSeek(xFilial("ADB")+QZC4->ZC4_CONTRA))

			//inicio desconto calcula
			dbSelectArea("ADB")
			ADB->(dbSetOrder(1))
			ADB->(!dbSeek(xFilial("ADB")+QZC4->ZC4_CONTRA + QZC4->ADB_ITEM))

			nVlrDesc	:= ((QZC4->VLRTOTAL + QZC4->ADB_VALDES) * (QZC4->ADB_DESC /100)) / 100
			nVlrUnit	:= Round(QZC4->VLRUNITARIO + nVlrDesc,TamSx3("C6_PRCVEN")[2])

			AADD(aLinha,{	{"C6_FILIAL"	,QZC4->ZC4_FILIAL		,Nil},;
				{"C6_ITEM"		,StrZero(nCont,2)		,Nil},;
				{"C6_PRODUTO"	,QZC4->ADB_CODPRO		,Nil},;
				{"C6_QTDVEN"	,QZC4->ZC4_QTDE			,Nil},;
				{"C6_PRCVEN"	,nVlrUnit				,Nil},;
				{"C6_TES"		,QZC4->ADB_TES			,Nil},;
				{"C6_CONTRAT"	,QZC4->ZC4_CONTRA		,Nil},;
				{"C6_ITEMCON"	,QZC4->ADB_ITEM			,Nil},;
				{"C6_NUMPCOM"	,nPedC					,Nil},;
				{"C6_DESCONT"	,QZC4->ADB_DESC			,Nil},;
				{"C6_ITEMPC"	,nItemC	    			,Nil}})

			cProdutos += IIf(Empty(cProdutos), "'" + QZC4->ADB_CODPRO + "'", "," + "'" + QZC4->ADB_CODPRO + "'")
			cContrato := QZC4->ZC4_CONTRA
			cNumPCom  := QZC4->ADA_XNUMBL

			QZC4->(DBSkip())
			nCont++

		Else
			cContrato := QZC4->ZC4_CONTRA
			cNumPCom  := QZC4->ADA_XNUMBL

			MsgRun("Aguarde... Gerando Pedido de Venda!!!","",{|| CursorWait(), GeraPedido(ZC3->ZC3_ORDEM,cCodPlaca,cNumPCom), CursorArrow()})

			aCabec := {}
			aLinha := {}
			nCont:= 1

			Loop
		EndIf
	EndDo

	if Len(aCabec) > 0
		ZC4->(DbSetOrder(2))
		If ZC4->(DbSeek(XFILIAL("ZC4")+ZC3->ZC3_ORDEM+cContrato))
			If Empty(ZC4->ZC4_PEDIDO)
				MsgRun("Aguarde... Gerando Pedido de Venda!!!","",{|| CursorWait(), GeraPedido(ZC3->ZC3_ORDEM,cCodPlaca,cNumPCom), CursorArrow()})

			Else
				MsgInfo("Ordem de Carregamento jแ possui o pedido de venda Nบ " + ZC4->ZC4_PEDIDO +  " emitido, para visualizar acesse a rotina de Pedido de Venda ! ")
				Return .F.
			EndIf
		EndIf
	Else
		MsgInfo("Nใo Existe Itens no Contrato , Verifique!!!")
		Return .F.
	EndIf

	QZC4->(DBCloseArea())


	RestArea(aAreaSB1)
	RestArea(aAreaZC3)
	RestArea(aAreaZC4)
	RestArea(aAreaSC5)
	RestArea(aAreaSC6)
	RestArea(aAreaSD2)
	RestArea(aAreaSF2)
	RestArea(aArea)
	ADB->(dbCloseArea())
	ADA->(dbCloseArea())

Return()

/*/{Protheus.doc} FAT010 
Gera Pedido de Venda a partir de uma Ordem de Carregamento
@author  
@type function
@since 01/2025 
/*/
Static Function GeraPedido(cOrdem,cCodPlaca,cNumPCom)

	Local cCodPed 		:= ""
	Local cPedTriang 	:= ""

	Local i				:= 0
	Local lAvalEst 		:= SuperGetMV("MV_XAVSTQ",.F.,.T.)

	//ฆ+---------------------------------------------------------+ฆ
	//ฆฆSE FOR BRITACAL + OPERAวรO 09 OU 10 (Operacao Triangular)
	//ฆ+---------------------------------------------------------+ฆ
	If cEmpAnt == "50" .And. ADB->ADB_XTIPO $ "09/10"
		If ExistBlock("MFAT200")
			If !U_MFAT200(@cPedTriang)
				Return(.T.)
			EndIf
		EndIf
	EndIf

	lMsErroAuto := .F.

	MSExecAuto({|x,y,z|Mata410(x,y,z)},aCabec,aLinha,3)

	If lMsErroAuto

		If !Empty(cPedTriang)
			DbSelectArea("SC5")
			SC5->(DbSetOrder(1))
			SC5->(DbSeek(FwXfilial("SC5")+cPedTriang))

			eventoNFE("Excluir")
		EndIf

		MsgAlert("Erro na inclusao!")
		MostraErro()
		lGeraNf 	:= .F. //Nao gera nota fiscal automaticamente
		Return(.T.)
	Else

		cCodPed := SC5->C5_NUM

		If !Empty(cPedTriang)
			ajusteSC6(cCodPed,cPedTriang)
		EndIf

	EndIf

	//Opera็ใo triangular para atender Ercal - Cesar J. Santos 29/06/2023..;
		If ExistBlock("FT400LIB")
		U_FT400LIB()
	EndIf

	cPedidos += IIf(Empty(cPedidos),"'"+cCodPed+"'",","+"'"+cCodPed+"'")

	//Claudio 13.12.16
	//Posiciona Ordem
	ZC3->( DbSetOrder(1) )
	ZC3->( DbSeek(XFILIAL("ZC3")+ cOrdem) )

	//Posiciona Transp
	SA4->( DbSetOrder(1) )
	SA4->( DbSeek(xFilial("SA4")+ ZC3->ZC3_TRANSP))
	SC5->( DbSetOrder(1) )
	if SC5->( DbSeek(xFilial("SC5")+ cCodPed) )

		Reclock("SC5",.F.)
		SC5->C5_VEICULO := cCodPlaca 			//Insere cod veiculo para sair na Danfe
		SC5->C5_TRANSP  := ZC3->ZC3_TRANSP
		SC5->C5_MENNOTA := IIF(!Empty(ZC4->ZC4_MENOTA), Alltrim(SC5->C5_MENNOTA) + " | " + Alltrim(ZC4->ZC4_MENOTA), Alltrim(SC5->C5_MENNOTA))
		SC5->C5_FRETAUT := ZC3->ZC3_FRETAU

		SC5->( MsUnlock() )
	EndIf

	DbSelectarea("SC5")
	SC5->( DBSetOrder(1) )
	If SC5->( MsSeek( xFilial("SC5") + cCodPed) )
		DbSelectarea("SC6")
		SC6->( DBSetOrder(1) )
		If SC6->( MsSeek( xFilial("SC6") + cCodPed ) )
			While !SC6->( EOF() ) .and. SC6->C6_NUM == cCodPed

				RecLock("SC6",.F.) //Forca a atualizacao do Buffer no Top
				Begin Transaction
					SC6->( MaLibDoFat(SC6->(RecNo()),SC6->C6_QTDVEN,.T.,lAvalEst /*ESTOQUE*/,.T.,.T.,.F.,.T.) ) //BLOQUEIO ESTOQUE NEGATIVO 2บ T
				End Transaction

				SC6->( MsUnLock() )

				Begin Transaction
					SC6->(MaLiberOk({cCodPed},.T.))
				End Transaction

				SC6->( dbSkip() )
			Enddo
		EndIf
	EndIf

	SC6->( dbCloseArea() )
	SC5->( MaLiberOk({ cCodPed },.T.) ) //Confirmar pedido como Aprovado se nao houver restricao por credito ou estoque
	SC5->( DBCloseArea() )
	SC9->( DBCloseArea() )

	SC5->( DbSeek(xFilial("SC5")+ cCodPed) )

	DbSelectarea("SC6")
	SC6->( DBSetOrder(1) )
	SC6->( MsSeek( xFilial("SC6") + cCodPed ) )

	cQryC9:= " SELECT C9_FILIAL, C9_PEDIDO, C9_PRODUTO, C9_CLIENTE, C9_LOJA, C9_BLEST, C9_BLCRED "
	cQryC9+= " FROM "+RetSQLName("SC9")+" "
	cQryC9+= " WHERE "
	cQryC9+= " D_E_L_E_T_ = ' ' "
	cQryC9+= " AND C9_FILIAL = '"+xFilial("SC9")+"' "
	cQryC9+= " AND C9_PEDIDO = '"+cCodPed+"'
	cQryC9+= " AND C9_BLEST  <> ' '"
	cQryC9+= " ORDER BY C9_PRODUTO "

	if Select("QSC9") > 1
		QSC9->( DbCloseArea() )
	EndIf

	TcQuery cQryC9 New Alias "QSC9"
	Count To nLinhas

	if nLinhas > 0
		xmaghelpfis("Aten็ใo","O pedido "+cCodPed+" do contrato de parceria "+QZC4->ZC4_CONTRA+" estแ com restri็๕es de estoque, a Nota Fiscal desta ordem de carregamento nใo serแ gerado automaticamente","Procure o setor responsavel pela libera็ใo do pedido!")
		lGeraNf := .F. //Nao gera nota fiscal automaticamente
	EndIf

	QSC9->( DBCloseArea() )

	ZC3->( DbSetOrder(1) )
	if ZC3->( DbSeek(XFILIAL("ZC3")+ cOrdem) )
		Reclock("ZC3")
		ZC3->ZC3_PEDIDO := cCodPed
		ZC3->( MsUnLock() )
	EndIf

	DBSelectArea("ZC4")
	ZC4->(DBSetOrder(2)) //ZC4_FILIAL+ZC4_ORDEM+ZC4_CONTRA+ZC4_PRODUT
	ZC4->(DBGoTop())

	//Gravar Codigo do pedido de venda na nos da ordem de carregamento
	For i := 1 To Len(aLinha)

		nPosPrd 	:= aScan(aLinha[i], { | x | x[1] == "C6_PRODUTO" })
		nPosCtr 	:= aScan(aLinha[i], { | x | x[1] == "C6_CONTRAT" })

		aLinha[i][nPosCtr][2] := AvKey(aLinha[i][nPosCtr][2],"C6_CONTRAT")
		aLinha[i][nPosPrd][2] := AvKey(aLinha[i][nPosPrd][2],"C6_PRODUTO")

		if ZC4->( DBSeek( xFilial("ZC4") + cOrdem + aLinha[i][nPosCtr][2] + aLinha[i][nPosPrd][2]) )
			if Reclock("ZC4")
				ZC4->ZC4_PEDIDO := cCodPed //GRAVA NUMERO PEDIDO APOS CRIAR
				ZC4->( MsUnlock() )
			EndIf
		EndIf
	Next i

	// ZC4->( DBCloseArea() )

	MsgAlert("Remessa do Contrato Gerado com Sucesso! "+SC5->C5_NUM)

	//Fatura Nota Fiscal
	If lGeraNF
		MsgRun("Aguarde... Faturando Pedido de Venda!!!","",{|| CursorWait(),	U_NFeAutoFAT(cCodPed,cOrdem)  , CursorArrow()})	 	 //U_NFeAutoFAT(cPedidos,ZC3->ZC3_ORDEM)  , CursorArrow()})
	EndIf

Return .T.


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGetVolEsp บAutor  ณMicrosiga           บ Data ณ  02/18/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Tela para usuario informar Qtde Volume e Especie que sera  บฑฑ
ฑฑบ          ณ levado para Nota fiscal                                    บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function GetVolEsp()

	SetPrvt("oFont,oDlg3,oVolume,cEspecie")

	#define DS_MODALFRAME   128

	//Cria Tela pra Informar Volume e Especie
	DEFINE MSDIALOG oDlg3 TITLE "Volume/Especie" FROM 000, 000  TO 200, 240 COLORS 0, 16777215 PIXEL Style DS_MODALFRAME // Cria dialog sem o X
	//@ 027, 013 SAY oSay4 PROMPT "Cod.Cliente" SIZE 030, 007 OF oDlgTela COLORS 0, 16777215 PIXEL
	//@ 010,005   Say "Volume(s):" FONT oFont OF oDlg3 PIXEL SIZE 340,15
	@ 010,005   Say "Volume(s):" OF oDlg3 PIXEL SIZE 340,15
	@ 010,040   MSGet oVolume VAR nVolume  Size 50,10  PicTure "@E 999,999,999.99" Of oDlg3 Pixel

	@035,005   Say "Especie:" OF oDlg3 PIXEL SIZE 340,15
	@035,040   MSGet oEspecie VAR cEspecie Size 50,10  Of oDlg3 Pixel

	@070, 045 BUTTON OemToAnsi('OK') SIZE 30,15 when .t. ACTION oDlg3:End() OF oDlg3 PIXEL

	ACTIVATE MSDIALOG oDlg3 CENTERED

	//oDlg3:lEscClose     := .F. 	//Nao permite sair ao se pressionar a tecla ESC.
Return()


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFAT010    บAutor  ณMicrosiga           บ Data ณ  08/09/17   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFatura Nota Fiscal                                          บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Montevidiu												  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function NFeAutoFAT(zcPedidos,zcOrdem)
	Local _aArea := GetArea()
	Processa({|lend| NFFATNFE(zcPedidos,zcOrdem)},"Faturamento Automแtico")
	RestArea(_aArea)
Return()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFATNFE    บAutor  ณMicrosiga           บ Data ณ  08/16/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Realiza Faturamento Automatico a partir de um pedido       บฑฑ
ฑฑบ          ณ Liberado                                                   บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function NFFATNFE(cPedidos,cOrdem)
	Local aPvlNfs := {}
	//Local cQuery  := ""
	//Local aDados  := {}
	Local cSerie  := GetMV("MV_SERIE")

	/*
	cQuery:= " SELECT C9_PEDIDO,C9_ITEM,C9_SEQUEN,C9_QTDLIB,C9_PRCVEN,C9_PRODUTO FROM " + RETSQLNAME("SC9")"
	cQuery+= " WHERE D_E_L_E_T_<>'*' " 
	cQuery+= " AND C9_FILIAL =  '" + xFILIAL("SC9") + "'"
	cQuery+= " AND C9_PEDIDO IN (" + cPedidos + ")"

	IF SELECT("QSC9") > 1
		QSC9->(dbclosearea())
	EndIf	       
			
	TcQuery cQuery New Alias "QSC9"	   

	QSC9->(DbGotop())
	// Salva dados que vao ser usados na rotina faturamento automatico
	While QSC9->(!EOF())
			AADD(aDados,{ QSC9->C9_PEDIDO,;
						QSC9->C9_ITEM,;
						QSC9->C9_SEQUEN,;
						QSC9->C9_QTDLIB,;
						QSC9->C9_PRCVEN,;
						QSC9->C9_PRODUTO})
		QSC9->(DbSkip())	
	Enddo                                                                
	
		For i:= 1 to len(aDados)
					
					IncProc("Processando Faturamento Automแtico...")
					
									
					SC5->(dbSetOrder(1))				 
					SC5->(dbSeek(xFilial("SC5")+ aDados[i,1]))    // Filial + Pedido
								
					SC6->( dbSetOrder(1))				 
					SC6->(MsSeek(xFilial("SC6") + aDados[i,1] + aDados[i,2] + aDados[i,6]))
										
					SC9->( dbSetOrder(1)) 							 
					SC9->( dbSeek(xFilial("SC9") + aDados[i,1] + aDados[i,2] + aDados[i,3] + aDados[i,6])) // Filial + Pedido + Item + sequencia + produto
						
					SE4->( dbSetOrder(1))					 
					SE4->( dbSeek(xFilial("SE4")+SC5->C5_CONDPAG))
						
					SB1->( dbSetOrder(1))					 
					SB1->( dbSeek(xFilial("SB1")+aDados[i,6] ))
					
					SB2->( dbSetOrder(1))					 
					SB2->( dbSeek(xFilial("SB2")+aDados[i,6] ))
						
					SF4->( dbSetOrder(1))					 
					SF4->( dbSeek(xFilial("SF4")+SC6->C6_TES ))
						
					
					aAdd(aPvlNfs,{aDados[i,1],; // C9_Pedido
								aDados[i,2],; // C9_Item
								aDados[i,3],; // C9_SEQUEN
								aDados[i,4],; // C9_QTLIB
								aDados[i,5],; // C9_C9_PRCVEN
								aDados[i,6],; // C9_PRODUTO
								.F.,;		 
								SC9->(RecNo()),;
								SC5->(RecNo()),;
								SC6->(RecNo()),;
								SE4->(RecNo()),;
								SB1->(RecNo()),;
								SB2->(RecNo()),;
								SF4->(RecNo()) })                      				
		Next i			                              

	*/

	cFilPed  := xFilial("SC5")
	cNumPed  := STRTRAN(cPedidos,"'","")

	DbSelectArea("SC5")
	SC5->( DbSetOrder(1) )
	if SC5->(dbSeek(xFilial("SC5")+cNumPed))

		//chama evento de liberacao de regras com o SC5 posicionado
		Begin Transaction
			MaAvalSC5("SC5",9)
		End Transaction

		MaLiberOk({ SC5->C5_NUM },.T.)

		DbSelectArea("SC6")
		SC6->(DbSetOrder(1))
		If SC6->(DbSeek(SC5->(C5_FILIAL+C5_NUM)))
			While !SC6->(Eof()) .AND. SC6->C6_NUM == SC5->C5_NUM .AND. SC5->C5_FILIAL == SC6->C6_FILIAL

				DbSelectArea("SC9")
				SC9->(DbSetOrder(1))
				SC9->(DbGotop())
				If !SC9->(DbSeek(SC6->(C6_FILIAL+C6_NUM+C6_ITEM)))  	//Array para geracao da NF (SC6,SE4,SB1,SB2,SF4) devem estar posicionados

					MaLibDoFat(SC6->(RecNo()),SC6->C6_QTDVEN,.T.,.T.)	     //Libera os itens do pedido para faturar

					DbSelectArea("SC9")
					SC9->(DbSetOrder(1))
					SC9->(DbGotop())
					If !SC9->(DbSeek(SC6->(C6_FILIAL+C6_NUM+C6_ITEM)))

						DisarmTransaction()
						Return(.F.)

					EndIf
				EndIf
				SC6->(DbSkip())
			EndDo
		EndIf

		SC9->(DbSetOrder(1))
		SC9->(DbGotop())
		SC9->(DbSeek(cFilPed+cNumPed))
		While !Eof() .And. SC9->C9_PEDIDO == cNumPed .And. SC9->C9_FILIAL == cFilPed

			DbSelectArea("SC6")
			DbSetOrder(1)
			DbSeek(xFilial("SC6") + SC9->C9_PEDIDO + SC9->C9_ITEM)

			DbSelectArea("SB1")
			DbSetOrder(1)
			DbSeek(xFilial("SB1") + SC9->C9_PRODUTO)

			DbSelectArea("SF4")
			DbSetOrder(1)
			DbSeek(xFilial("SF4") + SC6->C6_TES)

			DbSelectArea("SB2")
			DbSetOrder(1)
			DbSeek(xFilial("SB2") + SC9->C9_PRODUTO)

			DbSelectArea("SC9")
			aAdd(aPvlNfs, {SC9->C9_PEDIDO,;
				SC9->C9_ITEM,;
				SC9->C9_SEQUEN,;
				SC9->C9_QTDLIB,;
				SC9->C9_PRCVEN,;
				SC9->C9_PRODUTO,;
				.F., SC9->(RecNo()), ;
				SC5->(RecNo()), SC6->(RecNo()), SE4->(RecNo()), SB1->(RecNo()), ;
				SB2->(RecNo()), SF4->(RecNo())})

			SC9->(DbSkip())
		Enddo

		If Len(aPvlNfs) <> 0

		/*ฑฑณParametrosณExpA1: Array com os itens a serem gerados                 ณฑฑ 
		ฑฑณ            ณExpC2: Serie da Nota Fiscal                                 ณฑฑ 
		ฑฑณ            ณExpL3: Mostra Lct.Contabil                                  ณฑฑ 
		ฑฑณ            ณExpL4: Aglutina Lct.Contabil                                ณฑฑ 
		ฑฑณ            ณExpL5: Contabiliza On-Line                                  ณฑฑ 
		ฑฑณ            ณExpL6: Contabiliza Custo On-Line                            ณฑฑ 
		ฑฑณ            ณExpL7: Reajuste de preco na nota fiscal                     ณฑฑ 
		ฑฑณ            ณExpN8: Tipo de Acrescimo Financeiro                         ณฑฑ 
		ฑฑณ            ณExpN9: Tipo de Arredondamento                               ณฑฑ 
		ฑฑณ            ณExpLA: Atualiza Amarracao Cliente x Produto                 ณฑฑ 
		ฑฑณ            ณExplB: Cupom Fiscal                                         ณฑฑ 
		ฑฑณ            ณExpCC: Numero do Embarque de Exportacao                     ณฑฑ 
		ฑฑณ            ณExpBD: Code block para complemento de atualizacao dos titu- ณฑฑ 
		ฑฑณ            ณ       los financeiros.                                     ณฑฑ 
		ฑฑณ            ณExpBE: Code block para complemento de atualizacao dos dados ณฑฑ 
		ฑฑณ          ณ       apos a geracao da nota fiscal.                         ณฑฑ 
		ฑฑณ          ณ  ExpBF: Code Block de atualizacao do pedido de venda antes   ณฑฑ 
		ฑฑณ                  da geracao da nota fiscal                            ณฑฑ */ 
		
	Pergunte("MT460A",.F.)
	MV_PAR17:=1 //Gera Titulo ? 
	MV_PAR24:=1 //Gera Guia ICM Compl. UF Dest ? 
	//   cNota   := MaPvlNfs(aPvlNfs,cserie , .F. , .T. , .T. , .T.    , .F.    , 0  , 0 , .F.  ,.F.) 
	  cNota	  := MaPvlNfs(aPvlNfs,cserie , .F. , .F. , .F. , .F.    , .F.    , 0  ,0,.F.,.F.)  
	   //cNota:= MaPvlNfs(aPvlNfs,cSerie,.F.,.F.,.F.,.T.,.F.,0,0,.F.,.F.)			//Gera Nota Fiscal - Fatura Pedido
   	
   	aPvlNfs := {}
 	
 	if !Empty(cNota)  	

			// Atualiza Status se nota foi emitida 
		If !FwIsInCallStack("U_MFAT200")      
			ZC3->(DbSetOrder(1)) 
			if ZC3->(DbSeek(XFILIAL("ZC3")+cOrdem))
				Reclock("ZC3",.F.)  
					ZC3->ZC3_STATUS := "5"
				ZC3->(MsUnlock()) 	      
			EndIf 		
		EndIf
    Else
		MsgAlert("Erro Nota Fiscal Nใo Faturada")    
    EndIf
EndIf

Else
	MsgAlert("Pedido Nใo Encontrado")             
EndIf
// Comita todas as operacoes pendentes
DBCOMMITALL()  
                        
//Transmite Automatico
//Emite DANFE AUTOMATICO

Return()


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFAT010    บAutor  ณGontijo Consultoria บ Data ณ  12/13/17   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Exclui Ordem de Carregamento                               บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Montividiu                                                 บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function ExcOrdem(cNumOrdem)

	DbSelectArea("ZC3")
	ZC3->(DbGoTop())
	ZC3->(DbSetOrder(1))
	if ZC3->(DbSeek(xFilial("ZC3")+cNumOrdem))
		IF U_FAT010F()
			MsgAlert("Ordem de Carregamento Numero "+cNumOrdem+" Excluido com Sucesso!!! ")
			LimpaTela()
		EndIf
	EndIf


Return()


Static Function LimpaTela()
	cxOrdem      := Space(10)
	dxData		 := Space(10)
	cxHora       := Space(10)
	cxCliente 	 := Space(50)
	cxMotorista  := Space(30)
	cxNomCli     := Space(30)
	cxPedido     := Space(10)
	cxNomTrans   := Space(30)
	cxNomeMot	 := Space(30)
	cxLojaCli    := Space(2)
	cxPlaca 	 := Space(10)
	cxTranspor 	 := Space(30)
	cxVeiculo    := Space(30)
	nxPesoIni 	 := 0
	nxPesoFim 	 := 0
	nxPesoLiq 	 := 0
	cMensagem 	 := "Status: Aguardando Selecionar o Contrato"
	nxVlFrete    := 0
	nxVlFreau    := 0
	nxVlDesp     := 0
	cxNota   	 := Space(9)
	cxNotaTrian	 := Space(9)
	cxSerie   	 := Space(9)
	nxPesoInf	 := 0
	nxPesoCtr	 := 0
	nxDescont    := 0

	oOrdem:Refresh()
	oData:Refresh()
	oHora:Refresh()
	oxCliente:Refresh()
	oxLojaCli:Refresh()
	oxNomCli:Refresh()
	oxPlaca:Refresh()
	oxMotorista:Refresh()
	oxNomMot:Refresh()
	oxTranspor:Refresh()
	oxNomTrans:Refresh()
	oxVlFrete:Refresh()
	oxVlFreau:Refresh()
	//oxVlDesp:Refresh()
	oxDescont:Refresh()
	oxPesoIni:Refresh()
	oxPesoFim:Refresh()
	oxPesoLiq:Refresh()
	oMensagem:Refresh()
	oxPesoInf:Refresh()
	oxPesoCtr:Refresh()
	OxPesoIni:Refresh()
	OxPesoFim:Refresh()
	OxPesoLiq:Refresh()
	OxDescont:Refresh()
	oDlgTela:Refresh() //Ajustar Aqui Adriano Reis Alterar Tela quando Incluir um novo .
Return()
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFAT010    บAutor  ณMicrosiga           บ Data ณ  01/03/18   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณInclui Cadastros                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Montividiu                                                 บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function IncCad()
	Private oButton1
	Private oButton2
	Private oButton3
	Private oButton4
	Private oGroup1
	Private oDlgCadR

	DEFINE MSDIALOG oDlgCadR TITLE "Cadastro" FROM 000, 000  TO 350, 550 COLORS 0, 16777215 PIXEL

	@ 157, 233 BUTTON oButton4 PROMPT "Fechar" SIZE 037, 012 OF oDlgCadR PIXEL Action (oDlgCadR:End())

	@ 004, 003 GROUP oGroup1 TO 151, 271 PROMPT "Cadastros Rapidos " OF oDlgCadR COLOR 0, 16777215 PIXEL
	@ 012, 030 BUTTON oButton1 PROMPT "Cadastrar Veiculos" SIZE 107, 035 OF oDlgCadR PIXEL 			Action(OMSA060())
	@ 056, 030 BUTTON oButton2 PROMPT "Cadastrar Motorista" SIZE 107, 035 OF oDlgCadR PIXEL			Action(OMSA040())
	@ 104, 030 BUTTON oButton3 PROMPT "Cadastrar Transportadora" SIZE 107, 035 OF oDlgCadR PIXEL	Action(MATA050())

	ACTIVATE MSDIALOG oDlgCadR CENTERED

Return()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFAT010    บAutor  ณMicrosiga           บ Data ณ  11/02/17   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Manuten็ใo de Ordem de Carregamento                        บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Montividiu                                                 บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function MANCTR(nXOpc,nZOPC)//1  - manuten็ใo 2 - gatilho manuten็ใo
	//Local aButtons := {}

	Private nPesoIni  := 0
	Private nPesoFim  := 0
	Private _Query	  := ""
	Private cData	  := Date() // Data da Ordem
	Private cHora	  := Time() // Hora da Pesagem Incial
	Private cNrOrdem  := iif(nXOpc == 1,GETSX8NUM("ZC3","ZC3_ORDEM"),"")
	Private nPesoLiq  := 0
	Private nPesoInf  := 0
	Private nPesoDist := 0
	Private aContr	  := {}
	Private aHeader   := {}
	Private aCols	  := {}
	Private cPlaca    := Space(7)
	Private cMotora   := Space(6)
	Private cNome     := ""
	Private cCliente  := Space(06)
	Private cRazao    := ""
	Private cLoja     := Space(2)
	Private cContra
	Private oPesoInf
	Private oPesoDist
	Private oLoja
	Private oNome
	Private oRazao
	Private oCliente
	Private oMotora
	Private oPlaca
	Private oBrw
	Private oDlgman
	Private oData
	Private oHora
	Private oNrOrdem
	Private oPesoIni
	Private oPesoFim
	Private cStatus
	Private nLnAjt   := 0
	Private cTransp  := Space(11)
	Private oTransp
	Private oObs
	Private cObs  := Space(250)
	Private oDesp
	Private nDesp  := 0
	Private oVlrFau
	Private nVlrFau  := 0
	Private oVlrFre
	Private nVlrFre  := 0
	Private cArq
	Private cArq1
	Private lInverte := .F.
	Private cMark    := GetMark()
	Private oMark
	Private cMarkP   := GetMark()
	Private oMarkP
	Private nDescon  := nxDescont
	Private oDescon
	Private cLote := ZC3->ZC3_XLOTE
	Private oLote
//ABRE ADA PEGAR DADOS
//dbSelectArea("ADA")
//dbSetOrder(1)
//MsSeek(xFilial("ADA") + acols[1][2])

//cObs  := ADA->ADA_XMENOT //carlos Daniel

	if nXopc == 2 //Altera็ใo
		cStatus:= Posicione("ZC3",1,xFilial("ZC3") + ZC3->ZC3_ORDEM,"ZC3_STATUS")
		if cStatus > "2"
			Alert("Este Carregamento nใo pode ser Alterado !","Aten็ใo")
			Return .F.
		EndIf
	Elseif nXopc == 4 //Manut. Ordem de Carregamento

		if ZC3->ZC3_STATUS > "3"
			Alert("Este Carregamento jแ Foi Faturado , Verifique!!","Aten็ใo")
			Return .F.
		EndIf

	EndIf

	nxPesoLiq := (nxPesoLiq)

	IF nzOPC = 2
		nPesoDist := 0//(nxPesoLiq - nxDescont)
	Else
		nPesoDist := 0//(nxPesoLiq - nxPesoInf )
	EndIf

	cCliente := ZC3->ZC3_CODCLI
	cLoja	 := ZC3->ZC3_LOJA

	// Cria tela para Inclusใo de Ordem de Carregamento
	DEFINE MSDIALOG oDlgman FROM 002,003 TO 500 /*555*/,1100 TITLE 'Manuten็ใo Ordem de Carregamento' Pixel //Style DS_MODALFRAME

	Define Font oFont Name 'Courier New'  Size 0, -12
	Define Font oFont1 Name 'Courier New' Size 0, -20

	nLnAjt := 5

	@ 02+nLnAjt,007 TO 120+nLnAjt,360 LABEL 'Ordem de Carregamento' OF oDlgman PIXEL

	@ 07+nLnAjt,220 TO 040+nLnAjt,345 LABEL 'Peso Total Inf / Kg - CONTRATO' OF oDlgman PIXEL
	@ 20+nLnAjt,250 SAY oPesoInf PROMPT nPesoInf SIZE 100, 15 Picture "@E 99,999,999.99" OF oDlgman PIXEL Font oFont1 Color CLR_HRED

	@ 07+nLnAjt,370 TO 040+nLnAjt,495 LABEL 'SALDO A DISTRIBUIR' OF oDlgman PIXEL
	@ 20+nLnAjt,400 SAY oPesoDist PROMPT nPesoDist SIZE 100, 15 Picture "@E 99,999,999.99" OF oDlgman PIXEL Font oFont1 Color CLR_HRED

	@ 10+nLnAjt,010 Say "DESCONTO" Font oFont Pixel of oDlgman
	@ 18+nLnAjt,010 Say "CARREGAMENTO" Font oFont Pixel of oDlgman
	@ 10+nLnAjt,080 Msget oDescon Var nDescon Picture "@E 99,999,999.99" WHEN lDesconto SIZE 060, 010 Pixel of oDlgman Valid( BuscaDist() )//When .F.
//@ 090, 565 MSGET oxDescont VAR nxDescont Picture "@E 99,999,999.99" WHEN lDesconto SIZE 060, 010 OF oDlgmanTela COLORS 0, 16777215 PIXEL  Valid ( BuscaPeso(3) )  

	@ 91+nLnAjt,010 Say "Data " Font oFont Pixel of oDlgman
	@ 91+nLnAjt,055 Msget oData Var cData Size 50,10 Pixel of oDlgman When .F.

	@ 91+nLnAjt,130 Say "Hora " Font oFont Pixel of oDlgman
	@ 91+nLnAjt,150 Msget oHora Var cHora Size 50,10 Pixel of oDlgman When .F.

	@ 32+nLnAjt,010 Say "Ordem " Font oFont Pixel of oDlgman
	@ 32+nLnAjt,055 Msget oNrOrdem Var cNrOrdem When .F.  Size 50,10 Pixel of oDlgman

	@ 32+nLnAjt,130 Say "Placa " Font oFont Pixel of oDlgman
	@ 32+nLnAjt,150 Msget oPlaca Var cPlaca F3 "XDA3" Valid ( ExistCpo("DA3",cPlaca,3) .OR. !Vazio(cPlaca)) Size 50,10 Pixel of oDlgman

	@ 47+nLnAjt,10 Say "Motorista " Font oFont Pixel of oDlgman
	@ 47+nLnAjt,55 Msget oMotora Var cMotora F3 "DA4" Valid (ExistCpo("DA4",,1) .OR. !Vazio(cMotora)) Size 50,10 Pixel of oDlgman

	oMotora:bLostFocus := {||IIF(!Empty(cMotora), (cNome:= SUBSTR(DA4->DA4_NOME,1,40),cTransp :=DA4->DA4_XTRANS ),"")}

	@ 47+nLnAjt,130 Say "Nome Motorista " Font oFont Pixel of oDlgman
	@ 47+nLnAjt,195 Msget oNome Var cNome  Size 150,10 Pixel of oDlgman //When .F.

	@ 62+nLnAjt,10 Say "Cliente " Font oFont Pixel of oDlgman
	@ 62+nLnAjt,55 Msget oCliente Var cCliente F3 "SA1" Size 50,10 Pixel of oDlgman //Valid {|| iif( ExistCpo("SA1",,1), (cLoja:=SA1->A1_LOJA, .T.), (cLoja:=Space( len(SA1->A1_LOJA) ),.F.) )}
	oCliente:bLostFocus := {||IIF(!Empty(cCliente),u_MAN10B(Alltrim(cCliente),Alltrim(cLoja),nXOpc),"")}

	@ 62+nLnAjt,130 Say "Loja " Font oFont Pixel of oDlgman
	@ 62+nLnAjt,150 Msget oLoja Var cLoja Size 20,10 When .F. Pixel of oDlgman

	@ 62+nLnAjt,180 Say "Cliente " Font oFont Pixel of oDlgman
	@ 62+nLnAjt,220 Msget oRazao Var cRazao Size 125,10 When .F. Pixel of oDlgman

	@ 77+nLnAjt,10 Say "Transp." Font oFont Pixel of oDlgman
	@ 77+nLnAjt,55 Msget oTransp Var cTransp F3 "SA4" Valid ( ExistCpo("SA4",,1) .OR. Vazio(cTransp)) Size 50,10 Pixel of oDlgman  //when .f.

	@ 77+nLnAjt,130 Say "Frete Aut " Font oFont Pixel of oDlgman
	@ 77+nLnAjt,175 Msget oVlrFau Var nVlrFau Picture "@E 9,999,999.99" Size 50,10 Pixel of oDlgman

	@ 77+nLnAjt,240 Say "Frete " Font oFont Pixel of oDlgman
//@ 77+nLnAjt,295 Msget oGuiaST Var nGuiaST Picture "@E 9,999,999.99" Size 50,10 Pixel of oDlgman 
	@ 77+nLnAjt,295 Msget oVlrFre Var nVlrFre Picture "@E 9,999,999.99" Size 50,10 Pixel of oDlgman
//@ 77+nLnAjt,295 Msget oGuiaST Var cGuiaST Picture "@!" Size 50,10 Pixel of oDlgman 

//campo observacao nfe  
	@ 106+nLnAjt,010 Say "Obs. Nfe " Font oFont Pixel of oDlgman
	@ 106+nLnAjt,055 Msget oObs Var cObs Picture "@!" Size 135,10 Pixel of oDlgman when .f.
	@ 106+nLnAjt,240 Say "Lote" Font oFont Pixel of oDlgman
	@ 106+nLnAjt,295 Msget oLote Var cLote Picture "@!" Size 06,10  when .f. Pixel of oDlgman

//despesa transporte interna
	@ 91+nLnAjt,240 Say "Desp transp " Font oFont Pixel of oDlgman
	@ 91+nLnAjt,295 Msget oDesp Var nDesp Picture "@E 9,999,999.99" Size 50,10 Pixel of oDlgman

//if Empty(cCliente)
	u_MAN10B(Alltrim(cCliente),Alltrim(cLoja),nXOpc)
//EndIf

//if Empty(cCliente) .or. nXOpc == 2  
	u_MAN10C(aContr,nXOpc,nZOPC)
//EndIf                                                         

	if nXOpc == 1
	EndIf

	Private fNopc := 0

	if nXOpc = 1
		@ 220+nLnAjt,450 BUTTON oButton2 PROMPT "Incluir"  	  SIZE 045, 012 OF oDlgman PIXEL  	Action (fNopc := 1 ,GravaManu(oBrw:aCols,nPesoIni,nPesoFim,aContr,nXOpc),oDlgman:End()  )
		@ 220+nLnAjt,500 BUTTON oButton3 PROMPT "Cancelar" SIZE 045, 012 OF oDlgman PIXEL  		Action (fNopc := 2 ,oDlgman:End())
	Elseif nXOpc = 2
		@ 220+nLnAjt,450 BUTTON oButton2 PROMPT "Alterar"  	  SIZE 045, 012 OF oDlgman PIXEL  	Action (fNopc := 1 ,GravaManu(oBrw:aCols,nPesoIni,nPesoFim,aContr,nXOpc),oDlgman:End()  )
		@ 220+nLnAjt,500 BUTTON oButton3 PROMPT "Cancelar" SIZE 045, 012 OF oDlgman PIXEL  		Action (fNopc := 2 ,oDlgman:End())
	Elseif nXOpc = 4
		@ 220+nLnAjt,420 BUTTON oButton2 PROMPT "Confirmar Manuten็ใo"  SIZE 060, 012 OF oDlgman PIXEL   Action(ValManu(nXOpc)) //,fNopc := 1 ,GravaCarga(oBrw:aCols,nPesoIni,nPesoFim,aContr,nXOpc),oDlgman:End()
		@ 220+nLnAjt,500 BUTTON oButton3 PROMPT "Cancelar" SIZE 045, 012 OF oDlgman PIXEL  			  	 Action(fNopc := 2 ,nXPesoFim := 0, nxPesoLiq := 0, nPeso := 0,oDlgman:End()) //Cesar J. Santos - 01/06/2023
	Elseif nXOpc = 3
//	@ 220+nLnAjt,450 BUTTON oButton2 PROMPT "Visualizar"  SIZE 045, 012 OF oDlgman PIXEL  	Action (fNopc := 1 ,oDlgman:End())
		@ 220+nLnAjt,500 BUTTON oButton3 PROMPT "Cancelar Manuten็ใo" SIZE 060, 012 OF oDlgman PIXEL  Action (fNopc := 2 ,oDlgman:End())
	EndIf

	Activate MsDialog oDlgman Centered

//Fecha a Area e elimina os arquivos de apoio criados em disco.        

	if Select("QADA") > 1
		QADA->( DbCloseArea() )
	EndIf

	if fNopc = 1 .AND. ( nXOpc = 1 .OR. nXOpc = 4 ) //Caso Clique em Confirmar ้ Seja Incluir ou Manuten็ใo
	Else //Caso Clique em Cancelar
		RollBackSX8() //ConfirmSX8()
		if Select("QADA")> 1
			QADA->( DbCloseArea() )
		EndIf
	EndIf

Return()

Static Function BuscaDist()

//Manuten็ใo gontijo balanja bj 850

	nPesoDist := (nxPesoLiq - nPesoInf) - nDescon

//validacao peso tolerancia

	If nDescon >= 0 .AND. nDescon <= 100
		if !Empty(oPesoDist)
			oPesoDist:Refresh()
		EndIf
	Else
		xmaghelpfis("Aten็ใo"," A diferen็a do Peso Informado ้ superior a 100KG que ้ o Mแximo Permitido !","Solicite a Retirada do Peso excedente, e refa็a a pesagem!")
		nDescon := 0
		oDescon:Refresh()
		Return .F.
	EndIf

Return()

Static Function ValManu(nXOpc)
	Local lRet    := .T.  //Valida็ใo Saldo Distribuir
//Local nPerVar := SuperGetMV("MV_XPERVAR",,"10")   //nxPesoLiq*vAL(nPerVar)/100

	if nPesoDist = 0//nPesoDist >= 0 .AND. nPesoDist <= 100 //TOLERANCIA 100KG
		fNopc := 1
		GravaManu(oBrw:aCols,nPesoIni,nPesoFim,aContr,nXOpc)
		oDlgman:End()
	Else
		lRet := .F.
		xmaghelpfis("Aten็ใo"," Caminhใo com peso superior ao saldo do contrato !","limite de peso excedente ้ de 100kg, informe no campo DESCONTO CARREGAMENTO, a quantidade a ser descontada!")
		//MsgAlert("Se necessario digite desconto pois nใo pode ter saldo a DISTRIBUIR!")
	EndIf

Return(lRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFAT010    บAutor  ณInnovare Solu็๕es   บ Data ณ  08/01/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Busca Contratos disponiveis para o cliente selecionado     บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ FAT010                                                     บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/                               
User Function MAN10B(cCodCli,cLojaCli,nXOpc)
	Local _stru    := {}
	Local aCpoBro  := {}
	Local cQuery   := ""
	Local cQryZ4   := ""
	Local cQryZ	   := ""
	Local nExiste  := 0
	Local cProduto := ""
	Local i := 0
	Local nLinhas

	cProduto := Posicione('ZC4',1,xFilial('ZC4')+cXOrdem,"ZC4_PRODUT") // Cesar J. Santos - 01/06/2023
//cContra  := Posicione('ZC4',1,xFilial('ZC4')+cXOrdem,"ZC4_CONTRA") //Carlos Daniel posicionar Contrato

	cQryZ4:= " SELECT ZC4_CONTRA AS CONTRATO,ZC4_PRODUT AS PRODUTO FROM " + RETSQLNAME("ZC4")+ " ZC4"
	cQryZ4+= " WHERE ZC4.D_E_L_E_T_ = ' '
	cQryZ4+= " AND ZC4_FILIAL = '" + xFILIAL("ZC4") + "'"
	cQryZ4+= " AND ZC4_ORDEM  = '" + cXOrdem + "'"
	cQryZ4+= " ORDER BY ZC4_CONTRA "

	if Select("QRZ4") > 1
		QRZ4->( DbCloseArea() )
	EndIf
	TcQuery cQryZ4 New Alias "QRZ4"
//quantidade de itens
	cQryZ:= " SELECT ZC4_ORDEM AS ORDEM, COUNT(*) AS QUANTIDADE FROM " + RETSQLNAME("ZC4")+ " ZC4 WHERE ZC4.D_E_L_E_T_ = ' '    AND ZC4_FILIAL = '" + xFILIAL("ZC4") + "' AND ZC4_ORDEM  = '" + cXOrdem + "' group BY ZC4_ORDEM "
	if Select("QRZ") > 1
		QRZ->( DbCloseArea() )
	EndIf
	TcQuery cQryZ New Alias "QRZ"

	if !Empty(cCodCli) //.and. (nXOpc == 1 ) .OR. nXOpc == 4
		DbselectArea("SA1")
		SA1->(DbSetOrder(1))
		if SA1->(DbSeek(xFilial("SA1")+cCodCli+cLojaCli))

			//cLojaCli := SA1->A1_LOJA
			cLojaCli := SA1->A1_LOJA
			cLoja    := SA1->A1_LOJA
			cRazao	 := SUBSTR(SA1->A1_NOME,1,40)

			oLoja:Refresh()
			oRazao:Refresh()

			cQuery:= " SELECT DISTINCT ADA_NUMCTR,ADA_EMISSA, ADA_XMENOT FROM "+RETSQLNAME("ADA")+" ADA, "+RETSQLNAME("ADB")+" ADB "
			cQuery+= " WHERE ADA.D_E_L_E_T_ = ' ' AND ADB.D_E_L_E_T_ = ' ' "
			cQuery+= " 		AND ADA_FILIAL = ADB_FILIAL "
			cQuery+= " 		AND ADA_NUMCTR = ADB_NUMCTR "
			//cQuery+= " 		AND ADA_CODCLI = ADB_CODCLI "
			//cQuery+= " 		AND ADA_LOJCLI = ADB_LOJCLI "
			cQuery+= " 		AND ADB_QTDEMP < ADB_QUANT  "
			cQuery+= " 		AND ADA_STATUS IN ('B','C') "	// Contrato em Aberto ou Contrato Parcialmente Entregue
			cQuery+= " 		AND ADA_MSBLQL  = '2'	"		// Somente Contratos Liberados
			//cQuery+= " 		AND ADA_XLIBMS  != 'B'	"			// Somente Contratos Liberados MS / Cairo 26/06/20
			cQuery+= " 		AND ADA_FILIAL = '" + xFILIAL("ADA") + "' "
			cQuery+= " 		AND ADA_CODCLI = '" + cCodCli + "' "
			cQuery+= " 		AND ADA_LOJCLI = '" + cLojaCli + "' "

			//PEGA APENAS CONTRATOS SELECIONADOS NA INCLUSAO

			If !Empty(QRZ4->CONTRATO)

				nLinhas := QRZ->QUANTIDADE
				cQuery+= " 		AND ADA_NUMCTR IN ("
				QRZ4->( DbGoTop() )
				while !QRZ4->( Eof() )
					cQuery+=  "'"+ QRZ4->CONTRATO +"'"  // Carlos Daniel - 23/11/2024
					//SE MAIOR QUE 1 CONTRATO
					If nLinhas > 1
						cQuery+=  ","
						nLinhas := 1
					EndIf
					QRZ4->( DbSkip() )
				Enddo
				cQuery+=  ") "
			EndIf
			cQuery+= " ORDER BY ADA_NUMCTR,ADA_EMISSA "

			if Select("QDBA") > 1
				QDBA->( dbclosearea() )
				QRZ->( DbCloseArea() )
				QRZ4->( DbCloseArea() )
			EndIf

			TcQuery cQuery New Alias "QDBA"

		EndIf
	EndIf

	AADD(_stru,{"OKDA"     	,"C" , 2   ,0 })
	AADD(_stru,{"CONTRATO"  ,"C" , 21  ,0 })
	AADD(_stru,{"EMISSAO"   ,"D" , 10  ,0 })

	if Select("QADA")> 1
		QADA->( DbCloseArea() )
	EndIf

	oTable := FWTemporaryTable():New("QADA")
	oTable:SetFields(_stru)
	oTable:AddIndex("1", {"OKDA","CONTRATO","EMISSAO"} )
	oTable:Create()

//Define quais colunas (campos da TTRB) serao exibidas na 

	aCpoBro	:= {{ "OKDA"		,, "Mark"		  ,"@!" },;
		{ "CONTRATO"	,, "Contrato"     ,"@!" },;
		{ "EMISSAO"  	,, "Emissใo"      ,"@!" }}

//Alimenta o arquivo de apoio com os registros

	If !Empty(cCodcli) //.AND. (nXOpc == 1 )// Inclusao OU MANUTENวรO 1 OU 4
		QADA->( DbGotop() )
		While  !QDBA->( Eof() )
			RecLock("QADA",.T.)
			QADA->CONTRATO:=  QDBA->ADA_NUMCTR
			QADA->EMISSAO :=  STOD(QDBA->ADA_EMISSA)
			QADA->( MsunLock() )
			QDBA->( DbSkip() )
		Enddo
	Elseif nXOpc != 1 // Alterar ou Visualizar
		For i:= 1 to Len(aCols)
			// Valida se Contrato ja existe na tabela temporaria
			While !QADA->( Eof() )
				if AllTrim(QADA->CONTRATO) == AllTrim(aCols[i,2])
					nExiste++
					Exit
				EndIf
				QADA->( DbSkip() )
			Enddo

			if nExiste == 0
				RecLock("QADA",.T.)
				QADA->CONTRATO:=  aCols[i,2]
				QADA->EMISSAO :=  POSICIONE("ADA",1,xFILIAL("ADA")+aCols[i,2],"ADA_EMISSA")
				QADA->OKDA := cMark
				QADA->( MsunLock() )
			EndIf
		Next i

		QADA->( DBGOTOP() )
	EndIf

	if len(aCols)  = 0
		QADA->( DbGotop() )
		While  !QDBA->( Eof() )
			RecLock("QADA",.T.)
			QADA->CONTRATO:=  QDBA->ADA_NUMCTR
			QADA->EMISSAO :=  STOD(QDBA->ADA_EMISSA)
			QADA->( MsunLock() )
			QDBA->( DbSkip() )
		Enddo
	EndIf


	@ 002+nLnAjt+40,366 TO 120+nLnAjt+40,550 LABEL ' ' OF oDlgman PIXEL

	if Empty(oMark)
		oMark:= MsSelect():New("QADA","OKDA","",aCpoBro,@lInverte,@cMark,{050+nLnAjt   ,370,117+nLnAjt,545},,,,,)
	EndIf

	oMark:bMark:={|| Dispman() } //Exibe a Dialog

	QADA->( DbGoTop() )
	oMark:oBrowse:Refresh()

Return()


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFAT010C    บAutor  ณInnovare Solu็๕es  บ Data ณ  08/01/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Carrega os Itens da Ordem de Carregamento de Acordo com    บฑฑ
ฑฑบ          ณ Contratos Selecionados.                                    บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ FAT010                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function MAN10C(aContr,nXOpc,nzOPC)
	Local nItem:= 0
	Local nOpc := GD_DELETE+GD_UPDATE
	Local linha:=0, nova:=0
	Local aAlter:= {"ZC4_QTDE","ZC4_MENOTA"} //autoriza editar campos grid inferior
	Local i := 0
	Local ny := 0

	if len(aContr) >= 1

		aCols:= {}
		nPesoInf:= 0

		for nY:= 1 to Len(aContr)
//tras o saldo do contrato apos selecionar omark
			_Query:= " SELECT ADB_NUMCTR,ADB_CODPRO,ADB_DESPRO,SUM(ADB_QUANT - ADB_QTDEMP) SALDO, ADA.ADA_XMENOT FROM " + RETSQLNAME("ADB")+" ADB, " +RetSqlName("ADA")+" ADA"
			_Query+= " WHERE ADB.D_E_L_E_T_ = ' ' "
			_Query+= " AND ADA.D_E_L_E_T_ = ' ' "
			_Query+= " AND ADA.ADA_NUMCTR = ADB.ADB_NUMCTR "
			_Query+= " AND ADA.ADA_FILIAL = ADB.ADB_FILIAL "
			_Query+= " AND ADB_QTDEMP < ADB_QUANT "
			_Query+= " AND ADB_FILIAL = '" + xFILIAL("ADB") + "'"
			_Query+= " AND ADB_NUMCTR = '" + aContr[nY,1] + "'"
			_Query+= " GROUP BY ADB_NUMCTR,ADB_CODPRO,ADB_DESPRO, ADA.ADA_XMENOT "
			_Query+= " ORDER BY ADB_CODPRO,ADB_NUMCTR "

			if Select("QADB") > 1
				QADB->( DbCloseArea() )
			EndIf

			TcQuery _Query New Alias "QADB"

			While !QADB->( EOF() )

				// Salta registro se o saldo do produto for 0
				if QADB->SALDO == 0

					QADB->( DbSkip() )

				Else
					nova := len(aCols)+1
					//adiciona contrato selecionado se tiver mais
					AADD(aCols,Array((Len(aHeader)+1)))


					For i:= 1 to Len(aHeader)
						aCols[nova][i] := CriaVar(aHeader[i][2])
					Next i

					aCols[nova][Len(aHeader)+1] := .F.

					linha:= len(aCols)
					nItem++
					cUm:=POSICIONE("SB1",1,xFILIAL("SB1")+QADB->ADB_CODPRO,"B1_UM")
					nPesoLiq:= 0//POSICIONE("SB1",1,xFILIAL("SB1")+QADB->ADB_CODPRO,"B1_PESO")// - Altera็ใo para atender ERCAL
					//Quando seleciono o contrato na pesagem final
					//Alterado Carlos Daniel
					dbSelectArea("ADA")
					ADA->(dbSetOrder(1))
					ADA->(dbSeek(xFilial("ADA")+QADB->ADB_NUMCTR))

					cObs := QADB->ADA_XMENOT // attualiza observacao direto contrato
					oObs:Refresh()
					If ADA->ADA_XFRETE <> 0 // trata frete autonomo e destacado
						nVlrFre := QADB->SALDO*ADA->ADA_XDESPU
						oVlrFre:Refresh()
					ElseiF ADA->ADA_XDESP <> 0
						nDesp := QADB->SALDO*ADA->ADA_XDESPU
						oDesp :Refresh()
					Else
						nVlrFre := 0
						oVlrFre:Refresh()
						nDesp := 0
						oDesp :Refresh()
					EndIf

					if AllTrim(cUm) =="TN" .and. nPesoLiq=0
						nPesoInf += QADB->SALDO * 1000 // Atualiza Peso Informado
					else
						nPesoInf += nPesoLiq
					EndIf

					aCols[linha,Ascan(aHeader,{|x| Upper(AllTrim(x[2]))=="ZC4_ITEM"})]  := nItem
					aCols[linha,Ascan(aHeader,{|x| Upper(AllTrim(x[2]))=="ZC4_CONTRA"})]:= QADB->ADB_NUMCTR
					aCols[linha,Ascan(aHeader,{|x| Upper(AllTrim(x[2]))=="ZC4_PRODUT"})]:= QADB->ADB_CODPRO
					aCols[linha,Ascan(aHeader,{|x| Upper(AllTrim(x[2]))=="ZC4_DESCRI"})]:= QADB->ADB_DESPRO
					aCols[linha,Ascan(aHeader,{|x| Upper(AllTrim(x[2]))=="ZC4_QTDE"})]  := QADB->SALDO // Quantidade em toneladas
					aCols[linha,Ascan(aHeader,{|x| Upper(AllTrim(x[2]))=="ZC4_MENOTA"})]  := QADB->ADA_XMENOT // MENSAGEM NOTA NFE

				EndIf

				QADB->( DbSkip() )

			enddo

		next nY

		//BuscaDist() //Fun็ใo para calcular quantitade distribuida. Cesar J. Santos 28/06/2023
		nPesoDist := (nxPesoFim - nxPesoIni) - nDescon

		oPesoDist:Refresh()

		oBrw:SetArray(aCols)
		oBrw:Refresh(.T.)
		oPesoInf:Refresh()

		QADA->( DbGotop() )
		oMark:oBrowse:Refresh()

	Elseif len(aContr) < 1 .and. nxPesoFim > 0 //.and. nxPesoFim > nxPesoIni

		nPesoDist := (nxPesoFim - nxPesoIni) - nDescon

		oPesoDist:Refresh()

	EndIf

	if Len(aCols) == 0
		nPesoInf:= 0
		oPesoInf:Refresh()
		nVlrFre:= 0
		oVlrFre:Refresh()
		nDesp:= 0
		oDesp:Refresh()
	EndIf

	if Len(aContr) == 0 .and. Empty(oBrw)

		//Chama fun็ใo para montar aHeader e aCols
		MontaEst()

		@ 122+nLnAjt,007 TO 215+nLnAjt,550 LABEL 'Itens Contratos' OF oDlgman PIXEL

		oBrw:= MsNewGetDados():New( 130+nLnAjt, 010, 210+nLnAjt, 545,nOpc,"AllwaysTrue" , "AllwaysTrue","" , aAlter, , 999, "AllwaysTrue", "",, oDlgman  ,aHeader, aCols)
		//	oBrw:oBrowse:lUseDefaultColors := .F. // Desabilita cor padrao das linhas
		oBrw:bDelOk:={||u_DeletOKF()}

		if nXOpc == 1
			oMark:oBrowse:Refresh()
		Else // Chama fun็ใo para carregar dados quando opcao for editar
			u_FATMAN(nzOPC)

			if nXOpc == 4 //Manuten็ใo de Pesagem
				oMark:oBrowse:Enable()
			EndIf

		EndIf
	EndIf
Return()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFAT010E    บAutor  ณInnovare Solu็oes  บ Data ณ  08/01/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Carrega Dados quando opcao de editar ou Visualizar         บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/                  

User Function FATMAN(nzOPC)
	Local cQryZC4:= ""
	Local nItem := 0
	Local i := 0

	cData	 := ZC3->ZC3_DTRETI
	cCliente := ZC3->ZC3_CODCLI
	cLoja	 := ZC3->ZC3_LOJA
	cHora    := ZC3->ZC3_HORA
	cNrOrdem := ZC3->ZC3_ORDEM
	cPlaca   := ZC3->ZC3_PLACA
	cMotora  := ZC3->ZC3_CODMOT
	cNome    := ZC3->ZC3_MOTORI
	cRazao   := ZC3->ZC3_NOMCLI
	nPesoIni := ZC3->ZC3_PESINI
	nPesoFim := ZC3->ZC3_PESFIM
	nPesoLiq := ZC3->ZC3_PESLIQ
	cTransp  := ZC3->ZC3_TRANSP
//Claudio                         
	nVlrFre  := ZC3->ZC3_VLRFRE
//Carlos Daniel
	nVlrFau  := ZC3->ZC3_FRETAU
	nDesp    := ZC3->ZC3_DESPTR
//nGuiaST  := 0
//oCliente:Disable()
	oNrOrdem:Disable()
//oVlrFre:Disable()
//oVlrFau:Disable()
//oDesp:Disable()
//oPlaca:Disable()
//oMotora:Disable()
//oGuiaST:Disable()

	oCliente:Refresh()
	oNrOrdem:Refresh()
	oPlaca:Refresh()
	oMotora:Refresh()
//oPesoIni:Refresh()
//oPesoLiq:Refresh()


	oMark:oBrowse:Disable()

	cQryZC4:= " SELECT ZC4_CONTRA,ZC4_PRODUT,ZC4_DESCRI,ZC4_MENOTA,ZC4_EMBAL,ZC4_PALET,ZC4_QTDE,ZC4_ORDEM,ZC3_STATUS FROM " + RETSQLNAME("ZC4")+ " ZC4,"+ RETSQLNAME("ZC3") + " ZC3"
	cQryZC4+= " WHERE ZC4.D_E_L_E_T_ = ' ' AND ZC3.D_E_L_E_T_ = ' ' "
	cQryZC4+= " AND ZC3_FILIAL = ZC4_FILIAL"
	cQryZC4+= " AND ZC3_ORDEM = ZC4_ORDEM"
	cQryZC4+= " AND ZC4_FILIAL = '" + xFILIAL("ZC4") + "'"
	cQryZC4+= " AND ZC4_ORDEM  = '" + cNrOrdem + "'"
	cQryZC4+= " ORDER BY ZC4_CONTRA "

	if Select("QRZC4") > 1
		QRZC4->( DbCloseArea() )
	EndIf
	TcQuery cQryZC4 New Alias "QRZC4"

//iif(QRZC4->ZC3_STATUS == "1",oPesoFim:Disable(),oPesoFim:Enable())	

//oPesoFim:Refresh()	
	aCols:={}

	QRZC4->( DbGoTop() )
	nPesoInf:= 0

	While !QRZC4->( Eof() )

		nova := len(aCols)+1

		AADD(aCols,Array((Len(aHeader)+1)))

		for i:= 1 to Len(aHeader)
			aCols[nova][i] := CriaVar(aHeader[i][2])
		next i

		aCols[nova][Len(aHeader)+1] := .F.

		linha:= len(aCols)
		nItem++
		cUm:=POSICIONE("SB1",1,xFILIAL("SB1")+QRZC4->ZC4_PRODUT,"B1_UM")
		nPesoLiq:=0//POSICIONE("SB1",1,xFILIAL("SB1")+QRZC4->ZC4_PRODUT,"B1_PESO") //-- Altera็ใo para atender ERCAL
		//Quando confirma segunda pesagem

		IF nzOPC = 2
			nPesoInf  := 0
		Else

			If cUm=='TN' .and. nPesoLiq=0
				nPesoInf+= QRZC4->ZC4_QTDE * 1000
			Else
				nPesoInf += nPesoLiq
			EndIf

		EndIf

		aCols[linha,Ascan(aHeader,{|x| Upper(AllTrim(x[2]))=="ZC4_ITEM"})]  := nItem
		aCols[linha,Ascan(aHeader,{|x| Upper(AllTrim(x[2]))=="ZC4_CONTRA"})]:= QRZC4->ZC4_CONTRA
		aCols[linha,Ascan(aHeader,{|x| Upper(AllTrim(x[2]))=="ZC4_PRODUT"})]:= QRZC4->ZC4_PRODUT
		aCols[linha,Ascan(aHeader,{|x| Upper(AllTrim(x[2]))=="ZC4_DESCRI"})]:= QRZC4->ZC4_DESCRI
		aCols[linha,Ascan(aHeader,{|x| Upper(AllTrim(x[2]))=="ZC4_MENOTA"})] := QRZC4->ZC4_MENOTA //MONTA ACOLS
		//aCols[linha,Ascan(aHeader,{|x| Upper(AllTrim(x[2]))=="ZC4_PALET"})] := QRZC4->ZC4_PALET

		IF nzOPC = 2
			aCols[linha,Ascan(aHeader,{|x| Upper(AllTrim(x[2]))=="ZC4_QTDE"})]  := 0
		Else
			aCols[linha,Ascan(aHeader,{|x| Upper(AllTrim(x[2]))=="ZC4_QTDE"})]  := QRZC4->ZC4_QTDE
		EndIf

		oBrw:SetArray(aCols)
		oBrw:Refresh(.T.)
		oPesoInf:Refresh()

		QRZC4->( DbSkip() )

	Enddo

//if !Empty(aCols[1,2]) //.AND. nzOPC <> 4
//	Alert("OK")
	u_MAN10B(Alltrim(cCliente),Alltrim(cLoja),2)
//EndIf

Return()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณDisp      บAutor  ณInnovare Solu็๕es   บ Data ณ  08/01/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Fun็ใo auxiliar para marcar e desmarcar a Check da         บฑฑ
ฑฑบ          ณ  MsSelect                                                  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function Dispman()
	Local aReg:= {}

	RecLock("QADA",.F.)
	If Marked("OKDA")
		QADA->OKDA := cMark
	Else
		QADA->OKDA := ""
	EndIf

	MSUNLOCK()

	oMark:oBrowse:Refresh()
// Adiciona Contratos? Marcados na MsSelect no Array
	QADA->(DbGotop())
	While QADA->(!EOF())

		If !Empty(QADA->OKDA)
			AADD(aReg,{QADA->CONTRATO})
		EndIf

		QADA->(Dbskip())
	Enddo

// Se nenhum Contrato foi marcada apaga o que estiver no aCols
	if Len(aReg) == 0
		aCols:= {}
	EndIf

	QADA->(DbGotop())
	oMark:oBrowse:Refresh()
	oBrw:SetArray(aCols)
	oBrw:Refresh(.T.)

//Chama Fun็ใo que atualiza a GetDados dos Produtos

	u_MAN10C(aReg)

Return()

Static Function GravaManu(aDados,nPesoIni,nPesoFim,aContr,nXOpc)

	if  nXOpc = 1 .OR. nXOpc = 4 	//	Inclui  ou Manuten็ใo

		if u_MAN010D(aDados,nPesoIni,nPesoFim,aContr,nXOpc) //Processo Gravar Ordem de Carregamento e Alterar Status

			oDlgman:End()       //Fecha Rotina Inclui Carga

			if  nXOpc = 1   //Somente quando ้ Inclusใo
				oDlgCar:End()	 //Fecha Sele็ใo de Carga
			EndIf

			BuscaCarga(ZC3->ZC3_ORDEM,nXOpc)	//Adiciona Carga na Rotina Principal

		EndIf

	EndIf

Return()


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFAT010    บAutor  ณMicrosiga           บ Data ณ  05/20/18   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function MAN010D(aDados,nPesoIni,nPesoFim,aContr,nXOpc)
	Local cQry 			:= ""
	Local cContratos	:= ""
	Local aMarcado		:= {}
	Local _GravaOk		:= .T.
	Local nQtde 		:= 0
	Local lContrICM
	Local i, x, nj

//Posiciona as tabelas
	SA1->(dbSetOrder(1))
	SA1->(DbSeek( xFilial("SA1")+cCliente+iif(Empty(cLoja),"",cLoja) ) )

	SA4->(dbSetOrder(1))
	SA4->(MsSeek(xFilial("SA4")+cTransp))

	lContrICM := !(IIf(Empty(SA1->A1_INSCR) .Or. "ISENT"$SA1->A1_INSCR .Or. "RG"$SA1->A1_INSCR .Or. ( SA1->(FieldPos("A1_CONTRIB"))>0 .And. SA1->A1_CONTRIB == "2"),.T.,.F.))

	cStatus	  := Posicione("ZC3",1,xFILIAL("ZC3")+ cNrOrdem,"ZC3_STATUS")

	if Empty(nPesoFim) .AND. nXOpc == 2 .AND. cStatus == "2"
		Alert("Peso Final da Ordem de Carregamento deve ser Informado para finalizar o processo !")
		Return(.F.)
	EndIf

	IF .T.

		if Len(aDados) != 0
			// Valida se todas a linhas estao deletas para nao permitir inclusใo sem produto
			For x:= 1 to len(aDados)
				if aDados[x,len(aHeader)+1] == .T.
					nQtde++
				EndIf
			Next x

			if nQtde == Len(aCols)
				Alert("Ordem de Carregamento nใo pode ser gerada sem Produto, informe ao menos um Contrato com Produto Disponivel !","Aten็ใo")
				QADA->( DbGoTop() )
				Return(.F.)
			EndIf
		EndIf

		if nXOpc == 1 .OR. nXOpc == 4

			lRet	:= .t.
			cMsg	:= ""
			//if Empty(nPesoIni)
			//	Alert("O Campo Peso Inicial ้ de Preenchimento Obrigat๓rio","Aten็ใo")
			//	Return .F.
			if Empty(cPlaca)
				Alert("O Campo Placa ้ de Preenchimento Obrigat๓rio","Aten็ใo")
				lRet	:= .F.
				Return .F.
			Elseif Empty(cMotora)
				Alert("O Campo Motorista ้ de Preenchimento Obrigat๓rio","Aten็ใo")
				lRet	:= .F.
				Return .F.
			Elseif Empty(cTransp)
				lRet	:= .F.
				Alert("O Campo Transportadora ้ de Preenchimento Obrigat๓rio","Aten็ใo")
				Return .F.
			EndIf
			//Valida Frete

			//regra frete autonomo
			If nVlrFau > 0
				if POSICIONE("SA1",1,xFILIAL("SA1")+ADA->ADA_CODCLI,"A1_EST") == SuperGetMV("MV_ESTADO")
					//cMsg:="Cliente Minas Gerais, nใo tem Frete Autonomo"
					//lRet := .F.
					//nVlrFau := 0
					if MsgYesNo("Cliente Minas Gerais, nใo tem Frete Autonomo, deseja zerar o Frete Autonomo? ", "FRETE AUTONOMO")
						//lRet := .F.
						nVlrFau := 0
						//Return .F.
					Else
						lRet := .T.
					EndIf
				Elseif cTransp='000004' .OR. cTransp='000010' .OR. cTransp='000011' .OR. cTransp='000423'
					if MsgYesNo("Transp Ercal, ele realmente tem Frete Autonomo ? deseja retirar frete autonomo? ", "FRETE AUTONOMO")
						//cMsg :="Retirar Informa็ใo do Campo Frete Autonomo?"
						//lRet := .f.
						nVlrFau := 0
					else
						lRet := .T.
					EndIf
				EndIf
			Else
				if !cTransp='000004' .OR. !cTransp='000010' .OR. !cTransp='000011' .OR. !cTransp='000423'
					if POSICIONE("SA1",1,xFILIAL("SA1")+ADA->ADA_CODCLI,"A1_EST") <> SuperGetMV("MV_ESTADO")
						if MsgYesNo("Este Contrato tem Frete Autonomo ? ", "FRETE AUTONOMO")
							cMsg :="Informe o Valor do Frete Autonomo"
							lRet := .F.
						Else
							nVlrFau := 0
							lRet := .T.
						EndIf
					EndIf
				EndIf
			EndIf
			if !lRet
				Alert(cMsg,"Aten็ใo")
				Return .F.
			EndIf

			QADA->( DbGoTop() )
			While QADA->(!EOF())

				if !Empty(QADA->OKDA)
					AADD(aMarcado,{QADA->CONTRATO})
				EndIf

				QADA->( DbSkip() )
			Enddo

			For i:=1 to len(aMarcado)
				If i != Len(aMarcado)
					cContratos :=  "'" + aMarcado[i,1] + "'" + ","
				Else
					cContratos +=  "'" + aMarcado[i,1] + "'"
				EndIf
			Next i

			if !Empty(cContratos)
				//--- Verifica se existe exite carregamento em aberto para o Cliente + Contrato + placa informados
				cQry:= "  SELECT ZC3_ORDEM, ZC3_PLACA,ZC4_CONTRA, ZC3_STATUS FROM " + RETSQLNAME("ZC3") + " ZC3," + RETSQLNAME("ZC4") + " ZC4"
				cQry+= "  WHERE ZC3.D_E_L_E_T_ = ' ' AND ZC4.D_E_L_E_T_ = ' ' "
				cQry+= "  AND ZC3_FILIAL = ZC4_FILIAL "
				cQry+= "  AND ZC3_ORDEM = ZC4_ORDEM "
				cQry+= "  AND ZC3_FILIAL  = '" + xFILIAL("ZC3") + "'"
				cQry+= "  AND ZC3_CODCLI  = '" + Alltrim(cCliente) + "'"
				cQry+= "  AND ZC4_CONTRA  IN (" + cContratos + " ) "   //Contrato
				cQry+= "  AND ZC3_PLACA	  = '" + cPlaca + "'"
				cQry+= "  AND ZC3_STATUS IN ('1','2') "
				cQry+= "  ORDER BY ZC3_ORDEM "

				if Select("QZC4") > 1
					QZC4->( DbCloseArea() )
				EndIf
				TcQuery cQry New Alias "QZC4"

				//Count To nLinhas  //Contar linhas da QZC4
				nLinhas := QZC4->( LastRec() )

				if nLinhas > 0
					Alert("Existe Carregamento em Aberto para Contrato e Veiculo Informado !","Aten็ใo")
					QADA->( DbGoTop() )
					Return .F.
				EndIf
			EndIf

			if MsgYesNo("Confirma Grava็ใo da Ordem de Carregamento !", "Protheus ")

				Begin Transaction

					DbSelectArea("ZC3")
					ZC3->(DbSetOrder(1) )
					IF ZC3->(DbSeek(xFilial("ZC3")+cNrOrdem ) )

						nxPesoLiq := (nxPesoFim - nxPesoIni)

						Reclock("ZC3",.F.) //grava na zc3 os dados carregados tela
						ZC3->ZC3_PLACA	  := cPlaca
						ZC3->ZC3_CODMOT   := cMotora
						ZC3->ZC3_MOTORI	  := cNome
						ZC3->ZC3_CODCLI   := cCliente
						ZC3->ZC3_LOJA	  := cLoja
						ZC3->ZC3_NOMCLI   := cRazao
						ZC3->ZC3_TRANSP	  := cTransp
						ZC3->ZC3_VLRFRE	  := nVlrFre
						ZC3->ZC3_FRETAU	  := nVlrFau
						ZC3->ZC3_DESPTR   := nDesp
						ZC3->ZC3_DESCONTO := nDescon
						ZC3->ZC3_PESLIQ   := nxPesoLiq-nDescon
						ZC3->( Msunlock() )

					EndIf

				End Transaction

			Else
				QADA->( DbGoTop() )
				Return .F.
			EndIf

			//--- Chama funcao para validar peso
			_GravaOk:= u_ValPesoF(.T.,nPesoIni,nPesoFim,1)

			if _GravaOk

				cStatus:= ZC3->ZC3_STATUS

				Begin Transaction

					if nXOpc = 4  //Manuten็ใo
						Reclock("ZC3")
						ZC3->ZC3_DESCONTO := nDescon
						ZC3->( Msunlock() )
					EndIf

				End Transaction

				//Deleta Ordem de Carregamento ZC4
				DbSelectArea("ZC4")
				ZC4->( DbSetOrder(1) )
				ZC4->( DbSeek( xFilial("ZC4") + cNrOrdem ) )
				While ZC4->(!EOF()) .AND. cNrOrdem == ZC4->ZC4_ORDEM 	//--- deleta os itens que foram excluidos da getdados
					Begin Transaction
						Reclock("ZC4")
						ZC4->( dbDelete() )
						ZC4->( Msunlock() )
					End Transaction
					ZC4->(DbSkip())
				Enddo


				//Itens Ordem de Carregamento
				For nj:= 1 to Len(aDados)

					if oBrw:aCols[nj,len(aHeader)+1] == .F. // Altera item nao deletado

						Begin Transaction
							Reclock("ZC4",.T.)
							ZC4->ZC4_FILIAL  := xFilial("ZC4")
							ZC4->ZC4_ORDEM   := cNrOrdem
							ZC4->ZC4_CONTRA  := aDados[nj,2]
							ZC4->ZC4_PRODUT  := aDados[nj,3]
							ZC4->ZC4_DESCRI  := aDados[nj,4]
							ZC4->ZC4_MENOTA	 := aDados[nj,5]
							ZC4->ZC4_QTDE    := aDados[nj,6]
							ZC4->( Msunlock() )
						End Transaction
					EndIf
				Next nj

				Msginfo("Manuten็ใo Realizada com Sucesso !!!")

				oDlgman:End()

			EndIf
		Else
			Return .F.
		EndIf

	EndIf

Return(lret)

//trata senha loguin
Static Function fDigSenha(nXOpc,nPeso)
	Private zoButton8
	Private zoButton9
	Private zoGet8
	Private cSenha := Space(10)
	Private zoGroup8
	Private zoSay8
	Private Senhadlg
	Private cSenhAce := GetMV('MV_SEPESO')
	Private _lRet := .T.

	Define Font oFont10 Name 'Courier New' //Size 0, 0

	DEFINE MSDIALOG Senhadlg TITLE "Liberacao de Acesso: " FROM 000, 000  TO 190, 370 COLORS 0, 16777215 PIXEL

	@ 002, 002 GROUP 	zoGroup8 TO 074, 183 PROMPT "Valida็ใo de Usuario " OF Senhadlg COLOR 0, 16777215 PIXEL
	@ 010, 020 SAY 		zoSay8 PROMPT "Digite a senha " SIZE 110, 015 OF Senhadlg PIXEL Font oFont10 Color CLR_HRED
	@ 040, 020 MSGET 	zoGet8 VAR cSenha 	Password 	SIZE 060, 010 OF Senhadlg COLORS 0, 16777215 PIXEL
	@ 076, 099 BUTTON 	zoButton8 PROMPT "Confirmar" 	SIZE 037, 012 OF Senhadlg PIXEL Action(fOK(cSenha, _lRet))
	@ 076, 144 BUTTON 	zoButton9 PROMPT "Cancelar" 	SIZE 037, 012 OF Senhadlg PIXEL Action(_lRet := .F.,Senhadlg:End())

	ACTIVATE MSDIALOG Senhadlg CENTERED
//If fOK()
//	_lRet := .T.
//EndIf
Return(_lRet)

Static Function fOK(cSenha, _lRet)
//Private _lRet := .F.

	If ALLTRIM(cSenha)<> cSenhAce
		MsgStop("Senha nใo Confere !!!")
		cSenha  := Space(10)
		dlgRefresh(Senhadlg)
	Else
		//nPeso := PesoManual(nXOpc)
		Senhadlg:End()//add para fechar tela senha
		_lRet := .T.
		Return(_lRet)
	EndIf
Return(_lRet)
//fonte teste totvs pesagem
Static Function ApesaB(cPorta, cBaudRate, cParity, cData, cStop, cTimeOut )
	// Vars de Conexao com Serial
	Local cParte		:= Space( 1 )
	Local cSettings		:= AllTrim( cBaudRate )+','+AllTrim( cParity )+','+AllTrim( cData )+','+AllTrim( cStop )+','+AllTrim( cTimeOut )
	Local nHdlePorta
	Local nBytes		:= 0
	//--End VArs de Comunicacao Serial--
	Local nFor01		:= 0
	Local nFor02		:= 0
	//Local nRetorno		:= 0
	Local cConteudo		:= ""
	Local nHdll  	    := 0
	Local nCont  	    := 0
	Local cPortaMs      := AllTrim(cPorta) + ':' + AllTrim(cSettings)
	//AJUSTE LEITURA
	Local nX := 0
	Local nValor	:= 0
	Local cValor	:= ""
	Local cArquivo	:= "" // Leitura do arquivo
	Local aArquivo
	//FIM AJUSTE
	//Local nRetorno    := 0

	nHdlePorta	:= fOpenPort( cPorta, cSettings, 2 ) // Tentando conectar

	IF nHdlePorta == -1 //caso nใo conecte com o fOpenPort, irแ tentar com o MsOpenPort

		FClose( nHdlePorta )

		MsOpenPort(nHdll, cPortaMs)

		cConteudo := space(100)

		While (Empty(cConteudo) .AND. nCont < 50)
			MsRead(nHdll, @cConteudo)
			nCont++
		EndDo

		MsClosePort(nHdll)

		If Empty(cConteudo)
			Help(,,"AJUDA",,"nใo foi possivel conectar com a balan็a na Porta" + Chr(10) + Chr(13) +  "[ " + cPorta + " ]" , 1, 0 )  //"Ajuda"####nใo foi possivel conectar com a balan็a na Porta#
			Return 0
		EndIf
		MemoWrite("C:\TEMP\Geralbalanca.txt",cConteudo)
	Else
		For nFor01 := 1 to TRIES_TO_READ  		// tenta conectar N vezes
			cConteudo := ''
			For nFor02 := 1 to BUFFER_LEITURA   //32
				cParte := Space( 1 )
				nBytes := FRead( nHdlePorta, @cParte, 1 )
				If Empty( nBytes )
					Exit
				EndIf
				cConteudo += cParte
			Next nFor02
			IF ! Empty( cConTeudo )
				MemoWrite("C:\TEMP\Geralbalexit.txt",cConteudo)
				Exit
			EndIf
			MemoWrite("C:\TEMP\Geralbalanca.txt",cConteudo)
		Next nFor01
		FClose( nHdlePorta )
	EndIf
	cArquivo := cConteudo//"kkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkST,GS,+0020960kg ST,GS,+0020960kg"
	MemoWrite("C:\TEMP\balanca.txt",cArquivo)
	If cFilAnt == '4101'

		aArquivo := StrToKarr2(cArquivo, ",")
		//ajuste para leitura arquivo
		If Empty(aArquivo)
			FWAlertWarning('Nใo hแ dados para consultar.', 'Balan็a')
		Else
			For nX := 1 To Len(aArquivo)
				If Left(aArquivo[nX],1) == "+"
					cValor := aArquivo[nX]
					nValor := Val(StrTran(cValor,"kg",""))
					Exit
				EndIf
			Next nX
		EndIf
	ElseIf cFilAnt = '4104' .Or. cFilAnt = '4200'
		//cArquivo := "\0 021260000000Y\0 021260000000Y\0 021260000000Y\0 021260000000Y\0 021260000000Y\0 021260000000Y\0 021260000000Y\0 021260000000Y"
		aArquivo := StrToKarr2(cArquivo, "\")
		//ajuste para leitura arquivo
		If Empty(aArquivo)
			FWAlertWarning('Nใo hแ dados para consultar.', 'Balan็a')
		Else
			For nX := 1 To Len(aArquivo)
				If Left(aArquivo[nX],1) == "0"
					cValor := aArquivo[nX]
					nValor := val(substr(cValor,3,6))
					Exit
				EndIf
			Next nX
		EndIf

	EndIf

	If !Empty( nValor )
		nRetorno := nValor
	Else
		nRetorno := 0
	EndIf
Return( nRetorno )

User Function SetPeso()
	Local nPeso

	dbSelectArea("ADB")
	dbSetOrder(1)
	MsSeek(xFilial("ADB")+M->ZC5_CONTRA)
	nPeso := (ADB->ADB_QUANT - ADB->ADB_QTDEMP)

Return(nPeso)

User Function MaxOrdem()

	Local nOrdem := ""
	Local cQryMax := ""


	If Select("cQryMax") > 0

		cQryMax->(dbclosearea())

	EndIf

	cQryMax := "SELECT substr(MAX(ZC5_ORDEM),2,9) AS ORDEM "                                 + CRLF
	cQryMax += "FROM "+RetSQLName("ZC5")+" ZC5 "                                				   + CRLF
	cQryMax += "WHERE ZC5_FILIAL = '"+ XFILIAL("ZC4") + "'"                      + CRLF

	MemoWrite("C:\TEMP\QryMaxORDEM.txt",cQryMax)
	cQryMax := ChangeQuery(cQryMax)

	TcQuery cQryMax New Alias "cQryMax"

	IF empty(cQryMax->ORDEM)
		nOrdem := "000000001"
	Else
		nOrdem := (cQryMax->ORDEM+1)
	EndIf
	nOrdem := "M"+nOrdem
Return nOrdem
Static Function getCSS( cClass )
	Local cCSS      := '' as character
	Default cClass    := ''

	If cClass == 'TBUTTON_01'
		//cCSS   += "QPushButton { color: Black }"//cor texto
		//cCSS   += "QPushButton { font-weight: bolder }" //estilo da fonte
		//cCSS   += "QPushButton { border: 1px solid qlineargradient(x1: 0, y1: 0, x2: 0, y2: 1, stop: 0 #148AA8, stop: 1 #39ACC9) }" //borda solida
		//cCSS   += "QPushButton { background-color: qlineargradient(x1: 0, y1: 0, x2: 0, y2: 1, stop: 0 #148AA8, stop: 1 #39ACC9) }" //cor fundo principal antes clicar
		//cCSS   += "QPushButton { border-radius: 0px }" //borda estilo arredondada
		//cCSS   += "QPushButton:hover { background-color: #148AA8 } " // cor ao pssar o mouse
		//cCSS   += "QPushButton:hover { border-style: solid } " //passar mouse borda solida
		//cCSS   += "QPushButton:hover { border-width: 2px }" // pixel da borda ao passar mouse
		cCSS   += "QPushButton:pressed { background-color: qlineargradient(x1: 0, y1: 0, x2: 0, y2: 1, stop: 0 #148AA8, stop: 1 #39ACC9) }" // quando pressionar ficara nesta cor
		//cCSS   += "QPushButton:focus { background-color: #148AA8 } " //quando selecionado fica nesta cor
		//cCSS   += "QPushButton:focus { border-style: solid } " //quando tiver selecionado ficara com esta borda
		//cCSS   += "QPushButton:focus { border-width: 2px }" // a largura da borda quando selecionado
	ElseIf cClass == 'TBUTTON_02'
		cCSS   += "QPushButton { color: Black }"//cor texto
		cCSS   += "QPushButton { font-weight: bolder }" //estilo da fonte
		cCSS   += "QPushButton { border: 1px solid #39ACC9 }" //borda solida
		cCSS   += "QPushButton { background-color: #148AA8 }" //cor fundo principal antes clicar
		cCSS   += "QPushButton { border-radius: 3px }" //borda estilo arredondada
		cCSS   += "QPushButton:hover { background-color: #38c4e8 } " // cor ao pssar o mouse
		cCSS   += "QPushButton:hover { border-style: solid } " //passar mouse borda solida
		cCSS   += "QPushButton:hover { border-radius: 3px }" //borda estilo arredondada
		cCSS   += "QPushButton:hover { border-width: 3px }" // pixel da borda ao passar mouse
		cCSS   += "QPushButton:pressed { background-color: #148AA8 }" // quando pressionar ficara nesta cor
		//cCSS   += "QPushButton:focus { background-color: #148AA8 } " //quando selecionado fica nesta cor
		//cCSS   += "QPushButton:focus { border-style: solid } " //quando tiver selecionado ficara com esta borda
		//cCSS   += "QPushButton:focus { border-width: 2px }" // a largura da borda quando selecionado
	EndIf
Return( cCSS )

//custo para alterar Parametro Balanca principal ou secundaria
User Function mVbal()
// Variaveis Locais da Funcao                             
	Local cEdit1	 := GetMv("MV_BAL01")
	Local cEdit2	 := GetMv("MV_BAL02")
	Local oEdit1
	Local oEdit2
	Private _oDlg				// Dialog Principal

	DEFINE MSDIALOG _oDlg TITLE "Prioridade Balancas" FROM C(350),C(575) TO C(487),C(721) PIXEL
	@ C(007),C(007) Say "Balanca Entrada" Size C(055),C(008) COLOR CLR_BLACK PIXEL OF _oDlg
	@ C(015),C(007) MsGet oEdit1 Var cEdit1 Size C(060),C(009) COLOR CLR_BLACK PIXEL OF _oDlg
	@ C(030),C(007) Say "Balanca Saida" Size C(055),C(008) COLOR CLR_BLACK PIXEL OF _oDlg
	@ C(037),C(007) MsGet oEdit2 Var cEdit2 Size C(060),C(009) COLOR CLR_BLACK PIXEL OF _oDlg HASBUTTON
	DEFINE SBUTTON FROM C(055),C(007) TYPE 1 ENABLE OF _oDlg ACTION _bOk(cEdit1,cEdit2)
	DEFINE SBUTTON FROM C(055),C(040) TYPE 2 ENABLE OF _oDlg ACTION _oDlg:End()
	ACTIVATE MSDIALOG _oDlg CENTERED
Return(.T.)

//**************************
Static Function _bOk(cEdit1,cEdit2)
//**************************
	_oDlg:End()
	PutMv("MV_BAL01",cEdit1)
	PutMv("MV_BAL02",cEdit2)
Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณPrograma   ณ   C()   ณ Autores ณ Norbert/Ernani/Mansano ณ Data ณ10/05/2005ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณDescricao  ณ Funcao responsavel por manter o Layout independente da       ณฑฑ
ฑฑณ           ณ resolucao horizontal do Monitor do Usuario.                  ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
Static Function C(nTam)
Local nHRes	:=	oMainWnd:nClientWidth	// Resolucao horizontal do monitor
If nHRes == 640	// Resolucao 640x480 (soh o Ocean e o Classic aceitam 640)
	nTam *= 0.8
ElseIf (nHRes == 798).Or.(nHRes == 800)	// Resolucao 800x600
	nTam *= 1
Else	// Resolucao 1024x768 e acima
	nTam *= 1.28
EndIf

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณTratamento para tema "Flat"ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
If "MP8" $ oApp:cVersion
	If (Alltrim(GetTheme()) == "FLAT") .Or. SetMdiChild()
		nTam *= 0.90
	EndIf
EndIf
Return Int(nTam)


/*/{Protheus.doc} FAT010 
Valida MDFe se estแ Gerado
Regra ้ Pedido CIF + Motorista Autonomo ou Veiculo Proprio e MDFe sem preenchimento
@author Lucas Nogueira
@type function
@since 02/2025 
/*/
Static Function vldMDFE(_lImpressao)
	Local lPedido	:= .F.
	Local lDA3		:= .F.
	Local lSA4		:= .F.
	
	Default _lImpressao	:= .F.

	cxPedido 	:= AvKey(cxPedido,"C5_NUM")
	cxNota 		:= AvKey(cxNota,"F2_DOC")
	cxSerie		:= AvKey(cxSerie,"F2_SERIE")
	cxCliente 	:= AvKey(cxCliente,"A1_COD")
	cxLojaCli 	:= AvKey(cxLojaCli,"A1_LOJA")

	//ฆ+---------------------------------------------------------+ฆ
	//ฆฆValida se pode imprimir a NF
	//ฆ+---------------------------------------------------------+ฆ
	DbSelectArea("SC5")
	SC5->(DbSetOrder(1))
	If SC5->(DbSeek(FwXFilial("SC5") + cxPedido))
		If SC5->C5_TPFRETE == "C" //CIF
			lPedido := .T.
		EndIF
	EndIf

	DbSelectArea("DA3")
	DA3->(DbSetOrder(3))
	If DA3->(DbSeek(FwXFilial("DA3") + cxPlaca))
		If DA3->DA3_FROVEI == "1"  /*1=Propria;2=Terceiro;3=Agregado*/
			lDA3 := .T.
		EndIf
	EndIf

	DbSelectArea("SA4")
	SA4->(DbSetOrder(1))
	If SA4->(DbSeek(FwXFilial("SA4") + cxMotorista))
		If SA4->A4_TPTRANS == "3" /*1=Inscrito;2=Nao inscrito;3=Autonomo*/
			lSA4 := .T.
		EndIf
	EndIf

	If lPedido .And. (lDA3 .Or. lSA4)
		If Select("SF2") > 0
			SF2->(DbCloseArea())
		EndIf

		DbSelectArea("SF2")
		SF2->(DbSetOrder(1)) // F2_FILIAL + F2_DOC + F2_SERIE + F2_CLIENTE + F2_LOJA
		If SF2->(DbSeek(FwXFilial("SF2") + cxNota + cxSerie + cxCliente + cxLojaCli))
			
			If Empty(SF2->F2_NUMMDF)
				lpesini    := .F.
				lpesfim    := .F.
				lnfe       := .F.
				lDesconto  := .F.
				
				lDANFE     := .T.
				lTRNFE	   := .T.
				lMTNFE	   := .T.
				lExclPv	   := .T.
				lMDFE	   := .T.
				BotonTela(ZC3->ZC3_STATUS)

				If _lImpressao
					FWAlertWarning("MDF-e nใo gerado para a Nota Fiscal !" + CRLF + "Favor gerar MDFe para impressใo da DANFE.","Nใo ้ possํvel Imprimir DANFE!")
				EndIf
				Return(.F.)
			EndIf
		EndIf
	EndIf
	//-----------------------------------

Return(.T.)

/*/{Protheus.doc} FAT010 
Ajusta os dados do Contrato de Novo quando eh opera็ใo tringular.
@author Lucas Nogueira
@type function
@since 03/2025 
/*/
Static Function ajusteSC6(cPedAtu,cPedTriang)

	Local nX 				:= 1	as numeric
	Local nPContrato		:= 0			as numeric
	Local nPItemCtr			:= 0			as numeric
	Local nPOpc				:= 0			as numeric

	Local aAreaSC6			:= {}	as array
	Local aItens			:= {}	as array

	Local cChave			:= ""	as character

	aAreaSC6  := SC6->(FWGetArea())

	//ฆ+---------------------------------------------------------+ฆ
	//ฆฆGravo os dados do Contrato de Novo
	//ฆ+---------------------------------------------------------+ฆ
	SC6->(DbsetOrder(1)) // C6_FILIAL + C6_NUM + C6_ITEM + C6_PRODUTO
	If SC6->(DbSeek(xFilial("SC6") + cPedTriang))
		While SC6->(!Eof()) .AND. SC6->C6_FILIAL == xFilial("SC6") .AND. SC6->C6_NUM == cPedTriang
			
			cChave := SC6->C6_FILIAL + SC6->C6_PRODUTO + cPedAtu + SC6->C6_ITEM
			
			aadd(aItens,{cChave,SC6->C6_CONTRAT,SC6->C6_ITEMCON,SC6->C6_OPC})
			
			SC6->(DbSkip())
		EndDo

		For nX := 1 To Len(aItens)

			SC6->(DbsetOrder(2))
			If SC6->(DbSeek(aItens[nX,1]))

				nPProduto 	:= aScan(aLinha[nX], { | x | x[1] == "C6_PRODUTO" })
				nPContrato 	:= aScan(aLinha[nX], { | x | x[1] == "C6_CONTRAT" })
				nPItemCtr 	:= aScan(aLinha[nX], { | x | x[1] == "C6_ITEMCON" })
				nPOpc		:= aScan(aLinha[nX], { | x | x[1] == "C6_OPC" })

				If aLinha[nX][nPProduto][2] == SC6->C6_PRODUTO
					If nPContrato > 0
						aLinha[nX][nPContrato][2] := aItens[nX,2]
					EndIf

					If nPItemCtr > 0
						aLinha[nX][nPItemCtr][2] := aItens[nX,3]
					EndIf

					If nPOpc > 0
						aLinha[nX][nPOpc][2] := aItens[nX,4]
					EndIf
				ENDIF

				If RecLock("SC6",.F.)
					SC6->C6_CONTRAT := aItens[nX,2]
					SC6->C6_ITEMCON := aItens[nX,3]
					SC6->C6_OPC		:= aItens[nX,4]
					SC6->(MsUnLock())
				EndIf
			EndIf
		Next nX
	EndIf

	FWRestArea(aAreaSC6)
Return()
