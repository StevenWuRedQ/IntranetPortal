<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="~/Content.Master" CodeBehind="CaseParties.aspx.vb" Inherits="IntranetPortal.CaseParties" %>

<%@ Register Src="~/ShortSale/GeneralParties.ascx" TagPrefix="uc1" TagName="GeneralParties" %>


<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">   
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContentPH" runat="server">
    <div id="dataPanelDiv" style="padding:10px">
        <div id="ShortSaleCtrl" ng-controller="ShortSaleCtrl">
            <uc1:GeneralParties runat="server" ID="GeneralParties" />
        </div>
    </div>
    <script>

        $(document).ready(function () {

            var $scope = angular.element(document.getElementById('ShortSaleCtrl')).scope();

            $scope.BindPartiesData = function (bble) {
                if (!bble || bble == "")
                    return;

                $scope.ptCom.startLoading();
                var done1, done2;
                $.getJSON("/api/CaseParties/?bble=" + bble).done(function (data) {
                    $scope.SsCase = data.ShortSale;
                    $scope.LegalCase = data.Legal;

                    $scope.ptCom.stopLoading();
                });
            }

            $scope.BindPartiesData("<%= Request.QueryString("BBLE") %>");
        });
    </script>


</asp:Content>
