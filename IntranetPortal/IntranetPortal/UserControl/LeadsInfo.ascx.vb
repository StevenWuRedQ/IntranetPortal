Imports DevExpress.Web
Imports System.Threading
Imports IntranetPortal.Core

Public Class LeadsInfo1
    Inherits System.Web.UI.UserControl

    Dim category As Integer
    Dim CategoryName As String
    Public Property HiddenTab As Boolean = False
    Public Property ShowLogPanel As Boolean = True

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not Page.IsPostBack Then

            If Not String.IsNullOrEmpty(Request.QueryString("c")) Then
                CategoryName = Request.QueryString("c")
                category = Utility.GetLeadStatus(CategoryName)
                Dim folders = Utility.GetLeadsCustomStatus()
                If folders.Length > 0 Then
                    For Each o In folders
                        OtherFolderPopup.Items.Add(New MenuItem With {
                                                   .Text = o.ToString,
                                                   .Name = o.ToString & "|" & Int(o).ToString})
                    Next
                Else
                    otherFolderIcon.Visible = False
                End If

                If CategoryName = "Door Knock" Then
                    doorKnockMapPanel.Visible = True
                    ClientVisible = False
                Else
                    doorKnockMapPanel.Visible = False
                End If

            End If

            If Not ShowLogPanel Then
                contentSplitter.GetPaneByName("LogPanel").Collapsed = True
                'contentSplitter.GetPaneByName("paneInfo").Separator.Visible = DevExpress.Utils.DefaultBoolean.False
                'ActivityLogs.Visible = False
            End If
        End If

        HiddenTab = Not String.IsNullOrEmpty(Request.QueryString("HiddenTab"))
        If (HiddenTab) Then
            contentSplitter.GetPaneByName("LogPanel").Visible = False

        End If
    End Sub

    Sub BindLeadsInfo(bble As String)

        Core.SystemLog.Log("ViewLeadsInfo", Request.RawUrl, Core.SystemLog.LogCategory.Operation, bble, Page.User.Identity.Name)

        If Not ShowLogPanel Then
            contentSplitter.GetPaneByName("LogPanel").Collapsed = True
            'contentSplitter.GetPaneByName("paneInfo").Separator.Visible = DevExpress.Utils.DefaultBoolean.False
            'ActivityLogs.Visible = False
        End If

        Using Context As New Entities
            Dim lead = Context.Leads.Where(Function(li) li.BBLE = bble).FirstOrDefault
            Dim leadsinfodata As LeadsInfo

            If lead Is Nothing Then
                leadsinfodata = Context.LeadsInfoes.Where(Function(li) li.BBLE = bble).SingleOrDefault
                If leadsinfodata Is Nothing Then
                    leadsinfodata = DataWCFService.UpdateAssessInfo(bble)
                End If
            Else
                leadsinfodata = lead.LeadsInfo
            End If

            If lead IsNot Nothing AndAlso leadsinfodata Is Nothing Then
                Dim info As New LeadsInfo
                info.BBLE = lead.BBLE
                info.CreateBy = Page.User.Identity.Name
                info.CreateDate = DateTime.Now

                Context.LeadsInfoes.Add(info)
                Context.SaveChanges()

                Context.Entry(lead).Reload()

                leadsinfodata = lead.LeadsInfo
            End If

            'lblLeadsname.Text = lead.LeadsName
            If leadsinfodata IsNot Nothing Then
                'If lead.LeadsInfo.CreateDate
                If String.IsNullOrEmpty(leadsinfodata.Owner) AndAlso String.IsNullOrEmpty(leadsinfodata.Neighborhood) Then
                    If (DataWCFService.UpdateAssessInfo(leadsinfodata.BBLE) IsNot Nothing) Then
                        'Context.Entry(lead).Reload()
                        If lead IsNot Nothing Then
                            Context.Entry(lead.LeadsInfo).Reload()
                            leadsinfodata = lead.LeadsInfo
                        End If
                    End If
                End If

                If String.IsNullOrEmpty(leadsinfodata.PropertyAddress) Then
                    If (DataWCFService.UpdateAssessInfo(leadsinfodata.BBLE) IsNot Nothing) Then
                        'Context.Entry(lead).Reload()
                        If lead IsNot Nothing Then
                            Context.Entry(lead.LeadsInfo).Reload()
                            leadsinfodata = lead.LeadsInfo
                        End If
                    End If
                End If

                PropertyInfo.LeadsInfoData = leadsinfodata
                PropertyInfo.LeadsData = lead
                PropertyInfo.BindData()

                'Bind files info
                DocumentsUI.LeadsName = leadsinfodata.PropertyAddress

                'Bind Owner info
                HomeOwnerInfo2.BBLE = bble
                HomeOwnerInfo2.OwnerName = leadsinfodata.Owner
                HomeOwnerInfo2.BindData(bble)


                'If String.IsNullOrEmpty(leadsinfodata.CoOwner) Then
                '    HomeOwnerInfo3.Visible = False
                'Else
                HomeOwnerInfo3.BBLE = bble
                HomeOwnerInfo3.OwnerName = CoOwnerName(leadsinfodata.CoOwner, leadsinfodata.Owner, bble)
                HomeOwnerInfo3.BindData(bble)
                'End If

                'Bind Liens Info
                'If lead IsNot Nothing Then
                '    Dim liens = Context.PortalLisPens.Where(Function(li) li.BBLE = leadsinfodata.BBLE).ToList

                '    If liens IsNot Nothing Then
                '        gridLiens.DataSource = liens
                '        gridLiens.DataBind()
                '    End If
                'End If

                If lead IsNot Nothing Then
                    BindActivityLog(bble)
                Else
                    BindActivityLog(bble)
                End If
            End If
        End Using
    End Sub

    Protected Function CoOwnerName(CoOwner As String, ownerName As String, bble As String) As String
        If Not String.IsNullOrEmpty(CoOwner) Then
            Return CoOwner
        End If
        Using Context As New Entities
            Dim coOwner2 = Context.HomeOwners.Where(Function(h) h.BBLE = bble AndAlso h.Name <> ownerName And h.UserModified = True).Select(Function(h) h.Name).FirstOrDefault
            If Not String.IsNullOrEmpty(coOwner2) Then
                Return coOwner2
            End If
        End Using
        Return HomeOwner.EMPTY_HOMEOWNER
    End Function

    Sub BindActivityLog(bble As String)
        ActivityLogs.BindData(bble)
        Return
    End Sub

    Public Function GroupText(groupDateText As String) As String
        Dim today = DateTime.Now.Date
        Dim groupDate = Date.Parse(groupDateText)
        If today.Equals(groupDate) Then
            Return "Today"
        Else
            If today.AddDays(1).Equals(groupDate) Then
                Return "Tomorrow"
            Else
                Return groupDateText
            End If
        End If
    End Function

    Public Property ClientVisible() As Boolean
        Get
            Return contentSplitter.ClientVisible
        End Get
        Set(value As Boolean)
            contentSplitter.ClientVisible = value
        End Set
    End Property

    Public Sub BindData(bble As String)
        If Not Employee.HasControlLeads(Page.User.Identity.Name, bble) Then
            Server.Transfer("/PortalError.aspx?code=1001")
        End If

        hfBBLE.Value = bble
        BindLeadsInfo(bble)
    End Sub

    Sub UpdateLeadStatus(bble As String, status As LeadStatus, callbackDate As DateTime)
        Lead.UpdateLeadStatus(bble, status, callbackDate)
    End Sub

    Protected Sub leadStatusCallback_Callback(source As Object, e As DevExpress.Web.CallbackEventArgs)
        If e.Parameter.Length > 0 Then

            If e.Parameter.StartsWith("Tomorrow") Then
                If e.Parameter.Contains("|") Then
                    Dim bble = e.Parameter.Split("|")(1)
                    UpdateLeadStatus(bble, LeadStatus.Callback, DateTime.Now.AddDays(1))
                Else
                    UpdateLeadStatus(hfBBLE.Value, LeadStatus.Callback, DateTime.Now.AddDays(1))
                End If
            End If

            If e.Parameter = "nextWeek" Then
                UpdateLeadStatus(hfBBLE.Value, LeadStatus.Callback, DateTime.Now.AddDays(7))
            End If

            If e.Parameter = "thirtyDays" Then
                UpdateLeadStatus(hfBBLE.Value, LeadStatus.Callback, DateTime.Now.AddDays(30))
            End If

            If e.Parameter = "sixtyDays" Then
                UpdateLeadStatus(hfBBLE.Value, LeadStatus.Callback, DateTime.Now.AddDays(60))
            End If

            If e.Parameter = "customDays" Then

                Dim tmpdate = If(ASPxCalendar1 IsNot Nothing, ASPxCalendar1.Value, DateTime.Today)
                UpdateLeadStatus(hfBBLE.Value, LeadStatus.Callback, tmpdate)
            End If

            If e.Parameter.StartsWith(4) Then
                If e.Parameter.Contains("|") Then
                    Dim bble = e.Parameter.Split("|")(1)
                    UpdateLeadStatus(bble, LeadStatus.DoorKnocks, Nothing)
                Else
                    UpdateLeadStatus(hfBBLE.Value, LeadStatus.DoorKnocks, Nothing)
                End If
            End If

            If e.Parameter.StartsWith(5) Then
                If e.Parameter.Contains("|") Then
                    Dim bble = e.Parameter.Split("|")(1)
                    UpdateLeadStatus(bble, LeadStatus.Priority, Nothing)
                Else
                    UpdateLeadStatus(hfBBLE.Value, LeadStatus.Priority, Nothing)
                End If
            End If

            If e.Parameter.StartsWith(6) Then
                If e.Parameter.Contains("|") Then
                    Dim bble = e.Parameter.Split("|")(1)
                    UpdateLeadStatus(bble, LeadStatus.DeadEnd, Nothing)
                Else
                    'Dim reason = cbDeadReasons.Text
                    'Dim description = txtDeadLeadDescription.Text

                    'UpdateLeadStatus(hfBBLE.Value, LeadStatus.DeadEnd, Nothing)

                    'Dim comments = String.Format("<table style=""width:100%;line-weight:25px;""> <tr><td style=""width:100px;"">Dead Reason:</td>" &
                    '                "<td>{0}</td></tr>" &
                    '                "<tr><td>Description:</td><td>{1}</td></tr>" &
                    '              "</table>", reason, description)
                    'LeadsActivityLog.AddActivityLog(DateTime.Now, comments, hfBBLE.Value, LeadsActivityLog.LogCategory.Status.ToString, LeadsActivityLog.EnumActionType.DeadLead)
                End If
            End If

            If e.Parameter.StartsWith(7) Then
                If e.Parameter.Contains("|") Then
                    Dim bble = e.Parameter.Split("|")(1)
                    UpdateLeadStatus(bble, LeadStatus.InProcess, Nothing)


                    'Add leads to short sale section
                    'ShortSaleManage.MoveLeadsToShortSale(bble, Page.User.Identity.Name)
                Else
                    UpdateLeadStatus(hfBBLE.Value, LeadStatus.InProcess, Nothing)


                End If
            End If

            If e.Parameter.StartsWith(8) Then
                If e.Parameter.Contains("|") Then
                    Dim bble = e.Parameter.Split("|")(1)
                    UpdateLeadStatus(bble, LeadStatus.Closed, Nothing)
                Else
                    UpdateLeadStatus(hfBBLE.Value, LeadStatus.Closed, Nothing)
                End If
            End If

            'Appointment
            If e.Parameter.StartsWith(9) Then

            End If

            'Delete Lead
            If e.Parameter.StartsWith(11) Then
                If e.Parameter.Contains("|") Then
                    Dim bble = e.Parameter.Split("|")(1)
                    UpdateLeadStatus(bble, LeadStatus.Deleted, Nothing)
                Else
                    UpdateLeadStatus(hfBBLE.Value, LeadStatus.Deleted, Nothing)
                End If
            End If
        End If
    End Sub

    Protected Sub btnRefresh_Click(sender As Object, e As EventArgs)
        If Not Page.IsCallback Then

            Dim bble = hfBBLE.Value
            'DataWCFService.UpdateLeadInfo(bble)
            BindData(bble)
        End If
    End Sub

    Protected Sub callPhoneCallback_Callback(source As Object, e As DevExpress.Web.CallbackEventArgs)
        Dim needRefesh = False

        If e.Parameter.StartsWith("CallPhone") Then
            Dim phoneNo = e.Parameter.Split("|")(1)
            Dim comments = String.Format("{0} did phone ({1}) call.", Page.User.Identity.Name, phoneNo)
            LeadsActivityLog.AddActivityLog(DateTime.Now, comments, hfBBLE.Value, LeadsActivityLog.LogCategory.SalesAgent.ToString, LeadsActivityLog.EnumActionType.CallOwner)
            BindActivityLog(hfBBLE.Value)
            HomeOwnerPhone.CallAllPhones(hfBBLE.Value, phoneNo)
            needRefesh = True
        End If

        If e.Parameter.StartsWith("BadPhone") Then
            Dim phoneNo = e.Parameter.Split("|")(1)
            UpdateContact(OwnerContact.ContactStatus.Wrong, phoneNo, OwnerContact.OwnerContactType.Phone)

        End If

        If e.Parameter.StartsWith("RightPhone") Then
            Dim phoneNo = e.Parameter.Split("|")(1)
            UpdateContact(OwnerContact.ContactStatus.Right, phoneNo, OwnerContact.OwnerContactType.Phone)
        End If
        If e.Parameter.StartsWith("SaveComment") Then
            Dim phoneNo As String = e.Parameter.Split("|")(1)
            Dim phone As String = Regex.Replace(phoneNo, "[^\d]+", "")
            Dim comment = e.Parameter.Split("|")(2)
            Using Context As New Entities
                Dim contact = Context.HomeOwnerPhones.Where(Function(c) c.BBLE = hfBBLE.Value And c.Phone = phone).FirstOrDefault()
                If (contact IsNot Nothing) Then
                    contact.Comment = comment
                End If

                Context.SaveChanges()
            End Using

        End If
        If e.Parameter.StartsWith("UndoPhone") Then
            Dim phoneNo = e.Parameter.Split("|")(1)
            UpdateContact(OwnerContact.ContactStatus.Undo, phoneNo, OwnerContact.OwnerContactType.Phone)
        End If

        If e.Parameter.StartsWith("BadAddress") Then
            Dim address = e.Parameter.Split("|")(1)
            UpdateContact(OwnerContact.ContactStatus.Wrong, address, OwnerContact.OwnerContactType.MailAddress)

        End If

        If e.Parameter.StartsWith("RightAddress") Then
            Dim address = e.Parameter.Split("|")(1)
            UpdateContact(OwnerContact.ContactStatus.Right, address, OwnerContact.OwnerContactType.MailAddress)
        End If

        If e.Parameter.StartsWith("DoorKnock") Then
            Dim address = e.Parameter.Split("|")(1)
            UpdateContact(OwnerContact.ContactStatus.DoorKnock, address, OwnerContact.OwnerContactType.MailAddress)
        End If

        If e.Parameter.StartsWith("UndoAddress") Then
            Dim address = e.Parameter.Split("|")(1)
            UpdateContact(OwnerContact.ContactStatus.Undo, address, OwnerContact.OwnerContactType.MailAddress)
        End If


        e.Result = needRefesh
    End Sub

    Sub UpdateContact(status As OwnerContact.ContactStatus, phoneNo As String, type As OwnerContact.OwnerContactType)
        OwnerContact.UpdateContact(hfBBLE.Value, status, phoneNo, type)
        Return

        'Using Context As New Entities

        '    Dim contact = Context.OwnerContacts.Where(Function(c) c.BBLE = hfBBLE.Value And c.Contact.Contains(phoneNo)).FirstOrDefault


        '    'Remove the saved info. 
        '    If status = OwnerContact.ContactStatus.Undo Then
        '        If contact IsNot Nothing Then
        '            Context.OwnerContacts.Remove(contact)
        '            Context.SaveChanges()
        '        End If

        '        Return
        '    End If

        '    If contact Is Nothing Then
        '        contact = New OwnerContact
        '        contact.BBLE = hfBBLE.Value
        '        contact.Contact = phoneNo
        '        contact.ContactType = type
        '        contact.Status = status
        '        'contact.OwnerName = home
        '        Context.OwnerContacts.Add(contact)
        '    Else
        '        contact.BBLE = hfBBLE.Value
        '        contact.Contact = phoneNo
        '        contact.ContactType = type
        '        contact.Status = status
        '    End If

        '    Context.SaveChanges()

        'End Using
    End Sub

    Protected Sub ASPxCallbackPanel2_Callback(sender As Object, e As DevExpress.Web.CallbackEventArgsBase)
        Dim bble = ""
        Try
            'Dim start = DateTime.Now
            'Debug.WriteLine("Callpanel start:" & DateTime.Now.ToString("MM/dd/yyyy hh:mm:ss.fff tt"))
            If e.Parameter.StartsWith("Refresh") Then
                Dim params = e.Parameter.Split("|")
                bble = params(1)

                If bble = "null" Then
                    bble = hfBBLE.Value
                End If

                If params.Length = 3 Then
                    Dim type = params(2)

                    RefreshBBLE(bble, type)

                End If
            Else
                bble = e.Parameter
            End If

            contentSplitter.ClientVisible = True
            BindData(bble)

            If CategoryName = "Door Knock" Then
                doorKnockMapPanel.Visible = True
                contentSplitter.ClientVisible = False
            Else
                doorKnockMapPanel.Visible = False
            End If

        Catch ex As Exception
            Throw New CallbackException(ex.Message, ex)
        End Try

        Return
    End Sub

    Sub RefreshBBLE(bble As String, type As String)
        Dim comments = ""
        Dim username = HttpContext.Current.User.Identity.Name
        Select Case type
            Case "All"
                comments = String.Format("All leads info is refreshed by {0}", username)
                DataWCFService.UpdateLeadInfo(bble, True)
            'Core.DataLoopRule.AddRules(bble, Core.DataLoopRule.DataLoopType.All, HttpContext.Current.User.Identity.Name)vi

            Case "Assessment"
                comments = String.Format("General property info is refreshed by {0}", username)
                DataWCFService.UpdateAssessInfo(bble)
            Case "PropData"
                comments = String.Format("Mortgage and Violations is refreshed by {0}", username)
                'Core.DataLoopRule.AddRules(bble, Core.DataLoopRule.DataLoopType.Mortgage, HttpContext.Current.User.Identity.Name)
                DataWCFService.UpdateLeadInfo(bble, False, True, True, True, True, True, False)
            Case "TLO"
                comments = String.Format("Home Owner info is refreshed by {0}", username)
                'Core.DataLoopRule.AddRules(bble, Core.DataLoopRule.DataLoopType.HomeOwner, HttpContext.Current.User.Identity.Name)
                If Not DataWCFService.UpdateLeadInfo(bble, False, False, False, False, False, False, True) Then
                    Throw New Exception("This Lead didn't have owner info in our database.")
                End If
            Case "ZEstimate"
                comments = String.Format("ZEstimate info is refreshed by {0}", username)
                If Not DataWCFService.GetZillowValue(bble) Then
                    Throw New Exception("The ZEstimate info failed refreshing.")
                End If
            Case "JudgmentSearch"
                comments = String.Format("Judgement Search info is refreshed by {0}", username)
                IntranetPortal.Data.LeadsEcourtData.Update(bble, username)
        End Select

        LeadsActivityLog.AddActivityLog(DateTime.Now, comments, bble, LeadsActivityLog.LogCategory.Status.ToString, LeadsActivityLog.EnumActionType.RefreshLeads)
    End Sub

    Protected Sub SaveBestEmail(bble As String, ownerName As String, email As String)
        Using Context As New Entities
            Dim e = Context.HomeOwnerEmails.Where(Function(eh) eh.BBLE = bble And eh.OwnerName = ownerName And eh.Email = email).SingleOrDefault

            If e Is Nothing Then
                e = New HomeOwnerEmail
                e.BBLE = bble
                e.OwnerName = ownerName
                e.Email = email
                e.Source = PhoneSource.UserAdded
                Context.HomeOwnerEmails.Add(e)
                Context.SaveChanges()
            Else
                Throw New CallbackException("This email already exist.")
            End If
        End Using
    End Sub
    Protected Sub DelteEmail(bble As String, email As String, ownerName As String)
        Using Context As New Entities
            Dim mEmail = Context.HomeOwnerEmails.Where(Function(e) e.BBLE = bble And e.Email = email And e.OwnerName = ownerName).ToList
            Context.HomeOwnerEmails.RemoveRange(mEmail)
            Context.SaveChanges()
        End Using

    End Sub
    Protected Sub ownerInfoCallbackPanel_Callback(sender As Object, e As DevExpress.Web.CallbackEventArgsBase)
        Dim bble = hfBBLE.Value

        If Not String.IsNullOrEmpty(e.Parameter) Then
            If (e.Parameter.StartsWith("SaveEmail")) Then
                Dim paramters = e.Parameter.Split("|")
                SaveBestEmail(bble, paramters(2), paramters(1))
            ElseIf (e.Parameter.StartsWith("DeleteEmail")) Then
                Dim paramters = e.Parameter.Split("|")
                DelteEmail(bble, paramters(1), paramters(2))
            ElseIf e.Parameter.StartsWith("Refresh") Then
                Dim params = e.Parameter.Split("|")
                bble = params(1)

                If bble = "null" Then
                    bble = hfBBLE.Value
                End If

                If params.Length = 3 Then
                    Dim type = params(2)
                    Dim comments = String.Format("Home Owner info is refreshed by {0}", HttpContext.Current.User.Identity.Name)
                    If Not DataWCFService.UpdateLeadInfo(bble, False, False, False, False, False, False, True) Then
                        Throw New CallbackException("This Lead didn't have owner info in our database.")
                    End If
                    LeadsActivityLog.AddActivityLog(DateTime.Now, comments, bble, LeadsActivityLog.LogCategory.SalesAgent.ToString, LeadsActivityLog.EnumActionType.RefreshLeads)
                End If
            Else
                Dim phoneNo = e.Parameter.Split("|")(0)
                Dim ownerName = e.Parameter.Split("|")(1)

                Using context As New Entities
                    Dim p = context.HomeOwnerPhones.Where(Function(ph) ph.BBLE = bble And ph.OwnerName = ownerName And ph.Phone = phoneNo).FirstOrDefault

                    If p Is Nothing Then
                        p = New HomeOwnerPhone
                        p.BBLE = bble
                        p.OwnerName = ownerName
                        p.Phone = phoneNo
                        p.Source = PhoneSource.UserAdded

                        context.HomeOwnerPhones.Add(p)
                        context.SaveChanges()
                    Else
                        Throw New CallbackException("This Phone# already exist.")
                    End If
                End Using
            End If

        End If

        Using context As New Entities
            Dim li = context.LeadsInfoes.Where(Function(ld) ld.BBLE = bble).SingleOrDefault
            HomeOwnerInfo2.BBLE = bble
            HomeOwnerInfo2.OwnerName = li.Owner
            'HomeOwnerInfo2.Owner = context.HomeOwnerDatas.Where(Function(owner) owner.BBLE = bble And owner.Active = True And owner.OriginalSearchedName = li.Owner).FirstOrDefault
            HomeOwnerInfo2.BindData(bble)


            HomeOwnerInfo3.BBLE = bble
            HomeOwnerInfo3.OwnerName = CoOwnerName(li.CoOwner, li.Owner, bble)
            'HomeOwnerInfo3.Owner = context.HomeOwnerDatas.Where(Function(owner) owner.BBLE = bble And owner.Active = True And owner.OriginalSearchedName = li.CoOwner).SingleOrDefault
            HomeOwnerInfo3.BindData(bble)

        End Using
    End Sub

    Protected Sub ASPxPopupControl1_WindowCallback(source As Object, e As DevExpress.Web.PopupWindowCallbackArgs)
        popupContentAddAddress.Visible = True

        If e.Parameter.StartsWith("Save") Then
            Dim bble = hfBBLE.Value
            Dim ownerName = e.Parameter.Split("|")(1)
            Dim address = txtUserAddress.Text

            Using context As New Entities
                Dim p = context.HomeOwnerAddresses.Where(Function(ph) ph.BBLE = bble And ph.OwnerName = ownerName And ph.Address = address).SingleOrDefault

                If p Is Nothing Then
                    p = New HomeOwnerAddress
                    p.BBLE = bble
                    p.OwnerName = ownerName
                    p.Address = address
                    p.Description = txtAdrDes.Text
                    p.Source = AddressSource.UserAdded

                    context.HomeOwnerAddresses.Add(p)
                    context.SaveChanges()

                    txtUserAddress.Text = ""
                    txtAdrDes.Text = ""
                Else
                    Throw New CallbackException("This address already exist.")
                End If
            End Using
        End If
    End Sub


    Protected Sub pcMain_WindowCallback(source As Object, e As DevExpress.Web.PopupWindowCallbackArgs)
        If Not pcMainPopupControl.Visible Then
            pcMainPopupControl.Visible = True
        End If
    End Sub

    Protected Sub ReportNoHomeCallBack_OnCallback(source As Object, e As CallbackEventArgs)
        Dim BBLE = e.Parameter
        Dim em = Employee.GetInstance(Page.User.Identity.Name)
        Dim Eamil = ""
        If (em.Email IsNot Nothing) Then
            Eamil = ";" & em.Email
        End If
        Dim Chris = Employee.GetInstance("Chris Yan")
        Dim Steven = Employee.GetInstance("Steven Wu")
        If (Chris IsNot Nothing AndAlso Steven IsNot Nothing) Then
            EmailService.SendMail(Chris.Email, Steven.Email & Eamil, "Leads " & BBLE & " Can not get homeower info", "Hi Chris,  Leads " & BBLE & " does not have homeower info after refersh please check !" & " Submmit by " + Page.User.Identity.Name, Nothing)
            Throw New CallbackException("Submit succeed !")
        End If

        Throw New CallbackException("Submit failed !")
    End Sub
End Class