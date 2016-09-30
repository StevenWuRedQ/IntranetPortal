Imports IntranetPortal.Data
Public Class LeadTaxSearchRequest
    Inherits LeadsBasePage

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

    End Sub

    Protected Overrides Sub LoadLeadsData(bble As String)
        ASPxSplitter1.GetPaneByName("listPanel").Visible = False

        Dim ld = Data.LeadInfoDocumentSearch.GetInstance(bble)
        If ld.Status = Data.LeadInfoDocumentSearch.SearchStatus.NewSearch Then
            If Not Authenticate(UserName) Then
                Server.Transfer("/PortalError.aspx?code=1001")
            End If
        Else
            If CurrentUser.Position = "Finder" Then
                Server.Transfer("/PortalError.aspx?code=1001")
            End If

            ASPxSplitter1.GetPaneByName("dataPane").Visible = False
        End If
    End Sub

    Protected Overrides Sub LoadWithoutLeadsData()
        If Not Authenticate(UserName) Then
            Server.Transfer("/PortalError.aspx?code=1001")
        End If
    End Sub

    Private Function Authenticate(name As String) As Boolean
        Dim ur = Roles.GetRolesForUser(name)
        Return ur.Any(Function(r) UserRoles.Contains(r))
    End Function

    Private UserRoles() As String = {"Entity-Manager", "Relation-Manager", "Admin"}
End Class