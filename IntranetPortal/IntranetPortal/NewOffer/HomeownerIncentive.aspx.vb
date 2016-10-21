Imports IntranetPortal.Data

Public Class HomeownerIncentivePage
    Inherits LeadsBasePage

    Protected Overrides Sub LoadLeadsData(bble As String)
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
    End Sub

    Protected Overrides Sub LoadWithoutLeadsData()
        If Not String.IsNullOrEmpty(Request.QueryString("Id")) Then
            Dim id = Request.QueryString("Id")
            Dim record = IntranetPortal.Data.PreSignRecord.GetInstance(id)

            ' check user permission
            If record IsNot Nothing Then
                If Not Employee.GetManagedEmployees(UserName).Contains(record.Owner) Then
                    linkEdit.Visible = False
                End If
            End If
        Else
            'If Not PageAuthorization Then
            '    Server.Transfer("/PortalError.aspx?code=1001")
            'End If
        End If
    End Sub
End Class