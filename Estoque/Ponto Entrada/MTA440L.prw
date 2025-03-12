#include "rwmake.ch"
/*
_____________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦Programa  ¦ MTA440L   ¦ Autor ¦ Claudio              ¦ Data ¦ 25/07/17 ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Descriçào ¦ Ponto de Entrada p/  tratar estoque no fechamento do pedido¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦ Uso      ¦ Indica se bloqueia ou nao o pedido por falta de estoque    ¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
*/

// MV_XBLQSTQ
// .T. = Padrão (Bloqueia por falta de estoque)
// .F. = Não Bloqueia por falta de estoque (Default)
User Function MTA440L()
Local lBlqEst := SuperGetMv("MV_XBLQSTQ", .F., .F.)
Local cTipo:=Posicione("SB1",1,xFilial("SB1")+SC6->C6_PRODUTO,"B1_TIPO") 
if !cTipo$'PA/'  // Se nao for acabado verifica o estoque
  return 0
endif
return(iif(!lBlqEst,-999999999,0))

/*