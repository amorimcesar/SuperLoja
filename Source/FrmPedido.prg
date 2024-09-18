#include "Xailer.ch"

CLASS TFrmPedido FROM TForm

   COMPONENT oLabelId
   COMPONENT oEditId
   COMPONENT oLabelData
   COMPONENT oEditData
   COMPONENT oLabelCliente
   COMPONENT oComboboxCliente
   COMPONENT oBtnConfirmar
   COMPONENT oLabelCancelado

   METHOD CreateForm()
   METHOD ComboboxClienteCreate( oSender )
   METHOD BtnConfirmarClick( oSender )
   METHOD ValidaDados()
   METHOD GetClienteId()
   METHOD FormKeyDown( oSender, nKey, nFlags )

ENDCLASS

#include "FrmPedido.xfm"

//------------------------------------------------------------------------------

METHOD ComboboxClienteCreate( oSender ) CLASS TFrmPedido

   LOCAL aCliente:={}, aClientes:={}

   Application:oMainForm:oMySQL:Execute("SELECT nome FROM clientes ORDER BY nome",,@aClientes)

   for each aCliente in aClientes
      ::oComboboxCliente:AddItem(aCliente[1])
   next

RETURN Nil

//------------------------------------------------------------------------------

METHOD BtnConfirmarClick( oSender ) CLASS TFrmPedido

   LOCAL cSQL:='', oErro

   if !::ValidaDados()
      RETURN Nil
   endif

   try
      cSQL:="INSERT INTO pedidos (data, cliente_id) VALUES ("+ValToSQL(::oEditData:Value)+","+ValToSQL(::GetClienteId())+")"

      Application:oMainForm:oMySQL:BeginTrans()
      Application:oMainForm:oMySQL:Execute(cSQL)
      Application:oMainForm:oMySQL:CommitTrans()

      Application:oMainForm:oSQLQueryPedidos:Refresh()

      ::Close()

    catch oErro
      Application:oMainForm:oMySQL:RollbackTrans()
      Grava_Log_Erro(oErro)
      MessageBox(,"Ocorreu um erro ao registrar o produto.","Erro",MB_ICONERROR)
   end

RETURN Nil

//------------------------------------------------------------------------------

METHOD ValidaDados() CLASS TFrmPedido

   if Empty(::oEditData:Value)
      MessageBox(,"Informe a data do pedido.","Atenção",MB_ICONWARNING)
      RETURN .F.
   endif

   if Empty(::oComboboxCliente:cText)
      MessageBox(,"Informe o cliente.","Atenção",MB_ICONWARNING)
      RETURN .F.
   endif

RETURN .T.

//------------------------------------------------------------------------------

METHOD GetClienteId() CLASS TFrmPedido

   LOCAL aCliente:={}, nClienteID:=0

   Application:oMainForm:oMySQL:Execute("SELECT id FROM clientes WHERE nome="+ValToSQL(::oComboboxCliente:cText),,@aCliente)

   if Len(aCliente)>0
      nClienteID:=aCliente[1,1]
   endif

RETURN nClienteID

//------------------------------------------------------------------------------

METHOD FormKeyDown( oSender, nKey, nFlags ) CLASS TFrmPedido

   if nKey==VK_ESCAPE
      ::Close()
   endif

RETURN Nil

//------------------------------------------------------------------------------
