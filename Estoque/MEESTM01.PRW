#INCLUDE "rwmake.ch"
#INCLUDE "topconn.ch"
/*
_____________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦Programa  ¦ MEESTM01 ¦ Autor ¦ Cláudio Ferreira   ¦ Data ¦    27/06/13 ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Descriçào ¦ Criação/Alteração da MOD nas OP´s                          ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦ Uso      ¦ Usado para criar/alterar MOD nos itens que estavam         ¦¦¦
¦¦¦          ¦ sem estrutura ou corrigidas após apontamento 		      ¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
*/

//Esse fonte não preve existencia de revisoes de estrutura
//A correção é baseado no D3_NUMSEQ, assim MO´s geradas pelo apontamento Prod Mod2 e Documento de Entrada não serão afetadas pois são outro NUMSEQ

//09.01.15
//Revisado para criar qualquer componente da existente na estrutura e que não exista na OP apontada (SD3)


User Function MEESTM01()
Private cPerg 	:= "MEESTM01"

AjustaSx1()
Pergunte(cPerg,.F.)
Private cTipos:=MV_PAR06

@ 00,000 TO 227,463 DIALOG oDlg TITLE "Criação/Alteração dos componentes nas OP´s"
@ 08,010 TO 84,222
@ 23,16 SAY OemToAnsi("Este programa cria/altera as componentes nas OP´s ")
@ 91,140 BMPBUTTON TYPE 5 ACTION Pergunte(cPerg)
@ 91,168 BMPBUTTON TYPE 1 ACTION OkProc()
@ 91,196 BMPBUTTON TYPE 2 ACTION Close(oDlg)
ACTIVATE DIALOG oDlg CENTERED

Return




Static Function OkProc()
Processa( {|| RunProc() } )
Return


Static Function RunProc()
Local i
Local aInd:={}
Local aProd:={}
Private aLog:={}
Private cTipos:=MV_PAR06

//Seleciona OP´s

cQuery := "select D3_OP,D3_EMISSAO,D3_COD,D3_NUMSEQ, D3_QUANT "
cQuery += " FROM "+RetSqlName("SD3")+" A "
cQuery += " WHERE A.D_E_L_E_T_<>'*' "
cQuery += " AND D3_EMISSAO>='"+Dtos(mv_par01)+"' AND D3_EMISSAO<='"+Dtos(mv_par02)+"' "
cQuery += " AND D3_COD >= '"+mv_par03+"' AND D3_COD <= '"+mv_par04+"' "
cQuery += " AND D3_CF IN ('PR0','PR1') AND D3_ESTORNO<>'S' AND D3_OP NOT LIKE '%OS%' "
cQuery += " AND D3_FILIAL = '" + xFilial("SD3") + "' "
cQuery += " Order by D3_OP,D3_EMISSAO,D3_COD,D3_NUMSEQ "
//MemoWrit("c:\stq.sql", cQuery)
TCQUERY cQuery NEW ALIAS "_OPS"

dbSelectArea("_OPS")
dbGoTop()
nTotalReg:=0
dbEval({|| nTotalReg++ })

ProcRegua(nTotalReg)

SB1->(dbSetOrder(1))

dbSelectArea("_OPS")
dbGoTop()
while !eof()
	IncProc("OP ... "+_OPS->D3_OP)
	//Inicializa as variaveis
	dbSelectArea("SD3")
	dbSetOrder(4)
	dbSeek(xFilial('SD3')+_OPS->D3_NUMSEQ+'R0'+_OPS->D3_COD)
	//Inicia variaveis
	cIdent:= SD3->D3_IDENT
	cOP	  := SD3->D3_OP

	aSD3 := array(fCount())
	for i:=1 to FCount()
		aSD3[i] := fieldget(i)
	next
	
	//Localiza OP
	dbSelectArea("SC2")
	SC2->(dbsetorder(1))
    SC2->(MsSeek(xFilial('SC2')+_OPS->D3_OP))
	dDataOP:=SC2->C2_EMISSAO

	//Localiza Estrutura
	dbSelectArea("SG1")
	dbSetOrder(1)
	dbSeek(xFilial('SG1')+_OPS->D3_COD)
	nQB:=Posicione('SB1',1,xFilial('SB1')+_OPS->D3_COD,'B1_QB')
	
	While SG1->(G1_FILIAL+G1_COD)=xFilial('SG1')+_OPS->D3_COD
		SB1->(dbSeek(xFilial('SB1')+SG1->G1_COMP))
		if !SB1->B1_TIPO$cTipos .OR. SB1->B1_FANTASM='S' .OR. dDataOP<SG1->G1_INI .OR. dDataOP>SG1->G1_FIM  //MV_PAR06 OU FANTASMA OU FORA DATA 
			DbSkip()
			Loop
		endif
		
		//Tratamento de erro
		dbSelectArea("SD3")
		dbSetOrder(4)
		lOldModD3:=dbSeek(xFilial('SD3')+_OPS->D3_NUMSEQ+'R0'+SG1->G1_COMP)
		if lOldModD3
			While SD3->(D3_FILIAL+D3_NUMSEQ)=xFilial('SD3')+_OPS->D3_NUMSEQ
				if SD3->D3_TIPO$('PR0','PR1') .OR. !SD3->D3_TIPO$cTipos .OR. (SD3->D3_TIPO='MO' .AND. SD3->D3_CHAVE='E0') //Só MOD
					DbSkip()
					Loop
				endif
				dbSelectArea("SD3")
				RecLock("SD3",.F.)
				replace D3_CLVL     with "AUTOD2"
				DbDelete()
				MSUnlock()
				dbSkip()
			Enddo
		Endif
		
		//Verifica se existe o Componente lançado....se existe só altera
		dbSelectArea("SD3")
		dbSetOrder(4)
		lModD3:=dbSeek(xFilial('SD3')+_OPS->D3_NUMSEQ+'E0'+SG1->G1_COMP)
		// Codigo da Mod
		RecLock("SD3",!lModD3)
		nQtdMOD:=(_OPS->D3_QUANT/nQB)*SG1->G1_QUANT
		if lModD3
			replace D3_QUANT    with nQtdMOD
		else
			for i:=1 to FCount()
				fieldput(i,aSD3[i])
			next
			replace D3_TM       with '999'
			replace D3_UM       with SB1->B1_UM
			replace D3_QUANT    with nQtdMOD
			replace D3_CF       with "RE1" // TEM QUE SER MOVIMENTO  VALORIZADO PELO CM
			replace D3_COD      with SB1->B1_COD
			replace D3_CUSTO1   with 0
			replace D3_PARCTOT  with ""
			replace D3_GRUPO    with SB1->B1_GRUPO
			replace D3_CONTA    with SB1->B1_CONTA
			replace D3_LOCAL    with SB1->B1_LOCPAD
			replace D3_TIPO     with SB1->B1_TIPO
			replace D3_CHAVE    with "E0"
			replace D3_CLVL     with "AUTOI"
		endif
		MSUnlock()
		// Fim dos lançamentos
		
		//Ajusta Qtd Apontamento
		cIdent:= SD3->D3_IDENT
		cOP	  := SD3->D3_OP
		dbSelectArea("SG1")
		dbSkip()
	enddo
    //Gera apontamentos pela SH6
		//Posiciona SH6
		dbSelectArea("SH6")
		dbSetOrder(1)
		if  dbSeek(xFILIAL("SH6")+_OPS->D3_OP)
			dbSelectArea("SH1")
			dbSetOrder(1)
			dbSelectArea("SH6")
			While !EOF() .And. SH6->H6_FILIAL+SH6->H6_OP == xFilial("SH6")+_OPS->D3_OP
				SH1->(dbSeek(xFilial('SH1')+SH6->H6_RECURSO))
				If H6_IDENT == cIdent
					exit
				endif
				dbSkip()
			EndDo
		endif
		//Chama o PE de Ajuste
		If Existblock("MT680GD3")
			Execblock("MT680GD3",.f.,.f.)
		Endif

	if mv_par05=1 //Apaga os componentes que não existem mais na estrutura
		dbSelectArea("SD3")
		dbSetOrder(1)
		dbSeek(xFilial('SD3')+_OPS->D3_OP)		
		While SD3->(D3_FILIAL+D3_OP)=xFilial('SD3')+_OPS->D3_OP
			SB1->(dbSetOrder(1))		
			lExistSB1:=SB1->(dbSeek(xFilial('SB1')+SD3->D3_COD))
			if !SD3->D3_TIPO$cTipos
				DbSkip()
				Loop
			endif       
			//Teste SH6		
	   		cIdent:= SD3->D3_IDENT
			cOP	  := SD3->D3_OP
			lExistH6:=.F.
			//Posiciona SH6
			dbSelectArea("SH6")
			dbSetOrder(1)
			if  dbSeek(xFILIAL("SH6")+_OPS->D3_OP)
				dbSelectArea("SH1")
				dbSetOrder(1)
				dbSelectArea("SH6")
				While !EOF() .And. SH6->H6_FILIAL+SH6->H6_OP == xFilial("SH6")+_OPS->D3_OP
					SH1->(dbSeek(xFilial('SH1')+SH6->H6_RECURSO))
					If SH6->H6_IDENT == cIdent .and. SB1->B1_CCCUSTO=SH1->H1_CCUSTO
					   lExistH6:=	.T. 					   
					endif
					dbSkip()
				EndDo
			endif
			if !SG1->(dbSeek(xFilial('SG1')+_OPS->D3_COD+SD3->D3_COD)) .and. (!lExistH6 .or. !lExistSB1)
				dbSelectArea("SD3")
				RecLock("SD3",.F.)
				replace D3_CLVL     with "AUTOD"
				DbDelete()
				MSUnlock()
			endif
			dbSelectArea("SD3")
			dbSkip()
		Enddo
	endif
	dbSelectArea("_OPS")
	dbSkip()
enddo
dbSelectArea("_OPS")
dbCloseArea()
Close(oDlg)
return


Static Function AjustaSX1()

_sAlias	:=	Alias()
dbSelectArea("SX1")
SX1->( dbSetOrder(1) )
cPerg 	:=	PADR(cPerg,10)
/*
u_xputSx1(     cPerg,"01","Data de    ?","."     ,"."       ,"mv_ch1","D",08,0,0,"G","","","","","mv_par01","","","","","","","","","","","","","","","","")
u_xputSx1(     cPerg,"02","Data ate   ?","."     ,"."       ,"mv_ch2","D",08,0,0,"G","","","","","mv_par02","","","","","","","","","","","","","","","","")
u_xputSx1(     cPerg,"03","Produto de ?","."     ,"."       ,"mv_ch3","C",15,0,0,"G","","SB1","","","mv_par03","","","","","","","","","","","","","","","","")
u_xputSx1(     cPerg,"04","Produto ate?","."     ,"."       ,"mv_ch4","C",15,0,0,"G","","SB1","","","mv_par04","","","","","","","","","","","","","","","","")
u_xputSx1(     cPerg,"05","Apaga TIPO fora da estrutura?",".",".","mv_ch5","N",01,0,0,"C","",""   	,"","","mv_par05","Sim","Sim","Sim","","Não","Não","Não","","","","","","","","","")
u_xputSx1(     cPerg,"06","Tipos a considerar?",".",".","mv_ch6","C",30,0,0,"G","",""   	,"","","mv_par06","","","","","","","","","","","","","","","","")
*/
DbSelectArea(_sAlias)
Return

