#INCLUDE "Protheus.ch"
#INCLUDE "Totvs.ch"
#INCLUDE "topconn.ch"

User Function copcontr
//carllosdaniell - 30/11/2022

Local aArea := GetArea()
Private cTes := ''
Private cOper := ''

Private cQry        := ""
Private cQryADB     := ""
//Local cQryAtu     := ""
Private nMaxNum     := ""
//Local cTpOper     := ""
Private nCount      := 0
Private nSaldo      := 0
//Local nPrcVen     := 0
Private lGrava      := .F.
//Local lPrint      := .F.
Private lok         := .F.
Private vLrVend := 0
//Variáveis MVs
Private mvFilial   := "4200"
Private mvContrato := ADA->ADA_NUMCTR //define numero contrato da 4200 pra manter
//TELA FILTRO
Private cContra		:= ADA->ADA_NUMCTR
Private _oDlg		:= Nil
Private mvCliente  := ADA->ADA_CODCLI

   If cFilAnt <> '4200'

        MsgStop( 'Acesso NEGADO na Filial = '+cFilAnt+', Autorizado apenas na 4200 para copia venda ordem', 'Atencao' )

        Return()

    EndIf

ALTEMP('01','4104')

    If Select("cQry") > 0                                 
     
        cQry->(dbclosearea())

    EndIf   

	cQry := "SELECT * "
    cQry += "FROM ADA020 ADA "
	cQry += "INNER JOIN ADB020 ADB ON ADA_FILIAL = ADB_FILIAL "
    cQry += "AND ADA_NUMCTR =  ADB_NUMCTR "	                                      	
	cQry += "WHERE ADA.D_E_L_E_T_ <> '*' "
	cQry += "AND ADB.D_E_L_E_T_ <> '*' "		
 	cQry += "AND ADA_FILIAL = "+mvFilial+" " 
    cQry += "AND ADA_NUMCTR = "+mvContrato+" "                  

	MemoWrite("C:\TEMP\COPADA.txt",cQry)
	cQry := ChangeQuery(cQry)

	TcQuery cQry New Alias "cQry" 

    Count to nCount

    If nCount <= 0

        MsgStop( 'Nenhum registro foi encontrado com os parametros informados, por favor verifique os parametros.', 'Atencao' )

        Return()

    EndIf

    cQry->(DbGoTop()) 
	
    Begin Transaction      

	While !cQry->(EOF())
	
				//Busca Maior Numero
				nMaxNum := Soma1(MaxNumCtr())

				//RecLock ADA POSICIONAR 
				// COMECA CRIAR NOVO CONTRATO
					RecLock("ADA", .T.)  			
					ADA->ADA_FILIAL    := cFilAnt 
					ADA->ADA_NUMCTR    := nMaxNum
					ADA->ADA_EMISSA    := dDataBase
					ADA->ADA_CODCLI    := '002966'
					ADA->ADA_LOJCLI    := '01'
					ADA->ADA_XEST      := cQry->ADA_XEST 
					ADA->ADA_CONDPG    := '00D' 
					ADA->ADA_XPED      := cQry->ADA_XPED  
					ADA->ADA_TABELA    := ' '  
					ADA->ADA_VEND1     := cQry->ADA_VEND1
					ADA->ADA_COMIS1    := 0 
					ADA->ADA_MOEDA     := cQry->ADA_MOEDA 
					ADA->ADA_TIPLIB    := cQry->ADA_TIPLIB 
					ADA->ADA_STATUS    := 'A'
					ADA->ADA_XNOMC     := 'ERCAL SOLUCOES LTDA' 
					ADA->ADA_XNATUR    := cQry->ADA_XNATUR
					ADA->ADA_TPFRET    := cQry->ADA_TPFRET 
					ADA->ADA_ESPECI    := cQry->ADA_ESPECI
					ADA->ADA_VOLUME    := cQry->ADA_VOLUME
					ADA->ADA_MARCA     := '001' 
					ADA->ADA_XFRETE    := cQry->ADA_XFRETE
					ADA->ADA_XDESP     := cQry->ADA_XDESP 
					ADA->ADA_XBANCO    := '022' 
					ADA->ADA_XADIAN    := cQry->ADA_XADIAN 
					ADA->ADA_XMENOT    := cQry->ADA_XMENOT
					ADA->ADA_XCOMPL    := cQry->ADA_XCOMPL
					ADA->ADA_FRETE     := cQry->ADA_FRETE 
					ADA->ADA_XVENC     := dDataBase+30
					ADA->ADA_XOBS      := cQry->ADA_XOBS
					ADA->ADA_MSBLQL    := cQry->ADA_MSBLQL
					ADA->ADA_XORDEM    := '1'
					ADA->ADA_XCLIOR    := cQry->ADA_CODCLI
					ADA->ADA_XLOJOR    := cQry->ADA_LOJCLI

				ADA->(MsUnlock())			
				//RecLock ADB

				If Select("cQryADB") > 0                                 
     
        			cQryADB->(dbclosearea())

    			EndIf   
//TERMINA GRAVACAO ADA
				cQryADB := "SELECT * "                                                         + CRLF
    			cQryADB += "FROM ADB020 ADB "       				                           + CRLF
	    		cQryADB += "WHERE ADB.D_E_L_E_T_ <> '*' "                                      + CRLF
 	    		cQryADB += "AND ADB_FILIAL = '"+mvFilial+"' "                                  + CRLF
	    		cQryADB += "AND ADB_NUMCTR = '"+mvContrato+"' "                                + CRLF
	    		cQryADB += "AND ADB_CODCLI = '"+mvCliente+"'  "                                + CRLF  
 	    		//cQryADB += "AND ADB_LOJCLI = '"+cQry->ADA_LOJCLI+"' "                          + CRLF 

				MemoWrite("C:\TEMP\REPADB.txt",cQryADB)
				cQryADB := ChangeQuery(cQryADB)

				TcQuery cQryADB New Alias "cQryADB" 

				While !cQryADB->(EOF())

				nSaldo := cQryADB->ADB_QUANT - cQryADB->ADB_QTDEMP
					//Reclock ADB
				If nSaldo > 0
				//vLrVend
					If  MsgYesNo('Deseja informar Valor Venda Ercal?')
						DEFINE MSDIALOG oDlg TITLE "Valor Unitario Produto." FROM 09,0 TO 17,38
	
						DEFINE FONT oBold NAME 'Arial'	SIZE  0,-13 BOLD
						@ 03, 10 SAY "Valor Produto:" SIZE 160, 16 OF oDlg PIXEL
	
						@ 21, 53 MSGET oGet1 VAR vLrVend Picture "@E 999,999,999.9999" SIZE 060, 10 OF oDlg PIXEL
						//@ 30, 53 MSGET oGet1 VAR _nValDes Picture PesqPict("DTC","DTC_VALOR") SIZE 060, 10 OF oDlg PIXEL
	
						DEFINE SBUTTON oBut1 FROM 50, 65	TYPE 1 ACTION ( nOpca := 1,oDlg:End() ) ENABLE OF oDlg
						DEFINE SBUTTON oBut2 FROM 50, 97	TYPE 2 ACTION ( nOpca := 0,oDlg:End() ) ENABLE OF oDlg
	
						ACTIVATE MSDIALOG oDlg CENTERED
					else
						vLrVend := ADB->ADB_PRCVEN
					EndIf
					//u_vlrven(vLrVend) //altera valor venda para ercal
					// função que retorna a TES de acordo com o tipo de operação
					cOper := '85'
				    cTes := MaTesInt(2, cOper ,'002966','01',"C",'000082',NIL)	
					
					RecLock("ADB", .T.)
    			
					ADB->ADB_FILIAL    := cFilAnt  //alterar filial 
					ADB->ADB_NUMCTR    := nMaxNum
					ADB->ADB_ITEM      := cQryADB->ADB_ITEM  
					ADB->ADB_CODPRO    := '000082' 
					ADB->ADB_DESPRO    := cQryADB->ADB_DESPRO 
					ADB->ADB_UM        := cQryADB->ADB_UM  
					ADB->ADB_QUANT     := cQryADB->ADB_QUANT 
					ADB->ADB_PRCVEN    := vLrVend
					ADB->ADB_TOTAL     := (vLrVend*cQryADB->ADB_QUANT)
					ADB->ADB_XTIPO     := cOper //alterar para novo tipo
					ADB->ADB_TES       := cTes // tes 
					ADB->ADB_TESCOB    := '527' // tes cobrança
					ADB->ADB_LOCAL     := cQryADB->ADB_LOCAL 
					ADB->ADB_PRUNIT    := cQryADB->ADB_PRUNIT 
					ADB->ADB_SEGUM     := cQryADB->ADB_SEGUM
					ADB->ADB_UNSVEN    := cQryADB->ADB_UNSVEN 
					ADB->ADB_DESC      := cQryADB->ADB_DESC
					ADB->ADB_VALDES    := cQryADB->ADB_VALDES
					ADB->ADB_FILENT    := cQryADB->ADB_FILENT
					ADB->ADB_QTDENT    := cQryADB->ADB_QTDENT
					ADB->ADB_PEDCOB    := cQryADB->ADB_PEDCOB
					ADB->ADB_CODCLI    := '002966'//cQryADB->ADB_CODCLI 
					ADB->ADB_LOJCLI    := '01'//cQryADB->ADB_LOJCLI
		
					ADB->(MsUnlock())

					lGrava := .T.

				EndIf 

    			cQryADB->(DbSkip())

    			Enddo
				
				lOk    := .T.

				If !lGrava
        
      	            MsgStop("Este Contrato não tem saldo, apenas Contratos com saldo são permitidos.", "Atenção")
       	            DisarmTransaction()
					lOk    := .F.

            	EndIf
            

    cQry->(DbSkip())

    Enddo

	End Transaction

	If lOk 

		MsgAlert("O contrato foi criado com sucesso na 4104 Numero: "+nMaxNum+"!!!","Atenção")

	EndIf

ALTEMP('02','4200')
	//GRAVA NOME CONTRATO DA 1 VALIDAR
    RestArea(aArea)
	dbselectarea("SA7")
	SA7->(DbSetOrder(1))
	if !ADA->(Dbseek(xFilial("ADA")+mvContrato))
							
		RecLock("ADA",.T.)
		ADA->ADA_XCTR 	:= nMaxNum // NUMERO CONTRATO CRIADO CRIAR CAMPOS
		ADA->ADA_XFILIAL  := '4104' // FILIAL TRAVADA EMPRESA CONTRATO NOVO
		ADA->( MsUnlock() )
							
	endif

Return

Static Function MaxNumCtr()

Local cNumCtr := ""
Local cQryMax := ""

	
    If Select("cQryMax") > 0                                 
     
        cQryMax->(dbclosearea())

    EndIf   

	cQryMax := "SELECT MAX(ADA_NUMCTR) AS NUMCTR "                                 + CRLF
    cQryMax += "FROM ADA010 ADA "                                				   + CRLF
 	cQryMax += "WHERE ADA_FILIAL = '4104' "                                        + CRLF

	MemoWrite("C:\TEMP\repcQryMax.txt",cQryMax)
	cQryMax := ChangeQuery(cQryMax)

	TcQuery cQryMax New Alias "cQryMax" 

	cNumCtr := cQryMax->NUMCTR

Return cNumCtr

static Function ALTEMP(cEmp, cFil)
//funcao que altera empresa posicionado
Local cemp:=cEmp
Local cfil:=cFil
     
     dbcloseall()

     cempant :=cemp
     cfilant :=cfil
     cNumEmp :=cemp+cfil
     Opensm0(cempant+cfil)
     Openfile(cempant+cfil)
     lrefresh :=.T.
            
Return
