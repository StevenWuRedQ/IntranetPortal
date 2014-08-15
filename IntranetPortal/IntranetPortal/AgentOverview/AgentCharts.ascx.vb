Imports System.Web.Script.Serialization
Imports IntranetPortal.LeadsActivityLog

Public Class AgentCharts
    Inherits System.Web.UI.UserControl

    Public Property LeadsCategory As LeadStatus
    Public Property current_employee As String
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        'agnet_leads_activity_source()
        'AgentActivityToday()
        'AgentZoningData()
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

    Public Function OfficeLeadsSource(office As String) As String
        Using Context As New Entities
            Dim emps = Employee.GetAllDeptUsers(office)

            Dim source = (From ld In Context.Leads.Where(Function(ld) emps.Contains(ld.EmployeeName))
                         Group ld By Name = ld.EmployeeName Into Count()).ToList

            Dim json As New JavaScriptSerializer
            Dim jsonString = json.Serialize(source)
            Return jsonString
        End Using
    End Function

    Public Function Agent_leads_activity_source() As String

        Using Context As New Entities
            Dim source = (From ld In Context.Leads.Where(Function(ld) ld.EmployeeID = current_employee).ToList
                          Group ld By Name = CType(ld.Status, LeadStatus).ToString Into Count()).ToList

            Dim json As New JavaScriptSerializer
            Return json.Serialize(source)

            'Dim cstext1 As String = "<script type=""text/javascript"">" & _
            '              String.Format("show_bar_chart({0})", jsonString) & "</script>"

            'Page.ClientScript.RegisterStartupScript(Me.GetType, "ShowReport", cstext1)
        End Using
    End Function
    Public Function AgentActivityToday() As String
        'current_employee
        Dim today = DateTime.Today
        Using Context As New Entities
            Dim source = (From ld In Context.LeadsActivityLogs.ToList.Where(Function(ld) ld.ActivityDate.HasValue AndAlso ld.ActivityDate.Value.Date = today And ld.EmployeeID = current_employee And ld.ActionType IsNot Nothing).ToList
                          Group ld By Name = CType(ld.ActionType, EnumActionType).ToString Into Count()).ToList

            Dim json As New JavaScriptSerializer
            Dim jsonString = json.Serialize(source)
            Return jsonString
        End Using

    End Function
    Public Function AgentZoningData() As String
        Using Context As New Entities
            Dim source = (From li In Context.LeadsInfoes Join
                                  ld In Context.Leads On ld.BBLE Equals li.BBLE Where ld.EmployeeID = current_employee And li.Zoning IsNot Nothing Group ld By Name = li.Zoning Into Count()).ToList

            Dim json As New JavaScriptSerializer
            Dim jsonString = json.Serialize(source)
            Return jsonString
        End Using
    End Function


   
    Protected Sub callbackDs_Callback(source As Object, e As DevExpress.Web.ASPxCallback.CallbackEventArgs)
        LeadsCategory = CType(e.Parameter, LeadStatus)

        e.Result = ChartSource()
    End Sub

    Protected Sub ASPxCallback1_Callback(source As Object, e As DevExpress.Web.ASPxCallback.CallbackEventArgs)
        current_employee = e.Parameter
        e.Result = Agent_leads_activity_source()
    End Sub

    Protected Sub loadAgentCallBack_Callback(source As Object, e As DevExpress.Web.ASPxCallback.CallbackEventArgs)
        current_employee = e.Parameter
        e.Result = AgentActivityToday()
    End Sub

    Protected Sub loadAgentZoning_Callback(source As Object, e As DevExpress.Web.ASPxCallback.CallbackEventArgs)
        current_employee = e.Parameter
        e.Result = AgentZoningData()
    End Sub

    Protected Sub loadOfficeLeadsCallback_Callback(source As Object, e As DevExpress.Web.ASPxCallback.CallbackEventArgs)
        e.Result = OfficeLeadsSource(e.Parameter)
    End Sub
End Class