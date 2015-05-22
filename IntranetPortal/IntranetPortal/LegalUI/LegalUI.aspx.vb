Imports System.Web.Script.Serialization
Imports IntranetPortal.ShortSale
Imports Newtonsoft.Json
Imports System.Web.Services
Imports System.Web.Script.Services

Public Class LegalUI
    Inherits System.Web.UI.Page
    Public SecondaryAction As Boolean = False
    Public Agent As Boolean = False

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

    End Sub

    Sub Page_init(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Init
        SecondaryAction = Request.QueryString("Attorney") IsNot Nothing
        Agent = Request.QueryString("Agent") IsNot Nothing
        If Not String.IsNullOrEmpty(Request.QueryString("sn")) Then
            ASPxSplitter1.Panes("listPanel").Visible = False
            Dim wli = WorkflowService.LoadTaskProcess(Request.QueryString("sn"))
            Dim bble = wli.ProcessInstance.DataFields("BBLE").ToString
            ActivityLogs.BindData(bble)

            'Select Case wli.ActivityName
            '    Case "LegalResearch"
            '        btnCompleteResearch.Visible = True
            '    Case "ManagerAssign"
            '        lbEmployee.Visible = True
            '        btnAssign.Visible = True
            'End Select

            Return
        End If

        If Not String.IsNullOrEmpty(Request.QueryString("lc")) Then
            LegalCaseList.BindCaseList(CInt(Request.QueryString("lc")))
            LegalCaseList.AutoLoadCase = True
        End If
    End Sub

    Public Function GetAllContact() As String
        Dim json = New JavaScriptSerializer().Serialize(PartyContact.getAllContact().OrderBy(Function(c) c.Name))
        Return json
    End Function

    Protected Sub cbpLogs_Callback(sender As Object, e As DevExpress.Web.ASPxClasses.CallbackEventArgsBase)
        ActivityLogs.BindData(e.Parameter)
    End Sub

    <WebMethod()> _
    <ScriptMethod>
    Public Shared Sub SaveCase(legalCase As Legal.LegalCase)
        legalCase.SaveData()
    End Sub

    <WebMethod()> _
   <ScriptMethod>
    Public Shared Sub SaveCaseData(caseData As String, bble As String)
        Dim lgCase = Legal.LegalCase.GetCase(bble)
        lgCase.CaseData = caseData
        lgCase.SaveData()
    End Sub

    <WebMethod()> _
    <ScriptMethod(ResponseFormat:=ResponseFormat.Json)>
    Public Shared Function GetCaseData(bble As String) As String
        Return Legal.LegalCase.GetCase(bble).CaseData
    End Function

End Class