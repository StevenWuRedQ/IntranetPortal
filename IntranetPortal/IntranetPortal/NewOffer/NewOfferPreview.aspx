<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="~/Content.Master" CodeBehind="NewOfferPreview.aspx.vb" Inherits="IntranetPortal.NewOfferPreview" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContentPH" runat="server">
    <script type="text/javascript">

        var BBLE = '4127030033';
        angularApp = window.angular;
        angularApp.module('PortalApp')
                 .controller('NewOfferPreviewController', ['$scope', '$http', function ($scope, $http) {

                     me = this;
                     $http.get('/api/businessform/PropertyOffer/Tag/' + BBLE).success(function (data) {
                         if (data.FormData) {
                             me.BusinessForm = data;
                         }
                     });
                 }]);
    </script>

    <div ng-controller="NewOfferPreviewController as offer">
        <div class="container">
            <div style="text-align: center" ng-model="offer.BusinessForm.FormData">
                <h2>Property Address: {{PropertyAddress}}</h2>
            </div>
        </div>
    </div>

</asp:Content>
