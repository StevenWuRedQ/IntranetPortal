<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="ComplaintsView.aspx.vb" Inherits="IntranetPortal.ComplaintsView1" MasterPageFile="~/Content.Master" %>

<asp:Content runat="server" ContentPlaceHolderID="head">
</asp:Content>
<asp:Content ContentPlaceHolderID="MainContentPH" runat="server">
 
    <asp:Repeater runat="server" ID="rptComplaints">
        <ItemTemplate>
            <table class="" style="width: 100%; border: 1px solid #808080; line-height: 25px">
                <tr>
                    <td colspan="4" class="form_header">Complaints - <%# Eval("ComplaintNumber")%> - Detail
                    </td>
                </tr>
                <tr>
                    <td style="width: 150px;">Address
                    </td>
                    <td style="width: 35%">
                        <%#Eval("Address")%>
                    </td>
                    <td>DateEntered
                    </td>
                    <td>
                        <%#Eval("DateEntered")%>
                    </td>
                </tr>
                <tr>
                    <td>Owner
                    </td>
                    <td>
                        <%#Eval("Owner")%>
                    </td>
                    <td>AssignedTo
                    </td>
                    <td>
                        <%#Eval("AssignedTo")%>
                    </td>
                </tr>
                <tr>
                    <td>Subject
                    </td>
                    <td>
                        <%#Eval("Subject")%>
                    </td>
                    <td>Zip
                    </td>
                    <td>
                        <%#Eval("Zip")%>
                    </td>
                </tr>
                <tr>
                    <td>RE
                    </td>
                    <td>
                        <%#Eval("RE")%>
                    </td>

                    <td>Reference311Number
                    </td>
                    <td>
                        <%#Eval("Reference311Number")%>
                    </td>
                </tr>
                <tr>
                    <td>LastInspection
                    </td>
                    <td>
                        <%#Eval("LastInspection")%>
                    </td>
                    <td style="width: 150px">Category
                    </td>
                    <td>
                        <%#Eval("CategoryCode")%>
                    </td>

                </tr>
                <tr>
                    <td>Disposition
                    </td>
                    <td>
                        <%#Eval("Disposition")%>
                    </td>
                    <td>DispositionDetails
                    </td>
                    <td>
                        <%#Eval("DispositionDetails")%>
                    </td>
                </tr>
                <tr>
                    <td style="width: 150px">Comments
                    </td>
                    <td>
                        <%#Eval("Comments")%>
                    </td>
                    <td>LastUpdated
                    </td>
                    <td>
                        <%#Eval("LastUpdated")%>
                    </td>
                </tr>
                <tr>
                    <td>Priority
                    </td>
                    <td>
                        <%#Eval("Priority")%>
                    </td>
                    <td>BIN
                    </td>
                    <td>
                        <%#Eval("BIN")%>
                    </td>
                </tr>
                <tr>
                    <td>DOB Violation
                    </td>
                    <td>
                        <%#Eval("DOBViolation")%>
                    </td>
                    <td>ECB Violation
                    </td>
                    <td>
                        <%#Eval("ECBViolation")%>
                    </td>
                </tr>
            </table>
            <br />
        </ItemTemplate>
    </asp:Repeater>



</asp:Content>
