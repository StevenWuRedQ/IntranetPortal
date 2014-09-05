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

    Public ReadOnly Property Performance As EmployeePerformance
        Get
            Return New EmployeePerformance(Me)
        End Get
    End Property

    Public Shared Function HasControlLeads(name As String, bble As String) As Boolean
        Using context As New Entities
            If Roles.IsUserInRole(name, "Admin") Then
                Return True
            End If

            Dim lead = context.Leads.Where(Function(ld) ld.BBLE = bble).SingleOrDefault

            If lead IsNot Nothing Then
                Dim owner = lead.EmployeeName

                If owner = name And lead.Status <> LeadStatus.MgrApproval Then
                    Return True
                End If

                If GetManagedEmployees(name).Contains(owner) Then
                    Return True
                End If

                For Each rl In Roles.GetRolesForUser(name)
                    If rl.StartsWith("OfficeManager") Then
                        Dim dept = rl.Split("-")(1)

                        If GetDeptUsers(dept).Contains(owner) Then
                            Return True
                        End If
                    End If
                Next
            End If

            Return False
        End Using
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

    Public Shared Function IsManager(empName As String)
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
End Class
