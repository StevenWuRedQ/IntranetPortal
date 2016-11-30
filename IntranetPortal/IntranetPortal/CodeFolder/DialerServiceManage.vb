﻿Imports IntranetPortal.Data

''' <summary>
''' Dialer service manage class
''' </summary>
Public Class DialerServiceManage

    ''' <summary>
    ''' Update contactlist result to portal
    ''' </summary>
    ''' <param name="userName">The Agent Name</param>
    ''' <returns></returns>
    Public Shared Function UpdatePortal(userName As String) As Boolean

        Dim contacts = DialerContact.LoadContacts(userName, DialerContact.RecordStatus.Active)

        For Each ct In contacts
            If ct.LeadsStatus.HasValue Then
                Dim ld = Lead.GetInstance(ct.BBLE)
                Lead.UpdateLeadStatus(ct.BBLE, ct.LeadsStatus, DateTime.Now.AddDays(1), ct.Comments)
            End If

            ct.Processed()
        Next

        Return True
    End Function

    ''' <summary>
    ''' Sync new leads into contact list
    ''' </summary>
    ''' <param name="userName">Agent name</param>
    ''' <returns></returns>
    Public Shared Function SyncNewLeadsFolder(userName As String) As Integer
        Dim lds = Lead.GetUserLeadsData(userName, LeadStatus.NewLead)
        Dim contacts = DialerContact.LoadContacts(userName, DialerContact.RecordStatus.Processed).Select(Function(a) a.BBLE).ToList
        Dim items = lds.Where(Function(l) Not contacts.Contains(l.BBLE)).ToList

        For Each item In items
            Dim ct = InitContact(item)
            ct.Save()
        Next

    End Function

    ''' <summary>
    ''' Init the contact object from leads
    ''' </summary>
    ''' <param name="ld">The Leads</param>
    ''' <returns></returns>
    Public Shared Function InitContact(ld As Lead) As DialerContact
        Dim ct As New DialerContact
        ct.BBLE = ld.BBLE
        ct.Address = ld.LeadsInfo.PropertyAddress
        ct.Agent = ld.EmployeeName
        ct.Owner = ld.LeadsInfo.Owner

        Dim ownerPhones = HomeOwnerPhone.GetPhoneNums(ld.BBLE, ct.Owner)
        For i = 0 To 20
            If i >= ownerPhones.Length Then
                Exit For
            End If

            Dim phone = ownerPhones(i)
            ct.GetType().GetProperty("OwnerPhone" & (i + 1)).SetValue(ct, phone)
        Next

        If Not String.IsNullOrEmpty(ld.LeadsInfo.CoOwner) Then
            ct.CoOwner = ld.LeadsInfo.CoOwner

            ownerPhones = HomeOwnerPhone.GetPhoneNums(ld.BBLE, ct.CoOwner)
            For i = 0 To 20
                If i >= ownerPhones.Length Then
                    Exit For
                End If

                Dim phone = ownerPhones(i)
                ct.GetType().GetProperty("CoOwnerPhone" & (i + 1)).SetValue(ct, phone)
            Next

        End If

        Return ct
    End Function

    Public Shared Function UpdatePhoneNums(contact As DialerContact)
        Dim props = contact.GetType().GetProperties()

        Dim phones = props.Where(Function(p) ((p.Name.StartsWith("OwnerPhone") OrElse p.Name.StartsWith("CoOwnerPhone")) AndAlso
                                               Not String.IsNullOrEmpty(p.GetValue(contact)))).ToArray

        For Each ph In phones
            Dim phoneNo = ph.GetValue(contact).ToString
            Dim lastResult = props.Where(Function(p) p.Name.StartsWith("CallRecordLastResult-" & p.Name)).Select(Function(p)
                                                                                                                     Return p.GetValue(contact)
                                                                                                                 End Function).FirstOrDefault
            UpdatePhoneResult(contact.BBLE, phoneNo, lastResult)
        Next

        Return False
    End Function

    Public Shared Function UpdatePhoneResult(bble As String, phone As String, result As String)
        Select Case result
            Case "Active - Right Contact"
                OwnerContact.UpdateContact(bble, OwnerContact.ContactStatus.Right, phone, OwnerContact.OwnerContactType.Phone)
        End Select

        Return True
    End Function

End Class
