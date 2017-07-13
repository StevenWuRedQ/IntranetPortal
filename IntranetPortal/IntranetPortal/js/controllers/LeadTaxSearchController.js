/**
 * @author Steven Wu
 * @date 9/15/2016
 * @fix git committed bde6b6d
 * add tax search js cotroller
 * LeadTaxSearchController is doc search. 
 * naming wrong becuase the name always change from spec guys.
 */
angular.module('PortalApp')
    .controller('LeadTaxSearchCtrl', function ($scope, $http, $element, $timeout, ptContactServices, ptCom, DocSearch, LeadsInfo, DocSearchEavesdropper, DivError, $location) {
        //New Model(this,arguments)
        leadsInfoBBLE = $('#BBLE').val();
        $scope.ShowInfo = $('#ShowInfo').val();
        $scope.ptContactServices = ptContactServices;

        $scope.DivError = new DivError('DocSearchErrorDiv');

        //$scope.DocSearch.LeadResearch = $scope.DocSearch.LeadResearch || {}
        // for new version this is not right will suggest use .net MVC redo the page
        $scope.DocSearch = {}

        ////////// font end switch to new version //////////////
        $scope.endorseCheckDate = function (date) {
            // form chris ask delpoy 8/16/2016
            return false;
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

        $scope.multipleValidated = function (base, boolKey, arraykey) {
            var boolVal = base[boolKey];
            var arrayVal = base[arraykey];
            /**
             * bugs over here bool value can not check with null
             * @see Jira #PORTAL-378 https://myidealprop.atlassian.net/browse/PORTAL-378
             */
            var hasWarning = (boolVal === null) || (boolVal && arrayVal == false);
            return hasWarning;
        }
        $scope.init = function (bble) {

            leadsInfoBBLE = bble || $('#BBLE').val();
            $scope.ShowInfo = $('#ShowInfo').val();
            if (!leadsInfoBBLE) {
                console.log("Can not load page without BBLE !")
                return;
            }

            $scope.DocSearch = DocSearch.get({ BBLE: leadsInfoBBLE.trim() }, function () {
                $scope.LeadsInfo = LeadsInfo.get({ BBLE: leadsInfoBBLE.trim() }, function () {
                     
                    $scope.DocSearch.initLeadsResearch();
                    $scope.DocSearch.initTeam();
                    ////////// font end switch to new version //////////////
                    $scope.versionController.start2Eaves();
                });

            });

        }

        $scope.init(leadsInfoBBLE)

        /**
         * @author  Steven
         * @date    8/19/2016
         * @fix
         *  git commit f679a81 'finish the new doc search page'
         *  add javascript version of validate in new version of doc search
         *  it's not right to add the goal in git commit should create jira task.
         */

        /**
         * @author  Steven
         * @date    8/19/2016
         *  
         * @description
         *  new version validate javascript version validate
         * @returns {bool} true then pass validate
         */
        $scope.newVersionValidate = function () {
            /**
             * change java script version validate 
             * to oop model version validate
             */
            if (!$scope.newVersion) {
                return true;
            }

            if (!$scope.DivError.passValidate()) {
                return false;
            }

            return true;
            ////////////under are old validate///////////////////
            //var errormsg = '';
            //var validateFields = [
            //    "Has_Deed_Purchase_Deed",
            //    "Has_c_1st_Mortgage_c_1st_Mortgage",
            //    "fha",
            //    "Has_c_2nd_Mortgage_c_2nd_Mortgage",
            //    "has_Last_Assignment_Last_Assignment",
            //    "fannie",
            //    "Freddie_Mac_",
            //    "Has_Due_Property_Taxes_Due",
            //    "Has_Due_Water_Charges_Due",
            //    "Has_Open_ECB_Violoations",
            //    "Has_Open_DOB_Violoations",
            //    "hasCO",
            //    "Has_Violations_HPD_Violations",
            //    "Is_Open_HPD_Charges_Not_Paid_Transferred",
            //    "has_Judgments_Personal_Judgments",
            //    "has_Judgments_HPD_Judgments",
            //    "has_IRS_Tax_Lien_IRS_Tax_Lien",
            //    "hasNysTaxLien",
            //    "has_Sidewalk_Liens_Sidewalk_Liens",
            //    "has_Vacate_Order_Vacate_Order",
            //    "has_ECB_Tickets_ECB_Tickets",
            //    "has_ECB_on_Name_ECB_on_Name_other_known_address",

            //    /**
            //     * @author Steven
            //     * @date   8/19/2016
            //     * 
            //     * @fix 
            //     * git commit bde6b6d tax search
            //     * add validated to new version doc search at least one item add 
            //     * when select yes control grid
            //     */
            //    // under are one to multiple//
            //    "Has_Other_Mortgage",
            //    "Has_Other_Liens",
            //    "Has_TaxLiensCertifcate",
            //    "Has_COS_Recorded",
            //    "Has_Deed_Recorded",
            //    ///////////////////////////

            //];
            //var checkedAttrs = [["Has_Other_Mortgage", "OtherMortgage"],
            //                    ["Has_Other_Liens", "OtherLiens"],
            //                    ["Has_TaxLiensCertifcate", "TaxLienCertificate"],
            //                    ["Has_COS_Recorded", "COSRecorded"],
            //                    ["Has_Deed_Recorded", "DeedRecorded"]];

            //var fields = $scope.DocSearch.LeadResearch;
            //if (fields) {
            //    for (var i = 0; i < validateFields.length; i++) {
            //        var f = validateFields[i];
            //        if (fields[f] === undefined) {
            //            errormsg += "The fields marked * must been filled please check them before submit!<br>";
            //            break;
            //        }
            //    }

            //    for (var j = 0; j < checkedAttrs.length; j++) {
            //        var f1 = checkedAttrs[j];
            //        if ((fields[f1[0]] === true && !Array.isArray(fields[f1[1]])) || (fields[f1[0]] === true && fields[f1[1]].length === 0)) {
            //            errormsg = errormsg + f1[1] + " has checked but have no value.<br>";
            //        }
            //    }
            //}

            //return errormsg;

        }

        $scope.SearchComplete = function (isSave) {
            // only completed need check validate
            // when saving don't need validate input.
            if (!isSave) {
                if (!$scope.newVersionValidate()) {
                    var msg = $scope.DivError.getMessage();

                    AngularRoot.alert(msg[0]);
                    return;
                };
            }


            $scope.DocSearch.BBLE = $scope.DocSearch.BBLE.trim();
            $scope.DocSearch.ResultContent = $("#search_summary_div").html();

            if (isSave) {
                $scope.DocSearch.$update(null, function () {
                    AngularRoot.alert("Save successfully!");
                });
            } else {
                $scope.DocSearch.$completed(null, function () {

                    AngularRoot.alert("Document completed!")
                    gridCase.Refresh();
                });
            }

            $scope.test = function () {
                $scope.$digest();
            }

        }


        // only one of fha, fannie, freddie_mac can be yes at the same time

        $scope.$watch('DocSearch.LeadResearch.fha', function (nv, ov) {
            if (nv == true) {
                if ($scope.DocSearch.LeadResearch.fannie) $scope.DocSearch.LeadResearch.fannie = false;
                if ($scope.DocSearch.LeadResearch.Freddie_Mac_) $scope.DocSearch.LeadResearch.Freddie_Mac_ = false;
            }
        })
        $scope.$watch('DocSearch.LeadResearch.fannie', function (nv, ov) {
            if (nv == true) {
                if ($scope.DocSearch.LeadResearch.fha) $scope.DocSearch.LeadResearch.fha = false;
                if ($scope.DocSearch.LeadResearch.Freddie_Mac_) $scope.DocSearch.LeadResearch.Freddie_Mac_ = false;
            }
        })

        $scope.$watch('DocSearch.LeadResearch.Freddie_Mac_', function (nv, ov) {
            if (nv == true) {
                if ($scope.DocSearch.LeadResearch.fannie) $scope.DocSearch.LeadResearch.fannie = false;
                if ($scope.DocSearch.LeadResearch.fha) $scope.DocSearch.LeadResearch.fha = false;
            }
        })

        $scope.markCompleted = function (status, msg) {

            // because the underwriting completion is not reversible, comfirm it before save to db.
            msg = 'Please provide Note or press no to cancel';
            ptCom.prompt(msg, function (result) {
                //debugger;
                if (result != null) {
                    //debugger;
                    $scope.DocSearch.markCompleted($scope.DocSearch.BBLE, status, result).then(function succ(d) {
                        //debugger;
                        $scope.DocSearch.UnderwriteStatus = d.data.UnderwriteStatus;
                        $scope.DocSearch.UnderwriteCompletedBy = d.data.UnderwriteCompletedBy;
                        $scope.DocSearch.UnderwriteCompletedOn = d.data.UnderwriteCompletedOn;
                        $scope.DocSearch.UnderwriteCompletedNotes = d.data.UnderwriteCompletedNotes;
                    }, function err() {
                        console.log("fail to update docsearch");
                    });
                }
                
            }, true);

        }

        try {
            var modePatten = /mode=\d/;
            var matches = modePatten.exec(location.search);
            //debugger;
            if (matches && matches[0]) {
                $scope.viewmode = parseInt(matches[0].split('=')[1]);
            } else {
                $scope.viewmode = 0;
            }
        } catch (ex) {
            $scope.viewmode = 0;
        }
    });