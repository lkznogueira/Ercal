#include "protheus.ch"
#include "rwmake.ch"
#include "topconn.ch"

/*
__________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦Programa  ¦ FA050DES  ¦ Utilizador ¦ Claudio Ferreira ¦ Data ¦ 18/06/12¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Descriçào ¦ Ponto de Entrada na confirmação do Desdobramento           ¦¦¦
¦¦¦          ¦ Utilizado para alterar as parcelas                         ¦¦¦
¦¦¦          ¦ 															  ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦ Uso      ¦ TOTVS-GO                                                   ¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
*/

User Function FA050DES()

	Local aParcelas:=ParamixB
	Local aOldPar:=ParamixB
	Local lContinua:=.t.
	Local nTotParc:=0
	Local nY

	aHeader:={}
	aCols:={}

//	dbSelectArea("SX3")
//	dbSetOrder(2)
//	dbSeek("E1_VENCREA")	
//	AADD(aHeader,{"Vencimento"	,x3_campo,x3_picture,x3_tamanho,x3_decimal,".t.",x3_usado,x3_tipo,x3_arquivo})
//	dbSeek("E1_SALDO")
//	AADD(aHeader,{"Valor"	,x3_campo,x3_picture,x3_tamanho,x3_decimal,".t.",x3_usado,x3_tipo,x3_arquivo})

	AADD(aHeader,{	"Vencimento",;
					GetSx3Cache("E1_VENCREA","X3_CAMPO"),;
					GetSx3Cache("E1_VENCREA","X3_PICTURE"),;
					GetSx3Cache("E1_VENCREA","X3_TAMANHO"),;
					GetSx3Cache("E1_VENCREA","X3_DECIMAL"),;
					".T.",;
					GetSx3Cache("E1_VENCREA","X3_USADO"),;
					GetSx3Cache("E1_VENCREA","X3_TIPO"),;
					GetSx3Cache("E1_VENCREA","X3_ARQUIVO")})
					
	AADD(aHeader,{	"Valor",;
					GetSx3Cache("E1_SALDO","X3_CAMPO"),;
					GetSx3Cache("E1_SALDO","X3_PICTURE"),;
					GetSx3Cache("E1_SALDO","X3_TAMANHO"),;
					GetSx3Cache("E1_SALDO","X3_DECIMAL"),;
					".T.",;
					GetSx3Cache("E1_SALDO","X3_USADO"),;
					GetSx3Cache("E1_SALDO","X3_TIPO"),;
					GetSx3Cache("E1_SALDO","X3_ARQUIVO")})

	For nY := 1 To Len(aParcelas)
		aadd(aCols,{aParcelas[nY][1],aParcelas[nY][2],.f.})
	Next nY

	While lContinua
		DEFINE MSDIALOG oDlg TITLE OemToAnsi("Titulos a serem gerados") FROM 09,00 TO 28,60
		@ 005,004 TO 120,240 MULTILINE MODIFY object oMultiP
		DEFINE SBUTTON FROM 130 ,200 TYPE 1 PIXEL ACTION (oDlg:End()) ENABLE OF oDlg Pixel
		ACTIVATE MSDIALOG oDlg CENTERED

		For nY := 1 To Len(aCols)  //Valida
			nTotParc+=aCols[nY][2]
		Next nY
		if nTotParc=M->E2_VALOR
			aParcelas:={}
			For nY := 1 To Len(aCols)
				aadd(aParcelas,{aCols[nY][1],aCols[nY][2]})
			Next nY 
			lContinua := .F.
		else
			If IW_MsgBox("Abandona Ajuste do Desdobramento?","Valor Total Incorreto" , "YESNO",2)
				aParcelas:=aOldPar
				lContinua := .F.
			endif
			loop
		endif
	Enddo

Return aParcelas
