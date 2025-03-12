#INCLUDE "Protheus.ch"
#INCLUDE "Totvs.ch"
#INCLUDE "topconn.ch"

/*/{Protheus.doc} MFAT102
// Rotina para atualização do preço dos produtos do contrato de parceria.
@author Gontijo - 2022-04-30
/*/

User Function MFAT103

Local cQry        := ""
Local cQryADB     := ""
Local cQryAtu     := ""
Local nMaxNum     := ""
Local cTpOper     := ""
Local nCount      := 0
Local nSaldo      := 0
Local nPrcVen     := 0
Local lGrava      := .F.
Local lPrint      := .F.
Local lok         := .F.
Local lCnt        := u_xBlqCtr()
Local oFWMsExcel
Local oExcel
Local cArquivo    := 'c:\temp\MFAT103.xls'

//Variáveis MVs
Local mvFilial   := ""
Local mvContrato := ""
Local mvCliente  := ""
Local mvProduto  := ""
Local mvTipo     := ""

If !lCnt

	    Alert("Usuário sem acesso a rotina de atualização de preço.")

	    Return

Endif

If !(Pergunte('MFAT103',.T.))

	    Alert("Cancelado pelo usuario!")

	    Return

Endif

mvFilial   := u_RetMV(MV_PAR01,',')
mvContrato := u_RetMV(MV_PAR02,',')
mvCliente  := u_RetMV(MV_PAR03,',')
mvProduto  := u_RetMV(MV_PAR08,',')
mvTipo     := u_RetMV(MV_PAR09,',')

    If Select("cQry") > 0                                 
     
        cQry->(dbclosearea())

    EndIf   

	cQry := "SELECT * "
    cQry += "FROM "+RetSqlName( "ADA" ) + " ADA "
	cQry += "INNER JOIN "+RetSqlName( "ADB" ) +" ADB ON ADA_FILIAL = ADB_FILIAL "
    cQry += "AND ADA_NUMCTR =  ADB_NUMCTR "	                                     
    cQry += "AND ADA_CODCLI =  ADB_CODCLI "	 
    cQry += "AND ADA_LOJCLI =  ADB_LOJCLI "	 	
	cQry += "WHERE ADA.D_E_L_E_T_ <> '*' "
	cQry += "AND ADB.D_E_L_E_T_ <> '*' "	
	cQry += "AND ADA_STATUS NOT IN ('E','D') "	
	If !Empty(mvFilial)
 		cQry += "AND ADA_FILIAL IN ("+mvFilial+") " 
	EndIf  
	If !Empty(mvContrato)
		cQry += "AND ADA_NUMCTR IN ("+mvContrato+") " 
	EndIf      
	If !Empty(mvCliente)
		cQry += "AND ADA_CODCLI IN ("+mvCliente+") "     
	EndIf          
 	cQry += "AND ADA_EMISSA >= '"+DtoS(MV_PAR04)+"' "   
	cQry += "AND ADA_EMISSA <= '"+DtoS(MV_PAR05)+"' "   
 	cQry += "AND ADA_XVENC  >= '"+DtoS(MV_PAR06)+"' "   
	cQry += "AND ADA_XVENC  <= '"+DtoS(MV_PAR07)+"' "       
	If !Empty(mvProduto)
 		cQry += "AND ADB_CODPRO IN ("+mvProduto+") "  
	EndIf   
	If !Empty(mvTipo)     
 		cQry += "AND ADB_XTIPO  IN ("+mvTipo+") " 
	EndIf   

	MemoWrite("C:\TEMP\ADB.txt",cQry)
	cQry := ChangeQuery(cQry)

	TcQuery cQry New Alias "cQry" // Cria uma nova area com o resultado do query

    Count to nCount

    If nCount <= 0

        MsgStop( 'Nenhum registro foi encontrado com os parametros informados, por favor verifique os parametros.', 'Atencao' )

        Return()

    EndIf

    cQry->(DbGoTop()) 
	
    Begin Transaction      

	While !cQry->(EOF())

        //Monta o Update
        cQryAtu := "UPDATE "+RetSQLName('ADA')+" SET ADA_STATUS = 'E'"                 + CRLF
	    cQryAtu += "WHERE D_E_L_E_T_ <> '*' "                                          + CRLF
 	    cQryAtu += "AND ADA_FILIAL = '"+cQry->ADA_FILIAL+"' "                          + CRLF
	    cQryAtu += "AND ADA_NUMCTR = '"+cQry->ADA_NUMCTR+"' "                          + CRLF
	    cQryAtu += "AND ADA_CODCLI = '"+cQry->ADA_CODCLI+"' "                          + CRLF  
 	    cQryAtu += "AND ADA_LOJCLI = '"+cQry->ADA_LOJCLI+"' "                          + CRLF 
 	    cQryAtu += "AND ADA_EMISSA = '"+cQry->ADA_EMISSA+"' "                          + CRLF
 	    cQryAtu += "AND ADA_XVENC  = '"+cQry->ADA_XVENC+"' "                           + CRLF 

        MemoWrite("C:\TEMP\cQry_ADA.txt",cQryAtu)

            //Tenta executar o update
            nErro := TcSqlExec(cQryAtu)

            If nErro != 0
        
      	        MsgStop("Erro na execução da query: "+TcSqlError(), "Atenção")
       	        DisarmTransaction()

            Else

				//Busca Maior Numero

				nMaxNum := Soma1(MaxNumCtr(cQry->ADA_FILIAL))

				//Busca Tipo de Operação

				cTpOper := Posicione('ADB',1,cQry->ADA_FILIAL+cQry->ADA_NUMCTR,'ADB_XTIPO')

				//RecLock ADA

				RecLock("ADA", .T.)
    			
					ADA->ADA_FILIAL    := cQry->ADA_FILIAL 
					ADA->ADA_NUMCTR    := nMaxNum
					ADA->ADA_EMISSA    := dDataBase
					ADA->ADA_CODCLI    := cQry->ADA_CODCLI
					ADA->ADA_LOJCLI    := cQry->ADA_LOJCLI
					ADA->ADA_XEST      := cQry->ADA_XEST 
					ADA->ADA_CONDPG    := cQry->ADA_CONDPG 
					ADA->ADA_XPED      := cQry->ADA_XPED  
					ADA->ADA_TABELA    := cQry->ADA_TABELA  
					ADA->ADA_VEND1     := cQry->ADA_VEND1
					ADA->ADA_COMIS1    := cQry->ADA_COMIS1 
					ADA->ADA_MOEDA     := cQry->ADA_MOEDA 
					ADA->ADA_TIPLIB    := cQry->ADA_TIPLIB 
					ADA->ADA_STATUS    := Iif(cTpOper = '55','A','B') 
					ADA->ADA_XNOMC     := cQry->ADA_XNOMC 
					ADA->ADA_XNATUR    := cQry->ADA_XNATUR
					ADA->ADA_TPFRET    := cQry->ADA_TPFRET 
					ADA->ADA_ESPECI    := cQry->ADA_ESPECI
					ADA->ADA_VOLUME    := cQry->ADA_VOLUME
					ADA->ADA_MARCA     := cQry->ADA_MARCA 
					ADA->ADA_XFRETE    := cQry->ADA_XFRETE
					ADA->ADA_XDESP     := cQry->ADA_XDESP 
					ADA->ADA_XBANCO    := cQry->ADA_XBANCO 
					ADA->ADA_XADIAN    := cQry->ADA_XADIAN 
					ADA->ADA_XMENOT    := cQry->ADA_XMENOT
					ADA->ADA_XCOMPL    := cQry->ADA_XCOMPL
					ADA->ADA_FRETE     := cQry->ADA_FRETE 
					ADA->ADA_XVENC     := dDataBase+30
					ADA->ADA_XOBS      := cQry->ADA_XOBS
					ADA->ADA_MSBLQL    := cQry->ADA_MSBLQL
					//ADA->ADA_CTRORI    := cQry->ADA_NUMCTR

				ADA->(MsUnlock())
			
				//RecLock ADB

				If Select("cQryADB") > 0                                 
     
        			cQryADB->(dbclosearea())

    			EndIf   

				cQryADB := "SELECT * "                                                         + CRLF
    			cQryADB += "FROM "+RetSqlName( "ADB" ) + " ADB "                               + CRLF
	    		cQryADB += "WHERE ADB.D_E_L_E_T_ <> '*' "                                      + CRLF
 	    		cQryADB += "AND ADB_FILIAL = '"+cQry->ADA_FILIAL+"' "                          + CRLF
	    		cQryADB += "AND ADB_NUMCTR = '"+cQry->ADA_NUMCTR +"' "                         + CRLF
	    		cQryADB += "AND ADB_CODCLI = '"+cQry->ADA_CODCLI+"' "                          + CRLF  
 	    		cQryADB += "AND ADB_LOJCLI = '"+cQry->ADA_LOJCLI+"' "                          + CRLF 

				MemoWrite("C:\TEMP\ADB.txt",cQryADB)
				cQryADB := ChangeQuery(cQryADB)

				TcQuery cQryADB New Alias "cQryADB" // Cria uma nova area com o resultado do query

				While !cQryADB->(EOF())

				nSaldo := cQryADB->ADB_QUANT - cQryADB->ADB_QTDEMP

					//Reclock ADB
				If nSaldo > 0

					nPrcVen := BuscaPreco(cQryADB->ADB_FILIAL,cQryADB->ADB_CODPRO,cQry->ADA_XEST,cQry->ADA_TABELA,cQry->ADA_CODCLI, cQry->ADA_LOJCLI)

					nPrcVen := Iif(nPrcVen > 0, nPrcVen, cQryADB->ADB_PRCVEN)  
				
					RecLock("ADB", .T.)
    			
					ADB->ADB_FILIAL    := cQryADB->ADB_FILIAL   
					ADB->ADB_NUMCTR    := nMaxNum
					ADB->ADB_ITEM      := cQryADB->ADB_ITEM  
					ADB->ADB_CODPRO    := cQryADB->ADB_CODPRO 
					ADB->ADB_DESPRO    := cQryADB->ADB_DESPRO 
					ADB->ADB_UM        := cQryADB->ADB_UM  
					ADB->ADB_QUANT     := nSaldo
					ADB->ADB_PRCVEN    := nPrcVen 
					ADB->ADB_TOTAL     := Round(nSaldo * nPrcVen,2) 
					ADB->ADB_XTIPO     := cQryADB->ADB_XTIPO 
					ADB->ADB_TES       := cQryADB->ADB_TES  
					ADB->ADB_TESCOB    := cQryADB->ADB_TESCOB 
					ADB->ADB_LOCAL     := cQryADB->ADB_LOCAL 
					ADB->ADB_PRUNIT    := cQryADB->ADB_PRUNIT 
					ADB->ADB_SEGUM     := cQryADB->ADB_SEGUM
					ADB->ADB_UNSVEN    := cQryADB->ADB_UNSVEN 
					ADB->ADB_DESC      := cQryADB->ADB_DESC
					ADB->ADB_VALDES    := cQryADB->ADB_VALDES
					ADB->ADB_FILENT    := cQryADB->ADB_FILENT
					ADB->ADB_QTDENT    := 0
					ADB->ADB_PEDCOB    := cQryADB->ADB_PEDCOB
					ADB->ADB_CODCLI    := cQryADB->ADB_CODCLI 
					ADB->ADB_LOJCLI    := cQryADB->ADB_LOJCLI
		
					ADB->(MsUnlock())

					lGrava := .T.

				EndIf 

    			cQryADB->(DbSkip())

    			Enddo

				If !lGrava
        
      	        MsgStop("Nenhum produto possui saldo para atulização de preço. Por favor verifique os parametros.", "Atenção")
       	        DisarmTransaction()

            	EndIf
            
				lOk    := .T.

				lPrint := .T.
			
		    EndIf

    cQry->(DbSkip())

    Enddo

	End Transaction

	If lOk 

		MsgAlert("Os contratos foram atualizados com sucesso !!!","Atenção")

	EndIf

	If lPrint

    	If MsgYesNo('Deseja imprimir os contratos que foram alterados ?', 'Atenção')

        	oFWMsExcel := FWMSExcel():New()
	    	oFWMsExcel:AddworkSheet("MFAT103") 
	    	oFWMsExcel:AddTable("MFAT103","Contratos")

        	oFWMsExcel:AddColumn("MFAT103","Contratos","Filial",1)
			oFWMsExcel:AddColumn("MFAT103","Contratos","Contrato",1)
			oFWMsExcel:AddColumn("MFAT103","Contratos","Cliente",1)
			oFWMsExcel:AddColumn("MFAT103","Contratos","Loja",1)
			oFWMsExcel:AddColumn("MFAT103","Contratos","Emissao",1)
			oFWMsExcel:AddColumn("MFAT103","Contratos","Vencimento",1)

            	cQry->(DbGoTop())

            	While !cQry->(EoF())

            			oFWMsExcel:AddRow("MFAT103","Contratos",{;
 												padc(cQry->ADA_FILIAL,10),;
												padc(cQry->ADA_NUMCTR,10),; 
												padc(cQry->ADA_CODCLI,10),;
												padc(cQry->ADA_LOJCLI,10),;
												padc(cQry->ADA_EMISSA,10),;
												padc(cQry->ADA_XVENC,10) })


            	cQry->(DbSkip())
	
	          	EndDo

            	//Ativando o arquivo e gerando o xml
		        oFWMsExcel:Activate()
		        oFWMsExcel:GetXMLFile(cArquivo)

            	If !ApOleClient("MsExcel")
			            
                    MsgStop("Microsoft Excel nao instalado.") 

                Else

                //Abrindo o excel e abrindo o arquivo xml
		            oExcel := MsExcel():New()             //Abre uma nova conexão com Excel
		            oExcel:WorkBooks:Open(cArquivo)     //Abre uma planilha
		            oExcel:SetVisible(.T.)                 //Visualiza a planilha
		            oExcel:Destroy()                        //Encerra o processo do gerenciador de tarefas
			
		        EndIf

            cQry->(DbGoTop())

    	EndIf

	EndIf

Return

Static Function MaxNumCtr(CFilOrig)

Local cNumCtr := ""
Local cQryMax := ""

	
    If Select("cQryMax") > 0                                 
     
        cQryMax->(dbclosearea())

    EndIf   

	cQryMax := "SELECT MAX(ADA_NUMCTR) AS NUMCTR "                                 + CRLF
    cQryMax += "FROM "+RetSqlName( "ADA" ) + " ADA "                               + CRLF
 	cQryMax += "WHERE ADA_FILIAL = '"+CFilOrig+"' "                                + CRLF

	MemoWrite("C:\TEMP\cQryMax.txt",cQryMax)
	cQryMax := ChangeQuery(cQryMax)

	TcQuery cQryMax New Alias "cQryMax" // Cria uma nova area com o resultado do query

	cNumCtr := cQryMax->NUMCTR

Return cNumCtr

Static Function BuscaPreco(cFilPrc,cProdPrc,cEst,cTabela,cCliente,cLoja)

Local nPreco  := 0
Local cQryPrc := ""
Local cContri := Posicione("SA1",1,xFILIAL("SA1")+cCliente+cLoja,"A1_CONTRIB")
Local cEstado := Posicione("SA1",1,xFILIAL("SA1")+cCliente+cLoja,"A1_EST")

	If Select("cQryPrc") > 0                                 
     
    	cQryPrc->(dbclosearea())

    EndIf   

	cQryPrc := "SELECT DA1_PRCVEN AS PRECO "                                         + CRLF
    cQryPrc += "FROM "+RetSqlName( "DA0" ) + " DA0 "                                 + CRLF
    cQryPrc += "INNER JOIN "+RetSqlName( "DA1" ) +" DA1 ON DA0_FILIAL = DA1_FILIAL " + CRLF
    cQryPrc += "AND DA0_CODTAB =  DA1_CODTAB "	                                     + CRLF
	cQryPrc += "WHERE DA0.D_E_L_E_T_ <> '*' "                                        + CRLF
	cQryPrc += "AND DA1.D_E_L_E_T_ <> '*' "                                          + CRLF
	cQryPrc += "AND DA0_ATIVO = '1' "                                                + CRLF
 	cQryPrc += "AND DA0_FILIAL = '"+cFilPrc+"' "                                     + CRLF
 	cQryPrc += "AND DA1_CODPRO = '"+cProdPrc+"' "                                    + CRLF
	If cEstado <> 'MG' .and. cContri = '1'
 		cQryPrc += "AND DA1_ESTADO = '"+cEst+"' "                                    + CRLF
	Else
 		cQryPrc += "AND DA1_ESTADO = 'MG' "                                          + CRLF
	EndIf
	cQryPrc += "AND DA0_CODTAB = '"+cTabela+"' "                                     + CRLF

	MemoWrite("C:\TEMP\cQryPrc.txt",cQryPrc)
	cQryPrc := ChangeQuery(cQryPrc)

	TcQuery cQryPrc New Alias "cQryPrc" // Cria uma nova area com o resultado do query

	nPreco := cQryPrc->PRECO

Return nPreco


