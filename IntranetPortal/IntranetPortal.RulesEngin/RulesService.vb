Imports System.Threading
Imports IntranetPortal.Core

Public Class RulesService
    Private Shared ServiceInstance As RulesService
    Private StateObjs As New List(Of StateObjClass)
    Public Delegate Sub StatusChange(sta As ServiceStatus)
    Public Event OnStatusChange As StatusChange
    Private serviceMode As RunningMode

    Private _svrStatus As ServiceStatus
    Public Property Status As ServiceStatus
        Get
            Return _svrStatus
        End Get
        Set(value As ServiceStatus)
            _svrStatus = value
            RaiseEvent OnStatusChange(_svrStatus)
        End Set
    End Property

    Public Shared Function GetInstance() As RulesService
        If ServiceInstance Is Nothing Then
            ServiceInstance = New RulesService
        End If

        Return ServiceInstance
    End Function

    Public Shared ReadOnly Property Mode As RunningMode
        Get
            Return GetInstance.serviceMode
        End Get
    End Property

    Public Sub Start()
        If Status <> ServiceStatus.Running Then
            Status = ServiceStatus.Running

            InitServiceMode()
            InitRules()

            Log("Service is running")
            Log("Service Running Mode: " + Mode.ToString)

            For Each Rule In rules
                Log("Inital Rule: " & Rule.RuleName)
                RunTimer(Rule)
                Log("Inital Rule (" & Rule.RuleName & ") Finished. ")
            Next

            Log("Service is Start")
        End If
    End Sub

    Dim rules As List(Of BaseRule)
    Private Sub InitRules()
        rules = New List(Of BaseRule)
        'rules.Add(New RecycleProcessRule() With {.ExecuteOn = TimeSpan.Parse("19:00:00"), .Period = TimeSpan.Parse("1.0:0:0"), .RuleName = "Recycle Leads"})
        'rules.Add(New CompleteTaskRule() With {.ExecuteOn = TimeSpan.Parse("20:00:00"), .Period = TimeSpan.Parse("1.0:0:0"), .RuleName = "Complete Leads Task"})
        'rules.Add(New LeadsAndTaskRule() With {.ExecuteOn = TimeSpan.Parse("22:00:00"), .Period = TimeSpan.Parse("1.0:0:0"), .RuleName = "Leads and Task Rule"})

        rules.Add(New AssignLeadsRule() With {.ExecuteOn = TimeSpan.Parse("01:00:00"), .Period = TimeSpan.Parse("1.0:0:0"), .RuleName = "Assign Leads Rule"})
        'rules.Add(New EmailSummaryRule() With {.ExecuteOn = TimeSpan.Parse("08:00:00"), .Period = TimeSpan.Parse("1.0:0:0"), .RuleName = "User Task Summary Rule"})

        rules.Add(New LoopServiceRule() With {.ExecuteOn = TimeSpan.Parse("00:00:00"), .Period = TimeSpan.Parse("00:20:00"), .RuleName = "Data Loop Rule", .ExecuteNow = True})

        'rules.Add(New ExpiredAllReminderRule With {.ExecuteOn = TimeSpan.Parse("18:31:00"), .Period = TimeSpan.Parse("10.0:0:0"), .RuleName = "Expired all reminder"})
        'rules.Add(New CreateReminderBaseOnErrorProcess() With {.ExecuteOn = TimeSpan.Parse("00:00:00"), .Period = TimeSpan.Parse("00:20:00"), .RuleName = "CreateReminderBaseOnErrorProcess Rule", .ExecuteNow = True})

        'rules.Add(New LeadsAndTaskRule() With {.ExecuteOn = TimeSpan.Parse("00:00:00"), .Period = TimeSpan.Parse("0:1:0"), .RuleName = "Leads and Task Rule"})
        'rules.Add(New LoopServiceRule() With {.ExecuteOn = TimeSpan.Parse("00:00:01"), .Period = TimeSpan.Parse("00:1:00"), .RuleName = "Data Loop Rule"})
        'rules.Add(New EmailSummaryRule() With {.ExecuteOn = TimeSpan.Parse("08:00:00"), .Period = TimeSpan.Parse("0:1:0"), .RuleName = "User Task Summary Rule"})
        'rules.Add(New AssignLeadsRule() With {.ExecuteOn = TimeSpan.Parse("02:00:00"), .Period = TimeSpan.Parse("0:1:0"), .RuleName = "Assign Leads Rule"})
    End Sub

    Public Sub StopService()
        ' Request Dispose of the timer object.
        If StateObjs.Count > 0 Then
            For Each obj In StateObjs
                obj.TimerCanceled = True
                obj.TimerReference.Dispose()
            Next
        End If
    End Sub

    Private Sub RunTimer(rule As BaseRule)
        Dim StateObj As New StateObjClass
        StateObj.TimerCanceled = False
        StateObj.Rule = rule

        Dim TimerDelegate As New System.Threading.TimerCallback(AddressOf TimerTask)

        Dim dueTime = DateTime.Today.Add(rule.ExecuteOn) - DateTime.Now
        If dueTime.TotalSeconds < 0 Then
            dueTime = DateTime.Today.AddDays(1).Add(rule.ExecuteOn) - DateTime.Now
        End If

        If rule.ExecuteNow Then
            dueTime = TimeSpan.Parse("00:00:01")
        End If

        Log("Due Time: " & dueTime.ToString & " Period: " & rule.Period.ToString)
        Dim timerItem = New System.Threading.Timer(TimerDelegate, StateObj, dueTime, rule.Period)

        ' Save a reference for Dispose.
        StateObj.TimerReference = timerItem
        StateObjs.Add(StateObj)
    End Sub

    Private Sub TimerTask(ByVal StateObj As Object)
        Dim State As StateObjClass = CType(StateObj, StateObjClass)

        If State.InProcess Then
            Log("Timer is cancel")
            Return
        End If

        If State.Rule Is Nothing Then
            Log("Business Rule is nothing. Please check.")
            Return
        End If

        Log("Launched rule Task: " & State.Rule.RuleName)
        State.InProcess = True

        Try
            If WorkingHours.IsWorkingDay(DateTime.Now) Then
                'Run Rules
                'RunRules()
                State.Rule.Execute()
            End If
        Catch ex As Exception
            Log("Exception in Run Rules", ex)
        End Try

        Log("Rule Task " & State.Rule.RuleName & " is complete")

        'Dim dueTime = DateTime.Today.Add(State.Rule.ExecuteOn) - DateTime.Now
        'If dueTime.TotalSeconds < 0 Then
        '    dueTime = DateTime.Today.AddDays(1).Add(State.Rule.ExecuteOn) - DateTime.Now
        'End If

        'State.TimerReference.Change(dueTime, State.Rule.Period)

        State.InProcess = False

        If State.TimerCanceled Then
            ' Dispose Requested.
            State.TimerReference.Dispose()
            Log("Rule " & State.Rule.RuleName & " is cancel.")
        End If
    End Sub

    <Obsolete>
    Private Sub RunRules()
        'Run Task rule
        Dim tasks = UserTask.GetActiveTasks()
        Log("Total Active Tasks: " & tasks.Count)

        For Each t In tasks
            Try
                TaskEscalationRule.Excute(t)
            Catch ex As Exception
                Log("Exception when execute task rule. BBLE: " & t.BBLE & ", Task Id: " & t.TaskID & ", Exception: " & ex.Message, ex)
            End Try
        Next
        Log("Task Rules Finished.")


        Dim lds = Lead.GetAllActiveLeads()
        Log("Total Active Leads: " & lds.Count)

        'Run Leads Rule
        For Each ld In lds
            Try
                LeadsEscalationRule.Execute(ld)
            Catch ex As Exception
                Log("Exception when execute Leads Rule. BBLE: " & ld.BBLE & ", Employee: " & ld.EmployeeName & ", Exception: " & ex.Message, ex)
            End Try
        Next
        Log("Leads Rule finished.")

        'Run deal leads recycle rules
        lds = Lead.GetAllDeadLeads()
        Log("Dead leads recycle rules")

        For Each ld In lds
            Try
                LeadsEscalationRule.Execute(ld)
            Catch ex As Exception
                Log("Exception when execute dead Leads Rule. BBLE: " & ld.BBLE & ", Exception: " & ex.Message, ex)
            End Try
        Next
        Log("Dead leads recycle rules finished.")

        If WorkingHours.IsWorkingDay(DateTime.Now) Then
            Dim rules = AssignRule.GetAllRules()
            Log("Assign Rules count: " & rules.Count)
            'Run Assign Leads rule
            For Each Rule In rules
                Try
                    Log("Assign Rule: " & Rule.ToString)
                    If Not ServiceLog.Debug Then
                        Rule.Execute()
                    End If
                Catch ex As Exception
                    Log("Exception when execute assign Leads Rule. Exception: " & ex.Message, ex)
                End Try
            Next
            Log("Assign Rules Finished")
        Else
            Log("Assgin Rule is cancel, due to non-working day")
        End If

        'Log("Run Data loop service")
        'Try
        '    IntranetPortal.LeadsDataManage.LeadsDataService.GetInstance.DataLoop("New")
        'Catch ex As Exception
        '    Log("Exception when Data loop. Exception: " & ex.Message, ex)
        'End Try
        'Log("Data Loop service Started.")
    End Sub

    Private Sub Log(msg As String)
        ServiceLog.Log(msg)
    End Sub

    Private Sub Log(msg As String, ex As Exception)
        ServiceLog.Log(msg, ex)
    End Sub

    Public Sub InitServiceMode()
        Dim mode = System.Configuration.ConfigurationManager.AppSettings("ServiceMode")
        If Not String.IsNullOrEmpty(mode) Then
            serviceMode = [Enum].Parse(GetType(RunningMode), mode)
        End If
    End Sub

    Private Class StateObjClass
        ' Used to hold parameters for calls to TimerTask. 
        Public SomeValue As Integer
        Public TimerReference As System.Threading.Timer
        Public TimerCanceled As Boolean
        Public InProcess As Boolean
        Public Rule As BaseRule
    End Class

    Enum ServiceStatus
        Stopped
        Sleep
        Running
    End Enum

    Enum RunningMode
        Debug
        Trial
        Release
    End Enum
End Class
