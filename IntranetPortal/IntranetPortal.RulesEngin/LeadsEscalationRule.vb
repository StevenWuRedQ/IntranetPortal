
Public Class LeadsEscalationRule
    Public Shared Sub Execute(ld As Lead)
        For Each Rule In GetRule(ld)
            If Rule.IsDateDue(ld.LastUserUpdate, ld, ld.EmployeeName) Then
                'ServiceLog.Log("Execute Leads Rule: " & ld.BBLE)
                If Rule.Execute(ld) Then
                    ServiceLog.Log(String.Format("Rule Action, {0}, {1}, {2}, {3}", Rule.Name, Rule.EscalationAfter.ToString, ld.EmployeeName, ld.BBLE))
                End If
                'ServiceLog.Log("Finish Leads Rule: " & ld.BBLE)
                Return
            End If
        Next
    End Sub

    Public Shared Sub Execute(bble As String)
        RulesService.GetInstance.InitServiceMode()
        Dim ld = Lead.GetInstance(bble)
        If ld IsNot Nothing Then
            For Each Rule In GetRule(ld)
                If Rule.IsDateDue(ld.LastUserUpdate, ld, ld.EmployeeName) Then
                    ServiceLog.Log("Execute Leads Rule: " & ld.BBLE)
                    Rule.Execute(ld)
                    ServiceLog.Log("Finish Leads Rule: " & ld.BBLE)
                    Return
                End If
            Next
        End If
    End Sub

    Private Shared Function GetRule(ld As Lead) As List(Of EscalationRule)
        Return TaskRules.Where(Function(r) r.Name = CType(ld.Status, LeadStatus).ToString).OrderByDescending(Function(r) r.Sequence).ToList
    End Function

    Private Shared Function TaskRules() As List(Of EscalationRule)
        Dim rules As New List(Of EscalationRule)
        rules.Add(New EscalationRule("NewLead", "3.00:00:00",
                                     Sub(leads)
                                         Dim ld = CType(leads, Lead)
                                         'UserMessage.AddNewMessage(ld.EmployeeName, "New Leads Handler Warning", String.Format("The new leads BBLE:{0} will be recycled.", ld.BBLE), ld.BBLE)
                                         Dim log As New ActivityLogs
                                         Dim description = String.Format("This lead ({0},{1}) has not been reviewed within 3 days. This lead will be recycled within 48 hours.", ld.BBLE, ld.LeadsName)
                                         log.SetAsReminder(ld.EmployeeName, "Important", "Review New Leads Reminder", description, ld.BBLE, "Portal")
                                     End Sub,
                                     Function(leads)
                                         'Dim ld = CType(leads, Lead)
                                         'Return ld.LastUpdate2 <= ld.AssignDate
                                         Return True
                                     End Function,
                                     1,
                                     Function(leads)
                                         Dim ld = CType(leads, Lead)
                                         If ld.LastUserUpdate <= ld.AssignDate Then
                                             Return ld.AssignDate
                                         End If
                                         Return ld.LastUserUpdate
                                     End Function))

        rules.Add(New EscalationRule("NewLead", "5.00:00:00",
                                     Sub(leads)
                                         Dim ld = CType(leads, Lead)
                                         If RulesService.Mode = RulesService.RunningMode.Trial Then
                                             ld.UpdateAssignDate()
                                             Return
                                         End If

                                         'insert to assign leads folder of this team  -- need consider the UserinTeam situation
                                         ld.StartRecycleProcess()
                                         ServiceLog.Log("Recycle of Leads is done, BBLE: " & ld.BBLE)
                                     End Sub,
                                     Function(leads)
                                         'Dim ld = CType(leads, Lead)
                                         'Return ld.LastUserUpdate <= ld.AssignDate
                                         Return True
                                     End Function, 2,
                                      Function(leads)
                                          Dim ld = CType(leads, Lead)
                                          If ld.LastUserUpdate <= ld.AssignDate Then
                                              Return ld.AssignDate
                                          End If
                                          Return ld.LastUserUpdate
                                      End Function))

        rules.Add(New EscalationRule("Callback", "1.00:00:00",
                                     Sub(leads)
                                         'Dim ld = CType(leads, Lead)
                                         'UserMessage.AddNewMessage(ld.EmployeeName, "You missed a Callback", String.Format("The Call back of Leads ({0}) need to hanlder. BBLE:{1}", ld.LeadsName, ld.BBLE), ld.BBLE, DateTime.Now, "Portal")
                                     End Sub,
                                     Function(leads)
                                         Dim ld = CType(leads, Lead)
                                         If Not ld.CallbackDate.HasValue Then
                                             Return True
                                         End If
                                         Return ld.LastUpdate2 <= ld.CallbackDate
                                     End Function, 1,
                                     Function(leads)
                                         Dim ld = CType(leads, Lead)
                                         If ld.CallbackDate.HasValue Then
                                             Return ld.CallbackDate
                                         Else
                                             Return ld.LastUpdate2
                                         End If
                                     End Function))

        rules.Add(New EscalationRule("Callback", "4.00:00:00",
                                Sub(leads)
                                    Dim ld = CType(leads, Lead)

                                    'generate Urgent Task and include Manager and Agent
                                    Dim emps = ld.EmployeeName & ";" & ld.Employee.Manager
                                    Dim log As New ActivityLogs
                                    Dim description = String.Format("A call back was scheduled for {0:d}, If no call back is made within 48 hours, this lead will be recycled. Leads:{1}, BBLE: {2}", ld.CallbackDate, ld.LeadsName, ld.BBLE)
                                    log.SetAsReminder(emps, "Urgent", "Missed Callback Reminder", description, ld.BBLE, "Portal")
                                End Sub,
                                Function(leads)
                                    Dim ld = CType(leads, Lead)
                                    If Not ld.CallbackDate.HasValue Then
                                        Return True
                                    End If
                                    Return ld.LastUpdate2 <= ld.CallbackDate.Value.AddDays(1)
                                End Function, 2,
                                Function(leads)
                                    Dim ld = CType(leads, Lead)
                                    If ld.CallbackDate.HasValue Then
                                        Return ld.CallbackDate
                                    Else
                                        Return ld.LastUpdate2
                                    End If
                                End Function))

        rules.Add(New EscalationRule("Callback", "7.00:00:00",
                                Sub(leads)
                                    Dim ld = CType(leads, Lead)

                                    If RulesService.Mode = RulesService.RunningMode.Trial Then
                                        ld.UpdateCallbackDate(DateTime.Now)
                                        Return
                                    End If

                                    ld.StartRecycleProcess()
                                End Sub,
                                Function(leads)
                                    Dim ld = CType(leads, Lead)
                                    If Not ld.CallbackDate.HasValue Then
                                        Return True
                                    End If
                                    Return ld.LastUpdate2 <= ld.CallbackDate.Value.AddDays(2)
                                End Function, 3,
                                Function(leads)
                                    Dim ld = CType(leads, Lead)
                                    If ld.CallbackDate.HasValue Then
                                        Return ld.CallbackDate
                                    Else
                                        Return ld.LastUpdate2
                                    End If
                                End Function))

        rules.Add(New EscalationRule("DoorKnocks", "10.00:00:00",
                             Sub(leads)
                                 Dim ld = CType(leads, Lead)
                                 Dim emps = ld.EmployeeName & ";" & ld.Employee.Manager
                                 Dim log As New ActivityLogs
                                 Dim description = String.Format("A Door Knock was initiated on {0:d}, If no door knock attempt is made within 72 hours, this lead will be recycled.  Leads:{1}, BBLE: {2}", ld.LastUpdate2, ld.LeadsName, ld.BBLE)
                                 log.SetAsReminder(emps, "Urgent", "Door Knock Reminder", description, ld.BBLE, "Portal")
                             End Sub,
                             Function(leads)
                                 Return True
                             End Function, 1))

        rules.Add(New EscalationRule("DoorKnocks", "13.00:00:00",
                          Sub(leads)
                              Dim ld = CType(leads, Lead)

                              If RulesService.Mode = RulesService.RunningMode.Trial Then
                                  'ld.UpdateCallbackDate(DateTime.Now)
                                  Return
                              End If
                              ld.StartRecycleProcess()

                          End Sub, Function(leads)
                                       Return True
                                   End Function, 2))

        rules.Add(New EscalationRule("Priority", "2.00:00:00",
                                   Sub(leads)
                                       Dim ld = CType(leads, Lead)
                                       Dim emps = ld.EmployeeName & ";" & ld.Employee.Manager
                                       Dim log As New ActivityLogs
                                       Dim comments = "Hot Leads require an update every 48 Hours. If this is not a Hot Lead, change Status to Follow Up and select a date. If no comment is entered in 48 Hours, this lead will get escalated to a manager. "
                                       log.SetAsReminder(emps, "Urgent", "HotLeads Reminder", comments, ld.BBLE, "Portal")
                                   End Sub,
                                   Function(leads)
                                       Dim ld = CType(leads, Lead)
                                       Return ld.Task Is Nothing And ld.Appointment Is Nothing
                                   End Function, 1))

        rules.Add(New EscalationRule("Priority", "4.00:00:00",
                               Sub(leads)
                                   Dim ld = CType(leads, Lead)

                                   If RulesService.Mode = RulesService.RunningMode.Trial Then
                                       Return
                                   End If

                                   ld.StartRecycleProcess()
                               End Sub,
                               Function(leads)
                                   Dim ld = CType(leads, Lead)
                                   Return ld.Task Is Nothing And ld.Appointment Is Nothing
                               End Function, 2))

        rules.Add(New EscalationRule("DeadEnd", "00:00:00",
                  Sub(leads)
                      Dim ld = CType(leads, Lead)
                      ld.Recycle()
                  End Sub,
                  Function(leads)
                      Dim ld = CType(leads, Lead)
                      Select Case ld.DeadReason
                          Case 2, 3, 6
                              Return True
                      End Select

                      Return False
                  End Function,
                  1))

        rules.Add(New EscalationRule("DeadEnd", "30.00:00:00",
                     Sub(leads)
                         Dim ld = CType(leads, Lead)
                         ld.Recycle()
                     End Sub,
                     Function(leads)
                         Dim ld = CType(leads, Lead)
                         Select Case ld.DeadReason
                             Case 5
                                 Return True
                         End Select

                         Return False
                     End Function,
                     2))

        rules.Add(New EscalationRule("DeadEnd", "120.00:00:00",
                            Sub(leads)
                                Dim ld = CType(leads, Lead)
                                ld.Recycle()
                            End Sub,
                            Function(leads)
                                Dim ld = CType(leads, Lead)
                                Select Case ld.DeadReason
                                    Case 4
                                        Return True
                                End Select

                                Return False
                            End Function,
                            3))
        Return rules
    End Function
End Class