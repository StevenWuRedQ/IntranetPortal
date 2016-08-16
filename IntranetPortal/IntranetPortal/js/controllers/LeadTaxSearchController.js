angular.module('PortalApp')
    .controller('LeadTaxSearchCtrl', function ($scope, $http, $element, $timeout,
        ptContactServices, ptCom, DocSearch, LeadsInfo
        , DocSearchEavesdropper
        ) {
        //New Model(this,arguments)
        $scope.ptContactServices = ptContactServices;
        leadsInfoBBLE = $('#BBLE').val();



        //$scope.DocSearch.LeadResearch = $scope.DocSearch.LeadResearch || {}
        // for new version this is not right will suggest use .net MVC redo the page
        $scope.DocSearch = {}

        /////////////////////////////////////////////////////////////////////
        // @date 8/11/2016
        // for devextrem angular bugs have to init array frist
        // fast prototype of grid bug on 8/11/2016 may spend two hours on it
        //var INITS = {
        //   OtherMortgage: [],
        //   DeedRecorded: [],
        //   COSRecorded: [],
        //   OtherLiens: [],
        //   TaxLienCertificate:[]
        //};
        //$scope.DocSearch.LeadResearch = {}
        //angular.extend($scope.DocSearch.LeadResearch, INITS);
        // ///////////////////////////////////////////////////////////////// 
        // put here should not right for fast prototype ////////////////////

        ////////// font end switch to new version //////////////
        $scope.endorseCheckDate = function (date) {
            var that = $scope.DocSearch;

            if (that.CreateDate > date) {
                return true;
            }
            return false;
        }

        $scope.endorseCheckVersion = function () {
            var that = $scope.DocSearch;
            if (that.Version) {
                return true;
            }
            return false;
        }

        $scope.GoToNewVersion = function (versions) {
            $scope.newVersion = versions;
        }


        /////////////////// 8/12/2016 //////////////////////////

        $scope.versionController = new DocSearchEavesdropper()
        $scope.versionController.setEavesdropper($scope, $scope.GoToNewVersion);
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

                ////////// font end switch to new version //////////////
                $scope.versionController.start2Eaves();
                /////////////////// 8/12/2016 //////////////////////////

                /////////////////////////////// saving and grid init bug for faster portotype ///////////////////
                //
                // use fast prototype it have same bug
                // this is faster solution of grid init will remove to initGrid
                // put here should not right that not right it should like this 
                // scope.DocSearch.LeadResearch.OtherMortgage = scope.DocSearch.LeadResearch.OtherMortgage || [] 
                // and put it to model inside;
                // angular.extend($scope.DocSearch.LeadResearch, INITS);
                //
                /////////////////////////////// end saving and grid init bug for faster portotype ////////////////


            });
            // ////remove all code to model version date is some time of June 2016 /////////////////////////////////////////////
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
            // ////////////////////////////////// remove all code to model version date is some time of June 2016 ////////////////////
        }

        $scope.init(leadsInfoBBLE)

        $scope.newVersionValidate = function () {
            if (!$scope.newVersion) {
                return true;
            }
            var validateFields = [
                "Has_Deed_Purchase_Deed",
                "Has_c_1st_Mortgage_c_1st_Mortgage",
                "fha",
                "Has_c_2nd_Mortgage_c_2nd_Mortgage",
                "has_Last_Assignment_Last_Assignment",
                "fannie",
                "Freddie_Mac_",
                "Has_Due_Property_Taxes_Due",
                "Has_Due_Water_Charges_Due",
                "Has_Open_ECB_Violoations",
                "Has_Open_DOB_Violoations",
                "hasCO",
                "Has_Violations_HPD_Violations",
                "Is_Open_HPD_Charges_Not_Paid_Transferred",
                "has_Judgments_Personal_Judgments",
                "has_Judgments_HPD_Judgments",
                "has_IRS_Tax_Lien_IRS_Tax_Lien",
                "hasNysTaxLien",
                "has_Sidewalk_Liens_Sidewalk_Liens",
                "has_Vacate_Order_Vacate_Order",
                "has_ECB_Tickets_ECB_Tickets",
                "has_ECB_on_Name_ECB_on_Name_other_known_address",
                //under are one to multiple//
                "Has_Other_Mortgage",
                "Has_Other_Liens",
                "Has_TaxLiensCertifcate",
                "Has_COS_Recorded",
                "Has_Deed_Recorded",
                ///////////////////////////

            ];

            var fields = $scope.DocSearch.LeadResearch
            if (fields)
            {
                for (var i = 0; i < validateFields.length; i++) {
                    var f = validateFields[i];
                    if(fields[f] == undefined)
                    {
                        return false;
                    }
                }
            }
            
            return true;

        }



        $scope.SearchComplete = function (isSave) {

            var isValidated = fales;
            var errorMsg = '';


            if (!$scope.newVersionValidate())
            {
                AngularRoot.alert("The fields marked * must been filled please check them before submit!");
                return;
            }

            $scope.DocSearch.BBLE = $scope.DocSearch.BBLE.trim();
            if (isSave) {
                $scope.DocSearch.$update(null, function () {
                    AngularRoot.alert("Save successfully!");
                });
            } else {

                $scope.DocSearch.ResutContent = $("#searchReslut").html();
                $scope.DocSearch.$completed(null, function () {

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
