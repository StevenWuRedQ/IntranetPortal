Imports System.Text
Imports Microsoft.VisualStudio.TestTools.UnitTesting
Imports IntranetPortal.Core

<TestClass()> Public Class QueryBuilderTest

    <TestMethod()>
    Public Sub GenerateScript()
        Dim json = <string>
                         [
                               {
                                  "name":"NAME",
                                  "table":"ShortSaleCases",
                                  "column":"CaseName",
                                  "type":"string",
                                  "$$hashKey":"object:66",
                                  "checked":true,
                                  "filters":[
                                     {
                                        "criteria": "2",
                                        "value": "",
                                        "query": "",
                                        "$$hashKey": "object:386",
                                        "WhereTerm": "CreateCompare",
                                        "CompareOperator": "Like",
                                        "value1": "%sfs",
                                        "input1": "sfs"
                                     }
                                  ]
                               },
                               {
                                  "name":"DOB",
                                  "table":"PropertyBaseInfo",
                                  "column":"Block",
                                  "type":"date",
                                  "$$hashKey":"object:67",
                                  "checked":true,
                                  "filters":[
                                     {
                                        "criteria": "2",
                                        "value": "",
                                        "query": "",
                                        "$$hashKey": "object:382",
                                        "WhereTerm": "CreateCompare",
                                        "CompareOperator": "Greater",
                                        "value1": "09/22/2015",
                                        "input1": "09/22/2015"
                                     }
                                  ]
                               },
                               {
                                  "name":" Lot",
                                  "table":"PropertyBaseInfo",
                                  "column":"Lot",
                                  "type":" number",
                                  "$$hashKey":" object:68",
                                  "checked":true,
                                  "filters":[
                                     {
                                        "criteria": "5",
                                        "value": "",
                                        "query": "",
                                        "$$hashKey": "object:379",
                                        "WhereTerm": "CreateBetween",
                                        "CompareOperator": "",
                                        "value1": "22",
                                        "value2": "33",
                                        "input1": "22",
                                        "input2": "33"
                                     }
                                  ]
                               },{
                                    "name": "Mail Address",
                                    "table": "PropertyBaseInfo",
                                    "column": "MailAddress",
                                    "type": "list",
                                    "options": [ "1", "2", "3" ],
                                    "$$hashKey": "object:90",
                                    "checked": true,
                                    "filters": [
                                      {
                                        "criteria": "",
                                        "value": "",
                                        "query": "",
                                        "$$hashKey": "object:365",
                                        "input1": [ "1", "2" ],
                                        "WhereTerm": "CreateIn",
                                        "CompareOperator": "",
                                        "value1": [ "1", "2" ]
                                      }
                                    ]
                                  }
                            ]
                   </string>

        Dim qb As New QueryBuilder
        Dim sql = qb.BuildSelectQuery(json, "ShortSaleCases")
        Debug.Print(sql)
        Assert.IsInstanceOfType(sql, GetType(String))
    End Sub

    <TestMethod()>
    Public Sub ExecuteQueryTest()
        Dim sql = "SELECT * FROM Employees"
        Dim qb As New QueryBuilder
        Dim dt = qb.ExecuteQuery(sql)
        Assert.IsInstanceOfType(dt, GetType(DataTable))
        Assert.IsTrue(dt.Rows.Count > 0)
    End Sub

    <TestMethod()>
    Public Sub LoadReportDataTest()
        Dim json = jsonQuery

        Dim qb As New QueryBuilder
        Dim dt = qb.LoadReportData(json, "ShortSaleCases")
        Assert.IsInstanceOfType(dt, GetType(DataTable))
        Assert.IsTrue(dt.Rows.Count > 0)
    End Sub

    <TestMethod()>
    Public Sub CustomReportTest()
        Dim currentUser = "Chris Yan"

        Dim report As New CustomReport
        report.Name = "Test"
        report.Description = "this is test report."
        report.Save(currentUser)
        Assert.IsTrue(report.ReportId > 0)
        Assert.AreEqual(report.Owner, currentUser)

        report = CustomReport.Instance(report.ReportId)
        report.Name = "Test2"
        report.Save(currentUser)
        Assert.AreEqual(report.UpdateBy, "Chris Yan")

        report = CustomReport.Instance(report.ReportId)
        Assert.AreEqual(report.Name, "Test2")

        report.Delete()
        report = CustomReport.Instance(report.ReportId)
        Assert.IsNull(report)
    End Sub

    <TestMethod()>
    Public Sub CustomReportQueryDataTest()
        Dim currentUser = "Chris Yan"

        Dim report As New CustomReport
        report.Name = "Test"
        report.Description = "this is test report."
        report.Query = jsonQuery
        report.BaseTable = "ShortSaleCases"
        Dim dt = report.QueryData()
        Assert.IsTrue(dt.Rows.Count > 0)
    End Sub

    <TestMethod()>
    Public Sub GenerateReportTeamplateTest()
        Dim qb As New QueryBuilder
        Dim js = qb.GenerateReportTemplate("SSSecondMortgage", {"BBLE", "MortgageId", "CaseId"})
        Assert.IsTrue(js.Count > 0)

        Dim tables = <string>
                         [
                            {
                                "name": "LegalJTaxLienStatus",
                                "ignoreFields": ["BBLE"]
                            }
                         ]
                     </string>
        Dim template = qb.GenerateReportTemplate(tables)
        Assert.IsTrue(template.Length > 0)
    End Sub

    Private jsonQuery As String = <string>
                         [
                               {
                                  "name":"NAME",
                                  "table":"ShortSaleCases",
                                  "column":"CaseName",
                                  "type":"string",
                                  "$$hashKey":"object:66",
                                  "checked":true,
                                  "filters":[
                                     {
                                        "criteria": "2",
                                        "value": "",
                                        "query": "",
                                        "$$hashKey": "object:386",
                                        "WhereTerm": "CreateCompare",
                                        "CompareOperator": "Like",
                                        "value1": "%122%",
                                        "input1": "sfs"
                                     }
                                  ]
                               }
                        ]
                   </string>
End Class