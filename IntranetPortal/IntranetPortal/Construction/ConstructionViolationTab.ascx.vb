Imports HtmlAgilityPack

Public Class ConstructionViolationTab
    Inherits System.Web.UI.UserControl

    Class DOBViolation
        Public Property TotalViolation As Integer
        Public Property TotalOpenViolation As Integer
    End Class

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

    End Sub

    Public Sub GetInfoFromDOB(Url As String)
        Dim doc = New HtmlDocument
        doc.Load(Url)
        Dim link = doc.DocumentNode.SelectNodes("//tr[./td/b/a.text()]")
    End Sub

End Class