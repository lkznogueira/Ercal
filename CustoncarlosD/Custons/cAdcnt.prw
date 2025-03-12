#INCLUDE "PROTHEUS.CH"

User Function cAdcnt

//���������������������������������������������������������������������Ŀ
//� Declaracao de Variaveis                                             �
//�����������������������������������������������������������������������
Private aRotina   := MenuDef()
Private bManipula := {|| CADCNT()}
Private cCadastro := "Cadastro CNT"
Private cAlias    := "ZZ6"     

mBrowse( 6, 1,22,75,cAlias,,,,,,)

Return

/*/
���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  � CADCNT   � Autor � Carlos daniel         � Data �00/00/0000���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Utilizacao de Menu Funcional                               ���
���          �                                                            ���
�������������������������������������������������������������������������Ĵ��
���Retorno   � Array com opcoes da rotina                                 ���
�������������������������������������������������������������������������Ĵ��
���Parametros�Array aRotina:                                              ���
���          �                                                            ���
���          �1. Nome a aparecer no cabecalho                             ���
���          �2. Nome da Rotina associada                                 ���
���          �3. Reservado                                                ���
���          �4. Tipo de Transa��o a ser efetuada:                        ���
���          � 	  1 - Pesquisa e Posiciona em um Banco de Dados           ���
���          �    2 - Simplesmente Mostra os Campos                       ���
���          �    3 - Inclui registros no Bancos de Dados                 ���
���          �    4 - Altera o registro corrente                          ���
���          �    5 - Remove o registro corrente do Banco de Dados        ���
���          �5. Nivel de acesso                                          ���
���          �6. Habilita Menu Funcional                                  ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � cAdcnt()                                                   ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function MenuDef()

Private aRotina	:=  {{OemToAnsi("Pesquisar"),"AxPesqui", 0,1,0,.F.},;
{OemToAnsi("Visualizar"),"AxVisual" , 0 , 2,0,nil},;
{OemToAnsi("Incluir")   ,"AxInclui" , 0 , 3,0,nil},;
{OemToAnsi("Alterar")   ,"AxAltera" , 0 , 4,0,.F.},;
{OemToAnsi("Excluir")   ,'AxDeleta', 0 , 5,0,.F.}}

//{OemToAnsi("Excluir")   ,'Eval(bManipula)', 0 , 5,0,.F.}}
Return (aRotina)

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Funcao    �GLTDeleta � Autor �Carlos Daniel          � Data � 00.00.00 ���
�������������������������������������������������������������������������Ĵ��
���Descricao � Funcao para validar a exclusao.                            ���
���          � Verifica se nao existem Veiculos, amarrados ao motorista.  ���
���          �                                                            ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � AGLT001()                                                  ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function CADCNT

Local _cAlias  := "ZZ6"
Local _nOrdZZ6 := ZZ6->(IndexOrd())
Local _nRecZZ6 := ZZ6->(Recno())
Local nOpcao   := AxVisual(_cAlias,_nRecZZ6,5)

//�������������������Ŀ
//�Restaura o Ambiene.�
//���������������������
dbSelectArea(_cAlias)
dbSetOrder(_nOrdZZ6)
dbGoto(_nRecZZ6)

Return()