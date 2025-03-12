#include "protheus.ch"

USER Function SalvaAmbiente(mArea)
Local x := 0
Local mAlias := {}
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Salvando ambiente antes de executar a funcao do usuario que altera ponteiro de tabelas
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Aadd(mAlias,{Alias(),IndexOrd(),Recno()})

For x := 1 to Len(mArea)
	DbSelectArea(mArea[x])
	AaDd(mAlias,{Alias(),IndexOrd(),Recno()})
next x

Return (mAlias)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Restaurando o ambiente apos a execucao da funcao de usuario que altera ponteiros de tabelas
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
USER Function VoltaAmbiente(mAlias)
Local x := 0

For x:= 1 to Len(mAlias)
	DbSelectArea(mAlias[x,1])
	DbSetOrder(mAlias[x,2])
	DbGoto(mAlias[x,3])    
Next x

DbSelectArea(mAlias[1,1])
DbSetOrder(mAlias[1,2])
DbGoto(mAlias[1,3])

Return NIL