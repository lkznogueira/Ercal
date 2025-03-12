#INCLUDE "PROTHEUS.CH"

/*/{Protheus.doc} ]
    (connection if execution schedulle)
    @author byudi
    @since 31/07/2020
    @version 01
    /*/
class schedulle 

    data _cFunction
    data _aTable
    data _aConnection
    data _lConnection

    method new() constructor

    method setConnectionNoSmartClient( _cFunc, _aTab, _aConect ) 

endClass

/*/{Protheus.doc} schedulle
    (constructor schedulle)
    @author byudi
    @since 31/07/2020
    @version 01.01
    @param n/a
    @return self
    /*/
method new() class schedulle

    ::_cFunction        :=  ""
    ::_aTable           :=  {}
    ::_aConnection      :=  {}
    ::_lConnection      :=  .F.

return self

/*/{Protheus.doc} setConnectionNoSmartClient
    (return if connection when smartclient)
    @author byudi
    @since 31/07/2020
    @version 01.01
    @param _cFunc, _aTab, _aConect
    @return _lConnection
    /*/
method setConnectionNoSmartClient(_cFunc, _aTab, _aConnect) class schedulle

    ::_cFunction    :=  _cFunc
    ::_aTable       :=  _aTab
    ::_aConnection   :=  _aConnect
    ::_lConnection  :=  .F.

    if GetRemoteType() == -1
        
        if aConnection != nil
    
            RPCSetType(3)

            RPCSetEnv(::_aConnection[1],::_aConnection[2],,,::_cFunction,,::_aTable)

            ::_lConnection := .T.

            conout("[setConnectionNoSmartClient] - successful connection without SmartClient - " + DTOC(Date()) + " - " + Time())

        else

            conout("[setConnectionNoSmartClient] - company and subsidiary not informed for connection - " + DTOC(Date()) + " - " + Time())   

        endIf

    else

        conout("[setConnectionNoSmartClient] - connection with SmartClient - " + DTOC(Date()) + " - " + Time())   

	endIf

return