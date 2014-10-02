Public Class ShortSaleSummary
    Public Shared Function GetUrgentCases() As List(Of ShortSaleCase)
        Using context As New ShortSaleEntities
            Return context.ShortSaleCases.ToList
        End Using
    End Function

    Public Shared Function GetUpcomingClosings() As List(Of ShortSaleCase)
        Return GetUrgentCases()
    End Function

    Public Shared Function GetFollowUpCases() As List(Of ShortSaleCase)
        Using context As New ShortSaleEntities
            Return context.ShortSaleCases.Where(Function(ss) ss.Status = CaseStatus.FollowUp).ToList
        End Using
    End Function
End Class
