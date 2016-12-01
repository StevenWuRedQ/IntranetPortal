﻿Partial Public Class OwnerContact
    Public Enum OwnerContactType
        Phone
        MailAddress
    End Enum

    Public Enum ContactStatus
        Wrong = 0
        Right = 1
        DoorKnock = 2
        Undo = 3
    End Enum

    Public Shared Sub UpdateContact(bble As String, status As ContactStatus, phoneNo As String, type As OwnerContactType)
        Using Context As New Entities

            Dim contact = Context.OwnerContacts.Where(Function(c) c.BBLE = bble And c.Contact.Contains(phoneNo)).FirstOrDefault

            'Remove the saved info. 
            If status = OwnerContact.ContactStatus.Undo Then
                If contact IsNot Nothing Then
                    Context.OwnerContacts.Remove(contact)
                    Context.SaveChanges()
                End If

                Return
            End If

            If contact Is Nothing Then
                contact = New OwnerContact
                contact.BBLE = bble
                contact.Contact = phoneNo
                contact.ContactType = type
                contact.Status = status
                'contact.OwnerName = home
                Context.OwnerContacts.Add(contact)
            Else
                contact.BBLE = bble
                contact.Contact = phoneNo
                contact.ContactType = type
                contact.Status = status
            End If

            Context.SaveChanges()

        End Using
    End Sub

    Public Shared Function GetContact(bble As String, phoneNo As String) As OwnerContact
        Using ctx As New Entities
            Return ctx.OwnerContacts.Where(Function(c) c.BBLE = bble AndAlso c.Contact = phoneNo).FirstOrDefault
        End Using
    End Function
End Class
