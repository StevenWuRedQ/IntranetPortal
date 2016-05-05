Imports System.Text
Imports Microsoft.VisualStudio.TestTools.UnitTesting
Imports IntranetPortal.Data

<TestClass()> Public Class DeedCorpUnitTest
    Dim team = "GukasyanTeam"
    Dim corpId = 1
    Dim bble = "4025010109"

    <TestMethod()> Public Sub GetTeamCorps_ReturnCorpArray()

        Dim corps = DeedCorp.GetTeamDeedCorps(team)
        Assert.IsTrue(corps.Count > 0)

        For Each cp In corps
            Assert.AreEqual(team, cp.Office)
        Next
    End Sub

    <TestMethod()> Public Sub GetNextAvailableCorps_ReturnCorp()

        Dim corp = DeedCorp.GetNextAvailableCorp

        Assert.IsNotNull(corp)

        Dim corps = DeedCorp.GetDeedCorps().Select(Function(dc)
                                                       dc.LoadProperties()
                                                       Return dc
                                                   End Function).OrderBy(Function(dc) dc.Properties.Count)

        corp.LoadProperties()

        Assert.AreEqual(corp.EntityId, corps(0).EntityId)

        Assert.AreEqual(corp.Properties.Count, corps(0).Properties.Count)
    End Sub

    ''' <summary>
    ''' Assign property Test
    ''' </summary>
    <TestMethod()> Public Sub AssignProperty_CheckPropertySigned()

        Dim corp = DeedCorp.GetDeedCorp(corpId)

        If corp.Properties.Any(Function(a) a.BBLE.Trim = bble) Then
            Dim AssignedProp = corp.Properties.Where(Function(pr) pr.BBLE.Trim = bble).FirstOrDefault
            AssignedProp.Delete()
        End If

        corp.AssignProperty(bble, "Test")

        corp = DeedCorp.GetDeedCorp(corpId)

        Assert.IsTrue(corp.Properties.Any(Function(a) a.BBLE.Trim = bble))

        If corp.Properties.Any(Function(a) a.BBLE = bble) Then

            Dim AssignedProp = corp.Properties.Where(Function(pr) pr.BBLE = bble).FirstOrDefault
            AssignedProp.Delete()
        End If

    End Sub

End Class