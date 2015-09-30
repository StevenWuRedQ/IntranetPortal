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
                                        "criteria":"1",
                                        "value":"sss",
                                        "query":" Like  'sss%' ",
                                        "$$hashKey":"object:339"
                                     }
                                  ]
                               },
                               {
                                  "name":"Block",
                                  "table":"PropertyBaseInfo",
                                  "column":"Block",
                                  "type":"date",
                                  "$$hashKey":"object:67",
                                  "checked":true,
                                  "filters":[
                                     {
                                        "criteria":"1",
                                        "value":"09/07/2015",
                                        "query":" '09/07/2015' ",
                                        " $$hashKey":" object:342"
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
                                        " criteria":" 5",
                                        " value":" 111",
                                        " query":" BETWEEN 111 AND 222",
                                        " $$hashKey":" object:346",
                                        " value2":" 222"
                                     }
                                  ]
                               }
                            ]
                   </string>

        Dim qb As New QueryBuilder
        Dim sql = qb.BuilderSelectQuery(json, "ShortSaleCases")
        Debug.Print(sql)
        Assert.IsInstanceOfType(sql, GetType(String))
    End Sub

End Class