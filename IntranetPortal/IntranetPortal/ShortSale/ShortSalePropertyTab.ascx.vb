Imports Newtonsoft.Json
Imports IntranetPortal.ShortSale
Public Class ShortSalePropertyTab
    Inherits System.Web.UI.UserControl
    Public Property propertyInfo As New PropertyBaseInfo
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load



    End Sub
    Sub initPropertyInfo()
        Using Context As New Entities
            'propertyInfo = Internal.sh .Where(Function(pi) pi.BBLE = "123").FirstOrDefault()
        End Using
    End Sub


End Class