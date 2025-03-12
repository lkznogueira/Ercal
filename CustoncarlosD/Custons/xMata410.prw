#include "protheus.ch"
#include "topconn.ch"
#include "rwmake.ch"
#include "Tbiconn.ch"

User Function xMata410()

Local cQuery := cQuery1 := "" 
Local nRet := ""
Local nCont := 1 
Private cAlias := Criatrab(Nil,.F.)
Private cAlias1 := Criatrab(Nil,.F.)
Private lMsErroAuto := .F.  
Private lGeraNf := .T.
Private aCabec := {}
Private aLinha := {}
Private cPedidos := ""
Private cDoc
Private cVend := ""
Private cUpdat := ""     
Private cContrato := ""

cQuery += " SELECT * FROM USER_FORCA_VENDAS.TBL_PEDIDO
cQuery += " WHERE FL_IMPORTADO_ERP <> 1
DbUseArea(.T., "TOPCONN", TcGenQry(,, cQuery), cAlias, .T., .T.)
DbGotop()

cQuery1 += " SELECT * FROM USER_FORCA_VENDAS.TBL_ITEM_PEDIDO IT
cQuery1 += " WHERE (SELECT FL_IMPORTADO_ERP FROM USER_FORCA_VENDAS.TBL_PEDIDO PD WHERE PD.CD_PEDIDO_AFV = IT.CD_PEDIDO_AFV) <> 1
DbUseArea(.T., "TOPCONN", TcGenQry(,, cQuery1), cAlias1, .T., .T.)

If Select("cAlias") > 1 
	(cAlias)->(DBCloseArea())
EndIf	

(cAlias)->(DbGotop())
cContrato := (cAlias)->CD_PEDIDO_AFV
While (cAlias)->(!EOF())
		
	    If cContrato == (cAlias)->CD_PEDIDO_AFV
	       	If nCont == 1 

					cDoc := GetSxeNum("SC5","C5_NUM")  
					cVend := (cAlias)->CD_PEDIDO_AFV
					AADD(aCabec,{"C5_NUM",cDoc,Nil})
			 		AADD(aCabec,{"C5_TIPO" ,"N",Nil})
					AADD(aCabec,{"C5_CLIENTE",(cAlias)->CD_CLIENTE,Nil})
					AADD(aCabec,{"C5_LOJACLI",(cAlias)->CD_LOJA,Nil})
					AADD(aCabec,{"C5_LOJAENT",(cAlias)->CD_LOJA,Nil})
					AADD(aCabec,{"C5_CONDPAG",(cAlias)->CD_CONDICAO_PAGAMENTO,Nil})
				   	AADD(aCabec,{"C5_VEND1",(cAlias)->CD_VENDEDOR,Nil})
				   	AADD(aCabec,{"C5_COMIS1",(cAlias)->PC_COMISSAO,Nil}) 
				   	AADD(aCabec,{"C5_FECENT",dDatabase,Nil})  //MENSAGEM PARA NOTA FISCAL  
					 
		   	EndIf		   			
				Aadd(aLinha,{{"C6_ITEM",StrZero(nCont,2),Nil},; // Numero do Item no Pedido
    						{"C6_PRODUTO",(cAlias1)->CD_PRODUTO,Nil},; // Codigo do Produto
    						{"C6_QTDVEN",(cAlias1)->QT_VENDIDA,Nil},;
    						{"C6_PRUNIT",(cAlias1)->VL_PRECO,Nil},;
    						{"C6_TES","503",Nil},;
             				{"C6_ENTREG",dDataBase,Nil}}) // Data da Entrega
		   	       
            cContrato := (cAlias)->CD_PEDIDO_AFV        	
            
            (cAlias)->(DBSkip())  
                
            nCont++ 
        Else    
        	cContrato := (cAlias)->CD_PEDIDO_AFV
            
            GeraPedido()
            
            aCabec := {} 
            aLinha := {}
        	nCont:= 1
        	
        	Loop
        
        EndIf     		    
EndDo
GeraPedido() //Gera Pedido do Fim de Arquivo				
	
(cAlias)->(DBCloseArea())   
(cAlias1)->(DBCloseArea())
			
Return
//GERA PEDIDO AQUI.
Static Function GeraPedido()
Begin Transaction 
			
MSExecAuto({|x,y,z|Mata410(x,y,z)},aCabec,aLinha,3)
						
If !lMsErroAuto
	cUpdat += "UPDATE USER_FORCA_VENDAS.TBL_PEDIDO "
	cUpdat += "SET FL_IMPORTADO_ERP = '1', "  
	cUpdat += "DT_IMPORTACAO_ERP = TO_DATE( '" + DTOS( dDataBase ) + "', 'yyyymmdd' )
   	cUpdat += "WHERE CD_PEDIDO_AFV = "+cValToChar(cContrato) "

	nRet = TcSqlExec(cUpdat)   

	If nRet == 0 
 		TCRefresh("USER_FORCA_VENDAS.TBL_PEDIDO")               
    	MsgAlert("Inseriu","Alerta")      
	Else
    	nRet = TCSQLERROR()
    	//MsgAlert(nRet,"Alerta")
    	Do While !Empty(nRet)
      		MsgAlert(nRet,"Alerta")                              
      		nRet = TCSQLERROR()
    	EndDo
	EndIf
	
	MsgAlert("Remessa do Contrato Gerado com Sucesso! "+cDoc)				
	cPedidos += IIf(Empty(cPedidos),"'"+cDoc+"'",","+"'"+cDoc+"'")			
	ConfirmSX8()
Else
	MsgAlert("Erro no processo de INCLUSÃO!")
	RollBAckSx8()
	MostraErro()
	lGeraNf := .F. //Nao gera nota fiscal automaticamente     
EndIf    
End Transaction 
			  
Return