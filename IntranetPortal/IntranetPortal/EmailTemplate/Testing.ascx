<%@ Control Language="vb" AutoEventWireup="false" CodeBehind="Testing.ascx.vb" Inherits="IntranetPortal.Testing" %>
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

Dear {{$Agent}},
<br />
<br />
{{$RequestBy}} has requested information on your lead {{$Address}}.
<br />
<br />
<table style="margin-left: 15px; border: 1px solid black">
    <thead>
        <tr>
            <td colspan="2">Request Information Detail</td>            
        </tr>
    </thead>
    <tbody>        
        <tr>
            <td style="width:150px">Lead Name:</td>
            <td style="width:300px"><a href="http://portal.myidealprop.com/viewleadsinfo.aspx?id={{$BBLE}}">{{$Address}}</a></td>
        </tr>
        <tr>
            <td>Priority:</td>
            <td>{{$Priority}}</td>            
        </tr>
         <tr>
            <td>Request By:</td>
            <td>{{$RequestBy}}</td>
        </tr>
        <tr>
            <td>Description:</td>
            <td>{{$Description}}</td>            
        </tr>        
    </tbody>
</table>
<br />
Please use "Reply All" to respond to this email.
<br />
<br />
Regards,<br />
Portal