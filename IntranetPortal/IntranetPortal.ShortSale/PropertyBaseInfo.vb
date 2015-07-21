
Partial Public Class PropertyBaseInfo

    Public ReadOnly Property PropertyAddress As String
        Get
            Return IntranetPortal.Core.PropertyHelper.BuildPropertyAddress(Number, StreetName, "", City, Zipcode)
        End Get
    End Property

    Private _propFloors As List(Of PropertyFloor)
    Public ReadOnly Property PropFloors As List(Of PropertyFloor)
        Get
            If _propFloors Is Nothing Then
                Using context As New ShortSaleEntities
                    _propFloors = context.PropertyFloors.Where(Function(fl) fl.BBLE = BBLE).ToList
                End Using
            End If

            Return _propFloors
        End Get
    End Property

    Private _owners As List(Of PropertyOwner)
    Public ReadOnly Property Owners As List(Of PropertyOwner)
        Get
            If _owners Is Nothing Then
                Using context As New ShortSaleEntities
                    _owners = context.PropertyOwners.Where(Function(po) po.BBLE = BBLE).ToList
                End Using
            End If

            Return _owners
        End Get
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
                    floor.Save()
                Next
            End If

            If _owners IsNot Nothing Then
                For Each owner In _owners
                    owner.BBLE = BBLE
                    owner.Save()
                Next
            End If
        End Using
    End Sub

    Public Shared Function GetInstance(BBLE As String) As PropertyBaseInfo
        Using context As New ShortSaleEntities
            Return context.PropertyBaseInfoes.Find(BBLE)
        End Using
    End Function
End Class
