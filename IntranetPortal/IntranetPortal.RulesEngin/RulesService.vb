Imports System.Threading
Public Class RulesService
    Public Shared ServiceInstance As RulesService
    Private StateObj As New StateObjClass

    Private Shared Function GetInstance() As RulesService
        If ServiceInstance Is Nothing Then
            ServiceInstance = New RulesService
        End If

        Return ServiceInstance
    End Function

    Public Shared Sub Start()
        GetInstance().RunTimer()
    End Sub

    Public Shared Sub StopService()
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
        System.Diagnostics.Debug.WriteLine("Launched new thread  " & Now.ToString)

        If WorkingHours.IsWorkingHour(DateTime.Now) Then
            'Run Rules
            RunRules()
        End If

        If State.TimerCanceled Then
            ' Dispose Requested.
            State.TimerReference.Dispose()
            System.Diagnostics.Debug.WriteLine("Done  " & Now)
        End If
    End Sub

    Private Sub RunRules()
        'Run Task rule
        Dim tasks = UserTask.GetActiveTasks()
        For Each t In tasks
            TaskEscalationRule.Excute(t)
        Next

        'Run Leads Rule
        For Each ld In Lead.GetAllActiveLeads()
            LeadsEscalationRule.Execute(ld)
        Next

        'Run Assign Leads rule
        For Each Rule In AssignRule.GetAllRules()
            Rule.Execute()
        Next
    End Sub

    Private Class StateObjClass
        ' Used to hold parameters for calls to TimerTask. 
        Public SomeValue As Integer
        Public TimerReference As System.Threading.Timer
        Public TimerCanceled As Boolean
    End Class
End Class
