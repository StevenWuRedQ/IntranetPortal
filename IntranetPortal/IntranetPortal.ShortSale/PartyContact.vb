
Partial Public Class PartyContact
    Public Enum ContactType
        TitleCompany = 0
        Client = 1
        Attorney = 2
        Employee = 3
        Lender = 4
    End Enum

    Public Sub New()

    End Sub
    Public Shared Function getAllEmail() As List(Of String)

        Using context As New ShortSaleEntities
            Return context.PartyContacts.Select(Function(e) e.Email).Where(Function(e) e.IndexOf("@") > 0).ToList
        End Using
    End Function
    Public Shared Function getAllContact() As List(Of PartyContact)
        Using context As New ShortSaleEntities
            Dim result = context.PartyContacts.Where(Function(pc) pc.Type <> ContactType.Employee AndAlso Not String.IsNullOrEmpty(pc.Name)).ToList
            result.AddRange(GetContactByType(ContactType.Employee))

            Return result '.Where(Function(pc) Not String.IsNullOrEmpty(pc.Name))
        End Using
    End Function
    Public Shared Function SearchContacts(query As String) As List(Of PartyContact)
        If (query Is Nothing) Then
            Return Nothing
        End If
        query = query.ToUpper()
        Using context As New ShortSaleEntities
            Dim result = context.PartyContacts.Where(Function(pc) pc.Name.ToUpper().Contains(query) Or pc.OfficeNO.ToUpper().Contains(query) Or pc.Cell.ToUpper().Contains(query) Or pc.CorpName.ToUpper().Contains(query)).ToList()
            Return result
        End Using
    End Function

    

    Public Shared Function GetContactByType(type As ContactType) As List(Of PartyContact)
        Using ctx As New ShortSaleEntities
            If type = ContactType.Employee Then
                Dim result = (From emp In ctx.Employees.Where(Function(em) em.Active = True).ToList
                              Group Join pc In ctx.PartyContacts.Where(Function(pc) pc.Type = ContactType.Employee).ToList On pc.Name Equals emp.Name
                              Into contacts = Group
                            From cat In contacts.DefaultIfEmpty
                             Select New PartyContact With
                                    {
                                        .ContactId = If(cat Is Nothing, 0, cat.ContactId),
                                        .Name = emp.Name,
                                        .Office = emp.Department,
                                        .Email = emp.Email,
                                        .Cell = emp.Cellphone,
                                        .Type = ContactType.Employee
                                        }).ToList

                For Each emp In result.Where(Function(em) em.ContactId = 0).Distinct
                    emp.CreateBy = "System"
                    emp.Save()
                Next

                Return ctx.PartyContacts.Where(Function(p) p.Type = type).ToList
            Else
                Return ctx.PartyContacts.Where(Function(p) p.Type = type).ToList
            End If
        End Using
    End Function

    Public Sub New(contactName As String, contactNumber As String, contactEmail As String)
        Me.Name = contactName
        Me.OfficeNO = contactNumber
        Email = contactEmail
    End Sub

    Public Sub Save()
        Using context As New ShortSaleEntities

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
    Public Shared Function GetContactListByName(name As String) As List(Of PartyContact)
        Using ctx As New ShortSaleEntities
            Return ctx.PartyContacts.Where(Function(p) p.Name = name).ToList
        End Using
    End Function
    Public Shared Function GetContactByName(name As String) As PartyContact
        Using ctx As New ShortSaleEntities
            Return ctx.PartyContacts.Where(Function(pc) pc.Name = name).FirstOrDefault
        End Using
    End Function

    Public Shared Function GetContactByName(name As String, corpName As String, phone As String, fax As String, email As String) As PartyContact
        Using ctx As New ShortSaleEntities
            Dim contact = ctx.PartyContacts.Where(Function(pc) pc.Name = name).FirstOrDefault
            If contact Is Nothing Then
                contact = New PartyContact
                contact.Name = name
                contact.CorpName = corpName
                contact.Cell = phone
                contact.OfficeNO = fax
                contact.Email = email

                contact.Save()
            End If

            Return contact
        End Using
    End Function

    Public Shared Sub DeleteContact(contactId As Integer)
        Using context As New ShortSaleEntities
            Dim obj = context.PartyContacts.Find(contactId)

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
