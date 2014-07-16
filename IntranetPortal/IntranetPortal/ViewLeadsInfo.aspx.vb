Public Class ViewLeadsInfo
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not String.IsNullOrEmpty(Request.QueryString("id")) Then
            LeadsInfo.BindData(Request.QueryString("id"))

            If Not Page.ClientScript.IsStartupScriptRegistered("SetleadBBLE") Then
                Dim cstext1 As String = "<script type=""text/javascript"">" & _
                                String.Format("var leadsInfoBBLE = ""{0}"";", Request.QueryString("id")) & "</script>"
                Page.ClientScript.RegisterStartupScript(Me.GetType, "SetleadBBLE", cstext1)
            End If

            If Not Page.ClientScript.IsClientScriptBlockRegistered("OnEndCallback") Then
                Dim js As String = "<script type=""text/javascript"">" & _
                                   "function OnEndCallback() {}" & _
                                   "</script>"
                Page.ClientScript.RegisterClientScriptBlock(Me.GetType, "OnEndCallback", js)
            End If
        End If
    End Sub
End Class