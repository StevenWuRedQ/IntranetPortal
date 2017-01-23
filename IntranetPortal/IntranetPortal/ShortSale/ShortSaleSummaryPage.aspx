<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="ShortSaleSummaryPage.aspx.vb" Inherits="IntranetPortal.ShortSaleSummaryPage" MasterPageFile="~/Content.Master" %>
<%@ Register Src="~/ShortSale/TitleSummary.ascx" TagPrefix="uc1" TagName="TitleSummary" %>

<asp:Content ContentPlaceHolderID="MainContentPH" runat="server" ID="content">

    <%
        If Page.User.IsInRole("ShortSale-OutsideAgent") Then
            Response.Redirect("/SummaryPage.aspx")
        End If
    %>

    <uc1:TitleSummary runat="server" ID="TitleSummary" />
</asp:Content>

