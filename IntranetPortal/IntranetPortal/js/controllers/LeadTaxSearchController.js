angular.module('PortalApp')
    .controller('LeadTaxSearchCtrl', function ($scope, $http, $element, $timeout, ptContactServices, ptCom, DocSearch, LeadsInfo) {
        //New Model(this,arguments)
        $scope.ptContactServices = ptContactServices;
        leadsInfoBBLE = $('#BBLE').val();

        //$scope.DocSearch.LeadResearch = $scope.DocSearch.LeadResearch || {}
        // for new version this is not right will suggest use .net MVC redo the page
        $scope.DocSearch = {}
       
        
        var INITS = {
            OtherMortgage: [],
            DeedRecorded: [],
            COSRecorded: [],
            OtherLiens: [],
            TaxLienCertificate:[]
        };
        $scope.DocSearch.LeadResearch = {}
        angular.extend($scope.DocSearch.LeadResearch, INITS);
        // 
        // put here should not right
        $scope.init = function (bble) {

            leadsInfoBBLE = bble || $('#BBLE').val();
            if (!leadsInfoBBLE) {
                console.log("Can not load page without BBLE !")
                return;
            }

            $scope.DocSearch = DocSearch.get({ BBLE: leadsInfoBBLE.trim() }, function () {
                $scope.LeadsInfo = LeadsInfo.get({ BBLE: leadsInfoBBLE.trim() });
                $scope.DocSearch.initLeadsResearch();
                $scope.DocSearch.initTeam();
                // put here should not right that not right it should like this 
                // scope.DocSearch.LeadResearch.OtherMortgage = scope.DocSearch.LeadResearch.OtherMortgage || [] 
                // and put it to model inside;
                angular.extend($scope.DocSearch.LeadResearch, INITS);
                
                ///////
            });

            //$scope.DocSearch;
            // $http.get("/api/LeadInfoDocumentSearches/" + leadsInfoBBLE).
            // success(function (data, status, headers, config) {
            //     $scope.DocSearch = data;
            //     $http.get('/Services/TeamService.svc/GetTeam?userName=' + $scope.DocSearch.CreateBy).success(function (data) {
            //         $scope.DocSearch.team = data;

            //     });

            //     $http.get("/ShortSale/ShortSaleServices.svc/GetLeadsInfo?bble=" + leadsInfoBBLE).
            //       success(function (data1, status, headers, config) {
            //           $scope.LeadsInfo = data1;
            //           $scope.DocSearch.LeadResearch = $scope.DocSearch.LeadResearch || {};
            //           $scope.DocSearch.LeadResearch.ownerName = $scope.DocSearch.LeadResearch.ownerName || data1.Owner;
            //           $scope.DocSearch.LeadResearch.waterCharges = $scope.DocSearch.LeadResearch.waterCharges || data1.WaterAmt;
            //           $scope.DocSearch.LeadResearch.propertyTaxes = $scope.DocSearch.LeadResearch.propertyTaxes || data1.TaxesAmt;
            //           $scope.DocSearch.LeadResearch.mortgageAmount = $scope.DocSearch.LeadResearch.mortgageAmount || data1.C1stMotgrAmt;
            //           $scope.DocSearch.LeadResearch.secondMortgageAmount = $scope.DocSearch.LeadResearch.secondMortgageAmount || data1.C2ndMotgrAmt;
            //           var ownerName = $scope.DocSearch.LeadResearch.ownerName;
            //           if (ownerName) {
            //               $http.post("/api/homeowner/ssn/" + leadsInfoBBLE, JSON.stringify(ownerName)).
            //               success(function (ssn, status, headers, config) {
            //                   $scope.DocSearch.LeadResearch.ownerSSN = ssn;
            //               }).error(function () {

            //               });
            //           }


            //       }).error(function (data, status, headers, config) {
            //           alert("Get Leads Info failed BBLE = " + leadsInfoBBLE + " error : " + JSON.stringify(data));
            //       });
            // });
        }

        $scope.init(leadsInfoBBLE)

        $scope.SearchComplete = function (isSave) {

            $scope.DocSearch.BBLE = $scope.DocSearch.BBLE.trim();
            if (isSave) {
                $scope.DocSearch.$update(null,function () {
                    AngularRoot.alert("Save successfully!");
                });
            } else {

                $scope.DocSearch.ResutContent = $("#searchReslut").html();
                $scope.DocSearch.$completed(null,function () {
                
                    AngularRoot.alert("Document completed!")
                    gridCase.Refresh();
                });
            }


            //$http.put('/api/LeadInfoDocumentSearches/' + $scope.DocSearch.BBLE, JSON.stringify(PostData)).success(function () {
            //    alert(isSave ? 'Save success!' : 'Lead info search completed !');
            //    if (typeof gridCase != 'undefined') {
            //        if (!isSave) {
            //            $scope.DocSearch.Status = 1;
            //            gridCase.Refresh();
            //        }
            //    }
            //}).error(function (data) {
            //    alert('Some error Occurred url api/LeadInfoDocumentSearches ! Detail: ' + JSON.stringify(data));
            //});

            //Ajax anonymous function not work for angular scope need check about this.
            //$.ajax({
            //    type: "PUT",
            //    url: '/api/LeadInfoDocumentSearches/' + $scope.DocSearch.BBLE,
            //    data: JSON.stringify(PostData),
            //    dataType: 'json',
            //    contentType: 'application/json',
            //    success: function (data) {

            //        alert(isSave ? 'Save success!' : 'Lead info search completed !');
            //        if (typeof gridCase != 'undefined') {
            //            if (!isSave) {
            //                $scope.DocSearch.Status = 1;
            //                gridCase.Refresh();
            //            }

            //        }
            //    },
            //    error: function (data) {
            //        alert('Some error Occurred url api/LeadInfoDocumentSearches ! Detail: ' + JSON.stringify(data));
            //    }

            //});
        }
    });
