Imports IntranetPortal.Data
Imports DevExpress.XtraPrinting

Public Class ShortSaleReport
    Inherits PortalPage


    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        AllLeadsGrid.DataSource = ShortSaleCase.CaseReport2(CurrentAppId)
        AllLeadsGrid.DataBind()

    End Sub

    'Public Function GetDescrition(ssCase As ShortSaleCase) As String
    '    If ssCase IsNot Nothing Then
    '        Dim sb As New StringBuilder
    '        sb.Append("Investor: " & ssCase.GetMortageType(0) & Environment.NewLine)

    '        If ssCase.ValueInfoes IsNot Nothing AndAlso ssCase.ValueInfoes.Count > 0 Then
    '            Dim val = ssCase.ValueInfoes(0)
    '            sb.Append("Date of Valuation: " & String.Format("{0:d}", val.DateOfValue) & Environment.NewLine)
    '            sb.Append("Expiration Date of Value: " & String.Format("{0:d}", val.ExpiredOn) & Environment.NewLine)
    '            sb.Append("Value: " & String.Format("{0:C}", val.BankValue) & Environment.NewLine)
    '        End If

    '        Return sb.ToString
    '    End If

    '    Return Nothing
    '    'Expiration Date of Value: 8/22/2015
    '    'Value:  PENDING()
    '    'Date Offer Submitted: 
    '    'Offer:
    '    '        Lender Counter
    '    '        Counter Submitted
    '    '        Current Status : BPO Completed
    '    'Documents Missing: N/A
    '    'Start Intake: N/A 
    '    'Update/Notes:
    '    '"

    'End Function

    Protected Sub Unnamed_ServerClick(sender As Object, e As EventArgs)
        gridExport.FileName = String.Format("All-{0}-{1}-{2}.xlsx", Today.Month, Today.Day, Today.Year)
        gridExport.WriteXlsxToResponse()
    End Sub
End Class