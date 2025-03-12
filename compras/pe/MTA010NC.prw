#include "protheus.ch"
#include "topconn.ch"

/*-------------------------------------------------------------------
- Programa: MTA010NC
- Autor: Wellington Gonçalves
- Data: 07/04/2020
- Descrição: Ponto de Entrada executado na cópia do produto, para
  limpar campos que não devem ser copiados
-------------------------------------------------------------------*/

User Function MTA010NC()

Local aCpoNC := {}

aadd(aCpoNC, 'B1_GRTRIB')
aadd(aCpoNC, 'B1_MSBLQL')
aadd(aCpoNC, 'B1_TIPO')
aadd(aCpoNC, 'B1_POSIPI')

Return (aCpoNC)