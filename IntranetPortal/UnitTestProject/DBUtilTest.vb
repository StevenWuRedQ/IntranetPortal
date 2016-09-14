Imports System.Text
Imports Microsoft.VisualStudio.TestTools.UnitTesting
Imports IntranetPortal.Core
Imports Newtonsoft.Json.Linq
Imports IntranetPortal.Data

<TestClass()>
Public Class DBUtilTest

    Dim jstr As String
    Dim jobj As JObject

    <TestInitialize>
    Public Sub beforeEach()
        jstr = <![CDATA[
            {

            "A": "value1",
            "B": "value2",

            
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

    <TestMethod>
    Public Sub testMapTo()
        Dim ostr = DBJSONUtil.MapTo(jstr, "D:/TasksWebApplication/IntranetPortal/IntranetPortal/App_Data/test.csv")
        Dim oobj = JObject.Parse(ostr)
        Assert.IsTrue(oobj("D").ToString = "value1")
        Assert.IsTrue(oobj("E").ToString = "true")
        Assert.IsTrue(oobj("C").ToString = "value2")
    End Sub

    <TestMethod>
    Public Sub ConvertDocSearchVersion()
        Using ctx As New PortalEntities
            Dim data = From l In ctx.LeadInfoDocumentSearches
                       Where l.Version Is Nothing

            For Each d In data



                d.LeadResearch = DBJSONUtil.MapTo(d.LeadResearch, "D:/TasksWebApplication/IntranetPortal/IntranetPortal/App_Data/docsearchmap.csv")
                d.Version = 1
            Next

            ctx.SaveChanges()
        End Using
    End Sub
End Class
