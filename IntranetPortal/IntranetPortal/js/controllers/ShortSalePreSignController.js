var portalApp = angular.module('PortalApp');

portalApp.config(function (portalUIRouteProvider) {

    portalUIRouteProvider
        .statesFor('newoffer')
    //$stateProvider
    //  // router /#/newoffer
    //  .state('newoffer', {
    //      url: "/newoffer",
    //      templateUrl: "/js/views/newoffer/index.tpl.html"
    //  })
    //  // router /#/newoffer
    //  .state('newoffer.newoffer', {
    //      url: "/newoffer",
    //      templateUrl: "/js/views/newoffer/newoffer.tpl.html"
    //  }).state('newoffer.ssinfo', {
    //      url: "/ssinfo",
    //      templateUrl: "/js/views/newoffer/ssinfo.tpl.html"
    //  });

});


portalApp.controller('newofferNewofferCtrl', function ($scope) {
    $scope.text = 'newofferNewofferCtrl';
});
portalApp.controller('newofferSsinfoCtrl', function ($scope) {
    $scope.text = 'newofferSsinfoCtrl';
});
portalApp.controller('newofferCtrl', function ($scope) {
    $scope.text = 'newofferCtrl';
});

/*************old style without model contoller *********************/
ScopeHelper = {
    getShortSaleScope: function () {

        //return angular.element(document.getElementById('ShortSaleCtrl')).scope();
        return ScopeHelper.getScope('ShortSaleCtrl');
    },
    getLeadsSearchScope: function () {
        return ScopeHelper.getScope('LeadTaxSearchCtrl');
    },
    getScope: function (id) {
        return angular.element(document.getElementById(id)).scope();
    }
};

var portalApp = angular.module('PortalApp');

portalApp.controller('shortSalePreSignCtrl', function ($scope, ptCom, $http, ptContactServices, DocSearch, $location,PropertyOffer) {

    $scope.ptContactServices = ptContactServices;
    $scope.QueryUrl = PortalUtility.QueryUrl();

    if ($scope.QueryUrl.model == 'List') {
        $http.get('/api/PropertyOffer').success(function (data) {
            $scope.newOfferGridOpt = {
                dataSource: data,
                headerFilter: {
                    visible: true
                },
                searchPanel: {
                    visible: true,
                    width: 250
                },
                paging: {
                    pageSize: 10
                },
                columnAutoWidth: true,
                wordWrapEnabled: true,
                onRowPrepared: function (rowInfo) {
                    if (rowInfo.rowType != 'data')
                        return;
                    rowInfo.rowElement
                        .addClass('myRow');
                },
                columns: [{
                    dataField: 'Title',
                    caption: 'Address',
                    cellTemplate: function (container, options) {
                        $('<a/>').addClass('dx-link-MyIdealProp')
                            .text(options.value)
                            .on('dxclick', function () {
                                //Do something with options.data;
                                //ShowCaseInfo(options.data.BBLE);
                                var request = options.data;

                                PortalUtility.ShowPopWindow("New Offer", "/NewOffer/ShortSaleNewOffer.aspx?BBLE=" + request.BBLE);
                            })
                            .appendTo(container);
                    }
                },
                    'OfferType', {
                        dataField: 'CreateBy',
                        caption: 'Submit By'
                    }, {
                        dataField: 'CreateDate',
                        caption: 'Contract Date',
                        dataType: 'date',
                        sortOrder: 'desc',
                        format: 'shortDate'
                    },
                ]
            }
        });
    }

    $scope.SSpreSign = new PropertyOffer();

    //    {
    //    Type: 'Short Sale',
    //    FormName: 'PropertyOffer',
    //    DealSheet: {
    //        ContractOrMemo: {
    //            Sellers: [{}],
    //            Buyers: [{}]
    //        },
    //        Deed: {
    //            Sellers: [{}]
    //        },
    //        CorrectionDeed: {
    //            Sellers: [{}],
    //            Buyers: [{}]
    //        }
    //    }
    //};
    //var urlParam = //$location.search(); close html model use my libary
    if (PortalUtility.QueryUrl().BBLE)
    {
        $scope.DocSearch = DocSearch.get(PortalUtility.QueryUrl());
    }
    


    $scope.DeadType = {
        Contract: true,
        Memo: false,
        Deed: false,
        CorrectionDeed: false,
        POA: false
    };
    $scope.ensurePush = function (modelName, data) {
        ptCom.ensurePush($scope, modelName, data);
    };
    $scope.arrayRemove = ptCom.arrayRemove;
    $scope.NGAddArraryItem = ptCom.AddArraryItem;
    $scope.GenerateDocument = function () {
        $http.post('/api/PropertyOffer/GeneratePackage/' + $scope.SSpreSign.BBLE, JSON.stringify($scope.SSpreSign)).success(function (url) {
            var oldUrl = window.location.href;
            STDownloadFile('/TempDataFile/OfferDoc/' + $scope.SSpreSign.BBLE.trim() + '.zip', $scope.SSpreSign.BBLE.trim() + '.zip');
            $scope.SSpreSign.Status = 2;
            $scope.constractFromData();
            $http.post('/api/businessform/', JSON.stringify($scope.SSpreSign)).success(function (formdata) {
                $scope.refreshSave(formdata);
                //location.reload();
                window.location.href = oldUrl;

            });
        })
    }
    $scope.shortSaleInfoNext = function () {

        var ss = ScopeHelper.getShortSaleScope();
        var _sellers = ss.SsCase.PropertyInfo.Owners;

        var _dealSheet = $scope.SSpreSign.DealSheet;
        var eMessages = $scope.getErrorMessage('ShortSaleCtrl');
        if (_.any(eMessages)) {
            AngularRoot.alert(eMessages.join(' <br />'));
            return false;
        }
        _dealSheet.CorrectionDeed.PropertyAddress = $scope.SSpreSign.PropertyAddress;
        var _sellers = _.map(_sellers, function (o) {
            o.Name = ss.formatName(o.FirstName, o.MiddleName, o.LastName);
            o.Address = $scope.SSpreSign.PropertyAddress; //ss.formatAddr(o.MailNumber, o.MailStreetName, o.MailApt, o.MailCity, o.MailState, o.MailZip);
            o.PropertyAddress = $scope.SSpreSign.PropertyAddress;
            return o
        });

        _dealSheet.ContractOrMemo.Sellers = $.extend(true, _dealSheet.ContractOrMemo.Sellers || [], _sellers);
        _dealSheet.Deed.Sellers = $.extend(true, _dealSheet.Deed.Sellers || [], _sellers);
        _dealSheet.CorrectionDeed.Sellers = _dealSheet.CorrectionDeed.Sellers || [];
        //_dealSheet.CorrectionDeed.Sellers = $.extend(true, _dealSheet.CorrectionDeed.Sellers || [], _sellers);
        _dealSheet.Deed.PropertyAddress = $scope.SSpreSign.PropertyAddress;
        return true;
    }

    $scope.SelectTeamChange = function () {
        var team = $scope.SSpreSign.assignCrop.Name;
        $scope.SSpreSign.assignCrop.Signer = null;
        $http.get('/api/CorporationEntities/CorpSigners?team=' + team).success(function (signers) {
            $scope.SSpreSign.assignCrop.signers = signers
        });
    }

    // $scope.$watch('SSpreSign.assignCrop.Name', function(newValue, oldValue) {
    //     if (newValue) {

    //     }
    // });

    $scope.constractFromData = function () {
        var ss = ScopeHelper.getShortSaleScope();

        //var _sellers = ss.SsCase.PropertyInfo.Owners;
        $scope.SSpreSign.DeadType = $scope.DeadType

        $scope.SSpreSign.SsCase = ss ? ss.SsCase : null;
        $scope.SSpreSign.Tag = $scope.SSpreSign.BBLE;
        $scope.SSpreSign.FormData = null;
        $scope.SSpreSign.FormData = JSON.stringify($scope.SSpreSign);
    }
    $scope.searchInfoNext = function () {
        var eMessages = $scope.getErrorMessage('preSignSearchInfo');
        if (_.any(eMessages)) {
            AngularRoot.alert(eMessages.join(' <br />'));
            return false;
        }

        var leadSearch = ScopeHelper.getLeadsSearchScope();
        //do not copy lead search infomation to assignCrop WellsFargo
        //$.extend($scope.SSpreSign.assignCrop, {
        //    isWellsFargo: leadSearch.DocSearch.LeadResearch.wellsFargo
        //});
        return true;
    }
    $scope.getErrorMessage = function (id) {
        var eMessages = [];
        /*ignore every parent of has form-ignore*/
        $('#' + id + ' ul:not(.form_ignore) .ss_warning:not(.form_ignore)').each(function () {
            eMessages.push($(this).attr('data-message'));
        });
        return eMessages
    }
    $scope.ContractNext = function () {
        var eMessages = $scope.getErrorMessage('preSignContract');
        if (_.any(eMessages)) {
            AngularRoot.alert(eMessages.join(' <br />'));
            return false;
        }
        return true;
    }


    $scope.DeedNext = function () {
        var deedCrop = $scope.SSpreSign.DealSheet.Deed;
        /*use like synchronously call*/

        if (!deedCrop.EntityId) {

            var response = $.ajax({
                type: "POST",
                dataType: 'application/json',
                data: $scope.SSpreSign.DealSheet.Deed.Buyer,
                url: '/api/CorporationEntities/AssignDeedCorp?bble=' + $scope.SSpreSign.BBLE,
                async: false
            });

            var errorMsg = PortalHttp.BuildAjaxErrorMessage(response);
            if (!errorMsg) {
                $scope.SSpreSign.DealSheet.Deed.EntityId = $scope.SSpreSign.DealSheet.Deed.Buyer.EntityId;
                return true;
            } else {
                AngularRoot.alert(errorMsg);
                deedCrop.EntityId = null;
                return false;
            }


            //$http.post(,JSON.stringify($scope.SSpreSign.DealSheet.Deed.Buyer)).success(function()
            //{

            //}).error(function(){

            //});
        }

        var eMessages = $scope.getErrorMessage('preAssignDeed');
        if (_.any(eMessages)) {
            AngularRoot.alert(eMessages.join(' <br />'));
            return false;
        }
        return true;
    }
    $scope.preAssignCorrectionDeed = function () {
        var eMessages = $scope.getErrorMessage('preAssignCorrectionDeed');
        if (_.any(eMessages)) {
            AngularRoot.alert(eMessages.join(' <br />'));
            return false;
        }

        return true;
    }

    $scope.preAssignCorrectionPOA = function () {
        var eMessages = $scope.getErrorMessage('preSignPOA');
        if (_.any(eMessages)) {
            AngularRoot.alert(eMessages.join(' <br />'));
            return false;
        }
        return true;
    }
    $scope.AssignCorpSuccessed = function (data) {
        var _assignCrop = $scope.SSpreSign.assignCrop;
        $http.post('/api/CorporationEntities/Assign?bble=' + $scope.SSpreSign.BBLE, JSON.stringify(data)).success(function () {
            _assignCrop.Crop = data.CorpName;
            _assignCrop.CropData = data;
            $scope.SSpreSign.Status = 1;
            /*should save to data base*/
            $scope.constractFromData();
            //console.log( JSON.stringify($scope.SSpreSign));
            $http.post('/api/businessform/', JSON.stringify($scope.SSpreSign)).success(function (formdata) {
                $scope.refreshSave(formdata);
            });
        });
    }

    $scope.assginCropClick = function () {
        var _assignCrop = $scope.SSpreSign.assignCrop;
        var eMessages = $scope.getErrorMessage('assignBtnForm');
        if (_.any(eMessages)) {
            AngularRoot.alert(eMessages.join(' <br />'));
            return false;
        }
        //var assignApi = '/api/CorporationEntities/AvailableCorp?team=' + _assignCrop.Name + '&wellsfargo=' + _assignCrop.isWellsFargo;
        var assignApi = "/api/CorporationEntities/AvailableCorpBySigner?team=" + _assignCrop.Name + "&signer=" + _assignCrop.Signer;

        var confirmMsg = ' THIS PROCESS CANNOT BE REVERSED. Please confirm - The team is ' + _assignCrop.Name + ', and servicer is not Wells Fargo.';

        if (_assignCrop.isWellsFargo) {

            confirmMsg = ' THIS PROCESS CANNOT BE REVERSED. Please confirm - The team is ' + _assignCrop.Name + ', and Wells Fargo signer is ' + _assignCrop.Signer + '';
        }


        $http.get(assignApi).success(function (data) {

            AngularRoot.confirm(confirmMsg).then(function (r) {
                if (r) {
                    $scope.AssignCorpSuccessed(data);
                }
            });
        });

    }
    $http.get('/api/CorporationEntities/Teams').success(function (data) {
        $scope.CorpTeam = data;

    })
    $scope.AssignCropsNext = function () {

        var eMessages = $scope.getErrorMessage('preSignAssignCrops');
        if (_.any(eMessages)) {
            AngularRoot.alert(eMessages.join(' <br />'));
            return false;
        }
        var _dealSheet = $scope.SSpreSign.DealSheet;

        var _cropData = $scope.SSpreSign.assignCrop.CropData;
        _dealSheet.ContractOrMemo.Buyer = _cropData;
        //_dealSheet.Deed.Buyer = _cropData;
        return true;
    }


    $scope.DocRequiredNext = function (noAlert) {

        if (!_.any($scope.DeadType)) {
            if (!noAlert) {
                AngularRoot.alert("Please select at least one type to continue!")
            }
            return false;
        }
        return true;
    }
    $scope.DeedWizardInit = function () {
        var deedCrop = $scope.SSpreSign.DealSheet.Deed;
        /*use like synchronously call*/

        if (!deedCrop.EntityId) {
            $http.get('/api/CorporationEntities/DeedCorpsByTeam?team=' + $scope.SSpreSign.assignCrop.Name).success(function (data) {
                $scope.SSpreSign.DealSheet.Deed.Buyer = data;

            });
        }

    }
    $scope.steps = [{
        title: "New Offer",
        next: function () {
            return true;
        }
    },

        {
            title: "Pre Sign",
            caption: 'SS Info',
            next: $scope.shortSaleInfoNext,
        }, {
            title: "Assign Crops",
            caption: 'Assign Corp',
            next: $scope.AssignCropsNext
        }, {
            title: "Documents Required",
            caption: 'Doc Required',
            next: $scope.DocRequiredNext
        },

        //{ title: "Deal Sheet" },
        {
            title: 'Contract',
            caption: 'Contract Or Memo',
            sheet: 'Contract',
            next: $scope.ContractNext
        }, {
            title: 'Deed',
            sheet: 'Deed',
            next: $scope.DeedNext,
            init: $scope.DeedWizardInit
        }, {
            title: 'CorrectionDeed',
            caption: 'Correction Deed',
            sheet: 'CorrectionDeed',
            next: $scope.preAssignCorrectionDeed
        }, {
            title: 'POA',
            sheet: 'POA',
            next: $scope.preAssignCorrectionPOA
        }, {
            title: "Finish",
            init: previewForm
        },
    ];
    $scope.CheckSearchInfo = function (needSearch, searchCompleted) {
        var searchWized = {
            title: "Search Info",
            next: $scope.searchInfoNext
        };
        if (needSearch || searchCompleted) {
            $scope.steps.splice(1, 0, searchWized)
        } else {
            /*Should make sure the document before LeadTaxSearchCtrl initial this error handle move to server side*/
            //$("#LeadTaxSearchCtrl").remove();
        }
    }
    $scope.CheckSearchInfo($('.pt-need-search-input').val(), $('.pt-search-completed').val())
    $scope.CheckCurrentStep = function (BBLE) {
        $http.get('/api/businessform/PropertyOffer/Tag/' + BBLE).success(function (data) {
            if (data.FormData) {

                $scope.SSpreSign = data.FormData;
                $scope.refreshSave(data);
                $scope.DeadType = data.FormData.DeadType;
                $scope.SSpreSign.SsCase = data.FormData.SsCase;
                $scope.SSpreSign.Status = data.BusinessData.Status;

                // setTimeout(function () {

                var ss = ScopeHelper.getShortSaleScope();
                if (ss) {
                    ss.SsCase = $scope.SSpreSign.SsCase;
                }
                //}
                //, 1000);

            } else {
                $scope.SSpreSign.BBLE = data.Tag;
            }
        });
    }

    var BBLE = $("#BBLE").val();
    if (BBLE) {
        $http.get('/api/Leads/LeadsInfo/' + BBLE).success(function (data) {
            $scope.SSpreSign.PropertyAddress = data.PropertyAddress;
            $scope.SSpreSign.BBLE = BBLE
        })

        $scope.CheckCurrentStep(BBLE);
    }

    $scope.step = 1
    $scope.filteredSteps = [];
    $scope.MaxStep = function () {
        return $scope.filteredSteps.length;
    }
    $scope.currentStep = function () {
        return $scope.filteredSteps[$scope.step - 1];
    }
    $scope.refreshSave = function (formdata) {
        $scope.SSpreSign.DataId = formdata.DataId;
        $scope.SSpreSign.Tag = formdata.Tag;
        $scope.SSpreSign.CreateDate = formdata.CreateDate;
        $scope.SSpreSign.CreateBy = formdata.CreateBy;
    }
    $scope.NextStep = function () {
        var cStep = $scope.currentStep();
        $scope.step++;
        //if (cStep.next) {
        //    if (cStep.next()) {
        //        $scope.constractFromData();
        //        $http.post('/api/businessform/', JSON.stringify($scope.SSpreSign)).success(function (formdata) {
        //            $scope.refreshSave(formdata);
        //            $scope.step++;
        //            cStep = $scope.currentStep();
        //            if (cStep.init) {
        //                cStep.init();
        //            }
        //        })
        //    }

        //} else {
        //    $scope.step++;
        //}

    }
    $scope.PrevStep = function () {
        $scope.step--;
    }
    $scope.borrwerGrid = {
        dataSource: [{
            Name: "Borrower 1",
            "Address": "123 Main ST, New York NY 10001",
            "SSN": "123456789",
            "Phone": "212 123456",
            "Email": "email@gmail.com",
            "MailAddress": "123 Main ST, New York NY 10001"
        }],
        columns: ['Name', 'Address', 'SSN', 'Email', 'Phone', {
            dataField: "Type",
            lookup: {
                dataSource: ["Borrower", "Co-Borrower"],
            }
        }, 'MailAddress'],
        editing: {
            editEnabled: true,
            insertEnabled: true,
            removeEnabled: true
        }
    }
})
/************* end old style without model contoller ****************/
portalApp.filter('wizardFilter', function () {
    return function (items, sheetFilter) {
        var filtered = [];
        angular.forEach(items, function (item) {
            if (typeof item.sheet != 'undefined') {
                if (!sheetFilter) {
                    console.error("there are no filter please check filter")
                }
                for (key in sheetFilter) {
                    if (sheetFilter[key] && item.sheet == key) {
                        filtered.push(item)
                    }
                }
            } else {
                filtered.push(item);
            }

        });
        return filtered;
    };
});
portalApp.filter('ordered', function () {
    return function (item) {

        var orderDic = {
            "1": '1st',
            "2": "2nd",
            "3": "3rd"
        };

        return orderDic[item];
    };
});





