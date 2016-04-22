<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="~/Content.Master" CodeBehind="WebForm4.aspx.vb" Inherits="IntranetPortal.WebForm4" %>

<%@ Register Src="~/UserControl/AuditLogs.ascx" TagPrefix="uc1" TagName="AuditLogs" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContentPH" runat="server">

<uc1:AuditLogs runat="server" ID="logs" />

</asp:Content>
