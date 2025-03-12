#INCLUDE "PROTHEUS.CH"

User Function TesDesc(cReadVar,xConteudo)

	Local aArea     := GetArea()
	Local lRetorno  := .T.
	Local nPosCpo   := 0
	Local nPCodPro  := aScan(aHeader,{|x| Alltrim(x[2])=="ADB_CODPRO"})
//Local nPUM      := aScan(aHeader,{|x| Alltrim(x[2])=="ADB_UM"})
//Local nPSegUM   := aScan(aHeader,{|x| Alltrim(x[2])=="ADB_SEGUM"})
//Local nPTES     := aScan(aHeader,{|x| Alltrim(x[2])=="ADB_TES"})
//Local nPLocal   := aScan(aHeader,{|x| Alltrim(x[2])=="ADB_LOCAL"})
	Local nPQuant   := aScan(aHeader,{|x| Alltrim(x[2])=="ADB_QUANT"})
//Local nPQuant2  := aScan(aHeader,{|x| Alltrim(x[2])=="ADB_UNSVEN"})
	Local nPPrUnit  := aScan(aHeader,{|x| Alltrim(x[2])=="ADB_PRUNIT"})
	Local nPPrcVen  := aScan(aHeader,{|x| Alltrim(x[2])=="ADB_PRCVEN"})
	Local nPTotal   := aScan(aHeader,{|x| Alltrim(x[2])=="ADB_TOTAL"})
	Local nPDesc    := aScan(aHeader,{|x| Alltrim(x[2])=="ADB_DESC"}) //aqui
	Local nPValDes  := aScan(aHeader,{|x| Alltrim(x[2])=="ADB_VALDES"}) //aqui
//Local nDesPro   := aScan(aHeader,{|x| Alltrim(x[2])=="ADB_DESPRO"})
	Local cReadVar2 := ""
//importado do icms
	Local vDesc := 0
	LOCAL vIcm := 0
	LOCAL cEST  := ' '  //Estado do Cliente
	LOCAL cTIPc := ' '
	LOCAL cGrup := ' '  //Grupo do Produto
	LOCAL nDESC := 0
	LOCAL cSafra := ' ' //MARCACAO QUE IGNORA CONTRATOS ANTIGOS 26/06/2022

//TRATA TES INTELIGENTE CONTRATO

//aJUSTE iCMS DESONERADO
	SA1->(dbSetOrder(1))
	SA1->(dbSeek(xFilial("SA1")+M->ADA_CODCLI+M->ADA_LOJCLI))

	SE4->(dbSetOrder(1))
	SE4->(dbSeek(xFilial("SE4")+M->ADA_CONDPG))

	SA3->(dbSetOrder(1))
	SA3->(dbSeek(xFilial("SA3")+M->ADA_VEND1))

	SF4->(DbSetOrder(1))
	SF4->(DbSeek(xFilial("SF4")+_cTES) )                    //FILIAL+CODIGO

	//trata desconto ICMS desonerado Carlos Daniel
	vIcm  := SF4->F4_BASEICM
	cEST  := SA1->A1_EST  //Estado do Cliente
	cTIPc := SA1->A1_CONTRIB  //SE CONTRIBUINTE
	cGrup := Posicione("SB1",1,xFilial("SB1")+aCols[N][nPCodPro],"B1_GRUPO")  //Grupo do Produto
	cSafra := TRIM(M->ADA_CODSAF)

	IF cSafra <> '000001'
		IF vIcm > 0
			IF cTIPc == '1' .And. cEST <>'MG'  //SE CLIENTE FOR PRODUTO FORA DO ESTADO MG e grupo calcario
				IF cGrup == '0056' .OR.  cGrup == '0106' .OR. cGrup == '0108'
					IF cEST == 'PR' .OR. cEST== 'RS' .OR. cEST== 'RJ'.OR. cEST== 'SC' .OR. cEST== 'SP'
						nDESC := 12
						vDesc := ROUND(((aCols[n,7] - ((aCols[n,7]*vIcm)/100))*nDESC/100),2)
//						MsgBox("Este Cliente Contribuinte fora estado tera desconto de R$: "+Alltrim(Transform(vDesc," @E 999,999.99"))+" na Nota fiscal!!!","AVISO!!!",)
						//vDesc := vIcm
					ELSE
						nDESC := 7
						vDesc := ROUND(((aCols[n,7] - ((aCols[n,7]*vIcm)/100))*nDESC/100),2)
						//MsgBox("Este Cliente Contribuinte fora estado tera desconto de R$: "+Alltrim(Transform(vDesc," @E 999,999.99"))+" na Nota fiscal!!!","AVISO!!!",)
						//vDesc :=  vIcm
					ENDIF
				/*
				elseif cGrup == '0106' .And. cEST <>'MG'
					IF cEST == 'PR' .OR. cEST== 'RS' .OR. cEST== 'RJ'.OR. cEST== 'SC' .OR. cEST== 'SP'
						nDESC := 12
						vDesc := ROUND(((aCols[n,7] - ((aCols[n,7]*vIcm)/100))*nDESC/100),2)
						//MsgBox("Este Cliente Contribuinte fora estado tera desconto de R$: "+Alltrim(Transform(vDesc," @E 999,999.99"))+" na Nota fiscal!!!","AVISO!!!",)
						//ELSEIF cEST == 'MG'
						//nDESC := 18
						//	vDesc := ROUND(((aCols[n,7] - ((aCols[n,7]*vIcm)/100))*nDESC/100),2)
						//MsgBox("Este Cliente Contribuinte fora estado tera desconto de R$: "+Alltrim(Transform(vDesc," @E 999,999.99"))+" na Nota fiscal!!!","AVISO!!!",)
					ELSE
						nDESC := 7
						vDesc := ROUND(((aCols[n,7] - ((aCols[n,7]*vIcm)/100))*nDESC/100),2)
						//MsgBox("Este Cliente Contribuinte fora estado tera desconto de R$: "+Alltrim(Transform(vDesc," @E 999,999.99"))+" na Nota fiscal!!!","AVISO!!!",)
					ENDIF
				*/
				ENDIF

			ENDIF

		ENDIF
	ELSE
		vDesc := aCols[n,16]
		MsgBox("Este Cliente Contribuinte ja teve desconto anteriormente na Nota fiscal!!!","AVISO!!!",)
	ENDIF

	DEFAULT cReadVar  := AllTrim("M->ADB_VALDES")
	DEFAULT xConteudo := &(cValToChar(vDesc))

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Inicializa os campos interdependentes                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cReadVar2 := StrTran(cReadVar,"M->","")
	nPosCpo := aScan(aHeader,{|x| AllTrim(x[2])==cReadVar2})
	If nPosCpo<>0 .And. xConteudo <> aCols[N][nPosCpo]
		Do Case
		Case "ADB_VALDES" == cReadVar2
			aCols[n,nPPrcVen] := FtDescItem(FtDescCab(aCols[n,nPPrUnit],{M->ADA_DESC1,M->ADA_DESC2,M->ADA_DESC3,M->ADA_DESC4}),@aCols[n,nPPrcVen],aCols[n,nPQuant],@aCols[n,nPTotal],@aCols[n,nPDesc],@xConteudo,aCols[n,nPValDes],2)
		Case "ADB_DESC" == cReadVar2
			aCols[n,nPPrcVen] := FtDescItem(FtDescCab(aCols[n,nPPrUnit],{M->ADA_DESC1,M->ADA_DESC2,M->ADA_DESC3,M->ADA_DESC4}),@aCols[n,nPPrcVen],aCols[n,nPQuant],@aCols[n,nPTotal],@xConteudo,@aCols[n,nPValDes],@aCols[n,nPValDes],1)

		EndCase
	EndIf
	aCols[N][nPosCpo] := xConteudo
	RestArea(aArea)
Return(lRetorno)
