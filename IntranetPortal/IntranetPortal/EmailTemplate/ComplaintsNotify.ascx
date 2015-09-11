<%@ Control Language="vb" AutoEventWireup="false" CodeBehind="ComplaintsNotify.ascx.vb" Inherits="IntranetPortal.ComplaintsNotify1" %>
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

Dear <%=  UserName%>,
<br />
<br />
Below is your DOB Complaints Properties Watch List. You will get email notification upon any complaints status changed. 
<br />
<br />

<table style="margin-left: 15px; border: 1px solid black; border-collapse: collapse; border-spacing: 0px; width: 700px" border="1" cellspacing="0">
    <thead>
        <tr>
            <td>Total Properties Being Watch:<%=Complaints.Count%></td>
        </tr>
    </thead>
    <tr>
        <td>
            <ul style="line-height:25px">
                <% For Each cp In Complaints%>
                <li>
                  <a href="/Complaints/ComplainsMng.aspx?bble=<%= cp.BBLE %>" target="_blank" ><%= cp.Address %></a>
                </li>
                <% Next%>
            </ul>         

        </td>
    </tr>
</table>
<br />
More info, please <a href="http://portal.myidealprop.com/Complaints/ComplainsMng.aspx">click here</a>.
<br />
<br />
<br />
Regards,<br />
The Portal Team<br />
<small>(This is an automatic email. Please do not reply.)</small><br />
