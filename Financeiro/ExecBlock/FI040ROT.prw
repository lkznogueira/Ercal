#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'TOTVS.CH'

/*/{Protheus.doc} FI040ROT
//TODO 
@author Raphael Ferreira
@since  
/*/
User Function FI040ROT()

	Local aBotoes:= aClone( PARAMIXB )

	aAdd( aBotoes ,	{ "Imprime Boleto"		,"U_BMFIN01()"	, 0 , 6})
	aAdd( aBotoes ,	{ "HIST COBRANÇA"		,"U_HISTCLI()"	, 0 , 6})

Return(aBotoes)
