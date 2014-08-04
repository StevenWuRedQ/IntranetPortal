Imports DevExpress.Web.ASPxGridView
Imports System.Linq.Expressions
Imports DevExpress.Web.ASPxEditors

Public Class AgentOverview
    Inherits System.Web.UI.Page
    Public report_data As String

    Public Property CurrentEmployee As Employee
    Public portalDataContext As New Entities

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If String.IsNullOrEmpty(hfEmpName.Value) Then
            CurrentEmployee = Employee.GetInstance(User.Identity.Name)
            hfEmpName.Value = CurrentEmployee.Name
        Else
            CurrentEmployee = Employee.GetInstance(hfEmpName.Value)
        End If

        If Not IsPostBack Then
            gridEmps.DataBind()
            gridReport.DataBind()
        End If

        report_data = report_data_f()
    End Sub

    Function GetTemplates() As StringDictionary
        Dim up = Employee.GetProfile(User.Identity.Name)
        Return up.ReportTemplates
    End Function

    Sub BindEmp()
        gridEmps.DataSource = portalDataContext.Employees.ToList
    End Sub

    Sub BindGridReport()
        Dim name = hfEmpName.Value

        'If chkFields.SelectedValues.Count > 1 Then
        '    gridReport.Columns.Clear()
        '    For Each item As String In chkFields.SelectedValues
        '        Dim gridCol = New GridViewDataColumn
        '        gridCol.FieldName = item
        '        gridReport.Columns.Add(gridCol)
        '    Next
        'End If

        Dim reports = (From li In portalDataContext.LeadsInfoes Join
                                   ld In portalDataContext.Leads On ld.BBLE Equals li.BBLE
                                   Where ld.EmployeeName = name
                                   Select li).ToList
        gridReport.DataSource = reports
    End Sub

    'Function CreateNewStatement(fields As String) As Func(Of LeadsInfo, Object)
    '    Dim xParameter As ParameterExpression = Expression.Parameter(GetType(LeadsInfo), "o")
    '    Dim sourceProperties = fields.ToDictionary(Function(nam) nam, Function(nam) GetType(LeadsInfo).GetProperty(nam))

    '    Dim xNew = Expression.[New]((GetType(LeadsInfo)))

    '    Dim bindings = fields.Split(",").Select(Function(o) o.Trim).Select(Function(o)
    '                                                                           Dim mi = GetType(LeadsInfo).GetProperty(o)
    '                                                                           Dim xOriginal = Expression.Property(xParameter, mi)
    '                                                                           Return Expression.Bind(mi, xOriginal)
    '                                                                       End Function)
    '    Dim xInit = Expression.MemberInit(xNew, bindings)
    '    Dim lambda = Expression.Lambda(xInit, xParameter)

    '    Return lambda.Compile()
    'End Function

    'retrun the report data fields
    Function report_fields() As String
        Dim serializer As New System.Web.Script.Serialization.JavaScriptSerializer()
        Dim D_report_data As New List(Of String)
        'From()
        '    {"property", "date", "call_atpt"
        '        }
        D_report_data.Add("property")
        D_report_data.Add("date")

        D_report_data.Add("call_atpt")

        Return serializer.Serialize(D_report_data)
    End Function
    'retrun the report data
    Function report_data_f() As String
        Dim serializer As New System.Web.Script.Serialization.JavaScriptSerializer()
        Dim D_report_data As New List(Of Dictionary(Of String, String))


        For i As Integer = 1 To 20
            Dim item As New Dictionary(Of String, String) From
            {
                {"property", "123 Main St, Brooklyn, NY 12345"},
                {"date", "4/23/2014"},
                {"call_atpt", "12"},
                {"doorknk_atpt", "3"},
                {"Comment", "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Cras at porta justo, vitae ultrices orci."},
                {"data", "3"}
            }
            If i Mod 2 = 0 Then
                Dim item2 As New Dictionary(Of String, String) From
            {
                {"property", "5732 Jamaica Ave, Jamaica, NY 11456"},
                {"date", "5/17/2014"},
                {"call atpt", "20"},
                {"doorknk_atpt", "9"},
                {"Comment", "Phasellus enim libero, pulvinar sit amet felis at, rutrum rhoncus ante."},
                {"data", " "}
            }
                item = item2
            End If
            D_report_data.Add(item)
        Next
        Return serializer.Serialize(D_report_data)

    End Function
    Public Sub click_report_index(ByVal sender As System.Object)
        Dim index As Integer = sender
        'Request.QueryString("index")
        MsgBox("index =" & index)
    End Sub

    Protected Sub gridReport_DataBinding(sender As Object, e As EventArgs) Handles gridReport.DataBinding
        If gridReport.DataSource Is Nothing Then
            BindGridReport()
        End If
    End Sub

    Protected Sub gridEmps_DataBinding(sender As Object, e As EventArgs) Handles gridEmps.DataBinding
        If gridEmps.DataSource Is Nothing Then
            BindEmp()
        End If
    End Sub

    Protected Sub gridReport_CustomCallback(sender As Object, e As ASPxGridViewCustomCallbackEventArgs)
        gridReport.DataBind()
    End Sub

    Protected Sub Unnamed_ServerClick(sender As Object, e As EventArgs)
        gridExport.WriteXlsToResponse()
    End Sub

    Protected Sub contentCallback_Callback(sender As Object, e As DevExpress.Web.ASPxClasses.CallbackEventArgsBase)
        If Not String.IsNullOrEmpty(e.Parameter) Then
            CurrentEmployee = Employee.GetInstance(CInt(e.Parameter))
            hfEmpName.Value = CurrentEmployee.Name
            gridReport.DataBind()
        End If
    End Sub

    Protected Sub gridReport_Load(sender As Object, e As EventArgs)
        If chkFields.SelectedValues.Count > 0 Then
            For Each item As String In chkFields.SelectedValues
                Dim gridCol = gridReport.Columns(item)
                gridCol.Visible = True
            Next
        End If
    End Sub

    Protected Sub gridReport_Init(sender As Object, e As EventArgs)
        Dim s = hfEmpName.Value
        If chkFields.Items.Count > 0 Then
            gridReport.Columns.Clear()
            For Each item As ListEditItem In chkFields.Items
                Dim gridCol = New GridViewDataColumn
                gridCol.FieldName = item.Value
                gridCol.Visible = False
                gridReport.Columns.Add(gridCol)
            Next
        End If
    End Sub    
    

    Protected Sub callbackPnlTemplates_Callback(sender As Object, e As DevExpress.Web.ASPxClasses.CallbackEventArgsBase)
        If e.Parameter.StartsWith("AddReport") Then
            Dim name = e.Parameter.Split("|")(1)
            Dim up = Employee.GetProfile(Page.User.Identity.Name)

            If up.ReportTemplates Is Nothing Then
                up.ReportTemplates = New StringDictionary
            End If

            If up.ReportTemplates.ContainsKey(name) Then
                up.ReportTemplates(name) = gridReport.SaveClientLayout
            Else
                up.ReportTemplates.Add(name, gridReport.SaveClientLayout)
            End If

            Employee.SaveProfile(User.Identity.Name, up)
        End If

    End Sub

End Class