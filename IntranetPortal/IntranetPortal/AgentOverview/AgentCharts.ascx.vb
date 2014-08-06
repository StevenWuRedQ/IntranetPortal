Imports System.Web.Script.Serialization

Public Class AgentCharts
    Inherits System.Web.UI.UserControl

    Public Property LeadsCategory As LeadStatus

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not IsPostBack Then
            'LeadsCategory = LeadStatus.NewLead
        End If
    End Sub

    Public Function ChartSource() As String
        Using Context As New Entities

            Dim source = (From ld In Context.Leads.Where(Function(ld) ld.Status = LeadsCategory)
                         Group ld By Name = ld.EmployeeName Into Count()).ToList

            Dim json As New JavaScriptSerializer
            Dim jsonString = json.Serialize(source)
            Return jsonString
        End Using
    End Function

    Protected Sub callbackDs_Callback(source As Object, e As DevExpress.Web.ASPxCallback.CallbackEventArgs)
        LeadsCategory = CType(e.Parameter, LeadStatus)
        e.Result = ChartSource()
    End Sub
End Class