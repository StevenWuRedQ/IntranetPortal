Imports System.ComponentModel

Partial Public Class Lead

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

    Public ReadOnly Property LastUserUpdate As DateTime
        Get
            Dim log = LeadsActivityLogs.Where(Function(l) l.EmployeeName = EmployeeName).OrderByDescending(Function(lg) lg.ActivityDate).FirstOrDefault
            If log IsNot Nothing Then
                Return log.ActivityDate
            End If

            Return AssignDate
        End Get
    End Property

    Public ReadOnly Property ReferrelName As String
        Get
            Return Me.LeadsInfo.ReferrelName
        End Get
    End Property

    Public Shared Function UpdateLeadStatus(bble As String, status As LeadStatus, callbackDate As DateTime) As Boolean
        Using Context As New Entities
            Dim lead = Context.Leads.Where(Function(l) l.BBLE = bble).FirstOrDefault

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
                    Dim comments = String.Format("Change status from {0} to {1}.", CType(originateStatus, LeadStatus).ToString, status.ToString)
                    If status = LeadStatus.DoorKnocks Then
                        LeadsActivityLog.AddActivityLog(DateTime.Now, comments, bble, LeadsActivityLog.LogCategory.Status.ToString, empId, empName, LeadsActivityLog.EnumActionType.DoorKnock)
                    Else
                        If status = LeadStatus.Callback Then
                            comments = "Lead Status changed to Follow Up on " & callbackDate.ToString("MM/dd/yyyy")
                        End If

                        LeadsActivityLog.AddActivityLog(DateTime.Now, comments, bble, LeadsActivityLog.LogCategory.Status.ToString, empId, empName)
                    End If
                End If

                'copy to user task list
                If status = LeadStatus.Callback Or status = LeadStatus.Priority Then
                    'UserTask.AddUserTask(bble, empName, comments)
                End If
            End If
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

                If Not originateStatus = LeadStatus.DeadEnd Then
                    Dim empId = CInt(Membership.GetUser(HttpContext.Current.User.Identity.Name).ProviderUserKey)
                    Dim empName = HttpContext.Current.User.Identity.Name
                    Dim comments = String.Format("Change status from {0} to {1}.", CType(originateStatus, LeadStatus).ToString, LeadStatus.DeadEnd.ToString)
                    LeadsActivityLog.AddActivityLog(DateTime.Now, comments, bble, LeadsActivityLog.LogCategory.Status.ToString, empId, empName)
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

    Public Sub ReAssignLeads(empName As String)
        Dim emp = IntranetPortal.Employee.GetInstance(empName)

        If emp IsNot Nothing Then
            Dim originator = EmployeeName
            Using ctx As New Entities
                Dim ld = ctx.Leads.Find(BBLE)
                ld.EmployeeID = emp.EmployeeID
                ld.EmployeeName = emp.Name
                ld.Status = LeadStatus.NewLead
                ld.AssignDate = DateTime.Now
                ld.LastUpdate = DateTime.Now
                ctx.SaveChanges()

                Dim comments = String.Format("Leads Reassign from {0} to {1}.", originator, empName)
                LeadsActivityLog.AddActivityLog(DateTime.Now, comments, BBLE, LeadsActivityLog.LogCategory.Status.ToString, LeadsActivityLog.EnumActionType.Reassign)
            End Using
        End If
    End Sub

    Public Sub Recycle()
        Dim recycleName = Employee.Department & " office"
        If IntranetPortal.Employee.GetInstance(recycleName) IsNot Nothing Then
            ReAssignLeads(recycleName)
            Return
        End If

        Using ctx As New Entities
            Dim team = (From t In ctx.Teams
                       Join ut In ctx.UserInTeams On t.TeamId Equals ut.TeamId
                       Where ut.EmployeeName = EmployeeName
                       Select t.Name).FirstOrDefault

            If team IsNot Nothing Then
                recycleName = team & " office"

                If IntranetPortal.Employee.GetInstance(recycleName) IsNot Nothing Then
                    ReAssignLeads(recycleName)
                    Return
                End If
            End If
        End Using
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
                Return ctx.UserAppointments.Where(Function(t) t.BBLE = BBLE And t.Status = UserAppointment.AppointmentStatus.NewAppointment).Take(0).FirstOrDefault
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
