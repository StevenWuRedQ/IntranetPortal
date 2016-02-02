<%@ Control Language="vb" AutoEventWireup="false" CodeBehind="AuctionDailyReport.ascx.vb" Inherits="IntranetPortal.AuctionDailyReport" %>
<style type="text/css">
    table {
        border-collapse: collapse;
    }

    table, th, td {
        border: 1px solid black;
    }

    thead {
        font-weight: bold;
        background-color: #efefef;
    }

    td {
        padding: 5px 10px;
    }
</style>

Dear Manager,
<br />
<br />

<% If AuctionProperties.Count > 0 %>

Below is report of Auction Properties <% If IsWeekly Then %> in the next 7 days<%else %> today<% End if %>. Please review.
<br />
<br />
<table style="margin-left: 15px; border: 1px solid black">
    <thead>
        <tr>
            <td>Address</td>
            <td style="width: 80px">Auction Date</td>
            <td style="width: 80px">Liens</td>
            <%--   <td style="width:240px">Plaintiff</td>
            <td style="width:200px">Defendant</td>
            <td style="width:150px">Index No.</td>--%>
            <td style="width: 300px">Location</td>
        </tr>
    </thead>
    <tbody>
        <%
            For Each item In AuctionProperties.OrderBy(Function(a) a.AuctionDate)
        %>
        <tr>
            <td><a href="http://portal.myidealprop.com/AuctionLeads/AuctionList.aspx#/detail/<%= item.AuctionId %>" target="_blank"><%= item.Address %></a></td>
            <td><%=  String.Format("{0:g}", item.AuctionDate) %></td>
            <td><%= String.Format("{0:c}", item.Lien)  %></td>
            <%-- <td><%= item.Plaintiff  %></td>
            <td><%= item.Defendant  %></td>
            <td><%= item.IndexNo  %></td>--%>
            <td><%= item.AuctionLocation %></td>
        </tr>

        <% Next%>
    </tbody>
</table>
<br />
More info, please <a href="http://portal.myidealprop.com/AuctionLeads/AuctionList.aspx">click here</a>.
<%          Else %>
There are no auctions scheduled for today (<%= String.Format("{0:d}", DateTime.Today) %>).
<% End If %>
<br />
<br />
Regards,<br />
The Portal Team<br />
<small>(This is an automatic email. Please do not reply.)</small><br />
