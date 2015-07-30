
Public Class PropertyFloor
    Public Sub Save()
        Using context As New ShortSaleEntities
            Dim obj = context.PropertyFloors.Find(BBLE, FloorId)

            If obj Is Nothing Then
                CreateDate = DateTime.Now
                context.Entry(Me).State = Entity.EntityState.Added
            Else
                obj = ShortSaleUtility.SaveChangesObj(obj, Me)
            End If

            context.SaveChanges()

            If _evictionOccupants IsNot Nothing Then
                For Each occupant In _evictionOccupants
                    If String.IsNullOrEmpty(occupant.BBLE) Then
                        occupant.BBLE = BBLE
                        occupant.FloorId = FloorId
                    End If

                    occupant.Save()
                Next
            End If

            Dim oldOccupants = context.PropertyOccupants.Where(Function(pf) pf.BBLE = BBLE AndAlso pf.FloorId = FloorId).ToList
            If oldOccupants.Count > _evictionOccupants.Count Then
                For Each occupant In oldOccupants
                    If Not _evictionOccupants.Any(Function(ow) ow.BBLE = occupant.BBLE AndAlso ow.FloorId = occupant.FloorId) Then
                        context.PropertyOccupants.Remove(occupant)
                    End If
                Next
                context.SaveChanges()
            End If
        End Using
    End Sub

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
    Public Property EvictionOccupants As PropertyOccupant()
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
