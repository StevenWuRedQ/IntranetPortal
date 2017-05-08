Public Class EmployeeManage
    Public Shared Function FindEmployeeInRole(empName As String, roleName As String) As Employee.EmployeeData
        Dim result As Employee.EmployeeData
        Using ctx As New Entities
            Dim emp = ctx.Employees.Where(Function(u) u.Active _
                                                      AndAlso u.Name = empName).AsEnumerable()
            result = emp.Where(Function(u) Roles.IsUserInRole(u.Name, roleName)) _
                .Select(Function(u) u.GetData()).FirstOrDefault()
            Return result
        End Using
    End Function

    Public Shared Function FindEmployeesInRole(roleName As string) As IEnumerable(Of Employee.EmployeeData)
        Dim result As IEnumerable(Of Employee.EmployeeData)
        Using ctx As New Entities
            Dim emp = ctx.Employees.Where(Function(u) u.Active).AsEnumerable()
            result = emp.Where(Function(u) Roles.IsUserInRole(u.Name, roleName)) _
                        .Select(Function(u) u.GetData()).ToList()
            Return result
        End Using
    End Function
End Class
