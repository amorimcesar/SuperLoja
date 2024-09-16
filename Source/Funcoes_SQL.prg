#include "Xailer.ch"

//------------------------------------------------------------------------------

FUNCTION ValToSQL(xValor,cTipo)

   DEFAULT cTipo TO ValType(xValor)

   if cTipo=='BLOB'
      xValor:=IIF(Empty(xValor),'Null','0x'+xValor)
    elseif cTipo=='C'
      xValor:="'"+StrMySql( xValor )+"'"
    elseif cTipo=='N'
      xValor:=AllTrim(Str(xValor))
    elseif cTipo=='D'
      xValor:=IIF(Empty(xValor),"'0000-00-00'","'"+DToSQL(xValor)+"'")
    elseif cTipo=='L'
      xValor:=IIF(xValor,"'1'","'0'")
    elseif cTipo=='T'
      xValor:="'"+DTToSql(xValor)+"'"
    else
      xValor:='Null'
   endif

RETURN xValor

//------------------------------------------------------------------------------