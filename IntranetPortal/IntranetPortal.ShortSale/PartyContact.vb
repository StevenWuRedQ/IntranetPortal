
Partial Public Class PartyContact
    Public Enum ContactType
        TitleCompany = 0
        Client = 1
        Attorney = 2
        Employee = 3
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
            Dim result = context.PartyContacts.Where(Function(pc) pc.Type = ContactType.TitleCompany Or pc.Type = ContactType.Client Or pc.Type = ContactType.Attorney).ToList
            result.AddRange(GetContactByType(ContactType.Employee))
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

                Return result
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
