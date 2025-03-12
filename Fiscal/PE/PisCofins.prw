#INCLUDE "rwmake.ch"
#INCLUDE "PROTHEUS.CH"
#include "topconn.ch"

#DEFINE CRLF Chr(13)+Chr(10)


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ PisCofinsº Autor ³ Claudio Ferreira   º Data ³  24/05/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Re-Processamento do PIS/COFINS                             º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Microsiga                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/


User Function PisCofins
Private cPerg 		:= "PISCOFINS"
Private aLog:={}

ValidPerg()          // Cria pergunta
if  !pergunte(cPerg,.t.)
	return
endif

Processa({|| ProcPC() },"Aguarde","Processando Documentos ...",.T.)


if len(aLog)>0
    if empty(mv_par17)
	  LogProc("Log do processo",aLog)
	else
      LogProcTXT("Log do processo",aLog,mv_par17)
	endif  
else
	aadd(aLog,'Não foram encontradas inconsistências conforme parametros informados! ')
	LogProc("Log do processo",aLog)
endif


Return

Static Function ProcPC
Local _nTotPis:=0
Local _nTotCof:=0
Local _nBasPis:=0
Local _nBasCof:=0

Local eTotPis:=0
Local eTotCof:=0
Local eBasPis:=0
Local eBasCof:=0
Local eQtdDoc:=0

Local sTotPis:=0
Local sTotCof:=0
Local sBasPis:=0
Local sBasCof:=0
Local sQtdDoc:=0
Local i

Private lAbort:=.f.

cmvpar01:=mv_par01
cmvpar02:=mv_par02
cmvpar03:=mv_par03
cmvpar04:=mv_par04
cmvpar05:=mv_par05
cmvpar06:=mv_par06
cmvpar07:=mv_par07
cmvpar08:=mv_par08
cmvpar09:=mv_par09
cmvpar10:=mv_par10
cmvpar11:=mv_par11
cmvpar12:=mv_par12
cmvpar13:=mv_par13
cmvpar14:=mv_par14
cmvpar16:=mv_par16

// Alianca          LBV      TV Vit  TV Goia         CDA        JM     MELCOM  PEDREIRA   VIAN     VIALUZ  NOVA    ACONOBRE ILUMINATO  COAPIL  CMS     BIONASA  PLANALTO TERMOPOT LOCAGYN  VERSATIL NEWLINE/ NUTRIZA /Manaca/  LactoSul/Suport  /ALDEIA  /Linea    /Milhomix/Uniodonto/DHosp  /Bioline/Milhão  /King    /Fast    /Good    /Montivid/Elba     /SCTECH/WAVE /  VÃO LIVRE/RAYQUIM /Primetek Byblos / Lopac / DF Copac/Loclimp/    Ourolac/Beef     /jbj
cCGC:='02208767/03225684/02089969/03521447/05113990/26651646/74115692/04338716/00052803/01036755/00164699/25127432/26930164/01275639/02447928/01476143/06123299/37021136/03569492/01570529/01584393/08931820/37020260/01378322/05915146/01435507/01154242/05207076/10341756/00891689/08076127/37844479/08647384/07400611/07415082/08186139/02174951/02173151/01437707/05146498/13264891/06906404/07851862/01478932/08791240/14677905/19232679/04865228/14843457/15689716'

if .f. //!Substr(SM0->M0_CGC,1,8)$cCGC
	if cmvpar07=2
		Aviso("Atencao",'Gravação não habilitada',{"Ok"},3)
		cmvpar07:=1 //Somente LOG
		return
	endif
else
	if cmvpar07=2
		//	Aviso("Atencao",'Cópia liberada para para o CNPJ >'+SM0->M0_CGC,{"Ok"},3)
	endif
endif

//if cmvpar08=1
//	Aviso("Atencao",'Opção de Reproc.Livro não está disponivel!',{"Ok"},3)
//endif

if cmvpar07=2
	cAviso:="Efetuando a alteração através desta rotina, poderão ocorrer possíveis diferenças entre a tabela de Livros Fiscais e as Movimentações de Entrada e Saída de NFs acarretando futuros erros na geração de arquivos magnéticos. Recomendamos que esta operação seja realizada excluindo as NFs e incluindo-as novamente através dos ambientes SIGAFAT, SIGACOM ou SIGAFIS. Deseja prosseguir com a correção ?"
	If !Aviso("Atencao",cAviso,{"Sim","Nao"},3) ==1
		return
	Endif
endif


DbSelectArea("SF4") // TES
SF4->( DbSetOrder(1) )

DbSelectArea("SB1") // NF
SB1->( DbSetOrder(1) )

DbSelectArea("SF1") // NF
SF1->( DbSetOrder(1) )

DbSelectArea("SF2") // NF
SF2->( DbSetOrder(1) )

DbSelectArea("SF3") // CABECALHO FISCAL
SF3->( DbSetOrder(4) )

DbSelectArea("SFT") // ITENS FISCAIS
SFT->( DbSetOrder(1) )

_nTotPis:=0
_nTotCof:=0
_nBasPis:=0
_nBasCof:=0

if GetMV("MV_TXPIS")=0
	aadd(aLog,'>> Parametro MV_TXPIS zerado ')
	aadd(aLog,'.')
endif
if GetMV("MV_TXCOFIN")=0
	aadd(aLog,'>> Parametro MV_TXCOFIN zerado ')
	aadd(aLog,'.')
endif

ProcRegua(0) 

aFilsCalc:={}
if mv_par15 = 1
	aFilsCalc	:= MatFilCalc(.t.)
else
	Aadd(aFilsCalc,{.t.,cFilAnt})	
endif

For i:=1 to len(aFilsCalc)
	If aFilsCalc[i,1] .and. (cmvpar06=1 .or. cmvpar06=3) //Entradas
	    cFilAnt:=aFilsCalc[i,2]
		IncProc("Processando Entradas...")
		aadd(aLog,'Entradas filial '+cFilAnt)
		// CORRECAO NOS ITENS NF. ENTRADA
		DbSelectArea("SD1")
		DbSetOrder(6)
		DbSeek(xFilial("SD1")+Dtos(cmvpar04),.t.)
		cDocSer:=' '
		cEspecie:=''
		Do While !SD1->( Eof() )  .and. SD1->D1_DTDIGIT<=cmvpar05 .and. SD1->D1_FILIAL=xFilial('SD1')
			IncProc("Entradas... "+cFilAnt+"-"+Dtoc(SD1->D1_DTDIGIT)+" >>> "+ SD1->(D1_SERIE+'/'+D1_DOC))
			
			If lAbort
				aadd(aLog,'.')
				aadd(aLog,'.')
				aadd(aLog,'*** CANCELADO PELO OPERADOR ***')
				Exit
			Endif
			
			
			if SD1->D1_TIPO$'P/I'
				SD1->( DbSkip() )
				loop
			endif
			
			if cmvpar10=1
				if !(Alltrim(SD1->D1_CF)$cmvpar01 .and. iif(Empty(cmvpar02),.t.,Alltrim(SD1->D1_CC)$cmvpar02))
					SD1->( DbSkip() )
					loop
				endif
			endif 
			
			if !empty(cmvpar16)
			  if !VerProc('1',cmvpar16,SD1->D1_DOC,SD1->D1_SERIE,SD1->D1_FORNECE,SD1->D1_LOJA) 
			     cDocSer:=SD1->(D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA)
			     While cDocSer==SD1->(D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA) 
			       SD1->( DbSkip() )  
			     enddo 
			     loop
			  endif
			endif
			
			aRetProc:={'1',.t.,cmvpar13,cmvpar14}
			If ExistBlock("PCPROCES")
	      		aRetProc:=ExecBlock("PCPROCES",.F.,.F.,aRetProc)
			else
			  aRetProc:={.t.,cmvpar13,cmvpar14}	  
        	endif 
			
			if !aRetProc[1]
				SD1->( DbSkip() )
				loop
			endif 
			
			//Posiciona SB1
			SB1->(MsSeek(xFilial("SB1")+SD1->D1_COD))
			//Posiciona SF4
			SF4->(MsSeek(xFilial("SF4")+SD1->D1_TES))
			//Posiciona SF1
			if !SF1->(MsSeek(xFilial("SF1")+SD1->D1_DOC+SD1->D1_SERIE+SD1->D1_FORNECE+SD1->D1_LOJA+SD1->D1_TIPO))
				aadd(aLog,'NFE Não encontrada Doc: '+SD1->(D1_SERIE+'/'+D1_DOC+' - '+SD1->D1_FORNECE+'/'+SD1->D1_LOJA+' '+Posicione("SA2",1,xFilial("SA2")+SD1->(D1_FORNECE+SD1->D1_LOJA),"A2_NOME")))
				SD1->( DbSkip() )
				loop
			endif
			//Posiciona Cliente/Fornecedor
			if SD1->D1_TIPO$'DB'
				SA1->(MsSeek(xFilial("SA1")+SD1->(D1_FORNECE+D1_LOJA)))
			else
				SA2->(MsSeek(xFilial("SA2")+SD1->(D1_FORNECE+D1_LOJA)))
			endif
			
			
			if Alltrim(SD1->D1_CF)$cmvpar01 .and. iif(Empty(cmvpar02),.t.,Alltrim(SD1->D1_CC)$cmvpar02)
				//Analisa TES
				cTes:=MaTesInt(1,cmvpar03,SD1->D1_FORNECE,SD1->D1_LOJA,iif(SD1->D1_TIPO$'DB','C','F'),SD1->D1_COD)
				if !empty(cTes) .and. cTes <> SD1->D1_TES
					if cDocSer<>SD1->(D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA)
						aadd(aLog,replicate('-',132))
						aadd(aLog,'NFE Doc: '+SD1->(D1_SERIE+'/'+D1_DOC+' - '+SD1->D1_FORNECE+'/'+SD1->D1_LOJA+' '+Posicione("SA2",1,xFilial("SA2")+SD1->(D1_FORNECE+SD1->D1_LOJA),"A2_NOME")))
						cDocSer:=SD1->(D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA)
					endif
					aadd(aLog,'>> IT:'+SD1->D1_ITEM+' Divergência de TES - Atual: '+SD1->D1_TES+' Correta: '+cTes)
					if cmvpar07=2
						SD1->( RecLock("SD1",.F.) )
						SD1->D1_TES := cTes
						SD1->( DbUnLock() )
					endif
					//Posiciona SF4
					SF4->(MsSeek(xFilial("SF4")+cTes))
				endif
			endif
			
			//Analisa NF Serviços
			lIss:=SF4->F4_ISS='S' .or. (SD1->(D1_VALISS+SF1->(F1_VALPIS+F1_VALCOFI)+D1_VALIRR)>0) .or. (SF1->F1_ESPECIE$'NFS  /RPS  /NFPS /SPED ')
			
			//Somente com direito a Credito
			lPIS := SF4->F4_PISCOF $ '1/2/3' .and. SF4->F4_PISCRED $ '1/4'
			
			lExistSF3:=ExistSF3()
			if lIss .and. lPIS
				lLog:=(SF4->F4_ISS<>'S' .and. SD1->D1_VALISS>0 )  .or.  (!SF1->F1_ESPECIE$'NFS  /RPS  /NFPS /SPED '.and. SD1->D1_ITEM='0001') .or. (SF4->F4_LFISS='N') .or. (!lExistSF3)
				if lLog .and. cDocSer<>SD1->(D1_DOC+D1_SERIE)
					aadd(aLog,replicate('-',132))
					aadd(aLog,'NFPS Doc: '+SD1->(D1_SERIE+'/'+D1_DOC+' - '+SD1->D1_FORNECE+'/'+SD1->D1_LOJA+' '+Posicione("SA2",1,xFilial("SA2")+SD1->(D1_FORNECE+SD1->D1_LOJA),"A2_NOME")))
					cDocSer:=SD1->(D1_DOC+D1_SERIE)
				endif
				if SF4->F4_ISS<>'S' .and. SD1->D1_VALISS>0
					cMsg:='>> TES não calcula ISS (Calculo ISS): '+SF4->F4_CODIGO
					if aScan(aLog, {|x|  x $ cMsg  } )=0
						aadd(aLog,cMsg)
					endif
				endif
				if !SF1->F1_ESPECIE$'NFS  /RPS  /NFPS /SPED ' .and. SD1->D1_ITEM='0001'
					aadd(aLog,'>> Especie inválida para serviços Atual: '+AllTrim(SF1->F1_ESPECIE)+' Correta: '+'NFS/RPS/NFPS/SPED')
					cEspecie:='NFS'
				endif
				if  SF4->F4_LFISS='N'
					cMsg:='>> TES não gera livro de serviços (LFiscal ISS): '+SF4->F4_CODIGO
					if aScan(aLog, {|x|  x $ cMsg  } )=0
						aadd(aLog,cMsg)
					endif
				endif
				if !lExistSF3
					cMsg:='>> '+SD1->(D1_SERIE+'/'+D1_DOC)+' Livro de serviços não encontrado > Reprocessar documento'
					if aScan(aLog, {|x|  x $ cMsg  } )=0
						aadd(aLog,cMsg)
					endif
				endif
			endif
			
			//Verifica SFT para campos cadastrais
			lExistSFT:=SFT->(dbSeek(xFilial("SFT")+"E"+SD1->D1_SERIE+SD1->D1_DOC+SD1->D1_FORNECE+SD1->D1_LOJA+SD1->D1_ITEM+SD1->D1_COD))
			
			if lExistSFT
				//Analisa Frete
				lFrete:=substr(SFT->FT_CFOP,2,2)='35'
				
				//Analisa Especies da NF
				lLog:=(!SFT->FT_ESPECIE$'NFCEE' .and. substr(SFT->FT_CFOP,2,2)='25')  .or.  (!SFT->FT_ESPECIE$'CA   /CTR  /NFST /CTE  ' .and. substr(SFT->FT_CFOP,2,2)='35') .or. (!SFT->FT_ESPECIE$'NFSC /NTSC /NTST ' .and. substr(SFT->FT_CFOP,2,2)='30')
				if lLog .and. cDocSer<>SD1->(D1_DOC+D1_SERIE)
					aadd(aLog,replicate('-',132))
					aadd(aLog,'NFE Doc: '+SD1->(D1_SERIE+'/'+D1_DOC+' - '+SD1->D1_FORNECE+'/'+SD1->D1_LOJA+' '+Posicione("SA2",1,xFilial("SA2")+SD1->(D1_FORNECE+SD1->D1_LOJA),"A2_NOME")))
					cDocSer:=SD1->(D1_DOC+D1_SERIE)
				endif
				//Energia Eletrica
				if !SFT->FT_ESPECIE$'NFCEE' .and. substr(SFT->FT_CFOP,2,2)='25'
					aadd(aLog,'>> Especie inválida para CFOP Energia Eletrica Atual: '+AllTrim(SFT->FT_ESPECIE)+' Correta: '+'NFCEE')
					cEspecie:='NFCEE'
				endif
				//Transporte
				if !SFT->FT_ESPECIE$'CA   /CTR  /NFST /CTE  ' .and. substr(SFT->FT_CFOP,2,2)='35'
					aadd(aLog,'>> Especie inválida para CFOP de Transporte Atual: '+AllTrim(SFT->FT_ESPECIE)+' Correta: '+'CTR /NFST /CTE  /CA   ')
					cEspecie:='CTR'
				endif
				//Comunicação
				if !SFT->FT_ESPECIE$'NFSC /NTSC /NTST ' .and. substr(SFT->FT_CFOP,2,2)='30'
					aadd(aLog,'>> Especie inválida para CFOP de Comunicação Atual: '+AllTrim(SFT->FT_ESPECIE)+' Correta: '+'NFSC /NTSC /NTST ')
					cEspecie:='NFSC'
				endif
			else
				if  SF4->F4_LFICM<>'N'
					if cDocSer<>SD1->(D1_DOC+D1_SERIE)
						aadd(aLog,replicate('-',132))
						aadd(aLog,'NFE Doc: '+SD1->(D1_SERIE+'/'+D1_DOC+' - '+SD1->D1_FORNECE+'/'+SD1->D1_LOJA+' '+Posicione("SA2",1,xFilial("SA2")+SD1->(D1_FORNECE+SD1->D1_LOJA),"A2_NOME")))
						cDocSer:=SD1->(D1_DOC+D1_SERIE)
					endif
					cMsg:='>> Documento não consta no livro fiscal! '
					aadd(aLog,cMsg)
				endif
			endif
			
			if lExistSFT .and. cmvpar09=1  //PisCofins
				lLog:=(SF4->F4_INDNTFR<>SFT->FT_INDNTFR) .OR. (lFrete .and. empty(SF4->F4_INDNTFR)) .OR. (SF4->F4_CODBCC<>SFT->FT_CODBCC) .OR. (SF4->F4_CSTPIS<>SFT->FT_CSTPIS) .OR. (SF4->F4_CSTCOF<>SFT->FT_CSTCOF) .OR. ;
				(SF4->F4_PISCRED = '1' .and. (SF4->F4_CSTPIS<'50' .or. SF4->F4_CSTPIS>'67')) .OR. ;
				(SF4->F4_PISCRED = '1' .and. (SF4->F4_CSTCOF<'50' .or. SF4->F4_CSTCOF>'67')) .OR. ;
				(SF4->F4_PISCRED = '3' .and. (SF4->F4_CSTPIS<'70' .or. SF4->F4_CSTPIS='73')) .OR. ;
				(SF4->F4_PISCRED = '3' .and. (SF4->F4_CSTCOF<'70' .or. SF4->F4_CSTCOF='73')) .OR. ;
				(SF4->F4_PISCRED = '4' .and. SF4->F4_CSTPIS<>'73') .OR. ;
				(SF4->F4_PISCRED = '4' .and. SF4->F4_CSTCOF<>'73') .OR. ;
				(!SD1->D1_TIPO$'DB' .and. SA2->A2_SIMPNAC='1' .and. lPIS)
				
				if lLog .and. cDocSer<>SD1->(D1_DOC+D1_SERIE)
					aadd(aLog,replicate('-',132))
					aadd(aLog,'NFE Doc: '+SD1->(D1_SERIE+'/'+D1_DOC+' - '+SD1->D1_FORNECE+'/'+SD1->D1_LOJA+' '+Posicione("SA2",1,xFilial("SA2")+SD1->(D1_FORNECE+SD1->D1_LOJA),"A2_NOME")))
					cDocSer:=SD1->(D1_DOC+D1_SERIE)
				endif
				
				//Entrada geradora de Credito
				if SF4->F4_PISCRED = '1' .and. (SF4->F4_CSTPIS<'50' .or. SF4->F4_CSTPIS>'67')
					aadd(aLog,'>> IT:'+SD1->D1_ITEM+' TES: '+SF4->F4_CODIGO+' CST Pis inválido Atual: '+AllTrim(SF4->F4_CSTPIS)+' Correta: 50 a 67')
				endif
				if SF4->F4_PISCRED = '1' .and. (SF4->F4_CSTCOF<'50' .or. SF4->F4_CSTCOF>'67')
					aadd(aLog,'>> IT:'+SD1->D1_ITEM+' TES: '+SF4->F4_CODIGO+' CST Cofins inválido Atual: '+AllTrim(SF4->F4_CSTCOF)+' Correta: 50 a 67')
				endif
				
				//Entrada nao geradora de Credito
				if SF4->F4_PISCRED = '3' .and. (SF4->F4_CSTPIS<'70' .or. SF4->F4_CSTPIS='73')
					aadd(aLog,'>> IT:'+SD1->D1_ITEM+' TES: '+SF4->F4_CODIGO+' CST Pis inválido Atual: '+AllTrim(SF4->F4_CSTPIS)+' Correta: >= 70 e dif 73')
				endif
				if SF4->F4_PISCRED = '3' .and. (SF4->F4_CSTCOF<'70' .or. SF4->F4_CSTCOF='73')
					aadd(aLog,'>> IT:'+SD1->D1_ITEM+' TES: '+SF4->F4_CODIGO+' CST Cofins inválido Atual: '+AllTrim(SF4->F4_CSTCOF)+' Correta: >= 70 e dif 73')
				endif
				
				//Entrada aquisição a alíquota zero
				if SF4->F4_PISCRED = '4' .and. SF4->F4_CSTPIS<>'73'
					aadd(aLog,'>> IT:'+SD1->D1_ITEM+' TES: '+SF4->F4_CODIGO+' CST Pis inválido Atual: '+AllTrim(SF4->F4_CSTPIS)+' Correta: 73')
				endif
				if SF4->F4_PISCRED = '4' .and. SF4->F4_CSTCOF<>'73'
					aadd(aLog,'>> IT:'+SD1->D1_ITEM+' TES: '+SF4->F4_CODIGO+' CST Cofins inválido Atual: '+AllTrim(SF4->F4_CSTCOF)+' Correta: 73')
				endif
				
				//Fornecedor Simples Nacional
				if !SD1->D1_TIPO$'DB' .and. SA2->A2_TIPO='F' .and. lPIS
					aadd(aLog,'>> Credito indevido. Fornecedor Pessoa Fisica.')
				endif
				lNatFre:=.f.
				lCodBcc:=.f.
				lCSTPIS:=.f.
				lCSTCOF:=.f.
				if SF4->F4_INDNTFR<>SFT->FT_INDNTFR
					aadd(aLog,'>> IT:'+SD1->D1_ITEM+' TES: '+SF4->F4_CODIGO+' SFT: Indicador Nat.Frete divergente Atual: '+AllTrim(SFT->FT_INDNTFR)+' Correta: '+SF4->F4_INDNTFR)
					cNatFre:=SF4->F4_INDNTFR
					lNatFre:=.t.
				endif
				if lFrete .and. empty(SF4->F4_INDNTFR)
					aadd(aLog,'>> IT:'+SD1->D1_ITEM+' TES: '+SF4->F4_CODIGO+' Indicador da Natureza do Frete não informado.')
				endif
				if SF4->F4_CODBCC<>SFT->FT_CODBCC
					aadd(aLog,'>> IT:'+SD1->D1_ITEM+' TES: '+SF4->F4_CODIGO+' SFT: Cod Base Cred divergente Atual: '+AllTrim(SFT->FT_CODBCC)+' Correta: '+SF4->F4_CODBCC)
					cCodBcc:=SF4->F4_CODBCC
					lCodBcc:=.t.
				endif
				if SF4->F4_CSTPIS<>SFT->FT_CSTPIS
					aadd(aLog,'>> IT:'+SD1->D1_ITEM+' TES: '+SF4->F4_CODIGO+' SFT: CST Pis divergente Atual: '+AllTrim(SFT->FT_CSTPIS)+' Correta: '+SF4->F4_CSTPIS)
					cCSTPIS:=SF4->F4_CSTPIS
					lCSTPIS:=.t.
				endif
				if SF4->F4_CSTCOF<>SFT->FT_CSTCOF
					aadd(aLog,'>> IT:'+SD1->D1_ITEM+' TES: '+SF4->F4_CODIGO+' SFT: CST Cofins divergente Atual: '+AllTrim(SFT->FT_CSTCOF)+' Correta: '+SF4->F4_CSTCOF)
					cCSTCOF:=SF4->F4_CSTCOF
					lCSTCOF:=.t.
				endif
				if cmvpar07=2
					RecLock('SFT',.F.)
					if lNatFre
						SFT->FT_INDNTFR := cNatFre
					endif
					if lCodBcc
						SFT->FT_CODBCC :=  cCodBcc
					endif
					if lCSTPIS
						SFT->FT_CSTPIS :=  cCSTPIS
					endif
					if lCSTCOF
						SFT->FT_CSTCOF :=  cCSTCOF
					endif
					SFT->( DbUnLock() )
				endif
			endif
						
			
			//Atualiza Pis/Cofins
			aImp:=AtuPCIt(@cDocSer,@aLog,aRetProc[2],aRetProc[3])
			_nTotPis+=aImp[1]
			_nTotCof+=aImp[2]
			_nBasPis+=aImp[3]
			_nBasCof+=aImp[4]
			
			if lExistSFT .and. cmvpar09=1  .and. cmvpar11=2 //PisCofins
				if cmvpar07=2
					RecLock('SFT',.F.)
					if !empty(cEspecie) .and. SFT->FT_ESPECIE <>cEspecie
						SFT->FT_ESPECIE := cEspecie
					endif
					SFT->FT_VALPIS  := aImp[1]
					SFT->FT_VALCOF  := aImp[2]
					SFT->FT_BASEPIS := aImp[3]
					SFT->FT_BASECOF := aImp[4]
					SFT->FT_ALIQPIS := aImp[5]
					SFT->FT_ALIQCOF := aImp[6]
					SFT->( DbUnLock() )
				endif
			endif
			
			DbSelectArea("SD1")
			SD1->( DbSkip() )
			if !empty(cDocSer) .and. cDocSer<>SD1->(D1_DOC+D1_SERIE)
				eTotPis+=_nTotPis
				eTotCof+=_nTotCof
				eBasPis+=_nBasPis
				eBasCof+=_nBasCof
				eQtdDoc++
				if cmvpar07=2 .and. cmvpar11=2
					SF1->( RecLock("SF1",.F.) )
					SF1->F1_VALIMP6 := _nTotPis
					SF1->F1_VALIMP5 := _nTotCof
					SF1->F1_BASIMP6 := _nBasPis
					SF1->F1_BASIMP5 := _nBasCof
					if !empty(cEspecie) .and. SF1->F1_ESPECIE <>cEspecie
						SF1->F1_ESPECIE := cEspecie
					endif
					SF1->( DbUnLock() )
					
					if cmvpar08=1 //reprocessa livros
						aPergA930={}
						aAdd(aPergA930,Dtoc(SF1->F1_DTDIGIT))
						aAdd(aPergA930,Dtoc(SF1->F1_DTDIGIT))
						aAdd(aPergA930,2)
						aAdd(aPergA930,SF1->F1_DOC)
						aAdd(aPergA930,SF1->F1_DOC)
						aAdd(aPergA930,SF1->F1_SERIE)
						aAdd(aPergA930,SF1->F1_SERIE)
						aAdd(aPergA930,'')
						aAdd(aPergA930,'ZZZZZZZ')
						aAdd(aPergA930,'')
						aAdd(aPergA930,'ZZZZZZZ')
						aAdd(aPergA930,SF1->F1_FILIAL)
						aAdd(aPergA930,SF1->F1_FILIAL)	
						aAdd(aPergA930,'2')	
						aAdd(aPergA930,'2')												
						aArea:=GetArea()
						aAreaSM0:=SM0->(GetArea())
						MATA930(.T.,aPergA930)//Reprocessamento automático
						RestArea(aArea)
						SM0->(RestArea(aAreaSM0))
					endif
				endif
				_nTotPis:=0
				_nTotCof:=0
				_nBasPis:=0
				_nBasCof:=0
				cEspecie:=''
			endif
		Enddo
	Endif
	
	_nTotPis:=0
	_nTotCof:=0
	_nBasPis:=0
	_nBasCof:=0
	
	If aFilsCalc[i,1] .and. (cmvpar06=2 .or. cmvpar06=3) //Saidas
	    cFilAnt:=aFilsCalc[i,2]
		IncProc("Processando Saidas...")
		aadd(aLog,'Saidas filial '+cFilAnt)
		// CORRECAO NOS ITENS NF. SAIDA
		DbSelectArea("SD2")
		DbSetOrder(5)
		DbSeek(xFilial("SD2")+Dtos(cmvpar04),.t.)
		cDocSer:=' '
		cEspecie:=''
		Do While !SD2->( Eof() )  .and. SD2->D2_EMISSAO<=cmvpar05 .and. SD2->D2_FILIAL=xFilial('SD2')
			IncProc("Saidas... "+cFilAnt+"-"+Dtoc(SD2->D2_EMISSAO)+" >>> "+SD2->(D2_SERIE+'/'+D2_DOC))
			
			if SD2->D2_TIPO$'P/I'
				SD2->( DbSkip() )
				loop
			endif
			
			if cmvpar10=1
				if !(Alltrim(SD2->D2_CF)$cmvpar01)
					SD2->( DbSkip() )
					loop
				endif
			endif 
			if !empty(cmvpar16)
			  if !VerProc('2',cmvpar16,SD2->D2_DOC,SD2->D2_SERIE,SD2->D2_CLIENTE,SD2->D2_LOJA) 
			     cDocSer:=SD2->(D2_DOC+D2_SERIE)
			     While cDocSer==SD2->(D2_DOC+D2_SERIE) 
			       SD2->( DbSkip() )  
			     enddo 
			     loop
			  endif
			endif
			
			aRetProc:={'2',.t.,cmvpar13,cmvpar14}
			If ExistBlock("PCPROCES")
	      		aRetProc:=ExecBlock("PCPROCES",.F.,.F.,aRetProc)
			else
			  aRetProc:={.t.,cmvpar13,cmvpar14}	 				  
        	endif 
			
			if !aRetProc[1]
				SD2->( DbSkip() )
				loop
			endif
			
			//Posiciona SB1
			SB1->(MsSeek(xFilial("SB1")+SD2->D2_COD))
			//Posiciona SF4
			SF4->(MsSeek(xFilial("SF4")+SD2->D2_TES))
			//Posiciona SF2
			SF2->(MsSeek(xFilial("SF2")+SD2->D2_DOC+SD2->D2_SERIE))
			
			if Alltrim(SD2->D2_CF)$cmvpar01
				//Analisa TES
				cTes:=MaTesInt(2,cmvpar03,SD2->D2_CLIENTE,SD2->D2_LOJA,iif(SD2->D2_TIPO$'DB','F','C'),SD2->D2_COD)
				if !empty(cTes) .and. cTes <> SD2->D2_TES
					if cDocSer<>SD2->(D2_DOC+D2_SERIE)
						cRazao:=iif(!SD2->D2_TIPO$'DB',Posicione("SA1",1,xFilial("SA1")+SD2->(D2_CLIENTE+SD2->D2_LOJA),"A1_NOME"),Posicione("SA2",1,xFilial("SA2")+SD2->(D2_CLIENTE+SD2->D2_LOJA),"A2_NOME"))
						aadd(aLog,replicate('-',132))
						aadd(aLog,'NFS Doc: '+SD2->(D2_SERIE+'/'+D2_DOC+' - '+SD2->D2_CLIENTE+'/'+SD2->D2_LOJA+' '+cRazao))
						cDocSer:=SD2->(D2_DOC+D2_SERIE)
					endif
					aadd(aLog,'>> IT:'+SD2->D2_ITEM+' Divergência de TES - Atual: '+SD2->D2_TES+' Correta: '+cTes)
					//Posiciona SF4
					SF4->(MsSeek(xFilial("SF4")+cTes))
					if cmvpar07=2
						SD2->( RecLock("SD2",.F.) )
						SD2->D2_TES := cTes
						SD2->D2_CF  := SF4->F4_CF
						SD2->( DbUnLock() )
					endif
				endif
			endif
			
			
			//Analisa NF Serviços
			/*
			lIss:=SF4->F4_ISS='S' .or. (SD1->(D1_VALISS+SF1->(F1_VALPIS+F1_VALCOFI)+D1_VALIRR)>0) .or. (SF1->F1_ESPECIE$'NFS  /RPS  /NFPS ')
			lExistSF3:=ExistSF3()
			if lIss
			lLog:=(SF4->F4_ISS<>'S' .and. SD1->D1_VALISS>0 )  .or.  (!SF1->F1_ESPECIE$'NFS  /RPS  /NFPS '.and. SD1->D1_ITEM='0001') .or. (SF4->F4_LFISS='N') .or. (!lExistSF3)
			if lLog .and. cDocSer<>SD1->(D1_DOC+D1_SERIE)
			aadd(aLog,'Doc: '+SD1->(D1_SERIE+'/'+D1_DOC+' - '+SD1->D1_FORNECE+'/'+SD1->D1_LOJA+' '+Posicione("SA2",1,xFilial("SA2")+SD1->(D1_FORNECE+SD1->D1_LOJA),"A2_NOME")))
			cDocSer:=SD1->(D1_DOC+D1_SERIE)
			endif
			if SF4->F4_ISS<>'S' .and. SD1->D1_VALISS>0
			aadd(aLog,'>> TES não calcula ISS (Calculo ISS): '+SD1->D1_TES)
			endif
			if !SF1->F1_ESPECIE$'NFS  /RPS  /NFPS ' .and. SD1->D1_ITEM='0001'
			aadd(aLog,'>> Especie inválida para serviços Atual: '+AllTrim(SF1->F1_ESPECIE)+' Correta: '+'NFS/RPS/NFPS')
			cEspecie:='NFPS'
			endif
			if  SF4->F4_LFISS='N'
			aadd(aLog,'>> TES não gera livro de serviços (LFiscal ISS): '+SD1->D1_TES)
			endif
			if !lExistSF3
			aadd(aLog,'>> Livro de serviços não encontrado: '+SD1->D1_TES+ ' > Reprocessar documento')
			endif
			endif
			*/
			
			//Verifica SFT para campos cadastrais
			lExistSFT:=SFT->(dbSeek(xFilial("SFT")+"S"+SD2->D2_SERIE+SD2->D2_DOC+SD2->D2_CLIENTE+SD2->D2_LOJA+PADR(SD2->D2_ITEM,4)+SD2->D2_COD))
			if lExistSFT .and. cmvpar09=1  //PisCofins
				
				//Tabelas CST x Natureza Receita
				aTabela:={;
				{'02','4310'},;
				{'04','4310'},;
				{'05','4312'},;
				{'03','4311'},;
				{'06','4313'},;
				{'07','4314'},;
				{'08','4315'},;
				{'09','4316'};
				}
				cTab:=''
				cCST:=''
				nPos:=aScan(aTabela, {|x|  x[1] == SF4->F4_CSTPIS  } )
				if nPos>0
					cTab := aTabela[nPos][2]
					cCST:=SF4->F4_CSTPIS
				endif
				if empty(cTab)
					nPos:=aScan(aTabela, {|x|  x[1] == SF4->F4_CSTCOF  } )
					if nPos>0
						cTab := aTabela[nPos][2]
						cCST:=SF4->F4_CSTCOF
					endif
				endif
				
				lLog:=(SF4->F4_CSTPIS<>SFT->FT_CSTPIS) .OR. (SF4->F4_CSTCOF<>SFT->FT_CSTCOF) .or. ;
				(SF4->F4_PISCRED = '2' .and. !SF4->F4_CSTPIS$'01/02/03') .or. (SF4->F4_PISCRED = '2' .and. !SF4->F4_CSTCOF$'01/02/03') .or. ;
				(SF4->F4_PISCRED = '4' .and. !SF4->F4_CSTPIS$'06/04') .or. (SF4->F4_PISCRED = '4' .and. !SF4->F4_CSTCOF$'06/04') .or. ;
				(SF4->F4_PISCRED = '3' .and. !SF4->F4_CSTPIS$'07/08/09') .or. (SF4->F4_PISCRED = '3' .and. !SF4->F4_CSTCOF$'07/08/09/49') .or. ;
				((SF4->F4_DUPLIC = 'S' .and. (SF4->F4_CSTPIS$'02/03/04/06/07/08/09' .or. SF4->F4_CSTCOF$'02/03/04/06/07/08/09')) .and. (Empty(SB1->B1_TNATREC) .or. Empty(SB1->B1_CNATREC))) .or. ;
				((SF4->F4_DUPLIC = 'S' .and. (SF4->F4_CSTPIS$'02/03/04/06/07/08/09' .or. SF4->F4_CSTCOF$'02/03/04/06/07/08/09')) .and. !Empty(SB1->B1_TNATREC) .and. SB1->B1_TNATREC<>cTab) .or. ;
				(cmvpar12=1.and.SF4->F4_DUPLIC = 'S' .and. (!SB5->(DbSeek(xFilial('SB5')+SD2->D2_COD)))) .or. ;
				(!Empty(SB1->B1_TNATREC) .and. (SFT->FT_TNATREC<>SB1->B1_TNATREC .or. SFT->FT_CNATREC<>SB1->B1_CNATREC ))
				
				if lLog .and. cDocSer<>SD2->(D2_DOC+D2_SERIE)
					cRazao:=iif(!SD2->D2_TIPO$'DB',Posicione("SA1",1,xFilial("SA1")+SD2->(D2_CLIENTE+SD2->D2_LOJA),"A1_NOME"),Posicione("SA2",1,xFilial("SA2")+SD2->(D2_CLIENTE+SD2->D2_LOJA),"A2_NOME"))
					aadd(aLog,replicate('-',132))
					aadd(aLog,'NFS Doc: '+SD2->(D2_SERIE+'/'+D2_DOC+' - '+SD2->D2_CLIENTE+'/'+SD2->D2_LOJA+' '+cRazao))
					cDocSer:=SD2->(D2_DOC+D2_SERIE)
				endif
				
				//Saidas Tributadas
				if SF4->F4_PISCRED = '2' .and. !SF4->F4_CSTPIS$'01/02/03'
					aadd(aLog,'>> IT:'+SD2->D2_ITEM+' TES: '+SF4->F4_CODIGO+' CST Pis inválido Atual: '+AllTrim(SF4->F4_CSTPIS)+' Correta: (01/02/03)')
				endif
				if SF4->F4_PISCRED = '2' .and. !SF4->F4_CSTCOF$'01/02/03'
					aadd(aLog,'>> IT:'+SD2->D2_ITEM+' TES: '+SF4->F4_CODIGO+' CST Cofins inválido Atual: '+AllTrim(SF4->F4_CSTCOF)+' Correta: (01/02/03)')
				endif
				
				//Saidas Aliq Zero
				if SF4->F4_PISCRED = '4' .and. !SF4->F4_CSTPIS$'06/04'
					aadd(aLog,'>> IT:'+SD2->D2_ITEM+' TES: '+SF4->F4_CODIGO+' CST Pis inválido Atual: '+AllTrim(SF4->F4_CSTPIS)+' Correta: (04/06)')
				endif
				if SF4->F4_PISCRED = '4' .and. !SF4->F4_CSTCOF$'06/04'
					aadd(aLog,'>> IT:'+SD2->D2_ITEM+' TES: '+SF4->F4_CODIGO+' CST Cofins inválido Atual: '+AllTrim(SF4->F4_CSTCOF)+' Correta: (04/06)')
				endif
				
				//Saidas Operações não tributadas
				if SF4->F4_PISCRED = '3' .and. !SF4->F4_CSTPIS$'04/07/08/09/49'
					aadd(aLog,'>> IT:'+SD2->D2_ITEM+' TES: '+SF4->F4_CODIGO+' CST Pis inválido Atual: '+AllTrim(SF4->F4_CSTPIS)+' Correta: (04/07/08/09/49)')
				endif
				if SF4->F4_PISCRED = '3' .and. !SF4->F4_CSTCOF$'04/07/08/09/49'
					aadd(aLog,'>> IT:'+SD2->D2_ITEM+' TES: '+SF4->F4_CODIGO+' CST Cofins inválido Atual: '+AllTrim(SF4->F4_CSTCOF)+' Correta: (04/07/08/09/49)')
				endif
				if cmvpar12=1.and.SF4->F4_DUPLIC = 'S' .and. (!SB5->(DbSeek(xFilial('SB5')+SD2->D2_COD)))
					aadd(aLog,'>> IT:'+SD2->D2_ITEM+' PROD: '+SD2->D2_COD+' Produto sem complemento SB5 - Não será considerado no Bloco P ')
				endif
				
				//Analisa Código da Receita da Natureza
				cCodNat:=SB1->B1_CNATREC
				cTabNat:=SB1->B1_TNATREC
				if empty(cCodNat) //Verifica TES
					cCodNat:=SF4->F4_CNATREC
				endif
				if empty(cTabNat) //Verifica TES
					cTabNat:=SF4->F4_TNATREC
				endif
				if (SF4->F4_DUPLIC = 'S' .and. (SF4->F4_CSTPIS$'02/03/04/06/07/08/09' .or. SF4->F4_CSTCOF$'02/03/04/06/07/08/09')) .and. (Empty(cTabNat) .or. Empty(cCodNat))
					aadd(aLog,'>> IT:'+SD2->D2_ITEM+' TES: '+SF4->F4_CODIGO+' PRODUTO: '+SB1->B1_COD+' Cod. Natureza da Receita nao preenchido (CST: '+cCST+' Tab: '+cTab+')')
				endif
				
				if (SF4->F4_DUPLIC = 'S' .and. (SF4->F4_CSTPIS$'02/03/04/06/07/08/09' .or. SF4->F4_CSTCOF$'02/03/04/06/07/08/09')) .and. !Empty(cTabNat) .and. SB1->B1_TNATREC<>cTab .and. SF4->F4_TNATREC<>cTab
					aadd(aLog,'>> IT:'+SD2->D2_ITEM+' TES: '+SF4->F4_CODIGO+' PRODUTO: '+SB1->B1_COD+' Cod. Natureza da Receita divergente (CST: '+cCST+' Tab: '+cTab+')')
				endif
				
				lCSTPIS:=.f.
				lCSTCOF:=.f.
				lNatRec:=.f.
				if SF4->F4_CSTPIS<>SFT->FT_CSTPIS
					aadd(aLog,'>> IT:'+SD2->D2_ITEM+' TES: '+SF4->F4_CODIGO+' SFT: CST Pis divergente Atual: '+AllTrim(SFT->FT_CSTPIS)+' Correta: '+SF4->F4_CSTPIS)
					cCSTPIS:=SF4->F4_CSTPIS
					lCSTPIS:=.t.
				endif
				if SF4->F4_CSTCOF<>SFT->FT_CSTCOF
					aadd(aLog,'>> IT:'+SD2->D2_ITEM+' TES: '+SF4->F4_CODIGO+' SFT: CST Cofins divergente Atual: '+AllTrim(SFT->FT_CSTCOF)+' Correta: '+SF4->F4_CSTCOF)
					cCSTCOF:=SF4->F4_CSTCOF
					lCSTCOF:=.t.
				endif
				if !Empty(cTabNat) .and. (SFT->FT_TNATREC<>cTabNat .or. SFT->FT_CNATREC<>cCodNat )
					aadd(aLog,'>> IT:'+SD2->D2_ITEM+' TES: '+SF4->F4_CODIGO+' SFT: Nat.Rec divergente Atual: '+AllTrim(SFT->FT_TNATREC+'/'+SFT->FT_CNATREC)+' Correta: '+cTabNat+'/'+cCodNat)
					ctNatRec:=cTabNat
					ccNatRec:=cCodNat
					lNatRec:=.t.
				endif
				if cmvpar07=2
					RecLock('SFT',.F.)
					if lCSTPIS
						SFT->FT_CSTPIS :=  cCSTPIS
					endif
					if lCSTCOF
						SFT->FT_CSTCOF :=  cCSTCOF
					endif
					if lNatRec
						SFT->FT_TNATREC :=  ctNatRec
						SFT->FT_CNATREC :=  ccNatRec
					endif
					SFT->( DbUnLock() )
				endif
			endif
			
			
			//Atualiza Pis/Cofins
			aImp:=At2PCIt(@cDocSer,@aLog,aRetProc[2],aRetProc[3])
			_nTotPis+=aImp[1]
			_nTotCof+=aImp[2]
			_nBasPis+=aImp[3]
			_nBasCof+=aImp[4]
			
			if lExistSFT .and. cmvpar09=1 .and. cmvpar07=2 .and. cmvpar11=2 //PisCofins
				_nPauPis:=aImp[5]
				_nPauCof:=aImp[6]
				RecLock('SFT',.F.)
				SFT->FT_PAUTPIS :=  _nPauPis
				SFT->FT_PAUTCOF :=  _nPauCof
				SFT->FT_VALPIS  := aImp[1]
				SFT->FT_VALCOF  := aImp[2]
				SFT->FT_BASEPIS := aImp[3]
				SFT->FT_BASECOF := aImp[4]
				SFT->FT_ALIQPIS := aImp[7]
				SFT->FT_ALIQCOF := aImp[8]
				SFT->( DbUnLock() )
			endif
			
			//Return {_nTotPIS,_nTotCOF,_nBasPIS,_nBasCOF,_nPauPis,_nPauCof,_nAlqPis,_nAlqCof}
			
			DbSelectArea("SD2")
			SD2->( DbSkip() )
			if !empty(cDocSer) .and. cDocSer<>SD2->(D2_DOC+D2_SERIE)
				sTotPis+=_nTotPis
				sTotCof+=_nTotCof
				sBasPis+=_nBasPis
				sBasCof+=_nBasCof
				sQtdDoc++
				if cmvpar07=2 .and. cmvpar11=2
					SF2->( RecLock("SF2",.F.) )
					SF2->F2_VALIMP6 := _nTotPis
					SF2->F2_VALIMP5 := _nTotCof
					SF2->F2_BASIMP6 := _nBasPis
					SF2->F2_BASIMP5 := _nBasCof
					if !empty(cEspecie) .and. SF2->F2_ESPECIE <>cEspecie
						//SF2->F2_ESPECIE := cEspecie
					endif
					SF2->( DbUnLock() )
					
					if cmvpar08=1 //reprocessa livros
						aPergA930={}
						aAdd(aPergA930,Dtoc(SF2->F2_EMISSAO))
						aAdd(aPergA930,Dtoc(SF2->F2_EMISSAO))
						aAdd(aPergA930,2)
						aAdd(aPergA930,SF2->F2_DOC)
						aAdd(aPergA930,SF2->F2_DOC)
						aAdd(aPergA930,SF2->F2_SERIE)
						aAdd(aPergA930,SF2->F2_SERIE)
						aAdd(aPergA930,'')
						aAdd(aPergA930,'ZZZZZZZ')
						aAdd(aPergA930,'')
						aAdd(aPergA930,'ZZZZZZZ')
						aArea:=GetArea()
						aAreaSM0:=SM0->(GetArea())
						MATA930(.T.,aPergA930)//Reprocessamento automático
						RestArea(aArea)
						SM0->(RestArea(aAreaSM0))
					endif
					
				endif
				_nTotPis:=0
				_nTotCof:=0
				_nBasPis:=0
				_nBasCof:=0
				cEspecie:=''
			endif
		Enddo
	Endif
	
	if eQtdDoc>0
		aadd(aLog,'')
		aadd(aLog,'>> '+cFilAnt+' - Entrada: Processados '+Alltrim(Str(eQtdDoc))+' Doc(s) >>> Base: Pis > '+Transform(eBasPis,'@e 99,999,999.99')+' Cofins > '+Transform(eBasCof,'@e 99,999,999.99')+'  >>> Valor: Pis > '+Transform(eTotPis,'@e 9,999,999.99')+' Cofins > '+Transform(eTotCof,'@e 9,999,999.99'))
		eQtdDoc:=0
		eBasPis:=0
		eBasCof:=0 
		eTotPis:=0
		eTotCof:=0
	endif
	if sQtdDoc>0
		aadd(aLog,'')
		aadd(aLog,'>> '+cFilAnt+' - Saidas:  Processados '+Alltrim(Str(sQtdDoc))+' Doc(s) >>> Base: Pis > '+Transform(sBasPis,'@e 99,999,999.99')+' Cofins > '+Transform(sBasCof,'@e 99,999,999.99')+'  >>> Valor: Pis > '+Transform(sTotPis,'@e 9,999,999.99')+' Cofins > '+Transform(sTotCof,'@e 9,999,999.99'))
		sQtdDoc:=0
		sBasPis:=0
		sBasCof:=0 
		sTotPis:=0
		sTotCof:=0
	endif
Next i
Return

Static Function ExistSF3()
Local lRet:=.f.
SF3->(MsSeek(xFilial("SF3")+SF1->F1_FORNECE+SF1->F1_LOJA+SF1->F1_DOC+SF1->F1_SERIE))
While SF3->(!Eof()) .And.;
	xFilial("SF3") == SF3->F3_FILIAL .And.;
	SF1->F1_FORNECE == SF3->F3_CLIEFOR .And.;
	SF1->F1_LOJA == SF3->F3_LOJA .And.;
	SF1->F1_DOC == SF3->F3_NFISCAL .And.;
	SF1->F1_SERIE == SF3->F3_SERIE
	If SF3->F3_TIPO == 'S'
		lRet:=.t.
	EndIf
	SF3->(dbSkip())
EndDo
Return lRet


Static Function AtuPCIt(cDocSer,aLog,lIcmsBase,lApliDed)
Local _nTotPIS := 0
Local _nTotCOF := 0
Local _nBasPIS := 0
Local _nBasCOF := 0
Local _nAlqPis := 0
Local _nAlqCof := 0

lPIS := SF4->F4_PISCOF $ '1/2/3' .and. SF4->F4_PISCRED $ '1/4'
if lPIS
	if iif(cmvpar09=1,empty(SF4->F4_CODBCC) .or. empty(SF4->F4_TPREG),.f.) .or. (empty(SF4->F4_CSTPIS) .or. empty(SF4->F4_CSTCOF)) .or. (SF4->F4_CSTPIS>='50' .and. SF4->F4_CSTPIS<='56' .and. Empty(SB1->B1_POSIPI) .and. AModNot(SF1->F1_ESPECIE)='55') .or. (SF4->F4_CSTPIS<'50' .or. SF4->F4_CSTCOF<'50' )
		if cDocSer<>SD1->(D1_DOC+D1_SERIE)
			cRazao:=iif(SD1->D1_TIPO$'DB',Posicione("SA1",1,xFilial("SA1")+SD1->(D1_FORNECE+SD1->D1_LOJA),"A1_NOME"),Posicione("SA2",1,xFilial("SA2")+SD1->(D1_FORNECE+SD1->D1_LOJA),"A2_NOME"))
			aadd(aLog,replicate('-',132))
			aadd(aLog,'NFE Doc: '+SD1->(D1_SERIE+'/'+D1_DOC+' - '+SD1->D1_FORNECE+'/'+SD1->D1_LOJA+' '+cRazao))
			cDocSer:=SD1->(D1_DOC+D1_SERIE)
		endif
	endif
	if cmvpar09=1
		if empty(SF4->F4_CODBCC)
			cMsg:='>> Cod Base Calculo não preenchida TES (Cod Bc Cred)> '+SF4->F4_CODIGO
			if aScan(aLog, {|x|  x $ cMsg  } )=0
				aadd(aLog,cMsg)
			endif
		endif
		if empty(SF4->F4_TPREG)
			cMsg:='>> Tipo de Regime não preenchido TES (Tp Reg) > '+SF4->F4_CODIGO
			if aScan(aLog, {|x|  x $ cMsg  } )=0
				aadd(aLog,cMsg)
			endif
		endif
	endif
	if empty(SF4->F4_CSTPIS) .or. empty(SF4->F4_CSTCOF)
		cMsg:='>> CST não preenchida TES (Sit Trib Pis/Sit Trib Cof) > '+SF4->F4_CODIGO
		if aScan(aLog, {|x|  x $ cMsg  } )=0
			aadd(aLog,cMsg)
		endif
	endif
	
	if SF4->F4_CSTPIS>='50' .and. SF4->F4_CSTPIS<='56' .and. Empty(SB1->B1_POSIPI) .and. AModNot(SF1->F1_ESPECIE)='55'
		cMsg:='>> NCM não preenchido no produto (Pos.IPI/NCM) > '+SB1->B1_COD
		if aScan(aLog, {|x|  x $ cMsg  } )=0
			aadd(aLog,cMsg)
		endif
	endif
	
	if SF4->F4_CSTPIS<'50' .or. SF4->F4_CSTCOF<'50'
		cMsg:='>> CST invalida TES (Sit Trib Pis/Sit Trib Cof) > '+SF4->F4_CODIGO
		if aScan(aLog, {|x|  x $ cMsg  } )=0
			aadd(aLog,cMsg)
		endif
	endif
	
	// Atualiza os valores do PIS e COFINS
	_nAlqPis := iif(SB1->B1_PPIS<>0,SB1->B1_PPIS,GetMV("MV_TXPIS"))
	_nAlqCof := iif(SB1->B1_PCOFINS<>0,SB1->B1_PCOFINS,GetMV("MV_TXCOFIN"))
	
	cGrpCli:=iif(!SD1->D1_TIPO$'DB',SA2->A2_GRPTRIB,SA1->A1_GRPTRIB)
	cGrpTrib:=SB1->B1_GRTRIB
	cUf:=iif(!SD1->D1_TIPO$'DB',SA2->A2_EST,SA1->A1_EST)
	
	aAliqSF7:=GetSF7Aliq(cUf,cGrpTrib,cGrpCli)
	_nAlqPis := iif(aAliqSF7[1]<>0,aAliqSF7[1],_nAlqPis)
	_nAlqCof := iif(aAliqSF7[2]<>0,aAliqSF7[2],_nAlqCof)
	
	
	// Aliquota Zero
	if SF4->F4_CSTPIS='73'
		_nAlqPis := 0
	endif
	if SF4->F4_CSTCOF='73'
		_nAlqCof := 0
	endif
	
	//Agrega Desp Ac
	_DespAcPis:=iif(SF4->F4_DESPPIS=='2',0,SD1->D1_VALFRE)
	_DespAcCof:=iif(SF4->F4_DESPCOF=='2',0,SD1->D1_VALFRE)
	
	if Str(lApliDed,1) $ '/3' .or. (Str(lApliDed,1) $ '1' .AND. SD1->D1_TIPO='N') .or. (Str(lApliDed,1) $ '2' .AND. SD1->D1_TIPO='D')
		//Subtrai Icms Base Pis Cofins
		_IcmsPis:=iif(lIcmsBase=3.or.(lIcmsBase=1 .AND. SF4->F4_CREDICM<>'S'),0,SD1->D1_VALICM)
		_IcmsCof:=iif(lIcmsBase=3.or.(lIcmsBase=1 .AND. SF4->F4_CREDICM<>'S'),0,SD1->D1_VALICM)
	else
		_IcmsPis:=0
		_IcmsCof:=0
	endif
	
	//Agrega IPI
	_IpiPis:=iif(SF4->F4_IPIPC=='2',0,SD1->D1_VALIPI)
	_IpiCof:=iif(SF4->F4_IPIPC=='2',0,SD1->D1_VALIPI)
	
	//Agrega ST
	_StPis:=iif(GetMV('MV_DBSTPIS')=='6',0,SD1->D1_ICMSRET)
	_StCof:=iif(GetMV('MV_DBSTCOF')=='6',0,SD1->D1_ICMSRET)
	
	// Verificar % Red PIS
	_nRedPis:=iif(SB1->B1_REDPIS<>0,SB1->B1_REDPIS,SF4->F4_BASEPIS)
	If ( _nRedPis <> 0 )
		_nBasPIS :=  NoRound(SD1->(D1_TOTAL-D1_VALDESC+D1_DESPESA+_DespAcPis+_IpiPis+_StPis-_IcmsPis) * ((100-_nRedPis) /100),2)
	Else
		_nBasPIS := SD1->(D1_TOTAL-D1_VALDESC+D1_DESPESA+_DespAcPis+_IpiPis+_StPis-_IcmsPis)
	EndIf
	
	// Verificar % Red COFINS
	_nRedCof:=iif(SB1->B1_REDCOF<>0,SB1->B1_REDCOF,SF4->F4_BASECOF)
	If ( _nRedCof <> 0 )
		_nBasCOF :=  NoRound(SD1->(D1_TOTAL-D1_VALDESC+D1_DESPESA+_DespAcCof+_IpiCof+_StCof-_IcmsCof) * ((100-_nRedCof) /100),2)
	Else
		_nBasCOF := SD1->(D1_TOTAL-D1_VALDESC+D1_DESPESA+_DespAcCof+_IpiCof+_StCof-_IcmsCof)
	EndIf
	
	_nTotPIS := Round(( ( (_nBasPIS ) * _nAlqPis ) / 100 ),2)
	_nTotCOF := Round(( ( (_nBasCOF ) * _nAlqCof ) / 100 ),2)
	
	if Abs(SD1->D1_VALIMP5 - _nTotCOF )>0.01 .or. Abs( SD1->D1_VALIMP6 - _nTotPIS )>0.01   .or. SD1->D1_ALQIMP5 <>  _nAlqCof .or. SD1->D1_ALQIMP6 <>  _nAlqPis
		if cDocSer<>SD1->(D1_DOC+D1_SERIE)
			cRazao:=iif(SD1->D1_TIPO$'DB',Posicione("SA1",1,xFilial("SA1")+SD1->(D1_FORNECE+SD1->D1_LOJA),"A1_NOME"),Posicione("SA2",1,xFilial("SA2")+SD1->(D1_FORNECE+SD1->D1_LOJA),"A2_NOME"))
			aadd(aLog,replicate('-',132))
			aadd(aLog,'NFE Doc: '+SD1->(D1_SERIE+'/'+D1_DOC+' - '+SD1->D1_FORNECE+'/'+SD1->D1_LOJA+' '+cRazao))
			cDocSer:=SD1->(D1_DOC+D1_SERIE)
		endif
		aadd(aLog,'>> IT:'+SD1->D1_ITEM+' TES: '+SF4->F4_CODIGO+' Div.Valor Pis/Cofins-Atual: Pis> '+Transform(SD1->D1_VALIMP6,'@e 9,999.99')+' Cofins> '+Transform(SD1->D1_VALIMP5,'@e 9,999.99')+' Calculado: Pis> '+Transform(_nTotPIS,'@e 9,999.99')+' Cofins> '+Transform(_nTotCOF,'@e 9,999.99'))
		if cmvpar07=2 .and. cmvpar11=2
			RecLock('SD1',.F.)
			SD1->D1_VALIMP5 :=  _nTotCOF
			SD1->D1_VALIMP6 :=  _nTotPIS
			SD1->D1_BASIMP5 :=  _nBasCOF
			SD1->D1_BASIMP6 :=  _nBasPIS
			SD1->D1_ALQIMP5 :=  _nAlqCof
			SD1->D1_ALQIMP6 :=  _nAlqPis
			SD1->( DbUnLock() )
		endif
	endif
else // Limpa se nao e para calcular
	if ( SD1->D1_VALIMP5 <> 0 ) .or. ( SD1->D1_VALIMP6 <> 0 )
		if cDocSer<>SD1->(D1_DOC+D1_SERIE)
			cRazao:=iif(SD1->D1_TIPO$'DB',Posicione("SA1",1,xFilial("SA1")+SD1->(D1_FORNECE+SD1->D1_LOJA),"A1_NOME"),Posicione("SA2",1,xFilial("SA2")+SD1->(D1_FORNECE+SD1->D1_LOJA),"A2_NOME"))
			aadd(aLog,replicate('-',132))
			aadd(aLog,'NFE Doc: '+SD1->(D1_SERIE+'/'+D1_DOC+' - '+SD1->D1_FORNECE+'/'+SD1->D1_LOJA+' '+cRazao))
			cDocSer:=SD1->(D1_DOC+D1_SERIE)
		endif
		aadd(aLog,'>> IT:'+SD1->D1_ITEM+' TES: '+SF4->F4_CODIGO+' Div.Valor Pis/Cofins-Atual: Pis> '+Transform(SD1->D1_VALIMP6,'@e 9,999.99')+' Cofins> '+Transform(SD1->D1_VALIMP5,'@e 9,999.99')+' Calculado: Pis> '+Transform(_nTotPIS,'@e 9,999.99')+' Cofins> '+Transform(_nTotCOF,'@e 9,999.99'))
		if cmvpar07=2 .and. cmvpar11=2
			SD1->( RecLock('SD1',.F.) )
			SD1->D1_VALIMP5 :=  0  //COFINS
			SD1->D1_VALIMP6 :=  0  //PIS
			SD1->D1_BASIMP5 :=  0
			SD1->D1_BASIMP6 :=  0
			SD1->D1_ALQIMP5 :=  0
			SD1->D1_ALQIMP6 :=  0
			SD1->( DbUnLock() )
		endif
	endif
endif
Return {_nTotPIS,_nTotCOF,_nBasPIS,_nBasCOF,_nAlqPis,_nAlqCof}

Static Function At2PCIt(cDocSer,aLog,lIcmsBase,lApliDed)
Local _nTotPIS := 0
Local _nTotCOF := 0
Local _nBasPIS := 0
Local _nBasCOF := 0
Local _nPauPis := 0
Local _nPauCof := 0
Local _nAlqPis := 0
Local _nAlqCof := 0

lSufr:=iif(SD2->D2_TIPO$'DB',.f.,Posicione("SA1",1,xFilial("SA1")+SD2->(D2_CLIENTE+SD2->D2_LOJA),"A1_CALCSUF")='S')
lPIS := SF4->F4_PISCOF $ '1/2/3' .and. SF4->F4_PISCRED $ '2/4' //  .and. !lSufr Deve tratar Suframa Aliq 0
if lPIS
	if iif(cmvpar09=1,empty(SF4->F4_TPREG),.f.) .or. (empty(SF4->F4_CSTPIS) .or. empty(SF4->F4_CSTCOF))
		if cDocSer<>SD2->(D2_DOC+D2_SERIE)
			cRazao:=iif(!SD2->D2_TIPO$'DB',Posicione("SA1",1,xFilial("SA1")+SD2->(D2_CLIENTE+SD2->D2_LOJA),"A1_NOME"),Posicione("SA2",1,xFilial("SA2")+SD2->(D2_CLIENTE+SD2->D2_LOJA),"A2_NOME"))
			aadd(aLog,replicate('-',132))
			aadd(aLog,'NFS Doc: '+SD2->(D2_SERIE+'/'+D2_DOC+' - '+SD2->D2_CLIENTE+'/'+SD2->D2_LOJA+' '+cRazao))
			cDocSer:=SD2->(D2_DOC+D2_SERIE)
		endif
	endif
	if cmvpar09=1
		/*
		if empty(SF4->F4_CODBCC)
		cMsg:='>> Cod Base Calculo não preenchida TES (Cod Bc Cred)> '+SF4->F4_CODIGO
		if aScan(aLog, {|x|  x $ cMsg  } )=0
		aadd(aLog,cMsg)
		endif
		endif
		*/
		if empty(SF4->F4_TPREG)
			cMsg:='>> Tipo de Regime não preenchido TES (Tp Reg) > '+SF4->F4_CODIGO
			if aScan(aLog, {|x|  x $ cMsg  } )=0
				aadd(aLog,cMsg)
			endif
		endif
	endif
	if empty(SF4->F4_CSTPIS) .or. empty(SF4->F4_CSTCOF)
		cMsg:='>> CST não preenchida TES (Sit Trib Pis/Sit Trib Cof) > '+SF4->F4_CODIGO
		if aScan(aLog, {|x|  x $ cMsg  } )=0
			aadd(aLog,cMsg)
		endif
	endif
	/*
	if SF4->F4_CSTPIS>='50' .and. SF4->F4_CSTPIS<='56' .and. Empty(SB1->B1_POSIPI) .and. AModNot(SF1->F1_ESPECIE)='55'
	cMsg:='>> NCM não preenchido no produto (Pos.IPI/NCM) > '+SB1->B1_COD
	if aScan(aLog, {|x|  x $ cMsg  } )=0
	aadd(aLog,cMsg)
	endif
	endif
	*/
	
	if SF4->F4_CSTPIS>'49' .or. SF4->F4_CSTCOF>'49'
		cMsg:='>> CST invalida TES (Sit Trib Pis/Sit Trib Cof) > '+SF4->F4_CODIGO
		if aScan(aLog, {|x|  x $ cMsg  } )=0
			aadd(aLog,cMsg)
		endif
	endif
	
	// Atualiza os valores do PIS e COFINS
	_nAlqPis := iif(SB1->B1_PPIS<>0,SB1->B1_PPIS,GetMV("MV_TXPIS"))
	_nAlqCof := iif(SB1->B1_PCOFINS<>0,SB1->B1_PCOFINS,GetMV("MV_TXCOFIN"))
	_nFatCon := SB1->B1_CONV
	
	cGrpCli:=iif(SD2->D2_TIPO$'DB',SA2->A2_GRPTRIB,SA1->A1_GRPTRIB)
	cGrpTrib:=SB1->B1_GRTRIB
	cUf:=iif(SD2->D2_TIPO$'DB',SA2->A2_EST,SA1->A1_EST)
	
	aAliqSF7:=GetSF7Aliq(cUf,cGrpTrib,cGrpCli)
	_nAlqPis := iif(aAliqSF7[1]<>0,aAliqSF7[1],_nAlqPis)
	_nAlqCof := iif(aAliqSF7[2]<>0,aAliqSF7[2],_nAlqCof)
	
	
	if !empty(SD2->D2_SEGUM)
		//  Verifica valores de Pauta do PIS e COFINS
		_nPauPis := iif(SB1->B1_VLR_PIS<>0,SB1->B1_VLR_PIS*_nFatCon,0)
		_nPauCof := iif(SB1->B1_VLR_COF<>0,SB1->B1_VLR_COF*_nFatCon,0)
		
		_FatAtu:=SD2->(D2_QUANT/D2_QTSEGUM)
		_nPauPis := _nPauPis/_FatAtu
		_nPauCof := _nPauCof/_FatAtu
	else
		//  Verifica valores de Pauta do PIS e COFINS
		_nPauPis := iif(SB1->B1_VLR_PIS<>0,SB1->B1_VLR_PIS,0)
		_nPauCof := iif(SB1->B1_VLR_COF<>0,SB1->B1_VLR_COF,0)
	endif
	
	if _nPauPis+_nPauCof>0
		lPisCofPau:=.t.
	else
		lPisCofPau:=.f.
	endif
	
	
	// Aliquota Zero
	if SF4->F4_CSTPIS$'04/06' .or. lPisCofPau
		_nAlqPis := 0
	endif
	if SF4->F4_CSTCOF$'04/06' .or. lPisCofPau
		_nAlqCof := 0
	endif
	
	//Agrega Desp Ac
	_DespAcPis:=iif(SF4->F4_DESPPIS=='2',0,SD2->D2_VALFRE)
	_DespAcCof:=iif(SF4->F4_DESPCOF=='2',0,SD2->D2_VALFRE)
	
	if Str(lApliDed,1) $ '/3' .or. (Str(lApliDed,1) $ '/2' .AND. SD2->D2_TIPO='N') .or. (Str(lApliDed,1) $ '/1' .AND. SD2->D2_TIPO='D')
		//Subtrai Icms Base Pis Cofins
		_IcmsPis:=iif(lIcmsBase=3.or.(lIcmsBase=1 .AND. SF4->F4_CREDICM<>'S'),0,SD2->D2_VALICM)
		_IcmsCof:=iif(lIcmsBase=3.or.(lIcmsBase=1 .AND. SF4->F4_CREDICM<>'S'),0,SD2->D2_VALICM)
	else
		_IcmsPis:=0
		_IcmsCof:=0
	endif
	
	// Verificar % Red PIS
	_nRedPis:=iif(SB1->B1_REDPIS<>0,SB1->B1_REDPIS,SF4->F4_BASEPIS)
	If ( _nRedPis <> 0 )
		_nBasPIS :=  NoRound((SD2->D2_TOTAL+_DespAcPis-_IcmsPis) * ((100-_nRedPis) /100),2)
	Else
		_nBasPIS := SD2->D2_TOTAL+_DespAcPis-_IcmsPis
	EndIf
	
	// Verificar % Red COFINS
	_nRedCof:=iif(SB1->B1_REDCOF<>0,SB1->B1_REDCOF,SF4->F4_BASECOF)
	If ( _nRedCof <> 0 )
		_nBasCOF :=  NoRound((SD2->D2_TOTAL+_DespAcCof-_IcmsCof) * ((100-_nRedCof) /100),2)
	Else
		_nBasCOF := SD2->D2_TOTAL+_DespAcCof-_IcmsCof
	EndIf
	
	if !lPisCofPau
		_nTotPIS := Round(( ( (_nBasPIS ) * _nAlqPis ) / 100 ),2)
		_nTotCOF := Round(( ( (_nBasCOF ) * _nAlqCof ) / 100 ),2)
	else
		_nTotPIS := Round(( SD2->D2_QUANT  * _nPauPis  ),2)
		_nTotCOF := Round(( SD2->D2_QUANT  * _nPauCof  ),2)
	endif
	
	
	if Abs(SD2->D2_VALIMP5 - _nTotCOF )>0.01 .or. Abs( SD2->D2_VALIMP6 - _nTotPIS )>0.01 .or. Abs( SD2->D2_BASIMP6 - _nBasPIS )>0.01 .or. Abs( SD2->D2_BASIMP5 - _nBasCOF )>0.01
		if cDocSer<>SD2->(D2_DOC+D2_SERIE)
			cRazao:=iif(!SD2->D2_TIPO$'DB',Posicione("SA1",1,xFilial("SA1")+SD2->(D2_CLIENTE+SD2->D2_LOJA),"A1_NOME"),Posicione("SA2",1,xFilial("SA2")+SD2->(D2_CLIENTE+SD2->D2_LOJA),"A2_NOME"))
			aadd(aLog,replicate('-',132))
			aadd(aLog,'NFS Doc: '+SD2->(D2_SERIE+'/'+D2_DOC+' - '+SD2->D2_CLIENTE+'/'+SD2->D2_LOJA+' '+cRazao))
			cDocSer:=SD2->(D2_DOC+D2_SERIE)
		endif
		if _nAlqPis+_nAlqCof>0
			aadd(aLog,'>> IT:'+SD2->D2_ITEM+' TES: '+SF4->F4_CODIGO+' Div.Valor Pis/Cofins-Atual: Pis> '+Transform(SD2->D2_VALIMP6,'@e 9,999.99')+' Cofins> '+Transform(SD2->D2_VALIMP5,'@e 9,999.99')+' Calculado: Pis> '+Transform(_nTotPIS,'@e 9,999.99')+' Cofins> '+Transform(_nTotCOF,'@e 9,999.99'))
		else
			aadd(aLog,'>> IT:'+SD2->D2_ITEM+' TES: '+SF4->F4_CODIGO+' Div.Base  Pis/Cofins-Atual: Pis> '+Transform(SD2->D2_BASIMP6,'@e 9,999.99')+' Cofins> '+Transform(SD2->D2_BASIMP5,'@e 9,999.99')+' Calculado: Pis> '+Transform(_nBasPIS,'@e 9,999.99')+' Cofins> '+Transform(_nBasCOF,'@e 9,999.99'))
		endif
		if cmvpar07=2 .and. cmvpar11=2
			RecLock('SD2',.F.)
			SD2->D2_VALIMP5 :=  _nTotCOF
			SD2->D2_VALIMP6 :=  _nTotPIS
			SD2->D2_BASIMP5 :=  _nBasCOF
			SD2->D2_BASIMP6 :=  _nBasPIS
			SD2->D2_ALQIMP5 :=  _nAlqCof
			SD2->D2_ALQIMP6 :=  _nAlqPis
			SD2->( DbUnLock() )
		endif
	endif
else // Limpa se nao e para calcular
	if ( SD2->D2_VALIMP5 <> 0 ) .or. ( SD2->D2_VALIMP6 <> 0 )
		if cDocSer<>SD2->(D2_DOC+D2_SERIE)
			cRazao:=iif(!SD2->D2_TIPO$'DB',Posicione("SA1",1,xFilial("SA1")+SD2->(D2_CLIENTE+SD2->D2_LOJA),"A1_NOME"),Posicione("SA2",1,xFilial("SA2")+SD2->(D2_CLIENTE+SD2->D2_LOJA),"A2_NOME"))
			aadd(aLog,replicate('-',132))
			aadd(aLog,'NFS Doc: '+SD2->(D2_SERIE+'/'+D2_DOC+' - '+SD2->D2_CLIENTE+'/'+SD2->D2_LOJA+' '+cRazao))
			cDocSer:=SD2->(D2_DOC+D2_SERIE)
		endif
		aadd(aLog,'>> IT:'+SD2->D2_ITEM+' Divergência de valor Pis/Cofins - Atual: Pis > '+Transform(SD2->D2_VALIMP6,'@e 99,999.99')+' Cofins > '+Transform(SD2->D2_VALIMP5,'@e 99,999.99')+' Calculado: Pis > '+Transform(_nTotPIS,'@e 99,999.99')+' Cofins > '+Transform(_nTotCOF,'@e 99,999.99'))
		if cmvpar07=2 .and. cmvpar11=2
			SD2->( RecLock('SD2',.F.) )
			SD2->D2_VALIMP5 :=  0  //COFINS
			SD2->D2_VALIMP6 :=  0  //PIS
			SD2->D2_BASIMP5 :=  0
			SD2->D2_BASIMP6 :=  0
			SD2->D2_ALQIMP5 :=  0
			SD2->D2_ALQIMP6 :=  0
			SD2->( DbUnLock() )
		endif
	endif
endif
lCPRB:=cmvpar12=1.and.SF4->F4_DUPLIC = 'S' .and. (SB5->(DbSeek(xFilial('SB5')+SD2->D2_COD)))
if lCPRB .and. SB5->B5_INSPAT='1'
	CG1->(DbSeek(xFilial('CG1')+SB5->B5_CODATIV))
	nBaseCPRB:=SD2->D2_TOTAL
	nAliqCPRB:=CG1->CG1_ALIQ
	nVlrCPRB:=Round(( ( (nBaseCPRB ) * nAliqCPRB ) / 100 ),2)
else
	nBaseCPRB:=0
	nAliqCPRB:=0
	nVlrCPRB:=0
endif
if SD2->D2_BASECPB <>  nBaseCPRB .or. SD2->D2_VALCPB  <> nVlrCPRB
	aadd(aLog,'>> DOC: '+SD2->D2_DOC+' IT:'+SD2->D2_ITEM+' Div.Valor CPRB-Atual: Base> '+Transform(SD2->D2_BASECPB,'@e 999,999.99')+' Valor> '+Transform(SD2->D2_VALCPB,'@e 999,999.99')+' Calculado: Base> '+Transform(nBaseCPRB,'@e 999,999.99')+' Valor> '+Transform(nVlrCPRB,'@e 999,999.99'))
	if cmvpar07=2 .and. cmvpar11=2
		RecLock('SD2',.F.)
		SD2->D2_BASECPB :=  nBaseCPRB
		SD2->D2_VALCPB  :=  nVlrCPRB
		SD2->D2_ALIQCPB :=  nAliqCPRB
		SD2->( DbUnLock() )
	endif
endif

Return {_nTotPIS,_nTotCOF,_nBasPIS,_nBasCOF,_nPauPis,_nPauCof,_nAlqPis,_nAlqCof}



Static Function GetSF7Aliq(cUf,cGrpTrib,cGrpCli)
Local aAliqSF7:={0,0}
Local cQuery := "SELECT F7_ALIQPIS,F7_ALIQCOF"
cQuery += "  FROM "+RetSqlName("SF7")+" A"
cQuery += " WHERE A.D_E_L_E_T_<>'*'"
cQuery += "   AND F7_FILIAL ='"+xFilial("SF7")+"'"
cQuery += "   AND F7_EST ='"+cUf+"'"
cQuery += "   AND F7_GRTRIB ='"+cGrpTrib+"'"
cQuery += "   AND F7_GRPCLI ='"+cGrpCli+"'"
TCQUERY cQuery NEW ALIAS "QSF7"
DbSelectArea("QSF7")
dbGotop()
If !Eof()
	aAliqSF7:={QSF7->F7_ALIQPIS,QSF7->F7_ALIQCOF}
Endif
QSF7->(dbCloseArea())
Return aAliqSF7  

Static Function VerProc(cTipo,cProd,cDoc,cSerie,CliFor,Loja) 
Local   lRet:=.f.
Local cQuery := ""  
if cTipo=='1'
	cQuery += "SELECT D1_COD"
	cQuery += "  FROM "+RetSqlName("SD1")+" A,"+RetSqlName("SF4")+" B"
	cQuery += " WHERE A.D_E_L_E_T_=' ' AND B.D_E_L_E_T_= ' ' "
	cQuery += "  AND D1_FILIAL ='"+xFilial("SD1")+"'"
	cQuery += "  AND F4_FILIAL ='"+xFilial("SF4")+"'"
	cQuery += "  AND D1_TES = F4_CODIGO AND F4_TRANFIL<>'1' "
	cQuery += "  AND D1_COD ='"+cProd+"'"
	cQuery += "  AND D1_DOC ='"+cDoc+"'"
	cQuery += "  AND D1_SERIE ='"+cSerie+"'"
	cQuery += "  AND D1_FORNECE ='"+CliFor+"'"
	cQuery += "  AND D1_LOJA ='"+Loja+"'"
else
	cQuery += "SELECT D2_COD"
	cQuery += "  FROM "+RetSqlName("SD2")+" A,"+RetSqlName("SF4")+" B"
	cQuery += " WHERE A.D_E_L_E_T_=' ' AND B.D_E_L_E_T_= ' ' "
	cQuery += "  AND D2_FILIAL ='"+xFilial("SD2")+"'"
	cQuery += "  AND F4_FILIAL ='"+xFilial("SF4")+"'"
	cQuery += "  AND D2_TES = F4_CODIGO AND F4_TRANFIL<>'1' "
	cQuery += "  AND D2_COD ='"+cProd+"'"
	cQuery += "  AND D2_DOC ='"+cDoc+"'"
	cQuery += "  AND D2_SERIE ='"+cSerie+"'"
	cQuery += "  AND D2_CLIENTE ='"+CliFor+"'"
	cQuery += "  AND D2_LOJA ='"+Loja+"'"
endif	
TCQUERY cQuery NEW ALIAS "QVPROC"
If QVPROC->(!Eof())
  lRet:=.t.
Endif
QVPROC->(dbCloseArea())
Return lRet

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////










User Function _AtuTES()
Local _aConversao := {}
Local _aExcessaoCFOP := {}
Local _nPosicao := 0
Local _lEntrada := .T.
Local _aDevolucao := {}
Local _aDevCompra := {}

// VARIAVEL QUE GUARDA AS MODIFICACOES PARA ALTERAR AS TES

aadd(_aConversao,{'538','700','04600001','SUCATA DE EMBALAGENS'} )
aadd(_aConversao,{'545','701','12100001','ARROZ BENEFICIADO'} )
aadd(_aConversao,{'520','703','12400001',''} )
aadd(_aConversao,{'604','','13100001','FARELO DE ARROZ'})
aadd(_aConversao,{'604','704','13200001',''})
aadd(_aConversao,{'520','703','13200001',''})
aadd(_aConversao,{'545','701','33100001',''})
aadd(_aConversao,{'107','200','34100001',''})
aadd(_aConversao,{'112','201','','BOB ARROZ'})
aadd(_aConversao,{'027','202','PS000088',''})
aadd(_aConversao,{'037','203','PS000078',''})
aadd(_aConversao,{'078','203','PS000078',''})
aadd(_aConversao,{'516','705',''})
aadd(_aConversao,{'037','204',''})
aadd(_aConversao,{'115','205',''})

aadd( _aDevolucao, {'13100001','106','206'} )
aadd( _aDevolucao, {'13100001','064','207'} )
aadd( _aDevolucao, {'13100001','010','208'} )
aadd( _aDevolucao, {'33100001','046','209'} )
aadd( _aDevolucao, {'12100001','046','209'} )


aadd( _aDevCompra, {'34100001','501','706'} )
aadd( _aDevCompra, {'41110205','607','707'} )
aadd( _aDevCompra, {'41110305','501','706'} )
aadd( _aDevCompra, {'41110405','501','706'} )
aadd( _aDevCompra, {'41111105','501','706'} )
aadd( _aDevCompra, {'41112505','501','706'} )

aadd( _aDevCompra, {'41410101','501','706'} )
aadd( _aDevCompra, {'41410301','501','706'} )
aadd( _aDevCompra, {'41441201','501','706'} )
aadd( _aDevCompra, {'43100001','501','706'} )

aadd( _aExcessaoCFOP,{'14100001',{'1352/2352/1933/2933'}})
aadd( _aExcessaoCFOP,{'34100001',{'1352/2352/1933/2933'}})
aadd( _aExcessaoCFOP,{'34200001',{'1352/2352/1933/2933'}})




//CORREÇÃO NA TABELA DE PRODUTO
DbSelectArea("SB1")

do while !SB1->( Eof() ) .and. .F.
	
	_nPosicao := aScan(_aConversao, {|x|  iif( !Empty(x[3]), x[3] $ AllTrim(SB1->B1_COD),x[4] $ AllTrim(SB1->B1_DESC))  } )
	if _nPosicao > 0 .and. iif( _aConversao[_nPosicao,2] > '500', SB1->B1_TS <> _aConversao[_nPosicao,2], SB1->B1_TE <> _aConversao[_nPosicao,2] )
		
		SB1->( RecLock("SB1",.F.) )
		if _aConversao[_nPosicao,2] > '500'
			SB1->B1_TS := _aConversao[_nPosicao,2]
			
		else
			SB1->B1_TE := _aConversao[_nPosicao,2]
			
		endif
		
		SB1->( DbUnLock() )
		
	endif
	
	SB1->( DbSkip() )
	
enddo


// CORRECAO NOS ITENS DO PEDIDO DE VENDA
DbSelectArea("SC6")
SC6->( DbSetOrder(1) )

do while !SC6->( Eof() ) .and. .F.
	
	SC5->( DbSeek( xFilial("SC5")+SC6->C6_NUM ), .T. )
	Posicione("SB1", 1, xFilial("SB1")+SC6->C6_PRODUTO,"B1_DESC" )
	
	if SB1->B1_TS <> SC6->C6_TES .and. SC5->C5_TIPO == 'N' .and. !Empty(SB1->B1_TS)
		
		SC6->( RecLock("SC6",.F.) )
		SC6->C6_TES := SB1->B1_TS
		SC6->( DbUnLock() )
		
	endif
	
	SC6->( DbSkip() )
	
enddo


// CORRECAO NOS ITENS DO PEDIDO DE COMPRA
DbSelectArea("SC7")
SC7->( DbSetOrder(1) )

do while !SC7->( Eof() ) .and. .F.
	
	Posicione("SB1", 1, xFilial("SB1")+SC7->C7_PRODUTO,"B1_DESC" )
	if SB1->B1_TE <> SC7->C7_TES .and. !Empty(SB1->B1_TE)
		
		SC7->( RecLock("SC7",.F.) )
		SC7->C7_TES := SB1->B1_TE
		SC7->( DbUnLock() )
		
	endif
	
	SC7->( DbSkip() )
	
enddo





// CORRECAO NOS ITENS NF. SAIDA
DbSelectArea("SD2")
SD2->( DbSetOrder(1) )

do while !SD2->( Eof() ) .and. .F.
	
	Posicione("SB1", 1, xFilial("SB1")+SD1->D2_COD,"B1_DESC" )
	if SB1->B1_TS <> SD1->D2_TES .and. !Empty(SB1->B1_TS) .and. SD2->D2_TIPO = 'N' // Normal Venda
		
		SD2->( RecLock("SD2",.F.) )
		SD2->D2_TES := SB1->B1_TS
		SD2->( DbUnLock() )
		
	elseif SD2->D2_TIPO = 'D' // Nota de Devolucacao
		
		_nPosicao := aScan( _aDevCompra, {|x|  x[1] $ AllTrim(SD2->D2_COD) .and. x[2] = SD2->D2_TES  } )
		if  _nPosicao > 0 .and. _aDevCompra[_nPosicao,3] <> SD2->D2_TES    // Devolucao de Compra
			
			SD2->( RecLock("SD2",.F.) )
			SD2->D2_TES := _aDevCompra[_nPosicao,3]
			SD2->( DbUnLock() )
			
		endif
		
	endif
	
	SD2->( DbSkip() )
	
enddo


Return




/*************************************************************************************************/


/*************************************************************************************************/

User Function _AtuPISCOFINS()
Local _nTotCOF := _nTotPIS := _nTotNF := 0
Local sDoc := "", sTipo := sFilial := ""
Local nRecno := 0

DbSelectArea("SD1") // Cabecalho NF Entrada
SF1->( DbSetOrder(1) )

DbSelectArea("SF4") // TES

DbSelectArea("SF3") // CABECALHO FISCAL
SF3->( DbSetOrder(5) )

DbSelectArea("SFT") // ITENS FICAIS
SFT->( DbSetOrder(1) )

DbSelectArea("SF1") // Cabecalho de Itens NF

SD1->( DbGoTop() )


do while !SD1->( Eof() )
	
	// 31/12/2009 Data Limite para correcao
	if SD1->D1_EMISSAO < Stod("20091001") .and. SD1->D1_EMISSAO >= Stod("20091231")
		SD1->( DbSkip() )
		Loop
	endif
	
	if empty(SD1->D1_DOC)
		SD1->( DbSkip() )
		Loop
	endif
	
	sDoc  := SD1->D1_DOC+SD1->D1_SERIE+SD1->D1_FORNECE+SD1->D1_LOJA
	sTipo := SD1->D1_TIPO
	_nTotNF := _nTotPIS := _nTotCOF := 0
	lPIS := .F.
	
	do while (SD1->D1_DOC+SD1->D1_SERIE+SD1->D1_FORNECE+SD1->D1_LOJA) = sDoc
		
		SF4->( DbSeek( xFilial("SF4")+SD1->D1_TES ) )
		
		sFilial := SD1->D1_FILIAL
		lPIS := SF4->F4_PISCOF $ '1/2/3'
		if lPIS
			
			// Atualiza os valores do PIS e COFINS
			if (SD1->D1_VALIMP5 <>  ( ( (SD1->D1_TOTAL ) * GetMV("MV_TXCOFIN") ) / 100 ) ) .or. ( SD1->D1_VALIMP6 <> ( ( (SD1->D1_TOTAL ) * GetMV("MV_TXPIS") ) / 100 ) )
				RecLock('SD1',.F.)
				SD1->D1_VALIMP5 :=  ( ( (SD1->D1_TOTAL ) * GetMV("MV_TXCOFIN") ) / 100 )  //COFINS   GetMV("MV_TXCOFIN")    GetMV("MV_TXPIS")
				SD1->D1_VALIMP6 :=  ( ( (SD1->D1_TOTAL ) * GetMV("MV_TXPIS") ) / 100 )  //PIS
				SD1->( DbUnLock() )
			endif
			
			_nTotNF	 += SD1->D1_TOTAL
			_nTotPIS += SD1->D1_VALIMP6
			_nTotCOF += SD1->D1_VALIMP5
			
		else // Limpa se nao e para calcular
			if ( SD1->D1_VALIMP5 <> 0 ) .or. ( SD1->D1_VALIMP6 <> 0 )
				
				SD1->( RecLock('SD1',.F.) )
				SD1->D1_VALIMP5 :=  0  //COFINS
				SD1->D1_VALIMP6 :=  0  //PIS
				SD1->( DbUnLock() )
				
			endif
			
		endif
		
		//Atualiza a SFT
		SFT->( DbSeek( sFilial+"E"+SD1->D1_SERIE+SD1->D1_DOC+SD1->D1_FORNECE+SD1->D1_LOJA+SD1->D1_ITEM+SD1->D1_COD ) )
		
		if !SFT->( Found() )
			//Alert("A NF "+sDoc+" nao gerou Fiscal")
			
		else
			RecLock('SFT',.F.)
			SFT->FT_VALCOF := SD1->D1_VALIMP5  //COFINS
			SFT->FT_VALPIS := SD1->D1_VALIMP6  //PIS
			SFT->FT_CSTPIS := SF4->F4_CSTPIS
			SFT->FT_CSTCOF := SF4->F4_CSTCOF
			SFT->FT_ALIQCOF := iif( lPIS, GetMV("MV_TXCOFIN"), 0 )  //  GetMV("MV_TXCOFIN")    GetMV("MV_TXPIS")
			SFT->FT_ALIQPIS := iif( lPIS, GetMV("MV_TXPIS"), 0 )
			SFT->FT_BASECOF := iif( lPIS, SD1->D1_TOTAL, 0 )
			SFT->FT_BASEPIS := iif( lPIS, SD1->D1_TOTAL, 0)
			SFT->( DbUnLock() )
			
		endif
		
		SD1->( DbSkip() )
		SD1->( DbCommit() )
		
	enddo
	
	SF1->( DbSeek(sFilial+sDoc+sTipo ) )
	if SF1->( Found() ) .and. ( SF1->F1_VALIMP5 <> _nTotPIS .or. SF1->F1_VALIMP6 <> _nTotCOF )
		SF1->( RecLock('SF1',.F.) )
		SF1->F1_VALIMP5 := _nTotPIS
		SF1->F1_VALIMP6 := _nTotCOF
		SF1->( DbUnLock() )
		SF1->( DbCommit() )
		
	else
		
		conout("NF SEM SF1" + sFilial+sDoc )
	endif
	
	SF3->( DbSeek(sFilial+substr(sdoc,10,3)+substr(sdoc,1,9)+substr(sdoc,13,8) ) )
	if SF3->( Found() ) .and. ( SF3->F3_VALIMP5 <> _nTotPIS .or. SF3->F3_VALIMP6 <> _nTotCOF )
		RecLock('SF3',.F.)
		SF3->F3_VALIMP5 := _nTotPIS
		SF3->F3_VALIMP6 := _nTotCOF
		SF3->( DbUnLock() )
	endif
	SF3->( DbCommit() )
	
enddo

Return



//
// Funcao de ajustar das dt_emissao e dt_digitacao para SF1, SD1 e SF3 ficarem iguais
//
User Function _AtuDtEmissao()
Local dDTEmissao := dDTDigita := date()

// CORRECAO NOS ITENS NF. ENTRADA
DbSelectArea("SF1")
SF1->( DbSetOrder(1) )

DbSelectArea("SF3")
SF3->( DbSetOrder(6) )

DbSelectArea("SD1")
SD1->( DbSetOrder(1) )


do while !SF1->( Eof() )
	
	// 31/12/2009 Data Limite para correcao
	if SF1->F1_EMISSAO < Stod("20091001") .or. SF1->F1_EMISSAO >= Stod("20091231")
		SF1->( DbSkip() )
		Loop
	endif
	
	
	dDTEmissao	:= SF1->F1_EMISSAO
	dDTDigita	:= SF1->F1_DTDIGIT
	
	SD1->( DbSeek( xFilial("SD1")+SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA ),.T. )
	if SD1->( Found() )
		
		if Empty(dDTEmissao) .or. Empty(dDTDigita)
			
			dDTEmissao	:= SD1->D1_EMISSAO
			dDTDigita	:= SD1->D1_DTDIGIT
			
			RecLock('SF1',.F.)
			SF1->F1_EMISSAO := dDTEmissao
			SF1->F1_DTDIGIT := dDTDigita
			SF1->( DbUnLock() )
			
		elseif dDTEmissao <> SD1->D1_EMISSAO .or. dDTDigita <> SD1->D1_DTDIGIT
			
			RecLock('SD1',.F.)
			SD1->D1_EMISSAO := dDTEmissao
			SD1->D1_DTDIGIT := dDTDigita
			SD1->( DbUnLock() )
			
		endif
		
	endif
	
	SF3->( DbSeek( xFilial("SF3")+SF1->F1_DOC+SF1->F1_SERIE ) )
	
	if SF3->( Found() ) .and. (dDTEmissao <> SF3->F3_EMISSAO .or. dDTDigita <> SF3->F3_ENTRADA)
		
		RecLock('SF3',.F.)
		SF3->F3_EMISSAO := dDTEmissao
		SF3->F3_ENTRADA := dDTDigita
		SF3->( DbUnLock() )
		
	endif
	
	SF1->( DbSkip() )
	
enddo

Return

Static Function ValidPerg()
_sAlias	:=	Alias()
dbSelectArea("SX1")
dbSetOrder(1)
cPerg 	:=	PADR(cPerg,10)
//                                                                                  -SA1-
/*
u_xPutSx1(     cPerg,"01","CFOP´s    ?","."     ,"."       ,"mv_ch1","C",99,0,0,"G","","","","","mv_par01","","","","","","","","","","","","","","","","")
u_xPutSx1(     cPerg,"02","C.Custo   ?","."     ,"."       ,"mv_ch2","C",99,0,0,"G","","CTT","","","mv_par02","","","","","","","","","","","","","","","","")
u_xPutSx1(     cPerg,"03","Operação  ?","."     ,"."       ,"mv_ch3","C",02,0,0,"G","","DJ","","","mv_par03","","","","","","","","","","","","","","","","")
u_xPutSx1(     cPerg,"04","Data de   ?","."     ,"."       ,"mv_ch4","D",08,0,0,"G","","","","","mv_par04","","","","","","","","","","","","","","","","")
u_xPutSx1(     cPerg,"05","Data ate  ?","."     ,"."       ,"mv_ch5","D",08,0,0,"G","","","","","mv_par05","","","","","","","","","","","","","","","","")
u_xPutSx1(     cPerg,"06","Processa  ?","."     ,"."       ,"mv_ch6","N",01,0,0,"C","","","","","mv_par06","1-Entradas","","","","2-Saidas","","","3-Ambas","","","","","","","")
u_xPutSx1(     cPerg,"07","Processa  ?","."     ,"."       ,"mv_ch7","N",01,0,0,"C","","","","","mv_par07","1-Somente Log","","","","2-Log+Efetiva","","","","","","","","","","")
u_xPutSx1(     cPerg,"08","Re-Proc Livro ?","." ,"."       ,"mv_ch8","N",01,0,0,"C","","","","","mv_par08","1-Sim","","","","2-Nao","","","","","","","","","","")
u_xPutSx1(     cPerg,"09","Norma ?","."     ,"."           ,"mv_ch9","N",01,0,0,"C","","","","","mv_par09","1-EFD Pis Cofins","","","","2-IN86","","","","","","","","","","")
u_xPutSx1(     cPerg,"10","Filtra CFOP/C.Custo ?","."  ,".","mv_cha","N",01,0,0,"C","","","","","mv_par10","1-Sim","","","","2-Nao","","","","","","","","","","")
u_xPutSx1(     cPerg,"11","Efetiva ?"            ,"."  ,".","mv_chb","N",01,0,0,"C","","","","","mv_par11","1-Somente Cadastro","","","","2-Cadastro+Calculos","","","","","","","","","","")
u_xPutSx1(     cPerg,"12","Analisa Bloco P ?"    ,"."  ,".","mv_chc","N",01,0,0,"C","","","","","mv_par12","1-Sim","","","","2-Nao","","","","","","","","","","")
u_xPutSx1(     cPerg,"13","ICMS na base?","."     ,"."     ,"mv_chd","N",01,0,0,"C","","","","","mv_par13","I-Deduz ICMS Cred","","","","S-Deduz ICMS","","","N-Não Deduz ICMS","","","","","","","")
u_xPutSx1(     cPerg,"14","Aplica Ded ICMS?","."     ,"."  ,"mv_che","N",01,0,0,"C","","","","","mv_par14","1-Entradas","","","","2-Saidas","","","3-Ambas","","","","","","","")
u_xPutSx1(     cPerg,"15","Seleciona filiais ?","." ,"."   ,"mv_chf","N",01,0,0,"C","","","","","mv_par15","1-Sim","","","","2-Nao","","","","","","","","","","")
u_xPutSx1(     cPerg,"16","Filtra Produto ?","."  ,"."     ,"mv_chg","C",06,0,0,"G","","SB1","","","mv_par16","","","","","","","","","","","","","","","","")
u_xPutSx1(     cPerg,"17","Grava log na pasta ?","." ,"."  ,"mv_chh","C",99,0,0,"G","","","","","mv_par17","","","","","","","","","","","","","","","")
*/
dbSelectArea(_sAlias)

Return

/*
_____________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦Programa  ¦ LogProc  ¦ Autor ¦ Claudio Ferreira      ¦ Data ¦ 12/09/08 ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Descriçào ¦ Relatorio de Log de Processos                              ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦ Uso      ¦ Generico                                                   ¦¦¦
¦¦¦          ¦                                                            ¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
*/

Static Function LogProc(cOrigem,aLog)


titulo   := "LOG DO PROCESSO - "+cOrigem
cDesc1   := "Este programa irá emitir um Log de Processo"
cDesc2   := "conforme parametros especificados."
cDesc3   := ""
cString  := ""
aReturn  := { "Zebrado", 1,"Administracao", 2, 2, 1, "",1 }
nLastKey := 0
ntamanho := "M"
wnrel    := "LOGPROC"
nomeProg := "LOGPROC"
li       := 99
m_pag    := 1
nTipo    := IIF(aReturn[4]==1,15,18)
wnrel    := SetPrint(cString,wnrel,,@titulo,cDesc1,cDesc2,cDesc3,.F.,,.F.,)
If LastKey() == 27 .Or. nLastKey == 27
	Return
Endif
SetDefault(aReturn,cString)
RptStatus({|| ILogPro2(cOrigem,aLog)},Titulo)

Return Nil

Static Function ILogPro2(cOrigem,aLog)
Local _xi
cabec1  := "Descricao do Evento"
cabec2  := ""
SetRegua(len(aLog))
For _xi:=1 to len(aLog)
	incregua()
	if li > 60
		li:=Cabec(titulo,cabec1,cabec2,nomeprog,nTamanho,nTipo)+1
	endif
	@ li,000 Psay aLog[_xi]
	li++
Next

Roda(0,nTamanho)

Set Device to Screen

If aReturn[5] == 1
	Set Printer To
	dbCommitAll()
	ourspool(wnrel)
endif

MS_FLUSH()

Return Nil




/*
_____________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦Programa  ¦ LogProc  ¦ Autor ¦ Claudio Ferreira      ¦ Data ¦ 12/09/08 ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Descriçào ¦ Relatorio de Log de Processos                              ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦ Uso      ¦ Generico                                                   ¦¦¦
¦¦¦          ¦                                                            ¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
*/

Static Function LogProcTXT(cOrigem,aLog,cPath)

Local cLine := "LOG DO PROCESSO - "+cOrigem + Chr(13)+Chr(10)
Local _xi
cLine +="Periodo de "+Dtoc( mv_par04) +" a "+ Dtoc( mv_par05) + Chr(13)+Chr(10)
For _xi:=1 to len(aLog)
	cLine += aLog[_xi] + Chr(13)+Chr(10) 
Next
cPath:=Alltrim(cPath)
cPath:=cPath+iif( RAT('\', cPath)<>1,'\','')

MemoWrite( cPath +"ReprocPisCofins Fil "+cFilAnt+" - "+dtos(date())+'-'+strtran(time(),':','_')+".txt" , cLine )
  
Return


User Function __MACALCPIS
Local cCalc	:=	"S"
Local nAliq	:=	9
Return {cCalc,nAliq}


Static Function BaseAlqUni(nValor, cChaveCCZ, cContr)

Local nBaseQuant := 0
Local nAliquota  := 0
Local aRet		 := {}
Local cCodNat	 := ""

//Irá buscar a alíquota conforme código da natureza informado, para assim fazer a conversão e encontar a quantidade referente a unidade de medida
//estabelecido pel RFB.

IF CCZ->(msSeek(xFilial("CCZ")+cChaveCCZ))
	If cContr == "PIS"
		nAliquota := CCZ-> CCZ_ALQPIS
	Else
		nAliquota := CCZ-> CCZ_ALQCOF
	EndIF
	cCodNat := IIF( SubStr(CCZ-> CCZ_COD,1,1) $ "7#8", SubStr(CCZ-> CCZ_COD,1,1), "")
	IF nAliquota > 0
		nBaseQuant := NoRound(nValor / nAliquota,2)
		aAdd(aRet, {})
		nPos := Len(aRet)
		aAdd (aRet[nPos],nAliquota) //Base de cálculo em quantidade
		aAdd (aRet[nPos],nBaseQuant)	 //Alíquota em unidade de medida de produto.
		aAdd (aRet[nPos],cCodNat)	 //Código da Natureza da Receita.
	EndIF
EndIF

Return aRet



Static Function RetChvCCZ(clTab,clCod,clGrupo,dlDtEnt)

Local 	aArea		:= GetArea()
Local	aCCZArea    := CCZ->(GetArea())
Local 	cCCZAlias	:= "CCZ"
Local 	cChvCCz 	:= Space(Len(CCZ->(CCZ_TABELA+CCZ_COD+CCZ_GRUPO+DtoS(CCZ_DTFIM))))
Local 	dLastDt		:= CtoD("//")
Local 	clIndex		:= ""
Local 	clFiltro	:= ""
Local 	nlIndex		:= 0
Default	clTab		:= ""
Default	clCod		:= ""
Default	clGrupo		:= ""
Default dlDtEnt		:= CtoD("//")

dbSelectArea(cCCZAlias)
(cCCZAlias)->(DbSetOrder(1))



cCCZAlias	:= GetNextAlias()

BeginSql Alias cCCZAlias
	
	COLUMN CCZ_DTFIM AS DATE
	
	SELECT
	CCZ.CCZ_TABELA
	, CCZ.CCZ_COD
	, CCZ.CCZ_GRUPO
	, CCZ.CCZ_DTFIM
	FROM
	%Table:CCZ% CCZ
	WHERE
	CCZ.%NotDel%
	AND CCZ.CCZ_FILIAL	= %xFilial:CCZ%
	AND CCZ.CCZ_TABELA 	= %Exp:clTab%
	AND CCZ.CCZ_COD		= %Exp:clCod%
	AND CCZ.CCZ_GRUPO 	= %Exp:clGrupo%
	ORDER BY
	CCZ.CCZ_DTFIM
EndSql


dbSelectArea(cCCZAlias)
dbSetOrder(nlIndex+1)


(cCCZAlias)->(dbGoTop())
While (cCCZAlias)->(!Eof())
	If !Empty((cCCZAlias)->CCZ_DTFIM)
		If (dlDtEnt<=(cCCZAlias)->CCZ_DTFIM) .AND. ( Empty(dLastDt) .OR. (dlDtEnt>dLastDt))
			cChvCCz := ((cCCZAlias)->CCZ_TABELA+CCZ_COD+CCZ_GRUPO+DtoS(CCZ_DTFIM))
		EndIf
		dLastDt := (cCCZAlias)->CCZ_DTFIM
	Else
		cChvCCz := ((cCCZAlias)->CCZ_TABELA+CCZ_COD+CCZ_GRUPO+DtoS(CCZ_DTFIM))
	EndIf
	(cCCZAlias)->(dbSkip())
EndDo


DbSelectArea (cCCZAlias)
(cCCZAlias)->(DbCloseArea ())


CCZ->(RestArea(aCCZArea))
RestArea(aArea)

Return cChvCCz

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³VlrPauta  ºAutor  ³Erick G. Dias       º Data ³  09/09/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Processamento dos valores de aliquota e qtd por pauta.     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºParametros³ lCmpNRecFT = Logico de Campos na SFT.					  º±±
±±º          ³ lCmpNRecB1 = Logico de Campos na SB1.					  º±±
±±º          ³ cContrib = Codigo da Contribuicao.						  º±±
±±º          ³ cAliasSFT = Alias da Tabela SFT							  º±±
±±º          ³ cAliasSB1 = Alias da Tabela SB1							  º±±
±±º          ³ lCmpNRecF4 = Logico de Campos na SF4.					  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºRetorno   ³ aRetorno = Array contendo informacoes de Pauta. 		      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/


Static Function VlrPauta(lCmpNRecFT, lCmpNRecB1, cContrib,cAliasSFT,cAliasSB1,lCmpNRecF4)

Local cChaveCCZ		:= ""
Local aBaseAlqUn	:= {}
Local aRetorno		:= {}
Local nPos			:= 0
Local clTab			:= ""
Local clCod			:= ""
Local clGrupo		:= ""
Local dlDtEnt		:= CtoD("  /  /    ")

IF lCmpNRecFT //Campos criados da natureza da receita na tabela SFT
	cChaveCCZ := RetChvCCZ( (cAliasSFT)->FT_TNATREC , (cAliasSFT)->FT_CNATREC , (cAliasSFT)->FT_GRUPONC, (cAliasSFT)->FT_ENTRADA  )
	If !Empty(cChaveCCZ)
		IF cContrib == "PIS"
			aBaseAlqUn :=BaseAlqUni((cAliasSFT)->FT_VALPIS, cChaveCCZ, cContrib)
		ElseIF cContrib == "COF"
			aBaseAlqUn :=BaseAlqUni((cAliasSFT)->FT_VALCOF, cChaveCCZ, cContrib)
		EndIF
	EndIf
	IF len(aBaseAlqUn) > 0
		aAdd(aRetorno, {})
		nPos := Len(aRetorno)
		aAdd (aRetorno[nPos],aBaseAlqUn[1][1]) //Base de cálculo em quantidade
		aAdd (aRetorno[nPos],aBaseAlqUn[1][2])	 //Alíquota em unidade de medida de produto.
		aAdd (aRetorno[nPos],aBaseAlqUn[1][3])	 //Código da Natureza da Receita.
	EndIF
EndIF

If Len(aRetorno) == 0 // Se não conseguiu buscar valores atraves da SFT, irá buscar atraves do produto.
	If lCmpNRecB1 .And. !Empty(SB1->B1_TNATREC) .And. !Empty(SB1->B1_CNATREC)
		clTab	:= SB1->B1_TNATREC
		clCod	:= SB1->B1_CNATREC
		clGrupo	:= SB1->B1_GRPNATR
		dlDtEnt	:= (cAliasSFT)->FT_ENTRADA
	ElseIf  lCmpNRecF4 .And. !Empty(SF4->F4_TNATREC) .And. !Empty(SF4->F4_CNATREC)
		clTab	:= SF4->F4_TNATREC
		clCod	:= SF4->F4_CNATREC
		clGrupo	:= SF4->F4_GRPNATR
		dlDtEnt	:= (cAliasSFT)->FT_ENTRADA
	EndIf
	cChaveCCZ := RetChvCCZ(clTab,clCod,clGrupo,dlDtEnt)
	IF cContrib == "PIS"
		aBaseAlqUn :=BaseAlqUni((cAliasSFT)->FT_VALPIS, cChaveCCZ, cContrib)
	ElseIF cContrib == "COF"
		aBaseAlqUn :=BaseAlqUni((cAliasSFT)->FT_VALCOF, cChaveCCZ, cContrib)
	EndIF
	IF len(aBaseAlqUn) > 0
		aAdd(aRetorno, {})
		nPos := Len(aRetorno)
		aAdd (aRetorno[nPos],aBaseAlqUn[1][1]) //Base de cálculo em quantidade
		aAdd (aRetorno[nPos],aBaseAlqUn[1][2])	 //Alíquota em unidade de medida de produto.
		aAdd (aRetorno[nPos],aBaseAlqUn[1][3])	 //Código da Natureza da Receita.
	EndIF
EndIF

If Len(aRetorno) == 0 // Se não conseguiu buscar alíquotas nem pela SFT e nem pelo produto, então irá considerar alíquota convertida da STF
	aAdd(aRetorno, {})
	nPos := Len(aRetorno)
	IF cContrib == "PIS"
		aAdd (aRetorno[nPos],(cAliasSFT)->FT_PAUTPIS) //Base de cálculo em quantidade
	ElseIF cContrib == "COF"
		aAdd (aRetorno[nPos],(cAliasSFT)->FT_PAUTCOF) //Base de cálculo em quantidade
	EndIF
	aAdd (aRetorno[nPos],(cAliasSFT)->FT_QUANT)	 //Alíquota em unidade de medida de produto.
	aAdd (aRetorno[nPos],"")	 //Código da Natureza da Receita.
EndIF

Return aRetorno
