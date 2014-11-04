Partial Public Class AssignLeadsRule
    Public Property rule As AssignRule

    Public Sub Execute()
        rule.Execute()

        'Dim emp = Employee.GetInstance(rule.EmployeeName)

        'Using ctx As New Entities
        '    Dim lds = ctx.Leads.Where(Function(li) li.EmployeeName = emp.Department & " Office").Take(rule.Count)

        '    For Each ld In lds
        '        ld.EmployeeID = emp.EmployeeID
        '        ld.EmployeeName = emp.Name
        '        ld.AssignDate = DateTime.Now
        '        ld.AssignBy = "System"
        '    Next

        '    ctx.SaveChanges()
        'End Using
    End Sub
End Class
