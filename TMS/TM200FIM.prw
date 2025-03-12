#Include "Protheus.ch"

/*/-------------------------------------------------------------------
- Programa: TM200FIM
- Autor: Adriano Costa
- Data:27/02/2026
- Descrição: Este Ponto de Entrada, localizado no TMSA200(Cálculo do 
Frete), é executado após o final de todo o processo de gravação dos 
documentos e da geração das notas de saída.
-------------------------------------------------------------------/*/



User Function TM200FIM()

	Local cEmail    := SuperGetMv("MV_XWFTMS",,"carlosds@ercal.com.br")
    Local cCentroc  := SuperGetMv("MV_XCCTMS",,"0310401")
	Local cHtml 	:= ""
	Local cFilDoc   := PARAMIXB[1]
    Local cDocto    := PARAMIXB[2]
    Local cSerie    := PARAMIXB[3]
    Local cAliasQry
    
	cHtml := fMontaHTML()
	u_fEnvEmail('','Calculo do CTE'  , 'Calculo do CTE'  , cHtml , .F. ,cEmail)

	
        if !empty(cCentroc)

            //COMO EXISTE O PE M460FIM QUE GRAVA E1_CCC := D2_CCUSTO
            //FAÇO A GRAVACAO DO CAMPO D2_CCUSTO.
            cAliasQry := GetNextAlias()
            cQuery := "   SELECT R_E_C_N_O_ SD2_RECNO "
            cQuery += "       FROM " + RetSqlName("SD2") + " SD2 "
            cQuery += "    WHERE SD2.D2_FILIAL  = '" + xFilial('SD2') + "' "
            cQuery += "      AND SD2.D2_DOC     = '" + cDocto + "' "
            cQuery += "      AND SD2.D2_SERIE   = '" + cSerie + "' "
            cQuery += "      AND SD2.D2_CLIENTE = '" + DT6->DT6_CLIDEV + "' "
            cQuery += "      AND SD2.D2_LOJA    = '" + DT6->DT6_LOJDEV + "' "
            cQuery += "      AND SD2.D_E_L_E_T_ = ' ' "
            cQuery := ChangeQuery(cQuery)
            dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasQry)
            If (cAliasQry)->(!Eof())
                While (cAliasQry)->(!Eof())
                    SD2->(MsGoto((cAliasQry)->SD2_RECNO))

                    RecLock('SD2',.F.)
                        SD2->D2_CCUSTO := cCentroc
                    SD2->(MsUnLock())

                    (cAliasQry)->(DbSkip())
                EndDo
            EndIf
            (cAliasQry)->(DbCloseArea())

            
            cQuery := " SELECT R_E_C_N_O_ SE1_RECNO "
            cQuery += " FROM " + RetSqlName("SE1")
            cQuery += " WHERE E1_FILIAL  = '" + xFilial('SE1',cFilDoc) + "' "
            cQuery += "      AND E1_CLIENTE = '" + DT6->DT6_CLIDEV + "' "
            cQuery += "      AND E1_LOJA    = '" + DT6->DT6_LOJDEV + "' "
            cQuery += "      AND E1_PREFIXO = '" + cSerie + "' "
            cQuery += "      AND E1_NUM     = '" + cDocto + "' "
            cQuery += "      AND D_E_L_E_T_ = ' ' "
            cQuery := ChangeQuery(cQuery)
            dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasQry)
            If (cAliasQry)->(!Eof())
                While (cAliasQry)->(!Eof())
                    SE1->(MsGoto((cAliasQry)->SE1_RECNO))

                    RecLock('SE1',.F.)
                        SE1->E1_CCC := cCentroc
                    SE1->(MsUnLock())

                    (cAliasQry)->(DbSkip())
                EndDo
            EndIf
            (cAliasQry)->(DbCloseArea())

        Endif

Return(Nil)

/*/-------------------------------------------------------------------
	- Programa: fMontaHTML
	- Autor: Adriano Costa
	- Data: 22/04/2021
	- Descrição: Função que monta o html para envio do e-mail.
-------------------------------------------------------------------/*/

Static Function fMontaHTML()

	Local cHtml := ""
	

    cHtml := ' <strong>Segue o CTE faturado para '+Posicione("SA1",1,FWxFilial("SA1")+DT6->DT6_CLIDEV+DT6->DT6_LOJDEV,"A1_NOME")+' na data '+cValToChar(dDataBase)+', na hora : '+Time()+':</strong></p> '
    
    //cHtml := ' <td>Segue o CTE faturado para '+Posicione("SA1",1,FWxFilial("SA1")+DT6->DT6_CLIDEV+DT6->DT6_LOJDEV,"A1_NOME")+' na data '+cValToChar(dDataBase)+':</td></p> '
    
    cHtml += ' <br> '
    cHtml += ' <br> '
	cHtml += ' <br> '
	cHtml += ' <table border="2"> '
	cHtml += '    <tr> '
	cHtml += '       <td width="100" ><b>Notas Fiscais</b></td> '
	cHtml += '       <td width="100"><b>Data</b></td> '
	cHtml += '       <td width="300"><b>CT-e</b></td> '
	cHtml += '       <td width="1500"><b>Remetente</b></td> '
	cHtml += '       <td width="1500"><b>Destinatário</b></td> '
	cHtml += '       <td width="150"><b>Litros/Volume cobrado</b></td> '
	cHtml += '       <td width="150"><b>Tabela</b></td> '
	cHtml += '       <td width="120"><b>TARIFA</b></td> '
	cHtml += '       <td width="600"><b>ICMS</b></td> '
    cHtml += '       <td width="600"><b>Vlr Notas</b></td> '
    cHtml += '       <td width="600"><b>Vlr Frete</b></td> '
    cHtml += '       <td width="600"><b>Total</b></td> '
    cHtml += '    </tr> '
	cHtml += '    <tr> '
	cHtml += '       <td>'+AllTrim(DTC->DTC_NUMNFC)+'</td> '
	cHtml += '       <td>'+cValToChar(DT6->DT6_DATEMI)+'</td> '
	cHtml += '       <td>'+AllTrim(DT6->DT6_DOC)+'</td> '
	cHtml += '       <td>'+Posicione("SA1",1,FWxFilial("SA1")+DT6->DT6_CLIREM+DT6->DT6_LOJREM,"A1_NOME")+'</td> '
	cHtml += '       <td>'+Posicione("SA1",1,FWxFilial("SA1")+DT6->DT6_CLIDES+DT6->DT6_LOJDES,"A1_NOME")+'</td> '
	cHtml += '       <td>'+TransForm(DT6->DT6_PESCOB,X3Picture("DT6_PESCOB"))+'</td> '
	cHtml += '       <td>'+AllTrim(DT6->DT6_TABFRE)+'</td> '
	cHtml += '       <td>'+TransForm(DT1->DT1_VALOR,X3Picture("DT1_VALOR"))+'</td> '
	cHtml += '       <td>'+TransForm(DT6->DT6_VALIMP,X3Picture("DT6_VALIMP"))+'</td> '
    cHtml += '       <td>'+TransForm(DT6->DT6_VALMER,X3Picture("DT6_VALMER"))+'</td> '
    cHtml += '       <td>'+TransForm(DT6->DT6_VALFRE,X3Picture("DT6_VALFRE"))+'</td> '
    cHtml += '       <td>'+TransForm(DT6->DT6_VALTOT,X3Picture("DT6_VALTOT"))+'</td> '
	cHtml += '    </tr> '
	cHtml += ' </table> '
	cHtml += ' <br> '

Return(cHtml)
