<%@ Control Language="vb" AutoEventWireup="true" Inherits="IntranetPortal.AppointmentDragToolTip" Codebehind="AppointmentDragToolTip.ascx.vb" %>
<%@ Register Assembly="DevExpress.Web.v15.1, Version=15.1.6.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" Namespace="DevExpress.Web"
	TagPrefix="dxe" %>

<div style="white-space:nowrap;">
	<dxe:ASPxLabel ID="lblInterval" runat="server" Text="CustomDragAppointmentTooltip" EnableClientSideAPI="true">
		</dxe:ASPxLabel>
	<br />
	<dxe:ASPxLabel ID="lblInfo" runat="server" EnableClientSideAPI="true"></dxe:ASPxLabel>
</div>

<script id="dxss_ASPxClientAppointmentDragTooltip" type="text/javascript"><!--
    ASPxClientAppointmentDragTooltip = ASPx.CreateClass(ASPxClientToolTipBase, {
		CalculatePosition: function(bounds) {
			return new ASPxClientPoint(bounds.GetLeft(), bounds.GetTop() - bounds.GetHeight());
		},
		Update: function (toolTipData) {
			var stringInterval = this.GetToolTipContent(toolTipData);
			var oldText = this.controls.lblInterval.GetText();
			if (oldText != stringInterval)
				this.controls.lblInterval.SetText(stringInterval);
		},
		GetToolTipContent: function(toolTipData) {    
			var interval = toolTipData.GetInterval();
			return this.ConvertIntervalToString(interval);
		}
	});
//--></script>