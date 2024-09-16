#include "Xailer.ch"

CLASS TFrmCliente FROM TForm

   COMPONENT oLabelId
   COMPONENT oLabelNome
   COMPONENT oEditId
   COMPONENT oEditNome
   COMPONENT oBtnConfirmar

   METHOD CreateForm()
   METHOD BtnConfirmarClick( oSender )
   METHOD FormInitialize( oSender )
   METHOD ValidaDados()
   METHOD FormClose( oSender, @lClose )
   METHOD FormKeyDown( oSender, nKey, nFlags )

ENDCLASS

#include "FrmCliente.xfm"

//------------------------------------------------------------------------------

METHOD FormInitialize( oSender ) CLASS TFrmCliente

  ::oEditId:oDataSet  :=Application:oMainForm:oSQLQueryClientes
  ::oEditNome:oDataSet:=Application:oMainForm:oSQLQueryClientes

RETURN Nil

//------------------------------------------------------------------------------

METHOD FormKeyDown( oSender, nKey, nFlags ) CLASS TFrmCliente

   if nKey==VK_ESCAPE
      ::Close()
   endif

RETURN Nil

//------------------------------------------------------------------------------

METHOD FormClose( oSender, lClose ) CLASS TFrmCliente

   if Application:oMainForm:oSQLQueryClientes:lOnAppend() .OR. Application:oMainForm:oSQLQueryClientes:lOnEdit()
      Application:oMainForm:oSQLQueryClientes:Cancel()
   endif

RETURN Nil

//------------------------------------------------------------------------------

METHOD BtnConfirmarClick( oSender ) CLASS TFrmCliente

   Local oErro

   if !::ValidaDados()
      RETURN NIL
   endif

   try
      Application:oMainForm:oSQLQueryClientes:Update()
      ::Close()
    catch oErro
      Grava_Log_Erro(oErro)
      MessageBox(,"Ocorreu um erro ao registrar o cliente.","Erro",MB_ICONERROR)
   end

RETURN Nil

//------------------------------------------------------------------------------

METHOD ValidaDados() CLASS TFrmCliente

   if Empty(::oEditNome:Value)
      MessageBox(, "Informe o nome do cliente.", "Atenção", MB_ICONWARNING )
      RETURN.F.
   endif

RETURN .T.

//------------------------------------------------------------------------------