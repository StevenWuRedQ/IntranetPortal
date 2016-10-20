''' <summary>
''' The Portal navigation management
''' </summary>
Public Class PortalNavManage

    Private Shared XmlDataFile As String = "~/App_Data/PortalMenu.xml"
    Private Shared _navItems As List(Of PortalNavItem)

    ' get all menu
    Public Shared Function LoadMenuFromXml(context As HttpContext) As List(Of PortalNavItem)
        If _navItems Is Nothing Then
            Dim reader As New System.Xml.Serialization.XmlSerializer(GetType(List(Of PortalNavItem)))
            Dim file As New System.IO.StreamReader(context.Server.MapPath(XmlDataFile))
            Dim menuItems = CType(reader.Deserialize(file), List(Of PortalNavItem))
            file.Close()
            AddTeamsMenu(menuItems)
            _navItems = menuItems
        End If

        Return _navItems
    End Function

    Public Shared Function IsViewable(context As HttpContext) As Boolean
        Dim items = LoadMenuItem(context)

        If items Is Nothing AndAlso items.Count = 0 Then
            Return True
        End If

        Dim result = False
        For Each item In items
            Do While item.Name <> "Root"
                If String.IsNullOrEmpty(item.UserRoles) Then
                    item = item.Parent
                    Continue Do
                End If

                If item.IsUserRoles(context.User.Identity.Name) Then
                    Return True
                End If

                Continue For
            Loop
        Next

        Return False
    End Function

    Public Shared Function LoadMenuItem(context As HttpContext) As PortalNavItem()
        Dim page = context.Request.Url.AbsolutePath
        Dim item = GetAllMenuItems(LoadMenuFromXml(context)) _
                                  .Where(Function(a) a.NavigationUrl IsNot Nothing AndAlso a.NavigationUrl.ToLower.StartsWith(page.ToLower)).ToArray

        Return item
    End Function

    Public Shared Function GetAllMenuItems(navMenu As List(Of PortalNavItem), Optional parentMenu As PortalNavItem = Nothing, Optional results As List(Of PortalNavItem) = Nothing) As List(Of PortalNavItem)
        If parentMenu Is Nothing Then
            parentMenu = New PortalNavItem
            parentMenu.Name = "Root"
        End If

        If results Is Nothing Then
            results = New List(Of PortalNavItem)
        End If

        For Each item In navMenu
            item.Parent = parentMenu
            results.Add(item)

            If item.Items IsNot Nothing AndAlso item.Items.Count > 0 Then
                results = GetAllMenuItems(item.Items, item, results)
            End If
        Next

        Return results
    End Function

    Public Shared Function GetMyMenuItems(navMenu As List(Of PortalNavItem), userContext As HttpContext, Optional results As List(Of PortalNavItem) = Nothing) As List(Of PortalNavItem)
        If results Is Nothing Then
            results = New List(Of PortalNavItem)
        End If

        For Each item In navMenu
            If item.IsVisible(userContext) Then
                results.Add(item)

                If item.Items IsNot Nothing AndAlso item.Items.Count > 0 Then
                    results = GetMyMenuItems(item.Items, userContext, results)
                End If
            End If
        Next

        Return results
    End Function

    Shared Sub AddTeamsMenu(menus As List(Of PortalNavItem))
        Dim teamList As New List(Of PortalNavItem)

        For Each t In Team.GetActiveTeams()
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

    Shared Function GetTeamAssignItem(teamId As Integer, teamName As String, fontClass As String)
        Dim item As New PortalNavItem
        item.Name = String.Format("Team-{0}-AssignLeads", teamId)
        item.Text = "Assign Leads"
        item.NavigationUrl = String.Format("/Management/LeadsManagement.aspx?office={0}&team={1}", teamName, teamId)
        item.ShowAmount = True
        item.FontClass = String.Format("<i class=""fa {0}""></i>", fontClass)

        Return item
    End Function

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
End Class
