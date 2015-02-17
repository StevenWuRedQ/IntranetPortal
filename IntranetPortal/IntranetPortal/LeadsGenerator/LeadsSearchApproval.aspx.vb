Imports Newtonsoft.Json

Public Class LeadsSearchApproval
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not Page.IsPostBack Then
            Binddata()
        End If
    End Sub

    Public Property SearchName As String
    Public Property Applicant As String
    Public Property SearchData As String
    Public Property ActivityName As String
    Public Property SubmitedDate As DateTime
    Public Property DeclineReason As String

    Private Sub Binddata()
        If Not String.IsNullOrEmpty(Request.QueryString("sn")) Then
            Dim wli = WorkflowService.LoadTaskProcess(Request.QueryString("sn"))
            If wli IsNot Nothing Then
                SearchName = wli.ProcessInstance.DataFields("SearchName").ToString
                SearchData = wli.ProcessInstance.DataFields("SearchData").ToString
                Applicant = wli.ProcessInstance.Originator
                ActivityName = wli.ActivityName
                SubmitedDate = wli.ProcessInstance.StateDate
                GetSearchData()

            Else
                GetTestData()
            End If
        End If

        If Not String.IsNullOrEmpty(Request.QueryString("ProcInstId")) Then
            Dim procInst = WorkflowService.LoadProcInstById(CInt(Request.QueryString("ProcInstId")))
            SearchName = procInst.GetDataFieldValue("SearchName")
            SearchData = procInst.GetDataFieldValue("SearchData")
            Applicant = procInst.Originator
            SubmitedDate = procInst.StartDate
            ActivityName = procInst.ActivityInstances.Last.ActivityName
            tdButton.Visible = False
            GetSearchData()
        Else
            GetSearchData()
        End If
    End Sub
    Private Sub GetSearchData()
        Using Context As New Entities
            Dim task
            If (String.IsNullOrEmpty(SearchName)) Then
                task = Context.LeadsSearchTasks.ToList.Last()
            Else
                task = Context.LeadsSearchTasks.Where(Function(s) s.TaksName = SearchName).FirstOrDefault
            End If

            If task Is Nothing Then
                Return
            End If

            SearchName = task.TaksName
            hfSearchName.Value = SearchName
            DeclineReason = task.DeclineReason
        End Using
    End Sub
    Private Sub GetTestData()
        Using Context As New Entities
            SearchData = Context.LeadsSearchTasks.ToList.Last().SearchFileds.ToString
        End Using
    End Sub

    Protected Sub cbApproval_Callback(source As Object, e As DevExpress.Web.ASPxCallback.CallbackEventArgs)
        If Not String.IsNullOrEmpty(Request.QueryString("sn")) Then
            Dim wli = WorkflowService.LoadTaskProcess(Request.QueryString("sn"))
            Dim strReslut = e.Parameter
            If wli IsNot Nothing Then
                If (e.Parameter.StartsWith("Decline")) Then
                    strReslut = e.Parameter.Split("|")(0)
                    Dim DelcineReason = e.Parameter.Split("|")(1)
                    Using ctx As New Entities
                        Dim searchTask = ctx.LeadsSearchTasks.Where(Function(s) s.TaksName = hfSearchName.Value).FirstOrDefault
                        If (searchTask IsNot Nothing) Then
                            searchTask.DeclineReason = DelcineReason

                            ctx.SaveChanges()
                        End If
                    End Using
                End If
                wli.ProcessInstance.DataFields("result") = strReslut
                wli.Finish()
            End If
        End If
    End Sub
End Class