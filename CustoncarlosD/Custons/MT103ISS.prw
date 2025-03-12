#Include "PROTHEUS.CH"
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MT103ISS     � Autor � Carlos Daniel   � Data �  14/04/15   ���
�������������������������������������������������������������������������͹��
���Descricao � altera dados titulo iss na entrada                         ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Ercal			                                          ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function MT103ISS

//aRet(vetor)
//aRet[1] = Novo c�digo do fornecedor de ISS.
//aRet[2] = Nova loja do fornecedor de ISS.
//aRet[3] = Novo indicador de gera dirf.
//aRet[4] = Novo c�digo de reten��o do t�tulo de ISS.
//aRet[5] = Nova data de vencimento do t�tulo de ISS.

Local cFornIss  := PARAMIXB[1]      // C�digo do fornecedor de ISS atual para grava��o.
Local cLojaIss  := PARAMIXB[2]      // Loja do fornecedor de ISS atual para grava��o.
Local cDirf     := PARAMIXB[3]      // Indicador de gera dirf atual para grava��o.
Local cCodRet   := PARAMIXB[4]      // C�digo de reten��o do t�tulo de ISS atual para grava��o.
Local dVcIss    := PARAMIXB[5]      // Data de vencimento do t�tulo de ISS atual para grava��o.
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