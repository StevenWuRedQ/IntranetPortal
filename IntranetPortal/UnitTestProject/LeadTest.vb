Imports IntranetPortal

<TestClass()>
Public Class LeadTest

    <TestMethod()>
    Public Sub SubStatus_Test()
        Dim ld As New Lead
        ld.SubStatus = CType(LeadSubStatus.LoanModCompleted, Integer)
        ld.SubStatus = LeadSubStatus.LoanModCompleted
        If ld.SubStatus = LeadSubStatus.LoanModCompleted Then
            Assert.AreEqual(True, True)
        End If
        Assert.AreEqual(ld.SubStatusStr, "LoanMod Completed")
    End Sub

    <TestMethod()>
    Public Sub GetCustomStatus_StatusArray()
        Dim ls = Utility.GetLeadsCustomStatus()
        Assert.IsTrue(ls.Count > 0)
    End Sub

    <TestMethod()>
    Public Sub GetLeadsStatus_StatusArray()
        Dim ls = Utility.GetLeadStatus("LoanMod")
        Assert.AreEqual(Of LeadStatus)(ls, LeadStatus.LoanMod)

        ls = Utility.GetLeadStatus("Warm")
        Assert.AreEqual(Of LeadStatus)(ls, LeadStatus.Warm)
    End Sub

    <TestMethod()>
    Public Sub GetLoanModLeads_leadsArray()
        Dim lds = Lead.GetLoanModDue("Chris Yan", Nothing, New Date(2016, 12, 1))
        Assert.IsTrue(lds.Count > 1)
    End Sub

    <TestMethod()>
    Public Sub GetPriorityLeads_leadsArray()
        Dim count = Lead.GetUserLeadsData("Chris Yan", LeadStatus.Priority).Count
        Dim lds = Lead.GetHotLeadsDue("Chris Yan", New Date(2016, 12, 1))
        Assert.AreEqual(lds.Count, count)
    End Sub

    <TestMethod()>
    Public Sub TestAddress2BBLE()
        Dim bble = IntranetPortal.Core.Utility.Address2BBLE("515 Wilson Ave, Brooklyn  NY 11221")
        Assert.AreEqual(bble, "3033980006")
    End Sub

    <TestMethod()>
    Public Sub ClearSharedUserTest()
        Dim bble = "3047790022"
        Dim sharedUser = "Chris Yan"

        Dim ld = IntranetPortal.Lead.GetInstance(bble)
        ld.AddSharedUser(sharedUser, "Unit Test")

        Assert.IsTrue(ld.SharedUsers.Count > 0)
        Assert.IsTrue(ld.SharedUsers.Contains(sharedUser))

        ld.ClearSharedUser()
        Assert.IsTrue(ld.SharedUsers.Count = 0)
    End Sub

    <TestMethod()>
    Public Sub RefreshMortgageDataTest()
        Dim bble = "2022860035 "
        Dim result = DataWCFService.UpdateLeadInfo(bble, False, True, False, False, False, False, False)
        Assert.IsTrue(result)
    End Sub

    <TestMethod()>
    Public Sub LPAPITest()
        Dim bble = "2022860035 "
        Dim result = DataWCFService.GetLiensInfo(bble)
        Assert.IsTrue(result.Count > 0)
        Dim lp = result.First
        Assert.AreEqual("382738-09", lp.Docket_Number)

    End Sub

    <TestMethod()>
    Public Sub LeadViewableTest()
        Dim bble = "2037130013 "
        Dim ld = Lead.GetInstance(bble)

        Dim viewable = ld.IsViewable("Michael Gali")
        Assert.IsTrue(viewable)
    End Sub

    <TestMethod()>
    Public Sub UserInRoleTest()
        Dim name = "Elizabeth Rodriguez"

        Dim inrole2 = Utility.IsUserInRoleGroup(name, {"test", "Entity-*"})
        ''Dim inRole = System.Web.Security.Roles.IsUserInRole(name, "Entity-*")
        Assert.IsTrue(inrole2)
    End Sub

    ''' <summary>
    ''' The function test for check Leads Creation Limit, 
    ''' temparory set the team limitation is 1 per day
    ''' </summary>
    <TestMethod()>
    Public Sub LeadsCreationLimitFunction_returnOverLimit()
        Dim userName = "Michael Gali"
        Dim bble = "2037130013"
        Dim limit = CInt(IntranetPortal.Core.PortalSettings.GetValue("LeadsCreatedLimit"))

        IntranetPortal.Core.PortalSettings.SetValue("LeadsCreatedLimit", 1)

        Dim teamName = UserInTeam.GetUserTeam(userName)
        Assert.AreEqual(teamName, "GaliTeam")
        Assert.IsFalse(LeadManage.OverUserCreateLimit(userName))

        Dim log = LeadsStatusLog.AddNew(bble, LeadsStatusLog.LogType.CreateNew, userName, userName, Nothing)
        Dim log2 = LeadsStatusLog.AddNew(bble, LeadsStatusLog.LogType.CreateNew, userName, userName, Nothing)

        Dim tm = Team.GetTeam(teamName)
        Assert.IsTrue(tm.GetTeamCreateLeadsCount(DateTime.Today, DateTime.Today.AddDays(1)) > 0)
        Assert.IsTrue(LeadManage.OverUserCreateLimit(userName))

        log.Delete()
        log2.Delete()

        IntranetPortal.Core.PortalSettings.SetValue("LeadsCreatedLimit", limit)
    End Sub

    ''' <summary>
    ''' Check the start recyle process
    ''' </summary>
    <TestMethod> Public Sub StartRecycleProcess_returnNull()
        Dim bble = "1000251493 "
        RecycleManage.ExpireRecycles(bble)
        Dim ld = Lead.GetInstance(bble)
        ld.ReAssignLeads("Steven Wu")
        ld.StartRecycleProcess()
        Dim rc = RecycleManage.GetRecycledLead(bble)
        Assert.IsNotNull(rc)
    End Sub

    ''' <summary>
    ''' Test recyle action, the leads will move to lead pool.
    ''' </summary>
    <TestMethod> Public Sub Recycle_LeadsPool()
        Dim bble = "1000251493 "
        Dim ld = Lead.GetInstance(bble)
        ld.Recycle("testing")
        ld = Lead.GetInstance(bble)
        Assert.AreEqual(ld.EmployeeName, Lead.GetHotPoolUser().Name)
    End Sub

    <TestMethod> Public Sub NewLeadsRule_Recycle()
        Dim bble = "1000251493 "
        Dim ld = Lead.GetInstance(bble)
        ld.ReAssignLeads("Chris Yan")
        ld.AssignDate = New DateTime(2016, 10, 1)
        ld.Status = LeadStatus.NewLead
        ld.EmployeeName = "Chris Yan"
        IntranetPortal.RulesEngine.LeadsEscalationRule.Execute(ld)
        ld = Lead.GetInstance(bble)
        Assert.AreEqual(ld.EmployeeName, Lead.GetMainPooluser().Name)
    End Sub

    <TestMethod> Public Sub WarmLeadsRule_Recycle()
        Dim bble = "1000251493 "
        Dim ld = Lead.GetInstance(bble)
        ld.ReAssignLeads("Chris Yan")
        ld.AssignDate = New DateTime(2016, 10, 1)
        ld.Status = LeadStatus.Warm
        ld.EmployeeName = "Chris Yan"
        IntranetPortal.RulesEngine.LeadsEscalationRule.Execute(ld)
        ld = Lead.GetInstance(bble)
        Assert.AreEqual(ld.EmployeeName, Lead.GetMainPooluser().Name)
    End Sub

    <TestMethod> Public Sub PriorityLeadsRule_CreateRecycle()
        Dim bble = "1000251493 "
        RecycleManage.ExpireRecycles(bble)

        Dim ld = Lead.GetInstance(bble)
        ld.ReAssignLeads("Chris Yan")
        ld.AssignDate = New DateTime(2016, 10, 1)
        ld.Status = LeadStatus.Priority
        ld.EmployeeName = "Chris Yan"
        IntranetPortal.RulesEngine.LeadsEscalationRule.Execute(ld)
        Dim rc = RecycleManage.GetRecycledLead(bble)
        Assert.IsNotNull(rc)
    End Sub

    <TestMethod> Public Sub RecyclePostpone_returnTrue()
        Dim bble = "1000251493 "
        Dim rc = RecycleManage.GetRecycledLead(bble)
        rc.PostponeDays(15)
        rc = RecycleManage.GetRecycledLead(bble)
        Assert.IsTrue(rc.Status = Core.RecycleLead.RecycleStatus.Postponed)
    End Sub

    <TestMethod> Public Sub ExpiredRecycleWhenLeadsMoveToInProcess_returnTrue()
        Dim bble = "1000251493 "
        Dim ld = Lead.GetInstance(bble)
        ld.UpdateStatus2(LeadStatus.InProcess)
        Dim rc = RecycleManage.GetRecycledLead(bble)

        If rc Is Nothing Then
            PriorityLeadsRule_CreateRecycle()
        End If

        Dim rule As New RulesEngine.RecycleProcessRule
        rule.ExecuteRecycle(rc)
        rc = Core.RecycleLead.GetInstance(rc.RecycleId)
        Assert.AreEqual(rc.Status, CInt(Core.RecycleLead.RecycleStatus.Expired))
        ld.UpdateStatus2(LeadStatus.NewLead)
    End Sub

    <TestMethod>
    <ExpectedException(GetType(Exception))>
    Public Sub LeadsTaskRule_ReturnNothing()
        Dim rule As New RulesEngine.LeadsAndTaskRule
        Dim data = Core.PortalSettings.GetValue("LeadsRuleStartDate")
        Core.PortalSettings.SetValue("LeadsRuleStartDate", "Test")
        rule.Execute()
    End Sub

    ''' <summary>
    ''' Check the limitation for users not in agent team
    ''' </summary>
    <TestMethod> Public Sub LeadsCreationLimitFunction_NoLimitAdmin()

        Dim name = "Chris Yan"
        Assert.IsFalse(LeadManage.OverUserCreateLimit(name))

        name = "Michael Kay"
        Assert.IsFalse(LeadManage.OverUserCreateLimit(name))

    End Sub
    ''' <summary>
    ''' Adds the given number of business days to the <see cref="DateTime"/>.
    ''' </summary>
    ''' <param name="current">The date to be changed.</param>
    ''' <param name="days">Number of business days to be added.</param>
    ''' <returns>A <see cref="DateTime"/> increased by a given number of business days.</returns>

    Public Shared Function AddBusinessDays(current As DateTime, days As Integer) As DateTime
        Dim sign = Math.Sign(days)
        Dim unsignedDays = Math.Abs(days)
        For i As Integer = 0 To unsignedDays - 1
            Do
                current = current.AddDays(sign)
            Loop While current.DayOfWeek = DayOfWeek.Saturday OrElse current.DayOfWeek = DayOfWeek.Sunday
        Next
        Return current
    End Function
    ' test new leads recycel rule
    <TestMethod>
    Public Sub NewLeadsRecycleRulesTest()
        Dim mockLead = New Lead()
        Dim txtChrisYan = "Chris Yan"
        Dim mockEmp = Employee.GetInstance(txtChrisYan)

        mockLead.BBLE = "8000000001"
        mockLead.EmployeeName = mockEmp.Name
        mockLead.EmployeeID = mockEmp.EmployeeID
        Using mockEntity As New Entities

            MockDB.MockLead(mockEntity, mockLead,
                            Function()
                                ' test in assgin new leads 6 days
                                Dim sixBussinessDaysBefore = AddBusinessDays(DateTime.Now, 6)
                                mockLead.AssignDate = sixBussinessDaysBefore
                                mockLead.Status = LeadStatus.NewLead
                                mockEntity.SaveChanges()

                                RulesEngine.LeadsEscalationRule.Execute(mockLead)
                                Dim ld = Lead.GetInstance(mockLead.BBLE)
                                Assert.AreEqual(ld.EmployeeName, txtChrisYan)

                                ' update test leads assign date to 7 business days before
                                Dim sevenBussinessDaysBefore = AddBusinessDays(DateTime.Now, -7).AddHours(-1)
                                mockLead.AssignDate = sevenBussinessDaysBefore
                                mockEntity.SaveChanges()
                                RulesEngine.LeadsEscalationRule.Execute(mockLead)
                                ld = Lead.GetInstance(mockLead.BBLE)

                                Assert.AreEqual(ld.EmployeeName, Lead.GetMainPooluser().Name)
                                'assign date should update to today
                                Assert.AreEqual(Day(ld.AssignDate), Day(Date.Now))

                                ' update test lead assign date to 8 bussiness days before
                                Dim eightBussinessDaysBefore = AddBusinessDays(DateTime.Now, -8)
                                mockLead.AssignDate = eightBussinessDaysBefore
                                mockEntity.SaveChanges()

                                RulesEngine.LeadsEscalationRule.Execute(mockLead)
                                ld = Lead.GetInstance(mockLead.BBLE)
                                Assert.AreEqual(ld.EmployeeName, Lead.GetMainPooluser().Name)
                                ' assign date should update to today
                                Assert.AreEqual(CDate(ld.AssignDate).ToShortDateString, Date.Now.ToShortDateString())
                                ' assign to new leads folder 
                                ' it's not spec if this line do not pass can commemt line below
                                Assert.IsTrue(ld.Status = LeadStatus.NewLead)

                                Return 0
                            End Function)

        End Using

    End Sub

    ' warm leads recycel rule
    <TestMethod>
    Public Sub WarmLeadsRecycleRulesTest()
        Dim mockLead = New Lead()
        Dim txtChrisYan = "Chris Yan"
        Dim mockEmp = Employee.GetInstance(txtChrisYan)

        mockLead.BBLE = "8000000001"
        mockLead.EmployeeName = mockEmp.Name
        mockLead.EmployeeID = mockEmp.EmployeeID
        Using mockEntity As New Entities

            MockDB.MockLead(mockEntity, mockLead,
                            Function()

                                ' 19 bussiness days before now
                                Dim m19BussinessDaysBefore = AddBusinessDays(DateTime.Now, -19)
                                mockLead.AssignDate = m19BussinessDaysBefore
                                mockLead.Status = LeadStatus.Warm
                                mockEntity.SaveChanges()
                                ' do nothing
                                RulesEngine.LeadsEscalationRule.Execute(mockLead)
                                Dim ld = Lead.GetInstance(mockLead.BBLE)
                                Assert.AreEqual(ld.EmployeeName, txtChrisYan, "in 19 days shold be stay in warm lead folder")

                                ' 20 bussiness days before now
                                Dim m20BussinessDaysBefore = AddBusinessDays(DateTime.Now, -20).AddHours(-1)
                                mockLead.AssignDate = m20BussinessDaysBefore
                                mockEntity.SaveChanges()
                                ' if lead assgin before 20 days assgin to main pool
                                RulesEngine.LeadsEscalationRule.Execute(mockLead)
                                ld = Lead.GetInstance(mockLead.BBLE)
                                ' lead move  to main pool
                                Assert.AreEqual(ld.EmployeeName, Lead.GetMainPooluser().Name, "Should move to lead main pool")
                                Assert.AreEqual(Day(ld.AssignDate), Day(Date.Now), "Move to main pool should date should be now")

                                Return 0
                            End Function)

        End Using

    End Sub


    ''' <summary>
    ''' loan mod recycel rule test
    ''' </summary>
    <TestMethod>
    Public Sub HotLeadRecycleRuleTest()
        Dim mockLead = New Lead()
        mockLead.BBLE = "8000000001"
        mockLead.Status = LeadStatus.Priority
        Dim testEmp = Employee.GetInstance("Chris Yan")
        mockLead.EmployeeID = testEmp.EmployeeID
        mockLead.EmployeeName = testEmp.Name
        mockLead.AssignBy = "testing"
        ' assigned 100 days ago
        mockLead.AssignDate = DateTime.Now.AddDays(-100)
        Dim statusLog = New LeadsStatusLog()
        statusLog.Type = LeadsStatusLog.LogType.StatusChange
        statusLog.Employee = testEmp.Name
        statusLog.BBLE = mockLead.BBLE
        statusLog.CreateBy = "testing"
        ' change to hot leads
        statusLog.Description = "1"
        clearRecycleLeads(mockLead.BBLE)

        Using mockEntity As New Entities

            MockDB.Mock(Of LeadsStatusLog)(mockEntity, statusLog,
                                           Function()

                                               MockDB.Mock(Of Lead)(mockEntity, mockLead,
                                                                    Function()

                                                                        RecycleManage.ExpireRecycles(mockLead.BBLE)
                                                                        ' staying hot leads 12 days 
                                                                        statusLog.CreateDate = AddBusinessDays(Date.Now, -12)
                                                                        mockEntity.SaveChanges()
                                                                        RulesEngine.LeadsEscalationRule.Execute(mockLead)
                                                                        Dim ld = Lead.GetInstance(mockLead.BBLE)
                                                                        ' @todo check if the employee don't have manager
                                                                        Dim rl = RecycleManage.GetRecycledLead(mockLead.BBLE)
                                                                        Assert.IsNull(rl, "the lead stay in hot leads in 12 days the leads should not be recycle")

                                                                        ' lead staying hot leads 13 days
                                                                        statusLog.CreateDate = AddBusinessDays(Date.Now, -13).AddHours(-1)
                                                                        mockEntity.SaveChanges()
                                                                        RulesEngine.LeadsEscalationRule.Execute(mockLead)

                                                                        ld = Lead.GetInstance(mockLead.BBLE)

                                                                        rl = RecycleManage.GetRecycledLead(mockLead.BBLE)

                                                                        Dim rlId = rl.RecycleId

                                                                        Assert.IsNotNull(rl, "lead stay in hot leads in 13 days the leads should be recycle")

                                                                        ' lead staying hot lead 14 days
                                                                        ' lead arleady exist in recycle lead
                                                                        statusLog.CreateDate = AddBusinessDays(Date.Now, -14).AddHours(-1)
                                                                        mockEntity.SaveChanges()
                                                                        RulesEngine.LeadsEscalationRule.Execute(mockLead)
                                                                        ld = Lead.GetInstance(mockLead.BBLE)
                                                                        rl = RecycleManage.GetRecycledLead(mockLead.BBLE)
                                                                        Assert.IsNotNull(rl, "lead stay in hot leads in 14 days and leads recyceld once should stay in recycle")

                                                                        Assert.AreEqual(rlId, rl.RecycleId, "Hot lead recycel reminder only set once")

                                                                        Return 0
                                                                    End Function,
                                                              Function(x) x.BBLE = mockLead.BBLE ' clear leads        
                                               )

                                               Return 0
                                           End Function,
                                           Function(x) x.BBLE = mockLead.BBLE ' clear leads 
                                           )
        End Using

        clearRecycleLeads(mockLead.BBLE)

    End Sub
    Private Sub clearRecycleLeads(BBLE As String)
        Using ctx As New Core.CoreEntities

            Dim rls = ctx.RecycleLeads.Where(Function(x) x.BBLE = BBLE)
            If (rls.Any()) Then
                ctx.RecycleLeads.RemoveRange(rls)
            End If
            ctx.SaveChanges()
        End Using
    End Sub
    <TestMethod>
    Sub MockDbTest()

        ' 
        ' MockDB.Ctx(ctx).Mock(Of LeadsStatusLog)(statusLog).Test()
    End Sub

End Class
