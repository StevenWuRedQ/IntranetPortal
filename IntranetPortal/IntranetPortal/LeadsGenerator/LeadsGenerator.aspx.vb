Public Class LeadsGenerator
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        If (Not IsPostBack) Then
            'DataBinds()
        End If
    End Sub
    Private Sub DataBinds()
        Using context As New Entities
            QueryResultsGrid.DataSource = context.Leads.ToList()
            QueryResultsGrid.DataBind()
        End Using

    End Sub

End Class