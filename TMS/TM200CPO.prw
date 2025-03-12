#Include "Protheus.ch"

/*/-------------------------------------------------------------------
-�Programa: TM200PW01
-�Autor: Tarcisio Silva Miranda
-�Data:�20/04/2021
-�Descri��o:�Ponto de Entrada que permite manipula��o dos aHeader do
preview antes da visualiza��o do frete na tela, complemento do ponto 
de entrada TM200PW01.
-------------------------------------------------------------------/*/

User Function TM200CPO()

	Local aAux 	:= aClone(PARAMIXB[2])
	Local aRet 	:= {}
	Local nx 	:= 1

	if PARAMIXB[1] != 2

		for nX := 1 to len(aAux)

			if aAux[nX][3] == "04"

				aAdd( aRet , aAux[nX] )
				aAdd( aRet , { "DT6_XVLTAR" , "aPvw[nPosPvw,13,01,31]"   , "04X"  })

			else

				aAdd( aRet , aAux[nX] )

			endif

		next nX

	else

		aRet := aClone(PARAMIXB[2])

	endif

Return(aRet)
