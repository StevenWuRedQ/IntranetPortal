Imports DevExpress.Web.ASPxGridView

Public Class LeadsGenerator
    Inherits System.Web.UI.Page
    Public ZipCodes As List(Of String)
    Public AllNeighName As List(Of String)
    Public AllZoning As List(Of String)
    Public AllPropertyCode As List(Of String)
    Public CompletedTask As New List(Of LeadsSearchTask)
    Public MaxSelect = 250
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load


        DataBinds()

    End Sub

    Private Sub DataBinds()
        Using context As New Entities
            BindGrid("Demo Leads Search")
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




    Protected Sub QueryResultsGrid_CustomCallback(sender As Object, e As DevExpress.Web.ASPxGridView.ASPxGridViewCustomCallbackEventArgs)
        If (e.Parameters.StartsWith("loadFunction")) Then
            Dim funName = e.Parameters.Split("|")(1)
            CallByName(Me, funName, CallType.Method)
        Else
            Dim SearchName = e.Parameters
            BindGrid(SearchName)
        End If
        


    End Sub
    Protected Sub BindGrid(SearchName As String)
        Using context As New Entities
            Dim results = context.SearchResults.Where(Function(s) s.Type = SearchName).ToList
            'Dim s As SearchResult

            QueryResultsGrid.DataSource = results
            QueryResultsGrid.DataBind()

        End Using
    End Sub

    Protected Sub QueryResultsGrid_HtmlRowPrepared(sender As Object, e As DevExpress.Web.ASPxGridView.ASPxGridViewTableRowEventArgs)
        If e.RowType <> GridViewRowType.Data Then
            Return
        End If
        Dim resultId As Integer = Convert.ToInt32(e.GetValue("Id"))
        Dim s = SearchResult.getSeachResult(resultId)

        If Not String.IsNullOrEmpty(s.AgentInLeads) Then
            Dim c = System.Drawing.Color.FromArgb(194, 193, 193)

            e.Row.BackColor = c ' rgb(194, 193, 193)
        End If

    End Sub

    Public Sub Select250_ServerClick()


        Dim count = 0
        Dim maxAdd = LeadMaxAdd()
        If (maxAdd < 0) Then
            Alert("You have enough leads in your bank !")
            Return
        End If
        For Each rt In CType(QueryResultsGrid.DataSource, List(Of SearchResult))
            'Dim resultId As Integer = Convert.ToInt32(rt.Item("Id"))
            'Dim s = SearchResult.getSeachResult(resultId)
            If String.IsNullOrEmpty(rt.AgentInLeads) Then
                QueryResultsGrid.Selection.SelectRow(count)
                count = count + 1
                If (count >= maxAdd) Then
                    Exit For
                End If
            End If
        Next

    End Sub
    Protected Sub Alert(message As String)
        ErrorMessage.Item("hidden_value") = message
    End Sub
    Protected Function HasNewLeadsInProtal() As Integer
        Using Context As New Entities
            Return Context.Leads.Where(Function(l) l.EmployeeName = Page.User.Identity.Name And l.Status = LeadStatus.NewLead).Count()
        End Using

        Return 0
    End Function
    Protected Function LeadMaxAdd() As Integer
        Return MaxSelect - HasNewLeadsInProtal()
    End Function
    Public Sub ImportSelect_ServerClick()
        Dim maxAdd = LeadMaxAdd()
        Dim selectrows = QueryResultsGrid.GetSelectedFieldValues("BBLE")
        If selectrows.Count <= 0 Then
            Alert("You didn't select leads !")
            Return
        End If
        Dim empID = Employee.GetInstance(Page.User.Identity.Name).EmployeeID
        If selectrows.Count > maxAdd Then
            Using Context As New Entities
                For Each row In selectrows
                    Dim l = New Lead
                    l.EmployeeName = Page.User.Identity.Name
                    l.EmployeeID = empID
                    l.BBLE = row
                    l.Status = LeadStatus.NewLead
                    l.AssignBy = l.EmployeeName
                    l.AssignDate = Date.Now

                    Context.Leads.Add(l)

                Next
                Context.SaveChanges()
            End Using
        Else
            Throw New Exception("Only can import !" + maxAdd)
        End If
    End Sub
End Class