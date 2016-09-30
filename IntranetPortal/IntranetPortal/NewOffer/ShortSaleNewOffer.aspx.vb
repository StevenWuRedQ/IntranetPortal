Imports IntranetPortal.Data

Public Class ShortSaleNewOfferPage
    Inherits LeadsBasePage

    Public Property CorpData As IntranetPortal.Data.CorporationEntity

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

    End Sub

    Protected Overrides Sub LoadLeadsData(bble As String)
        MyBase.LoadLeadsData(bble)

        ' check the if HOI exsited or not 
        Dim record = PreSignRecord.GetInstanceByBBLE(bble)
        If record Is Nothing Then
            Server.Transfer("/PortalError.aspx?code=1002")
        End If

        ' check offer status
        Dim offer = PropertyOffer.GetOffer(bble)

        ' check user permission
        If offer IsNot Nothing AndAlso Not PropertyOfferManage.IsManager(UserName) Then
            If Not Employee.GetControledDeptEmployees(UserName).Contains(offer.LeadsOwner) Then
                Server.Transfer("/NewOffer/NewOfferPreview.aspx?bble=" & bble)
            End If
        End If

        If offer IsNot Nothing AndAlso offer.Status = PropertyOffer.OfferStatus.Completed Then
            Dim Corp = IntranetPortal.Data.CorporationEntity.GetCorpByBBLE(bble)
            If Corp IsNot Nothing Then
                CorpData = Corp
                content.Visible = False
                divMsg.Visible = True
                Return
            End If
        End If

        ' check doc search status, show Search Tab if Doc search is completed
        Dim search = LeadInfoDocumentSearch.GetInstance(bble)
        If (search IsNot Nothing) Then
            If search.Status = LeadInfoDocumentSearch.SearchStatus.Completed Then
                txtSearchCompleted.Value = True
                NeedSearch.Value = True
                DivLeadTaxSearchCtrl.Visible = True
            End If
        End If
    End Sub

    Protected Overrides Sub LoadWithoutLeadsData()
        If Request.QueryString("model") IsNot Nothing Then
            If Request.QueryString("model") = "List" Then

            End If
        Else
            Server.Transfer("/PortalError.aspx?code=1001")
        End If
    End Sub

    Protected Sub btnEdit_Click(sender As Object, e As EventArgs)
        content.Visible = True
        divMsg.Visible = False
    End Sub
End Class