<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="PublishPropertyPage.aspx.vb" Inherits="IntranetPortal.PublishPropertyPage" MasterPageFile="~/Content.Master" %>

<%@ Register Src="~/Publish/PublishProperty.ascx" TagPrefix="uc1" TagName="PublishProperty" %>

<asp:Content ContentPlaceHolderID="MainContentPH" runat="server">
    <uc1:PublishProperty runat="server" id="PublishProperty" />
</asp:Content>