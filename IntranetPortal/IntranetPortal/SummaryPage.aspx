<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="SummaryPage.aspx.vb" Inherits="IntranetPortal.SummaryPage" MasterPageFile="~/Content.Master" %>
<%@ Register Src="~/UserControl/UserSummary.ascx" TagPrefix="uc1" TagName="UserSummary" %>

<asp:Content ContentPlaceHolderID="MainContentPH" runat="server">
    <uc1:UserSummary runat="server" ID="UserSummary" />
</asp:Content>
