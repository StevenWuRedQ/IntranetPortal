Public Class Test
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Response.Write(Roles.IsUserInRole("123", "OfficeManager-Bronx"))
    End Sub

End Class