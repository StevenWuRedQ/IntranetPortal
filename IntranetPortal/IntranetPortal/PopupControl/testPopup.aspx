<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="testPopup.aspx.vb" Inherits="IntranetPortal.testPopup" MasterPageFile="~/Content.Master" %>

<%@ Register Src="~/PopupControl/VendorsPopup.ascx" TagPrefix="uc1" TagName="VendorsPopup" %>



<asp:Content ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ContentPlaceHolderID="MainContentPH" runat="server">
    <span class="time_buttons" onclick="VendorsPopupClient.Show()">VendorsPopUp</span>
    <h1>{{hello}}</h1>
    <uc1:VendorsPopup runat="server" ID="VendorsPopup" />
   
</asp:Content>

