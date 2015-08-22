
Public Class PropertyFloor

    Public Property DataStatus As ModelStatus

    Public Sub Save()
        Using context As New ShortSaleEntities
            If Not context.PropertyFloors.Any(Function(pf) pf.BBLE = BBLE And pf.FloorId = FloorId) Then
                If DataStatus = ModelStatus.Deleted Then
                    Return
                End If

                CreateDate = DateTime.Now
                context.Entry(Me).State = Entity.EntityState.Added
            Else
                If DataStatus = ModelStatus.Deleted Then
                    context.Entry(Me).State = Entity.EntityState.Deleted
                Else
                    context.Entry(Me).State = Entity.EntityState.Modified
                End If
            End If

            context.SaveChanges()

            If _evictionOccupants IsNot Nothing AndAlso Not DataStatus = ModelStatus.Deleted Then
                For Each occupant In _evictionOccupants
                    If String.IsNullOrEmpty(occupant.BBLE) Then
                        occupant.BBLE = BBLE
                        occupant.CaseId = ShortSaleCase.GetCaseByBBLE(BBLE).CaseId
                    End If

                    occupant.FloorId = FloorId
                    occupant.Save()
                Next
            End If

            Dim oldOccupants = context.PropertyOccupants.Where(Function(pf) pf.BBLE = BBLE AndAlso pf.FloorId = FloorId).ToList
            If _evictionOccupants IsNot Nothing Then
                If oldOccupants.Count > _evictionOccupants.Count Then
                    For Each occupant In oldOccupants
                        If Not _evictionOccupants.Any(Function(ow) ow.OccupantId = occupant.OccupantId) Then
                            context.PropertyOccupants.Remove(occupant)
                        End If
                    Next
                    context.SaveChanges()
                End If
            End If

        End Using
    End Sub

    Public Shared Function Instance(bble As String, floorId As Integer) As PropertyFloor
        Using context As New ShortSaleEntities
            Return context.PropertyFloors.Find(bble, floorId)

        End Using
    End Function


    Public Shared Sub Delete(bble As String, floorId As Integer)
        Using context As New ShortSaleEntities
            Dim obj = context.PropertyFloors.Find(bble, floorId)

            If obj IsNot Nothing Then
                context.PropertyFloors.Remove(obj)
                context.SaveChanges()
            End If
        End Using
    End Sub

    Private _evictionOccupants As PropertyOccupant()
    Public Property Occupants As PropertyOccupant()
        Get
            If _evictionOccupants Is Nothing Then
                _evictionOccupants = PropertyOccupant.GetOccupantByBBLE(BBLE, FloorId)
            End If

            Return _evictionOccupants
        End Get
        Set(value As PropertyOccupant())
            _evictionOccupants = value
        End Set
    End Property
End Class
