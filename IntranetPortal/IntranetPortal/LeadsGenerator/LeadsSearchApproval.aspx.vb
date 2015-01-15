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

    Private Sub Binddata()
        If Not String.IsNullOrEmpty("sn") Then
            Dim wli = WorkflowService.LoadTaskProcess(Request.QueryString("sn"))
            If wli IsNot Nothing Then
                SearchName = wli.ProcessInstance.DataFields("SearchName").ToString
                SearchData = wli.ProcessInstance.DataFields("SearchData").ToString
                Applicant = wli.ProcessInstance.Originator
                ActivityName = wli.ActivityName
            End If
        End If
    End Sub

    Protected Sub cbApproval_Callback(source As Object, e As DevExpress.Web.ASPxCallback.CallbackEventArgs)
        If Not String.IsNullOrEmpty("sn") Then
            Dim wli = WorkflowService.LoadTaskProcess(Request.QueryString("sn"))
            If wli IsNot Nothing Then
                wli.ProcessInstance.DataFields("Result") = e.Parameter
                wli.Finish()
            End If
        End If
    End Sub
End Class