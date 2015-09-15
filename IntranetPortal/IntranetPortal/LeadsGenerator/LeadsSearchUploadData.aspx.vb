Public Class LeadsSearchUploadData
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
            End If
        End If
    End Sub

    Protected Sub cbApproval_Callback(source As Object, e As DevExpress.Web.CallbackEventArgs)
        If Not String.IsNullOrEmpty(Request.QueryString("sn")) Then
            Dim wli = WorkflowService.LoadTaskProcess(Request.QueryString("sn"))
            If wli IsNot Nothing Then
                wli.ProcessInstance.DataFields("Result") = e.Parameter
                wli.Finish()
            End If
        End If
    End Sub

    Protected Sub SearchResultsUpolad_FilesUploadComplete(sender As Object, e As DevExpress.Web.FilesUploadCompleteEventArgs)

    End Sub
End Class