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
    .topbar {
        background-color:#234b60; height:50px;
        font-size:30px;font-weight:600;color:white; text-align:left; vertical-align:central;
        margin-top:30px;
        margin-bottom:30px;
        padding:10px;
        font-family: Tahoma;
    }
    .text {
        font-size:18px;
    }
</style>

<div style="width:900px">
            <% If OfferData IsNot Nothing AndAlso OfferData.Count > 0 %>
            <div class="topbar">
                Short Sales Accepted 
            </div>
            <span class="text">Properties accepted by ShortSale for the week (<%= String.Format("{0:d} - {1:d}", Now.AddDays(-7), Now.AddDays(-1)) %>):</span>
            <br />
            <br />
            <table style="margin-left: 15px; border: 1px solid black; border-collapse:collapse;border-spacing: 0px;" border="1" cellspacing="0">
                <thead style="border: 1px solid black; font-weight:bold;background-color: #efefef;">
                    <tr>
                        <td>Property Address</td>                        
                        <td>Agent</td>
                        <td>Team</td>
                        <td>Acceptance Date</td>
                        <td>Accepted By</td>
                    </tr>
                </thead>
                <tbody>
                  <% For Each offer In OfferData %>
                    <tr>
                        <td>
                           <a href="http://portal.myidealprop.com/viewleadsinfo.aspx?id=<%= offer.BBLE %>"><%= offer.Title %></a> </td>
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
            For more infomation, please <a href="http://portal.myidealprop.com/newoffer/newofferlist.aspx">click here</a>.
            <br />
            <br />
            <br />
            Regards,<br />
            The Portal Team<br />
            <br />
        </div>