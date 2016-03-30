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