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
                Dim search = LeadInfoDocumentSearch.GetInstance(bble)

                If record.NeedSearch Then

                    If search Is Nothing Then
                        Server.Transfer("/PortalError.aspx?code=1003")
                    End If

                    If search.Status <> LeadInfoDocumentSearch.SearchStauts.Completed Then
                        Server.Transfer("/PortalError.aspx?code=1004")

                    End If
                    NeedSearch.Value = True
                End If
                If (search IsNot Nothing) Then
                    If search.Status = LeadInfoDocumentSearch.SearchStauts.Completed Then
                        txtSearchCompleted.Value = True
                    End If
                End If
                
                Dim offer = PropertyOffer.GetOffer(bble)
                If offer IsNot Nothing AndAlso offer.Status = PropertyOffer.OfferStatus.Completed Then
                    Dim Corp = IntranetPortal.Data.CorporationEntity.GetCorpByBBLE(bble)
                    If Corp IsNot Nothing Then
                        CorpData = Corp
                        content.Visible = False
                        divMsg.Visible = True
                    End If 
                End If

                If ((Not String.IsNullOrEmpty(NeedSearch.Value)) OrElse (Not String.IsNullOrEmpty(txtSearchCompleted.Value))) Then
                    DivLeadTaxSearchCtrl.Visible = True
                End If

            End If
        End If
    End Sub
End Class