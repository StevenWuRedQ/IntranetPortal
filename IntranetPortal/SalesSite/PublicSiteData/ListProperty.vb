Partial Public Class ListProperty

    Public Shared Function GetProperty(bble As String) As ListProperty
        Using ctx As New PublicSiteEntities
            Return ctx.ListProperties.Find(bble)
        End Using
    End Function

    Public Shared Function GetRecentListing() As List(Of ListProperty)
        Using ctx As New PublicSiteEntities
            Return ctx.ListProperties.OrderByDescending(Function(lp) lp.CreateDate).Take(4).ToList
        End Using
    End Function

    Public Shared Function GetListedPropertyByOwner(ownerNames As String()) As List(Of ListProperty)
        Using ctx As New PublicSiteEntities
            Return ctx.ListProperties.Where(Function(p) ownerNames.Contains(p.Agent)).ToList
        End Using
    End Function

    Public Shared Function SearchList(criteria As SearchCriteria) As List(Of ListProperty)
        Return GetRecentListing()
    End Function

    Public Function Create() As ListProperty
        Me.CreateDate = DateTime.Now
        Me.Status = ListPropertyStatus.Publishing

        Using ctx As New PublicSiteEntities
            ctx.ListProperties.Add(Me)
            ctx.SaveChanges()

            Return Me
        End Using
    End Function

    Public Sub Save()
        Using ctx As New PublicSiteEntities
            Dim data = ctx.ListProperties.Find(BBLE)
            Utility.SaveChangesObj(data, Me)
            ctx.SaveChanges()
        End Using
    End Sub

    Private _features As List(Of PropertyFeature)
    Public ReadOnly Property Features As List(Of PropertyFeature)
        Get
            If _features Is Nothing Then
                Using ctx As New PublicSiteEntities
                    _features = ctx.PropertyFeatures.Where(Function(a) a.BBLE = BBLE).ToList
                End Using
            End If
            Return _features
        End Get
    End Property

    Public Sub SaveFeatures(features As List(Of PropertyFeature))
        Using ctx As New PublicSiteEntities
            Dim tmpFeatures = ctx.PropertyFeatures.Where(Function(pf) pf.BBLE = BBLE).ToList
            ctx.PropertyFeatures.RemoveRange(tmpFeatures)
            ctx.PropertyFeatures.AddRange(features)
            ctx.SaveChanges()
        End Using
    End Sub

    Public ReadOnly Property Images As List(Of PropertyImage)
        Get
            Return PropertyImage.GetPropertyImages(BBLE)
        End Get
    End Property

    Public Enum ListPropertyStatus
        Publishing = 0
        Published = 1
        UnPublish = 2
        Sold = 3
    End Enum
End Class

Public Class SearchCriteria
    Public Property Type As String
    Public Property Keyword As String
    Public Property PriceRange As Range
    Public Property BedRoomCount As Integer
    Public Property BathRoomCount As Integer
    Public Property More As String

    Public Property Result As List(Of ListProperty)

    Public Structure Range
        Public Property Min As Decimal
        Public Property Max As Decimal
    End Structure
End Class

Partial Public Class FeatureData
    Public Shared Function GetList() As List(Of FeatureData)
        Using ctx As New PublicSiteEntities
            Return ctx.FeatureDatas.ToList
        End Using
    End Function
End Class

Partial Public Class PropertyImage
    Public Shared Function GetPropertyImages(bble As String) As List(Of PropertyImage)
        Using ctx As New PublicSiteEntities
            Return ctx.PropertyImages.Where(Function(pi) pi.BBLE = bble).OrderBy(Function(pi) pi.OrderId).ToList
        End Using
    End Function

    Public Shared Function GetImage(imageId As Integer) As PropertyImage
        Using ctx As New PublicSiteEntities
            Return ctx.PropertyImages.Find(imageId)
        End Using
    End Function

    Public Shared Sub UpdateBBLE(fileId As Integer, bble As String, Description As String)
        Using ctx As New PublicSiteEntities
            Dim img = ctx.PropertyImages.Find(fileId)
            img.BBLE = bble
            If Not String.IsNullOrEmpty(Description) Then
                img.Description = Description
            End If

            ctx.SaveChanges()
        End Using
    End Sub

    Public Function Create() As PropertyImage
        Using ctx As New PublicSiteEntities
            Me.CreateDate = DateTime.Now
            ctx.PropertyImages.Add(Me)
            ctx.SaveChanges()

            Return Me
        End Using
    End Function

    Public Sub Save()
        Using ctx As New PublicSiteEntities
            Dim img = ctx.PropertyImages.Find(ImageId)
            Utility.SaveChangesObj(img, Me)
            ctx.SaveChanges()
        End Using
    End Sub

    Public Shared Sub Delete(imgId As Integer)
        Using ctx As New PublicSiteEntities
            Dim img = ctx.PropertyImages.Find(imgId)
            ctx.PropertyImages.Remove(img)
            ctx.SaveChanges()
        End Using
    End Sub
End Class

Public Class Utility
    Public Shared Function SaveChangesObj(oldObj As Object, newObj As Object) As Object
        Dim type = oldObj.GetType()

        For Each prop In type.GetProperties
            Dim newValue = prop.GetValue(newObj)
            If newValue IsNot Nothing Then
                Dim oldValue = prop.GetValue(oldObj)
                If Not newValue.Equals(oldValue) Then
                    If prop.CanWrite Then
                        prop.SetValue(oldObj, newValue)
                    End If
                End If
            End If
        Next
        Return oldObj
    End Function
End Class