#include "protheus.ch"
#include "topconn.ch"

/*-------------------------------------------------------------------
- Programa: AtuGrp
- Autor: Claudio Ferreira
- Data: 20/01/2021
- Descrição: Rotina para atualizar o Grupo de Produtos
-------------------------------------------------------------------*/

User Function AtuGrp(cGrp)

Local aArea     := GetArea()



//dbSelectArea("SB1")
//	dbSetOrder(1)
//	MsSeek(xFilial("SB1")+cCodProd)                  //Posiciona no Produto
	

	IF SB1->B1_GRTRIB  <> cGrp
	
		RecLock("SB1",.F.)
		SB1->B1_GRTRIB := cGrp                   // Grava Grp no Produto
		MsUnlock()
		
	Endif


RestArea( aArea )

Return .t.

