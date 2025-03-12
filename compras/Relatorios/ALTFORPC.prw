/*______________________________________________________________________
   ¦Autor     ¦ Carlos Daniel                       ¦ Data ¦ 26/08/16 ¦
   +----------+-------------------------------------------------------¦
   ¦Descrição ¦ Mudar fornecedor do pedido de compra                  ¦
  ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
#include "protheus.ch"
#include "topconn.ch"

user function ALTFORPC()
	local oButton1, oButton2
	local oGroup1, oGroup2
	local oSay1, oSay2, oSay4, oSay5
	local oGet1, oGet2, oGet3, oGet4, oGet5, oGet6
	local cGet1 := Space(9)
	local cGet2 := Space(70)
	local cGet3 := Space(9)
	local cGet4 := Space(70)
	local cGet5 := Space(20)
	local cGet6 := Space(20)
	local lValid := .T.
	
	private oDlg
	private aArea := GetArea()
	private cNumCot
	private cFornea 
	private cLojaa 

	if Select("TMP") <> 0
		TMP->(DbCloseArea())
	endif
	
	cQry := "select * from "+RetSqlName("SC7")+" where C7_NUM = '"+SC7->C7_NUM+"' and D_E_L_E_T_ <> '*' and C7_FILIAL = '"+xFilial("SC7")+"'"
	
	tcquery cQry new alias "TMP"
	DbSelectArea("TMP")
	TMP->(DbGoTop())
	
	while !TMP->(Eof())
		if TMP->C7_ENCER == "E"
			lValid := .F.
		endif
		If !Empty(TMP->C7_NUMCOT)
			cNumCot := TMP->C7_NUMCOT
		else
			cNumCot := 000000
		EndIf
		TMP->(DbSkip())
	enddo

	
	TMP->(DbCloseArea())
	
	if !lValid
		MsgAlert("O pedido de compra possui pelo menos um item encerrado e por isso nao pode alterar o fornecedor.")
		
		return
	endif
	
	if SA2->(DbSeek(xFilial("SA2")+SC7->(C7_FORNECE+C7_LOJA),.F.))
		cGet1 := SA2->A2_COD+"-"+SA2->A2_LOJA
		cGet2 := SA2->A2_NOME
		cGet5 := SA2->A2_NREDUZ
		//cNumCot := 
		cFornea := SA2->A2_COD
		cLojaa  := SA2->A2_LOJA
		define msdialog oDlg title "Mudar Fornecedor PC" from 000,000 to 240,500 colors 0,16777215 pixel
			@002,003 group oGroup1 to 047,246 prompt " Atualmente " of oDlg color 0,16777215 pixel
			@015,008 say oSay1 prompt "CODIGO" size 045,007 of oDlg colors 0,16777215 pixel
			@014,053 msget oGet1 var cGet1 size 045,010 of oDlg colors 0,16777215 when .F. pixel
			@015,102 say oSay6 prompt "N. FANTASIA" size 039,007 of oDlg colors 0,16777215 pixel
			@014,142 msget oGet5 var cGet5 size 097,010 of oDlg colors 0,16777215 when .F. pixel
			@032,008 say oSay2 prompt "RAZAO SOCIAL" size 045,007 of oDlg colors 0,16777215 pixel
			@030,053 msget oGet2 var cGet2 size 187,010 of oDlg colors 0,16777215 when .F. pixel
			
			@050,003 group oGroup2 to 095,246 prompt " Mudar Para " of oDlg color 0,16777215 pixel
			@062,008 say oSay4 prompt "CODIGO" size 025,007 of oDlg colors 0,16777215 pixel
			@060,053 msget oGet3 var cGet3 size 045,010 of oDlg colors 0,16777215 F3 "SA2001" pixel
			@062,102 say oSay7 prompt "N. FANTASIA" size 039,007 of oDlg colors 0,16777215 pixel
			@060,142 msget oGet6 var cGet6 size 097,010 of oDlg colors 0,16777215 when .F. pixel
			@078,008 say oSay5 prompt "RAZAO SOCIAL" size 045,007 of oDlg colors 0,16777215 pixel
			@077,053 msget oGet4 var cGet4 size 187,010 of oDlg colors 0,16777215 when .F. pixel
			
			@103,167 button oButton1 prompt "Mudar" size 037,012 of oDlg action Mudar(cGet3,cGet6,Left(SA2->A2_CONTATO,15),SC7->C7_NUM,cNumCot,cFornea, cLojaa) pixel
			@103,208 button oButton2 prompt "Cancelar" size 037,012 of oDlg action oDlg:End() pixel
		activate msdialog oDlg centered
	else
		MsgAlert("Fornecedor do pedido de compra nao encontrado.")
	endif
return

static function Mudar(cFornec,cNReduz,cContato,cNum,cNumCot,cFornea, cLojaa)
//Local aArea := GetArea()

	if SA2->(DbSeek(xFilial("SA2")+Left(cFornec,6)+Right(cFornec,2),.F.))
		if Empty(cNum)
			MsgAlert("Nao foi selecionado nenhum pedido de compra para alterar o fornecedor.")
			
			return
		endif
		
		SC7->(DbGoTop())
		
		if SC7->(MsSeek(xFilial("SC7")+cNum,.F.))
			while SC7->C7_NUM == cNum .and. !SC7->(Eof())
				if RecLock("SC7",.F.)
					SC7->C7_FORNECE := Left(cFornec,6)
					SC7->C7_LOJA := Right(cFornec,2)
					//SC7->C7_NOMFORN := cNReduz
					SC7->C7_CONTATO := cContato
					
					MsUnLock()
				else
					MsgAlert("Fornecedor nao pode ser alterado devido o pedido esta em uso.")
				endif
				
				SC7->(DbSkip())
			enddo
		endif

		If !Empty(cNumCot)
			
			dbSelectArea("SC8")
			dbSetOrder(1)
			SC8->(DbGoTop())
			dbSeek( xFilial("SC8") + Padr(cNumCot,6) + Padr(cFornea,6) + cLojaa )
			while SC8->C8_NUM == cNumCot .and. !SC8->(Eof())
				If SC8->C8_NUMPED == cNum
					if RecLock("SC8",.F.)
						SC8->C8_FORNECE := Left(cFornec,6)
						SC8->C8_LOJA 	:= Right(cFornec,2)
						SC8->C8_CONTATO := cContato   
						MsUnLock()
					else
						MsgAlert("Fornecedor nao pode ser alterado devido o pedido esta em uso.")
					endif
				EndIf
				SC8->(DbSkip())
			enddo
		endif
		/*
		//se tiver cotacao altera tambem
		dbSelectArea("SC8")
		dbSetOrder(1)
		dbSeek( xFilial("SC8") + Padr(cNumCot,6) + Padr(cFornea,6) + cLojaa )
		while SC8->C8_NUM == cNumCot .and. !SC8->(Eof())
			if RecLock("SC8",.F.)
				SC8->C8_FORNECE := cFornec
				SC8->C8_LOJA 	:= cFornec
				SC8->C8_CONTATO := cContato   
				MsUnLock()
			else
				MsgAlert("Fornecedor nao pode ser alterado devido o pedido esta em uso.")
			endif
				
			SC8->(DbSkip())
		enddo
		*/
	EndIf
		
		MsgInfo("Fornecedor ALterado.")
		RestArea(aArea)
		oDlg:End()
return
