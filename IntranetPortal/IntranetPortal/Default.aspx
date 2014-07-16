<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="~/Main.Master" CodeBehind="Default.aspx.vb" Inherits="IntranetPortal.Default2" %>

<%@ Register Src="~/UserControl/UserSummary.ascx" TagPrefix="uc1" TagName="UserSummary" %>

<asp:Content ID="Content1" ContentPlaceHolderID="Left" runat="server">
    <dx:ASPxCallbackPanel runat="server" ID="agentTreeCallbackPanel" ClientInstanceName="agentTreeCallbackPanel" OnCallback="agentTreeCallbackPanel_Callback">
        <PanelCollection>
            <dx:PanelContent>
                <dx:ASPxTreeView ID="AgentTree" AllowSelectNode="True" runat="server" ClientInstanceName="agentTree" Font-Size="Medium" Target="contentUrlPane" Images-NodeImage-Height="20" Images-NodeImage-Width="20" EncodeHtml="False">
                    <Nodes>
                        <dx:TreeViewNode Text="Agent - Bob Harry" Name="LeadsNode" Expanded="True" Image-Url="/images/person.png" NavigateUrl="/SummaryPage.aspx" AllowCheck="True">
                            <Nodes>
                                <dx:TreeViewNode Text="Summary" Image-IconID="chart_chart_32x32" NavigateUrl="SummaryPage.aspx" Target="contentUrlPane" Name="SummaryNode"></dx:TreeViewNode>
                                <dx:TreeViewNode Text="New Leads" Image-Url="/images/new_lead1.png" NavigateUrl="LeadAgent.aspx?c=New Leads" Target="contentUrlPane" Name="NewLeadsNode">
                                    <Nodes>
                                        <dx:TreeViewNode Text="Create" Image-Url="/images/Create.png" NavigateUrl="LeadAgent.aspx?c=Create" Target="contentUrlPane">
                                        </dx:TreeViewNode>
                                    </Nodes>
                                </dx:TreeViewNode>
                                <dx:TreeViewNode Text="Priority" Image-Url="/images/priority.jpg" NavigateUrl="LeadAgent.aspx?c=Priority" Name="priorityNode">
                                </dx:TreeViewNode>
                                <dx:TreeViewNode Text="Follow Up" Expanded="true" Image-Url="/images/callback.png" NavigateUrl="LeadAgent.aspx?c=Call Back" Name="callBackNode">
                                </dx:TreeViewNode>
                                <dx:TreeViewNode Text="Door Knock" Image-Url="/images/door_knocks.png" NavigateUrl="LeadAgent.aspx?c=Door Knock" Name="doorKnockNode">
                                </dx:TreeViewNode>
                                <dx:TreeViewNode Text="Shared" Image-IconID="actions_add_16x16" NavigateUrl="LeadAgent.aspx?c=Shared" Name="SharedNode">
                                </dx:TreeViewNode>
                                <dx:TreeViewNode Text="In Process" Image-Url="images/process-icon2.jpg" NavigateUrl="LeadAgent.aspx?c=In Process" Name="inProcessNode" />
                                <dx:TreeViewNode Text="Task" Image-Url="images/upcomming.jpg" NavigateUrl="LeadAgent.aspx?c=Task" Name="TaskNode" />
                                <dx:TreeViewNode Text="Dead Lead" Image-Url="images/dead.png" NavigateUrl="LeadAgent.aspx?c=Dead Lead" Name="deadNode" />
                                <dx:TreeViewNode Text="Closed" Image-Url="images/Closed.png" NavigateUrl="LeadAgent.aspx?c=Closed" Name="closedNode" />
                            </Nodes>
                        </dx:TreeViewNode>
                        <dx:TreeViewNode Text="Management" Expanded="true" Image-Url="/images/Management.png" Visible="false" Name="MgrNode">
                            <Nodes>
                                <dx:TreeViewNode Text="Assign Leads" Image-Url="/images/assigned.png" NavigateUrl="Management/LeadsManagement.aspx" Name="assignNode" Visible="false">
                                </dx:TreeViewNode>
                                <dx:TreeViewNode Text="New Leads" Image-Url="/images/new_lead1.png" NavigateUrl="MgrViewLeads.aspx?c=New Leads" Name="mgrNewNode">
                                </dx:TreeViewNode>
                                <dx:TreeViewNode Text="Priority" Image-Url="/images/priority.jpg" NavigateUrl="MgrViewLeads.aspx?c=Priority" Name="mgrPriorityNode">
                                </dx:TreeViewNode>
                                <dx:TreeViewNode Text="Follow Up" Expanded="true" Image-Url="/images/callback.png" NavigateUrl="MgrViewLeads.aspx?c=Call Back" Name="mgrCallbackNode">
                                </dx:TreeViewNode>
                                <dx:TreeViewNode Text="Door Knock" Image-Url="/images/door_knocks.png" NavigateUrl="MgrViewLeads.aspx?c=Door Knock" Name="mgrDoorknockNode">
                                </dx:TreeViewNode>
                                <dx:TreeViewNode Text="In Process" Image-Url="/images/process-icon2.jpg" NavigateUrl="MgrViewLeads.aspx?c=In Process" Name="mgrInProcessNode" />
                                <dx:TreeViewNode Text="Dead Lead" Image-Url="/images/dead.png" NavigateUrl="MgrViewLeads.aspx?c=Dead Lead" Name="deadleadNode" />
                                <dx:TreeViewNode Text="Closed" Image-Url="images/Closed.png" NavigateUrl="MgrViewLeads.aspx?c=Closed" Name="mgrClosedNode" />
                                <dx:TreeViewNode Text="Search" Image-Url="/images/Search.png" NavigateUrl="MgrViewLeads.aspx?c=Search"></dx:TreeViewNode>
                            </Nodes>
                        </dx:TreeViewNode>
                        <dx:TreeViewNode Text="Bronx" Expanded="false" Image-Url="/images/Management.png" Visible="false" Name="BronxNode">
                            <Nodes>                               
                                <dx:TreeViewNode Text="New Leads" Image-Url="/images/new_lead1.png" NavigateUrl="MgrViewLeads.aspx?c=New Leads&o=Bronx" Name="New Leads">
                                </dx:TreeViewNode>
                                <dx:TreeViewNode Text="Priority" Image-Url="/images/priority.jpg" NavigateUrl="MgrViewLeads.aspx?c=Priority&o=Bronx" Name="Priority">
                                </dx:TreeViewNode>
                                <dx:TreeViewNode Text="Follow Up" Expanded="true" Image-Url="/images/callback.png" NavigateUrl="MgrViewLeads.aspx?c=Call Back&o=Bronx" Name="Follow Up">
                                </dx:TreeViewNode>
                                <dx:TreeViewNode Text="Door Knock" Image-Url="/images/door_knocks.png" NavigateUrl="MgrViewLeads.aspx?c=Door Knock&o=Bronx" Name="Door Knock">
                                </dx:TreeViewNode>
                                <dx:TreeViewNode Text="In Process" Image-Url="/images/process-icon2.jpg" NavigateUrl="MgrViewLeads.aspx?c=In Process&o=Bronx" Name="In Process"/>
                                <dx:TreeViewNode Text="Dead Lead" Image-Url="/images/dead.png" NavigateUrl="MgrViewLeads.aspx?c=Dead Lead&o=Bronx" Name="Dead Lead"/>
                                <dx:TreeViewNode Text="Closed" Image-Url="images/Closed.png" NavigateUrl="MgrViewLeads.aspx?c=Closed&o=Bronx" Name="Closed" />
                            </Nodes>
                        </dx:TreeViewNode>
                        <dx:TreeViewNode Text="Queens" Image-Url="/images/Management.png" Visible="false" Name="QueensNode">
                            <Nodes>
                                <dx:TreeViewNode Text="New Leads" Image-Url="/images/new_lead1.png" NavigateUrl="MgrViewLeads.aspx?c=New Leads&o=Queens" Name="New Leads">
                                </dx:TreeViewNode>
                                <dx:TreeViewNode Text="Priority" Image-Url="/images/priority.jpg" NavigateUrl="MgrViewLeads.aspx?c=Priority&o=Queens" Name="Priority">
                                </dx:TreeViewNode>
                                <dx:TreeViewNode Text="Follow Up" Expanded="true" Image-Url="/images/callback.png" NavigateUrl="MgrViewLeads.aspx?c=Call Back&o=Queens" Name="Follow Up">
                                </dx:TreeViewNode>
                                <dx:TreeViewNode Text="Door Knock" Image-Url="/images/door_knocks.png" NavigateUrl="MgrViewLeads.aspx?c=Door Knock&o=Queens" Name="Door Knock">
                                </dx:TreeViewNode>
                                <dx:TreeViewNode Text="In Process" Image-Url="/images/process-icon2.jpg" NavigateUrl="MgrViewLeads.aspx?c=In Process&o=Queens" Name="In Process" />
                                <dx:TreeViewNode Text="Dead Lead" Image-Url="/images/dead.png" NavigateUrl="MgrViewLeads.aspx?c=Dead Lead&o=Queens" Name="Dead Lead" />
                                <dx:TreeViewNode Text="Closed" Image-Url="images/Closed.png" NavigateUrl="MgrViewLeads.aspx?c=Closed&o=Queens" Name="Closed" />
                            </Nodes>
                        </dx:TreeViewNode>
                        <dx:TreeViewNode Text="Patchen" Image-Url="/images/Management.png" Visible="false" Name="PatchenNode">
                            <Nodes>
                                <dx:TreeViewNode Text="New Leads" Image-Url="/images/new_lead1.png" NavigateUrl="MgrViewLeads.aspx?c=New Leads&o=Patchen" Name="New Leads">
                                </dx:TreeViewNode>
                                <dx:TreeViewNode Text="Priority" Image-Url="/images/priority.jpg" NavigateUrl="MgrViewLeads.aspx?c=Priority&o=Patchen" Name="Priority">
                                </dx:TreeViewNode>
                                <dx:TreeViewNode Text="Follow Up" Expanded="true" Image-Url="/images/callback.png" NavigateUrl="MgrViewLeads.aspx?c=Call Back&o=Patchen" Name="Follow Up">
                                </dx:TreeViewNode>
                                <dx:TreeViewNode Text="Door Knock" Image-Url="/images/door_knocks.png" NavigateUrl="MgrViewLeads.aspx?c=Door Knock&o=Patchen" Name="Door Knock">
                                </dx:TreeViewNode>
                                <dx:TreeViewNode Text="In Process" Image-Url="/images/process-icon2.jpg" NavigateUrl="MgrViewLeads.aspx?c=In Process&o=Patchen" Name="In Process"/>
                                <dx:TreeViewNode Text="Dead Lead" Image-Url="/images/dead.png" NavigateUrl="MgrViewLeads.aspx?c=Dead Lead&o=Patchen" Name="Dead Lead"/>
                                <dx:TreeViewNode Text="Closed" Image-Url="images/Closed.png" NavigateUrl="MgrViewLeads.aspx?c=Closed&o=Patchen" Name="Closed"/>
                            </Nodes>
                        </dx:TreeViewNode>
                         <dx:TreeViewNode Text="Rockaway" Image-Url="/images/Management.png" Visible="false" Name="RockawayNode">
                            <Nodes>
                                <dx:TreeViewNode Text="New Leads" Image-Url="/images/new_lead1.png" NavigateUrl="MgrViewLeads.aspx?c=New Leads&o=Rockaway" Name="New Leads">
                                </dx:TreeViewNode>
                                <dx:TreeViewNode Text="Priority" Image-Url="/images/priority.jpg" NavigateUrl="MgrViewLeads.aspx?c=Priority&o=Rockaway" Name="Priority">
                                </dx:TreeViewNode>
                                <dx:TreeViewNode Text="Follow Up" Expanded="true" Image-Url="/images/callback.png" NavigateUrl="MgrViewLeads.aspx?c=Call Back&o=Rockaway" Name="Follow Up">
                                </dx:TreeViewNode>
                                <dx:TreeViewNode Text="Door Knock" Image-Url="/images/door_knocks.png" NavigateUrl="MgrViewLeads.aspx?c=Door Knock&o=Rockaway" Name="Door Knock">
                                </dx:TreeViewNode>
                                <dx:TreeViewNode Text="In Process" Image-Url="/images/process-icon2.jpg" NavigateUrl="MgrViewLeads.aspx?c=In Process&o=Rockaway" Name="In Process"/>
                                <dx:TreeViewNode Text="Dead Lead" Image-Url="/images/dead.png" NavigateUrl="MgrViewLeads.aspx?c=Dead Lead&o=Rockaway" Name="Dead Lead"/>
                                <dx:TreeViewNode Text="Closed" Image-Url="images/Closed.png" NavigateUrl="MgrViewLeads.aspx?c=Closed&o=Rockaway" Name="Closed"/>
                            </Nodes>
                        </dx:TreeViewNode>
                    </Nodes>
                    <Styles>
                        <NodeImage Paddings-PaddingTop="3px" />
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
            <dx:SplitterPane Name="ContentUrlPane" ContentUrlIFrameName="contentUrlPane" ContentUrl="/SummaryPage.aspx" PaneStyle-Border-BorderStyle="None" PaneStyle-Paddings-PaddingBottom="0">
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
