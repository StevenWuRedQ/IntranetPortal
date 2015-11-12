Imports System.ComponentModel

''' <summary>
''' Represents the lead data, inclued employee, status, etc.
''' </summary>
Partial Public Class Lead

    Public Enum LeadProcess
        Agent = 0
        Publishing = 1
        Published = 2
    End Enum

    Public ReadOnly Property FormatLeadsname As String
        Get
            Dim leadsname = String.Format("<span style='color:red'>{0} {1}</span> - {2}", LeadsInfo.Number, LeadsInfo.StreetName, LeadsInfo.Owner)
            Return leadsname
        End Get
    End Property

    Public Shared Function GetInstance(bble As String) As Lead
        Dim context As New Entities

        Return context.Leads.Where(Function(l) l.BBLE = bble).SingleOrDefault
    End Function

    Public ReadOnly Property LastUpdate2 As DateTime
        Get
            Dim log = LeadsActivityLogs.OrderByDescending(Function(lg) lg.ActivityDate).FirstOrDefault
            If log IsNot Nothing Then
                Return log.ActivityDate
            End If

            If LastUpdate.HasValue Then
                Return LastUpdate
            Else
                Return AssignDate
            End If
        End Get
    End Property

    Public ReadOnly Property LatestAppointmentDate As DateTime
        Get
            Dim appt = UserAppointment.GetLatestUserAppointment(BBLE)

            If appt IsNot Nothing Then
                Return appt.ScheduleDate
            End If

            Return DateTime.MinValue
        End Get
    End Property

    Public ReadOnly Property LastOwnerUpdate As DateTime
        Get
            Dim log = LeadsActivityLogs.Where(Function(l) l.EmployeeName.ToLower = EmployeeName.ToLower).OrderByDescending(Function(lg) lg.ActivityDate).FirstOrDefault
            If log IsNot Nothing Then
                Return log.ActivityDate
            End If

            Return AssignDate
        End Get
    End Property

    Public ReadOnly Property LastUserUpdate As DateTime
        Get
            Dim log = LeadsActivityLogs.Where(Function(l) l.EmployeeID <> Nothing).OrderByDescending(Function(lg) lg.ActivityDate).FirstOrDefault
            If log IsNot Nothing Then
                Return log.ActivityDate
            End If

            Return AssignDate
        End Get
    End Property

    Public Shared Function GetRecycledLeads(name As String, recycled As String, startDate As String) As List(Of Lead)
        Using ctx As New Entities
            Dim comments = String.Format("Leads Reassign from {0} to {1}.", name, recycled)
            Dim bbles = ctx.LeadsActivityLogs.Where(Function(l) l.EmployeeName = "Portal" And l.Comments = comments And l.ActivityDate > startDate).Select(Function(b) b.BBLE).Distinct.ToArray

            Return ctx.Leads.Where(Function(ld) bbles.Contains(ld.BBLE) And ld.EmployeeName = recycled).ToList
        End Using
    End Function

    Public ReadOnly Property ReferrelName As String
        Get
            Return Me.LeadsInfo.ReferrelName
        End Get
    End Property

    Private _viewable As Boolean? = Nothing
    Public ReadOnly Property Viewable As Boolean
        Get
            If _viewable.HasValue Then
                Return _viewable.Value
            End If

            If HttpContext.Current IsNot Nothing Then
                _viewable = IsViewable(HttpContext.Current.User.Identity.Name)
                Return _viewable
            End If

            _viewable = False
            Return _viewable
        End Get
    End Property

    Public Property ThirdPartyCategory As String

    Public Shared Function HasArchieved(bble As String) As Boolean
        Using ctx As New Entities
            Return ctx.LeadsActivityLogArchiveds.Any(Function(l) l.BBLE = bble)
        End Using
    End Function

    Friend Function IsViewable(name As String) As Boolean
        If Status = LeadStatus.DeadEnd Or EmployeeName = "Dead Leads" Then
            Return True
        End If

        Dim roleNames = Core.PortalSettings.GetValue("LeadsViewableRoles").Split(";")

        Dim myRoles = Roles.GetRolesForUser(name)

        If myRoles.Any(Function(r) roleNames.Contains(r)) Then
            Return True
        End If

        Dim owner = EmployeeName

        If owner = name Then
            If Status <> LeadStatus.MgrApproval And Status <> LeadStatus.MgrApprovalInWf Then
                Return True
            Else
                Return False
            End If
        End If

        If IntranetPortal.Employee.GetManagedEmployees(name).Contains(owner) Then
            Return True
        End If

        For Each rl In Roles.GetRolesForUser(name)
            If rl.StartsWith("OfficeManager") Then
                Dim dept = rl.Split("-")(1)

                If IntranetPortal.Employee.GetDeptUsers(dept).Contains(owner) Then
                    Return True
                End If

                If owner.Contains(dept & " Office") Then
                    Return True
                End If
            End If
        Next

        If SharedUsers.Contains(name) Then
            Return True
        End If

        Return False
    End Function

    Public Shared Function CreateLeads(bble As String, status As LeadStatus, createBy As String) As Lead

        Using ctx As New Entities

            Dim li As LeadsInfo

            If ctx.LeadsInfoes.Any(Function(l) l.BBLE = bble) Then
                li = LeadsInfo.GetInstance(bble)
            Else
                li = DataWCFService.UpdateAssessInfo(bble)
            End If

            Dim emp = Employee.GetInstance(createBy)

            Dim ld As Lead
            If ctx.Leads.Any(Function(l) l.BBLE = bble) Then
                ld = ctx.Leads.Find(bble)
            Else
                ld = New Lead
                ctx.Leads.Add(ld)
            End If

            ld.BBLE = bble
            ld.LeadsName = If(li Is Nothing, "", li.LeadsName)
            ld.EmployeeID = Employee.GetInstance(createBy).EmployeeID
            ld.EmployeeName = createBy
            ld.Neighborhood = li.NeighName
            ld.AssignDate = DateTime.Now
            ld.AssignBy = createBy
            ld.Status = status
            ld.AppId = emp.AppId

            ctx.SaveChanges()

            Return ld
        End Using
    End Function


    'Get user data by status
    Public Shared Function GetUserLeadsData(name As String, status As LeadStatus) As List(Of Lead)
        Return GetUserLeadsData({name}, status)
    End Function

    Public Shared Function GetUserLeadsData(names As String(), status As LeadStatus) As List(Of Lead)
        Return GetUserLeadsData(names, {status})
    End Function

    Public Shared Function GetUserLeadsData(names As String(), status As LeadStatus()) As List(Of Lead)
        Dim context As New Entities

        Dim result = From ld In context.Leads.Where(Function(ld) status.Contains(ld.Status) And names.Contains(ld.EmployeeName))
                     Order By ld.LastUpdate Descending
                     Select ld

        Return result.ToList
    End Function

    Public Shared Function GetPublicSiteLeads(names As String()) As List(Of Lead)
        Dim ctx As New Entities
        Dim processes = {LeadProcess.Published, LeadProcess.Publishing}
        Dim result = From ld In ctx.Leads.Where(Function(l) names.Contains(l.EmployeeName) AndAlso processes.Contains(l.Process))
                     Order By ld.LastUpdate Descending
                     Select ld

        Return result.ToList
    End Function

    Public Shared Sub InThirdParty(bble As String, category As String, thirdParty As String, createby As String)
        Using ctx As New Entities

            Dim ldt = ctx.LeadsInThirdParties.Find(bble, category)

            If ldt Is Nothing Then
                ldt = New LeadsInThirdParty
                ldt.CreateBy = createby
                ldt.CreateDate = DateTime.Now
                ctx.LeadsInThirdParties.Add(ldt)
            End If

            ldt.BBLE = bble
            ldt.Category = category
            ldt.ThirdParty = thirdParty

            ctx.SaveChanges()
        End Using
    End Sub

    Public Shared Function Get3rdPartyLeads(names As String()) As List(Of Lead)
        Using ctx As New Entities
            Dim result = (From ld In ctx.Leads.Where(Function(l) names.Contains(l.EmployeeName) AndAlso l.Status = LeadStatus.InProcess)
                          Join tp In ctx.LeadsInThirdParties On ld.BBLE Equals tp.BBLE
                          Select ld, tp.Category).ToList.Select(Function(item)
                                                                    item.ld.ThirdPartyCategory = item.Category
                                                                    Return item.ld
                                                                End Function).ToList

            Return result
        End Using
    End Function

    Public Shared Sub Publishing(bble As String)
        Using ctx As New Entities
            Dim ld = ctx.Leads.Find(bble)

            If ld IsNot Nothing Then
                ld.Process = LeadProcess.Publishing
                ctx.SaveChanges()
                Try
                    InitPublicData(bble)
                Catch ex As Exception
                    Throw New Exception("Unable to Publishing Now.")
                End Try
            End If
        End Using
    End Sub

    Public Shared Sub Published(bble As String, publicBy As String)
        Using ctx As New Entities
            Dim ld = ctx.Leads.Find(bble)

            If ld IsNot Nothing Then
                ld.Process = LeadProcess.Published
                ctx.SaveChanges()

                Try
                    Dim prop = PublicSiteData.ListProperty.GetProperty(bble)
                    prop.Published(publicBy)
                Catch ex As Exception
                    Throw New Exception("Exception in Published. Exception: " & ex.Message)
                End Try
            End If
        End Using
    End Sub

    Public Shared Function InitPublicData(bble As String) As PublicSiteData.ListProperty
        Dim ld = LeadsInfo.GetInstance(bble)

        Dim listProp As New PublicSiteData.ListProperty
        listProp.BBLE = bble
        listProp.Block = ld.Block
        listProp.Lot = ld.Lot
        listProp.PropertyClass = ld.PropertyClass
        listProp.AptNo = ld.UnitNum
        listProp.Number = ld.Number
        listProp.StreetName = ld.StreetName
        listProp.NeighName = ld.NeighName
        listProp.State = ld.State
        listProp.Zipcode = ld.ZipCode
        listProp.Borough = ld.Borough
        listProp.Agent = Lead.GetInstance(bble).EmployeeName

        'geo info
        listProp.Latitude = ld.Latitude
        listProp.Longitude = ld.Longitude

        Return listProp.Create()
    End Function

    Public Shared Function UpdateLeadStatus(bble As String, status As LeadStatus, callbackDate As DateTime, Optional addCommend As String = Nothing) As Boolean
        Using Context As New Entities
            Dim lead = Context.Leads.Where(Function(l) l.BBLE = bble).FirstOrDefault
            Dim addComStr = If(String.IsNullOrEmpty(addCommend), "", "<br/>" & " Comments: " & addCommend)
            If lead IsNot Nothing Then
                Dim originateStatus = lead.Status
                lead.Status = status
                If Not callbackDate = Nothing Then
                    lead.CallbackDate = callbackDate
                End If

                Context.SaveChanges()

                If Not originateStatus = status Then
                    Dim empId = CInt(Membership.GetUser(HttpContext.Current.User.Identity.Name).ProviderUserKey)
                    Dim empName = HttpContext.Current.User.Identity.Name

                    Dim comments = String.Format("Change status from {0} to {1}. {2}", CType(originateStatus, LeadStatus).ToString, status.ToString, addComStr)
                    If status = LeadStatus.DoorKnocks Then
                        LeadsActivityLog.AddActivityLog(DateTime.Now, comments, bble, LeadsActivityLog.LogCategory.SalesAgent.ToString, empId, empName, LeadsActivityLog.EnumActionType.DoorKnock)
                    Else
                        Dim action = LeadsActivityLog.EnumActionType.DefaultAction
                        If status = LeadStatus.Callback Then
                            comments = "Lead Status changed to Follow Up on " & callbackDate.ToString("MM/dd/yyyy") & addComStr
                            action = LeadsActivityLog.EnumActionType.FollowUp
                        End If

                        If status = LeadStatus.Priority Then
                            action = LeadsActivityLog.EnumActionType.HotLeads
                        End If

                        If status = LeadStatus.InProcess Then
                            action = LeadsActivityLog.EnumActionType.InProcess

                            'In Process Log
                            LeadsStatusLog.AddNew(bble, LeadsStatusLog.LogType.InProcess, lead.EmployeeName, empName, Nothing)
                        End If

                        If status = LeadStatus.Closed Then
                            LeadsStatusLog.AddNew(bble, LeadsStatusLog.LogType.Closed, lead.EmployeeName, empName, Nothing)
                        End If

                        'If status = LeadStatus.DeadEnd Then
                        '    action = LeadsActivityLog.EnumActionType.DeadLead
                        '    LeadsStatusLog.AddNew(bble, LeadsStatusLog.LogType.DeadLeads, lead.EmployeeName, empName)
                        'End If

                        LeadsActivityLog.AddActivityLog(DateTime.Now, comments, bble, LeadsActivityLog.LogCategory.SalesAgent.ToString, empId, empName, action)
                    End If
                Else
                    Dim empId = CInt(Membership.GetUser(HttpContext.Current.User.Identity.Name).ProviderUserKey)
                    Dim empName = HttpContext.Current.User.Identity.Name
                    If status = LeadStatus.Callback Then
                        Dim comments = "Lead Status changed to Follow Up on " & callbackDate.ToString("MM/dd/yyyy") & addComStr
                        LeadsActivityLog.AddActivityLog(DateTime.Now, comments, bble, LeadsActivityLog.LogCategory.SalesAgent.ToString, empId, empName, LeadsActivityLog.EnumActionType.FollowUp)
                    End If
                End If

                'copy to user task list
                If status = LeadStatus.Callback Or status = LeadStatus.Priority Then
                    'UserTask.AddUserTask(bble, empName, comments)
                End If
            End If
        End Using
    End Function

    Public Shared Function GetUserTodayFollowUps(userName As String) As List(Of Lead)
        Using ctx As New Entities
            Return ctx.Leads.Where(Function(ld) ld.Status = LeadStatus.Callback And ld.EmployeeName = userName).ToList.Where(Function(ld) ld.CallbackDate < DateTime.Today.AddDays(1)).ToList
        End Using
    End Function

    Public Shared Function SetDeadLeadsStatus(bble As String, reason As Integer, description As String) As Boolean
        Using Context As New Entities
            Dim lead = Context.Leads.Where(Function(l) l.BBLE = bble).FirstOrDefault

            If lead IsNot Nothing Then
                Dim originateStatus = lead.Status
                lead.Status = LeadStatus.DeadEnd
                lead.DeadReason = reason
                lead.Description = description

                Context.SaveChanges()

                'Dead End
                LeadsStatusLog.AddNew(bble, LeadsStatusLog.LogType.DeadLeads, lead.EmployeeName, HttpContext.Current.User.Identity.Name, Nothing)

                'Expired user Task
                WorkflowService.ExpireTaskProcess(bble)
                UserTask.ExpiredTasks(bble, lead.EmployeeName)

                If Not originateStatus = LeadStatus.DeadEnd Then
                    Dim empId = CInt(Membership.GetUser(HttpContext.Current.User.Identity.Name).ProviderUserKey)
                    Dim empName = HttpContext.Current.User.Identity.Name
                    Dim comments = String.Format("Change status from {0} to {1}.", CType(originateStatus, LeadStatus).ToString, LeadStatus.DeadEnd.ToString)
                    LeadsActivityLog.AddActivityLog(DateTime.Now, comments, bble, LeadsActivityLog.LogCategory.SalesAgent.ToString, empId, empName, LeadsActivityLog.EnumActionType.DeadLead)
                End If
            End If
        End Using
    End Function

    Public Shared Function GetAllActiveLeads() As List(Of Lead)
        Dim ctx As New Entities
        Dim emps = Employee.GetAllActiveEmps()

        Dim results = (From ld In ctx.Leads
                       Where emps.Contains(ld.EmployeeName) And (ld.Status <> LeadStatus.DeadEnd And ld.Status <> LeadStatus.InProcess)
                       Select ld).ToList
        Return results
    End Function

    Public Shared Function GetAllDeadLeads() As List(Of Lead)
        Dim ctx As New Entities
        Dim results = (From ld In ctx.Leads Where ld.Status = LeadStatus.DeadEnd).ToList
        Return results
    End Function

    Public Shared Sub ArchivedLogs(bble As String)

        If LeadsInfo.IsInProcess(bble) Then
            Return
        End If

        If ShortSaleManage.IsInShortSale(bble) Then
            Return
        End If

        If LegalCaseManage.IsInLegal(bble) Then
            Return
        End If

        Using ctx As New Entities
            Dim logs = ctx.LeadsActivityLogs.Where(Function(log) log.BBLE = bble).ToList

            Dim archivedLogs As New List(Of LeadsActivityLogArchived)

            For Each log In logs
                Dim tmp = New LeadsActivityLogArchived
                tmp = Core.Utility.CopyTo(log, tmp)
                archivedLogs.Add(tmp)
            Next

            ctx.LeadsActivityLogArchiveds.AddRange(archivedLogs)
            ctx.LeadsActivityLogs.RemoveRange(logs)
            ctx.SaveChanges()
        End Using
    End Sub

    Public Shared Sub BatchAssignLeads(bbles As String(), name As String, empId As Integer, assignBy As String, Optional archiveLogs As Boolean = False)
        Using Context As New Entities
            For Each item In bbles
                If archiveLogs Then
                    ArchivedLogs(item)
                End If

                Dim li = Context.LeadsInfoes.Find(item)
                Dim emp = Employee.GetInstance(empId)
                If li IsNot Nothing Then
                    Dim newlead = Context.Leads.Find(item)
                    Dim orgName = Nothing
                    If newlead Is Nothing Then
                        newlead = New Lead() With {
                                          .BBLE = li.BBLE,
                                          .LeadsName = li.LeadsName,
                                          .Neighborhood = li.NeighName,
                                          .EmployeeID = empId,
                                          .EmployeeName = name,
                                          .AppId = emp.AppId,
                                          .Status = LeadStatus.NewLead,
                                          .AssignDate = DateTime.Now,
                                          .AssignBy = assignBy
                                          }
                        Context.Leads.Add(newlead)

                        Dim comments = String.Format("Leads assign to  {0}", name)
                        LeadsActivityLog.AddActivityLogEntity(DateTime.Now, comments, item, LeadsActivityLog.LogCategory.Status.ToString, Nothing, assignBy, LeadsActivityLog.EnumActionType.Reassign, Context)
                    Else
                        orgName = newlead.EmployeeName
                        newlead.LeadsName = li.LeadsName
                        newlead.Neighborhood = li.NeighName
                        newlead.EmployeeID = empId
                        newlead.EmployeeName = name
                        newlead.AppId = emp.AppId
                        newlead.Status = LeadStatus.NewLead
                        newlead.AssignDate = DateTime.Now
                        newlead.AssignBy = assignBy

                        Dim comments = String.Format("Leads assign from {0} to  {1}", orgName, name)
                        LeadsActivityLog.AddActivityLogEntity(DateTime.Now, comments, item, LeadsActivityLog.LogCategory.Status.ToString, Nothing, assignBy, LeadsActivityLog.EnumActionType.Reassign, Context)
                    End If

                    'LeadsActivityLog.AddActivityLogEntity(DateTime.Now, "", item, LeadsActivityLog.LogCategory.Status.ToString, Nothing, assignBy, LeadsActivityLog.EnumActionType.Reassign, Context)
                    LeadsStatusLog.AddNewEntity(item, LeadsStatusLog.LogType.NewLeads, name, assignBy, orgName, Context)
                End If
            Next
            If Context.GetValidationErrors().Count > 0 Then
                Throw New Exception("Exception Occured in Assign: " & Context.GetValidationErrors()(0).ValidationErrors(0).ErrorMessage)
            Else
                Context.SaveChanges()
            End If
        End Using
    End Sub

    Public ReadOnly Property SharedUsers As List(Of String)
        Get
            Using ctx As New Entities
                Return ctx.SharedLeads.Where(Function(s) s.BBLE = BBLE).Select(Function(s) s.UserName).ToList
            End Using
        End Get
    End Property

    Public Sub UpdateAssignDate()
        Using ctx As New Entities
            Dim ld = ctx.Leads.Find(BBLE)
            ld.Status = LeadStatus.NewLead
            ld.AssignDate = DateTime.Now
            ld.LastUpdate = DateTime.Now
            ld.UpdateBy = "Portal"
            ctx.SaveChanges()

            Dim comments = String.Format("New Leads need to review within 5 days. Otherwise, the leads will be recycled.")
            LeadsActivityLog.AddActivityLog(DateTime.Now, comments, BBLE, LeadsActivityLog.LogCategory.Status.ToString, LeadsActivityLog.EnumActionType.Reassign)
        End Using
    End Sub

    Public Sub UpdateCallbackDate(dt As DateTime)
        Using ctx As New Entities
            Dim ld = ctx.Leads.Find(BBLE)
            ld.CallbackDate = dt
            ld.LastUpdate = DateTime.Now
            ld.UpdateBy = "Portal"
            ctx.SaveChanges()

            Dim comments = String.Format("Callback date is update to {0}", dt.ToString("MM/dd/yyyy"))
            LeadsActivityLog.AddActivityLog(DateTime.Now, comments, BBLE, LeadsActivityLog.LogCategory.Status.ToString, LeadsActivityLog.EnumActionType.FollowUp)
        End Using
    End Sub

    Public Sub ReAssignLeads(empName As String, Optional assignBy As String = "Portal", Optional archieve As Boolean = False)
        If String.Equals(EmployeeName, empName, StringComparison.CurrentCultureIgnoreCase) Then
            Return
        End If

        Dim emp = IntranetPortal.Employee.GetInstance(empName)

        If emp IsNot Nothing Then
            Dim originator = EmployeeName

            If archieve Then
                ArchivedLogs(BBLE)
            End If

            Using ctx As New Entities
                Dim ld = ctx.Leads.Find(BBLE)
                ld.EmployeeID = emp.EmployeeID
                ld.EmployeeName = emp.Name
                ld.Status = LeadStatus.NewLead
                ld.AssignDate = DateTime.Now
                ld.LastUpdate = DateTime.Now

                If HttpContext.Current Is Nothing Then
                    ld.AssignBy = assignBy
                Else
                    ld.AssignBy = HttpContext.Current.User.Identity.Name
                End If

                ctx.SaveChanges()

                'log the status
                LeadsStatusLog.AddNew(BBLE, LeadsStatusLog.LogType.NewLeads, emp.Name, ld.AssignBy, EmployeeName)

                'Expired the task on this bble
                WorkflowService.ExpiredLeadsProcess(BBLE)
                UserTask.ExpiredTasks(BBLE, originator)
                UserAppointment.ExpiredAppointmentByBBLE(BBLE)

                Dim comments = String.Format("Leads Reassign from {0} to {1}.", originator, empName)
                LeadsActivityLog.AddActivityLog(DateTime.Now, comments, BBLE, LeadsActivityLog.LogCategory.Status.ToString, LeadsActivityLog.EnumActionType.Reassign)

            End Using
        End If
    End Sub

    Public Sub StartRecycleProcess()
        If Not InRecycle Then
            Dim comments = "This Lead will be recycled today."
            Dim log = LeadsActivityLog.AddActivityLog(DateTime.Now, comments, BBLE, LeadsActivityLog.LogCategory.RecycleTask.ToString, Nothing, "Portal", LeadsActivityLog.EnumActionType.SetAsTask)
            Dim rLead = Core.RecycleLead.AddRecycle(BBLE, DateTime.Now, log.LogID)

            Dim emps = IntranetPortal.Employee.GetEmpOfficeManagers(EmployeeName)

            If emps Is Nothing Then
                emps = New String() {Employee.Manager}
            End If

            WorkflowService.StartTaskProcess("RecycleProcess", LeadsName, rLead.RecycleId, BBLE, String.Join(";", emps), "Normal")
        End If
    End Sub

    Public ReadOnly Property InRecycle As Boolean
        Get
            Return Core.RecycleLead.InRecycle(BBLE)
        End Get
    End Property
    Public Shared Function InSystem(BBLE As String) As Boolean
        Using ctx As New Entities
            If (ctx.Leads.Find(BBLE) IsNot Nothing) Then
                Return True
            End If
            If (ctx.PendingAssignLeads.Find(BBLE) IsNot Nothing) Then
                Return True
            End If
        End Using
        Return False
    End Function
    Public Sub Recycle(Optional recycleBy As String = "")
        Dim recylceName = IntranetPortal.Employee.GetOfficeAssignAccount(EmployeeName)
        If String.IsNullOrEmpty(recycleBy) Then
            ReAssignLeads(recylceName)
        Else
            ReAssignLeads(recylceName, recycleBy)
        End If

        LeadsStatusLog.AddNew(BBLE, LeadsStatusLog.LogType.Recycled, EmployeeName, recycleBy, Nothing)
        Return

        'Dim recycleName = Employee.Department & " office"
        'If IntranetPortal.Employee.GetInstance(recycleName) IsNot Nothing Then
        '    ReAssignLeads(recycleName)
        '    Return
        'End If

        'Using ctx As New Entities
        '    Dim team = (From t In ctx.Teams
        '               Join ut In ctx.UserInTeams On t.TeamId Equals ut.TeamId
        '               Where ut.EmployeeName = EmployeeName
        '               Select t.Name).FirstOrDefault

        '    If team IsNot Nothing Then
        '        recycleName = team & " office"

        '        If IntranetPortal.Employee.GetInstance(recycleName) IsNot Nothing Then
        '            ReAssignLeads(recycleName)
        '            Return
        '        End If
        '    End If
        'End Using

        'UserMessage.AddNewMessage("Recycle Message", "Failed Recycle Leads: " & BBLE, String.Format("Failed Recycle Leads BBLE: {0}, Employee name:{1}. ", BBLE, EmployeeName), BBLE, DateTime.Now, "Recycle")
    End Sub

    Public ReadOnly Property Task As UserTask
        Get
            Using ctx As New Entities
                Return ctx.UserTasks.Where(Function(t) t.BBLE = BBLE And t.Status = UserTask.TaskStatus.Active).Take(0).FirstOrDefault
            End Using
        End Get
    End Property

    Public ReadOnly Property Appointment As UserAppointment
        Get
            Using ctx As New Entities
                Return ctx.UserAppointments.Where(Function(t) t.BBLE = BBLE And (t.Status = UserAppointment.AppointmentStatus.NewAppointment)).Take(0).FirstOrDefault
            End Using
        End Get
    End Property


    Enum DeadReasonEnum
        <Description("Deed Recorded with Other Party")>
        DeadRecord = 1
        <Description("Working towards a Loan MOD")>
        LoanMod = 2
        <Description("Working towards a short sale with another company")>
        ShortSaleWithOther = 3
        <Description("MOD Completed")>
        ModCompleted = 4
        <Description("Not Interested")>
        NotInterested = 5
        <Description("Unable to contact")>
        UnableToContact = 6
        <Description("Manager disapproved")>
        MgrDisapproved = 7
    End Enum
End Class
