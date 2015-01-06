Imports log4net
Imports log4net.Config

Public Class RuleEngineManagement


    Private Sub ToolStripButton1_Click(sender As Object, e As EventArgs) Handles ToolStripButton1.Click

        AddHandler IntranetPortal.RulesEngine.ServiceLog.GetInstance.OnWriteLog, Sub(msg)
                                                                                     Me.Invoke(New MethodInvoker(Sub()
                                                                                                                     Me.lbLogs.Items.Insert(0, String.Format("[{0}] {1}", DateTime.Now.ToString, msg))
                                                                                                                     Logger.Log.Info(msg)
                                                                                                                 End Sub))
                                                                                 End Sub

        AddHandler IntranetPortal.RulesEngine.ServiceLog.GetInstance.OnWriteException, Sub(msg, ex)
                                                                                           Me.Invoke(New MethodInvoker(Sub()
                                                                                                                           Me.lbLogs.Items.Insert(0, String.Format("[{0}] {1}", DateTime.Now.ToString, msg))
                                                                                                                           Logger.Log.Error(msg, ex)
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

Public NotInheritable Class Logger
    Private Sub New()
    End Sub
    Private Shared ReadOnly m_log As ILog = LogManager.GetLogger(GetType(Logger))
    Private Shared _configured As Boolean
    Private Shared _lock As New Object()
    Public Shared ReadOnly Property Log() As ILog
        Get
            If Not _configured Then
                SyncLock _lock
                    If Not _configured Then
                        InitLogger()
                        _configured = True
                    End If
                End SyncLock
            End If
            Return m_log
        End Get
    End Property

    Public Shared Sub InitLogger()
        XmlConfigurator.Configure()
    End Sub
End Class