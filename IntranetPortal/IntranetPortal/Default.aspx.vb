Imports DevExpress.Web

Public Class Default2
    Inherits System.Web.UI.Page
    'Private layoutFomat = "<table><tr><td style=""width: 120px;"">{0}</td><td><div class=""raund-label2"">{1}</div></td></tr></table>"

    Public ContentUrl As String = "/SummaryPage.aspx" '"about:blank"
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not Page.IsPostBack Then
            If Not String.IsNullOrEmpty(Request.QueryString("key")) Then
                ContentUrl = String.Format("/LeadAgent.aspx?c=Search&key={0}&id={1}", Request.QueryString("key"), Request.QueryString("id"))
            End If

            If Roles.GetRolesForUser().Any(Function(ss) ss.Contains("ShortSale-")) Then
                ContentUrl = "/ShortSale/ShortSaleSummaryPage.aspx"
                Return
            End If

            If Roles.GetRolesForUser().Any(Function(ss) ss.Contains("Title-")) Then
                ContentUrl = "/MyDefault.aspx?name=Title"
                Return
            End If

            If User.IsInRole("Construction-Users") OrElse User.IsInRole("Construction-Manager") Then
                ContentUrl = "/MyDefault.aspx"
            End If

        End If
    End Sub
End Class