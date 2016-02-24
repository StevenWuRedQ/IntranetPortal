<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="~/Content.Master" CodeBehind="TitleSummaryPage.aspx.vb" Inherits="IntranetPortal.TitleSummaryPage" %>

<%@ Register Src="~/TitleUI/TitleSummaryView.ascx" TagPrefix="uc1" TagName="TitleSummaryView" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContentPH" runat="server">
    <uc1:TitleSummaryView runat="server" ID="TitleSummaryView" />
</asp:Content>
