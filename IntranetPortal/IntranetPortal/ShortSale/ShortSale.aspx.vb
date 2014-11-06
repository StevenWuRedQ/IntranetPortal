Imports IntranetPortal.ShortSale
Imports System.Web.Services
Imports System.Web.Script.Serialization

Public Class ShortSalePage
    Inherits System.Web.UI.Page

    Public Property ShortSaleCaseData As ShortSaleCase

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not Page.IsPostBack Then
            If Not String.IsNullOrEmpty(Request.QueryString("s")) Then
                Dim status = CType(Request.QueryString("s"), CaseStatus)
                ShortSaleCaseList.BindCaseList(status)
            End If

            If Not String.IsNullOrEmpty(Request.QueryString("CaseId")) Then
                Dim caseId = CInt(Request.QueryString("CaseId"))
                BindCaseData(caseId)

                ASPxSplitter1.Panes("listPanel").Collapsed = True
                contentSplitter.ClientVisible = True
            End If

            If Not String.IsNullOrEmpty(Request.QueryString("ShowList")) Then
                ASPxSplitter1.Panes("listPanel").Collapsed = False

                If ShortSaleCaseData IsNot Nothing Then
                    ShortSaleCaseList.BindCaseList(ShortSaleCaseData.Status)
                    ShortSaleCaseList.AutoLoadCase = False
                End If

                If Not Page.ClientScript.IsStartupScriptRegistered("RefreshCaseContent") Then
                    Dim cstext1 As String = "<script type=""text/javascript"">" & _
                                    String.Format("OnGetRowValues({0});", ShortSaleCaseData.CaseId) & "</script>"
                    Page.ClientScript.RegisterStartupScript(Me.GetType, "RefreshCaseContent", cstext1)
                End If
            End If
        End If
    End Sub

    Sub MortgageStatusUpdate(mortageType As String, status As String, bble As String) Handles ActivityLogs.MortgageStatusUpdateEvent
        Dim ssCase = ShortSaleCase.GetCaseByBBLE(bble)

        If mortageType = "1st Mortgage" Then
            If ssCase.Mortgages.Count > 0 Then
                Dim obj = ssCase.Mortgages(0)
                If obj IsNot Nothing Then
                    obj.Status = status
                    obj.Save()
                End If
            End If
        End If

        If mortageType = "2nd Mortgage" Then
            If ssCase.Mortgages.Count > 1 Then
                Dim obj = ssCase.Mortgages(1)
                If obj IsNot Nothing Then
                    obj.Status = status
                    obj.Save()
                End If
            End If
        End If
    End Sub

    Protected Sub ASPxCallbackPanel2_Callback(sender As Object, e As DevExpress.Web.ASPxClasses.CallbackEventArgsBase)
        BindCaseData(e.Parameter)
    End Sub

    Private Sub BindCaseData(caseId As Integer)
        ShortSaleCaseData = ShortSaleCase.GetCase(caseId)
        contentSplitter.ClientVisible = True
        ShortSaleOverVew.BindData(ShortSaleCaseData)
        ucTitle.BindData(ShortSaleCaseData)
        ActivityLogs.BindData(ShortSaleCaseData.BBLE)
        'DocumentsUI.BindFileList(ShortSaleCaseData.BBLE)
        DocumentsUI.LeadsName = ShortSaleCaseData.CaseName
        DocumentsUI.LeadsBBLE = ShortSaleCaseData.BBLE
    End Sub

    <WebMethod()> _
    Public Shared Function GetCase(caseId As String) As String
        Dim ssCase = ShortSaleCase.GetCase(caseId)

        Dim json As New JavaScriptSerializer
        Return json.Serialize(ssCase)
    End Function

    Public Shared Function CheckBox(isChecked As Boolean?) As String
        If isChecked Is Nothing Then
            Return ""
        End If
        Return If(isChecked, "checked", "")
    End Function
End Class