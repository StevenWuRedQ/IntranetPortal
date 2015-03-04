Public Class SearchResult
    Public ReadOnly Property AgentInLeads As String
        Get
            Using context As New Entities
                Dim agent = context.Leads.Where(Function(l) l.BBLE = BBLE).Select(Function(l) l.EmployeeName).FirstOrDefault
                If agent Is Nothing Then
                    agent = context.PendingAssignLeads.Where(Function(pl) pl.BBLE = BBLE).Select(Function(pl) pl.EmployeeName).FirstOrDefault
                End If
                Return agent
            End Using
        End Get
    End Property
    Public Shared Function getSeachResult(id As Integer) As SearchResult
        Using ctx As New Entities
            Dim s = ctx.SearchResults.Where(Function(sl) sl.Id = id).FirstOrDefault
            Return s
        End Using
    End Function

End Class
