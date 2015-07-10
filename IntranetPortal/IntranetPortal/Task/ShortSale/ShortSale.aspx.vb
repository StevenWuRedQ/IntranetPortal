Imports IntranetPortal.ShortSale
Imports System.Web.Services
Imports System.Web.Script.Serialization
Imports System.Web.Script.Services

Public Class ShortSalePage
    Inherits System.Web.UI.Page

    Public Property ShortSaleCaseData As ShortSaleCase
    Public Property isEviction As Boolean = False
    Public Property HiddenTab As Boolean = False

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        isEviction = CBool(hfIsEvction.Value)
        If Not Page.IsPostBack Then

            HiddenTab = Not String.IsNullOrEmpty(Request.QueryString("HiddenTab"))
            If (HiddenTab) Then
                contentSplitter.GetPaneByName("LogPanel").Visible = False
                ASPxSplitter1.GetPaneByName("listPanel").Visible = False
            End If

            If Not String.IsNullOrEmpty(Request.QueryString("s")) Then
                Dim status = CType(Request.QueryString("s"), CaseStatus)
                ShortSaleCaseList.BindCaseList(status)
            End If

            If Not String.IsNullOrEmpty(Request.QueryString("category")) Then
                Dim category = Request.QueryString("category").ToString
                ShortSaleCaseList.BindCaseListByCategory(category)
            End If

            'process the task
            If Not String.IsNullOrEmpty(Request.QueryString("sn")) Then
                Dim wli = WorkflowService.LoadTaskProcess(Request.QueryString("sn"))

                If wli IsNot Nothing Then
                    Dim bble = wli.ProcessInstance.DataFields("BBLE").ToString
                    BindCaseData2(bble)
                    ASPxSplitter1.Panes("listPanel").Visible = False
                    contentSplitter.ClientVisible = True

                    If Not Page.ClientScript.IsStartupScriptRegistered("GetShortSaleData") Then

                        Dim cstext1 As String = "<script type=""text/javascript"">" & _
                                        String.Format("GetShortSaleData({0});", ShortSaleCaseData.CaseId) & "</script>"
                        Page.ClientScript.RegisterStartupScript(Me.GetType, "GetShortSaleData", cstext1)
                    End If
                End If

                Return
            End If

            'View shortsale
            If Not String.IsNullOrEmpty(Request.QueryString("ProcInstId")) Then
                Dim procInst = WorkflowService.LoadProcInstById(CInt(Request.QueryString("ProcInstId")))
                If procInst IsNot Nothing Then
                    Dim bble = procInst.GetDataFieldValue("BBLE")
                    If Not String.IsNullOrEmpty(bble) Then
                        BindCaseData2(bble)
                        ASPxSplitter1.Panes("listPanel").Visible = False
                        contentSplitter.ClientVisible = True

                        If Not Page.ClientScript.IsStartupScriptRegistered("GetShortSaleData") Then
                            Dim cstext1 As String = "<script type=""text/javascript"">" & _
                                            String.Format("GetShortSaleData({0});", ShortSaleCaseData.CaseId) & "</script>"
                            Page.ClientScript.RegisterStartupScript(Me.GetType, "GetShortSaleData", cstext1)
                        End If
                        Return
                    End If
                End If
            End If

            If Not String.IsNullOrEmpty(Request.QueryString("bble")) Then
                Dim bble = Request.QueryString("bble").ToString
                hfBBLE.Value = bble
                BindCaseData2(bble)

                ASPxSplitter1.Panes("listPanel").Visible = False
                contentSplitter.ClientVisible = True

                If Not Page.ClientScript.IsStartupScriptRegistered("GetShortSaleData") Then
                    Dim cstext1 As String = "<script type=""text/javascript"">" & _
                                    String.Format("GetShortSaleData({0});", ShortSaleCaseData.CaseId) & "</script>"
                    Page.ClientScript.RegisterStartupScript(Me.GetType, "GetShortSaleData", cstext1)
                End If
            End If

            If Not String.IsNullOrEmpty(Request.QueryString("CaseId")) Then
                Dim caseId = CInt(Request.QueryString("CaseId"))
                Dim ssCase = ShortSaleCase.GetCase(caseId)
                If (ssCase IsNot Nothing) Then
                    hfBBLE.Value = ssCase.BBLE
                End If
                BindCaseData(caseId)

                ASPxSplitter1.Panes("listPanel").Visible = False
                contentSplitter.ClientVisible = True

                If Not Page.ClientScript.IsStartupScriptRegistered("GetShortSaleData") Then
                    Dim cstext1 As String = "<script type=""text/javascript"">" & _
                                    String.Format("GetShortSaleData({0});", ShortSaleCaseData.CaseId) & "</script>"
                    Page.ClientScript.RegisterStartupScript(Me.GetType, "GetShortSaleData", cstext1)
                End If
            End If


            If Not String.IsNullOrEmpty(Request.QueryString("ShowList")) Then
                ASPxSplitter1.Panes("listPanel").Visible = True

                If ShortSaleCaseData IsNot Nothing Then
                    ShortSaleCaseList.BindCaseList(ShortSaleCaseData.Status)
                    ShortSaleCaseList.AutoLoadCase = False
                End If

                If Not Page.ClientScript.IsStartupScriptRegistered("GetShortSaleData") Then
                    Dim cstext1 As String = "<script type=""text/javascript"">" & _
                                    String.Format("GetShortSaleData({0});", ShortSaleCaseData.CaseId) & "</script>"
                    Page.ClientScript.RegisterStartupScript(Me.GetType, "GetShortSaleData", cstext1)
                End If
            End If

            If (Not String.IsNullOrEmpty(Request.QueryString("LeadsAgent"))) Then
                Dim users = {User.Identity.Name}
                If String.IsNullOrEmpty(Request.QueryString("isEviction")) Then
                    ShortSaleCaseList.BindCaseByBBLEs(ShortSaleManage.GetShortSaleCasesByUsers(users).Select(Function(ss) ss.BBLE).ToList)
                    isEviction = False
                Else
                    isEviction = True
                    ShortSaleCaseList.BindCaseByBBLEs(ShortSaleManage.GetEvictionCasesByUsers(users).Select(Function(evi) evi.BBLE).ToList)
                End If

                Return
            End If

            If Not String.IsNullOrEmpty(Request.QueryString("mgr")) Then
                Dim users = Employee.GetManagedEmployees(User.Identity.Name)

                If String.IsNullOrEmpty(Request.QueryString("isEviction")) Then
                    isEviction = False
                    ShortSaleCaseList.BindCaseByBBLEs(ShortSaleManage.GetShortSaleCasesByUsers(users).Select(Function(ss) ss.BBLE).ToList)
                Else
                    isEviction = True
                    ShortSaleCaseList.BindCaseByBBLEs(ShortSaleManage.GetEvictionCasesByUsers(users).Select(Function(evi) evi.BBLE).ToList)
                End If

                Return
            End If

            If Not String.IsNullOrEmpty(Request.QueryString("teamId")) Then
                Dim teamId = CInt(Request.QueryString("teamId"))
                Dim users = Employee.GetAllTeamUsers(teamId)

                Using ctx As New Entities
                    Dim bbles = ctx.Leads.Where(Function(l) l.Status = LeadStatus.InProcess AndAlso users.Contains(l.EmployeeName)).Select(Function(l) l.BBLE).ToList
                    If Utility.IsAny(bbles) Then
                        ShortSaleCaseList.BindCaseByBBLEs(bbles)
                    End If
                End Using

                Return
            End If

            If Not String.IsNullOrEmpty(Request.QueryString("isEviction")) Then
                isEviction = True
                'it should be Eviction not new file for test
                If Not String.IsNullOrEmpty(Request.QueryString("tid")) Then
                    Dim teamId = CInt(Request.QueryString("tid"))
                    Dim users = Employee.GetAllTeamUsers(teamId)

                    Using ctx As New Entities
                        Dim bbles = ctx.Leads.Where(Function(l) l.Status = LeadStatus.InProcess AndAlso users.Contains(l.EmployeeName)).Select(Function(l) l.BBLE).ToList
                        If Utility.IsAny(bbles) Then
                            ShortSaleCaseList.BindCaseByBBLEs(EvictionCas.GetCaseByBBLEs(bbles).Select(Function(evi) evi.BBLE).ToList)
                        End If
                    End Using
                Else
                    ShortSaleCaseList.BindCaseList(CaseStatus.Eviction)
                End If
            Else
                isEviction = False
            End If
        End If
        hfIsEvction.Value = isEviction.ToString
    End Sub

    Sub MortgageStatusUpdate(mortageType As String, status As String, category As String, bble As String) Handles ActivityLogs.MortgageStatusUpdateEvent
        Dim ssCase = ShortSaleCase.GetCaseByBBLE(bble)

        Select Case mortageType
            Case "2nd Lien"
                ssCase.UpdateMortgageStatus(1, category, status)
            Case "3rd Lien"
                ssCase.UpdateMortgageStatus(2, category, status)
            Case Else
                ssCase.UpdateMortgageStatus(0, category, status)
        End Select
    End Sub

    Protected Sub ASPxCallbackPanel2_Callback(sender As Object, e As DevExpress.Web.ASPxClasses.CallbackEventArgsBase)
        BindCaseData(e.Parameter)
    End Sub

    Private Sub BindCaseData(caseId As Integer)
        ShortSaleCaseData = ShortSaleCase.GetCase(caseId)
        contentSplitter.ClientVisible = True
        ShortSaleOverVew.BindData(ShortSaleCaseData)
        hfBBLE.Value = ShortSaleCaseData.BBLE
        ucTitle.BindData(ShortSaleCaseData)
        ActivityLogs.DisplayMode = IntranetPortal.ActivityLogs.ActivityLogMode.ShortSale
        ActivityLogs.BindData(ShortSaleCaseData.BBLE)

        ShortSaleFileOverview.BindData(ShortSaleCaseData.BBLE)

        'DocumentsUI.BindFileList(ShortSaleCaseData.BBLE)
        DocumentsUI.LeadsName = ShortSaleCaseData.CaseName
        DocumentsUI.LeadsBBLE = ShortSaleCaseData.BBLE
    End Sub

    Private Sub BindCaseData2(bble As String)
        ShortSaleCaseData = ShortSaleCase.GetCaseByBBLE(bble)

        If ShortSaleCaseData Is Nothing Then
            Response.Clear()
            Response.Write("This leads isnot in Short Sale. Please check!")
            Response.End()
            Return
        End If

        contentSplitter.ClientVisible = True
        ShortSaleOverVew.BindData(ShortSaleCaseData)
        ucTitle.BindData(ShortSaleCaseData)
        ActivityLogs.DisplayMode = IntranetPortal.ActivityLogs.ActivityLogMode.ShortSale
        ActivityLogs.BindData(ShortSaleCaseData.BBLE)

        ShortSaleFileOverview.BindData(ShortSaleCaseData.BBLE)

        'DocumentsUI.BindFileList(ShortSaleCaseData.BBLE)
        DocumentsUI.LeadsName = ShortSaleCaseData.CaseName
        DocumentsUI.LeadsBBLE = ShortSaleCaseData.BBLE
    End Sub

    <WebMethod()> _
    <ScriptMethod(ResponseFormat:=ResponseFormat.Json)>
    Public Shared Function GetCase(caseId As String) As ShortSaleCase
        Dim ssCase = ShortSaleCase.GetCase(caseId)
        'Dim json As New JavaScriptSerializer
        'Return json.Serialize(ssCase)
        Return ssCase
    End Function

    Public Shared Function CheckBox(isChecked As Boolean?) As String
        If isChecked Is Nothing Then
            Return ""
        End If
        Return If(isChecked, "checked", "")
    End Function
End Class