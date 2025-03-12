#INCLUDE "Protheus.ch"
#INCLUDE "Totvs.ch"
#INCLUDE "topconn.ch"

/*/{Protheus.doc} MT103EXC
// Ponto de entrada para recompor saldo do contrato, caso a nota de devolução seja excluida.
@author Gontijo - 2022-04-30
/*/

User Function MT103EXC()

Local lRet       := .T.
Local aArea      := GetArea()
Local aAreaF1    := SF1->(GetArea())
Local aAreaD1    := SD1->(GetArea())
Local cTes       := Posicione('SD2',3,SD1->D1_FILIAL+SD1->D1_NFORI+SD1->D1_SERIORI,"D2_TES")
Local cNF        := SD1->D1_DOC
Local cSerie     := SD1->D1_SERIE
Local cNFOrig    := SD1->D1_NFORI
Local cSerieOrig := SD1->D1_SERIORI
Local cFilOrig   := SD1->D1_FILIAL
Local cCliOrig   := SD1->D1_FORNECE
Local cLojOrig   := SD1->D1_LOJA
Local cCtrOrig   := ""
Local cOper      := ""
Local cQryAtu    := ""

DbSelectArea('SF4')
SF4->(DbSetOrder(1))

DbSelectArea('SD2')
SD2->(DbSetOrder(3))

DbSelectArea('SD1')
SD1->(DbSetOrder(1))

DbSelectArea('ADB')
ADB->(DbSetOrder(3))

SF4->(dbGoTop())

SD2->(dbGoTop())

ADB->(dbGoTop())


    If SD2->(Dbseek(cFilOrig+cNFOrig+cSerieOrig+cCliOrig+cLojOrig))

        cCtrOrig := Posicione('SC5',1,cFilOrig+SD2->D2_PEDIDO,"C5_CONTRA")

        cOper := BuscaADB(cFilOrig,cCtrOrig)

        SD1->(dbGoTop())

        If SD1->(Dbseek(cFilOrig+cNF+cSerie+cCliOrig+cLojOrig))

            If SF4->(Dbseek(xFilial("SF4")+cTes))

            	If cOper = '55'

					If SF4->F4_DUPLIC = 'N' .and. SF4->F4_ESTOQUE = 'S' .and. SF1->F1_TIPO = 'D'					

				    	Begin Transaction      

                            While SD1->(!Eof()) .and. SD1->D1_FILIAL = cFilOrig .and. SD1->D1_DOC = cNF .and. SD1->D1_SERIE = cSerie

                                //Monta o Update
                                cQryAtu := "UPDATE "+RetSQLName('ADB')+" SET ADB_QTDEMP = (ADB_QTDEMP + "+cValToChar(SD1->D1_QUANT)+")" + CRLF
	                            cQryAtu += "WHERE D_E_L_E_T_ <> '*' "                                                                   + CRLF
 	                            cQryAtu += "AND ADB_FILIAL = '"+SD1->D1_FILIAL+"' "                                                     + CRLF
	                            cQryAtu += "AND ADB_NUMCTR = '"+cCtrOrig+"' "                                                           + CRLF
	                            cQryAtu += "AND ADB_CODCLI = '"+SD1->D1_FORNECE+"' "                                                    + CRLF  
 	                            cQryAtu += "AND ADB_LOJCLI = '"+SD1->D1_LOJA+"' "                                                       + CRLF 
 	                            cQryAtu += "AND ADB_CODPRO = '"+SD1->D1_COD+"' "                                                        + CRLF 

                                MemoWrite("C:\TEMP\cQry_ADB.txt",cQryAtu)

                                //Tenta executar o update
                                nErro := TcSqlExec(cQryAtu)

                                If nErro != 0
        
      	                        MsgStop("Erro na execução da query: "+TcSqlError(), "Atenção")
       	                
                                    DisarmTransaction()

                                EndIf

                            SD1->(dbSkip())

                            EndDo

                        End Transaction
											
					ElseIf SF4->F4_DUPLIC = 'S' .and. SF4->F4_ESTOQUE = 'N' .and. SF1->F1_TIPO = 'D'
											
                        Begin Transaction      

                            While SD1->(!Eof()) .and. SD1->D1_FILIAL = cFilOrig .and. SD1->D1_DOC = cNF .and. SD1->D1_SERIE = cSerie

                                //Monta o Update
                                cQryAtu := "UPDATE "+RetSQLName('ADB')+" SET ADB_QTDEMP = (ADB_QTDEMP - "+cValToChar(SD1->D1_QUANT)+")"   + CRLF
	                            cQryAtu += "WHERE D_E_L_E_T_ <> '*' "                                                                   + CRLF
 	                            cQryAtu += "AND ADB_FILIAL = '"+SD1->D1_FILIAL+"' "                                                     + CRLF
	                            cQryAtu += "AND ADB_NUMCTR = '"+cCtrOrig+"' "                                                           + CRLF
	                            cQryAtu += "AND ADB_CODCLI = '"+SD1->D1_FORNECE+"' "                                                    + CRLF  
 	                            cQryAtu += "AND ADB_LOJCLI = '"+SD1->D1_LOJA+"' "                                                       + CRLF 
 	                            cQryAtu += "AND ADB_CODPRO = '"+SD1->D1_COD+"' "                                                        + CRLF 

                                MemoWrite("C:\TEMP\cQry_ADB.txt",cQryAtu)

                                //Tenta executar o update
                                nErro := TcSqlExec(cQryAtu)

                                If nErro != 0
        
      	                            MsgStop("Erro na execução da query: "+TcSqlError(), "Atenção")
       	                            DisarmTransaction()

                                EndIf

                                //Monta o Update
                                cQryAtuTot := "UPDATE "+RetSQLName('ADB')+" SET ADB_TOTAL = ADB_QUANT * ADB_PRCVEN"                        + CRLF
	                            cQryAtuTot += "WHERE D_E_L_E_T_ <> '*' "                                                                   + CRLF
 	                            cQryAtuTot += "AND ADB_FILIAL = '"+SD1->D1_FILIAL+"' "                                                     + CRLF
	                            cQryAtuTot += "AND ADB_NUMCTR = '"+cCtrOrig+"' "                                                           + CRLF
	                            cQryAtuTot += "AND ADB_CODCLI = '"+SD1->D1_FORNECE+"' "                                                    + CRLF  
 	                            cQryAtuTot += "AND ADB_LOJCLI = '"+SD1->D1_LOJA+"' "                                                       + CRLF 
 	                            cQryAtuTot += "AND ADB_CODPRO = '"+SD1->D1_COD+"' "                                                        + CRLF 

                                MemoWrite("C:\TEMP\cQry_ADB.txt",cQryAtuTot)

                                //Tenta executar o update
                                nErro := TcSqlExec(cQryAtuTot)

                                If nErro != 0
        
      	                            MsgStop("Erro na execução da query: "+TcSqlError(), "Atenção")
       	                            DisarmTransaction()

                                EndIf

                            SD1->(dbSkip())

                            EndDo

                        End Transaction

					EndIF

				ElseIf cOper = '70' //Contrato só tem notas de remessa, caso seja devolvido, a quantidade devolvida deve voltar a compor novamente o saldo do contrato 
							
				    	Begin Transaction      

                            While SD1->(!Eof()) .and. SD1->D1_FILIAL = cFilOrig .and. SD1->D1_DOC = cNF .and. SD1->D1_SERIE = cSerie

                                //Monta o Update
                                cQryAtu := "UPDATE "+RetSQLName('ADB')+" SET ADB_QTDEMP = (ADB_QTDEMP + "+cValToChar(SD1->D1_QUANT)+")" + CRLF
	                            cQryAtu += "WHERE D_E_L_E_T_ <> '*' "                                                                   + CRLF
 	                            cQryAtu += "AND ADB_FILIAL = '"+SD1->D1_FILIAL+"' "                                                     + CRLF
	                            cQryAtu += "AND ADB_NUMCTR = '"+cCtrOrig+"' "                                                           + CRLF
	                            cQryAtu += "AND ADB_CODCLI = '"+SD1->D1_FORNECE+"' "                                                    + CRLF  
 	                            cQryAtu += "AND ADB_LOJCLI = '"+SD1->D1_LOJA+"' "                                                       + CRLF 
 	                            cQryAtu += "AND ADB_CODPRO = '"+SD1->D1_COD+"' "                                                        + CRLF 

                                MemoWrite("C:\TEMP\cQry_ADB.txt",cQryAtu)

                                //Tenta executar o update
                                nErro := TcSqlExec(cQryAtu)

                                If nErro != 0
        
      	                        MsgStop("Erro na execução da query: "+TcSqlError(), "Atenção")
       	                
                                    DisarmTransaction()

                                EndIf

                            SD1->(dbSkip())

                            EndDo

                        End Transaction

				ElseIf cOper = '50'	//Contrato de venda direta, caso seja devolvido, deverá zerar o saldo do contrato e encerrar o mesmo	

				    	Begin Transaction      

                            While SD1->(!Eof()) .and. SD1->D1_FILIAL = cFilOrig .and. SD1->D1_DOC = cNF .and. SD1->D1_SERIE = cSerie

                                //Monta o Update
                                cQryAtu := "UPDATE "+RetSQLName('ADB')+" SET ADB_QTDEMP = 0"                                            + CRLF
	                            cQryAtu += "WHERE D_E_L_E_T_ <> '*' "                                                                   + CRLF
 	                            cQryAtu += "AND ADB_FILIAL = '"+SD1->D1_FILIAL+"' "                                                     + CRLF
	                            cQryAtu += "AND ADB_NUMCTR = '"+cCtrOrig+"' "                                                           + CRLF
	                            cQryAtu += "AND ADB_CODCLI = '"+SD1->D1_FORNECE+"' "                                                    + CRLF  
 	                            cQryAtu += "AND ADB_LOJCLI = '"+SD1->D1_LOJA+"' "                                                       + CRLF 
 	                            cQryAtu += "AND ADB_CODPRO = '"+SD1->D1_COD+"' "                                                        + CRLF 

                                MemoWrite("C:\TEMP\cQry_ADB.txt",cQryAtu)

                                //Tenta executar o update
                                nErro := TcSqlExec(cQryAtu)

                                If nErro != 0
        
      	                        MsgStop("Erro na execução da query: "+TcSqlError(), "Atenção")
       	                
                                    DisarmTransaction()

                                EndIf

                            SD1->(dbSkip())

                            EndDo

                                //Monta o Update
                                cQryAtu := "UPDATE "+RetSQLName('ADA')+" SET ADA_STATUS = 'E'"                 + CRLF
	                            cQryAtu += "WHERE D_E_L_E_T_ <> '*' "                                          + CRLF
 	                            cQryAtu += "AND ADA_FILIAL = '"+cFilOrig+"' "                                  + CRLF
	                            cQryAtu += "AND ADA_NUMCTR = '"+cCtrOrig+"' "                                  + CRLF
	                            cQryAtu += "AND ADA_CODCLI = '"+cCliOrig+"' "                                  + CRLF  
 	                            cQryAtu += "AND ADA_LOJCLI = '"+cLojOrig+"' "                                  + CRLF 

                                MemoWrite("C:\TEMP\cQry_ADA.txt",cQryAtu)

                                //Tenta executar o update
                                nErro := TcSqlExec(cQryAtu)

                                If nErro != 0
        
      	                            MsgStop("Erro na execução da query: "+TcSqlError(), "Atenção")
       	                            DisarmTransaction()

                                EndIf

                        End Transaction				
						
				EndIf	      

            EndIf
        
        Endif

    EndIf

SF4->(dbCloseArea())
SD2->(dbCloseArea())

RestArea(aArea)
RestArea(aAreaF1)
RestArea(aAreaD1)

Return lReT

Static Function BuscaADB(cFilOrig,cCtrOrig)

Local cOper    := ""
Local cQryOper := ""

If Select("cQryOper") > 0                                 
     cQryOper->(dbclosearea())
EndIf 

	cQryOper := "SELECT ADB_XTIPO AS OPERACAO "                                       + CRLF
    cQryOper += "FROM "+RetSqlName( "ADB" ) + " ADB "                                 + CRLF
	cQryOper += "WHERE ADB.D_E_L_E_T_ <> '*' "                                        + CRLF
 	cQryOper += "AND ADB_FILIAL = '"+cFilOrig+"' "                                    + CRLF
 	cQryOper += "AND ADB_NUMCTR = '"+cCtrOrig+"' "                                    + CRLF

	MemoWrite("C:\TEMP\cQryOper.txt",cQryOper)
	cQryOper := ChangeQuery(cQryOper)

	TcQuery cQryOper New Alias "cQryOper" // Cria uma nova area com o resultado do query

	cOper := cQryOper->OPERACAO

Return cOper
