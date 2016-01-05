
Partial Public Class DataStatu

    Public Shared Function LoadDataStatus(category As String) As List(Of DataStatu)

        Using ctx As New PortalEntities
            Return ctx.DataStatus.Where(Function(ds) ds.Active = True AndAlso ds.Category = category).OrderBy(Function(ds) ds.DisplayOrder).ToList
        End Using
    End Function

    Public Shared Function LoadCategories() As String()

        Using ctx As New PortalEntities
            Return ctx.DataStatus.Select(Function(a) a.Category).Distinct.ToArray
        End Using
    End Function

    Public Shared Function LoadAllDataStatus(category As String) As List(Of DataStatu)

        Using ctx As New PortalEntities
            Return ctx.DataStatus.Where(Function(ds) ds.Category = category).OrderBy(Function(ds) ds.DisplayOrder).ToList
        End Using
    End Function

    Public Shared Function Instance(category As String, statusId As Integer) As DataStatu
        Using ctx As New PortalEntities
            Return ctx.DataStatus.Find(category, statusId)
        End Using
    End Function

    Private Function GetNewStatus(category As String) As Integer
        Dim status = LoadAllDataStatus(category)
        Return status.Max(Function(s) s.Status) + 1
    End Function

    Public Sub Save()
        Using ctx As New PortalEntities
            If Not ctx.DataStatus.Any(Function(s) s.Category = Category AndAlso s.Status = Status) Then
                Me.Status = GetNewStatus(Me.Category)
                ctx.Entry(Me).State = Entity.EntityState.Added
            Else
                ctx.Entry(Me).State = Entity.EntityState.Modified
            End If

            ctx.SaveChanges()
        End Using
    End Sub

    Public Sub Delete()
        Using ctx As New PortalEntities
            ctx.Entry(Me).State = Entity.EntityState.Deleted
            ctx.SaveChanges()
        End Using
    End Sub

End Class
