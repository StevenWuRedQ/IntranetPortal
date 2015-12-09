Imports System.Text
Imports Microsoft.VisualStudio.TestTools.UnitTesting
Imports IntranetPortal.Core

<TestClass()>
Public Class DBUtilTest

    <TestMethod()>
    Public Sub TestGetPrimayKey()
        Try
            Dim result = DBJSONUtil.GetPrimayKey("TitleCase")
            Assert.AreEqual(result(0), "BBLE")
        Catch ex As Exception
            Assert.IsFalse(True, ex.StackTrace.ToString)
        End Try

    End Sub

End Class
