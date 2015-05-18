Public Class LegalUI
    Inherits System.Web.UI.Page
    Public SecondaryAction As Boolean = False
    Public Agent As Boolean = False
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If (Not IsPostBack) Then

            SecondaryAction = Request.QueryString("Attorney") IsNot Nothing
            Agent = Request.QueryString("Agent") IsNot Nothing

            If Not String.IsNullOrEmpty(Request.QueryString("sn")) Then
                ASPxSplitter1.Panes("listPanel").Visible = False
                ShortSaleCaseList.BindCaseForTest(SecondaryAction AndAlso Agent)

            End If
        End If
    End Sub

    Protected Sub btnCompleteResearch_ServerClick(sender As Object, e As EventArgs)
        If Not String.IsNullOrEmpty(Request.QueryString("sn")) Then
            Dim sn = Request.QueryString("sn").ToString

            Dim wli = WorkflowService.LoadTaskProcess(sn)
            wli.Finish()

            Response.Clear()
            Response.Write("The case is move back to manager.")
            Response.End()
        End If
    End Sub
End Class