Imports System.Threading
Public Class RulesService
    Private Shared ServiceInstance As RulesService
    Private StateObj As New StateObjClass
    Public Delegate Sub StatusChange(sta As ServiceStatus)
    Public Event OnStatusChange As StatusChange

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

    Public Sub Start()
        If Status <> ServiceStatus.Running Then
            Status = ServiceStatus.Running
            Log("Service is running")
            RunTimer()
            Log("Service is Start")
        End If
    End Sub

    Public Sub StopService()
        ' Request Dispose of the timer object.
        GetInstance.StateObj.TimerCanceled = True
    End Sub

    Private Sub RunTimer()
        StateObj.TimerCanceled = False
        StateObj.SomeValue = 1

        Dim TimerDelegate As New System.Threading.TimerCallback(AddressOf TimerTask)
        Dim TimerItem As New System.Threading.Timer(TimerDelegate, StateObj, New TimeSpan(1000), New TimeSpan(1, 0, 0))

        ' Save a reference for Dispose.
        StateObj.TimerReference = TimerItem
    End Sub

    Private Sub TimerTask(ByVal StateObj As Object)
        Dim State As StateObjClass = CType(StateObj, StateObjClass)
        ' Use the interlocked class to increment the counter variable.
        System.Threading.Interlocked.Increment(State.SomeValue)

        Log("Launched new task")

        If WorkingHours.IsWorkingHour(DateTime.Now) Then
            'Run Rules
            RunRules()
        End If

        Status = ServiceStatus.Sleep

        If State.TimerCanceled Then
            ' Dispose Requested.
            State.TimerReference.Dispose()
            Log("Service is stop.")
            Status = ServiceStatus.Stopped
        End If


    End Sub

    Private Sub RunRules()
        'Run Task rule
        Dim tasks = UserTask.GetActiveTasks()
        Log("Total Active Tasks: " & tasks.Count)

        For Each t In tasks
            Try
                TaskEscalationRule.Excute(t)
            Catch ex As Exception
                Log("Exception when execute task rule. BBLE: " & t.BBLE & ", Task Id: " & t.TaskID & ", Exception: " & ex.Message)
            End Try

        Next

        Dim lds = Lead.GetAllActiveLeads()
        Log("Total Active Leads: " & lds.Count)

        'Run Leads Rule
        For Each ld In lds
            Try
                LeadsEscalationRule.Execute(ld)
            Catch ex As Exception
                Log("Exception when execute Leads Rule. BBLE: " & ld.BBLE & ", Employee: " & ld.EmployeeName & ", Exception: " & ex.Message)
            End Try

        Next

        Dim rules = AssignRule.GetAllRules()
        Log("Assign Rules count: " & rules.Count)
        'Run Assign Leads rule
        For Each Rule In rules
            Try
                Rule.Execute()
            Catch ex As Exception
                Log("Exception when execute assign Leads Rule. Exception: " & ex.Message)
            End Try
        Next
    End Sub

    Private Sub Log(msg As String)
        ServiceLog.Log(msg)
    End Sub

    Private Class StateObjClass
        ' Used to hold parameters for calls to TimerTask. 
        Public SomeValue As Integer
        Public TimerReference As System.Threading.Timer
        Public TimerCanceled As Boolean
    End Class

    Enum ServiceStatus
        Stopped
        Sleep
        Running
    End Enum
End Class
