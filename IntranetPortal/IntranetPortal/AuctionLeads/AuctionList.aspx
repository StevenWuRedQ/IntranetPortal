<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="~/Content.Master" CodeBehind="AuctionList.aspx.vb" Inherits="IntranetPortal.AuctionList" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <script src="https://cdnjs.cloudflare.com/ajax/libs/moment.js/2.11.1/moment.js"></script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContentPH" runat="server">
    <div class="container">

        <h2>Auction Properties </h2>
        <div class="row">
            <div class="col-md-6" ng-controller="AuctionListCtrl">
                <div class="row">
                    <div class="col-md-5">
                        <div class="row">
                            <div class="col-md-6">
                                <h5>{{Filter}}</h5>
                            </div>
                            <div class="col-md-6">
                                <div class="dropdown">
                                    <a class="btn dropdown-toggle" id="filterDropdown" data-toggle="dropdown" aria-haspopup="true" aria-expanded="true">Switch filter
                                    </a>
                                    <ul class="dropdown-menu" aria-labelledby="filterDropdown">
                                        <li ng-click="LoadLeads(f.name)" ng-repeat="f in Filters"><a>{{f.name}} </a></li>
                                    </ul>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-7">
                        <div class="input-group" style="padding-top: 3px;">
                            <input type="text" class="form-control" ng-model="auctionFilter" placeholder="Search by BBLE,Address,ZipCode,Auction Date ..." aria-describedby="basic-addon2">
                            <span class="input-group-addon" id="basic-addon2"><i class="fa fa-search"></i></span>
                        </div>
                    </div>
                </div>

                <div class="wx_scorll_list" data-bottom="90" style="margin-top: 10px">
                    <div class="list-group">
                        <a href="#/detail/{{au.AuctionId}}" class="list-group-item" ng-repeat=" au in AuctionList |filter:auctionFilter as results"><span class="badge">{{au.AuctionDate |date:'MM/dd/yyyy'}} </span>{{au.Address}}
                        </a>
                        <a class="list-group-item" ng-if="results.length == 0"><strong>No results found...</strong>
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
        portalApp.factory("AgentsData", ['$q', '$http', function ($q, $http) {
            var deferred = $q.defer();

            $http.get('/api/Leads/ManagedAgents')
            .then(function (response) {
                // promise is fulfilled
                deferred.resolve(response);
            });

            return deferred.promise;
        }]);

        angular.module('PortalApp').controller('AuctionCtrl', ['$scope', '$http', '$routeParams', 'AgentsData',
        function ($scope, $http, $routeParams, AgentsData) {

            $scope.Id = $routeParams.Id;
            AgentsData.then(function (response) {
                $scope.AgentsData = response.data;
            });

            if ($scope.Id) {
                $http.get('/api/AuctionProperties/' + $scope.Id).success(function (data) {
                    $scope.auction = data;
                }).error(function () { alert('Get auction propertiy list error! scope id:' + $scope.Id) });
            };
            $scope.AssginAuctionLeads = function (auction) {
                $http.post('/api/Leads/Assign/' + auction.BBLE, JSON.stringify(auction.AgentAssignedChoise)).success(function (response) {
                    auction.EmployeeName = auction.AgentAssignedChoise;
                    alert('Assign to ' + auction.EmployeeName + ' Succeed !');
                });

            }

            $scope.SaveAuction = function (auction) {
                $http.put('/api/AuctionProperties/' + auction.AuctionId, auction).success(function (response) {
                    alert('Save auction ' + auction.Address + ' Succeed !');
                });
            }
        }]);

        angular.module('PortalApp').controller('AuctionListCtrl', ['$scope', '$http',
        function ($scope, $http) {

            $scope.AuctionList = demoList;
            $scope.Filters = [
                { name: 'All Auctions', listUrl: '/api/AuctionProperties/?showAll=true' },
                { name: 'Open Auctions', listUrl: '/api/AuctionProperties' },
                { name: 'Unassigned Auctions', listUrl: '/api/AuctionProperties/?unassigned=true' },
            ];

            $scope.LoadLeads = function (filter) {
                $scope.Filter = filter;
                var f = _.find($scope.Filters, { name: filter });
                if (f != null) {
                    $http.get(f.listUrl).success(function (data) {

                        $scope.AuctionList = _.map(data, function (a) { a.AuctionDate = moment(a.AuctionDate).format('MM/DD/YYYY'); return a; });
                        //$scope.AuctionList = data;
                    }).error(function () { alert('Get auction properties list error!') });
                }

            }
            $scope.LoadLeads($scope.Filters[1].name);

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
    <script type="text/javascript" src="/js/PortalHttpFactory.js"></script>
</asp:Content>
