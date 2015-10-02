Imports System.IO
Imports ClosedXML
Imports Newtonsoft.Json.Linq

Public Class ExcelBuilder
    Public Shared Function BuildBudgetReport(jsQuery As JToken) As Byte()
        Using ms As New MemoryStream
            Dim wb As New Excel.XLWorkbook
            Dim ws = wb.Worksheets.Add("sheet1")

            Dim header = ws.Range("A1:H1")
            header.Cell("A1").Value = "Description"
            header.Cell("B1").Value = "Estimate"
            header.Cell("C1").Value = "Qty"
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

                    Dim estimate = row.SelectToken("estimate").ToString
                    If Not String.IsNullOrEmpty(estimate) Then
                        ws.Cell("B" & Index).Value = Double.Parse(estimate)
                        ws.Cell("B" & Index).Style.NumberFormat.Format = "$ #,##0.00"
                    End If

                    Dim qty = row.SelectToken("qty").ToString
                    If Not String.IsNullOrEmpty(qty) Then
                        ws.Cell("C" & Index).Value = Integer.Parse(qty)
                        ws.Cell("C" & Index).Style.NumberFormat.NumberFormatId = 1
                    End If

                    Dim materials = row.SelectToken("materials").ToString
                    If Not String.IsNullOrEmpty(materials) Then
                        ws.Cell("D" & Index).Value = Double.Parse(materials)
                        ws.Cell("D" & Index).Style.NumberFormat.Format = "$ #,##0.00"
                    End If

                    Dim labor = row.SelectToken("labor").ToString
                    If Not String.IsNullOrEmpty(labor) Then
                        ws.Cell("E" & Index).Value = Double.Parse(labor)
                        ws.Cell("E" & Index).Style.NumberFormat.Format = "$ #,##0.00"
                    End If

                    Dim contract = row.SelectToken("contract").ToString
                    If Not String.IsNullOrEmpty(contract) Then
                        ws.Cell("F" & Index).Value = Double.Parse(contract)
                        ws.Cell("F" & Index).Style.NumberFormat.Format = "$ #,##0.00"
                    End If

                    Dim paid = row.SelectToken("paid").ToString
                    If Not String.IsNullOrEmpty(paid) Then
                        ws.Cell("G" & Index).Value = Double.Parse(paid)
                        ws.Cell("G" & Index).Style.NumberFormat.Format = "$ #,##0.00"
                    End If

                    ws.Cell("H" & Index).FormulaA1 = "=(F" & Index & "-G" & Index & ")"
                    ws.Cell("H" & Index).Style.NumberFormat.Format = "$ #,##0.00"

                    Index = Index + 1
                Next
            End If
            wb.SaveAs(ms)
            Return ms.ToArray
        End Using
    End Function
End Class
