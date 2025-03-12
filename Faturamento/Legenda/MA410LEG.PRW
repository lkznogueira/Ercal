USER FUNCTION MA410LEG

aCores := {{"ENABLE","Pedido em aberto"},;      //Pedido em aberto
{"DISABLE","Pedido encerrado"},;    //Pedido encerrado
{"BR_AMARELO","Apto a Faturar"}}

Aadd(aCores,{"BR_BRANCO","Pedido Bloquedo por Crédito"})
Aadd(aCores,{"BR_PRETO","Pedido Bloquedo por Estoque"})  //Pedido Liberado


Aadd(aCores,{"BR_AZUL","Pedido Bloquedo por regra"})
Aadd(aCores,{"BR_LARANJA","Pedido Bloquedo por verba"})  //Pedido Liberado






RETURN(aCores)