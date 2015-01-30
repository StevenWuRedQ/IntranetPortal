<%@ Control Language="vb" AutoEventWireup="false" CodeBehind="TaskSummary.ascx.vb" Inherits="IntranetPortal.TaskSummary" %>

Dear <%= DestinationUser%>,
<br />
<br />
Below are <b><%= TaskCount%></b> outstanding reminders or Tasks that are in your Que. Please review and complete them.
<%--As so far, you have totally <b><%= TaskCount%></b> tasks. Please review below list and complete as soon as possible.--%><br />
<br />
Regards,<br />
My Ideal Property PORTAL team.
<br />
<br />
<small>This is an auto-generated Email. No reply is necessary. </small>
<br />
<br />

<asp:Repeater runat="server" ID="rptWorklist" OnItemDataBound="rptWorklist_ItemDataBound">
    <ItemTemplate>
        <h3><%# Eval("ProcSchemeDisplayName")%></h3>
        <asp:Repeater runat="server" ID="rptWorklistItem">
            <ItemTemplate>
                <table style="width:500px">
                    <tr>
                        <td colspan="2">
                            <hr />
                        </td>
                    </tr>
                    <tr>
                        <td style="width:150px">Property Address:</td>
                        <td><a href='http://portal.myidealprop.com<%# Eval("ItemData") %>'><%# Eval("DisplayName")%></a></td>
                    </tr>
                    <tr>
                        <td>Create By:</td>
                        <td><%# Eval("Originator")%></td>
                    </tr>
                    <tr>
                        <td>Date Created:</td>
                        <td><%# Eval("StartDate", "{0:g}") %></td>
                    </tr>
                    <tr>
                        <td>Description:</td>
                        <td><%# Eval("Description")%></td>
                    </tr>
                    <tr runat="server" visible='<%# Eval("ShowPortalMsg")%>'>
                        <td>PORTAL Message:</td>
                        <td><%# Eval("PortalMsg")%></td>
                    </tr>
                </table>
            </ItemTemplate>
          
        </asp:Repeater>
    </ItemTemplate>
    <FooterTemplate>       
    </FooterTemplate>
</asp:Repeater>
<br />
<br />
<%--<asp:Repeater runat="server" ID="rptWorklist" OnItemDataBound="rptWorklist_ItemDataBound">
    <HeaderTemplate>
        <table>
            <thead>
                <tr style="font-weight: 800">
                    <td style="width: 300px"></td>
                    <td style="width: 150px">From</td>
                    <td style="width: 150px">Create Date</td>
                    <td></td>
                </tr>
            </thead>
    </HeaderTemplate>
    <ItemTemplate>
        <tr>
            <td colspan="5" style="font-weight: 800; background-color: #cfcfcf">
                <%# Eval("ProcSchemeDisplayName")%>
            </td>
        </tr>
        <asp:Repeater runat="server" ID="rptWorklistItem">
            <ItemTemplate>
                <tr>
                    <td><a href='http://portal.myidealprop.com<%# Eval("ItemData") %>'><%# Eval("DisplayName")%></a></td>
                    <td><%# Eval("Originator")%></td>
                    <td><%# Eval("StartDate", "{0:g}") %></td>
                    <td></td>
                </tr>
            </ItemTemplate>
            <AlternatingItemTemplate>
                <tr style="background-color: whitesmoke">
                    <td><a href='http://portal.myidealprop.com<%# Eval("ItemData") %>'><%# Eval("DisplayName")%></a></td>
                    <td><%# Eval("Originator")%></td>
                    <td><%# Eval("StartDate", "{0:g}") %></td>
                    <td></td>
                </tr>
            </AlternatingItemTemplate>
        </asp:Repeater>
    </ItemTemplate>
    <FooterTemplate>
        </table>
    </FooterTemplate>
</asp:Repeater>--%>