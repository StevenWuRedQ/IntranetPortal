Public Class NewOfferTracking
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        If Not Page.IsPostBack Then
            If Request.QueryString("bble") IsNot Nothing Then
                Dim bble = Request.QueryString("bble").ToString
                Dim leadsinfodata = LeadsInfo.GetInstance(bble)
                PropertyInfo.LeadsInfoData = leadsinfodata
                PropertyInfo.LeadsData = leadsinfodata.Lead
                PropertyInfo.BindData()

                If Not Page.ClientScript.IsStartupScriptRegistered("SetleadBBLE") Then
                    Dim cstext1 As String = "<script type=""text/javascript"">" &
                                    String.Format("var leadsInfoBBLE = ""{0}"";", bble) & "</script>"
                    Page.ClientScript.RegisterStartupScript(Me.GetType, "SetleadBBLE", cstext1)
                End If

                If Not Page.ClientScript.IsClientScriptBlockRegistered("OnEndCallback") Then
                    Dim js As String = "<script type=""text/javascript"">" &
                                       "function OnEndCallback() {}" &
                                       "</script>"
                    Page.ClientScript.RegisterClientScriptBlock(Me.GetType, "OnEndCallback", js)
                End If
            End If
        End If
    End Sub

End Class