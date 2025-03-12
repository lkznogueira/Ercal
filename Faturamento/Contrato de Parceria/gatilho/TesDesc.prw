#INCLUDE "PROTHEUS.CH"

User Function TesDesc(cReadVar,xConteudo)

Local aArea     := GetArea()
Local lRetorno  := .T.
//Local nPosCpo   := 0
Local nPCodPro  := aScan(aHeader,{|x| Alltrim(x[2])=="ADB_CODPRO"})
Local nPQuant   := aScan(aHeader,{|x| Alltrim(x[2])=="ADB_QUANT"})
//Local nPPrUnit  := aScan(aHeader,{|x| Alltrim(x[2])=="ADB_PRUNIT"})
Local nPPrcVen  := aScan(aHeader,{|x| Alltrim(x[2])=="ADB_PRCVEN"})
Local nPTotal   := aScan(aHeader,{|x| Alltrim(x[2])=="ADB_TOTAL"})
//Local nPDesc    := aScan(aHeader,{|x| Alltrim(x[2])=="ADB_DESC"}) //aqui
//Local nPValDes  := aScan(aHeader,{|x| Alltrim(x[2])=="ADB_VALDES"}) //aqui
////Local cReadVar2 := ""
//importado do icms
Local vDesc := 0
LOCAL vIcm := 0
LOCAL cEST  := ' '  //Estado do Cliente
LOCAL cTIPc := ' '
LOCAL cGrup := ' '  //Grupo do Produto
LOCAL nDESC := 0
LOCAL cSafra := ' ' //MARCACAO QUE IGNORA CONTRATOS ANTIGOS 26/06/2022
Local nVlrUn := 0
Local nVlrau := 0
Local nFatConv := 0
Local nAliq  := 0
Local nTotat := 0
//LOCAL cFilAnt := SM0->M0_CODFIL
//LOCAL cEmpAnt := SM0->M0_CODIGO

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
IF SF4->F4_BASEICM == 0
	vIcm  := SF4->F4_BASEICM 
Else
	vIcm  := (100-SF4->F4_BASEICM)
EndIf
cEST  := SA1->A1_EST  //Estado do Cliente
cTIPc := SA1->A1_CONTRIB  //SE CONTRIBUINTE
cGrup := Posicione("SB1",1,xFilial("SB1")+trim(aCols[N][nPCodPro]),"B1_GRUPO")  //Grupo do Produto
cSafra := TRIM(M->ADA_CODSAF)
nVlrUn := 0

IF cSafra <> '000001'
	IF vIcm > 0 .And. cTIPc == '1' .And. cEST <> SuperGetMV("MV_ESTADO")
		IF cGrup == '0056' .OR.  cGrup == '0106' .OR. cGrup == '0108'
			IF cEmpAnt <> '50'//CALCULOS ERCAL

				IF cEST == 'PR' .OR. cEST== 'RS' .OR. cEST== 'RJ'.OR. cEST== 'SC' .OR. cEST== 'SP'
					IF DTos(ADA->ADA_EMISSA) <= '20230504'
						nDESC := 12
						vDesc := ROUND(((aCols[n,7] - ((aCols[n,7]*vIcm)/100))*nDESC/100),4)
					Else	
						nDESC := 0.88
						vDesc := ROUND((aCols[n,7]-(aCols[n,7]*nDESC)),4)//ROUND(((aCols[n,7] - ((aCols[n,7]*vIcm)/100))*nDESC/100),2)
					endIf
					MsgBox("CONTRIBUINTE FORA DO ESTADO, TERA DESCONTO DE R$: "+Alltrim(Transform(vDesc," @E 999,999.99"))+" na Nota fiscal!!!","AVISO!!!",)
				ELSE
					IF DTos(ADA->ADA_EMISSA) <= '20230504'
						nDESC := 7
						vDesc := ROUND(((aCols[n,7] - ((aCols[n,7]*vIcm)/100))*nDESC/100),4)
					Else	
						nDESC := 0.93
						vDesc := ROUND((aCols[n,7]-(aCols[n,7]*nDESC)),4)//ROUND(((aCols[n,7] - ((aCols[n,7]*vIcm)/100))*nDESC/100),2)
					endIf
					MsgBox("CONTRIBUINTE FORA DO ESTADO, TERA DESCONTO DE R$: "+Alltrim(Transform(vDesc," @E 999,999.99"))+" na Nota fiscal!!!","AVISO!!!",)
				ENDIF

			Else //CALCULO BRITACAL
				If trim(cFilAnt) == '2000' //se Calta TO
					nAliq := 12
						
						aCols[n,nPPrcVen] := Round( ((aCols[n,nPTotal]/(100-((nAliq*(vIcm/100))))*100)/aCols[N][nPQuant]), TamSX3("ADB_PRCVEN")[02] )
						aCols[n,nPTotal]  := Round( aCols[n,nPPrcVen] *  aCols[n,nPQuant] ,2)
						nTotadb := Round( aCols[n,nPPrcVen] *  aCols[n,nPQuant] ,2)
						aCols[n,nPPrcVen] := Round( aCols[n,nPTotal] / aCols[n,nPQuant], TamSX3("ADB_PRCVEN")[02] )
						
						MsgInfo("CONTRIBUINTE FORA DO ESTADO, TERA DESCONTO REF ICMS DESON DE R$: "+Alltrim(Transform((nTotadb-nTotat)," @E 999,999.99"))+" na Nota fiscal!!!")
				ElseIf trim(cFilAnt) == '1004' //Britacal 04 - Unai MG

					IF cEST == 'PR' .OR. cEST== 'RS' .OR. cEST== 'RJ'.OR. cEST== 'SC' .OR. cEST== 'SP'

						nAliq := 12
						
						aCols[n,nPPrcVen] := Round( ((aCols[n,nPTotal]/(100-((nAliq*(vIcm/100))))*100)/aCols[N][nPQuant]), TamSX3("ADB_PRCVEN")[02] )
						aCols[n,nPTotal]  := Round( aCols[n,nPPrcVen] *  aCols[n,nPQuant] ,2)
						nTotadb := Round( aCols[n,nPPrcVen] *  aCols[n,nPQuant] ,2)
						aCols[n,nPPrcVen] := Round( aCols[n,nPTotal] / aCols[n,nPQuant], TamSX3("ADB_PRCVEN")[02] )
						
						MsgInfo("CONTRIBUINTE FORA DO ESTADO, TERA DESCONTO REF ICMS DESON DE R$: "+Alltrim(Transform((nTotadb-nTotat)," @E 999,999.99"))+" na Nota fiscal!!!")
					ELSE
						nAliq := 7
						nTotat := aCols[n,nPTotal]
						aCols[n,nPPrcVen] := Round( ((aCols[n,nPTotal]/(100-((nAliq*(vIcm/100))))*100)/aCols[N][nPQuant]), TamSX3("ADB_PRCVEN")[02] )
						aCols[n,nPTotal]  := Round( aCols[n,nPPrcVen] *  aCols[n,nPQuant] ,2)
						nTotadb := Round( aCols[n,nPPrcVen] *  aCols[n,nPQuant] ,2)
						aCols[n,nPPrcVen] := Round( aCols[n,nPTotal] / aCols[n,nPQuant], TamSX3("ADB_PRCVEN")[02] )
						
						MsgInfo("CONTRIBUINTE FORA DO ESTADO, TERA DESCONTO REF ICMS DESON DE R$: "+Alltrim(Transform((nTotadb-nTotat)," @E 999,999.99"))+" na Nota fiscal!!!")
					ENDIF
				EndIf
			EndIf
		ENDIF

	ENDIF
ELSE
	//vDesc := aCols[n,16]
	MsgInfo("Este Cliente Contribuinte ja teve desconto anteriormente na Nota fiscal!!!")
ENDIF

/*
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
		aCols[N,nPPrUnit] := nVlrUn
		aCols[n,nPPrcVen] := FtDescItem(FtDescCab(aCols[n,nPPrUnit],{M->ADA_DESC1,M->ADA_DESC2,M->ADA_DESC3,M->ADA_DESC4}),@aCols[n,nPPrcVen],aCols[n,nPQuant],@aCols[n,nPTotal],@aCols[n,nPDesc],@xConteudo,aCols[n,nPValDes],2)
	Case "ADB_DESC" == cReadVar2
		aCols[N,nPPrUnit] := nVlrUn
		aCols[n,nPPrcVen] := FtDescItem(FtDescCab(aCols[n,nPPrUnit],{M->ADA_DESC1,M->ADA_DESC2,M->ADA_DESC3,M->ADA_DESC4}),@aCols[n,nPPrcVen],aCols[n,nPQuant],@aCols[n,nPTotal],@xConteudo,@aCols[n,nPValDes],@aCols[n,nPValDes],1)

	EndCase
EndIf
aCols[N][nPosCpo] := xConteudo
*/
RestArea(aArea)

Return(lRetorno)
