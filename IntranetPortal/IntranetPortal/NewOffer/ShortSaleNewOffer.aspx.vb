Imports IntranetPortal.Data

Public Class ShortSaleNewOfferPage
    Inherits System.Web.UI.Page

    Public Property CorpData As IntranetPortal.Data.CorporationEntity

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        If Not Page.IsPostBack Then
            If Request.QueryString("bble") IsNot Nothing Then

                Dim bble = Request.QueryString("bble").ToString

                ' check the if HOI exsited or not 
                Dim record = PreSignRecord.GetInstanceByBBLE(bble)
                If record Is Nothing Then
                    Server.Transfer("/PortalError.aspx?code=1002")
                End If

                ' check offer status
                Dim offer = PropertyOffer.GetOffer(bble)
                If offer IsNot Nothing AndAlso offer.Status = PropertyOffer.OfferStatus.Completed Then
                    Dim Corp = IntranetPortal.Data.CorporationEntity.GetCorpByBBLE(bble)
                    If Corp IsNot Nothing Then
                        CorpData = Corp
                        Content.Visible = False
                        divMsg.Visible = True

                        Return
                    End If
                End If

                ' check doc search status, show Search Tab if Doc search is completed
                Dim search = LeadInfoDocumentSearch.GetInstance(bble)
                If (search IsNot Nothing) Then
                    If search.Status = LeadInfoDocumentSearch.SearchStauts.Completed Then
                        txtSearchCompleted.Value = True
                        NeedSearch.Value = True
                        DivLeadTaxSearchCtrl.Visible = True
                    End If
                End If
            End If
        End If
    End Sub
End Class