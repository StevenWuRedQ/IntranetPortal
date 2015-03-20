<%@ Control Language="vb" AutoEventWireup="false" CodeBehind="ActivitySummary.ascx.vb" Inherits="IntranetPortal.ActivitySummary" %>
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
    td{
 padding: 5px 10px;
    }         
</style>

Dear <%= Manager%>,
<br />
<br />
Below is summary of your agents' activities today (<%= DateTime.Today.ToShortDateString() %>). Please review.
<br />
<br />
<table style="margin-left:15px; border:1px solid black">
    <thead>
        <tr>
            <td>Name</td>
            <td>CallOwner</td>
            <td>Comments</td>
            <td>DoorKnock</td>
            <td>FollowUp</td>
            <td>UniqueBBLE</td>
        </tr>
    </thead>
    <tbody>
        <% For Each item In IntranetPortal.PortalReport.LoadTeamAgentActivityReport(team.Name, DateTime.Today, DateTime.Today.AddDays(1))%>
            <% If IntranetPortal.Employee.GetInstance(item.Name).Position = "Finder" Then%>
        <tr>
            <td><%= item.Name%></td>
            <td><%= item.CallOwner %></td>
            <td><%= item.Comments %></td>
            <td><%= item.DoorKnock%></td>
            <td><%= item.FollowUp%></td>
            <td><%= item.UniqueBBLE%></td>
        </tr>
        <% End If%>
        <% Next%>
    </tbody>
</table>
<br />
More info, please <a href="http://104.130.40.123/managementui/management.aspx">click here</a>.
<br />
<br />
<br />
Regards,<br />
The Portal Team<br />
<small>(This is an automatic email. Please do not reply.)</small>



