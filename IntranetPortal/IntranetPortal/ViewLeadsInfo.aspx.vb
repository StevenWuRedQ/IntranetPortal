Public Class ViewLeadsInfo
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not String.IsNullOrEmpty(Request.QueryString("id")) Then
            Dim bble = Request.QueryString("id").ToString

            If Not Employee.HasControlLeads(User.Identity.Name, bble) Then
                Response.Clear()
                Response.Write("You are not allowed to view this lead.")
                Response.End()
                Return
            End If

            LeadsInfo.BindData(Request.QueryString("id"))
            If Not Page.ClientScript.IsStartupScriptRegistered("SetleadBBLE") Then
                Dim cstext1 As String = "<script type=""text/javascript"">" & _
                                String.Format("var leadsInfoBBLE = ""{0}"";AttachScrollbar();", Request.QueryString("id")) & "</script>"
                Page.ClientScript.RegisterStartupScript(Me.GetType, "SetleadBBLE", cstext1)
            End If

            If Not Page.ClientScript.IsClientScriptBlockRegistered("OnEndCallback") Then
                Dim js As String = "<script type=""text/javascript"">" & _
                                   "function OnEndCallback() {AttachScrollbar();}" & _
                                   "</script>"
                Page.ClientScript.RegisterClientScriptBlock(Me.GetType, "OnEndCallback", js)
            End If
            
            Return
        End If

        If Not String.IsNullOrEmpty(Request.QueryString("sn")) AndAlso Not Page.IsPostBack Then
            Dim sn = Request.QueryString("sn").ToString
            Dim wli = WorkflowService.LoadTaskProcess(sn)
            Dim bble = wli.ProcessInstance.DataFields("BBLE").ToString
            LeadsInfo.BindData(bble)

            If Not Page.ClientScript.IsStartupScriptRegistered("SetleadBBLE") Then
                Dim cstext1 As String = "<script type=""text/javascript"">" & _
                                String.Format("var leadsInfoBBLE = ""{0}"";AttachScrollbar();", bble) & "</script>"
                Page.ClientScript.RegisterStartupScript(Me.GetType, "SetleadBBLE", cstext1)
            End If

            If Not Page.ClientScript.IsClientScriptBlockRegistered("OnEndCallback") Then
                Dim js As String = "<script type=""text/javascript"">" & _
                                   "function OnEndCallback() {AttachScrollbar();}" & _
                                   "</script>"
                Page.ClientScript.RegisterClientScriptBlock(Me.GetType, "OnEndCallback", js)
            End If
            Return
        End If

        If Not String.IsNullOrEmpty(Request.QueryString("ProcInstId")) Then
            Dim procInst = WorkflowService.LoadProcInstById(CInt(Request.QueryString("ProcInstId")))
            If procInst IsNot Nothing Then
                Dim bble = procInst.GetDataFieldValue("BBLE")
                If Not String.IsNullOrEmpty(bble) Then
                    LeadsInfo.BindData(bble.ToString)

                    If Not Page.ClientScript.IsStartupScriptRegistered("SetleadBBLE") Then
                        Dim cstext1 As String = "<script type=""text/javascript"">" & _
                                        String.Format("var leadsInfoBBLE = ""{0}"";AttachScrollbar();", Request.QueryString("id")) & "</script>"
                        Page.ClientScript.RegisterStartupScript(Me.GetType, "SetleadBBLE", cstext1)
                    End If

                    If Not Page.ClientScript.IsClientScriptBlockRegistered("OnEndCallback") Then
                        Dim js As String = "<script type=""text/javascript"">" & _
                                           "function OnEndCallback() {AttachScrollbar();}" & _
                                           "</script>"
                        Page.ClientScript.RegisterClientScriptBlock(Me.GetType, "OnEndCallback", js)
                    End If
                End If
            End If
        End If

    End Sub
End Class