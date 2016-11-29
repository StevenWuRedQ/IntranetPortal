Imports System.Text
Imports Microsoft.VisualStudio.TestTools.UnitTesting

<TestClass()> Public Class DialerRuleTest

    <TestMethod()> Public Async Function TestMethod1() As Task
        Dim dialerapi As New IntranetPortal.Data.DialerService
        Await dialerapi.ExportList("e358b71a-e908-4da3-9201-ca0dcbef9d8a", True)
    End Function

End Class