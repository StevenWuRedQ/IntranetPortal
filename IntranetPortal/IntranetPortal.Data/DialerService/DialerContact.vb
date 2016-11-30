Partial Class DialerContact

    Public Shared Function BatchSave(agentName As String, contacts As DialerContact()) As Integer
        Using ctx As New PortalEntities

            For Each contact In contacts
                contact.Status = RecordStatus.Active
                contact.Agent = agentName
                If ctx.DialerContacts.Any(Function(a) a.inin_outbound_id = contact.inin_outbound_id) Then
                    ctx.Entry(contact).State = Entity.EntityState.Modified
                Else
                    ctx.DialerContacts.Add(contact)
                End If
            Next

            Return ctx.SaveChanges()
        End Using
    End Function

    Public Sub Save()

    End Sub

    Public Sub Completed()
        Me.Status = RecordStatus.Updated
        Using ctx As New PortalEntities
            Dim item = ctx.DialerContacts.Find(Me.inin_outbound_id)
            item.Status = Me.Status
            ctx.SaveChanges()
        End Using
    End Sub

    Public Sub Processed()
        Me.Status = RecordStatus.Processed
        Using ctx As New PortalEntities
            Dim item = ctx.DialerContacts.Find(Me.inin_outbound_id)
            item.Status = Me.Status
            ctx.SaveChanges()
        End Using
    End Sub

    Public Sub Remove()
        Using ctx As New PortalEntities

        End Using
    End Sub

    Public Shared Function LoadContacts(userName As String, status As RecordStatus) As List(Of DialerContact)
        Using ctx As New PortalEntities
            Return ctx.DialerContacts.Where(Function(a) a.Status = status And a.Agent = userName).ToList
        End Using
    End Function

    Public Enum RecordStatus
        Active = 0
        Processed = 1
        Removed = 2
        Updated = 3
    End Enum

End Class
