angular.module("PortalApp")
.controller('BuyerEntityCtrl', ['$scope', '$http', 'ptContactServices', function ($scope, $http, ptContactServices) {
    $scope.EmailTo = [];
    $scope.EmailCC = [];
    $scope.ptContactServices = ptContactServices;
    $scope.selectType = 'All Entities';
    $scope.loadPanelVisible = true;
    //for view and upload document -- add by chris
    $scope.encodeURIComponent = window.encodeURIComponent;
    $http.get('/Services/ContactService.svc/GetAllBuyerEntities')
        .success(function (data) {
            $scope.CorpEntites = data;
            $scope.currentContact = $scope.CorpEntites[0];
            $scope.loadPanelVisible = false;
        }).error(function (data) {
            alert('Get All buyers Entities error : ' + JSON.stringify(data));
        });
    $http.get('/Services/TeamService.svc/GetAllTeam')
        .success(function (data) {
            $scope.AllTeam = data;
        }).error(function (data) {
            alert('Get All Team name  error : ' + JSON.stringify(data));
        });
    $scope.Groups = [
        { GroupName: 'All Entities' },
        { GroupName: 'Available' },
        { GroupName: 'Assigned Out' },
        {
            GroupName: 'Current Offer',
            SubGroups:
            [
                { GroupName: 'NHA Current Offer' }, { GroupName: 'Isabel Current Offer' },
                { GroupName: 'Quiet Title Action' }, { GroupName: 'Deed Purchase' },
                { GroupName: 'Straight Sale' }, { GroupName: 'Jay Current Offer' }
            ]
        },
        {
            GroupName: 'Sold',
            SubGroups: [
                { GroupName: 'Purchased' }, { GroupName: 'Partnered' },
                { GroupName: 'Sold (Final Sale)/Recyclable' }
            ]
        },
        { GroupName: 'In House' },
        { GroupName: 'Agent Corps' }
    ];

    $scope.ChangeGroups = function (name) {
        $scope.selectType = name;
    }
    $scope.GetTitle = function () {
        return ($scope.SelectedTeam ? ($scope.SelectedTeam === "" ? "All Team's " : $scope.SelectedTeam + "s ") : "") + $scope.selectType;
    }
    $scope.ExportExcel = function () {
        JSONToCSVConvertor($scope.filteredCorps, true, $scope.GetTitle());

    }
    $scope.GroupCount = function (g) {
        if (!$scope.CorpEntites) {
            return 0;
        }
        if (g.GroupName == 'All Entities') {
            if ($scope.SelectedTeam) {
                return $scope.CorpEntites.filter(function (o) { return o.Office && o.Office.toLowerCase().trim() == $scope.SelectedTeam.toLowerCase().trim() }).length;
            }
            return $scope.CorpEntites.length;
        }
        var count = 0
        if (g.SubGroups) {
            for (var i = 0; i < g.SubGroups.length; i++) {
                count += $scope.GroupCount(g.SubGroups[i]);
            }
            return count
        }
        var corps = $scope.CorpEntites.filter(function (o) { return (o.Status && o.Status.toLowerCase().trim() == g.GroupName.toLowerCase().trim()) });
        if ($scope.SelectedTeam) {
            corps = corps.filter(function (o) { return o.Office && o.Office.toLowerCase().trim() == $scope.SelectedTeam.toLowerCase().trim() });
        }
        return corps.length;
    }
    $scope.lookupDataSource = new DevExpress.data.ODataStore({
        url: "/odata/LeadsInfoes",
        key: "CategoryID",
        keyType: "Int32"
    });
    $scope.TeamCount = function (teamName) {
        if (!$scope.CorpEntites) {
            return 0;
        }
        var crops = [];
        crops = teamName ? $scope.CorpEntites.filter(function (o) { return o.Office && o.Office.toLowerCase().trim() == teamName.toLowerCase().trim() }) : $scope.CorpEntites;


        if ($scope.selectType && $scope.selectType != $scope.Groups[0].GroupName) {
            crops = crops.filter(function (o) { return o.Status && o.Status.toLowerCase().trim() == $scope.selectType.toLowerCase().trim() })
        }

        return crops.length;
    }
    $scope.EmployeeDataSource = function () {
        var employees = $scope.ptContactServices.getContactsByGroup(4);

        var mSource = new DevExpress.data.CustomStore({
            load: function (loadOptions) {
                if (loadOptions.searchValue) {
                    var q = loadOptions.searchValue;
                    return employees.filter(function (e) { e.Email && (e.Email.toLowerCase() == q.toLowerCase() || e.Name.toLowerCase() == q.toLowerCase()) }).slice(0, 10);
                }
                return employees.slice(0, 10);
            },
            byKey: function (key, extra) {
                // . . .
            },


        });
        return {
            dataSource: mSource,
            searchEnabled: true,
            placeholder: 'Type to Search',
            displayExpr: 'Email',
            valueExpr: 'Email',
            bindingOptions: {
                values: 'EmailTo'
            }
        };
    }
    $scope.EntitiesFilter = function (entity) {
        if ($scope.selectType == 'All Entities' || (entity.Status && $scope.selectType.toLowerCase().trim() == entity.Status.toLowerCase().trim()))
            return true;
        var subs = $scope.Groups.filter(function (o) { return o.GroupName == $scope.selectType })[0];
        if (subs && subs.SubGroups) {
            for (var i = 0; i < subs.SubGroups.length; i++) {
                var sg = subs.SubGroups[i];
                if (entity.Status && sg.GroupName.toLowerCase().trim() == entity.Status.toLowerCase().trim()) {
                    return true;
                }
            }
        }

        return false;
    }
    $scope.selectCurrent = function (contact) {
        $scope.currentContact = contact;
    }
    $scope.SaveCurrent = function () {
        $scope.loadPanelVisible = true;
        $http.post('/Services/ContactService.svc/SaveCorpEntitiy', { c: JSON.stringify($scope.currentContact) }).success(function (data, status, headers, config) {
            $scope.loadPanelVisible = false;
            alert("Save succeed!")
        }).error(function (data, status, headers, config) {
            alert("Get error save corp entitiy : " + JSON.stringify(data))
            $scope.loadPanelVisible = false;
        });
    }
    $scope.AllGroups = function () {
        var HasSub = $scope.Groups.filter(function (o) { return o.SubGroups != null });
        var groups = [];
        for (var i = 0; i < HasSub.length; i++) {
            groups = groups.concat(HasSub[i].SubGroups);
        }
        var HasNotSub = $scope.Groups.filter(function (o) { return o.SubGroups == null && o.GroupName != 'All Entities' });
        groups = groups.concat(HasNotSub);
        return groups;
    }
    $scope.addContactFunc = function () {
        $scope.loadPanelVisible = true;
        $http.post('/Services/ContactService.svc/SaveCorpEntitiy', { c: JSON.stringify($scope.addContact) }).success(function (data, status, headers, config) {
            $scope.loadPanelVisible = false;
            if (!data) {
                alert("Already have a entitity named " + $scope.addContact.CorpName + "! please pick other name");
                return;
            }
            $scope.currentContact = data;
            $scope.CorpEntites.push($scope.addContact);
            alert("Add entity succeed !")
        }).error(function (data, status, headers, config) {
            $scope.loadPanelVisible = false;
            alert('Add buyer Entities error : ' + JSON.stringify(data))
        });
    }
    $scope.AssginEntity = function () {
        $scope.loadPanelVisible = true;
        $http.post('/Services/ContactService.svc/AssginEntity', { c: JSON.stringify($scope.currentContact) }).success(function (data, status, headers, config) {
            $scope.loadPanelVisible = false;
            $scope.currentContact.BBLE = data;
            alert("Assigned succeed !")
        }).error(function (data, status, headers, config) {
            $scope.loadPanelVisible = false;
            alert('Can not find BBLE of address:(' + $scope.currentContact.PropertyAssigned + ") Please make sure this address is available");
        });
    }
    $scope.ChangeTeam = function (team) {
        $scope.SelectedTeam = team;
    }
    $scope.OpenLeadsView = function () {
        var bble = $scope.currentContact.BBLE
        var url = '/ViewLeadsInfo.aspx?id=' + bble;
        OpenLeadsWindow(url, "View Leads Info " + bble);
    }
    $scope.UploadFile = function (fileUploadId, type, field) {
        $scope.loadPanelVisible = true;

        var contact = $scope.currentContact;
        var entityId = contact.EntityId;

        // grab file object from a file input
        var fileData = document.getElementById(fileUploadId).files[0];

        $.ajax({
            url: '/services/ContactService.svc/UploadFile?id=' + entityId + '&type=' + type,
            type: 'POST',
            data: fileData,
            cache: false,
            dataType: 'json',
            processData: false, // Don't process the files
            contentType: "application/octet-stream", // Set content type to false as jQuery will tell the server its a query string request
            success: function (data) {
                alert('successful..');
                $scope.currentContact[field] = data;
                $scope.loadPanelVisible = false;
                $scope.$apply();
            },
            error: function (data) {
                alert('Some error Occurred!');
                $scope.loadPanelVisible = false;
                $scope.$apply();
            }
        });
    }

    //end - view and upload document
}]);
angular.module('PortalApp')
.controller('ConstructionCtrl', ['$scope', '$http', '$interpolate', 'ptCom', 'ptContactServices', 'ptEntityService', 'ptShortsSaleService', 'ptLeadsService', 'ptConstructionService', function ($scope, $http, $interpolate, ptCom, ptContactServices, ptEntityService, ptShortsSaleService, ptLeadsService, ptConstructionService) {

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

    // end scope variables defination

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
        var done1, done2, done3, done4;

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
    /* end status change function */

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
            _.each(target, function(k, i) {
                $scope.$eval(ds[k] + '=false');
            });
            _.each(newValue, function(el, i) {
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
        _.each($scope.WATCHED_MODEL, function(el, i) {
            $scope.$eval(el.backedModel + '=' + el.model);
        });
    }
    $scope.checkWatchedModel = function () {
        var res = "";
        _.each($scope.WATCHED_MODEL, function(el, i) {
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
}]
);
angular.module('PortalApp')
    .controller('LeadTaxSearchCtrl', function ($scope, $http, $element, $timeout, ptContactServices, ptCom) {
    $scope.ptContactServices = ptContactServices;
    leadsInfoBBLE = $('#BBLE').val();
    //$scope.DocSearch.LeadResearch = $scope.DocSearch.LeadResearch || {}
    $scope.init = function (bble) {

        leadsInfoBBLE = bble || $('#BBLE').val();
        if (!leadsInfoBBLE) {
            console.log("Can not load page without BBLE !")
            return;
        }




        $http.get("/api/LeadInfoDocumentSearches/" + leadsInfoBBLE).
        success(function (data, status, headers, config) {
            $scope.DocSearch = data;
            $http.get('/Services/TeamService.svc/GetTeam?userName=' + $scope.DocSearch.CreateBy).success(function (data) {
                $scope.DocSearch.team = data;

            });

            $http.get("/ShortSale/ShortSaleServices.svc/GetLeadsInfo?bble=" + leadsInfoBBLE).
              success(function (data1, status, headers, config) {
                  $scope.LeadsInfo = data1;
                  $scope.DocSearch.LeadResearch = $scope.DocSearch.LeadResearch || {};
                  $scope.DocSearch.LeadResearch.ownerName = $scope.DocSearch.LeadResearch.ownerName || data1.Owner;
                  $scope.DocSearch.LeadResearch.waterCharges = $scope.DocSearch.LeadResearch.waterCharges || data1.WaterAmt;
                  $scope.DocSearch.LeadResearch.propertyTaxes = $scope.DocSearch.LeadResearch.propertyTaxes || data1.TaxesAmt;
                  $scope.DocSearch.LeadResearch.mortgageAmount = $scope.DocSearch.LeadResearch.mortgageAmount || data1.C1stMotgrAmt;
                  $scope.DocSearch.LeadResearch.secondMortgageAmount = $scope.DocSearch.LeadResearch.secondMortgageAmount || data.C2ndMotgrAmt;

              }).error(function (data, status, headers, config) {
                  alert("Get Leads Info failed BBLE = " + leadsInfoBBLE + " error : " + JSON.stringify(data));
              });

        });
    }

    $scope.init(leadsInfoBBLE)
    $scope.SearchComplete = function (isSave) {
        $scope.DocSearch.Status = 1;
        $scope.DocSearch.IsSave = isSave
        $scope.DocSearch.ResutContent = $("#searchReslut").html();
        $.ajax({
            type: "PUT",
            url: '/api/LeadInfoDocumentSearches/' + $scope.DocSearch.BBLE,
            data: JSON.stringify($scope.DocSearch),
            dataType: 'json',
            contentType: 'application/json',
            success: function (data) {

                alert(isSave ? 'Save success!' : 'Lead info search completed !');
                if (typeof gridCase != 'undefined') {
                    gridCase.Refresh();
                }
            },
            error: function (data) {
                alert('Some error Occurred url api/LeadInfoDocumentSearches ! Detail: ' + JSON.stringify(data));
            }

        });
    }
});
/* global LegalShowAll */
/* global angular */
angular.module('PortalApp').controller('LegalCtrl', ['$scope', '$http', 'ptContactServices', 'ptCom', 'ptTime','$window', function ($scope, $http, ptContactServices, ptCom, ptTime, $window) {

    $scope.ptContactServices = ptContactServices;
    $scope.ptCom = ptCom;
    $scope.isPassByDays = ptTime.isPassByDays;
    $scope.isPassOrEqualByDays = ptTime.isPassOrEqualByDays;
    $scope.isLessOrEqualByDays = ptTime.isLessOrEqualByDays;
    $scope.isPassByMonths = ptTime.isPassByMonths;
    $scope.isPassOrEqualByMonths = ptTime.isPassOrEqualByMonths;

    $scope.LegalCase = { PropertyInfo: {}, ForeclosureInfo: {}, SecondaryInfo: {}, PreQuestions: {} };
    $scope.LegalCase.SecondaryInfo.StatuteOfLimitations = [];
    $scope.LegalCase.SecondaryTypes = []
    $scope.SecondaryTypeSource = ["Statute Of Limitations", "Estate", "Miscellaneous", "Deed Reversal", "Partition", "Breach of Contract", "Quiet Title", ""];
    $scope.TestRepeatData = [];
    if (typeof LegalShowAll == 'undefined' || LegalShowAll == null) {
        $scope.LegalCase.SecondaryInfo.SelectTypes = $scope.SecondaryTypeSource;
    }
    $scope.filterSelected = true;
    $scope.LegalCase.ForeclosureInfo.PlaintiffId = 638;
    $scope.PickedContactId = null;
    $scope.History = [];

    $scope.querySearch = function (query) {
        var createFilterFor = function (query) {
            var lowercaseQuery = angular.lowercase(query);
            return function filterFn(contact) {
                return contact.Name && (contact.Name.toLowerCase().indexOf(lowercaseQuery) !== -1);
            };
        }
        var results = query ?
            $scope.allContacts.filter(createFilterFor(query)) : [];
        return results;
    }
    $scope.loadContacts = function () {
        var contacts = AllContact ? AllContact : [];
        return contacts.map(function (c, index) {
            c.image = 'https://storage.googleapis.com/material-icons/external-assets/v1/icons/svg/ic_account_circle_black_48px.svg';
            if (c.Name) {
                c._lowername = c.Name.toLowerCase();
            }
            return c;
        });
    };
    $scope.allContacts = $scope.loadContacts();
    $scope.contacts = [$scope.allContacts[0]];
    $scope.AllJudges = AllJudges ? AllJudges : [];

    $scope.addTest = function () {
        $scope.TestRepeatData[$scope.TestRepeatData.length] = $scope.TestRepeatData.length;
    };

    $scope.RoboSingerDataSource = new DevExpress.data.DataSource({
        store: new DevExpress.data.CustomStore({
            load: function (loadOptions) {
                if (AllRoboSignor) {
                    if (loadOptions.searchValue) {
                        return AllRoboSignor.filter(function (o) { if (o.Name) { return o.Name.toLowerCase().indexOf(loadOptions.searchValue.toLowerCase()) >= 0 } return false });
                    }
                    return [];
                }
            },
            byKey: function (key) {
                if (AllRoboSignor) {
                    return AllRoboSignor.filter(function (o) { return o.ContactId == key })[0];
                }

            },
            searchExpr: ["Name"]
        })
    });
    $scope.InitContact = function (id, dataSourceName) {
        return {
            dataSource: dataSourceName ? $scope[dataSourceName] : $scope.ContactDataSource,
            valueExpr: 'ContactId',
            displayExpr: 'Name',
            searchEnabled: true,
            minSearchLength: 2,
            noDataText: "Please input to search",
            bindingOptions: { value: id }
        }
    };
    $scope.TestContactId = function (c) {
        $scope.$eval(c + '=' + '192');
    };
    $scope.GetContactById = function (id) {
        return AllContact.filter(function (o) { return o.ContactId == id })[0];
    };

    $scope.CheckPlace = function (p) {
        if (p) {
            return p === 'NY';
        }
        return false;
    };

    $scope.SaveLegal = function (scuessfunc) {
        if (!LegalCaseBBLE || LegalCaseBBLE !== leadsInfoBBLE) {
            alert("Case not load completed please wait!");
            return;
        }
        var json = JSON.stringify($scope.LegalCase);
        var data = { bble: LegalCaseBBLE, caseData: json };
        $http.post('LegalUI.aspx/SaveCaseData', data).
            success(function () {
                if (scuessfunc) {
                    scuessfunc()
                } else {
                    $scope.LogSaveChange();
                    alert("Save Successed !");
                }
                ResetCaseDataChange();
            }).
            error(function (data, status) {
                alert("Fail to save data. status " + status + "Error : " + JSON.stringify(data));
            });
    };

    $scope.CompleteResearch = function () {
        var json = JSON.stringify($scope.LegalCase);
        var data = { bble: leadsInfoBBLE, caseData: json, sn: taskSN };
        $http.post('LegalUI.aspx/CompleteResearch', data).success(function () {
            alert("Submit Success!");
            if (typeof gridTrackingClient !== 'undefined')
                gridTrackingClient.Refresh();

        }).error(function (data) {
            alert("Fail to save data :" + JSON.stringify(data));
            console.log(data);
        });
    }

    $scope.BackToResearch = function (comments) {
        var json = JSON.stringify($scope.LegalCase);

        var data = { bble: leadsInfoBBLE, caseData: json, sn: taskSN, comments: comments };
        $http.post('LegalUI.aspx/BackToResearch', data).
            success(function () {
                alert("Submit Success!");
                if (typeof gridTrackingClient !== 'undefined')
                    gridTrackingClient.Refresh();
            }).error(function (data1) {
                alert("Fail to save data :" + JSON.stringify(data1));
                console.log(data1);
            });
    }

    $scope.CloseCase = function (comments) {
        var data = { bble: leadsInfoBBLE, comments: comments };
        $http.post('LegalUI.aspx/CloseCase', data).
            success(function () {
                alert("Submit Success!");
                if (typeof gridTrackingClient !== 'undefined')
                    gridTrackingClient.Refresh();

            }).error(function (data) {
                alert("Fail to save data :" + JSON.stringify(data));
                console.log(data);
            });
    }

    $scope.AttorneyComplete = function () {
        var json = JSON.stringify($scope.LegalCase);

        var data = { bble: leadsInfoBBLE, caseData: json, sn: taskSN };
        $http.post('LegalUI.aspx/AttorneyComplete', data).
            success(function () {
                alert("Submit Success!");
                if (typeof gridTrackingClient !== 'undefined')
                    gridTrackingClient.Refresh();

            }).
            error(function () {
                alert("Fail to save data.");
            });

    }


    $scope.LogSaveChange = function () {
        for (var i in $scope.LogChange) {
            var changeObject = $scope.LogChange[i];
            var old = changeObject.old;
            var now = changeObject.now()
            if (old != now) {
                var elem = '#LealCaseStatusData'
                var OldStatus = $(elem + ' option[value="' + old + '"]').html();
                var NowStatus = $(elem + ' option[value="' + now + '"]').html();

                if (!OldStatus)
                {
                    AddActivityLog(changeObject.msg.replace(" from", '') + ' to ' + NowStatus);
                }
                else
                {
                    AddActivityLog(changeObject.msg + OldStatus + ' to ' + NowStatus);
                }
                
                $scope.LogChange[i].old = now;
            }
        }
    }

    $scope.LoadLeadsCase = function (BBLE) {
        ptCom.startLoading();
        var data = { bble: BBLE };
        var leadsInfoUrl = "/ShortSale/ShortSaleServices.svc/GetLeadsInfo?bble=" + BBLE;
        var shortsaleUrl = '/ShortSale/ShortSaleServices.svc/GetCaseByBBLE?bble=' + BBLE;
        var taxlienUrl = '/api/TaxLiens/' + BBLE;
        var legalecoursUrl = "/api/LegalECourtByBBLE/" + BBLE;

        $http.post('LegalUI.aspx/GetCaseData', data).
            success(function (data, status, headers, config) {
                $scope.LegalCase = $.parseJSON(data.d);
                $scope.LegalCase.BBLE = BBLE
                $scope.LegalCase.LegalComments = $scope.LegalCase.LegalComments || [];
                $scope.LegalCase.ForeclosureInfo = $scope.LegalCase.ForeclosureInfo || {};
                $scope.LogChange = {
                    'TaxLienFCStatus': { "old": $scope.LegalCase.TaxLienFCStatus, "now": function () { return $scope.LegalCase.TaxLienFCStatus; }, "msg": 'Tax Lien FC status changed from ' },
                    'CaseStauts': { "old": $scope.LegalCase.CaseStauts, "now": function () { return $scope.LegalCase.CaseStauts; }, "msg": 'Mortgage foreclosure status changed from ' }
                }

                var arrays = ["AffidavitOfServices", "Assignments", "MembersOfEstate"];
                for (a in arrays) {
                    var porp = arrays[a]
                    var array = $scope.LegalCase.ForeclosureInfo[porp];
                    if (!array || array.length === 0) {
                        $scope.LegalCase.ForeclosureInfo[porp] = [];
                        $scope.LegalCase.ForeclosureInfo[porp].push({});
                    }
                }
                $scope.LegalCase.SecondaryTypes = $scope.LegalCase.SecondaryTypes || []
                $scope.showSAndCFrom();

                LegalCaseBBLE = BBLE;
                ptCom.stopLoading();

                ResetCaseDataChange();
                CaseNeedComment = true;
            }).
            error(function () {
                ptCom.stopLoading();
                alert("Fail to load data : " + BBLE);
            });


        $http.get(shortsaleUrl)
            .success(function (data) {
                $scope.ShortSaleCase = data;
            }).error(function () {
                alert("Fail to Short sale case  data : " + BBLE);
            });
    


        $http.get(leadsInfoUrl)
            .success(function (data) {
                $scope.LeadsInfo = data;
                $scope.LPShow = $scope.ModelArray('LeadsInfo.LisPens');
            }).error(function (data) {
                alert("Get Short Sale Leads failed BBLE =" + BBLE + " error : " + JSON.stringify(data));
            });

        $http.get(taxlienUrl)
            .success(function (data) {
                $scope.TaxLiens = data;
                $scope.TaxLiensShow = $scope.ModelArray('TaxLiens');
            }).error(function (data) {
                alert("Get Tax Liens failed BBLE = " + BBLE + " error : " + JSON.stringify(data));
            });

        $http.get(legalecoursUrl)
            .success(function (data) {
                $scope.LegalECourt = data;
            }).error(function () {
                $scope.LegalECourt = null;
            });

    }

    $scope.ModelArray = function (model) {
        var array = $scope.$eval(model);
        return (array && array.length > 0) ? 'Yes' : '';
    }

    // return true it hight light check date  
    $scope.HighLightFunc = function (funcStr) {
        var args = funcStr.split(",");

    }

    $scope.AddSecondaryArray = function () {
        var selectType = $scope.LegalCase.SecondaryInfo.SelectedType;
        if (selectType) {
            var name = selectType.replace(/\s/g, '');
            var arr = $scope.LegalCase.SecondaryInfo[name];
            if (name === 'StatuteOfLimitations') {
                alert('match');
            }
            if (!arr || !Array.isArray($scope.LegalCase.SecondaryInfo[name])) {
                $scope.LegalCase.SecondaryInfo[name] = [];
                //arr = $scope.LegalCase.SecondaryInfo[name];
            }
            $scope.LegalCase.SecondaryInfo[name].push({});
            //$scope.LegalCase.SecondaryInfo.StatuteOfLimitations.push({});
        }
    }
    $scope.LegalCase.SecondaryInfo.SelectedType = $scope.SecondaryTypeSource[0];
    $scope.SecondarySelectType = function () {
        $scope.LegalCase.SecondaryInfo.SelectTypes = $scope.LegalCase.SecondaryInfo.SelectTypes || [];
        var selectTypes = $scope.LegalCase.SecondaryInfo.SelectTypes;
        if (!_.contains(selectTypes, $scope.LegalCase.SecondaryInfo.SelectedType)) {
            selectTypes.push($scope.LegalCase.SecondaryInfo.SelectedType);
        }

    }
    $scope.CheckShow = function (filed) {
        if (typeof LegalShowAll === 'undefined' || LegalShowAll === null) {
            return true;
        }
        if ($scope.LegalCase.SecondaryInfo) {
            return $scope.LegalCase.SecondaryInfo.SelectedType == filed;
        }

        return false;
    }

    $scope.SaveLegalJson = function () {
        $scope.LegalCaseJson = JSON.stringify($scope.LegalCase)
    }

    $scope.ShowContorl = function (m) {
        var t = typeof m;
        if (t === "string") {
            return m === 'true'
        }
        return m;

    }

    $scope.DocGenerator = function (tplName) {
        if (!$scope.LegalCase.SecondaryInfo) {
            $scope.LegalCase.SecondaryInfo = {}
        }
        var Tpls = [{
            "tplName": 'OSCTemplate.docx',
            data: {
                "Plantiff": $scope.LegalCase.ForeclosureInfo.Plantiff,
                "PlantiffAttorney": $scope.LegalCase.ForeclosureInfo.PlantiffAttorney,
                "PlantiffAttorneyAddress": $scope.LegalCase.ForeclosureInfo.PlantiffAttorneyAddress,//ptContactServices.getContact($scope.LegalCase.ForeclosureInfo.PlantiffAttorneyId, $scope.LegalCase.ForeclosureInfo.PlantiffAttorney).Address,
                "FCFiledDate": $scope.LegalCase.ForeclosureInfo.FCFiledDate,
                "FCIndexNum": $scope.LegalCase.ForeclosureInfo.FCIndexNum,
                "BoroughName": $scope.LeadsInfo.BoroughName,
                "Block": $scope.LeadsInfo.Block,
                "Lot": $scope.LeadsInfo.Lot,
                "Defendant": $scope.LegalCase.SecondaryInfo.Defendant,

                "Defendants": $scope.LegalCase.SecondaryInfo.OSC_Defendants ? ',' + $scope.LegalCase.SecondaryInfo.OSC_Defendants.map(function (o) { return o.Name }).join(",") : ' ',
                "DefendantAttorneyName": $scope.LegalCase.SecondaryInfo.DefendantAttorneyName,
                "DefendantAttorneyPhone": ptContactServices.getContact($scope.LegalCase.SecondaryInfo.DefendantAttorneyId, $scope.LegalCase.SecondaryInfo.DefendantAttorneyName).OfficeNO,
                "DefendantAttorneyAddress": ptContactServices.getContact($scope.LegalCase.SecondaryInfo.DefendantAttorneyId, $scope.LegalCase.SecondaryInfo.DefendantAttorneyName).Address,
                "CourtAddress": $scope.GetCourtAddress($scope.LeadsInfo.Borough),
                "PropertyAddress": $scope.LeadsInfo.PropertyAddress,

            }
        },
        {
            "tplName": 'DeedReversionTemplate.docx',
            data: {
                "Plantiff": $scope.LegalCase.SecondaryInfo.DeedReversionPlantiff,
                "PlantiffAttorney": $scope.LegalCase.SecondaryInfo.DeedReversionPlantiffAttorney,
                "PlantiffAttorneyAddress": $scope.ptContactServices.getContact($scope.LegalCase.SecondaryInfo.DeedReversionPlantiffAttorneyId, $scope.LegalCase.SecondaryInfo.DeedReversionPlantiffAttorney).Address,
                "PlantiffAttorneyPhone": $scope.ptContactServices.getContact($scope.LegalCase.SecondaryInfo.DeedReversionPlantiffAttorneyId, $scope.LegalCase.SecondaryInfo.DeedReversionPlantiffAttorney).OfficeNO,
                "IndexNum": $scope.LegalCase.SecondaryInfo.DeedReversionIndexNum || ' ',
                "BoroughName": $scope.LeadsInfo.BoroughName,
                "Block": $scope.LeadsInfo.Block,
                "Lot": $scope.LeadsInfo.Lot,
                "Defendant": $scope.LegalCase.SecondaryInfo.DeedReversionDefendant,
                "Defendants": $scope.LegalCase.SecondaryInfo.DeedReversionDefendants ? ',' + $scope.LegalCase.SecondaryInfo.DeedReversionDefendants.map(function (o) { return o.Name }).join(",") : ' ',
                "CourtAddress": $scope.GetCourtAddress($scope.LeadsInfo.Borough),
                "PropertyAddress": $scope.LeadsInfo.PropertyAddress,

            },


        },
        {
            "tplName": 'SpecificPerformanceComplaintTemplate.docx',
            data: {
                "Plantiff": $scope.LegalCase.SecondaryInfo.SPComplaint_Plantiff,
                "PlantiffAttorney": $scope.LegalCase.SecondaryInfo.SPComplaint_PlantiffAttorney,
                "PlantiffAttorneyAddress": $scope.ptContactServices.getContact($scope.LegalCase.SecondaryInfo.SPComplaint_PlantiffAttorneyId, $scope.LegalCase.SecondaryInfo.SPComplaint_PlantiffAttorney).Address,
                "PlantiffAttorneyPhone": $scope.ptContactServices.getContact($scope.LegalCase.SecondaryInfo.SPComplaint_PlantiffAttorneyId, $scope.LegalCase.SecondaryInfo.SPComplaint_PlantiffAttorney).OfficeNO,
                "IndexNum": $scope.LegalCase.SecondaryInfo.SPComplaint_IndexNum || ' ',
                "BoroughName": $scope.LeadsInfo.BoroughName,
                "Block": $scope.LeadsInfo.Block,
                "Lot": $scope.LeadsInfo.Lot,
                "Defendant": $scope.LegalCase.SecondaryInfo.SPComplaint_Defendant,
                "Defendants": $scope.LegalCase.SecondaryInfo.SPComplaint_Defendants ? ',' + $scope.LegalCase.SecondaryInfo.SPComplaint_Defendants.map(function (o) { return o.Name }).join(",") : ' ',
                "CourtAddress": $scope.GetCourtAddress($scope.LeadsInfo.Borough),
                "PropertyAddress": $scope.LeadsInfo.PropertyAddress,
            },

        },
        {
            "tplName": 'QuietTitleComplantTemplate.docx',
            data: {
                "Plantiff": $scope.LegalCase.SecondaryInfo.QTA_Plantiff,
                "PlantiffAttorney": $scope.LegalCase.SecondaryInfo.QTA_PlantiffAttorney,
                "PlantiffAttorneyAddress": $scope.ptContactServices.getContact($scope.LegalCase.SecondaryInfo.QTA_PlantiffAttorneyId, $scope.LegalCase.SecondaryInfo.QTA_PlantiffAttorney).Address,
                "PlantiffAttorneyPhone": $scope.ptContactServices.getContact($scope.LegalCase.SecondaryInfo.QTA_PlantiffAttorneyId, $scope.LegalCase.SecondaryInfo.QTA_PlantiffAttorney).OfficeNO,
                "OriginalMortgageLender": $scope.LegalCase.SecondaryInfo.QTA_OrgMorgLender,
                "Mortgagee": $scope.LegalCase.SecondaryInfo.QTA_Mortgagee,
                "IndexNum": $scope.LegalCase.SecondaryInfo.QTA_IndexNum || ' ',
                "BoroughName": $scope.LeadsInfo.BoroughName,
                "Block": $scope.LeadsInfo.Block,
                "Lot": $scope.LeadsInfo.Lot,
                "Defendant": $scope.LegalCase.SecondaryInfo.QTA_Defendant,
                "Defendant2": $scope.LegalCase.SecondaryInfo.QTA_Defendant2,
                "Defendants": $scope.LegalCase.SecondaryInfo.QTA_Defendants ? ',' + $scope.LegalCase.SecondaryInfo.QTA_Defendants.map(function (o) { return o.Name }).join(",") : ' ',
                "CourtAddress": $scope.GetCourtAddress($scope.LeadsInfo.Borough),
                "PropertyAddress": $scope.LeadsInfo.PropertyAddress,
                "FCFiledDate": $scope.LegalCase.ForeclosureInfo.FCFiledDate,
                "FCIndexNum": $scope.LegalCase.ForeclosureInfo.FCIndexNum,
                "DefaultDate": $scope.LegalCase.ForeclosureInfo.QTA_DefaultDate,
                "DeedToPlaintiffDate": $scope.LegalCase.SecondaryInfo.QTA_DeedToPlaintiffDate,
            },

        },
        {
            "tplName": 'Partition_Temp.docx',
            data: {
                "Plantiff": $scope.LegalCase.SecondaryInfo.PartitionsPlantiff,
                "PlantiffAttorney": $scope.LegalCase.SecondaryInfo.PartitionsPlantiffAttorney,
                "PlantiffAttorneyAddress": $scope.ptContactServices.getContact($scope.LegalCase.SecondaryInfo.PartitionsPlantiffAttorneyId, $scope.LegalCase.SecondaryInfo.PartitionsPlantiffAttorney).Address,
                "PlantiffAttorneyPhone": $scope.ptContactServices.getContact($scope.LegalCase.SecondaryInfo.PartitionsPlantiffAttorneyId, $scope.LegalCase.SecondaryInfo.PartitionsPlantiffAttorney).OfficeNO,
                "OriginalMortgageLender": $scope.LegalCase.SecondaryInfo.PartitionsOriginalLender,
                "MortgageDate": $scope.LegalCase.SecondaryInfo.PartitionsMortgageDate,
                "IndexNum": $scope.LegalCase.SecondaryInfo.PartitionsIndexNum || ' ',
                "BoroughName": $scope.LeadsInfo.BoroughName,
                "Block": $scope.LeadsInfo.Block,
                "Lot": $scope.LeadsInfo.Lot,
                "Defendant": $scope.LegalCase.SecondaryInfo.PartitionsDefendant,
                "Defendant1": $scope.LegalCase.SecondaryInfo.PartitionsDefendant1,

                "PropertyAddress": $scope.LeadsInfo.PropertyAddress,
                "MortgageAmount": $scope.LegalCase.SecondaryInfo.PartitionsMortgageAmount,
                "DateOfRecording": $scope.LegalCase.SecondaryInfo.PartitionsDateOfRecording,
                "CRFN": $scope.LegalCase.SecondaryInfo.PartitionsCRFN,
                "OriginalLender": $scope.LegalCase.SecondaryInfo.PartitionsOriginalLender,


            },

        }
        ];
        var tpl = Tpls.filter(function (o) { return o.tplName == tplName })[0]

        if (tpl) {
            for (var v in tpl.data) {
                var filed = tpl.data[v];
                if (!filed) {
                    alert("Some data missing please check " + v + "Please check!")
                    return;
                }
            }
            ptCom.DocGenerator(tpl.tplName, tpl.data, function (url) {
                //window.open(url,'blank');
                STDownloadFile(url, tpl.tplName.replace("Template", ""));
            });
        } else {
            alert("can find tlp " + tplName)
        }
    }

    $scope.CheckSecondaryTags = function (tag) {
        return $scope.LegalCase.SecondaryTypes.filter(function (t) { return t == tag })[0];
    }
    $scope.GetCourtAddress = function (boro) {
        var address = ['', '851 Grand Concourse Bronx, NY 10451', '360 Adams St. Brooklyn, NY 11201', '8811 Sutphin Boulevard, Jamaica, NY 11435'];
        return address[boro - 1];
    }
    $scope.hSummery = [
                    {
                        "Name": "CaseStauts",
                        "CallFunc": "HighLightStauts(LegalCase.CaseStauts,4)",
                        "Description": "Last milestone document recorded on Clerk Minutes after O/REF. ",
                        "ArrayName": ""
                    },
                    {
                        "Name": "EveryOneIn",
                        "CallFunc": "LegalCase.ForeclosureInfo.WasEstateFormed != null",
                        "Description": "There is an estate.",
                        "ArrayName": ""
                    },
                    {
                        "Name": "BankruptcyFiled",
                        "CallFunc": "LegalCase.ForeclosureInfo.BankruptcyFiled == true",
                        "Description": "Bankruptcy filed",
                        "ArrayName": ""
                    },
                    {
                        "Name": "Efile",
                        "CallFunc": "LegalCase.ForeclosureInfo.Efile == true",
                        "Description": "Has E-filed",
                        "ArrayName": ""
                    },
                    {
                        "Name": "EfileN",
                        "CallFunc": "LegalCase.ForeclosureInfo.Efile == false",
                        "Description": "No E-filed",
                        "ArrayName": ""
                    },
                    {
                        "Name": "ClientPersonallyServed",
                        "CallFunc": "false",
                        "Description": "Client personally is not served. ",
                        "ArrayName": "AffidavitOfServices"
                    },
                    {
                        "Name": "NailAndMail",
                        "CallFunc": "true",
                        "Description": "Nail and Mail.",
                        "ArrayName": "AffidavitOfServices"
                    },
                    {
                        "Name": "BorrowerLiveInAddrAtTimeServ",
                        "CallFunc": "false",
                        "Description": "Borrower didn\'t live in service Address at time of Serv.",
                        "ArrayName": "AffidavitOfServices"
                    },
                    {
                        "Name": "BorrowerEverLiveHere",
                        "CallFunc": "false",
                        "Description": "Borrower didn\'t ever live in service address.",
                        "ArrayName": "AffidavitOfServices"
                    },
                    {
                        "Name": "ServerInSererList",
                        "CallFunc": "true",
                        "Description": "process server is in server list.",
                        "ArrayName": "AffidavitOfServices"
                    },
                    {
                        "Name": "isServerHasNegativeInfo",
                        "CallFunc": "true",
                        "Description": "Web search provide any negative information on process server. ",
                        "ArrayName": "AffidavitOfServices"
                    },
                    {
                        "Name": "AffidavitServiceFiledIn20Day",
                        "CallFunc": "false",
                        "Description": "Affidavit of service wasn\'t file within 20 days of service.",
                        "ArrayName": "AffidavitOfServices"
                    },
                    {
                        "Name": "AnswerClientFiledBefore",
                        "CallFunc": "LegalCase.ForeclosureInfo.AnswerClientFiledBefore == false",
                        "Description": "Client hasn\'t ever filed an answer before.",
                        "ArrayName": ""
                    },
                    {
                        "Name": "NoteIsPossess",
                        "CallFunc": "LegalCase.ForeclosureInfo.NoteIsPossess == false",
                        "Description": "We Don't possess a copy of the note.",
                        "ArrayName": ""
                    },
                    {
                        "Name": "NoteEndoresed",
                        "CallFunc": "LegalCase.ForeclosureInfo.NoteEndoresed == false",
                        "Description": "Note wasn\'t endores.",
                        "ArrayName": ""
                    },
                    {
                        "Name": "NoteEndorserIsSignors",
                        "CallFunc": "LegalCase.ForeclosureInfo.NoteEndorserIsSignors == true",
                        "Description": "The endorser is in signors list.",
                        "ArrayName": ""
                    },
                    {
                        "Name": "HasDocDraftedByDOCXLLC",
                        "CallFunc": "true",
                        "Description": "There are documents drafted by DOCX LLC .",
                        "ArrayName": "Assignments"
                    },
                    {
                        "Name": "LisPendesRegDate",
                        "CallFunc": "isPassOrEqualByDays(LegalCase.ForeclosureInfo.LisPendesDate, LegalCase.ForeclosureInfo.LisPendesRegDate, 5)",
                        "Description": "Date of registration 5 days after Lis Pendens letter",
                        "ArrayName": ""
                    },
                    {
                        "Name": "AccelerationLetterMailedDate",
                        "CallFunc": "isPassOrEqualByMonths(LegalCase.ForeclosureInfo.DefaultDate,LegalCase.ForeclosureInfo.AccelerationLetterMailedDate,12 )",
                        "Description": "Acceleration letter mailed to borrower after 12 months of Default Date. ",
                        "ArrayName": ""
                    },
                    {
                        "Name": "AccelerationLetterRegDate",
                        "CallFunc": "isPassOrEqualByDays(LegalCase.ForeclosureInfo.AccelerationLetterMailedDate,LegalCase.ForeclosureInfo.AccelerationLetterRegDate,3 )",
                        "Description": "Date of registration for Acceleration letter filed  3 days after acceleration letter mailed date",
                        "ArrayName": ""
                    },
                    {
                        "Name": "AffirmationFiledDate",
                        "CallFunc": "isPassByDays(LegalCase.ForeclosureInfo.JudgementDate,LegalCase.ForeclosureInfo.AffirmationFiledDate,0)",
                        "Description": "Affirmation filed after Judgement. ",
                        "ArrayName": ""
                    },
                    {
                        "Name": "AffirmationReviewerByCompany",
                        "CallFunc": "LegalCase.ForeclosureInfo.AffirmationReviewerByCompany == false",
                        "Description": "The affirmation reviewer wasn\'t employe by the servicing company. ",
                        "ArrayName": ""
                    },
                    {
                        "Name": "MortNoteAssInCert",
                        "CallFunc": "LegalCase.ForeclosureInfo.MortNoteAssInCert == false",
                        "Description": "In the Certificate of Merit, the Mortgage, Note and Assignment aren\'t included. ",
                        "ArrayName": ""
                    },
                    {
                        "Name": "MissInCert",
                        "CallFunc": "checkMissInCertValue()",
                        "Description": "Mortgage Note or Assignment are missing. ",
                        "ArrayName": ""
                    },
                    {
                        "Name": "CertificateReviewerByCompany",
                        "CallFunc": "LegalCase.ForeclosureInfo.CertificateReviewerByCompany == false",
                        "Description": "The certificate  reviewer wasn\'t employe by the servicing company. ",
                        "ArrayName": ""
                    },
                    {
                        "Name": "LegalCase.ItemsRedacted",
                        "CallFunc": "LegalCase.ForeclosureInfo.ItemsRedacted == false",
                        "Description": "Are items of personal information Redacted.",
                        "ArrayName": ""
                    },
                    {
                        "Name": "RJIDate",
                        "CallFunc": "isPassByMonths(LegalCase.ForeclosureInfo.SAndCFiledDate, LegalCase.ForeclosureInfo.RJIDate, 12)",
                        "Description": "RJI filed after 12 months of S&C.",
                        "ArrayName": ""
                    },
                    {
                        "Name": "ConferenceDate",
                        "CallFunc": "isLessOrEqualByDays(LegalCase.ForeclosureInfo.RJIDate, LegalCase.ForeclosureInfo.ConferenceDate, 60)",
                        "Description": "Conference date scheduled 60 days before RJI",
                        "ArrayName": ""
                    },
                    {
                        "Name": "OREFDate",
                        "CallFunc": "isPassByMonths(LegalCase.ForeclosureInfo.RJIDate, LegalCase.ForeclosureInfo.OREFDate, 12)",
                        "Description": "O/REF filed after 12 months after RJI.",
                        "ArrayName": ""
                    },
                    {
                        "Name": "JudgementDate",
                        "CallFunc": "isPassByMonths(LegalCase.ForeclosureInfo.RJIDate, LegalCase.ForeclosureInfo.OREFDate, 12)",
                        "Description": "Judgement submitted 12 months after O/REF. ",
                        "ArrayName": ""
                    }];
    $scope.evalVisible = function (h) {
        var result = false;
        if (h.ArrayName) {
            if ($scope.LegalCase.ForeclosureInfo[h.ArrayName]) {
                angular.forEach($scope.LegalCase.ForeclosureInfo[h.ArrayName], function (el, idx) {
                    result = result || (el[h.Name] == (h.CallFunc === 'true'));
                })
            }
        } else {
            result = $scope.$eval(h.CallFunc);
        }
        return result;
    };
    angular.forEach($scope.hSummery, function (el, idx) {
        $scope.$watch(function () { return $scope.evalVisible(el); }, function (newV) {
            el.visible = newV;
        })

    })

    $scope.GetCaseInfo = function () {
        var CaseInfo = { Name: '', Address: '' }
        var caseName = $scope.LegalCase.CaseName
        if (caseName) {
            CaseInfo.Address = caseName.replace(/-(?!.*-).*$/, '');
            var matched = caseName.match(/-(?!.*-).*$/);
            if (matched && matched[0]) {
                CaseInfo.Name = matched[0].replace('-', '')
            }
        }
        return CaseInfo;
    }

    $scope.AddArrayItem = function (model) {
        model = model || [];
        model.push({});
    }
    $scope.DeleteItem = function (model, index) {
        model.splice(index, 1);
    }

    $scope.isLess08292013 = false;
    $scope.isBigger08302013 = false;
    $scope.isBigger03012015 = false;
    $scope.showSAndCFormFlag = false;

    $scope.showSAndCFrom = function () {
        var date = new Date($scope.LegalCase.ForeclosureInfo.SAndCFiledDate);
        if (date - new Date("08/29/2013") > 0) {
            $scope.isLess08292013 = false;
        } else {
            $scope.isLess08292013 = true;
        }
        if ($scope.isLess08292013) {
            $scope.isBigger08302013 = false;
        } else {
            $scope.isBigger08302013 = true;
        } if (date - new Date("03/01/2015") > 0) {
            $scope.isBigger03012015 = true;
        } else {
            $scope.isBigger03012015 = false;
        }
        $scope.showSAndCFormFlag = $scope.isLess08292013 | $scope.isBigger08302013 | $scope.isBigger03012015;
    };
    $scope.HighLightStauts = function (model, index) {
        return parseInt(model) > index ? true : false;
    };
    $scope.addToEstateMembers = function (index) {
        $scope.LegalCase.ForeclosureInfo.MembersOfEstate.push({ "id": index, "name": $scope.LegalCase.membersText });
        $scope.LegalCase.membersText = '';
    }
    $scope.delEstateMembers = function (index) {
        $scope.LegalCase.ForeclosureInfo.MembersOfEstate.splice(index, 1);
    }
    $scope.ShowECourts = function (borough) {
        $http.post('/CallBackServices.asmx/GetBroughName', { bro: $scope.LegalCase.PropertyInfo.Borough }).success(function (data) {
            var urls = ['http://bronxcountyclerkinfo.com/law/UI/User/lne.aspx', ' http://iapps.courts.state.ny.us/kcco/', ' https://iapps.courts.state.ny.us/qcco/'];
            var url = urls[borough - 2];
            var title = $scope.LegalCase.CaseName;
            var subTitle = ' (' + 'Brough: ' + data.d + ' Block: ' + $scope.LegalCase.PropertyInfo.Block + ' Lot: ' + $scope.LegalCase.PropertyInfo.Lot + ')';
            ShowPopupMap(url, title, subTitle);
        })

    }

    $scope.missingItems = [
        { id: 1, label: "Mortgage" },
        { id: 2, label: "Note" },
        { id: 3, label: "Assignment" },
    ];

    $scope.updateMissInCertValue = function (value) {
        $scope.LegalCase.ForeclosureInfo.MissInCert = value;
    }

    $scope.checkMissInCertValue = function () {
        if ($scope.LegalCase.ForeclosureInfo.MortNoteAssInCert) return false;
        if (!$scope.LegalCase.ForeclosureInfo.MissInCert || $scope.LegalCase.ForeclosureInfo.MissInCert.length == 0)
            return true;
        else return false;
    }

    $scope.initMissInCert = function () {
        return {
            dataSource: $scope.missingItems,
            valueExpr: 'id',
            displayExpr: 'label',
            onValueChanged: function (e) {
                e.model.updateMissInCertValue(e.values);
            }
        };
    }
    //-- end Steven code part--

    $scope.ShowAddPopUp = function (event) {
        $scope.addCommentTxt = "";
        aspxAddLeadsComments.ShowAtElement(event.target);
    }

    $scope.SaveLegalComments = function () {

        $scope.LegalCase.LegalComments.push({ id: $scope.LegalCase.LegalComments.length + 1, Comment: $scope.addCommentTxt });
        $scope.SaveLegal(function () {
            console.log("ADD comments" + $scope.addCommentTxt);
            aspxAddLeadsComments.Hide();
        });
    }

    $scope.DeleteComments = function (index) {
        $scope.LegalCase.LegalComments.splice(index, 1);
        $scope.SaveLegal(function () {
            console.log("Deleted comments");
        });
    }


    $scope.AddActivityLog = function () {
        if (typeof AddActivityLog === "function") {
            AddActivityLog($scope.MustAddedComment);
        }
    }

    $scope.CheckWorkHours = function () {
        $http.get("/api/WorkingLogs/Legal/" + $scope.LegalCase.BBLE).success(function (data) {
            $scope.TotleHours = data;
            $("#WorkPopUp").modal();
        });
    }

    $scope.showHistory = function () {
        var url = "/api/legal/SaveHistories/" + $scope.LegalCase.BBLE;
        $scope.History = [];
        $http.get(url).success(function (data) {
            $scope.History = data;
            $("#HistoryPopup").modal();
        })
    }

    $scope.loadHistoryData = function (logid) {
        if (logid) {
            var url = "/api/Legal/HistoryCaseData/" + logid;
            $http.get(url).success(function (data) {
                    $scope.LegalCase = $.parseJSON(data);
                    var BBLE = $scope.LegalCase.BBLE;
                    if (BBLE) {
                        var leadsInfoUrl = "/ShortSale/ShortSaleServices.svc/GetLeadsInfo?bble=" + BBLE;
                        var shortsaleUrl = '/ShortSale/ShortSaleServices.svc/GetCaseByBBLE?bble=' + BBLE;
                        var taxlienUrl = '/api/TaxLiens/' + BBLE;
                        var legalecoursUrl = "/api/LegalECourtByBBLE/" + BBLE;


                        $scope.LegalCase.LegalComments = $scope.LegalCase.LegalComments || [];
                        $scope.LegalCase.ForeclosureInfo = $scope.LegalCase.ForeclosureInfo || {};
                        $scope.LogChange = {
                            'TaxLienFCStatus': { "old": $scope.LegalCase.TaxLienFCStatus, "now": function () { return $scope.LegalCase.TaxLienFCStatus; }, "msg": 'Tax Lien FC Status changed from ' },
                            'CaseStauts': { "old": $scope.LegalCase.CaseStauts, "now": function () { return $scope.LegalCase.CaseStauts; }, "msg": 'Mortgae foreclosure Status changed from ' }
                        }
                        var arrays = ["AffidavitOfServices", "Assignments", "MembersOfEstate"];
                        for (a in arrays) {
                            var porp = arrays[a]
                            var array = $scope.LegalCase.ForeclosureInfo[porp];
                            if (!array || array.length === 0) {
                                $scope.LegalCase.ForeclosureInfo[porp] = [];
                                $scope.LegalCase.ForeclosureInfo[porp].push({});
                            }
                        }
                        $scope.LegalCase.SecondaryTypes = $scope.LegalCase.SecondaryTypes || []
                        $scope.showSAndCFrom();

                        $http.get(shortsaleUrl)
                            .success(function (data) {
                                $scope.ShortSaleCase = data;
                            }).error(function () {
                                alert("Fail to Short sale case  data : " + BBLE);
                            });



                        $http.get(leadsInfoUrl)
                            .success(function (data) {
                                $scope.LeadsInfo = data;
                                $scope.LPShow = $scope.ModelArray('LeadsInfo.LisPens');
                            }).error(function (data) {
                                alert("Get Short Sale Leads failed BBLE =" + BBLE + " error : " + JSON.stringify(data));
                            });

                        $http.get(taxlienUrl)
                            .success(function (data) {
                                $scope.TaxLiens = data;
                                $scope.TaxLiensShow = $scope.ModelArray('TaxLiens');
                            }).error(function (data) {
                                alert("Get Tax Liens failed BBLE = " + BBLE + " error : " + JSON.stringify(data));
                            });

                        $http.get(legalecoursUrl)
                            .success(function (data) {
                                $scope.LegalECourt = data;
                            }).error(function () {
                                $scope.LegalECourt = null;
                            });

                        LegalCaseBBLE = BBLE;
                    }
                }).error(function () {
                    alert("Fail to load data : ");
                });

        }       


    }

    $scope.openHistoryWindow = function (logid) {
        $window.open('/LegalUI/Legalinfo.aspx?logid='+logid , '_blank', 'width=1024, height=768')
    }
}]);
angular.module('PortalApp')
.controller("ReportWizardCtrl", function ($scope, $http, $timeout, ptCom) {
    $scope.camel = _.camelCase;

    $scope.step = 1;
    $scope.collpsed = [];
    $scope.CurrentQuery = null;
    $scope.reload = function (callback) {
        $scope.step = 1;
        $scope.CurrentQuery = null;
        $http.get(CUSTOM_REPORT_TEMPLATE)
            .then(function (res) {
                $scope.Fields = res.data[0].Fields;
                $scope.BaseTable = res.data[0].BaseTable;
                $scope.IncludeAppId = res.data[0].IncludeAppId;
                if (callback) callback();
            });
        $scope.loadSavedReport();
    };
    $scope.loadSavedReport = function () {
        $http.get("/api/Report/Load")
            .then(function (res) {
                $scope.SavedReports = res.data;
            });
    };
    $scope.deleteSavedReport = function (q) {
        var _confirm = confirm("Are you sure to delete?");
        if (_confirm) {
            if (q.ReportId) {
                $http({
                    method: "DELETE",
                    url: "/api/Report/Delete/" + q.ReportId,
                }).then(function (res) {
                    $scope.reload();
                    alert("Delete Success.");
                });
            } else {
                alert("Delete Fails!");
            }
        }

    }; // load saved query
    $scope.load = function (q) {
        $scope.reload(
            function () {
                if (q.ReportId) {
                    $http.get("/api/Report/Load/" + q.ReportId)
                    .then(function (res) {
                        var data = res.data;
                        $scope.CurrentQuery = data;
                        $scope.Fields = JSON.parse(data.Query);
                        $scope.generate();

                        var gridState = JSON.parse(data.Layout);
                        $("#queryReport").dxDataGrid("instance").state(gridState);
                    });
                }
            }
        );
    };
    $scope.someCheck = function (category) {
        return _.some(category.fields, { checked: true });
    };
    $scope.addFilter = function (f) {
        if (!f.filters) f.filters = [];
        f.filters.push({});
    };
    $scope.removeFilter = function (f, i) {
        f.filters.splice(i, 1);
    };
    $scope.updateStringFilter = function (x) {
        if (!x.criteria || !x.input1) {
            x.WhereTerm = "";
            x.CompareOperator = "";
            x.value1 = "";
            return;
        } else {
            switch (x.criteria) {
                case "1":
                    x.WhereTerm = "CreateCompare";
                    x.CompareOperator = "Like";
                    x.value1 = x.input1.trim() + "%";
                    break;
                case "2":
                    x.WhereTerm = "CreateCompare";
                    x.CompareOperator = "Like";
                    x.value1 = "%" + x.input1.trim();
                    break;
                case "3":
                    x.WhereTerm = "CreateCompare";
                    x.CompareOperator = "Like";
                    x.value1 = "%" + x.input1.trim() + "%";
                    break;
                default:
                    x.WhereTerm = "";
                    x.CompareOperator = "";
                    x.value1 = "";
            }
        }
    };
    $scope.updateDateFilter = function (x) {
        if (!x.criteria || !x.input1) {
            x.WhereTerm = "";
            x.CompareOperator = "";
            x.value1 = "";
            return;
        } else {
            switch (x.criteria) {
                case "1":
                    x.WhereTerm = "CreateCompare";
                    x.CompareOperator = "Less";
                    x.value1 = x.input1;
                    break;
                case "2":
                    x.WhereTerm = "CreateCompare";
                    x.CompareOperator = "Greater";
                    x.value1 = x.input1;
                    break;
                case "3":
                    x.WhereTerm = "CreateCompare";
                    x.CompareOperator = "Equal";
                    x.value1 = x.input1;
                    break;
                default:
                    x.WhereTerm = "";
                    x.CompareOperator = "";
                    x.value1 = "";
            }
        }

    };
    $scope.updateNumberFilter = function (x) {

        if (!x.criteria || !x.input1 || (x.criteria == "5" && !x.input2)) {
            x.WhereTerm = "";
            x.CompareOperator = "";
            x.value1 = "";
            x.value2 = "";
            return;
        } else {
            switch (x.criteria) {
                case "0":
                    x.WhereTerm = "CreateCompare";
                    x.CompareOperator = "Equal";
                    x.value1 = x.input1.trim();
                    x.value2 = "";
                    break;
                case "1":
                    x.WhereTerm = "CreateCompare";
                    x.CompareOperator = "Less";
                    x.value1 = x.input1.trim();
                    x.value2 = "";
                    break;
                case "2":
                    x.WhereTerm = "CreateCompare";
                    x.CompareOperator = "LessOrEqual";
                    x.value1 = x.input1.trim();
                    x.value2 = "";
                    break;
                case "3":
                    x.WhereTerm = "CreateCompare";
                    x.CompareOperator = "Greater";
                    x.value1 = x.input1.trim();
                    x.value2 = "";
                    break;
                case "4":
                    x.WhereTerm = "CreateCompare";
                    x.CompareOperator = "GreaterOrEqual";
                    x.value1 = x.input1.trim();
                    x.value2 = "";
                    break;
                case "5":
                    x.WhereTerm = "CreateBetween";
                    x.CompareOperator = "";
                    x.value1 = x.input1.trim();
                    x.value2 = x.input2.trim();
                    break;
                default:
                    x.WhereTerm = "";
                    x.CompareOperator = "";
                    x.value1 = "";
                    x.value2 = "";
            }
        }
    };
    $scope.updateListFilter = function (x) {
        if (!x.input1 || x.input1.length < 1) {
            x.WhereTerm = "";
            x.CompareOperator = "";
            x.value1 = "";
        } else {
            x.WhereTerm = "CreateIn";
            x.CompareOperator = "";
            x.value1 = x.input1;
        }
    };    
    $scope.updateBooleanFilter = function (x) {
        if (!x.input1) {
            x.WhereTerm = "";
            x.CompareOperator = "";
            x.value1 = "";
        } else {
            switch (x.input1) {
                case "1":
                    x.WhereTerm = "CreateCompare";
                    x.CompareOperator = "Equal";
                    x.value1 = true;
                    break;
                case "0":
                    x.WhereTerm = "CreateCompare";
                    x.CompareOperator = "Equal";
                    x.value1 = false;
                    break;
                default:
                    x.WhereTerm = "";
                    x.CompareOperator = "";
                    x.value1 = "";
            }
        }
    };

    $scope.onSaveQueryPopCancel = function () {
        $scope.NewQueryName = '';
        $scope.SaveQueryPop = false;
    };
    $scope.onSaveQueryPopSave = function () {
        if (!$scope.NewQueryName) {
            alert("New query name is empty!");
            $scope.NewQueryName = '';
            $scope.SaveQueryPop = false;
        } else {

            var data = {};

            data.Name = $scope.NewQueryName;

            data.Query = JSON.stringify($scope.Fields);
            data.sqlText = $scope.sqlText;
            data.Layout = JSON.stringify($("#queryReport").dxDataGrid("instance").state());

            data = JSON.stringify(data);

            $http({
                method: "POST",
                url: "/api/Report/Save",
                data: data,
            }).then(function (res) {
                $scope.NewQueryName = '';
                $scope.SaveQueryPop = false;
                $scope.reload();
                alert("Save successful!");
            });
        }
    };

    $scope.update = function () {

        var data = $scope.CurrentQuery;

        data.Query = JSON.stringify($scope.Fields);
        data.sqlText = $scope.sqlText;
        data.Layout = JSON.stringify($("#queryReport").dxDataGrid("instance").state());

        data = JSON.stringify(data);

        $http({
            method: "POST",
            url: "/api/Report/Save",
            data: data,
        }).then(function (res) {
            $scope.NewQueryName = '';
            $scope.SaveQueryPop = false;
            $scope.reload();
            alert("Save successful!");
        });
    };
    $scope.isBindColumn = function (f) {

        if (!f.table || !f.column) {
            return false;
        } else {
            return true;
        }
    };
    $scope.next = function () {
        $scope.step = $scope.step + 1;
    };
    $scope.prev = function () {
        $scope.step = $scope.step - 1;
    };
    $scope.filterDate = function (model) {
        var dtPatn = /\d{4}-\d{2}-\d{2}/;
        if (model) {
            _.each(model, function (el, idx) {
                if (el) {
                    _.forOwn(el, function (v, k) {
                        if (v && typeof (v) === 'string' && v.match(dtPatn)) {
                            el[k] = ptCom.toUTCLocaleDateString(v);
                        }
                    });
                }

            });
        }
    };
    $scope.generate = function () {
        var result = [];
        var BaseTable = $scope.BaseTable ? $scope.BaseTable : '';
        var IncludeAppId = $scope.IncludeAppId ? $scope.IncludeAppId : '';
        _.each($scope.Fields, function (el, i) {
            _.each(el.fields, function (el, i) {
                if (el.checked) {
                    result.push(el);
                }
            });
        });
        if (result.length > 0) {
            $scope.step = 3;
            $http({
                method: "POST",
                url: "/api/Report/QueryData?baseTable=" + BaseTable + "&includeAppId=" + IncludeAppId,
                data: JSON.stringify(result),
            }).then(function (res) {
                var rdata = res.data[0];
                $scope.filterDate(rdata);
                $scope.reportData = rdata;
                $scope.sqlText = res.data[1];
            });
        } else {
            alert("Query is empty!");
        }
    };
    $scope.reload();
    var PreLoadReportId = $('#txtReportID').val()
    if (PreLoadReportId>0)
    {
        $scope.LoadByID = true;
        $scope.load({ReportId: PreLoadReportId,UseSql:true})
    }
});
var i = 1;
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

        //-- auto save function, add by Chris ---
        var UpdatedProperties = ['UpdateTime', 'UpdateDate', 'UpdateBy', 'OwnerId', 'MortgageId', 'OfferId', 'ValueId', 'CallbackDate', 'LastUpdate'];
        var autoSaveError = false;

        $scope.AutoSaveShortSale = function (callback) {
            var json = $scope.SsCase;
            var data = { caseData: JSON.stringify(json) };

            $http.post('ShortSaleServices.svc/SaveCase', JSON.stringify(data)).
                    success(function (data) {
                        autoSaveError = false;
                        // Remove deleted mortgages
                        RemoveDeletedMortgages();

                        //Sync objects
                        SyncObjects(data, $scope.SsCase);

                        if (!callback) {
                            ptCom.alert("Save Successed !");
                        }

                        if (callback) { callback(); }

                    }).error(function (data1, status) {
                        if (!autoSaveError) {
                            autoSaveError = true;
                            var message = (data1 && typeof data1 == 'object' && data1.message) ? data1.message : JSON.stringify(data1);
                            ptCom.alert("Error in AutoSave. status " + status + "Error : " + message);
                        }
                    });
        };

        var RemoveDeletedMortgages = function () {
            _.remove($scope.SsCase.Mortgages, { DataStatus: 3 })
            console.log($scope.SsCase.Mortgages);
        }

        var SyncObjects = function (obj, toObj) {
            var copy = toObj;

            // Handle Date
            if (obj instanceof Date) {
                if (copy == null)
                    copy = new Date();

                copy = new Date();
                copy.setTime(obj.getTime());

                return;
            }

            // Handle Array
            if (obj instanceof Array) {
                if (copy == null)
                    copy = [];

                for (var i = 0, len = obj.length; i < len; i++) {
                    SyncObjects(obj[i], copy[i]);
                }

                return;
            }

            // Handle Object
            if (obj instanceof Object) {
                if (copy == null)
                    copy = {};

                for (var attr in obj) {
                    if (obj.hasOwnProperty(attr)) {
                        if (null == obj[attr] || "object" != typeof obj[attr]) {
                            if (typeof copy[attr] == 'undefined' || copy[attr] == null || copy[attr] != obj[attr]) {
                                if (UpdatedProperties.indexOf(attr) > 0) {
                                    //console.log("Changed: " + attr + " from " + copy[attr] + " to " + obj[attr]);
                                    copy[attr] = obj[attr];
                                }
                            }
                        }
                        else {
                            SyncObjects(obj[attr], copy[attr]);
                        }
                    }
                }

                return;
            }

            throw new Error("Unable to copy obj! Its type isn't supported.");
        }
        //--- end auto save function ---

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

angular.module("PortalApp")
.controller("TitleController", ['$scope', '$http', 'ptCom', 'ptContactServices', 'ptLeadsService', 'ptShortsSaleService', function ($scope, $http, ptCom, ptContactServices, ptLeadsService, ptShortsSaleService) {
    /* model define*/
    $scope.OwnerModel = function (name) {
        this.name = name;
        this.Mortgages = [{}];
        this.Lis_Pendens = [{}];
        this.Judgements = [{}];
        this.ECB_Notes = [{}];
        this.PVB_Notes = [{}];
        this.Bankruptcy_Notes = [{}];
        this.UCCs = [{}];
        this.FederalTaxLiens = [{}];
        this.MechanicsLiens = [{}];
        this.TaxLiensSaleCerts = [{}];
        this.VacateRelocationLiens = [{}];
        this.shownlist = [false, false, false, false, false, false, false, false, false, false, false];
    };
    $scope.FormModel = function () {
        this.FormData = {
            Comments: [],
            Owners: [new $scope.OwnerModel("Prior Owner Liens"), new $scope.OwnerModel("Current Owner Liens")],
            preclosing: {
                ApprovalData: [{}]
            },
            docs: {}
        };
    };

    $scope.StatusList = [
        {
            num: 0,
            desc: 'Initial Review'
        }, {
            num: 1,
            desc: 'Clearance'
        }
    ];
    $scope.arrayRemove = ptCom.arrayRemove;
    $scope.ptCom = ptCom;
    $scope.ptContactServices = ptContactServices;
    $scope.ensurePush = function (modelName, data) { ptCom.ensurePush($scope, modelName, data); };
    $scope.Form = new $scope.FormModel();
    $scope.ReloadedData = {};

    $scope.Load = function (data) {
        $scope.Form = new $scope.FormModel();
        $scope.ReloadedData = {};
        ptCom.nullToUndefined(data);
        $.extend(true, $scope.Form, data);
        if (!$scope.Form.FormData.Owners[0].shownlist) {
            $scope.Form.FormData.Owners[0].shownlist = [false, false, false, false, false, false, false, false, false, false, false];
            $scope.Form.FormData.Owners[1].shownlist = [false, false, false, false, false, false, false, false, false, false, false];
        }
        $scope.BBLE = data.Tag;
        if ($scope.BBLE) {
            ptLeadsService.getLeadsByBBLE($scope.BBLE, function (res) {
                $scope.LeadsInfo = res;
            });
            ptShortsSaleService.getBuyerTitle($scope.BBLE, function (error, res) {
                if (error) console.log(error);
                if (res) $scope.BuyerTitle = res.data;
            });
            $scope.getStatus($scope.BBLE);
        }
        $scope.$broadcast('ownerliens-reload');
        $scope.$broadcast('clearance-reload');
        $scope.$broadcast('titledoc-reload')

        $scope.checkReadOnly(TitleControlReadOnly);
        $scope.$apply();
    };
    $scope.Get = function (isSave) {
        if (isSave) {
            $scope.updateBuyerTitle();
        }
        return $scope.Form;
    }; /* end convention function */

    $scope.checkReadOnly = function (ro) {

        if (ro) {
            $("#TitleUIContent input").attr("disabled", true);
            if ($("#TitleROBanner").length == 0) {
                $("#title_prioity_content").before("<div class='barner-warning text-center' id='TitleROBanner' >Readonly</div>");
            }

        }
    };
    $scope.completeCase = function () {
        if ($scope.CaseStatus != 1 && $scope.BBLE) {
            ptCom.confirm("You are going to complated the case?", "")
                .then(function (r) {
                    if (r) {
                        $http({
                            method: 'POST',
                            url: '/api/Title/Completed',
                            data: JSON.stringify($scope.BBLE)
                        }).then(function success() {
                            $scope.CaseStatus = 1;
                            $scope.Form.FormData.CompletedDate = new Date();
                            ptCom.alert("The case have moved to Completed");
                        }, function error() { });
                    }
                });
        } else if ($scope.BBLE) {
            ptCom.confirm("You are going to uncomplated the case?", "")
                .then(function (r) {
                    if (r) {
                        $http({
                            method: 'POST',
                            url: '/api/Title/UnCompleted',
                            data: JSON.stringify($scope.BBLE)
                        }).then(function success() {
                            $scope.CaseStatus = -1;
                            ptCom.alert("Uncomplete case successful");
                        }, function error() { });
                    }
                });
        }
    };
    $scope.updateCaseStatus = function () {
        if ($scope.CaseStatus && $scope.BBLE) {
            $scope.ChangeStatusIsOpen = false;
            ptCom.confirm("You are going to change case status?", "")
               .then(function (r) {
                   if (r) {
                       $http({
                           method: 'POST',
                           url: '/api/Title/UpdateStatus?bble=' + $scope.BBLE,
                           data: JSON.stringify($scope.CaseStatus)
                       }).then(function success() {
                           ptCom.alert("The case status has changed!");
                       }, function error() { });
                   }
               });
        }
    };
    $scope.getStatus = function (bble) {
        $http.get('/api/Title/GetCaseStatus?bble=' + bble)
        .then(function succ(res) {
            $scope.CaseStatus = res.data;
        }, function error() {
            $scope.CaseStatus = -1;
            console.log("get status error");
        });
    };
    $scope.generateXML = function () {
        $http({
            url: "/api/Title/GenerateExcel",
            method: "POST",
            data: JSON.stringify($scope.Form)
        }).then(function (res) {
            STDownloadFile("/api/Title/GetGeneratedExcel", "titlereport.xlsx");
        });
    };
    $scope.updateBuyerTitle = function () {
        var updateFlag = false;
        var data = $scope.BuyerTitle;
        var newdata = $scope.Form.FormData.info;
        if (data && newdata) {

            if (newdata.Company != data.CompanyName) {
                data.CompanyName = newdata.Company;
                updateFlag = true;
            }

            if (newdata.Title_Num != data.OrderNumber) {
                data.OrderNumber = newdata.Title_Num;
                updateFlag = true;
            }

            if (ptCom.toUTCLocaleDateString(newdata.Order_Date) != ptCom.toUTCLocaleDateString(data.ReportOrderDate)) {
                updateFlag = true;
            }
            data.ReportOrderDate = newdata.Order_Date;

            if (ptCom.toUTCLocaleDateString(newdata.Confirmation_Date) != ptCom.toUTCLocaleDateString(data.ConfirmationDate)) {
                updateFlag = true;
            }
            data.ConfirmationDate = newdata.Confirmation_Date;

            if (ptCom.toUTCLocaleDateString(newdata.Received_Date) != ptCom.toUTCLocaleDateString(data.ReceivedDate)) {
                updateFlag = true;
            }
            data.ReceivedDate = newdata.Received_Date;

            if (ptCom.toUTCLocaleDateString(newdata.Initial_Reivew_Date) != ptCom.toUTCLocaleDateString(data.ReviewedDate)) {
                updateFlag = true;
            }
            data.ReviewedDate = newdata.Initial_Reivew_Date;

            if (updateFlag) {
                $http({
                    url: "/api/ShortSale/UpdateBuyerTitle",
                    method: 'POST',
                    data: JSON.stringify(data)
                }).then(function succ(res) {
                    if (!res) console.log("fail to update buyertitle");
                }
                , function error() {
                    console.log("fail to update buyertitle");
                });
            }
        }
    };
}])
.controller("TitleCommentCtrl", ['$scope', function ($scope) {
    $scope.showPopover = function (e) {
        aspxConstructionCommentsPopover.ShowAtElement(e.target);
    };
    $scope.addComment = function (comment, user) {
        var newComments = {};
        newComments.comment = comment;
        newComments.caseId = $scope.CaseId;
        newComments.createBy = user;
        newComments.createDate = new Date();
        $scope.Form.FormData.Comments.push(newComments);
    };
    $scope.addCommentFromPopup = function (user) {
        var comment = $scope.addCommentTxt;
        $scope.addComment(comment, user);
        $scope.addCommentTxt = '';
    };
    $scope.$on('titleComment', function (e, args) {
        $scope.addComment(args.message);
    }); /* end comments */
}])
.controller('TitleLienCtrl', ['$scope', 'ptCom', '$timeout', function ($scope, ptCom, $timeout) {
    $scope.Form = $scope.$parent.Form;
    $scope.OwnerLienPopup = [false, false];

    $scope.reload = function () {
        $scope.Form = $scope.$parent.Form;
        $scope.OwnerLienPopup = [false, false];
    }

    $scope.setPopVisible = function (model, step, index) {
        $scope.OwnerLienPopup[index] = true;
        model.popStep = step ? step : 0;

    }

    $scope.setPopHide = function (model, index) {
        $scope.OwnerLienPopup[index] = false;
        model.popStep = 0;
    }

    $scope.showWatermark = function (model) {
        var result = true;
        _.each(model, function (n) {
            result &= !n;
        });
        return result;
    }

    $scope.showNext = function (model) {
        var step = model.popStep;
        return ptCom.next(model.shownlist, true, step) >= 0;
    }
    $scope.next = function (model, index) {
        var step = model.popStep;
        if ($scope.showNext(model)) {
            model.popStep = ptCom.next(model.shownlist, true, step) + 1;
        } else {
            $scope.setPopHide(model, index);
        }

    }
    $scope.showPrevious = function (model) {
        var step = model.popStep;
        return ptCom.previous(model.shownlist, true, step) >= 0;
    }

    $scope.previous = function (model, index) {
        var step = model.popStep;
        if ($scope.showPrevious(model)) {
            model.popStep = ptCom.previous(model.shownlist, true, step - 1) + 1;
        } else {
            $scope.setPopHide(model, index);
        }
    }

    $scope.$on('ownerliens-reload', function (e, args) {
        $scope.reload();
    });
    $scope.swapOwnerPos = function (index) {
        $timeout(function () {
            var temp1 = $scope.Form.FormData.Owners[index];
            $scope.Form.FormData.Owners[index] = $scope.Form.FormData.Owners[index - 1];
            $scope.Form.FormData.Owners[index - 1] = temp1;
        });
    };
}])
.controller('TitleFeeClearanceCtrl', ['$scope', function ($scope) {
    var FeeClearanceModel = function () {
        this.data = [
            {
                name: 'Purchase Price',
                cost: 0.0,
                lastupdate: null, note: ''

            },
            {
                name: '2nd Lien',
                cost: 0.0,
                lastupdate: null, note: ''
            },
            {
                name: 'Taxes due',
                cost: 0.0,
                lastupdate: null, note: ''
            },
            {
                name: 'Water',
                cost: 0.0,
                lastupdate: null, note: ''
            },
            {
                name: 'Multi Dwelling',
                cost: 0.0,
                lastupdate: null, note: ''

            },
            {
                name: 'PVB',
                cost: 0.0,
                lastupdate: null, note: ''
            },
            {
                name: 'ECBS',
                cost: 0.0,
                lastupdate: null, note: ''
            },
            {
                name: 'Judgments',
                cost: 0.0,
                lastupdate: null, note: ''
            },
            {
                name: 'Taxes on HUD',
                cost: 0.0,
                lastupdate: null, note: ''
            },
            {
                name: 'Water on HUD',
                cost: 0.0,
                lastupdate: null, note: ''
            },
            {
                name: 'HPD on HUD',
                cost: 0.0,
                lastupdate: null, note: ''
            },
            {
                name: 'ECB on hud',
                cost: 0.0,
                lastupdate: null, note: ''
            }],
        this.total = 0.0

    }

    $scope.FormData = $scope.$parent.Form.FormData;
    $scope.FormData.FeeClearance = new FeeClearanceModel();
    $scope.reload = function () {
        $scope.FormData = $scope.$parent.Form.FormData;
        if ($scope.$parent.Form.FormData.FeeClearance) {
            $scope.FormData.FeeClearance = $scope.FormData.FeeClearance;
        } else {
            $scope.FormData.FeeClearance = new FeeClearanceModel();
        }
    }
    $scope.updateTotal = function (d) {
        d.lastupdate = new Date();
        var total = 0.0;
        _.each($scope.FormData.FeeClearance.data, function (el, idx) {

            if (typeof el.cost == 'string' && el.cost.length > 0) {
                el.cost = el.cost.replace(/[^0-9|\.|\-|\+]/, '');
            }

            total += parseFloat(el.cost) ? parseFloat(el.cost) : 0.0;
        })
        $scope.FormData.FeeClearance.total = total;
    }
    $scope.$on('clearance-reload', function (e, args) {
        $scope.reload();
    })
}])
.controller("TitleDocCtrl", ['$scope', '$http', 'ptCom', function ($scope, $http, ptCom) {
    $scope.transferors = [
        {
            name: 'Ron Borovinsky'
        }, {
            name: 'Jay Gottlieb'
        }, {
            name: 'Princess Simeon'
        }, {
            name: 'Eliezer Herts'
        }, {
            name: 'Magda Brillite'
        }, {
            name: 'Tomer Aronov'
        }, {
            name: 'Moisey Iskhakov'
        }, {
            name: 'Albert Gavriyelov'
        }, {
            name: 'Yvette Guizie'
        }, {
            name: 'Michael Gendin'
        }, {
            name: 'Rosanne Alicea'
        }
    ]
    $scope.data = $scope.$parent.Form.FormData.docs;
    $scope.ReloadedData = {};

    $scope.generatePackage = function () {
        $("#generatedDocsLink").hide()
        $("#generatedDocWarning").hide()
        ptCom.startLoading();

        $http({
            url: "/api/Title/GeneratePakcage",
            method: "POST",
            data: $scope.data
        }).then(function (res) {
            ptCom.stopLoading();
            if (res.data.length > 0) {
                $("#generatedDocsLink").show();
            } else {
                $("#generatedDocWarning").show();
            }
        }, function () {
            ptCom.stopLoading();
            $("#generatedDocWarning").show();
        })
    }

    $scope.$on('titledoc-reload', function (e, args) {
        $scope.data = $scope.$parent.Form.FormData.docs;
        $scope.ReloadedData = {};
    })


}])
angular.module("PortalApp")
    .controller('VendorCtrl', ["$scope", "$http" ,"$element", function ($scope, $http, $element) {

    $($('[title]')).tooltip({
        placement: 'bottom'
    });
    $scope.popAddgroup = function (Id) {
        $scope.AddGroupId = Id;
        $('#AddGroupPopup').modal();
    }
    $scope.AddGroups = function () {
        $http.post('/CallBackServices.asmx/AddGroups', { gid: $scope.AddGroupId, groupName: $scope.addGroupName, addUser: $('#CurrentUser').val() }).
           success(function (data) {
               $scope.initGroups();
           });
    }
    $scope.ChangeGroups = function (g) {

        $scope.selectType = g.Id == null ? "All Vendors" : g.GroupName;
        if (g.Id == null) {
            g.Id = 0;
        }
        $http.post('/CallBackServices.asmx/GetContactByGroup', { gId: g.Id }).
            success(function (data) {
                $scope.InitDataFunc(data);
            });
    };
    $scope.InitData = function (data) {
        $scope.allContacts = data.slice();
        var gropData = data;//groupBy(data, group_func);
        $scope.showingContacts = gropData;

        return gropData;
    }
    $scope.initGroups = function () {
        $http.post('/CallBackServices.asmx/GetAllGroups', {}).
         success(function (data, status, headers, config) {
             $scope.Groups = data.d;
             
         }).error(function (data, status, headers, config) {


             alert("error get GetAllGroups: " + status + " error :" + data.d);
         });
    }

    $scope.initGroups();
    $scope.InitDataFunc = function (data) {
        var gropData = $scope.InitData(data.d);
        //debugger;
        var allContacts = gropData;
        if (allContacts.length > 0) {
            $scope.currentContact = gropData[0];
            m_current_contact = $scope.currentContact;

        }
    }
    $http.post('/CallBackServices.asmx/GetContact', { p: '1' }).
        success(function (data, status, headers, config) {
            $scope.InitDataFunc(data);
            $scope.AllTest = data.d;

        }).error(function (data, status, headers, config) {
            $scope.LogError = data
            alert("error get contacts: " + status + " error :" + data.d);
        });

    $scope.initLenderList = function () {
        $http.post('/CallBackServices.asmx/GetLenderList', {}).success(function (data, status) {
            $scope.lenderList = _.uniq(data.d);
        });
    }

    $scope.initLenderList();

    $scope.predicate = "Name";
    $scope.group_text_order = "group_text";
    $scope.addContact = {};
    $scope.selectType = "All Vendors";
    $scope.query = {};
    $scope.addContactFunc = function () {
        var addType = $scope.query.Type;
        if (!$scope.addContact || !$scope.addContact.Name) {
            alert("Please fill vender Name !");
            return;
        }
        if (addType != null) {
            $scope.addContact.Type = addType;


        }
        var addC = $scope.addContact;
        //addC.OfficeNO = $('#txtOffice').val();
        //addC.Cell = $('#txtCell').val();
        //addC.Email = $('#txtEmail').val();

        debugger;
        $http.post("/CallBackServices.asmx/AddContact", { contact: $scope.addContact }).
        success(function (data, status, headers, config) {
            // this callback will be called asynchronously
            // when the response is available
            if (data.d.Name == 'Same')
            {
                alert("Already have " + $scope.addContact.Name + " in system please change name to identify !")
                return;
            }
            $scope.allContacts.push(data.d);
            $scope.InitData($scope.allContacts);
            var addContact = data.d;
            //debugger;

            $scope.currentContact = addContact;
            m_current_contact = $scope.currentContact;
            $scope.initLenderList();
            var stop = $(".popup_employee_list_item_active:first").position().top;
            $('#employee_list').scrollTop(stop);
            alert("Add" + $scope.currentContact.Name + " succeed !");
            //debugger;
        }).
        error(function (data, status, headers, config) {
            // called asynchronously if an error occurs
            // or server returns response with an error status.
            var message = data&& data.Message ?data.Message :JSON.stringify(data)

            alert("Add contact error: " + message);
        });
    }
    
    $scope.filterContactFunc = function (e, type) {
        //$(e).parent().find("li").removeClass("popup_menu_list_item_active");
        //$(e).addClass("popup_menu_list_item_active");

        var text = angular.element(e.currentTarget).html();
        //debugger;
        if (typeof (type) == 'string') {
            $scope.query = {};
            $scope.selectType = text;
            return true;
        } else {
            $scope.query.Type = type;
        }

        var corpName = type == 4 && text != 'Lenders' ? text : '';
        $scope.query.CorpName = corpName;


        $scope.addContact.CorpName = corpName;

        $scope.selectType = text;
        return true;
    }

    $scope.SaveCurrent = function () {
        
        $http.post("/CallBackServices.asmx/SaveContact", { json: $scope.currentContact }).
        success(function (data, status, headers, config) {
            alert("Save succeed!");
            $scope.initLenderList();
        }).
        error(function (data, status, headers, config) {
            alert("geting SaveCurrent error" + status + "error:" + JSON.stringify(data.d));
        });
    }

    $scope.FilterContact = function (type) {
        $scope.showingContacts = $scope.allContacts;
        if (type < 0) {
            return;
        }
        var contacts = $scope.allContacts;

        for (var i = 0; i < contacts.length; i++) {
            if (contacts.Type != type) {
                $scope.showingContacts.splice(i, 1);
            }

        }

    }
    $scope.selectCurrent = function (selectContact) {
        $scope.currentContact = selectContact;
        m_current_contact = selectContact;
    }

}]);