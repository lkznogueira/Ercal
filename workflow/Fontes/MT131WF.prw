#include "rwmake.ch"
#include "TbiConn.ch"
#include "TopConn.ch"
#include "TbiCode.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MT130WF   ºAutor  ³Anderson Machado    º Data ³  18/11/08   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Ponto de entrada para envio de Workflow na apos confirmacao º±±
±±º          ³ da Geracao de Cotacao                                      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ CARROCERIAS FLACH	                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function MT131WF(oProcess)

	Local aCond:={}, aItensUpg := {}
	Local _cC8_NUM, _cC8_FORNECE, _cC8_LOJA
	Local _cEmlFor, _ix_upg, _cC8_RecNO
	Local cUsermail, cMailID
	Local _AreaSC8 := SC8->( GetArea() )
	Local _AreaSE4 := SE4->( GetArea() )
	Local _AreaSB1 := SB1->( GetArea() )
//Local cEmailComp
	Local nDiasTime
	Local cWfWs    := GetMv("MV_WFWS")
	Local cWfDir   := GetMv("MV_WFDIR")
	Private cRelFrom := GetMv("MV_RELFROM",," ")
	Private cRelaCnt := GetMV("MV_RELACNT")
	Private cEmailComp
	Private cNameEmp:=Alltrim(SM0->M0_NOME)

/*** Atualiza a variavel quando nao for a rotina automatica do configurador ***/
	If len( PswRet() ) # 0
		cUsermail := PswRet()[1][14]
	EndIF
Return()//retirar

/***  Gera uma tabela com todas as informacoes necessarias e vinculos necessarios
Para facilitar a cotacao os itens sao Ordenados pela Descricao ***/
cQuery := 'SELECT SC8.C8_WFCO, SC8.C8_WFEMAIL, SC8.C8_WFID, SC8.C8_NUM, SC8.C8_VALIDA, SC8.C8_FILIAL, SC8.C8_CONTATO, TRIM(UTL_RAW.CAST_TO_VARCHAR2(SC8.C8_OBS)) C8_OBS, SC8.C8_OBSFOR, '
cQuery += 'SC8.C8_ITEM, SC8.C8_PRODUTO, SC8.C8_QUANT, SC8.C8_UM, SC8.C8_DATPRF, SA2.A2_COD, SA2.A2_LOJA, '
cQuery += 'SA2.A2_NOME, SA2.A2_END, SA2.A2_MUN, SA2.A2_BAIRRO, SA2.A2_TEL, SA2.A2_FAX, SA2.A2_EMAIL, SB1.B1_COD, SB1.B1_DESC, SC8.R_E_C_N_O_ '
cQuery += 'FROM ' + RetSqlName("SC8") + ' SC8, ' + RetSqlName("SA2") + ' SA2, ' + RetSqlName("SB1") + ' SB1 '
cQuery += 'WHERE SC8.C8_FORNECE=SA2.A2_COD AND  SC8.C8_LOJA=SA2.A2_LOJA '
cQuery += 'AND SC8.C8_PRODUTO = SB1.B1_COD '
cQuery += "AND SC8.C8_FILIAL = '" + xFilial("SC8") + "' AND SA2.A2_FILIAL = '" + xFilial("SA2") + "' "
cQuery += "AND SC8.D_E_L_E_T_ = ' ' AND SA2.D_E_L_E_T_ = ' ' AND SB1.D_E_L_E_T_ = ' ' "
cQuery += "AND SC8.C8_FILIAL = '"+xFilial("SC8")+"' AND SC8.C8_NUM = '"+ParamIXB[1]+"'"
cQuery += ' ORDER BY SC8.C8_FILIAL, SC8.C8_NUM, SA2.A2_COD, SA2.A2_LOJA, SB1.B1_DESC'

cQuery := ChangeQuery(cQuery)
memowrite("c:\temp\sqlwf.txt",cQuery)

TCQUERY cQuery NEW ALIAS "WAFORNEC"  

//dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"EMPENTREGA",.T.,.T.)


/*** Gera um laco para para possibilitar que sera executados todos os itens da cotacao ***/
while !WAFORNEC->( eof() ) .and. xFilial("SC8")+ParamIXB[1] == (WAFORNEC->C8_FILIAL+WAFORNEC->C8_NUM)
	
	/*** Verifica se a cotacao ja foi respondida ***/
	if WAFORNEC->C8_WFCO == "1004"
		
		WAFORNEC->( dbSkip() )
		Loop
		
	endif
	
	
	/*** Atualiza variaveis com as informacoes da cotacao posicionada ***/

	_cC8_NUM     := WAFORNEC->C8_NUM
	_cC8_FORNECE := WAFORNEC->A2_COD
	_cC8_LOJA    := WAFORNEC->A2_LOJA
	_cEmlFor 	 := AllTrim(WAFORNEC->A2_EMAIL)
	_cC8_RecNO   := WAFORNEC->R_E_C_N_O_
	nDiasTime    := stod(WAFORNEC->C8_VALIDA)-dDatabase
	aItensUpg 	 := {}
	
	
	/*** Verifica no cadastro do fornecedor se o mesmo possui o campo e-mail preenchido ***/

	if Empty( _cEmlFor )
		
		
		/*** Atualizar a cotacao (SC8) para nao processar novamente (falta da informacao e-mail) ***/
		SC8->( DbGoTo(_cC8_RecNO) )
		
		RecLock('SC8')
		SC8->C8_WFID := "WF9999"
		SC8->( MsUnlock() )
		
		WAFORNEC->( dbSkip() )
		Loop
		
	endif
	
	
	/*** Armazena os dados do usuario atualmente logado ***/
	PswOrder(1)
	if PswSeek(Substr(cUsuario,7,15),.t.)
		aInfo    := PswRet(1)
		_cUser   := aInfo[1,2]
	endIf
	
	/*** Inicia um novo Processo de Workflow para env ***/
	oProcess := TWFProcess():New( "COTPRE", "Cotação de Preços" ) //voltar cotacao
	oProcess:NewTask( "Fluxo de Cotação de Preços", "/workflow/cotacao_new.htm" )
	oProcess:ohtml:valbyname('proc_link2', 'https://'+cWfWs+"/" )
	oProcess:ohtml:valbyname('proc_link3', 'https://'+cWfWs+cWfDir+"/" )
	oProcess:Track('1000',"Gerando o Processo de Workflow para o fornecedor: "+Trim(WAFORNEC->A2_NOME),SubStr(cUsuario,7,15))
	
	
	/*** Preenche os dados do cabecalho ***/
	oHtml    := oProcess:oHTML
	oHtml:ValByName( "WF2P11", "WFHTTPRET.APL")
	oHtml:ValByName( "C8_CONTATO" , WAFORNEC->C8_CONTATO  )
	oHtml:ValByName( "C8_NUM"    , WAFORNEC->C8_NUM		)
	oHtml:ValByName( "C8_VALIDA" , substr(WAFORNEC->C8_VALIDA,7,2)+"/"+substr(WAFORNEC->C8_VALIDA,5,2)+"/"+substr(WAFORNEC->C8_VALIDA,1,4) )
	oHtml:ValByName( "C8_FORNECE", WAFORNEC->A2_COD 	)
	oHtml:ValByName( "C8_LOJA"   , WAFORNEC->A2_LOJA	)
	oHtml:ValByName( "A2_NOME"   , WAFORNEC->A2_NOME   )
	oHtml:ValByName( "A2_END"    , WAFORNEC->A2_END    )
	oHtml:ValByName( "A2_MUN"    , WAFORNEC->A2_MUN    )
	oHtml:ValByName( "A2_BAIRRO" , WAFORNEC->A2_BAIRRO )
	oHtml:ValByName( "A2_TEL"    , WAFORNEC->A2_TEL    )
	oHtml:ValByName( "A2_FAX"    , WAFORNEC->A2_FAX    )

	
	//Innovare Solucoes - Enviar dados da Empresa para o cabecalho da pagina de cotacao
	_cFil  	   := alltrim(SM0->M0_CODFIL)
	_cFantasia := alltrim(SM0->M0_NOMECOM)
	_cCnpj     := alltrim(Transform(SM0->M0_CGC, "@R 99.999.999/9999-99"))
	_cCidade   := AllTrim(SM0->M0_CIDENT)
	_cUf       := AllTrim(SM0->M0_ESTENT)
	_cempresa_filial := _cFil+ " - "+_cFantasia
	
	oHtml:ValByName( "empresa_filial", _cempresa_filial)
	_cCnpj_filial := "CNPJ: "+_cCnpj+" - Cidade: "+_cCidade+"/"+_cUf
	oHtml:ValByName( "cnpj_filial", _cCnpj_filial)
	
	
	/*** Preenche de Entrega ***/
	//oHtml:ValByName( "C8_ENDENTREGA1", trim(SM0->M0_ENDENT) )
	//oHtml:ValByName( "C8_ENDENTREGA2", trim(SM0->M0_CIDENT)+" - "+SM0->M0_ESTENT+" - "+trim(SM0->M0_CEPENT) )
	//Alteração solicitada Claudio Vilarim em 30/07/2013
	
	// **** Endereço estatico para o link **** //
	oHtml:ValByName( "C8_ENDENTREGA1", "Avenida Amazonas, Nro: 623 - Bairro Brasil" )
	oHtml:ValByName( "C8_ENDENTREGA2", "Uberlandia - MG" )
	
	// Inicia a localizacao das Formas de Pagamento
	aCond:={}
	SE4->( dbSetOrder(1) )
	if SE4->( dbSeek(xFilial("SE4") + SA2->A2_COND ) )
		aAdd( aCond, SE4->E4_Codigo + " - " + SE4->E4_Descri )
	endif
	
	SE4->( dbGoTop() )
	while !SE4->( Eof() ) .and. SE4->E4_Filial == xFilial("SE4")
		aAdd( aCond, SE4->E4_Codigo + " - " + SE4->E4_Descri )
		SE4->( dbSkip() )
	enddo
	
	/*** Inicia o Processo de Substituição das variaveis dos Itens da Cotação no HTML ***/
	while !WAFORNEC->( eof() ) .and. WAFORNEC->C8_FILIAL = xFilial("SC8") ;
		.and. WAFORNEC->C8_NUM  = _cC8_NUM ;
		.and. WAFORNEC->A2_COD 	= _cC8_FORNECE ;
		.and. WAFORNEC->A2_LOJA = _cC8_LOJA
		
		if aScan(aItensUpg, {|x| x[2] = (WAFORNEC->A2_COD+WAFORNEC->A2_LOJA+WAFORNEC->B1_COD) } ) > 0
			
			WAFORNEC->( dbSkip() )
			Loop
			
		endif
		
		aAdd( (oHtml:ValByName( "it.item"    )), WAFORNEC->C8_ITEM    )
		aAdd( (oHtml:ValByName( "it.produto" )), WAFORNEC->C8_PRODUTO ) //, o fornecedor quer a referencia do produto
		aAdd( (oHtml:ValByName( "it.descri"  )), trim(WAFORNEC->B1_DESC) )
		aAdd( (oHtml:ValByName( "it.quant"   )), TRANSFORM( WAFORNEC->C8_QUANT,'@E 99,999.99' ) )
		aAdd( (oHtml:ValByName( "it.um"      )), WAFORNEC->C8_UM      )
		aAdd( (oHtml:ValByName( "it.preco"   )), TRANSFORM( 0.00,'@E 99,999.99' ) )
		aAdd( (oHtml:ValByName( "it.valor"   )), TRANSFORM( 0.00,'@E 99,999.99' ) )
		aAdd( (oHtml:ValByName( "it.ipi"     )), TRANSFORM( 0.00,'@E 99.99' ) )
		aAdd( (oHtml:ValByName( "it.prazo"   )), "0" )   
		//aAdd( (oHtml:ValByName( "it.marca"   )), "Informe aqui a marca" ) //quintais 
		aAdd( (oHtml:ValByName( "it.c8_obs"   )), WAFORNEC->C8_OBS ) //quintais 
		aAdd( (oHtml:ValByName( "it.c8_obsfor"))," " ) //quintais 
		
		//aAdd( (oHtml:ValByName( "obsMont"   )),  WAFORNEC->C8_ITEM )  comentado quintais
		//		aAdd( (oHtml:ValByName( "it.dia"     )), str(day(WAFORNEC->C8_DATPRF))         )
		//		aAdd( (oHtml:ValByName( "it.mes"     )), padl( alltrim( str( month(WAFORNEC->C8_DATPRF) ) ),2,"0") )
		//		aAdd( (oHtml:ValByName( "it.ano"     )), right(str(year(WAFORNEC->C8_DATPRF)),2))
		//		aAdd( (oHtml:ValByName( "c8_obsfor"   )), WAFORNEC->C8_OBSFOR )
		
		aAdd( aItensUpg, {WAFORNEC->R_E_C_N_O_,(WAFORNEC->A2_COD+WAFORNEC->A2_LOJA+WAFORNEC->B1_COD)})
		WAFORNEC->( dbSkip() )
		
	enddo
	
	oHtml:ValByName( "Pagamento", aCond    )
	oHtml:ValByName( "Frete"    , {"CIF","FOB"}   )
	oHtml:ValByName( "subtot"   , TRANSFORM( 0 ,'@E 999,999.99' ) )
	oHtml:ValByName( "vldesc"   , TRANSFORM( 0 ,'@E 999,999.99' ) )
	oHtml:ValByName( "aliipi"   , TRANSFORM( 0 ,'@E 999,999.99' ) )
	//	oHtml:ValByName( "Valipi"   , TRANSFORM( 0 ,'@E 999,999.99' ) )
	oHtml:ValByName( "valfre"   , TRANSFORM( 0 ,'@E 999,999.99' ) )
	oHtml:ValByName( "totped"   , TRANSFORM( 0 ,'@E 999,999.99' ) )
	
	oProcess:cSubject := "Processo de geração de Cotação de Preços N." + _cC8_NUM
	//	oProcess:cTo      := SubStr(cUsuario,7,15) //Documentação solicita que se altere para o usuário microsiga e não mais o email usando a variavel: _cEmlFor
	oProcess:cTo      := 'cotpre' //Documentação solicita que se altere para o usuário microsiga e não mais o email usando a variavel: _cEmlFor
	oProcess:bReturn  := "U_MT130WFR(1)"       // Funçao de Retorno
	
	nDiasTime:=iif(nDiasTime<0,0,nDiasTime)  
	//oProcess:bTimeOut := { { "U_MT130WFR(2)", nDiasTime, 0 , 2 } } //oProcess:bTimeOut := { { funcao, dias, horas, minutos0 } }
	oProcess:bTimeOut := { { "U_MT130WFR(3)", nDiasTime, 0 , 2 } } //oProcess:bTimeOut := { { funcao, dias, horas, minutos0 } }
	

	cMailID := oProcess:Start() // Inicia o processo com o Messenger ativo gera o HTML na pasta do usuário pelo messenger.
	

	
	cAviso:='Solicitação de Cotação de Preços N.'+_cC8_NUM+' - '+_cempresa_filial  //cNameEmp
	
//	cLink:='http://'+GetMv("MV_WFBRWSR")+'/emp' + cEmpAnt + '/'+'workflow'+'/' + cMailId + '.htm'
	cLink:='http://'+GetMv("MV_WFWS")+'/messenger/emp' + cEmpAnt + '/'+'cotpre'+'/' + cMailId + '.htm'
	
	//Envia email de Aviso
	xHTM := '<HTML><BODY>'
	xHTM += '<hr>'
	xHTM += '<p  style="word-spacing: 0; line-height: 100%; margin-top: 0; margin-bottom: 0">'
	xHTM += '<b><font face="Verdana" SIZE=3>'+cAviso+' &nbsp; '+dtoc(date())+'&nbsp;&nbsp;&nbsp;'+time()+'</b></p>'
	xHTM += '<hr>'
	xHTM += '<br>'
	xHTM += '<b><font face="Verdana" SIZE=3> Prezado(a) Fornecedor(a)</b></p>'
	xHTM += '<br>'
	xHTM += 'Favor clicar no link abaixo para participar do processo de cotação em referencia<BR> <br>'
	xHTM += "<a href="+cLink+" title="+cLink+">Ver Cotação</a> <br><br>  "+cLink  
	
	//  Link temporario para a Simulação
	//xHTM += '<p><a href="http://192.168.1.137:8099/emp' + cEmpAnt + '/'+'cotpre'+'/' + cMailId + '.htm" title="Simulação">'
	//xHTM += 'Simulação Montividiu </a>'
	//  Fim do link temporario
	
	xHTM += '<p>'
	xHTM += '<b>Presado(a) fornecedor(a), não responda esse e-mail,<br> para enviar a cotação, preencha o formulário atravé so link e clique em enviar.</b>'
	xHTM += '</BODY></HTML>'
	
	
	//Parametros necessarios para a rotina
	// MV_RELACNT - Conta a ser utilizada no envio de E-Mail
	// MV_RELFROM - E-mail utilizado no campo FROM no envio
	// MV_RELSERV - Nome do Servidor de Envio de E-mail utilizado no envio
	// MV_RELAUTH - Determina se o Servidor de Email necessita de Autenticação
	// MV_RELAUSR - Usuário para Autenticação no Servidor de Email
	// MV_RELAPSW - Senha para Autenticação no Servidor de Email
	oMail := SendMail():new()
	oMail:SetTo(_cEmlFor)
	oMail:SetFrom(Alltrim(cRelFrom))
	//    oMail:SetSubject('Aviso - '+cAviso)
	oMail:SetSubject('Solicitação de Cotação de Preços - '+cNameEmp)
	oMail:SetBody(xHTM)
	oMail:SetEchoMsg(.f.)
	if oMail:Send()
		//ok (opc)
	else
		//erro (opc)
	endif
	
	oProcess:Track('1001',"Enviando o e-mail para o fornecedor: "+Trim(WAFORNEC->A2_NOME),SubStr(cUsuario,7,15))
	WFSendMail()          
	cAviso:="Enviando email para Fornecedor"
	//U_EnviarEMail('','Aviso - '+cAviso+'','Aviso - '+cAviso+'',xHTM,.t.,UsrRetMail(RetCodUsr())) quintais
	
	// Busca os itens para Gravar as informações já processadas do WorkFlow
	for _ix_upg := 1 to Len(aItensUpg)
		
		SC8->( DbGoTo(aItensUpg[_ix_upg,1]) )
		
		RecLock('SC8')
		//		If Empty(C8_WFDT)
		//			SC8->C8_WFDT   := dDataBase
		//		EndIF
		SC8->C8_WFCO    := "1003"
		SC8->C8_WFEMAIL := iif( cUsername == "Administrador", cRelaCnt, cUsermail )
		SC8->C8_WFID    := oProcess:fProcessID
		SC8->( MsUnlock() )
		
	next _ix_upg
	//	RastreiaWF(oProcess:fProcessID+'.'+oProcess:fTaskID,oProcess:fProcCode,'1002',RetCodUsr(),"Aguardando retorno do fornecedor: "+Trim(WAFORNEC->A2_NOME))
	oProcess:Track('1002',"Aguardando retorno do fornecedor: "+Trim(WAFORNEC->A2_NOME),SubStr(cUsuario,7,15))
	
enddo
WAFORNEC->( DbCloseArea() )

		cEmailComp := SC8->C8_WFEMAIL
/*** Restaura Ambiente ***/
RestArea( _AreaSC8 )
RestArea( _AreaSE4 )
RestArea( _AreaSB1 )
Return NIL


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MT130WFR  ºAutor  ³Anderson Machado    º Data ³  08/01/09   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Faz a gravacao no retorno do workflow                       º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ VIAN - Viacao Anapolina                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function MT131WFR(AOpcao, oProcess)
	Local aCab   :={}
	Local nY, _nind
	Local aRelImp := MaFisRelImp("MT150",{"SC8"})
	Local _AreaSC8 := SC8->( GetArea() )
	Local _AreaSE4 := SE4->( GetArea() )
	Local _AreaSB1 := SB1->( GetArea() )
	Local _cValPreco := ""
	Local _nVlrPreco := _nTotPed := _nVlDesc := 0
	Private cNameEmp:=Alltrim(SM0->M0_NOME)

	if ValType(aOpcao) = "A"
		aOpcao := aOpcao[1]
	endif

	if aOpcao == NIL
		aOpcao := 0

	elseif aOpcao == 1
		_cC8_NUM     := oProcess:oHtml:RetByName("C8_NUM"     )
		_cC8_FORNECE := oProcess:oHtml:RetByName("C8_FORNECE" )
		_cC8_LOJA    := oProcess:oHtml:RetByName("C8_LOJA"    )

	elseif aOpcao == 2
		_cC8_NUM     := oProcess:oHtml:RetByName("C8_NUM"     )
		_cC8_FORNECE := oProcess:oHtml:RetByName("C8_FORNECE" )
		_cC8_LOJA    := oProcess:oHtml:RetByName("C8_LOJA"    )


	elseif aOpcao == 3 //TimeOut

		SPCTimeOut( oProcess )
		Return
	endif

	dbSelectArea("SC8")
	dbSetOrder(1)
	dbSeek( xFilial("SC8") + Padr(_cC8_NUM,6) + Padr(_cC8_FORNECE,6) + _cC8_LOJA )

/*** Cotacao Recebida ***/
	if oProcess:oHtml:RetByName("Aprovacao") = "S"

		//RastreiaWF(oProcess:fProcessID+'.'+oProcess:fTaskID,oProcess:fProcCode,'1003',RetCodUsr(),"Processando a resposta da Cotação N."+_cC8_NUM+" do Fornecedor: "+_cC8_FORNECE)
		oProcess:Track('1003',"Processando a resposta da Cotação N."+_cC8_NUM+" do Fornecedor: "+_cC8_FORNECE, SubStr(cUsuario,7,15))

		_cC8_VLDESC := oProcess:oHtml:RetByName("VLDESC" )
		_cC8_ALIIPI := oProcess:oHtml:RetByName("ALIIPI" )
		_cC8_VALFRE := oProcess:oHtml:RetByName("VALFRE" )

	/*** Verifica o frete ***/
		if oProcess:oHtml:RetByName("Frete") = "FOB"
			_cC8_RATFRE := 0
		endif

	/*** Atualizacao dos valores da cotacao na SC8 ***/
		for _nind := 1 to len(oProcess:oHtml:RetByName("it.preco"))

			//BASE DO ICMS
			MaFisIni(Padr(_cC8_FORNECE,6),_cC8_LOJA,"F","N","R",aRelImp)
			MaFisIniLoad(1)

			For nY := 1 To Len(aRelImp)
				MaFisLoad(aRelImp[nY][3],SC8->(FieldGet(FieldPos(aRelImp[nY][2]))),1)
			Next nY

			MaFisEndLoad(1)

			dbSelectArea("SB1")
			dbSetOrder(1)
			dbSeek( xFilial() + oProcess:oHtml:RetByName("it.produto")[_nind] )
			cIcm := SC8->C8_PICM

			_cC8_ITEM := oProcess:oHtml:RetByName("it.item")[_nind]
			dbSelectArea("SC8")
			dbSetOrder(1)
			dbSeek( xFilial("SC8") + Padr(_cC8_NUM,6) + Padr(_cC8_FORNECE,6) + _cC8_LOJA + _cC8_ITEM )

		/*** Verifica se o prazo tenha vencido não permite gravacao ***/
			If SC8->C8_WFID = "9999"
				//RastreiaWF(oProcess:fProcessID+'.'+oProcess:fTaskID,oProcess:fProcCode,'1004',RetCodUsr(),"Cotação N."+Padr(_cC8_NUM,6)+" recebida fora do prazo do fornecedor: "+Padr(_cC8_FORNECE,6))
				oProcess:Track('1004',"Cotação N."+Padr(_cC8_NUM,6)+" recebida fora do prazo do fornecedor: "+Padr(_cC8_FORNECE,6), SubStr(cUsuario,7,15))

			/*** Restaura Ambiente ***/
				RestArea( _AreaSC8 )
				RestArea( _AreaSE4 )
				RestArea( _AreaSB1 )

				Return

			EndIf

			RecLock("SC8",.f.)
			SC8->C8_WFCO   := "1004"
			SC8->C8_MOTIVO := trim( oProcess:oHtml:RetByName("c8_obs") ) //fornecedor nao digita observacoes nesse campo
			//SC8->C8_OBS    := Substr(Dtoc(Date()),1,5)+'-'+Substr(Time(),1,5)+':'+SC8->C8_MOTIVO          QUINTAIS

			SC8->C8_OBSFOR  := Trim(oProcess:oHtml:RetByName("it.c8_obsfor")[_nind])

			_cValPreco := Trim(oProcess:oHtml:RetByName("it.preco")[_nind])
			SC8->C8_PRECO  := Val( Substr(_cValPreco,1,len(_cValPreco)-3)+'.'+Right(_cValPreco,2) )

			_cValPreco := Trim(oProcess:oHtml:RetByName("it.valor")[_nind])
			SC8->C8_TOTAL  := Val( Substr(_cValPreco,1,len(_cValPreco)-3)+'.'+Right(_cValPreco,2) )

			_cValPreco := Trim(oProcess:oHtml:RetByName("it.ipi")[_nind])
			SC8->C8_ALIIPI := Val( Substr(_cValPreco,1,len(_cValPreco)-3)+'.'+Right(_cValPreco,2) )

			//quintais
			//conout("quintais")
			//_cMarca       := Trim(oProcess:oHtml:RetByName("it.marca")[_nind])
			//_ctexto:="Marca:"+_cMarca
			//conout(_cTexto)
			//SC8->C8_XMARCA:= _cMarca

			//caso o IPI não seja zero
			If Val(oProcess:oHtml:RetByName("it.ipi"  )[_nind])>0
				C8_VALIPI  := (Val(oProcess:oHtml:RetByName("it.ipi")[_nind])*Val(oProcess:oHtml:RetByName("it.valor")[_nind]))/100
				C8_BASEIPI := SC8->C8_TOTAL
			EndIf

			//caso o icm nao seja zero
			MaFisAlt("IT_ALIQICM",cIcm,1)
			C8_PICM        := MaFisRet(1,"IT_ALIQICM")

			If C8_PICM >0

				C8_BASEICM     := SC8->C8_TOTAL
				MaFisAlt("IT_VALICM",cIcm,1)
				C8_VALICM      := MaFisRet(1,"IT_VALICM")

			EndIf

			SC8->C8_COND   := Substr(oProcess:oHtml:RetByName("pagamento"),1,3)
			SC8->C8_TPFRETE:= Substr(oProcess:oHtml:RetByName("Frete"),1,1)


		/*** Preenche variaveis ***/
			_cValPreco := Trim(oProcess:oHtml:RetByName("it.preco")[_nind])
			_nVlrPreco := Val( Substr(_cValPreco,1,len(_cValPreco)-3)+'.'+Right(_cValPreco,2) )

			_cValPreco := Trim(oProcess:oHtml:RetByName("totped"))
			_nTotPed := Val( Substr(_cValPreco,1,len(_cValPreco)-3)+'.'+Right(_cValPreco,2) )

			_cValPreco := Trim(oProcess:oHtml:RetByName("valfre"))
			_nVlDesc := Val( Substr(_cValPreco,1,len(_cValPreco)-3)+'.'+Right(_cValPreco,2) )

			iif( oProcess:oHtml:RetByName("Frete") = "FOB", ;
				SC8->C8_VALFRE := 0, ;
				SC8->C8_VALFRE := ( ( Val(oProcess:oHtml:RetByName("it.quant")[_nind]) * ( _nVlrPreco / _nTotPed ) ) * _nVlDesc ) )


		/*** Preenche variaveis (valor desconto) ***/
			_cValPreco := Trim(oProcess:oHtml:RetByName("vldesc"))
			_nVlDesc := Val( Substr(_cValPreco,1,len(_cValPreco)-3)+'.'+Right(_cValPreco,2) )

			iif( Val(oProcess:oHtml:RetByName("vldesc")) == 0 ,;
				SC8->C8_VLDESC := 0, ;
				SC8->C8_VLDESC := ( (Val(oProcess:oHtml:RetByName("it.quant")[_nind]) * (_nVlrPreco / _nTotPed) ) * _nVlDesc ) )

			MsUnlock()
			MaFisEnd()
		next
		//RastreiaWF(oProcess:fProcessID+'.'+oProcess:fTaskID,oProcess:fProcCode,'1005',RetCodUsr(),"Concluido a atualzação da cotação do fornecedor: "+_cC8_FORNECE)
		oProcess:Track('1005', "Concluido a atualzação da cotação do fornecedor: "+_cC8_FORNECE, SubStr(cUsuario,7,15))
		oProcess:Finish()  //Finalizo o Processo

/*
Envio resposta 05/07
*/
		cEmailComp := SC8->C8_WFEMAIL

		oProcess:Track('1008',"Enviando e-mail de notificação ao Comprador de participação do fornecedor: "+Padr(_cC8_FORNECE,6)+" da Cotação de Preços N."+Padr(_cC8_NUM,6), SubStr(cUsuario,7,15))
		Aprovar(oProcess, cEmailComp, _cC8_NUM)
		oProcess:Finish()  //Finalizo o Processo

	Else //caso tenha sido rejeitado

		aCab := {	{"C8_NUM"	,_cC8_NUM,NIL}}
		oProcess:Track('1006', "O fornecedor "+_cC8_FORNECE+" informou sua desistência no processo de Cotação N."+Padr(_cC8_NUM,6), SubStr(cUsuario,7,15))
		//	RastreiaWF(oProcess:fProcessID+'.'+oProcess:fTaskID,oProcess:fProcCode,'1006',RetCodUsr(),"O fornecedor "+_cC8_FORNECE+" informou sua desistência no processo de Cotação N."+Padr(_cC8_NUM,6))

	/*** Atualiza os itens da cotação na SC8 ***/
		for _nind := 1 to len(oProcess:oHtml:RetByName("it.preco"))

			_cC8_ITEM := oProcess:oHtml:RetByName("it.item")[_nind]

			dbSelectArea("SC8")
			dbSetOrder(1)
			dbSeek( xFilial("SC8") + Padr(_cC8_NUM,6) + Padr(_cC8_FORNECE,6) + _cC8_LOJA + _cC8_ITEM )

			RecLock("SC8",.f.)
			SC8->C8_MOTIVO := Substr(Dtoc(Date()),1,5)+'-'+Substr(Time(),1,5)+':'+trim( oProcess:oHtml:RetByName("c8_obs") )
			MsUnlock()

		/*** PEGA O EMAIL PARA AVISAR O COMPRADOR ***/
			cEmailComp := SC8->C8_WFEMAIL

			//lMsErroAuto := .F.

			//aadd(aItem,   {{"C8_ITEM",_cC8_ITEM ,NIL},;
				///				{"C8_FORNECE",_cC8_FORNECE ,NIL},;
				//				{"C8_LOJA",_cC8_LOJA ,NIL}})

			//		MSExecAuto({|x,y,z| mata150(x,y,z)},aCab,aItem,5) //EXCLUI

			//		ConOut( iif(lMsErroAuto, "Erro de Execução ao tentar cancelar a Cotação", "Ok, Pedido Cancelado") )
			//RastreiaWF(oProcess:fProcessID+'.'+oProcess:fTaskID,oProcess:fProcCode,'1007',RetCodUsr(),"Cancelado a Cotação N."+Padr(_cC8_NUM,6)+" do fornecedor "+Padr(_cC8_FORNECE,6))
			oProcess:Track('1007',"Cancelado a Cotação N."+Padr(_cC8_NUM,6)+" do fornecedor "+Padr(_cC8_FORNECE,6), SubStr(cUsuario,7,15))

		Next
		//	RastreiaWF(oProcess:fProcessID+'.'+oProcess:fTaskID,oProcess:fProcCode,'1008',RetCodUsr(),"Enviando e-mail de notificação ao Comprador de desistência do fornecedor: "+Padr(_cC8_FORNECE,6)+" da Cotação de Preços N."+Padr(_cC8_NUM,6))
		cEmailComp := SC8->C8_WFEMAIL

		oProcess:Track('1008',"Enviando e-mail de notificação ao Comprador de desistência do fornecedor: "+Padr(_cC8_FORNECE,6)+" da Cotação de Preços N."+Padr(_cC8_NUM,6), SubStr(cUsuario,7,15))
		Rprovar(oProcess, cEmailComp, _cC8_NUM)
		oProcess:Finish()  //Finalizo o Processo
	endif

/*** Restaura Ambiente ***/
	RestArea( _AreaSC8 )
	RestArea( _AreaSE4 )
	RestArea( _AreaSB1 )
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³Rprovar  ºAutor  ³Anderson Machado    º Data ³  09/01/09   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Envia e-mail para os compradores                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ VIAN - Viacao Anapolina                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

static function Rprovar(oProcess,cEmailComp,_cC8_NUM)



	//Local _user := Subs(cUsuario,7,15)
	Local _cHTM := ""
	Local _cNrCotacao := oProcess:oHtml:RetByName("C8_FORNECE")+oProcess:oHtml:RetByName("C8_LOJA")
	Local _cAviso:="NOTIFICAÇÃO - Desistência do fornecedor na Cotação de Preços - "+AllTrim(SM0->M0_CODFIL) +"-"+alltrim(SM0->M0_NOMECOM)+"  Nr. "+_cC8_NUM
	Local _cFornecedor := Posicione("SA2", 1, xFilial("SA2")+_cNrCotacao, "A2_NOME" )
	Local _cCodFor := oProcess:oHtml:RetByName("C8_FORNECE")
	Local _cCodljF :=oProcess:oHtml:RetByName("C8_LOJA")
//Local _cObs:=oProcess:oHtml:RetByName("lbmotivo")  //C8_OBS  
	Local _cObs:=oProcess:oHtml:RetByName("C8_OBS")  //lbmotivo


	_cHTM := '<HTML><BODY>'
	_cHTM += '<hr>'
	_cHTM += '<p  style="word-spacing: 0; line-height: 100%; margin-top: 0; margin-bottom: 0">'
	_cHTM += '<b><font face="Verdana" SIZE=3>'+_cAviso+' &nbsp; '+dtoc(date())+'&nbsp;&nbsp;&nbsp;'+time()+'</b></p>'
	_cHTM += '<hr>'
	_cHTM += '<br>'
	_cHTM += '<br>'
	_cHTM += 'O fornecedor <b>'+"("+_cCodFor+"-" +_cCodljF +") "+Trim(_cFornecedor)+'</b> informa sua desistência na Cotação de Nr. <b>'+xFilial("SC8")+"-"+_cC8_NUM+'</b> <BR><BR>'
	_cHTM += 'Sob motivo: <b>'+_cObs+'</b> <BR><BR>'
	_cHTM += '</BODY></HTML>'


	oMail := SendMail():new()
	oMail:SetTo(iif( !empty(cEmailComp), cEmailComp, GetMv("MV_WFCMP") ))
	oMail:SetFrom(Alltrim(GetMv("MV_RELFROM",," ")))
	oMail:SetSubject(_cAviso)
	oMail:SetBody(_cHTM)
	oMail:SetEchoMsg(.f.)
	if oMail:Send()
		//ok (opc)
	else
		//erro (opc)
	endif

	************************************************************************************************************************************
static function Aprovar(oProcess,cEmailComp,_cC8_NUM)

	//Local _user := Subs(cUsuario,7,15)
	Local _cHTM := ""
	Local _cNrCotacao := oProcess:oHtml:RetByName("C8_FORNECE")+oProcess:oHtml:RetByName("C8_LOJA")
	Local _cAviso:="NOTIFICAÇÃO - Atualização do fornecedor na Cotação de Preços - "+AllTrim(SM0->M0_CODFIL) +"-"+alltrim(SM0->M0_NOMECOM)+"  Nr. "+_cC8_NUM
	Local _cFornecedor := Posicione("SA2", 1, xFilial("SA2")+_cNrCotacao, "A2_NOME" )
	Local _cCodFor := oProcess:oHtml:RetByName("C8_FORNECE")
	Local _cCodljF :=oProcess:oHtml:RetByName("C8_LOJA")

	_cHTM := '<HTML><BODY>'
	_cHTM += '<hr>'
	_cHTM += '<p  style="word-spacing: 0; line-height: 100%; margin-top: 0; margin-bottom: 0">'
	_cHTM += '<b><font face="Verdana" SIZE=3>'+_cAviso+' &nbsp; '+dtoc(date())+'&nbsp;&nbsp;&nbsp;'+time()+'</b></p>'
	_cHTM += '<hr>'
	_cHTM += '<br>'
	_cHTM += '<br>'
	_cHTM += 'O fornecedor <b>'+"("+_cCodFor+"-" +_cCodljF +") "+Trim(_cFornecedor)+'</b> informa que atualizou a Cotação de Nr. <b>'+xfilial("SC8")+"-"+_cC8_NUM+'</b> <BR><BR>'
	_cHTM += 'Sob motivo: <b>'+oProcess:oHtml:RetByName("C8_OBS")+'</b> <BR><BR>'
	_cHTM += '</BODY></HTML>'

	oMail := SendMail():new()
	oMail:SetTo(iif( !empty(cEmailComp), cEmailComp, GetMv("MV_WFCMP") ))
	oMail:SetFrom(Alltrim(GetMv("MV_RELFROM",," ")))
	oMail:SetSubject(_cAviso)
	oMail:SetBody(_cHTM)
	oMail:SetEchoMsg(.f.)
	if oMail:Send()
		//ok (opc)
	else
		//erro (opc)
	endif

	oProcess:Track('1009',"Finalizado a participação do fornecedor: "+Padr(_cC8_FORNECE,6)+" da Cotação de Preços N."+Padr(_cC8_NUM,6), SubStr(cUsuario,7,15))

return
	*********************************************************************************************************************************************

STATIC Function SPCTimeOut( oProcess )
	Local _nind
	Private cNameEmp:=Alltrim(SM0->M0_NOME)

	_cC8_NUM     := oProcess:oHtml:RetByName("C8_NUM"     )
	_cC8_FORNECE := oProcess:oHtml:RetByName("C8_FORNECE" )
	_cC8_LOJA    := oProcess:oHtml:RetByName("C8_LOJA"    )
	_cCodFor:=_cC8_FORNECE
	_cCodljF:=_cC8_LOJA

	ConOut("Funcao de TIMEOUT executada Cotação "+_cC8_NUM+ " "+_cC8_FORNEC )

/*** Atualiza os itens da cotação na SC8 vila75 ***/
	for _nind := 1 to len(oProcess:oHtml:RetByName("it.preco"))

		_cC8_ITEM := oProcess:oHtml:RetByName("it.item")[_nind]

		dbSelectArea("SC8")
		dbSetOrder(1)
		dbSeek( xFilial("SC8") + Padr(_cC8_NUM,6) + Padr(_cC8_FORNECE,6) + _cC8_LOJA + _cC8_ITEM )

		RecLock("SC8",.f.)
		SC8->C8_MOTIVO := 'AUTOMATICO: Falta de retorno'
		MsUnlock()

	/*** PEGA O EMAIL PARA AVISAR O COMPRADOR ***/
		cEmailComp := SC8->C8_WFEMAIL
		oProcess:Track('1007',"Cancelado a Cotação N."+Padr(_cC8_NUM,6)+" do fornecedor "+Padr(_cC8_FORNECE,6), SubStr(cUsuario,7,15))

	Next

	_cAviso:="NOTIFICAÇÃO - Cotação finalizada por falta de resposta - "+AllTrim(SM0->M0_CODFIL) +"-"+alltrim(SM0->M0_NOMECOM)+"- Cotação No "+_cC8_NUM
	_cHTM := '<HTML><BODY>'
	_cHTM += '<hr>'
	_cHTM += '<p  style="word-spacing: 0; line-height: 100%; margin-top: 0; margin-bottom: 0">'
	_cHTM += '<b><font face="Verdana" SIZE=3>'+_cAviso+' &nbsp; '+dtoc(date())+'&nbsp;&nbsp;&nbsp;'+time()+'</b></p>'
	_cHTM += '<hr>'
	_cHTM += '<br>'
	_cHTM += '<br>'
	_cHTM += 'O fornecedor <b>'+"("+_cCodFor+"-" +_cCodljF +") "+_cC8_FORNECE+'</b> teve sua Cotação finalizada por falta de retorno - Cotação Nr. <b>'+_cC8_NUM+'</b> <BR><BR>'
	_cHTM += '</BODY></HTML>'


	oMail := SendMail():new()
	oMail:SetTo(iif( !empty(cEmailComp), cEmailComp, GetMv("MV_WFCMP") ))
	oMail:SetFrom(Alltrim(GetMv("MV_RELFROM",," ")))
	oMail:SetSubject(_cAviso)
	oMail:SetBody(_cHTM)
	oMail:SetEchoMsg(.f.)
	if oMail:Send()
		//ok (opc)
	else
		//erro (opc)
	endif

	oProcess:Finish()  //Finalizo o Processo
Return
