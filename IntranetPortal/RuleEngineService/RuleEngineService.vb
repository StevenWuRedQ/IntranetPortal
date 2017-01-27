Public Class RuleEngineService

    Private EventLog1 As System.Diagnostics.EventLog

    Public Sub New(ByVal cmdArgs() As String)
        InitializeComponent()
        Dim eventSourceName As String = "RuleEngine"
        Dim logName As String = "EngineLog"
        If (cmdArgs.Count() > 0) Then
            eventSourceName = cmdArgs(0)
        End If

        If (cmdArgs.Count() > 1) Then
            logName = cmdArgs(1)
        End If

        Me.EventLog1 = New System.Diagnostics.EventLog
        If Not System.Diagnostics.EventLog.SourceExists(eventSourceName) Then
            System.Diagnostics.EventLog.CreateEventSource(eventSourceName, logName)
        End If
        EventLog1.Source = eventSourceName
        EventLog1.Log = logName
    End Sub

    Shared Sub Main(ByVal cmdArgs() As String)
        Dim ServicesToRun() As System.ServiceProcess.ServiceBase
        ServicesToRun = New System.ServiceProcess.ServiceBase() {New RuleEngineService(cmdArgs)}
        System.ServiceProcess.ServiceBase.Run(ServicesToRun)
    End Sub


    Protected Overrides Sub OnStart(ByVal args() As String)
        ' Add code here to start your service. This method should set things
        ' in motion so your service can do its work.

        EventLog1.WriteEntry("In OnStart")
        IntranetPortal.RulesEngine.RulesService.GetInstance.Start()
        EventLog1.WriteEntry("Engine Started")
    End Sub

    Protected Overrides Sub OnStop()
        EventLog1.WriteEntry("Engine Stopped")
        ' Add code here to perform any tear-down necessary to stop your service.
        IntranetPortal.RulesEngine.RulesService.GetInstance.StopService()
    End Sub

End Class
