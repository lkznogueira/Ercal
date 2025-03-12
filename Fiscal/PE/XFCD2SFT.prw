#include "rwmake.ch"
#INCLUDE "topconn.ch"

/*
__________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦Programa  ¦ XFCD2SFT  ¦ Utilizador ¦ Claudio Ferreira ¦ Data ¦ 07/05/15¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Descriçào ¦ Ponto de Entrada na gravação da SFT                        ¦¦¦
¦¦¦          ¦                                                            ¦¦¦
¦¦¦          ¦ 															  ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦ Uso      ¦ Ercal - Tratamento Convenio 100/97                         ¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
*/

User Function XFCD2SFT
Local lSaida:=CD2->CD2_TPMOV='S'
Local lEntrada:=CD2->CD2_TPMOV='E'

//Tratamento para certificar o posicionamento SD1->SFT  // SD2->SFT
if lEntrada .and. !SD1->(D1_DOC+D1_SERIE+D1_ITEM)=SFT->(FT_NFISCAL+FT_SERIE+FT_ITEM)
	Return
endif
if lSaida .and. !SD2->(D2_DOC+D2_SERIE+Padr(D2_ITEM,4))=SFT->(FT_NFISCAL+FT_SERIE+FT_ITEM)
	Return
endif

if lSaida .and. substr(SD2->D2_CF,1,4)$'6101/6116'
	//Acerta por Item
	SFT->(RecLock("SFT",.F.))
	SFT->FT_ISENICM-=SFT->FT_DESCONT
	SFT->(MsUnlock())
	
	//Acerta no Livro
	dbSelectArea("SF3")
	dbSetOrder(5)
	if dbSeek(xFilial('SF3')+SFT->(FT_SERIE+FT_NFISCAL+FT_CLIEFOR+FT_LOJA+FT_IDENTF3))
		SF3->(RecLock("SF3",.F.))
		SF3->F3_ISENICM-=SFT->FT_DESCONT
		SF3->(MsUnlock())
	endif
endif

Return

User Function MATR930A
Local aColObs:=ParaMixb[1]
Local nTamObs:=41
Local xx
if len(aColObs)>1
	nPosObs:=Ascan(aColObs,{|x|x[1]='ICMS FRET.AUT'})
	if nPosObs>0
		cMensagem:=U_GetMsgFre((cArqTemp)->F3_NFISCAL,(cArqTemp)->F3_SERIE)
		For xx:=1 to MlCount(cMensagem,nTamObs)
			AADD(aColObs,{MemoLine(cMensagem,nTamObs,xx),.T.})
		Next xx
	endif
endif
Return aColObs                    


