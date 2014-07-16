Partial Public Class Employee

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

    Public Shared Function GetManagedEmployees(managerName As String) As String()
        Return GetManagedEmployees(managerName, True)
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
