#INCLUDE "protheus.ch"

/*
_____________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦Funçào    ¦ MT410INC ¦ Autor ¦ Pedro Paulo Aires   ¦ Data ¦ 08/10/2012 ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Descriçào ¦ Soma a quantidade de volumes e grava no SC5.               ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦ Uso      ¦**********                                                  ¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯     
*/

USER FUNCTION MT410INC()
Local _aArea   := getArea()
Local _nVol    := 0
Local _nPesoL  := 0
Local _nPesoB  := 0
Local _cFilPed := SC5->C5_FILIAL+SC5->C5_NUM
 /*
    DbSelectArea("SC6")
    SC6->(DbSetOrder(1))
    SB1->(DbSetOrder(1))
    SC6->(DbSeek(_cFilPed))
	WHILE !SC6->(EOF()) .And. (alltrim(SC6->C6_FILIAL+SC6->C6_NUM) == _cFilPed)
		SB1->(dbseek(xFilial()+SC6->C6_PRODUTO))
		_nVol   += Round((SC6->C6_QTDVEN*SB1->B1_PESO)/SB1->B1_CONV ,0)//Soma volume por caixa 
		_nPesoB += SC6->C6_QTDVEN*SB1->B1_PESBRU //soma o peso bruto total
		_nPesoL += SC6->C6_QTDVEN*SB1->B1_PESO //soma o peso liquido total   
	SC6->(DbSkip())
	END

	DbSelectArea("SC5")
	SC5->(DbSetOrder(1))
	SC5->(DbSeek(_cFilPed))
	IF RecLock("SC5",.F.)
		SC5->C5_VOLUME1 := MAX(1,_nVol)
	  	SC5->C5_PBRUTO  := _nPesoB
	    SC5->C5_PESOL   := _nPesoL
	MsUnlock()
	ENDIF
         */
RestArea(_aArea)        
RETURN
