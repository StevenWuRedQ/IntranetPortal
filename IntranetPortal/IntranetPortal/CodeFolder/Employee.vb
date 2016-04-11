
Imports System.Runtime.Serialization.Formatters.Binary
Imports System.IO
Imports Newtonsoft.Json
Imports System.ComponentModel.DataAnnotations

<MetadataType(GetType(EmployeeMetaData))>
Partial Public Class Employee

    Private Shared _ceo As Employee
    Public Shared ReadOnly Property CEO As Employee
        Get
            If _ceo Is Nothing Then
                Using ctx As New Entities
                    _ceo = ctx.Employees.Where(Function(em) em.Position = "CEO").FirstOrDefault
                End Using
            End If

            Return _ceo
        End Get
    End Property

    Public Shared ReadOnly Property CurrentAppId As Integer
        Get
            Try
                If HttpContext.Current IsNot Nothing AndAlso HttpContext.Current.User IsNot Nothing AndAlso HttpContext.Current.User.Identity IsNot Nothing AndAlso Not String.IsNullOrEmpty(HttpContext.Current.User.Identity.Name) Then
                    Dim emp = GetInstance(HttpContext.Current.User.Identity.Name)
                    If emp IsNot Nothing Then
                        Return emp.AppId
                    End If
                Else
                    Return 1
                End If
            Catch ex As Exception
                Core.SystemLog.LogError("Error to get CurrentAppId", ex, ex.ToJsonString, "", "")
                Return 1
            End Try
        End Get
    End Property

    Public Shared Function GetProfile(name As String) As EmployeeProfile
        Using context As New Entities
            Dim data = context.UserProfileDatas.Where(Function(up) up.UserName = name).Select(Function(up) up.ProfileData).SingleOrDefault
            If data IsNot Nothing Then
                Dim serializer As New BinaryFormatter
                Dim writer As New MemoryStream(data)
                Dim profile As EmployeeProfile = serializer.Deserialize(writer)
                Return profile
            Else
                Return New EmployeeProfile
            End If
        End Using
    End Function

    Public Shared Sub SaveProfile(name As String, profile As EmployeeProfile)
        If profile IsNot Nothing Then

            Using myWriter As New StringWriter
                Dim serializer As New BinaryFormatter
                Dim writer As New MemoryStream()
                serializer.Serialize(writer, profile)
                writer.Flush()

                Using context As New Entities
                    Dim userprofile = context.UserProfileDatas.Where(Function(up) up.UserName = name).SingleOrDefault
                    If userprofile IsNot Nothing Then
                        userprofile.ProfileData = writer.ToArray
                    Else
                        userprofile = New UserProfileData
                        userprofile.UserName = name
                        userprofile.ProfileData = writer.ToArray

                        context.UserProfileDatas.Add(userprofile)
                    End If

                    context.SaveChanges()
                End Using
            End Using
        End If
    End Sub

    Public ReadOnly Property Office As String
        Get
            If Position IsNot Nothing AndAlso Position.Length > 0 Then
                Return Position & "(" & Department & ")"
            End If

            Return ""
        End Get
    End Property

    Public Shared ReadOnly Property Application As Core.Application
        Get
            Return Core.Application.Instance(CurrentAppId)
        End Get
    End Property

    <JsonIgnoreAttribute>
    Public ReadOnly Property Manager As String
        Get
            If ReportTo.HasValue AndAlso ReportTo.Value > 0 Then
                Dim mgr = GetInstance(ReportTo.Value)
                If mgr Is Nothing Then
                    Return ""
                Else
                    Return mgr.Name
                End If
            End If

            Return ""
        End Get
    End Property

    Private _performance As EmployeePerformance

    <JsonIgnoreAttribute>
    Public ReadOnly Property Performance As EmployeePerformance
        Get
            If _performance Is Nothing Then
                _performance = New EmployeePerformance(Me)
            End If

            Return _performance
        End Get
    End Property

    Public Shared Function HasControlLeads(name As String, bble As String) As Boolean
        If Roles.IsUserInRole(name, "Admin") Then
            Return True
        End If

        Dim ld = Lead.GetInstance(bble)
        If ld Is Nothing Then
            Return False
        End If

        Return ld.IsViewable(name)

        'Using context As New Entities
        '    If Roles.IsUserInRole(name, "Admin") Then
        '        Return True
        '    End If

        '    If Roles.IsUserInRole(name, "Title-Users") Then
        '        Return True
        '    End If

        '    Dim lead = context.Leads.Where(Function(ld) ld.BBLE = bble).SingleOrDefault

        '    If lead IsNot Nothing Then
        '        Dim owner = lead.EmployeeName

        '        If owner = name Then
        '            If lead.Status <> LeadStatus.MgrApproval And lead.Status <> LeadStatus.MgrApprovalInWf Then
        '                Return True
        '            Else
        '                Return False
        '            End If
        '        End If

        '        If GetManagedEmployees(name).Contains(owner) Then
        '            Return True
        '        End If

        '        For Each rl In Roles.GetRolesForUser(name)
        '            If rl.StartsWith("OfficeManager") Then
        '                Dim dept = rl.Split("-")(1)

        '                If GetDeptUsers(dept).Contains(owner) Then
        '                    Return True
        '                End If
        '            End If
        '        Next
        '    End If

        '    Return False
        'End Using
    End Function

    ''' <summary>
    ''' Return the employees in the teams that user managed
    ''' </summary>
    ''' <param name="userName">The user name</param>
    ''' <returns>the list of UserInTeam object</returns>
    Public Shared Function GetMyEmployeesByTeam(userName As String) As List(Of UserInTeam)
        Using ctx As New Entities
            If Roles.IsUserInRole(userName, "Admin") Then
                Return UserInTeam.GetAllUsers
            End If

            Dim teams As New List(Of String)
            For Each rl In Roles.GetRolesForUser(userName)
                If rl.StartsWith("OfficeManager") Then
                    If rl.Contains("*") Then
                        Continue For
                    End If

                    teams.Add(rl.Split("-")(1))
                End If
            Next

            If teams.Count > 0 Then
                Dim result = New List(Of UserInTeam)

                For Each tm In teams
                    result.AddRange(UserInTeam.GetTeamUsers(tm))
                Next
                Return result
            End If

            If Employee.HasSubordinates(userName) Then
                Return UserInTeam.GetTeamUsersByNames(Employee.GetManagedEmployees(userName))
            End If

            Return New List(Of UserInTeam)
        End Using
    End Function

    Public Shared Function GetMyEmployees(userName As String) As List(Of Employee)

        Using ctx As New Entities

            Dim roleNames = Core.PortalSettings.GetValue("LeadsViewableRoles").Split(";")

            Dim myRoles = Roles.GetRolesForUser(userName)

            If myRoles.Any(Function(r) roleNames.Contains(r)) Then
                Return ctx.Employees.Where(Function(em) em.Active = True).OrderBy(Function(em) em.Name).ToList
            End If

            Dim emps As New List(Of Employee)

            For Each rl In myRoles
                If rl.Contains("*") Then
                    Continue For
                End If

                If rl.StartsWith("OfficeManager") Then

                    Dim dept = rl.Split("-")(1)

                    emps.AddRange(GetDeptUsersList(dept, True))

                End If
            Next

            If Employee.HasSubordinates(userName) Then
                emps.AddRange(Employee.GetManagedEmployeeList(userName))
            End If

            Return emps.Distinct(New EmployeeItemComparer()).OrderBy(Function(em) em.Name).ToList

        End Using

    End Function

    ''' <summary>
    ''' Get managed team users list
    ''' </summary>
    ''' <param name="userName">Manager name</param>
    ''' <returns></returns>
    Public Shared Function GetControledDeptEmployees(userName As String) As String()
        Dim emps As New List(Of String)
        For Each rl In Roles.GetRolesForUser(userName)
            If rl.StartsWith("OfficeManager") Then
                Dim dept = rl.Split("-")(1)
                emps.AddRange(GetDeptUsers(dept).ToList)
                emps.AddRange(UserInTeam.GetTeamUsersArray(dept))
            End If
        Next

        Return emps.Distinct.ToArray
    End Function

    Public Shared Function GetInstance(id As Integer) As Employee
        Using context As New Entities
            Dim emp = context.Employees.Where(Function(em) em.EmployeeID = id).FirstOrDefault
            Return emp
        End Using
    End Function

    Public Shared Function GetInstance(username As String) As Employee
        Using context As New Entities
            Dim emp = context.Employees.Where(Function(em) em.Name = username).FirstOrDefault
            Return emp
        End Using
    End Function

    Public Shared Function GetInstanceByEmail(email As String) As Employee
        Using ctx As New Entities
            Return ctx.Employees.Where(Function(em) em.Email = email).FirstOrDefault
        End Using
    End Function

    Public Shared Function GetInstanceData(username As String) As Employee
        Using context As New Entities
            Dim emp = context.Employees.Where(Function(em) em.Name = username).ToList.Select(Function(em)
                                                                                                 Dim result As New Employee
                                                                                                 Core.Utility.CopyTo(em, result)
                                                                                                 Return result
                                                                                             End Function).FirstOrDefault

            Return emp
        End Using
    End Function

    Public Shared Function GetSubOrdinate(managerName As String) As Integer()
        Dim emps As New List(Of Employee)
        Dim mgr = GetInstance(managerName)
        emps.Add(mgr)
        emps.AddRange(GetSubOrdinate(mgr.EmployeeID))

        Return emps.Select(Function(e) e.EmployeeID).ToArray
    End Function

    Public Shared Function GetSubOrdinateWithoutMgr(managerName As String) As Integer()
        Dim emps As New List(Of Employee)
        Dim mgr = GetInstance(managerName)
        emps.AddRange(GetSubOrdinate(mgr.EmployeeID))

        Return emps.Select(Function(e) e.EmployeeID).ToArray
    End Function

    'Public Shared Function GetEmployeeUnderManaged(managerName As String) As List(Of Employee)
    '    If Roles.IsUserInRole(managerName, "Admin") Then
    '        Return GetAllEmps()
    '    End If

    'End Function

    ''' <summary>
    ''' Get managed active employee through manager name
    ''' </summary>
    ''' <param name="managerName">Manager name</param>
    ''' <returns>Employee name array</returns>
    Public Shared Function GetManagedEmployees(managerName As String) As String()
        Return GetManagedEmployees(managerName, True)
    End Function

    Public Shared Function GetManagedEmployeeList(managerName As String) As List(Of Employee)
        Dim emps As New List(Of Employee)
        Dim mgr = GetInstance(managerName)
        emps.Add(mgr)
        emps.AddRange(GetSubOrdinate(mgr.EmployeeID, True))

        Return emps
    End Function

    Public Shared Function GetManagedEmployees(managerName As String, onlyActive As String) As String()
        Dim emps As New List(Of Employee)
        Dim mgr = GetInstance(managerName)
        emps.Add(mgr)
        emps.AddRange(GetSubOrdinate(mgr.EmployeeID, onlyActive))

        Return emps.Select(Function(e) e.Name).ToArray
    End Function

    Public Shared Function GetUsersByDept(deptName As String) As List(Of Employee)
        Dim emps As New List(Of Employee)
        Using context As New Entities
            Return context.Employees.Where(Function(em) em.Department = deptName And em.Active = True).ToList
        End Using
    End Function

    Public Shared Function GetSubOrdinate(employeeID As Integer) As List(Of Employee)
        Return GetSubOrdinate(employeeID, True)
    End Function

    Public Shared Function GetSubOrdinate(employeeID As Integer, onlyActive As Boolean) As List(Of Employee)
        Dim emps As New List(Of Employee)
        Using context As New Entities
            If onlyActive = True Then
                For Each emp In context.Employees.Where(Function(em) em.ReportTo = employeeID And em.Active = onlyActive)
                    emps.Add(emp)
                    emps.AddRange(GetSubOrdinate(emp.EmployeeID))
                Next
            Else
                For Each emp In context.Employees.Where(Function(em) em.ReportTo = employeeID)
                    emps.Add(emp)
                    emps.AddRange(GetSubOrdinate(emp.EmployeeID))
                Next
            End If
        End Using

        Return emps
    End Function

    Public Shared Function GetRoleUsers(roleName As String) As String()
        Dim ssRoles = Roles.GetAllRoles().Where(Function(r) r.StartsWith(roleName))

        Dim users As New List(Of String)
        For Each r In ssRoles
            users.AddRange(Roles.GetUsersInRole(r))
        Next

        Return users.Distinct.ToArray
    End Function

    Public Shared Function GetDeptUsers(deptName As String, Optional onlyActive As Boolean = True) As String()
        Return GetDeptUsersList(deptName, onlyActive).Select(Function(em) em.Name).ToArray

        'Dim emps As New List(Of Employee)
        'Using context As New Entities
        '    Return context.Employees.Where(Function(em) em.Department = deptName And em.Active = True).Select(Function(em) em.Name).ToArray
        'End Using
    End Function

    Public Shared Function GetAllDeptUsers(deptName As String) As String()
        Return GetDeptUsers(deptName, False)
        'Using context As New Entities
        '    Return context.Employees.Where(Function(em) em.Department = deptName).Select(Function(em) em.Name).ToArray
        'End Using
    End Function

    Public Shared Function GetUnActiveUser(deptName As String) As String()
        Return GetDeptUnActiveUserList(deptName).Select(Function(em) em.Name).ToArray
        'Using context As New Entities
        '    Return context.Employees.Where(Function(em) em.Department = deptName And em.Active = False).Select(Function(em) em.Name).ToArray
        'End Using
    End Function

    Public Shared Function GetDeptUnActiveUserList(deptName As String) As List(Of Employee)
        Return GetDeptUsersList(deptName, False).Where(Function(em) em.Active = False).ToList

        'Using context As New Entities
        '    Return context.Employees.Where(Function(em) em.Department = deptName And (em.Active = False)).ToList
        'End Using
    End Function

    Public Shared Function GetDeptUsersList(deptName As String) As List(Of Employee)
        Return GetDeptUsersList(deptName, True)
    End Function

    Public Shared Function GetDeptUsersList(deptName As String, isActive As Boolean) As List(Of Employee)
        Dim emps As New List(Of Employee)
        Using context As New Entities
            Return context.Employees.Where(Function(em) em.Department = deptName And (em.Active = isActive Or isActive = False)).ToList
        End Using
    End Function

    Public Shared Function GetReportToManger(employeeName As String) As Employee
        Dim emp = GetInstance(employeeName)

        If emp.ReportTo > 0 Then
            Dim mgr = GetInstance(emp.ReportTo.Value)
            Return mgr
        Else
            Return emp
        End If
    End Function

    Public Shared Function GetAllEmps() As String()
        Using Context As New Entities
            Return Context.Employees.Select(Function(em) em.Name).ToArray
        End Using
    End Function

    Public Shared Function GetAllActiveEmps() As String()
        Using Context As New Entities
            Return Context.Employees.Where(Function(em) em.Active = True).Select(Function(em) em.Name).ToArray
        End Using
    End Function

    Public Shared Function GetAllActiveEmps(appId As Integer) As String()
        Using Context As New Entities
            Return Context.Employees.Where(Function(em) em.Active = True And em.AppId = appId).Select(Function(em) em.Name).ToArray
        End Using
    End Function

    Public Shared Function IsAdmin(empName As String) As Boolean
        Dim rs = Roles.GetRolesForUser(empName)

        If rs.Contains("Admin") Then
            Return True
        End If

        Return False
    End Function

    Public Shared Function IsManager(empName As String) As Boolean
        Dim rs = Roles.GetRolesForUser(empName)

        If rs.Contains("Admin") Then
            Return True
        End If

        If rs.Where(Function(r) r.StartsWith("OfficeManager")).Count > 0 Then
            Return True
        End If

        If rs.Any(Function(r) r.Contains("Manager")) Then
            Return True
        End If

        Return HasSubordinates(empName)
    End Function

    Public Shared Function HasSubordinates(employeeName As String) As Boolean
        Using context As New Entities
            Dim emp = GetInstance(employeeName)
            If emp IsNot Nothing Then
                Return context.Employees.Where(Function(em) em.ReportTo = emp.EmployeeID And em.Active = True).Count > 0
            Else
                Return False
            End If
        End Using
    End Function

    Public Shared Function GetTeamUsers(teamId As Integer) As String()
        Using ctx As New Entities
            Dim emps = (From user In ctx.UserInTeams.Where(Function(ut) ut.TeamId = teamId)
                        Join emp In ctx.Employees On user.EmployeeName Equals emp.Name
                        Where emp.Active = True
                        Select user.EmployeeName).ToArray

            Return emps
        End Using
    End Function

    Public Shared Function GetAllTeamUsers(teamId As Integer) As String()
        Using ctx As New Entities
            Return ctx.UserInTeams.Where(Function(ut) ut.TeamId = teamId).Select(Function(ut) ut.EmployeeName).ToArray
        End Using
    End Function

    Public Shared Function GetTeamUserList(teamId As Integer) As List(Of Employee)
        Using ctx As New Entities
            Dim emps = ctx.UserInTeams.Where(Function(ut) ut.TeamId = teamId).ToList.Select(Function(ut) Employee.GetInstance(ut.EmployeeName)).ToList
            Return emps
        End Using
    End Function

    ''' <summary>
    ''' Return a boolean to indicate if the user is shortsale manager
    ''' </summary>
    ''' <param name="userName"></param>
    ''' <returns></returns>
    Public Shared Function IsShortSaleManager(userName As String) As Boolean
        Dim rs = Roles.GetRolesForUser(userName)

        If rs.Contains("Admin") Then
            Return True
        End If

        If rs.Contains("Legal-Manager") Then
            Return True
        End If

        If rs.Where(Function(r) r = "ShortSale-Manager").Count > 0 Then
            Return True
        End If

        Return False
    End Function

    Public Shared Function GetShortSaleRole(userName As String) As ShortSaleRole
        Dim rs = Roles.GetRolesForUser(userName)

        If rs.Contains("Admin") Then
            Return ShortSaleRole.Manager
        End If

        If rs.Where(Function(r) r = "ShortSale-Manager").Count > 0 Then
            Return ShortSaleRole.Manager
        End If

        If rs.Where(Function(r) r = "ShortSale-Processor").Count > 0 Then
            Return ShortSaleRole.Processor
        End If

        If rs.Where(Function(r) r = "ShortSale-Negotiator").Count > 0 Then
            Return ShortSaleRole.Negotiator
        End If

        Return Nothing
    End Function

    Public Shared Function GetOfficeAssignAccount(empName As String) As String
        Dim emp = GetInstance(empName)
        Dim recycleName = emp.Department & " Office"
        'If GetInstance(recycleName) IsNot Nothing Then
        '    Return recycleName
        'End If

        Using ctx As New Entities
            Dim team = UserInTeam.GetUserTeam(empName)

            If team IsNot Nothing Then
                recycleName = team & " Office"

                If GetInstance(recycleName) IsNot Nothing Then
                    Return recycleName
                End If
            End If
        End Using

        If Not String.IsNullOrEmpty(emp.Manager) Then
            Return emp.Manager
        End If

        Return empName
    End Function

    Public Shared Function GetEmpOfficeManagers(empName As String) As String()
        'Dim depart = GetInstance(empName).Department

        'Dim officeRole = "OfficeManager-" & depart

        'If Roles.RoleExists(officeRole) Then
        '    Return Roles.GetUsersInRole(officeRole)
        'End If

        Dim teams = GetEmpTeams(empName)
        If teams IsNot Nothing AndAlso teams.Length > 0 Then
            Dim team = teams.First()

            If Roles.RoleExists("OfficeManager-" & team) Then
                Return Roles.GetUsersInRole("OfficeManager-" & team)
            End If
        End If
        Dim emp = Employee.GetInstance(empName)
        If emp IsNot Nothing AndAlso Not String.IsNullOrEmpty(emp.Manager) Then
            Return {empName, emp.Manager}
        End If

        Return {empName}

    End Function

    ''' <summary>
    ''' Get emloyees email and joined with ";" can easily use to send email.
    ''' </summary>
    ''' <param name="emps">List of emloyee</param>
    ''' <returns>emails String joined with ";" </returns>
    Public Shared Function GetEmpsEmails(ParamArray emps() As Employee) As String
        If (emps IsNot Nothing AndAlso emps.Count > 0) Then
            Dim emails = emps.Select(Function(e) e.Email).Distinct()
            Return String.Join(";", emails)
        End If
        Return Nothing
    End Function

    ''' <summary>
    ''' Get emloyees email and joined with ";" can easily use to send email.
    ''' </summary>
    ''' <param name="emps">List of emloyee</param>
    ''' <returns>emails String joined with ";" </returns>
    Public Shared Function GetEmpsEmails(emps As String()) As String
        If (emps IsNot Nothing AndAlso emps.Count > 0) Then
            Using ctx As New Entities
                Dim emails = ctx.Employees.Where(Function(em) emps.Contains(em.Name)).Select(Function(em) em.Email).ToArray
                Return String.Join(";", emails)
            End Using

        End If
        Return Nothing
    End Function

    Public Shared Function GetEmpTeams(empName As String) As String()
        Using ctx As New Entities
            Dim team = (From t In ctx.Teams
                        Join ut In ctx.UserInTeams On t.TeamId Equals ut.TeamId
                        Where ut.EmployeeName = empName
                        Select t.Name).ToList

            If team IsNot Nothing Then
                Return team.ToArray
            End If

            Return Nothing
        End Using
    End Function

    Public Function GetData() As EmployeeData

        Return Core.Utility.CopyTo(Me, New EmployeeData())
    End Function

    Public Class EmployeeData
        Inherits Employee

        <JsonIgnoreAttribute>
        Public Overrides Property Leads As ICollection(Of Lead)
            Get
                Return MyBase.Leads
            End Get
            Set(value As ICollection(Of Lead))
                MyBase.Leads = value
            End Set
        End Property

        <JsonIgnoreAttribute>
        Public Overrides Property LeadsActivityLogs As ICollection(Of LeadsActivityLog)
            Get
                Return MyBase.LeadsActivityLogs
            End Get
            Set(value As ICollection(Of LeadsActivityLog))
                MyBase.LeadsActivityLogs = value
            End Set
        End Property
    End Class
End Class

Public Class EmployeeMetaData
    <JsonIgnoreAttribute>
    Public Property Password As String
    <JsonIgnoreAttribute>
    Public Property Leads As ICollection(Of Lead)
    <JsonIgnoreAttribute>
    Public Property LeadsActivityLogs As ICollection(Of LeadsActivityLog)
End Class




Public Enum ShortSaleRole
    Processor
    Negotiator
    Manager
End Enum