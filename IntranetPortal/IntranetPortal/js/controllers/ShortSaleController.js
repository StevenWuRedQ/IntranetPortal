angular.module("PortalApp")
.controller('ShortSaleCtrl', ['$scope', '$http', '$timeout', 'ptContactServices', 'ptCom',
    function ($scope, $http, $timeout, ptContactServices, ptCom) {
        $scope.ptContactServices = ptContactServices;
        $scope.capitalizeFirstLetter = ptCom.capitalizeFirstLetter;
        $scope.formatName = ptCom.formatName;
        $scope.formatAddr = ptCom.formatAddr;
        $scope.ptCom = ptCom;
        $scope.MortgageTabs = [];
        $scope.SsCase = {
            PropertyInfo: { Owners: [{}] },
            CaseData: {},
            Mortgages: [{}]
        };
        $scope.SsCaseApprovalChecklist = {};
        $scope.Approval_popupVisible = false;
        $http.get('/Services/ContactService.svc/getbanklist').success(function (data) {
            $scope.bankNameOptions = data;
        }).error(function (data) {
            $scope.bankNameOptions = [];
        });

        //move to construction - add by chris
        $scope.MoveToConstruction = function (scuessfunc) {
            var json = $scope.SsCase;
            var data = { bble: leadsInfoBBLE };

            $http.post('ShortSaleServices.svc/MoveToConstruction', JSON.stringify(data))
                .success(function () {
                    if (scuessfunc) {
                        scuessfunc();
                    } else {
                        ptCom.alert("Move to Construction successful!");
                    }
                }).error(function (data1, status) {
                    ptCom.alert("Fail to save data. status :" + status + "Error : " + JSON.stringify(data1));
                });
        };

        $scope.MoveToTitle = function (scuessfunc) {
            var json = $scope.SsCase;
            var data = { bble: leadsInfoBBLE };

            $http.post('ShortSaleServices.svc/MoveToTitle', JSON.stringify(data))
                .success(function () {
                    if (scuessfunc) {
                        scuessfunc();
                    } else {
                        ptCom.alert("Move to Title successful !");
                    }
                }).error(function (data1, status) {
                    ptCom.alert("Fail to save data. status " + status + "Error : " + JSON.stringify(data1));
                });
        }; // -- end --


        $scope.GetShortSaleCase = function (caseId, callback) {
            if (!caseId) {
                console.log("Can not find case Id ");
                return;
            }

            ptCom.startLoading();
            var done1, done2;
            $http.get("ShortSaleServices.svc/GetCase?caseId=" + caseId)
                .success(function (data) {
                    $scope.SsCase = data;
                    leadsInfoBBLE = $scope.SsCase.BBLE;
                    window.caseId = caseId;

                    $http.get("ShortSaleServices.svc/GetLeadsInfo?bble=" + $scope.SsCase.BBLE).success(function (data1) {
                        $scope.ReloadedData = {};
                        $scope.SsCase.LeadsInfo = data1;
                        $('#CaseData').val(JSON.stringify($scope.SsCase));
                        if (callback) { callback(); }
                        done1 = true;
                        if (done1 && done2) {
                            ptCom.stopLoading();
                        }

                    }).error(function (data1) {
                        ptCom.stopLoading();
                        ptCom.alert("Get Short sale Leads failed BBLE =" + $scope.SsCase.BBLE + " error : " + JSON.stringify(data1));
                    });

                    $http.get('/LegalUI/LegalServices.svc/GetLegalCase?bble=' + leadsInfoBBLE).success(function (data1) {
                        $scope.LegalCase = data1;
                        done2 = true;
                        if (done1 && done2) {
                            ptCom.stopLoading();
                        }
                    }).error(function (data1) {
                        ptCom.stopLoading();
                        console.log("Fail to load data : " + leadsInfoBBLE + " :" + JSON.stringify(data1)); // alert("Fail to load data : " + leadsInfoBBLE + " :" + 
                    });
                }).error(function (data) {
                    ptCom.stopLoading();
                    ptCom.alert("Get Short sale failed CaseId= " + caseId + ", error : " + JSON.stringify(data));
                });
        };
        $scope.GetLoadId = function () {
            return window.caseId;
        };
        $scope.GetModifyUserUrl = function () {
            return 'ShortSaleServices.svc/GetModifyUserUrl?caseId=' + window.caseId;
        };

        $scope.NGAddArraryItem = function (item, model, popup) {
            if (model) {
                var array = $scope.$eval(model);
                if (!array) { $scope.$eval(model + '=[{}]'); }
                else { $scope.$eval(model + '.push({})'); }
            } else { item.push({}); }
            if (popup) { $scope.setVisiblePopup(item[item.length - 1], true); }

        };
        $scope.NGremoveArrayItem = function (item, index, disable) {
            var r = window.confirm("Delete This?");
            if (r) {
                if (disable) item[index].DataStatus = 3;
                else item.splice(index, 1);
            }

        };

        $scope.SaveShortSale = function (callback) {
            var json = $scope.SsCase;
            var data = { caseData: JSON.stringify(json) };

            $http.post('ShortSaleServices.svc/SaveCase', JSON.stringify(data)).
                    success(function () {
                        // if save scuessed load data again 

                        $scope.GetShortSaleCase($scope.SsCase.CaseId);
                        if (!callback) {
                            ptCom.alert("Save Successed !");
                        }

                        if (callback) { callback(); }

                    }).error(function (data1, status) {
                        var message = (data1 && typeof data1 == 'object' && data1.message) ? data1.message : JSON.stringify(data1);
                        ptCom.alert("Fail to save data. status " + status + "Error : " + message);
                    });
        };
        $scope.ShowAddPopUp = function (event) {
            $scope.addCommentTxt = "";
            aspxAddLeadsComments.ShowAtElement(event.target);
        };
        $scope.AddComments = function () {

            $http.post('ShortSaleServices.svc/AddComments', { comment: $scope.addCommentTxt, caseId: $scope.SsCase.CaseId }).success(function (data) {
                $scope.SsCase.Comments.push(data);
            }).error(function (data, status) {
                ptCom.alert("Fail to AddComments. status " + status + "Error : " + JSON.stringify(data));
            });

        };
        $scope.DeleteComments = function (index) {
            var comment = $scope.SsCase.Comments[index];
            $http.get('ShortSaleServices.svc/DeleteComment?commentId=' + comment.CommentId).success(function (data) {
                $scope.SsCase.Comments.splice(index, 1);
            }).error(function (data, status) {
                ptCom.alert("Fail to delete comment. status " + status + "Error : " + JSON.stringify(data));
            });
        };
        $scope.GetCaseInfo = function () {
            var CaseInfo = { Name: '', Address: '' };
            var caseName = $scope.SsCase.CaseName;
            if (caseName) {
                CaseInfo.Address = caseName.replace(/-(?!.*-).*$/, '');
                var matched = caseName.match(/-(?!.*-).*$/);
                if (matched && matched[0]) {
                    CaseInfo.Name = matched[0].replace('-', '');
                }
            }
            return CaseInfo;
        };

        $scope.setVisiblePopup = function (model, value) {
            if (model) model.visiblePopup = value;
            _.defer(function () { $scope.$apply(); });

        };


        $scope.approvalSave = function () {
            if ($scope.approvalSuccCallback) $scope.approvalSuccCallback();
            $scope.SaveShortSale();
            $scope.Approval_popupVisible = false;
        };
        $scope.approvalCancl = function () {
            if ($scope.approvalCanclCallback) $scope.approvalCanclCallback();
            $scope.Approval_popupVisible = false;
        };
        $scope.regApproval = function (succ, cancl) {
            if (!$scope.approvalSuccCallback) $scope.approvalSuccCallback = succ;
            if (!$scope.approvalCanclCallback) $scope.approvalCanclCallback = cancl;
        };
        $scope.toggleApprovalPopup = function () {
            $scope.$apply(function () {
                $scope.Approval_popupVisible = !$scope.Approval_popupVisible;
            });
        }; /* end approval popup */

        /* valuation popup */
        $scope.ValuationWatchField = {
            Method: 'Type of Valuation',
            DateOfCall: 'Date of Call',
            AgentName: 'BPO Agent',
            AgentPhone: 'Agent Phone #',
            DateOfValue: 'Date of Valuation',
            TimeOfValuation: 'Time of Valuation',
            Access: 'Access',
            IsValuationComplete: 'Valuation Completed',
            DateComplate: 'Complete Date'
        };
        $scope.Valuation_popupVisible = false;
        $scope.Valuation_Show_Option = 1;
        $scope.addPendingValue = function () {
            $scope.SsCase.ValueInfoes.push({ Pending: true });
        };
        $scope.removePendingValue = function (el) {
            var index = $scope.SsCase.ValueInfoes.indexOf(el);
            $scope.NGremoveArrayItem($scope.SsCase.ValueInfoes, index);
        };
        $scope.ensurePendingValue = function () {
            var existPending = false;
            _.each($scope.SsCase.ValueInfoes, function (el, index) {
                if (el.Pending) existPending = true;
            });
            if (!existPending) $scope.addPendingValue();
        };
        $scope.setPendingModified = function () {
            $scope.oldPendingValues = [];
            _.each($scope.SsCase.ValueInfoes, function (el, index) {
                if (el.Pending) {
                    var newEl = {};
                    for (var property in el) {
                        if (el.hasOwnProperty(property)) {
                            newEl[property] = el[property];
                        }
                    }
                    $scope.oldPendingValues.push(newEl);
                }
            });
        };
        $scope.checkPendingModified = function () {
            var updates = '';
            _.each($scope.SsCase.ValueInfoes, function (el, index) {
                if (el.Pending) {
                    var oldEl = $scope.oldPendingValues.filter(function (e, i) { return e.$$hashKey == el.$$hashKey })[0];
                    if (!oldEl) {
                        for (var property in el) {
                            if ($scope.ValuationWatchField.hasOwnProperty(property)) {
                                updates += 'Valuation' + index + ' <b>' + $scope.ValuationWatchField[property] + '</b> changes to <b>' + el[property] + '</b><br/>';
                            }
                        }
                    } else {
                        for (var property in el) {
                            if ($scope.ValuationWatchField[property] && el[property] !== oldEl[property]) {
                                updates += 'Valuation' + index + ' <b>' + $scope.ValuationWatchField[property] + '</b> changes to <b>' + el[property] + '</b><br/>';
                            }
                        }
                    }

                }
            }); //console.log(updates)
            return updates;
        };
        $scope.restorePendingModified = function () {
            _.remove($scope.SsCase.ValueInfoes, function (el, index) {
                return el.Pending;
            });
            _.each($scope.oldPendingValues, function (el, index) {
                $scope.SsCase.ValueInfoes.push(el);
            });
        };
        $scope.valuationCanl = function () {
            $scope.restorePendingModified();
            if ($scope.valuationCanclCallback) $scope.valuationCanclCallback();
            $scope.Valuation_popupVisible = false;
        };
        $scope.valuationSave = function () {
            var updates = $scope.checkPendingModified();
            if ($scope.valuationSuccCallback) $scope.valuationSuccCallback(updates);
            $scope.Valuation_popupVisible = false;

        };
        $scope.valuationCompl = function (el) {
            var updates = $scope.checkPendingModified();
            if ($scope.valuationSuccCallback) $scope.valuationSuccCallback(updates);
            el.Pending = false;
            $scope.Valuation_popupVisible = false;
        };
        $scope.regValuation = function (succ, cancl) {
            if (!$scope.valuationSuccCallback) $scope.valuationSuccCallback = succ;
            if (!$scope.valuationCanclCallback) $scope.valuationCanclCallback = cancl;
        };
        $scope.toggleValuationPopup = function (status) {
            $scope.$apply(function () {
                $scope.Valuation_Show_Option = status;
                $scope.setPendingModified();
                $scope.ensurePendingValue();
                $scope.Valuation_popupVisible = !$scope.Valuation_popupVisible;
            });
        }; /* end valuation popup */

        /* update mortage status */
        $scope.UpdateMortgageStatus = function (selType1, selStatusUpdate, selCategory) {
            var index = 0;
            switch (selType1) {
                case '2nd Lien':
                    index = 1;
                    break;
                case '3d Lien':
                    index = 2;
                    break;
                default:
                    index = 0;
            }

            $timeout(function () {
                if ($scope.SsCase.Mortgages[index]) {
                    $scope.SsCase.Mortgages[index].Category = selCategory;
                    $scope.SsCase.Mortgages[index].Status = selStatusUpdate;
                }

            });
        }; /* end update mortage status*/
    }]);