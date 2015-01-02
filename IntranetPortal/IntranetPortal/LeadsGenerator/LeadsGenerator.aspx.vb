Public Class LeadsGenerator
    Inherits System.Web.UI.Page
    Public ZipCodes As List(Of String)
    Public AllNeighName As List(Of String)
    Public AllZoning As List(Of String)
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load


        'DataBinds()

    End Sub

    Private Sub DataBinds()
        Using context As New Entities
            QueryResultsGrid.DataSource = context.Leads.ToList()
            QueryResultsGrid.DataBind()
            ZipCodes = context.LeadsInfoes.OrderBy(Function(o) o.ZipCode).Select(Function(l) l.ZipCode).Distinct().ToList
            AllNeighName = context.LeadsInfoes.OrderBy(Function(l) l.NeighName).Select(Function(l) l.NeighName).Distinct().ToList
            AllZoning = context.LeadsInfoes.Select(Function(l) l.Zoning).Distinct.ToList
        End Using
    End Sub

End Class