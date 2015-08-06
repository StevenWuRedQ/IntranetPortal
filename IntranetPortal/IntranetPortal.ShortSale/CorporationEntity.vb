Public Class CorporationEntity

    Private Shared ReadOnly DocumentLibrary = "CorporationEntity"

    Public Shared Function GetEntitiesByStatus(status As String()) As List(Of CorporationEntity)
        Using ctx As New ShortSaleEntities
            Return ctx.CorporationEntities.Where(Function(s) status.Contains(s.Status)).ToList
        End Using
    End Function

    Public Shared Function GetEntitiesByStatus(name As String, status As String) As List(Of CorporationEntity)
        Using ctx As New ShortSaleEntities
            Return ctx.CorporationEntities.Where(Function(s) status = s.Status AndAlso s.CorpName.Contains(name)).ToList
        End Using
    End Function

    Public Shared Function GetAllEntities() As List(Of CorporationEntity)
        Using ctx As New ShortSaleEntities
            Return ctx.CorporationEntities.ToList
        End Using
    End Function

    Public Shared Function GetEntity(entityId As Integer) As CorporationEntity
        Using ctx As New ShortSaleEntities
            Return ctx.CorporationEntities.Find(entityId)
        End Using
    End Function

    Public Shared Function UploadFile(entityId As Integer, fileName As String, fileBytes As Byte(), uploadBy As String) As String
        Dim corp = CorporationEntity.GetEntity(entityId)

        Dim fileUrl = String.Format("/{0}/{1}/{2}", DocumentLibrary, corp.CorpName.Trim, fileName)
        Core.DocumentService.CreateFolder(DocumentLibrary, corp.CorpName.Trim)
        Return Core.DocumentService.UploadFile(fileUrl, fileBytes, uploadBy)
    End Function

    Public Shared Function GetEntityByCorpName(CorpName As String) As CorporationEntity
        Using ctx As New ShortSaleEntities
            Return ctx.CorporationEntities.Where(Function(c) c.CorpName = CorpName).FirstOrDefault
        End Using
    End Function

    Public Sub Save()
        Using context As New ShortSaleEntities

            If EntityId = 0 Then
                CreateTime = DateTime.Now
                context.Entry(Me).State = Entity.EntityState.Added
            Else
                Dim obj = context.CorporationEntities.Find(EntityId)
                obj = Core.Utility.SaveChangesObj(obj, Me)
                obj.UpdateTime = DateTime.Now
            End If

            context.SaveChanges()
        End Using
    End Sub

    Public Sub Delete()
        Using ctx As New ShortSaleEntities
            Dim obj = ctx.CorporationEntities.Find(EntityId)
            ctx.CorporationEntities.Remove(obj)
            ctx.SaveChanges()
        End Using
    End Sub
End Class
