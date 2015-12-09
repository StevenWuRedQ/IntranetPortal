Imports Microsoft.VisualBasic

Public Class TodoList
    Public Sub UpdateDuDate()
        If (DateNeed IsNot Nothing) Then
            Dim createDateTime = CType(CreateDate, DateTime)

            Using Context As New DevAppEntities
                Dim frisTask = Context.TodoLists.Where(Function(td) td.Priority IsNot Nothing AndAlso td.Priority = 1 And td.Owner = Me.Owner).FirstOrDefault()
                If (frisTask IsNot Nothing) Then
                    createDateTime = CType(frisTask.CreateDate, DateTime)
                    If (Date.Now - createDateTime).Days > 20 Then
                        createDateTime = CType(Date.Now, DateTime)
                    End If
                End If
                If (Priority IsNot Nothing) Then
                    Dim days = Context.TodoLists.Where(Function(td) td.Priority < Me.Priority AndAlso td.DueDate IsNot Nothing AndAlso td.Owner = Me.Owner).Sum(Function(td) td.DateNeed) '.Sum(Function(td) td.DueDate
                    days = If(days Is Nothing, 0, days) + DateNeed
                    'DueDate = createDateTime.AddDays(days + DateNeed)
                    DueDate = Me.GetFinalDate(createDateTime, days)
                    Return
                End If
            End Using

            DueDate = Me.GetFinalDate(createDateTime, DateNeed)
        End If
    End Sub

    Public Function GetFinalDate(startDate As DateTime, days As Integer) As DateTime
        Dim finalDate = startDate
        For i = 0 To days - 1
            finalDate = finalDate.AddDays(1)

            If finalDate.DayOfWeek = DayOfWeek.Saturday Then
                finalDate = finalDate.AddDays(2)
                Continue For
            End If

            If finalDate.DayOfWeek = DayOfWeek.Sunday Then
                finalDate = finalDate.AddDays(1)
                Continue For
            End If

        Next

        Return finalDate
    End Function
End Class
