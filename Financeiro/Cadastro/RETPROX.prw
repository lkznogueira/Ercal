#include "rwmake.ch"
#include "topconn.ch"
#include "protheus.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRETPROX   บAutor  ณDaniel Coelho       บ Data ณ  05/12/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Funcao para retornar o proximo numero disponivel para      บฑฑ
ฑฑบ          ณ inclusao de clientes/fornecedores                          บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณu_RTPROX('SA1',)  Corrigido por Carlos Daniel 			  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function RTPROX(cAlias,cPesq,cCampo,nTam,cTp)
Local cArea:= Alias()
Local cQuery:=''
Local _cQuery := "" 
Local cFil
Local QAux,nSeq,TRB
Local cRetLoja:=''
Local cRetorno:=''   
Local cProx   := ''
Default nTam=TamSx3(cCampo)[1]  

Private lRet:=empty(cRetorno)   
    
cFil:= Right(cAlias,2)+'_FILIAL'                                                 

cPesq:=If(cTp='J',Left(cPesq,8),cPesq)

cQuery := "SELECT MAX("+cCampo+") as NSEQ FROM "+RetSqlName(cAlias)+" WHERE "
cQuery += "D_E_L_E_T_<>'*'" 
cQuery += " AND NOT REGEXP_LIKE("+Right(cAlias,2)+"_COD, '[A-Z]', 'i')"
     
If cTp = 'J'
   cQuery += " AND "+Right(cAlias,2)+"_CGC Like '"+cPesq+"%'" 
Else
	cQuery += " AND "+Right(cAlias,2)+"_CGC = '"+cPesq+"'"
EndIf   
   
cQuery += " AND "+cFil+" = '"+xfilial(cAlias)+"' "     

cQuery:=Changequery(cQuery)
TCQUERY cQuery NEW ALIAS "QAux"

if Empty(QAux->NSEQ)    // Nao achou o CPF/CNPJ
	
	If nTam <> 2
	_cQuery := "SELECT MAX("+cCampo+") as CODIGO FROM "+RetSqlName(cAlias)+" WHERE "
	_cQuery += "D_E_L_E_T_<>'*'" 
	_cQuery += " AND NOT REGEXP_LIKE("+Right(cAlias,2)+"_COD, '[A-Z]', 'i')"

	TcQuery _cQuery New Alias "TRB"
	dbSelectArea("TRB")
	dbGoTop()               
	cProx :=  Strzero(Val(Right(Alltrim(TRB->CODIGO),6))+1,6)                  
	//dbSelectArea("TRB")
	dbCloseArea("TRB")

	While !MayIUseCode(Right(cAlias,2)+"_COD"+xFilial(cAlias)+cProx)
  		cProx := Soma1(cProx)
	EndDo             
    	   //cProx := //GETSXENUM(cAlias,cCampo)  //SEQUENCIAL
 	   	cRetorno:=cProx   	          
  	 Else
  	   	cRetorno:=Strzero(1,nTam)   	   
  	 EndIf
  
else      // Achou o CPF/CNPJ
   If nTam = 2      
      cRetorno:=Soma1(QAux->NSEQ)
   Else
      cRetorno:=QAux->NSEQ
   EndIf   
endif

QAux->(dbCloseArea())
    
dbselectarea(cArea)    
Return iif(!lRet,.t.,cRetorno)
