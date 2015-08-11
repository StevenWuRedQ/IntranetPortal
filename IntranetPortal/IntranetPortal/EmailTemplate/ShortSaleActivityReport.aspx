<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="ShortSaleActivityReport.aspx.vb" Inherits="IntranetPortal.ShortSaleActivityReport" %>

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
            Below is summary of your Short Sale team activities today (<%= DateTime.Today.ToShortDateString() %>). Please review.
            <br />
            <br />
            <table style="margin-left: 15px; border: 1px solid black; border-collapse:collapse;border-spacing: 0px;" border="1" cellspacing="0">
                <thead style="border: 1px solid black; font-weight:bold;background-color: #efefef;">
                    <tr>
                        <td>Name</td>
                        <td>View Case</td>
                        <td>Emails</td>
                        <td>Comments</td>                       
                        <td>UniqueBBLE</td>
                    </tr>
                </thead>
                <tbody>
                    <% For Each item In TeamActivityData%>                  
                    <tr>
                        <td><%= item.Name%></td>
                        <td><%= item.AmountofViewCase%></td>
                        <td><%= item.Email%></td>
                        <td><%= item.Comments %></td>                     
                        <td><%= item.UniqueBBLE%></td>
                    </tr>                  
                    <% Next%>
                </tbody>
            </table>
            <br />
            <img src=<%= ChartImage%> />

            <dx:WebChartControl ID="chartActivity" runat="server" Height="400px" CssClass="AlignCenter TopLargeMargin" Visible="false"
                Width="700px" ClientInstanceName="chart" CrosshairEnabled="False" EnableClientSideAPI="false" ToolTipEnabled="False">                
            </dx:WebChartControl>
            <br />
            More info, please <a href="http://portal.myidealprop.com/managementui/management.aspx">click here</a>.
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
