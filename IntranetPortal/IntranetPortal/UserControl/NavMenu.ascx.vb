Imports System.Web.Script.Serialization
Imports IntranetPortal.Messager
Imports System.Data.SqlClient
Imports ShortSale = IntranetPortal.Data
Imports legal = IntranetPortal.Data

Public Class NavMenu
    Inherits System.Web.UI.UserControl

    Private Shared XmlDataFile As String = "~/App_Data/PortalMenu.xml"
    Public Property PortalMenuItems As List(Of PortalNavItem)

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        PortalMenuItems = LoadMenuFromXml(HttpContext.Current)

        'InitialMenu()
        'WriteXML()

    End Sub

    Shared Sub AddTeamsMenu(menus As List(Of PortalNavItem))
        Dim teamList As New List(Of PortalNavItem)

        For Each t In Team.GetAllTeams()
            Dim item As New PortalNavItem
            item.Name = String.Format("Team-{0}-Management", t.TeamId)
            item.Text = t.Name
            item.NavigationUrl = "#"
            item.ShowAmount = True
            BuildTeamMenu(item, t.TeamId, t.Name)
            item.UserRoles = "OfficeManager-" & t.Name

            teamList.Add(item)
        Next

        Dim teamMgr = menus.Where(Function(mi) mi.Name = "OfficeManagement").Single
        teamMgr.Items.AddRange(teamList)
    End Sub

    Shared Sub BuildTeamMenu(item As PortalNavItem, teamId As Integer, teamName As String)
        If item.Items Is Nothing Then
            item.Items = New List(Of PortalNavItem)
        End If

        item.Items.Add(GetTeamAssignItem(teamId, teamName, "fa-check-square-o"))
        item.Items.Add(GetTeamNavItem("New Leads", teamId, "fa-star"))
        item.Items.Add(GetTeamNavItem("Hot Leads", teamId, "glyphicon glyphicon-fire"))
        item.Items.Add(GetTeamNavItem("LoanMod", teamId, "fa-money"))
        item.Items.Add(GetTeamNavItem("Warm", teamId, "fa-circle-o"))
        item.Items.Add(GetTeamNavItem("Follow Up", teamId, "fa-rotate-right"))
        item.Items.Add(GetTeamNavItem("Door Knock", teamId, "fa-sign-in"))
        item.Items.Add(GetTeamNavItem("In Process", teamId, "fa-refresh"))
        item.Items.Add(GetTeamNavItem("Dead Lead", teamId, "fa-times-circle"))
        item.Items.Add(GetTeamNavItem("Closed", teamId, "fa-check-circle"))

    End Sub

    Shared Function GetTeamNavItem(type As String, teamId As Integer, fontClass As String)
        Dim item As New PortalNavItem
        item.Name = String.Format("Team-{0}-{1}", teamId, type.Replace(" ", ""))
        item.Text = type
        item.NavigationUrl = String.Format("/MgrViewLeads.aspx?c={0}&amp;team={1}", type, teamId)
        item.ShowAmount = True
        item.FontClass = String.Format("<i class=""fa {0}""></i>", fontClass)

        If type = "In Process" Then
            item.Items = New List(Of PortalNavItem)
            item.Items.AddRange({New PortalNavItem With {
                                .Name = String.Format("{0}-ShortSale", item.Name),
                                .Text = "Short Sale",
                                .NavigationUrl = String.Format("/MgrViewLeads.aspx?c={0}&amp;team={1}&amp;t=ShortSale", type, teamId), '"/MgrViewLeads.aspx?t=ShortSale&amp;teamId=" & teamId,
                                .ShowAmount = True,
                                .FontClass = "<i class=""fa fa-line-chart""></i>",
                                .AmountManageClass = "LeadManage"
                                }, New PortalNavItem With {
                                .Name = String.Format("{0}-Eviction", item.Name),
                                .Text = "Eviction",
                                .NavigationUrl = String.Format("/MgrViewLeads.aspx?c={0}&amp;team={1}&amp;t=Eviction", type, teamId),
                                .ShowAmount = True,
                                .FontClass = "<i class=""fa fa-sign-out""></i>",
                                .AmountManageClass = "LeadManage"
                                }, New PortalNavItem With {
                                .Name = String.Format("{0}-Construction", item.Name),
                                .Text = "Construction",
                                .NavigationUrl = String.Format("/MgrViewLeads.aspx?c={0}&amp;team={1}&amp;t=Construction", type, teamId),
                                .ShowAmount = True,
                                .FontClass = "<i class=""fa  fa-wrench""></i>",
                                .AmountManageClass = "LeadManage"
                                }, New PortalNavItem With {
                                .Name = String.Format("{0}-Legal", item.Name),
                                .Text = "Litigation",
                                .NavigationUrl = String.Format("/MgrViewLeads.aspx?c={0}&amp;team={1}&amp;t=Legal", type, teamId),
                                .ShowAmount = True,
                                .FontClass = "<i class=""fa fa-university""></i>",
                                .AmountManageClass = "LeadManage"
                                }
                           })
        End If

        Return item
    End Function

    Shared Function GetTeamAssignItem(teamId As Integer, teamName As String, fontClass As String)
        Dim item As New PortalNavItem
        item.Name = String.Format("Team-{0}-AssignLeads", teamId)
        item.Text = "Assign Leads"
        item.NavigationUrl = String.Format("/Management/LeadsManagement.aspx?office={0}&team={1}", teamName, teamId)
        item.ShowAmount = True
        item.FontClass = String.Format("<i class=""fa {0}""></i>", fontClass)

        Return item
    End Function

    Public Sub InitialMenu()
        Dim item As New PortalNavItem
        item.Name = "Manager"
        item.Text = "Manager"
        item.NavigationUrl = "/summary.aspx"

        PortalMenuItems = New List(Of PortalNavItem)
        PortalMenuItems.Add(item)
    End Sub

    Public Sub WriteXML()
        Dim writer As New System.Xml.Serialization.XmlSerializer(GetType(List(Of PortalNavItem)))
        Dim file As New System.IO.StreamWriter(Server.MapPath(XmlDataFile))
        writer.Serialize(file, PortalMenuItems)
        file.Close()
    End Sub

    Public Shared Function LoadMenuFromXml(context As HttpContext) As List(Of PortalNavItem)
        Dim reader As New System.Xml.Serialization.XmlSerializer(GetType(List(Of PortalNavItem)))
        Dim file As New System.IO.StreamReader(context.Server.MapPath(XmlDataFile))
        Dim menuItems = CType(reader.Deserialize(file), List(Of PortalNavItem))
        file.Close()
        AddTeamsMenu(menuItems)
        Return menuItems
    End Function
End Class

Public Class RefreshLeadsCountHandler
    Implements IHttpAsyncHandler

    Private _Delegate As AsyncProcessorDelegate
    Protected Delegate Sub AsyncProcessorDelegate(context As HttpContext)

    Public Function BeginProcessRequest(context As HttpContext, cb As AsyncCallback, extraData As Object) As IAsyncResult Implements IHttpAsyncHandler.BeginProcessRequest
        'Refresh online user list
        'OnlineUser.Refresh(HttpContext.Current)

        _Delegate = New AsyncProcessorDelegate(AddressOf ProcessRequest)
        Return _Delegate.BeginInvoke(context, cb, extraData)
    End Function

    Public Sub EndProcessRequest(result As IAsyncResult) Implements IHttpAsyncHandler.EndProcessRequest

    End Sub

    Public ReadOnly Property IsReusable As Boolean Implements IHttpHandler.IsReusable
        Get

        End Get
    End Property

    Public Sub ProcessRequest(context As HttpContext) Implements IHttpHandler.ProcessRequest
        Dim items = GetAllMenuItems(NavMenu.LoadMenuFromXml(context), context)
        Dim results = From item In items.Where(Function(nav) nav.ShowAmount = True)
                     Select New With {
                         .Name = item.LeadsCountSpanId,
                         .Count = GetAmount(item, context.User.Identity.Name, context)
                                }
        ''GetLeadsCount(item.Name, item.Text, context.User.Identity.Name, context)
        Dim json As New JavaScriptSerializer
        Dim jsonString = json.Serialize(results)

        If results IsNot Nothing Then
            context.Response.Clear()
            context.Response.ContentType = "text/html"
            context.Response.Write(jsonString)
            context.Response.End()
        End If
    End Sub

    Public Function GetAllMenuItems(navMenu As List(Of PortalNavItem), userContext As HttpContext, Optional results As List(Of PortalNavItem) = Nothing) As List(Of PortalNavItem)
        If results Is Nothing Then
            results = New List(Of PortalNavItem)
        End If

        For Each item In navMenu
            If item.IsVisible(userContext) Then
                results.Add(item)

                If item.Items IsNot Nothing AndAlso item.Items.Count > 0 Then
                    results = GetAllMenuItems(item.Items, userContext, results)
                End If
            End If
        Next

        Return results
    End Function

    Public Function GetAmount(item As PortalNavItem, userName As String, context As HttpContext) As Integer

        If Not String.IsNullOrEmpty(item.AmountManageClass) Then
            Try
                Dim myObj = CType(Activator.CreateInstance(Type.GetType("IntranetPortal." & item.AmountManageClass)), INavMenuAmount)

                If myObj IsNot Nothing Then
                    Return myObj.GetAmount(item, userName)
                End If
            Catch ex As Exception
                Return 0
            End Try
        Else
            Return GetLeadsCount(item.Name, item.Text, context.User.Identity.Name, context)
        End If
    End Function

    Public Function GetLeadsCount(name As String, itemText As String, userName As String, context As HttpContext) As Integer
        If name.StartsWith("Agent") Then
            If itemText = "3rd Party" Then
                Return Lead.Get3rdPartyLeads({userName}).Count
            Else
                Return Utility.GetLeadsCount(Utility.GetLeadStatus(itemText), userName)
            End If
        End If

        If name.StartsWith("Mgr") Then
            Dim emps = Employee.GetManagedEmployees(userName)
            If itemText = "3rd Party" Then
                Return Lead.Get3rdPartyLeads(emps).Count
            Else
                Return Utility.GetMgrLeadsCount(Utility.GetLeadStatus(itemText), emps)
            End If
        End If

        If name.StartsWith("Task") Then
            Return UserTask.GetTaskCount(userName, context)
        End If

        If name = "AssignLeads" Then
            Return Utility.GetUnAssignedLeadsCount(context)
        End If

        If name.StartsWith("Office") Then
            Return GetOfficeLeadsCount(name, itemText)
        End If

        If name.StartsWith("Team") Then
            Return GetTeam2LeadsCount(name, itemText)
        End If

        If name.StartsWith("ShortSale") Then
            Try
                Return GetShortSaleCaseCount(name, itemText, userName)
            Catch ex As Exception
                IntranetPortal.Core.SystemLog.Log("Error in Refresh System log", String.Format("Message:{0}, Stack: {1}", ex.Message, ex.StackTrace), "Error", "", userName)
                Return 0
            End Try
        End If

        If name.StartsWith("Eviction") Then
            Return ShortSale.ShortSaleCase.GetEvictionCases().Count
        End If

        If name.StartsWith("MyTask") Then
            Return GetMyTaskCount()
        End If

        If name.StartsWith("MyApplication") Then
            Return GetMyApplicationCount(name, userName)
        End If

        If name.StartsWith("MyCompleted") Then
            Return GetMyCompletedCount(userName)
        End If

        If name.StartsWith("Legal") Then
            Return GetLegalCaseCount(name, itemText, userName)
        End If

    End Function

    Function GetLegalCaseCount(name As String, itemText As String, userName As String) As Integer
        Dim tmpStr = name.Split("-")

        If tmpStr.Length > 0 Then
            Dim type = tmpStr(1)

            Dim status As Legal.LegalCaseStatus

            If [Enum].TryParse(Of Legal.LegalCaseStatus)(type, status) Then
                Return LegalCaseManage.GetLegalLightCaseList(userName, status).Count
            Else
                Return 0
            End If
        End If
    End Function

    Function GetMyTaskCount() As Integer
        Try
            Return WorkflowService.GetMyWorklist().Count
        Catch ex As Exception
            Return 0
        End Try
    End Function

    Function GetMyApplicationCount(name As String, userName As String) As Integer
        Try
            Dim status = name.Split("_")(1)
            Return WorkflowService.GetMyOriginated(userName).Where(Function(pi) pi.Status = status).Count
        Catch ex As Exception
            Return 0
        End Try
    End Function

    Function GetMyCompletedCount(userName As String) As Integer
        Try
            Return WorkflowService.GetMyCompleted(userName).Count
        Catch ex As Exception
            Return 0
        End Try
    End Function

    Function GetTeam2LeadsCount(name As String, itemText As String) As Integer
        'Dim mgrId = CInt(name.Split("-")(1))

        Dim tmpStr = name.Split("-")

        If tmpStr.Length > 2 Then
            Dim teamId = CInt(tmpStr(1))
            Dim type = tmpStr(2)

            Select Case type
                Case "AssignLeads"
                    Return Utility.GetTeamUnAssignedLeadsCount(teamId)
                Case "Management"
                    Return Utility.GetTeamLeadsCount(LeadStatus.ALL, teamId) + Utility.GetTeamUnAssignedLeadsCount(teamId)
                Case "InProcess"
                    If tmpStr.Length = 4 Then
                        Dim subCategory = tmpStr(3)
                        If subCategory.StartsWith("ShortSale") Then
                            Return GetTeamShortSale(teamId)
                        End If

                        If subCategory.StartsWith("Eviction") Then
                            Return GetTeamEviction(teamId)
                        End If

                        Return 0
                    Else
                        Return Utility.GetTeamLeadsCount(Utility.GetLeadStatus(itemText), teamId)
                    End If
                Case Else
                    Return Utility.GetTeamLeadsCount(Utility.GetLeadStatus(itemText), teamId)
            End Select
        End If
    End Function

    Function GetTeamLeadsCount(name As String, itemText As String) As Integer
        'Dim mgrId = CInt(name.Split("-")(1))

        Dim tmpStr = name.Split("-")

        If tmpStr.Length > 2 Then
            Dim mgrId = CInt(tmpStr(1))
            Dim type = tmpStr(2)
            Dim mgrName = Employee.GetInstance(mgrId).Name
            Select Case type
                Case "AssignLeads"
                    Return Utility.GetTeamUnAssignedLeadsCount(mgrName)
                Case "Management"
                    Return Utility.GetMgrLeadsCount(LeadStatus.ALL, Employee.GetManagedEmployees(mgrName))
                Case Else
                    Return Utility.GetMgrLeadsCount(Utility.GetLeadStatus(itemText), Employee.GetManagedEmployees(mgrName))
            End Select
        End If
    End Function

    Function GetOfficeLeadsCount(name As String, itemText As String) As Integer
        Dim tmpStr = name.Split("-")

        If tmpStr.Length > 2 Then
            Dim office = tmpStr(1)
            Dim type = tmpStr(2)

            Select Case type
                Case "AssignLeads"
                    Return Utility.GetUnAssignedLeadsCount(office)
                Case "Management"
                    Return Utility.GetOfficeLeadsCount(LeadStatus.ALL, office) + Utility.GetUnAssignedLeadsCount(office)
                Case Else
                    Return Utility.GetOfficeLeadsCount(Utility.GetLeadStatus(itemText), office)
            End Select
        End If
    End Function

    Function GetShortSaleCaseCount(name As String, itemText As String, userName As String) As Integer
        Dim tmpStr = name.Split("-")

        If tmpStr.Length > 1 Then
            Dim type = tmpStr(1)

            Select Case type
                Case "AssignLeads"
                    Return 0 'Utility.GetUnAssignedLeadsCount(Office)  
                Case "Manager"
                    If tmpStr.Length = 3 Then
                        Dim subCategory = tmpStr(2)
                        Dim users = Employee.GetManagedEmployees(userName)

                        If subCategory = "All" Then
                            Return ShortSaleManage.GetShortSaleCasesByUsers(users).Count
                        End If

                        If subCategory = "Eviction" Then
                            Return ShortSaleManage.GetEvictionCasesByUsers(users).Count
                        End If
                    End If

                    Return 0
                Case "Agent"
                    If tmpStr.Length = 3 Then
                        Dim subCategory = tmpStr(2)

                        If subCategory = "All" Then
                            Return ShortSaleManage.GetShortSaleCasesByUsers({userName}).Count
                        End If

                        If subCategory = "Eviction" Then
                            Return ShortSaleManage.GetEvictionCasesByUsers({userName}).Count
                        End If
                    End If

                    Return 0
                Case "Category"
                    If tmpStr.Length = 3 Then
                        Dim category = tmpStr(2)

                        If (Employee.IsShortSaleManager(userName)) Then
                            Return ShortSale.ShortSaleCase.GetCaseByCategory(category, Employee.GetInstance(userName).AppId).Count
                        End If

                        Return ShortSale.ShortSaleCase.GetCaseByCategory(category, Employee.GetInstance(userName.ToString).AppId, Employee.GetManagedEmployees(userName)).Count
                    End If
                Case Else
                    Dim status As ShortSale.CaseStatus

                    If [Enum].TryParse(Of ShortSale.CaseStatus)(type, status) Then
                        If (Employee.IsShortSaleManager(userName)) Then
                            Return ShortSale.ShortSaleCase.GetCaseCount(status, Employee.GetInstance(userName).AppId)
                        End If

                        Return ShortSale.ShortSaleCase.GetCaseCount(status, Employee.GetManagedEmployees(userName), Employee.GetInstance(userName).AppId)
                    Else
                        Return 0
                    End If
            End Select
        End If
    End Function

    Function GetShortSaleCaseByOwner(userName As String) As Integer
        Return GetShortSaleCountByUsers({userName})
    End Function

    Function GetTeamShortSale(teamId As Integer) As Integer
        Dim users = Employee.GetAllTeamUsers(teamId)
        Return GetShortSaleCountByUsers(users)
    End Function

    Function GetManagerShortSale(mgr As String) As Integer
        Dim users = Employee.GetManagedEmployees(mgr)
        Return GetShortSaleCountByUsers(users)
    End Function

    Function GetTeamEviction(teamId As Integer) As Integer
        Dim users = Employee.GetAllTeamUsers(teamId)
        Return ShortSaleManage.GetEvictionCasesByUsers(users).Count
    End Function

    Function GetShortSaleCountByUsers(users As String()) As Integer
        Return ShortSaleManage.GetShortSaleCasesByUsers(users).Count
    End Function
End Class