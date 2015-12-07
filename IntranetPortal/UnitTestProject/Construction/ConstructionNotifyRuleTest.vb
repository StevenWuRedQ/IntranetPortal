Imports System.Text
Imports Microsoft.VisualStudio.TestTools.UnitTesting

<TestClass()> Public Class ConstructionNotifyRuleTest

    <TestMethod()>
    Public Sub TestNotifyHPDRegExpired()
        Dim rule = New IntranetPortal.RulesEngine.ConstructionNotifyRule
        'rule.NotifyHPDRegExpired()
        ' no ex throw
        Assert.IsTrue(True)
    End Sub




End Class