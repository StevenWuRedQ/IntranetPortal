angular.module('PortalApp')
.controller('ConstructionCtrl', ['$scope', '$http', '$interpolate', 'ptCom', 'ptContactServices', 'ptEntityService', 'ptShortsSaleService', 'ptLeadsService', 'ptConstructionService',
function ($scope, $http, $interpolate, ptCom, ptContactServices, ptEntityService, ptShortsSaleService, ptLeadsService, ptConstructionService) {

    //data structure defination
    var CSCaseModel = function () {
        this.CSCase = {
            InitialIntake: {},
            Photos: {},
            Utilities: {
                Company: [],
                Insurance_Type: []
            },
            Violations: {
                DOBViolations: [],
                ECBViolations: []
            },
            ProposalBids: {},
            Plans: {},
            Contract: {},
            Signoffs: {},
            Comments: []
        }
    }
    var PercentageModel = function () {
        this.intake = {
            count: 0,
            finished: 0,
        };
        this.signoff = {
            count: 0,
            finished: 0
        };
        this.construction = {
            count: 0,
            finished: 0
        };
        this.test = {
            count: 0,
            finished: 0
        }
    }

    $scope._ = _;

    // scope variables defination
    $scope.ReloadedData = {}
    $scope.CSCase = new CSCaseModel();
    $scope.percentage = new PercentageModel();

    $scope.UTILITY_SHOWN = {
        'ConED': 'CSCase.CSCase.Utilities.ConED_Shown',
        'Energy Service': 'CSCase.CSCase.Utilities.EnergyService_Shown',
        'National Grid': 'CSCase.CSCase.Utilities.NationalGrid_Shown',
        'DEP': 'CSCase.CSCase.Utilities.DEP_Shown',
        'MISSING Water Meter': 'CSCase.CSCase.Utilities.MissingMeter_Shown',
        'Taxes': 'CSCase.CSCase.Utilities.Taxes_Shown',
        'ADT': 'CSCase.CSCase.Utilities.ADT_Shown',
        'Insurance': 'CSCase.CSCase.Utilities.Insurance_Shown',
    };
    $scope.HIGHLIGHTS = [
                            { message: 'Plumbing signed off at {{CSCase.CSCase.Signoffs.Plumbing_SignedOffDate}}', criteria: 'CSCase.CSCase.Signoffs.Plumbing_SignedOffDate' },
                            { message: 'Electrical signed off at {{CSCase.CSCase.Signoffs.Electrical_SignedOffDate}}', criteria: 'CSCase.CSCase.Signoffs.Electrical_SignedOffDate' },
                            { message: 'Construction signed off at {{CSCase.CSCase.Signoffs.Construction_SignedOffDate}}', criteria: 'CSCase.CSCase.Signoffs.Construction_SignedOffDate' },
                            { message: 'HPD Violations has all finished', criteria: 'CSCase.CSCase.Violations.HPD_OpenHPDViolation === false' }
    ];
    $scope.WATCHED_MODEL = [
                                {
                                    model: 'CSCase.CSCase.Signoffs.Plumbing_SignedOffDate',
                                    backedModel: 'ReloadedData.Backed_Plumbing_SignedOffDate',
                                    info: 'Plumbing Sign Off Date'
                                },
                                {
                                    model: 'CSCase.CSCase.Signoffs.Construction_SignedOffDate',
                                    backedModel: 'ReloadedData.Backed_Construction_SignedOffDate',
                                    info: 'Construction Sign Off Date'
                                },
                                {
                                    model: 'CSCase.CSCase.Signoffs.Electrical_SignedOffDate',
                                    backedModel: 'ReloadedData.Electrical_SignedOffDate',
                                    info: 'Electrical Sign Off Date'
                                }];



    $scope.arrayRemove = ptCom.arrayRemove;
    $scope.ptContactServices = ptContactServices;
    $scope.ensurePush = function (modelName, data) { ptCom.ensurePush($scope, modelName, data); }
    $scope.getRunnerList = function () {
        var url = "/api/ConstructionCases/GetRunners";
        $http.get(url)
            .then(function (res) {
                if (res.data) {
                    $scope.RUNNER_LIST = res.data;
                }
            });
    }();
    $scope.setPopupVisible = function (modelName, bVal) {
        $scope.$eval(modelName + '=' + bVal);
    }

    $scope.reload = function () {
        $scope.ReloadedData = {};
        $scope.CSCase = new CSCaseModel();
        $scope.ensurePush('CSCase.CSCase.Utilities.Floors', { FloorNum: '?', ConED: {}, EnergyService: {}, NationalGrid: {} });
        $scope.percentage = new PercentageModel();
        $scope.clearWarning();
    }
    $scope.init = function (bble, callback) {
        ptCom.startLoading();
        bble = bble.trim();
        $scope.reload();
        var done1, done2, done3, done4; // status marker to indicate all async job finished

        ptConstructionService.getConstructionCases(bble, function (res) {
            ptCom.nullToUndefined(res);
            $.extend(true, $scope.CSCase, res);
            $scope.initWatchedModel();
            done1 = true;
            if (done1 && done2 && done3 & done4) {
                ptCom.stopLoading();
                if (callback) callback();
            }

        });
        ptShortsSaleService.getShortSaleCaseByBBLE(bble, function (res) {
            $scope.SsCase = res;
            done2 = true;
            if (done1 && done2 && done3 & done4) {
                ptCom.stopLoading();
                if (callback) callback();
            }

        });
        ptLeadsService.getLeadsByBBLE(bble, function (res) {
            $scope.LeadsInfo = res;
            done3 = true;
            if (done1 && done2 && done3 & done4) {
                ptCom.stopLoading();
                if (callback) callback();
            }
        });
        ptEntityService.getEntityByBBLE(bble, function (error, data) {
            if (data) {
                $scope.EntityInfo = data;
            } else {
                $scope.EntityInfo = {};
                console.log(error);
            }
            done4 = true;
            if (done1 && done2 && done3 & done4) {
                ptCom.stopLoading();
                if (callback) callback();
            }
        })

    }

    /* Status change function -- Chris */
    $scope.ChangeStatus = function (scuessfunc, status) {
        $http.post('/api/ConstructionCases/ChangeStatus/' + leadsInfoBBLE, status)
            .success(function () {
                if (scuessfunc) {
                    scuessfunc();
                } else {
                    ptCom.alert("Successed !");
                }
            }).error(function (data, status) {
                ptCom.alert("Fail to save data. status " + status + "Error : " + JSON.stringify(data));
            });
    }

    $scope.saveCSCase = function () {
        var data = angular.toJson($scope.CSCase);
        ptConstructionService.saveConstructionCases($scope.CSCase.BBLE, data, function (res) {
            ScopeSetLastUpdateTime($scope.GetTimeUrl());
            ptCom.alert("Save successfully!");
        });
        $scope.updateInitialFormOwner();
        $scope.checkWatchedModel();
    }


    /* multiple company selection */
    $scope.$watch('CSCase.CSCase.Utilities.Company', function (newValue) {
        if (newValue) {
            var ds = $scope.UTILITY_SHOWN;
            var target = $scope.CSCase.CSCase.Utilities.Company;
            _.each(target, function (k, i) {
                $scope.$eval(ds[k] + '=false');
            });
            _.each(newValue, function (el, i) {
                $scope.$eval(ds[el] + '=true');
            });
        }
    }, true);

    $scope.$watch('CSCase.CSCase.Utilities.ConED_EnergyServiceRequired', function (newVal) {

        if (newVal) {
            if ($scope.CSCase.CSCase.Utilities.Company.indexOf('Energy Service') < 0) {
                $scope.CSCase.CSCase.Utilities.Company.push('Energy Service');
                $scope.ReloadedData.EnergyService_Collapsed = false;
            }
        } else {
            var index = $scope.CSCase.CSCase.Utilities.Company.indexOf('Energy Service');
            if (index !== -1) $scope.CSCase.CSCase.Utilities.Company.splice(index, 1);
        }


    });
    /* end multiple company selection */

    /* reminder */
    $scope.sendNotice = function (id, name) {
        confirm("Send Intake Sheet To " + name + " ?");
    }
    /* end reminder */

    /* comments */
    $scope.showPopover = function (e) {
        aspxConstructionCommentsPopover.ShowAtElement(e.target);
    }

    $scope.addComment = function (comment) {
        var newComments = {}
        newComments.comment = comment;
        newComments.caseId = $scope.CaseId;
        newComments.createBy = Current_User;
        newComments.createDate = new Date();
        $scope.CSCase.CSCase.Comments.push(newComments);
    }
    $scope.addCommentFromPopup = function () {
        var comment = $scope.addCommentTxt;
        $scope.addComment(comment);
        $scope.addCommentTxt = '';
    }
    /* end comments */

    /* active tab */
    $scope.activeTab = 'CSInitialIntake';
    $scope.updateActive = function (id) {
        $scope.activeTab = id;
    }
    /* end active tab */

    /* highlight */
    $scope.isHighlight = function (criteria) {
        return $scope.$eval(criteria);
    }
    $scope.highlightMsg = function (msg) {
        var msgstr = $interpolate(msg)($scope);
        return msgstr;
    }

    $scope.initWatchedModel = function () {
        _.each($scope.WATCHED_MODEL, function (el, i) {
            $scope.$eval(el.backedModel + '=' + el.model);
        });
    }
    $scope.checkWatchedModel = function () {
        var res = "";
        _.each($scope.WATCHED_MODEL, function (el, i) {
            if ($scope.$eval(el.backedModel + "!=" + el.model)) {
                $scope.$eval(el.backedModel + "=" + el.model);
                res += (el.info + " changes to " + $scope.$eval(el.model) + ".<br>");
            }
        });
        if (res) AddActivityLog(res);
    }

    /* end highlight */

    /* header editing */
    $scope.HeaderEditing = false;
    $scope.toggleHeaderEditing = function (open) {
        $scope.HeaderEditing = !$scope.HeaderEditing;
        if (open) $("#ConstructionTitleInput").focus();
    }
    /* end header editing */

    /* dob fetch */
    $scope.addNewDOBViolation = function () {
        $scope.ensurePush('CSCase.CSCase.Violations.DOBViolations');
        $scope.setPopupVisible('ReloadedData.DOBViolations_PopupVisible_' + ($scope.CSCase.CSCase.Violations.DOBViolations.length - 1), true);
    }
    $scope.addNewECBViolation = function () {
        $scope.ensurePush('CSCase.CSCase.Violations.ECBViolations');
        $scope.setPopupVisible('ReloadedData.ECBViolations_PopupVisible_' + ($scope.CSCase.CSCase.Violations.ECBViolations.length - 1), true);
    }

    $scope.fetchDOBViolations = function () {
        ptCom.confirm("<h3 style='color:red'>Warning!!!</h3>Getting information from DOB takes a while.<br>And it will <b>REPLACE</b> your current Data, are you sure to continue?", "Warning")
        .then(function (confirmed) {
            if (confirmed) {
                ptConstructionService.getDOBViolations($scope.CSCase.BBLE, function (error, res) {
                    if (error) {
                        ptCom.alert(error);
                        console.log(error)
                    } else {
                        ptCom.confirm("<h3 style='color:red'>Warning!!!</h3>Your current DOB Violation data will be replaced.", "Warning")
                        .then(function (confirmed) {
                            if (confirmed) {

                                if (res && res.DOB_TotalDOBViolation) $scope.CSCase.CSCase.Violations.DOB_TotalDOBViolation = res.DOB_TotalDOBViolation;
                                if (res && res.DOB_TotalOpenViolations) $scope.CSCase.CSCase.Violations.DOB_TotalOpenViolations = res.DOB_TotalOpenViolations;
                                if (res && res.violations) $scope.CSCase.CSCase.Violations.DOBViolations = res.violations;

                            }
                        })

                    }
                })
            }

        })

    }
    $scope.fetchECBViolations = function () {
        ptCom.confirm("<h3 style='color:red'>Warning!!!</h3>Getting information from DOB takes a while.<br>And it will <b>REPLACE</b> your current Data, are you sure to continue?", "Warning")
        .then(function (confirmed) {
            if (confirmed) {
                ptConstructionService.getECBViolations($scope.CSCase.BBLE, function (error, res) {
                    if (error) {
                        ptCom.alert(error);
                        console.log(error)
                    } else {
                        ptCom.confirm("<h3 style='color:red'>Warning!!!</h3>Your current DOB Violation data will be replaced.", "Warning")
                        .then(function (confirmed) {
                            if (confirmed) {
                                if (res && res.ECP_TotalViolation) $scope.CSCase.CSCase.Violations.ECP_TotalViolation = res.ECP_TotalViolation;
                                if (res && res.ECP_TotalOpenViolations) $scope.CSCase.CSCase.Violations.ECP_TotalOpenViolations = res.ECP_TotalOpenViolations;
                                if (res && res.violations) {
                                    $scope.CSCase.CSCase.Violations.ECBViolations = _.filter(res.violations, function (el, i) {
                                        return el.DOBViolationStatus.slice(0, 4) == "OPEN"
                                    });
                                }
                            }
                        })

                    }
                })
            }

        })
    }
    /* end dob fetch */

    /* intakeComplete */
    $scope.test = $scope.checkIntake;
    $scope.intakeComplete = function () {
        if (!$scope.checkIntake(function (el) {
            el.prev().css('background-color', 'yellow')
        })) {
            $scope.CSCase.IntakeCompleted = true;
            AddActivityLog("Intake Process have finished!");
            $scope.saveCSCase();
        } else {
            ptCom.alert("Intake Complete Fails.\nPlease check highlights for missing information!");
        }
    }
    $scope.checkIntake = function (callback) {
        $scope.clearWarning();
        $scope.percentage.intake.count = 0;
        $scope.percentage.intake.finished = 0;
        $(".intakeCheck").each(function (idx) {
            var test;
            var model = $(this).attr('ng-model') || $(this).attr('ss-model') || $(this).attr('file-model') || $(this).attr('model');
            if (model) {
                if (model.slice(0, 4) === "floor") {
                    test = _.has($(this).scope().floor, model.split(".").splice(1).join('.'));
                    if (!test) {
                        if (callback) callback($(this))
                    } else {
                        $scope.percentage.intake.finished++;
                    }
                } else {
                    test = $scope.$eval(model)
                    if (test === undefined) {
                        if (callback) callback($(this))
                    } else {
                        $scope.percentage.intake.finished++;
                    }
                }
            }
            $scope.percentage.intake.count++;
        })
        var errors = $scope.percentage.intake.count - $scope.percentage.intake.finished;
        return errors;
    }
    $scope.clearWarning = function () {
        $(".intakeCheck").each(function (idx) {
            $(this).prev().css('background-color', 'transparent');
        });
    }
    $scope.updatePercentage = function () {
        $scope.checkIntake();
    }
    /* end intakeComplte */

    /*check file be modify*/
    $scope.GetTimeUrl = function () {
        return $scope.CSCase.BBLE ? "/api/ConstructionCases/LastLastUpdate/" + $scope.CSCase.BBLE : "";
    }
    $scope.GetCSCaseId = function () {
        return $scope.CSCase.BBLE;
    }
    $scope.GetModifyUserUrl = function () {
        return "/api/ConstructionCases/LastModifyUser/" + $scope.CSCase.BBLE;
    }
    /****** end check file be modify*********/

    /* printWindows*/
    $scope.printWindow = function () {
        window.open("/Construction/ConstructionPrint.aspx?bble=" + $scope.CSCase.BBLE, 'Print', 'width=1024, height=800');
    }
    /* end printWindows */

    /* open form windows */
    $scope.openInitialForm = function () {
        window.open("/Construction/ConstructionInitialForm.aspx?bble=" + $scope.CSCase.BBLE, 'Initial Form', 'width=1280, height=960')
    }
    $scope.openBudgetForm = function () {
        window.open("/Construction/ConstructionBudgetForm.aspx?bble=" + $scope.CSCase.BBLE, 'Budget Form', 'width=1024, height=768')
    }
    /* end open form windows */

    $scope.updateInitialFormOwner = function () {
        var url = "/api/ConstructionCases/UpdateInitialFormOwner?BBLE=" + $scope.CSCase.BBLE + "&owner=" + $scope.CSCase.CSCase.InitialIntake.InitialFormAssign
        $http({
            method: 'POST',
            url: url
        }).then(function success(res) {
            console.log("Assign Initial Form owner Success.")
        }, function error(res) {
            console.log("Fail to assign Initial Form owner.")
        });
    }

    $scope.getOrdersLength = function () {
        return
    }
}]);