Imports System.IO
Imports ClosedXML
Imports ClosedXML.Excel
Imports Newtonsoft.Json.Linq

Public Class ExcelBuilder
    Public Shared Property XLColor As XLColor

    Public Shared Function BuildBudgetReport(jsQuery As JToken) As Byte()
        Using ms As New MemoryStream
            Dim wb As New Excel.XLWorkbook
            Dim ws = wb.Worksheets.Add("sheet1")

            Dim header = ws.Range("A1:H1")
            header.Cell("A1").Value = "Description"
            header.Cell("D1").Value = "Materials"
            header.Cell("E1").Value = "Labor"
            header.Cell("F1").Value = "Contract Price"
            header.Cell("G1").Value = "Paid"
            header.Cell("H1").Value = "Balance"
            header.Style.Font.SetBold()

            Dim Index = 2
            If Not jsQuery Is Nothing Then
                For Each row In jsQuery.ToList
                    Dim description = row.SelectToken("description").ToString
                    If Not String.IsNullOrEmpty(description) Then
                        ws.Cell("A" & Index).Value = description
                    End If

                    Dim materials = row.SelectToken("materials").ToString
                    If Not String.IsNullOrEmpty(materials) Then
                        ws.Cell("B" & Index).Value = Double.Parse(materials)
                        ws.Cell("B" & Index).Style.NumberFormat.Format = "$ #,##0.00"
                    End If

                    Dim labor = row.SelectToken("labor").ToString
                    If Not String.IsNullOrEmpty(labor) Then
                        ws.Cell("C" & Index).Value = Double.Parse(labor)
                        ws.Cell("C" & Index).Style.NumberFormat.Format = "$ #,##0.00"
                    End If

                    Dim contract = row.SelectToken("contract").ToString
                    If Not String.IsNullOrEmpty(contract) Then
                        ws.Cell("D" & Index).Value = Double.Parse(contract)
                        ws.Cell("D" & Index).Style.NumberFormat.Format = "$ #,##0.00"
                    End If

                    Dim paid = row.SelectToken("paid").ToString
                    If Not String.IsNullOrEmpty(paid) Then
                        ws.Cell("E" & Index).Value = Double.Parse(paid)
                        ws.Cell("E" & Index).Style.NumberFormat.Format = "$ #,##0.00"
                    End If

                    ws.Cell("F" & Index).FormulaA1 = "=(F" & Index & "-G" & Index & ")"
                    ws.Cell("F" & Index).Style.NumberFormat.Format = "$ #,##0.00"

                    Index = Index + 1
                Next
            End If

            If Index > 1 Then
                ws.Cell("A" & Index).Value = "Total"
                ws.Cell("D" & Index).FormulaA1 = "=SUM(F2:D" & (Index - 1) & ")"
                ws.Cell("D" & Index).Style.NumberFormat.Format = "$ #,##0.00"
                ws.Cell("E" & Index).FormulaA1 = "=SUM(G2:E" & (Index - 1) & ")"
                ws.Cell("E" & Index).Style.NumberFormat.Format = "$ #,##0.00"
                ws.Cell("F" & Index).FormulaA1 = "=SUM(H2:F" & (Index - 1) & ")"
                ws.Cell("F" & Index).Style.NumberFormat.Format = "$ #,##0.00"

                Dim TotalRange = ws.Range("A" & Index & ":F" & Index)
                TotalRange.Style.Fill.BackgroundColor = XLColor.Yellow

            End If
            wb.SaveAs(ms)
            Return ms.ToArray
        End Using
    End Function
End Class
