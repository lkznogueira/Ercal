//nome na tela aprovacao compras
// Carlos Daniel -- 22-03-2023

User function ColCNA

Local cContr := TRIM(SCR->CR_NUM)
Local cFil := TRIM(SCR->CR_FILIAL)
local cCodigo := ' '
Local cLojfor := ' '
local cFOr := ' '//Posicione("SA2",1,xFilial("SA2")+cCodigo+cLojfor,"A2_NOME")
Private cQry := Space(0) 
Private cAlias := Criatrab(Nil,.F.)

cQry += "SELECT"  
cQry += " CASE LENGTH(TRIM(CR_NUM))"
cQry += " WHEN 15 THEN (SELECT CNA_FORNEC FROM "+RetSqlName("CNA") +" CNA WHERE CNA.D_E_L_E_T_ <> '*' AND CNA_CONTRA LIKE TRIM('"+cContr+"') AND CNA_FILIAL = TRIM('"+cFil+"') AND ROWNUM = 1)"
cQry += " WHEN 6 THEN (SELECT C7_FORNECE FROM "+RetSqlName("SC7") +" SC7 WHERE SC7.D_E_L_E_T_ <> '*' AND C7_NUM LIKE TRIM('"+cContr+"') AND C7_FILIAL = TRIM('"+cFil+"') AND ROWNUM = 1)"
cQry += " ELSE ' '"
cQry += " END FORNECE,"
cQry += " CASE LENGTH(TRIM(CR_NUM))"
cQry += " WHEN 15 THEN (SELECT CNA_LJFORN FROM "+RetSqlName("CNA") +" CNA WHERE CNA.D_E_L_E_T_ <> '*' AND CNA_CONTRA LIKE TRIM('"+cContr+"') AND CNA_FILIAL = TRIM('"+cFil+"') AND ROWNUM = 1)"
cQry += " WHEN 6 THEN (SELECT C7_LOJA FROM "+RetSqlName("SC7") +" SC7 WHERE SC7.D_E_L_E_T_ <> '*' AND C7_NUM LIKE TRIM('"+cContr+"') AND C7_FILIAL = TRIM('"+cFil+"') AND ROWNUM = 1)"
cQry += " ELSE ' '"
cQry += " END LOJA"
cQry += " FROM "+RetSqlName("SCR") +" SCR1"
cQry += " WHERE SCR1.D_E_L_E_T_ <> '*'"
cQry += " AND TRIM(CR_NUM) = TRIM('"+cContr+"')"
cQry += " AND TRIM(CR_FILIAL) = TRIM('"+cFil+"')"
cQry += " AND ROWNUM = 1

DbUseArea(.T., "TOPCONN", TcGenQry(,, cQry), cAlias, .T., .T.)
DbGotop() 
cCodigo := (cAlias)->FORNECE
cLojfor := (cAlias)->LOJA

cFOr := Posicione("SA2",1,xFilial("SA2")+cCodigo+cLojfor,"A2_NOME")

(cAlias)->(dbCloseArea())

Return cFOr
//SCR->CR_NUM SCR->CR_FILIAL
