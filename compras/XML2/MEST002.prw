#INCLUDE "rwmake.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MEST002   º Autor ³ Ramon Teles        º Data ³  00/00/00   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Importa os arquivos XML para a rotina de geracao NFE       º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP6 IDE                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function MEST002()
Local aFiles := {} 
//Local cFiles := {}
Local nX	 := 0                
Private aContas		:= {}
Private cIniFile	:= GetADV97()    
//Private c4StartPath := "c:\xml\"    // PASTA COM XML NATIVO
Private cStartPath 	:= "\xml\IMPORTADOS\"
//Private cStartLido	:= Trim(cStartPath)+"IMPORTADOS\"
Private c2StartPath	:= Trim(cStartPath)+AllTrim(SM0->M0_CGC)+"\"     		//CNPJ
Private c3StartPath	:= Trim(c2StartPath)+AllTrim(Str(Year(Date())))+"\"		//ANO    
Private c5StartPath := Trim(c3StartPath)+AllTrim(Str(Month(Date())))+"\"    //MES
Private cStartError	:= Trim(c5StartPath)+"ERRO\"           					//ERROS


//CRIA DIRETORIOS
//MakeDir(GetPvProfString(GetEnvServer(),"StartPath","ERROR", cIniFile )+'NFE\')
//MakeDir(Trim(cStartPath)) //CRIA DIRETOTIO ENTRADA
MakeDir(cStartPath) //CRIA DIRETORIO ARQUIVOS IMPORTADOS
MakeDir(c2StartPath) //CRIA DIRETOTIO CNPJ
MakeDir(c3StartPath) //CRIA DIRETOTIO ANO              
//MakeDir(c4StartPath) //CRIA DIRETOTIO DIA 
MakeDir(c5StartPath) //CRIA DIRETOTIO MES  
MakeDir(cStartError) //CRIA DIRETORIO ERRO

//aFiles := Directory(GetSrvProfString("RootPath","") +"\" +cStartPath2 +"*.xml")
aFiles := Directory(cStartPath+"*.xml")      

nXml := 0 
conout(" ")
conout(Replicate("=",80))
conout("Processando Arquivos..... ")
conout(Replicate("=",80))

For nX := 1 To Len(aFiles)
	
	conout(" ")
	conout(Replicate("=",80))
	conout(OemtoAnsi("O sistem possui "+StrZero(Len(aFiles) -nXML,8)+" arquivos(s) para processar") ) //###
	conout(Replicate("=",80))
	
	nXml++
	U_ReadXML(aFiles[nX,1],.F.)
	
	//QUANDO TIVER 500 XML SAI DA ROTINA, SENAO ESTOURA O ARRAY DO XML
	If nXml == 500
		Return
	EndIf
	
Next nX

//RpcClearEnv()


Return
