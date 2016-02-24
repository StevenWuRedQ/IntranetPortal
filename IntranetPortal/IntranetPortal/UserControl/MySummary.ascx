<%@ Control Language="vb" AutoEventWireup="false" CodeBehind="MySummary.ascx.vb" Inherits="IntranetPortal.MySummary" %>
<%@ Register Src="~/UserControl/Devexpress/CustomVerticalAppointmentTemplate.ascx" TagName="CustomVerticalAppointmentTemplate" TagPrefix="uc1" %>
<%@ Register Src="~/UserControl/LeadsSubMenu.ascx" TagPrefix="uc1" TagName="LeadsSubMenu" %>

<div style="font-family: 'Source Sans Pro'; margin-left: 19px; margin-top: 15px;">
    <div style="float: left; font-weight: 300; font-size: 48px; color: #234b60">
        <span style="text-transform: capitalize" id="spanUserName"><%= Page.User.Identity.Name %></span>'s Summary &nbsp;

    </div>
    <div align="center" style="background-color: #ff400d;" class="label-summary-info">
        <span style="font-weight: 900" id="spanWorklistCount" runat="server">          
        </span>
        <span style="font-weight: 200">&nbsp;Tasks
        </span>
    </div>
    <div align="center" style="background-color: #1a3847; margin-left: 10px;" class="label-summary-info">

        <span style="font-weight: 900" id="spanAppointmentCount" runat="server">
          
        </span>
        <span style="font-weight: 200">&nbsp;Appointments Today
        </span>
    </div>  
</div>
<%------end------%>
<div class="content" style="float: left; margin-right: 10px; margin-left: 35px;">
    <div class="row">
        <asp:Repeater ID="rptModules" runat="server" OnItemDataBound="rptModules_ItemDataBound">
            <ItemTemplate>
                <div class="col-md-3 col-lg-3" id="ltContainer" runat="server">
                </div>
            </ItemTemplate>
        </asp:Repeater>
    </div>
</div>
