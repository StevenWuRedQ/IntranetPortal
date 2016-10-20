Imports IntranetPortal.Data

Public Class HomeownerIncentivePage
    Inherits PortalPage

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        If Not Page.IsPostBack Then

            If Not String.IsNullOrEmpty(Request.QueryString("bble")) Then
                Dim bble = Request.QueryString("bble")

                If Not Employee.HasControlLeads(Page.User.Identity.Name, bble) Then
                    Server.Transfer("/PortalError.aspx?code=1001")
                End If

                Dim search = LeadInfoDocumentSearch.GetInstance(bble)

                If search Is Nothing Then
                    divSearchWarning.Visible = True
                End If

                'If search.Status <> LeadInfoDocumentSearch.SearchStauts.Completed Then
                '    Server.Transfer("/PortalError.aspx?code=1004")
                'End If

                Dim record = IntranetPortal.Data.PreSignRecord.GetInstanceByBBLE(bble)

                If record IsNot Nothing Then
                    Response.Redirect("/NewOffer/HomeownerIncentive.aspx?model=View&Id=" & record.Id)
                End If
            End If

            If Not String.IsNullOrEmpty(Request.QueryString("Id")) Then
                Dim id = Request.QueryString("Id")
                Dim record = IntranetPortal.Data.PreSignRecord.GetInstance(id)

                ' check user permission
                If record IsNot Nothing Then
                    If Not Employee.GetManagedEmployees(Page.User.Identity.Name).Contains(record.Owner) Then
                        linkEdit.Visible = False
                    End If
                End If
            End If
        End If
    End Sub

End Class