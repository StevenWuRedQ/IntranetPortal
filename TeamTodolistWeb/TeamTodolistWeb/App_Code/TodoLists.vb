Imports Microsoft.VisualBasic

Public Class TodoList
    Public Sub UpdateDuDate()
        If (DateNeed IsNot Nothing) Then
            Dim createDateTime = CType(CreateDate, DateTime)
            Using Context As New DevAppEntities
                If (Priority IsNot Nothing) Then
                    Dim days = Context.TodoLists.Where(Function(td) td.Priority < Me.Priority AndAlso td.DueDate IsNot Nothing AndAlso td.Owner = Me.Owner).Sum(Function(td) td.DateNeed) '.Sum(Function(td) td.DueDate
                    days = If(days Is Nothing, 0, days)

                    DueDate = createDateTime.AddDays(days + DateNeed)
                    Return
                End If
            End Using

            DueDate = createDateTime.AddDays(DateNeed)
        End If
    End Sub
End Class
