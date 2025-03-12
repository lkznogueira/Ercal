#INCLUDE "PROTHEUS.CH"
#INCLUDE "rwmake.ch"
#include "TOTVS.CH"
#INCLUDE "TBICONN.CH"
#define MB_OK                       0
#define MB_OKCANCEL                 1
#define MB_YESNO                    4
#define MB_ICONHAND                 16
#define MB_ICONQUESTION             32
#define MB_ICONEXCLAMATION          48
#define MB_ICONASTERISK             64  
// Retornos possíveis do MessageBox
#define IDOK			    1
#define IDCANCEL		    2
#define IDYES			    6
#define IDNO			    7



///**************************************************************************************************************************************************
///*************************************************************************************************************************************************
////*************************************************************************************************************************************************
////                                                             Consulta a Chave na SEF 
////*************************************************************************************************************************************************
////*************************************************************************************************************************************************
///**************************************************************************************************************************************************

user Function ConsChave(Chave,vTela)

	Local aArea  := GetArea()
	Local cIdEnt := ""
	Local cURL   := PadR(GetNewPar("MV_SPEDURL","http://"),250)
	Local oWs
	Local cChav  :=  Chave
    LOCAL xerr   := .f.

    Local xRetCons   := {"",;  // Codigo Retorno
                         "",;   // Mensagem do retorno
                         ""}   // Protocolo

	If Empty(cChav)
		return xRetCons
	EndIf	

	oWS := WsSPEDAdm():New()
	oWS:cUSERTOKEN := "TOTVS"
	
	oWS:oWSEMPRESA:cCNPJ       := IIF(SM0->M0_TPINSC==2 .Or. Empty(SM0->M0_TPINSC),SM0->M0_CGC,"")
	oWS:oWSEMPRESA:cCPF        := IIF(SM0->M0_TPINSC==3,SM0->M0_CGC,"")
	oWS:oWSEMPRESA:cIE         := SM0->M0_INSC
	oWS:oWSEMPRESA:cIM         := SM0->M0_INSCM
	oWS:oWSEMPRESA:cNOME       := SM0->M0_NOMECOM
	oWS:oWSEMPRESA:cFANTASIA   := SM0->M0_NOME
	oWS:oWSEMPRESA:cENDERECO   := FisGetEnd(SM0->M0_ENDENT)[1]
	oWS:oWSEMPRESA:cNUM        := FisGetEnd(SM0->M0_ENDENT)[3]
	oWS:oWSEMPRESA:cCOMPL      := FisGetEnd(SM0->M0_ENDENT)[4]
	oWS:oWSEMPRESA:cUF         := SM0->M0_ESTENT
	oWS:oWSEMPRESA:cCEP        := SM0->M0_CEPENT
	oWS:oWSEMPRESA:cCOD_MUN    := SM0->M0_CODMUN
	oWS:oWSEMPRESA:cCOD_PAIS   := "1058"
	oWS:oWSEMPRESA:cBAIRRO     := SM0->M0_BAIRENT
	oWS:oWSEMPRESA:cMUN        := SM0->M0_CIDENT
	oWS:oWSEMPRESA:cCEP_CP     := Nil
	oWS:oWSEMPRESA:cCP         := Nil
	oWS:oWSEMPRESA:cDDD        := Str(FisGetTel(SM0->M0_TEL)[2],3)
	oWS:oWSEMPRESA:cFONE       := AllTrim(Str(FisGetTel(SM0->M0_TEL)[3],15))
	oWS:oWSEMPRESA:cFAX        := AllTrim(Str(FisGetTel(SM0->M0_FAX)[3],15))
	oWS:oWSEMPRESA:cEMAIL      := UsrRetMail(RetCodUsr())
	oWS:oWSEMPRESA:cNIRE       := SM0->M0_NIRE
	oWS:oWSEMPRESA:dDTRE       := SM0->M0_DTRE
	oWS:oWSEMPRESA:cNIT        := IIF(SM0->M0_TPINSC==1,SM0->M0_CGC,"")
	oWS:oWSEMPRESA:cINDSITESP  := ""
	oWS:oWSEMPRESA:cID_MATRIZ  := ""
	oWS:oWSOUTRASINSCRICOES:oWSInscricao := SPEDADM_ARRAYOFSPED_GENERICSTRUCT():New()
	oWS:_URL := AllTrim(cURL)+"/SPEDADM.apw"
	If oWs:ADMEMPRESAS()
		cIdEnt  := oWs:cADMEMPRESASRESULT
	Else
//		Aviso("SPED",IIf(Empty(GetWscError(3)),GetWscError(1),GetWscError(3)),{"Ok"},3)
		xerr   := .T.
	EndIf

	RestArea(aArea)
    If !xerr
		xRetCons:= ConsNFeChave(cChav,cIdEnt,vtela)
	EndIf	
Return xRetCons

///**************************************************************************************************************************************************
///*************************************************************************************************************************************************
////*************************************************************************************************************************************************
////                                                             Funcção complementar Chave na SEF 
////*************************************************************************************************************************************************
////*************************************************************************************************************************************************
///**************************************************************************************************************************************************

Static Function ConsNFeChave(cChaveNFe,cIdEnt,vTela)
	
	Local cURL     := PadR(GetNewPar("MV_SPEDURL","http://"),250)
	Local cMensagem:= ""
	Local oWS
	Local lErro  := .F.
	Local CodRet := ""
	Local MsgRet := ""
	Local Protoc := ""
    Local xRetConsnfe   := {"",;  // Codigo Retorno
                            "",; // Mensagem do retorno
                            ""}  // Protoclo
	
	oWs:= WsNFeSBra():New()
	oWs:cUserToken   := "TOTVS"
	oWs:cID_ENT      := cIdEnt
	ows:cCHVNFE		 := cChaveNFe
	oWs:_URL         := AllTrim(cURL)+"/NFeSBRA.apw"

	If oWs:ConsultaChaveNFE()
		cMensagem := ""
		If !Empty(oWs:oWSCONSULTACHAVENFERESULT:cVERSAO)
			cMensagem += "Versão da Mensagem"+": "+oWs:oWSCONSULTACHAVENFERESULT:cVERSAO+CRLF
		EndIf      
		CodRet := oWs:oWSCONSULTACHAVENFERESULT:cCODRETNFE
		MsgRet := oWs:oWSCONSULTACHAVENFERESULT:cMSGRETNFE
		
		xRetConsnfe[1]:= CodRet
		xRetConsnfe[2]:= MsgRet 
		
		cMensagem += "Ident"+": "+cIdEnt+CRLF  
		cMensagem += "Chave"+": "+cChaveNFe+CRLF
		cMensagem += "Ambiente"+": "+IIf(oWs:oWSCONSULTACHAVENFERESULT:nAMBIENTE==1,"Produção","Homologação")+CRLF //"Produção"###"Homologação"
		cMensagem += "Cod.Ret.NFe"+": "+CodRet+CRLF
		cMensagem += "Msg.Ret.NFe"+": "+MsgRet+CRLF
		If !Empty(oWs:oWSCONSULTACHAVENFERESULT:cPROTOCOLO)
			Protoc := oWs:oWSCONSULTACHAVENFERESULT:cPROTOCOLO
			cMensagem += "Protocolo"+": "+Protoc+CRLF
			xRetConsnfe[3] := Protoc
		EndIf
		If vTela
			Aviso("Consulta NF",cMensagem,{"Ok"},3)
        EndIf
	Else
		If vTela
		    Aviso("SPED",IIf(Empty(GetWscError(3)),GetWscError(1),GetWscError(3)),{"Ok"},3)
        EndIf
	EndIf  
	
Return xRetConsnfe