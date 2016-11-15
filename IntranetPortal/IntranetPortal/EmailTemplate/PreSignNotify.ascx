<%@ Control Language="vb" AutoEventWireup="false" CodeBehind="PreSignNotify.ascx.vb" Inherits="IntranetPortal.PreSignNotify" %>


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

<!--
Dear <%=  UserName%>,
<br /> -->
<br />
<% If IsUpdateMode Then %>
<%= PreSign.UpdateBy %> just update the HOI request, please review.
<% Else %>
<%= PreSign.CreateBy %> just submit a HOI request, please review.
<% End If %>
<br />
<br />
<table style="margin-left: 15px; border: 1px solid black; width: 580px">
    <tr>
        <td style="width: 200px">Address: </td>
        <td><%= PreSign.Title %> </td>
    </tr>
    <tr>
        <td>Requestor: </td>
        <td><%= PreSign.CreateBy %> </td>
    </tr>
    <tr>
        <td>Expected Date of Signing: </td>
        <td><%= String.Format("{0:d}", PreSign.ExpectedDate) %> </td>
    </tr>
    <tr>
        <td>Deal Amount: </td>
        <td><%= PreSign.DealAmount %> </td>
    </tr>
    <% If PreSign.NeedCheck AndAlso PreSign.CheckRequestData IsNot Nothing Then %>
    <tr>
        <td>Type of Check Request: </td>
        <td><%= PreSign.CheckRequestData.Type %> </td>
    </tr>  
    <% End If %>
    <tr>
        <td>Parties: </td>
        <td>
            <% If PreSign.PartiesArray IsNot Nothing Then %>

            <% For each p In PreSign.PartiesArray
            %>

            <%= p.Value(Of String)("Name") %>
            <br />

            <% Next %>
            <% End If %>
        </td>
    </tr>
</table>

<% If PreSign.NeedCheck AndAlso PreSign.CheckRequestData IsNot Nothing %>
<br />
<table style="margin-left: 15px; border: 1px solid black; border-collapse: collapse; border-spacing: 0px; width: 700px" border="1">
    <thead>
        <tr>
            <td style="text-align: left">NO.</td>
            <td>Payable To</td>
            <td>Amount</td>
            <td>Date</td>
            <td>Description</td>
        </tr>
    </thead>
    <% 
        Dim i = 1
        For Each check In PreSign.CheckRequestData.Checks %>
    <tr <% if check.Status = IntranetPortal.Data.BusinessCheck.CheckStatus.Canceled Then%> style="text-decoration: line-through" <% End If %>>
        <td><%= i %></td>
        <td><%= check.PaybleTo %></td>
        <td><%= string.Format("{0:c}", check.Amount) %></td>
        <td><%= string.Format("{0:d}", check.Date) %></td>
        <td><%= check.Description %></td>
    </tr>

    <%
            i = i + 1
        Next %>
</table>
<% else %>

<br />
(No Checks)
<br />
<% End if %>
<br />
More info, please <a href="http://portal.myidealprop.com/">click here</a>.
<br />
<br />
<br />
Regards,<br />
The Portal Team<br />
<small>(This is an automatic email. Please do not reply.)</small><br />
