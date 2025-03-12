#include "PROTHEUS.CH"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³dESCCLI   º Autor ³CARLOS DANIEL       º Data ³  12/11/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³DESCONTO PARA CLIENTES CONTRIBUINTES POR  ESTADO            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ ERCAL                                                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function dESCCLI() //VALOR AO CAMPO ADB_PRCVEN

	LOCAL nVALU := aCols[1,6]//val(CVALTOCHAR(aCols[1,6])) //preço unitario
	LOCAL cEST  := M->ADA_XEST  //Estado do Cliente
	LOCAL cTIPc := Posicione("SA1",1,xFilial("SA1")+M->ADA_CODCLI+M->ADA_LOJCLI,"A1_CONTRIB")  //SE CONTRIBUINTE
	LOCAL cGrup := Posicione("SB1",1,xFilial("SB1")+aCols[1,2],"B1_GRUPO")  //Grupo do Produto
	LOCAL nVALS := '' //VALOR DESCONTO FINAL
	LOCAL nVALP := '' // VALOR UNITARIO NOVO
	LOCAL nQUANT := aCols[1,5] //CVALTOCHAR(aCols[1,5]) //QUANTIDADE PRODUTO
	//LOCAL nQUANF := '' //QUANTIDADE PRODUTO final
	//LOCAL dEsc := 0
	PRIVATE nVALT := '' //PREÇO * PORCENTAGEM = DESCONTO
	PRIVATE nVALG := '' //PREÇO + nVALT = PREÇO UNITARIO
	PRIVATE nDESC := '' //taxa desconto
	PRIVATE nVlr := '' //valor base desconto



	IF cTIPc == '1' .And. cEST <>'MG' .And. cGrup == '0056' // SE CLIENTE FOR PRODUTO FORA DO ESTADO MG e grupo calcario
		IF cEST == 'PR' .OR. cEST== 'RS' .OR. cEST== 'RJ'.OR. cEST== 'SC' .OR. cEST== 'SP'
			nDESC := 12
			nVlr    := 13.65
			nVALT := (nVALU * nVlr) / 100  //VALOR DO DESCONTO    1.42
			nVALG := nVALU + nVALT // VALOR UNITARIO + DESCONTO = valor real unitario novo   11.82
			nVALS := (nQUANT * nVALG) //valor total
			nVALP  := (nVALS * nDESC) / 100  //valor desconto
			//aCols[1,6] := nVALG
			//aCols[1,16] := nVALP
			//MsgAlert('CLIENTE CONTRIBUINTE DE'+' '+cEST+' '+chr(13)+chr(10)+'FAVOR INFORMAR OS VALORES ABAIXO.'+chr(13)+chr(10)+' VALOR BASE:'+ CVALTOCHAR(ROUND(nVALU,2))+' + '+CVALTOCHAR(ROUND(nVlr,2))+'% = R$ '+ CVALTOCHAR(ROUND(nVALG,2))+chr(13)+chr(10)+' VLR UNIT: R$'+ CVALTOCHAR(ROUND(nVALG,2)) +chr(13)+chr(10)+' DESCONTO:'+' %'+CVALTOCHAR(ROUND(nDESC,2)), 'DESCONTO OBRIGATORIO')
		ELSE
			nDesc := 7
			nVlr := 7.53
			nVALT := (nVALU * nVlr) / 100  //VALOR DO DESCONTO    1.42
			nVALG := nVALU + nVALT // VALOR UNITARIO + DESCONTO = valor real unitario novo   11.82
			nVALS := (nQUANT * nVALG) //valor total
			nVALP  := (nVALS * nDESC) / 100  //valor desconto
			//aCols[1,6] := nVALG
			//aCols[1,16] := nVALP
			//MsgAlert('CLIENTE CONTRIBUINTE DE'+' '+cEST+' '+chr(13)+chr(10)+'FAVOR INFORMAR OS VALORES ABAIXO.'+chr(13)+chr(10)+' VALOR BASE:'+ CVALTOCHAR(ROUND(nVALU,2))+' + '+CVALTOCHAR(ROUND(nVlr,2))+'% = R$ '+ CVALTOCHAR(ROUND(nVALG,2))+chr(13)+chr(10)+' VLR UNIT: R$'+ CVALTOCHAR(ROUND(nVALG,2)) +chr(13)+chr(10)+' DESCONTO:'+' %'+CVALTOCHAR(ROUND(nDESC,2)), 'DESCONTO OBRIGATORIO')
		ENDIF
	ELSE
		//nVALG := aCols[1,6]
		oGetDad:oBrowse:Refresh()
		RETURN aCols[1,6]

	ENDIF


	//oMark:oBrowse:Refresh()
	oGetDad:oBrowse:Refresh()
RETURN aCols[1,6]

//desconto
User Function CTR001()


	//Local _cTES := ''
	Local _cCod := aCols[n,16]

	//LOCAL nVALU := aCols[n,6]//val(CVALTOCHAR(aCols[1,6])) //preço unitario
	LOCAL cEST  := M->ADA_XEST  //Estado do Cliente
	LOCAL cTIPc := Posicione("SA1",1,xFilial("SA1")+M->ADA_CODCLI+M->ADA_LOJCLI,"A1_CONTRIB")  //SE CONTRIBUINTE
	LOCAL cGrup := Posicione("SB1",1,xFilial("SB1")+aCols[1,2],"B1_GRUPO")  //Grupo do Produto
	//LOCAL nVALS := '' //VALOR DESCONTO FINAL
	//LOCAL nVALP := '' // VALOR UNITARIO NOVO
	//LOCAL nQUANT := aCols[n,5] //CVALTOCHAR(aCols[1,5]) //QUANTIDADE PRODUTO
	LOCAL iDc := 0
	LOCAL vTotal := aCols[1,7]
	LOCAL vDESC := 0 //taxa desconto
	LOCAL vRult := 0
	//LOCAL nQUANF := '' //QUANTIDADE PRODUTO final
	//LOCAL dEsc := 0
	PRIVATE nVALT := '' //PREÇO * PORCENTAGEM = DESCONTO
	PRIVATE nVALG := '' //PREÇO + nVALT = PREÇO UNITARIO
	
	//Calcario
	IF cTIPc == '1' .And. cEST <>'MG' .And. cGrup == '0056' // SE CLIENTE FOR PRODUTO FORA DO ESTADO MG e grupo calcario
		IF Empty(_cCod) .OR. _cCod = NIl
			IF cEST == 'PR' .OR. cEST== 'RS' .OR. cEST== 'RJ'.OR. cEST== 'SC' .OR. cEST== 'SP'
				//12%
				iDc := 1.077586
				vRult := ROUND((vTotal*iDc),2)
				vDESC := (vRult-ROUND(vTotal,2))
				//MsgAlert('Este cliente é contribuinte fora do estado '+' '+cEST+' '+chr(13)+chr(10)+'por isso foi aplicado desconto a seguir.'+chr(13)+chr(10)+' Valor de R$ '+ CVALTOCHAR(ROUND(vDESC,2)))
			ELSE
				//7%
				iDc := 1.043841
				vRult := ROUND((vTotal*iDc),2)
				vDESC := (vRult-ROUND(vTotal,2))
				//MsgAlert('Este cliente é contribuinte fora do estado '+' '+cEST+' '+chr(13)+chr(10)+'por isso foi aplicado desconto a seguir.'+chr(13)+chr(10)+' Valor de R$ '+ CVALTOCHAR(ROUND(vDESC,2)))	
			ENDIF
		ELSE
			RETURN _cCod
		ENDIF
	//fertilizantes
	ELSEIF cTIPc == '1' .And. cEST <>'MG' .And. cGrup == '0106'
		IF Empty(_cCod) .OR. _cCod = NIl
			IF cEST == 'PR' .OR. cEST== 'RS' .OR. cEST== 'RJ'.OR. cEST== 'SC' .OR. cEST== 'SP'
				//12%
				iDc := 1.049322
				vRult := ROUND((vTotal*iDc),2)
				vDESC := (vRult-ROUND(vTotal,2))
				//MsgAlert('Este cliente é contribuinte fora do estado '+' '+cEST+' '+chr(13)+chr(10)+'por isso foi aplicado desconto a seguir.'+chr(13)+chr(10)+' Valor de R$ '+ CVALTOCHAR(ROUND(vDESC,2)))
			ELSE
				//7% 
				iDc := 1.023749
				vRult := ROUND((vTotal*iDc),2)
				vDESC := (vRult-ROUND(vTotal,2))
				//MsgAlert('Este cliente é contribuinte fora do estado '+' '+cEST+' '+chr(13)+chr(10)+'por isso foi aplicado desconto a seguir.'+chr(13)+chr(10)+' Valor de R$ '+ CVALTOCHAR(ROUND(vDESC,2)))
			ENDIF
		ELSE
			RETURN _cCod
		ENDIF


	ELSE
		//nVALG := aCols[1,6]
		//oGetDad:oBrowse:Refresh()
		If Type('oGetDad')<>"U"
			Ft400Rodap(oGetDad)
			oGetDad:oBrowse:Refresh()
		EndIf
		RestArea(aArea)
		RETURN _cCod

	ENDIF
	//aCols[1,16] := vDESC
	//aCols[1,16] := vDESC
	//aCols[1,16] := vDESC


	//oMark:oBrowse:Refresh()
	//oGetDad:oBrowse:Refresh()
	If Type('oGetDad')<>"U"
		Ft400Rodap(oGetDad)
		oGetDad:oBrowse:Refresh()
	EndIf
	//RestArea(aArea)
RETURN aCols[1,16]
