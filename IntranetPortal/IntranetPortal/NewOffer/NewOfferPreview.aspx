<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="~/Content.Master" CodeBehind="NewOfferPreview.aspx.vb" Inherits="IntranetPortal.NewOfferPreview" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContentPH" runat="server">
    <script type="text/ng-template" id="/templates/short-sale-seller.html">
        {{owner.FirstName}}
    </script>

    <script type="text/javascript">
        function NewOfferBusinessForm() {

        }

        NewOfferBusinessForm.prototype.init = function () {
            //Init property over there
            //this.xxx
        }
      
        //def function here
        //NewOfferBusinessForm.prototype.func =

        var BBLE = '4127030033';


        var angularApp = angular.module('PortalApp')
                 .controller('NewOfferPreviewController', ['$scope', '$http', function ($scope, $http) {

                     me = this;
                     $http.get('/api/businessform/PropertyOffer/Tag/' + BBLE).success(function (data) {
                         if (data.FormData) {
                             me.BusinessForm = data;
                         }
                     });
                     me.Eidt = true;
                 }])
        angularApp.directive("offerBusinessForm", function () {

            return {
                restrict: 'E',
                scope: {
                    formData: '=',
                },
                templateUrl: '/NewOffer/Templates/offer-business-form.html',
            }
        });
        ///templates/short-sale-seller.html
        angularApp.directive("ptSeller", function () {
            return {
                restrict: 'E',
                scope: {
                    owner: '=',
                },
                templateUrl: '/templates/short-sale-seller.html'
            }
        });
    </script>

    <div ng-controller="NewOfferPreviewController as offer">
        <div class="container">
            <offer-business-form form-data="offer.BusinessForm.FormData" ></offer-business-form>

        </div>
        
    </div>

</asp:Content>
