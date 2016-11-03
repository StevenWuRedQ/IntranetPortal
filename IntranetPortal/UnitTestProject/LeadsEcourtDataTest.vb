Imports System.Text
Imports Microsoft.VisualStudio.TestTools.UnitTesting
Imports IntranetPortal.Data

<TestClass()> Public Class LeadsEcourtDataTest

    <TestMethod()>
    Public Sub GetUnSyncLeads_returnBBLEs()
        Dim bbles = LeadsEcourtData.GetUnSyncLeads
        Assert.IsNotNull(bbles)
        Assert.IsTrue(bbles.Length > 0)
    End Sub

    <TestMethod()>
    Public Sub UpdateByChanges_returnNothing()
        Dim dtStart = New DateTime(2016, 10, 26)
        Dim dtEnd = dtStart.AddDays(1)

        LeadsEcourtData.UpdateByChanges(dtStart, dtEnd, "unittest")
    End Sub

    <TestMethod()>
    Public Sub UpdateNewCases_returnNothing()
        Dim dtStart = New DateTime(2016, 10, 27)
        Dim dtEnd = dtStart.AddDays(1)
        LeadsEcourtData.AddNewCases(dtStart, dtEnd)
    End Sub

    <TestMethod()>
    Public Sub DailyUpdate_returnNothing()
        LeadsEcourtData.DailyUpdate()
        Dim lastUpdate = LeadsEcourtData.GetLastUpdateTime
        Assert.IsTrue(lastUpdate > DateTime.MinValue)
    End Sub

End Class