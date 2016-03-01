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
        Assert.IsTrue(tm.LeadsCreateLimit >= 0)
        Assert.IsTrue(tm.OverLimitation(-1))

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