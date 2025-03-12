#INCLUDE "Protheus.ch" 
#include "rwmake.ch" 
#INCLUDE "topconn.ch"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o	 � MA330MOD   � Autor � Claudio Ferreira    � Data � 19/06/13 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Ponto de entrada para alterar a forma de calculo do MOD    ���
���          � consideradas para calculo da mao de obra no recalculo do   ���
���          � custo medio                                                ���
�������������������������������������������������������������������������Ĵ��
��� Uso		 � Especifico para CTB                                        ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User function ma330mod()
Local aArea     := GetArea()
Local cCodPesq  := ParamixB[1]
Local nX        := 0
Local cCodAnt   := ""
Local aSaldos   := {0,0,0,0,0}
Local nQuant    := 0
Local nQuantTot := 0
Local _nValor   := 0
Local lModOri   := .t. 
Local lA330QTMO := ExistBlock("A330QTMO")
Local cIndice
Local cFilSD3
Local cKey
Local nIndex 
Local lModOri  := ParamixB[1] == "MOD"
Local cCodCC:=ParamixB[2]    
Local cGrupo:=ParamixB[3] 

                        

    //���������������������������������������������Ŀ
	//� Atualiza o log de processamento			    �
	//�����������������������������������������������
     ProcLogAtu("MENSAGEM",OemToAnsi("Iniciando Recalculo do Custo da M�o de Obra (Especifico CTB) "+cFilAnt +"-"+ cCodPesq),OemToAnsi("Iniciando Recalculo do Custo da M�o de Obra (Especifico CTB) "+cFilAnt+"-"+cCodPesq)) 

	//��������������������������������������������������������������Ŀ
	//� Zera os saldos de MOD para recalcular                        �
	//����������������������������������������������������������������
	dbSelectArea("SB2")
	dbSetOrder(1)
	dbSeek(xFilial("SB2")+cCodPesq)
	While !Eof() .And. B2_FILIAL+If(lModOri,Substr(B2_COD,1,3),B2_COD) == xFilial("SB2")+cCodPesq
		If SB2->B2_COD # cCodAnt
			//��������������������������������������������������������������Ŀ
			//� Pega os saldos do centro de custo                            �
			//����������������������������������������������������������������
			//aSaldos := MA330SalCC(If(lModOri,SubStr(SB2->B2_COD,4,9),cCodCC),a330ParamZX[01],cGrupo)
			aSaldos   := {0,0,0,0,0}
			For nX := 1 to 1 //S� moeda 1
			  _nValor := U__RetSlCC(nX,If(lModOri,SubStr(SB2->B2_COD,4,9),cCodCC),dtos(a330ParamZX[01]),cGrupo)
			  aSaldos[nX] += _nValor
			Next nX
			
			cCodAnt := SB2->B2_COD
			//��������������������������������������������������������������Ŀ
			//� Aplica o % de aumento no custo da MOD                        �
			//����������������������������������������������������������������
			For nX := 1 to 1 //Len(aSaldos)
				// Verifica se moeda devera ser considerada 	
				//If nx # 1 .And. !(Str(nx,1,0) $ cMoeda330C)
                //	Loop
   				//EndIf
				aSaldos[nX] += (aSaldos[nX] * (a330ParamZX[05]/100))
			Next nX
			//��������������������������������������������������������������Ŀ
			//� Quantidade total do produto MOD                              �
			//����������������������������������������������������������������
			nQuantTot:=0
			//��������������������������������������������������������������Ŀ
			//� Filtra movimentos validos do produto                         �
			//����������������������������������������������������������������
			dbSelectArea("SD3")
			cIndice := CriaTrab("",.F.)
			dbSelectArea("SD3")
			cFilSD3 := 'D3_FILIAL == "'+xFilial("SD3")+'" .And. dTos(D3_EMISSAO) >="'+dtos(dInicio)+'"'
			cFilSD3 += ' .And. D3_COD == "'+cCodAnt+'" .And. dTos(D3_EMISSAO) <="'+dtos(a330ParamZX[01])+'"'
			cKey    := 'D3_FILIAL+D3_COD'
			IndRegua("SD3",cIndice,cKey,,cFILSD3,IIF(lCusLifo,OemToAnsi("Selecionando Saldo Lotes FIFO/LIFO..."),OemToAnsi("Selecionando Saldo Lotes FIFO/LIFO...")))		//"Selecionando Saldo Lotes FIFO/LIFO..."
			nIndex := Retindex("SD3")
			#IFNDEF TOP
				dbSetIndex(cIndice+OrdBagExt())
			#ENDIF
			dbSetOrder(nIndex+1)
			dbGoTop()
			While !Eof()
				If D3_TM <= "500"
					nQuantTot += D3_QUANT
				Else
					nQuantTot -= D3_QUANT
				EndIf
				dbSkip()
			EndDo
			RetIndex("SD3")
			dbClearFilter()
			Ferase(cIndice+OrdBagExt())
		EndIf		
		//��������������������������������������������������������������Ŀ
		//� Quantidade do produto nesse armazem                          �
		//����������������������������������������������������������������
		nQuant := 0
		dbSelectArea("SD3")
		dbSetOrder(7)  // PRODUTO+LOCAL+DATA
		dbSeek(xFilial("SD3")+SB2->B2_COD+SB2->B2_LOCAL+DTOS(dInicio),.T.)                                          
		While !Eof() .And. D3_FILIAL+D3_COD+D3_LOCAL == xFilial("SD3")+SB2->B2_COD+SB2->B2_LOCAL .And. dTos(D3_EMISSAO) >= dtos(dInicio) .AND. DTOS(D3_EMISSAO) <= DTOS(a330ParamZX[01])
		//.And. (DTOS(D3_EMISSAO) > dtos(GETMV("MV_ULMES")) .AND. DTOS(D3_EMISSAO) <= DTOS(a330ParamZX[01]))
			If D3_TM <= "500"
				nQuant += D3_QUANT
			Else
				nQuant -= D3_QUANT
			EndIf
			dbSkip()
			//��������������������������������������������������������������Ŀ
			//� Movimentacao do Cursor                                       �
			//����������������������������������������������������������������
			If !lBat
				IncProc(OemToAnsi("Acertando o Custo da M�o de Obra")) //"Acertando o Custo da M�o de Obra"
			EndIf
		EndDo

		dbSelectArea("SB2")
		RecLock("SB2",.F.)

		Replace B2_VFIM1 With aSaldos[01]*ABS(nQuant/nQuantTot)
		// Verifica se moeda devera ser considerada 	
        /*
		Replace B2_VFIM2 With aSaldos[02]*ABS(nQuant/nQuantTot)
		Replace B2_VFIM3 With aSaldos[03]*ABS(nQuant/nQuantTot)
		Replace B2_VFIM4 With aSaldos[04]*ABS(nQuant/nQuantTot)
		Replace B2_VFIM5 With aSaldos[05]*ABS(nQuant/nQuantTot)				
        */  
        
		Replace B2_CM1 With B2_VFIM1/ABS(nQuant)
		Replace B2_CMFIM1 With B2_VFIM1/ABS(nQuant)

		// Verifica se moeda devera ser considerada 	
		/*
		Replace B2_CM2 With B2_VFIM2/ABS(nQuant)
		Replace B2_CM3 With B2_VFIM3/ABS(nQuant)
		Replace B2_CM4 With B2_VFIM4/ABS(nQuant)
		Replace B2_CM5 With B2_VFIM5/ABS(nQuant)
		*/				
		Replace B2_QFIM With nQuant

		//��������������������������������������������������������������Ŀ
		//� A330QTMO - Ponto de entrada utilizado para manipular a       |
		//|            quantidade da mao de obra apurada.                �
		//����������������������������������������������������������������
		If lA330QTMO
			ExecBlock("A330QTMO",.F.,.F.)
		EndIf

		MsUnlock()

		TTFimComMO({SB2->B2_VFIM1,SB2->B2_VFIM2,SB2->B2_VFIM3,SB2->B2_VFIM4,SB2->B2_VFIM5})
		TTFimQtdMO()
		dbSkip()
	EndDo
	//��������������������������������������������������������������Ŀ
	//� Devolve ordem principal dos arquivos                         �
	//����������������������������������������������������������������
	dbSelectArea("SD3")
	dbSetOrder(1)

	//���������������������������������������������Ŀ
	//� Atualiza o log de processamento			    �
	//�����������������������������������������������
     ProcLogAtu("MENSAGEM",OemToAnsi("Termino do Recalculo do Custo da M�o de Obra"),OemToAnsi("Termino do Recalculo do Custo da M�o de Obra")) //"Termino do Recalculo do Custo da M�o de Obra"  
RestArea(aArea)
Return


/*
������������������������������������������������������������������������������������
������������������������������������������������������������������������������������
��������������������������������������������������������������������������������Ŀ��
���Fun��o	 � _RetSlCC          � Autor � TBC                 � Data � 19/06/13 ���
��������������������������������������������������������������������������������Ĵ��
���Descri��o � Funcao que retorna o saldo do centro de custo por classe de valor ���
���          � pois a funcao atual busca da CT3 e na mesma nao possui quebra por ���
���          � classe.Essa funcao vai buscar o saldo da CT2, igual o Razao CTB.  ���
��������������������������������������������������������������������������������Ĵ��
��� Uso		 � Especifico para NUTRIZA                                           ���
���������������������������������������������������������������������������������ٱ�
������������������������������������������������������������������������������������
������������������������������������������������������������������������������������
*/
User Function _RetSlCC(_Moeda,_CC,_Data,_cGrp)
Local _cQuery  := ""
Local _Retorno := 0
Local aArea    := GetArea()
                              
if _Moeda <> 1
  Return _Retorno
endif

_cQuery := " SELECT"
_cQuery += "  (DEB.VALOR - CRE.VALOR) AS SALDO"
_cQuery += " FROM"
_cQuery += " ("
_cQuery += " SELECT"
_cQuery += "  COALESCE(SUM(CT2_VALOR),0) VALOR"
_cQuery += " FROM"
_cQuery += "   " + RetSqlName( "CT2" ) + " CT2"
_cQuery += "  ," + RetSqlName( "CT1" ) + " CT1"
_cQuery += " WHERE"
_cQuery += "     CT2_FILIAL               = '" + xFilial("CT2") + "' "
_cQuery += " AND CT1_FILIAL               = '" + xFilial("CT1") + "' "
_cQuery += " AND CT1_CONTA                = CT2_DEBITO "
if !empty(_cGrp)
  _cQuery += " AND CT1_GRUPO               = '" + _cGrp + "' "
endif  
_cQuery += " AND CT1.D_E_L_E_T_           = ' '"
_cQuery += " AND CT2.D_E_L_E_T_           = ' '"
_cQuery += " AND CT2_DATA                <= '"+_Data+"'"           
_cQuery += " AND CT2_DATA                > '"+DTOS(getmv("MV_ULMES"))+"'"
_cQuery += " AND LTRIM(RTRIM(CT2_CCD))    = '"+ALLTRIM(_CC)+"'"
_cQuery += " AND LTRIM(RTRIM(CT2_CLVLDB)) = '"+CFILANT+"'"
_cQuery += " AND LTRIM(RTRIM(CT2_ROTINA)) <> 'MTA330P' "
_cQuery += " ) DEB"
_cQuery += " ,("
_cQuery += " SELECT"
_cQuery += "  COALESCE(SUM(CT2_VALOR),0) VALOR"
_cQuery += " FROM"
_cQuery += "   " + RetSqlName( "CT2" ) + " CT2"
_cQuery += "  ," + RetSqlName( "CT1" ) + " CT1"
_cQuery += " WHERE
_cQuery += "     CT2_FILIAL               = '" + xFilial("CT2") + "' "
_cQuery += " AND CT1_FILIAL               = '" + xFilial("CT1") + "' "
_cQuery += " AND CT1_CONTA                = CT2_CREDIT "
if !empty(_cGrp)
  _cQuery += " AND CT1_GRUPO               = '" + _cGrp + "' "
endif  
_cQuery += " AND CT1.D_E_L_E_T_           = ' '"
_cQuery += " AND CT2.D_E_L_E_T_           = ' '"
_cQuery += " AND CT2_DATA                <= '"+_Data+"'"
_cQuery += " AND CT2_DATA                > '"+DTOS(getmv("MV_ULMES"))+"'"
_cQuery += " AND LTRIM(RTRIM(CT2_CCC))    = '"+ALLTRIM(_CC)+"'"
_cQuery += " AND LTRIM(RTRIM(CT2_CLVLCR)) = '"+CFILANT+"'"
_cQuery += " AND LTRIM(RTRIM(CT2_ROTINA)) <> 'MTA330P' "
_cQuery += " ) CRE"
dbUseArea(.T., "TOPCONN", TCGenQry(,,_cQuery), '_QRY', .F., .T.)
_Retorno := _QRY->SALDO
                                  
_QRY->( dbCloseArea("_QRY") )

memowrit("d:\sql.txt",_cQuery)

RestArea(aArea)
Return _Retorno

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �TTFimComMO� Autor �Rodrigo de A. Sartorio � Data � 13/11/01 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Atualiza o saldo final do TRT (VFIM) baseado no val. da MOD���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   � TTFimComMO(ExpA1)                                          ���
�������������������������������������������������������������������������Ĵ��
���Parametros� ExpA1 = Array com os custos da MOD                         ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Generico                                                   ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function TTFimComMO(aCusto)
Local nV,nX,aVFim[5],aCM[5],nMultiplic := 1
Local bBloco := { |nV,nX| Trim(nV)+Str(nX,1) }
Local nDec:=Set(3,8)
Local aArea:=GetArea()
If lCusFil .Or. lCusEmp
   //�������������������������������������������������������Ŀ
   //� Posiciona no local a ser atualizado                   �
   //���������������������������������������������������������
   dbSelectArea("TRT")
   If !dbSeek(If(lCusEmp,Space(Len(cFilAnt)),cFilAnt)+SB2->B2_COD)
               CriaTRT(If(lCusEmp,Space(Len(cFilAnt)),cFilAnt),SB2->B2_COD)
   EndIf
   RecLock("TRT",.F.)
   //�������������������������������������������������������Ŀ
   //� Pega o custo do campo e soma o custo da entrada       �
   //���������������������������������������������������������
   If aCusto <> NIL
               //�������������������������������������������������������Ŀ
               //� Pega o custo do campo e soma o custo da entrada       �
               //���������������������������������������������������������
               For nX := 1 to 1
                           // Verifica se moeda devera ser considerada 
                           //If nx # 1 .And. !(Str(nx,1,0) $ cMoeda330C)
               //Loop
                           //EndIf
                           aVfim[nX] := &(Eval(bBloco,"TRT->TRB_VFIM",nX)) + aCusto[nX]
               Next nX
   EndIf
   Replace TRB_VFIM1 With aVFim[01]  
   /*
   //If "2" $ cMoeda330C
               Replace TRB_VFIM2 With aVFim[02]
   //EndIf
   //If "3" $ cMoeda330C
               Replace TRB_VFIM3 With aVFim[03]
   //EndIf
   //If "4" $ cMoeda330C
               Replace TRB_VFIM4 With aVFim[04]
   //EndIf
   //If "5" $ cMoeda330C
               Replace TRB_VFIM5 With aVFim[05]
   //EndIf
   */
   MsUnlock()
EndIf
Set(3,nDec)
RestArea(aArea)
Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �TTFimQtdMO� Autor �Rodrigo de A. Sartorio � Data � 13/11/01 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Atualiza a quantidade final do TRT baseado nos movimentos  ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   � TTFimQtdMO()                                               ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � MATA330                                                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function TTFimQtdMO()
LOCAL nV,nX,aVFim[5],aCM[5],nMultiplic := 1
LOCAL bBloco := { |nV,nX| Trim(nV)+Str(nX,1) }
LOCAL nDec:=Set(3,8)
LOCAL aArea:=GetArea()
If lCusFil .Or. lCusEmp
   //�������������������������������������������������������Ŀ
   //� Posiciona no local a ser atualizado                   �
   //���������������������������������������������������������
   dbSelectArea("TRT")
   If !dbSeek(If(lCusEmp,Space(Len(cFilAnt)),cFilAnt)+SB2->B2_COD)
               CriaTRT(If(lCusEmp,Space(Len(cFilAnt)),cFilAnt),SB2->B2_COD)
   EndIf
   RecLock("TRT",.F.)
   Replace TRB_QFIM  With TRB_QFIM + SB2->B2_QFIM
   aCM[01] := TRB_CM1
   aCM[02] := TRB_CM2
   aCM[03] := TRB_CM3
   aCM[04] := TRB_CM4
   aCM[05] := TRB_CM5
   For nX := 1 to 1
               // Verifica se moeda devera ser considerada 
               //If nx # 1 .And. !(Str(nx,1,0) $ cMoeda330C)
               //Loop
               //EndIf
               //�������������������������������������������������������Ŀ
               //� Pega o custo final do campo correto                   �
               //���������������������������������������������������������
               aVfim[nX] := &(Eval(bBloco,"TRT->TRB_VFIM",nX))
               aCM[nX]   := aVFIM[nX]/ABS(TRB_QFIM)
   Next nX
   Replace TRB_CM1 With aCM[01]
   /*
   //If "2" $ cMoeda330C
               Replace TRB_CM2 With aCM[02]
   //EndIf
   //If "3" $ cMoeda330C
               Replace TRB_CM3 With aCM[03]
   //EndIf
   //If "4" $ cMoeda330C
               Replace TRB_CM4 With aCM[04]
   //EndIf
   //If "5" $ cMoeda330C
               Replace TRB_CM5 With aCM[05]
   //EndIf
   */
   MsUnlock()
EndIf
Set(3,nDec)
RestArea(aArea)
Return
