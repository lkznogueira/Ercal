#include "rwmake.ch"
#include"protheus.ch"
/*
_____________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦Programa  ¦ unifret   ¦ Autor ¦ Carlos Daniel        ¦ Data ¦ 03/11/21 ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Descriçào ¦ Ponto de Entrada p/tratar calculo frete sobre tipo vend. 70¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦ Uso      ¦ Uso Para Ercal empresas Reunidas Calcario                  ¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
*/


User Function unifret()

	//Local cTipo  := M->adb_XTIPO
	Local nFrede := M->ada_xdesp
	Local vFrede
	Local nFrete := M->ada_xfrete
	Local vFrete
	Local nlCodPos := aScan(aHeader,{|x| Trim(x[2])=="ADB_QUANT"} )
	Local nQuant := ACOLS[N][nlCodPos]
	Local vPunit := 0
	

	if nfrede <> 0 // verifica se for tipo 70 e tiver despesa de frete
		vFrede := (nFrede/nQuant)
		M->ada_xdespu := vFrede
		MSGALERT( "VALOR UNITARIO DE DESPESA TRANSPORTE PREENCHIDO", "DESPESA SIMBOLICA" )
	ElseIf nFrete <> 0
		vFrete := (nFrete/nQuant)
		//M->ada_xfret := vFrete //campo unitanio de frete
		M->ada_xdespu := vFrete //campo unitanio de frete
		MSGALERT( "VALOR UNITARIO DE FRETE PREENCHIDO", "FRETE DESTACADO NF" )
	ELSE
		//M->ada_TABELA = ' '
        GetDRefresh()
		return(vPunit)
	endif
	//M->ada_TABELA = '   '
	GetDRefresh()
return (vPunit)
