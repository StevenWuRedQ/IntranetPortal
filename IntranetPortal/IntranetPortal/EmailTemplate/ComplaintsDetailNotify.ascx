<%@ Control Language="vb" AutoEventWireup="false" CodeBehind="ComplaintsDetailNotify.ascx.vb" Inherits="IntranetPortal.ComplaintsDetailNotify" %>
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


Dear All,
<br />
<br />
FYI - The DOB Complaint, for the property located at: (<%= GetMailDataItem("Address") %>),<% If Resolved Then %> was resolved or cleared. <% else %> has been updated. <% End If %>
<br />
<br />

<asp:Repeater ID="rptComplaints" runat="server">
    <ItemTemplate>
        <uc1:complaintcontent runat="server" id="ComplaintContent" item="<%# Container.DataItem %>" />
    </ItemTemplate>
</asp:Repeater>

<%--<% For Each item In complaint.ComplaintsResult.Where(Function(c) c.Status = "ACT").ToList %>

<table border="0" cellpadding="1" cellspacing="0" width="750" style="margin: 0 auto;">
    <tbody>
        <tr>
            <td>
                <h3 class="mainhdg">Overview for Complaint #:<%= item.ComplaintNumber %>= <%= item.Status %></h3>
            </td>
        </tr>
    </tbody>
</table>
<table border="0" cellpadding="1" cellspacing="0" width="750" style="margin: 0 auto;">
    <tbody>
        <tr>
            <td class="maininfo" align="left" width="300" colspan="2">Complaint at:&nbsp;&nbsp;<%=item.Address%></td>
            <td class="maininfo" align="right">BIN: <%=item.BIN%></td>
            <td class="maininfo" width="10">&nbsp;&nbsp;</td>
            <td class="maininfo" align="right">Borough:&nbsp;<%=item.Borough%></td>
            <td class="maininfo" width="10">&nbsp;&nbsp;</td>
            <td class="maininfo" align="right">ZIP:&nbsp;<%=item.Zip%></td>
        </tr>
        <tr valign="top">
            <td class="content" colspan="6">Re:&nbsp;&nbsp;<%= item.RE%></td>
        </tr>
    </tbody>
</table>
<br />
<table border="0" cellpadding="1" cellspacing="0" width="750" style="margin: 0 auto;">
    <tbody>
        <tr>
            <td class="content" colspan="2"></td>
            <td class="content"></td>
        </tr>
        <tr>
            <td class="content" width="150"><b>Category Code:</b></td>
            <td class="content" colspan="2" width="600"><%=item.CategoryCode%></td>
        </tr>
        <tr>
            <td class="content" width="150" colspan="3">
                <br>
            </td>
        </tr>
        <tr>
            <td class="content" width="150" colspan="3">
                <br>
            </td>
        </tr>
        <tr>
            <td class="content" width="150"><b>Assigned To:</b></td>
            <td class="content" width="450"><%=item.AssignedTo%></td>
            <td class="content" width="150"><b>Priority:</b>&nbsp;&nbsp;<%=item.Priority%>&nbsp;
			&nbsp;&nbsp;</td>
        </tr>
        <tr>
            <td class="rightcontent" colspan="3"><b>311 Reference Number:</b>&nbsp;&nbsp;<%=item.Reference311Number%>
			&nbsp;&nbsp;</td>
        </tr>
    </tbody>
</table>
<table border="0" cellpadding="1" cellspacing="0" width="750" style="margin: 0 auto;">
    <tbody>
        <tr>
            <td>
                <hr>
            </td>
        </tr>
    </tbody>
</table>
<table border="0" cellpadding="1" cellspacing="0" width="750" style="margin: 0 auto;">
    <tbody>
        <tr>
            <td class="content"><b>Received:</b></td>
            <td class="content">&nbsp;&nbsp;<%=item.DateEntered%></td>
            <td class="content" width="10">&nbsp;</td>
            <td class="content"><b>BBLE:</b>&nbsp;&nbsp;<%=item.BBLE%></td>
            <td class="content"><b></b>&nbsp;&nbsp;</td>
            <td class="content" width="25">&nbsp;</td>
            <td class="content" align="right"><b>Community Board:</b>&nbsp;&nbsp;</td>
        </tr>
        <tr>
            <td class="content"><b>Owner:</b></td>
            <td class="content">&nbsp;&nbsp;<%=item.Owner%></td>
            <!--- Value for Owner --->
            <td colspan="5">&nbsp;</td>
        </tr>

    </tbody>
</table>
<br />
<table border="0" cellpadding="0" cellspacing="0" width="750" style="margin: 0 auto;">
    <tbody>
        <tr>
            <td class="content" width="30%" align="right" valign="top"><b>Last Inspection:</b>&nbsp;&nbsp;</td>

            <td class="content" width="70%"><%=item.LastInspection%> </td>

        </tr>
        <tr>
            <td class="content" width="30%" align="right" valign="top"><b>Disposition:</b>&nbsp;&nbsp;</td>
            <td class="content" width="70%"><%=item.DispositionDetails%> </td>
        </tr>
        <tr>
            <td class="content" width="30%" valign="top" align="right"><b>Comments:</b>&nbsp;&nbsp;</td>
            <td class="content" width="70%"><%=item.Comments%></td>
        </tr>
    </tbody>
</table>
<table border="0" cellpadding="1" cellspacing="0" width="750" style="margin: 0 auto;">
    <tbody>
        <tr>
            <td>
                <hr>
            </td>
        </tr>
    </tbody>
</table>

<% If item.Complaints_Disposition_History IsNot Nothing AndAlso item.Complaints_Disposition_History.Count > 0 Then %>

<table border="0" cellpadding="1" cellspacing="0" width="750">
    <tbody>
        <tr>
            <td class="mainhdg">Complaint Disposition History</td>
        </tr>
    </tbody>
</table>
<br />
<table border="0" cellpadding="2" cellspacing="0" width="750">
    <!--- Nested Table for Content Area --->
    <tbody>
        <tr valign="middle">
            <td class="centercolhdg">#</td>
            <td class="centercolhdg" colspan="2">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Disposition</td>
            <td class="centercolhdg" rowspan="2">Disposition</td>
            <td class="centercolhdg">Inspection</td>
            <td class="centercolhdg" rowspan="2">Date</td>
        </tr>
        <tr>
            <td class="centercolhdg"></td>
            <td class="centercolhdg">Date</td>
            <td class="centercolhdg">Code</td>
            <td class="centercolhdg">By</td>
        </tr>
        <tr>
            <td colspan="6"></td>
        </tr>

        <% for each history In item.Complaints_Disposition_History %>

        <tr class="inlineform" valign="top">
            <!--- ROW For Data --->
            <td class="content"><%= history.Disp_Num  %>&nbsp;</td>
            <td class="content">&nbsp;<%= String.Format("{0:d}", history.Disp_Date) %>&nbsp;</td>
            <!--- Cell for Disp Date --->
            <td class="content">&nbsp;&nbsp;&nbsp;&nbsp;<%= history.Disp_Code %>&nbsp;</td>
            <td class="content"><%= history.Disposition %>&nbsp;</td>

            <td class="content">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<%= history.Inspection_By %></td>
            <!--- Cell for Inspection By --->

            <td class="content">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<%= String.Format("{0:d}", history.Inspection_Date) %>&nbsp;</td>
        </tr>

        <% Next %>

    </tbody>
</table>

<% else %>

<table border="0" cellpadding="1" cellspacing="0" width="750">
    <tbody>
        <tr>
            <td class="mainhdg">No Complaint Disposition History</td>
        </tr>
    </tbody>
</table>

<% End If %>

<br />

<% Next %>--%>



For more information, Please click on <a href='http://portal.myidealprop.com/Complaints/ComplainsMng.aspx?bble=<%= GetMailDataItem("BBLE") %>'>this link </a>to  review. 
<br />
<br />
Regards,
<br />
Portal Team
<br />
<small>This is an automatic email. Please do not reply.</small>