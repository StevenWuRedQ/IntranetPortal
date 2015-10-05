<%@ Control Language="vb" AutoEventWireup="false" CodeBehind="ComplaintsDetailNotify.ascx.vb" Inherits="IntranetPortal.ComplaintsDetailNotify" %>
Dear All,
<br />
<br />
FYI - The DOB Complaint, for the property located at: (<%= GetMailDataItem("Address") %>), has been updated. <br />
<br />

<% For Each item In complaint.ComplaintsResult.Where(Function(c) c.Status = "ACT").ToList %>

  <table class="table" style="width: 100%; border: 1px solid #808080; line-height: 25px; white-space: normal; color: black">
                        <tr>
                            <td colspan="4" class="form_header">Complaints - <%= item.ComplaintNumber %> -Detail
                            </td>
                        </tr>
                        <tr>
                            <td style = "width: 150px;" > Address:  
                            </td>
                            <td style = "width: 35%"> <%= item.Address%>
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
                            <td style = "width: 150px" > DateEntered:  
                            </td>
                            <td style = "width: 35%"> <%= item.DateEntered%>
                            </td>
                        </tr>
                        <tr>
                            <td style = "color: red; vertical-align: top" > Red Notes:
                            </td>
                            <td style = "color: red"> <%= item.RedNotes%>
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
                            <td style = "background-color: lightyellow"> <%= item.LastInspection%>
                            </td>
                            <td style = "width: 150px" > Category :  
                            </td>
                            <td><%= item.CategoryCode%>
                            </td>
                    
                        </tr>
                        <tr>
                            <td style = "width: 150px" > Comments:  
                            </td>
                            <td style = "background-color: lightyellow"> <%= item.Comments%>
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
                    </table>

  <br />

<% Next %>



For more information, Please click on <a href='http://portal.myidealprop.com/Complaints/ComplainsMng.aspx?bble=<%= GetMailDataItem("BBLE") %>'> this link </a> to  review. 
<br />
<br />
Regards, <br />
Portal Team
<br />
<small>This is an automatic email. Please do not reply.</small>