#ifdef SPANISH
	#define STR0001 "Informe de comisiones "
	#define STR0002 "Emision del informe de comisiones."
	#define STR0003 "A Rayas"
	#define STR0004 "Administracion"
	#define STR0005 "INFORME DE COMISIONES  "
	#define STR0006 "(PAGO EN LA EMISION)"
	#define STR0007 "(PAGO EN LA CANCELACION)"
	#define STR0008 "INFORME DE COMISIONES "
	#define STR0009 "PRF NUMERO   CUOTA CODIGO                 SC  NOMBRE                               FCH.DE HOY  FECHA       FECHA       FECHA      NUMERO          VALOR           VALOR      %           VALOR    TIPO"
	#define STR0010 "    TITULO         CLIENTE                                                         COMISION    ORIGEN      BAJA        PGTO       PEDIDO         TITULO            BASE               COMISION   COMISION"
	#define STR0011 "ANULADO POR EL OPERADOR"
	#define STR0012 "Vendedor : "
	#define STR0013 "TOTAL DEL VENDEDOR --> "
	#define STR0014 "TOTAL  GENERAL    --> "
	#define STR0015 "TOTAL  DE IR      --> "
	#define STR0016 "Seleccionando registros..."
	#define STR0017 "                      "
	#define STR0018 "AJUSTE"
	#define STR0019 "ANALITICO"
	#define STR0020 "SINTETICO"
	#define STR0021 "CODIGO VENDEDOR                                           TOTAL            TOTAL      %            TOTAL           TOTAL           TOTAL"
	#define STR0022 "                                                         TITULO             BASE                COMISION              IR          (-) IR"
	#define STR0023 "Detalhes : Titulos de origem da liquida��o "
	#define STR0024 "Prefijo    Numero          Cuota   Tipo    Cliente   Tienda  Nombre                                     Valor Titulo      Fecha Liq.        Valor Liquidacion     Valor Base Liq."

	#define STR0025 "Informe de comisiones"
	#define STR0026 "Emision del informe de comisiones."
	#define STR0027 "Total Titulo"
	#define STR0028 "Total IR"
	#define STR0029 "Total (-) IR"
	#define STR0030 "Total Base"
	#define STR0031 "Total Comision"
	#define STR0032 "%"
	#define STR0033 "Vencto Origen"
	#define STR0034 "Fch.Baja"
	#define STR0035 "Vlr Titulo"
	#define STR0036 "Vlr Base"
	#define STR0037 "AJUSTE"
	#define STR0038 "Comision"
	#define STR0039 "Pedido"
	#define STR0040 "Tipo"
	#define STR0041 "por Vendedor"
	#define STR0042 "Titulos Origen de Liquidacion"
	#define STR0043 "Fecha Neta"
	#define STR0044 "Vlr.Neto"
	#define STR0045 "Vlr.Base Neta"
	#define STR0046 "Por Vendedor+Prefijo+Titulo+Cuota"
	#define STR0047 "Por Vendedor+Cliente+Tienda+Prefijo+Titulo+Cuota"
	#define STR0048 "Comisiones(Analitico)"
	#define STR0049 "Comisiones(Sintetico)"
#else
	#ifdef ENGLISH
		#define STR0001 "Report of Commissions "
		#define STR0002 "Issue of Report of Commissions.   "
		#define STR0003 "Z.Form "
		#define STR0004 "Management"
		#define STR0005 "REPORT OF COMMISSIONS"
		#define STR0006 "(PAYM. PER ISSUE)"
		#define STR0007 "(PAYM. PER W.OFF)"
		#define STR0008 "REPORT OF COMMISSIONS"
		#define STR0009 "PRX BILL     INST. CUSTOMER               UN  NAME                                 COMMISSION  MATURITY    DATE OF     PAYMENT    ORDER           VALUE           BASE       %           VALUE    TYPE"
		#define STR0010 "    NUMBER         CODE                                                            BASE DATE   DATE        WRITE-OFF   DATE       NUMBER         OF BILL          VALUE               OF COMM.   OF COMM."
		#define STR0011 "CANCELLED BY THE OPERATOR  "
		#define STR0012 "Representative.: "
		#define STR0013 "TOTAL OF REPRES.  --> "
		#define STR0014 "GRAND TOTAL       --> "
		#define STR0015 "TOTAL IR          --> "
		#define STR0016 "Selecting Records..."
		#define STR0017 "TOTAL (-) IR      --> "
		#define STR0018 "ADJUSTMENT"
		#define STR0019 "DETAILED "
		#define STR0020 "SUMMARIZD"
		#define STR0021 "SALES REPR.CODE                                           TOTAL            TOTAL      %            TOTAL           TOTAL           TOTAL"
		#define STR0022 "                                                         BILL               BASE                COMMISS.              IR          (-) IR"
		#define STR0023 "Details :  Bills of origin of liquidation "
		#define STR0024 "Prefix     Number          Inst    Type    Customer  Store   Name                                       Bill Amount       Liq. Date         Liquidation Amount    Base Liq. Amount"

		#define STR0025 "Commissions report    "
		#define STR0026 "Generation of commissions report. "
		#define STR0027 "Bill total  "
		#define STR0028 "IR total"
		#define STR0029 "Total (-) IR"
		#define STR0030 "Base total"
		#define STR0031 "Commiss. total"
		#define STR0032 "%"
		#define STR0033 "Origin due dt."
		#define STR0034 "Pstng.Dt"
		#define STR0035 "Bill amnt."
		#define STR0036 "Base amn"
		#define STR0037 "ADJ.  "
		#define STR0038 "Commiss."
		#define STR0039 "Order "
		#define STR0040 "Type"
		#define STR0041 "by sales rep"
		#define STR0042 "Liquidation origin bills    "
		#define STR0043 "Liq. date"
		#define STR0044 "Net amnt."
		#define STR0045 "Net base amnt"
		#define STR0046 "By Sales Rep.+Prefix+Bill+Installm."
		#define STR0047 "By Sales Rep.+Customer+Store+Prefix+Bill+Instal."
		#define STR0048 "Commissions (Detailed)"
		#define STR0049 "Commissions (Summari.)"
	#else
		Static STR0001 := "Relatorio de Comiss�es"
		Static STR0002 := "Emissao do relatorio de Comissoes."
		Static STR0003 := "Zebrado"
		Static STR0004 := "Administracao"
		Static STR0005 := "RELATORIO DE COMISSOES "
		Static STR0006 := "(PGTO PELA EMISSAO)"
		Static STR0007 := "(PGTO PELA BAIXA)"
		Static STR0008 := "RELATORIO DE COMISSOES"
		Static STR0009 := "PRF NUMERO   PARC. CODIGO DO              LJ  NOME                                 DT.BASE     VENCTO      DATA        DATA       NUMERO          VALOR           VALOR      %           VALOR    TIPO"
		Static STR0010 := "    TITULO         CLIENTE                                                         COMISSAO    ORIGEM      BAIXA       PAGTO      PEDIDO         TITULO            BASE               COMISSAO   COMISSAO"
		Static STR0011 := "CANCELADO PELO OPERADOR"
		#define STR0012  "Vendedor : "
		Static STR0013 := "TOTAL DO VENDEDOR --> "
		Static STR0014 := "TOTAL  GERAL      --> "
		Static STR0015 := "TOTAL  DE IR      --> "
		Static STR0016 := "Selecionando Registros..."
		Static STR0017 := "TOTAL (-) IR      --> "
		Static STR0018 := "AJUSTE"
		Static STR0019 := "ANALITICO"
		Static STR0020 := "SINTETICO"
		Static STR0021 := "CODIGO VENDEDOR                                           TOTAL            TOTAL      %            TOTAL           TOTAL           TOTAL"
		Static STR0022 := "                                                         TITULO             BASE                COMISSAO              IR          (-) IR"
		Static STR0023 := "Detalhes : Titulos de origem da liquida��o "
		#define STR0024  "Prefixo    Numero          Parc    Tipo    Cliente   Loja    Nome                                       Valor Titulo      Data Liq.         Valor Liquida��o      Valor Base Liq."

		Static STR0025 := "Relatorio de Comiss�es"
		Static STR0026 := "Emissao do relatorio de Comissoes."
		Static STR0027 := "Total Titulo"
		Static STR0028 := "Total IR"
		Static STR0029 := "Total (-) IR"
		#define STR0030  "Total Base"
		Static STR0031 := "Total Comissao"
		#define STR0032  "%"
		Static STR0033 := "Vencto Origem"
		Static STR0034 := "Dt.Baixa"
		Static STR0035 := "Vlr Titulo"
		#define STR0036  "Vlr Base"
		Static STR0037 := "AJUSTE"
		Static STR0038 := "Comissao"
		#define STR0039  "Pedido"
		#define STR0040  "Tipo"
		Static STR0041 := "por Vendedor"
		Static STR0042 := "Titulos Origem da Liquidacao"
		#define STR0043  "Data Liq."
		#define STR0044  "Vlr. Liq."
		Static STR0045 := "Vlr.Base Liq."
		Static STR0046 := "Por Vendedor+Prefixo+Titulo+Parcela"
		Static STR0047 := "Por Vendedor+Cliente+Loja+Prefixo+Titulo+Parcela"
		Static STR0048 := "Comissoes (Analitico)"
		Static STR0049 := "Comissoes (Sintetico)"
		Static STR0050 := "PRF NUMERO   PARC. CODIGO DO              LJ  NOME                                 DT.BASE       %         VALOR         %        VALOR          VALOR           VALOR      %           VALOR    TIPO"
		Static STR0051 := "    TITULO         CLIENTE                    CLIENTE                              COMISSAO     INSS        INSS        IRPF       IRPF         TITULO            BASE               COMISSAO   COMISSAO"
	#endif
#endif

#ifndef SPANISH
#ifndef ENGLISH
	STATIC uInit := __InitFun()

	Static Function __InitFun()
	uInit := Nil
	If Type('cPaisLoc') == 'C'

		If cPaisLoc == "PTG"
			STR0001 := "Relat�rio de comissoes"
			STR0002 := "Emiss�o Do Relat�rio De Comiss�es."
			STR0003 := "C�digo de barras"
			STR0004 := "Administra��o"
			STR0005 := "Relat�rio de comiss�es "
			STR0006 := "(pgt Pela Emiss�o)"
			STR0007 := "(pgt Pela Baixa)"
			STR0008 := "Relat�rio De Comissoes"
			STR0009 := "Prf N�mero   Parc. C�digo  Do              Lj  Nome                                 Dt.base     Vencto      Data        Data       N�mero          Valor           Valor      %           Valor    Tipo"
			STR0010 := "    T�tulo         Cliente                                                         Comiss�o    Origem      Liquida��o       Pgt      Pedido         T�tulo            Base               Comiss�o   Comiss�o"
			STR0011 := "Cancelado Pelo Operador"
			STR0013 := "Total do vendedor --> "
			STR0014 := "Total  crial      --> "
			STR0015 := "Total  de ir      --> "
			STR0016 := "A Seleccionar Registos..."
			STR0017 := "Total (-) ir      --> "
			STR0018 := "Ajuste"
			STR0019 := "Anal�tico"
			STR0020 := "Sint�tico"
			STR0021 := "C�digo Do Vendedor                                           Total            Total      %            Total           Total           Total"
			STR0022 := "                                                         T�tulo             Base                Comiss�o              Ir          (-) Ir"
			STR0023 := "Detalhes : t�tulos de origem da liquida��o "
			STR0025 := "Relat�rio de comissoes"
			STR0026 := "Emiss�o Do Relat�rio De Comiss�es."
			STR0027 := "Total De T�tulo"
			STR0028 := "Total Ir"
			STR0029 := "Total (-) Ir"
			STR0031 := "Total Comiss�o"
			STR0033 := "Vencto De Origem"
			STR0034 := "Dt.levantamento"
			STR0035 := "Vlr De T�tulo"
			STR0037 := "Ajuste"
			STR0038 := "Comiss�o"
			STR0041 := "Por Vendedor"
			STR0042 := "T�tulos Origem Da Liquida��o"
			STR0045 := "Vlr.base Liq."
			STR0046 := "Por Vendedor+prefixo+t�tulo+parcela"
			STR0047 := "Por Vendedor+cliente+loja+prefixo+t�tulo+parcela"
			STR0048 := "Comiss�es (anal�tico)"
			STR0049 := "Comiss�es (sint�tico)"
		EndIf
		EndIf
	Return Nil
#ENDIF
#ENDIF
