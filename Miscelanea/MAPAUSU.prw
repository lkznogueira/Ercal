#Include "rwmake.ch"

User Function reluser()  
                                                                   
Local cStr     := A1_USERLGI //ou A1_USERLGA
Local cNovaStr := Embaralha(cStr, 1) // parametro 0 embaralha, 1 desembaralha  
Local cCodigo := SUBSTR( EMBARALHA(SA1->A1_USERLGI,1),3,6 ) 
Local cUsu     := SubStr(cNovaStr,0,15) //usuario que alterou
//Agora vem a parte boa, descobrir a data ;D
Local nDias    := Load2in4(SubStr(cNovaStr,16))
Local dData    := CtoD("01/01/96","DDMMYY") + nDias

//variavel "cUsu" eh o login e "dData" foi a data da alteração ;x 

//nova alternativa
cCodigo := SUBSTR( EMBARALHA(SC7->C7_USERLGI,1),3,6 ) 
PswOrder(1)     // Busca por ID 

If PSWSEEK( cCodigo, .T. )      
     aUser := PSWRET() // Retorna vetor com informações do usuário 
	Alert(aUser+"Dados de acesso")
	Alert(cUsu+"Dados de acesso")
	Alert(dData+"Dados de acesso")
endif
// onde: 
//   aUser[1][1] é o Código 
//   aUser[1][2] é o Login 
//   aUser[1][4] é o Nome Completo      



// FWLeUserlg - Informaes do USERLGI\USERLGA ( cCampo [ nTipo ] ) --> cRet 
// O parmetro nTipo recebe o seguinte contedo: 1 - Efetua a consulta do nome do usurio. 2 - Efetua a consulta da data de manipulao. 
return()