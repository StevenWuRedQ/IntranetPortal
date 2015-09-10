<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="ShortSaleActivityReport.aspx.vb" Inherits="IntranetPortal.ShortSaleActivityReport" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <style type="text/css">
        html
        {
          
        }

        ul li{
            line-height:25px;
        }

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
</head>
<body>
    <form id="form1" runat="server">
        <div>
            Dear <%= Manager%>,
            <br />
            <br />
            Below is summary of your team activities today (<%= DateTime.Today.ToShortDateString() %>). Please review.
            <br />
            <br />
            <table style="margin-left: 15px; border: 1px solid black; border-collapse: collapse; border-spacing: 0px;" border="1" cellspacing="0">
                <thead style="border: 1px solid black; font-weight: bold; background-color: #efefef;">
                    <tr>
                        <td>Name</td>
                        <td>Files Worked w/ Comments</td>
                        <td>Files Worked w/o Comments</td>
                        <td>Files Viewed Only</td>
                        <td>Total Files Opened</td>
                    </tr>
                </thead>
                <tbody>
                    <% For Each item In TeamActivityData%>
                    <tr>
                        <td><%= item.Name%></td>
                        <td><%= item.FilesWorkedWithComments.Count%></td>
                        <td><%= item.FilesWorkedWithoutComments.Count%></td>
                        <td><%= item.FilesViewedOnly.Count%></td>
                        <td><%= item.TotalFileOpened.Count%></td>
                    </tr>
                    <% Next%>
                </tbody>
            </table>
            <br />
            <img src="<%= ChartImage%>" />

            <dx:WebChartControl ID="chartActivity" runat="server" Height="400px" CssClass="AlignCenter TopLargeMargin" Visible="false"
                Width="700px" ClientInstanceName="chart" CrosshairEnabled="False" EnableClientSideAPI="false" ToolTipEnabled="False">
            </dx:WebChartControl>
            <br />

            <h3>Activity Breakdown:</h3>
            
            <% For Each item In TeamActivityData%>

            <% If item.TotalFileOpened.Count > 0 Then%>
            <table style="margin-left: 15px; border: 1px solid black; border-collapse: collapse; border-spacing: 0px; width: 700px" border="1" cellspacing="0">
                <thead>
                    <tr>
                        <td><%= item.Name%>&nbsp;(Total Files Opened:<%=item.TotalFileOpened.Count%>)</td>
                    </tr>
                </thead>
                <tr>
                    <td>
                        <% If item.FilesWithCmtCount > 0 Then%>
                        <strong>Files Worked With Comments (<%= item.FilesWithCmtCount%>)</strong>
                        <ul>
                            <% For Each ssCase In item.FilesWorkedWithComments%>
                            <li>
                                <a href="http://portal.myidealprop.com/<%=item.GetViewLink(ssCase.BBLE)%>" target="_blank">
                                    <%= ssCase.PropertyAddress%>
                                </a>                                
                            </li>
                            <% Next%>
                        </ul>
                        <% End If%>

                        <% If item.FilesWithoutCmtCount > 0 Then%>
                        <strong>Files Worked Without Comments (<%= item.FilesWithoutCmtCount%>)</strong>
                        <ul>
                            <% For Each ssCase In item.FilesWorkedWithoutComments%>
                            <li>
                                <a href="http://portal.myidealprop.com/<%=item.GetViewLink(ssCase.BBLE)%>" target="_blank">
                                    <%= ssCase.PropertyAddress%>
                                </a>     
                            </li>
                            <% Next%>
                        </ul>
                        <% End If%>


                        <% If item.FilesViewedCount > 0 Then%>
                        <strong>Files Viewed Only (<%= item.FilesViewedCount%>)</strong>
                        <ul>
                            <% For Each ssCase In item.FilesViewedOnly%>
                            <li>
                                <a href="http://portal.myidealprop.com/<%=item.GetViewLink(ssCase.BBLE)%>" target="_blank">
                                    <%= ssCase.PropertyAddress%>
                                </a>     
                            </li>
                            <% Next%>
                        </ul>
                        <% End If%>

                    </td>
                </tr>
            </table>
            <br />
            <% End If%>

            <% Next%>



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
