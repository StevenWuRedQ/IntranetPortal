
Partial Public Class PartyContact
    Public Enum ContactType
        TitleCompany = 0
        Client = 1
        Attorney = 2
    End Enum

    Public Sub New()

    End Sub

    Public Sub New(contactName As String, contactNumber As String, contactEmail As String)
        Me.Name = contactName
        Me.OfficeNO = contactNumber
        Email = contactEmail
    End Sub

    Public Sub Save()
        Using context As New ShortSaleEntities
            'context.ShortSaleCases.Attach(Me)
            If ContactId = 0 Then
                CreateDate = DateTime.Now
                context.Entry(Me).State = Entity.EntityState.Added
            Else
                Dim obj = context.PartyContacts.Find(ContactId)
                obj = ShortSaleUtility.SaveChangesObj(obj, Me)
            End If

            context.SaveChanges()
        End Using
    End Sub

    Public Shared Function GetContact(contactId As Integer) As PartyContact
        Using context As New ShortSaleEntities
            Return context.PartyContacts.Find(contactId)
        End Using
    End Function

    Public Shared Sub DeleteContact(contactId As Integer)
        Using context As New ShortSaleEntities
            Dim obj = context.PartyContacts.Find(ContactId)

            If obj IsNot Nothing Then
                context.PartyContacts.Remove(obj)
                context.SaveChanges()
            End If
        End Using
    End Sub

    Public Shared Function GetTitleCompanies(type As String) As List(Of PartyContact)
        Using context As New ShortSaleEntities
            If String.IsNullOrEmpty(type) Then
                Return context.PartyContacts.ToList
            Else
                Return context.PartyContacts.Where(Function(pc) pc.Type = CInt(type)).ToList
            End If
        End Using
    End Function
End Class
