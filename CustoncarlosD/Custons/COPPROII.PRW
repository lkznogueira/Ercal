#include "rwmake.ch"  
#include "topconn.ch"  

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCOPPROII  บAutor  ณCarlos Daniel       บ Data ณ  09/10/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ       Gera cod. sequencial automaticamente                 บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/


User Function COPPROII()
                             
Local _cCodPro := ""
Local _cArea := GetArea()
Local _cQuery := ""        

_cQuery := " SELECT MAX(B1_COD) AS CODIGO "
_cQuery += " FROM " + RetSqlName("SB1")
_cQuery += " WHERE D_E_L_E_T_ <> '*'"
_cQuery += " AND NOT REGEXP_LIKE(B1_COD, '[A-Z]', 'i')"


TcQuery _cQuery New Alias "TRB"
dbSelectArea("TRB")
dbGoTop()               
_cCodPro :=  Strzero(Val(Right(Alltrim(TRB->CODIGO),6))+1,6)                  
//dbSelectArea("TRB")
dbCloseArea("TRB")

While !MayIUseCode("B1_COD"+xFilial("SB1")+_cCodPro)
	_cCodPro := Soma1(_cCodPro)
EndDo             

RestArea(_cArea)

Return(_cCodPro)   

//RHCODII

User Function RHCODII()
                             
Local _cCodRH := ""
Local _cArea := GetArea()
Local _cQuery := "" 
Local cFil := FWCodFil()       

_cQuery := " SELECT MAX(RA_MAT) AS CODIGO "
_cQuery += " FROM " + RetSqlName("SRA")
_cQuery += " WHERE D_E_L_E_T_ <> '*'"   
_cQuery += " AND RA_FILIAL = '"+cFil+"'
_cQuery += " AND NOT REGEXP_LIKE(RA_MAT, '[A-Z]', 'i')"

TcQuery _cQuery New Alias "TRB"
dbSelectArea("TRB")
dbGoTop()               
_cCodRH :=  Strzero(Val(Right(Alltrim(TRB->CODIGO),6))+1,6)                  
//dbSelectArea("TRB")
dbCloseArea("TRB")

While !MayIUseCode("RA_MAT"+xFilial("SRA")+_cCodRH)
	_cCodRH := Soma1(_cCodRH)
EndDo             

RestArea(_cArea)

Return(_cCodRH)     

//Ativo fixo sequencia
User Function cOdAtv()
                             
Local _cCodatv := ""
Local _cArea := GetArea()
Local _cQuery := ""        

_cQuery := " SELECT MAX(N1_CBASE) AS CODIGO "
_cQuery += " FROM " + RetSqlName("SN1")
_cQuery += " WHERE D_E_L_E_T_ <> '*'"
_cQuery += " AND NOT REGEXP_LIKE(N1_CBASE, '[A-Z]', 'i')"


TcQuery _cQuery New Alias "TRB"
dbSelectArea("TRB")
dbGoTop()               
_cCodatv :=  Strzero(Val(Right(Alltrim(TRB->CODIGO),10))+1,10)                  
//dbSelectArea("TRB")
dbCloseArea("TRB")

While !MayIUseCode("N1_CBASE"+xFilial("SN1")+_cCodatv)
	_cCodatv := Soma1(_cCodatv)
EndDo             

RestArea(_cArea)

Return(_cCodatv)  