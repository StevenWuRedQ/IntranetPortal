Imports System.ComponentModel.DataAnnotations
Imports Newtonsoft.Json
Imports Newtonsoft.Json.Linq

''' <summary>
''' The model class for Pre Sign Process
''' </summary>
<MetadataType(GetType(PreSignRecordmMetaData))>
Partial Public Class PreSignRecord

    Public Property CheckRequestData As CheckRequest
    Public Property SearchData As LeadInfoDocumentSearch

    ''' <summary>
    ''' Return Pre Sign Records by Owner, will return all records if given owner name *
    ''' </summary>
    ''' <param name="name">Owner Name</param>
    ''' <returns></returns>
    Public Shared Function GetRecords(name As String) As PreSignRecord()
        Using ctx As New PortalEntities
            Dim records = ctx.PreSignRecords.Where(Function(p) p.Owner = name OrElse name = "*").ToArray
            Return records
        End Using
    End Function

    ''' <summary>
    ''' Return Pre Sign process instance by record id
    ''' </summary>
    ''' <param name="recordId">The record id</param>
    ''' <returns></returns>
    Public Shared Function GetInstance(recordId As Integer) As PreSignRecord
        Using ctx As New PortalEntities

            Dim record = ctx.PreSignRecords.Find(recordId)

            If record Is Nothing Then
                Return Nothing
            End If

            If record.NeedSearch Then
                record.SearchData = LeadInfoDocumentSearch.GetInstance(record.BBLE)
            End If

            If record.NeedCheck Then
                record.CheckRequestData = CheckRequest.GetInstance(record.CheckRequestId)
            End If

            Return record
        End Using
    End Function

    Public Sub Create(createBy As String)
        Using ctx As New PortalEntities

            If Me.NeedCheck Then
                Me.CheckRequestData.Create(createBy)
                Me.CheckRequestId = Me.CheckRequestData.RequestId
            End If

            Me.Owner = createBy
            Me.CreateBy = createBy
            Me.CreateDate = DateTime.Now

            ctx.PreSignRecords.Add(Me)
            ctx.SaveChanges()

        End Using
    End Sub

    Public Sub Save(saveBy As String)

        Using ctx As New PortalEntities

            If ctx.PreSignRecords.Any(Function(r) r.Id = Id) Then
                Me.UpdateBy = saveBy
                Me.UpdateTime = DateTime.Now
                ctx.Entry(Me).State = Entity.EntityState.Modified
            Else
                Me.CreateBy = saveBy
                Me.CreateDate = DateTime.Now

            End If

            ctx.SaveChanges()
        End Using
    End Sub

    Public Sub Delete()
        Using ctx As New PortalEntities
            If ctx.PreSignRecords.Any(Function(r) r.Id = Id) Then
                ctx.Entry(Me).State = Entity.EntityState.Deleted
                ctx.SaveChanges()
            End If
        End Using
    End Sub

    Private _partiesArray As JArray

    <JsonIgnoreAttribute>
    Public ReadOnly Property PartiesArray As JArray
        Get
            If _partiesArray Is Nothing Then
                If Not String.IsNullOrEmpty(Parties) Then
                    _partiesArray = JArray.Parse(Parties)
                End If
            End If

            Return _partiesArray
        End Get
    End Property
End Class

Public Class PreSignRecordmMetaData
    <Newtonsoft.Json.JsonConverter(GetType(Core.JsArrayToStringConverter))>
    Public Property Parties As String
End Class