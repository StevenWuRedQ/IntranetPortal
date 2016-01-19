<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="~/Content.Master" CodeBehind="AuctionList.aspx.vb" Inherits="IntranetPortal.AuctionList" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContentPH" runat="server">
    <div class="container" style="padding-top: 30px;">

        <div class="row">
            <div class="col-md-6" ng-controller="AuctionListCtrl">
                <div class="input-group" style="padding-top: 23px;">
                    <input type="text" class="form-control" ng-model="auctionFilter" placeholder="Search..." aria-describedby="basic-addon2">
                    <span class="input-group-addon" id="basic-addon2"><i class="fa fa-search"></i></span>
                </div>
                <div class="wx_scorll_list" data-bottom="50">
                    <div class="list-group">
                        <a href="#/detail/{{au.AuctionId}}/test" class="list-group-item" ng-repeat=" au in AuctionList |filter:auctionFilter"><span class="badge">{{au.AuctionDate |date:'MM/dd/yyyy'}} </span>{{au.Address}}
                        </a>
                    </div>
                </div>

            </div>
            <div class="col-md-6">
                <div ng-view></div>
            </div>
        </div>


    </div>
    <script>
        var demoList = [{ "AuctionId": 1, "BBLE": 1000251493, "BBL": "NULL", "Address": "15 William Street #18B, New York, NY 10005", "Zipcode": 10005, "Neighborhood": "Financial District", "BuildingClass": "RM", "AuctionDate": "2012-04-23T18:25:43.511", "DateEntered": "2015-12-24 00:00:00.000", "Lien": 994335.00, "Judgment": "2015-11-05 00:00:00.000", "Plaintiff": "Pennymac Corp., Et.Al.", "Defendant": "Miguel Ortiz, Et.Al.", "IndexNo": "Mn 2013 / 850172", "Referee": "Paul Sklar, Esq.", "AuctionLocation": "Room 130, 60 Centre Street, New York, NY 10007.", "PlaintiffAttorney": "Fein Such & Crane, LLP", "AttorneyPhone": "(585) 232-7400", "ForeclosureType": "Mortgage Foreclosure", "AgentAssigned": "NULL", "Grade": "NULL", "TaxWaterCombo": "NULL", "DOBViolation": "NULL", "PreviousAuctionDate": "NULL", "DeedRecorded": "NULL", "MaxAuctionBid": "NULL", "RenovatedValue": "NULL", "Points": "NULL", "LeadType": "NULL", "Description": "NULL", "CreateDate": "NULL", "CreateBy": "NULL" },
                                { "AuctionId": 2, "BBLE": 1010201201, "BBL": "NULL", "Address": "1600 Broadway #19G, New York, NY 10019", "Zipcode": 10019, "Neighborhood": "Theatre District - Times Square", "BuildingClass": "RM", "AuctionDate": "2016-04-23T14:15:00.00", "DateEntered": "2016-01-06 00:00:00.000", "Lien": 1242155.00, "Judgment": "2015-11-16 00:00:00.000", "Plaintiff": "U.S. Bank N.A., Et. Al.", "Defendant": "Ick K. Yoon, Et. Al.", "IndexNo": "Mn 2009 / 112402", "Referee": "Richard O. Tolchin, Esq.", "AuctionLocation": "New York County Courthouse, 60 Centre Street, New York, NY., Room 130", "PlaintiffAttorney": "SHAPIRO, DICARO & BARAK, LLC", "AttorneyPhone": "631-844-9611", "ForeclosureType": "Mortgage Foreclosure", "AgentAssigned": "NULL", "Grade": "NULL", "TaxWaterCombo": "NULL", "DOBViolation": "NULL", "PreviousAuctionDate": "NULL", "DeedRecorded": "NULL", "MaxAuctionBid": "NULL", "RenovatedValue": "NULL", "Points": "NULL", "LeadType": "NULL", "Description": "NULL", "CreateDate": "NULL", "CreateBy": "NULL" }];


        angular.module('PortalApp').controller('AuctionCtrl', ['$scope', '$http', '$routeParams',
        function ($scope, $http, $routeParams) {

            $scope.Id = $routeParams.Id;
            if ($scope.Id) {
                $http.get('/api/AuctionProperties/' + $scope.Id).success(function (data) {
                    $scope.auction = data;
                }).error(function () { alert('Get auction properties list error!') });

                // $scope.auction = _.findLast(demoList, { "AuctionId": parseInt($scope.Id) }) || {};
            };
        }]);

        angular.module('PortalApp').controller('AuctionListCtrl', ['$scope', '$http',
     function ($scope, $http) {

         $scope.AuctionList = demoList;
         $http.get('/api/AuctionProperties').success(function (data) {
             $scope.AuctionList = data;
         }).error(function () { alert('Get auction properties list error!') });

     }]);
        portalApp.config(['$routeProvider',
          function ($routeProvider) {
              $routeProvider.
                when('/detail/:Id/:Name', {
                    templateUrl: 'partials/auction-detail.tmpl.html',
                    controller: 'AuctionCtrl'
                }).
                when('/detail/:Id', {
                    templateUrl: 'partials/auction-detail.tmpl.html',
                    controller: 'AuctionCtrl'
                }).
                otherwise({
                    redirectTo: '/'
                });
          }]);



    </script>
</asp:Content>
