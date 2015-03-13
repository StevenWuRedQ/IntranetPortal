Imports System.Runtime.Serialization.Formatters.Binary
Imports System.IO

Partial Public Class Employee

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

    Public Shared Function GetMyEmployeesByTeam(userName As String) As List(Of UserInTeam)
        Using ctx As New Entities
            If Roles.IsUserInRole(userName, "Admin") Then
                Return UserInTeam.GetAllUsers
            End If

            Dim teams As New List(Of String)
            For Each rl In Roles.GetRolesForUser(userName)
                If rl.StartsWith("OfficeManager") Then
                    teams.Add(rl.Split("-")(1))
                End If
            Next

            If teams.Count > 0 Then
                Return UserInTeam.GetTeamUsers(String.Join(",", teams.ToArray))
            End If

            If Employee.HasSubordinates(userName) Then
                Return UserInTeam.GetTeamUsersByNames(Employee.GetManagedEmployees(userName))
            End If

            Return New List(Of UserInTeam)
        End Using
    End Function

    Public Shared Function GetMyEmployees(userName As String) As List(Of Employee)
        Using ctx As New Entities
            If Roles.IsUserInRole(userName, "Admin") Then
                Return ctx.Employees.Where(Function(em) em.Active = True).OrderBy(Function(em) em.Name).ToList
            End If

            Dim emps As New List(Of Employee)

            For Each rl In Roles.GetRolesForUser(userName)
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

    Public Shared Function GetControledDeptEmployees(userName As String) As String()
        Dim emps As New List(Of String)
        For Each rl In Roles.GetRolesForUser(userName)
            If rl.StartsWith("OfficeManager") Then
                Dim dept = rl.Split("-")(1)
                emps.AddRange(GetDeptUsers(dept).ToList)
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

    Public Shared Function GetDeptUsers(deptName As String, Optional onlyActive As Boolean = True) As String()
        Return GetDeptUsersList(deptName, onlyActive).Select(Function(em) em.Name).ToArray

        'Dim emps As New List(Of Employee)
        'Using context As New Entities
        '    Return context.Employees.Where(Function(em) em.Department = deptName And em.Active = True).Select(Function(em) em.Name).ToArray
        'End Using
    End Function

    Public Shared Function GetAllDeptUsers(deptName As String) As String()
        Using context As New Entities
            Return context.Employees.Where(Function(em) em.Department = deptName).Select(Function(em) em.Name).ToArray
        End Using
    End Function

    Public Shared Function GetUnActiveUser(deptName As String) As String()
        Using context As New Entities
            Return context.Employees.Where(Function(em) em.Department = deptName And em.Active = False).Select(Function(em) em.Name).ToArray
        End Using
    End Function

    Public Shared Function GetDeptUsersList(deptName As String) As List(Of Employee)
        Dim emps As New List(Of Employee)
        Using context As New Entities
            Return context.Employees.Where(Function(em) em.Department = deptName And em.Active = True).ToList
        End Using
    End Function

    Public Shared Function GetDeptUsersList(deptName As String, isActive As Boolean) As List(Of Employee)
        Dim emps As New List(Of Employee)
        Using context As New Entities
            Return context.Employees.Where(Function(em) em.Department = deptName And em.Active = isActive).ToList
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

    Public Shared Function IsShortSaleManager(userName As String) As Boolean
        Dim rs = Roles.GetRolesForUser(userName)

        If rs.Contains("Admin") Then
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
        Dim recycleName = emp.Department & " office"
        If GetInstance(recycleName) IsNot Nothing Then
            Return recycleName
        End If

        Using ctx As New Entities
            Dim team = (From t In ctx.Teams
                       Join ut In ctx.UserInTeams On t.TeamId Equals ut.TeamId
                       Where ut.EmployeeName = empName
                       Select t.Name).FirstOrDefault

            If team IsNot Nothing Then
                recycleName = team & " office"

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

End Class

Public Enum ShortSaleRole
    Processor
    Negotiator
    Manager
End Enum