Public Class LeadsGenerator
    Inherits System.Web.UI.Page
    Public ZipCodes As List(Of String)
    Public AllNeighName As List(Of String)
    Public AllZoning As List(Of String)
    Public CompletedTask As New List(Of LeadsSearchTask)
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load


        DataBinds()

    End Sub

    Private Sub DataBinds()
        Using context As New Entities
            QueryResultsGrid.DataSource = context.Leads.ToList()
            QueryResultsGrid.DataBind()
            CompletedTask = context.LeadsSearchTasks.Where(Function(s) s.Status = LeadsSearchTaskStauts.Completed And s.CreateBy = Page.User.Identity.Name).ToList
            ZipCodes = context.NYC_DATA_COMMENT.Where(Function(c) c.Type = "ZIP").Select(Function(c) c.Data).ToList
            AllNeighName = context.NYC_DATA_COMMENT.Where(Function(c) c.Type = "Neighborhood").Select(Function(c) c.Data).ToList
            AllZoning = context.NYC_DATA_COMMENT.Where(Function(c) c.Type = "ZONING_MAP").Select(Function(c) c.Data).ToList
        End Using
    End Sub

    Protected Sub SaveSearchPopup_WindowCallback(source As Object, e As DevExpress.Web.ASPxPopupControl.PopupWindowCallbackArgs)
        Using Context As New Entities
            Dim s = New LeadsSearchTask
            s.TaksName = e.Parameter.Split("|")(0)
            s.SearchFileds = e.Parameter.Split("|")(1)
            s.CreateBy = Page.User.Identity.Name
            s.CreateTime = Date.Now
            Context.LeadsSearchTasks.Add(s)
            Context.SaveChanges()
        End Using
    End Sub
    Protected Sub cbStartProcess_Callback(source As Object, e As DevExpress.Web.ASPxCallback.CallbackEventArgs)
        Dim procName = e.Parameter
        Dim searchName = e.Parameter
        Dim searchData = e.Parameter
        WorkflowService.StartLeadsSearchProcess(procName, searchName, searchData)
    End Sub
End Class