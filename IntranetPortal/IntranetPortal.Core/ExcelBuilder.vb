Imports System.IO
Imports ClosedXML
Imports ClosedXML.Excel
Imports Newtonsoft.Json.Linq

Public Class ExcelBuilder

    Public Shared Function BuildBudgetReport(jsQuery As JToken, template As MemoryStream) As Byte()
        Dim BBLE = jsQuery.SelectToken("BBLE").ToString
        Dim Data = jsQuery.SelectToken("updata").ToObject(Of BudgetRow())

        Using ms As New MemoryStream
            Dim wb As New Excel.XLWorkbook(template)
            Dim ws = wb.Worksheet("CHECK REQUEST")

            wb.SaveAs(ms)
            Return ms.ToArray
        End Using
    End Function

    Class BudgetRow
        Public balance As Double
        Public contract As Double
        Public toDay As Double
        Public paid As Double
    End Class
End Class
