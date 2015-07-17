Imports IntranetPortal.ShortSale
Imports System.Web.Services
Imports System.Web.Script.Serialization
Imports System.Web.Script.Services

Public Class NGShortSale
    Inherits System.Web.UI.Page

    Public Property ShortSaleCaseData As ShortSaleCase
    Public Property isEviction As Boolean = False
    Public Property HiddenTab As Boolean = False

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
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