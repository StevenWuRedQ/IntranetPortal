Imports System.Web.Script.Serialization
Imports IntranetPortal.LeadsActivityLog
Imports System.Data.SqlClient

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

            'Set chart  title property
            Dim chart = New With {.Title = String.Format("{0} Leads By All Employee", LeadsCategory.ToString),
                                  .DataSource = source}

            Dim json As New JavaScriptSerializer
            Dim jsonString = json.Serialize(chart)
            Return jsonString
        End Using
    End Function

    Public Function OfficeLeadsSource(office As String) As String
        Using Context As New Entities
            Dim emps = Employee.GetAllDeptUsers(office)

            Dim source = (From ld In Context.Leads.Where(Function(ld) emps.Contains(ld.EmployeeName))
                         Group ld By Name = ld.EmployeeName Into Count()).ToList

            Dim chart = New With {.Title = String.Format("{0} Leads By Employee", office & " Office"),
                                  .DataSource = source}

            Dim json As New JavaScriptSerializer
            Dim jsonString = json.Serialize(chart)
            Return jsonString
        End Using
    End Function

    Public Function Agent_leads_activity_source() As String

        Using Context As New Entities
            Dim source = (From ld In Context.Leads.Where(Function(ld) ld.EmployeeID = current_employee).ToList
                          Group ld By Name = CType(ld.Status, LeadStatus).ToString Into Count()).ToList


            Dim chart = New With {.Title = String.Format("{0}'s Leads", Employee.GetInstance(CInt(current_employee)).Name),
                                  .DataSource = source}

            Dim json As New JavaScriptSerializer
            Return json.Serialize(chart)


        End Using
    End Function
    Public Function AgentActivityToday(ByVal formdays As Date) As String
        'current_employee
        Dim today = formdays
        Using Context As New Entities
            Dim source = (From ld In Context.LeadsActivityLogs.ToList.Where(Function(ld) ld.ActivityDate.HasValue AndAlso ld.ActivityDate.Value.Date > today And ld.EmployeeID = current_employee And ld.ActionType IsNot Nothing).ToList
                          Group ld By Name = CType(ld.ActionType, EnumActionType).ToString Into Count()).ToList
            Dim dateStr = today.ToShortDateString
            If today <> DateTime.Today Then
                dateStr += " - " + DateTime.Today.Date.ToShortDateString
            End If
            Dim chart = New With {.Title = String.Format("{0}'s Activity on {1}", Employee.GetInstance(CInt(current_employee)).Name, dateStr),
                                  .DataSource = source}

            Dim json As New JavaScriptSerializer
            Dim jsonString = json.Serialize(chart)
            Return jsonString
        End Using

    End Function
    Public Function AgentZoningData() As String
        Using Context As New Entities
            Dim source = (From li In Context.LeadsInfoes Join
                                  ld In Context.Leads On ld.BBLE Equals li.BBLE Where ld.EmployeeID = current_employee And li.Zoning IsNot Nothing Group ld By Name = li.Zoning Into Count()).ToList

            Dim chart = New With {.Title = String.Format("{0}'s Leads data by Zoning", Employee.GetInstance(CInt(current_employee)).Name),
                                  .DataSource = source}

            Dim json As New JavaScriptSerializer
            Dim jsonString = json.Serialize(chart)
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
        current_employee = e.Parameter.Split(",")(0)
        Dim days = e.Parameter.Split(",")(1)
        Dim formeDate = Date.Today
        formeDate = formeDate.AddDays(-1 * Convert.ToInt32(days))

        e.Result = AgentActivityToday(formeDate)
    End Sub

    Protected Sub loadAgentZoning_Callback(source As Object, e As DevExpress.Web.ASPxCallback.CallbackEventArgs)
        current_employee = e.Parameter

        e.Result = AgentZoningData()
    End Sub

    Protected Sub loadOfficeLeadsCallback_Callback(source As Object, e As DevExpress.Web.ASPxCallback.CallbackEventArgs)
        e.Result = OfficeLeadsSource(e.Parameter)
    End Sub
    Public Function map_x_axis(x_axis As String) As String
        Dim dataBaseCounsMap = New Dictionary(Of String, String)
        'dataBaseCounsMap.Add("")

        Try
            Dim field = dataBaseCounsMap.Item(x_axis)
            x_axis = If(field Is Nothing, x_axis, field)
        Catch ex As Exception

        End Try
        Return x_axis
    End Function

    Interface ConvertEnum
        Function Convert(value As Integer) As String
    End Interface

    Public Class converLeadStatus
        Implements ConvertEnum

        Function Convert(value As Integer) As String Implements ConvertEnum.Convert
            Return CType(value, LeadStatus).ToString
        End Function
    End Class

    Public Function map_LeadStatus(stauts As Integer) As String
        Dim convers = New Dictionary(Of Integer, String)
        convers.Add(LeadStatus.Priority, "Hot leads")
        convers.Add(LeadStatus.InProcess, "In Negotiation")

        Try
            Dim stautsStr = convers.Item(stauts)
            If (stautsStr IsNot Nothing AndAlso stautsStr.Length > 0) Then
                Return stautsStr
            End If
        Catch ex As Exception

        End Try
        Return CType(stauts, LeadStatus).ToString
    End Function
    Public Function map_value(x_axis As String, value As String) As String
        Dim convers = New Dictionary(Of String, ConvertEnum)
        convers.Add("Status", New converLeadStatus)

        Try
            Dim covert = convers.Item(x_axis)
            If covert IsNot Nothing Then
                Dim intValue = Convert.ToInt32(value)
                Return covert.Convert(intValue)
            End If
        Catch ex As Exception

        End Try

        Return value
    End Function
    Public Function char_change_axis(x_axis As String, empId As String) As String
        Using Context As New Entities
            Dim source = New List(Of Dictionary(Of String, Object))

            x_axis = map_x_axis(x_axis)

            Dim sqlConnection1 As New SqlConnection(Context.Database.Connection.ConnectionString)
            Dim cmd As New SqlCommand
            Dim reader As SqlDataReader

            cmd.CommandText = "SELECT Count(" + x_axis + ") As Count," + x_axis + " as Name FROM [IntranetPortal].[dbo].[LeadsInfo] ld left join [IntranetPortal].[dbo].[Leads] li on ld.BBLE=li.BBLE  where " + x_axis + " is not null and li.EmployeeID=" + empId + " group by " + x_axis
            '"SELECT COUNT(" + x_axis + ") as Count, " + x_axis + " as Name FROM [IntranetPortal].[dbo].[LeadsInfo] where " + x_axis + " is not null group by " + x_axis
            cmd.CommandType = CommandType.Text
            cmd.Connection = sqlConnection1

            sqlConnection1.Open()

            reader = cmd.ExecuteReader()
            While (reader.Read())
                Dim item = New Dictionary(Of String, Object)
                item.Add("Count", reader.GetInt32(0))
                Dim name = ""
                Try
                    name = reader.GetString(1)
                Catch ex As Exception
                    name = reader.GetInt32(0).ToString
                End Try
                name = map_value(x_axis, name)
                item.Add("Name", name)
                source.Add(item)

            End While
            ' Data is accessible through the DataReader object here.

            sqlConnection1.Close()
            'Dim source = (From ld In Context.LeadsInfoes Where ld[x_axis] isnot nothing  group ld by name = ld[x_axis] into count() ).ToList()
            ' Employee.GetInstance(CInt(current_employee)).Name can't get employee instance
            Dim chart = New With {.Title = String.Format("{0}'s Leads data by {1}", "123", x_axis),
                                  .DataSource = source}

            Dim json As New JavaScriptSerializer
            Dim jsonString = json.Serialize(chart)
            Return jsonString
        End Using
    End Function

    Protected Sub char_change_x_axis_id_Callback(source As Object, e As DevExpress.Web.ASPxCallback.CallbackEventArgs)
        Dim a_x_axis = e.Parameter.Split("|")(0)
        Dim a_empID = e.Parameter.Split("|")(1)
        current_employee = a_empID
        e.Result = char_change_axis(a_x_axis, a_empID)
    End Sub

    Public Function getStatusBarChartByOffice(status As Integer, officeName As String) As String
        Using Context As New Entities
            Dim source = (From e In Context.Employees Join
                                 ld In Context.Leads On ld.EmployeeID Equals e.EmployeeID Where e.Department = officeName And ld.Status = status Group ld By Name = ld.EmployeeName Into Count()).ToList

            Dim chart = New With {.Title = String.Format("{0}'s Employees {1} Leads data ", officeName, map_LeadStatus(status)),
                              .DataSource = source}

            Dim json As New JavaScriptSerializer
            Dim jsonString = json.Serialize(chart)
            Return jsonString
        End Using

    End Function

    Protected Sub LoadStatusBarChartByOffice_Callback(source As Object, e As DevExpress.Web.ASPxCallback.CallbackEventArgs)
        Dim status = Convert.ToInt32(e.Parameter.Split("|")(0))
        Dim office = e.Parameter.Split("|")(1)
        e.Result = getStatusBarChartByOffice(status, office)
    End Sub
End Class