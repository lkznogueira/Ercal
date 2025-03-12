#INCLUDE "rwmake.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MA410MNU  ºAutor  ³CARLOS DANIEL       º Data ³  15/12/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ PE para inclusao de botao no aRotina do pedido de venda.   º±±
±±º          ³                                                            º±±
±±º	   		 ³              				                              º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ ERCAL                                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function MA410MNU   
Public BFILTRABRW:={|| .T.}
Public aFilBrw := {'SF2','.T.'}
  

//aadd(aRotina,{'DANFE','u_SDanfeh()' , 0 , 3,0,NIL})   //SpedDanfe
aadd(aRotina,{'DANFE','SpedDanfe()' , 0 , 3,0,NIL})   //SpedDanfe
aadd(aRotina,{'MONITOR-FAIXA','SpedNFe1Mnt()' , 0 , 3,0,NIL})
aadd(aRotina,{'Transmissao','SPEDNFEREMESSA()',0,3,0,NIL}) 
aadd(aRotina,{'Imprimir Pedido','MATR730',0,3,0,NIL})
aadd(aRotina,{'Libera Cred/Est','u_libmanu()',0,3,0,NIL})
aadd(aRotina,{'Duplicata','U_IMPDUP()' , 0 , 11,0,NIL}) // Rotina para imprimir a duplicata
aadd(aRotina,{'Imprime Boleto','U_BMFIN01()' , 0 , 11,0,NIL}) // Rotina para imprimir a duplicata
// adiciono menu da alteração da embalagem
aadd(aRotina,{"Remessa Destinatario","U_UFATE005" , 0, 7,0,NIL}) 
aadd(aRotina,{"Libera Excluir","U_Stsped" , 0, 7,0,NIL})    

Return

User Function SDanfeh()

Private AFILBRW := {}
Private cCondicao :=" "
cCondicao := "F2_FILIAL=='"+xFilial("SF2")+"'"
AFILBRW	 := {'SF2',cCondicao}
SpedDanfe()
Return()

User Function Stsped()

Local cNota      := ALLTRIM(SC5->C5_NOTA)
//Local cLib       := SC5->C5_LIBEROK
Local aAreaSC6   := SC6->(GetArea())

if Empty(cNota) // sem nota pedido liberado
    //if cLib == 'S' // se tiver liberado 
        Reclock("SC5",.F.)								   	
		SC5->C5_LIBEROK := ' ' 			//altera para pedido liberado exclusao		
	    SC5->( MsUnlock() )	
    
    //EXCLUI TAMBEM SC6  
        SC6->(dbSetOrder(1)) // C6_FILIAL+C6_NUM+C6_ITEM+C6_PRODUTO	
	    if SC6->(dbSeek(fwxFilial("SC6") + SC5->C5_NUM)) .AND. RecLock("SC6", .F.)				
		    SC6->C6_QTDEMP := 0				
	    msUnlock()
        endif
    //else
       // MsgStop('Pedido já esta liberado para exclusão! ')//mensagem avisando que ja esta liberado    
    //Endif
else
    MsgStop('Pedido Ja faturado, não é possivel alterar! ') //mensagem alerta
endIf
RestArea(aAreaSC6)
Return()
