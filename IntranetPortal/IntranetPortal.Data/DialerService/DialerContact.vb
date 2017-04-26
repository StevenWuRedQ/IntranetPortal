''' <summary>
''' The dialer contact object
''' </summary>
Partial Class DialerContact

    ''' <summary>
    ''' Save contactlist into portal
    ''' </summary>
    ''' <param name="agentName">Agent Name</param>
    ''' <param name="listid">The contact list Id</param>
    ''' <param name="contacts">Contact List data</param>
    ''' <returns></returns>
    Public Shared Function BatchSave(agentName As String, listid As String, contacts As DialerContact()) As Integer
        Using ctx As New PortalEntities

            For Each contact In contacts
                contact.Status = RecordStatus.Active
                contact.Agent = agentName
                contact.ContactListId = listid
                If ctx.DialerContacts.Any(Function(a) a.inin_outbound_id = contact.inin_outbound_id) Then
                    ctx.Entry(contact).State = Entity.EntityState.Modified
                Else
                    ctx.DialerContacts.Add(contact)
                End If
            Next

            Return ctx.SaveChanges()
        End Using
    End Function

    ''' <summary>
    ''' Save object changes
    ''' </summary>
    Public Sub Save()
        Using ctx As New PortalEntities
            Dim item = ctx.DialerContacts.Find(Me.inin_outbound_id)
            item.Status = Me.Status
            item.LastUpdate = DateTime.Now
            ctx.SaveChanges()
        End Using
    End Sub

    ''' <summary>
    ''' Update status to Removed
    ''' </summary>
    Public Sub Removed()
        Me.Status = RecordStatus.Removed
        Me.Save()
    End Sub

    ''' <summary>
    ''' Update status to Completed
    ''' </summary>
    Public Sub Completed()
        Me.Status = RecordStatus.Updated
        Me.Save()
    End Sub

    ''' <summary>
    ''' Update status to Processed
    ''' </summary>
    Public Sub Processed()
        Me.Status = RecordStatus.Processed
        Me.Save()
    End Sub

    ''' <summary>
    ''' Remove the data from database
    ''' </summary>
    Public Sub Remove()
        Using ctx As New PortalEntities

        End Using
    End Sub

    ''' <summary>
    ''' Return active contacts that were just downloaded from cloud
    ''' </summary>
    ''' <param name="userName">Agent Name</param>
    ''' <param name="status">Record Status</param>
    ''' <returns></returns>
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
