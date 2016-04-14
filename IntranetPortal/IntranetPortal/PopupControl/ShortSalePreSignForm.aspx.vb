Public Class ShortSalePreSignForm
    Inherits System.Web.UI.Page

    Public Property CorpData As IntranetPortal.Data.CorporationEntity

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        If Not Page.IsPostBack Then
            If Request.QueryString("bble") IsNot Nothing Then

                Dim bble = Request.QueryString("bble").ToString

                If Not PropertyOfferManage.CheckPreConditions(bble) Then
                    Server.Transfer("/PortalError.aspx?code=1002")
                Else
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