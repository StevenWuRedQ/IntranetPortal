
Partial Public Class PropertyBaseInfo

    Public ReadOnly Property PropertyAddress As String
        Get
            Return IntranetPortal.Core.PropertyHelper.BuildPropertyAddress(Number, StreetName, "", City, Zipcode)
        End Get
    End Property

    Private _propFloors As PropertyFloor()
    Public Property PropFloors As PropertyFloor()
        Get
            If _propFloors Is Nothing Then
                Using context As New ShortSaleEntities
                    _propFloors = context.PropertyFloors.Where(Function(fl) fl.BBLE = BBLE).ToArray
                End Using
            End If

            Return _propFloors
        End Get
        Set(value As PropertyFloor())
            _propFloors = value
        End Set
    End Property

    Private _owners As PropertyOwner()
    Public Property Owners As PropertyOwner()
        Get
            If _owners Is Nothing Then
                Using context As New ShortSaleEntities
                    _owners = context.PropertyOwners.Where(Function(po) po.BBLE = BBLE).ToArray
                End Using

                If _owners.Count = 0 Then
                    _owners = {New PropertyOwner}
                End If
            End If

            Return _owners
        End Get
        Set(value As PropertyOwner())
            _owners = value
        End Set
    End Property

    Public Sub Save()
        Using context As New ShortSaleEntities
            Dim pbi = context.PropertyBaseInfoes.Find(BBLE)
            If pbi Is Nothing Then
                CreateDate = DateTime.Now
                context.Entry(Me).State = Entity.EntityState.Added
            Else
                pbi = ShortSaleUtility.SaveChangesObj(pbi, Me)
                pbi.UpdateDate = DateTime.Now
            End If

            context.SaveChanges()

            If _propFloors IsNot Nothing Then
                For Each floor In _propFloors
                    If String.IsNullOrEmpty(floor.BBLE) Then
                        floor.BBLE = BBLE
                    End If

                    floor.Save()
                Next
            End If

            Dim olderEntities = context.PropertyFloors.Where(Function(pf) pf.BBLE = BBLE).ToList
            If olderEntities.Count > _propFloors.Count Then
                For Each floor In olderEntities
                    If Not _propFloors.Any(Function(so) so.FloorId = floor.FloorId) Then
                        context.PropertyFloors.Remove(floor)
                    End If
                Next
                context.SaveChanges()
            End If

            If _owners IsNot Nothing Then
                For Each owner In _owners
                    owner.BBLE = BBLE

                    If Not String.IsNullOrEmpty(owner.FirstName) AndAlso Not String.IsNullOrEmpty(owner.LastName) Then
                        owner.Save()
                    End If
                Next
            End If

            Dim oldOwners = context.PropertyOwners.Where(Function(pf) pf.BBLE = BBLE).ToList
            If oldOwners.Count > _owners.Count Then
                For Each owner In oldOwners
                    If Not _owners.Any(Function(ow) ow.OwnerId = owner.OwnerId) Then
                        context.PropertyOwners.Remove(owner)
                    End If
                Next
                context.SaveChanges()
            End If

        End Using
    End Sub

    Public Shared Function GetInstance(BBLE As String) As PropertyBaseInfo
        Using context As New ShortSaleEntities
            Return context.PropertyBaseInfoes.Find(BBLE)
        End Using
    End Function
End Class
