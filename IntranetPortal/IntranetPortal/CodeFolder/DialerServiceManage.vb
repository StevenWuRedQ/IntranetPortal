Imports IntranetPortal.Data

''' <summary>
''' Dialer service manage class
''' </summary>
Public Class DialerServiceManage

    Private Shared contactlists As New Dictionary(Of String, String) From {
            {"Chris Yan", "aca8647e-8346-49f6-8938-4df54168afbd"}
    }

    Private Const CONTACTLISTNAME = "List_{0}"

    Public Shared Function GetContactListId(userName As String) As String
        If contactlists.ContainsKey(userName) Then
            Return contactlists(userName)
        End If

        Return "3f247b83-5bcc-41e5-acad-ed71cfdec111"
    End Function

    Public Shared Async Function LoadContactList(userName As String) As Threading.Tasks.Task(Of Integer)
        Dim service As New DialerService
        Dim list = Await service.ExportList(GetContactListId(userName), False)
        If list IsNot Nothing AndAlso list.Count > 0 Then
            Dim result = DialerContact.BatchSave(userName, list.ToArray)
            Return result
        End If

        Return 0
    End Function

    ''' <summary>
    ''' Update contactlist result to portal
    ''' </summary>
    ''' <param name="userName">The Agent Name</param>
    ''' <returns></returns>
    Public Shared Function UpdatePortal(userName As String) As Boolean

        Dim contacts = DialerContact.LoadContacts(userName, DialerContact.RecordStatus.Active)
        Dim service As New DialerService

        For Each ct In contacts
            If ct.LeadsStatus.HasValue Then
                Dim ld = Lead.GetInstance(ct.BBLE)
                If ct.Status > 0 Then
                    Lead.UpdateLeadStatus(ct.BBLE, ct.LeadsStatus, DateTime.Now.AddDays(1), ct.Comments)
                    service.RemoveContactFromList(ct.ContactListId, ct.inin_outbound_id)
                End If
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
        Dim data As New List(Of DialerContact)
        For Each item In items
            Dim ct = InitContact(item)
            data.Add(ct)
        Next

        If data.Count > 0 Then
            Dim service As New DialerService
            service.AddContactsToList(GetContactListId(userName), data)
        End If
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

    Public Shared Async Function CreateContactList(userName As String) As Threading.Tasks.Task(Of String)
        Dim service As New DialerService
        Dim list = Await service.AddContactList(String.Format(CONTACTLISTNAME, userName))
        If list Is Nothing Then
            Throw New Exception("Error happend")
        End If

        Return list("id")
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
