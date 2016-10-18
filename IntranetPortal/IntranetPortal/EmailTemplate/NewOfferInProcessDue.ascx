<%@ Control Language="vb" AutoEventWireup="false" CodeBehind="NewOfferInProcessDue.ascx.vb" Inherits="IntranetPortal.NewOfferPassDueControl" %>

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

    .topbar {
        background-color: #234b60;
        height: 50px;
        font-size: 30px;
        font-weight: 600;
        color: white;
        text-align: left;
        vertical-align: central;
        margin-top: 30px;
        margin-bottom: 30px;
        padding: 10px;
        font-family: Tahoma;
    }

    .text {
        font-size: 18px;
    }
</style>

<div style="width: 900px">
    <% If OfferData IsNot Nothing AndAlso OfferData.Count > 0 %>
    <div class="topbar">
        InProcess New Offers Pass Due
    </div>    
    <span class="text">Please check below NewOffers, which were in Process for over one week but not accepted by ShortSale.</span>
    <br />
    <br />
    <table style="margin-left: 15px; border: 1px solid black; border-collapse: collapse; border-spacing: 0px;" border="1" cellspacing="0">
        <thead style="border: 1px solid black; font-weight: bold; background-color: #efefef;">
            <tr>
                <td>Property Address</td>
                <td>Completed</td>
                <td>Agent</td>
                <td>Team</td>               
                <td>InProcess</td>               
                <td>Duration</td>
            </tr>
        </thead>
        <tbody>
            <% For Each offer In OfferData %>
            <tr>
                <td>
                    <a href="http://portal.myidealprop.com/viewleadsinfo.aspx?id=<%= offer.BBLE %>"><%= offer.Title %></a></td>
                <td><%= string.Format("{0:d}", offer.UpdateDate) %></td>
                <td><%= offer.LeadsOwner %></td>
                <td><%= offer.Team %></td>
                <td><%= offer.InProcessDate %></td>
                <td><%= HumanizeTimeSpan(DateTime.Now - offer.InProcessDate) %></td>
            </tr>
            <% Next %>
        </tbody>
    </table>
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
