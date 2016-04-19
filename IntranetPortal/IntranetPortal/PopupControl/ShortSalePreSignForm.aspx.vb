Imports IntranetPortal.Data

Public Class ShortSalePreSignForm
    Inherits System.Web.UI.Page

    Public Property CorpData As IntranetPortal.Data.CorporationEntity

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        If Not Page.IsPostBack Then
            If Request.QueryString("bble") IsNot Nothing Then

                Dim bble = Request.QueryString("bble").ToString

                Dim record = PreSignRecord.GetInstanceByBBLE(bble)
                If record Is Nothing Then
                    Server.Transfer("/PortalError.aspx?code=1002")
                End If

                If record.NeedSearch Then
                    Dim search = LeadInfoDocumentSearch.GetInstance(bble)
                    If search Is Nothing Then
                        Server.Transfer("/PortalError.aspx?code=1003")
                    End If

                    If search.Status <> LeadInfoDocumentSearch.SearchStauts.Completed Then
                        Server.Transfer("/PortalError.aspx?code=1004")
                    Else
                        SearchCompleted.Value = True
                    End If
                    NeedSearch.Value = True
                End If

                Dim offer = PropertyOffer.GetOffer(bble)
                If offer.Status = PropertyOffer.OfferStatus.Completed Then
                    Dim Corp = IntranetPortal.Data.CorporationEntity.GetCorpByBBLE(bble)
                    If Corp IsNot Nothing Then
                        CorpData = Corp
                        content.Visible = False
                        divMsg.Visible = True
                    End If
                End If
            End If
        End If
    End Sub
End Class