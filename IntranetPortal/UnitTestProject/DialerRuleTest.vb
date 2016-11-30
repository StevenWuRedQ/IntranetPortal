Imports System.Text
Imports Microsoft.VisualStudio.TestTools.UnitTesting
Imports IntranetPortal

<TestClass()> Public Class DialerRuleTest

    <TestMethod()> Public Async Function TestMethod1() As Task
        Dim dialerapi As New IntranetPortal.Data.DialerService
        Await dialerapi.ExportListDetail("4de28bcd-d5de-4cbb-a7c1-303dd0cbbd0e", False)
    End Function

    <TestMethod()> Public Sub TestInitContact()
        Dim ld = Lead.GetInstance("1000251493")
        Dim result = DialerServiceManage.InitContact(ld)
        Assert.IsNotNull(result)
        Assert.IsNotNull(result.OwnerPhone1)
    End Sub

End Class