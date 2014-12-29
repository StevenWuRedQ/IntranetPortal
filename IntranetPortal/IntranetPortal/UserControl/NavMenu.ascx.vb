Imports System.Web.Script.Serialization
Imports IntranetPortal.Messager
Imports System.Data.SqlClient

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

        Using ctx As New Entities
            For Each t In ctx.Teams.OrderBy(Function(r) r.Name)
                Dim item As New PortalNavItem
                item.Name = String.Format("Team-{0}-Management", t.TeamId)
                item.Text = t.Name
                item.NavigationUrl = "#"
                item.ShowAmount = True
                BuildTeamMenu(item, t.TeamId, t.Name)
                item.UserRoles = "OfficeManager-" & t.Name

                teamList.Add(item)
            Next
        End Using

        Dim teamMgr = menus.Where(Function(mi) mi.Name = "OfficeManagement").Single
        teamMgr.Items.AddRange(teamList)
    End Sub

    Shared Sub BuildTeamMenu(item As PortalNavItem, teamId As Integer, teamName As String)
        If item.Items Is Nothing Then
            item.Items = New List(Of PortalNavItem)
        End If

        item.Items.Add(GetTeamAssignItem(teamId, teamName, "fa-check-square-o"))
        item.Items.Add(GetTeamNavItem("New Leads", teamId, "fa-star"))
        item.Items.Add(GetTeamNavItem("Hot Leads", teamId, "fa-sun-o"))
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
                         .Count = GetLeadsCount(item.Name, item.Text, context.User.Identity.Name, context)
                                }

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

    Public Function GetLeadsCount(name As String, itemText As String, userName As String, context As HttpContext) As Integer
        If name.StartsWith("Agent") Then
            Return Utility.GetLeadsCount(Utility.GetLeadStatus(itemText), userName)
        End If

        If name.StartsWith("Mgr") Then
            Dim emps = Employee.GetManagedEmployees(userName)
            Return Utility.GetMgrLeadsCount(Utility.GetLeadStatus(itemText), emps)
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
            Return GetShortSaleCaseCount(name, itemText, userName)
        End If

        If name.StartsWith("MyTask") Then
            Return GetMyTaskCount()
        End If

        If name.StartsWith("MyApplication") Then
            Return GetMyApplicationCount(userName)
        End If

        If name.StartsWith("MyCompleted") Then
            Return GetMyCompletedCount(userName)
        End If
    End Function

    Function GetMyTaskCount() As Integer
        Try
            Return WorkflowService.GetMyWorklist().Count
        Catch ex As Exception
            Return 0
        End Try
    End Function

    Function GetMyApplicationCount(userName As String) As Integer
        Try
            Return WorkflowService.GetMyOriginated(userName).Count
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
                Case "All"
                    Dim count = GetShortSaleCaseByOwner(userName)
                    Return GetShortSaleCaseByOwner(userName)
                Case Else
                    Dim status As ShortSale.CaseStatus

                    If [Enum].TryParse(Of ShortSale.CaseStatus)(type, status) Then
                        If (Employee.IsShortSaleManager(userName)) Then
                            Return ShortSale.ShortSaleCase.GetCaseCount(status)
                        End If

                        Return ShortSale.ShortSaleCase.GetCaseCount(status, userName)
                    Else
                        Return 0
                    End If
            End Select
        End If
    End Function
    Function GetShortSaleCaseByOwner(userName As String) As Integer
        Using context As New Entities
            Dim bbles As List(Of String) = context.Leads.Where(Function(l) l.Status = LeadStatus.InProcess AndAlso l.EmployeeName = userName).Select(Function(l) l.BBLE).ToList
            If Utility.IsAny(bbles) Then
                Return ShortSale.ShortSaleCase.GetCaseByBBLEs(bbles).Count
            End If
        End Using
        Return 0
    End Function
    'Function GetAllShortSaleByOwner(userName As String) As Integer
    '    Dim count = 0
    '    Using Context As New Entities
    '        Dim sqlConnect As New SqlConnection(Context.Database.Connection.ConnectionString)
    '        Dim cmd As New SqlCommand
    '        Dim reader As SqlDataReader
    '        cmd.CommandText = "SELECT COUNT(ShortSaleCases.BBLE) as Count FROM [ShortSaleCases] inner join Leads on Leads.BBLE  = ShortSaleCases.BBLE where leads.EmployeeName='" & userName & "' "
    '        cmd.CommandType = CommandType.Text
    '        cmd.Connection = sqlConnect

    '        sqlConnect.Open()

    '        reader = cmd.ExecuteReader()
    '        While (reader.Read())
    '            count = reader.GetInt32(0)
    '        End While
    '        sqlConnect.Close()
    '    End Using
    '    Return count
    'End Function
End Class