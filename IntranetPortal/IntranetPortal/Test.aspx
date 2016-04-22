<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="Test.aspx.vb" Inherits="IntranetPortal.Test" MasterPageFile="~/Content.Master" %>

<%@ Register Src="~/TitleUI/TitleDocTab.ascx" TagPrefix="uc1" TagName="TitleDocTab" %>

<asp:Content ContentPlaceHolderID="head" runat="server">
    <script src="https://cdnjs.cloudflare.com/ajax/libs/jasmine/2.4.1/jasmine.js"></script>
</asp:Content>

<asp:Content runat="server" ContentPlaceHolderID="MainContentPH">
    <uc1:TitleDocTab runat="server" ID="TitleDocTab" />
    <script type="text/javascript">
        
    </script>
</asp:Content>

