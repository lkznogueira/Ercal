#INCLUDE "protheus.ch"
#INCLUDE "rwmake.ch"
#INCLUDE "topconn.ch"

/*
_____________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦Programa  ¦ RCTBM010    ¦ Autor ¦ Totvs            ¦ Data ¦ 07/04/2014 ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Descriçào ¦ Rotina de exportação de visões gerenciais      			  ¦¦¦
¦¦¦          ¦ Contabilidade Gerencial                                    ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Uso       ¦ TOTVS - GO		                                          ¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
*/
User Function RCTBM010()

Private oDlg10

//variaveis dos parametros
Private cPerg := "RCTBM010"

AjustaSX1()

//Montando Dialog para parametrização
@ 200,1 TO 420,410 DIALOG oDlg10 TITLE OemToAnsi("Exportação XML - Visões Gerenciais")
@ 10,10 TO 080,197
@ 20,018 Say " Este programa tem o objetivo gerar Planilha XML  "
@ 28,018 Say " das visões gerenciais. Utilize os parâmetros para preparar "
@ 36,018 Say " as configurações do processamento ."

@ 90,108 BMPBUTTON TYPE 05 ACTION Pergunte(cPerg,.T.)
@ 90,138 BMPBUTTON TYPE 01 ACTION OkVldParam()
@ 90,168 BMPBUTTON TYPE 02 ACTION Close(oDlg10)

Activate Dialog oDlg10 Centered

Return

/*
_____________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦Programa  ¦ OkVldParam    ¦ Autor ¦ Totvs          ¦ Data ¦ 14/11/2013 ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Descriçào ¦ Faz validaçao para o Processamento da rotina de Contabilização¦¦¦
¦¦¦          ¦                                                            ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Uso       ¦ TOTVS - GO		                                          ¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
*/
Static Function OkVldParam()

Local lRet := .T.

Pergunte(cPerg,.F.) //força criar parametros pelo grupo de perguntas

if lRet
	Processa({|| lRet := DoCtb2XML() },"Processando...")
	iif(lRet, Close(oDlg10),.f.)//fecha dlg
endif

Return lRet

/*
_____________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦Programa  ¦ DoCtb2XML     ¦ Autor ¦ Totvs          ¦ Data ¦ 07/04/2014 ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Descriçào ¦ Faz o Processamento da rotina de Exportação XML 			  ¦¦¦
¦¦¦          ¦                                                            ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Uso       ¦ TOTVS - GO		                                          ¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
*/
Static Function DoCtb2XML()
Local lRet := .T.
Local lPrim:= .T.
Local oExcel := FWMSEXCEL():New()
Local cNome :=''
Local aPeriodos:={}
Local dDatai:=MV_PAR02
Local dDataf:=MV_PAR03
Local nImpAntLP := iif(MV_PAR06 == 1,1,0)
Local dDataLp:=MV_PAR07
Local i,ii,jj
Local aClasses:={} 
Local aCCustos:={}

DbSelectArea("CT1")
CT1->(DbSetOrder(1))

if MV_PAR05=1
	While .t.
		if Month(dDatai)<>Month(dDataf)
			aadd(aPeriodos,{dDatai,LastDay(dDatai)})
			dDatai:=LastDay(dDatai)+1
			if dDatai>dDataf
				exit
			endif
		else
			aadd(aPeriodos,{dDatai,dDataf})
			exit
		endif
	Enddo
else
	aadd(aPeriodos,{dDatai,dDataf})
endif

//Trata Classe de/ate
if !empty(mv_par08+mv_par09)
	if mv_par10=1
		DbSelectArea("CTH")
		CTH->(DbSetOrder(1), DbGoTop(), DbSeek(xFilial("CTH")+mv_par08))
		While CTH->(!EOF()) .and. CTH->CTH_FILIAL=xFilial("CTH").and. CTH->CTH_CLVL<=mv_par09
			aadd(aClasses,{CTH->CTH_CLVL,CTH->CTH_CLVL})
			CTH->(dbskip()) //proximo
		Enddo
	else
		if empty(mv_par08)
			CTH->(DbSetOrder(1), DbGoTop(), DbSeek(xFilial("CTH")))
			mv_par08:=CTH->CTH_CLVL
		endif
		aadd(aClasses,{mv_par08,mv_par09})
	endif
else
	aadd(aClasses,{'',''})
endif

_cCCI := ''
_cCCF := ''

//Trata Centro de Custos de/ate
if !empty(mv_par16+mv_par17) .and. mv_par15 = 1
    If mv_par21 = 1 
		aadd(aCCustos,{'',''})             
    EndIF
	if mv_par18=1
		DbSelectArea("CTT")
//		CTT->(DbSetOrder(1), DbGoTop(), DbSeek(xFilial("CTT")+mv_par16))
//		While CTT->(!EOF()) .and. CTT->CTT_FILIAL=xFilial("CTT").and. CTT->CTT_CUSTO<=mv_par17
                          
		_cCCI := ''
		_cCCF := ''
		
		CTT->(DbSetOrder(1), DbGoTop())
		While CTT->(!EOF()) 
            If CTT->CTT_CLASSE = '2'
            	If _cCCI = ''
                	_cCCI := CTT->CTT_CUSTO
            	EndIf                      
            	If CTT->CTT_CUSTO >= mv_par16  .and. CTT->CTT_FILIAL=xFilial("CTT") .and. CTT->CTT_CUSTO<=mv_par17
					aadd(aCCustos,{CTT->CTT_CUSTO,CTT->CTT_CUSTO})
				EndIf
				_cCCF := CTT->CTT_CUSTO	
			EndIf
			CTT->(dbskip()) //proximo				
		Enddo
	else
		if empty(mv_par16)
			CTT->(DbSetOrder(1), DbGoTop(), DbSeek(xFilial("CTT")))
			mv_par16:=CTT->CTT_CUSTO
		endif
		aadd(aCCustos,{mv_par16,mv_par17})
	endif
else
	aadd(aCCustos,{'',''})
endif

ProcRegua(Len(aPeriodos)*Len(aClasses)*Len(aCCustos))

For ii:=1 to Len(aPeriodos)
	For i:=1 to Len(aClasses) 
		For jj:=1 to Len(aCCustos)
			if mv_par15=1
				//posiciones
				DbSelectArea("CTS")
				CTS->(DbSetOrder(1), DbGoTop(), DbSeek(xFilial("CTS")+MV_PAR01))
				While CTS->(!EOF()) .and. CTS->CTS_FILIAL+CTS_CODPLA=xFilial("CTS")+MV_PAR01
					if lPrim
						cVisao:=AllTrim(PADR(Substr(AllTrim(CTS->CTS_NOME),1,AT(" ",AllTrim(CTS->CTS_NOME))-1),10))
						cNome :=cVisao+iif(Len(aPeriodos)>1.or.MV_PAR05=1,"-"+Strzero(Month(aPeriodos[ii,1]),2)+StrZero(Year(aPeriodos[ii,1]),4),'')+iif(Len(aClasses)>1,'-'+aClasses[i,1],'')
						IncProc("Processando " + cNome + "...")
						oExcel:AddworkSheet(cNome)
						oExcel:AddTable (cNome,cNome)
						/*
						Parâmetros
						Nome	Tipo	Descrição	Default	Obrigatório	Referência
						cWorkSheet	Caracteres	Nome da planilha	 	X
						cTable	Caracteres	Nome da planilha	 	X
						cColumn	Caracteres	Titulo da tabela que será adicionada	 	X
						nAlign	Numérico	Alinhamento da coluna ( 1-Left,2-Center,3-Right )	 	X
						nFormat	Numérico	Codigo de formatação ( 1-General,2-Number,3-Monetário,4-DateTime )	 	X
						lTotal	Lógico	Indica se a coluna deve ser totalizada	 	X
						*/
						oExcel:AddColumn(cNome,cNome,"Conta de",1,1)
						oExcel:AddColumn(cNome,cNome,"Conta ate",1,1)
						oExcel:AddColumn(cNome,cNome,"C.Custo de",1,1)
						oExcel:AddColumn(cNome,cNome,"C.Custo ate",1,1)
						oExcel:AddColumn(cNome,cNome,"Item de",1,1)
						oExcel:AddColumn(cNome,cNome,"Item ate",1,1)
						oExcel:AddColumn(cNome,cNome,"Classe de",1,1)
						oExcel:AddColumn(cNome,cNome,"Classe ate",1,1)
						oExcel:AddColumn(cNome,cNome,"Saldo",3,3)
						lPrim:=.F.
					endif
					if CTS->CTS_CLASSE='2'
						
						//CTSMMOV(Data De, Data Até, Moeda,TipoSaldo,QualSaldo, Conta De, Conta Até, Centro de Custo De, Centro de Custo Até, Item Contábil De, Item Contábil Até, Classe de Valor De, Classe de Valor Até)
						if empty(aClasses[i,1])
							cClVlIni:=CTS->CTS_CTHINI
							cClVlFim:=CTS->CTS_CTHFIM
						else
							cClVlIni:=aClasses[i,1]
							cClVlFim:=aClasses[i,2]
						endif
						                      
						// tratamento para os centros de custos
						if empty(aCCustos[jj,1])
							cCCIni:=CTS->CTS_CTTINI
							cCCFim:=CTS->CTS_CTTFIM
						else
							cCCIni:=aCCustos[jj,1]
							cCCFim:=aCCustos[jj,2]
						endif

						If mv_par20 = 1
							//Trata plano de contas para a opcao Balancete
							CT1->(DbSeek(xFilial("CT1")+CTS->CTS_CT1INI))
							While CT1->(!EOF()) .and. CT1->CT1_FILIAL=xFilial("CT1") .and.;
							      CT1->CT1_CONTA <= CTS->CTS_CT1FIM  
                                If CT1->CT1_CLASSE = '2' 
                                    if mv_par22 = 1
										//Trata Item Ctb para a opcao Balancete
						   				CTD->(DbSeek(xFilial("CTD")+CTS->CTS_CTDINI))
						  				While CTD->(!EOF()) .and. CTD->CTD_FILIAL=xFilial("CTD") .and.;
							    			CTD->CTD_ITEM <= CTS->CTS_CTDFIM  
                                			If CTD->CTD_CLASSE = '2'                                			                                    
												If jj=1 .and. mv_par21=1
													nSldCC:=CTSMMOV(aPeriodos[ii,1],aPeriodos[ii,2],"01",CTS->CTS_TPSALD,'3',CT1->CT1_CONTA,CT1->CT1_CONTA,_cCCI,_cCCF,CTD->CTD_ITEM,CTD->CTD_ITEM,cClVlIni,cClVlFim,nImpAntLP,dDataLp)									
													nSaldo:=CTSMMOV(aPeriodos[ii,1],aPeriodos[ii,2],"01",CTS->CTS_TPSALD,'3',CT1->CT1_CONTA,CT1->CT1_CONTA,cCCIni,cCCFim,CTD->CTD_ITEM,CTD->CTD_ITEM,cClVlIni,cClVlFim,nImpAntLP,dDataLp)									
													nSaldo:=nSaldo - nSldCC
												Else	
													nSaldo:=CTSMMOV(aPeriodos[ii,1],aPeriodos[ii,2],"01",CTS->CTS_TPSALD,'3',CT1->CT1_CONTA,CT1->CT1_CONTA,cCCIni,cCCFim,CTD->CTD_ITEM,CTD->CTD_ITEM,cClVlIni,cClVlFim,nImpAntLP,dDataLp)
												EndIf
													
												If nSaldo <> 0
													oExcel:AddRow(cNome,cNome,{CT1->CT1_CONTA,CT1->CT1_CONTA,cCCIni,cCCFim,CTD->CTD_ITEM,CTD->CTD_ITEM,cClVlIni,cClVlFim,nSaldo})
												EndIf	       
												IncProc("Processando " + cNome + "..."+CT1->CT1_CONTA+'-'+CTD->CTD_ITEM)
											Endif	
										 	CTD->(dbskip()) 
									   Enddo									            
									 Else 	
										If jj=1 .and. mv_par21=1
											nSldCC:=CTSMMOV(aPeriodos[ii,1],aPeriodos[ii,2],"01",CTS->CTS_TPSALD,'3',CT1->CT1_CONTA,CT1->CT1_CONTA,_cCCI,_cCCF,CTS->CTS_CTDINI,CTS->CTS_CTDFIM,cClVlIni,cClVlFim,nImpAntLP,dDataLp)									
											nSaldo:=CTSMMOV(aPeriodos[ii,1],aPeriodos[ii,2],"01",CTS->CTS_TPSALD,'3',CT1->CT1_CONTA,CT1->CT1_CONTA,cCCIni,cCCFim,CTS->CTS_CTDINI,CTS->CTS_CTDFIM,cClVlIni,cClVlFim,nImpAntLP,dDataLp)									
											nSaldo:=nSaldo - nSldCC
										Else	
											nSaldo:=CTSMMOV(aPeriodos[ii,1],aPeriodos[ii,2],"01",CTS->CTS_TPSALD,'3',CT1->CT1_CONTA,CT1->CT1_CONTA,cCCIni,cCCFim,CTS->CTS_CTDINI,CTS->CTS_CTDFIM,cClVlIni,cClVlFim,nImpAntLP,dDataLp)
										EndIf
											
										If nSaldo <> 0
											oExcel:AddRow(cNome,cNome,{CT1->CT1_CONTA,CT1->CT1_CONTA,cCCIni,cCCFim,CTS->CTS_CTDINI,CTS->CTS_CTDFIM,cClVlIni,cClVlFim,nSaldo})
										EndIf
										IncProc("Processando " + cNome + "..."+CT1->CT1_CONTA)	
									 Endif
            					Endif
								CT1->(dbskip()) 
							Enddo
						Else
							If jj=1 .and. mv_par21=1
								nSldCC:=CTSMMOV(aPeriodos[ii,1],aPeriodos[ii,2],"01",CTS->CTS_TPSALD,'3',CT1->CT1_CONTA,CT1->CT1_CONTA,_cCCI,_cCCF,CTS->CTS_CTDINI,CTS->CTS_CTDFIM,cClVlIni,cClVlFim,nImpAntLP,dDataLp)									
								nSaldo:=CTSMMOV(aPeriodos[ii,1],aPeriodos[ii,2],"01",CTS->CTS_TPSALD,'3',CT1->CT1_CONTA,CT1->CT1_CONTA,cCCIni,cCCFim,CTS->CTS_CTDINI,CTS->CTS_CTDFIM,cClVlIni,cClVlFim,nImpAntLP,dDataLp)									
								nSaldo:=nSaldo - nSldCC
							Else	
								nSaldo:=CTSMMOV(aPeriodos[ii,1],aPeriodos[ii,2],"01",CTS->CTS_TPSALD,'3',CTS->CTS_CT1INI,CTS->CTS_CT1FIM,cCCIni,cCCFim,CTS->CTS_CTDINI,CTS->CTS_CTDFIM,cClVlIni,cClVlFim,nImpAntLP,dDataLp)
                            EndIf
                            
							If nSaldo <> 0
								oExcel:AddRow(cNome,cNome,{CTS->CTS_CT1INI,CTS->CTS_CT1FIM,cCCIni,cCCFim,CTS->CTS_CTDINI,CTS->CTS_CTDFIM,cClVlIni,cClVlFim,nSaldo})
							EndIf
                            IncProc("Processando " + cNome + "..."+CTS->CTS_CT1INI)
                        EndIf
					endif
					CTS->(dbskip()) //proximo
				Enddo
			Else				
				
				//posiciones
				DbSelectArea("CTS")
				CTS->(DbSetOrder(1), DbGoTop(), DbSeek(xFilial("CTS")+MV_PAR01))
				While CTS->(!EOF()) .and. CTS->CTS_FILIAL+CTS_CODPLA=xFilial("CTS")+MV_PAR01
					if lPrim
						cVisao:=AllTrim(PADR(Substr(AllTrim(CTS->CTS_NOME),1,AT(" ",AllTrim(CTS->CTS_NOME))-1),10))
						cNome :=cVisao+iif(Len(aPeriodos)>1.or.MV_PAR05=1,"-"+Strzero(Month(aPeriodos[ii,1]),2)+StrZero(Year(aPeriodos[ii,1]),4),'')+iif(Len(aClasses)>1,'-'+aClasses[i,1],'')
						IncProc("Processando " + cNome + "...")
						oExcel:AddworkSheet(cNome)
						oExcel:AddTable (cNome,cNome)
						/*
						Parâmetros
						Nome	Tipo	Descrição	Default	Obrigatório	Referência
						cWorkSheet	Caracteres	Nome da planilha	 	X
						cTable	Caracteres	Nome da planilha	 	X
						cColumn	Caracteres	Titulo da tabela que será adicionada	 	X
						nAlign	Numérico	Alinhamento da coluna ( 1-Left,2-Center,3-Right )	 	X
						nFormat	Numérico	Codigo de formatação ( 1-General,2-Number,3-Monetário,4-DateTime )	 	X
						lTotal	Lógico	Indica se a coluna deve ser totalizada	 	X
						*/
						oExcel:AddColumn(cNome,cNome,"Data",1,1)
						oExcel:AddColumn(cNome,cNome,"Conta",1,1)
						oExcel:AddColumn(cNome,cNome,"Descr",1,1)
						oExcel:AddColumn(cNome,cNome,"Historico",1,1)
						oExcel:AddColumn(cNome,cNome,"C.Custo",1,1)
						oExcel:AddColumn(cNome,cNome,"Descr",1,1)
						oExcel:AddColumn(cNome,cNome,"Item",1,1)
						oExcel:AddColumn(cNome,cNome,"Descr",1,1)
						oExcel:AddColumn(cNome,cNome,"Classe",1,1)
						oExcel:AddColumn(cNome,cNome,"Descr",1,1)
						oExcel:AddColumn(cNome,cNome,"Valor",3,3)
						oExcel:AddColumn(cNome,cNome,"D/C",1,1)
						lPrim:=.F.
					endif
					if CTS->CTS_CLASSE='2'
						//CTSMMOV(Data De, Data Até, Moeda,TipoSaldo,QualSaldo, Conta De, Conta Até, Centro de Custo De, Centro de Custo Até, Item Contábil De, Item Contábil Até, Classe de Valor De, Classe de Valor Até)
						if empty(aClasses[i,1])
							cClVlIni:=CTS->CTS_CTHINI
							cClVlFim:=CTS->CTS_CTHFIM
						else
							cClVlIni:=aClasses[i,1]
							cClVlFim:=aClasses[i,2]
						endif
						
						cClVlIni:=aClasses[i,1]
						cClVlFim:=aClasses[i,2]


						// tratamento para os centros de custos
						if empty(aCCustos[jj,1])
							cCCIni:=CTS->CTS_CTTINI
							cCCFim:=CTS->CTS_CTTFIM
						else
							cCCIni:=aCCustos[jj,1]
							cCCFim:=aCCustos[jj,2]
						endif
						
						cQry := "Select  * "
						cQry +=  " FROM "+RetSqlName("CT2")
						cQry += " WHERE CT2_FILIAL  = '" + xFilial("CT2") + "'"
						cQry += "  AND D_E_L_E_T_ <> '*'"
						cQry += "  AND CT2_DATA BETWEEN '" + dtos(aPeriodos[ii,1]) + "' AND '"+ dtos(aPeriodos[ii,2])+"' "
						//Conta
						cQry += "  AND ((CT2_DEBITO BETWEEN '" + CTS->CTS_CT1INI + "' AND '"+ CTS->CTS_CT1FIM+ "') OR (CT2_CREDIT BETWEEN '" + CTS->CTS_CT1INI + "' AND '"+ CTS->CTS_CT1FIM+ "')) "
						//Classe
						if !empty(cClVlIni+cClVlFim)
							cQry += "  AND ((CT2_CLVLDB BETWEEN '" + cClVlIni + "' AND '"+ cClVlFim +"') OR (CT2_CLVLCR BETWEEN '" + cClVlIni + "' AND '"+ cClVlFim +"')) "
						endif
						//C.Custo
						if !empty(cCCIni+cCCFim)
							cQry += "  AND ((CT2_CCD BETWEEN '" + cCCIni + "' AND '"+ cCCFim +"') OR (CT2_CCC BETWEEN '" + cCCIni + "' AND '"+ cCCFim +"')) "
						endif
						//Item
						if !empty(CTS->CTS_CTDINI+CTS->CTS_CTDFIM)
							cQry += "  AND ((CT2_ITEMD BETWEEN '" + CTS->CTS_CTDINI + "' AND '"+ CTS->CTS_CTDFIM +"') OR (CT2_ITEMC BETWEEN '" + CTS->CTS_CTDINI + "' AND '"+ CTS->CTS_CTDFIM +"')) "
						endif
						cQry += "  AND CT2_MOEDLC = '01' "
						cQry += "  AND CT2_TPSALD = '" + CTS->CTS_TPSALD + "'"
						cQry += "  ORDER BY  CT2_DATA "
						cQry := ChangeQuery(cQry)                                      
						//memowrit("c:\temp\sql.txt",cQry)
						dbUseArea(.T., "TOPCONN", TCGenQry(,,cQry), 'QRY', .F., .T.)
						QRY->(dbGoTop())
						While QRY->(!EOF())
						    cHistor:=QRY->(GetHist(CT2_FILIAL,stod(CT2_DATA),CT2_LOTE,CT2_SBLOTE,CT2_DOC,CT2_LINHA)) 
							if QRY->CT2_DEBITO>=CTS->CTS_CT1INI .and. QRY->CT2_DEBITO<=CTS->CTS_CT1FIM 
							    cDescCon:=Posicione('CT1',1,xFilial('CT1')+QRY->CT2_DEBITO,'CT1_DESC01')
							    cDescCCu:=Posicione('CTT',1,xFilial('CTT')+QRY->CT2_CCD,'CTT_DESC01')
							    cDescItc:=Posicione('CTD',1,xFilial('CTD')+QRY->CT2_ITEMD,'CTD_DESC01')
							    cDescClv:=Posicione('CTH',1,xFilial('CTH')+QRY->CT2_CLVLDB,'CTH_DESC01')
								QRY->(oExcel:AddRow(cNome,cNome,{DTOC(STOD(CT2_DATA)),CT2_DEBITO,cDescCon,cHistor,CT2_CCD,cDescCCu,CT2_ITEMD,cDescItc,CT2_CLVLDB,cDescClv,CT2_VALOR,'D'}))						
							endif	
							if QRY->CT2_CREDIT>=CTS->CTS_CT1INI .and. QRY->CT2_CREDIT<=CTS->CTS_CT1FIM 
							    cDescCon:=Posicione('CT1',1,xFilial('CT1')+QRY->CT2_CREDIT,'CT1_DESC01')
							    cDescCCu:=Posicione('CTT',1,xFilial('CTT')+QRY->CT2_CCC,'CTT_DESC01')
							    cDescItc:=Posicione('CTD',1,xFilial('CTD')+QRY->CT2_ITEMC,'CTD_DESC01')
							    cDescClv:=Posicione('CTH',1,xFilial('CTH')+QRY->CT2_CLVLCR,'CTH_DESC01')
								QRY->(oExcel:AddRow(cNome,cNome,{DTOC(STOD(CT2_DATA)),CT2_CREDIT,cDescCon,cHistor,CT2_CCC,cDescCCu,CT2_ITEMC,cDescItc,CT2_CLVLCR,cDescClv,CT2_VALOR*-1,'C'}))						
							endif
							QRY->(dbskip()) //proximo
						Enddo
						QRY->(dbCloseArea())
					endif
					CTS->(dbskip()) //proximo
				Enddo
			Endif
		Next jj					
		If mv_par19=1
			lPrim:=.T.
		EndIf	
	Next i
	lPrim:=.T.
Next ii 
//Plano de contas
if mv_par11=1
	DbSelectArea("CT1")
	CT1->(DbSetOrder(1), DbGoTop(), DbSeek(xFilial("CT1")))
	cNome :='Plano de Contas'
	IncProc("Processando " + cNome + "...")
	oExcel:AddworkSheet(cNome)
	oExcel:AddTable (cNome,cNome)
	oExcel:AddColumn(cNome,cNome,"Conta",1,1)
	oExcel:AddColumn(cNome,cNome,"Classe",1,1)
	oExcel:AddColumn(cNome,cNome,"Descrição",1,1)
	While CT1->(!EOF()) .and. CT1->CT1_FILIAL=xFilial("CT1")
		oExcel:AddRow(cNome,cNome,{CT1->CT1_CONTA,if(CT1->CT1_CLASSE='1','Sintetica','Analitica'),CT1->CT1_DESC01})
		CT1->(dbskip()) //proximo
	Enddo
endif

//Centro de Custos
if mv_par12=1
	DbSelectArea("CTT")
	CTT->(DbSetOrder(1), DbGoTop(), DbSeek(xFilial("CTT")))
	cNome :='Centro de Custos'
	IncProc("Processando " + cNome + "...")
	oExcel:AddworkSheet(cNome)
	oExcel:AddTable (cNome,cNome)
	oExcel:AddColumn(cNome,cNome,"C.Custo",1,1)
	oExcel:AddColumn(cNome,cNome,"Classe",1,1)
	oExcel:AddColumn(cNome,cNome,"Descrição",1,1)
	While CTT->(!EOF()) .and. CTT->CTT_FILIAL=xFilial("CTT")
		oExcel:AddRow(cNome,cNome,{CTT->CTT_CUSTO,if(CTT->CTT_CLASSE='1','Sintetica','Analitica'),CTT->CTT_DESC01})
		CTT->(dbskip()) //proximo
	Enddo
endif

//Itens Ctb
if mv_par13=1
	DbSelectArea("CTD")
	CTD->(DbSetOrder(1), DbGoTop(), DbSeek(xFilial("CTD")))
	cNome :='Itens Ctb'
	IncProc("Processando " + cNome + "...")
	oExcel:AddworkSheet(cNome)
	oExcel:AddTable (cNome,cNome)
	oExcel:AddColumn(cNome,cNome,"Item",1,1)
	oExcel:AddColumn(cNome,cNome,"Classe",1,1)
	oExcel:AddColumn(cNome,cNome,"Descrição",1,1)
	While CTD->(!EOF()) .and. CTD->CTD_FILIAL=xFilial("CTD")
		oExcel:AddRow(cNome,cNome,{CTD->CTD_ITEM,if(CTD->CTD_CLASSE='1','Sintetica','Analitica'),CTD->CTD_DESC01})
		CTD->(dbskip()) //proximo
	Enddo
endif

//Classes
if mv_par14=1
	DbSelectArea("CTH")
	CTH->(DbSetOrder(1), DbGoTop(), DbSeek(xFilial("CTH")))
	cNome :='Classes'
	IncProc("Processando " + cNome + "...")
	oExcel:AddworkSheet(cNome)
	oExcel:AddTable (cNome,cNome)
	oExcel:AddColumn(cNome,cNome,"Classe Vlr",1,1)
	oExcel:AddColumn(cNome,cNome,"Classe",1,1)
	oExcel:AddColumn(cNome,cNome,"Descrição",1,1)
	While CTH->(!EOF()) .and. CTH->CTH_FILIAL=xFilial("CTH")
		oExcel:AddRow(cNome,cNome,{CTH->CTH_CLVL,if(CTH->CTH_CLASSE='1','Sintetica','Analitica'),CTH->CTH_DESC01})
		CTH->(dbskip()) //proximo
	Enddo
endif

CTS->(DbSetOrder(1), DbGoTop(), DbSeek(xFilial("CTS")+MV_PAR01))
oExcel:Activate()
cPath:=AllTrim(mv_par04)
cArquivo:=AllTrim(CTS->CTS_NOME)+".xml"
oExcel:GetXMLFile(cArquivo)
cpys2t("\system\"+cArquivo,cPath)
oExcelApp := MsExcel():New()
oExcelApp:WorkBooks:Open( cPath+cArquivo) // Abre uma planilha
oExcelApp:SetVisible(.T.)

Return lRet

Static Function GetHist(cFILIAL,dDATA,cLOTE,cSBLOTE,cDOC,cLINHA)
Local cHist:=''  
Local cChave:=cFILIAL+dtos(dDATA)+cLOTE+cSBLOTE+cDOC+cLINHA
if CT2->(DbSetOrder(1), DbGoTop(), DbSeek(cChave))   
  cHist:=CT2->CT2_HIST
endif
cChave:=cFILIAL+dtos(dDATA)+cLOTE+cSBLOTE+cDOC
While CT2->(CT2_FILIAL+dtos(CT2_DATA)+CT2_LOTE+CT2_SBLOTE+CT2_DOC)=cChave
  
  CT2->(dbskip())
  if CT2->(CT2_FILIAL+dtos(CT2_DATA)+CT2_LOTE+CT2_SBLOTE+CT2_DOC)=cChave .and. CT2->CT2_DC='4' //Complemento de historico
    cHist+=CT2->CT2_HIST
  else
    Exit  
  endif
Enddo
Return AllTrim(cHist)

/*
_____________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦Programa  ¦ AjustaSX1   ¦ Autor ¦ Totvs            ¦ Data ¦ 14/11/2013 ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Descriçào ¦ Cria perguntas da rotina									  ¦¦¦
¦¦¦          ¦                                                            ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Uso       ¦ TOTVS - GO		                                          ¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
*/
Static Function AjustaSX1()

Local aHelpPor	:= {}
Local aHelpEng	:= {}
Local aHelpSpa	:= {}

PutSx1( cPerg, "01","Visão Gerencial?","Visão Gerencial ?","Visão Gerencial ?","mv_ch1","C",3,0,0,"G","","CTS","","",;
"mv_par01","","","","","","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)
PutSx1( cPerg, "02","Data Inicial ?","¿Fecha Inicial ?","Initial Date ?","mv_ch2","D",10,0,0,"G","","","","",;
"mv_par02","","","","","","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)
PutSx1( cPerg, "03","Data Final ?","¿Fecha Final ?","Final Date ?","mv_ch3","D",10,0,0,"G","","","","",;
"mv_par03","","","","","","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)
PutSx1( cPerg, "04","Path de gravação?","Path de gravação ?","Path de gravação ?","mv_ch4","C",30,0,0,"G","","","","",;
"mv_par04","","","","","","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)
PutSx1( cPerg, "05","Quebra por mês ?","¿Quebra por mês ?","Quebra por mês ?","mv_ch5","N",1,0,0,"C","","","","",;
"mv_par05","Sim","Si","Yes","Não","Não","No","No","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)
PutSx1( cPerg, "06","Impr Antes L/P ?","Impr Antes L/P ?","Impr Antes L/P ?","mv_ch6","N",1,0,0,"C","","","","",;
"mv_par06","Sim","Si","Yes","Não","Não","No","No","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)
PutSx1( cPerg, "07","Data L/P ?","Data L/P ?","Data L/P ?","mv_ch7","D",10,0,0,"G","","","","",;
"mv_par07","","","","","","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)
PutSx1( cPerg, "08","Classe de?","Classe de?","Classe de?","mv_ch8","C",9,0,0,"G","","CTH","","",;
"mv_par08","","","","","","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)
PutSx1( cPerg, "09","Classe ate?","Classe ate?","Classe ate?","mv_ch9","C",9,0,0,"G","","CTH","","",;
"mv_par09","","","","","","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)
PutSx1( cPerg, "10","Quebra por Classe ?","¿Quebra por Classe ?","Quebra por Classe ?","mv_cha","N",1,0,0,"C","","","","",;
"mv_par10","Sim","Si","Yes","Não","Não","No","No","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)
PutSx1( cPerg, "11","Gera Plano de Contas ?","¿QGera Plano de Contas ?","Gera Plano de Contas ?","mv_chb","N",1,0,0,"C","","","","",;
"mv_par11","Sim","Si","Yes","Não","Não","No","No","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)
PutSx1( cPerg, "12","Gera C.Custo ?","¿QGera C.Custo ?","Gera C.Custo ?","mv_chc","N",1,0,0,"C","","","","",;
"mv_par12","Sim","Si","Yes","Não","Não","No","No","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)
PutSx1( cPerg, "13","Gera Itens Ctb ?","¿QGera Itens Ctb ?","Gera Itens Ctb ?","mv_chd","N",1,0,0,"C","","","","",;
"mv_par13","Sim","Si","Yes","Não","Não","No","No","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)
PutSx1( cPerg, "14","Gera Classe Vlr ?","¿QGera  Classe Vlr ?","Gera  Classe Vlr ?","mv_che","N",1,0,0,"C","","","","",;
"mv_par14","Sim","Si","Yes","Não","Não","No","No","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)
PutSx1( cPerg, "15","Balancete/Razao?","Balancete/Razao?","Balancete/Razao?","mv_chf","N",1,0,0,"C","","","","",;
"mv_par15","Balancete","Balancete","Balancete","Razao","Razao","Razao","Razao","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)
PutSx1( cPerg, "16","C.Custo de?","C.Custo de?","C.Custo de?","mv_chg","C",9,0,0,"G","","CTT","","",;
"mv_par16","","","","","","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)
PutSx1( cPerg, "17","C.Custo ate?","C.Custo ate?","C.Custo ate?","mv_chh","C",9,0,0,"G","","CTT","","",;
"mv_par17","","","","","","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)
PutSx1( cPerg, "18","Quebra por C. Custos ?","¿Quebra por C. Custos ?","Quebra por C. Custos ?","mv_chi","N",1,0,0,"C","","","","",;
"mv_par18","Sim","Si","Yes","Não","Não","No","No","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)
PutSx1( cPerg, "19","WorkSheet por Classe de Valor ?","¿WorkSheet por Classe de Valor?","WorkSheet por Classe de Valor ?","mv_chj","N",1,0,0,"C","","","","",;
"mv_par19","Sim","Si","Yes","Não","Não","No","No","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)
PutSx1( cPerg, "20","Desmembra Conta contábil ?","¿Desmembra Conta contábil?","Desmembra Conta contábil?","mv_chk","N",1,0,0,"C","","","","",;
"mv_par20","Sim","Si","Yes","Não","Não","No","No","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)
PutSx1( cPerg, "21","Buscar lanctos sem C.Custo?","¿Buscar lanctos sem C.Custo?","Buscar lanctos sem C.Custo","mv_chl","N",1,0,0,"C","","","","",;
"mv_par21","Sim","Si","Yes","Não","Não","No","No","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)
PutSx1( cPerg, "22","Desmembra Item Contabil?","¿Desmembra Item Contabil?","Desmembra Item Contabil","mv_chm","N",1,0,0,"C","","","","",;
"mv_par22","Sim","Si","Yes","Não","Não","No","No","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)

Return
