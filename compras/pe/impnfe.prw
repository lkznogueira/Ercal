#INCLUDE "Protheus.ch"
#INCLUDE "Totvs.ch"
#INCLUDE "topconn.ch"

/*/
Autor: Carlos Daniel
Data: 06/06/2024
Descrição: Importação Notas Fiscas de outra empresa
/*/

User Function IMPNFE

//Local aArea         := GetArea()
//Local alItens	    := {}
//Local alCabec       :={}
//Local aAreaSRA := SF2->( GetArea() )
Private cTes        := ''
Private cOper       := ''
Private cQry        := ""
Private cQryUpd     := ""
Private cQrySD2     := ""
Private nMaxNum     := ""
Private nCount      := 0
Private nSaldo      := 0
Private lGrava      := .F.
Private lok         := .F.
Private vLrVend     := 0
Private lMsErroAuto := .F.
Private aAreaSF2
Private cDoc       
Private cSer       
Private cCli       
Private cLoj   
Private cFill   
Private cFili
Private cProd
Private cPerg  := "impnfe"  
aCabec         := {}
aItens         := {}
aLinha         := {}

If cFilAnt <> '4200'

    MsgStop( 'Não esta habilitado para = '+cFilAnt+', Autorizado apenas na 4200.', 'Atencao' )

    Return()

EndIf

//PutSX1(cPerg , "01" , "FILIAL                    " , "" , "" , "mv_ch1" , "C" , 4 , 0 , 0 , "G" , "", "", "", "", "mv_par01" , "    " ,"","","", "    " ,"","","", "    " , "" , "" , "" , "" , "" , "" , "" , "" )
PutSx1(cPerg,  "01",  "FILIAL                    " , "" , "" , "mv_ch1" , "N" , 1 , 0 , 0 , "G" , "", "","",""  , "mv_par01" , "4101","4101","4101","4104","4104","4104","","","","","","","","","")
PutSX1(cPerg , "02" , "DATA DE                   " , "" , "" , "mv_ch2" , "D" , 4 , 0 , 0 , "G" , "", "", "", "", "mv_par02" , "    " ,"","","", "        " ,"","","", "        " , "" , "" , "" , "" , "" , "" , "" , "" )
PutSX1(cPerg , "03" , "DATA ATE    	             " , "" , "" , "mv_ch3" , "D" , 4 , 0 , 0 , "G" , "", "", "", "", "mv_par03" , "    " ,"","","", "   	  " ,"","","", "        " , "" , "" , "" , "" , "" , "" , "" , "" )

pergunte(cPerg,.T.)

iF MV_PAR01 == 1
    cFili := '4101'
Elseif MV_PAR01 == 2
    cFili := '4104'
Else
    MsgStop( 'Filial Incorreta, Operação Cancelada.', 'Atencao' )

    Return()
EndIf
If Select("cQry") > 0                                 
     
    cQry->(dbclosearea())

EndIf   

cQry := "SELECT * "
cQry += "FROM SF2010 SF2 "
cQry += "INNER JOIN SD2010 SD2 ON F2_FILIAL = D2_FILIAL AND D2_DOC = F2_DOC AND D2_CLIENTE = F2_CLIENTE "                                      	
cQry += "WHERE SD2.D_E_L_E_T_ <> '*' "
cQry += "AND SF2.D_E_L_E_T_ <> '*' "		
cQry += "AND F2_FILIAL = '"+cFili+"' " 
cQry += "AND F2_CLIENTE = '002966' " 
cQry += "AND F2_EMISSAO BETWEEN '"+dtos(MV_PAR02)+"' AND '"+dtos(MV_PAR03)+"' "     
cQry += "AND F2_XIMPORT  = ' ' "              

MemoWrite("C:\TEMP\NotasImportadas.txt",cQry)
cQry := ChangeQuery(cQry)

TcQuery cQry New Alias "cQry" 

Count to nCount

If nCount <= 0

    MsgStop( 'Nenhum registro encontrado.', 'Atencao' )

    Return()

EndIf

If MsgYesNo('Serão Geradas: '+" "+cValToChar(nCount)+" ?"+'Notas, Deseja Continuar ?')  //pergunta se deseja deletar

    cQry->(DbGoTop()) 
	
    Begin Transaction  

	While !cQry->(EOF())
        
    cDoc  := cQry->F2_DOC
    cSer  := cQry->F2_SERIE
    cCli  := '000009'
    If cFili == '4104'
        cLoj  := '01'
        cProd := '001082'
    Else
        cLoj  := '02'
        cProd := '000185'
    EndIf
    cFill := '4200'

    aadd(aCabec,{"F1_TIPO"       ,"N"         })
    aadd(aCabec,{"F1_FORMUL"     ,"N"         })
    aadd(aCabec,{"F1_FILIAL"     ,'4200'      })
    aadd(aCabec,{"F1_DOC"        ,cQry->F2_DOC})
    aadd(aCabec,{"F1_SERIE"      ,cQry->F2_SERIE  })
    aadd(aCabec,{"F1_EMISSAO"    ,stod(cQry->F2_EMISSAO)   })
    aadd(aCabec,{"F1_CHVNFE"     ,cQry->f2_CHVNFE })
    aadd(aCabec,{"F1_DESPESA"    ,cQry->F2_DESPESA}) 
    aadd(aCabec,{"F1_FORNECE"    ,cCli         })
    aadd(aCabec,{"F1_LOJA"       ,cLoj         })
    aadd(aCabec,{"F1_ESPECIE"    ,"SPED"       })
    aadd(aCabec,{"F1_EST"        ,cQry->F2_EST })
    aadd(aCabec,{"F1_COND"       ,"001"        })
    aadd(aCabec,{"F1_SEGURO"     ,cQry->F2_SEGURO,NIL       })
    aadd(aCabec,{"F1_FRETE"      ,cQry->F2_FRETE,NIL        })
    aadd(aCabec,{"F1_DESCONT"    ,cQry->F2_DESCONT,NIL      })
    //aadd(aCabec,{"F1_VALMERC"    ,25    ,NIL})
    //aadd(aCabec,{"F1_VALBRUT"    ,25    ,NIL})


    aadd(aLinha,{"D1_ITEM"      ,'0001'         ,Nil})
    aadd(aLinha,{"D1_FILIAL"    ,'4200'         ,Nil})
    aadd(aLinha,{"D1_COD"       ,cProd          ,Nil})
    aadd(aLinha,{"D1_UM"        ,'UN'           ,Nil})
    aadd(aLinha,{"D1_QUANT"     ,cQry->D2_QUANT ,Nil})
    aadd(aLinha,{"D1_VUNIT"     ,cQry->D2_PRCVEN,Nil})    
    aadd(aLinha,{"D1_TOTAL"     ,(cQry->D2_PRCVEN*cQry->D2_QUANT ),Nil})
    aadd(aLinha,{"D1_LOCAL"     ,"01"          ,Nil})         
    aadd(aLinha,{"D1_DESCRI"    ,Posicione("SB1",1,xFilial("SB1")+cProd,"B1_DESC"),Nil})             
    aadd(aLinha,{"D1_FCICOD"    ,''            ,Nil}) 
    aadd(aLinha,{"D1_DESPESA"   ,0             ,Nil})
    aadd(aLinha,{"D1_DESC"      ,0             ,Nil})
    aadd(aLinha,{"D1_VALDESC"   ,0             ,Nil}) 
    aAdd(aLinha,{"D1_LOTEFOR"   ,' '           ,NIL})
    aadd(aLinha,{"D1_CC"        ,' '           ,Nil})
    aadd(aLinha,{"D1_CLASFIS"   ,"5  "         ,Nil})
    aadd(aLinha,{"AUTDELETA"    ,"N"           ,Nil})
    aadd(aItens,aLinha)

    //MSExecAuto({|x,y,z| MATA140(x,y,z)}, aCabec,aItens,3)
    MsgRun("Aguarde gerando Pré-Nota de Entrada."+cDoc,,{|| MSExecAuto({|x,y,z| MATA140(x,y,z)}, aCabec,aItens,3 )})
		
    If lMsErroAuto
        mostraerro()
        
        //Monta o Update
        cQryUpd := "UPDATE SF2010 SET F2_XIMPORT = '"+TRIM("erro"+cDoc+TRIM(cSer)+cCli)+"' "  + CRLF
	    cQryUpd += "WHERE D_E_L_E_T_ <> '*' "       + CRLF
 	    cQryUpd += "AND F2_FILIAL = '"+cFili+"' "   + CRLF
	    cQryUpd += "AND F2_DOC = '"+cDoc+"' "       + CRLF
	    cQryUpd += "AND F2_CLIENTE = '002966' "   + CRLF  

        MemoWrite("C:\TEMP\cQry_erroIMPORTNFE.txt",cQryUpd)

        //Tenta executar o update
        nErro := TcSqlExec(cQryUpd)

        If nErro != 0   
            //cQry->(DbSkip())     
      	    MsgStop("Erro na execução da query: "+TcSqlError(), "Atenção")
       	    DisarmTransaction()
        EndIf
        //cQry->(DbSkip())
    Else

        //Monta o Update
        cQryUpd := "UPDATE SF2010 SET F2_XIMPORT = '"+TRIM(cFill+cDoc+TRIM(cSer)+cCli)+"' "  + CRLF
	    cQryUpd += "WHERE D_E_L_E_T_ <> '*' "       + CRLF
 	    cQryUpd += "AND F2_FILIAL = '"+cFili+"' "   + CRLF
	    cQryUpd += "AND F2_DOC = '"+cDoc+"' "       + CRLF
	    cQryUpd += "AND F2_CLIENTE = '002966' "   + CRLF  

        MemoWrite("C:\TEMP\cQry_UPDIMPORTNFE.txt",cQryUpd)

        //Tenta executar o update
        nErro := TcSqlExec(cQryUpd)

        If nErro != 0   
            cQry->(DbSkip())     
      	    MsgStop("Erro na execução da query: "+TcSqlError(), "Atenção")
       	    DisarmTransaction()
        EndIf

    ENDIF
    aCabec         := {}
    aItens         := {}
    aLinha         := {}
	cQry->(DbSkip())			
    Enddo

	End Transaction

Else
    //cQry->(DbSkip())
    Return
EndIf
Aviso("Atenção", "Processo Finalizado com Sucesso!" ,{"Ok"})
Return
