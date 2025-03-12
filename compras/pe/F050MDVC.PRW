#INCLUDE "RWMAKE.CH"
#INCLUDE "PROTHEUS.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma ณ F050MDVC บ Autor ณ CARLOS DANIEL        บ Data ณ 17/03/15 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Codigo gerado pelo AP11IDE. บฑฑ
ฑฑบ ณ บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso ณ AP6 IDE บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
Ponto de Entrada responsavel pelo tratamento dos vencimentos dos impostos
de maneira customizada conforme documento enviado, em
17/03/15.

ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
USER FUNCTION F050MDVC
Local dVencPR := ParamIXB[1]
Local cImposto := ParamIXB[2]
Local dEmissao := ParamIXB[3]
Local dEmis1 := ParamIXB[4]
Local dVencRea := ParamIXB[5]

If AllTrim(Upper(cImposto)) == 'IRRF'
dDtVenc := MsSomaMes(dEmissao,1,.T.)

dDtVenc := CtoD('20/'+StrZero(Month(dDtVenc),2)+'/'+Str(Year(dDtVenc),4))
ElseIf	AllTrim(Upper(cImposto)) == 'INSS'
dDtVenc := MsSomaMes(dEmissao,1,.T.)

dDtVenc := CtoD('20/'+StrZero(Month(dDtVenc),2)+'/'+Str(Year(dDtVenc),4))
ElseIf	AllTrim(Upper(cImposto)) $ 'CSLL*PIS*COFINS'
dDtVenc := MsSomaMes(dEmissao,1,.T.)

dDtVenc := CtoD('15/'+StrZero(Month(dDtVenc),2)+'/'+Str(Year(dDtVenc),4))
ElseIf	AllTrim(Upper(cImposto)) == 'ISS'
dDtVenc := MsSomaMes(dEmissao,1,.T.)

dDtVenc := CtoD('10/'+StrZero(Month(dDtVenc),2)+'/'+Str(Year(dDtVenc),4))
Endif

// Tratamento da Data para Nใo Cair aos Sabados, Domingos e Feriados
// Antecipando o Vencimento

If Dow(dDtVenc) = 1
dDtVenc := dDtVenc-2
dDtVenc := DataValida(dDtVenc)
ElseIf Dow(dDtVenc) == 7
dDtVenc := dDtVenc-1
dDtVenc := DataValida(dDtVenc)
Endif


RETURN dDtVenc
