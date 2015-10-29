Imports System.IO
Imports ClosedXML.Excel
Imports Newtonsoft.Json.Linq


Public Class ExcelBuilder

    Public Shared Function BuildBudgetReport(address As String, owner As String, budgetData As BudgetRow(), fs As Stream) As Byte()

        Using wb = New XLWorkbook(fs)
            Dim ws = wb.Worksheet("CHECK REQUEST")
            ws.Cell("B3").Value = owner
            ws.Cell("B5").Value = "Construction"
            ws.Cell("B7").Value = DateTime.Now
            Dim index = 10

            For Each row In budgetData
                If (index <= 35) Then
                    ws.Cell("A" & index).Value = address
                    ws.Cell("B" & index).Value = row.contract
                    ws.Cell("C" & index).Value = row.toDay
                    ws.Cell("D" & index).Value = row.paid
                    ws.Cell("G" & index).Value = row.description
                    index = index + 1
                Else
                    ws.Cell("A" & index).InsertCellsAbove(1)
                    ws.Cell("A" & index).Value = address
                    ws.Cell("B" & index).Value = row.contract
                    ws.Cell("C" & index).Value = row.toDay
                    ws.Cell("D" & index).Value = row.paid
                    ws.Cell("G" & index).Value = row.description
                    index = index + 1
                End If

            Next

            Using ms As New MemoryStream
                wb.SaveAs(ms)
                Return ms.ToArray
            End Using
        End Using

    End Function

    Public Shared Function BuildTitleReport(json As JObject) As Byte()
        Using ms As New MemoryStream

        End Using
    End Function
    Class BudgetRow
        Public balance As Double
        Public contract As Double
        Public toDay As Double
        Public paid As Double
        Public description As String
    End Class
End Class
