#include "protheus.ch"

/*
_____________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦Programa  ¦ MSD2460    ¦ Autor ¦ Claudio Ferreira   ¦ Data ¦ 07/06/2012¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Descriçào ¦ Ponto de Entrada apos o faturamento preenche o C.Custo     ¦¦¦
¦¦¦          ¦                                                            ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦ Uso      ¦ TOTVS-GO                                                   ¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
*/

User Function MSD2460()
  //Local vDesc := 0
  //LOCAL vIcm := 0
  //LOCAL cEST  := ' '  //Estado do Cliente
  //LOCAL cTIPc := ' '
  //LOCAL cGrup := Posicione("SB1",1,xFilial("SB1")+SD2->D2_COD,"B1_GRUPO")  //Grupo do Produto
  //LOCAL nDESC := 0
/*
  SA1->(dbSetOrder(1))
  SA1->(dbSeek(xFilial("SA1")+SF2->F2_CLIENTE+SF2->F2_LOJA))

  //trata desconto ICMS desonerado Carlos Daniel
  cEST  := SF2->F2_EST  //Estado do Cliente
  cTIPc := SA1->A1_CONTRIB  //SE CONTRIBUINTE

  IF cTIPc == '1' .And. cEST <>'MG'  // SE CLIENTE FOR PRODUTO FORA DO ESTADO MG e grupo calcario
    IF cGrup == '0056' .OR.  cGrup == '0106'
      IF cEST == 'PR' .OR. cEST== 'RS' .OR. cEST== 'RJ'.OR. cEST== 'SC' .OR. cEST== 'SP'
        nDESC := 12
        vIcm := ((SD2->D2_TOTAL - SD2->D2_BASEICM)*nDESC/100)
        vDesc :=  vIcm

        SD2->(Reclock("SD2",.f.))

        SD2->D2_DESC := vDesc

        SD2->(MsUnlock())
      ELSE
        nDESC := 7
        vIcm := ((SD2->D2_TOTAL - SD2->D2_BASEICM)*nDESC/100)
        vDesc :=  vIcm

        SD2->(Reclock("SD2",.f.))

        SD2->D2_DESC := vDesc

        SD2->(MsUnlock())
      ENDIF
    ENDIF
  ENDIF
  //FIM
*/

  SD2->(Reclock("SD2",.f.))

  If SC5->(FieldPos("C5_XCC"))> 0
    SD2->D2_CCUSTO := SC5->C5_XCC
  Endif
  If SC5->(FieldPos("C5_XITEMC"))> 0
    SD2->D2_ITEMCC := SC5->C5_XITEMC
  Endif
  SD2->(MsUnlock())

Return
