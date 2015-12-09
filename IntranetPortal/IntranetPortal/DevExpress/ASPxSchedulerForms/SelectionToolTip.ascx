<%@ Control Language="vb" AutoEventWireup="true" Inherits="IntranetPortal.SelectionToolTip" Codebehind="SelectionToolTip.ascx.vb" %>
<%@ Register Assembly="DevExpress.Web.v15.1, Version=15.1.6.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" Namespace="DevExpress.Web"
	TagPrefix="dxe" %>
<div runat="server" id="buttonDiv">
	<dxe:ASPxButton ID="btnShowMenu" runat="server" AutoPostBack="False" AllowFocus="False">
		<Border BorderWidth="0px" />
		<Paddings Padding="0px" />
		<FocusRectPaddings Padding="4px" />
		<FocusRectBorder BorderStyle="None" BorderWidth="0px" />
	</dxe:ASPxButton>
</div>