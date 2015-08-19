Public Class LegalSummaryUI
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If (Not IsPostBack) Then
            BindGrid()
            BindUpCommingFCGrid()
        End If
    End Sub
    Sub BindGrid()
        Dim mCases = IntranetPortal.Data.LegalCase.GetAllCases

        gdCases.DataSource = mCases
        gdCases.DataBind()
    End Sub

    Sub BindUpCommingFCGrid()
        Dim mCases = IntranetPortal.Data.LegalCaseReport.GetAllReport.Where(Function(r) r.SaleDate IsNot Nothing).ToList
        gridUpCommingFCSale.DataSource = mCases
        gridUpCommingFCSale.GroupBy(gridUpCommingFCSale.Columns("SaleDate"))
        gridUpCommingFCSale.ExpandAll()
        gridUpCommingFCSale.DataBind()
    End Sub

    Protected Sub gdCases_DataBinding(sender As Object, e As EventArgs)

        If (gdCases.DataSource Is Nothing) Then
            BindGrid()
        End If
    End Sub

    Protected Sub lbExportExcel_Click(sender As Object, e As EventArgs)
        CaseExporter.WriteXlsxToResponse()
    End Sub

    Protected Sub gridUpCommingFCSale_DataBinding(sender As Object, e As EventArgs)
        If (gridUpCommingFCSale.DataSource Is Nothing) Then
            BindUpCommingFCGrid()
        End If
    End Sub
End Class