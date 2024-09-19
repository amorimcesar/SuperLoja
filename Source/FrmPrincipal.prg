#include "Xailer.ch"

CLASS TFrmPrincipal FROM TForm

   COMPONENT oMenuPrincipal

   COMPONENT oPages

   COMPONENT oPageProdutos
   COMPONENT oExplorerBarProdutos
   COMPONENT oOptionListProdutos
   COMPONENT oBrowseProdutos
   COMPONENT oSQLQueryProdutos

   COMPONENT oPageClientes
   COMPONENT oExplorerBarClientes
   COMPONENT oOptionListClientes
   COMPONENT oBrowseClientes
   COMPONENT oSQLQueryClientes

   COMPONENT oPagePedidos
   COMPONENT oExplorerBarPedidos
   COMPONENT oOptionListPedidos
   COMPONENT oBevelFooter
   COMPONENT oBevelBrowse
   COMPONENT oBrowsePedidos
   COMPONENT oImageLegendaCancelado
   COMPONENT oLabelLegendaCancelado
   COMPONENT oSQLQueryPedidos

   COMPONENT oMySQL

   METHOD CreateForm()
   METHOD FormInitialize( oSender )
   METHOD MenuPrincipalProdutosClick( oSender, oMenu )
   METHOD OptionNovoProdutoClick( oSender )
   METHOD OptionFecharClick( oSender )
   METHOD SQLQueryProdutosCreate( oSender )
   METHOD OptionAlterarProdutoClick( oSender )
   METHOD BrowseProdutosDblClick( oSender, nKeys, nCol, nRow )
   METHOD OptionExcluirProdutoClick( oSender )
   METHOD BrowseProdutosKeyDown( oSender, nKey, nFlags )
   METHOD OptionFiltrarProdutoClick( oSender )
   METHOD MenuPrincipalClientesClick( oSender, oMenu )
   METHOD SQLQueryClientesCreate( oSender )
   METHOD OptionNovoClienteClick( oSender )
   METHOD OptionAlterarClienteClick( oSender )
   METHOD OptionExcluirClienteClick( oSender )
   METHOD OptionFiltrarClienteClick( oSender )
   METHOD BrowseClientesDblClick( oSender, nKeys, nCol, nRow )
   METHOD MenuPrincipalPedidosClick( oSender, oMenu )
   METHOD SQLQueryPedidosCreate( oSender )
   METHOD OptionNovoPedidoClick( oSender )
   METHOD OptionVisualizarPedidoClick( oSender )
   METHOD OptionCancelarPedidoClick( oSender )
   METHOD ClienteTemPedido()
   METHOD OptionFiltrarPedidoClick( oSender )
   METHOD BrowsePedidosDblClick( oSender, nKeys, nCol, nRow )
   METHOD BrowsePedidosDrawCell( oSender, @cText, @nClrText, @nClrPane, lHighLite, hDC, aRect )
   METHOD BrowseClientesKeyDown( oSender, nKey, nFlags )
   METHOD BrowsePedidosKeyDown( oSender, nKey, nFlags )

ENDCLASS

#include "FrmPrincipal.xfm"

//------------------------------------------------------------------------------

METHOD FormInitialize( oSender ) CLASS TFrmPrincipal

   ::oPages:nIndex:=0

RETURN Nil

//------------------------------------------------------------------------------

METHOD MenuPrincipalProdutosClick( oSender, oMenu ) CLASS TFrmPrincipal

   ::oSQLQueryProdutos:Refresh()
   ::oPages:nIndex:=1
   ::oBrowseProdutos:SetFocus()

RETURN Nil

//------------------------------------------------------------------------------

METHOD SQLQueryProdutosCreate( oSender ) CLASS TFrmPrincipal

   ::oSQLQueryProdutos:lOpen  :=.F.
   ::oSQLQueryProdutos:cSelect:='SELECT id, nome, estoque FROM produtos ORDER BY nome'
   ::oSQLQueryProdutos:lOpen  :=.T.

RETURN Nil

//------------------------------------------------------------------------------

METHOD OptionNovoProdutoClick( oSender ) CLASS TFrmPrincipal

   with object TFrmProduto()
      :cModo:='I'
      :New()
      :cText:='Novo produto'
      :ShowModal()
   end

RETURN Nil

//------------------------------------------------------------------------------

METHOD OptionAlterarProdutoClick( oSender ) CLASS TFrmPrincipal

   if ::oSQLQueryProdutos:RecCount()==0
      MessageBox(, "Não há produto para alterar", "Atenção", MB_ICONWARNING)
      RETURN NIL
   endif

   with object TFrmProduto()
      :cModo:='A'
      :New()
      :cText:='Alterar produto'
      :ShowModal()
   end

RETURN Nil

//------------------------------------------------------------------------------

METHOD OptionExcluirProdutoClick( oSender ) CLASS TFrmPrincipal

   LOCAL oErro

   if ::oSQLQueryProdutos:RecCount()==0
      MessageBox(, "Não há produto para excluir", "Atenção", MB_ICONWARNING)
      RETURN NIL
   endif

   if MessageBox(,"Deseja realmente excluir o produto?","Aten??o",MB_YESNO+MB_ICONWARNING)==IDNO
      RETURN Nil
   endif

   try
      ::oMySQL:BeginTrans()
      ::oMySQL:Execute("DELETE FROM produtos WHERE id="+ValToSQL(::oSQLQueryProdutos:id))
      ::oMySQL:CommitTrans()

      ::oSQLQueryProdutos:Refresh()

    catch oErro
      ::oMySQL:RollBackTrans()
      Grava_Log_Erro(oErro)
      MessageBox(,"Ocorreu um erro ao excluir o produto.","Erro",MB_ICONERROR)
   end

RETURN Nil

//------------------------------------------------------------------------------

METHOD OptionFiltrarProdutoClick( oSender ) CLASS TFrmPrincipal

   if ::oBrowseProdutos:lFilterBar
      ::oBrowseProdutos:lFilterBar:=.F.
      oSender:cText:="Ativar filtro"
    else
      ::oBrowseProdutos:lFilterBar:=.T.
      oSender:cText:="Desativar filtro"
   endif

RETURN Nil

//------------------------------------------------------------------------------

METHOD BrowseProdutosDblClick( oSender, nKeys, nCol, nRow ) CLASS TFrmPrincipal

   ::OptionAlterarProdutoClick()

RETURN Nil

//------------------------------------------------------------------------------

METHOD BrowseProdutosKeyDown( oSender, nKey, nFlags ) CLASS TFrmPrincipal

   if nKey==VK_INSERT
      ::OptionNovoProdutoClick()
    elseif nKey==VK_RETURN
      ::OptionAlterarProdutoClick()
    elseif nKey==VK_DELETE
      ::OptionExcluirProdutoClick()
   endif

RETURN Nil

//------------------------------------------------------------------------------

METHOD MenuPrincipalClientesClick( oSender, oMenu ) CLASS TFrmPrincipal

   ::oSQLQueryClientes:Refresh()
   ::oPages:nIndex:=2
   ::oBrowseClientes:SetFocus()

RETURN Nil

//------------------------------------------------------------------------------

METHOD SQLQueryClientesCreate( oSender ) CLASS TFrmPrincipal

  ::oSQLQueryClientes:lOpen  :=.F.
  ::oSQLQueryClientes:cSelect:='SELECT id, nome FROM clientes ORDER BY nome'
  ::oSQLQueryClientes:lOpen  :=.T.

RETURN Nil

//------------------------------------------------------------------------------

METHOD OptionNovoClienteClick( oSender ) CLASS TFrmPrincipal

   with object TFrmCliente()
      :New()
      :cText:='Novo cliente'
      ::oSQLQueryClientes:AddNew()
      :ShowModal()
   end

RETURN Nil

//------------------------------------------------------------------------------

METHOD OptionAlterarClienteClick( oSender ) CLASS TFrmPrincipal

   if ::oSQLQueryClientes:RecCount()==0
      MessageBox(,"Não há cliente para alterar", "Atenção", MB_ICONWARNING)
      RETURN Nil
   endif

   with object TFrmCliente()
     :New()
     :cText:='Alterar cliente'
     ::oSQLQueryClientes:Edit()
     :ShowModal()
   end

RETURN Nil

//------------------------------------------------------------------------------

METHOD ClienteTemPedido() CLASS TFrmPrincipal

   LOCAL aPedidos:={}, lTemPedidos:=.F.

   Application:oMainForm:oMySQL:Execute("SELECT NULL FROM pedidos WHERE cliente_id="+ValToSQL(::oSQLQueryClientes:id),,@aPedidos)

   lTemPedidos:=Len(aPedidos)>0

RETURN lTemPedidos

//------------------------------------------------------------------------------

METHOD OptionExcluirClienteClick( oSender ) CLASS TFrmPrincipal

   LOCAL oErro

   if ::oSQLQueryClientes:RecCount()==0
      MessageBox(,"Não há cliente para excluir.","Atenção",MB_ICONWARNING)
      RETURN Nil
   endif

   if ::ClienteTemPedido()
      MessageBox(,"O cliente não pode ser excluído porque existe pedido para este cliente.","Atenção",MB_ICONWARNING)
      RETURN Nil
   endif

   if MessageBox(,"Deseja realmente excluir o cliente?","Atenção",MB_YESNO+MB_ICONWARNING)==IDNO
      RETURN Nil
   endif

   try
      ::oSQLQueryClientes:Delete()
    catch oErro
      Grava_Log_Erro(oErro)
      MessageBox(,"Ocorreu um erro ao excluir o cliente.","Erro",MB_ICONERROR)
   end

RETURN Nil

//------------------------------------------------------------------------------

METHOD BrowseClientesKeyDown( oSender, nKey, nFlags ) CLASS TFrmPrincipal

   if nKey==VK_INSERT
      ::OptionNovoClienteClick()
    elseif nKey==VK_RETURN
      ::OptionAlterarClienteClick()
    elseif nKey==VK_DELETE
      ::OptionExcluirClienteClick()
   endif

RETURN Nil

//------------------------------------------------------------------------------

METHOD BrowseClientesDblClick( oSender, nKeys, nCol, nRow ) CLASS TFrmPrincipal

   ::OptionAlterarClienteClick()

RETURN Nil

//------------------------------------------------------------------------------

METHOD OptionFiltrarClienteClick( oSender ) CLASS TFrmPrincipal

   if ::oBrowseClientes:lFilterBar
      ::oBrowseClientes:lFilterBar:=.F.
      oSender:cText:="Ativar filtro"
    else
      ::oBrowseClientes:lFilterBar:=.T.
      oSender:cText:="Desativar filtro"
   endif

RETURN Nil


//------------------------------------------------------------------------------
METHOD MenuPrincipalPedidosClick( oSender, oMenu ) CLASS TFrmPrincipal

   ::oSQLQueryPedidos:Refresh()
   ::oPages:nIndex:=3
   ::oBrowsePedidos:SetFocus()

RETURN Nil

//------------------------------------------------------------------------------

METHOD SQLQueryPedidosCreate( oSender ) CLASS TFrmPrincipal

   ::oSQLQueryPedidos:lOpen  :=.F.
   ::oSQLQueryPedidos:cSelect:="SELECT p.id, p.data, p.cliente_id, c.nome, p.cancelado FROM pedidos p LEFT JOIN clientes c ON p.cliente_id=c.id ORDER BY p.data DESC, p.id DESC"
   ::oSQLQueryPedidos:lOpen  :=.T.

RETURN Nil

//------------------------------------------------------------------------------

METHOD OptionNovoPedidoClick( oSender ) CLASS TFrmPrincipal

   with object TFrmPedido()
      :New()
      :cText:="Novo pedido"
      :ShowModal()
   end

RETURN Nil

//------------------------------------------------------------------------------

METHOD OptionVisualizarPedidoClick( oSender ) CLASS TFrmPrincipal

   if ::oSQLQueryPedidos:RecCount()==0
      MessageBox(,"Não há pedido para visualizar.","Atenção",MB_ICONWARNING)
      RETURN Nil
   endif

   with object TFrmPedido()
      :New()

      :cText:="Visualizar pedido"

      :oEditId:Value         :=::oSQLQueryPedidos:id
      :oEditData:Value       :=::oSQLQueryPedidos:data
      :oComboboxCliente:cText:=AllTrim(Str(::oSQLQueryPedidos:cliente_id))+' - '+::oSQLQueryPedidos:nome

      :oEditData:lEnabled       :=.F.
      :oComboboxCliente:lEnabled:=.F.

      :oLabelCancelado:lVisible:=::oSQLQueryPedidos:cancelado

      :oBtnConfirmar:lVisible      :=.F.
      :oBtnNovoItem:lVisible       :=.F.
      :oBtnAlterarItem:lVisible    :=.F.
      :oBtnExcluirItem:lVisible    :=.F.

      :oBrowseItens:lAllowAppend:=.F.
      :oBrowseItens:lAllowInsert:=.F.
      :oBrowseItens:lAllowEdit  :=.F.
      :oBrowseItens:lAllowDelete:=.F.

      :PreencheBrowseItens()

      :ShowModal()
   end

RETURN Nil

//------------------------------------------------------------------------------

METHOD OptionCancelarPedidoClick( oSender ) CLASS TFrmPrincipal

   LOCAL nPedidoID:=0, nProdutoID:=0, nQuantidade:=0, aItem:={}, aItens:={}, oErro

   if ::oSQLQueryPedidos:RecCount()==0
      MessageBox(,"Não há pedido para cancelar.","Atenção",MB_ICONWARNING)
      RETURN Nil
   endif

   if ::oSQLQueryPedidos:cancelado
      MessageBox(,"O pedido já está cancelado.","Atenção",MB_ICONWARNING)
      RETURN Nil
   endif

   if MessageBox(,"Deseja realmente cancelar esse pedido?","Atenção",MB_YESNO+MB_ICONWARNING)==IDNO
      RETURN Nil
   endif

   try
      nPedidoID:=::oSQLQueryPedidos:id

      ::oMySQL:BeginTrans()
      ::oMySQL:Execute("UPDATE pedidos SET cancelado=1 WHERE id="+ValToSQL(nPedidoID))
      ::oMySQL:Execute("SELECT produto_id, quantidade FROM pedidos_itens WHERE pedido_id="+ValToSQL(nPedidoID),,@aItens)

      for each aItem in aItens
         nProdutoID :=aItem[1]
         nQuantidade:=aItem[2]
         ::oMySQL:Execute("UPDATE produtos SET estoque=estoque+"+ValToSQL(nQuantidade)+" WHERE id="+ValToSQL(nProdutoID))
      next

      ::oMySQL:CommitTrans()
      ::oSQLQueryPedidos:Refresh()

    catch oErro
      ::oMySQL:RollBackTrans()
      Grava_Log_Erro(oErro)
      MessageBox(,"Ocorreu um erro ao cancelar o pedido.","Erro",MB_ICONERROR)
   end

RETURN Nil

//------------------------------------------------------------------------------

METHOD OptionFiltrarPedidoClick( oSender ) CLASS TFrmPrincipal

   if ::oBrowsePedidos:lFilterBar
      ::oBrowseClientes:lFilterBar:=.F.
      oSender:cText:="Ativar filtro"
    else
      ::oBrowsePedidos:lFilterBar:=.T.
      oSender:cText:="Desativar filtro"
   endif

RETURN Nil

//------------------------------------------------------------------------------

METHOD BrowsePedidosDblClick( oSender, nKeys, nCol, nRow ) CLASS TFrmPrincipal

 ::OptionVisualizarPedidoClick()

RETURN Nil

//------------------------------------------------------------------------------

METHOD BrowsePedidosDrawCell( oSender, cText, nClrText, nClrPane, lHighLite, hDC, aRect ) CLASS TFrmPrincipal

   if ::oSQLQueryPedidos:cancelado
      nClrText:=clRed
   endif

RETURN Nil


METHOD BrowsePedidosKeyDown( oSender, nKey, nFlags ) CLASS TFrmPrincipal

if nKey==VK_INSERT
      ::OptionNovoPedidoClick()
    elseif nKey==VK_RETURN
      ::OptionVisualizarPedidoClick()
    elseif nKey==VK_DELETE
      ::OptionCancelarPedidoClick()
   endif

RETURN Nil

//------------------------------------------------------------------------------

//------------------------------------------------------------------------------

METHOD OptionFecharClick( oSender ) CLASS TFrmPrincipal

   ::oPages:nIndex:=0

RETURN Nil

//------------------------------------------------------------------------------
