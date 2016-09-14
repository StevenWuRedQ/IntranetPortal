Imports System.Text
Imports Microsoft.VisualStudio.TestTools.UnitTesting
Imports IntranetPortal.Core
Imports Newtonsoft.Json.Linq

<TestClass()>
Public Class DBUtilTest

    Dim jstr As String
    Dim jobj As JObject

    <TestInitialize>
    Public Sub beforeEach()
        jstr = <![CDATA[
            {

            "A": "value1",
            "B": "value2"
            
           }
        ]]>.Value
        jobj = JObject.Parse(jstr)
    End Sub



    <TestMethod>
    Public Sub testReplaceField()
        DBJSONUtil.ReplaceField(jobj, "A", "C")
        Assert.IsTrue(jobj("C").ToString = "value1")
    End Sub


    <TestMethod>
    Public Sub testReplace1AndUpdate2()
        DBJSONUtil.Replace1AndUpdate2(jobj, "A", "B", "C")
        Assert.IsTrue(jobj("C").ToString = "true")
        Assert.IsTrue(jobj("B").ToString = "value1")
        Assert.IsTrue(jobj("A") Is Nothing)
    End Sub
End Class
