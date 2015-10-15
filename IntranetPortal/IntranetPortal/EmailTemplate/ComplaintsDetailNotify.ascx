<%@ Control Language="vb" AutoEventWireup="false" CodeBehind="ComplaintsDetailNotify.ascx.vb" Inherits="IntranetPortal.ComplaintsDetailNotify" %>
<style type="text/css">
    .maininfo {
        font-family: arial;
        font-size: 9pt;
        color: black;
        font-weight: bold;
        background-color: #9BCDFF;
    }

    .content {
        font-family: arial;
        font-size: 9pt;
        color: black;
        font-weight: normal;
    }

    .mainhdg {
        font-family: Arial;
        font-size: 11pt;
        font-weight: bold;
        color: #000080;
        text-align: center;
    }

    .rightcontent {
        font-family: Arial;
        font-size: 9pt;
        color: black;
        text-align: right;
        font-weight: normal;
    }
</style>


Dear All,
<br />
<br />
FYI - The DOB Complaint, for the property located at: (<%= GetMailDataItem("Address") %>), has been updated.
<br />
<br />

<% For Each item In complaint.ComplaintsResult.Where(Function(c) c.Status = "ACT").ToList %>

<table border="0" cellpadding="1" cellspacing="0" width="750" style="margin: 0 auto;">
    <tbody>
        <tr>
            <td>
                <h3 class="mainhdg">Overview for Complaint #:<%= item.ComplaintNumber %>= <%= item.Status %></h3>
            </td>
        </tr>
    </tbody>
</table>
<table border="0" cellpadding="1" cellspacing="0" width="750" style="margin: 0 auto;">
    <tbody>
        <tr>
            <td class="maininfo" align="left" width="300" colspan="2">Complaint at:&nbsp;&nbsp;<%=item.Address%></td>
            <td class="maininfo" align="right">BIN: <%=item.BIN%></td>
            <td class="maininfo" width="10">&nbsp;&nbsp;</td>
            <td class="maininfo" align="right">Borough:&nbsp;<%=item.Borough%></td>
            <td class="maininfo" width="10">&nbsp;&nbsp;</td>
            <td class="maininfo" align="right">ZIP:&nbsp;<%=item.Zip%></td>
        </tr>
        <tr valign="top">
            <td class="content" colspan="6">Re:&nbsp;&nbsp;<%= item.RE%></td>
        </tr>
    </tbody>
</table>
<br />
<table border="0" cellpadding="1" cellspacing="0" width="750" style="margin: 0 auto;">
    <tbody>
        <tr>
            <td class="content" colspan="2"></td>
            <td class="content"></td>
        </tr>
        <tr>
            <td class="content" width="150"><b>Category Code:</b></td>
            <td class="content" colspan="2" width="600"><%=item.CategoryCode%></td>
        </tr>
        <tr>
            <td class="content" width="150" colspan="3">
                <br>
            </td>
        </tr>
        <tr>
            <td class="content" width="150" colspan="3">
                <br>
            </td>
        </tr>
        <tr>
            <td class="content" width="150"><b>Assigned To:</b></td>
            <td class="content" width="450"><%=item.AssignedTo%></td>
            <td class="content" width="150"><b>Priority:</b>&nbsp;&nbsp;<%=item.Priority%>&nbsp;
			&nbsp;&nbsp;</td>
        </tr>
        <tr>
            <td class="rightcontent" colspan="3"><b>311 Reference Number:</b>&nbsp;&nbsp;<%=item.Reference311Number%>
			&nbsp;&nbsp;</td>
        </tr>
    </tbody>
</table>
<table border="0" cellpadding="1" cellspacing="0" width="750" style="margin: 0 auto;">
    <tbody>
        <tr>
            <td>
                <hr>
            </td>
        </tr>
    </tbody>
</table>
<table border="0" cellpadding="1" cellspacing="0" width="750" style="margin: 0 auto;">
    <tbody>
        <tr>
            <td class="content"><b>Received:</b></td>
            <td class="content">&nbsp;&nbsp;<%=item.DateEntered%></td>
            <td class="content" width="10">&nbsp;</td>
            <td class="content"><b>BBLE:</b>&nbsp;&nbsp;<%=item.BBLE%></td>
            <td class="content"><b></b>&nbsp;&nbsp;</td>
            <td class="content" width="25">&nbsp;</td>
            <td class="content" align="right"><b>Community Board:</b>&nbsp;&nbsp;</td>
        </tr>
        <tr>
            <td class="content"><b>Owner:</b></td>
            <td class="content">&nbsp;&nbsp;<%=item.Owner%></td>
            <!--- Value for Owner --->
            <td colspan="5">&nbsp;</td>
        </tr>

    </tbody>
</table>
<br />
<table border="0" cellpadding="0" cellspacing="0" width="750" style="margin: 0 auto;">
    <tbody>
        <tr>
            <td class="content" width="30%" align="right" valign="top"><b>Last Inspection:</b>&nbsp;&nbsp;</td>

            <td class="content" width="70%"><%=item.LastInspection%> </td>

        </tr>
        <tr>
            <td class="content" width="30%" align="right" valign="top"><b>Disposition:</b>&nbsp;&nbsp;</td>
            <td class="content" width="70%"><%=item.DispositionDetails%> </td>
        </tr>
        <tr>
            <td class="content" width="30%" valign="top" align="right"><b>Comments:</b>&nbsp;&nbsp;</td>
            <td class="content" width="70%"><%=item.Comments%></td>
        </tr>
    </tbody>
</table>
<table border="0" cellpadding="1" cellspacing="0" width="750" style="margin: 0 auto;">
    <tbody>
        <tr>
            <td>
                <hr>
            </td>
        </tr>
    </tbody>
</table>

<% If item.Complaints_Disposition_History IsNot Nothing AndAlso item.Complaints_Disposition_History.Count > 0 %>

<table border="0" cellpadding="1" cellspacing="0" width="750">
    <tbody>
        <tr>
            <td class="mainhdg">Complaint Disposition History</td>
        </tr>
    </tbody>
</table>
<br />
<table border="0" cellpadding="2" cellspacing="0" width="750">
    <!--- Nested Table for Content Area --->
    <tbody>    
        <tr valign="middle">
            <td class="centercolhdg">#</td>
            <td class="centercolhdg" colspan="2">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Disposition</td>
            <td class="centercolhdg" rowspan="2">Disposition</td>
            <td class="centercolhdg">Inspection</td>
            <td class="centercolhdg" rowspan="2">Date</td>
        </tr>
        <tr>
            <td class="centercolhdg"></td>
            <td class="centercolhdg">Date</td>
            <td class="centercolhdg">Code</td>
            <td class="centercolhdg">By</td>
        </tr>
        <tr>
            <td colspan="6"></td>
        </tr>

        <tr class="inlineform" valign="top">
            <!--- ROW For Data --->
            <td class="content">3&nbsp;</td>
            <td class="content">&nbsp;10/18/2012&nbsp;</td>
            <!--- Cell for Disp Date --->
            <td class="content">&nbsp;&nbsp;&nbsp;&nbsp;C2&nbsp;</td>
            <td class="content">INSPECTOR UNABLE TO GAIN ACCESS - 2ND ATTEMPT&nbsp;</td>

            <td class="content">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;2222</td>
            <!--- Cell for Inspection By --->

            <td class="content">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;10/17/2012&nbsp;</td>
        </tr>

        <tr valign="top">
            <td class="content">&nbsp;</td>
            <td class="content">&nbsp;</td>
            <td class="content">&nbsp;</td>
            <td class="content">NO ACCESS TO BUILDING. LS4 POSTED</td>
            <td class="content" colspan="2"></td>
        </tr>

        <tr class="inlineform" valign="top">
            <!--- ROW For Data --->
            <td class="content">2&nbsp;</td>
            <td class="content">&nbsp;10/18/2012&nbsp;</td>
            <!--- Cell for Disp Date --->
            <td class="content">&nbsp;&nbsp;&nbsp;&nbsp;C1&nbsp;</td>
            <td class="content">INSPECTOR UNABLE TO GAIN ACCESS - 1ST ATTEMPT&nbsp;</td>

            <td class="content">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;2222</td>
            <!--- Cell for Inspection By --->

            <td class="content">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;10/17/2012&nbsp;</td>
        </tr>

        <tr valign="top">
            <td class="content">&nbsp;</td>
            <td class="content">&nbsp;</td>
            <td class="content">&nbsp;</td>
            <td class="content">NO ACCESS LS4 POSTED</td>
            <td class="content" colspan="2"></td>
        </tr>




        <tr class="inlineform" valign="top">
            <!--- ROW For Data --->
            <td class="content">1&nbsp;</td>
            <td class="content">&nbsp;10/17/2012&nbsp;</td>
            <!--- Cell for Disp Date --->
            <td class="content">&nbsp;&nbsp;&nbsp;&nbsp;D5&nbsp;</td>
            <td class="content">COMPLAINT ASSIGNED TO EMERGENCY RESPONSE TEAM&nbsp;</td>

            <td class="content">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;2374</td>
            <!--- Cell for Inspection By --->

            <td class="content">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;10/17/2012&nbsp;</td>
        </tr>

        <tr valign="top">
            <td class="content">&nbsp;</td>
            <td class="content">&nbsp;</td>
            <td class="content">&nbsp;</td>
            <td class="content">REFER TO BORO ERT AS PER A. CHIEF OF BORO ERT</td>
            <td class="content" colspan="2"></td>
        </tr>




    </tbody>
</table>

<% End If %>

<%--<table class="table" style="width: 100%; border: 1px solid #808080; line-height: 25px; white-space: normal; color: black">
    <tr>
                                                                                                                            <td colspan="4" class="form_header">Complaints - <%= item.ComplaintNumber %> -Detail
        </td>
    </tr>
    <tr>
        <td style="width: 150px;">Address:  
        </td>
        <td style="width: 35%"><%= item.Address%>
        </td>
        <td>Acquisition Date:
        </td>
        <td><%= item.AcquisitionDate%>
        </td>
    </tr>
    <tr>
        <td>Owner :  
        </td>
        <td><%= item.Owner%>
        </td>
        <td style="width: 150px">DateEntered:  
        </td>
        <td style="width: 35%"><%= item.DateEntered%>
        </td>
    </tr>
    <tr>
        <td style="color: red; vertical-align: top">Red Notes:
        </td>
        <td style="color: red"><%= item.RedNotes%>
        </td>
        <td>AssignedTo:  
        </td>
        <td><%= item.AssignedTo%>
        </td>
    </tr>
    <tr>
        <td>Subject:  
        </td>
        <td><%= item.Subject%>
        </td>
        <td>Zip:  
        </td>
        <td><%= item.Zip%>
        </td>
    </tr>
    <tr>
        <td>RE:  
        </td>
        <td><%= item.RE%>
        </td>
        <td>Reference311Number :  
        </td>
        <td><%= item.Reference311Number%>
        </td>
    </tr>
    <tr>
        <td>LastInspection:  
        </td>
        <td style="background-color: lightyellow"><%= item.LastInspection%>
        </td>
        <td style="width: 150px">Category :  
        </td>
        <td><%= item.CategoryCode%>
        </td>

    </tr>
    <tr>
        <td style="width: 150px">Comments:  
        </td>
        <td style="background-color: lightyellow"><%= item.Comments%>
        </td>
        <td>DispositionDetails:  
        </td>
        <td><%= item.DispositionDetails%>
        </td>
    </tr>
    <tr>
        <td>Disposition:  
        </td>
        <td><%= item.Disposition%>
        </td>
        <td>LastUpdated:  
        </td>
        <td><%= item.LastUpdated%>
        </td>
    </tr>
    <tr>
        <td>Priority:  
        </td>
        <td><%= item.Priority%>
        </td>
        <td>BIN:  
        </td>
        <td><%= item.BIN%>
        </td>
    </tr>
    <tr>
        <td>DOB Violation:
        </td>
        <td><%= item.DOBViolation %>
        </td>
        <td>ECB Violation:
        </td>
        <td><%= item.ECBViolation%>
        </td>
    </tr>
</table>--%>

<br />

<% Next %>



For more information, Please click on <a href='http://portal.myidealprop.com/Complaints/ComplainsMng.aspx?bble=<%= GetMailDataItem("BBLE") %>'>this link </a>to  review. 
<br />
<br />
Regards,
<br />
Portal Team
<br />
<small>This is an automatic email. Please do not reply.</small>