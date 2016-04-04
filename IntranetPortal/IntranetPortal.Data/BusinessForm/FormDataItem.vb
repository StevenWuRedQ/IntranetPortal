Imports System.ComponentModel.DataAnnotations

<MetadataType(GetType(FormDataItemMetaData))>
Public Class FormDataItem

    Private _businessData As BusinessDataBase
    Public ReadOnly Property BusinessData As BusinessDataBase
        Get
            If _businessData Is Nothing AndAlso Not String.IsNullOrEmpty(FormName) Then
                _businessData = CreateBusinessDataInstance()
                If DataId > 0 Then
                    _businessData = _businessData.LoadData(DataId)
                End If
            End If

            Return _businessData
        End Get
    End Property

    Public Sub LogSave(saveBy As String)
        Core.SystemLog.Log(Me.FormName, Me.FormData, Core.SystemLog.LogCategory.SaveData, Me.Tag, saveBy)
    End Sub

    Public Sub LogOpen(openBy As String)
        Core.SystemLog.Log(Me.FormName, "Business Form", Core.SystemLog.LogCategory.OpenData, Me.Tag, openBy)
    End Sub

    Public Shared Function Instance(name As String, tag As String) As FormDataItem
        Using ctx As New PortalEntities
            Return ctx.FormDataItems.Where(Function(f) f.FormName = name AndAlso f.Tag = tag).FirstOrDefault
        End Using
    End Function

    Public Shared Function Instance(dataId As Integer) As FormDataItem
        Using ctx As New PortalEntities
            Return ctx.FormDataItems.Find(dataId)
        End Using
    End Function

    ''' <summary>
    ''' Return business form instance
    ''' </summary>
    ''' <param name="dataId">form id</param>
    ''' <param name="formName">form name </param>
    ''' <returns></returns>
    Public Shared Function Instance(dataId As Integer, formName As String) As FormDataItem
        Using ctx As New PortalEntities
            Return ctx.FormDataItems.Where(Function(f) f.DataId = dataId AndAlso f.FormName = formName).FirstOrDefault
        End Using
    End Function

    Public Sub Save(saveBy As String)
        Using ctx As New PortalEntities

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

            Dim bId = BusinessData.Save(Me)

            If String.IsNullOrEmpty(Me.Tag) OrElse Me.Tag <> bId Then
                Me.Tag = bId
                ctx.SaveChanges()
            End If
        End Using
    End Sub

    Private Function CreateBusinessDataInstance() As BusinessDataBase
        Dim myobj = New BusinessDataBase

        If Not String.IsNullOrEmpty(FormName) Then
            Dim t = Type.GetType("IntranetPortal.Data." & FormName)
            If t IsNot Nothing Then
                Dim obj = Activator.CreateInstance(t)
                If obj IsNot Nothing Then
                    myobj = obj
                End If
            End If
        End If

        Return myobj
    End Function
End Class

Public Class FormDataItemMetaData
    <Newtonsoft.Json.JsonConverter(GetType(Core.JsObjectToStringConverter))>
    Public Property FormData As String
End Class
