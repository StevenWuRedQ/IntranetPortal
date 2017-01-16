/**
 * @author Steven Wu
 * @date 9/15/2016
 * @fix git committed bde6b6d
 * add tax search js cotroller
 * LeadTaxSearchController is doc search. 
 * naming wrong becuase the name always change from spec guys.
 */
angular.module("PortalApp").controller("DocSearchController", [
        "$scope", "$http", "$element", "$timeout", "ptContactServices",
        "ptCom", "DocSearch", "LeadsInfo", "DocSearchEavesdropper", "DivError", 'ptUnderwriting',
        function ($scope, $http, $element, $timeout, ptContactServices,
         ptCom, DocSearch, LeadsInfo, DocSearchEavesdropper, DivError, ptUnderwriting) {

            var leadsInfoBBLE = $("#BBLE").val();
            $scope.ShowInfo = $("#ShowInfo").val();
            $scope.ptContactServices = ptContactServices;
            $scope.DivError = new DivError("DocSearchErrorDiv");

            //$scope.DocSearch.LeadResearch = $scope.DocSearch.LeadResearch || {}
            // for new version this is not right will suggest use .net MVC redo the page
            $scope.DocSearch = {};

            ////////// font end switch to new version //////////////
            $scope.endorseCheckDate = function (date) {
                return false;
            };
            $scope.endorseCheckVersion = function () {
                var that = $scope.DocSearch;
                if (that.Version) {
                    return true;
                }
                return false;
            };
            $scope.GoToNewVersion = function (versions) {
                $scope.newVersion = versions;
            };

            /////////////////// 8/12/2016 //////////////////////////

            $scope.versionController = new DocSearchEavesdropper();
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
            };

            $scope.init = function (bble) {
                var leadsInfoBBLE = bble || $("#BBLE").val();
                $scope.ShowInfo = $("#ShowInfo").val();
                if (!leadsInfoBBLE) {
                    console.log("Can not load page without BBLE !");
                    return;
                }
                $scope.DocSearch = DocSearch.get({ BBLE: leadsInfoBBLE.trim() },
                    function () {
                        $scope.LeadsInfo = LeadsInfo.get({ BBLE: leadsInfoBBLE.trim() },
                            function () {

                                $scope.DocSearch.initLeadsResearch();
                                $scope.DocSearch.initTeam();
                                ////////// font end switch to new version //////////////
                                $scope.versionController.start2Eaves();
                            });

                    });

            };
            $scope.init(leadsInfoBBLE);

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
            };

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
                $scope.DocSearch.ResutContent = $("#search_summary_div").html();

                if (isSave) {
                    $scope.DocSearch.$update(null, function () {
                        AngularRoot.alert("Save successfully!");
                    });
                } else {
                    $scope.DocSearch.$completed(null, function () {
                        ptUnderwriting.tryCreate($scope.DocSearch.BBLE.trim()).then(function () {
                            AngularRoot.alert("Document completed!");
                        }, function error(e) {
                            console.log(e);
                        });
                        // if (gridCase) gridCase.Refresh();
                    });
                }

            };

            // only one of fha, fannie, freddie_mac can be yes at the same time
            $scope.$watch("DocSearch.LeadResearch.fha",
                function (nv, ov) {
                    if (nv === true) {
                        if ($scope.DocSearch.LeadResearch.fannie) $scope.DocSearch.LeadResearch.fannie = false;
                        if ($scope.DocSearch.LeadResearch
                            .Freddie_Mac_) $scope.DocSearch.LeadResearch.Freddie_Mac_ = false;
                    }
                });
            $scope.$watch("DocSearch.LeadResearch.fannie",
                function (nv, ov) {
                    if (nv === true) {
                        if ($scope.DocSearch.LeadResearch.fha) $scope.DocSearch.LeadResearch.fha = false;
                        if ($scope.DocSearch.LeadResearch
                            .Freddie_Mac_) $scope.DocSearch.LeadResearch.Freddie_Mac_ = false;
                    }
                });
            $scope.$watch("DocSearch.LeadResearch.Freddie_Mac_",
                function (nv, ov) {
                    if (nv === true) {
                        if ($scope.DocSearch.LeadResearch.fannie) $scope.DocSearch.LeadResearch.fannie = false;
                        if ($scope.DocSearch.LeadResearch.fha) $scope.DocSearch.LeadResearch.fha = false;
                    }
                });

            $scope.markCompleted = function (status, msg) {
                // because the underwriting completion is not reversible, comfirm it before save to db.
                msg = msg || "Please provide note or press no to cancel";
                ptCom.prompt(msg,
                    function (result) {
                        //debugger;
                        if (result != null) {
                            //debugger;
                            $scope.DocSearch.markCompleted($scope.DocSearch.BBLE, status, result)
                                .then(function succ(d) {
                                    //debugger;
                                    $scope.DocSearch.UnderwriteStatus = d.data.UnderwriteStatus;
                                    $scope.DocSearch.UnderwriteCompletedBy = d.data.UnderwriteCompletedBy;
                                    $scope.DocSearch.UnderwriteCompletedOn = d.data.UnderwriteCompletedOn;
                                    $scope.DocSearch.UnderwriteCompletedNotes = d.data.UnderwriteCompletedNotes;
                                },
                                    function err() {
                                        console.log("fail to update docsearch");
                                    });
                        }
                    },
                    true);
            };
            try {
                var modePatten = /mode=\d/;
                var matches = modePatten.exec(location.search);
                //debugger;
                if (matches && matches[0]) {
                    $scope.viewmode = parseInt(matches[0].split("=")[1]);
                } else {
                    $scope.viewmode = 0;
                }
            } catch (ex) {
                $scope.viewmode = 0;
            }
        }
]);