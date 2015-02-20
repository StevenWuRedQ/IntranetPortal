Imports DevExpress.Web.ASPxEditors
Imports DevExpress.Web.ASPxClasses
Imports DevExpress.Web.ASPxTreeView

Public Class Default2
    Inherits System.Web.UI.Page
    Private layoutFomat = "<table><tr><td style=""width: 120px;"">{0}</td><td><div class=""raund-label2"">{1}</div></td></tr></table>"

    Public ContentUrl As String = "/SummaryPage.aspx"
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not String.IsNullOrEmpty(Request.QueryString("key")) Then
            contentUrl = String.Format("/LeadAgent.aspx?c=Search&key={0}&id={1}", Request.QueryString("key"), Request.QueryString("id"))
        End If

        'Change layout by steven

        'Use the font image to the text
        'Dim layoutFomatRed = "<table><tr><td style=""width: 120px;"">{0}</td><td><div class=""raund-label2"" style=""background: #ff400d;"">{1}</div></td></tr></table>"

        'Dim taskNode = AgentTree.Nodes.FindByName("TaskNode")
        'taskNode.Text = String.Format(layoutFomatRed, "Task", UserTask.GetTaskCount(User.Identity.Name))

        'Dim summaryNode = AgentTree.Nodes.FindByName("SummaryNode")

        'Dim newNode = AgentTree.Nodes.FindByName("NewLeadsNode")
        'newNode.Text = String.Format(layoutFomat, "New Leads", Utility.GetLeadsCount(LeadStatus.NewLead, User.Identity.Name))

        'Dim priorityNode = AgentTree.Nodes.FindByName("priorityNode")
        'priorityNode.Text = String.Format(layoutFomat, "Hot Leads ", Utility.GetLeadsCount(LeadStatus.Priority, User.Identity.Name))

        'Dim callbackNode = AgentTree.Nodes.FindByName("callBackNode")
        'callbackNode.Text = String.Format(layoutFomat, "Follow Up ", Utility.GetLeadsCount(LeadStatus.Callback, User.Identity.Name))

        'Dim doorNode = AgentTree.Nodes.FindByName("doorKnockNode")
        'doorNode.Text = String.Format(layoutFomat, "Door Knock", Utility.GetLeadsCount(LeadStatus.DoorKnocks, User.Identity.Name))

        'Dim inProcess = AgentTree.Nodes.FindByName("inProcessNode")
        'inProcess.Text = String.Format(layoutFomat, "In Process", Utility.GetLeadsCount(LeadStatus.InProcess, User.Identity.Name))

        'Dim deadlead = AgentTree.Nodes.FindByName("deadNode")
        'deadlead.Text = String.Format(layoutFomat, "Dead Lead", Utility.GetLeadsCount(LeadStatus.DeadEnd, User.Identity.Name))

        'Dim closed = AgentTree.Nodes.FindByName("closedNode")
        'closed.Text = String.Format(layoutFomat, "Closed", Utility.GetLeadsCount(LeadStatus.Closed, User.Identity.Name))

        'If Not Employee.HasSubordinates(User.Identity.Name) Then
        '    AgentTree.Nodes.FindByName("MgrNode").Visible = False
        '    AgentTree.Nodes.FindByName("LeadsNode").Text = String.Format("Agent - {0}", User.Identity.Name)
        'Else
        '    'If User.IsInRole("Admin") Then
        '    '    'assignNode()
        '    Dim assingNode = AgentTree.Nodes.FindByName("assignNode")
        '    assingNode.Text = String.Format(layoutFomat, "Assign Leads", Utility.GetUnAssignedLeadsCount())
        '    assingNode.Visible = True
        '    'End If

        '    Dim leadsNode = AgentTree.Nodes.FindByName("LeadsNode")
        '    Dim mgrLeads = AgentTree.Nodes.FindByName("MgrNode")

        '    mgrLeads.Text = "Manager - " & User.Identity.Name
        '    mgrLeads.Visible = True
        '    mgrLeads.Nodes.Insert(0, leadsNode)
        '    mgrLeads.Nodes.Insert(2, taskNode)
        '    mgrLeads.Nodes.Insert(0, summaryNode)
        '    leadsNode.Expanded = False
        '    leadsNode.Text = "My Leads"

        '    Dim emps = Employee.GetManagedEmployees(User.Identity.Name)
        '    priorityNode = AgentTree.Nodes.FindByName("mgrNewNode")
        '    priorityNode.Text = String.Format(layoutFomat, "New Leads ", Utility.GetMgrLeadsCount(LeadStatus.NewLead, emps))

        '    priorityNode = AgentTree.Nodes.FindByName("mgrPriorityNode")
        '    priorityNode.Text = String.Format(layoutFomat, "Hot Leads", Utility.GetMgrLeadsCount(LeadStatus.Priority, emps))

        '    callbackNode = AgentTree.Nodes.FindByName("mgrCallbackNode")
        '    callbackNode.Text = String.Format(layoutFomat, "Follow Up ", Utility.GetMgrLeadsCount(LeadStatus.Callback, emps))

        '    doorNode = AgentTree.Nodes.FindByName("mgrDoorknockNode")
        '    doorNode.Text = String.Format(layoutFomat, "Door Knock", Utility.GetMgrLeadsCount(LeadStatus.DoorKnocks, emps))

        '    doorNode = AgentTree.Nodes.FindByName("mgrInProcessNode")
        '    doorNode.Text = String.Format(layoutFomat, "In Process", Utility.GetMgrLeadsCount(LeadStatus.InProcess, emps))

        '    doorNode = AgentTree.Nodes.FindByName("mgrClosedNode")
        '    doorNode.Text = String.Format(layoutFomat, "Closed ", Utility.GetMgrLeadsCount(LeadStatus.Closed, emps))

        '    doorNode = AgentTree.Nodes.FindByName("deadleadNode")
        '    doorNode.Text = String.Format(layoutFomat, "Dead Lead", Utility.GetMgrLeadsCount(LeadStatus.DeadEnd, emps))

        'End If

        'CheckOfficeNode("Bronx")
        'CheckOfficeNode("Queens")
        'CheckOfficeNode("Patchen")
        'CheckOfficeNode("Rockaway")
    End Sub

    'Sub CheckOfficeNode(officeName As String)
    '    Dim nodeName = officeName & "Node"
    '    Dim officeNode = AgentTree.Nodes.FindByName(nodeName)

    '    If User.IsInRole("OfficeManager-" & officeName) Or User.IsInRole("Admin") Then
    '        officeNode.Visible = True

    '        officeNode.Text = String.Format(layoutFomat, officeName, Utility.GetOfficeLeadsCount(LeadStatus.ALL, officeName) + Utility.GetUnAssignedLeadsCount(officeName))
    '        For Each node As TreeViewNode In officeNode.Nodes
    '            If Not String.IsNullOrEmpty(node.Name) AndAlso node.Name <> "Assign" Then
    '                node.Text = String.Format(layoutFomat, node.Name, Utility.GetOfficeLeadsCount(Utility.GetLeadStatus(node.Name), officeName))
    '            End If
    '        Next

    '        If officeNode.Nodes.FindByName("Assign") Is Nothing Then
    '            officeNode.Nodes.Insert(0, GetAssignleadsNode(officeName))
    '        End If
    '    End If
    'End Sub

    'Function GetAssignleadsNode(office As String) As TreeViewNode
    '    Dim assginNode = New TreeViewNode
    '    assginNode.Text = String.Format(layoutFomat, "Assign Leads", Utility.GetUnAssignedLeadsCount(office))
    '    'change icon by steven
    '    assginNode.Image.Url = "/images/assign_leads_icon.png"
    '    assginNode.NavigateUrl = "Management/LeadsManagement.aspx?office=" & office
    '    assginNode.Name = "Assign"
    '    Return assginNode
    'End Function

    'Protected Sub agentTreeCallbackPanel_Callback(sender As Object, e As CallbackEventArgsBase)

    'End Sub
End Class