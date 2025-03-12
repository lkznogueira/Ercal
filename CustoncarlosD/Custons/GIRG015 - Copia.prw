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
		cQry := " SELECT sum(E1_SALDO) as DIVIDA FROM SE1010 SE1 "
		cQry += " WHERE SE1.d_e_l_e_t_ <> '*' "
		cQry += " AND e1_saldo > 0 " 
		cQry += " AND e1_cliente = '"+M->ADA_CODCLI+"' "	
		cQry += " AND E1_TIPO NOT IN ('RA','NCC') "
		cQry += " AND (E1_VENCREA < "+DTOS(dDatabase)+" OR E1_XNEG = '1')"
		DbUseArea(.T., "TOPCONN", TcGenQry(,, cQry), cAlias, .T., .T.)
		DbGotop()

		cQry1 := " SELECT sum(E1_SALDO) as DIVIDA FROM SE1020 SE1 "
		cQry1 += " WHERE SE1.d_e_l_e_t_ <> '*' "
		cQry1 += " AND e1_saldo > 0 "
		cQry1 += " AND e1_cliente = '"+M->ADA_CODCLI+"' "
		cQry1 += " AND E1_TIPO NOT IN ('RA','NCC') "
		cQry1 += " AND (E1_VENCREA < "+DTOS(dDatabase)+" OR E1_XNEG = '1')"
		DbUseArea(.T., "TOPCONN", TcGenQry(,, cQry1), cAlias1, .T., .T.)
		DbGotop()

		cQry2 := " SELECT sum(E1_SALDO) as DIVIDA FROM SE1060 SE1 "
		cQry2 += " WHERE SE1.d_e_l_e_t_ <> '*' "
		cQry2 += " AND e1_saldo > 0 "
		cQry2 += " AND e1_cliente = '"+M->ADA_CODCLI+"' "
		cQry2 += " AND E1_TIPO NOT IN ('RA','NCC') "
		cQry2 += " AND (E1_VENCREA < "+DTOS(dDatabase)+" OR E1_XNEG = '1')"
		DbUseArea(.T., "TOPCONN", TcGenQry(,, cQry2), cAlias2, .T., .T.)
		DbGotop()

		_nValor := (cAlias)->DIVIDA+(cAlias1)->DIVIDA+(cAlias2)->DIVIDA
		If _nValor>0
			MsgBox("Cliente:"+M->ADA_CODCLI+" com Pendência Financeira, Consulte setor Financeiro. RAMAL 1015 !!!","AVISO!!!",)
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
