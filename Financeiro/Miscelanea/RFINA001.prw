#Include "PROTHEUS.CH"

/*/{Protheus.doc} RFINA001
Criado por Gontijo Tecnologia 
Data: 21/10/2022
/*/ 

#include "protheus.ch"


user function RFINA001

 Private aSize := {}
 Private bOk := {|| }
 Private bCancel:= {|| }
 Private oButton1
Private oButton2
Private oComboBo1
Private nComboBo1 := 1
Private oGet1
Private cGet1 := ctod("  /  /   ")
Private oGet2
Private cGet2 :=  ctod("  /  /   ")
Private oGet3
Private cGet3 := ctod("  /  /   ")
Private oGet4
Private cGet4 := ctod("  /  /   ")
Private oGet5
Private cGet5 := space(6)
Private oGet6
Private cGet6 := "ZZZZZZ"
Private oGet7
Private cGet7 := space(6)
Private oGet8
Private cGet8 := "ZZZZZZ"
Private oGet9
Private cGet9 := space(6)
Private oGet10
Private cGet10 := "ZZZZZZ"
Private oGet12
Private cGet12 := space(3)
Private oGet13
Private cGet13 := space(6)
Private oGet14
Private cGet14 := space(10)
Private CGET15 := date()
Private oGet15
Private oGet16
Private cGet16 := space(3)
Private oGet17
Private cGet17 := "ZZZ"
Private oGroup1
Private oSay1
Private oSay10
Private oSay11
Private oSay12
Private oSay13
Private oSay14
Private oSay15
Private oSay2
Private oSay3
Private oSay4
Private oSay5
Private oSay6
Private oSay7
Private oSay8
Private oSay9
Private nValorSaldo := 0
Private oFont1 := TFont():New("MS Sans Serif",,026,,.T.,,,,,.F.,.F.)
Private bSvblDblClick
Private oPeso
Private oGet18
Private cGet18 := "  "
Private oGet19
Private cGet19 := "ZZ"

aSize := MsAdvSize(.F.)
 
Define MsDialog oDlg TITLE "Baixa Automática HighLine" STYLE DS_MODALFRAME From aSize[7],0 To aSize[6],aSize[5] OF oMainWnd PIXEL
 
  nLin := 5
 
    //@ 003, 003 GROUP oGroup1 TO 037, 695 PROMPT "Pesquisar" OF oDlg COLOR 0, 16777215 PIXEL
    @ 005+nLin, 009 SAY oSay1 PROMPT "Data de Emissão" SIZE 065, 007 OF oDlg COLORS 0, 16777215 PIXEL
    @ 005+nLin, 009 SAY oSay1 PROMPT "Data de Emissão" SIZE 065, 007 OF oDlg COLORS 0, 16777215 PIXEL
    @ 014+nLin, 011 MSGET oGet1 VAR cGet1 SIZE 056, 010 OF oDlg COLORS 0, 16777215 PIXEL
    @ 017+nLin, 070 SAY oSay2 PROMPT "à" SIZE 025, 007 OF oDlg COLORS 0, 16777215 PIXEL
    @ 014+nLin, 078 MSGET oGet2 VAR cGet2 SIZE 060, 010 OF oDlg COLORS 0, 16777215 PIXEL

    @ 005+nLin, 149 SAY oSay3 PROMPT "Data de Vencimento" SIZE 065, 007 OF oDlg COLORS 0, 16777215 PIXEL
    @ 014+nLin, 148 MSGET oGet3 VAR cGet3 SIZE 053, 010 OF oDlg COLORS 0, 16777215 PIXEL
    @ 017+nLin, 203 SAY oSay4 PROMPT "à" SIZE 025, 007 OF oDlg COLORS 0, 16777215 PIXEL
    @ 014+nLin, 209 MSGET oGet4 VAR cGet4 SIZE 049, 010 OF oDlg COLORS 0, 16777215 PIXEL
    
    @ 005+nLin, 265 SAY oSay5 PROMPT "Cliente De" SIZE 065, 007 OF oDlg COLORS 0, 16777215 PIXEL
    @ 014+nLin, 264 MSGET oGet5 VAR cGet5 F3 "SA1" SIZE 032, 010 OF oDlg COLORS 0, 16777215 PIXEL
    
    @ 005+nLin, 298 SAY oSay5 PROMPT "Loja" SIZE 065, 007 OF oDlg COLORS 0, 16777215 PIXEL
    @ 014+nLin, 298 MSGET oGet18 VAR cGet18 SIZE 015, 010 OF oDlg COLORS 0, 16777215 PIXEL
    
    @ 017+nLin, 316 SAY oSay6 PROMPT "à" SIZE 025, 007 OF oDlg COLORS 0, 16777215 PIXEL

    @ 005+nLin, 321 SAY oSay5 PROMPT "Cliente Até" SIZE 065, 007 OF oDlg COLORS 0, 16777215 PIXEL
    @ 014+nLin, 322 MSGET oGet6 VAR cGet6 F3 "SA1" SIZE 032, 010 OF oDlg COLORS 0, 16777215 PIXEL
    @ 005+nLin, 355 SAY oSay5 PROMPT "Loja" SIZE 065, 007 OF oDlg COLORS 0, 16777215 PIXEL
    @ 014+nLin, 355 MSGET oGet19 VAR cGet19 SIZE 015, 010 OF oDlg COLORS 0, 16777215 PIXEL
   
    @ 005+nLin, 373 SAY oSay7 PROMPT "Prefixo" SIZE 065, 007 OF oDlg COLORS 0, 16777215 PIXEL
    @ 014+nLin, 371 MSGET oGet7 VAR cGet7 SIZE 031, 010 OF oDlg COLORS 0, 16777215 PIXEL
    @ 017+nLin, 406 SAY oSay8 PROMPT "à" SIZE 025, 007 OF oDlg COLORS 0, 16777215 PIXEL
    @ 014+nLin, 413 MSGET oGet8 VAR cGet8 SIZE 031, 010 OF oDlg COLORS 0, 16777215 PIXEL
    
    nLin := 35

    @ 005+nLin, 009 SAY oSay9 PROMPT "Natureza" SIZE 065, 007 OF oDlg COLORS 0, 16777215 PIXEL
    @ 014+nLin, 011 MSGET oGet9 VAR cGet9 F3 "SED" SIZE 043, 010 OF oDlg COLORS 0, 16777215 PIXEL
    @ 016+nLin, 058 SAY oSay10 PROMPT "à" SIZE 025, 007 OF oDlg COLORS 0, 16777215 PIXEL
    @ 014+nLin, 064 MSGET oGet10 VAR cGet10 F3 "SED" SIZE 040, 010 OF oDlg COLORS 0, 16777215 PIXEL
  
    @ 005+nLin, 110 SAY oSay16 PROMPT "Tipo" SIZE 065, 007 OF oDlg COLORS 0, 16777215 PIXEL
    @ 014+nLin, 112 MSGET oGet16 VAR cGet16 F3 "05" SIZE 043, 010 OF oDlg COLORS 0, 16777215 PIXEL
    @ 016+nLin, 156 SAY oSay17 PROMPT "à" SIZE 025, 007 OF oDlg COLORS 0, 16777215 PIXEL
    @ 014+nLin, 165 MSGET oGet17 VAR cGet17 F3 "05" SIZE 040, 010 OF oDlg COLORS 0, 16777215 PIXEL  

    @ 006+nLin, 215 BUTTON oButton1 PROMPT "Pesquisar" SIZE 060, 020 OF oDlg PIXEL action Processa({|| funPesq()},"Pesquisando","Aguarde, processando informações...")

    fMSNewGe1()

    @ 220+nLin, 310-200 SAY oSay11 PROMPT "Motivo Baixa" SIZE 041, 007 OF oDlg COLORS 0, 16777215 PIXEL
    @ 227+nLin, 311-200 MSCOMBOBOX oComboBo1 VAR nComboBo1 ITEMS {"Normal","Dação","Devolução","Mutuo","Cancela NF"} SIZE 072, 010 OF oDlg COLORS 0, 16777215 PIXEL
    @ 220+nLin, 393-200 SAY oSay12 PROMPT "Banco" SIZE 025, 007 OF oDlg COLORS 0, 16777215 PIXEL
    @ 227+nLin, 394-200 MSGET oGet12 VAR cGet12 F3 "SA6" SIZE 037, 010 OF oDlg COLORS 0, 16777215 PIXEL
    @ 220+nLin, 433-200 SAY oSay13 PROMPT "Agência" SIZE 025, 007 OF oDlg COLORS 0, 16777215 PIXEL
    @ 227+nLin, 433-200 MSGET oGet13 VAR cGet13 SIZE 060, 010 OF oDlg COLORS 0, 16777215 PIXEL
    @ 220+nLin, 497-200 SAY oSay14 PROMPT "Conta" SIZE 025, 007 OF oDlg COLORS 0, 16777215 PIXEL
    @ 227+nLin, 498-200 MSGET oGet14 VAR cGet14 SIZE 050, 010 OF oDlg COLORS 0, 16777215 PIXEL
    @ 220+nLin, 550-200 SAY oSay15 PROMPT "Data Baixa" SIZE 025, 007 OF oDlg COLORS 0, 16777215 PIXEL
    @ 227+nLin, 551-200 MSGET oGet15 VAR cGet15 SIZE 050, 010 OF oDlg COLORS 0, 16777215 PIXEL

    @ 222+nLin, 020 SAY oPeso PROMPT "Valor R$ " +allTrim(Transform(nValorSaldo, "@E 9,999,999,999,999.99")) SIZE 150, 013 OF oDlg FONT oFont1 COLORS CLR_RED, 16777215 PIXEL

    @ 222+nLin, 618-200 BUTTON oButton2 PROMPT "Salvar" SIZE 052, 017 OF oDlg PIXEL action Processa({|| funSalvar() },"Salvando","Aguarde, processando informações...")

    @ 222+nLin, 630-150  BUTTON oButton2 PROMPT "Sair" SIZE 052, 017 OF oDlg PIXEL action oDlg:end()


ACTIVATE MSDIALOG oDlg CENTERED // ON INIT EnchoiceBar(oDlg, bCancel)

Return


static function funSalvar 
  LOCAL aAreaAnt := GETAREA()
  Local nX := 1
  Private lMsErroAuto     := .F.
  nContBaixa := 0

  if MsgYesNo("Tem certeza que deseja baixar os títulos? ") 


    nPorta := padR(alltrim(cGet12),3,"")
    nAgenc := padR(alltrim(cGet13),5,"")
    nConta := padR(alltrim(cGet14),10,"")

    DbSelectArea("SA6")
    SA6->(DbSetOrder(1))
    SA6->(DbGotop())
    if SA6->(dbseek(xFilial("SA6")+nPorta+nAgenc+nConta)) //A6_FILIAL+A6_COD+A6_AGENCIA+A6_NUMCON
      if SA6->A6_BLOCKED == "1"
        aviso("Atenção","Conta bloqueada! Escolha olha!",{"OK"})
        return 
      endif
    else 
      aviso("Atenção","Conta encontrada",{"OK"})
      return 
    endif 

    for nX := 1 to len(oMSNewGe1:ACOLS)

      if oMSNewGe1:ACOLS[nX][01] == "LBOK"

          cE1_FILIAL  := oMSNewGe1:ACOLS[nX][02] 
          cE1_PREFIXO := oMSNewGe1:ACOLS[nX][03]
          cE1_NUM     := oMSNewGe1:ACOLS[nX][04]
          cE1_PARCELA := oMSNewGe1:ACOLS[nX][05]
          cE1_TIPO    := oMSNewGe1:ACOLS[nX][06]
          cE1_CLIENTE := oMSNewGe1:ACOLS[nX][07]
          cE1_LOJA    := oMSNewGe1:ACOLS[nX][08]
          nValRec     := oMSNewGe1:ACOLS[nX][14]
          
          if SE1->(dbseek(cE1_FILIAL+cE1_PREFIXO+cE1_NUM+cE1_PARCELA+cE1_TIPO ))

                aBaixa := { {"E1_PREFIXO"  ,cE1_PREFIXO           ,Nil    },;
                            {"E1_NUM"      ,cE1_NUM               ,Nil    },;
                            {"E1_TIPO"     ,cE1_TIPO              ,Nil    },;
                            {"E1_PARCELA"  , cE1_PARCELA          ,Nil    },;
                            {"E1_CLIENTE"  , cE1_CLIENTE          ,Nil    },;
                            {"E1_LOJA"     , cE1_LOJA             ,Nil    },;
                            {"AUTMOTBX"    ,"NOR"                 ,Nil    },;
                            {"AUTBANCO"    ,nPorta                ,Nil    },; //PRECISA VER QUAL O BANCO CORRETO
                            {"AUTAGENCIA"  ,nAgenc                ,Nil    },;
                            {"AUTCONTA"    ,nConta                ,Nil    },;
                            {"AUTDTBAIXA"  ,cGet15                ,Nil    },;
                            {"AUTDTCREDITO",cGet15                ,Nil    },;
                            {"AUTHIST"     ,"BX.AUTO.RFINA001"+SA6->A6_COD+SA6->A6_AGENCIA+SA6->A6_NUMCON    ,Nil    },;
                            {"AUTJUROS"    ,0                     ,Nil,.T.},;
                            {"AUTVALREC"   ,nValRec               ,Nil    }}

                lMsErroAuto := .F.

                MSExecAuto({|x,y,b,a| Fina070(x,y,b,a)},aBaixa,3,.F.,5) //3 - Baixa de Título, 5 - Cancelamento de baixa, 6 - Exclusão de Baixa.

                If lMsErroAuto
                    MostraErro()        
                else
                    nContBaixa += 1 
                endif 
          endif 
      endif 
    next nX 

  endif 
  aviso("Informação",alltrim(str(nContBaixa))+" título(s) baixado(s) com sucesso!",{"OK"})
  Processa({|| funPesq()},"Pesquisando","Aguarde, processando informações...")
  RESTAREA(aAreaAnt)

return 
static function funPesq

      oMSNewGe1:aCols :={}
      oMSNewGe1:Refresh()	
  
      cQuery := "SELECT * FROM " + RetSqlName("SE1") + " SE1,  "+ RetSqlName("SA1") + " SA1  "
	    cQuery += " WHERE SE1.D_E_L_E_T_ <> '*' AND E1_SALDO > 0 AND SA1.D_E_L_E_T_ <> '*' AND A1_COD = E1_CLIENTE AND A1_LOJA = E1_LOJA "

      if !empty(cGet1) 
        cQuery += " AND E1_EMISSAO BETWEEN '"+dtos(cGet1)+"' AND '"+dtos(cGet2)+"' "
      endif 
      if !empty(cGet3) 
        cQuery += " AND E1_VENCTO BETWEEN '"+dtos(cGet3)+"' AND '"+dtos(cGet4)+"' "
      endif 
      if !empty(cGet5) 
        cQuery += " AND E1_CLIENTE BETWEEN '"+cGet5+"' AND '"+cGet6+"' "
      endif 
      if !empty(cGet7) 
        cQuery += " AND E1_PREFIXO BETWEEN '"+cGet7+"' AND '"+cGet8+"' "
      endif 
      if !empty(cGet9) 
        cQuery += " AND E1_NATUREZ BETWEEN '"+cGet9+"' AND '"+cGet10+"' "
      endif 
      if !empty(cGet16) 
        cQuery += " AND E1_TIPO BETWEEN '"+cGet16+"' AND '"+cGet17+"' "
      endif

      if !empty(cGet18)
        cQuery += " AND E1_LOJA BETWEEN '"+cGet18+"' AND '"+cGet19+"' "
      endif 

      cQuery += " AND E1_FILIAL = '"+xFilial("SE1")+"' " 

      cQuery += "ORDER BY E1_FILIAL, E1_PREFIXO, E1_NUM"

      MemoWrite("C:\TEMP\cQuery.txt",cQuery)

			If select("TMP") <> 0 
			   TMP->(DbcloseArea())
			Endif
			dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"TMP",.T.,.T.) 

      If TMP->(eof())

        MsgAlert("Não há registros pare serem exibidos, por favor verifique os parametros.","Atenção !!!")

      EndIf

	TMP->(DbGoTop())
      aNewCols := {}
	while !TMP->(eof())
        aadd(aNewCols,{"LBNO",TMP->E1_FILIAL,TMP->E1_PREFIXO,TMP->E1_NUM,TMP->E1_PARCELA,TMP->E1_TIPO,TMP->E1_CLIENTE,TMP->E1_LOJA,TMP->A1_NOME,StoD(TMP->E1_EMISSAO),StoD(TMP->E1_VENCREA),TMP->E1_VALOR,TMP->E1_SALDO,TMP->E1_SALDO,TMP->E1_HIST, .F.})
        TMP->(dbskip())
    enddo 	

    oMSNewGe1:aCols := {}
    if len(aNewCols) > 0 
      oMSNewGe1:aCols := aNewCols
      oMSNewGe1:nAt   := 1
      oMSNewGe1:Refresh()	
    endif 
    nValorSaldo := 0
    FreeObj(oPeso)
    @ 290, 020 SAY oPeso PROMPT "Valor R$ " +allTrim(Transform(nValorSaldo, "@E 9,999,999,999,999.99")) SIZE 150, 013 OF oDlg FONT oFont1 COLORS CLR_RED, 16777215 PIXEL

return 


static Function CLIQUE()

	if oMSNewGe1:ACOLS[oMSNewGe1:NAT][1] == "LBOK"
		oMSNewGe1:ACOLS[oMSNewGe1:NAT][1] := "LBNO"
	else
		oMSNewGe1:ACOLS[oMSNewGe1:NAT][1] := "LBOK"
	endif 
  u_RFINALOK()
  FreeObj(oPeso) 
   @ 290, 020 SAY oPeso PROMPT "Valor R$ " + allTrim(Transform(nValorSaldo, "@E 9,999,999,999,999.99")) SIZE 150, 013 OF oDlg FONT oFont1 COLORS CLR_RED, 16777215 PIXEL

  oMSNewGe1:REFRESH()

return

//------------------------------------------------ 
Static Function fMSNewGe1()
//------------------------------------------------ 
Local nX
Private aHeaderEx := {}
Private aColsEx := {}
Private aFieldFill := {}
Private aFields := {"_OK","E1_FILIAL","E1_PREFIXO","E1_NUM","E1_PARCELA","E1_TIPO","E1_CLIENTE","E1_LOJA","A1_NREDUZ","E1_EMISSAO","E1_VENCREA","E1_VALOR","E1_SALDO","E1_XVALORP","E1_HIST"}
Private aAlterFields := {"E1_XVALORP"}
Static oMSNewGe1

  // Define field properties
  DbSelectArea("SX3")
	SX3->(DbSetOrder(2))
	For nX := 1 to Len(aFields)
		If SX3->(DbSeek(aFields[nX]))
			Aadd(aHeaderEx, {AllTrim(X3Titulo()),SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VALID,;
			SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_F3,SX3->X3_CONTEXT,SX3->X3_CBOX,SX3->X3_RELACAO})
		else
			SX3->(DbSeek("_OK"))
			Aadd(aHeaderEx, {"Selec.","OK","@BMP",SX3->X3_TAMANHO,SX3->X3_DECIMAL,"AllwaysTrue()",;
			SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_F3,SX3->X3_CONTEXT,SX3->X3_CBOX,SX3->X3_RELACAO})
		Endif
	Next nX

  // Define field values
  For nX := 1 to Len(aFields)

    SX3->(DbGoTop())

    If SX3->(DbSeek(aFields[nX]))
     
      //Aadd(aFieldFill, CriaVar(SX3->X3_CAMPO))
      Aadd(aFieldFill, Space(TamSX3(aFields[nX])[1]))
    
    Else 

      Aadd(aFieldFill, Space(2))
    
    Endif
  
  Next nX

  Aadd(aFieldFill, .F.)
  Aadd(aColsEx, aFieldFill)

  _cLineOk  := "U_RFINALOK(.F.)"

  //Alert(aSize[3]-230) == 531

  oMSNewGe1 := MsNewGetDados():New( 040+nLin, 006, 245, 531, GD_UPDATE,_cLineOk, "AllwaysTrue", "+Field1+Field2", aAlterFields,, 999, "U_RFINALOK(.T.)", "AllwaysTrue", "AllwaysTrue", oDlg, aHeaderEx, aColsEx) 

  oMSNewGe1:oBrowse:bLDblClick := {|| Iif(oMSNewGe1:oBrowse:nColPos == 1 ,(CLIQUE(),oMSNewGe1:oBrowse:Refresh()),oMSNewGe1:EditCell()) } 


Return

user function RFINALOK(lDigita)
  local nX := 1 
  nValorSaldo := 0 

  If Empty(oMSNewGe1:ACOLS[nX][4])

    MsgAlert("Não existem títulos para serem selecionados, por favor revise seus filtros.")

    Return .T.

  EndIf

  for nX := 1 to len(oMSNewGe1:ACOLS)
    if lDigita
       if oMSNewGe1:ACOLS[nX][1] == "LBOK" .and. n <> NX
        nValorSaldo += oMSNewGe1:ACOLS[nX][14]
       endif 
    else
        if oMSNewGe1:ACOLS[nX][1] == "LBOK"
        nValorSaldo += oMSNewGe1:ACOLS[nX][14]
       endif
    endif 
  next nX
  if lDigita
    if oMSNewGe1:ACOLS[n][1] == "LBOK"
      nValorSaldo += M->E1_XVALORP
    endif 
  endif  
  FreeObj(oPeso) 
  @ 290, 020 SAY oPeso PROMPT "Valor R$ " + allTrim(Transform(nValorSaldo, "@E 9,999,999,999,999.99")) SIZE 150, 013 OF oDlg FONT oFont1 COLORS CLR_RED, 16777215 PIXEL

return .T. 
