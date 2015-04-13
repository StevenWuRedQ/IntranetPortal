<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="CallManagement.aspx.vb" Inherits="IntranetPortal.CallManagement" MasterPageFile="~/Content.Master" %>

<%@ Register Src="~/PopupControl/MapsPopup.ascx" TagPrefix="uc1" TagName="MapsPopup" %>



<asp:Content ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ContentPlaceHolderID="MainContentPH" runat="server">
    <div class="container">
        <table class="table table-striped">
            <thead>
                <tr>
                    <th>From</th>
                    <th>To</th>
                    <th>Duration</th>
                    <th>Join</th>
                </tr>
            </thead>
            <tbody>
                <tr>
                    <th >9298883289</th>
                    <td>Chris</td>
                    <td>10:00</td>
                    <td><i class="fa fa-phone icon_btn"></i></td>
                </tr>
               <%For Each c In CallList%>
                 <tr>
                    
                    <th ><%= c.From%></th>
                    <td><%= c.To %></td>
                    <td><%= c.Duration %></td>
                    <td><i class="fa fa-phone icon_btn" onclick="MonitorCall('<%=c.Sid %>')"></i></td>
                </tr>
                <% Next %>
            </tbody>
        </table>
    </div>
    <script>
        function MonitorCall(sid)
        {
            alert(sid)
        }
    </script>
</asp:Content>
