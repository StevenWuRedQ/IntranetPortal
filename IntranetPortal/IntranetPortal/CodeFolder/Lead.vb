Partial Public Class Lead

    Public ReadOnly Property FormatLeadsname As String
        Get
            'Dim leadsName = ""

            'If leadData IsNot Nothing AndAlso Not String.IsNullOrEmpty(leadData.PropertyAddress) Then
            '    If String.IsNullOrEmpty(leadData.Owner) Then
            '        Return leadData.PropertyAddress
            '    End If

            '    leadsName = String.Format("{0} {1} - {2}", leadData.Number, leadData.StreetName, leadData.Owner)
            '    leadsName = leadsName.TrimStart(" ")
            '    If Not String.IsNullOrEmpty(leadData.CoOwner) Then
            '        leadsName += "; " & leadData.CoOwner
            '    End If

            'End If

            Dim leadsname = String.Format("<span style='color:red'>{0} {1}</span> - {2}", LeadsInfo.Number, LeadsInfo.StreetName, LeadsInfo.Owner)
            Return leadsname

        End Get
    End Property

    Public Shared Function GetInstance(bble As String) As Lead
        Using context As New Entities
            Return context.Leads.Where(Function(l) l.BBLE = bble).SingleOrDefault
        End Using
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

    Public Shared Function GetAllActiveLeads() As List(Of Lead)
        Using ctx As New Entities
            Dim emps = Employee.GetAllActiveEmps()

            Dim results = (From ld In ctx.Leads
                          Where emps.Contains(ld.EmployeeName) And (ld.Status <> LeadStatus.DeadEnd And ld.Status <> LeadStatus.InProcess)
                          Select ld).ToList

            Return results
        End Using
    End Function

    Public Sub ReAssignLeads(empName As String)
        Dim emp = IntranetPortal.Employee.GetInstance(empName)

        If emp IsNot Nothing Then
            Dim originator = emp.Name
            Using ctx As New Entities
                Me.EmployeeID = emp.EmployeeID
                Me.EmployeeName = emp.Name
                Me.AssignDate = DateTime.Now
                Me.LastUpdate = DateTime.Now

                ctx.Entry(Me).State = Entity.EntityState.Modified
                ctx.SaveChanges()

                Dim comments = String.Format("Leads Reassign from {0} to {1}.", originator, empName)
                LeadsActivityLog.AddActivityLog(DateTime.Now, comments, BBLE, LeadsActivityLog.LogCategory.Status.ToString)
            End Using
        End If
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

End Class
