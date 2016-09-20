<%@ Control Language="vb" AutoEventWireup="false" CodeBehind="NewOfferNotification.ascx.vb" Inherits="IntranetPortal.NewOfferNotification1" %>
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
<div>
            Dear <%= Manager%>,
            <br />
            <br />
            <% If OfferData IsNot Nothing AndAlso OfferData.Count > 0 %>
            Below is the properties that accepted by ShortSale Last week. Please review.
            <br />
            <br />
            <table style="margin-left: 15px; border: 1px solid black; border-collapse:collapse;border-spacing: 0px;" border="1" cellspacing="0">
                <thead style="border: 1px solid black; font-weight:bold;background-color: #efefef;">
                    <tr>
                        <td>Property Address</td>                        
                        <td>Agent</td>
                        <td>Team</td>
                        <td>Accepted Date</td>
                        <td>Accepted By</td>
                    </tr>
                </thead>
                <tbody>
                  <% For Each offer In OfferData %>
                    <tr>
                        <td>
                           <a href="/viewleadsinfo.aspx?id=<%= offer.BBLE %>"><%= offer.Title %></a> </td>
                        <td><%= offer.Owner %></td>
                        <td><%= offer.Team %></td>
                        <td><%= string.Format("{0:d}", offer.AcceptedDate) %></td>
                        <td><%= offer.AcceptedBy %></td>
                    </tr>
                  <% Next %>
                </tbody>
            </table>
            <% else %>
            No property was accepted by ShortSale last week. Thank you.
            <% End If %>          
            <br />
            More info, please <a href="http://portal.myidealprop.com/managementui/management.aspx">click here</a>.
            <br />
            <br />
            <br />
            Regards,<br />
            The Portal Team<br />
            <br />
        </div>