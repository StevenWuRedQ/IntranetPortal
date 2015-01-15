﻿Imports System.Threading

Public Class RulesService
    Private Shared ServiceInstance As RulesService
    Private StateObj As New StateObjClass
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

            Log("Service is running")
            Log("Service Running Mode: " + Mode.ToString)
            RunTimer()
            Log("Service is Start")
        End If
    End Sub

    Public Sub StopService()
        ' Request Dispose of the timer object.
        GetInstance.StateObj.TimerCanceled = True
        If timerItem IsNot Nothing Then
            timerItem.Dispose()
        End If
    End Sub

    Dim timerItem As Threading.Timer
    Private Sub RunTimer()
        StateObj.TimerCanceled = False
        StateObj.SomeValue = 1

        Dim TimerDelegate As New System.Threading.TimerCallback(AddressOf TimerTask)
        timerItem = New System.Threading.Timer(TimerDelegate, StateObj, New TimeSpan(1000), New TimeSpan(23, 59, 59))

        ' Save a reference for Dispose.
        StateObj.TimerReference = TimerItem
    End Sub

    Private Sub TimerTask(ByVal StateObj As Object)
        Dim State As StateObjClass = CType(StateObj, StateObjClass)

        If State.InProcess Then
            Log("Timer is cancel")
            Return
        End If

        ' Use the interlocked class to increment the counter variable.
        System.Threading.Interlocked.Increment(State.SomeValue)

        Log("Launched new task ")
        State.InProcess = True

        Try
            If Not WorkingHours.IsWorkingHour(DateTime.Now) Then
                'Run Rules
                RunRules()
            End If
        Catch ex As Exception
            Log("Exception in Run Rules", ex)
        End Try

        Status = ServiceStatus.Sleep
        State.InProcess = False

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
