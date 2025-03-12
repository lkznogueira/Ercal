#INCLUDE "PROTHEUS.CH"

User Function NFEGAR

//���������������������������������������������������������������������Ŀ
//� Declaracao de Variaveis                                             �
//�����������������������������������������������������������������������

Private aRotina   := MenuDef()
Private bManipula := {|| NFDeleta()}
Private cCadastro := "Cadastro de Garantias"
Private cAlias    := "ZZ3"

mBrowse( 6, 1,22,75,cAlias,,,,,,)

Return

/*/
���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  � NFEGAR   � Autor � Carlos daniel         � Data �00/00/0000���
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
��� Uso      � NFEGAR()                                                   ���
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
Static Function NFDeleta

Local _cAlias  := "ZZ3"
Local _nOrdZZ3 := ZZ3->(IndexOrd())
Local _nRecZZ3 := ZZ3->(Recno())
Local nOpcao   := AxVisual(_cAlias,_nRecZZ3,5)

//�������������������Ŀ
//�Restaura o Ambiene.�
//���������������������
dbSelectArea(_cAlias)
dbSetOrder(_nOrdZZ3)
dbGoto(_nRecZZ3)

Return()