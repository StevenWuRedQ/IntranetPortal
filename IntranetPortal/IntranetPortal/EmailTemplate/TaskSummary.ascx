<%@ Control Language="vb" AutoEventWireup="false" CodeBehind="TaskSummary.ascx.vb" Inherits="IntranetPortal.TaskSummary" %>

Dear <%= DestinationUser%>,
<br />
<br />
Below are <b><%= TaskCount%></b> outstanding reminders or Tasks that are in your Que. Please review and complete them.
<%--As so far, you have totally <b><%= TaskCount%></b> tasks. Please review below list and complete as soon as possible.--%><br />
<br />
Regards,<br />
My Ideal Property PORTAL team. <br />
This is an auto-generated Email. No reply is necessary. 
<br />
<br />


<asp:Repeater runat="server" ID="rptWorklist" OnItemDataBound="rptWorklist_ItemDataBound">
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
</asp:Repeater>
<br />
<br />
Regards,<br />
My Ideal Property PORTAL team.
        <br />
<small>This is an automatic email. Please do not reply.</small>