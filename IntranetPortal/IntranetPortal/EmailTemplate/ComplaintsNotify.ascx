<%@ Control Language="vb" AutoEventWireup="false" CodeBehind="ComplaintsNotify.ascx.vb" Inherits="IntranetPortal.ComplaintsNotify1" %>
<%@ Register Src="~/EmailTemplate/ComplaintContent.ascx" TagPrefix="uc1" TagName="ComplaintContent" %>

<style type="text/css">
    .maininfo {
        font-family: arial;
        font-size: 9pt;
        color: black;
        font-weight: bold;
        background-color: #9BCDFF;
    }

    .content {
        font-family: arial;
        font-size: 9pt;
        color: black;
        font-weight: normal;
    }

    .mainhdg {
        font-family: Arial;
        font-size: 11pt;
        font-weight: bold;
        color: #000080;
        text-align: center;
    }

    .rightcontent {
        font-family: Arial;
        font-size: 9pt;
        color: black;
        text-align: right;
        font-weight: normal;
    }

    .inlineform {
        font-family: arial;
        font-size: 9pt;
        color: black;
        background-color: #CECECE;
    }

    .centercolhdg {
        font-family: Arial;
        font-size: 9pt;
        font-weight: bold;
        color: #000000;
        text-align: center;
        background-color: #CECECE;
    }
</style>

Dear <%=  UserName%>,
<br />
<br />
Your DOB Complaints Properties Watch List just refreshed. Following are actively complaints, please check.
<br />
<br />

<table style="margin-left: 15px; border: 1px solid black; border-collapse: collapse; border-spacing: 0px; width: 700px" border="1" cellspacing="0">
    <thead>
        <tr>
            <td class="mainhdg" style="text-align:left">Active Complaints:</td>
        </tr>
    </thead>
    <tr>
        <td>
            <asp:Repeater ID="rptProperties" runat="server" OnItemDataBound="rptProperties_ItemDataBound">
                <ItemTemplate>
                    <asp:Repeater ID="rptComplaints" runat="server">
                        <ItemTemplate>
                            <uc1:ComplaintContent runat="server" ID="ComplaintContent" item="<%# Container.DataItem %>" />
                        </ItemTemplate>
                    </asp:Repeater>
                </ItemTemplate>
            </asp:Repeater>          
        </td>
    </tr>
</table>
<br />
More info, please <a href="http://portal.myidealprop.com/Complaints/ComplainsMng.aspx">click here</a>.
<br />
<br />
<br />
Regards,<br />
The Portal Team<br />
<small>(This is an automatic email. Please do not reply.)</small><br />
