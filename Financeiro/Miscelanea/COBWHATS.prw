#INCLUDE "Protheus.ch"
#INCLUDE "Totvs.ch"
#INCLUDE "topconn.ch"

/*/{Protheus.doc} COBWHATS
// Verifica boletos próximo do vencimento.
@author
/*/

User Function COBWHATS()

    Local cCob := "1"

    //Chama fonte do boleto passando parâmetros do titulo/cliente
    u_BMFIN02(cCob)

return
