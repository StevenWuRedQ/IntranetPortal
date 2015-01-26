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

    Private Sub Binddata()
        If Not String.IsNullOrEmpty(Request.QueryString("sn")) Then
            Dim wli = WorkflowService.LoadTaskProcess(Request.QueryString("sn"))
            If wli IsNot Nothing Then
                SearchName = wli.ProcessInstance.DataFields("SearchName").ToString
                SearchData = wli.ProcessInstance.DataFields("SearchData").ToString
                Applicant = wli.ProcessInstance.Originator
                ActivityName = wli.ActivityName
                SubmitedDate = wli.ProcessInstance.StateDate
            Else
                GetTestData()
            End If
        End If

        If Not String.IsNullOrEmpty(Request.QueryString("ProcInstId")) Then
            Dim procInst = WorkflowService.LoadProcInstById(CInt(Request.QueryString("ProcInstId")))
            SearchName = procInst.GetDataFieldValue("SearchName")
            SearchData = procInst.GetDataFieldValue("SearchData")
            Applicant = procInst.Originator
            ActivityName = procInst.ActivityInstances.Last.ActivityName
            tdButton.Visible = False
        End If
    End Sub
    Private Sub GetTestData()
        Using Context As New Entities
            SearchData = Context.LeadsSearchTasks.ToList.Last().SearchFileds.ToString
        End Using
    End Sub
    Protected Sub cbApproval_Callback(source As Object, e As DevExpress.Web.ASPxCallback.CallbackEventArgs)
        If Not String.IsNullOrEmpty(Request.QueryString("sn")) Then
            Dim wli = WorkflowService.LoadTaskProcess(Request.QueryString("sn"))
            If wli IsNot Nothing Then
                wli.ProcessInstance.DataFields("Result") = e.Parameter
                wli.Finish()
            End If
        End If
    End Sub
End Class