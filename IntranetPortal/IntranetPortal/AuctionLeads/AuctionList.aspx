<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="~/Content.Master" CodeBehind="AuctionList.aspx.vb" Inherits="IntranetPortal.AuctionList" %>

<%@ Register Src="~/AuctionLeads/AuctionListCtrl.ascx" TagPrefix="uc1" TagName="AuctionListCtrl" %>
<%@ Register Src="~/AuctionLeads/VacantListCtrl.ascx" TagPrefix="uc1" TagName="VacantListCtrl" %>



<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <script src="https://cdnjs.cloudflare.com/ajax/libs/moment.js/2.11.1/moment.js"></script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContentPH" runat="server">
    <div class="container">

        <h2><%=ControlType %>  </h2>
        <div class="row">
            <uc1:AuctionListCtrl runat="server" ID="AuctionListCtrl" Visible="false" />
            <uc1:VacantListCtrl runat="server" ID="VacantListCtrl" Visible="false" />
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
        /**********Auction detail controller ****************************/
        angular.module('PortalApp').controller('AuctionCtrl', ['$scope', '$http', '$routeParams', 'AgentsData',
        function ($scope, $http, $routeParams, AgentsData) {

            $scope.Id = $routeParams.Id;
            AgentsData.then(function (response) {
                $scope.AgentsData = response.data;
            });

            if ($scope.Id) {
                $http.get('/api/AuctionProperties/' + $scope.Id).success(function (data) {
                    $scope.auction = data;
                });
            };
            $scope.AssginAuctionLeads = function (auction) {
                $http.post('/api/Leads/Assign/' + auction.BBLE, JSON.stringify(auction.AgentAssignedChoise)).success(function (response) {
                    auction.EmployeeName = auction.AgentAssignedChoise;
                    AngularRoot.alert('Assign to ' + auction.EmployeeName + ' Succeed !')

                });

            }

            $scope.SaveAuction = function (auction) {
                $http.put('/api/AuctionProperties/' + auction.AuctionId, auction).success(function (response) {
                    AngularRoot.alert('Save auction ' + auction.Address + ' Succeed !');
                });
            }
        }]);

        /**********Auction List controller ****************************/
        angular.module('PortalApp').controller('AuctionListCtrl', ['$scope', '$http',
        function ($scope, $http) {

            //$scope.AuctionList = demoList;
            $scope.Filters = [
                { name: 'All Auctions', listUrl: '/api/AuctionProperties/?showAll=true&unassigned=false' },
                { name: 'Open Auctions', listUrl: '/api/AuctionProperties' },
                { name: 'Unassigned Auctions', listUrl: '/api/AuctionProperties/?unassigned=true&showAll=false' },
            ];
            $scope.MergeRirgt = function (obj, src) {
                var comp = function (o, s) {
                    return o.AuctionId == s.AuctionId
                }
                //var diff = _.differenceWith(obj, src,comp);

                var diffObj = _.filter(obj, function (o) { return _.find(src, { 'AuctionId': o.AuctionId }) == null });
                var diffSrc = _.filter(src, function (o) { return _.find(obj, { 'AuctionId': o.AuctionId }) == null });
                //remove the diffent in object
                _.remove(obj, function (o) { return _.find(diffObj, { 'AuctionId': o.AuctionId }) != null })
                _.each(diffSrc, function (o) { obj.push(o) });
            }
            $scope.LoadLeads = function (filter) {
                $scope.Filter = filter;
                var f = _.find($scope.Filters, { name: filter });
                if (f != null) {
                    $http.get(f.listUrl).success(function (data) {

                        var src = _.map(data, function (a) { a.AuctionDate = moment(a.AuctionDate).format('MM/DD/YYYY'); return a; });
                        //if ($scope.AuctionList)
                        //    $scope.MergeRirgt($scope.AuctionList,src);
                        //else
                        $scope.AuctionList = src;

                    });
                }

            }
            $scope.LoadLeads($scope.Filters[1].name);

        }]);
        /**********************end Auction list controller*************/

        /*****************VacantListCtrl ***************/
        var DemoVacatList = [{ "BBLE": 4090410021, "IsLisPendens": 1, "IsOtherLiens": "NULL", "IsTaxesOwed": "NULL", "IsWaterOwed": 1, "IsECBViolations": "NULL", "IsDOBViolations": "NULL", "C1stMotgrAmt": 125080.00, "C2ndMotgrAmt": "125080.00", "C3rdMortgrAmt": "NULL", "TaxesAmt": 0.00, "TaxesOrderStatus": "Task-Done", "TaxesOrderTime": "2015-06-02 18:56:37.323", "TaxesOrderDeliveryTime": "2015-06-02 18:59:43.457", "WaterAmt": 289.22, "WaterOrderStatus": "Task-Done", "WaterOrderTime": "2015-06-02 18:56:37.323", "WaterOrderDeliveryTime": "2015-06-02 19:03:06.990", "ECBViolationsAmt": 0, "ECBOrderStatus": "Task-Done", "ECBOrderTime": "2015-06-02 18:56:37.323", "ECBOrderDeliveryTime": "2015-06-02 18:56:37.203", "DOBViolationsAmt": 0, "DOBOrderStatus": "Task-Done", "DOBOrderTime": "NULL", "DOBOrderDeliveryTime": "2015-06-02 18:59:43.020", "AcrisOrderStatus": "Task-Done", "AcrisOrderTime": "2015-06-02 18:56:37.323", "AcrisOrderDeliveryTime": "2015-06-02 18:56:37.140", "LastPaid": "NULL", "IsCoOnFile": "NULL", "TypeOfCo": "NULL", "Owner": "PERALTA, LUIS", "CoOwner": "PERALTA, ROSA", "Date": "NULL", "PropertyAddress": "95-2 97 ST, OZONE PARK,NY 11416", "SaleDate": "NULL", "PropertyClass": "B2", "TaxClass": 1, "SaleType": "NULL", "Condition": "NULL", "Block": 9041, "Lot": 21, "DOBViolation": "NULL", "Remark1": "NULL", "Remark2": "NULL", "Remark3": "NULL", "Remark4": "NULL", "Deed": "NULL", "LPindex": "NULL", "YearBuilt": 1931, "NumFloors": 2, "BuildingDem": "20'x48'", "LotDem": "20.17'x80'", "EstValue": "NULL", "Number": "95-2", "StreetName": "97 ST", "NeighName": "OZONE PARK", "State": "NY", "ZipCode": 11416, "Borough": 4, "Zoning": "R5       ", "MaxFar": 1.25, "ActualFar": 1.19, "NYCSqft": 1920, "UnbuiltSqft": 96.25, "BuildingBBLE": "NULL", "UnitNum": "NULL", "Type": "NULL", "Latitude": 40.6875002017371, "Longitude": -73.8456654978255, "CreateDate": "2015-06-02 18:48:32.837", "CreateBy": "Dataloop", "LastUpdate": "2015-06-02 19:03:07.967", "UpdateBy": "Data Services" },
                                { "BBLE": 3075710076, "IsLisPendens": 1, "IsOtherLiens": "NULL", "IsTaxesOwed": "1", "IsWaterOwed": 1, "IsECBViolations": "NULL", "IsDOBViolations": "NULL", "C1stMotgrAmt": 265000.00, "C2ndMotgrAmt": "NULL", "C3rdMortgrAmt": "NULL", "TaxesAmt": 1039.91, "TaxesOrderStatus": "Task-Done", "TaxesOrderTime": "2016-01-07 11:48:30.487", "TaxesOrderDeliveryTime": "2016-01-07 11:50:10.310", "WaterAmt": 580.91, "WaterOrderStatus": "Task-Done", "WaterOrderTime": "2016-01-07 11:48:30.487", "WaterOrderDeliveryTime": "2016-01-07 11:50:18.797", "ECBViolationsAmt": 0, "ECBOrderStatus": "Task-Done", "ECBOrderTime": "2016-01-07 11:48:30.487", "ECBOrderDeliveryTime": "2016-01-07 11:48:29.767", "DOBViolationsAmt": 0, "DOBOrderStatus": "Task-Done", "DOBOrderTime": "NULL", "DOBOrderDeliveryTime": "2016-01-07 11:50:05.707", "AcrisOrderStatus": "Task-Done", "AcrisOrderTime": "2016-01-11 11:44:22.660", "AcrisOrderDeliveryTime": "2016-01-11 11:44:24.637", "LastPaid": "NULL", "IsCoOnFile": "NULL", "TypeOfCo": "NULL", "Owner": "BRONSTEIN, CHAIM", "CoOwner": "BRONSTEIN, ZIPORAH", "Date": "NULL", "PropertyAddress": "872 E 26 ST, Brooklyn,NY 11210", "SaleDate": "NULL", "PropertyClass": "A9", "TaxClass": 1, "SaleType": "NULL", "Condition": "NULL", "Block": 7571, "Lot": 76, "DOBViolation": "NULL", "Remark1": "NULL", "Remark2": "NULL", "Remark3": "NULL", "Remark4": "NULL", "Deed": "NULL", "LPindex": "NULL", "YearBuilt": 1915, "NumFloors": 2, "BuildingDem": "16'x32'", "LotDem": "21.67'x100'", "EstValue": "NULL", "Number": "872", "StreetName": "E 26 ST", "NeighName": "MIDWOOD", "State": "NY", "ZipCode": 11210, "Borough": 3, "Zoning": "R4       ", "MaxFar": 0.9, "ActualFar": 0.53, "NYCSqft": 1152, "UnbuiltSqft": 798.3, "BuildingBBLE": "NULL", "UnitNum": "NULL", "Type": "NULL", "Latitude": 40.6293986446432, "Longitude": -73.9515157111409, "CreateDate": "2015-12-02 12:52:23.343", "CreateBy": "Dataloop", "LastUpdate": "2016-01-11 11:44:25.027", "UpdateBy": "Data Services" }];

        angular.module('PortalApp').controller('VacantListCtrl', ['$scope', '$http',
          function ($scope, $http) {
              $http.get('/api/Leads/VacantLeads').then(function (data) {
                  $scope.List = data.data;
              });


          }]);
        /*****************End VacantListCtrl ***************/

        /*****************VacantCtrl ***************/
        angular.module('PortalApp').controller('VacantCtrl', ['$scope', '$http', '$routeParams', 'AgentsData',
          function ($scope, $http, $routeParams, AgentsData) {
              $scope.BBLE = $routeParams.Id;
              AgentsData.then(function (response) {
                  $scope.AgentsData = response.data;
              });
              if ($scope.BBLE) {
                  $http.get('/api/Leads/LeadsInfo/' + $scope.BBLE).then(function (data) {
                      $scope.SelectItem = data.data;
                  });
              }
              //$scope.SelectItem = _.find(DemoVacatList, function(e){ return e.BBLE== $routeParams.Id });
              $scope.AssginAuctionLeads = function (vacant) {
                  $http.post('/api/Leads/Assign/' + vacant.BBLE, JSON.stringify(vacant.AgentAssignedChoise)).success(function (response) {
                      vacant.EmployeeName = vacant.AgentAssignedChoise;
                      AngularRoot.alert('Assign to ' + vacant.EmployeeName + ' Succeed !')

                  });

              }
          }]);
        /*****************End VacantListCtrl ***************/

        /*************router map config *******************/
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
                    when('/vacant/:Id', {
                        templateUrl: 'partials/vacant-detail.tmpl.html',
                        controller: 'VacantCtrl'
                    }).
                   otherwise({
                       redirectTo: '/'
                   });
             }]);
        /************end router map config *******************/
        portalApp.config(['$httpProvider', function ($httpProvider) {
            $httpProvider.interceptors.push('PortalHttpInterceptor');
        }]);

    </script>

</asp:Content>
