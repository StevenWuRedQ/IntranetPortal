Imports IntranetPortal.Data

''' <summary>
''' Dialer service manage class
''' </summary>
Public Class DialerServiceManage

    Private Const CONTACTLISTNAME = "List_{0}"
    'Private Shared service As DialerService

    'Private Function GetService() As DialerService
    '    If service Is Nothing Then
    '        service = New DialerService
    '    End If

    '    Return service
    'End Function

    Private Shared Function GetAgentContactListName(userName As String) As String
        Return String.Format(CONTACTLISTNAME, userName)
    End Function

    ''' <summary>
    ''' Execute the daily task to sync the contactlist and new leads folder
    ''' </summary>
    ''' <param name="userName">The agent name</param>
    Public Shared Sub RunDailyTask(userName As String)
        LoadContactList(userName)
        UpdatePortal(userName)
        SyncNewLeadsFolder(userName)
    End Sub

    ''' <summary>
    ''' Return contact list id by agent name
    ''' </summary>
    ''' <param name="userName">Agent Name</param>
    ''' <returns>Contact List Id</returns>
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

    Private Shared Function GetAgentContactList(userName As String) As List(Of DialerContact)
        Dim service As New DialerService
        Dim listId = GetContactListId(userName)
        Dim task = service.ExportList(listId, False)
        task.Wait()
        Return task.Result
    End Function

    ''' <summary>
    ''' Save agent's contact list to Portal database
    ''' </summary>
    ''' <param name="userName">Agent Name</param>
    ''' <returns>The amount of records</returns>
    Public Shared Function LoadContactList(userName As String) As Integer
        Dim list = GetAgentContactList(userName)
        If list IsNot Nothing AndAlso list.Count > 0 Then
            Dim result = DialerContact.BatchSave(userName, GetContactListId(userName), list.ToArray)
            Return result
        End If

        Return 0
    End Function

    ''' <summary>
    ''' Clear agent's contact list from clound
    ''' </summary>
    ''' <param name="userName">Agent Name</param>
    ''' <returns></returns>
    Public Shared Function ClearContactList(userName As String) As Integer
        Dim contacts = GetAgentContactList(userName)
        Dim listId = GetContactListId(userName)
        For Each ct In contacts
            RemoveContactFromlist(listId, ct.inin_outbound_id)
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
            Dim ld = Lead.GetInstance(ct.BBLE)

            ' leads was archived
            ' leads was tansferred to other user
            ' leads was move to other folder
            If ld Is Nothing OrElse ld.EmployeeName <> userName OrElse ld.Status > 0 Then
                RemoveContactFromlist(ct.ContactListId, ct.inin_outbound_id)
                ct.Removed()
                Continue For
            End If

            If ct.LeadsStatus.HasValue Then
                If ct.LeadsStatus > 0 Then
                    Lead.UpdateLeadStatus(ct.BBLE, ct.LeadsStatus, DateTime.Now.AddDays(1), ct.Comments, Nothing, ct.Agent)
                    RemoveContactFromlist(ct.ContactListId, ct.inin_outbound_id)
                End If
            End If

            UpdatePhoneNums(ct)
            ct.Processed()
        Next

        Return True
    End Function

    Private Shared Sub RemoveContactFromlist(listId As String, contactId As String)
        Dim service As New DialerService
        Dim task = service.RemoveContactFromList(listId, contactId)
        task.Wait()
    End Sub

    ''' <summary>
    ''' Sync new leads into contact list base on database
    ''' </summary>
    ''' <param name="userName">Agent name</param>
    ''' <returns></returns>
    Public Shared Function SyncNewLeadsFolder(userName As String) As Integer
        Dim lds = Lead.GetUserLeadsData(userName, LeadStatus.NewLead)
        Dim contacts = DialerContact.LoadContacts(userName, DialerContact.RecordStatus.Processed).ToList
        If contacts Is Nothing Then
            Throw New Exception("Agent contact list is nothing. agent name: " & userName)
        End If
        Dim contactBBLEs = contacts.Select(Function(c) c.BBLE).ToArray
        Dim items = lds.Where(Function(l) Not contactBBLEs.Contains(l.BBLE)).ToList
        Dim result = UploadContactsByLeads(userName, items)

        For Each ct In contacts
            ct.Completed()
        Next

        Return result
    End Function

    ''' <summary>
    ''' Sync new leads into contact list base on cloud contact list
    ''' </summary>
    ''' <param name="userName">Agent name</param>
    ''' <returns></returns>
    Public Shared Function UploadNewLeadsToContactlist(userName As String) As Integer
        Dim lds = Lead.GetUserLeadsData(userName, LeadStatus.NewLead)
        Dim contacts = GetAgentContactList(userName)
        Dim contactBBLEs = contacts.Select(Function(c) c.BBLE).ToArray
        Dim items = lds.Where(Function(l) Not contactBBLEs.Contains(l.BBLE)).ToList
        Return UploadContactsByLeads(userName, items)
    End Function

    Private Shared Function UploadContactsByLeads(userName As String, lds As List(Of Lead)) As Integer
        If lds Is Nothing OrElse lds.Count = 0 Then
            Return 0
        End If

        Dim listId = GetContactListId(userName)
        Dim data As New List(Of DialerContact)
        For Each item In lds
            Dim ct = InitContact(item)
            If ct IsNot Nothing Then
                data.Add(ct)
            End If
        Next

        Dim service As New DialerService
        If data.Count > 0 Then
            Dim task = service.AddContactsToList(listId, data)
            task.Wait()
        End If

        Return data.Count
    End Function

    ''' <summary>
    ''' Init the contact object from leads
    ''' </summary>
    ''' <param name="ld">The Leads</param>
    ''' <returns></returns>
    Public Shared Function InitContact(ld As Lead) As DialerContact
        Dim li = ld.LeadsInfo
        Dim ct As New DialerContact
        ct.BBLE = ld.BBLE
        ct.PropertyAddress = li.PropertyAddress
        ct.Agent = ld.EmployeeName
        ct.C1stMotgrAmt = li.C1stMotgrAmt
        ct.C2ndMotgrAmt = li.C2ndMotgrAmt
        ct.DOBViolationsAmt = li.DOBViolationsAmt
        ct.WaterAmt = li.WaterAmt
        ct.TaxesAmt = li.TaxesAmt

        Dim hasPhone = False

        If Not String.IsNullOrEmpty(li.Owner) Then
            ct.Owner = li.Owner
            Dim ownerPhones = HomeOwnerPhone.GetPhoneNums(ld.BBLE, ct.Owner)
            For i = 0 To 19
                If i >= ownerPhones.Length Then
                    Exit For
                End If

                Dim phone = ownerPhones(i)
                ct.GetType().GetProperty("OwnerPhone" & (i + 1)).SetValue(ct, phone)
                hasPhone = True
            Next
        End If

        If Not String.IsNullOrEmpty(li.CoOwner) Then
            ct.CoOwner = li.CoOwner

            Dim ownerPhones = HomeOwnerPhone.GetPhoneNums(ld.BBLE, ct.CoOwner)
            For i = 0 To 19
                If i >= ownerPhones.Length Then
                    Exit For
                End If

                Dim phone = ownerPhones(i)
                ct.GetType().GetProperty("CoOwnerPhone" & (i + 1)).SetValue(ct, phone)
                hasPhone = True
            Next
        End If

        If hasPhone Then
            Return ct
        End If

        Return Nothing
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
                OwnerContact.UpdateContact(bble, OwnerContact.ContactStatus.Right, OwnerContact.FormatPhoneNumber(phone), OwnerContact.OwnerContactType.Phone)
        End Select

        Return True
    End Function

End Class
