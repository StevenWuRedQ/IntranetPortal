Imports System.Text
Imports Microsoft.VisualStudio.TestTools.UnitTesting
Imports IntranetPortal.Core

<TestClass()> Public Class QueryBuilderTest

    <TestMethod()>
    Public Sub GenerateScript()

        Dim qb As New QueryBuilder
        Dim sql = qb.BuildSelectQuery()
        Debug.Print(sql)
        Assert.IsInstanceOfType(sql, GetType(String))
    End Sub

End Class