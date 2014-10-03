Public Class PropertyOccupant
    Public Shared Function GetOccupantsByCase(caseId As Integer) As List(Of PropertyOccupant)
        Using context As New ShortSaleEntities
            Return context.PropertyOccupants.Where(Function(pc) pc.CaseId = caseId).ToList
        End Using
    End Function

End Class
