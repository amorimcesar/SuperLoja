#include "Xailer.ch"

CLASS TFrmPrincipal FROM TForm

   COMPONENT oMenuPrincipal

   COMPONENT oPages
   COMPONENT oPageProdutos
   COMPONENT oExplorerBarProdutos
   COMPONENT oOptionListProdutos
   COMPONENT oBrowseProdutos
   COMPONENT oSQLQueryProdutos

   COMPONENT oMySQL
   COMPONENT oOptionListProdutosItem5
   COMPONENT oBrowseProdutosColumn3

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
   METHOD OptionExcluirProdutoClick( oSender )
   METHOD OptionFiltrarProdutoClick( oSender )

ENDCLASS

#include "FrmPrincipal.xfm"

//------------------------------------------------------------------------------

METHOD FormInitialize( oSender ) CLASS TFrmPrincipal

   ::oPages:nIndex:=0

RETURN Nil

//------------------------------------------------------------------------------

METHOD MenuPrincipalProdutosClick( oSender, oMenu ) CLASS TFrmPrincipal

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

METHOD OptionFecharClick( oSender ) CLASS TFrmPrincipal

   ::oPages:nIndex:=0

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
