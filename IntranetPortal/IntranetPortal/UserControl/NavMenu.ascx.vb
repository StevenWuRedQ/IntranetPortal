Imports System.Web.Script.Serialization
Imports IntranetPortal.Messager

Public Class NavMenu
    Inherits System.Web.UI.UserControl

    Private Shared XmlDataFile As String = "~/App_Data/PortalMenu.xml"
    Public Property PortalMenuItems As List(Of PortalNavItem)

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        PortalMenuItems = LoadMenuFromXml(HttpContext.Current)
        'InitialMenu()
        'WriteXML()
    End Sub

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
            If item.Visible(userContext) Then
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
            Return ""
        End If

        'Select Case name
        '    Case "AgentNewLeads"
        '        Return Utility.GetLeadsCount(LeadStatus.NewLead, userName)
        '    Case "AgentHotLeads"
        '        Return Utility.GetLeadsCount(LeadStatus.Priority, userName)
        '    Case "AgentFollowUp"
        '        Return Utility.GetLeadsCount(LeadStatus.Callback, userName)
        '    Case "AgentDoorKnock"
        '        Return Utility.GetLeadsCount(LeadStatus.DoorKnocks, userName)
        '    Case "AgentInProcess"
        '        Return Utility.GetLeadsCount(LeadStatus.InProcess, userName)
        '    Case "AgentDeadLead"
        '        Return Utility.GetLeadsCount(LeadStatus.DeadEnd, userName)
        '    Case "AgentClosed"
        '        Return Utility.GetLeadsCount(LeadStatus.Closed, userName)
        'End Select

        'Dim emps = Employee.GetManagedEmployees(userName)

        'Select Case name
        '    Case "MgrNewLeads"
        '        Return Utility.GetMgrLeadsCount(LeadStatus.NewLead, emps)
        '    Case "MgrHotLeads"
        '        Return Utility.GetMgrLeadsCount(LeadStatus.Priority, emps)
        '    Case "MgrFollowUp"
        '        Return Utility.GetMgrLeadsCount(LeadStatus.Callback, emps)
        '    Case "MgrDoorKnock"
        '        Return Utility.GetMgrLeadsCount(LeadStatus.DoorKnocks, emps)
        '    Case "MgrInProcess"
        '        Return Utility.GetMgrLeadsCount(LeadStatus.InProcess, emps)
        '    Case "MgrDeadLead"
        '        Return Utility.GetMgrLeadsCount(LeadStatus.DeadEnd, emps)
        '    Case "MgrClosed"
        '        Return Utility.GetMgrLeadsCount(LeadStatus.Closed, emps)
        'End Select

    End Function

End Class