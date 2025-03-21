#ifdef SPANISH
	#define STR0001 "Detalle de los pedidos por producto"
	#define STR0002 "Este informe emitira el detalle de las ventas por"
	#define STR0003 "orden del producto."
	#define STR0004 "A Rayas"
	#define STR0005 "Administracion"
	#define STR0006 "DETALLE DE LAS VENTAS POR PRODUCTO"
	#define STR0007 "CODIGO          DENOMINACION                              CANTIDAD            CANTIDAD UM            DESCUENTO                 VALOR"
	#define STR0008 "PRODUCTO                                                   VENDIDA           FACTURADA                                         TOTAL"
	#define STR0009 "Seleccionando registros "
	#define STR0010 "ANULADO POR EL OPERADOR"
	#define STR0011 "TOTAL GENERAL: "
	#define STR0012 "Lista de Pedidos por Producto"
	#define STR0013 "Este informe emitira la lista de Ventas por"
	#define STR0014 "orden de Produc."
	#define STR0015 "Produc."
	#define STR0016 "Denominac. "
	#define STR0017 "Ctd.Vendida"
	#define STR0018 "Ctd. Factur."
	#define STR0019 "UM"
	#define STR0020 "Descuen."
	#define STR0021 "Valor Total"
	#define STR0022 "Selecion de Registros "	
	#define STR0023 "Pedidos por Producto"
#else
	#ifdef ENGLISH
		#define STR0001 "List of Orders per Product    "
		#define STR0002 "This report will print the Sales list ordered by"
		#define STR0003 "Product."
		#define STR0004 "Z.Form "
		#define STR0005 "Management   "
		#define STR0006 "LIST OF SALES PER PRODUCT"
		#define STR0007 "CODE            DENOMINATION                              QUANTITY            QUANTITY UM             DISCOUNT                 TOTAL"
		#define STR0008 "PRODUCT                                                     SOLD              INVOICED                                         VALUE"
		#define STR0009 "Selecting Products     "
		#define STR0010 "CANCELLED BY THE OPERATOR  "
		#define STR0011 "G R A N D  T O T A L"
		#define STR0012 "List of orders by product     "
		#define STR0013 "This report will generate the list of sales by   "
		#define STR0014 "order of product."
		#define STR0015 "Product"
		#define STR0016 "Name       "
		#define STR0017 "Qty. sold  "
		#define STR0018 "Qty. billed "
		#define STR0019 "UM"
		#define STR0020 "Discount"
		#define STR0021 "Total amnt."
		#define STR0022 "Selecting records      "	
		#define STR0023 "Orders by product  "
	#else
		Static STR0001 := "Relacao de Pedidos por Produto"
		Static STR0002 := "Este relatorio ira emitir a relacao de Vendas por"
		Static STR0003 := "ordem de Produto."
		Static STR0004 := "Zebrado"
		Static STR0005 := "Administracao"
		Static STR0006 := "RELACAO DE VENDAS POR PRODUTO"
		Static STR0007 := "CODIGO          DENOMINACAO                             QUANTIDADE          QUANTIDADE UN             DESCONTO                 VALOR"
		Static STR0008 := "PRODUTO                                                   VENDIDA            FATURADA                                          TOTAL"
		Static STR0009 := "Selecionando Registros "
		Static STR0010 := "CANCELADO PELO OPERADOR"
		Static STR0011 := "T O T A L  G E R A L : "
		Static STR0012 := "Relacao de Pedidos por Produto"
		Static STR0013 := "Este relatorio ira emitir a relacao de Vendas por"
		Static STR0014 := "ordem de Produto."
		Static STR0015 := "Produto"
		Static STR0016 := "Denominacao"
		Static STR0017 := "Qtd.Vendida"
		Static STR0018 := "Qtd.Faturada"
		Static STR0019 := "UM"
		#define STR0020  "Desconto"
		#define STR0021  "Valor Total"
		Static STR0022 := "Selecionando Registros "	
		Static STR0023 := "Pedidos por Produto"
	#endif
#endif

#ifndef SPANISH
#ifndef ENGLISH
	STATIC uInit := __InitFun()

	Static Function __InitFun()
	uInit := Nil
	If Type('cPaisLoc') == 'C'

		If cPaisLoc == "PTG"
			STR0001 := "Relacao de Pedidos por Artigo"
			STR0002 := "Este relat�rio ir� emitir a rela��o de vendas por"
			STR0003 := "Ordem De Artigo"
			STR0004 := "C�digo de barras"
			STR0005 := "Administra��o"
			STR0006 := "RELA��O DE VENDAS POR ARTIGO"
			STR0007 := "C�digo           Denomina��o                             Quantidade          Quantidade Un             Desconto                 Valor"
			STR0008 := "ARTIGO                                                   VENDIDA            FACTURADA                                          TOTAL"
			STR0009 := "A seleccionar registos "
			STR0010 := "Cancelado Pelo Operador"
			STR0011 := "T O T A L  C R I A L : "
			STR0012 := "Rela��o de Pedidos por Artigo"
			STR0013 := "Este relat�rio ir� emitir a rela��o de vendas por"
			STR0014 := "Ordem De Artigo."
			STR0015 := "Artigo"
			STR0016 := "Denomina��o"
			STR0017 := "Qtd.vendida"
			STR0018 := "Qtd.facturada"
			STR0019 := "Um"
			STR0022 := "Seleccionando registos "	
			STR0023 := "Pedidos Por Artigo"
		EndIf
		EndIf
	Return Nil
#ENDIF
#ENDIF
