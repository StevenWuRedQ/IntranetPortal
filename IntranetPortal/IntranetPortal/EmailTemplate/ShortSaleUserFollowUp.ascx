<%@ Control Language="vb" AutoEventWireup="false" CodeBehind="ShortSaleUserFollowUp.ascx.vb" Inherits="IntranetPortal.ShortSaleUserFollowUp" %>
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
Below is summary of your Followups today (<%= DateTime.Today.ToShortDateString() %>). Please review.
<br />
<br />
<% Dim item = ActivityData%>
<table style="margin-left: 15px; border: 1px solid black; border-collapse: collapse; border-spacing: 0px; width: 700px" border="1" cellspacing="0">
    <thead>
        <tr>
            <td>Total FollowUp Cases:<%=item.FollowUpMissedCount%></td>
        </tr>
    </thead>
    <tr>
        <td>
            <% If item.FollowUpMissedCount > 0 Then%>
            <strong>Missed FollowUp (<%= item.FollowUpMissedCount%>) / Followup Date</strong>
            <ul>
                <% For Each ssCase In item.FollowUpMissed%>
                <li>
                    <a href="http://portal.myidealprop.com/<%=item.GetViewLink(ssCase.BBLE)%>" target="_blank">
                        <%= ssCase.CaseName%> 
                    </a>&nbsp; (<%= ssCase.FollowUpDate.ToShortDateString %>)
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
