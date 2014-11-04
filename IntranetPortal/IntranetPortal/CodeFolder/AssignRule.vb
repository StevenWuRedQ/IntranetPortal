Partial Public Class AssignRule

    Public ReadOnly Property LeadsTypeText As String
        Get
            Try
                Return CType(LeadsType, LeadsInfo.LeadsType).ToString
            Catch ex As Exception
                Return ""
            End Try

        End Get
    End Property

    Public ReadOnly Property IntervalTypeText As String
        Get
            Try
                Return CType(IntervalType, RuleInterval).ToString
            Catch ex As Exception
                Return ""
            End Try
        End Get
    End Property

    Public Shared Function GetAllRules() As List(Of AssignRule)
        Using ctx As New Entities
            Return ctx.AssignRules.ToList
        End Using
    End Function

    Public Sub Execute()
        Dim logdata = GetLogData(CType(IntervalType, RuleInterval))
        If IsAssigned(logdata, EmployeeName) Then
            Return
        End If

        Dim emp = Employee.GetInstance(EmployeeName)
        Using ctx As New Entities
            Dim lds = ctx.Leads.Where(Function(li) li.EmployeeName = emp.Department & " Office").Take(Count)

            For Each ld In lds
                ld.EmployeeID = emp.EmployeeID
                ld.EmployeeName = emp.Name
                ld.AssignDate = DateTime.Now
                ld.AssignBy = "System"
            Next
            ctx.SaveChanges()

            Dim log = New AssginRulesLog
            log.EmployeeName = EmployeeName
            log.LogData = logdata
            log.LeadsAmount = lds.Count
            log.CreateBy = "Data Service"
            log.CreateDate = DateTime.Now

            ctx.AssginRulesLogs.Add(log)
            ctx.SaveChanges()
        End Using
    End Sub

    Private Function GetLogData(interval As RuleInterval) As String
        Select Case interval
            Case RuleInterval.Day
                Return DateTime.Today.DayOfYear
            Case RuleInterval.Week
                Return DateTime.Today.DayOfWeek
        End Select

        Return ""
    End Function

    Private Function IsAssigned(logdata As String, empName As String) As Boolean
        Using ctx As New Entities
            Return ctx.AssginRulesLogs.Where(Function(log) log.LogData = logdata And log.EmployeeName = empName).Count > 0
        End Using
    End Function

    Public Enum RuleInterval
        Day
        Week
    End Enum
End Class
