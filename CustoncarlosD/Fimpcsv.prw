#include "totvs.ch"
#include "protheus.ch"
#include "TOPCONN.CH"
//importação cadastro Transportadora
//Carlos Daniel - 21/06/2024
User Function ImpCsv() 
Local cDiret
Local cLinha  := ""
Local lPrimlin   := .T.
Local aCampos := {}
Local aDados  := {}
Local i
Local j 
Private aErro := {}
 
cDiret :=  cGetFile( 'Arquito CSV|*.csv| Arquivo TXT|*.txt| Arquivo XML|*.xml',; //[ cMascara], 
                         'Selecao de Arquivos',;                  //[ cTitulo], 
                         0,;                                      //[ nMascpadrao], 
                         'C:\TOTVS\',;                            //[ cDirinicial], 
                         .F.,;                                    //[ lSalvar], 
                         GETF_LOCALHARD  + GETF_NETWORKDRIVE,;    //[ nOpcoes], 
                         .T.)         

FT_FUSE(cDiret)
ProcRegua(FT_FLASTREC())
FT_FGOTOP()
While !FT_FEOF()
 
	IncProc("Lendo arquivo texto...")
 
	cLinha := FT_FREADLN()
 
	If lPrimlin
		aCampos := Separa(cLinha,";",.T.)
		lPrimlin := .F.
	Else
		AADD(aDados,Separa(cLinha,";",.T.))
	EndIf
 
	FT_FSKIP()
EndDo
 
Begin Transaction
	ProcRegua(Len(aDados))
	For i:=1 to Len(aDados)
 
		IncProc("Importando Registros...")
 
		dbSelectArea("SA4")
		dbSetOrder(1)
		dbGoTop()
		If !dbSeek(xFilial("SA4")+aDados[i,1])
			Reclock("SA4",.T.)
			SA4->A4_FILIAL := xFilial("SA4")
			For j:=1 to Len(aCampos)
				cCampo  := "SA4->" + aCampos[j] //SA4->A4_COD
				&cCampo := aDados[i,j]
			Next j
			SA4->(MsUnlock())
		EndIf
	Next i
End Transaction
  
ApMsgInfo("Importação concluída com sucesso!","Sucesso!")
 
Return
