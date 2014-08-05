Imports System.Web.Script.Serialization

Public Class AgentCharts
    Inherits System.Web.UI.UserControl

    Public Property LeadsCategory As LeadStatus

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        LeadsCategory = LeadStatus.NewLead
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
End Class