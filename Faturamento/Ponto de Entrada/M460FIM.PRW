#INCLUDE 'PROTHEUS.CH'
#include "TBICONN.CH"
#include "RWMAKE.CH"
#include "TOPCONN.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³M460FIM   ºAutor  ³Carlos Daniel       º Data ³  07/03/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³Atualiza campos no contas a receber                         º±±
±±º          ³Por Carlos Daniel  										  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico Ercal                                           º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function M460FIM()
	Local _AREA := GetArea()
	Local _DOC
	Local _SERIE
	Local _PEDIDO
	//Local _TOTDES
	//Local _TOTGER
	Local _DTEMIS
	//Local aParc


	// Local _aCab		:= {}
	// Local _aItens	:= {}
	// Local _nCount	:= 0
	// Local _cNumPed 	:= ""
	// Local _cTes		:= ""
	// Local _cObsPedido:=""
	// Local _cCondPag := ""
	// Local _lEmp		:= .F.
	// Local nPercSyn   := 0
	// Local _cTPPED   := ""

	Private lPrimeira	:= .T.
	Private xNumBor		:= ""

	_DOC	 	:= SD2->D2_DOC
	_SERIE	 	:= SF2->F2_PREFIXO
	_PEDIDO  	:= SD2->D2_PEDIDO
	_DTEMIS  	:= SD2->D2_EMISSAO
	nMoedaCor	:= SC5->C5_MOEDA

	DbSelectArea("SA1")
	DbSelectArea("SE1")
	SA1->(dbSetOrder(1))
	SE1->(dbSetOrder(1))
	SC5->(dbSetOrder(1))
	SA1->(dbSeek(xFilial("SA1")+SF2->F2_CLIENTE+SF2->F2_LOJA))
	SE1->(dbSeek(xFilial("SE1")+SF2->F2_PREFIXO+SF2->F2_DOC))
	SD2->(DbSetOrder(3), DbSeek( xFilial("SD2") + SF2->F2_DOC + SF2->F2_SERIE ) )
	SC5->(DbSetOrder(1),dbSeek(xFilial("SC5")+SD2->(D2_PEDIDO)),.F.)

	Do While SE1->E1_PREFIXO+SE1->E1_NUM+SE1->E1_CLIENTE+SE1->E1_LOJA == SF2->F2_PREFIXO+SF2->F2_DOC+SF2->F2_CLIENTE+SF2->F2_LOJA

		Reclock("SE1",.F.)
		SE1->E1_XBANCO  := SC5->C5_XBANCO
		SE1->E1_XFRETE  := SC5->C5_XDESP
		SE1->E1_XBLOCO  := SC5->C5_XPED

		If SF2->F2_TIPO == "N"
			SE1->E1_HIST	:= "NF NORMAL"

		ElseIf SF2->F2_TIPO == "C"
			SE1->E1_HIST	:= "NF COMPL PRECO"

		ElseIf SF2->F2_TIPO == "I"
			SE1->E1_HIST	:= "NF COMPL ICMS"

		ElseIf SF2->F2_TIPO == "P"
			SE1->E1_HIST	:= "NF COMPL IPI"
		EndIf

		SE1->(MsUnlock())
		SE1->(dbSkip())
	EndDo

	//gravar Marca na tabela SF2
	IF SC5->C5_XMARCA <> ' '
		If RecLock("SF2",.F.)
			SF2->F2_MARCA1 := Posicione("SX5", 1, xFilial("SX5")+ "80" + AllTrim(SC5->C5_XMARCA), "X5_DESCRI")
			SF2->( MsUnlock() )
		Endif
	EndIf
	//FIM gravacao Marca	
	
	If SC5->C5_FRETAUT>0
		// Preenche a tabela CDA AJUSTE APURAÇÃO // Claudio 25.06.15
		If !CDA->( DbSetOrder(1), MsSeek( xFilial("CDA") + "SSPEDS" + SF2->F2_SERIE + SF2->F2_DOC + SF2->F2_CLIENTE + SF2->F2_LOJA ) )

			If SD2->( DbSetOrder(3), DbSeek( xFilial("SD2") + SF2->F2_DOC + SF2->F2_SERIE ) )
				RecLock("CDA", .T.)
				CDA->CDA_FILIAL := xFilial("CDA")
				CDA->CDA_TPMOVI	:= "S"
				CDA->CDA_ESPECIE:= "SPED"
				CDA->CDA_FORMUL := "S"
				CDA->CDA_NUMERO	:= SD2->D2_DOC
				CDA->CDA_SERIE	:= SD2->D2_SERIE
				CDA->CDA_CLIFOR	:= SF2->F2_CLIENTE
				CDA->CDA_LOJA	:= SF2->F2_LOJA
				CDA->CDA_NUMITE := SD2->D2_ITEM
				CDA->CDA_SEQ	:= '0'+SD2->D2_ITEM
				CDA->CDA_CODLAN	:= 'MG71091014'
				CDA->CDA_CALPRO	:= '2'
				CDA->CDA_BASE	:= SC5->C5_FRETAUT
				CDA->CDA_ALIQ	:= SD2->D2_PICM
				CDA->CDA_VALOR	:= (SC5->C5_FRETAUT)*(CDA->CDA_ALIQ/100)
				CDA->CDA_IFCOMP	:= RIGHT(SD2->D2_DOC, 6)
				CDA->CDA_TPLANC	:= '2'
				CDA->CDA_CALPRO	:= '2'
				CDA->( DbUnLock() )
				cMensFis:='Icms Frete Aut.'+Alltrim(Transform(CDA->CDA_VALOR,"@e 999,999,999.99"))
				cMensFis+=' '+U_GetMsgFre(SD2->D2_DOC,SD2->D2_SERIE)

				RecLock("CCE", .T.)
				CCE->CCE_FILIAL := xFilial("CCE")
				CCE->CCE_COD	:= RIGHT(SD2->D2_DOC, 6)
				CCE->CCE_DESCR  := cMensFis
				CCE->( DbUnLock() )
			EndIf
		Endif
	Endif

	SA1->(dbSeek(xFilial("SA1")+SF2->F2_CLIENTE+SF2->F2_LOJA))
	SE1->(dbSeek(xFilial("SE1")+SF2->F2_PREFIXO+SF2->F2_DOC))

	//¦+---------------------------------------------------------+¦
	//¦¦Quando for cartão gera liquidação - 024 - CD ; 025 - CC  ¦¦
	//¦+---------------------------------------------------------+¦
	If Alltrim(SC5->C5_XBANCO) == "024" .Or. Alltrim(SC5->C5_XBANCO) == "025"
		U_MFAT300()
	EndIf

	//Chamada de geração de borderô automático e boleto
	//Raphael Ferreira - Oficina5
	geraBordAut()

	RestArea(_AREA)

Return()

/*/{Protheus.doc} M460FIM 
hamada de geração de borderô automático e boleto
@author Raphael Ferreira
@type function
@since 01/2025 
/*/
Static Function geraBordAut()

	Local lImpBol	:= .T.
	Local cPathBol	:= ""
	Local cParFim	:= ""

	Local oBordero	:= BordCR.BordCRAPI():New()

	If AllTrim(SC5->C5_XBANCO) $ AllTrim(GETMV( 'MV_PGTOBOL' ,, ''  )) .AND. cEmpAnt $ '01/02/06'
		
		DbSelectArea("SE1")
		DbSetOrder(1)
		If SE1->(dbSeek(xFilial("SE1")+SF2->F2_PREFIXO+SF2->F2_DOC))

			lImpBol 	:= .T.
			cPathBol	:= cGetFile( "Todos os arquivos|.", "Escolha a Pasta", 0, "C:\", .F., nOR(GETF_RETDIRECTORY,GETF_LOCALHARD ) , .T., .T.)

			Do While SE1->E1_PREFIXO+SE1->E1_NUM+SE1->E1_CLIENTE+SE1->E1_LOJA == SF2->F2_PREFIXO+SF2->F2_DOC+SF2->F2_CLIENTE+SF2->F2_LOJA

				cBanco		:= PADR( GETMV( 'O5_BORNBCO' ,, ''  ) , TamSX3('E1_PORTADO')[01])
				cAgencia	:= PADR( GETMV( 'O5_BORNAGE' ,, ''  ) , TamSX3('E1_AGEDEP')[01])
				cConta		:= PADR( GETMV( 'O5_BORNCTA' ,, ''  ) , TamSX3('E1_CONTA')[01])
				cNumSCt		:= PADR( GETMV( 'O5_BORNSCT' ,, ''  ) , TamSX3('EE_SUBCTA')[01])

				DbSelectArea("SEE")
				SEE->(DbSetOrder(1))
				SEE->(DbSeek(xFilial("SEE") + cBanco + cAgencia + cConta + cNumSCt))

				oBordero:cPrefixo   := SE1->E1_PREFIXO
				oBordero:cNumero    := SE1->E1_NUM //"000000123"
				oBordero:cParcela   := SE1->E1_PARCELA//"1"
				oBordero:cTipo      := SE1->E1_TIPO//"NF"
				oBordero:cBanco     := cBanco
				oBordero:cAgencia   := cAgencia
				oBordero:cConta     := cConta
				oBordero:cSituaca   := "1"
				oBordero:cNumBco    := SEE->EE_FAXATU
				oBordero:dDataMov   := dDataBase

				DbSelectArea("Z00")
				DbSetOrder(2)
				If !DbSeek(xFilial("Z00") + DToS(dDataBase))
					Processa( {|| oBordero:IncluiBordero()}, "Aguarde...","Gerando Borderô...",.F.)
				Else

					DbSelectArea("SEA")
					DbSetOrder(1)
					If DbSeek(xFilial("SEA") + Z00->Z00_NUMBOR)

						If Val(SubStr(Time(),1,2)) < 12 .AND. Z00->Z00_SEQ == 1
							lPrimeira	:= .T.
							xNumBor		:= Z00->Z00_NUMBOR
							Processa( {|| oBordero:AlteraBordero()}, "Aguarde...","Gerando Borderô...",.F.)
						Else
							DbSelectArea("Z00")
							DbSetOrder(2)
							If DbSeek(xFilial("Z00") + DToS(dDataBase) + "2")
								lPrimeira	:= .T.
								xNumBor		:= Z00->Z00_NUMBOR
								Processa( {|| oBordero:AlteraBordero()}, "Aguarde...","Gerando Borderô...",.F.)
							Else
								Processa( {|| oBordero:IncluiBordero()}, "Aguarde...","Gerando Borderô...",.F.)
							EndIf
						EndIf
					Else
						Reclock("Z00", .F.)
						DbDelete()
						MsUnlock()
						Processa( {|| oBordero:IncluiBordero()}, "Aguarde...","Gerando Borderô...",.F.)
					EndIf
				EndIf

				If lImpBol
					Processa( {|| U_BMFIN01(cNumSCt, cPathBol, .F. )}, "Aguarde...","Gerando Boleto...",.F.)
				EndIf

				cParFim	:= SE1->E1_PARCELA

				SE1->(dbSkip())

			EndDo

			SA1->(dbSeek(xFilial("SA1")+SF2->F2_CLIENTE+SF2->F2_LOJA))
			SE1->(dbSeek(xFilial("SE1")+SF2->F2_PREFIXO+SF2->F2_DOC))

			If !Empty(SA1->A1_EMAIL)
				Processa( {|| U_BMFIN01(cNumSCt, cPathBol, .F., .T.)}, "Aguarde...","Enviando Boleto por e-mail...",.F.)
			EndIf
		EndIf
	EndIf
Return()
