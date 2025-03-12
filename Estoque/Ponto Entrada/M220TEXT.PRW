#include "rwmake.ch"
#include "TbiConn.ch"
#include "protheus.ch"
/*
________________________________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-------------------------------------------------------------------------------------------+                                                             ¦¦
¦¦¦Programa  ¦ M200TEXT ¦ Autor ¦ Innovare Solucoes   ¦ Data ¦ 12/07/13                        ¦¦¦
¦¦+----------+--------------------------------------------------------------------------------                                                            ¦¦¦
¦¦¦Descriçào ¦ Ponto de entrada para incluir a unidade de Medida na arvore de estrutura de prod¦¦¦
¦¦¦          ¦ Este codigo e executa na abertura da arvore de estrutura de produto                                             ¦¦¦
¦¦¦          ¦ Chamado pela rotina MATA200 - Estrutura de produto                                                                       ¦¦¦
¦¦+----------+-------------------------------------------------------------------------------                                                              ¦¦¦
¦¦¦ Uso      ¦ Montividiu                                                                                                                                                 ¦¦¦
¦¦+----------+--------------------------------------------------------------------------------                                                            ¦¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
*/
User Function M200TEXT()      

Local aArea    := GetArea()
Local aAreaSB1 := SB1->(GetArea())
Local cQuant   := ""
Local cTextOri := ParamIXB[1]// Texto original, já com o TRT e a QTDE adicionados por padrão do sistema

Local cPai     := ParamIXB[2] // Código do item pai
Local cTRT     := ParamIXB[3] // Sequencia TRT do item na estrutura
Local cComp    := ParamIXB[4] // Código do componente que está sendo inserido na árvore
Local nQuant   := ParamIXB[5] // Quantidade do item na estrutura
Local nTamCod  := TamSX3("B1_COD")
Local nTamQtd  := TamSX3("G1_QUANT")
Local cReturn  := ""          // retorno do PE

If !(Empty(cComp))   
					
					 SB1->(dbSetOrder(1))  
									 	
				 	If SB1->(dbSeek(xFilial("SB1") + cComp, .F.)) // Posiciona no produto para obter sua descrição        
							  cReturn := AllTrim(cComp) + " - " + RTRIM(SB1->B1_DESC) + " - "+RTRIM(SB1->B1_UM) + IIF(nQuant == 0,space(50)," - "+AllTrim(Str(nQuant, nTamQtd[1], nTamQtd[2])))      
						EndIf	    
					If !Empty(cTRT)       
			  				 cReturn += " | "+cTRT 
			    	EndIf

Else   
	 cReturn := cTextOri
EndIf

RestArea(aAreaSB1)
RestArea(aArea)

Return cReturn // novo texto a ser apresentado na árvore da estrutura