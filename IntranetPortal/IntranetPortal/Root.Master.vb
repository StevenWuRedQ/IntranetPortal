Public Class Root
    Inherits System.Web.UI.MasterPage

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        'MainSplitter.GetPaneByName("HeaderPane").Size = If(DevExpress.Web.ASPxWebControl.GlobalTheme = "Moderno", 101, 87)
        lblVersion.Text = String.Format("{2}: {0},{1}", System.Reflection.Assembly.GetExecutingAssembly().GetName().Version.ToString, Server.MachineName, Employee.Application.Name)

        If Page.IsCallback Then
            'BindSearchGrid("")
        End If
    End Sub

    Protected Sub gridSearch_CustomCallback(sender As Object, e As DevExpress.Web.ASPxGridViewCustomCallbackEventArgs)
        'Dim key = e.Parameters
        'BindSearchGrid(key)
    End Sub

    Private _empUnderMgred As String()
    Public ReadOnly Property EmpUnderManaged As String()
        Get
            If _empUnderMgred Is Nothing Then

                If Page.User.IsInRole("Admin") Or Page.User.IsInRole("Title-Users") Then

                    _empUnderMgred = Employee.GetAllEmps()
                Else
                    Dim emps = Employee.GetManagedEmployees(Page.User.Identity.Name, False).ToList
                    emps.AddRange(Employee.GetControledDeptEmployees(Page.User.Identity.Name).ToList)
                    _empUnderMgred = emps.ToArray
                End If
            End If
            Return _empUnderMgred
        End Get
    End Property

    Private _sharedBBLEs As String()
    Public ReadOnly Property SharedBBLEs As String()
        Get
            Using Context As New Entities
                If _sharedBBLEs Is Nothing Then
                    _sharedBBLEs = Context.SharedLeads.Where(Function(sl) sl.UserName = Page.User.Identity.Name).Select(Function(sl) sl.BBLE).ToArray
                End If

                Return _sharedBBLEs
            End Using
        End Get
    End Property

    Private _viewable As Boolean? = Nothing
    Public ReadOnly Property ShortMenuViewable As Boolean
        Get
            If _viewable.HasValue Then
                Return _viewable
            End If

            _viewable = ShortSaleManage.IsViewable(Nothing, Page.User.Identity.Name)
            Return _viewable
        End Get
    End Property

    Sub BindSearchGrid(key As String, appId As Integer)
        key = txtSearchKey.Text
        If String.IsNullOrEmpty(key) Then
            Return
        End If

        ' remove the given teams search whole portal permission
        'Dim denyTeams = {"RonTeam", "GaliTeam", "AviTeam"}
        'Dim emp = Employee.GetInstance(Page.User.Identity.Name)

        'If denyTeams.Contains(emp.Department) Then
        '    BindSearchGrid2(emp.Department, key, Employee.CurrentAppId)
        '    Return
        'End If
        ' end 

        If IsPhoneNo(key) Then
            Dim phoneNo = key.Replace("(", "").Replace(")", "").Replace("-", "")

            Using Context As New Entities
                Dim results = (From lead In Context.Leads.Where(Function(ld) ld.AppId = appId)
                               Join field In Context.HomeOwnerPhones On lead.BBLE Equals field.BBLE
                               Where field.Phone = phoneNo Or lead.BBLE.StartsWith(phoneNo)
                               Select lead).Union(Context.Leads.Where(Function(ld) ld.BBLE.StartsWith(phoneNo))).Distinct.ToList

                gridSearch.DataSource = results
                gridSearch.DataBind()
            End Using
        Else
            If IsApartmentSearch(key) Then
                Dim bble = key.Split("#")(0)
                Dim unitNum = key.Split("#")(1)

                Using ctx As New Entities
                    gridSearch.DataSource = ctx.Leads.Where(Function(ld) ld.LeadsInfo.BuildingBBLE = bble And ld.LeadsInfo.UnitNum = unitNum And ld.AppId = appId).ToList
                    gridSearch.DataBind()
                End Using
            Else
                Using Context As New Entities
                    gridSearch.DataSource = Context.Leads.Where(Function(ld) (ld.LeadsName.Contains(key) Or ld.BBLE.StartsWith(key)) And ld.AppId = appId).ToList
                    gridSearch.DataBind()
                End Using
            End If
        End If

        'add Search by steven

        If (gridSearch.DataSource Is Nothing Or gridSearch.GetRow(0) Is Nothing) Then
            Try
                Dim bble = Core.Utility.Address2BBLE(key)
                If (Not String.IsNullOrEmpty(bble)) Then
                    Using Context As New Entities
                        gridSearch.DataSource = Context.Leads.Where(Function(ld) ld.BBLE = bble And ld.AppId = appId).ToList
                        gridSearch.DataBind()
                    End Using
                End If

            Catch ex As Exception

            End Try

        End If
    End Sub

    Protected Sub HeadLoginStatus_LoggingOut(sender As Object, e As LoginCancelEventArgs)
        OnlineUser.LogoutUser(HttpContext.Current.User.Identity.Name)
    End Sub

    Function IsApartmentSearch(key As String) As Boolean
        Dim rx As New Regex("^\d{10}\#\w")
        Return rx.IsMatch(key)
    End Function

    Function IsPhoneNo(key As String) As Boolean
        Dim phoneNo = key.Replace("(", "").Replace(")", "").Replace("-", "")

        Dim result As Int64 = 0
        If phoneNo.Length = 10 AndAlso Int64.TryParse(phoneNo, result) Then
            Return True
        End If

        Return False
    End Function

    Protected Sub gridSearch_AfterPerformCallback(sender As Object, e As DevExpress.Web.ASPxGridViewAfterPerformCallbackEventArgs) Handles gridSearch.AfterPerformCallback
        BindSearchGrid("", Employee.CurrentAppId)
    End Sub

    Protected Sub btnLogOut_Click(sender As Object, e As EventArgs)
        FormsAuthentication.SignOut()
        FormsAuthentication.RedirectToLoginPage()
    End Sub

    Protected Sub pcMain_WindowCallback(source As Object, e As DevExpress.Web.PopupWindowCallbackArgs)
        popupContentSearchPanel.Visible = True
        'Dim menu = Page.LoadControl("~/UserControl/LeadsSubMenu.ascx")
        'popupContentSearchPanel.Controls.Add(menu)
        BindSearchGrid(e.Parameter, Employee.CurrentAppId)
    End Sub


    Sub BindSearchGrid2(teamName As String, key As String, appId As Integer)
        key = txtSearchKey.Text
        If String.IsNullOrEmpty(key) Then
            Return
        End If

        Dim users = Employee.GetDeptUsers(teamName, False)
        users = users.Concat(UserInTeam.GetTeamUsersArray(teamName, True)).Distinct.ToArray

        If IsPhoneNo(key) Then
            Dim phoneNo = key.Replace("(", "").Replace(")", "").Replace("-", "")

            Using Context As New Entities
                Dim results = (From lead In Context.Leads.Where(Function(ld) ld.AppId = appId And users.Contains(ld.EmployeeName))
                               Join field In Context.HomeOwnerPhones On lead.BBLE Equals field.BBLE
                               Where field.Phone = phoneNo Or lead.BBLE.StartsWith(phoneNo)
                               Select lead).Union(Context.Leads.Where(Function(ld) ld.BBLE.StartsWith(phoneNo))).Distinct.ToList

                gridSearch.DataSource = results
                gridSearch.DataBind()
            End Using
        Else
            If IsApartmentSearch(key) Then
                Dim bble = key.Split("#")(0)
                Dim unitNum = key.Split("#")(1)

                Using ctx As New Entities
                    gridSearch.DataSource = ctx.Leads.Where(Function(ld) ld.LeadsInfo.BuildingBBLE = bble And ld.LeadsInfo.UnitNum = unitNum And ld.AppId = appId And users.Contains(ld.EmployeeName)).ToList
                    gridSearch.DataBind()
                End Using
            Else
                Using Context As New Entities
                    gridSearch.DataSource = Context.Leads.Where(Function(ld) (ld.LeadsName.Contains(key) Or ld.BBLE.StartsWith(key)) And ld.AppId = appId And users.Contains(ld.EmployeeName)).ToList
                    gridSearch.DataBind()
                End Using
            End If
        End If

        'add Search by steven

        If (gridSearch.DataSource Is Nothing Or gridSearch.GetRow(0) Is Nothing) Then
            Try
                Dim bble = Core.Utility.Address2BBLE(key)
                If (Not String.IsNullOrEmpty(bble)) Then
                    Using Context As New Entities
                        gridSearch.DataSource = Context.Leads.Where(Function(ld) ld.BBLE = bble And ld.AppId = appId And users.Contains(ld.EmployeeName)).ToList
                        gridSearch.DataBind()
                    End Using
                End If

            Catch ex As Exception

            End Try

        End If
    End Sub

End Class