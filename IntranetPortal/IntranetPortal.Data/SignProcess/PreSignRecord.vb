Imports System.ComponentModel.DataAnnotations
Imports Newtonsoft.Json
Imports Newtonsoft.Json.Linq

''' <summary>
''' The model class for Pre Sign Process
''' </summary>
<MetadataType(GetType(PreSignRecordmMetaData))>
Partial Public Class PreSignRecord

    ' For UI purpose this version don't have client model so move model define in servier side,
    ' Can Move it to client side model later after we descusss but doing on server side is also okay.
    ' By Steven
    Public Property CheckRequestData As New CheckRequest
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
                If (record.CheckRequestId) Then
                    record.CheckRequestData = CheckRequest.GetInstance(record.CheckRequestId)
                End If

            End If

            Return record
        End Using
    End Function

    ''' <summary>
    ''' Return Pre Sign process instance by property BBLE
    ''' </summary>
    ''' <param name="bble">The propety bble</param>
    ''' <returns></returns>
    Public Shared Function GetInstanceByBBLE(bble As String) As PreSignRecord
        Using ctx As New PortalEntities

            Dim record = ctx.PreSignRecords.Where(Function(p) p.BBLE = bble).FirstOrDefault

            If record Is Nothing Then
                Return Nothing
            End If

            If record.NeedSearch Then
                record.SearchData = LeadInfoDocumentSearch.GetInstance(record.BBLE)
            End If

            If record.NeedCheck Then

                If (record.CheckRequestId IsNot Nothing) Then
                    record.CheckRequestData = CheckRequest.GetInstance(record.CheckRequestId)
                End If

            End If

            Return record
        End Using
    End Function

    ''' <summary>
    ''' Becuase backend model can not know UI change so pass client model property 
    ''' may have other way doing better use cient side model
    ''' By Steven
    ''' </summary>
    ''' <param name="isNeedCheck"></param>
    ''' <param name="check"></param>
    ''' <returns></returns>
    Public Function AddCheck(isNeedCheck As Boolean, check As BusinessCheck, Optional saveBy As String = Nothing) As BusinessCheck

        If (Not isNeedCheck) Then
            Throw New Exception("Can not add check when need check is not selected")
        End If

        Me.NeedCheck = isNeedCheck

        If (Me.NeedCheck And (Me.CheckRequestId Is Nothing Or Me.CheckRequestId = 0)) Then

            Me.CheckRequestData = New CheckRequest()
            Me.CheckRequestData.BBLE = BBLE
            Me.CheckRequestData.Type = "Short Sale"
            Me.CheckRequestData.Checks.Add(check)
            Me.CheckRequestData.Create(saveBy)

            ''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
            Me.CheckRequestId = Me.CheckRequestData.RequestId
            Me.Save(saveBy)
            '' save twice for safety maybe other desgin will better or we don't need it even

            '' not necessary Chris check it later
            'Me.CheckRequestData.Save(saveBy)
            '' not necessary Chris check it later

        Else
            Me.CheckRequestData.AddCheck(check, saveBy)
        End If

        'check.RequestId = Me.CheckRequestId

        ''not necessary Chris check it later
        'check.Save(saveBy)

        Return check
    End Function

    ''' <summary>
    ''' Create the record
    ''' </summary>
    ''' <param name="createBy"></param>
    Public Sub Create(createBy As String)
        Using ctx As New PortalEntities
            If String.IsNullOrEmpty(BBLE) Then
                Throw New DataException("BBLE is mandatory.")
            End If

            If ctx.PreSignRecords.Any(Function(p) p.BBLE = BBLE) Then
                Throw New DataException("The records already exist.")
            Else
                If Me.NeedCheck Then
                    Me.CheckRequestData.Create(createBy)
                    Me.CheckRequestId = Me.CheckRequestData.RequestId
                End If

                Me.Owner = createBy
                Me.CreateBy = createBy
                Me.CreateDate = DateTime.Now

                ctx.PreSignRecords.Add(Me)
                ctx.SaveChanges(createBy)
            End If
        End Using
    End Sub

    ''' <summary>
    ''' Save data
    ''' </summary>
    ''' <param name="saveBy"></param>
    Public Sub Save(saveBy As String)

        Using ctx As New PortalEntities

            If ctx.PreSignRecords.Any(Function(r) r.Id = Id) Then
                Me.UpdateBy = saveBy
                Me.UpdateTime = DateTime.Now
                ctx.Entry(Me).State = Entity.EntityState.Modified
                ctx.Entry(Me).OriginalValues.SetValues(ctx.Entry(Me).GetDatabaseValues)
            Else
                Me.CreateBy = saveBy
                Me.CreateDate = DateTime.Now

            End If

            ctx.SaveChanges(saveBy)

            If Me.NeedCheck AndAlso Me.CheckRequestData IsNot Nothing Then
                Me.CheckRequestData.Save(saveBy)
            End If
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