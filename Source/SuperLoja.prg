#include "Xailer.ch"

Procedure Main()

   SET DATE TO BRITISH
   SET EPOCH TO 1950
   SET CENTURY ON
   SET DECIMALS TO 3

   Application:cTitle := "SuperLoja"
   Application:oIcon := "loja"
   TFrmPrincipal():New( Application ):Show()
   Application:Run()

Return
