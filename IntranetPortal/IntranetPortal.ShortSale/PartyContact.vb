Partial Public Class PartyContact
    Public Shared Function GetContact(contactId As Integer) As PartyContact
        Using context As New ShortSaleEntities
            Return context.PartyContacts.Find(contactId)
        End Using
    End Function
End Class
