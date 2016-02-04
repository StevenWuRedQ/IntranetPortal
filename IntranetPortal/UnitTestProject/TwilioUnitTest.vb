Imports System.Text
Imports Microsoft.VisualStudio.TestTools.UnitTesting
Imports IntranetPortal.Data

<TestClass()> Public Class TwilioUnitTest

    <TestMethod()> Public Sub SendMessage_ReturnRID()
        Dim client As New TwilioClient
        Dim result = client.SendMessge("+19179633481", "this is test twilio message.")

        Assert.IsNotNull(result)
    End Sub

End Class