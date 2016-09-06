﻿Imports System.ComponentModel
Imports System.ComponentModel.DataAnnotations
Imports Newtonsoft.Json

''' <summary>
''' Represents the lead data, inclued employee, status, etc.
''' </summary>
Partial Public Class Lead

    Public Enum LeadProcess
        Agent = 0
        Publishing = 1
        Published = 2
    End Enum

    <JsonIgnoreAttribute>
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

    <JsonIgnoreAttribute>
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

    <JsonIgnoreAttribute>
    Public ReadOnly Property LatestAppointmentDate As DateTime
        Get
            Dim appt = UserAppointment.GetLatestUserAppointment(BBLE)

            If appt IsNot Nothing Then
                Return appt.ScheduleDate
            End If

            Return DateTime.MinValue
        End Get
    End Property

    Public ReadOnly Property SubStatusStr As String
        Get
            If SubStatus.HasValue Then
                Return CType(SubStatus, LeadSubStatus).ToString
            End If

            Return ""
        End Get
    End Property

    <JsonIgnoreAttribute>
    Public ReadOnly Property LastOwnerUpdate As DateTime
        Get
            Dim log = LeadsActivityLogs.Where(Function(l) l.EmployeeName.ToLower = EmployeeName.ToLower).OrderByDescending(Function(lg) lg.ActivityDate).FirstOrDefault
            If log IsNot Nothing Then
                Return log.ActivityDate
            End If

            Return AssignDate
        End Get
    End Property

    <JsonIgnoreAttribute>
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

    <JsonIgnoreAttribute>
    Public ReadOnly Property ReferrelName As String
        Get
            Return Me.LeadsInfo.ReferrelName
        End Get
    End Property

    Private _viewable As Boolean? = Nothing
    <JsonIgnoreAttribute>
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

    <JsonIgnoreAttribute>
    Public Property ThirdPartyCategory As String

    Public Shared Function HasArchieved(bble As String) As Boolean
        Using ctx As New Entities
            Return ctx.LeadsActivityLogArchiveds.Any(Function(l) l.BBLE = bble)
        End Using
    End Function

    Public Function IsViewable(name As String) As Boolean
        If String.IsNullOrEmpty(EmployeeName) Then
            Return True
        End If

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

        If IntranetPortal.Employee.GetManagedEmployees(name, False).Contains(owner) Then
            Return True
        End If

        For Each rl In myRoles
            If rl.Contains("*") Then
                Continue For
            End If

            If rl.StartsWith("OfficeManager") Then
                Dim dept = rl.Split("-")(1)
                If IntranetPortal.Employee.GetDeptUsers(dept, False).Contains(owner) Then
                    Return True
                End If

                If IntranetPortal.UserInTeam.GetTeamUsersArray(dept, True).Contains(owner) Then
                    Return True
                End If

                If owner.ToLower.Contains(dept.ToLower & " office") Then
                    Return True
                End If
            End If
        Next

        If SharedUsers.Contains(name) Then
            Return True
        End If

        Return False
    End Function

    Public Shared Function GetLeadsByBBLEs(bbles As String()) As Lead()
        Using ctx As New Entities
            Return ctx.Leads.Where(Function(l) bbles.Contains(l.BBLE)).ToArray
        End Using
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

    ''' <summary>
    ''' Create User Tasks
    ''' </summary>
    ''' <param name="employees"></param>
    ''' <param name="taskPriority"></param>
    ''' <param name="taskAction"></param>
    ''' <param name="taskDescription"></param>
    ''' <param name="bble"></param>
    ''' <param name="createUser"></param>
    ''' <param name="logCategory"></param>
    ''' <returns>Task Id</returns>
    Public Shared Function CreateTask(employees As String, taskPriority As String, taskAction As String, taskDescription As String, bble As String, createUser As String, logCategory As LeadsActivityLog.LogCategory, Optional dueDate As DateTime = Nothing) As UserTask
        Dim scheduleDate As DateTime
        If Not dueDate = Nothing Then
            scheduleDate = dueDate
        Else
            scheduleDate = DateTime.Now

            If taskPriority = "Normal" Then
                scheduleDate = scheduleDate.AddDays(3)
            End If

            If taskPriority = "Important" Then
                scheduleDate = scheduleDate.AddDays(1)
            End If

            If taskPriority = "Urgent" Then
                scheduleDate = scheduleDate.AddHours(2)
            End If
        End If


        Dim comments = String.Format("<table style=""width:100%;line-weight:25px;""> <tr><td style=""width:100px;"">Employees:</td>" &
                                     "<td>{0}</td></tr>" &
                                     "<tr><td>Action:</td><td>{1}</td></tr>" &
                                     "<tr><td>Important:</td><td>{2}</td></tr>" &
                                   "<tr><td>Description:</td><td>{3}</td></tr>" &
                                   "</table>", employees, taskAction, taskPriority, taskDescription)
        Dim emp = Employee.GetInstance(createUser)
        Dim log = LeadsActivityLog.AddActivityLog(DateTime.Now, comments, bble, logCategory.ToString, emp.EmployeeID, createUser, LeadsActivityLog.EnumActionType.SetAsTask)
        Dim task = UserTask.AddUserTask(bble, employees, taskAction, taskPriority, "In Office", scheduleDate, taskDescription, log.LogID, createUser)
        Return task
    End Function

    '''' <summary>
    '''' Return the given user's LoanMod leads which need followup on today
    '''' </summary>
    '''' <param name="userName">The given username</param>
    '''' <returns></returns>
    'Public Shared Function GetLoanModDueToday(userName As String) As List(Of Lead)
    '    Dim lds = Lead.GetLoanModDue(userName, DateTime.Today)
    '    Return lds
    'End Function

    ''' <summary>
    ''' Return the given user's LoanMod leads which need followup on due date
    ''' </summary>
    ''' <param name="userName">The given username</param>
    ''' <param name="dueDate">The given datetime</param>
    ''' <returns></returns>
    Public Shared Function GetLoanModDue(userName As String, Optional dueDate As DateTime? = Nothing) As List(Of Lead)
        Return GetLeadsDue(LeadStatus.LoanMod, userName, dueDate)
    End Function

    ''' <summary>
    ''' Return the given user's LoanMod leads which need followup on given date
    ''' </summary>
    ''' <param name="userName"></param>
    ''' <param name="dueDate">The given datetime, default is today</param>
    ''' <returns></returns>
    Public Shared Function GetHotLeadsDue(userName As String, Optional dueDate As DateTime? = Nothing) As List(Of Lead)
        Return GetLeadsDue(LeadStatus.Priority, userName, dueDate)
    End Function

    ''' <summary>
    ''' Return the leads that need to follow up
    ''' </summary>
    ''' <param name="status">The leads statu</param>
    ''' <param name="userName">The given user name</param>
    ''' <param name="dueDate">The due date</param>
    ''' <returns></returns>
    Public Shared Function GetLeadsDue(status As LeadStatus, userName As String, Optional dueDate As DateTime? = Nothing) As List(Of Lead)
        If dueDate Is Nothing Then
            dueDate = Date.Today
        End If

        Dim lds = Lead.GetUserLeadsData(userName, status)
        Return lds.Where(Function(ld) ld.IsDueOn(dueDate, leadsStatusDueDays(status))).ToList
    End Function

    Private Shared dic As Dictionary(Of LeadStatus, Integer)
    Private Shared ReadOnly Property leadsStatusDueDays As Dictionary(Of LeadStatus, Integer)
        Get
            If dic Is Nothing Then
                dic = New Dictionary(Of LeadStatus, Integer)
                dic.Add(LeadStatus.LoanMod, 30)
                dic.Add(LeadStatus.Priority, 5)
            End If

            Return dic
        End Get
    End Property

    Private Function IsDueOn(dueDate As DateTime, days As Integer) As Boolean
        Dim ts = dueDate - LastOwnerUpdate

        If ts.TotalDays > days Then
            Return True
        End If

        Return False
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

    ''' <summary>
    ''' Leads Request Update action
    ''' </summary>
    ''' <param name="bble">Leads BBLE</param>
    ''' <param name="description">The description that would send to leads owner</param>
    ''' <param name="priority">The request priority</param>
    ''' <param name="requestBy">The user that send this request</param>
    ''' <param name="manager">The user manager</param>
    Public Shared Sub RequestUpdate(bble As String, description As String, priority As String, requestBy As String, manager As String)
        Dim ld = Lead.GetInstance(bble)

        Dim agent = Employee.GetInstance(ld.EmployeeName)
        If agent IsNot Nothing AndAlso Not String.IsNullOrEmpty(agent.Email) Then
            Dim emailData As New Dictionary(Of String, String)
            emailData.Add("Address", ld.LeadsName)
            emailData.Add("Agent", ld.EmployeeName)
            emailData.Add("RequestBy", requestBy)
            emailData.Add("Description", description)
            emailData.Add("Priority", priority)
            emailData.Add("BBLE", bble)

            Dim ccAddresses As New List(Of String)
            Dim requestEmp = Employee.GetInstance(requestBy)
            ccAddresses.Add(requestEmp.Email)
            Dim mgr = Employee.GetInstance(manager)
            ccAddresses.Add(mgr.Email)

            IntranetPortal.Core.EmailService.SendMail(agent.Email, String.Join(";", ccAddresses), "RequestUpdateTemplate", emailData)

            IntranetPortal.Core.SystemLog.Log("RequestUpdate", emailData.ToJsonString, Core.SystemLog.LogCategory.Operation, bble, requestBy)
        Else
            Throw New CallbackException("Can not find the agent in the System. Please contact the system admin. Agent Name: " & ld.EmployeeName)
        End If
    End Sub

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

    Public Shared Function UpdateLeadStatus(bble As String, status As LeadStatus, callbackDate As DateTime, Optional addCommend As String = Nothing, Optional subStatus As String = Nothing) As Boolean
        Using Context As New Entities
            Dim lead = Context.Leads.Where(Function(l) l.BBLE = bble).FirstOrDefault
            Dim addComStr = If(String.IsNullOrEmpty(addCommend), "", "<br/>" & " Comments: " & addCommend)
            If lead IsNot Nothing Then
                Dim originateStatus = lead.Status
                lead.Status = status
                If Not callbackDate = Nothing Then
                    lead.CallbackDate = callbackDate
                End If

                If Not String.IsNullOrEmpty(subStatus) Then
                    lead.SubStatus = CInt(subStatus)
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
    ''' <summary>
    ''' Set leads to dead and expire all rule enginee and task
    ''' </summary>
    ''' <param name="bble"></param>
    ''' <param name="reason"></param>
    ''' <param name="description"></param>
    ''' <param name="notlog">defult is false , set true if don't want show change status log in activity log </param>
    ''' <returns></returns>
    Public Shared Function SetDeadLeadsStatus(bble As String, reason As Integer, description As String, Optional notlog As Boolean = False) As Boolean
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
                UserTask.ExpiredAgentTasks(bble)
                'UserTask.ExpiredTasks(bble, lead.EmployeeName)

                If Not originateStatus = LeadStatus.DeadEnd Then
                    Dim empId = CInt(Membership.GetUser(HttpContext.Current.User.Identity.Name).ProviderUserKey)
                    Dim empName = HttpContext.Current.User.Identity.Name
                    Dim comments = String.Format("Change status from {0} to {1}.", CType(originateStatus, LeadStatus).ToString, LeadStatus.DeadEnd.ToString)
                    If (Not notlog) Then
                        LeadsActivityLog.AddActivityLog(DateTime.Now, comments, bble, LeadsActivityLog.LogCategory.SalesAgent.ToString, empId, empName, LeadsActivityLog.EnumActionType.DeadLead)
                    End If

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

    ''' <summary>
    ''' Assign single lead
    ''' </summary>
    ''' <param name="bble">Leads bble</param>
    ''' <param name="userName">Employee name who assigned to</param>
    ''' <param name="assignBy">Assigned User</param>
    Public Shared Sub AssignLeads(bble As String, userName As String, assignBy As String)
        Dim emp = Employee.GetInstance(userName)

        If emp Is Nothing Then
            Throw New PortalException("Can't find employee. Name: " & userName)
        End If

        If Not LeadsInfo.Exists(bble) Then
            LeadsInfo.CreateLeadsInfo(bble)
        End If

        BatchAssignLeads({bble}, userName, emp.EmployeeID, assignBy)
    End Sub

    ''' <summary>
    ''' Assign multiple leads at one time
    ''' </summary>
    ''' <param name="bbles">the list of BBLE</param>
    ''' <param name="name">Employee name assigned to</param>
    ''' <param name="empId">Employee Id</param>
    ''' <param name="assignBy">Assigned User</param>
    ''' <param name="archiveLogs">indicator if acchieve logs needed</param>
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
                        LeadsActivityLog.AddActivityLogEntity(DateTime.Now, comments, item, LeadsActivityLog.LogCategory.SalesAgent.ToString, Nothing, assignBy, LeadsActivityLog.EnumActionType.Reassign, Context)
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
                        LeadsActivityLog.AddActivityLogEntity(DateTime.Now, comments, item, LeadsActivityLog.LogCategory.SalesAgent.ToString, Nothing, assignBy, LeadsActivityLog.EnumActionType.Reassign, Context)
                    End If

                    'Clear shared user information
                    newlead.ClearSharedUser()

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

    ''' <summary>
    ''' The list of shared users
    ''' </summary>
    ''' <returns>List of Usernames</returns>
    Public ReadOnly Property SharedUsers As List(Of String)
        Get
            Using ctx As New Entities
                Return ctx.SharedLeads.Where(Function(s) s.BBLE = BBLE).Select(Function(s) s.UserName).ToList
            End Using
        End Get
    End Property

    ''' <summary>
    ''' Add shared user relationship
    ''' </summary>
    ''' <param name="userName">shared user</param>
    ''' <param name="createBy">the user who add shared user</param>
    Public Sub AddSharedUser(userName As String, createBy As String)
        Using Context As New Entities
            Dim item = Context.SharedLeads.Where(Function(sl) sl.BBLE = BBLE And sl.UserName = userName).FirstOrDefault

            If item Is Nothing Then
                Dim sharedItem As New SharedLead
                sharedItem.BBLE = BBLE
                sharedItem.UserName = userName
                sharedItem.CreateBy = createBy
                sharedItem.CreateDate = DateTime.Now

                Context.SharedLeads.Add(sharedItem)
                Context.SaveChanges()
            End If
        End Using
    End Sub

    ''' <summary>
    ''' Remove all shared user relationship
    ''' </summary>
    Public Sub ClearSharedUser()
        Using ctx As New Entities
            If ctx.SharedLeads.Any(Function(sl) sl.BBLE = BBLE) Then
                Dim sharedUsers = ctx.SharedLeads.Where(Function(s) s.BBLE = BBLE).ToList

                ctx.SharedLeads.RemoveRange(sharedUsers)
                ctx.SaveChanges()
            End If
        End Using
    End Sub

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
                UserTask.ExpiredAgentTasks(BBLE)
                'UserTask.ExpiredTasks(BBLE, originator)
                UserAppointment.ExpiredAppointmentByBBLE(BBLE)

                Dim comments = String.Format("Leads Reassign from {0} to {1}.", originator, empName)
                LeadsActivityLog.AddActivityLog(DateTime.Now, comments, BBLE, LeadsActivityLog.LogCategory.Status.ToString, LeadsActivityLog.EnumActionType.Reassign)

            End Using
        End If
    End Sub

    Public Shared Function ExpiredLeadsTask(bble As String) As Boolean
        Try
            'Expired the task on this bble
            WorkflowService.ExpiredLeadsProcess(bble)
            UserTask.ExpiredAgentTasks(bble)
            'UserTask.ExpiredTasks(BBLE, originator)
            UserAppointment.ExpiredAppointmentByBBLE(bble)
            Return True
        Catch ex As Exception
            Return False
        End Try

        Return True
    End Function

    Public Shared Sub UpdateLeadSubStatus(bble As String, newSubStatus As String)
        If newSubStatus = "0" OrElse newSubStatus = "1" Then
            Using Context As New Entities

                Dim lead = Context.Leads.Where(Function(l) l.BBLE = bble).FirstOrDefault
                If lead IsNot Nothing Then
                    lead.SubStatus = CInt(newSubStatus)
                    Context.SaveChanges()


                    Dim empId = CInt(Membership.GetUser(HttpContext.Current.User.Identity.Name).ProviderUserKey)
                    Dim empName = HttpContext.Current.User.Identity.Name
                    Dim comments = "Lead Status changed to LoanMod(" & lead.SubStatusStr.ToString & ") on " & Date.Now.ToString("MM/dd/yyyy")
                    LeadsActivityLog.AddActivityLog(DateTime.Now, comments, bble, LeadsActivityLog.LogCategory.SalesAgent.ToString, empId, empName, LeadsActivityLog.EnumActionType.RefreshLeads)
                End If
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
    <JsonIgnoreAttribute>
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

    <JsonIgnoreAttribute>
    Public ReadOnly Property Task As UserTask
        Get
            Using ctx As New Entities
                Return ctx.UserTasks.Where(Function(t) t.BBLE = BBLE And t.Status = UserTask.TaskStatus.Active).Take(0).FirstOrDefault
            End Using
        End Get
    End Property

    <JsonIgnoreAttribute>
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
