#INCLUDE "Protheus.ch"
#INCLUDE "Totvs.ch"
#INCLUDE "topconn.ch"

/*/{Protheus.doc} COBWHATS
// Verifica boletos pr�ximo do vencimento.
@author
/*/

User Function COBWHATS()

    Local cCob := "1"

    //Chama fonte do boleto passando par�metros do titulo/cliente
    u_BMFIN02(cCob)

return
