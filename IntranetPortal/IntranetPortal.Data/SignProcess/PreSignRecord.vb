Partial Public Class PreSignRecord

    Public Property CheckRequestData As CheckRequest
    Public Property SearchData As LeadInfoDocumentSearch

    Public Shared Function GetInstance(recordId As Integer) As PreSignRecord
        Using ctx As New PortalEntities

            Dim record = ctx.PreSignRecords.Find(recordId)

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

End Class
