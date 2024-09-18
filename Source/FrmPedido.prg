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
   COMPONENT oBrowseItens
   COMPONENT oBtnNovoItem
   COMPONENT oBtnAlterarItem
   COMPONENT oBtnExcluirItem

   METHOD CreateForm()
   METHOD ComboboxClienteCreate( oSender )
   METHOD BtnConfirmarClick( oSender )
   METHOD ValidaDados()
   METHOD GetClienteId()
   METHOD GetProdutoId( cProdutoNome )
   METHOD FormKeyDown( oSender, nKey, nFlags )
   METHOD BtnNovoItemClick( oSender )
   METHOD BrowseItensColumnProdutoCreate( oSender )
   METHOD GravaPedido( nPedidoID )
   METHOD GravaItensDoPedido( nPedidoID )
   METHOD BtnAlterarItemClick( oSender )
   METHOD BtnExcluirItemClick( oSender )
   METHOD PreencheBrowseItens()

ENDCLASS

#include "FrmPedido.xfm"

//------------------------------------------------------------------------------

METHOD ComboboxClienteCreate( oSender ) CLASS TFrmPedido

   LOCAL aCliente:={}, aClientes:={}, cID:='', cNome:=''

   Application:oMainForm:oMySQL:Execute("SELECT id, nome FROM clientes ORDER BY nome",,@aClientes)

   for each aCliente in aClientes
      cID  :=Alltrim(Str(aCliente[1]))
      cNome:=aCliente[2]
      ::oComboboxCliente:AddItem(cID+' - '+cNome)
   next

RETURN Nil

//------------------------------------------------------------------------------

METHOD BrowseItensColumnProdutoCreate( oSender ) CLASS TFrmPedido

   LOCAL aProduto:={}, aProdutos:={}, cID:='', cNome:=''

   Application:oMainForm:oMySQL:Execute("SELECT id, nome FROM produtos ORDER BY nome",,@aProdutos)

   for each aProduto in aProdutos
      cID  :=AllTrim(Str(aProduto[1]))
      cNome:=aProduto[2]
      AAdd(::oBrowseItens:ColWithHeader("Produto"):aEditListText,cID+' - '+cNome)
   next

RETURN Nil

//------------------------------------------------------------------------------

METHOD BtnConfirmarClick( oSender ) CLASS TFrmPedido

   LOCAL oErro, nPedidoID:=0

   if !::ValidaDados()
      RETURN Nil
   endif

   try
      Application:oMainForm:oMySQL:BeginTrans()

      ::GravaPedido(@nPedidoID)
      ::GravaItensDoPedido(nPedidoID)

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

   if Empty(::oBrowseItens:aArrayData)
      MessageBox(,"Informe os itens do pedido.","Atenção",MB_ICONWARNING)
      RETURN .F.
   endif

RETURN .T.

//------------------------------------------------------------------------------


METHOD GravaPedido( nPedidoID ) CLASS TFrmPedido

   LOCAL cSQL:='', aPedidoID:={}

   cSQL:="INSERT INTO pedidos (data, cliente_id) VALUES ("+ValToSQL(::oEditData:Value)+","+ValToSQL(::GetClienteId())+")"

   Application:oMainForm:oMySQL:Execute(cSQL)

   Application:oMainForm:oMySQL:Execute("SELECT LAST_INSERT_ID()",,@aPedidoID)

   nPedidoID:=aPedidoID[1,1]

RETURN Nil

//------------------------------------------------------------------------------

METHOD GetClienteId() CLASS TFrmPedido

   LOCAL nPosicaoTraco:=0, nClienteID:=0

   nPosicaoTraco:=At('-', ::oComboboxCliente:cText)

   if nPosicaoTraco>0
      nClienteID:=Val(SubStr(::oComboboxCliente:cText,1,nPosicaoTraco-1))
   endif

RETURN nClienteID

//------------------------------------------------------------------------------

METHOD GravaItensDoPedido( nPedidoID ) CLASS TFrmPedido

   LOCAL aItem:={}, nProdutoID:=0, nQuantidade:=0, cSQL:=''

   for each aItem in ::oBrowseItens:aArrayData
      nProdutoID :=::GetProdutoId(aItem[1])
      nQuantidade:=aItem[2]

      cSQL:="INSERT INTO pedidos_itens (pedido_id, produto_id, quantidade) VALUES ("
      cSQL+=ValToSQL(nPedidoID)  +","
      cSQL+=ValToSQL(nProdutoID) +","
      cSQL+=ValToSQL(nQuantidade)+")"

      Application:oMainForm:oMySQL:Execute(cSQL)

      cSQL:="UPDATE produtos SET estoque=estoque-"+ValToSQL(nQuantidade)+" WHERE id="+ValToSQL(nProdutoID)

      Application:oMainForm:oMySQL:Execute(cSQL)
   next

RETURN Nil

//------------------------------------------------------------------------------

METHOD GetProdutoId( cProdutoNome ) CLASS TFrmPedido

   LOCAL nPosicaoTraco:=0, nProdutoID:=0

   nPosicaoTraco:=At('-',cProdutoNome)

   if nPosicaoTraco>0
      nProdutoID:=Val(SubStr(cProdutoNome,1,nPosicaoTraco-1))
   endif

RETURN nProdutoID

//------------------------------------------------------------------------------

METHOD FormKeyDown( oSender, nKey, nFlags ) CLASS TFrmPedido

   if nKey==VK_ESCAPE
      ::Close()
   endif

RETURN Nil

//------------------------------------------------------------------------------

METHOD BtnNovoItemClick( oSender ) CLASS TFrmPedido

   ::oBrowseItens:Append()

RETURN Nil

//------------------------------------------------------------------------------

METHOD BtnAlterarItemClick( oSender ) CLASS TFrmPedido

   if Empty(::oBrowseItens:aArrayData)
      MessageBox(,"Não há item para alterar.","Atenção",MB_ICONWARNING)
      RETURN Nil
   endif

   ::oBrowseItens:Edit()

RETURN Nil

//------------------------------------------------------------------------------

METHOD BtnExcluirItemClick( oSender ) CLASS TFrmPedido

   if Empty(::oBrowseItens:aArrayData)
      MessageBox(,"Não há item para excluir.","Atenção",MB_ICONWARNING)
      RETURN Nil
   endif

   ::oBrowseItens:Delete()

RETURN Nil

//------------------------------------------------------------------------------

METHOD PreencheBrowseItens() CLASS TFrmPedido

   LOCAL cSQL:='', aItem:={}, aItens:={}, cNome:='', nQuantidade:=0

   cSQL:=" SELECT"
   cSQL+=" pi.produto_id,"
   cSQL+=" p.nome,"
   cSQL+=" pi.quantidade"
   cSQL+=" FROM pedidos_itens pi"
   cSQL+=" LEFT JOIN produtos p ON pi.produto_id=p.id"
   cSQL+=" WHERE pi.pedido_id="+ValToSQL(Application:oMainForm:oSQLQueryPedidos:id)

   Application:oMainForm:oMySQL:Execute(cSQL,,@aItens)

   for each aItem in aItens
      cNome      :=AllTrim(Str(aItem[1]))+' - '+aItem[2]
      nQuantidade:=aItem[3]
      ::oBrowseItens:AddRow({cNome,nQuantidade})
   next

RETURN Nil

//------------------------------------------------------------------------------