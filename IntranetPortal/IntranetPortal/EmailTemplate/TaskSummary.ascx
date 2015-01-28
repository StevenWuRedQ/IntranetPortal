<%@ Control Language="vb" AutoEventWireup="false" CodeBehind="TaskSummary.ascx.vb" Inherits="IntranetPortal.TaskSummary" %>

Dear <%= DestinationUser%>,
<br />
<br />
As so far, you have totally <%= TaskCount%> tasks. Please review below list and complete.<br />
<br />
<asp:Repeater runat="server" ID="rptWorklist" OnItemDataBound="rptWorklist_ItemDataBound">
    <HeaderTemplate>
        <table>
            <thead>
                <tr style="font-weight: 800">
                    <td style="width: 300px">Name</td>
                    <td style="width: 150px">Originator</td>
                    <td style="width: 150px">Create Date</td>
                    <td></td>
                </tr>
            </thead>
    </HeaderTemplate>
    <ItemTemplate>
        <tr>
            <td colspan="5" style="font-weight: 800; background-color:#efefef">
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
        </asp:Repeater>
    </ItemTemplate>
    <FooterTemplate>
        </table>
    </FooterTemplate>
</asp:Repeater>
<br />
<br />
Regards,<br />
My Ideal Property PORTAL team.
        <br />
<small>This is an automatic email. Please do not reply.</small>