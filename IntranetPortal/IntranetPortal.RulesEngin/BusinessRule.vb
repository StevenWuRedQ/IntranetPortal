Imports System.Threading

Public Class BaseRule
    Public Property RuleName As String
    Public Property ExecuteOn As TimeSpan
    Public Property Period As TimeSpan

    Public Sub New()

    End Sub

    Public Sub New(executeOn As TimeSpan, period As TimeSpan)
        Me.ExecuteOn = executeOn
        Me.Period = period
    End Sub

    Public Overridable Sub Execute()

    End Sub

    Protected Sub Log(msg As String)
        ServiceLog.Log(msg)
    End Sub

    Protected Sub Log(msg As String, ex As Exception)
        ServiceLog.Log(msg, ex)
    End Sub
End Class

Public Class LeadsAndTaskRule
    Inherits BaseRule

    Public Overrides Sub Execute()
        RunRules()
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

        'If WorkingHours.IsWorkingDay(DateTime.Now) Then
        '    Dim rules = AssignRule.GetAllRules()
        '    Log("Assign Rules count: " & rules.Count)
        '    'Run Assign Leads rule
        '    For Each Rule In rules
        '        Try
        '            Log("Assign Rule: " & Rule.ToString)
        '            If Not ServiceLog.Debug Then
        '                Rule.Execute()
        '            End If
        '        Catch ex As Exception
        '            Log("Exception when execute assign Leads Rule. Exception: " & ex.Message, ex)
        '        End Try
        '    Next
        '    Log("Assign Rules Finished")
        'Else
        '    Log("Assgin Rule is cancel, due to non-working day")
        'End If
    End Sub
End Class

Public Class EmailSummaryRule
    Inherits BaseRule

    Public Overrides Sub Execute()

        Dim emps = Employee.GetAllActiveEmps()
        Using client As New PortalService.CommonServiceClient
            For Each emp In emps
                client.SendTaskSummaryEmail(emp)
            Next
        End Using
    End Sub
End Class

Public Class LoopServiceRule
    Inherits BaseRule

    Dim threadPools As New List(Of Thread)
    Dim rules As List(Of Core.DataLoopRule)
    Public Overrides Sub Execute()
        rules = IntranetPortal.Core.DataLoopRule.GetAllActiveRule

        If rules IsNot Nothing AndAlso rules.Count > 0 Then
            CurrentIndex = 0
            For i = 0 To 1
                Log("Thread " & i & " is starting.")
                Dim TestThread As New System.Threading.Thread(New ThreadStart(Sub()
                                                                                  InitialData()
                                                                              End Sub))
                threadPools.Add(TestThread)
                TestThread.Start()
                Log("Thread " & i & " is started.")
            Next

            If threadPools.Count > 0 Then
                For Each th In threadPools
                    th.Join()
                Next
            End If
        End If
    End Sub

    Dim CurrentIndex As Integer
    Public Sub InitialData()
        Dim index = 0
        While index < rules.Count
            index = CurrentIndex
            CurrentIndex = index + 1

            If index >= rules.Count Then
                Continue While
            End If

            Dim rule = rules(index)
            Dim attemps = 0
InitialLine:
            attemps += 1
            Try
                ExecuteDataloopRule(rule)
                rule.Complete()
            Catch ex As Exception
                Log("Initial Data Error " & rule.BBLE & " Attemps: " & attemps, ex)
                Select Case attemps
                    Case 1
                        Thread.Sleep(30000)
                    Case 2
                        Thread.Sleep(60000)
                    Case 3
                        Thread.Sleep(300000)
                    Case Else

                        Thread.Sleep(1000000)
                End Select

                GoTo InitialLine
            End Try
        End While
    End Sub

    Private Sub ExecuteDataloopRule(rule As Core.DataLoopRule)
        'check if server is busy
        While DataWCFService.IsServerBusy
            Thread.Sleep(30000)
        End While

        Dim bble = rule.BBLE
        Select Case rule.LoopType
            Case Core.DataLoopRule.DataLoopType.All
                If DataWCFService.UpdateLeadInfo(bble, True, True, True, True, True, False, True) Then
                    rule.Complete()
                    Log("All Data is refreshed. BBLE: " & bble)
                End If
            Case Core.DataLoopRule.DataLoopType.Servicer
                DataWCFService.UpdateServicer(bble)
                DataWCFService.UpdateTaxLiens(bble)
                rule.Complete()
                Log("Initial Data Message " & bble & String.Format(". Servicer info and Taxlien BBLE: {0} data is Update. ", bble))
            Case Core.DataLoopRule.DataLoopType.GeneralData
                DataWCFService.UpdateAssessInfo(bble)
                rule.Complete()
                Log("Initial Data Message " & bble & String.Format(" General info BBLE: {0} data is Update. ", bble))
            Case Core.DataLoopRule.DataLoopType.HomeOwner
                If DataWCFService.UpdateLeadInfo(bble, False, False, False, False, False, False, True) Then
                    rule.Complete()
                    Log("Initial Data Message " & bble & String.Format(" Refresh BBLE: {0} homeowner info is finished.", bble))
                End If
            Case Core.DataLoopRule.DataLoopType.Mortgage
                If DataWCFService.UpdateLeadInfo(bble, False, True, True, True, True, False, True) Then
                    rule.Complete()
                    Log("Initial Data Message " & bble & String.Format(" BBLE: {0} Morgatage data is loaded. ", bble))
                End If
            Case Else
                Dim lead = LeadsInfo.GetInstance(bble)
                If String.IsNullOrEmpty(lead.Owner) Then
                    If DataWCFService.UpdateLeadInfo(bble, True, True, True, True, True, False, True) Then
                        rule.Complete()
                        Log("All Data is refreshed. BBLE: " & bble)
                    End If
                Else
                    If Not lead.C1stMotgrAmt.HasValue Then
                        If DataWCFService.UpdateLeadInfo(bble, False, True, True, True, True, False, True) Then
                            rule.Complete()
                            Log("Initial Data Message " & bble & String.Format(" BBLE: {0} Morgatage data is loaded. ", bble))
                        End If
                    Else
                        If lead.IsUpdating Then
                            If DataWCFService.UpdateLeadInfo(bble, False, True, True, True, True, False, True) Then
                                rule.Complete()
                                Log("Initial Data Message " & bble & String.Format("Refresh BBLE: {0} data is Finished. ", bble))
                            End If
                        Else
                            If Not lead.HasOwnerInfo Then
                                If DataWCFService.UpdateLeadInfo(bble, False, False, False, False, False, False, True) Then
                                    rule.Complete()
                                    Log("Initial Data Message " & bble & String.Format(" Refresh BBLE: {0} homeowner info is finished.", bble))
                                End If
                            End If
                        End If
                    End If
                End If
        End Select
    End Sub
End Class

