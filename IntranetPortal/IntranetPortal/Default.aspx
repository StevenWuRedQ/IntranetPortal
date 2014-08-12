<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="~/Main.Master" CodeBehind="Default.aspx.vb" Inherits="IntranetPortal.Default2" %>

<%@ Register Src="~/UserControl/UserSummary.ascx" TagPrefix="uc1" TagName="UserSummary" %>

<asp:Content ID="Content1" ContentPlaceHolderID="Left" runat="server">
    <%--ifjasodfjosa--%>
    <link href='http://fonts.googleapis.com/css?family=Source+Sans+Pro:200,300,400,600,700,900,200italic,300italic,400italic,600italic,700italic,900italic' rel='stylesheet' type='text/css' />
    <link href="styles/stevencss.css" rel='stylesheet' type='text/css' />
    <style type="text/css">
        /*have scrollbar content class add by steven*/
        .scorllbar_content {
            /*it can' don't need postion relative by this class  in tree view it add atuo*/
            position: relative;
            
            /*height: 600px;*/
        }
        /*-----end-------*/
    </style>
    <dx:ASPxCallbackPanel runat="server" ID="agentTreeCallbackPanel" ClientInstanceName="agentTreeCallbackPanel" OnCallback="agentTreeCallbackPanel_Callback">
        <PanelCollection>
            <dx:PanelContent>
                 
                  <dx:ASPxTreeView ID="AgentTree" AllowSelectNode="True" runat="server" ClientInstanceName="agentTree" Font-Size="Medium" Target="contentUrlPane" Images-NodeImage-Height="20" Images-NodeImage-Width="20" EncodeHtml="False" CssClass="scorllbar_content">
                    <Nodes>                       
                        <dx:TreeViewNode Text="Agent - Bob Harry" Name="LeadsNode" Expanded="True" Image-Url="/images/summary.png" NavigateUrl="/SummaryPage.aspx" AllowCheck="True">
                            <Nodes>
                                <dx:TreeViewNode Text="Summary" Image-Url="/images/summary_icon.png" NavigateUrl="SummaryPage.aspx" Target="contentUrlPane" Name="SummaryNode"></dx:TreeViewNode>
                                <dx:TreeViewNode Text="New Leads" Image-Url="/images/new_leads_icon.png" NavigateUrl="LeadAgent.aspx?c=New Leads" Target="contentUrlPane" Name="NewLeadsNode">
                                    <Nodes>
                                        <dx:TreeViewNode Text="Create" Image-Url="/images/assign_leads_icon.png" NavigateUrl="LeadAgent.aspx?c=Create" Target="contentUrlPane">
                                        </dx:TreeViewNode>
                                    </Nodes>
                                </dx:TreeViewNode>
                                <dx:TreeViewNode Text="Priority" Image-Url="/images/priority_icon.png" NavigateUrl="LeadAgent.aspx?c=Priority" Name="priorityNode">
                                </dx:TreeViewNode>
                                <dx:TreeViewNode Text="Follow Up" Expanded="true" Image-Url="/images/callback_icon.png" NavigateUrl="LeadAgent.aspx?c=Call Back" Name="callBackNode">
                                </dx:TreeViewNode>
                                <dx:TreeViewNode Text="Door Knock" Image-Url="/images/door_knock_icon.png" NavigateUrl="LeadAgent.aspx?c=Door Knock" Name="doorKnockNode">
                                </dx:TreeViewNode>
                                <dx:TreeViewNode Text="Shared" Image-Url="/images/door_knock_icon.png" NavigateUrl="LeadAgent.aspx?c=Shared" Name="SharedNode">
                                </dx:TreeViewNode>
                                <dx:TreeViewNode Text="In Process" Image-Url="images/inprogess_icon_s.png" NavigateUrl="LeadAgent.aspx?c=In Process" Name="inProcessNode" />
                                <dx:TreeViewNode Text="Task" Image-Url="images/task.png" NavigateUrl="LeadAgent.aspx?c=Task" Name="TaskNode" />
                                <dx:TreeViewNode Text="Dead Lead" Image-Url="images/dead_lead_icon.png" NavigateUrl="LeadAgent.aspx?c=Dead Lead" Name="deadNode" />

                                <dx:TreeViewNode Text="Closed" Image-Url="images/close_icon.png" NavigateUrl="LeadAgent.aspx?c=Closed" Name="closedNode" />
                            </Nodes>
                        </dx:TreeViewNode>
                        <dx:TreeViewNode Text="Management" Expanded="true" Image-Url="/images/Management.png" Visible="false" Name="MgrNode">
                            <Nodes>
                                <%-- Image-Url="/images/assign_leads_icon.png"--%>
                                <dx:TreeViewNode Text="Assign Leads" NavigateUrl="Management/LeadsManagement.aspx" Name="assignNode" Visible="false">
                                    <Image Url="/images/assign_leads_icon.png"></Image>
                                </dx:TreeViewNode>
                                <dx:TreeViewNode Text="New Leads" Image-Url="/images/new_leads_icon.png" NavigateUrl="MgrViewLeads.aspx?c=New Leads" Name="mgrNewNode">
                                </dx:TreeViewNode>
                                <dx:TreeViewNode Text="Priority" Image-Url="/images/priority_icon.png" NavigateUrl="MgrViewLeads.aspx?c=Priority" Name="mgrPriorityNode">
                                </dx:TreeViewNode>
                                <dx:TreeViewNode Text="Follow Up" Expanded="true" Image-Url="/images/callback_icon.png" NavigateUrl="MgrViewLeads.aspx?c=Call Back" Name="mgrCallbackNode">
                                </dx:TreeViewNode>
                                <dx:TreeViewNode Text="Door Knock" Image-Url="/images/door_knock_icon.png" NavigateUrl="MgrViewLeads.aspx?c=Door Knock" Name="mgrDoorknockNode">
                                </dx:TreeViewNode>
                                <dx:TreeViewNode Text="In Process" Image-Url="/images/inprogess_icon_s.png" NavigateUrl="MgrViewLeads.aspx?c=In Process" Name="mgrInProcessNode" />

                                <dx:TreeViewNode Text="Dead Lead" Image-Url="/images/dead_lead_icon.png" NavigateUrl="MgrViewLeads.aspx?c=Dead Lead" Name="deadleadNode" />
                                <dx:TreeViewNode Text="Closed" Image-Url="images/close_icon.png" NavigateUrl="MgrViewLeads.aspx?c=Closed" Name="mgrClosedNode" />
                                <dx:TreeViewNode Text="Search" Image-Url="/images/search_icon.png" NavigateUrl="MgrViewLeads.aspx?c=Search"></dx:TreeViewNode>

                                <dx:TreeViewNode Text="Agent Overview" Image-Url="/images/agent_overview_icon.png" NavigateUrl="AgentOverview/AgentOverview.aspx" Name="agentOverviewNode" />
                                <%--add priority by steven--%>
                                <dx:TreeViewNode Text="Priority" Image-Url="/images/priority_icon.png" NavigateUrl="Proiority/Priority.aspx" Name="priorityNode" />
                                <%--add short sale case by steven--%>
                                <dx:TreeViewNode Text="Cases" Image-Url="images/icon_short_sale.png" NavigateUrl="ShortSale/ShortSale.aspx" Name="shortSaleNode" />
                                
                            </Nodes>
                        </dx:TreeViewNode>
                        <dx:TreeViewNode Text="Bronx" Expanded="false" Image-Url="/images/Management.png" Visible="false" Name="BronxNode">
                            <Nodes>                               
                                <dx:TreeViewNode Text="New Leads" Image-Url="/images/new_leads_icon.png" NavigateUrl="MgrViewLeads.aspx?c=New Leads&o=Bronx" Name="New Leads">
                                </dx:TreeViewNode>
                                <dx:TreeViewNode Text="Hot Leads" Image-Url="/images/priority_icon.png" NavigateUrl="MgrViewLeads.aspx?c=Priority&o=Bronx" Name="Hot Leads">
                                </dx:TreeViewNode>
                                <dx:TreeViewNode Text="Follow Up" Expanded="true" Image-Url="/images/callback_icon.png" NavigateUrl="MgrViewLeads.aspx?c=Call Back&o=Bronx" Name="Follow Up">
                                </dx:TreeViewNode>
                                <dx:TreeViewNode Text="Door Knock" Image-Url="/images/door_knock_icon.png" NavigateUrl="MgrViewLeads.aspx?c=Door Knock&o=Bronx" Name="Door Knock">
                                </dx:TreeViewNode>
                                <dx:TreeViewNode Text="In Process" Image-Url="/images/inprogess_icon_s.png" NavigateUrl="MgrViewLeads.aspx?c=In Process&o=Bronx" Name="In Process"/>
                                <dx:TreeViewNode Text="Dead Lead" Image-Url="/images/dead_lead_icon.png" NavigateUrl="MgrViewLeads.aspx?c=Dead Lead&o=Bronx" Name="Dead Lead"/>
                                <dx:TreeViewNode Text="Closed" Image-Url="images/close_icon.png" NavigateUrl="MgrViewLeads.aspx?c=Closed&o=Bronx" Name="Closed" />
                            </Nodes>
                        </dx:TreeViewNode>
                        <dx:TreeViewNode Text="Queens" Image-Url="/images/Management.png" Visible="false" Name="QueensNode">
                            <Nodes>
                                <dx:TreeViewNode Text="New Leads" Image-Url="/images/new_leads_icon.png" NavigateUrl="MgrViewLeads.aspx?c=New Leads&o=Queens" Name="New Leads">
                                </dx:TreeViewNode>
                                <dx:TreeViewNode Text="Hot Leads" Image-Url="/images/priority_icon.png" NavigateUrl="MgrViewLeads.aspx?c=Priority&o=Queens" Name="Hot Leads">
                                </dx:TreeViewNode>
                                <dx:TreeViewNode Text="Follow Up" Expanded="true" Image-Url="/images/callback_icon.png" NavigateUrl="MgrViewLeads.aspx?c=Call Back&o=Queens" Name="Follow Up">
                                </dx:TreeViewNode>
                                <dx:TreeViewNode Text="Door Knock" Image-Url="/images/door_knock_icon.png" NavigateUrl="MgrViewLeads.aspx?c=Door Knock&o=Queens" Name="Door Knock">
                                </dx:TreeViewNode>
                                <dx:TreeViewNode Text="In Process" Image-Url="/images/inprogess_icon_s.png" NavigateUrl="MgrViewLeads.aspx?c=In Process&o=Queens" Name="In Process" />
                                <dx:TreeViewNode Text="Dead Lead" Image-Url="/images/dead_lead_icon.png" NavigateUrl="MgrViewLeads.aspx?c=Dead Lead&o=Queens" Name="Dead Lead" />
                                <dx:TreeViewNode Text="Closed" Image-Url="images/close_icon.png" NavigateUrl="MgrViewLeads.aspx?c=Closed&o=Queens" Name="Closed" />
                            </Nodes>
                        </dx:TreeViewNode>
                        <dx:TreeViewNode Text="Patchen" Image-Url="/images/Management.png" Visible="false" Name="PatchenNode">
                            <Nodes>
                                <dx:TreeViewNode Text="New Leads" Image-Url="/images/new_leads_icon.png" NavigateUrl="MgrViewLeads.aspx?c=New Leads&o=Patchen" Name="New Leads">
                                </dx:TreeViewNode>
                                <dx:TreeViewNode Text="Hot Leads" Image-Url="/images/priority_icon.png" NavigateUrl="MgrViewLeads.aspx?c=Priority&o=Patchen" Name="Hot Leads">
                                </dx:TreeViewNode>
                                <dx:TreeViewNode Text="Follow Up" Expanded="true" Image-Url="/images/callback_icon.png" NavigateUrl="MgrViewLeads.aspx?c=Call Back&o=Patchen" Name="Follow Up">
                                </dx:TreeViewNode>
                                <dx:TreeViewNode Text="Door Knock" Image-Url="/images/door_knock_icon.png" NavigateUrl="MgrViewLeads.aspx?c=Door Knock&o=Patchen" Name="Door Knock">
                                </dx:TreeViewNode>
                                <dx:TreeViewNode Text="In Process" Image-Url="/images/inprogess_icon_s.png" NavigateUrl="MgrViewLeads.aspx?c=In Process&o=Patchen" Name="In Process"/>
                                <dx:TreeViewNode Text="Dead Lead" Image-Url="/images/dead_lead_icon.png" NavigateUrl="MgrViewLeads.aspx?c=Dead Lead&o=Patchen" Name="Dead Lead"/>
                                <dx:TreeViewNode Text="Closed" Image-Url="images/close_icon.png" NavigateUrl="MgrViewLeads.aspx?c=Closed&o=Patchen" Name="Closed"/>
                            </Nodes>
                        </dx:TreeViewNode>
                         <dx:TreeViewNode Text="Rockaway" Image-Url="/images/Management.png" Visible="false" Name="RockawayNode">
                            <Nodes>
                                <dx:TreeViewNode Text="New Leads" Image-Url="/images/new_leads_icon.png" NavigateUrl="MgrViewLeads.aspx?c=New Leads&o=Rockaway" Name="New Leads">
                                </dx:TreeViewNode>
                                <dx:TreeViewNode Text="Hot Leads" Image-Url="/images/priority_icon.jpg" NavigateUrl="MgrViewLeads.aspx?c=Priority&o=Rockaway" Name="Hot Leads">
                                </dx:TreeViewNode>
                                <dx:TreeViewNode Text="Follow Up" Expanded="true" Image-Url="/images/callback_icon.png" NavigateUrl="MgrViewLeads.aspx?c=Call Back&o=Rockaway" Name="Follow Up">
                                </dx:TreeViewNode>
                                <dx:TreeViewNode Text="Door Knock" Image-Url="/images/door_knock_icon.png" NavigateUrl="MgrViewLeads.aspx?c=Door Knock&o=Rockaway" Name="Door Knock">
                                </dx:TreeViewNode>
                                <dx:TreeViewNode Text="In Process" Image-Url="/images/inprogess_icon_s.jpg" NavigateUrl="MgrViewLeads.aspx?c=In Process&o=Rockaway" Name="In Process"/>
                                <dx:TreeViewNode Text="Dead Lead" Image-Url="/images/dead_lead_icon.png" NavigateUrl="MgrViewLeads.aspx?c=Dead Lead&o=Rockaway" Name="Dead Lead"/>
                                <dx:TreeViewNode Text="Closed" Image-Url="images/close_icon.png" NavigateUrl="MgrViewLeads.aspx?c=Closed&o=Rockaway" Name="Closed"/>
                            </Nodes>
                        </dx:TreeViewNode>
                    </Nodes>
                    <Styles>
                        <NodeImage CssClass="treePadding" />
                        <NodeText CssClass="treePadding textMargin" />
                        <%--<Node  BackColor="#163240"></Node>--%>

                        <Node CssClass="menuItem"></Node>
                    </Styles>
                </dx:ASPxTreeView>
             
                
            </dx:PanelContent>
        </PanelCollection>
        <ClientSideEvents EndCallback="function(s,e){             
            }" />
    </dx:ASPxCallbackPanel>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="Content" runat="server">
    <dx:ASPxSplitter Width="100%" Height="100%" ID="splitter" runat="server" Border-BorderStyle="None" ClientInstanceName="splitterRightDefaultPage">
        <Panes>
            <dx:SplitterPane Name="ContentUrlPane" ContentUrlIFrameName="contentUrlPane" ContentUrl="/SummaryPage.aspx" PaneStyle-Border-BorderStyle="None" PaneStyle-Paddings-PaddingBottom="0" ScrollBars="None" >
                <ContentCollection>
                    <dx:SplitterContentControl runat="server">
                    </dx:SplitterContentControl>
                </ContentCollection>
            </dx:SplitterPane>
        </Panes>
    </dx:ASPxSplitter>
    <%-- <script type="text/javascript">
         attachEventHandler(window, "onresize", function () {
             splitterRightDefaultPage.AdjustControl();
             alert("splitterRightDefaultPage Resize");
         });
    </script>--%>
</asp:Content>
