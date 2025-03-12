#INCLUDE "rwmake.ch"
#INCLUDE "topconn.ch"   
#INCLUDE "Protheus.ch" 	

User Function GIRG015()

//Local I
Private cQry := Space(0)
Private cQry1 := Space(0)
Private cQry2 := Space(0)
Private cAlias := Criatrab(Nil,.F.)
Private cAlias1 := Criatrab(Nil,.F.)
Private cAlias2 := Criatrab(Nil,.F.)
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±º Programa ³ GIRG015  º Autor ³ CARLOS DANIEL       º Data ³   06/08/15  ±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±³Descricao³ Start de mensagem ao incluir o cliente do PDV, informando   ¹±±
±±            Se o mesmo tem inadimplencia financeira .                   ¹±±  
±±            Fonte Ativado por Gatilho                                   ¹±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Utilizacao³ ERCAL EMPRESAS REUNIDAS                                    ³±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

_nTotal:={}
_nValor:=0
//SE1->(Dbselectarea("SE1"))
//SE1->(Dbsetorder(2))
//SE1->(Dbseek(xFilial("SE1")+M->ADA_CODCLI+M->ADA_LOJCLI)) 
  
//While SE1->(!Eof()).And. SE1->E1_CLIENTE==M->ADA_CODCLI
	//If SE1->E1_SALDO>0 .And.SE1->E1_VENCTO<dDatabase
		//AADD(_nTotal ,SE1->E1_SALDO)
	//Endif
	//SE1->(DbSkip())
//End
//For I:=1 to Len(_nTotal)
	//_nTotal[I]
	//_nValor:=_nValor+_nTotal[I] 
//Next
//If _nValor>0
	//MsgBox("Cliente com Pendência Financeira de: "+Alltrim(Transform(_nValor," @E 999,999.99"))+" Consulte setor Financeiro!!!","AVISO!!!",)			  	
//Endif
IF cEmpAnt <> '50'
	cQry := " SELECT e1_cliente," 
	cQry += " ((NVL(sum(SE1.E1_SALDO),0)+"
	cQry += " 	NVL((select sum(SE2.E1_SALDO) from se1020 se2 where se2.d_e_l_e_t_ <> '*' and se2.e1_cliente = se1.e1_cliente and se2.e1_cliente = '"+M->ADA_CODCLI+"' group by se2.e1_cliente ),0))+ "
	cQry += " 	NVL((select sum(SE6.E1_SALDO) from se1060 se6 where se6.d_e_l_e_t_ <> '*' and se6.e1_cliente = se1.e1_cliente and se6.e1_cliente = '"+M->ADA_CODCLI+"' group by se6.e1_cliente ),0)) AS DIVIDA "
	cQry += " 	FROM SE1010 SE1"
	cQry += " 	WHERE SE1.d_e_l_e_t_ <> '*'"
	cQry += " 	AND e1_saldo > 0  "
	cQry += " 	AND e1_cliente = '"+M->ADA_CODCLI+"'"
	cQry += " 	AND E1_TIPO NOT IN ('RA','NCC') "
	cQry += " 	AND (E1_VENCREA < "+DTOS(dDatabase)+" OR E1_XNEG = '1')"
	cQry += " 	group by e1_cliente"
Else
	cQry := " SELECT e1_cliente," 
	cQry += " NVL(sum(SE1.E1_SALDO),0) AS DIVIDA"
	cQry += " 	FROM SE1500 SE1"
	cQry += " 	WHERE SE1.d_e_l_e_t_ <> '*'"
	cQry += " 	AND e1_saldo > 0  "
	cQry += " 	AND e1_cliente = '"+M->ADA_CODCLI+"'"
	cQry += " 	AND E1_TIPO NOT IN ('RA','NCC') "
	cQry += " 	AND (E1_VENCREA < "+DTOS(dDatabase)+" OR E1_XNEG = '1')"
	cQry += " 	group by e1_cliente"
EndIf
DbUseArea(.T., "TOPCONN", TcGenQry(,, cQry), cAlias, .T., .T.)
DbGotop()

_nValor := (cAlias)->DIVIDA
If _nValor>0
	Alert('<b><font color="#FF0000" size="06">Atenção</font></b><br><br><font size="04">Cliente com Pendencia, </font><br><br><font color="#FF0000" size="05"><b>favor consular o Financeiro</b></font><font size="04">, antes e liberar Contrato</font>') 
	//MsgBox("Cliente:"+M->ADA_CODCLI+" com Pendência, consulte setor FINANCEIRO, antes Liberar Contrato!!!","AVISO!!!",)
	//_lRet := .T. //aceita salvar pedido mesmo com restrição
	//Return(_lRet)
	//(cAlias)->(dbCloseArea())
	//(cAlias1)->(dbCloseArea())
	//(cAlias2)->(dbCloseArea())
//ELSE			
	//(cAlias)->(dbCloseArea())
	//(cAlias1)->(dbCloseArea())
	//(cAlias2)->(dbCloseArea())
Endif
Return(M->ADA_CODCLI)
//se informar .T. no lugar do (M->lq_cliente) o mesmo ficara assim(M->.T.) ele zera o campo do cliente quando devedor
