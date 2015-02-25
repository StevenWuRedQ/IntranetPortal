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
            LoadData(bble)
            Return
        End If

        If Not String.IsNullOrEmpty(Request.QueryString("b")) Then
            Dim bble = Request.QueryString("b").ToString
            LeadsInfo.ShowLogPanel = False
            LoadData(bble)
            Return
        End If

        If Not String.IsNullOrEmpty(Request.QueryString("sn")) AndAlso Not Page.IsPostBack Then
            Dim sn = Request.QueryString("sn").ToString
            Dim wli = WorkflowService.LoadTaskProcess(sn)
            If wli IsNot Nothing Then
                Dim bble = wli.ProcessInstance.DataFields("BBLE").ToString
                LoadData(bble)
            End If
            Return
        End If

        If Not String.IsNullOrEmpty(Request.QueryString("ProcInstId")) Then
            Dim procInst = WorkflowService.LoadProcInstById(CInt(Request.QueryString("ProcInstId")))

            If procInst IsNot Nothing Then
                Dim bble = procInst.GetDataFieldValue("BBLE")
                If bble IsNot Nothing AndAlso Not String.IsNullOrEmpty(bble) Then
                    If Not Employee.HasControlLeads(User.Identity.Name, bble) Then
                        Response.Clear()
                        Response.Write("You are not allowed to view this lead.")
                        Response.End()
                        Return
                    End If

                    If procInst.ProcessName = "NewLeadsRequest" Then
                        Dim result = procInst.GetDataFieldValue("Result")

                        If result = "Decline" Then
                            Response.Clear()
                            Response.Write("This new leads is declined.")
                            Response.End()
                            Return
                        End If
                    End If

                    If Not String.IsNullOrEmpty(bble) Then
                        'check if this leads is waiting manager approval
                        Dim ld = IntranetPortal.Lead.GetInstance(bble)
                        If ld.Status = IntranetPortal.LeadStatus.MgrApprovalInWf Then
                            Response.Clear()
                            Response.Write("This leads is pending for manager approval. Please wait.")
                            Response.End()
                            Return
                        End If

                        If Not Employee.HasControlLeads(User.Identity.Name, bble) Then
                            Response.Clear()
                            Response.Write("You are not allowed to view this lead for now.")
                            Response.End()
                            Return
                        End If

                        LoadData(bble)
                    End If
                End If

            End If
        End If
    End Sub

    Private Sub LoadData(bble As String)
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
    End Sub
End Class