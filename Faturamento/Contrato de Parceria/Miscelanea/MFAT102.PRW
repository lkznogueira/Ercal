#INCLUDE "Protheus.ch"
#INCLUDE "Totvs.ch"
#INCLUDE "topconn.ch"

/*/{Protheus.doc} MFAT102
// Rotina para atualização do vencimento do contrato de parceria.
@author Gontijo - 2022-04-30
/*/

User Function MFAT102

Local cQry        := ""
Local cQryAtu     := ""
Local nCount      := 0
Local lPrint      := .F.
Local lOk         := .T.
Local lCnt        := u_xBlqCtr()
Local oFWMsExcel
Local oExcel
Local cArquivo    := 'c:\temp\MFAT102.xls'

//Variáveis MVs
Local mvFilial   := ""
Local mvContrato := ""
Local mvCliente  := ""
Local mvTipo     := ""

If !lCnt

	    Alert("Usuário sem acesso a rotina de atualização de vencimento.")

	    Return

Endif

If !(Pergunte('MFAT102',.T.))

	    Alert("Cancelado pelo usuario!")

	    Return

Endif

mvFilial   := u_RetMV(MV_PAR01,',')
mvContrato := u_RetMV(MV_PAR02,',')
mvCliente  := u_RetMV(MV_PAR03,',')
mvTipo     := u_RetMV(MV_PAR08,',')

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
	If !Empty(mvTipo)     
 		cQry += "AND ADB_XTIPO  IN ("+mvTipo+") " 
	EndIf

	MemoWrite("C:\TEMP\ADA.txt",cQry)
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
        cQryAtu := "UPDATE "+RetSQLName('ADA')+" SET ADA_XVENC = '"+DtoS(MV_PAR09)+"'" + CRLF
	    cQryAtu += "WHERE D_E_L_E_T_ <> '*' "                                          + CRLF
 	    cQryAtu += "AND ADA_FILIAL = '"+cQry->ADA_FILIAL+"' "                          + CRLF
	    cQryAtu += "AND ADA_NUMCTR = '"+cQry->ADA_NUMCTR +"' "                         + CRLF
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

            else

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
	    	oFWMsExcel:AddworkSheet("MFAT102") 
	    	oFWMsExcel:AddTable("MFAT102","Contratos")

        	oFWMsExcel:AddColumn("MFAT102","Contratos","Filial",1)
			oFWMsExcel:AddColumn("MFAT102","Contratos","Contrato",1)
			oFWMsExcel:AddColumn("MFAT102","Contratos","Cliente",1)
			oFWMsExcel:AddColumn("MFAT102","Contratos","Loja",1)
			oFWMsExcel:AddColumn("MFAT102","Contratos","Emissao",1)
			oFWMsExcel:AddColumn("MFAT102","Contratos","Vencimento",1)

            	cQry->(DbGoTop())

            	While !cQry->(EoF())

            			oFWMsExcel:AddRow("MFAT102","Contratos",{;
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
