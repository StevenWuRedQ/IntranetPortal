Imports DevExpress.Web.ASPxGridView
Imports System.Linq.Expressions
Imports DevExpress.Web.ASPxEditors

Public Class AgentOverview
    Inherits System.Web.UI.Page

    Public Property CurrentEmployee As Employee
    Public Property CurrentStatus As LeadStatus
    Public Property CurrentOffice As String
    Public portalDataContext As New Entities

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If String.IsNullOrEmpty(hfEmpName.Value) Then
            CurrentEmployee = Employee.GetInstance(User.Identity.Name)
            hfEmpName.Value = CurrentEmployee.Name
        Else
            CurrentEmployee = Employee.GetInstance(hfEmpName.Value)
        End If
        If Not String.IsNullOrEmpty(CurrentEmployee.Picture) Then
            profile_image.ImageUrl = CurrentEmployee.Picture
        End If

        If Not IsPostBack Then
            gridEmps.DataBind()
            gridReport.DataBind()

            gridEmps.GroupBy(gridEmps.Columns("Department"))
        End If
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
        If e.Parameters.StartsWith("BindEmp") Then
            CurrentEmployee = Employee.GetInstance(CInt(e.Parameters.Split("|")(1)))
            'AgentCharts.current_employee = CurrentEmployee.Name
            'AgentCharts.Agent_leads_activity_source()
            hfEmpName.Value = CurrentEmployee.Name
            gridReport.DataBind()
        End If

        If e.Parameters.StartsWith("LoadLayout") Then
            Dim report = e.Parameters.Split("|")(1)
            Dim up = Employee.GetProfile(User.Identity.Name)
            gridReport.LoadClientLayout(up.ReportTemplates(report))
            SetFlieds(GetReportColumns())
        End If

        If e.Parameters.StartsWith("FieldChange") Then
            'show_grid_by_items(True)
            Dim columns = e.Parameters.Split("|")(1)
            LoadGridColumn(columns)
            gridReport.DataBind()
        End If

        If e.Parameters.StartsWith("BindStatus") Then
            hfMode.Value = "Status"
            Dim status = e.Parameters.Split("|")(1)
            CurrentStatus = CType(status, LeadStatus)
            AgentCharts.LeadsCategory = CurrentStatus
            gridReport.DataBind()
        End If

        If e.Parameters.StartsWith("BindOffice") Then
            hfMode.Value = "Office"
            CurrentOffice = e.Parameters.Split("|")(1)
            gridReport.DataBind()
        End If

        'gridReport.DataBind()
    End Sub

    Protected Sub Unnamed_ServerClick(sender As Object, e As EventArgs)
        gridExport.WriteXlsToResponse()
    End Sub

    Protected Sub infoCallback_Callback(sender As Object, e As DevExpress.Web.ASPxClasses.CallbackEventArgsBase)
        If e.Parameter.StartsWith("EMP") Then
            If Not String.IsNullOrEmpty(e.Parameter) Then
                CurrentEmployee = Employee.GetInstance(CInt(e.Parameter.Split("|")(1)))
                hfEmpName.Value = CurrentEmployee.Name
            End If
        End If

        If e.Parameter.StartsWith("Status") Then
            hfMode.Value = "Status"
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

        If e.Parameter.StartsWith("RemoveReport") Then
            Dim name = e.Parameter.Replace("RemoveReport|", "")
            Dim up = Employee.GetProfile(Page.User.Identity.Name)

            If up.ReportTemplates Is Nothing Then
                Return
            End If

            If up.ReportTemplates.ContainsKey(name) Then
                up.ReportTemplates.Remove(name)
            End If

            Employee.SaveProfile(User.Identity.Name, up)
        End If
    End Sub

    Protected Sub gridReport_Init(sender As Object, e As EventArgs)
        LoadGridColumn()
    End Sub

    Function GetTemplates() As StringDictionary
        Dim up = Employee.GetProfile(User.Identity.Name)
        Return up.ReportTemplates
    End Function

    Sub BindEmp()
        If User.IsInRole("Admin") Then
            gridEmps.DataSource = portalDataContext.Employees.OrderBy(Function(em) em.Name).ToList
            Return
        End If

        Dim emps As New List(Of Employee)

        Dim offices = "Bronx,Patchen,Queens,Rockaway"

        For Each office In offices.Split(",")
            If User.IsInRole("OfficeManager-" & office) Then
                emps.AddRange(Employee.GetDeptUsersList(office))
            End If
        Next

        If Employee.HasSubordinates(User.Identity.Name) Then
            emps.AddRange(Employee.GetManagedEmployeeList(User.Identity.Name))
        End If

        gridEmps.DataSource = emps.Distinct.OrderBy(Function(em) em.Name).ToList
    End Sub

    Sub BindGridReport()
        If Not String.IsNullOrEmpty(hfMode.Value) Then
            'Load lead by Status
            If hfMode.Value = "Status" Then

                Dim reports = (From li In portalDataContext.LeadsInfoes Join
                                      ld In portalDataContext.Leads On ld.BBLE Equals li.BBLE
                                      Where ld.Status = CurrentStatus
                                      Select li).ToList
                gridReport.DataSource = reports
            End If

            'Load lead by Office
            If hfMode.Value = "Office" Then

                Dim emps = Employee.GetAllDeptUsers(CurrentOffice)

                Dim reports = (From li In portalDataContext.LeadsInfoes Join
                                    ld In portalDataContext.Leads On ld.BBLE Equals li.BBLE
                                    Where emps.Contains(ld.EmployeeName)
                                    Select li).ToList
                gridReport.DataSource = reports
            End If
        Else
            Dim name = hfEmpName.Value
            Dim reports = (From li In portalDataContext.LeadsInfoes Join
                                       ld In portalDataContext.Leads On ld.BBLE Equals li.BBLE
                                       Where ld.EmployeeName = name
                                       Select li).ToList
            gridReport.DataSource = reports
        End If
    End Sub

    Protected Sub show_grid_by_items(isInit As Boolean)
        'init_grid_by_items(chkFields.Items, isInit)
        'init_grid_by_items(chkFields2.Items, isInit)
        'LoadGridColumn(chkFields.Items)
        'LoadGridColumn(chkFields2.Items)
    End Sub

    Sub LoadGridColumn()
        Dim fields = GetFlieds()

        If String.IsNullOrEmpty(fields) Then
            fields = "PropertyAddress,BBLE"
        End If

        LoadGridColumn(fields)
    End Sub

    Sub LoadGridColumn(collectItems As String)
        SetFlieds(collectItems)

        gridReport.Columns.Clear()
        For Each item In collectItems.Split(",")
            Dim gridCol = New GridViewDataColumn
            gridCol.FieldName = item
            gridReport.Columns.Add(gridCol)
        Next
    End Sub

    Protected Sub init_grid_by_items(collectItems As ListEditItemCollection, isAdd As Boolean)
        If collectItems.Count > 0 Then
            For Each item As ListEditItem In collectItems
                Dim gridCol = New GridViewDataColumn
                If Not isAdd Then
                    gridCol = gridReport.Columns(item.Value)

                    If gridCol Is Nothing Then
                        gridCol = New GridViewDataColumn
                        gridCol.FieldName = item.Value
                    End If
                Else
                    gridCol.FieldName = item.Value
                End If

                If item.Selected Then
                    gridCol.Visible = True
                    If gridReport.Columns(item.Value) Is Nothing Then
                        gridReport.Columns.Add(gridCol)
                    End If
                Else
                    If gridReport.Columns(item.Value) IsNot Nothing Then
                        gridReport.Columns.Remove(gridCol)
                    End If
                End If

                If isAdd Then
                    'gridReport.Columns.Add(gridCol)
                End If
            Next
        End If
    End Sub

#Region "Helper methods"

    Function GetReportColumns() As String
        Dim cols As New List(Of String)

        For Each col As GridViewDataColumn In gridReport.Columns
            cols.Add(col.FieldName)
        Next

        Return String.Join(",", cols)
    End Function

    Function GetFlieds() As String
        If Request.Cookies("ReportFields") Is Nothing Then
            Return ""
        Else
            Return Request.Cookies.Item("ReportFields").Value
        End If
    End Function

    Sub SetFlieds(fields As String)
        If Response.Cookies("ReportFields") Is Nothing Then
            Response.Cookies.Add(New HttpCookie("ReportFields", fields))
        Else
            Response.Cookies.Item("ReportFields").Value = fields
        End If
    End Sub
#End Region

End Class
