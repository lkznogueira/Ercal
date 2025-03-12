#include "protheus.ch"
#include "rwmake.ch"
#include "topconn.ch"
#include "report.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRFIN002   บAutora  ณFrancielly Castro  บ Data ณ  18/07/08   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRelacao de movimentacao por motivo de baixa                 บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ SIGAFIN - CIF                                              บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/


User Function RFIN003()
**********************
Local cDesc1      := "Relacao de movimentacao a Transferir"
Local cDesc2      := ""
Local cDesc3      := "" 
Local aRegs       := {} 
Local j , i

Private lAbortPrint := .F.
Private li		    := 120
Private M_PAG       := 1
Private cTamanho    := "P" //TAMANHO DO RELATORIO: P=ATE 80 COLUNAS  M=ATE 132 COLUNAS G=ATE 252 COLUNAS
Private cString     := "SE5"
Private cTitulo     := "Relacao de movimentacao a Transferir"
Private aOrdem      := {}
Private cPerg       := "RFIN003"
Private Wnrel       := "RFIN003"
Private nLastKey    := 0
Private oSE5A
Private aReturn     := {OemToAnsi("Zebrado"),1,OemToAnsi("Administracao"),2,2,1,"",1}


aRegs:={}                                                        //G=Edit S=Texto C=Combo el siguiente parametro es para el Valid 
aAdd(aRegs,{cPerg,"01","Carteira   ","Carteira  ","Carteira ","MV_CH1","C",1,0,0,"G","","MV_PAR01","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"02","Do Motivo  ","Do Motivo ","Do Motivo","MV_CH2","C",3,0,0,"G","","MV_PAR02","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"03","Ate Motivo ","Ate Motivo","AteMotivo","MV_CH3","C",3,0,0,"G","","MV_PAR03","","","","","","","","","","","","","","","","","","","","","","","","",""})

For i:=1 to Len(aRegs)
    SELE SX1
    If !dbSeek(cPerg+aRegs[i,2])
        RecLock("SX1",.T.)
        For j:=1 to FCount()
            If j <= Len(aRegs[i])
                FieldPut(j,aRegs[i,j])
            Endif
        Next
        MsUnlock()
    Endif
Next

Pergunte(cPerg,.F.)
  
Wnrel := SetPrint(cString,Wnrel,cPerg,cTitulo,cDesc1,cDesc2,cDesc3,.F.,aOrdem,,cTamanho,,)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
	Return
Endif

RptStatus({|lEnd| RFIN003IMP()}) 

Return

STATIC Function RFIN003IMP()
***************************
Local cCabec1     := "Data        Cli/For   Prefixo Numero     Parcela Tipo Banco Agencia Conta      Valor          Historico"
Local cCabec2     := ""
Local cnomeprog   := "RFIN003"
Local cArqIndex, I
Local nTvalor:= 0.00
Local cOrdem

//DATA        CLI/FOR   PREFIXO NUMERO     PARCELA TIPO BANCO AGENCIA CONTA      VALOR          HISTORICO
//99/99/99    999999    XXX     XXXXXXXXX  XX      XX   XXX   XXX     XXXXXXXXX  999999999.99   XXXXXXXXXXXXXXXXXXXXX

Private nOrdem 	:= 0

li := 80

c2Query  := "SELECT E5_FILIAL,E5_RECPAG,E5_MOTBX, E5_DATA, E5_CLIFOR, E5_TIPO, E5_PREFIXO, E5_NUMERO, E5_PARCELA, E5.E5_BANCO, E5.E5_AGENCIA,E5_CONTA, E5_HISTOR "
c2Query  += "FROM "+RetSQLname("SE5")+" SE5, "
c2Query  += " WHERE    E5_FILIAL = '"+ xFilial("SE5") + "' "
c2Query  += " AND      E5_RECPAG = '"+ mv_par01+ "' "
c2Query  += " AND      E5_MOTBX BETWEEN '"+ mv_par02 + "' AND '"+ mv_par03 + "' "
c2Query  += " AND      SE5.D_E_L_E_T_ = ' ' "
c2Query  += " GROUP BY SE5.E5_MOTBX "
c2Query  := ChangeQuery(c2Query)

dBUseArea(.T.,"TOPCONN",TCGENQRY(,,c2Query),"TRB",.F.,.T.)

dbselectarea("TRB")
dbgotop()

SetRegua(reccount())     

WHILE !Eof()
  
      Incproc()

      nLastKey := Inkey()
      
      IF lEnd
         @PROW()+1,001 PSAY "Operacion Cancelada por el Operador"
         Exit
      EndIf 
	  
      If li >= 58
         cabec(cTitulo,cCabec1,cCabec2,cNomeprog,cTamanho)
         li++
         li++
      End

      @ li,002	PSAY TRB->E5_DATA
      @ li,012	PSAY TRB->E5_CLIFOR
      @ li,022	PSAY TRB->E5_PREFIXO
      @ li,032	PSAY TRB->E5_NUMERO
      @ li,043	PSAY TRB->E5_PARCELA
      @ li,052	PSAY TRB->E5_TIPO
      @ li,058	PSAY TRB->E5_BANCO 
      @ li,065	PSAY TRB->E5_AGENCIA  	
      @ li,074	PSAY TRB->E5_CONTA
      @ li,085	PSAY TRB->E5_VALOR    PICTURE "@E 999999999.99"     
      @ li,100	PSAY TRB->E5_HISTOR

    nTvalor:= nTvalor+TRB->E5_VALOR
      
      li++
     
      dbSkip()
end

li++
@ li,085	PSAY nTvalor          PICTURE "@E 999999999.99"

Set Device To Screen
Set Filter To

TRB->(dbCloseArea())

If aReturn[5] == 1
   Set Printer TO
   dbCommitAll()
   ourspool(wnrel)
Endif

MS_FLUSH()

Return