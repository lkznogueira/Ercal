#INCLUDE "rwmake.ch"
/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �CHKCT2SF1 � Autor � AP6 IDE            � Data �  22/05/15   ���
�������������������������������������������������������������������������͹��
���Descricao � Codigo gerado pelo AP6 IDE.                                ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/
User Function CHKCT2SF1
//���������������������������������������������������������������������Ŀ
//� Declaracao de Variaveis                                             �
//�����������������������������������������������������������������������
Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         := "de acordo com os parametros informados pelo usuario."
Local cDesc3         := ""
Local cPict          := ""
Local titulo       := ""
Local nLin         := 80

Local Cabec1       := ""
Local Cabec2       := ""
Local imprime      := .T.
Local aOrd := {}
Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite           := 132
Private tamanho          := "M"
Private nomeprog         := "CHKCT2SF1" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo            := 18
Private aReturn          := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey        := 0
Private cbtxt      := Space(10)
Private cbcont     := 00
Private CONTFL     := 01
Private m_pag      := 01
Private wnrel      := "CHKCT2SF1" // Coloque aqui o nome do arquivo usado para impressao em disco
Private aErrLog	   := {}
Private cString	:= ""
//���������������������������������������������������������������������Ŀ
//� Monta a interface padrao com o usuario...                           �
//�����������������������������������������������������������������������
wnrel := SetPrint(cString,NomeProg,"",@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,.T.,Tamanho,,.F.)
If nLastKey <> 27
	SetDefault(aReturn,cString)
	If nLastKey <> 27
		MsgRun("Montando SF1TMP, Aguarde...","",{|| CursorWait(), MontaSql() ,CursorArrow()})
		Processa({|| MontaDif() },"Montando Diferencas, Aguarde...")
		nTipo := If(aReturn[4]==1,15,18)
		//���������������������������������������������������������������������Ŀ
		//� Processamento. RPTSTATUS monta janela com a regua de processamento. �
		//�����������������������������������������������������������������������
		If Len(aErrLog) > 0
			RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)
		Else
			MsgAlert("Nao existem dados a serem Impresso","Atencao")
		Endif
		DbSelectArea("SF1TMP")
		DbCloseArea()
	Endif
Endif
Return

/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Fun��o    �RUNREPORT � Autor � AP6 IDE            � Data �  22/05/15   ���
�������������������������������������������������������������������������͹��
���Descri��o � Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS ���
���          � monta a janela com a regua de processamento.               ���
�������������������������������������������������������������������������͹��
���Uso       � Programa principal                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/
Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)
Local nOrdem:=0
Local _cMensg:= ""
Local _nx

SetRegua(Len(aErrLog))
For _nx:=1 to Len(aErrLog)
	IncRegua()
	//���������������������������������������������������������������������Ŀ
	//� Verifica o cancelamento pelo usuario...                             �
	//�����������������������������������������������������������������������
	If lAbortPrint
		@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
		Exit
	Endif
	//���������������������������������������������������������������������Ŀ
	//� Impressao do cabecalho do relatorio. . .                            �
	//�����������������������������������������������������������������������
	If nLin > 60 // Salto de P�gina. Neste caso o formulario tem 55 linhas...
		Cabec1:= 'Relacao de Notas Fiscais nao Contabilizadas"
		nLin := Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		nLin ++
	Endif
	//_cMensg:=StrZero(aErrLog[_nx,3],2)+" ; UPDATE SF1010 SET F1_DTLANC = ' ' WHERE F1_DOC='"+aErrLog[_nx,1]+"' AND F1_SERIE = '"+aErrLog[_nx,2]+"' AND F1_FORNECE = '000844';"
	@nLin,00 PSAY _cMensg
	nLin ++ // Avanca a linha de impressao
Next
//���������������������������������������������������������������������Ŀ
//� Finaliza a execucao do relatorio...                                 �
//�����������������������������������������������������������������������

SET DEVICE TO SCREEN

//���������������������������������������������������������������������Ŀ
//� Se impressao em disco, chama o gerenciador de impressao...          �
//�����������������������������������������������������������������������

If aReturn[5]==1
	dbCommitAll()
	SET PRINTER TO
	OurSpool(wnrel)
Endif

MS_FLUSH()

Return

Static Function MontaSql
Local _cSql := ""
//_cSql := "SELECT F1_DOC,F1_SERIE FROM SF1010 WHERE F1_SERIE = '1  ' AND F1_FORNECE = '000844' AND D_E_L_E_T_ = ' ' AND "
_cSql := "SELECT F1_DOC,F1_SERIE FROM SF1010 WHERE D_E_L_E_T_ <> '*' AND "
_cSql += "F1_EMISSAO BETWEEN '20150101' AND '20150531' ORDER BY F1_DOC,F1_SERIE "
_cSql:=ChangeQuery(_cSql)
dbUseArea(.T., "TOPCONN", TCGenQry(,,_cSql), 'SF1TMP', .F., .T.)
DbGotop()
Return

Static Function MontaDif
Local _cSql := ""
Local _nTotrec := 0
DbSelectArea('SF1TMP')
_nTotrec := Reccount()
ProcRegua(Reccount())
DbGotop()
While !Eof()
	IncProc("Nota "+SF1TMP->F1_DOC)
	_cSql := "SELECT COUNT(*) CTT_CNT FROM CT2010 WHERE CT2_HIST LIKE '%"+SF1TMP->F1_DOC+"/"+SF1TMP->F1_SERIE
	_cSql += "%' AND D_E_L_E_T_ = '  ' AND CT2_MOEDLC = '01' AND CT2_LOTE = '008810' "
	_cSql:=ChangeQuery(_cSql)
	dbUseArea(.T., "TOPCONN", TCGenQry(,,_cSql), 'CT2TMP', .F., .T.)
	If CT2TMP->CTT_CNT < 3
		Aadd(aErrLog,{SF1TMP->F1_DOC,SF1TMP->F1_SERIE,CT2TMP->CTT_CNT})
	Endif
	DbSelectArea("CT2TMP")
	DbCloseArea()
	DbSelectArea("SF1TMP")
	DbSkip()
Enddo
Return
