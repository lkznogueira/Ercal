#include "protheus.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ft400ped ºAutor  ³ Carlos Daniel   º Data ³  10/02/22       º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ tratar ajustes desconto atravez pe                         º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³    Alterado por Carlos Daniel							  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function ft400ped()
	Local _mArea    := {"ADA", "SA1", "SE4", "SA3","ADB","SF4"}
	Local _mAlias   := U_SalvaAmbiente(_mArea)

	Local vDesc  := 0
	LOCAL vIcm   := 0
	LOCAL cEST   := ' '  //Estado do Cliente
	LOCAL cTIPc  := ' '
	LOCAL cGrup  := Posicione("SB1",1,xFilial("SB1")+ADB->ADB_CODPRO,"B1_GRUPO")  //Grupo do Produto
	LOCAL nDESC  := 0
	Local cPCli  := aScan(aHeader,{|x| Alltrim(x[2])=="C6_NUMPCOM"})
	Local cPItem := aScan(aHeader,{|x| Alltrim(x[2])=="C6_ITEMPC"})
	//LOCAL nLtes := 0

//Ajuste Icms Desonerado 2025
	//Local nPCodPro  := aScan(aHeader,{|x| Alltrim(x[2])=="C6_PRODUTO"})
	//Local nPQuant   := aScan(aHeader,{|x| Alltrim(x[2])=="C6_QTDVEN"})
	//Local nPPrcVen  := aScan(aHeader,{|x| Alltrim(x[2])=="C6_PRCVEN"})
	//Local nPTotal   := aScan(aHeader,{|x| Alltrim(x[2])=="C6_VALOR"})
	//Local nPTes     := aScan(aHeader,{|x| Alltrim(x[2])=="C6_TES"})
//fim Ajuste
	SA1->(dbSetOrder(1))
	SA1->(dbSeek(xFilial("SA1")+ADA->ADA_CODCLI+ADA->ADA_LOJCLI))

	SE4->(dbSetOrder(1))
	SE4->(dbSeek(xFilial("SE4")+ADA->ADA_CONDPG))

	SA3->(dbSetOrder(1))
	SA3->(dbSeek(xFilial("SA3")+ADA->ADA_VEND1))

	ADB->(dbSetOrder(1))
	ADB->(dbSeek(xFilial("ADB")+ADA->ADA_NUMCTR+"01"))

	IF ADB->ADB_XTIPO == '50' .OR. ADB->ADB_XTIPO == '70' .OR. ADB->ADB_XTIPO == '81'
		SF4->(DbSetOrder(1))
		SF4->(DbSeek(xFilial("SF4")+ADB->ADB_TES) )                    //FILIAL+CODIGO
	ELSEIF ADB->ADB_XTIPO == '55' .OR. ADB->ADB_XTIPO == '85'
		SF4->(DbSetOrder(1))
		SF4->(DbSeek(xFilial("SF4")+ADB->ADB_TES) )                    //FILIAL+CODIGO	
	ENDIF

	//trata desconto ICMS desonerado Carlos Daniel
	IF SF4->F4_BASEICM == 0
		vIcm  := SF4->F4_BASEICM 
	Else
		vIcm  := (100-SF4->F4_BASEICM)
	EndIf
	//vIcm  := SF4->F4_BASEICM
	cEST  := SA1->A1_EST  //Estado do Cliente
	cTIPc := SA1->A1_CONTRIB  //SE CONTRIBUINTE

	IF vIcm > 0 .AND. cEmpAnt <> '50' //.AND. DTos(ADA->ADA_EMISSA) <= '20241231' // ajuste data icms 2025
		IF cTIPc == '1' .And. cEST <>'MG'  // SE CLIENTE FOR PRODUTO FORA DO ESTADO MG e grupo calcario
			IF cGrup == '0056' .OR.  cGrup == '0106' .OR. cGrup == '0108'
				IF cEST == 'PR' .OR. cEST== 'RS' .OR. cEST== 'RJ'.OR. cEST== 'SC' .OR. cEST== 'SP'
					IF DTos(ADA->ADA_EMISSA) <= '20230504'
						nDESC := 12
						vDesc := ROUND(((ADB->ADB_TOTAL - ((ADB->ADB_TOTAL*vIcm)/100))*nDESC/100),4)
					else
						nDESC := 0.88
						vDesc := ROUND((ADB->ADB_TOTAL-(ADB->ADB_TOTAL*nDESC)),4)
					EndIf
					//vDesc :=  vIcm
				ELSE
					IF DTos(ADA->ADA_EMISSA) <= '20230504'
						nDESC := 7
						vDesc := ROUND(((ADB->ADB_TOTAL - ((ADB->ADB_TOTAL*vIcm)/100))*nDESC/100),4)
					else
						nDESC := 0.93
						vDesc := ROUND((ADB->ADB_TOTAL-(ADB->ADB_TOTAL*nDESC)),4)
					EndIf
					//vDesc :=  vIcm
				ENDIF
			ENDIF
		ENDIF
	ENDIF
	/*
	nLtes := aCols[n,nPTes]
	IF DTos(ADA->ADA_EMISSA) >= '20241201' .AND. nLtes == '527' // ICMS DESON 2025
		nLTotal  := aCols[n,nPTotal]
		nLPrcVen := aCols[n,nPPrcVen]
		nLQuant  := aCols[n,nPQuant]
		U_cN527(vDesc,nLtes,vIcm, nPCodPro, nPQuant, nPPrcVen, nPTotal, cEST, nLTotal, nLPrcVen, nLQuant)
	EndIf
	*/
	If ADA->ADA_E_PED  <> ' '
		aCols[n,cPCli]  := ADA->ADA_E_PED
		aCols[n,cPItem] := "0001"
	EndIf
	M->C5_DESCONT := vDesc // validar

	U_VoltaAmbiente(_mAlias)

Return()
/*
//tes 527 pra gerar desconto do icms na nota mae
User Function cN527(vDesc,nLtes,vIcm, nPCodPro, nPQuant, nPPrcVen, nPTotal, cEST, nLTotal, nLPrcVen, nLQuant) 
				
If nLtes == '527' //apenas nota mae

	IF cEST == 'PR' .OR. cEST== 'RS' .OR. cEST== 'RJ'.OR. cEST== 'SC' .OR. cEST== 'SP'
//nLTotal, nLPrcVen, nLQuant
		nAliq    := 12		
		nTotat   := aCols[n,nPTotal]				
		nPPrcVen := Round( ((nLTotal/(100-((nAliq*(vIcm/100))))*100)/nLQuant), TamSX3("ADB_PRCVEN")[02] )
		nPTotal  := Round( nLPrcVen *  nLQuant ,2)
		nTotadb  := Round( nLPrcVen *  nLQuant ,2)
		nPPrcVen := Round( nLTotal / nLQuant, TamSX3("ADB_PRCVEN")[02] )
	ELSE
		nAliq    := 7
		nTotat   := aCols[n,nPTotal]				
		nPPrcVen := Round( ((nLTotal/(100-((nAliq*(vIcm/100))))*100)/nLQuant), TamSX3("ADB_PRCVEN")[02] )
		nPTotal  := Round( nLPrcVen *  nLQuant ,2)
		nTotadb  := Round( nLPrcVen *  nLQuant ,2)
		nPPrcVen := Round( nLTotal / nLQuant, TamSX3("ADB_PRCVEN")[02] )
		vDesc    := (nTotadb-nTotat)
	ENDIF
EndIf

Return(vDesc)
*/
