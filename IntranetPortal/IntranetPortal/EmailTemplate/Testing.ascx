<%@ Control Language="vb" AutoEventWireup="false" CodeBehind="Testing.ascx.vb" Inherits="IntranetPortal.Testing" %>
Dear {{$UserName}}, 
<br />
<br />
FYI - The DOB Complaint, for the property located at: ({{$Address}}), has been updated. <br />
<br />

  <table class="table" style="width: 100%; border: 1px solid #808080; line-height: 25px; white-space: normal; color: black">
                        <tr>
                            <td colspan="4" class="form_header">Complaints - {{$ComplaintNumber}} - Detail
                            </td>
                        </tr>
                        <tr>
                            <td style="width: 150px;">Address:
                            </td>
                            <td style="width: 35%">{{$Address}}
                            </td>
                            <td>Acquisition Date:
                            </td>
                            <td>{{$AcquisitionDate}}
                            </td>
                        </tr>
                        <tr>
                            <td>Owner:
                            </td>
                            <td>{{$Owner}}
                            </td>
                            <td style="width: 150px">DateEntered:
                            </td>
                            <td style="width: 35%">{{$DateEntered}}
                            </td>
                        </tr>
                        <tr>
                            <td style="color: red; vertical-align: top">Red Notes:
                            </td>
                            <td style="color: red">{{$RedNotes}}
                            </td>
                            <td>AssignedTo:
                            </td>
                            <td>{{$AssignedTo}}
                            </td>
                        </tr>
                        <tr>
                            <td>Subject:
                            </td>
                            <td>{{$Subject}}
                            </td>
                            <td>Zip:
                            </td>
                            <td>{{$Zip}}
                            </td>
                        </tr>
                        <tr>
                            <td>RE:
                            </td>
                            <td>{{$RE}}
                            </td>
                            <td>Reference311Number:
                            </td>
                            <td>{{$Reference311Number}}
                            </td>
                        </tr>
                        <tr>
                            <td>LastInspection:
                            </td>
                            <td style="background-color: lightyellow">{{$LastInspection}}
                            </td>
                            <td style="width: 150px">Category:
                            </td>
                            <td>{{$CategoryCode}}
                            </td>

                        </tr>
                        <tr>
                            <td style="width: 150px">Comments:
                            </td>
                            <td style="background-color: lightyellow">{{$Comments}}
                            </td>
                            <td>DispositionDetails:
                            </td>
                            <td>{{$DispositionDetails}}
                            </td>
                        </tr>
                        <tr>
                            <td>Disposition:
                            </td>
                            <td>{{$Disposition}}
                            </td>
                            <td>LastUpdated:
                            </td>
                            <td>{{$LastUpdated}}
                            </td>
                        </tr>
                        <tr>
                            <td>Priority:
                            </td>
                            <td>{{$Priority}}
                            </td>
                            <td>BIN:
                            </td>
                            <td>{{$BIN}}
                            </td>
                        </tr>
                        <tr>
                            <td>DOB Violation:
                            </td>
                            <td>{{$DOBViolation}}
                            </td>
                            <td>ECB Violation:
                            </td>
                            <td>{{$ECBViolation}}
                            </td>
                        </tr>
                    </table>

<br />



Please click on <a href='http://portal.myidealprop.com/Complaints/ComplainsMng.aspx?bble={{$BBLE}}'> this link </a> to  review. 
<br />
<br />
Regards, <br />
Portal Team
<br />
<small>This is an automatic email. Please do not reply.</small>