
Imports System.Runtime.Serialization.Formatters.Binary
Imports System.IO
Imports Newtonsoft.Json
Imports System.ComponentModel.DataAnnotations
Imports System.Security.Cryptography

''' <summary>
''' The Employee Object
''' </summary>
<MetadataType(GetType(EmployeeMetaData))>
Partial Public Class Employee
    ' it better to separate to two const but now both of them is 30
    ' so make it as one const number
#If DEBUG Then
    Private Shared ReadOnly FOLLOW_UP_OR_LOAN_MODS_COUNT_LIMIT As Integer = 3
#Else
    Private Shared ReadOnly FOLLOW_UP_OR_LOAN_MODS_COUNT_LIMIT As Integer = 30
#End If


    Private Shared _ceo As Employee
    ''' <summary>
    ''' Get company CEO
    ''' </summary>
    ''' <returns>The Employee Object</returns>
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

    ''' <summary>
    ''' Get Current Application Id
    ''' </summary>
    ''' <returns>The Application Id</returns>
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

    ''' <summary>
    ''' Get Employee User Profile Data
    ''' </summary>
    ''' <param name="name">The employee name</param>
    ''' <returns>The Employee Profile Object</returns>
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

    ''' <summary>
    ''' Save Employee Profile Object
    ''' </summary>
    ''' <param name="name">The employee name</param>
    ''' <param name="profile">The employee profile object</param>
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

    ''' <summary>
    ''' The employee office display name
    ''' </summary>
    ''' <returns>Return the string with format: Positon(Department)</returns>
    Public ReadOnly Property Office As String
        Get
            If Position IsNot Nothing AndAlso Position.Length > 0 Then
                Return Position & "(" & Department & ")"
            End If

            Return ""
        End Get
    End Property

    ''' <summary>
    ''' Return Current Application Object
    ''' </summary>
    ''' <returns>The Application Object</returns>
    Public Shared ReadOnly Property Application As Core.Application
        Get
            Return Core.Application.Instance(CurrentAppId)
        End Get
    End Property

    ''' <summary>
    ''' Return manager name if employee has reportTo manager, otherwise return empty string
    ''' </summary>
    ''' <returns>The manager name or empty string</returns>
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

    ''' <summary>
    ''' Get Employee Performance Overview
    ''' </summary>
    ''' <returns>The Employee Performance Object</returns>
    <JsonIgnoreAttribute>
    Public ReadOnly Property Performance As EmployeePerformance
        Get
            If _performance Is Nothing Then
                _performance = New EmployeePerformance(Me)
            End If

            Return _performance
        End Get
    End Property

    ''' <summary>
    ''' Return if the given employee has permission on the given lead
    ''' </summary>
    ''' <param name="name">The Employee Name</param>
    ''' <param name="bble">The Leads BBLE info</param>
    ''' <returns>Boolean value to indicate the permission</returns>
    Public Shared Function HasControlLeads(name As String, bble As String) As Boolean
        If Roles.IsUserInRole(name, "Admin") Then
            Return True
        End If
        ' Roles.GetUsersInRole("ShortSale-")
        Dim ld = Lead.GetInstance(bble)
        If ld Is Nothing Then
            Return False
        End If

        Return ld.IsViewable(name)
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

    ''' <summary>
    ''' Return the managed employee list of the given employee
    ''' </summary>
    ''' <param name="userName">The Employee Name</param>
    ''' <returns>The Employee Object List</returns>
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
                If rl.Contains("*") Then
                    Continue For
                End If

                Dim dept = rl.Split("-")(1)
                emps.AddRange(GetDeptUsers(dept).ToList)
                emps.AddRange(UserInTeam.GetTeamUsersArray(dept))
            End If
        Next

        Return emps.Distinct.ToArray
    End Function

    ''' <summary>
    ''' Return Employee Object by the employee Id
    ''' </summary>
    ''' <param name="id">The given employee Id</param>
    ''' <returns>The Employee Object</returns>
    Public Shared Function GetInstance(id As Integer) As Employee
        Using context As New Entities
            Dim emp = context.Employees.Where(Function(em) em.EmployeeID = id).FirstOrDefault
            Return emp
        End Using
    End Function

    ''' <summary>
    ''' Return Employee Object by the employee name
    ''' </summary>
    ''' <param name="username">The Employee Name</param>
    ''' <returns>The Employee Object</returns>
    Public Shared Function GetInstance(username As String) As Employee
        Using context As New Entities
            Dim emp = context.Employees.Where(Function(em) em.Name = username).FirstOrDefault
            Return emp
        End Using
    End Function

    ''' <summary>
    ''' Return Employee Object by the employee's email
    ''' </summary>
    ''' <param name="email">The Employee Email</param>
    ''' <returns>The Employee Object</returns>
    Public Shared Function GetInstanceByEmail(email As String) As Employee
        Using ctx As New Entities
            Return ctx.Employees.Where(Function(em) em.Email = email).FirstOrDefault
        End Using
    End Function

    ''' <summary>
    ''' Return employee object, which can used to JSON serialized
    ''' </summary>
    ''' <param name="username">The Employee Name</param>
    ''' <returns>The Employee Object</returns>
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

    ''' <summary>
    ''' Return the list of sub ordinates  (include manager) of given manager name
    ''' </summary>
    ''' <param name="managerName">The Employee Name</param>
    ''' <returns>The list of employee Id</returns>
    Public Shared Function GetSubOrdinate(managerName As String) As Integer()
        Dim emps As New List(Of Employee)
        Dim mgr = GetInstance(managerName)
        emps.Add(mgr)
        emps.AddRange(GetSubOrdinate(mgr.EmployeeID))

        Return emps.Select(Function(e) e.EmployeeID).ToArray
    End Function

    ''' <summary>
    ''' Return the list of sub ordinates (without manager) of given manager
    ''' </summary>
    ''' <param name="managerName">The Employee Name</param>
    ''' <returns>The list of Employee Id</returns>
    Public Shared Function GetSubOrdinateWithoutMgr(managerName As String) As Integer()
        Dim emps As New List(Of Employee)
        Dim mgr = GetInstance(managerName)
        emps.AddRange(GetSubOrdinate(mgr.EmployeeID))

        Return emps.Select(Function(e) e.EmployeeID).ToArray
    End Function

    ''' <summary>
    ''' Get managed active employee through manager name
    ''' </summary>
    ''' <param name="managerName">Manager name</param>
    ''' <returns>Employee name array</returns>
    Public Shared Function GetManagedEmployees(managerName As String) As String()
        Return GetManagedEmployees(managerName, True)
    End Function

    ''' <summary>
    ''' Return if given manager has manage permission on given employee
    ''' </summary>
    ''' <param name="manager">The Manager Name</param>
    ''' <param name="username">The Employee Name</param>
    ''' <returns></returns>
    Public Shared Function IsUserManager(manager As String, username As String) As Boolean
        Dim users = GetManagedEmployees(manager, False)
        Return users.Contains(username)
    End Function

    ''' <summary>
    ''' Return list of employee object managed by the given manager
    ''' </summary>
    ''' <param name="managerName">The Employee Name</param>
    ''' <returns>The list of Employee</returns>
    Public Shared Function GetManagedEmployeeList(managerName As String) As List(Of Employee)
        Dim emps As New List(Of Employee)
        Dim mgr = GetInstance(managerName)
        emps.Add(mgr)
        emps.AddRange(GetSubOrdinate(mgr.EmployeeID, True))

        Return emps
    End Function

    ''' <summary>
    ''' Return list of managed employee of given manager name
    ''' </summary>
    ''' <param name="managerName">The Manager Name</param>
    ''' <param name="onlyActive">If include non-active user </param>
    ''' <returns>The list of employee name</returns>
    Public Shared Function GetManagedEmployees(managerName As String, onlyActive As String) As String()
        Dim emps As New List(Of Employee)
        Dim mgr = GetInstance(managerName)
        emps.Add(mgr)
        emps.AddRange(GetSubOrdinate(mgr.EmployeeID, onlyActive))

        Return emps.Select(Function(e) e.Name).ToArray
    End Function

    ''' <summary>
    ''' Return list of employee under the given department
    ''' </summary>
    ''' <param name="deptName">The Department Name</param>
    ''' <returns>The list of employee instance</returns>
    Public Shared Function GetUsersByDept(deptName As String) As List(Of Employee)
        Dim emps As New List(Of Employee)
        Using context As New Entities
            Return context.Employees.Where(Function(em) em.Department = deptName And em.Active = True).ToList
        End Using
    End Function

    ''' <summary>
    ''' Get the list of active employee which report to given employee
    ''' </summary>
    ''' <param name="employeeID">The Employee ID</param>
    ''' <returns>The list of Employee Object</returns>
    Public Shared Function GetSubOrdinate(employeeID As Integer) As List(Of Employee)
        Return GetSubOrdinate(employeeID, True)
    End Function

    ''' <summary>
    ''' Get the list of employee which report to given employee and indicate if include non active
    ''' </summary>
    ''' <param name="employeeID">The given employee ID</param>
    ''' <param name="onlyActive">To indicate if non-active users would included</param>
    ''' <returns>The list of Employee Object</returns>
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

    ''' <summary>
    ''' Return list of user name that belong to given role name
    ''' </summary>
    ''' <param name="roleName">The Role Name</param>
    ''' <returns>The list of User Name</returns>
    Public Shared Function GetRoleUsers(roleName As String) As String()
        Dim ssRoles = Roles.GetAllRoles().Where(Function(r) r.StartsWith(roleName))

        Dim users As New List(Of String)
        For Each r In ssRoles
            users.AddRange(Roles.GetUsersInRole(r))
        Next

        Return users.Distinct.ToArray
    End Function
    ''' <summary>
    ''' get all user email split with ; in role 
    ''' </summary>
    ''' <param name="roleName">Role Name</param>
    ''' <returns>user emails split with ; </returns>
    Public Shared Function GetRoleUserEmails(roleName As String) As String
        Dim users = GetRoleUsers(roleName)
        Return GetEmpsEmails(users)
    End Function
    ''' <summary>
    ''' Return list of user names that belong to given department
    ''' </summary>
    ''' <param name="deptName">The Department Name</param>
    ''' <param name="onlyActive">Indicate if non active employee included</param>
    ''' <returns></returns>
    Public Shared Function GetDeptUsers(deptName As String, Optional onlyActive As Boolean = True) As String()
        Return GetDeptUsersList(deptName, onlyActive).Select(Function(em) em.Name).ToArray
    End Function

    ''' <summary>
    ''' Get all the user names that belong to given department, include non-active users
    ''' </summary>
    ''' <param name="deptName">The Department Name</param>
    ''' <returns>The list of User Names</returns>
    Public Shared Function GetAllDeptUsers(deptName As String) As String()
        Return GetDeptUsers(deptName, False)
    End Function

    ''' <summary>
    ''' Get non-active users that belong to given department
    ''' </summary>
    ''' <param name="deptName">The Department Name</param>
    ''' <returns>The list of employee name</returns>
    Public Shared Function GetUnActiveUser(deptName As String) As String()
        Return GetDeptUnActiveUserList(deptName).Select(Function(em) em.Name).ToArray
        'Using context As New Entities
        '    Return context.Employees.Where(Function(em) em.Department = deptName And em.Active = False).Select(Function(em) em.Name).ToArray
        'End Using
    End Function

    ''' <summary>
    ''' Get non-active employee objects that under given department
    ''' </summary>
    ''' <param name="deptName">The Department Name</param>
    ''' <returns>The list of Employee Object</returns>
    Public Shared Function GetDeptUnActiveUserList(deptName As String) As List(Of Employee)
        Return GetDeptUsersList(deptName, False).Where(Function(em) em.Active = False).ToList
    End Function

    ''' <summary>
    ''' Get the list of Employee Objects that under given department
    ''' </summary>
    ''' <param name="deptName">The Department Name</param>
    ''' <returns>The list of Employee Object</returns>
    Public Shared Function GetDeptUsersList(deptName As String) As List(Of Employee)
        Return GetDeptUsersList(deptName, True)
    End Function

    ''' <summary>
    ''' Get the list of Employee Object that under given department
    ''' </summary>
    ''' <param name="deptName">The Department Name</param>
    ''' <param name="isActive">Indicate if non-active employee included</param>
    ''' <returns>The list of Employee Object</returns>
    Public Shared Function GetDeptUsersList(deptName As String, isActive As Boolean) As List(Of Employee)
        Dim emps As New List(Of Employee)
        Using context As New Entities
            Return context.Employees.Where(Function(em) em.Department = deptName And (em.Active = isActive Or isActive = False)).ToList
        End Using
    End Function

    ''' <summary>
    ''' Get the given employee's manager instance
    ''' </summary>
    ''' <param name="employeeName">The Employee Name</param>
    ''' <returns>The Employee Object</returns>
    Public Shared Function GetReportToManger(employeeName As String) As Employee
        Dim emp = GetInstance(employeeName)

        If emp.ReportTo > 0 Then
            Dim mgr = GetInstance(emp.ReportTo.Value)
            Return mgr
        Else
            Return emp
        End If
    End Function

    ''' <summary>
    ''' Get the list of all employee's name
    ''' </summary>
    ''' <returns>The list of employee name</returns>
    Public Shared Function GetAllEmps() As String()
        Using Context As New Entities
            Return Context.Employees.Select(Function(em) em.Name).ToArray
        End Using
    End Function

    ''' <summary>
    ''' Get the list of active employee's name
    ''' </summary>
    ''' <returns>The list of active employee name</returns>
    Public Shared Function GetAllActiveEmps() As String()
        Using Context As New Entities
            Return Context.Employees.Where(Function(em) em.Active = True).Select(Function(em) em.Name).ToArray
        End Using
    End Function

    ''' <summary>
    ''' Get the list of active employee's names under given application
    ''' </summary>
    ''' <param name="appId">The Application Id</param>
    ''' <returns>The list of employee name</returns>
    Public Shared Function GetAllActiveEmps(appId As Integer) As String()
        Using Context As New Entities
            Return Context.Employees.Where(Function(em) em.Active = True And em.AppId = appId).Select(Function(em) em.Name).ToArray
        End Using
    End Function

    ''' <summary>
    ''' Return if given employee is admin user
    ''' </summary>
    ''' <param name="empName">The Employee Name</param>
    ''' <returns>True if employee is admin user</returns>
    Public Shared Function IsAdmin(empName As String) As Boolean
        Dim rs = Roles.GetRolesForUser(empName)

        If rs.Contains("Admin") Then
            Return True
        End If

        Return False
    End Function

    ''' <summary>
    ''' Return if given user is manager
    ''' </summary>
    ''' <param name="empName">The Employee Name</param>
    ''' <returns></returns>
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

        If rs.Any(Function(r) r.Contains("OfficeExecutive")) Then
            Return True
        End If

        Return HasSubordinates(empName)
    End Function

    ''' <summary>
    ''' Return if the given employee has subordinates
    ''' </summary>
    ''' <param name="employeeName">The Employee Name</param>
    ''' <returns></returns>
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

    ''' <summary>
    ''' Get the list of active usernames in given team
    ''' </summary>
    ''' <param name="teamId">The given team ID</param>
    ''' <returns>The list of employee name</returns>
    Public Shared Function GetTeamUsers(teamId As Integer) As String()
        Using ctx As New Entities
            Dim emps = (From user In ctx.UserInTeams.Where(Function(ut) ut.TeamId = teamId)
                        Join emp In ctx.Employees On user.EmployeeName Equals emp.Name
                        Where emp.Active = True
                        Select user.EmployeeName).ToArray

            Return emps
        End Using
    End Function

    ''' <summary>
    ''' Get the list of all usernames in given team
    ''' </summary>
    ''' <param name="teamId">The team id</param>
    ''' <returns>The list of username</returns>
    Public Shared Function GetAllTeamUsers(teamId As Integer) As String()
        Using ctx As New Entities
            Return ctx.UserInTeams.Where(Function(ut) ut.TeamId = teamId).Select(Function(ut) ut.EmployeeName).ToArray
        End Using
    End Function

    ''' <summary>
    ''' Get the list of employee objects in given team
    ''' </summary>
    ''' <param name="teamId">The team id</param>
    ''' <returns>The list of employee object</returns>
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

        Dim viewableRoles = Core.PortalSettings.GetValue("ShortSaleManagerRoles").Split(";")

        If rs.Any(Function(a) viewableRoles.Any(Function(r) a.StartsWith(r.Replace("*", "")))) Then
            Return True
        End If

        If rs.Where(Function(r) r = "ShortSale-Manager").Count > 0 Then
            Return True
        End If

        Return False
    End Function

    ''' <summary>
    ''' Get ShortSaleRole type related to given employee, 
    ''' if the given employee is not in ShortSale, return nothing
    ''' </summary>
    ''' <param name="userName">The given employee</param>
    ''' <returns>The ShortSale Role Type</returns>
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

    ''' <summary>
    ''' Get team/office assign folder account of the given employee
    ''' </summary>
    ''' <param name="empName">The Employee Name</param>
    ''' <returns>The account name</returns>
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

    ''' <summary>
    ''' Get team/office managers of the given employee, if no manager found, return the given employee
    ''' </summary>
    ''' <param name="empName">The employee name</param>
    ''' <returns>The manager names</returns>
    Public Shared Function GetEmpOfficeManagers(empName As String) As String()
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
        If CheckIsTesting() Then
            Return "chrisy@myidealprop.com"
        End If

        If (emps IsNot Nothing AndAlso emps.Count > 0) Then
            Dim emails = emps.Where(Function(f) f IsNot Nothing).Select(Function(e) e.Email).Distinct()
            Return String.Join(";", emails)
        End If
        Return Nothing
    End Function

    ''' <summary>
    ''' Get emloyees email and joined with ";" can easily use to send email.
    ''' </summary>
    ''' <param name="emps">List of emloyee</param>
    ''' <returns>emails String joined with ";" </returns>
    Public Shared Function GetEmpsEmails(ParamArray emps() As String) As String
        If CheckIsTesting() Then
            Return "chrisy@myidealprop.com"
        End If

        If (emps IsNot Nothing AndAlso emps.Count > 0) Then
            Using ctx As New Entities
                Dim emails = ctx.Employees.Where(Function(em) emps.Contains(em.Name)).Select(Function(em) em.Email).ToArray
                Return String.Join(";", emails)
            End Using

        End If
        Return Nothing
    End Function

    Private Shared Function CheckIsTesting() As Boolean
        Return Utility.IsTesting()
    End Function

    Private Shared _empTeams As New Dictionary(Of String, String)
    Private Shared lockObj As New Object
    Public Shared Function GetEmpTeam(empName As String) As String
        If Not _empTeams.ContainsKey(empName) Then
            SyncLock lockObj
                If _empTeams.ContainsKey(empName) Then
                    Return _empTeams(empName)
                End If

                Dim team = GetEmpTeams(empName)
                If team IsNot Nothing AndAlso team.Count > 0 Then
                    _empTeams.Add(empName, team(0))
                Else
                    _empTeams.Add(empName, Nothing)
                End If
            End SyncLock

        End If

        Return _empTeams(empName)
    End Function

    ''' <summary>
    ''' Get the list of team which the given employee belongs to
    ''' </summary>
    ''' <param name="empName">The Employee Name</param>
    ''' <returns>The list of team name</returns>
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


    ''' <summary>
    ''' Get Employee Data, used for JSON serialized
    ''' </summary>
    ''' <returns></returns>
    Public Function GetData() As EmployeeData
        Return Core.Utility.CopyTo(Me, New EmployeeData())
    End Function
    ''' <summary>
    ''' verify plain text to md5 crypted 
    ''' </summary>
    ''' <param name="input">input plain text  to compare with password in database</param>
    ''' <returns>t</returns>
    Public Function VerifyPassword(input As String) As Boolean

        Return Password = CryptoPasswrod(input)
    End Function
    ''' <summary>
    ''' Change  password
    ''' </summary>
    ''' <param name="newPassword"></param>
    Public Sub ChangePassword(newPassword As String)
        Password = CryptoPasswrod(newPassword)
    End Sub
    ''' <summary>
    ''' crypto password using md5 crypto algorithm
    ''' </summary>
    ''' <param name="password">password need crypto</param>
    ''' <returns></returns>
    Public Function CryptoPasswrod(password As String) As String
        Using md5Hash = MD5.Create()
            Dim hash = GetMd5Hash(md5Hash, password)
            Return hash
        End Using

    End Function


    ''' <summary>
    ''' MD5 encrypt password
    ''' </summary>
    ''' <param name="md5Hash">MD5 hash algorithm</param>
    ''' <param name="input">string need to encrypt</param>
    ''' <returns></returns>
    Private Shared Function GetMd5Hash(md5Hash As MD5, input As String) As String

        ' Convert the input string to a byte array and compute the hash.
        Dim data As Byte() = md5Hash.ComputeHash(Encoding.UTF8.GetBytes(input))

        ' Create a new Stringbuilder to collect the bytes
        ' and create a string.
        Dim sBuilder As New StringBuilder()

        ' Loop through each byte of the hashed data 
        ' and format each one as a hexadecimal string.
        For i As Integer = 0 To data.Length - 1
            sBuilder.Append(data(i).ToString("x2"))
        Next

        ' Return the hexadecimal string.
        Return sBuilder.ToString()
    End Function

    ' Verify a hash against a string.
    Private Shared Function VerifyMd5Hash(md5Hash As MD5, input As String, hash As String) As Boolean
        ' Hash the input.
        Dim hashOfInput As String = GetMd5Hash(md5Hash, input)

        ' Create a StringComparer an compare the hashes.
        Dim comparer As StringComparer = StringComparer.OrdinalIgnoreCase

        If 0 = comparer.Compare(hashOfInput, hash) Then
            Return True
        Else
            Return False
        End If
    End Function


    ''' <summary>
    ''' Check limit status leads count achieve to limit or not 
    ''' </summary>
    ''' <param name="limitStatus"></param>
    ''' <param name="limitCount"></param>
    ''' <returns>true is achived limit , false is not</returns>
    Private Function LeadsCountAchiveLimited(limitStatus As LeadStatus, limitCount As Integer) As Boolean

        Dim ctx = New Entities



        Using ctx
            Return ctx.Leads.Where(Function(l) l.Status = limitStatus And l.EmployeeName = Name).Count >= limitCount
        End Using
        ' use leads is better for unit test
        ' Return Me.Leads.Where(Function(e) e.s)
    End Function

    ''' <summary>
    ''' Check leads count achive follow up limit
    ''' </summary>
    ''' <returns>true is achived limit</returns>
    Public Function IsAchieveFollowUpLimit() As Boolean
        Return LeadsCountAchiveLimited(LeadStatus.Callback, FOLLOW_UP_OR_LOAN_MODS_COUNT_LIMIT)
    End Function

    ''' <summary>
    ''' Check leads of employee achive loan mod limit
    ''' </summary>
    ''' <returns> true is achieve loan mod limit</returns>
    Public Function IsAchieveLoanModLimit() As Boolean
        Return LeadsCountAchiveLimited(LeadStatus.LoanMod, FOLLOW_UP_OR_LOAN_MODS_COUNT_LIMIT)
    End Function

    ''' <summary>
    ''' The employee data object, used for JSON serialized
    ''' </summary>
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