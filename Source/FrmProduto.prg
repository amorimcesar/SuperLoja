#include "Xailer.ch"

CLASS TFrmProduto FROM TForm

   DATA cModo INIT 'I'

   COMPONENT oLabelId
   COMPONENT oEditId
   COMPONENT oLabelNome
   COMPONENT oEditNome
   COMPONENT oLabelEstoque
   COMPONENT oEditEstoque
   COMPONENT oBtnConfirmar

   METHOD CreateForm()
   METHOD BtnConfirmarClick( oSender )
   METHOD FormInitialize( oSender )
   METHOD FormKeyDown( oSender, nKey, nFlags )
   METHOD FormInitialize( oSender )

ENDCLASS

#include "FrmProduto.xfm"


//------------------------------------------------------------------------------

METHOD FormInitialize( oSender ) CLASS TFrmProduto

   if ::cModo=='A'
      ::oEditId:Value     :=Application:oMainForm:oSQLQueryProdutos:id
      ::oEditNome:Value   :=Application:oMainForm:oSQLQueryProdutos:nome
      ::oEditEstoque:Value:=Application:oMainForm:oSQLQueryProdutos:estoque
   endif

RETURN Nil

//------------------------------------------------------------------------------

METHOD FormKeyDown( oSender, nKey, nFlags ) CLASS TFrmProduto

   if nKey==VK_ESCAPE
      ::Close()
   endif

RETURN Nil

//------------------------------------------------------------------------------

METHOD BtnConfirmarClick( oSender ) CLASS TFrmProduto

   LOCAL cSQL:='', oErro

   try
      if ::cModo=='I'
         cSQL:=" INSERT INTO produtos (nome, estoque) VALUES ("
         cSQL+=ValToSQL(::oEditNome:Value)+','
         cSQL+=ValToSQL(::oEditEstoque:Value)+")"
       elseif ::cModo=='A'
         cSQL:=" UPDATE produtos SET "
         cSQL+=" nome="+ValToSQL(::oEditNome:Value)+','
         cSQL+=" estoque="+ValToSQL(::oEditEstoque:Value)
         cSQL+=" WHERE id="+ValToSQL(::oEditId:Value)
      endif

      Application:oMainForm:oMySQL:BeginTrans()
      Application:oMainForm:oMySQL:Execute(cSQL)
      Application:oMainForm:oMySQL:CommitTrans()

      ::Close()

      Application:oMainForm:oSQLQueryProdutos:Refresh()

    catch oErro
      Application:oMainForm:oMySQL:RollbackTrans()
      Grava_Log_Erro(oErro)
      MessageBox(,"Ocorreu um erro ao registrar o produto.","Erro",MB_ICONERROR)
   end

RETURN Nil

//------------------------------------------------------------------------------

