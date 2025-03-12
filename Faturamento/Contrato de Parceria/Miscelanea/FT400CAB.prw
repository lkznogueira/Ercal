#include "protheus.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³FT400CAB  ºAutor  ³ TOTVS GO           º Data ³  14/05/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Ponto de Entrada apos fazer a remessa do pedido de venda   º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³    Alterado por Carlos Daniel							  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function FT400CAB()
	Local _mArea    := {"ADA", "SA1", "SE4", "SA3","ADB","SF4"}
	Local _mAlias   := U_SalvaAmbiente(_mArea)

	//Local vDesc := 0
	//LOCAL vIcm := 0
	//LOCAL cEST  := ' '  //Estado do Cliente
	//LOCAL cTIPc := ' '
	//LOCAL cGrup := Posicione("SB1",1,xFilial("SB1")+ADB->ADB_CODPRO,"B1_GRUPO")  //Grupo do Produto
	//LOCAL nDESC := 0

	SA1->(dbSetOrder(1))
	SA1->(dbSeek(xFilial("SA1")+ADA->ADA_CODCLI+ADA->ADA_LOJCLI))

	SE4->(dbSetOrder(1))
	SE4->(dbSeek(xFilial("SE4")+ADA->ADA_CONDPG))

	SA3->(dbSetOrder(1))
	SA3->(dbSeek(xFilial("SA3")+ADA->ADA_VEND1))

	ADB->(dbSetOrder(1))
	ADB->(dbSeek(xFilial("ADB")+ADA->ADA_NUMCTR+"01"))

	//IF ADB->ADB_XTIPO == '50' .OR. ADB->ADB_XTIPO == '70'
//		SF4->(DbSetOrder(1))
	//	SF4->(DbSeek(xFilial("SF4")+ADB->ADB_TES) )                    //FILIAL+CODIGO
//	ELSEIF ADB->ADB_XTIPO == '55'
//		SF4->(DbSetOrder(1))
//		SF4->(DbSeek(xFilial("SF4")+ADB->ADB_TES) )                    //FILIAL+CODIGO	
//	ENDIF

	//trata desconto ICMS desonerado Carlos Daniel
//	vIcm  := SF4->F4_BASEICM
//	cEST  := SA1->A1_EST  //Estado do Cliente
//	cTIPc := SA1->A1_CONTRIB  //SE CONTRIBUINTE
/*
	IF vIcm > 0
		IF cTIPc == '1' .And. cEST <>'MG'  // SE CLIENTE FOR PRODUTO FORA DO ESTADO MG e grupo calcario
			IF cGrup == '0056' .OR.  cGrup == '0106'
				IF cEST == 'PR' .OR. cEST== 'RS' .OR. cEST== 'RJ'.OR. cEST== 'SC' .OR. cEST== 'SP'
					nDESC := 12
					vDesc := ((ADB->ADB_TOTAL - ((ADB->ADB_TOTAL*vIcm)/100))*nDESC/100)
					//vDesc :=  vIcm
				ELSE
					nDESC := 7
					vDesc := ((ADB->ADB_TOTAL - ((ADB->ADB_TOTAL*vIcm)/100))*nDESC/100)
					//vDesc :=  vIcm
				ENDIF
			ENDIF
		ENDIF
	ENDIF
	//FIM 
	*/
	M->C5_XNOMCLI := ADA->ADA_XNOMC
	M->C5_XPED    := ADA->ADA_XPED
	M->C5_NATUREZ := ADA->ADA_XNATUR
	M->C5_TPFRETE := ADA->ADA_TPFRET
	M->C5_FRETE   := ADA->ADA_XFRETE  //INCLUIDO FRETE
	M->C5_XDESP   := ADA->ADA_XDESP   //INCLUIDO VALOR DO FRENTE IMBUTIDO NO PRODUTO
	M->C5_CONTRA  := ADA->ADA_NUMCTR
	M->C5_ESPECI1 := ADA->ADA_ESPECI
	M->C5_VOLUME1 := ADA->ADA_VOLUME
	M->C5_XMARCA  := ADA->ADA_MARCA
	M->C5_PARC1   := ADA->ADA_XPARC1
	M->C5_PARC2   := ADA->ADA_XPARC2
	M->C5_PARC3   := ADA->ADA_XPARC3
	M->C5_PARC4   := ADA->ADA_XPARC4
	M->C5_DATA1   := ADA->ADA_XDATA1
	M->C5_DATA2   := ADA->ADA_XDATA2
	M->C5_DATA3   := ADA->ADA_XDATA3
	M->C5_DATA4   := ADA->ADA_XDATA4
	M->C5_XBANCO  := ADA->ADA_XBANCO
	M->C5_MENNOTA := ADA->ADA_XMENOT
	M->C5_XCOMPL  := ADA->ADA_XCOMPL
	M->C5_XDESPU  := ADA->ADA_XDESPU
	M->C5_XTIPO   := ADB->ADB_XTIPO
	U_VoltaAmbiente(_mAlias)

Return()
