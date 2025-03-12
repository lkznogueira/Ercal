#INCLUDE 'PROTHEUS.CH'
 
User Function TMF76Cps()
Local nAcao   := ParamIXB[1]
Local cAlias  := ParamIXB[2]
Local aCampos := Aclone(ParamIXB[3])
 
If nAcao == 1
    Aadd(aCampos,{})
    Ains(aCampos,10)
    
    aCampos[7] := {"DF1_REGORI","DF1_REGORI","DF1_REGORI",.F.} 
    aCampos[8] := {"DF1_REGDES","DF1_REGDES","DF1_REGDES",.F.} 
    aCampos[10] := {"DF1_NOMREM","DF1_NOMREM","DF1_NOMREM",.F.}
    aCampos[19] := {"DF1_NOMDES","DF1_NOMDES","DF1_NOMDES",.F.}

EndIf

If nAcao == 2 .and. cAlias == "DTC"
    Aadd(aCampos,{})
    Ains(aCampos,14)
    
    aCampos[14] := {"DTC_NOMREM","DTC_NOMREM","DTC_NOMREM",.F.} 
    aCampos[17] := {"DTC_NOMDES","DTC_NOMDES","DTC_NOMDES",.F.}
    

EndIf

If nAcao == 2 .and. cAlias == "DTW"
    Aadd(aCampos,{})
    Ains(aCampos,14)
    
    aCampos[14] := {"DTW_DESATI","DTW_DESATI","DTW_DESATI",.F.} 
 
EndIf

If nAcao == 2 .and. cAlias == "DF0"
    Aadd(aCampos,{})
    Ains(aCampos,5)
    
    aCampos[5] := {"DF0_NOMSOL","DF0_NOMSOL","DF0_NOMSOL",.F.} 

EndIf

If nAcao == 2 .and. cAlias == "DTQ"
    Aadd(aCampos,{})
    Ains(aCampos,7)
    
    aCampos[7] := {"DTQ_DESROT","DTQ_DESROT","DTQ_DESROT",.F.} 
    
EndIf


Return Aclone(aCampos)
