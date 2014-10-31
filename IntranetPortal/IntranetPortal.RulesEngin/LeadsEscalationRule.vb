

Public Class LeadsEscalationRule
    Public Sub Execute(ld As Lead)
        For Each Rule In GetRule(ld)
            If Rule.IsDateDue(ld.LastUpdate2) Then
                Rule.Execute(ld)
            End If
        Next
    End Sub

    Private Function GetRule(ld As Lead) As List(Of EscalationRule)
        Return TaskRules.Where(Function(r) r.Name = CType(ld.Status, LeadStatus).ToString).OrderBy(Function(r) r.Sequence).ToList
    End Function

    Private Shared Function TaskRules() As List(Of EscalationRule)
        Dim rules As New List(Of EscalationRule)
        rules.Add(New EscalationRule("NewLeads", "3.00:00:00",
                                     Sub(leads)
                                         Dim ld = CType(leads, Lead)
                                         UserMessage.AddNewMessage(ld.EmployeeName, "New Leads Handler Warning", String.Format("The new leads BBLE:{0} will be recycled.", ld.BBLE), ld.BBLE)
                                     End Sub,
                                     Function(leads)
                                         Dim ld = CType(leads, Lead)
                                         Return ld.LastUpdate2 <= ld.AssignDate
                                     End Function,
                                     1))

        rules.Add(New EscalationRule("NewLeads", "4.00:00:00",
                                     Sub(leads)
                                         Dim ld = CType(leads, Lead)
                                         'insert to assign leads folder of this team

                                     End Sub,
                                     Function(leads)
                                         Dim ld = CType(leads, Lead)
                                         Return ld.LastUpdate2 <= ld.AssignDate
                                     End Function, 2))

        Return rules
    End Function
End Class