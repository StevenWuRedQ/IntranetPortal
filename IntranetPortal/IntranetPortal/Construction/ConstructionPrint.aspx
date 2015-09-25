<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="ConstructionPrint.aspx.vb" Inherits="IntranetPortal.ConstructionPrint" MasterPageFile="~/Content.Master" %>

<%@ Register Src="~/Construction/ConstructionUICtrl.ascx" TagPrefix="uc1" TagName="ConstructionUICtrl" %>


<asp:Content runat="server" ContentPlaceHolderID="head"></asp:Content>
<asp:Content runat="server" ContentPlaceHolderID="MainContentPH">
    <uc1:ConstructionUICtrl runat="server" ID="ConstructionUICtrl" />
    <script>
        $(function () {
            $(".legal-menu").remove();
            $("#ConstructionTab .tab-pane").addClass("active");
            $("#constructionTabContent").removeAttr("style");
            var scope = angular.element('#ConstructionCtrl').scope();
            scope.init("<%= BBLE %>", function () {
            window.print();
            window.onfocus = function () { window.close(); }
        });
    });
    </script>
</asp:Content>
