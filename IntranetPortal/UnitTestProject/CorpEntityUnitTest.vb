Imports System.Text
Imports Microsoft.VisualStudio.TestTools.UnitTesting
Imports IntranetPortal
Imports IntranetPortal.Data


''' <summary>
''' The corporation entity Unit test
''' </summary>
<TestClass()> Public Class CorpEntityUnitTest

    Dim bble As String = "4089170024 "
    Dim team As String = "TomTeam"
    Dim address As String = "80-70 87 ROAD, WOODHAVEN,NY 11421"

    ''' <summary>
    ''' Testing Corp Save function
    ''' Check Auditlog data
    ''' Check the assign out days
    ''' Check Status change from Assigned Out to Available
    ''' </summary>
    <TestMethod()> Public Sub SaveCorp_returnCorp()
        Dim corp = CorporationEntity.GetAvailableCorp(team, False)
        Assert.AreEqual("Available", corp.Status)
        Assert.AreEqual(team, corp.Office)
        corp.AssignCorp(bble, address, "UnitTest")

        Assert.AreEqual("Assigned Out", corp.Status)
        Assert.AreEqual(address, corp.PropertyAssigned)
        Assert.AreEqual(1, corp.AssignedOutDays)
        Dim logs = AuditLog.GetLogs("CorporationEntity", corp.EntityId)
        Assert.IsTrue(logs.Count > 0)
        Assert.IsTrue(logs.Any(Function(a) a.ColumnName = "Status" AndAlso a.OriginalValue = "Available" AndAlso a.NewValue = "Assigned Out"))
        corp.Status = "Available"
        corp.Save("UnitTest")
    End Sub

    ''' <summary>
    ''' GetAvailableCorp testing
    ''' </summary>
    <TestMethod()> Public Sub GetAvailableCorp_returnAvailableCorp()
        Dim corp = CorporationEntity.GetAvailableCorp(team, False)

        Assert.AreEqual("Available", corp.Status)
        Assert.AreEqual(team, corp.Office)
    End Sub

    ''' <summary>
    ''' GetTeamAvailableCorps testing
    ''' </summary>
    <TestMethod()> Public Sub GetTeamAvailableCorps_returnSignerArray()
        Dim corps = CorporationEntity.GetTeamAvailableCorps(team)
        For Each corp In corps
            Assert.AreEqual("Available", corp.Status)
            Assert.AreEqual(team, corp.Office)
        Next
    End Sub

    <TestMethod>
    Public Sub TestLowCorpEmail_SendEmailWithCount()
        CorpManage.CheckAvailableCorp("GaliTeam")
    End Sub

    <TestMethod>
    Public Sub TestNotifyCorpIsAssigned_SendEmail()
        Dim li = LeadsInfo.GetInstance(bble)
        Dim corp = CorporationEntity.GetAvailableCorp(team, False)

        CorpManage.NotifyCorpIsAssigned(li, corp, "GaliTeam")
    End Sub

    ''' <summary>
    ''' AssignCorp testing
    ''' </summary>
    <TestMethod()> Public Sub AssignCorp_returnAssignedCorp()

        Dim li = LeadsInfo.GetInstance(BBLE)

        Dim corp = CorporationEntity.GetAvailableCorp(team, False)

        Dim address = "116-55 Queens Blvd"
        corp.AssignCorp(bble, address, "UnitTest")

        corp = CorporationEntity.GetEntity(corp.EntityId)

        Assert.AreEqual(corp.BBLE, bble)
        Assert.AreEqual(address, corp.PropertyAssigned)
        Assert.AreEqual("Assigned Out", corp.Status)

        corp.Status = "Available"
        corp.BBLE = Nothing
        corp.Save("UnitTest")
    End Sub

End Class