<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="~/Main.Master" CodeBehind="Management.aspx.vb" Inherits="IntranetPortal.Management" %>
<asp:Content ID="Content1" ContentPlaceHolderID="Left" runat="server">
    <dx:ASPxTreeView ID="AgentTree" AllowSelectNode="True" runat="server" ClientInstanceName="agentTree" Font-Size="Medium" Target="contentUrlPane" Images-NodeImage-Height="20" Images-NodeImage-Width="20">
        <Nodes>            
             <dx:TreeViewNode Text="Employee Manage" Expanded="true" Image-Url="/images/Management.png" Visible="true">
                <Nodes>
                    <dx:TreeViewNode Text="Employee List" Image-Url="/images/assigned.png" NavigateUrl="/Management/MgrEmployee.aspx">
                    </dx:TreeViewNode>     
                    <dx:TreeViewNode Text="Roles" Image-Url="/images/User Group.png" NavigateUrl="/Management/MgrRole.aspx">
                    </dx:TreeViewNode>   
                    <dx:TreeViewNode Text="ImportData" Image-Url="/images/User Group.png" NavigateUrl="/Management/ImportAgentData.aspx">
                    </dx:TreeViewNode> 
                      <dx:TreeViewNode Text="Portal Status" Image-Url="/images/User Group.png" NavigateUrl="/Management/PortalStatus.aspx">
                    </dx:TreeViewNode>                                     
                </Nodes>
            </dx:TreeViewNode>
        </Nodes>
        <Styles>
            <NodeImage Paddings-PaddingTop="3px" />
        </Styles>      
    </dx:ASPxTreeView>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="Content" runat="server">
      <dx:ASPxSplitter Width="100%" Height="100%" ID="splitter" runat="server" Border-BorderStyle="None">
        <Panes>
          <dx:SplitterPane Name="ContentUrlPane" ContentUrlIFrameName="contentUrlPane" ContentUrl="/Management/Default.aspx" PaneStyle-Border-BorderStyle="None" PaneStyle-Paddings-PaddingBottom="0">
                <ContentCollection>
                    <dx:SplitterContentControl runat="server">
                    </dx:SplitterContentControl>
                </ContentCollection>
            </dx:SplitterPane>
        </Panes>
    </dx:ASPxSplitter>
</asp:Content>
