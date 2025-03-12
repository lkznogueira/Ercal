#INCLUDE "Protheus.ch"
#INCLUDE "Totvs.ch"
#INCLUDE "topconn.ch"

/*/{Protheus.doc} CFGxFAT
// Conjuto de funções auxiliares - Faturamento
@author Gontijo - 2022-04-30
/*/

/*/ Função para bloquei de campos do pedido de venda / contrato de parceria/*/
User Function xBlqCtr()

Local cRet     := .F.
Local cUsrAtu  := RetCodUsr()
Local fUncao   := FUNNAME()
local cTes1
Local cContra

DbSelectArea("ZZA")
DbSetOrder(1)
ZZA->(DbGoTop())

    If ZZA->(DbSeek(xFilial("ZZA")+cUsrAtu))
        IF fUncao <> "LIBCONTR"
            cRet := .T.
        EndIf//Alert( 'Usuario sem permissao para alterar este campo no pedido de venda' )
    EndIf
    //verifica se a tes ou cf for de contrato especifico trava carllosdaniell
    If fUncao == "MATA410" 
        cTes1 := ACOLS[N][12]
        cContra := TRIM(M->C5_CONTRA)
    ElseIf fUncao == "FATA400" 
        cTes1 := ACOLS[N][9]
        cContra := '000000'
    ElseIf fUncao == "FINA050" .or. fUncao == "FINA750"
        If SE2->E2_TIPO <> "PR" //.OR. SE2->E2_PREFIXO <> "PRC"
            cRet     := .T.
        EndIf
    ElseIf fUncao == "FINA040" .or. fUncao == "FINA740"
        If SE1->E1_TIPO <> "PR" //.OR. SE1->E1_PREFIXO <> "PRC"
            cRet     := .T.
        EndIf
    EndIf
    IF !Empty(cContra) //.OR. cContra <> NIl
        If !cRet
            SF4->(DbSetOrder(1))
            SF4->(DbSeek(xFilial("SF4")+cTes1) )                    //FILIAL+CODIGO   
        //If TRIM(ACOLSHIST[1][15]) ==  "5922" .or. TRIM(ACOLSHIST[1][15]) == "6922" .or. TRIM(ACOLSHIST[1][15]) == "5101" .or. TRIM(ACOLSHIST[1][15]) == "6101" .or. TRIM(ACOLSHIST[1][15]) == "5116" .or. TRIM(ACOLSHIST[1][15]) == "6116"
            If TRIM(SF4->F4_CF) ==  "5922" .or. TRIM(SF4->F4_CF) == "6922" .or. TRIM(SF4->F4_CF) == "5101" .or. TRIM(SF4->F4_CF) == "6101" .or. TRIM(SF4->F4_CF) == "5116" .or. TRIM(SF4->F4_CF) == "6116"
                cRet     := .F.
                //Alert( 'Usuario sem permissao para alterar este campo com CFOP: '+TRIM(SF4->F4_CF) )
            EndIf

        EndIf
    EndIf

ZZA->(DbCloseArea())

Return cRet

/*/ Função para bloquei de campos do pedido de venda / contrato de parceria/*/
User Function xCadCtr()

Local cDelOk   := ".T."
Local cFunTOk  := ".T."
Local cRet     := .F.
Local cUserLog := RetCodUsr()

DbSelectArea("ZZ9")
DbSetOrder(1)
ZZ9->(DbGoTop())

    If ZZ9->(DbSeek(xFilial("ZZ9")+cUserLog))

        cRet := .T.

    EndIf

ZZ9->(DbCloseArea())

If !cRet

	Alert("Usuário sem acesso a rotina de cadastro.")

	Return

EndIf

    AxCadastro('ZZA', 'Usuários - Liberação campos pedido de venda - contrato de parceria', cDelOk, cFunTOk)
 
Return


/*/ Função para cadastro de administradores da rotina de liberação de usuários./*/
User Function xMV_LIBCMP

Local cDelOk   := ".T."
Local cFunTOk  := ".T."
Local cUserLog := RetCodUsr()
Local cUserGrp := UsrRetGrp(RetCodUsr())

If Empty(cUserGrp)

    cUserGrp := 'XXXXXX'

EndIf

If cUserLog <> '000000'

    If cUserGrp[1] <> '000000'

	    Alert("Usuário sem acesso a rotina de cadastro de administradores da rotina de liberação de usuários.")

	    Return

    EndIf

EndIf

    AxCadastro('ZZ9', 'Usuários - Liberação campos pedido de venda - contrato de parceria', cDelOk, cFunTOk)
 

Return

/*/ Função para converter as caracteres das perguntas para SQL./*/
User Function RetMV(cTexto,cSeparador)

Local cTxt         := ""
Local nX           := 0

Default cParametro := ""
Default cSeparador := ""

//Pega o conteúdo do parâmetro
cGetCont := AllTrim(cTexto)
         
//Busca todos os dados quebrando pelo separador
aDados := StrTokArr(cGetCont, cSeparador)

For nX := 1 to len(aDados)

    If nX < len(aDados)

        cTxt += "'"+aDados[nX]+"',"

    Else 

        cTxt += "'"+aDados[nX]+"'"

    EndIf

Next

Return cTxt
