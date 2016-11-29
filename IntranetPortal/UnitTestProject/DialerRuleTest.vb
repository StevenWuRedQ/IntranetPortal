Imports System.Text
Imports Microsoft.VisualStudio.TestTools.UnitTesting

<TestClass> Public Class DialerRuleTest

    <TestMethod> Public Async Function TestMethod1() As Task
        Dim dialerrule As New IntranetPortal.RulesEngine.DialerRule
        Await dialerrule.DownloadContactListExportCSV("4de28bcd-d5de-4cbb-a7c1-303dd0cbbd0e")
    End Function

End Class