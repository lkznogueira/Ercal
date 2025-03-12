#INCLUDE 'PROTHEUS.CH'

/*/-------------------------------------------------------------------
Programa: C105VLIN
Autor: Claudio Ferreira
Data: 28/07/21
Descrição: Ponto de Entrada Utilizado para validar linhas 
------------------------------------------------------------------/*/

User Function  C105VLIN
Local lRet:=.t. 
Local cUserok := '000000/000021/000044/000071/000077/000128'
//local lAdmin := PswAdmin(,,RetCodUsr())=0  
Local cUserLog := RetCodUsr()
//alterado Carlos Daniel
If !(cUserLog $ cUserok)

	If TMP->CT2_FLAG .and. !FunName() $ 'CTBA102#CTBA103#CTBA104#CTBA350'+SuperGetMV("MV_XVLDDRT",.F.,'')	/// SE ESTIVER DELETADO E NAO FOR CTB   
            MsgStop("ATENÇÃO, Não é permitido apagar as linhas."+chr(13)+chr(10)+" Por favor solicite apoio do responsável contábil")
            lRet :=.f.                            
	Endif

EndIf
/*
//Valida linha deletada alterado Carlos Daniel
if SuperGetMV("MV_XVLDDEL",.F.,.T.) .and. !lAdmin
	If TMP->CT2_FLAG .and. !FunName() $ 'CTBA102#CTBA103#CTBA104#CTBA350'+SuperGetMV("MV_XVLDDRT",.F.,'')	/// SE ESTIVER DELETADO E NAO FOR CTB  
      MsgStop("ATENÇÃO, Não é permitido apagar as linhas."+chr(13)+chr(10)+" Por favor solicite apoio do responsável contábil")
      lRet :=.f.                            
	Endif
endif
*/
Return lRet

