#include "Xailer.ch"

//------------------------------------------------------------------------------

FUNCTION Grava_Log_Erro( oErro )

   LOCAL dData:=Date(), cHora:=Time(), nArquivo, nWorkArea:=Select(), lWorkAreas:=.F., cFileError, nCount:=0

   nArquivo:=FCreate("Error.log")

   if FError()==0
      FWrite(nArquivo,PadC(' Arquivo: Error.log ',80,'=')+CRLF)

      FWrite(nArquivo,CRLF)

		FWrite(nArquivo,PadR(' Data do erro',20)+': '+DToC(dData)      +CRLF)
		FWrite(nArquivo,PadR(' Hora do erro',20)+': '+cHora            +CRLF)
      FWrite(nArquivo,PadR(' Usuário'     ,20)+': '+GetUserName()    +CRLF)
		FWrite(nArquivo,PadR(' Computador'  ,20)+': '+GetComputerName()+CRLF)

		FWrite(nArquivo,CRLF)

      FWrite(nArquivo,PadC(' Informações do erro ',80,'-')+CRLF)

      FWrite(nArquivo,CRLF)

      FWrite(nArquivo,PadR(' Subsistema'       ,20)+': '+oErro:subsystem()               +CRLF)
		FWrite(nArquivo,PadR(' Código subsistema',20)+': '+Ltrim(ToString(oErro:subcode()))+CRLF)
		FWrite(nArquivo,PadR(' Descrição do erro',20)+': '+oErro:description()             +CRLF)
		FWrite(nArquivo,PadR(' Operação'         ,20)+': '+oErro:operation()               +CRLF)

      FWrite(nArquivo,CRLF)

		FWrite(nArquivo,PadR(' Rota do erro',20)+': '+CRLF)

      if ValType(oErro:Cargo)=="A" .and. Len(oErro:Cargo)>0 .and. ValType(oErro:Cargo[1])=="C" .and. oErro:Cargo[1]=="Xailer: Error stack trace."
         for nCount:=2 TO Len(oErro:Cargo)
            FWrite(nArquivo, " -> "+oErro:Cargo[nCount,1]+" ("+LTrim(Str(oErro:Cargo[nCount,2],20))+")"+CRLF)
         next
       else
         do while !Empty(ProcName(++nCount))
            FWrite(nArquivo, " -> "+ProcName(nCount)+" ("+LTrim(Str(ProcLine(nCount),20))+")"+CRLF)
         enddo
      endif

      FWrite(nArquivo,Replicate('=',80)+CRLF)

      FClose(nArquivo)
   endif

RETURN NIL

//------------------------------------------------------------------------------