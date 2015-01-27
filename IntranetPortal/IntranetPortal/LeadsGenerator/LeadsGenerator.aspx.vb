Public Class LeadsGenerator
    Inherits System.Web.UI.Page
    Public ZipCodes As List(Of String)
    Public AllNeighName As List(Of String)
    Public AllZoning As List(Of String)
    Public AllPropertyCode As List(Of String)
    Public CompletedTask As New List(Of LeadsSearchTask)
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load


        DataBinds()

    End Sub

    Private Sub DataBinds()
        Using context As New Entities
           
            CompletedTask = context.LeadsSearchTasks.Where(Function(s) s.Status = LeadsSearchTaskStauts.Completed And s.CreateBy = Page.User.Identity.Name).ToList
            ZipCodes = context.NYC_DATA_COMMENT.Where(Function(c) c.Type = "ZIP").Select(Function(c) c.Data).ToList
            AllNeighName = context.NYC_DATA_COMMENT.Where(Function(c) c.Type = "Neighborhood").Select(Function(c) c.Data).ToList
            AllZoning = context.NYC_DATA_COMMENT.Where(Function(c) c.Type = "ZONING").Select(Function(c) c.Data).ToList
            AllPropertyCode = context.NYC_DATA_COMMENT.Where(Function(c) c.Type = "PropertyDesc").Select(Function(c) c.Data).ToList
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

            WorkflowService.StartLeadsSearchProcess(s.TaksName, s.TaksName, s.SearchFileds, s.Id)
        End Using
    End Sub

    Protected Sub cbStartProcess_Callback(source As Object, e As DevExpress.Web.ASPxCallback.CallbackEventArgs)
    End Sub

    

    Protected Sub loadClick_Callback(source As Object, e As DevExpress.Web.ASPxCallback.CallbackEventArgs)
        Dim SearchName = e.Parameter

        Using context As New Entities
            Dim results = context.SearchResults.Where(Function(s) s.Type = SearchName).ToList
            QueryResultsGrid.DataSource = results
            QueryResultsGrid.DataBind()

        End Using

    End Sub
End Class