Partial Public Class AssignRule

    Public Property LeadsTypeText As String
        Get
            Try
                Return CType(LeadsType, LeadsInfo.LeadsType).ToString
            Catch ex As Exception
                Return ""
            End Try
        End Get
        Set(value As String)
            If (IsNumeric(value)) Then
                LeadsType = CType(CInt(value), LeadsInfo.LeadsType)
                Return
            End If
            LeadsType = [Enum].Parse(GetType(LeadsInfo.LeadsType), value)
        End Set
    End Property

    Public Property IntervalTypeText As String
        Get
            Try
                Return CType(IntervalType, RuleInterval).ToString
            Catch ex As Exception
                Return ""
            End Try
        End Get
        Set(value As String)
            If (IsNumeric(value)) Then
                IntervalType = CType(CInt(value), RuleInterval)
                Return
            End If
            IntervalType = DirectCast([Enum].Parse(GetType(RuleInterval), value), RuleInterval)
        End Set
    End Property

    Public Shared Function GetAllRules() As List(Of AssignRule)
        Using ctx As New Entities
            Return ctx.AssignRules.ToList
        End Using
    End Function

    Public Shared Function GetRuleById(ruleId As Integer) As AssignRule
        Using ctx As New Entities
            Return ctx.AssignRules.Find(ruleId)
        End Using
    End Function

    Public Sub Execute()
        Dim logdata = GetLogData(CType(IntervalType, RuleInterval))
        If IsAssigned(logdata, EmployeeName) Then
            Return
        End If

        Dim emp = Employee.GetInstance(EmployeeName)

        Using ctx As New Entities
            Dim rowCount = 0
            If Not String.IsNullOrEmpty(Source) Then
                Dim lds As List(Of Lead)
                If LeadsType = LeadsInfo.LeadsType.All Then
                    lds = ctx.Leads.Where(Function(li) li.EmployeeName = Source).Take(Me.Count).ToList
                Else
                    lds = ctx.Leads.Where(Function(li) li.EmployeeName = Source And li.LeadsInfo.Type = LeadsType).Take(Count).ToList
                End If

                For Each ld In lds
                    ld.EmployeeID = emp.EmployeeID
                    ld.EmployeeName = emp.Name
                    ld.Status = LeadStatus.NewLead
                    ld.AssignDate = DateTime.Now
                    ld.AssignBy = "System"
                Next
                ctx.SaveChanges()
                rowCount = lds.Count
            Else
                If Description = "LeadsBankRule" Then
                    rowCount = AssginLeadsBank()
                End If
            End If

            If rowCount > 0 Then
                Dim log = New AssginRulesLog
                log.EmployeeName = EmployeeName
                log.LogData = logdata
                log.RuleId = RuleId
                log.LeadsAmount = Count
                log.CreateBy = "System"
                log.CreateDate = DateTime.Now
                ctx.AssginRulesLogs.Add(log)
                ctx.SaveChanges()
            End If
        End Using
    End Sub

    Private Function AssginLeadsBank() As Integer
        Dim key = "BusinessRules"
        Using Context As New Entities
            Dim rowCount = 0
            Try
                For Each prop In Context.Agent_Properties.Where(Function(ap) ap.BBLE IsNot Nothing And (ap.Active = True Or Not ap.Active.HasValue) And ap.Agent_Name = EmployeeName).Take(count)
                    Dim li = Context.LeadsInfoes.Where(Function(l) l.BBLE = prop.BBLE).SingleOrDefault
                    If li Is Nothing Then

                        li = New LeadsInfo
                        li.PropertyAddress = prop.Property_Address
                        li.BBLE = prop.BBLE
                        li.CreateBy = key
                        li.CreateDate = DateTime.Now

                        If Not String.IsNullOrEmpty(prop.Type) Then
                            li.Type = li.GetLeadsType(prop.Type)
                        End If

                        If Context.LeadsInfoes.Local.Where(Function(tmp) tmp.BBLE = li.BBLE).Count = 0 Then
                            Context.LeadsInfoes.Add(li)
                            rowCount += 1
                        End If
                    End If

                    If Not String.IsNullOrEmpty(prop.Agent_Name) Then
                        Dim emp = Employee.GetInstance(prop.Agent_Name)

                        If emp IsNot Nothing Then
                            Dim newlead = Context.Leads.Where(Function(ld) ld.BBLE = prop.BBLE).SingleOrDefault
                            If newlead Is Nothing Then
                                newlead = New Lead() With {
                                                  .BBLE = prop.BBLE,
                                                  .LeadsName = li.LeadsName,
                                                  .Neighborhood = li.NeighName,
                                                  .EmployeeID = emp.EmployeeID,
                                                  .EmployeeName = emp.Name,
                                                  .Status = LeadStatus.NewLead,
                                                  .AssignDate = DateTime.Now,
                                                  .AssignBy = key
                                                  }

                                If Context.Leads.Local.Where(Function(tmp) tmp.BBLE = prop.BBLE).Count = 0 Then
                                    Context.Leads.Add(newlead)
                                End If
                            End If
                        End If
                    End If

                    prop.Active = False
                Next
                Context.SaveChanges()

            Catch ex As Exception
                Throw ex
            End Try

            Return rowCount
        End Using
    End Function

    Private Function GetLogData(interval As RuleInterval) As String
        Select Case interval
            Case RuleInterval.Day
                Return String.Format("DAY:{0}/{1}", DateTime.Today.DayOfYear, DateTime.Today.Year)
            Case RuleInterval.Week
                Return String.Format("WEEK:{0}/{1}", DatePart(DateInterval.WeekOfYear, DateTime.Today, Microsoft.VisualBasic.FirstDayOfWeek.Sunday), DateTime.Today.Year)
        End Select

        Return ""
    End Function

    Public Overrides Function ToString() As String
        Return String.Format("Employee Name: {0}, Amount: {1}, LeadsType: {2}", EmployeeName, Count, LeadsTypeText)
    End Function

    Private Function IsAssigned(logdata As String, empName As String) As Boolean
        Using ctx As New Entities
            Return ctx.AssginRulesLogs.Where(Function(log) log.LogData = logdata And log.EmployeeName = empName And log.RuleId = RuleId).Count > 0
        End Using
    End Function

    Public Enum RuleInterval
        Day
        Week
    End Enum
End Class
