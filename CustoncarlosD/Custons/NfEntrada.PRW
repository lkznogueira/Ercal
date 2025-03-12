#Include "RwMake.Ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³NFENTRADA ºAutor  ³Carlos Daniel       º Data ³  04/06/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Busca informacoes da Nota Fiscal de Entrada                 º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Ercal Uberlandia                                           º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function NfEntrada()

	Local I

	dbSelectArea("SF1")					// * Cabecalho da Nota Fiscal Entrada
	dbSetOrder(1)	
	dbSeek(xFilial("SF1")+mv_par01+mv_par03,.t.)
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Inicializa Regua de Impressao                                ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	SetRegua(RecCount())
	  
	While !eof() .and. SF1->F1_DOC <= mv_par02 .and. lContinua .AND. SF1->F1_FILIAL == xFilial("SF1")
	
		xPESO_LIQUID	:= 0					// Peso Liquido da Nota Fiscal
		
		If SF1->F1_SERIE # mv_par03 .Or. SF1->F1_FORMUL <> "S" 	// Se a Serie do Arquivo for Diferente
			DbSkip()																					// do Parametro Informado !!!
			Loop
		Endif
	
			
		#IFNDEF WINDOWS
			IF LastKey()==286
				@ 00,01 PSAY "** CANCELADO PELO OPERADOR **"
				lContinua := .F.
				Exit
			Endif
		#ELSE
			IF lAbortPrint
				@ 00,01 PSAY "** CANCELADO PELO OPERADOR **"
				lContinua := .F.
				Exit
			Endif
		#ENDIF
		
		//+--------------------------------------------------------------+
		//¦ Inicio de Levantamento dos Dados da Nota Fiscal              ¦
		//+--------------------------------------------------------------+
		
		xNUM_NF     :=SF1->F1_DOC             // Numero
		xSERIE      :=SF1->F1_SERIE           // Serie
		xFORNECE    :=SF1->F1_FORNECE         // Cliente/Fornecedor
		xEMISSAO    :=SF1->F1_EMISSAO         // Data de Emissao
		xTOT_FAT    :=SF1->F1_VALBRUT         // Valor Bruto da Compra
		xLOJA       :=SF1->F1_LOJA            // Loja do Cliente
		xFRETE      :=SF1->F1_FRETE           // Frete
		xSEGURO     :=SF1->F1_DESPESA         // Despesa
		xBASE_ICMS  :=SF1->F1_BASEICM         // Base   do ICMS
		xBASE_IPI   :=SF1->F1_BASEIPI         // Base   do IPI
		xBSICMRET   :=SF1->F1_BRICMS          // Base do ICMS Retido
		xVALOR_ICMS :=SF1->F1_VALICM          // Valor  do ICMS
		xICMS_RET   :=SF1->F1_ICMSRET         // Valor  do ICMS Retido
		xVALOR_IPI  :=SF1->F1_VALIPI          // Valor  do IPI
		xVALOR_MERC :=SF1->F1_VALMERC         // Valor  da Mercadoria
		xNUM_DUPLIC :=SF1->F1_DUPL            // Numero da Duplicata
		xCOND_PAG   :=SF1->F1_COND            // Condicao de Pagamento
		xTIPO       :=SF1->F1_TIPO            // Tipo do Cliente
		xNFORI      :=SF1->F1_NFORI           // NF Original
		xPREF_DV    :=SF1->F1_SERIORI         // Serie Original
		
		dbSelectArea("SD1")                   // * Itens da N.F. de Compra
		dbSetOrder(1)
		dbSeek(xFilial("SD1")+xNUM_NF+xSERIE+xFORNECE+xLOJA)
		
		cPedAtu := SD1->D1_PEDIDO
		cItemAtu:= SD1->D1_ITEMPC
		
		xPEDIDO  :={}                         // Numero do Pedido de Compra
		xITEM_PED:={}                         // Numero do Item do Pedido de Compra
		xNUM_NFDV:={}                         // Numero quando houver devolucao
		xPREF_DV :={}                         // Serie  quando houver devolucao
		xICMS    :={}                         // Porcentagem do ICMS
		xCOD_PRO :={}                         // Codigo  do Produto
		xQTD_PRO :={}                         // Peso/Quantidade do Produto
		xPRE_UNI :={}                         // Preco Unitario de Compra
		xIPI     :={}                         // Porcentagem do IPI
		xPESOPROD:={}                         // Peso do Produto
		xVAL_IPI :={}                         // Valor do IPI
		xDESC    :={}                         // Desconto por Item
		xVAL_DESC:={}                         // Valor do Desconto
		xVAL_MERC:={}                         // Valor da Mercadoria
		xTES     :={}                         // TES
		xCF      :={}                         // Classificacao quanto natureza da Operacao
		xICMSOL  :={}                         // Base do ICMS Solidario
		xICM_PROD:={}                         // ICMS do Produto
		
		While !eof() .and. SD1->D1_DOC==xNUM_NF .and. SD1->D1_FILIAL == xFilial("SD1")
			If SD1->D1_SERIE #mv_par03        // Se a Serie do Arquivo for Diferente
				DbSkip()                      // do Parametro Informado !!!
				Loop
			Endif
			
			AADD(xPEDIDO ,SD1->D1_PEDIDO)           // Ordem de Compra
			AADD(xITEM_PED ,SD1->D1_ITEMPC)         // Item da O.C.
			AADD(xNUM_NFDV ,IIF(Empty(SD1->D1_NFORI),"",SD1->D1_NFORI))
			AADD(xPREF_DV  ,SD1->D1_SERIORI)        // Serie Original
			AADD(xICMS     ,IIf(Empty(SD1->D1_PICM),0,SD1->D1_PICM))
			AADD(xCOD_PRO  ,SD1->D1_COD)            // Produto
			AADD(xQTD_PRO  ,SD1->D1_QUANT)          // Guarda as quant. da NF
			AADD(xPRE_UNI  ,SD1->D1_VUNIT)          // Valor Unitario
			AADD(xIPI      ,SD1->D1_IPI)            // % IPI
			AADD(xVAL_IPI  ,SD1->D1_VALIPI)         // Valor do IPI
			AADD(xPESOPROD ,SD1->D1_PESO)           // Peso do Produto
			AADD(xDESC     ,SD1->D1_DESC)           // % Desconto
			AADD(xVAL_MERC ,SD1->D1_TOTAL)          // Valor Total
			AADD(xTES      ,SD1->D1_TES)            // Tipo de Entrada/Saida
			AADD(xCF       ,SD1->D1_CF)             // Codigo Fiscal
			AADD(xICM_PROD ,IIf(Empty(SD1->D1_PICM),0,SD1->D1_PICM))
			dbskip()
		End
		
		dbSelectArea("SB1")                     // * Desc. Generica do Produto
		dbSetOrder(1)
		xUNID_PRO:={}                           // Unidade do Produto
		xDESC_PRO:={}                           // Descricao do Produto
		xMEN_POS :={}                           // Mensagem da Posicao IPI
		xDESCRICAO :={}                         // Descricao do Produto
		xCOD_TRIB:={}                           // Codigo de Tributacao
		xMEN_TRIB:={}                           // Mensagens de Tributacao
		xCOD_FIS :={}                           // Cogigo Fiscal
		xCLAS_FIS:={}                           // Classificacao Fiscal
		xISS     :={}                           // Aliquota de ISS
		xTIPO_PRO:={}                           // Tipo do Produto
		xLUCRO   :={}                           // Margem de Lucro p/ ICMS Solidario
		xCLFISCAL   :={}
		xSUFRAMA :=""
		xCALCSUF :=""
		
		I:=1
		For I:=1 to Len(xCOD_PRO)
			
			dbSeek(xFilial("SB1")+xCOD_PRO[I])
			dbSelectArea("SB1")
			
			AADD(xDESC_PRO ,SB1->B1_DESC)
			AADD(xUNID_PRO ,SB1->B1_UM)
			AADD(xCOD_TRIB ,SB1->B1_ORIGEM)
			If Ascan(xMEN_TRIB, SB1->B1_ORIGEM)==0
				AADD(xMEN_TRIB ,SB1->B1_ORIGEM)
			Endif
			AADD(xDESCRICAO ,SB1->B1_DESC)
			AADD(xMEN_POS  ,SB1->B1_POSIPI)
			If SB1->B1_ALIQISS > 0
				AADD(xISS,SB1->B1_ALIQISS)
			Endif
			AADD(xTIPO_PRO ,SB1->B1_TIPO)
			AADD(xLUCRO    ,SB1->B1_PICMRET)
			
			npElem := ascan(xCLAS_FIS,SB1->B1_POSIPI)
			
			if npElem == 0
				AADD(xCLAS_FIS  ,SB1->B1_POSIPI)
			endif
			npElem := ascan(xCLAS_FIS,SB1->B1_POSIPI)
			
			DO CASE
				CASE npElem == 1
					_CLASFIS := "A"
					
				CASE npElem == 2
					_CLASFIS := "B"
					
				CASE npElem == 3
					_CLASFIS := "C"
					
				CASE npElem == 4
					_CLASFIS := "D"
					
				CASE npElem == 5
					_CLASFIS := "E"
					
				CASE npElem == 6
					_CLASFIS := "F"
					
			EndCase
			nPteste := Ascan(xCLFISCAL,_CLASFIS)
			If nPteste == 0
				AADD(xCLFISCAL,_CLASFIS)
			Endif
			AADD(xCOD_FIS ,_CLASFIS)
			
		Next
		
		//+---------------------------------------------+
		//¦ Pesquisa da Condicao de Pagto               ¦
		//+---------------------------------------------+
		
		dbSelectArea("SE4")                    // Condicao de Pagamento
		dbSetOrder(1)
		dbSeek(xFilial("SE4")+xCOND_PAG)
		xDESC_PAG := SE4->E4_DESCRI
		
		If xTIPO == "D"
			
			dbSelectArea("SA1")                // * Cadastro de Clientes
			dbSetOrder(1)
			dbSeek(xFilial("SA1")+xFORNECE)
			xCOD_CLI :=SA1->A1_COD             // Codigo do Cliente
			xNOME_CLI:=SA1->A1_NOME            // Nome
			xEND_CLI :=SA1->A1_END             // Endereco
			xBAIRRO  :=SA1->A1_BAIRRO          // Bairro
			xCEP_CLI :=SA1->A1_CEP             // CEP
			xCOB_CLI :=SA1->A1_ENDCOB          // Endereco de Cobranca
			xREC_CLI :=SA1->A1_ENDENT          // Endereco de Entrega
			xMUN_CLI :=SA1->A1_MUN             // Municipio
			xEST_CLI :=SA1->A1_EST             // Estado
			xCGC_CLI :=SA1->A1_CGC             // CGC
			xINSC_CLI:=SA1->A1_INSCR           // Inscricao estadual
			xTRAN_CLI:=SA1->A1_TRANSP          // Transportadora
			xTEL_CLI :=SA1->A1_TEL             // Telefone
			xFAX_CLI :=SA1->A1_FAX             // Fax
			
		Else
			
			dbSelectArea("SA2")                // * Cadastro de Fornecedores
			dbSetOrder(1)
			dbSeek(xFilial("SA2")+xFORNECE+xLOJA)
			xCOD_CLI :=SA2->A2_COD                // Codigo do Cliente
			xNOME_CLI:=SA2->A2_NOME               // Nome
			xEND_CLI :=SA2->A2_END                // Endereco
			xBAIRRO  :=SA2->A2_BAIRRO             // Bairro
			xCEP_CLI :=SA2->A2_CEP                // CEP
			xCOB_CLI :=""                         // Endereco de Cobranca
			xREC_CLI :=""                         // Endereco de Entrega
			xMUN_CLI :=SA2->A2_MUN                // Municipio
			xEST_CLI :=SA2->A2_EST                // Estado
			xCGC_CLI :=SA2->A2_CGC                // CGC
			xINSC_CLI:=SA2->A2_INSCR              // Inscricao estadual
			xTRAN_CLI:=SA2->A2_TRANSP             // Transportadora
			xTEL_CLI :=SA2->A2_TEL                // Telefone
			xFAX     :=SA2->A2_FAX                // Fax
			
		EndIf
		
		dbSelectArea("SE1")                   // * Contas a Receber
		dbSetOrder(1)
		xPARC_DUP  :={}                       // Parcela
		xVENC_DUP  :={}                       // Vencimento
		xVALOR_DUP :={}                       // Valor
		xDUPLICATAS:=IIF(dbSeek(xFilial("SE1")+xSERIE+xNUM_DUPLIC,.T.),.T.,.F.) // Flag p/Impressao de Duplicatas
		
		while !eof() .and. SE1->E1_NUM==xNUM_DUPLIC .and. xDUPLICATAS==.T.
			AADD(xPARC_DUP ,SE1->E1_PARCELA)
			AADD(xVENC_DUP ,SE1->E1_VENCTO)
			AADD(xVALOR_DUP,SE1->E1_VALOR)
			dbSkip()
		EndDo
		
		xNATUREZA := POSICIONE("SF4",1,XFILIAL("SF4")+XTES[1],"F4_TEXTO")             // Natureza da Operacao
		xNOME_TRANSP :=" "           // Nome Transportadora
		xEND_TRANSP  :=" "           // Endereco
		xMUN_TRANSP  :=" "           // Municipio
		xEST_TRANSP  :=" "           // Estado
		xVIA_TRANSP  :=" "           // Via de Transporte
		xCGC_TRANSP  :=" "           // CGC
		xTEL_TRANSP  :=" "           // Fone
		xTPFRETE     :=" "           // Tipo de Frete
		xVOLUME      := 0            // Volume
		xESPECIE     :=" "           // Especie
		xPESO_LIQ    := 0            // Peso Liquido
		xPESO_BRUTO  := 0            // Peso Bruto
		xCOD_MENS    :=" "           // Codigo da Mensagem
		xMENSAGEM    :=" "           // Mensagem da Nota
		
		
		U_ImprimeNF()
		
		//+--------------------------------------------------------------+
		//¦ Termino da Impressao da Nota Fiscal                          ¦
		//+--------------------------------------------------------------+
		
		IncRegua()                    // Termometro de Impressao
		
		dbSelectArea("SF1")
		dbSkip()                     // e passa para a proxima Nota Fiscal
		
	EndDo    
	
	dbSelectArea("SF1")
	Retindex("SF1")	
	dbSelectArea("SD1")
	Retindex("SD1")
	
Return
