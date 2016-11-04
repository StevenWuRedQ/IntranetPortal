Imports IntranetPortal
Imports System.Web.Security
Imports Newtonsoft.Json.Linq
Imports Newtonsoft.Json

<TestClass()>
Public Class EmployeeTest

    <TestMethod()>
    Public Sub GetCurrentAppId()
        Dim appId = IntranetPortal.Employee.CurrentAppId
        Assert.AreEqual(Of Integer)(appId, 1)
    End Sub

    <TestMethod>
    Public Sub TestLegalCaseRelateUser()
        Dim el = IntranetPortal.LegalCaseManage.GetCaseRelateUsers("3037220024")
        Assert.IsTrue(el IsNot Nothing)
    End Sub

    <TestMethod>
    Public Sub GetUserRoles_ReturnRolesWithStar()
        Dim roles = System.Web.Security.Roles.GetRolesForUser("Michael Kay")
        Assert.IsTrue(roles.Contains("ShortSale-*"))

        roles = System.Web.Security.Roles.GetRolesForUser("Michael Gali")
        Assert.IsTrue(roles.Contains("OfficeManager-*"))
    End Sub

    <TestMethod>
    Public Sub GetDeptUsersList_ReturnEmployee()
        Dim result = Employee.GetDeptUsersList("GaliTeam", True)
        Assert.IsFalse(result.Any(Function(a) a.Name = "Crystal Dixon"))

        result = Employee.GetDeptUsersList("GaliTeam", False)
        Assert.IsTrue(result.Any(Function(a) a.Name = "Crystal Dixon"))
    End Sub

    <TestMethod>
    Public Sub GetTeamUsersArray_returnUserList()
        Dim result = UserInTeam.GetTeamUsersArray("GaliTeam")
        Assert.IsFalse(result.Contains("Crystal Dixon"))

        For Each user In result
            Assert.IsTrue(Employee.GetEmpTeams(user).Contains("GaliTeam"))
        Next

        result = UserInTeam.GetTeamUsersArray("GaliTeam", True)
        Assert.IsTrue(result.Contains("Crystal Dixon"))
    End Sub

    Dim deptName = "TomTeam"
    <TestMethod>
    Public Sub GetAllDeptUser_returnAllUsers()
        Dim users = Employee.GetDeptUsers(deptName, False)
        Dim users2 = Employee.GetAllDeptUsers(deptName)
        Assert.AreEqual(11, users.Length)
        Assert.AreEqual(11, users2.Length)
    End Sub

    <TestMethod>
    Public Sub GetActiveDeptUser_returnActiveUsers()
        Dim users = Employee.GetDeptUsersList(deptName, False)
        Dim users2 = Employee.GetDeptUsers(deptName)
        Assert.AreEqual(7, users2.Count)
        Assert.AreEqual(7, users.Where(Function(em) em.Active = True).Count)
    End Sub

    <TestMethod>
    Public Sub GetNonActiveDeptUser_returnNonActiveUsers()
        Dim users = Employee.GetDeptUsersList(deptName, False)
        Dim nonActiveUsers = Employee.GetDeptUnActiveUserList(deptName)
        Assert.AreEqual(4, nonActiveUsers.Count)
        Assert.AreEqual(4, users.Where(Function(em) em.Active = False).Count)
    End Sub

    <TestMethod>
    Public Sub GetMyEmployeesByTeam_returnEmployees()
        Dim userName = "Michael Gali"


        Dim users1 = Employee.GetMyEmployeesByTeam(userName).Select(Function(ut) ut.EmployeeName).OrderBy(Function(ut) ut).ToArray
        Dim users2 = UserInTeam.GetTeamUsersArray("GaliTeam").OrderBy(Function(ut) ut).ToArray

        Assert.IsTrue(users1.SequenceEqual(users2))

        Dim ui = New UsersInRole
        ui.Rolename = "OfficeManager-TomTeam"
        ui.Username = userName
        ui.Add()

        users1 = Employee.GetMyEmployeesByTeam(userName).Select(Function(ut) ut.EmployeeName).OrderBy(Function(ut) ut).ToArray
        ui.Delete()
        Dim users2List = users2.ToList
        users2List.AddRange(UserInTeam.GetTeamUsersArray("TomTeam"))
        users2 = users2List.Distinct.OrderBy(Function(ut) ut).ToArray

        Assert.IsTrue(users1.SequenceEqual(users2))

        Assert.IsFalse(ui.IsExsit)
    End Sub

    <TestMethod>
    Public Sub GetEmloyeeEmailTest()
        Dim a As String = ""
        a = Nothing
        Dim emails = Employee.GetEmpsEmails(a)


        Assert.IsTrue(String.IsNullOrEmpty(emails))
        Dim chris = Employee.GetInstance("Chris Yan")
        Dim steven = Employee.GetInstance("xsxxx")
        emails = Employee.GetEmpsEmails(chris, steven)
        Assert.IsFalse(String.IsNullOrEmpty(emails))

        emails = Employee.GetEmpsEmails(steven)
        Assert.IsTrue(String.IsNullOrEmpty(emails))
    End Sub
    <TestMethod>
    Public Sub CryptoPasswordTest()
        Dim e = New Employee()
        Dim testPassword = "Hello wolrd!"
        e.Password = testPassword
        ' not crypto yet the verify password should not equal
        Assert.IsFalse(e.VerifyPassword(testPassword))

        Dim hash = e.CryptoPasswrod(e.Password)
        ' check hello world md5 crypto if you change the password it may not pass this unit test
        ' run CryptoPasswrod function and copy test crypto password to here
        Assert.AreEqual(hash, "52e7a4e9de7dc90f7eb53d67c2d79547")
        e.ChangePassword(testPassword)
        Assert.AreEqual(hash, e.Password)
        ' after change password it should pass verify password
        Assert.IsTrue(e.VerifyPassword(testPassword))
    End Sub

    ' by steven
    ' if our code have data proivder layer or we have mock database
    ' we don't need this
    ' mock test leads will delete it automatically
    ' Func(Of Void, Void) not working now will do research later
    Private Shared Sub MockLeads(mockCtx As Entities, mLead As Lead, mCount As Integer, testFunc As Func(Of Integer, Integer))
        Dim ls = New Lead(mCount) {}
        Dim jlead = mLead.ToJsonString()
        Dim i = 0
        For Each lt In ls
            ls(i) = JsonConvert.DeserializeObject(Of Lead)(jlead)
            Dim ld = ls(i)

            ' BBLE start at 8 may never used BBLE 
            ' If there Then is any error ask Chris when changed 
            ' BBLE after this
            ld.BBLE = CStr(8000151131 + i)
            ' for safety
            ld.AssignDate = DateTime.Now()
            i = i + 1
            ' Return ld
        Next

        'Using mockCtx As New Entities
        mockCtx.Leads.AddRange(ls)
            mockCtx.Leads.Count()
            mockCtx.SaveChanges()
            ' use try catch to clear database anyway
            ' can change to goto
            Try
                testFunc(1)
            Catch ex As Exception
                ' need clear test database any way
                mockCtx.Leads.RemoveRange(ls)
                mockCtx.SaveChanges()
                Throw ex
            End Try
        mockCtx.Leads.RemoveRange(ls)
        mockCtx.SaveChanges()

        'End Using
    End Sub

    Private Sub MockLead(mockEntity As Entities, mLead As Lead, testFunc As Func(Of Integer, Integer))
        mockEntity.Leads.Add(mLead)
        mockEntity.SaveChanges()
        Try
            testFunc(1)
        Catch ex As Exception
            mockEntity.Leads.Remove(mLead)
            mockEntity.SaveChanges()
            Throw ex
        End Try
        mockEntity.Leads.Remove(mLead)
        mockEntity.SaveChanges()
    End Sub

    Private Shared Function GetLeadsCountByStatusHelper(ctx As Entities, testEmloyee As String, status As LeadStatus) As Integer
        Return ctx.Leads.Where(Function(l) l.Status = status AndAlso l.EmployeeName = testEmloyee).Count
    End Function
    ''' <summary>
    ''' test employee have loan mod or follow up count limit
    ''' </summary>
    <TestMethod>
    Public Sub LeadsLimitTest()
        Using mockEntity As New Entities()
            ' set up test data
            Dim testEmloyee = "Chris Yan"
            Dim tChrisYan = Employee.GetInstance(testEmloyee)
            Dim testLead = New Lead()
            testLead.Status = LeadStatus.Callback
            testLead.BBLE = "8900151131"
            testLead.EmployeeName = tChrisYan.Name
            testLead.EmployeeID = tChrisYan.EmployeeID ' for safety
            testLead.AssignBy = "Testing"
            ' ''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
            '  unit testing follow up limit
            ' dont care about speed in unit test so using leads
            Dim followUpLeadCount = GetLeadsCountByStatusHelper(mockEntity, testEmloyee, LeadStatus.Callback)

            If (followUpLeadCount < Employee.FOLLOW_UP_COUNT_LIMIT) Then
                Dim limitCount = Employee.FOLLOW_UP_COUNT_LIMIT - followUpLeadCount
                'test 29 leads

                MockLeads(mockEntity, testLead, limitCount - 2,
                          Function(x)
                              ' have 29 leads
                              Dim followUpNow = GetLeadsCountByStatusHelper(mockEntity, testEmloyee, LeadStatus.Callback)
                              Assert.AreEqual(followUpNow, 59)
                              ' agent have 29 follow up now leads
                              Assert.IsFalse(tChrisYan.IsAchieveFollowUpLimit())

                              ' insert other follow up leads
                              testLead.Status = LeadStatus.Callback
                              MockLead(mockEntity,
                                       testLead,
                                       Function(xx)
                                           followUpNow = GetLeadsCountByStatusHelper(mockEntity, testEmloyee, LeadStatus.Callback)

                                           Assert.AreEqual(followUpNow, 60)
                                           Assert.IsTrue(tChrisYan.IsAchieveFollowUpLimit())

                                           testLead.Status = LeadStatus.NewLead
                                           Try
                                               testLead.UpdateStatus(LeadStatus.Callback)
                                           Catch ex As Exception
                                               Assert.AreEqual(ex.Message, "Can not move to Follow Up becuase achieve to limit.")
                                           End Try

                                           Return xx
                                       End Function)

                              ' todo
                              ' it should not allow insert
                              ' Do not pass the 
                              ' Lead.UpdateStatus(LeadStatus.Callback)
                              Return x
                          End Function)
            Else
                ' test when have more than 30 hot leads
                Assert.IsTrue(followUpLeadCount >= 60)
                ' test employee achive follo up limit
                Assert.IsFalse(tChrisYan.IsAchieveFollowUpLimit())


            End If
            ' ''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''

            ' ''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
            ' unit testing follow up limit
            ' do not care about speed in unit test so using leads
            Dim loanModLeadCount = GetLeadsCountByStatusHelper(mockEntity, testEmloyee, LeadStatus.LoanMod)
            testLead.Status = LeadStatus.LoanMod
            If (loanModLeadCount < Employee.LOAN_MODS_COUNT_LIMIT) Then
                Dim limitCount = Employee.LOAN_MODS_COUNT_LIMIT - loanModLeadCount
                'test 29 leads

                MockLeads(mockEntity, testLead, limitCount - 2,
                          Function(x)
                              ' have 29 leads
                              Dim loanModNow = GetLeadsCountByStatusHelper(mockEntity, testEmloyee, LeadStatus.LoanMod)
                              Assert.AreEqual(loanModNow, 29)
                              ' agent have 29 follow up now leads

                              Assert.IsFalse(tChrisYan.IsAchieveLoanModLimit())

                              ' insert one more follow up lead
                              testLead.Status = LeadStatus.LoanMod
                              MockLead(mockEntity,
                                       testLead,
                                       Function(xx)
                                           loanModNow = GetLeadsCountByStatusHelper(mockEntity, testEmloyee, LeadStatus.LoanMod)

                                           Assert.AreEqual(loanModNow, 30)
                                           Assert.IsTrue(tChrisYan.IsAchieveLoanModLimit())

                                           testLead.Status = LeadStatus.NewLead
                                           Try
                                               testLead.UpdateStatus(LeadStatus.LoanMod)
                                           Catch ex As Exception
                                               Assert.AreEqual(ex.Message, "Can not move to Loan Mod becuase achieve to limit.")
                                           End Try

                                           Return xx
                                       End Function)

                              ' todo
                              ' it should not allow insert
                              ' Do not pass the 
                              ' Lead.UpdateStatus(LeadStatus.Callback)
                              Return x
                          End Function)
            Else
                ' when test employee loan mod leads over 30
                Assert.IsTrue(loanModLeadCount >= 30)
                Assert.IsFalse(tChrisYan.IsAchieveLoanModLimit())
            End If


        End Using



    End Sub
End Class
