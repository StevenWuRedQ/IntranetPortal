Imports Newtonsoft.Json.Linq

Public Class Transfer2Legal
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

    End Sub

    Protected Sub TransfterButon_Click(sender As Object, e As EventArgs)
        If (String.IsNullOrEmpty(BBLELists.Text)) Then
            TransfterStauts.Text = "Please in put BBLE json list"
            Return
        End If
        Dim BBLEs = JArray.Parse(BBLELists.Text)

        For Each bble In BBLEs
            Dim legalCase = IntranetPortal.Data.LegalCase.GetCase(bble)
            If (legalCase Is Nothing) Then
                LegalCaseManage.StartLegalRequest(bble, "{}", Page.User.Identity.Name)
                LeadsActivityLog.AddActivityLog(Date.Now, "Transfter Leads to Legal", bble, LeadsActivityLog.LogCategory.Legal.ToString)
            End If
        Next
        TransfterStauts.Text = "Transftered"
    End Sub
End Class