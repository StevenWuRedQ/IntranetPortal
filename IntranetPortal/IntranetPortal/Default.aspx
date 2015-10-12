<%@ Page Title="" Language="vb" AutoEventWireup="false" CodeBehind="Default.aspx.vb" Inherits="IntranetPortal.Default2" MasterPageFile="~/Root.Master" %>
<%@ Register Src="~/UserControl/UserSummary.ascx" TagPrefix="uc1" TagName="UserSummary" %>
<%@ Register Src="~/UserControl/NavMenu.ascx" TagPrefix="uc1" TagName="NavMenu" %>

<asp:Content ID="Content1" ContentPlaceHolderID="NavContentHolder" runat="server">  
      <style type="text/css">
        /*have scrollbar content class add by steven*/
        .scorllbar_content {
            /*it can' don't need postion relative by this class  in tree view it add atuo*/
            position: relative;            
            /*height: 600px;*/
        }
        /*-----end-------*/
    </style>
    <uc1:NavMenu runat="server" ID="NavMenu" />
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="Content" runat="server">
      <iframe id="contentUrlPane" width="100%" height="100%" frameborder="0" name="contentUrlPane" scrolling="yes" marginheight="0" marginwidth="0" src="<%= ContentUrl%>"></iframe>
</asp:Content>
