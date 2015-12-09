Imports System.Text
Imports Microsoft.VisualStudio.TestTools.UnitTesting
Imports IntranetPortal.Core

<TestClass()> Public Class WebGrabberTest

    <TestMethod()>
    Public Sub TestHPD()
        Dim WebGrabber = New WebGrabber
        WebGrabber.GetHPDInfo()
        Assert.IsTrue(True)
    End Sub

End Class