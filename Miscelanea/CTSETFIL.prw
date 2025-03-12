/*/-----------------------------------------------------------------------------
Programa: CTSETFIL
Autor: Claudio Ferreira
Data: 29.03.22
Descrição: Ponto de entrada para filtrar filiais
-----------------------------------------------------------------------------/*/
User Function __CTSETFIL()
Local aArea := SM0->( GetArea() )
Local aAuxArea := GetArea()
Local aRetSM0 := {}
Local cFilBx := "4110,4201,4202,4205,4206"

DbSelectArea( "SM0" )
SM0->( DbGoTop() )
DbSeek(cEmpAnt)


While SM0->( !Eof() ) .AND. SM0->M0_CODIGO = cEmpAnt
      alert(SM0->M0_CODFIL)
      if !SM0->M0_CODFIL $ cFilBx 
        aAdd( aRetSM0, {SM0->M0_CODFIL,SM0->M0_FILIAL,LEFT(SM0->M0_CGC,2)+"."+SUBSTR(SM0->M0_CGC,3,3)+"."+SUBSTR(SM0->M0_CGC,6,3)+"/"+SUBSTR(SM0->M0_CGC,9,4)+"-"+SUBSTR(SM0->M0_CGC,13,2)} )
	  endif	
      SM0->(DbSkip())
EndDo

RestArea( aArea )
RestArea( aAuxArea )

Return aRetSM0

user function __AfterLogin()
Local cFilBx := "4110,4201,4202,4205,4206"
//if Type("cEmpAnt") == "C" .and. Type("cFilAnt") == "C" .and. cEmpAnt == "99" .and. cFilAnt == "01"
//    Final("Esse grupo de empresas e filial encontra-se desabilitado para utilização")
//endif
alert(SM0->M0_CODFIL)
DbSelectArea( "SM0" )
SET FILTER TO !SM0->M0_CODFIL $ cFilBx 

return
