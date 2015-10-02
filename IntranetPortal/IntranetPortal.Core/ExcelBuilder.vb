Imports System.IO
Imports ClosedXML
Imports Newtonsoft.Json.Linq

Public Class ExcelBuilder
    Public Shared Sub BuildBudgetReport(jsQuery As JToken, ms As MemoryStream)
        'Dim wb As New Excel.XLWorkbook
        'Dim ws = wb.Worksheets.Add("sheet1")

        'Dim header = ws.Range("A1:H1")
        'header.Cell("A1").Value = "Description"
        'header.Cell("B1").Value = "Estimate"
        'header.Cell("C1").Value = "Qty"
        'header.Cell("D1").Value = "Materials"
        'header.Cell("E1").Value = "Contract Price"
        'header.Cell("F1").Value = "Paid"
        'header.Cell("H1").Value = "Balance"
        'header.Style.Font.SetBold()

        'Dim Index = 2
        'If Not jsQuery Is Nothing Then
        '    For Each row In jsQuery.ToList
        '        Dim description = row.SelectToken("description").ToString
        '        If Not String.IsNullOrEmpty(description) Then
        '            header.Cell("A" & Index).Value = description
        '        End If

        '        Dim estimate = row.SelectToken("estimate").ToString
        '        If Not String.IsNullOrEmpty(estimate) Then
        '            header.Cell("B" & Index).Value = Double.Parse(estimate)
        '            header.Cell("B" & Index).Style.NumberFormat.Format = "$ #,##0.00"
        '        End If

        '        Dim qty = row.SelectToken("qty").ToString
        '        If Not String.IsNullOrEmpty(qty) Then
        '            header.Cell("C" & Index).Value = Integer.Parse(qty)
        '            header.Cell("C" & Index).Style.NumberFormat.NumberFormatId = 1
        '        End If

        '        Dim materials = row.SelectToken("materials").ToString
        '        If Not String.IsNullOrEmpty(materials) Then
        '            header.Cell("D" & Index).Value = Double.Parse(materials)
        '            header.Cell("D" & Index).Style.NumberFormat.Format = "$ #,##0.00"
        '        End If

        '        Dim labor = row.SelectToken("labor").ToString
        '        If Not String.IsNullOrEmpty(labor) Then
        '            header.Cell("E" & Index).Value = Double.Parse(labor)
        '            header.Cell("E" & Index).Style.NumberFormat.Format = "$ #,##0.00"
        '        End If

        '        Dim contract = row.SelectToken("contract").ToString
        '        If Not String.IsNullOrEmpty(contract) Then
        '            header.Cell("F" & Index).Value = Double.Parse(contract)
        '            header.Cell("F" & Index).Style.NumberFormat.Format = "$ #,##0.00"
        '        End If

        '        Dim paid = row.SelectToken("paid").ToString
        '        If Not String.IsNullOrEmpty(paid) Then
        '            header.Cell("F" & Index).Value = Double.Parse(paid)
        '            header.Cell("F" & Index).Style.NumberFormat.Format = "$ #,##0.00"
        '        End If

        '        header.Cell("G" & Index).FormulaA1 = "=(F" & Index & "-G" & Index & ")"
        '        header.Cell("G" & Index).Style.NumberFormat.Format = "$ #,##0.00"
        '    Next
        'End If
        'wb.SaveAs(ms)
    End Sub
End Class
