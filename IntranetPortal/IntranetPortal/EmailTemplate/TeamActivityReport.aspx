<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="TeamActivityReport.aspx.vb" Inherits="IntranetPortal.TeamActivityReport" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
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
</head>
<body>
    <form id="form1" runat="server">
        <div>
            Dear <%= Manager%>,
            <br />
            <br />
            Below is summary of your agents' activities today (<%= DateTime.Today.ToShortDateString() %>). Please review.
            <br />
            <br />
            <table style="margin-left: 15px; border: 1px solid black; border-collapse:collapse;border-spacing: 0px;" border="1" cellspacing="0">
                <thead style="border: 1px solid black; font-weight:bold;background-color: #efefef;">
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
                    <% For Each item In TeamActivityData%>
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
            <img src=<%= ChartImage%> />

            <dx:WebChartControl ID="chartActivity" runat="server" Height="400px" CssClass="AlignCenter TopLargeMargin" Visible="false"
                Width="700px" ClientInstanceName="chart" CrosshairEnabled="False" EnableClientSideAPI="false" ToolTipEnabled="False">                
            </dx:WebChartControl>
            <br />
            More info, please <a href="http://104.130.40.123/managementui/management.aspx">click here</a>.
            <br />
            <br />
            <br />
            Regards,<br />
            The Portal Team<br />
            <br />
        </div>
    </form>
</body>
</html>
