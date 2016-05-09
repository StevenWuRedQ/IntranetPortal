Imports IntranetPortal.Data

Public Class HomeownerIncentivePage
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        If Not Page.IsPostBack Then

            If Not String.IsNullOrEmpty(Request.QueryString("bble")) Then
                Dim bble = Request.QueryString("bble")

                Dim search = LeadInfoDocumentSearch.GetInstance(bble)

                If search Is Nothing Then

                    divSearchWarning.Visible = True

                End If

                'If search.Status <> LeadInfoDocumentSearch.SearchStauts.Completed Then
                '    Server.Transfer("/PortalError.aspx?code=1004")
                'End If

                Dim record = IntranetPortal.Data.PreSignRecord.GetInstanceByBBLE(bble)

                If record IsNot Nothing Then
                    Response.Redirect("/PopupControl/PreAssignCropForm.aspx?model=View&Id=" & record.Id)
                End If

            End If
        End If
    End Sub

End Class