Public Class Troubleshooting

    Private Sub btnLeadsRule_Click(sender As Object, e As EventArgs) Handles btnLeadsRule.Click
        Dim bble = TextBox1.Text
        IntranetPortal.RulesEngine.LeadsEscalationRule.Execute(bble)
    End Sub

    Private Sub Button1_Click(sender As Object, e As EventArgs) Handles Button1.Click
        IntranetPortal.RulesEngine.TaskEscalationRule.Excute(CInt(txtTaskId.Text))
    End Sub

    Private Sub Button2_Click(sender As Object, e As EventArgs) Handles Button2.Click
        IntranetPortal.AssignRule.GetRuleById(CInt(txtRuleId.Text)).Execute()
    End Sub

    Private Sub Button3_Click(sender As Object, e As EventArgs) Handles Button3.Click
        'IntranetPortal.RulesEngine.TaskSummaryRule.LoadSummaryEmail("Chris Yan")
        'Return

        Using client As New PortalService.CommonServiceClient
            client.SendTaskSummaryEmail(txtName.Text)
        End Using
    End Sub

    Private Sub Button4_Click(sender As Object, e As EventArgs) Handles Button4.Click
        Dim rule As New IntranetPortal.RulesEngine.LoopServiceRule
        rule.Execute()
    End Sub

    Private Sub Button5_Click(sender As Object, e As EventArgs) Handles Button5.Click
        Dim rule As New IntranetPortal.RulesEngine.CompleteTaskRule
        rule.ExpiredReminderTask("4032340101", 9685, 747)
    End Sub

    Private Sub Button6_Click(sender As Object, e As EventArgs) Handles Button6.Click
        Dim rule As New IntranetPortal.RulesEngine.RecycleProcessRule
        rule.Execute()
    End Sub

    Private Sub Button7_Click(sender As Object, e As EventArgs) Handles Button7.Click
        Dim name = txtName.Text
        Try
            IntranetPortal.RecycleManage.BatchPostponeRecycle(name, 5)
        Catch ex As Exception
            IntranetPortal.RulesEngine.ServiceLog.Log("Error messager: ", ex)
        End Try
    End Sub

    Private Sub Button8_Click(sender As Object, e As EventArgs) Handles Button8.Click
        Dim name = txtName.Text
        Try
            IntranetPortal.RecycleManage.PostponeRecyle(name, 5, "Michael Gendin")
        Catch ex As Exception
            IntranetPortal.RulesEngine.ServiceLog.Log("Error messager: ", ex)
        End Try
    End Sub

    Private Sub Button9_Click(sender As Object, e As EventArgs) Handles Button9.Click
        Dim name = txtRecycleFrom.Text
        Dim recycleTo = txtRecycleTo.Text
        Dim startDate = txtRecycleDate.Text

        Dim result = IntranetPortal.RecycleManage.UndoRecycle(name, recycleTo, startDate)
        MessageBox.Show(String.Format("{0} leads are undo recycled.", result))
    End Sub

    Private Sub Troubleshooting_Load(sender As Object, e As EventArgs) Handles MyBase.Load

    End Sub

    Private Sub btnEmailSend_Click(sender As Object, e As EventArgs) Handles btnEmailSend.Click
        Using client As New PortalService.CommonServiceClient
            Try
                client.SendTeamActivityEmail(cbTeams.Text)
                MessageBox.Show("Mail is send!")
            Catch ex As Exception
                MessageBox.Show("Exception: " & ex.Message)
            End Try
        End Using
    End Sub

    Private Sub txtTeamName_TextChanged(sender As Object, e As EventArgs)

    End Sub

    Private Sub TabControl1_SelectedIndexChanged(sender As Object, e As EventArgs) Handles TabControl1.SelectedIndexChanged
        If TabControl1.SelectedTab.Name = "tabEmail" Then
            cbTeams.DataSource = IntranetPortal.Team.GetAllTeams().Select(Function(t) t.Name).ToList
        End If
    End Sub
End Class