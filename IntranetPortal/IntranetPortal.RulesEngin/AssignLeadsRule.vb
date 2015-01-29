Public Class AssignLeadsRule
    Inherits BaseRule

    Public Overrides Sub Execute()
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
    End Sub
End Class
