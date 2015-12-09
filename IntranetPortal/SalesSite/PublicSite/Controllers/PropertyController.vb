Imports System.Web.Mvc

Namespace Controllers
    Public Class PropertyController
        Inherits Controller

        ' GET: Property
        Function Index() As ActionResult
            Return View()
        End Function
    End Class
End Namespace