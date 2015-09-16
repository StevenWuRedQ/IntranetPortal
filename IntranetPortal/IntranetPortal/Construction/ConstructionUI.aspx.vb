Public Class ConstructionUI
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not IsPostBack Then

            If Not String.IsNullOrEmpty(Request.QueryString("sn")) Then
                ASPxSplitter1.Panes("listPanel").Visible = False
                Dim wli = WorkflowService.LoadTaskProcess(Request.QueryString("sn"))
                If wli IsNot Nothing Then
                    Dim bble = wli.ProcessInstance.DataFields("BBLE").ToString
                    BindData(bble)
                End If
                Return
            End If

            If Not String.IsNullOrEmpty(Request.QueryString("bble")) Then
                Dim bble = Request.QueryString("bble").ToString
                BindData(bble)
                Return
            Else
                ConstructionCaseList.BindCaseList()
                ConstructionCaseList.AutoLoadCase = True
            End If
        End If
    End Sub

    Private Sub BindData(bble As String)
        ASPxSplitter1.Panes("listPanel").Visible = False
        ActivityLogs.BindData(bble)
        If Not Page.ClientScript.IsStartupScriptRegistered("SetleadBBLE") Then
            Dim cstext1 As String = "<script type=""text/javascript"">" & _
                            String.Format("var leadsInfoBBLE = ""{0}"";", bble) & "</script>"
            Page.ClientScript.RegisterStartupScript(Me.GetType, "SetleadBBLE", cstext1)

            If Not Page.ClientScript.IsStartupScriptRegistered("InitData") Then
                cstext1 = "<script type=""text/javascript"">" & _
                                String.Format("LoadCaseData(""{0}"");", bble) & "</script>"
                Page.ClientScript.RegisterStartupScript(Me.GetType, "InitData", cstext1)
            End If
        End If
    End Sub

    Protected Sub cbpLogs_Callback(sender As Object, e As DevExpress.Web.CallbackEventArgsBase)
        ActivityLogs.BindData(e.Parameter)
    End Sub

    Protected Sub ASPxPopupControl3_WindowCallback(source As Object, e As DevExpress.Web.PopupWindowCallbackArgs)
        PopupContentReAssign.Visible = True

        If e.Parameter.StartsWith("Show") Then
            If e.Parameter.Split("|").Length > 1 Then
                hfUserType.Value = e.Parameter.Split("|")(1)
            End If

            listboxEmployee.DataSource = ConstructionManage.GetConstructionUsers()
            listboxEmployee.DataBind()
        End If

        If Not String.IsNullOrEmpty(e.Parameter) AndAlso e.Parameter.StartsWith("Save") Then
            Dim bble = e.Parameter.Split("|")(1)
            Dim user = e.Parameter.Split("|")(2)
            Dim status = Data.ConstructionCase.CaseStatus.All

            If Not String.IsNullOrEmpty(hfUserType.Value) Then
                status = CType(hfUserType.Value, Data.ConstructionCase.CaseStatus)
            End If

            ConstructionManage.AssignCase(bble, user, Page.User.Identity.Name, status)
        End If
    End Sub

End Class