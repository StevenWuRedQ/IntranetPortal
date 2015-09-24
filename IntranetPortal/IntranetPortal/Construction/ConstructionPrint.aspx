<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="ConstructionPrint.aspx.vb" Inherits="IntranetPortal.ConstructionPrint" MasterPageFile="~/Content.Master" %>

<%@ Register Src="~/Construction/ConstructionUICtrl.ascx" TagPrefix="uc1" TagName="ConstructionUICtrl" %>


<asp:Content runat="server" ContentPlaceHolderID="head"></asp:Content>
<asp:Content runat="server" ContentPlaceHolderID="MainContentPH">
    <uc1:ConstructionUICtrl runat="server" ID="ConstructionUICtrl" />
</asp:Content>
<script>

</script>