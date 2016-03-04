Imports System.Text
Imports Microsoft.VisualStudio.TestTools.UnitTesting
Imports IntranetPortal

''' <summary>
''' Unit Test for Team object
''' </summary>
<TestClass()> Public Class TeamUnitTest
    Dim teamName As String = "GaliTeam"
    Dim userName = "Michael Gali"
    Dim bble = "2037130013"

    ''' <summary>
    ''' Regression for GetUserTeam function, check all the user in given team.
    ''' </summary>
    <TestMethod> Public Sub GetUserTeam_returnTeamName()
        Dim tm = Team.GetTeam(teamName)

        For Each name In tm.AllUsers
            Assert.AreEqual(teamName, UserInTeam.GetUserTeam(name))
        Next

        Dim mgr = tm.Manager

        Assert.AreEqual(teamName, UserInTeam.GetUserTeam(mgr))

        Assert.IsNull(UserInTeam.GetUserTeam("ddd"))
    End Sub


    ''' <summary>
    ''' The unit test for overlimitation function, should return true given limitation is -1
    ''' </summary>
    <TestMethod()> Public Sub OverLimitation_returnTrue()
        Dim tm = Team.GetTeam(teamName)
        tm.LeadsCreateLimit = 0
        Assert.IsTrue(tm.OverLimitation(tm.LeadsCreateLimit))

    End Sub

    ''' <summary>
    ''' The unit test for different limit setting for different team, should return team's limit
    ''' </summary>
    <TestMethod()> Public Sub MultipleTeamLimitation_returnLimitation()
        Dim bble = "2037130013"
        Dim galiTeam = Team.GetTeam(teamName)
        galiTeam.LeadsCreateLimit = 2
        Dim tomTeam = Team.GetTeam("TomTeam")
        tomTeam.LeadsCreateLimit = 1

        Dim galiUser = galiTeam.ActiveUsers(0)
        Dim tomUser = tomTeam.ActiveUsers(0)

        Dim log1 = LeadsStatusLog.AddNew(bble, LeadsStatusLog.LogType.CreateNew, galiUser, galiUser, Nothing)
        Dim log2 = LeadsStatusLog.AddNew(bble, LeadsStatusLog.LogType.CreateNew, tomUser, tomUser, Nothing)

        Assert.IsFalse(galiTeam.OverLimitation())
        Assert.IsFalse(tomTeam.OverLimitation())

        Dim log3 = LeadsStatusLog.AddNew(bble, LeadsStatusLog.LogType.CreateNew, galiUser, galiUser, Nothing)
        Dim log4 = LeadsStatusLog.AddNew(bble, LeadsStatusLog.LogType.CreateNew, tomUser, tomUser, Nothing)

        Assert.IsFalse(galiTeam.OverLimitation())
        Assert.IsTrue(tomTeam.OverLimitation())

        Dim log5 = LeadsStatusLog.AddNew(bble, LeadsStatusLog.LogType.CreateNew, galiUser, galiUser, Nothing)
        Assert.IsTrue(galiTeam.OverLimitation)

        log1.Delete()
        log2.Delete()
        log3.Delete()
        log4.Delete()
        log5.Delete()
    End Sub

    ''' <summary>
    ''' The unit test for GetTeamCreateLeadsCount, 
    ''' the return count should greate than zero and equal to amount in database
    ''' </summary>
    <TestMethod()> Public Sub GetTeamCreateLeadsCount_returnNumber()
        Dim tm = Team.GetTeam(teamName)
        Dim count = tm.GetTeamCreateLeadsCount(DateTime.Today, DateTime.Today.AddDays(1))
        Dim log = LeadsStatusLog.AddNew(bble, LeadsStatusLog.LogType.CreateNew, userName, userName, Nothing)
        Assert.AreEqual(count + 1, tm.GetTeamCreateLeadsCount(DateTime.Today, DateTime.Today.AddDays(1)))
        log.Delete()
    End Sub

End Class