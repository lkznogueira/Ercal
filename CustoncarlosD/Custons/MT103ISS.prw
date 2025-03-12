#Include "PROTHEUS.CH"
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMT103ISS     บ Autor ณ Carlos Daniel   บ Data ณ  14/04/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ altera dados titulo iss na entrada                         บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Ercal			                                          บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
User Function MT103ISS

//aRet(vetor)
//aRet[1] = Novo c๓digo do fornecedor de ISS.
//aRet[2] = Nova loja do fornecedor de ISS.
//aRet[3] = Novo indicador de gera dirf.
//aRet[4] = Novo c๓digo de reten็ใo do tํtulo de ISS.
//aRet[5] = Nova data de vencimento do tํtulo de ISS.

Local cFornIss  := PARAMIXB[1]      // C๓digo do fornecedor de ISS atual para grava็ใo.
Local cLojaIss  := PARAMIXB[2]      // Loja do fornecedor de ISS atual para grava็ใo.
Local cDirf     := PARAMIXB[3]      // Indicador de gera dirf atual para grava็ใo.
Local cCodRet   := PARAMIXB[4]      // C๓digo de reten็ใo do tํtulo de ISS atual para grava็ใo.
Local dVcIss    := PARAMIXB[5]      // Data de vencimento do tํtulo de ISS atual para grava็ใo.
Local aRet      := {}   
Local xTemp

//xTemp := dDataBase 
xTemp := Dtoc( dDataBase )
xTemp := MonthSum( Ctod( '20/' + SubStr( xTemp, 04, 02 ) + '/' + SubStr( xTemp, 07, 04 ) ), 1 ) 
//dVcIss := ''
aAdd( aRet , '000764') //Cod Forn ISS
aAdd( aRet , '01')     //Cod Loja Forn ISS
aAdd( aRet , '2')      //Gera Dirf ? - 1=Sim, 2=Nao
aAdd( aRet , '9999')   //Codigo de Receita
aAdd( aRet , xTemp)   //Vencimento ISS      

Return (aRet)