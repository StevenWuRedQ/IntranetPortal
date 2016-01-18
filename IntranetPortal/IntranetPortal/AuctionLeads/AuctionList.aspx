<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="~/Content.Master" CodeBehind="AuctionList.aspx.vb" Inherits="IntranetPortal.AuctionList" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContentPH" runat="server">
    <div class="container">
        <div class="row">
            <div class="col-md-6">
                <div class="list-group">
                    <a href="#/detail/{{n}}/test" class="list-group-item" ng-repeat=" n in [1,2,3,4,5,6]  track by $index">detail id {{n}}
                    </a>

                </div>
            </div>
            <div class="col-md-6">
                <div ng-view></div>
            </div>
        </div>


    </div>
    <script>

        angular.module('PortalApp').controller('AuctionCtrl', ['$scope', '$http','$routeParams',
        function ($scope, $http,$routeParams) {

            $scope.Id = $routeParams.Id;
            $scope.Name = $routeParams.Name;
            $scope.orderProp = 'age';
        }]);
      
        portalApp.config(['$routeProvider',
          function ($routeProvider) {
              $routeProvider.
                when('/detail/:Id/:Name', {
                    templateUrl: 'partials/auction-detail.tmpl.html',
                    controller: 'AuctionCtrl'
                }).
                otherwise({
                    redirectTo: '/'
                });
          }]);


    </script>
</asp:Content>
