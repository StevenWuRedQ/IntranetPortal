Imports System.Text
Imports Microsoft.VisualStudio.TestTools.UnitTesting

<TestClass()> Public Class CheckingComplaintsTest

    <TestMethod()>
    Public Sub NotifyEmailMethod1()

        Dim svr = New IntranetPortal.PortalDataService
        svr.ComplaintsUpdatedNotify(IntranetPortal.Data.CheckingComplain.Instance("1000163028"))

    End Sub

End Class