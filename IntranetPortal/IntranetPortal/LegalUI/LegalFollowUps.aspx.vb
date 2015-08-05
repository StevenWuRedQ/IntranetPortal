Public Class LegalFollowUps
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If (Not IsPostBack) Then
            BindGrid()
        End If
    End Sub
    Sub BindGrid()
        Dim mCases = IntranetPortal.Legal.LegalCase.GetFollowUpCases

        gdCases.DataSource = mCases
        gdCases.DataBind()
    End Sub

    Protected Sub gdCases_DataBinding(sender As Object, e As EventArgs)

        If (gdCases.DataSource Is Nothing) Then
            BindGrid()
        End If
    End Sub

    Protected Sub lbExportExcel_Click(sender As Object, e As EventArgs)
        CaseExporter.WriteXlsxToResponse()
    End Sub

    Protected Sub gdCases_RowDeleting(sender As Object, e As DevExpress.Web.Data.ASPxDataDeletingEventArgs)
        Dim bble = e.Keys("BBLE")
        LegalCaseManage.ClearFollowUp(bble)

        e.Cancel = True
        BindGrid()
    End Sub
End Class