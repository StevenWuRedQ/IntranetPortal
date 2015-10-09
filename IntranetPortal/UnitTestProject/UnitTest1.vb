Imports System.IO
Imports System.Net
Imports System.Text
Imports Microsoft.VisualStudio.TestTools.UnitTesting

<TestClass()> Public Class CheckingComplaintsTest

    <TestMethod()>
    Public Sub NotifyEmailMethod1()

        Dim svr = New IntranetPortal.PortalDataService
        svr.ComplaintsUpdatedNotify(IntranetPortal.Data.CheckingComplain.Instance("1000163028"))

    End Sub

    <TestMethod()>
    Public Sub Writetest()
        Dim stream = HttpWebRequest.Create("http://www.jerseysnflnba.com/image/data/nfl.jpg").GetResponse.GetResponseStream
        stream.CopyTo(File.Open("D:\test.jpg", FileMode.OpenOrCreate, FileAccess.Write))
        ' no exception throw
        Assert.IsTrue(True)
    End Sub
End Class