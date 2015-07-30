Public Class PropertyOccupant
    Public Shared Function GetOccupantsByCase(caseId As Integer) As List(Of PropertyOccupant)
        Using context As New ShortSaleEntities
            Return context.PropertyOccupants.Where(Function(pc) pc.CaseId = caseId).ToList
        End Using
    End Function

    Public Shared Function GetOccupantByBBLE(bble As String, floorId As Integer) As PropertyOccupant()
        Using ctx As New ShortSaleEntities
            Return ctx.PropertyOccupants.Where(Function(pc) pc.BBLE = bble AndAlso pc.FloorId = floorId).ToArray
        End Using
    End Function

    Public Property DataStatus As ModelStatus

    Public Sub Save()
        Using context As New ShortSaleEntities
            Dim pbi = context.PropertyOccupants.Find(OccupantId)

            If pbi Is Nothing Then
                CreateDate = DateTime.Now
                context.Entry(Me).State = Entity.EntityState.Added
            Else
                If DataStatus = ModelStatus.Deleted Then
                    'When delete Occupate better delete notes also by steven.
                    context.PropertyOccupants.Remove(pbi)
                Else
                    pbi = ShortSaleUtility.SaveChangesObj(pbi, Me)
                End If
            End If

            context.SaveChanges()
        End Using
    End Sub
End Class
