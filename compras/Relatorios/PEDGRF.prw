#include "PROTHEUS.CH"
#include 'topconn.ch'

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหออออออัอออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ PEDGRF   บAutor ณCarlos Daniel da Silvaบ Data ณ  08/07/13  บฑฑ
ฑฑฬออออออออออุออออออออออสออออออฯอออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ PEDIDO DE COMPRAS (Emissao em formato Grafico)             บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Compras                                                    บฑฑ
ฑฑฬออออออออออุออออออออออัอออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบDATA      ณ ANALISTA ณ MOTIVO                                          บฑฑ
ฑฑฬออออออออออุออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ          ณ          ณ                                                 บฑฑ
ฑฑศออออออออออฯออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

// alterar o parametro MV_PCOMPRA e colocar PEDGRF para substituir a impressใo padrใo.

User Function PEDGRF()
Private	lEnd		:= .f.,;
		aAreaSC7	:= SC7->(GetArea()),;
		aAreaSA2	:= SA2->(GetArea()),;
		aAreaSA5	:= SA5->(GetArea()),;   
		aAreaSF4	:= SF4->(GetArea()),;
	 	cPerg		:= Padr('PEDGRF',10)
   
// Declaracao da variaveis

	Private	cNumPed  		// Numero do Pedido de Compras
	Private	lImpPrc			// Imprime os Precos ?
	Private	nTitulo 		// Titulo do Relatorio ?
	Private	cObserv1		// 1a Linha de Observacoes
	Private	cObserv2		// 2a Linha de Observacoes
	Private	cObserv3		// 3a Linha de Observacoes
	Private	cObserv4		// 4a Linha de Observacoes
	Private	lPrintCodFor


	 	//	aAreaSZF	:= SZF->(GetArea()),;


		// Se a Impressใo Nใo Vier da Tela de Pedido de Compras entใo Efetua Pergunta de Parโmetros
		// Caso contrแrio entใo posiciona no pedido que foi clicado a op็ใo imprimir.

		If Upper(ProcName(2)) <> 'A120IMPRI'
           	If !Pergunte(cPerg,.t.)
           		Return
           	Endif

				cNumPed  	:= mv_par01			// Numero do Pedido de Compras
				lImpPrc		:= (mv_par02==2)	// Imprime os Precos ?
				nTitulo 	:= mv_par03			// Titulo do Relatorio ?
				cObserv1	:= mv_par04			// 1a Linha de Observacoes
				cObserv2	:= mv_par05			// 2a Linha de Observacoes
				cObserv3	:= mv_par06			// 3a Linha de Observacoes
				cObserv4	:= mv_par07			// 4a Linha de Observacoes
				lPrintCodFor:= (mv_par08==1)	// Imprime o Cvvvvvvvvvvvvvvvvvvvvvvvvvvvodigo do produto no fornecedor ?

  		Else

				cNumPed  	:= SC7->C7_NUM		// Numero do Pedido de Compras
				lImpPrc		:= .t.	// Imprime os Precos ?
				nTitulo 	:= 2			// Titulo do Relatorio ?
				cObserv1	:= ''			// 1a Linha de Observacoes
				cObserv2	:= ''			// 2a Linha de Observacoes
				cObserv3	:= ''			// 3a Linha de Observacoes
				cObserv4	:= ''			// 4a Linha de Observacoes
				lPrintCodFor:= .f.	// Imprime o Codigo do produto no fornecedor ?
  		Endif


		DbSelectArea('SC7')
		SC7->(DbSetOrder(1))
		If	( ! SC7->(DbSeek(xFilial('SC7') + cNumPed)) )
			Help('',1,'PEDGRF',,OemToAnsi('Pedido nใo encontrado.'),1)
			Return .f.
		EndIf

		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณExecuta a rotina de impressao ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		Processa({ |lEnd| xPrintRel(),OemToAnsi('Gerando o relat๓rio.')}, OemToAnsi('Aguarde...'))
		
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณRestaura a area anterior ao processamento. !ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		RestArea(aAreaSC7)
		RestArea(aAreaSA2)
		RestArea(aAreaSA5)
	 //	RestArea(aAreaSZF)
		RestArea(aAreaSF4)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหออออออัอออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ xPrintRelบAutor ณCarlos Daniel da Silvaบ Data ณ  08/07/13  บฑฑ
ฑฑฬออออออออออุออออออออออสออออออฯอออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Imprime a Duplicata...                                     บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Funcao Principal                                           บฑฑ
ฑฑฬออออออออออุออออออออออัอออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบDATA      ณ ANALISTA ณ MOTIVO                                          บฑฑ
ฑฑฬออออออออออุออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ          ณ          ณ                                                 บฑฑ
ฑฑศออออออออออฯออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function xPrintRel()

Local _nT
Local cTpFret := " "

Private	oPrint		:= TMSPrinter():New(OemToAnsi('Pedido de Compras')),;
		oBrush		:= TBrush():New(,4),;
		oPen		:= TPen():New(0,5,CLR_BLACK),;
		cFileLogo	:= GetSrvProfString('Startpath','') + 'ercal' + '.png',;
		oFont07		:= TFont():New('Courier New',07,07,,.F.,,,,.T.,.F.),;
		oFont08		:= TFont():New('Courier New',08,08,,.F.,,,,.T.,.F.),;
		oFont09		:= TFont():New('Tahoma',09,09,,.F.,,,,.T.,.F.),;
		oFont10		:= TFont():New('Tahoma',10,10,,.F.,,,,.T.,.F.),;
		oFont10n	:= TFont():New('Courier New',10,10,,.T.,,,,.T.,.F.),;
		oFont11		:= TFont():New('Tahoma',11,11,,.F.,,,,.T.,.F.),;
		oFont12		:= TFont():New('Tahoma',09,09,,.T.,,,,.T.,.F.),;
		oFont12n	:= TFont():New('Tahoma',09,09,,.F.,,,,.T.,.F.),;
		oFont13		:= TFont():New('Tahoma',13,13,,.T.,,,,.T.,.F.),;
		oFont14		:= TFont():New('Tahoma',14,14,,.T.,,,,.T.,.F.),;
		oFont15		:= TFont():New('Courier New',15,15,,.T.,,,,.T.,.F.),;
		oFont18		:= TFont():New('Arial',18,18,,.T.,,,,.T.,.T.),;
		oFont16		:= TFont():New('Arial',14,14,,.T.,,,,.T.,.F.),;
		oFont20		:= TFont():New('Arial',20,20,,.F.,,,,.T.,.F.),;
		oFont22		:= TFont():New('Arial',22,22,,.T.,,,,.T.,.F.)

	oPrint:Setup()
	
	If cEmpAnt <> '50' 
		cFileLogo	:= GetSrvProfString('Startpath','') + 'ercal' + '.png'
	Else
		If SUBSTR(trim(cFilAnt),1,2) == '10'
			cFileLogo	:= GetSrvProfString('Startpath','') + 'Britacal' + '.png'
		ElseIf SUBSTR(trim(cFilAnt),1,2) == '20'
			cFileLogo	:= GetSrvProfString('Startpath','') + 'Calta' + '.png'
		ElseIf SUBSTR(trim(cFilAnt),1,2) == '30'
			cFileLogo	:= GetSrvProfString('Startpath','') + 'Emfol' + '.png'
		ElseIf SUBSTR(trim(cFilAnt),1,2) == '40'
			cFileLogo	:= GetSrvProfString('Startpath','') + 'Americal' + '.png'
		EndIf
	EndIf
	//If !File(cFileLogo)
	//	cFileLogo := "ercal.png"
	//EndIf

Private	lFlag		:= .t.,;	// Controla a impressao do fornecedor
		nLinha		:= 3000,;	// Controla a linha por extenso
		nLinFim		:= 0,;		// Linha final para montar a caixa dos itens
		lPrintDesTab:= .f.,;	// Imprime a Descricao da tabela (a cada nova pagina)
		cRepres		:= Space(80)

Private	_nQtdReg	:= 0,;		// Numero de registros para intruir a regua
		_nValMerc 	:= 0,;		// Valor das mercadorias
		_nValIPI	:= 0,;		// Valor do I.P.I.
		_nValDesc	:= 0,;		// Valor de Desconto
		_nTotAcr	:= 0,;		// Valor total de acrescimo
		_nTotSeg	:= 0,;		// Valor de Seguro
		_nTotFre	:= 0,;		// Valor de Frete
		_nTotIcmsRet:= 0		// Valor do ICMS Retido        
		cAprov := ""  //Aprovador da SC

		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณPosiciona nos arquivos necessarios. !ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		DbSelectArea('SA2')
		SA2->(DbSetOrder(1))
		If	! SA2->(DbSeek(xFilial('SA2')+SC7->(C7_FORNECE+C7_LOJA)))
			Help('',1,'REGNOIS')
			Return .f.
		EndIf
		
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณDefine que a impressao deve ser RETRATOณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		oPrint:SetPortrait()

		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณMonta query !ณ    //SC7.C7_CODPRF, 
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤู
		cSELECT :=	'SC7.C7_FILIAL, SC7.C7_NUM, SC7.C7_EMISSAO, SC7.C7_FORNECE, SC7.C7_LOJA, SC7.C7_COND, SC7.C7_CONTATO, SC7.C7_OBS, '+;
					'SC7.C7_ITEM, SC7.C7_UM, SC7.C7_PRODUTO, SC7.C7_DESCRI, SC7.C7_QUANT, '+;
					'SC7.C7_PRECO, SC7.C7_IPI, SC7.C7_TOTAL, SC7.C7_VLDESC, SC7.C7_DESPESA, '+;
					'SC7.C7_SEGURO, SC7.C7_VALFRE, SC7.C7_TES, SC7.C7_ICMSRET, SC7.C7_DATPRF '

		cFROM   :=	RetSqlName('SC7') + ' SC7 '

		cWHERE  :=	'SC7.D_E_L_E_T_ <>   '+CHR(39) + '*'            +CHR(39) + ' AND '+;
					'SC7.C7_FILIAL  =    '+CHR(39) + xFilial('SC7') +CHR(39) + ' AND '+;
					'SC7.C7_NUM     =    '+CHR(39) + cNumPed        +CHR(39) 

		cORDER  :=	'SC7.C7_FILIAL, SC7.C7_ITEM '

		cQuery  :=	' SELECT '   + cSELECT + ; 
					' FROM '     + cFROM   + ;
					' WHERE '    + cWHERE  + ;
					' ORDER BY ' + cORDER

		TCQUERY cQuery NEW ALIAS 'TRA'   
		
		TcSetField('TRA','C7_DATPRF','D')

		If	! USED()
			MsgBox(cQuery+'. Query errada','Erro!!!','STOP')
		EndIf

		DbSelectArea('TRA')
		Count to _nQtdReg
		ProcRegua(_nQtdReg)
		TRA->(DbGoTop())

		
      cObServ := ''
		While 	TRA->( ! Eof() )

				xVerPag()

				If	( lFlag )
					//ฺฤฤฤฤฤฤฤฤฤฤฟ
					//ณFornecedorณ
					//ภฤฤฤฤฤฤฤฤฤฤู
					oPrint:Say(0530,0100,OemToAnsi('Fornecedor:'),oFont10)
					oPrint:Say(0520,0430,AllTrim(SA2->A2_NOME) + '  ('+AllTrim(SA2->A2_COD)+'/'+AllTrim(SA2->A2_LOJA)+')',oFont13)
					oPrint:Say(0580,0100,OemToAnsi('CNPJ/CPF:'),oFont10)
					oPrint:Say(0580,0430,Iif(Len(AllTrim(SA2->A2_CGC)) <= 11,TransForm(SA2->A2_CGC,"@R 999.999.999-99"),TransForm(SA2->A2_CGC,"@R 99.999.999/9999-99")),oFont13)
					//oPrint:Say(0630,0100,OemToAnsi('Municํpio/U.F.:'),oFont10)
					//oPrint:Say(0630,0430,AllTrim(SA2->A2_MUN)+'/'+AllTrim(SA2->A2_EST),oFont11)
					oPrint:Say(0630,0100,OemToAnsi('Endere็o:'),oFont10) // Carlos Daniel ajuste
					oPrint:Say(0630,0430,SA2->A2_END,oFont11)
					oPrint:Say(0630,1200,OemToAnsi('Cep:'),oFont10)
					oPrint:Say(0630,1370,TransForm(SA2->A2_CEP,'@R 99.999-999'),oFont11)
					oPrint:Say(0680,0100,OemToAnsi('Telefone:'),oFont10)
					oPrint:Say(0680,0430,SA2->A2_TEL,oFont11)
					oPrint:Say(0680,1200,OemToAnsi('Cidade:'),oFont10)
					oPrint:Say(0680,1370,AllTrim(SA2->A2_MUN)+'/'+AllTrim(SA2->A2_EST),oFont11)
					oPrint:Say(0730,0100,OemToAnsi('Numero SC:'),oFont10)
					oPrint:Say(0730,0430,SC7->C7_NUMSC,oFont13)
					oPrint:Say(0730,1200,OemToAnsi('Email:'),oFont10)
					oPrint:Say(0730,1370,SA2->A2_EMAIL,oFont11)

					//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
					//ณNumero/Emissaoณ
					//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
					oPrint:Box(0530,1900,0730,2300)
  //					oPrint:FillRect({0530,1900,0730,2300},oBrush)
					oPrint:Say(0545,1960,OemToAnsi('Pedido de Compra'),oFont11) //('Pedido de Compra'),oFont08) Cairo
					oPrint:Say(0580,2000,SC7->C7_NUM,oFont18)
					oPrint:Say(0660,2000,Dtoc(SC7->C7_EMISSAO),oFont12)         
					cAprov:=Posicione('SC1',1,xFilial('SC1')+SC7->C7_NUMSC,'C1_NOMAPRO')
					lFlag := .f.
				EndIf
				
				If	( lPrintDesTab )
					oPrint:Line(nLinha,100,nLinha,2300) 
					oPrint:Line(nLinha,100,nLinha+70,100) // Item
					oPrint:Line(nLinha,170,nLinha+70,170) // Codigo
					oPrint:Line(nLinha,310,nLinha+70,310) // Descricao
					oPrint:Line(nLinha,850,nLinha+70,850) // Un 1200
					oPrint:Line(nLinha,950,nLinha+70,950) // Entrega 1300
					oPrint:Line(nLinha,1150,nLinha+70,1150) // Qtde 1455
					oPrint:Line(nLinha,1400,nLinha+70,1400) // Unit 1610
					oPrint:Line(nLinha,1640,nLinha+70,1640) // Ipi 1850 
					oPrint:Line(nLinha,1790,nLinha+70,1790) // Total2000
					oPrint:Line(nLinha,2300,nLinha+70,2300) //2300

					oPrint:Say(nLinha,0120,OemToAnsi('It'),oFont12)
					oPrint:Say(nLinha,0180,OemToAnsi('C๓digo'),oFont12)
					oPrint:Say(nLinha,0320,OemToAnsi('Descri็ใo'),oFont12)
					oPrint:Say(nLinha,0860,OemToAnsi('Un'),oFont12)
					oPrint:Say(nLinha,0960,OemToAnsi('Entrg'),oFont12)
					oPrint:Say(nLinha,1160,OemToAnsi('Qtde'),oFont12)
					oPrint:Say(nLinha,1410,OemToAnsi('Vlr.Unit.'),oFont12)
					oPrint:Say(nLinha,1650,OemToAnsi('Ipi %'),oFont12)
					oPrint:Say(nLinha,1800,OemToAnsi('Valor Total'),oFont12)
					lPrintDesTab := .f.
					nLinha += 70
					oPrint:Line(nLinha,100,nLinha,2300)
				EndIf

				oPrint:Line(nLinha,100,nLinha,2300) 
				oPrint:Line(nLinha,100,nLinha+70,100) // Item
				oPrint:Line(nLinha,170,nLinha+70,170) // Codigo
				oPrint:Line(nLinha,310,nLinha+70,310) // Descricao
				oPrint:Line(nLinha,850,nLinha+70,850) // Un 1200
				oPrint:Line(nLinha,950,nLinha+70,950) // Entrega 1300
				oPrint:Line(nLinha,1150,nLinha+70,1150) // Qtde 1455
				oPrint:Line(nLinha,1400,nLinha+70,1400) // Unit 1610
				oPrint:Line(nLinha,1640,nLinha+70,1640) // Ipi 1850 
				oPrint:Line(nLinha,1790,nLinha+70,1790) // Total2000
				oPrint:Line(nLinha,2300,nLinha+70,2300) //2300

				oPrint:Say(nLinha,0120,Right(TRA->C7_ITEM,2),oFont12n)
				If	( lPrintCodFor )
					DbSelectArea('SA5')
					SA5->(DbSetOrder(1))
					If	SA5->(DbSeek(xFilial('SA5') + SA2->A2_COD + SA2->A2_LOJA + TRA->C7_PRODUTO)) .and. ( ! Empty(SA5->A5_CODPRF) )
						oPrint:Say(nLinha,0180,SA5->A5_CODPRF,oFont12n)
					Else
						oPrint:Say(nLinha,0180,TRA->C7_PRODUTO,oFont12n)
					EndIf
				Else
					oPrint:Say(nLinha,0180,TRA->C7_PRODUTO,oFont12n)
				EndIf	
				oPrint:Say(nLinha,860,TRA->C7_UM,oFont10)
				oPrint:Say(nLinha,1050,Left(DtoC(TRA->C7_DATPRF),5),oFont10n,,,,1)
				oPrint:Say(nLinha,1400,AllTrim(TransForm(TRA->C7_QUANT,'@E 999,999.9999')),oFont10n,,,,1)

				If	( lImpPrc )
					oPrint:Say(nLinha,1600,AllTrim(TransForm(TRA->C7_PRECO,'@E 999,999.9999')),oFont12n,,,,1)
					oPrint:Say(nLinha,1780,AllTrim(TransForm(TRA->C7_IPI,'@E 99.99')),oFont12n,,,,1)
					oPrint:Say(nLinha,1950,AllTrim(TransForm(TRA->C7_TOTAL,'@E 999,999,999.99')),oFont12n,,,,1)
				EndIf

				SB1->(dbSetOrder(1), dbSeek(xFilial("SB1")+TRA->C7_PRODUTO))
				If !SB5->(dbSetOrder(1), dbSeek(xFilial("SB5")+TRA->C7_PRODUTO))
					cDesc := AllTrim(SB1->B1_DESC)
				Else
					cDesc := AllTrim(SB5->B5_CEME)
				Endif
				

				_nLinhas := MlCount(cDesc,35) //Conta linhas descricao produto
				For _nT := 1 To _nLinhas

					oPrint:Line(nLinha,100,nLinha+70,100) // Item
					oPrint:Line(nLinha,170,nLinha+70,170) // Codigo
					oPrint:Line(nLinha,310,nLinha+70,310) // Descricao
					oPrint:Line(nLinha,850,nLinha+70,850) // Un 1200
					oPrint:Line(nLinha,950,nLinha+70,950) // Entrega 1300
					oPrint:Line(nLinha,1150,nLinha+70,1150) // Qtde 1455
					oPrint:Line(nLinha,1400,nLinha+70,1400) // Unit 1610
					oPrint:Line(nLinha,1640,nLinha+70,1640) // Ipi 1850 
					oPrint:Line(nLinha,1790,nLinha+70,1790) // Total2000
					oPrint:Line(nLinha,2300,nLinha+70,2300) //2300
					oPrint:Say(nLinha,0320,Capital(MemoLine(cDesc,35,_nT)),oFont10,,0)
					nLinha+=40
				Next _nT

				nLinha += 30
				oPrint:Line(nLinha,100,nLinha,2300)

				_nValMerc 		+= TRA->C7_TOTAL
				_nValIPI		+= (TRA->C7_TOTAL * TRA->C7_IPI) / 100
				_nValDesc		+= TRA->C7_VLDESC
				_nTotAcr		+= TRA->C7_DESPESA
				_nTotSeg		+= TRA->C7_SEGURO
				_nTotFre		+= TRA->C7_VALFRE

				If	( Empty(TRA->C7_TES) )
					_nTotIcmsRet	+= TRA->C7_ICMSRET
				Else
					DbSelectArea('SF4')
					SF4->(DbSetOrder(1))
					If	SF4->(DbSeek(xFilial('SF4') + TRA->C7_TES))
						If	( AllTrim(SF4->F4_INCSOL) == 'S' )
							_nTotIcmsRet	+= TRA->C7_ICMSRET
						EndIf
					EndIf
				EndIf

				       
				cObserv += AllTrim(TRA->C7_OBS)+' ' 
				

			IncProc()
			TRA->(DbSkip())	

		End

		xVerPag()

		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณImprime TOTAL DE MERCADORIASณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		If	( lImpPrc )
			oPrint:Line(nLinha,1455,nLinha+80,1455)
			oPrint:Line(nLinha,1850,nLinha+80,1850)
			oPrint:Line(nLinha,2300,nLinha+80,2300)
			oPrint:Say(nLinha+10,1470,'Valor Mercadorias ',oFont12)
			oPrint:Say(nLinha+10,2260,TransForm(_nValMerc,'@E 99,999,999.99'),oFont13,,,,1)
			nLinha += 80
			oPrint:Line(nLinha,1455,nLinha,2300)
		EndIf

		xVerPag()

		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณImprime TOTAL DE I.P.I. ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		If	( lImpPrc ) .and. ( _nValIpi > 0 )
			oPrint:Line(nLinha,1455,nLinha+80,1455)
			oPrint:Line(nLinha,1850,nLinha+80,1850)
			oPrint:Line(nLinha,2300,nLinha+80,2300)
			oPrint:Say(nLinha+10,1470,'Valor de I. P. I. (+)',oFont12)
			oPrint:Say(nLinha+10,2260,TransForm(_nValIpi,'@E 99,999,999.99'),oFont13,,,,1)
			nLinha += 80
			oPrint:Line(nLinha,1455,nLinha,2300)
		EndIf

		xVerPag()

		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณImprime TOTAL DE DESCONTOณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		If	( lImpPrc ) .and. ( _nValDesc > 0 )
			oPrint:Line(nLinha,1455,nLinha+80,1455)
			oPrint:Line(nLinha,1850,nLinha+80,1850)
			oPrint:Line(nLinha,2300,nLinha+80,2300)
			oPrint:Say(nLinha+10,1470,'Valor de Desconto (-)',oFont12)
			oPrint:Say(nLinha+10,2260,TransForm(_nValDesc,'@E 99,999,999.99'),oFont13,,,,1)
			nLinha += 80
			oPrint:Line(nLinha,1455,nLinha,2300)
		EndIf

		xVerPag()

		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณImprime TOTAL DE ACRESCIMO ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		If	( lImpPrc ) .and. ( _nTotAcr > 0 )
			oPrint:Line(nLinha,1455,nLinha+80,1455)
			oPrint:Line(nLinha,1850,nLinha+80,1850)
			oPrint:Line(nLinha,2300,nLinha+80,2300)
			oPrint:Say(nLinha+10,1470,'Valor de Acresc. (+)',oFont12)
			oPrint:Say(nLinha+10,2260,TransForm(_nTotAcr,'@E 99,999,999.99'),oFont13,,,,1)
			nLinha += 80
			oPrint:Line(nLinha,1455,nLinha,2300)
		EndIf

		xVerPag()

		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณImprime TOTAL DE SEGURO ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		If	( lImpPrc ) .and. ( _nTotSeg > 0 )
			oPrint:Line(nLinha,1455,nLinha+80,1455)
			oPrint:Line(nLinha,1850,nLinha+80,1850)
			oPrint:Line(nLinha,2300,nLinha+80,2300)
			oPrint:Say(nLinha+10,1470,'Valor de Seguro (+)',oFont12)
			oPrint:Say(nLinha+10,2260,TransForm(_nTotSeg,'@E 99,999,999.99'),oFont13,,,,1)
			nLinha += 80
			oPrint:Line(nLinha,1455,nLinha,2300)
		EndIf

		xVerPag()

		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณImprime TOTAL DE FRETE ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		If	( lImpPrc ) .and. ( _nTotFre > 0 )
			oPrint:Line(nLinha,1455,nLinha+80,1455)
			oPrint:Line(nLinha,1850,nLinha+80,1850)
			oPrint:Line(nLinha,2300,nLinha+80,2300)
			oPrint:Say(nLinha+10,1470,'Valor de Frete (+)',oFont12)
			oPrint:Say(nLinha+10,2260,TransForm(_nTotFre,'@E 99,999,999.99'),oFont13,,,,1)
			nLinha += 80
			oPrint:Line(nLinha,1455,nLinha,2300)
		EndIf

		xVerPag()

		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณImprime ICMS RETIDO    ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		If	( lImpPrc ) .and. ( _nTotIcmsRet > 0 )
			oPrint:Line(nLinha,1455,nLinha+80,1455)
			oPrint:Line(nLinha,1840,nLinha+80,1850)
			oPrint:Line(nLinha,2300,nLinha+80,2300)
			oPrint:Say(nLinha+10,1400,'Valor de ICMS Retido',oFont12)
			oPrint:Say(nLinha+10,2260,TransForm(_nTotIcmsRet,'@E 99,999,999.99'),oFont13,,,,1)
			nLinha += 80
			oPrint:Line(nLinha,1455,nLinha,2300)
		EndIf

		xVerPag()

		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณImprime o VALOR TOTAL !ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
//		oPrint:FillRect({nLinha,1390,nLinha+80,2300},oBrush)
		oPrint:Line(nLinha,1455,nLinha+80,1455)
		oPrint:Line(nLinha,1850,nLinha+80,1850)
		oPrint:Line(nLinha,2300,nLinha+80,2300)
		oPrint:Say(nLinha+10,1470,'VALOR TOTAL ',oFont12)
		If	( lImpPrc )
			oPrint:Say(nLinha+10,2260,TransForm(_nValMerc + _nValIPI - _nValDesc + _nTotAcr	+ _nTotSeg + _nTotFre + _nTotIcmsRet,'@E 99,999,999.99'),oFont13,,,,1)
		EndIf
		nLinha += 80
		xVerPag()
		oPrint:Line(nLinha,1455,nLinha,2300)
		nLinha += 70

		xVerPag()

		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณImprime as observacoes dos parametros. !ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		
		cObserv1 := Left(cObserv,70)
		cObserv2 := SubStr(cObserv,71,70)
		cObserv3 := SubStr(cObserv,141,70)
		cObserv4 := SubStr(cObserv,211,70)
		
		oPrint:Say(nLinha,0100,OemToAnsi('Observa็๕es/USO:'),oFont12)
		oPrint:Say(nLinha,0400,cObserv1,oFont12n)
		nLinha += 60
		
		If SC7->C7_TPFRETE == "C"
			cTpFret := "CIF"
			oPrint:Say(nLinha,100,OemToAnsi('Frete:'),oFont12)
		ElseIf SC7->C7_TPFRETE == "F"
			cTpFret := "FOB"
			oPrint:Say(nLinha,100,OemToAnsi('Frete:'),oFont12)
		Else
			cTpFret := "Sem Inf. Frete"
			oPrint:Say(nLinha,100,OemToAnsi('Frete:'),oFont12)
		EndIf
		oPrint:Say(nLinha,0450,cTpFret,oFont12n)
		nLinha += 40
		xVerPag()
		If	( ! Empty(cObserv2) )
			oPrint:Say(nLinha,0400,cObserv2,oFont12n)
			nLinha += 40
			xVerPag()
		EndIf	
		If	( ! Empty(cObserv3) )
			oPrint:Say(nLinha,0400,cObserv3,oFont12n)
			xVerPag()
			nLinha += 40
		EndIf	
		If	( ! Empty(cObserv4) )
			oPrint:Say(nLinha,0400,cObserv4,oFont12n)
			xVerPag()
			nLinha += 40
			xVerPag()
		EndIf

		nLinha += 20
		xVerPag()

		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณImprime o Representante comercial do fornecedorณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู   
		/*
		DbSelectArea('SZF')
		SZF->(DbSetOrder(1))
		If	SZF->(DbSeek(xFilial('SZF') + SA2->A2_COD + SA2->A2_LOJA))
			If	( ! Empty(SZF->ZF_REPRES) )
				oPrint:Say(nLinha,0100,OemToAnsi('Representante:'),oFont12)
				oPrint:Say(nLinha,0500,AllTrim(SZF->ZF_REPRES) + Space(5) + AllTrim(SZF->ZF_TELREPR) + Space(5) + AllTrim(SZF->ZF_FAXREPR),oFont12n)
				nLinha += 60
				xVerPag()
			EndIf
		EndIf	
        */
		nLinha += 20
		xVerPag()

		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณImprime a linha de prazo pagamento/entrega!ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		oPrint:Say(nLinha,0100,OemToAnsi('Prazo Pagamento:'),oFont12)
		If !Empty(SC7->C7_COND)
			If SE4->(dbSetOrder(1), dbSeek(xFilial("SE4")+SC7->C7_COND))
				oPrint:Say(nLinha,0450,SE4->E4_CODIGO + ' - ' + SE4->E4_DESCRI,oFont12n)
			Endif
		Else
			oPrint:Say(nLinha,0450,'_____________________',oFont12n)
		Endif
		
//		oPrint:Say(nLinha,1120,OemToAnsi('Prazo Entrega:'),oFont12)
//		oPrint:Say(nLinha,1500,'___________________________',oFont12n)
		nLinha += 60
  		xVerPag()

		nLinha += 20
		xVerPag()

		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณImprime a linha de transportadora !ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
/*		oPrint:Say(nLinha,0100,OemToAnsi('Transportadora:'),oFont12)
		oPrint:Say(nLinha,0500,'____________________________________________________',oFont12n)*/
		//oPrint:Say(nLinha,0100,OemToAnsi('Observa็๕es/USO:'),oFont12)
		//oPrint:Say(nLinha,0490,cObserv1,oFont12n)
		oPrint:Say(nLinha,100,OemToAnsi('Comprador:'),oFont12)
		oPrint:Say(nLinha,0450,UsrFullName(SC7->C7_USER),oFont12n)
		nLinha += 40
		xVerPag()

		nLinha += 20
		xVerPag()

		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณImprime o Contato.ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		If	( ! Empty(SA2->A2_CONTATO) )
			oPrint:Say(nLinha,0100,OemToAnsi('Contato: '),oFont12)
			oPrint:Say(nLinha,0450,SA2->A2_CONTATO,oFont12n)
			oPrint:Say(nLinha,1000,OemToAnsi('Aprov.SC: '),oFont12) 			
			oPrint:Say(nLinha,1200,cAprov,oFont12n)
			nLinha += 40
			xVerPag()
		ELSE
			oPrint:Say(nLinha,0100,OemToAnsi('Aprov.SC: '),oFont12) 			
			oPrint:Say(nLinha,0450,cAprov,oFont12n)
			nLinha += 40
			xVerPag()
		EndIf
		oPrint:Line(nLinha,0100,nLinha,2300)
		nLinha += 40
		xVerPag()
		oPrint:Say(nLinha,100,OemToAnsi('Favor enviar copia do pedido e informar no campo Obs. da Nota Fiscal o Numero do Pedido: ' + SC7->C7_NUM),oFont13)
		nLinha += 70
		oPrint:Say(nLinha,100,OemToAnsi('** FAVOR ANEXAR O BOLETO NA NOTA FISCAL '),oFont13)
		nLinha += 70
		If cEmpAnt <> '50' 
			oPrint:Say(nLinha,100,OemToAnsi('** EMAIL PARA ENVIO DE NF E BOLETOS - ercal@ercal.com.br '),oFont13)
		Else
			oPrint:Say(nLinha,100,OemToAnsi('** EMAIL PARA ENVIO DE NF E BOLETOS - compras@grupobritacal.com.br '),oFont13)
		EndIf
		nLinha += 10
		xVerPag()
		
		TRA->(DbCloseArea())

		xRodape()

		/*     //retirado por Carlos Daniel para nao imprimir etiqueta
		If !Empty(_nQtdReg)
			U_EPed(cNumPed,'')					
		Endif
		  */
	
		oPrint:Preview()

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหออออออัอออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ xCabec() บAutor ณCarlos Daniel da Silvaบ Data ณ  08/07/13  บฑฑ
ฑฑฬออออออออออุออออออออออสออออออฯอออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Imprime o Cabecalho do relatorio...                        บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Funcao Principal                                           บฑฑ
ฑฑฬออออออออออุออออออออออัอออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบDATA      ณ ANALISTA ณ  MOTIVO                                         บฑฑ
ฑฑฬออออออออออุออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ          ณ          ณ                                                 บฑฑ
ฑฑศออออออออออฯออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function xCabec()

		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณImprime o cabecalho da empresa. !ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		oPrint:SayBitmap(050,100,cFileLogo,600,270)
		oPrint:Box(0030,0740,0285,2300)
		oPrint:Say(050,750,AllTrim(Upper(SM0->M0_NOMECOM)),oFont16)
		oPrint:Say(135,750,"CNPJ: "+TransForm(SM0->M0_CGC,'@R 99.999.999/9999-99'),oFont12)
		oPrint:Say(135,1300,"Insc. Est.: "+SM0->M0_INSC,oFont12)
		//oPrint:Say(135,750,AllTrim(SM0->M0_ENDCOB),oFont11)
		//oPrint:Say(180,750,Capital(AllTrim(SM0->M0_CIDCOB))+'/'+AllTrim(SM0->M0_ESTCOB)+ '  -  ' + AllTrim(TransForm(SM0->M0_CEPCOB,'@R 99.999-999')) + '  -  ' + ' (34) 3230-3300',oFont11)
		If cEmpAnt <> '50'
			oPrint:Say(190,750,AllTrim('www.grupoercal.com.br'),oFont12)
		Else
			oPrint:Say(190,750,AllTrim('www.grupobritacal.com.br'),oFont12)
		EndIf
		oPrint:Say(190,1300,"Cod. Filial: "+cFilAnt,oFont12)
		oPrint:Line(285,750,285,2270)
		

		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณTitulo do Relatorioณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		If	( nTitulo == 1 ) // Cotacao
			oPrint:Say(0400,0800,OemToAnsi('Cota็ใo de Compras'),oFont22)
		Else
			oPrint:Say(0400,0800,OemToAnsi('Pedido de Compras'),oFont22)
		EndIf

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหออออออัอออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ xRodape()บAutor ณCarlos Daniel da Silvaบ Data ณ  08/07/13  บฑฑ
ฑฑฬออออออออออุออออออออออสออออออฯอออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Imprime o Rodape do Relatorio....                          บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Funcao Principal                                           บฑฑ
ฑฑฬออออออออออุออออออออออัอออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบDATA      ณ ANALISTA ณ  MOTIVO                                         บฑฑ
ฑฑฬออออออออออุออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ          ณ          ณ                                                 บฑฑ
ฑฑศออออออออออฯออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function xRodape()
//Local cCrLf 	:= Chr(13) + Chr(10)

If cEmpAnt <> '50' 
	//oPrint:Box(3000,0100,3480,2300)
	oPrint:Line(3000,0100,3000,2300)
	oPrint:Say(3050,0100,'Central de Atendimento',oFont16)
    //oPrint:Say(3120,1050,'(34)3230-3300',oFont16)
	//oPrint:Line(2800,0100,2800,2300)
	oPrint:Say(3110,0100,'Av. Amazonas, 232 - Bairro Brasil. Uberlโndia/MG',oFont12n)
	oPrint:Say(3160,0100,'Fone: (34) 3230-3300',oFont12n)
	oPrint:Say(3210,0100,'Site: www.grupoercal.com.br',oFont12n)
	
	oPrint:Say(3280,0100,'CALCมRIO TRIยNGULO',oFont12)
	oPrint:Say(3330,0100,'CNPJ:18.572.206/0001-51',oFont12n)
	oPrint:Say(3380,0100,'Inscri็ใo Estadual: 701.416.562.0093',oFont12n)
	oPrint:Say(3430,0100,'Endere็o: Rod.BR050, KM124. Uberaba/MG',oFont12n)
	
	//oPrint:Say(2720,0100,'Central de Atendimento',oFont12n)
    //oPrint:Say(3120,1050,'(34)3230-3300',oFont16)
	//oPrint:Line(2800,0100,2800,2300)
	oPrint:Say(3100,1400,'ERCAl:',oFont12)
	oPrint:Say(3150,1400,'CNPJ: 19.564.343/0001-07',oFont12n)
	oPrint:Say(3200,1400,'Inscri็ใo Estadual: 193.434.613.0039',oFont12n)
	
	oPrint:Say(3270,1400,'ERCAL FILIAL 01',oFont12)
	oPrint:Say(3320,1400,'Endere็o: Rod.MG-188 sentido Coromandel a Paracatu - 24 KM',oFont12n)
	
	oPrint:Say(3380,1400,'ERCAL FILIAL 04',oFont12)
	oPrint:Say(3430,1400,'Endere็o: Rod.MG-188 sentido Coromandel a Paracatu - 8 KM',oFont12n)
	oPrint:EndPage()
Else //britacal

	oPrint:Line(3000,0100,3000,2300)
	oPrint:Say(3050,0100,'FATURAMENTO',oFont16)
	
	oPrint:Say(3120,0100,AllTrim(Upper(SM0->M0_NOMECOM)),oFont12)
	oPrint:Say(3170,0100,"CNPJ: "+TransForm(SM0->M0_CGC,'@R 99.999.999/9999-99'),oFont12n)
	oPrint:Say(3220,0100,"I.E.: " + Transform(SM0->M0_INSC, "@R 999.999.999.999"),oFont12n)
	oPrint:Say(3270,0100,'END:' +alltrim(SM0->M0_ENDENT) + ", " +AllTrim(SM0->M0_BAIRENT),oFont12n)
	oPrint:Say(3320,0100,'CIDADE/CEP:' +AllTrim(SM0->M0_CIDENT) + "-" + SM0->M0_ESTENT + "-" +SM0->M0_CEPENT,oFont12n)
	oPrint:Say(3370,0100,'FONE: (61) 2106-0600',oFont12n)
	oPrint:Say(3420,0100,'SITE: www.grupobritacal.com.br',oFont12n)
	
	oPrint:Say(3050,1400,'COBRANวA',oFont16)

	oPrint:Say(3120,1400,'BRITACAL - ESCRITORIO CENTRAL - BRASILIA',oFont12)
	oPrint:Say(3170,1400,'CNPJ: 26.970.103/0009-25',oFont12n)
	oPrint:Say(3220,1400,'I.E.: 07.322.138/002-28',oFont12n)
	oPrint:Say(3270,1400,'Endere็o: Sia/Sul Trecho 03 Lote 335 2บ Andar Cep: 71.200-030',oFont12n)
	oPrint:EndPage()
EndIf
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหออออออัอออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ xVerPag()บAutor ณCarlos Daniel da Silvaบ Data ณ  08/07/13  บฑฑ
ฑฑฬออออออออออุออออออออออสออออออฯอออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Verifica se deve ou nao saltar pagina...                   บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Funcao Principal                                           บฑฑ
ฑฑฬออออออออออุออออออออออัอออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบDATA      ณ ANALISTA ณ  MOTIVO                                         บฑฑ
ฑฑฬออออออออออุออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ          ณ          ณ                                                 บฑฑ
ฑฑศออออออออออฯออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function xVerPag()

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณInicia a montagem da impressao.ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	If	( nLinha >= 3000 )

		If	( ! lFlag )
			xRodape()
			oPrint:EndPage()
			nLinha:= 600
		Else
			nLinha:= 800
		EndIf

		oPrint:StartPage()
		xCabec()

		lPrintDesTab := .t.

	EndIf
	

Return

/*  //Retirado por Carlos Daniel para nao imprimir a etiqueta de cod barras

User Function EPed(cPedido,cProduto)
Local _aArea  := GetArea()
Private oArial30  	:=	TFont():New("Arial",,24,,.F.,,,,,.F.,.F.)
Private oArial15N	:=	TFont():New("Arial Narrow",,15,,.T.,,,,,.F.,.F.)
Private o17N	:=	TFont():New("Arial Narrow",,12,,.T.,,,,,.F.,.F.)//TFont():New("",,10,,.T.,,,,,.F.,.F.)
Private o19N	:=	TFont():New("Arial Narrow",,14,,.T.,,,,,.F.,.F.)//TFont():New("",,10,,.T.,,,,,.F.,.F.)
Private o18N	:=	TFont():New("",,12,,.T.,,,,,.F.,.F.)
Private o21N	:=	TFont():New("",,10,,.T.,,,,,.F.,.F.)
Private o10N	:=	TFont():New("",,7,,.T.,,,,,.F.,.F.)
Private o11N	:=	TFont():New("",,8,,.T.,,,,,.F.,.F.)
Private oTimes14N	:=	TFont():New("Times New Roman",,12,,.T.,,,,,.F.,.F.)
Private o29N	:=	TFont():New("",,18,,.T.,,,,,.F.,.F.)
Private o28N	:=	TFont():New("Times New Roman",,12,,.T.,,,,,.F.,.F.)
PRIVATE oFont6  := TFont():New( "Arial",,08,,.f.,,,,,.f. )

aPrd := {}
If !Empty(cPedido) 
	If SC7->(dbSetOrder(1), dbSeek(xFilial("SC7")+cPedido))
		While SC7->(!Eof()) .And. SC7->C7_NUM == cPedido
			If !Empty(cProduto)
				If cProduto <> SC7->C7_PRODUTO
					SC7->(dbSkip(1));Loop
				Endif
			Endif
			
			SB1->(dbSetOrder(1), dbSeek(xFilial("SB1")+SC7->C7_PRODUTO))

			AAdd(aPrd,{SC7->C7_PRODUTO, SB1->B1_DESC, SB1->B1_UM, SC7->C7_QUANT})
			
			SC7->(dbSkip(1))
		Enddo
	Endif
ElseIf !Empty(cProduto)
	SB1->(dbSetOrder(1), dbSeek(xFilial("SB1")+cProduto))

	AAdd(aPrd,{cProduto, SB1->B1_DESC, SB1->B1_UM, 1})
Else
	Return .t.
Endif

SC7->(dbSetOrder(1), dbSeek(xFilial("SC7")+cPedido))
SA2->(dbSetOrder(1), dbSeek(xFilial("SA2")+SC7->C7_FORNECE+SC7->C7_LOJA))

//oPrinter:Setup()
//oPrinter:SetPortrait()
For _nX := 1 To Len(aPrd)           

	SB1->(dbSetOrder(1), dbSeek(xFilial("SB1")+aPrd[_nX,1]))

	For nCopias := 1 To 1 //aPrd[_nX,4]
		oPrint:StartPage()
		
		If _nX == 1                                 
			oPrint:Say(0150,1000,"A T E N ว ร O",oTimes14N,,0)
			oPrint:Say(0204,1000,"Sr. Fornecedor, caso seu material nใo possua C๓digo de Barras com Seu C๓digo Interno",o11N,,0)
			oPrint:Say(0240,1000,"por gentileza utilizar nossas etiquetas que acompanham este pedido de compra",o11N,,0)
			oPrint:Say(0280,1000,"para acompanhar as embalagens dos seus materiais para nosso devido procedimento Interno",o11N,,0)
			oPrint:Say(0320,1000,"de confer๊ncia.",o11N,,0)
			oPrint:Say(0360,1000,"Calcario Ercal",oTimes14N,,0)
		Endif
		
		oPrint:Box(0044,0046,0182,0800)
		oPrint:Box(0182,0046,0293,0800)
	
		MSBAR("CODE3_9",0.8,0.8,Rtrim(aPrd[_nX,1]),oPrint,.f.,NIL,.T.,0.0270,0.7,.F.,oFont6,"CODE3_9",.F.)
	
		oPrint:Say(0150,0200,aPrd[_nX,1],o11N,,0)
		
		oPrint:Say(0204,0058,"Pedido:",oTimes14N,,0)
		oPrint:Say(0200,0240,cPedido,o19N,,0)
		oPrint:Box(0293,0046,0371,800)
		oPrint:Say(0297,0063,"Fornec:",oTimes14N,,0)
		oPrint:Say(0297,0240,Capital(SA2->A2_NOME),o11N,,0)
		oPrint:Box(0371,0046,0946,800)
		oPrint:Say(0390,0079,"Descri็ใo:",oTimes14N,,0)
	
		cDesc := aPrd[_nX,2]
		
		_nLinhas := MlCount(cDesc,45)
		lI := 0440 
		For _nT := 1 To _nLinhas
			oPrint:Say(lI,0079,Capital(MemoLine(cDesc,45,_nT)),o11N,,0)
			lI+=30
		Next _nT
				

		oPrint:Say(0660,0079,"Tipo:",oTimes14N,,0)
		oPrint:Say(0660,0300,"Unidade:",oTimes14N,,0)
		oPrint:Say(0660,0500,"Peso Total:",oTimes14N,,0)

		oPrint:Say(0722,0079,SB1->B1_TIPO,o17N,,0)
		oPrint:Say(0722,0300,aPrd[_nX,3],o17N,,0)
		oPrint:Say(0722,0500,TransForm((SB1->B1_PESO * aPrd[_nX,4]),"@E 99,999.9999"),o17N,,0)
		oPrint:Say(0804,0079,"Alm.Padrใo:",oTimes14N,,0)
		oPrint:Say(0857,0079,SB1->B1_LOCPAD,o17N,,0)
		oPrint:Box(0946,0046,1100,800)
	
		oPrint:Say(0080,0520,"QTDE: "+Str(aPrd[_nX,4],5),o28N,,0)
	
		oPrint:Say(1020,0079,"Cliente: ",oTimes14N,,0)
		oPrint:Say(1020,0240,SM0->M0_NOME,o17N,,0)
				  
		oPrint:EndPage()
	Next
Next
RestArea(_aArea)
Return   
*/
