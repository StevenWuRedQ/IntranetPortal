Imports IntranetPortal.Data

Public Class HomeownerIncentivePage
    Inherits LeadsBasePage

    Protected Overrides Sub LoadLeadsData(bble As String)
        Dim record = IntranetPortal.Data.PreSignRecord.GetInstanceByBBLE(bble)

        If record IsNot Nothing Then
            'Response.Redirect("/NewOffer/test.aspx?model=View&Id=" & record.Id)
            Response.Redirect("/NewOffer/HomeownerIncentive.aspx#/preassign/view/" & record.Id)
        End If
    End Sub

    Protected Overrides Sub LoadWithoutLeadsData()
        If Not String.IsNullOrEmpty(Request.QueryString("Id")) Then
            Dim id = Request.QueryString("Id")
            Dim record = IntranetPortal.Data.PreSignRecord.GetInstance(id)

            ' check user permission
            If record IsNot Nothing Then
                If Not Employee.GetManagedEmployees(UserName).Contains(record.Owner) Then
                    ' linkEdit.Visible = False
                End If
            End If
        Else

        End If
    End Sub
End Class