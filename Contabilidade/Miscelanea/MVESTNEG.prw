#INCLUDE "PROTHEUS.CH"
/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  �MVESTNEG  � Autor � Carlos Daniel         � Data �08/12/2021���
�������������������������������������������������������������������������Ĵ��
���Locacao   � Ercal            �Contato �                                 ��
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/
User Function MVESTNEG  
// Variaveis Locais da Funcao                             
Local cEdit1	 := GetMv("MV_ESTNEG")
Local cEdit2	 := GetMv("MV_ESTNEG")
Local oEdit1
Local oEdit2
Private _oDlg				// Dialog Principal

DEFINE MSDIALOG _oDlg TITLE "MV_ESTNEG" FROM C(350),C(575) TO C(487),C(721) PIXEL
@ C(007),C(007) Say "Atual N=Fechado   S=Aberto" Size C(055),C(008) COLOR CLR_BLACK PIXEL OF _oDlg
@ C(015),C(007) MsGet oEdit1 Var cEdit1 Size C(060),C(009) COLOR CLR_BLACK WHEN .F. PIXEL OF _oDlg 
@ C(030),C(007) Say "Novo N=Fechado   S=Aberto" Size C(055),C(008) COLOR CLR_BLACK PIXEL OF _oDlg
@ C(037),C(007) MsGet oEdit2 Var cEdit2 Size C(060),C(009) COLOR CLR_BLACK PIXEL OF _oDlg HASBUTTON  
DEFINE SBUTTON FROM C(055),C(007) TYPE 1 ENABLE OF _oDlg ACTION _bOk(cEdit2)
DEFINE SBUTTON FROM C(055),C(040) TYPE 2 ENABLE OF _oDlg ACTION _oDlg:End()
ACTIVATE MSDIALOG _oDlg CENTERED
Return(.T.)

//**************************
Static Function _bOk(cEdit2)
//**************************
_oDlg:End()
PutMv("MV_ESTNEG",cEdit2)
Return

/*������������������������������������������������������������������������������
��������������������������������������������������������������������������������
����������������������������������������������������������������������������Ŀ��
���Programa   �   C()   � Autores � Norbert/Ernani/Mansano � Data �10/05/2005���
����������������������������������������������������������������������������Ĵ��
���Descricao  � Funcao responsavel por manter o Layout independente da       ���
���           � resolucao horizontal do Monitor do Usuario.                  ���
�����������������������������������������������������������������������������ٱ�
��������������������������������������������������������������������������������
������������������������������������������������������������������������������*/
Static Function C(nTam)
Local nHRes	:=	oMainWnd:nClientWidth	// Resolucao horizontal do monitor
If nHRes == 640	// Resolucao 640x480 (soh o Ocean e o Classic aceitam 640)
	nTam *= 0.8
ElseIf (nHRes == 798).Or.(nHRes == 800)	// Resolucao 800x600
	nTam *= 1
Else	// Resolucao 1024x768 e acima
	nTam *= 1.28
EndIf

//���������������������������Ŀ
//�Tratamento para tema "Flat"�
//�����������������������������
If "MP8" $ oApp:cVersion
	If (Alltrim(GetTheme()) == "FLAT") .Or. SetMdiChild()
		nTam *= 0.90
	EndIf
EndIf
Return Int(nTam)
