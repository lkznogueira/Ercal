#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'TBICONN.CH'
#INCLUDE 'TOTVS.CH'
#INCLUDE 'TOPCONN.CH'

#Define MGM             1
#Define CULTIBRAS       2
#Define RIO_BRANCO      3
#Define SCHIPPERS       4
#Define ERCAL           5
#Define CONSUBE         6
#Define MONTEPETRO      7
#Define SOMA_AMBIENTAL  8
#Define CERTRIM         9
#Define PET_SOCIETY     10
#Define MILHAO		    11
#Define RENOVAGRO	    12
#Define NATERCOOP		13
#Define PPF				14
#Define COOPA_DF		15
#Define DEMO			99

/*/{Protheus.doc} CONECT00
// EXPORTA DADOS
@author Lucas Nogueira
/*/

User Function CONECT00() 

    Local cEmp  := "06"
    Local cFil  := "4600"
    Local cArq  := ""

    Local lCliente      := .T.
    Local lProduto      := .F.
    Local lVendedor     := .F.
    Local lPedVenda     := .F.
    Local lContrato     := .F.
    Local lFinanceiro   := .F.
    Local lFiscal       := .F.
    Local lAtivo        := .F.
    Local lTransportes  := .F.
    Local lTabPreco     := .F.
    Local lFreteRB      := .F.
    Local lNotasFiscais := .F.

    Private nIdEmp      := ERCAL

    RESET ENVIRONMENT

    If Select('SX6') == 0
		RpcClearEnv()
		RpcSetType(3)
		PREPARE ENVIRONMENT EMPRESA cEmp FILIAL cFil MODULO 'SIGAFAT'
	Endif

    //Produtos
    If lProduto .Or. "01" $ cArq
        U_CONECT01()
    Endif
 
    //Tabela de Preço
    If lTabPreco .Or. "02" $ cArq
//      U_CONECT02()
        U_CONECT45()
    Endif

    //Itens Tabela de Preço
    If lTabPreco .Or. "03" $ cArq
//      U_CONECT03()
        U_CONECT46()
    Endif

    //Tipos de Produtos
    If lProduto .Or. "04" $ cArq
        U_CONECT04()
    Endif

    //Unidades de medida
    If lProduto .Or. "05" $ cArq
        U_CONECT05()
    Endif

    //Formas de Pagamento (Métodos de Cobrança)
    If lFinanceiro .Or. "06" $ cArq
        U_CONECT06()
    Endif

    //Planos de Pagamento (Condição de Pagamento)
    If lFinanceiro .Or. "07" $ cArq
        U_CONECT07()
    Endif

    //Marcas
    If lProduto .Or. "08" $ cArq
        U_CONECT08()
    Endif

    //Naturezas
    If lFinanceiro .Or. "09" $ cArq
        U_CONECT09()
    Endif

    //Grupo de Produtos
    If lProduto .Or. "10" $ cArq
        U_CONECT10()
    Endif

    //Tipos Endereço
    If lCliente .Or. "11" $ cArq
        U_CONECT11()
    Endif

    //Pessoas
    If lCliente .Or. "12" $ cArq
        U_CONECT12()
    Endif

    //Endereços
    If lCliente .Or. "13" $ cArq
        U_CONECT13()
    Endif

    //E-Mails
    If lVendedor .Or. "14" $ cArq
        U_CONECT14()
    Endif

    //Telefones
    If lVendedor .Or. "15" $ cArq
        U_CONECT15()
    Endif

    //Clientes
    If lCliente .Or. "16" $ cArq
        U_CONECT16()
    Endif

    //Vendedores
    If lVendedor .Or. "17" $ cArq
        U_CONECT17()
    Endif

    //Gerentes
    If lVendedor .Or. "18" $ cArq
        U_CONECT18()
    Endif

    //Supervisor
    If lVendedor .Or. "19" $ cArq
        U_CONECT19()
    Endif

    //Grupo de Tributação
    If lFiscal .Or. "20" $ cArq
        U_CONECT20()
    Endif

    //Tipos de Clientes
    If lCliente .Or. "21" $ cArq
        U_CONECT21()
    Endif

    //Segmentos (Tipos de Atividade)
    If lCliente .Or. "22" $ cArq
        U_CONECT22()
    Endif

    //Regiões
    If lVendedor .Or. "23" $ cArq
        U_CONECT23()
    Endif

    //Tipos de Vendedor
    If lVendedor .Or. "24" $ cArq
        U_CONECT24()
    Endif

    //Endereço de Vendedor
    If lVendedor .Or. "25" $ cArq
        U_CONECT25()
    Endif

    //Pessoas Vendedor
    If lVendedor .Or. "26" $ cArq
        U_CONECT26()
    Endif

    //Clientes + Vendedores Contrato de Parceria
    If lContrato .Or. "27" $ cArq
        U_CONECT27()
    Endif

    //Clientes + Vendedores Pedido de Venda
    If lPedVenda .Or. "28" $ cArq
        U_CONECT28()
    Endif
    
    //Veiculos
    If lTransportes .Or. "29" $ cArq
        U_CONECT29()
    Endif

    //Motorista
    If lTransportes .Or. "30" $ cArq
        U_CONECT30()
    Endif
    
    //Ativos Imobilizados
    If lAtivo .Or. "31" $ cArq
        U_CONECT31()
    Endif
    
    //Transportadora
    If lTransportes .Or. "32" $ cArq
        U_CONECT32()
    Endif

    //Transportadora Pessoa
    If lTransportes .Or. "33" $ cArq
        U_CONECT33()
    Endif
    
    //Transportadora Endereço
    If lTransportes .Or. "34" $ cArq
        U_CONECT34()
    Endif
    
    //Transportadora Telefone
    If lTransportes .Or. "35" $ cArq
        U_CONECT35()
    Endif

    //Transportadora E-mail
    If lTransportes .Or. "36" $ cArq
        U_CONECT36()
    Endif

    //CNAE
    If lCliente .Or. "37" $ cArq
        U_CONECT37()
    Endif

    //Clientes + Vendedores Carteira de clientes
    If lCliente .Or. lVendedor .Or. "38" $ cArq
        U_CONECT38()
    Endif

    //Contrato de Parceria
    If lContrato .Or. "39" $ cArq
        U_CONECT39()
    Endif

    //Itens do Contrato de Parceria
    If lContrato .Or. "40" $ cArq
        U_CONECT40()
    Endif

    //Tabelas de Frete da Rio Branco
    If lFreteRB .And. nIdEmp == RIO_BRANCO
//      U_CONECT41()
//      U_CONECT42()
    Endif

    //Pedido de Venda
    If lPedVenda .Or. "43" $ cArq
        U_CONECT43()
    Endif

    //Itens Pedido de Venda
    If lPedVenda .Or. "44" $ cArq
        U_CONECT44()
    Endif

    //Notas Fiscais
    If lNotasFiscais .Or. "47" $ cArq
        U_CONECT47()
    Endif

    //Itens Notas Fiscais
    If lNotasFiscais .Or. "48" $ cArq
        U_CONECT48()
    Endif

    RESET ENVIRONMENT

Return()
