Imports DevExpress.Web
Imports System.Linq.Expressions

Public Class AgentOverview
    Inherits System.Web.UI.Page

    Public Property CurrentEmployee As Employee
    Public Property eID As Integer
    Public Property CurrentStatus As LeadStatus
    Public Property CurrentOffice As Office
    Public portalDataContext As New Entities

    Public Property ComparedEmps As New List(Of Employee)

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If String.IsNullOrEmpty(hfEmpName.Value) Then
            CurrentEmployee = Employee.GetInstance(User.Identity.Name)
            hfEmpName.Value = CurrentEmployee.Name
        Else
            CurrentEmployee = Employee.GetInstance(hfEmpName.Value)
        End If

        If Not String.IsNullOrEmpty(hfOfficeName.Value) Then
            CurrentOffice = Office.GetInstance(hfOfficeName.Value)
        End If

        'If Not ComparedEmps.Contains(CurrentEmployee) Then
        '    ComparedEmps.Add(CurrentEmployee)
        'End If

        If Not String.IsNullOrEmpty(CurrentEmployee.Picture) Then
            profile_image.ImageUrl = CurrentEmployee.Picture
        End If

        If Not IsPostBack Then
            gridEmps.DataBind()
            gridReport.DataBind()
            gridEmps.GroupBy(gridEmps.Columns("TeamName"))
        End If
    End Sub

    Protected Sub gridReport_DataBinding(sender As Object, e As EventArgs) Handles gridReport.DataBinding
        If gridReport.DataSource Is Nothing Then
            BindGridReport()
        End If
    End Sub

    Function getProfileImage(empID As Integer) As String
        Dim e = Employee.GetInstance(empID)
        If e IsNot Nothing Then
            Return If(e.Picture Is Nothing, "/images/user-empty-icon.png", e.Picture)
        End If

        Return "/images/user-empty-icon.png"
    End Function

    Protected Sub gridEmps_DataBinding(sender As Object, e As EventArgs) Handles gridEmps.DataBinding
        If gridEmps.DataSource Is Nothing Then
            BindEmp()
        End If
    End Sub

    Function getEmployeeByName(ByVal parametersStrg As String) As Employee
        Dim employeeID = CInt(parametersStrg.Split("|")(1))
        If (employeeID < 0) Then
            Return Employee.GetInstance(parametersStrg.Split("|")(2))
        End If
        Return Employee.GetInstance(employeeID)
    End Function

    Function EmployeeIDToName(parametersStrg As String) As String
        Dim employeeID = Employee.GetInstance(parametersStrg).EmployeeID
        Return employeeID.ToString
    End Function
    Protected Sub gridReport_CustomCallback(sender As Object, e As ASPxGridViewCustomCallbackEventArgs)
        If e.Parameters.StartsWith("BindEmp") Then
            CurrentEmployee = getEmployeeByName(e.Parameters)
            hfMode.Value = ""
            'AgentCharts.current_employee = CurrentEmployee.Name
            'AgentCharts.Agent_leads_activity_source()
            hfEmpName.Value = CurrentEmployee.Name
            gridReport.DataBind()
        End If

        If e.Parameters.StartsWith("LoadLayout") Then
            Dim report = e.Parameters.Split("|")(1)
            Dim up = Employee.GetProfile(User.Identity.Name)
            LoadGridColumn(up.ReportTemplates(report))
            SetFlieds(GetReportColumns())
            gridReport.DataBind()
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
            hfOfficeName.Value = e.Parameters.Split("|")(1)
            CurrentOffice = Office.GetInstance(hfOfficeName.Value)

            gridReport.DataBind()
        End If

        If e.Parameters.StartsWith("OfficeStatus") Then
            hfMode.Value = "OfficeStatus"
            hfOfficeName.Value = e.Parameters.Split("|")(1)
            CurrentOffice = Office.GetInstance(hfOfficeName.Value)
            CurrentStatus = CType(e.Parameters.Split("|")(2), LeadStatus)

            gridReport.DataBind()
        End If

        'gridReport.DataBind()
    End Sub

    Protected Sub Unnamed_ServerClick(sender As Object, e As EventArgs)
        gridExport.WriteXlsxToResponse()
    End Sub

    Protected Sub infoCallback_Callback(sender As Object, e As DevExpress.Web.CallbackEventArgsBase)
        If e.Parameter.StartsWith("EMP") Then
            If Not String.IsNullOrEmpty(e.Parameter) Then
                hfMode.Value = ""
                CurrentEmployee = getEmployeeByName(e.Parameter)
                hfEmpName.Value = CurrentEmployee.Name

                AgentInfoPanel.Visible = True
                OfficeInfoPanel.Visible = False
            End If
        End If

        If e.Parameter.StartsWith("OFFICE") Then
            hfMode.Value = "Office"
            hfOfficeName.Value = e.Parameter.Split("|")(1)
            CurrentOffice = Office.GetInstance(hfOfficeName.Value)

            AgentInfoPanel.Visible = False
            OfficeInfoPanel.Visible = True
        End If

        If e.Parameter.StartsWith("Status") Then
            hfMode.Value = "Status"
        End If
    End Sub

    Protected Sub callbackPnlTemplates_Callback(sender As Object, e As DevExpress.Web.CallbackEventArgsBase)
        If e.Parameter.StartsWith("AddReport") Then
            Dim name = e.Parameter.Split("|")(1)
            Dim up = Employee.GetProfile(Page.User.Identity.Name)

            If up.ReportTemplates Is Nothing Then
                up.ReportTemplates = New StringDictionary
            End If

            If up.ReportTemplates.ContainsKey(name) Then
                up.ReportTemplates(name) = GetReportColumns()
            Else
                up.ReportTemplates.Add(name, GetReportColumns())
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

    'Function GetOfficeMgr() As String
    '    Dim users = Roles.GetUsersInRole("OfficeManager-" & CurrentOffice.Name)
    '    Return String.Join(",", users)
    'End Function

    Function GetTemplates() As StringDictionary
        Dim up = Employee.GetProfile(User.Identity.Name)
        Return up.ReportTemplates
    End Function

    Function GetEmpDataSource()
        Return Employee.GetMyEmployeesByTeam(Page.User.Identity.Name) 'Employee.GetMyEmployees(Page.User.Identity.Name)
    End Function

    Sub BindEmp()
        Dim ds = GetEmpDataSource()
        gridEmps.DataSource = ds
    End Sub

    Sub BindGridReport()
        If Not String.IsNullOrEmpty(hfMode.Value) Then
            'Load lead by Status
            If hfMode.Value = "Status" Then

                Dim reports = (From li In portalDataContext.LeadsInfoes Join
                                      ld In portalDataContext.Leads On ld.BBLE Equals li.BBLE
                                      Where ld.Status = CurrentStatus
                                      Select li).ToList
                'Dim reports = portalDataContext.LeadsInfoViews.Where(Function(li) li.Status = CurrentStatus)
                gridReport.DataSource = reports
            End If

            'Load lead by Office
            If hfMode.Value = "Office" Then

                Dim emps = CurrentOffice.Users

                Dim reports = (From li In portalDataContext.LeadsInfoes Join
                                    ld In portalDataContext.Leads On ld.BBLE Equals li.BBLE
                                    Where emps.Contains(ld.EmployeeName)
                                    Select li).ToList
                gridReport.DataSource = reports
            End If

            If hfMode.Value = "OfficeStatus" Then
                Dim emps = CurrentOffice.Users

                Dim reports = (From li In portalDataContext.LeadsInfoes Join
                                  ld In portalDataContext.Leads On ld.BBLE Equals li.BBLE
                                  Where emps.Contains(ld.EmployeeName) And ld.Status = CurrentStatus
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

        Dim colProp = gridReport.Columns("PropertyAddress")
        gridReport.Columns.Clear()
        For Each item In collectItems.Split(",")

            Dim gridCol = New GridViewDataColumn
            If item = "PropertyAddress" Then
                gridReport.Columns.Add(colProp)
            Else
                gridCol.FieldName = item

                If item = "LastUpdate2" Then
                    gridCol.Caption = "Last Update"
                End If

                gridReport.Columns.Add(gridCol)
            End If
        Next
    End Sub

   

    Public _allEmps As List(Of Employee)
    Public Function allEmpoyeeName() As List(Of Employee)
        If _allEmps Is Nothing Then
            Using Context As New Entities
                _allEmps = (From p In Context.Employees Select p).ToList
            End Using
        End If

        Return _allEmps
    End Function

    Protected Sub getEmployeeIDByName_Callback(source As Object, e As DevExpress.Web.CallbackEventArgs)
        e.Result = EmployeeIDToName(e.Parameter)
    End Sub

    Protected Sub cbPnlCompare_Callback(sender As Object, e As DevExpress.Web.CallbackEventArgsBase)
        If e.Parameter = "CompareEmp" Then
            If String.IsNullOrEmpty(hfComparedEmps.Value) Or Not hfComparedEmps.Value.StartsWith(CurrentEmployee.EmployeeID) Then
                ComparedEmps.Add(CurrentEmployee)
                SaveComparedEmps()
            Else
                LoadComparedEmps()
            End If
        End If

        If e.Parameter = "AddNewEmp" Then
            LoadComparedEmps()
            Dim emp = New Employee
            ComparedEmps.Add(emp)
            SaveComparedEmps()
        End If

        If e.Parameter.StartsWith("ChangeEmp") Then
            Dim oldEmp = e.Parameter.Split("|")(1)
            Dim newEmp = e.Parameter.Split("|")(2)
            ChangeId(oldEmp, newEmp)
            LoadComparedEmps()
        End If

        If e.Parameter.StartsWith("ChangeDate") Then
            LoadComparedEmps()

            For Each emp In ComparedEmps
                emp.Performance.DateRange = e.Parameter.Split("|")(1)
            Next
        End If
    End Sub

    Sub ChangeId(oldEmp As String, newEmp As String)
        Dim empIds = hfComparedEmps.Value.Split(",")

        For i = 0 To empIds.Length - 1
            If empIds(i) = oldEmp Then
                empIds(i) = newEmp

                Exit For
            End If
        Next

        hfComparedEmps.Value = String.Join(",", empIds)
    End Sub

    Sub SaveComparedEmps()
        hfComparedEmps.Value = String.Join(",", ComparedEmps.Select(Function(em) em.EmployeeID).ToArray)
    End Sub

    Sub LoadComparedEmps()
        If String.IsNullOrEmpty(hfComparedEmps.Value) Then
            Return
        End If

        For Each empId In hfComparedEmps.Value.Split(",")
            If empId = 0 Then
                ComparedEmps.Add(New Employee)
            Else
                Dim emp = Employee.GetInstance(CInt(empId))
                If ComparedEmps.Where(Function(em) em.EmployeeID = emp.EmployeeID).Count = 0 Then
                    ComparedEmps.Add(emp)
                End If
            End If
        Next
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
