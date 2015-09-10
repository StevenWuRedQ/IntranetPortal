<%@ Control Language="vb" AutoEventWireup="false" CodeBehind="ShortSaleUserReport.ascx.vb" Inherits="IntranetPortal.ShortSaleUserReport" %>
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

Dear <%= ActivityData.Name%>,
<br />
<br />
Below is summary of your activities today (<%= DateTime.Today.ToShortDateString() %>). Please review.
<br />
<br />
<% Dim item = ActivityData%>
<table style="margin-left: 15px; border: 1px solid black; border-collapse: collapse; border-spacing: 0px; width: 700px" border="1" cellspacing="0">
    <thead>
        <tr>
            <td>Total Files Opened:<%=item.TotalFileOpened.Count%></td>
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
More info, please <a href="http://portal.myidealprop.com/">click here</a>.
<br />
<br />
<br />
Regards,<br />
The Portal Team<br />
<small>(This is an automatic email. Please do not reply.)</small><br />
