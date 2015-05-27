Public Class ManagePreViewControl
    Inherits System.Web.UI.UserControl
    Public Property Applicant As String
    Public Property BBLE As String
    Public Property SubmitedDate As DateTime
    Public Property CaseName As String
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not String.IsNullOrEmpty(Request.QueryString("sn")) Then
            Dim wli = WorkflowService.LoadTaskProcess(Request.QueryString("sn"))
            If wli IsNot Nothing Then
                BBLE = wli.ProcessInstance.DataFields("BBLE").ToString
                Applicant = wli.ProcessInstance.Originator
                SubmitedDate = wli.ProcessInstance.StateDate
                CaseName = wli.DisplayName

                BindLegalUser()
            End If
        End If
    End Sub

    Private Sub BindLegalUser()
        Dim users = Roles.GetUsersInRole("Legal-Research")

        Dim userData As New List(Of Object)
        For Each item In users
            userData.Add(New With {
                         .Name = item,
                         .Amount = 10
                         })
        Next

        lbLegalUser.DataSource = userData
        lbLegalUser.DataBind()
    End Sub

    Protected Sub btnSubmit_ServerClick(sender As Object, e As EventArgs)
        If lbLegalUser.SelectedItem Is Nothing Then
            Return
        End If

        If Not String.IsNullOrEmpty(Request.QueryString("sn")) Then
            Dim sn = Request.QueryString("sn").ToString
            Dim searchUser = lbLegalUser.SelectedItem.GetValue("Name")
            Dim wli = WorkflowService.LoadTaskProcess(sn)
            Dim bble = wli.ProcessInstance.DataFields("BBLE").ToString
            wli.ProcessInstance.DataFields("ResearchUser") = searchUser
            wli.Finish()

            Dim lc = Legal.LegalCase.GetCase(bble)
            lc.Status = Legal.LegalCaseStatus.LegalResearch
            lc.ResearchBy = searchUser
            lc.SaveData()

            Response.Clear()
            Response.Write("The case is assign to " & searchUser)
            Response.End()
        End If
    End Sub

End Class