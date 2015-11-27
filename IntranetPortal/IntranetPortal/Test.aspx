<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="Test.aspx.vb" Inherits="IntranetPortal.Test" MasterPageFile="~/Content.Master" %>

<%@ Register Src="~/TitleUI/TitleDocTab.ascx" TagPrefix="uc1" TagName="TitleDocTab" %>

<asp:Content ContentPlaceHolderID="head" runat="server">

</asp:Content>

<asp:Content runat="server" ContentPlaceHolderID="MainContentPH">
    <uc1:TitleDocTab runat="server" ID="TitleDocTab" />

</asp:Content>

