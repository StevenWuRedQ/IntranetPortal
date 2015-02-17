Imports Newtonsoft.Json
Public Class ZipMap
    Inherits System.Web.UI.Page
    Public Property leadsByZip As String
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        bindData()
    End Sub
    Sub bindData()
        Dim s
        Using ctx As New Entities

            s = ctx.LeadsInfoes.GroupBy(Function(l) l.ZipCode).Select(Function(f) New With {.Count = f.Count, .ZipCode = f.Key}).ToList


        End Using
        leadsByZip = JsonConvert.SerializeObject(s)
    End Sub
End Class