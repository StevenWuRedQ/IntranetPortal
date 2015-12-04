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
            width: 100%;
            height: 950px;
            margin: 0;
            border: none;
        }
    </style>
    <script>
        function resizeIframe(obj) {
            obj.style.height = obj.contentWindow.document.body.scrollHeight + 'px';
        }
    </script>
    <uc1:NavMenu runat="server" ID="NavMenu" />
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="Content" runat="server">
    <iframe id="contentUrlPane" name="contentUrlPane" height="100%" frameborder="0" scrolling="no" src="<%= ContentUrl%>" onload="resizeIframe(this);"></iframe>
</asp:Content>
