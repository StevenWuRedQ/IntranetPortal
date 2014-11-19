Public Class RuleEngineManagement


    Private Sub ToolStripButton1_Click(sender As Object, e As EventArgs) Handles ToolStripButton1.Click

        AddHandler IntranetPortal.RulesEngine.ServiceLog.GetInstance.OnWriteLog, Sub(msg)
                                                                                     Me.Invoke(New MethodInvoker(Sub()
                                                                                                                     Me.lbLogs.Items.Insert(0, String.Format("[{0}] {1}", DateTime.Now.ToString, msg))
                                                                                                                 End Sub))
                                                                                 End Sub

        Dim svr = IntranetPortal.RulesEngine.RulesService.GetInstance

        AddHandler svr.OnStatusChange, Sub(status)
                                           Me.Invoke(New MethodInvoker(Sub()
                                                                           Me.lblStatus.Text = String.Format("Current Status: {0}", status.ToString)
                                                                       End Sub))
                                       End Sub
        Dim td As New Threading.Thread(New Threading.ThreadStart(AddressOf svr.Start))
        td.Start()
    End Sub

    Private Sub ToolStripButton3_Click(sender As Object, e As EventArgs) Handles ToolStripButton3.Click
        Dim frm = New Troubleshooting
        frm.Show()
    End Sub
End Class