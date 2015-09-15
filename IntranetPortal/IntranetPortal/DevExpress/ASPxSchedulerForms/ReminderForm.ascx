<%@ Control Language="vb" AutoEventWireup="true" Inherits="IntranetPortal.ReminderForm" Codebehind="ReminderForm.ascx.vb" %>
<%@ Register Assembly="DevExpress.Web.v15.1, Version=15.1.6.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" Namespace="DevExpress.Web"
	TagPrefix="dxe" %>

<table class="dxscBorderSpacing" <%= DevExpress.Web.Internal.RenderUtils.GetTableSpacings(Me, 0, 0) %> style="width:100%; padding-bottom:15px;">
	<tr><td> 
		 <dxe:ASPxListBox ID="lbItems" runat="server" Width="100%" style="padding-bottom:15px;"></dxe:ASPxListBox>
	</td></tr>
</table>
<table class="dxscButtonTable" style="width: 100%" <%= DevExpress.Web.Internal.RenderUtils.GetTableSpacings(Me, 0, 0) %>>
	<tr>
		<td style="width:100%;"><dxe:ASPxButton ID="btnDismissAll" runat="server" AutoPostBack="false"></dxe:ASPxButton></td>
		<td class="dx-ar" style="width:80px;" <%= DevExpress.Web.Internal.RenderUtils.GetAlignAttributes(Me, "right", Nothing)%>>
            <dxe:ASPxButton ID="btnDismiss" runat="server" Width="80px" AutoPostBack="false"></dxe:ASPxButton></td>
	</tr>
	<tr>
		<td colspan="2" style="padding:8px 0 4px 0;"><dxe:ASPxLabel ID="lblClickSnooze" runat="server"></dxe:ASPxLabel></td>
	</tr>
	<tr>
		<td style="width:100%;padding-right:20px;"><dxe:ASPxComboBox ID="cbSnooze" runat="server" Width="100%">
		</dxe:ASPxComboBox></td>
		<td style="width:80px;"><dxe:ASPxButton ID="btnSnooze" runat="server" Width="80px" AutoPostBack="false"></dxe:ASPxButton></td>
	</tr>
</table>