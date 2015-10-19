<TestClass()>
Public Class EmployeeTest

    <TestMethod()>
    Public Sub GetCurrentAppId()
        Dim appId = IntranetPortal.Employee.CurrentAppId
        Assert.AreEqual(Of Integer)(appId, 1)
    End Sub

    <TestMethod>
    Public Sub TestLegalCaseRelateUser()
        Dim el = IntranetPortal.LegalCaseManage.GetCaseRelateUsers("3037220024")
        Assert.IsTrue(el IsNot Nothing)
    End Sub

End Class
