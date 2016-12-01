Imports IntranetPortal.Data

''' <summary>
''' Dialer service manage class
''' </summary>
Public Class DialerServiceManage

    Private Const CONTACTLISTNAME = "List_{0}"
    Private Shared Function GetAgentContactListName(userName As String) As String
        Return String.Format(CONTACTLISTNAME, userName)
    End Function

    Public Shared Function GetContactListId(userName As String) As String
        Dim service As New DialerService
        Dim task = service.GetContactListByName(GetAgentContactListName(userName))
        task.Wait()
        Dim jsobj = task.Result
        If jsobj IsNot Nothing Then
            Return jsobj("id").ToString
        Else
            Throw New Exception("Can't find agent contact list. Agent name: " & userName)
        End If
    End Function

    Public Shared Async Function LoadContactList(userName As String) As Threading.Tasks.Task(Of Integer)
        Dim service As New DialerService
        Dim listId = GetContactListId(userName)
        Dim list = Await service.ExportList(listId, False)
        If list IsNot Nothing AndAlso list.Count > 0 Then
            Dim result = DialerContact.BatchSave(userName, listId, list.ToArray)
            Return result
        End If

        Return 0
    End Function

    Public Shared Function ClearContactList(userName As String) As Integer
        Dim service As New DialerService
        Dim listId = GetContactListId(userName)
        Dim task = service.ExportList(listId, False)
        task.Wait()
        Dim contacts = task.Result

        For Each ct In contacts
            Dim task2 = service.RemoveContactFromList(listId, ct.inin_outbound_id)
            task2.Wait()
        Next
        Return contacts.Count
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
                If ct.LeadsStatus > 0 Then
                    Lead.UpdateLeadStatus(ct.BBLE, ct.LeadsStatus, DateTime.Now.AddDays(1), ct.Comments)
                    Dim task = service.RemoveContactFromList(ct.ContactListId, ct.inin_outbound_id)
                    task.Wait()
                End If
            End If

            UpdatePhoneNums(ct)

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
        Dim contacts = DialerContact.LoadContacts(userName, DialerContact.RecordStatus.Processed).ToList
        Dim contactBBLEs = contacts.Select(Function(c) c.BBLE).ToArray
        Dim items = lds.Where(Function(l) Not contactBBLEs.Contains(l.BBLE)).ToList
        If items IsNot Nothing AndAlso items.Count > 0 Then
            Dim listId = GetContactListId(userName)
            Dim data As New List(Of DialerContact)
            For Each item In items
                Dim ct = InitContact(item)
                data.Add(ct)
            Next

            If data.Count > 0 Then
                Dim service As New DialerService
                service.AddContactsToList(listId, data)
            End If
        End If

        For Each ct In contacts
            ct.Completed()
        Next

        Return items.Count
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

    ''' <summary>
    ''' Create Contact list base on User Name
    ''' </summary>
    ''' <param name="userName"></param>
    ''' <returns></returns>
    Public Shared Async Function CreateContactList(userName As String) As Threading.Tasks.Task(Of String)
        Dim service As New DialerService
        Dim list = Await service.AddContactList(GetAgentContactListName(userName))
        If list Is Nothing Then
            Throw New Exception("Error happend")
        End If

        Return list("id")
    End Function

    ''' <summary>
    ''' Update phone number status base on the dialer result
    ''' </summary>
    ''' <param name="contact"></param>
    Public Shared Sub UpdatePhoneNums(contact As DialerContact)
        Dim props = contact.GetType().GetProperties()

        Dim phones = props.Where(Function(p) ((p.Name.StartsWith("OwnerPhone") OrElse p.Name.StartsWith("CoOwnerPhone")) AndAlso
                                               Not String.IsNullOrEmpty(p.GetValue(contact)))).ToArray

        For Each ph In phones
            Dim phoneNo = ph.GetValue(contact).ToString
            Dim lastResult = props.Where(Function(p) p.Name = "CallRecordLastResult_" & ph.Name).Select(Function(p)
                                                                                                            Return p.GetValue(contact)
                                                                                                        End Function).FirstOrDefault
            UpdatePhoneResult(contact.BBLE, phoneNo, lastResult)
        Next
    End Sub

    Public Shared Function UpdatePhoneResult(bble As String, phone As String, result As String)
        Select Case result
            Case "Active - Right Contact"
                OwnerContact.UpdateContact(bble, OwnerContact.ContactStatus.Right, phone, OwnerContact.OwnerContactType.Phone)
        End Select

        Return True
    End Function

End Class
