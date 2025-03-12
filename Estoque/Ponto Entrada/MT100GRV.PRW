#include "rwmake.ch"

/*
_____________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦Programa  ¦ MT100GRV¦ Autor ¦ Matheus Ferreira       ¦ Data ¦ 02/09/10 ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Descriçào ¦ Ponto de Entrada para complementar os dados da NF          ¦¦¦
¦¦¦          ¦                                                            ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦ Uso      ¦                                                            ¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
*/


User Function MT100GRV()

Local cf
Local cNCM 		:= ""
Local cCodProd 	:= ""
Local cCodNCM 	:= ""
Local nPosProd 	:= 0
Local nPosNCM 	:= 0     
Local lExclui	:= Paramixb[1]

If lExclui
	Return
Endif

For cf:=1 to Len(aCols)
	nPosProd     	:= aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="D1_COD" })		 			//Produto
	cCodProd     	:= aCols[cf][nPosProd]
	nPosNCM     	:= aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="D1_XPOSPI" })		 			//NCM
	cCodNCM     	:= aCols[cf][nPosNCM]
	
	dbSelectArea("SB1")
	dbSetOrder(1)
	MsSeek(xFilial("SB1")+cCodProd)                  //Posiciona no Produto
	

	IF empty(SB1->B1_POSIPI) .OR.  SB1->B1_POSIPI='99'  .OR. AllTrim(cCodNCM)<>AllTrim(SB1->B1_POSIPI)               // Verifica se o Campo NCM esta Vazio  OU 99
		cNCM := cCodNCM
		IF cNCM <> ' '
			RecLock("SB1",.F.)
			SB1->B1_POSIPI := cNCM                   // Grava NCM no Produto verificar
			MsUnlock()
		EndIf
		
	Endif
		
	
next

Return


/*
Static Function ValidNCM()

Local cCodProd := ""
Local cCodNCM  := ""

dbSelectArea("SB1")
dbSetOrder(1)
MsSeek(xFilial("SB1")+M->D1_COD)

IF M->D1_X_POSPI <> SB1->B1_POSIPI
IF msgYesNo("NCM do Produto já está Cadastrado, Deseja Altera-ló? ")
cCodNCM := M->D1_X_POSPI
Endif
Endif

Return
*/
