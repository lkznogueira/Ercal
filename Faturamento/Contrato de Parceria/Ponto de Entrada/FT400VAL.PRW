#INCLUDE 'PROTHEUS.CH'

/*/{Protheus.doc} FT400VAL
// FT400VAL - Valida preenchimento do aHeader
@author Lucas Nogueira
@url https://tdn.totvs.com/display/public/PROT/FT400VAL+-+Valida+preenchimento+do+aHeader
/*/
User Function FT400VAL() 
    Local lRet := .T.
    Local dEntr := ADA->ADA_XVCTO
    Local cStatus := ADA->ADA_STATUS

    If ADA->ADA_XVENC < Date()
        lRet := .F.
        MsgAlert("Contrato Vencido!!" + CRLF + CRLF + "N�o ser� poss�vel prosseguir." + CRLF + CRLF + " Favor contactar a equipe de Faturamento!","Aten��o")
    Endif

    //Carlos Daniel
    IF cStatus <> "A"
        If Date() < dEntr 
            lRet := .F.
            MsgAlert("Carregamento nao autorizado!!" + CRLF + CRLF + "So ser� poss�vel a partir do dia. "+ CVALTOCHAR(dEntr) + CRLF + CRLF + " Favor contactar Financeiro(contas a receber)!","Aten��o")
        Endif
    Endif

Return(lRet)
