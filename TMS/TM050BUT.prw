#include 'protheus.ch'
#include 'parmtype.ch'
#include 'Rwmake.ch'

user function TM050BUT()

	Local nOpcx := ParamIXB[1]
	Local aButtons := {}

	if nOpcx == 3 .OR. nOpcx == 4 .OR. nOpcx == 6 //inclusao

		AAdd(aButtons, {'XML' , {|| U_TM050XML() },"Importa XML","Importa XML"} )

	endif

return aButtons


User Function TM050XML()

	Local cError   := ""
	Local cWarning := ""
	Local oXml := NIl
	Local cFile := ""
	Local cDirSrv := '\dirdoc'
	Local cFileName := ""
	Local dEmissao, cNumNF, cSerNF, cCGCRem, cCGCDest, cProd, cDsProd, cInscriEst, nRecDest
	Local cEmbal, nPeso, nVlrTot, cCFOP, nVlrICMS, cChavNFE
	//Local nQtdVol, nKM
	Local lOK := .T., lLinOk := .T.
	Local cFilOrig, nX, nPos
	Local aSavAcols := aClone(aCols)
	Local cMaskFile := "Arquivos xml (*.xml) |*.XML | "
	Local lJaImp := .F.
	Local nI
	Static oDlg

	Private oNFe, oNF, oEmitente, oIdent, oDestino, oTotal, oTransp, oDet

	
	//If !Empty(M->DTC_CLIREM)
	nPos := Ascan(aHeader,{|x| AllTrim(x[2]) == "DTC_NUMNFC"})
	if len(aCols) > 1 .Or. !empty(aCols[1][nPos])
		//MsgInfo("Dados ja preenchidos!")
		//ReturNN
		lJaImp := .T.
	endif

	cFile := cGetFile( cMaskFile, "Selecione o arquivo.", 1, 'C:\', .F., nOR( GETF_LOCALHARD, GETF_LOCALFLOPPY ),.T., .T. )
	if empty(cFile)
		Return
	endif
	if UPPER(right(alltrim(cFile),3)) != "XML"
		MsgInfo("Selecione um arquivo do tipo *.XML","Atençao")
		return
	endif
	if !File(alltrim(cFile))
		MsgInfo("Arquivo não pode ser localizado.","Atençao")
		return
	endif

	nPos := RAt("\",cFile)
	if nPos == 0
		MsgInfo("Arquivo não pode ser localizado.","Atençao")
		Return
	endif

	//cFile := "C:\temp\teste.xml"
	cFileName := SubStr(cFile,nPos+1) //"teste.xml"

	if CpyT2S(cFile,cDirSrv,.T.)

		
		cFileSrv := cDirSrv+"\"+cFileName

		//Gera o Objeto XML
		oXml := XmlParserFile( cFileSrv, "_", @cError, @cWarning )

		if oXml <> Nil

			
			if !VldTag(oXml,{"_NFEPROC","_NFE"})
				MsgInfo("Arquivo XML nao compativel com NFE.","Atençao")
				Return
			endif

			oNFe	  := oXml:_NfeProc
			oNF       := oNFe:_NFe
			oEmitente := oNF:_InfNfe:_Emit
			oIdent    := oNF:_InfNfe:_IDE
			oDestino  := oNF:_InfNfe:_Dest
			oTotal    := oNF:_InfNfe:_Total
			oTransp   := oNF:_InfNfe:_Transp
			oDet      := oNF:_InfNfe:_Det
			oDet 	  := IIf(ValType(oDet)=="O",{oDet},oDet)


			dEmissao := STOD(StrTran(SubStr(oIdent:_dhEmi:Text ,1,10),'-',''))
			cNumNF := PadL(oIdent:_nNF:Text, 9, "0")
			cSerNF := PadR(oIdent:_serie:Text, 3)

			Do Case
				Case Type("oEmitente:_CNPJ")=="O"
					cCGCRem := oEmitente:_CNPJ:Text
				Case Type("oEmitente:_CPF")=="O"
					cCGCRem := oEmitente:_CPF:Text
			EndCase
			dbSelectArea("SA1")
			dbSetOrder(3)
			If Empty(M->DTC_CLIREM) .And. !Empty(AllTrim(cCGCRem))
				If MsSeek(xFilial("SA1")+cCGCRem)
					M->DTC_CLIREM := SA1->A1_COD
					M->DTC_LOJREM := SA1->A1_LOJA
					__readvar := "M->DTC_CLIREM"
					if !CheckSX3("DTC_CLIREM",M->DTC_CLIREM) //faz a validaçao do campo
						lOK := .F.
					else
						If ExistTrigger("DTC_CLIREM")
							RunTrigger(1,,,,"DTC_CLIREM")
						EndIf
					endif
				EndIf
			EndIf

			if lOK

				
				cFilOrig := GetFilByCGC(cCGCRem)

				Do Case
					Case Type("oDestino:_CNPJ")=="O"
						cCGCDest := oDestino:_CNPJ:Text
					Case Type("oDestino:_CPF")=="O"
						cCGCDest := oDestino:_CPF:Text
				EndCase
				cInscriEst := oDestino:_IE:Text
				dbSelectArea("SA1")
				dbSetOrder(3)
				If Empty(M->DTC_CLIDES) .And. !Empty(AllTrim(cCGCDest))
					If MsSeek(xFilial("SA1")+cCGCDest)
						//buscando pela incrição estadual
						nRecDest := SA1->(Recno())
						While SA1->(!Eof()) .AND. SA1->A1_FILIAL==xFilial("SA1") .AND. SA1->A1_CGC == cCGCDest
							if VldIE(SA1->A1_INSCR) == cInscriEst
								Exit
							endif
							SA1->(DbSkip())
						enddo
						if SA1->A1_CGC <> cCGCDest //volto para o primeiro caso nao encontre
							SA1->(DbGoTo(nRecDest))
						endif

						M->DTC_CLIDES := SA1->A1_COD
						M->DTC_LOJDES := SA1->A1_LOJA
						__readvar := "M->DTC_CLIDES"
						if !CheckSX3("DTC_CLIDES",M->DTC_CLIDES)
							lOK := .F.
						else
							If ExistTrigger("DTC_CLIDES")
								RunTrigger(1,,,,"DTC_CLIDES")
							EndIf
						endif
					EndIf
				EndIf

				if lOK //.AND. !empty(cFilOrig)

					
					nPeso := Val(IIf(VldTag(oTransp,{"_VOL","_PESOL"}),oTransp:_Vol:_PesoL:TEXT,""))
					cChavNFE := SubStr(oNF:_InfNfe:_ID:Text,4)

					if !lJaImp
						aCols:= {}
					endif

					for nX := 1 to len(oDet)

						nPesoQtd := Val(oDet[nX]:_Prod:_qTrib:Text)
						
						//buscando nota e pedido, para pegar KM e embalagem
						/*if nX==1
							//busco cliente na filial da NF origem
							If MsSeek(xFilial("SA1",cFilOrig)+cCGCDest)
								//buscando pela incrição estadual
								nRecDest := SA1->(Recno())
								While SA1->(!Eof()) .AND. SA1->A1_FILIAL==xFilial("SA1",cFilOrig) .AND. SA1->A1_CGC == cCGCDest
									if VldIE(SA1->A1_INSCR) == cInscriEst
										Exit
									endif
									SA1->(DbSkip())
								enddo
								if SA1->A1_CGC <> cCGCDest //volto para o primeiro caso nao encontre
									SA1->(DbGoTo(nRecDest))
								endif

								SD2->(DbSetOrder(3)) //D2_FILIAL+D2_DOC+D2_SERIE+D2_CLIENTE+D2_LOJA+D2_COD+D2_ITEM
								if SD2->(DBSeek(xFilial("SD2",cFilOrig)+cNumNF+cSerNF+SA1->A1_COD+SA1->A1_LOJA+Alltrim(oDet[nX]:_prod:_cProd:Text) ))
									SC5->(DbSetOrder(1))
									if !empty(SD2->D2_PEDIDO) .AND. SC5->(DbSeek(xFilial("SC5",cFilOrig)+SD2->D2_PEDIDO ))
										//nKM := SC5->C5_YKM * 2
										cEmbal := space(3)
										Do Case
											Case Alltrim(SC5->C5_ESPECI1) $ "GRANEL"
												cEmbal := "GR "
											Case Alltrim(SC5->C5_ESPECI1) $ "CAIXA"
												cEmbal := "CX "
											Case Alltrim(SC5->C5_ESPECI1) $ "TAMBOR"
												cEmbal := "TB "
											Case Alltrim(SC5->C5_ESPECI1) $ "UNIDADE"
												cEmbal := "UN "
										EndCase
									endif
								endif
							endif

							M->DTC_SELORI := "2" //Origem: CLIENTE REMETENTE
							__readvar := "M->DTC_SELORI"
							if !CheckSX3("DTC_SELORI",M->DTC_SELORI)
								lOK := .F.
							else
								If ExistTrigger("DTC_SELORI")
									RunTrigger(1,,,,"DTC_SELORI")
								EndIf
							endif

							M->DTC_DISTIV := "1" //Ida e Vlta = SIM
							__readvar := "M->DTC_DISTIV"
							if !CheckSX3("DTC_DISTIV",M->DTC_DISTIV)
								lOK := .F.
							else
								If ExistTrigger("DTC_DISTIV")
									RunTrigger(1,,,,"DTC_DISTIV")
								EndIf
							endif

							/*if !lJaImp .AND. !empty(nKM)
								M->DTC_KM := nKM
							//endif
						endif*/

						//busco produto pela descricao
						cDsProd := oDet[nX]:_prod:_xProd:Text
						cDsProd := Alltrim(STR(Val(cDsProd)))
						
						SA7->(DbSetOrder(3))
						If SA7->(dbSeek(xFilial("SA7")+SA1->A1_COD+SA1->A1_LOJA+cDsProd ))
							cProd := SA7->A7_PRODUTO
						Else
							cProd := Space(TamSX3("B1_COD")[1])

							@ 65,153 To 200,435 Dialog oDlg Title OemToAnsi("Inclusão Amarração")

							@ 09,009 Say OemToAnsi("Cliente:") Size 99,8
							@ 15,009 Say OemToAnsi( AllTrim(SA1->A1_COD+SA1->A1_LOJA) + "-" + AllTrim(Posicione("SA1",1,xFilial("SA1")+SA1->A1_COD+SA1->A1_LOJA,"A1_NOME"))) Size 200,8
							@ 28,009 Get cProd Picture "@!" F3 "SB1" VALID Existcpo("SB1",cProd) Size 59,10
							@ 52,059 BMPBUTTON TYPE 1 ACTION Close(oDlg)
							Activate Dialog oDlg CENTERED

							SA7->(DbSetOrder(1))
							if !Empty(cProd) .and. !SA7->(dbSeek(xFilial("SA7")+SA1->A1_COD+SA1->A1_LOJA+cProd )) 
								RecLock("SA7",.T.)
									SA7->A7_FILIAL 	:= xFilial("SA7")
									SA7->A7_CLIENTE	:= SA1->A1_COD
									SA7->A7_LOJA 	:= SA1->A1_LOJA
									SA7->A7_CODCLI  := cDsProd
									SA7->A7_PRODUTO := cProd
								SA7->( MsUnlock() )
							EndIf
						EndIf

						//cProd := Posicione("SB1",3,xFilial("SB1")+Alltrim(Upper(cDsProd)),"B1_COD") //B1_FILIAL+B1_DESC+B1_COD

						if !empty(cProd)

							nVlrTot := Val(oDet[nX]:_Prod:_vProd:TEXT)
							cCFOP := oDet[nX]:_Prod:_CFOP:Text
							nVlrICMS := GetVIcms(oDet[nX])

							If Len(aCols) > 0
								nPos := Ascan(aHeader,{|x| AllTrim(x[2]) == "DTC_NUMNFC"})
								If !Empty(aCols[n][nPos])
									//Cria uma nova linha em branco
									AAdd(aCols,Array(Len(aHeader)+1))
								EndIf
							Else
								//Cria uma nova linha em branco
								AAdd(aCols,Array(Len(aHeader)+1))
							EndIf

							n := Len(aCols)
							For nI:= 1 To Len(aHeader)
								If aHeader[nI,10] != "V"
									aCols[Len(aCols),nI]:= CriaVar(aHeader[nI,2])
								Else
									If aHeader[nI,2] == "DTC_ALI_WT"
										aCols[Len(aCols),nI]:= "DTC"
									ElseIf aHeader[nI,2] == "DTC_REC_WT"
										aCols[Len(aCols),nI]:= 0
									Else
										aCols[Len(aCols),nI]:= CriaVar(aHeader[nI,2])
									EndIf
								EndIf
							Next nI
							aCols[Len(aCols),Len(aHeader)+1] := .F.

							//numero da nota
							nPos := Ascan(aHeader,{|x| AllTrim(x[2]) == "DTC_NUMNFC"})
							aCols[n,nPos] := cNumNF
							M->DTC_NUMNFC := cNumNF
							__readvar:="M->DTC_NUMNFC"
							If !CheckSX3("DTC_NUMNFC",aCols[n,nPos])
								lLinOk := .F.
							EndIf

							//serie
							nPos := Ascan(aHeader,{|x| AllTrim(x[2]) == "DTC_SERNFC"})
							aCols[n,nPos] := cSerNF
							M->DTC_SERNFC := cSerNF
							__readvar:="M->DTC_SERNFC"
							If !CheckSX3("DTC_SERNFC",aCols[n,nPos])
								lLinOk := .F.
							EndIf

							//produto
							nPos := Ascan(aHeader,{|x| AllTrim(x[2]) == "DTC_CODPRO"})
							aCols[n,nPos] := cProd
							M->DTC_CODPRO := cProd //CriaVar( aHeader[nPos][2] )
							__readvar:="M->DTC_CODPRO"
							SB1->(DbSetOrder(1))
							If !CheckSX3(aHeader[nPos][2], aCols[n,nPos]) //!(ExistCpo("SB1",M->DTC_CODPRO) .And. TMSA050NF() .And. TMSA050Vld())
								lLinOk := .F.
							EndIf
							If ExistTrigger("DTC_CODPRO")
								RunTrigger(2,n,,o1Get,"DTC_CODPRO")
							EndIf

							//if !empty(cEmbal)
								nPos := Ascan(aHeader,{|x| AllTrim(x[2]) == "DTC_CODEMB"})
								aCols[n,nPos] := oDet[nX]:_Prod:_UCOM:Text
								M->DTC_CODEMB := oDet[nX]:_Prod:_UCOM:Text
								__readvar:="M->DTC_CODEMB"
								If !CheckSX3("DTC_CODEMB",aCols[n,nPos])
									aCols[n,nPos] := "   "
								EndIf
								If ExistTrigger("DTC_CODEMB")
									RunTrigger(2,n,,o1Get,"DTC_CODEMB")
								EndIf
							//endif

							//data emissao
							nPos := Ascan(aHeader,{|x| AllTrim(x[2]) == "DTC_EMINFC"})
							aCols[n,nPos] := dEmissao
							M->DTC_EMINFC := dEmissao
							__readvar:="M->DTC_EMINFC"
							If !CheckSX3("DTC_EMINFC",aCols[n,nPos])
								lLinOk := .F.
							EndIf

							//qtd volumes (sempre 1 a pedido do usuario)
							nPos := Ascan(aHeader,{|x| AllTrim(x[2]) == "DTC_QTDVOL"})
							aCols[n,nPos] := 1
							M->DTC_QTDVOL := 1
							__readvar:="M->DTC_QTDVOL"
							If !CheckSX3("DTC_QTDVOL",aCols[n,nPos])
								aCols[n,nPos]	:= 0
							EndIf

							//peso
							nPos := Ascan(aHeader,{|x| AllTrim(x[2]) == "DTC_PESO"})
							aCols[n,nPos] := nPesoqtd
							M->DTC_PESO := nPesoqtd
							__readvar:="M->DTC_PESO"
							If !CheckSX3("DTC_PESO",aCols[n,nPos])
								aCols[n,nPos]	:= 0
							EndIf

							//valor produto
							nPos := Ascan(aHeader,{|x| AllTrim(x[2]) == "DTC_VALOR"})
							aCols[n,nPos] := nVlrTot
							M->DTC_VALOR := nVlrTot
							__readvar:="M->DTC_VALOR"
							If !CheckSX3("DTC_VALOR",aCols[n,nPos])
								lLinOk := .F.
							EndIf

							//CFOP
							nPos := Ascan(aHeader,{|x| AllTrim(x[2]) == "DTC_CF"})
							aCols[n,nPos] := cCFOP
							M->DTC_CF := cCFOP
							__readvar:="M->DTC_CF"
							If !CheckSX3("DTC_CF",aCols[n,nPos])
								lLinOk := .F.
							EndIf

							//peso liquido
							nPos := Ascan(aHeader,{|x| AllTrim(x[2]) == "DTC_PESLIQ"})
							aCols[n,nPos] := nPeso
							M->DTC_PESLIQ := nPeso
							__readvar:="M->DTC_PESLIQ"
							If !CheckSX3("DTC_PESLIQ",aCols[n,nPos])
								aCols[n,nPos] := 0
							EndIf

							//valor icms
							nPos := Ascan(aHeader,{|x| AllTrim(x[2]) == "DTC_VALICM"})
							aCols[n,nPos] := nVlrICMS
							M->DTC_VALICM := nVlrICMS
							__readvar:="M->DTC_VALICM"
							If !CheckSX3("DTC_VALICM",aCols[n,nPos])
								aCols[n,nPos] := 0
							EndIf

							//-- Campo da NF-e
							nPos := Ascan(aHeader,{|x| AllTrim(x[2]) == "DTC_NFEID"})
							aCols[n,nPos] := cChavNFE
							M->DTC_NFEID := cChavNFE
							__readvar:="M->DTC_NFEID"
							If !CheckSX3("DTC_NFEID",aCols[n,nPos])
								lLinOk := .F.
							EndIf

							If !lLinOk
								aCols[n,Len(aHeader)+1] := .T.
							EndIf

						endif
					next nX

					//se nao foi possivel adicionar itens, restauro
					if empty(aCols)
						aCols := aClone(aSavAcols)
					endif

					o1Get:oBrowse:Refresh(.T.)
				endif
			endif
		endif

		FERASE(cFileSrv) //apago arquivo após leitura

	endif

Return


Static Function GetVIcms(_oImposto)

	Local aSitTrib      := {}
	Local aSitSN        := {}
	Local nY, nLenSit
	Local nValICM := 0
	Private oImposto := _oImposto

	aadd(aSitTrib,"00")
	aadd(aSitTrib,"10")
	aadd(aSitTrib,"20")
	aadd(aSitTrib,"30")
	aadd(aSitTrib,"40")
	aadd(aSitTrib,"41")
	aadd(aSitTrib,"50")
	aadd(aSitTrib,"51")
	aadd(aSitTrib,"60")
	aadd(aSitTrib,"70")
	aadd(aSitTrib,"90")
	aadd(aSitTrib,"PART")

	aadd(aSitSN,"101")
	aadd(aSitSN,"102")
	aadd(aSitSN,"201")
	aadd(aSitSN,"202")
	aadd(aSitSN,"500")
	aadd(aSitSN,"900")

	If VldTag(oImposto,{"_IMPOSTO","_ICMS"})
		nLenSit := Len(aSitTrib)
		For nY := 1 To nLenSit
			If VldTag(oImposto:_Imposto:_ICMS,{"_ICMS"+aSitTrib[nY], "_VICMS"})
				nValICM  := Val(&("oImposto:_Imposto:_ICMS:_ICMS"+aSitTrib[nY]+":_vICMS:TEXT"))
			EndIf
		Next nY

		//Tratamento para o ICMS para optantes pelo Simples Nacional
		If VldTag(oEmitente,{"_CRT"}) .And. oEmitente:_CRT:TEXT == "1"
			nLenSit := Len(aSitSN)
			For nY := 1 To nLenSit
				If VldTag(oImposto,{"_IMPOSTO","_ICMS","_ICMSSN"+aSitSN[nY],"_VICMS"})
					nValICM  := Val(&("oImposto:_Imposto:_ICMS:_ICMSSN"+aSitSN[nY]+":_vICMS:TEXT"))
				EndIf
			Next nY
		EndIf
	EndIf

Return nValICM


Static Function GetFilByCGC(cCGC)

	Local cRet := ""
	Local aAreaSM0 := SM0->(GetArea())
	Local nRecSM0 := SM0->(Recno())

	SM0->(DbSetOrder(1))
	SM0->(DbGoTop())
	SM0->(DbSeek(cempant)) //cempant EMPRESA QUE ESTÁ LOGADA
	While SM0->(!Eof()) .and. SM0->M0_CODIGO = cempant

		if SM0->(!Deleted()) .AND. SM0->M0_CGC == cCGC
			cRet := Alltrim(SM0->M0_CODFIL)
		endif

		SM0->(DbSkip())
	EndDo

	SM0->(DbGoTo(nRecSM0))
	RestArea(aAreaSM0)

Return cRet


Static Function VldTag(oObjIni, aTags)

	Local lRet := .T.
	Local oObjXml := oObjIni
	Local nX

	for nX := 1 to len(aTags)
		oObjXml := XmlChildEx(oObjXml,aTags[nX])
		if oObjXml == Nil
			lRet := .F.
			EXIT
		endif
	next nX

Return lRet

//ajusta campo inscriçao estadual para comparaçao (copiado do NFESEFAZ.prw)
Static Function VldIE(cInsc,lContr)

	Local cRet	:=	""
	Local nI	:=	1
	DEFAULT lContr  :=      .T.
	For nI:=1 To Len(cInsc)
		If Isdigit(Subs(cInsc,nI,1)) .Or. IsAlpha(Subs(cInsc,nI,1))
			cRet+=Subs(cInsc,nI,1)
		Endif
	Next
	cRet := AllTrim(cRet)
	If "ISENT"$Upper(cRet)
		cRet := ""
	EndIf
	If lContr .And. Empty(cRet)
		cRet := "ISENTO"
	EndIf
	If !lContr
		cRet := ""
	EndIf

Return(cRet)
