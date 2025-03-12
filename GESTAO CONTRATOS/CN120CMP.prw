#include "protheus.ch"
#include "fwmvcdef.ch"
#INCLUDE "rwmake.ch"

STATIC CQRYCN120ESY := ""

/*/{Protheus.doc} User Function CN120CMP
    (long_description)
    @type  Function
    @author user
    @since 16/07/2020
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/

User Function CN120CMP()
	Local aCab  		:= PARAMIXB[1]
	Local aCampos  		:= PARAMIXB[2]
	Local cQry          := U_GetQry120()
	Local cAlias        := ""

	cAlias := MPSysOpenQuery(ChangeQuery(cQry))

	if !(cAlias)->(Eof())
		//if (cAlias)->CN9_ESPCTR == '1'
		AAdd( aCab, GetSx3Cache( "CN9_TPCTO", "X3_TITULO" ) )
		Aadd( aCampos, { "CN9_TPCTO", GetSx3Cache( "CN9_TPCTO", "X3_TIPO" ), GetSx3Cache( "CN9_TPCTO", "X3_CONTEXT" ),GetSx3Cache( "CN9_TPCTO", "X3_PICTURE" ) } )
		//ElseIf (cAlias)->CN9_ESPCTR == '2'
		AAdd( aCab, GetSx3Cache( "CN9_DESCRI", "X3_TITULO" ) )
		Aadd( aCampos, { "CN9_DESCRI", GetSx3Cache( "CN9_DESCRI", "X3_TIPO" ), GetSx3Cache( "CN9_DESCRI", "X3_CONTEXT" ),GetSx3Cache( "CN9_DESCRI", "X3_PICTURE" ) } )
		//Endif
	Endif

	(cAlias)->(DbCloseArea())

Return {aCab,aCampos}

/*/{Protheus.doc} User Function CN120ESY
    (long_description)
    @type  Function
    @author user
    @since 16/07/2020
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
User Function CN120ESY()
	Local cQuery    := PARAMIXB[1]
	Local cFields   := " CN9_TPCTO ,CN9_DESCRI,"
	Local cRet      as char

	cRet := StrTran(cQuery, "SELECT", "SELECT "+cFields )
	cRet := StrTran(cRet, "GROUP BY", "GROUP BY "+cFields )
	cRet := StrTran(cRet, "ORDER BY", "ORDER BY "+cFields )

	U_SetQry120(cRet)

Return cRet

User function GetQry120()
Return CQRYCN120ESY

User function SetQry120(cQuery)
	CQRYCN120ESY := cQuery
Return
