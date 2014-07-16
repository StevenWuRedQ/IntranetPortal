Imports DevExpress.XtraReports.UI

Public Class ActivityLogReport

    Sub BindData(id As String)

        Dim lead As New List(Of Lead)
        Using Context As New Entities
            lead = Context.Leads.Where(Function(l) l.BBLE = id).ToList
            Me.DataSource = lead
            'lblDate.DataBindings.Add("Text", lead(0).LeadsInfo, "SaleDate")

            DetailReport.DataSource = lead(0).LeadsActivityLogs

            'lblPropName.DataBindings.Add("Text", lead.LeadsInfo, "PropertyAddress")
            cellDate.DataBindings.Add("Text", Nothing, "ActivityDate", "{0:g}")

            'cellComments.DataBindings.Add("HTML", Nothing, "Comments")
            XrRichText1.DataBindings.Add("Html", Nothing, "Comments")
            cellCommentBy.DataBindings.Add("Text", Nothing, "EmployeeName")
            cellCategory.DataBindings.Add("Text", Nothing, "Category")

        End Using
    End Sub

    Private Sub XrRichText1_BeforePrint(sender As Object, e As Drawing.Printing.PrintEventArgs) Handles XrRichText1.BeforePrint
        Dim richText = CType(sender, XRRichText)
        richText.ForeColor = Drawing.Color.Red
        richText.Font = New Drawing.Font(New Drawing.FontFamily("Arial"), 5)
    End Sub

    Private Sub XrRichText1_Draw(sender As Object, e As DevExpress.XtraReports.UI.DrawEventArgs) Handles XrRichText1.Draw

    End Sub

    Private Sub DetailReport_BeforePrint(sender As Object, e As Drawing.Printing.PrintEventArgs) Handles DetailReport.BeforePrint
        Dim dr = CType(sender, DetailReportBand)
        dr.FindControl("XrRichText1", True).Font = New Drawing.Font(New Drawing.FontFamily("Arial"), 5)
    End Sub
End Class