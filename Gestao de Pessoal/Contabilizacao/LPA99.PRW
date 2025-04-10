#INCLUDE "rwmake.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �LPA99  � Autora� Denise Oliveira 	   	 � Data �  09/01/14  ���
�������������������������������������������������������������������������͹��
���Descricao � Lancamento Padrao Folha Pagamento    					  ���
�������������������������������������������������������������������������͹��
���Uso       � MDM					                                      ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

                  
User Function LPA99(cTipo)

    Local _aArea := GetArea()
	
	Local _cConta := ""             
	
	
DbSelectArea("SRA")
DbSetOrder(1)
DbSeek(xfilial("SRA")+SRZ->RZ_MAT)

DbSelectArea("SRV")
DbSetOrder(1)
DbSeek(xfilial("SRV")+SRZ->RZ_PD)

DbSelectArea("CTT") 
DbSetOrder(1)
DbSeek(xFilial("CTT")+SRZ->RZ_CC)


If SRV->RV_LCTOP <> "   "         
	
            Do Case
				Case  cTipo == "CD" .AND. ALLTRIM(SRA->RA_CATFUNC) = "M" .AND. CTT->CTT_XCD == "A"  		// CONTA D�BITO - ADMINISTRATIVO
				_cConta := SRV->RV_DEBA 	
				Case  cTipo == "CD" .AND. ALLTRIM(SRA->RA_CATFUNC) = "M" .AND. CTT->CTT_XCD == "V"  		// CONTA D�BITO - VENDAS
				_cConta := SRV->RV_DEBV 	
				Case  cTipo == "CD" .AND. ALLTRIM(SRA->RA_CATFUNC) = "M" .AND. CTT->CTT_XCD == "C"  		// CONTA D�BITO - CUSTO
				_cConta := SRV->RV_DEBC 	
				Case  cTipo == "CD" .AND. ALLTRIM(SRA->RA_CATFUNC) = "M" .AND. CTT->CTT_XCD == "D" 	     	// CONTA D�BITO - CUSTO DIRETO
				_cConta := SRV->RV_DEBCD
				Case  cTipo == "CD" .AND. ALLTRIM(SRA->RA_CATFUNC) = "A"                                    // CONTA D�BITO - AUT�NOMO
				_cConta := SRV->RV_DEBAUT
				Case  cTipo == "CD" .AND. ALLTRIM(SRA->RA_CATFUNC) = "P"                                    // CONTA D�BITO - PR�-LABORE
				_cConta := SRV->RV_DEBPRO


				Case  cTipo == "CC" .AND. ALLTRIM(SRA->RA_CATFUNC) = "M" .AND. CTT->CTT_XCD == "A"  		// CONTA CR�DITO - ADMINISTRATIVO
				_cConta := SRV->RV_CREDA 	
				Case  cTipo == "CC" .AND. ALLTRIM(SRA->RA_CATFUNC) = "M" .AND. CTT->CTT_XCD == "V"  		// CONTA CR�DITO - VENDAS
				_cConta := SRV->RV_CREDV 	
				Case  cTipo == "CC" .AND. ALLTRIM(SRA->RA_CATFUNC) = "M" .AND. CTT->CTT_XCD == "C"  		// CONTA CR�DITO - CUSTO
				_cConta := SRV->RV_CREDC 	
				Case  cTipo == "CC" .AND. ALLTRIM(SRA->RA_CATFUNC) = "M" .AND. CTT->CTT_XCD == "D" 	    	// CONTA CR�DITO - CUSTO DIRETO
				_cConta := SRV->RV_CREDCD
				Case  cTipo == "CC" .AND. ALLTRIM(SRA->RA_CATFUNC) = "A"                                    // CONTA CR�DITO - AUT�NOMO
				_cConta := SRV->RV_CREDAUT
				Case  cTipo == "CC" .AND. ALLTRIM(SRA->RA_CATFUNC) = "P"                                    // CONTA CR�DITO - PR�-LABORE
				_cConta := SRV->RV_CREDPRO
 				OtherWise 
 				MsgAlert("Verifique Centro de Custo "+SRA->RA_CC+" Pois o campo 'TIPO' CTT_XCD esta vazio","AVISO")
 			EndCase 
 				
 			
ELSE
					
Endif			
	
Return(_cConta)