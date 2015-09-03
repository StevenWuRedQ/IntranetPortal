Imports System.ComponentModel.DataAnnotations

<MetadataType(GetType(FormDataItemMetaData))>
Public Class FormDataItem

    Private _businessData As BusinessDataBase
    Public ReadOnly Property BusinessData As BusinessDataBase
        Get
            If _businessData Is Nothing Then
                _businessData = BusinessDataBase.Create(FormName)
            End If

            Return _businessData
        End Get
    End Property

    Public Shared Function Instance(dataId As Integer) As FormDataItem
        Using ctx As New ConstructionEntities
            Return ctx.FormDataItems.Find(dataId)
        End Using
    End Function

    Public Sub Save(saveBy As String)
        Using ctx As New ConstructionEntities

            If Not ctx.FormDataItems.Any(Function(c) c.DataId = DataId) Then
                Me.CreateBy = saveBy
                Me.CreateDate = DateTime.Now
                ctx.FormDataItems.Add(Me)
            Else
                Me.UpdateBy = saveBy
                Me.UpdateDate = DateTime.Now
                ctx.Entry(Me).State = Entity.EntityState.Modified
            End If
            ctx.SaveChanges()

            Me.Tag = BusinessData.Save(Me)
        End Using
    End Sub
End Class

Public Class FormDataItemMetaData
    <Newtonsoft.Json.JsonConverter(GetType(Core.JsObjectToStringConverter))>
    Public Property FormData As String
End Class
