<%@ Page Title="" Language="vb" AutoEventWireup="false" CodeBehind="Default.aspx.vb" EnableEventValidation="false" Inherits="IntranetPortal.Default2" MasterPageFile="~/Root.Master" %>

<%@ Register Src="~/UserControl/NavMenu.ascx" TagPrefix="uc1" TagName="NavMenu" %>

<asp:Content ID="Content1" ContentPlaceHolderID="NavContentHolder" runat="server">
    <style type="text/css">
        /*have scrollbar content class add by steven*/
        .scorllbar_content {
            /*it can' don't need postion relative by this class  in tree view it add atuo*/
            position: relative;
            /*height: 600px;*/
        }

        #contentUrlPane {
            position: relative;
            width: 100%;
            height: 100%;
            min-height: 960px;
            overflow: hidden;
            margin: 0;
            border: none;
        }
    </style>
    <uc1:NavMenu runat="server" ID="NavMenu" />
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="Content" runat="server">
    <iframe id="contentUrlPane" name="contentUrlPane" height="100%" frameborder="0" scrolling="no" src="<%= ContentUrl%>"></iframe>
</asp:Content>
