#include "rwmake.ch"
#INCLUDE "topconn.ch"

/*
__________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦Programa  ¦ SPDPINFO  ¦ Utilizador ¦ Claudio Ferreira ¦ Data ¦ 25/06/15¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Descriçào ¦ Ponto de Entrada na geração do C195  EFD-Fiscal            ¦¦¦
¦¦¦          ¦                                                            ¦¦¦
¦¦¦          ¦ 															  ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦ Uso      ¦ Ercal - Tratamento DECRETO Nº 46.591                       ¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
*/

User Function SPDPINFO()
Local	cDoc		:=	PARAMIXB[1] //FT_NFISCAL
Local	cSerie		:=	PARAMIXB[2] //FT_SERIE
Local	cFornec		:=	PARAMIXB[3] //FT_CLIEFOR
Local	cLoja		:=	PARAMIXB[4] //FT_LOJA
Local	dEntr		:=	PARAMIXB[5] //FT_ENTRADA
Local	cEntSai		:=	PARAMIXB[6] //Entr/Saida	 	
Local	cChave		:=	""
Local	nX			:=	0
Local	aRetorno	:=	{}
Local	aAreaSFT	:=	SFT->(GetArea())
If cEntSai == "1"	
  cChave	:=	xFilial("SFT")+"E"+DTOS(dEntr)+cSerie+cDoc+cFornec+cLoja
Else	
  cChave	:=	xFilial("SFT")+"S"+DTOS(dEntr)+cSerie+cDoc+cFornec+cLoja
Endif	
If SFT->(DbSeek(cChave))
    If SFT->FT_ICMAUTO>0
	  cMensFis:='Icms Frete Remetente/Alienante. '+Alltrim(Transform(SFT->FT_ICMAUTO,"@e 999,999,999.99"))
	  cMensFis+=' '+U_GetMsgFre(cDoc,cSerie)
      aAdd(aRetorno,{   RIGHT(cDoc, 6) /*'000002'*/,;				//02 - COD_INF			 		
      cMensFis})		//03 - TXT_COMPL		
    endif  
Endif
RestArea(aAreaSFT)
Return aRetorno  


User Function GetMsgFre(cNotaFis,cSerie)
Local cMensagem:=''
//Localiza PV
dbSelectArea("SD2")
dbSetOrder(3)
if dbSeek(xFilial("SD2")+cNotaFis+cSerie)
	dbSelectArea("SC5")
	dbSetOrder(1)
	if dbSeek(xFilial("SC5")+SD2->D2_PEDIDO) .and. SC5->C5_FRETAUT>0
		cMensagem+='Vlr Frete: '+Alltrim(Transform(SC5->C5_FRETAUT/0.8,"@e 999,999,999.99"))
		cMensagem+=' Base Calc: '+Alltrim(Transform(SC5->C5_FRETAUT,"@e 999,999,999.99"))+' Aliq.: '+Alltrim(Transform(SD2->D2_PICM,"@e 99"))+'%'
		cCPFCNPJ:=Posicione("SA4",1,xFilial("SA4")+SC5->C5_TRANSP,"A4_CGC")
		if Len(Alltrim(cCPFCNPJ))==11
			cMensagem+=' CPF:'+Alltrim(Transform(cCPFCNPJ,"@R 999.999.999-99"))
		else
			cMensagem+=' CNPJ:'+Alltrim(Transform(cCPFCNPJ,"@R 99.999.999/999-99"))
		endif
	endif
endif
Return cMensagem
