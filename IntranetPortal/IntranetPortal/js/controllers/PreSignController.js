var portalApp = angular.module('PortalApp');

portalApp.config(function (portalRouteProvider) {

    var newPreSign = ['$route', 'PreSign', function ($route, PreSign) {
        var preSign = new PreSign();
        preSign.BBLE = $route.current.params.BBLE.toString();

        return preSign; //.$route.current.params.BBLE;
    }];

    var preSignList = ['PreSign', function (PreSign) {

        return PreSign.query();
    }];
    var preSignItem = ['$route', 'PreSign', function ($route, PreSign) {
        var preSignId = $route.current.params[portalRouteProvider.ITEM_ID]
        return PreSign.get({ Id: preSignId });
    }];

    var preSignFinanceList = ['PreSign', function (PreSign) {
        return PreSign.financeList();
    }];

    /***
     * Leave this for example that nomal router resgister   
     **/
    //$routeProvider.when('/preAssign/new', {
    //    templateUrl: '/js/Views/preAssign/preassign-edit.tpl.html',
    //    controller: 'preAssignEditCtrl',
    //    resolve:{BBLE:BBLE},
    //})

    var config = portalRouteProvider.routesFor('preAssign')
        // /preassign/new?BBLE=BBLE becuse javascript case sensitive
        // so the portalRouteProvider url should be lower case
        // #/preassign/new?BBLE=123456789
        .whenNew({ PreSignItem: newPreSign })
        // #/preassign/28
        .whenEdit({ PreSignItem: preSignItem })
        // #/preassign/view/28
        .whenView({ PreSignItem: preSignItem })
        // #/preassign
        .whenList({ PreSignList: preSignList })
        // #/preassign/finance/list
        // I don not know why need the suffix url list
        // otherwise it will go to edit view
        .whenOther({ PreSignFinaceList: preSignFinanceList }, 'Finance', 'list')
    //.when({BBLE:BBLE})

});
/**************************************** constant define *********************************/
/* do not change constant value , if you want change make a copy and change copied object */
var CONSTANT_ASSIGN_PARTIES_GRID_OPTION = {
    bindingOptions: {
        dataSource: 'preAssign.Parties'
    },
    //dataSource: $scope.preAssign.CheckRequestData.Checks,
    paging: {
        pageSize: 10
    },
    //editing: { insertEnabled: true },//$.extend({}, $scope.gridEdit),
    pager: {
        showPageSizeSelector: true,
        allowedPageSizes: [5, 10, 20],
        showInfo: true
    },
    columns: [{
        dataField: "Name",
        validationRules: [{
            type: "required"
        }]
    }],
    sorting: { mode: 'none' },
    summary: {
        totalItems: [{
            column: "Name",
            summaryType: "count"
        }]
    },
    initRowText: function () {
        self = this;
        self.editing.texts = { deleteRow: 'Delete' }
    }
}

var CONSTANT_ASSIGN_CHECK_GRID_OPTION =
{
    bindingOptions: {
        dataSource: 'preAssign.CheckRequestData.Checks'
    },
    sorting: { mode: 'none' },
    //dataSource: $scope.preAssign.CheckRequestData.Checks,
    paging: {
        pageSize: 10
    },

    // editing: $scope.gridEdit,
    pager: {

        showInfo: true
    },
    wordWrapEnabled: true,
    columns: [{
        dataField: "PaybleTo",
        caption: 'Payable To',
        validationRules: [{
            type: "required"
        }]
    }, {
        dataField: 'Amount',
        dataType: 'number',
        format: 'currency',
        precision: 2,
        validationRules: [{
            type: "required"
        }]
    }, new dxGridColumnModel(
    {
        dataField: 'Date',
        dataType: 'date',
        caption: 'Date of Release',
        validationRules: [{
            type: "required"
        }]
    }), {
        dataField: 'Description',
        validationRules: [{
            type: "required"
        }]
    }, ],
    //show avoid check any time
    // "onRowPrepared": $scope.CheckRowPrepared,
    initEdit: function () {
        var self = this;
        var voidReasonColumn = {
            dataField: 'Comments',
            caption: 'Void Reason',
            allowEditing: false
        }
        if (self.columns.indexOf(voidReasonColumn) < 0) {
            self.columns.push(voidReasonColumn)
        }


    },
    summary: {
        calculateCustomSummary: function (options) {


            if (options.name == 'SumAmount') {
                options.totalValue = _.sum(_.filter(options.component._options.dataSource, function (o) {
                    return o.Status != 1;
                }), "Amount"); //$scope.CheckTotalAmount();
            }
        },
        totalItems: [{
            column: "Name",
            summaryType: "count"
        }, {
            name: "SumAmount",
            showInColumn: "Amount",
            summaryType: "sum",
            displayFormat: "Sum: {0}",
            valueFormat: "currency",
            precision: 2,
            summaryType: "custom"
        }]
    }
};


// with void reason as default display
var CONSTANT_ASSIGN_CHECK_GRID_OPTION_2 = _.extend({}, CONSTANT_ASSIGN_CHECK_GRID_OPTION);

CONSTANT_ASSIGN_CHECK_GRID_OPTION_2.columns.push({
    dataField: 'Comments',
    caption: 'Void Reason'
});

var CONSTANT_ASSIGN_LIST_GRID_OPTION = {
    bindingOptions: {
        dataSource: 'preSignList'
    },
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
    onRowPrepared: function (rowInfo) {
        if (rowInfo.rowType != 'data')
            return;
        rowInfo.rowElement
        .addClass('myRow');
    },
    columnAutoWidth: true,
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
                    PortalUtility.OpenWindow('/NewOffer/HomeownerIncentive.aspx#/view/' + request.Id, 'Pre Sign ' + request.BBLE, 800, 900);
                })
                .appendTo(container);
        }
    }, {
        dataField: 'CreateBy',
        caption: 'Request By'
    }, new dxGridColumnModel({
        dataField: 'CreateDate',
        caption: 'Request Date',
        dataType: 'date'
    }), new dxGridColumnModel({
        dataField: 'ExpectedDate',
        caption: 'Expected Date Of Sign',
        dataType: 'date'
    }), {
        dataField: 'DealAmount',
        format: 'currency',
        dataType: 'number',
        precision: 2
    },
    //{
    //    dataField: 'NeedSearch',
    //    caption: 'Search Request'
        //},
    ],
    wordWrapEnabled: true
}
/**************************************** end constant define ******************************/
/**
 * HIO name histroy
 * Now the pre Assign is named HIO
 * But the version name history is 
 * if in code or file named 
 * please maintenance this list blow if the name changed again 
 * pre sssign == pre sign ==  pre deal == HOI
 * 1. pre assign
 * 2. pre sign  
 * 3. pre deal
 * 4. HOI
 *
 **/

portalApp.controller('preAssignEditCtrl', function ($scope, ptCom, PreSignItem, DxGridModel, $location, PortalHttpInterceptor, $http) {

    $scope.preAssign = PreSignItem;
    setTimeout(function () {

        if (!$scope.preAssign.CheckRequestData) {
            $scope.preAssign.CheckRequestData = { Type: 'Short Sale', Checks: [] };
        }

        if (!$scope.preAssign.Id) {
            $scope.preAssign.CheckRequestData = { Type: 'Short Sale', Checks: [] };
            $scope.preAssign.Parties = [];
            $scope.preAssign.NeedSearch = true;
            $scope.preAssign.NeedCheck = true;
        }


        var checkGrid = $('#gridChecks').dxDataGrid('instance');
        if (checkGrid) {
            checkGrid.refresh();
        } else {
            console.error("can not find checkGrid instance");
        }
        if ($scope.preAssign.BBLE) {
            $http.get('/api/Leads/LeadsInfo/' + $scope.preAssign.BBLE).success(function (data) {
                $scope.preAssign.Title = data.PropertyAddress
            });
        }
        if (!$scope.preAssign.CreateBy) {
            $scope.preAssign.CreateBy = $('#currentUser').val();

        }
    }, 1000);
    $scope.partiesGridOptions = new DxGridModel(CONSTANT_ASSIGN_PARTIES_GRID_OPTION, {
        editMode: "cell"
    });

    $scope.checkGridOptions = {
        bindingOptions: {
            dataSource: 'preAssign.CheckRequestData.Checks'
        },
        editing: {
            editMode: 'cell',
            texts: {
                deleteRow: 'Void',
                confirmDeleteMessage: ''
            },
            editEnabled: true,
            removeEnabled: true,
            insertEnabled: true
        },
        sorting: { mode: 'none' },

        pager: {

            showInfo: true
        },
        wordWrapEnabled: true,
        columns: [{
            dataField: "PaybleTo",
            caption: 'Payable To',
            validationRules: [{
                type: "required"
            }]
        }, {
            dataField: 'Amount',
            dataType: 'number',
            format: 'currency',
            precision: 2,
            validationRules: [{
                type: "required"
            }]
        }, new dxGridColumnModel(
        {
            dataField: 'Date',
            dataType: 'date',
            caption: 'Date of Release',
            validationRules: [{
                type: "required"
            }]
        }), {
            dataField: 'Description',
            validationRules: [{
                type: "required"
            }]
        }, {
            dataField: 'Comments',
            caption: 'Void Reason',
            allowEditing: false
        }],

        summary: {
            calculateCustomSummary: function (options) {
                if (options.name == 'SumAmount') {
                    options.totalValue = _.sum(_.filter(options.component._options.dataSource, function (o) {
                        return o.Status != 1;
                    }), "Amount"); //$scope.CheckTotalAmount();
                }
            },
            totalItems: [{
                column: "Name",
                summaryType: "count"
            }, {
                name: "SumAmount",
                showInColumn: "Amount",
                summaryType: "sum",
                displayFormat: "Sum: {0}",
                valueFormat: "currency",
                precision: 2,
                summaryType: "custom"
            }]
        }
    };

    $scope.CheckByBBLE = function () {
        var preAssign = $scope.preAssign;
        /**with id request cancel check*/
        if (preAssign.$promise != null) {
            return;
        }
        if (preAssign.Id == 0 || preAssign.Id == null) {
            //console.log(typeof preAssign.BBLE);
            //console.log(preAssign.BBLE)
            //preAssign.BBLE = preAssign.BBLE.toString()
            preAssign.$getByBBLE(function () {
                $location.path('/preassign/view/' + preAssign.Id);
            })
        }
    }

    $scope.CheckByBBLE();

    $scope.Save = function () {
        if ($scope.preAssign.validation()) {
            if ($scope.preAssign.hasId()) {
                $scope.preAssign.$update(function () {
                    $location.path('/preassign/view/' + $scope.preAssign.Id);
                })
            } else {
                $scope.preAssign.$save(function () {
                    $location.path('/preassign/view/' + $scope.preAssign.Id);
                })
            }


        } else {
            var msg = $scope.preAssign.getErrorMsgStr();
            AngularRoot.alert(msg);
        }

    }

    $scope.CheckRowPrepared = function (e) {
        if (e.data && e.data.Status == 1) {
            e.rowElement.addClass('avoid-check');
        }
    }

    $scope.checkGridOptions.onRowPrepared = $scope.CheckRowPrepared;

    $scope.checkGridOptions.onEditingStart = function (e) {
        if (e.data.Status == 1 || e.data.CheckId) {
            e.cancel = true;
        }
    }

    $scope.AddCheck = function (e) {
        var cancel = false;
        e.data.RequestId = $scope.preAssign.CheckRequestData.RequestId;
        e.data.Date = new Date(e.data.Date).toISOString();
        // can not use anguler model here
        // for devextreme 15.1 only can use sync call for control the event of grid 
        // when we moved to 16.1 grid view support 'promise' it can change to ng model function
        var response = $.ajax({
            url: '/api/PreSign/' + $scope.preAssign.Id + '/AddCheck/' + $scope.preAssign.NeedCheck,
            type: 'POST',
            dataType: 'json',
            async: false,
            data: e.data,
            success: function (data, textStatus, xhr) {
                $scope.addedCheck = data;
                // Use client side model will solve this 
                // But there should have better way to implement put update in javascript 
                // in restful client can check android update for put http://square.github.io/retrofit/
                // find the batch update for angular services

                ///////////////////////////////////////
                //e.data = data;
                e.cancel = true;
                e.component.refresh();
                var pageExpectedDate = $scope.preAssign.ExpectedDate;
                var pageParties = $scope.preAssign.Parties;
                //$scope.preAssign.CheckRequestData.RequestId = data.RequestId
                angular.extend($scope.preAssign, data) //.CheckRequestId = data.RequestId
                if (pageExpectedDate) {
                    $scope.preAssign.ExpectedDate = pageExpectedDate;

                }
                if (pageParties) {
                    $scope.preAssign.Parties = pageParties;
                }
                //$scope.preAssign.CheckRequestData.Checks.push(data);


            }
        });

        var message = PortalHttpInterceptor.BuildAjaxErrorMessage(response);
        if (message) {
            AngularRoot.alert(message);
            e.cancel = true;
        };
        return cancel;
    }

    $scope.CancelCheck = function (e) {
        e.cancel = true;
        if (e.data.Status == 1) {
            $('#gridChecks').dxDataGrid('instance').refresh();
            return;
        }
        AngularRoot.prompt("Please input void reason", function (voidReason) {
            if (voidReason) {
                var response = $.ajax({
                    url: '/api/businesscheck/' + e.data.CheckId,
                    type: 'DELETE',
                    data: JSON.stringify(voidReason),
                    contentType: "application/json",
                    dataType: "json",
                    async: false,
                    success: function (data, textStatus, xhr) {
                        data.Comments = voidReason;
                        //e.model = data;
                        e.model.Status = 1;
                        e.data.Status = 1;
                        e.data.Comments = voidReason;
                        // _.remove($scope.preAssign.CheckRequestData.Checks, {
                        //     CheckId: e.data.CheckId
                        // });
                        //$scope.preAssign.CheckRequestData.Checks.push(data);
                        //$scope.clearCheckRequest($scope.preAssign.CheckRequestData.Checks);
                        //_.remove($scope.preAssign.CheckRequestData.Checks,function(o){  return o.CheckId == null});

                        $('#gridChecks').dxDataGrid('instance').refresh();
                        $scope.deletedCheck = data;
                    }
                });
                var message = PortalHttpInterceptor.BuildAjaxErrorMessage(response);
                if (message) {
                    AngularRoot.alert(message);

                };

            }
        })

        $('#gridChecks').dxDataGrid('instance').refresh();
    }

    path = $location.path();

    if (path.indexOf('new') < 0) {
        $scope.checkGridOptions.onRowRemoving = $scope.CancelCheck;
        $scope.checkGridOptions.onRowInserting = $scope.AddCheck;
    }


});

portalApp.controller('preAssignViewCtrl', function ($scope, PreSignItem, DxGridModel, CheckRequest) {

    $scope.preAssign = PreSignItem;
    setTimeout(function () {
        if (!$scope.preAssign.CheckRequestData) {
            $scope.preAssign.CheckRequestData = { Checks: [{}] };
        }
        var checkGrid = $('#gridChecks').dxDataGrid('instance');
        if (checkGrid) {
            checkGrid.refresh();
        } else {
            console.error("can not find checkGrid instance");
        }

    }, 1000);

    $scope.partiesGridOptions = new DxGridModel(CONSTANT_ASSIGN_PARTIES_GRID_OPTION);

    $scope.checkGridOptions = new DxGridModel(CONSTANT_ASSIGN_CHECK_GRID_OPTION_2);


    setTimeout(function () {
        $("#preDealForm input").prop("disabled", true);
        $("#preDealForm select").prop("disabled", true);
    }, 1000);

    $scope.CheckRowPrepared = function (e) {
        if (e.data && e.data.Status == 1) {
            e.rowElement.addClass('avoid-check');
        }
    }
    $scope.checkGridOptions.onRowPrepared = $scope.CheckRowPrepared;

});

portalApp.controller('preAssignFinanceCtrl', function ($scope, PreSignFinaceList) {
    $scope.preSignList = PreSignFinaceList;
    $scope.preSignRecordsGridOpt = angular.extend({}, CONSTANT_ASSIGN_LIST_GRID_OPTION);
    $scope.preSignRecordsGridOpt.masterDetail = {
        enabled: true,
        template: function (container, options) {
            var opt = {
                dataSource: options.data.Checks,
                columnAutoWidth: true,
                columns: [{
                    dataField: 'PaybleTo',
                    caption: 'Payable To',
                }, {
                    dataField: 'Amount',
                    format: 'currency', dataType: 'number', precision: 2

                }, {
                    dataField: 'Date',
                    caption: 'Date of Release',
                    dataType: 'date',
                    format: 'shortDate'
                }, {
                    dataField: 'Description'
                }, {
                    dataField: 'Comments',
                    caption: 'Void Reason'
                }],
                onRowPrepared: $scope.CheckRowPrepared,
            }
            $("<div>").text("Checks: ").appendTo(container);
            $("<div>")
                .addClass("internal-grid")
                .dxDataGrid(opt).appendTo(container);

        }
    }
    $scope.preSignRecordsGridOpt.selection = null;
    $scope.preSignRecordsGridOpt.columns = [{
        dataField: 'PropertyAddress',
        caption: 'Address'
    }, {
        dataField: 'RequestBy',
        caption: 'Request By'
    }, {
        dataField: 'Type',
        caption: 'Request Type'
    }, {
        dataField: 'RequestDate',
        caption: 'Request Date',
        dataType: 'date'
    }, {
        dataField: 'CheckAmount',
        format: 'currency',
        dataType: 'number',
        precision: 2
    }, ]

    $scope.CheckRowPrepared = function (e) {
        if (e.data && e.data.Status == 1) {
            e.rowElement.addClass('avoid-check');
        }
    }

});

portalApp.controller('preAssignListCtrl', function ($scope, PreSignList) {
    $scope.preSignList = PreSignList;
    $scope.preSignRecordsGridOpt = angular.extend({}, CONSTANT_ASSIGN_LIST_GRID_OPTION);
});

/*************************old style contoller******************************/
portalApp.controller('preAssignCtrl', function ($scope, ptCom, PortalHttpInterceptor,$http) {


    $scope.preAssign = {
        Parties: [],
        CheckRequestData: {
            Checks: []
        },
        NeedSearch: true,
        NeedCheck: true
    };
    $scope.showHistroy = function () {
        auditLog.show(null, $scope.preAssign.Id);
    }
    var _BBLE = PortalUtility.QueryUrl().BBLE;
    var _model = PortalUtility.QueryUrl().model;
    var _role = PortalUtility.QueryUrl().role;
    $scope.role = _role;
    $scope.model = _model;
    $scope.role = _role;
    $scope.gridEdit = {
        editMode: "cell",
        editEnabled: true,
        insertEnabled: true,
        removeEnabled: true
    };
    $scope.allowEdit = false;
    if (_model == 'List') {
        var checksListApi = $scope.role == 'finance' ? '/api/PreSign/CheckRequests' : '/api/presign/records';
        $http.get(checksListApi).success(function (data) {
            $scope.preSignList = _.map(data, function (p) {
                p.ChecksTotal = _.sum(p.Checks, 'Amount');

                return p;
            });
        });
    }
    if (_model == 'View') {
        setTimeout(function () {
            $("#preDealForm input").prop("disabled", true);
            $("#preDealForm select").prop("disabled", true);
        }, 1000);

        $scope.gridEdit = {}
        var _Id = PortalUtility.QueryUrl().Id;

        var preSignRespose = $.ajax({
            url: '/api/PreSign/' + _Id,
            async: false
        });

        var message = PortalHttpInterceptor.BuildAjaxErrorMessage(preSignRespose);
        if (message) {
            AngularRoot.alert(message)
        } else {
            _.extend($scope.preAssign, JSON.parse(preSignRespose.responseText));

            $scope.preAssign.CheckRequestData = $scope.preAssign.CheckRequestData || { Checks: [] }
            _BBLE = $scope.preAssign.BBLE
        }
    }

    $scope.init = function (preSignId) {
        $http.get('/api/PreSign/' + preSignId).success(function (data) {
            $scope.preAssign = data;

            $scope.preAssign.Parties = $scope.preAssign.Parties || [];
        });
        //auditLog.show("PreSignRecord",preSignId);
    }
    /**
     * Init Edit model data by id
     * @param  {number} id [pre assign Id]
     */
    $scope.initEdit = function (id) {
        $scope.preAssign.Id = id;
        //$scope.partiesGridEditing = {mode: 'batch', editEnabled: false, insertEnabled: true, removeEnabled: true};
        $scope.partiesGridOptions.editing.editEnabled = true;
        $scope.checkGridOptions.onRowInserting = $scope.AddCheck;
        $scope.checkGridOptions.editing.texts = {
            deleteRow: 'Void',
            confirmDeleteMessage: '' //'Are you sure you want void this check?'
        }
        $scope.checkGridOptions.onRowRemoving = $scope.CancelCheck;
        $scope.checkGridOptions.onEditingStart = function (e) {
            if (e.data.Status == 1 || e.data.CheckId) {
                e.cancel = true;
            }
        }
        $scope.checkGridOptions.initEdit();
        // $scope.checkGridOptions.editing.removeEnabled = false;
        // $scope.checkGridOptions.columns.push({
        //     width: 100,
        //     alignment: 'center',
        //     cellTemplate: function(container, options) {
        //         $('<a/>').addClass('dx-link')
        //             .text('Avoid')
        //             .on('dxclick', function() {
        //                 $scope.CancelCheck(options)
        //                 //Do something with options.data;
        //             })
        //             .appendTo(container);
        //     }
        // });
        //$scope.checkGridOptions.onRowPrepared  = 
        //$scope.gridEdit.editEnabled = false;

        $scope.init($scope.preAssign.Id);
    }

    $scope.AddCheck = function (e) {
        var cancel = false;
        //e.data.RequestId = $scope.preAssign.CheckRequestData.RequestId;
        e.data.Date = new Date(e.data.Date).toISOString();
        var response = $.ajax({
            //url: '/api/businesscheck',
            url: '/api/PreSign/' + $scope.preAssign.Id + '/AddCheck/' + $scope.preAssign.NeedCheck,
            type: 'POST',
            dataType: 'json',
            async: false,
            data: e.data,
            success: function (data, textStatus, xhr) {
                $scope.addedCheck = data;
                // Use client side model will solve this 
                // But there should have better way to implement put update in javascript 
                // in restful client can check android update for put http://square.github.io/retrofit/
                // find the batch update for angular services

                ///////////////////////////////////////
                //e.data = data;
                e.cancel = true;
                e.component.refresh();
                var pageExpectedDate = $scope.preAssign.ExpectedDate;
                //$scope.preAssign.CheckRequestData.RequestId = data.RequestId
                angular.extend($scope.preAssign, data) //.CheckRequestId = data.RequestId
                if (pageExpectedDate) {
                    $scope.preAssign.ExpectedDate = pageExpectedDate;
                }
                //$scope.preAssign.CheckRequestData.Checks.push(data);


            }
        });

        var message = PortalHttpInterceptor.BuildAjaxErrorMessage(response);
        if (message) {
            AngularRoot.alert(message);
            e.cancel = true;
        };
        return cancel;
    }

    // $scope.$watch('preAssign.CheckRequestData.Checks', function(oldData,newData)
    // {
    //     _.remove($scope.preAssign.CheckRequestData.Checks,function(o){  return o["CheckId"] == null});
    // })
    $scope.clearCheckRequest = function (data) {
        _.remove(data, function (o) { return o["CheckId"] == null });
    }
    $scope.CancelCheck = function (e) {
        e.cancel = true;
        if (e.data.Status == 1) {
            $('#gridChecks').dxDataGrid('instance').refresh();
            return;
        }
        AngularRoot.prompt("Please input void reason", function (voidReason) {
            if (voidReason) {
                var response = $.ajax({
                    url: '/api/businesscheck/' + e.data.CheckId,
                    type: 'DELETE',
                    data: JSON.stringify(voidReason),
                    contentType: "application/json",
                    dataType: "json",
                    async: false,
                    success: function (data, textStatus, xhr) {
                        data.Comments = voidReason;
                        //e.model = data;
                        e.model.Status = 1;
                        e.data.Status = 1;
                        e.data.Comments = voidReason;
                        // _.remove($scope.preAssign.CheckRequestData.Checks, {
                        //     CheckId: e.data.CheckId
                        // });
                        //$scope.preAssign.CheckRequestData.Checks.push(data);
                        //$scope.clearCheckRequest($scope.preAssign.CheckRequestData.Checks);
                        //_.remove($scope.preAssign.CheckRequestData.Checks,function(o){  return o.CheckId == null});

                        $('#gridChecks').dxDataGrid('instance').refresh();
                        $scope.deletedCheck = data;
                    }
                });
                var message = PortalHttpInterceptor.BuildAjaxErrorMessage(response);
                if (message) {
                    AngularRoot.alert(message);

                };

            }
        })

        $('#gridChecks').dxDataGrid('instance').refresh();
    }

    $scope.steps = [{
        title: "Pre Sign",
        show: true
    }, {
        title: "Parties",
        show: $scope.preAssign.NeedCheck
    }, {
        title: "Checks",
        show: $scope.preAssign.NeedCheck
    }, {
        title: "Finish",
        show: true
    }, ];

    $scope.arrayRemove = ptCom.arrayRemove;
    $scope.step = 1
    $scope.MaxStep = $scope.steps.length;
    $scope.NextStep = function () {
        $scope.step++;
    }
    $scope.PrevStep = function () {
        $scope.step--;
    }

    /**
     * @param  {[type]}
     * @return {[type]}
     */
    $scope.initByBBLE = function (BBLE) {
        $http.get('/api/Leads/LeadsInfo/' + BBLE).success(function (data) {
            $scope.preAssign.Title = data.PropertyAddress
        });
        if ($scope.model != 'View') {
            $scope.preAssign.CheckRequestData.Type = "Short Sale";
            $scope.preAssign.DealAmount = 0;
            $scope.preAssign.NeedSearch = true;
        }
        $http.get('/api/PropertyOffer/isCompleted/' + BBLE).success(function (data) {
            $scope.allowEdit = !data;
        })

        $scope.preAssign.BBLE = _BBLE
        $scope.preAssign.CheckRequestData = $scope.preAssign.CheckRequestData || {};
        if ($scope.preAssign.CheckRequestData) {
            $scope.preAssign.CheckRequestData.Checks = $scope.preAssign.CheckRequestData.Checks || [];
            $scope.preAssign.CheckRequestData.BBLE = $scope.preAssign.BBLE;
        }
    }

    if (_BBLE) {
        $scope.initByBBLE(_BBLE);
    }
    /**
     * [validation description my have diffrent in view mode and edit mode]
     */
    $scope.validationPreAssgin = function () {
        var selfData = $scope.preAssign;
        if (!selfData.ExpectedDate) {
            $scope.alert("Please fill expected date !");
            return false;
        }
        if ((!$scope.preAssign.Parties) || $scope.preAssign.Parties.length < 1) {
            $scope.alert("Please fill at least one Party !");
            return false;
        }

        if ($scope.preAssign.NeedCheck && $scope.preAssign.CheckRequestData.Checks.length < 1) {
            $scope.alert("Check Request is enabled. Please enter checks to be issued.");
            return false;
        }
        if ($scope.CheckTotalAmount() > $scope.preAssign.DealAmount) {
            $scope.alert("The check's total amount must less than the deal amount, Please correct! ");
            return false;
        }
        if (!$scope.preAssign.NeedCheck) {
            //$scope.preAssign.Parties = null;
            $scope.preAssign.CheckRequestData = null
        }
        return true;
    }

    $scope.alert = function (msg) {
        if (typeof AngularRoot != 'undefined') {
            AngularRoot.alert(msg)
        }
    }
    /**
     * 
     */
    $scope.Save = function () {
        var selfData = $scope.preAssign;

        if ($scope.preAssign.Id) {
            if ($scope.validationPreAssgin()) {
                $http.put('/api/PreSign/' + $scope.preAssign.Id, JSON.stringify($scope.preAssign)).success(function (data) {
                    //if (typeof AngularRoot != 'undefined') {
                    //    AngularRoot.alert("Updated success!");
                    //}
                    //for unit test
                    $scope.localhref = '/NewOffer/HomeownerIncentive.aspx?model=View&Id=' + $scope.preAssign.Id
                    window.location.href = $scope.localhref
                });
            }

        } else {
            if ($scope.validationPreAssgin()) {
                $http.post('/api/PreSign', JSON.stringify($scope.preAssign)).success(function (data) {
                    //AngularRoot.alert("Submit success !");
                    $scope.preAssign = data;
                    window.location.href = '/NewOffer/HomeownerIncentive.aspx?model=View&Id=' + data.Id
                });
            }
        }
    }

    //var ref = new Firebase("https://sdatabasetest.firebaseio.com/qqq");
    //var syncObject = $firebaseObject(ref);
    //syncObject.$bindTo($scope, "Test");

    $scope.onSelectedChanged = function (e) {
        var request = e.selectedRowsData[0];
        PortalUtility.OpenWindow('/NewOffer/HomeownerIncentive.aspx?model=View&Id=' + request.Id, 'Pre Sign ' + request.BBLE, 800, 900);
    }


    $scope.preSignRecordsGridOpt = {
        bindingOptions: {
            dataSource: 'preSignList'
        },
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
        onRowPrepared: function (rowInfo) {
            if (rowInfo.rowType != 'data')
                return;
            rowInfo.rowElement
            .addClass('myRow');
        },
        columnAutoWidth: true,
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
                        PortalUtility.OpenWindow('/NewOffer/HomeownerIncentive.aspx?model=View&Id=' + request.Id, 'Pre Sign ' + request.BBLE, 800, 900);
                    })
                    .appendTo(container);
            }
        }, {
            dataField: 'CreateBy',
            caption: 'Request By'
        }, new dxGridColumnModel({
            dataField: 'CreateDate',
            caption: 'Request Date',
            dataType: 'date'
        }), new dxGridColumnModel({
            dataField: 'ExpectedDate',
            caption: 'Expected Date Of Sign',
            dataType: 'date'
        }), {
            dataField: 'DealAmount',
            format: 'currency',
            dataType: 'number',
            precision: 2
        },
        //{
        //    dataField: 'NeedSearch',
        //    caption: 'Search Request'
            //},
        ],
        wordWrapEnabled: true
    }

    $scope.partiesGridOptions = {
        bindingOptions: {
            dataSource: 'preAssign.Parties'
        },
        //dataSource: $scope.preAssign.CheckRequestData.Checks,
        paging: {
            pageSize: 10
        },
        editing: $.extend({}, $scope.gridEdit),
        pager: {
            showPageSizeSelector: true,
            allowedPageSizes: [5, 10, 20],
            showInfo: true
        },
        columns: [{
            dataField: "Name",
            validationRules: [{
                type: "required"
            }]
        }],
        sorting: { mode: 'none' },
        summary: {
            totalItems: [{
                column: "Name",
                summaryType: "count"
            }]
        }
    }

    $scope.CheckTotalAmount = function () {
        if ($scope.preAssign.CheckRequestData && $scope.preAssign.CheckRequestData.Checks) {
            return _.sum(_.filter($scope.preAssign.CheckRequestData.Checks, function (o) {
                return o.Status != 1;
            }), 'Amount');
        }
        return 0;
    }
    $scope.CheckRowPrepared = function (e) {
        if (e.data && e.data.Status == 1) {
            e.rowElement.addClass('avoid-check');
        }
    }
    $scope.checkGridOptions = {
        bindingOptions: {
            dataSource: 'preAssign.CheckRequestData.Checks'
        },
        sorting: { mode: 'none' },
        //dataSource: $scope.preAssign.CheckRequestData.Checks,
        paging: {
            pageSize: 10
        },

        editing: $scope.gridEdit,
        pager: {

            showInfo: true
        },
        wordWrapEnabled: true,
        columns: [{
            dataField: "PaybleTo",
            caption: 'Payable To',
            validationRules: [{
                type: "required"
            }]
        }, {
            dataField: 'Amount',
            dataType: 'number',
            format: 'currency',
            precision: 2,
            validationRules: [{
                type: "required"
            }]
        }, new dxGridColumnModel(
        {
            dataField: 'Date',
            dataType: 'date',
            caption: 'Date of Release',
            validationRules: [{
                type: "required"
            }]
        }), {
            dataField: 'Description',
            validationRules: [{
                type: "required"
            }]
        }, ],
        //show avoid check any time
        "onRowPrepared": $scope.CheckRowPrepared,
        initEdit: function () {
            var self = this;
            self.columns.push({
                dataField: 'Comments',
                caption: 'Void Reason',
                allowEditing: false
            });
        },
        summary: {
            calculateCustomSummary: function (options) {


                if (options.name == 'SumAmount') {
                    options.totalValue = _.sum(_.filter(options.component._options.dataSource, function (o) {
                        return o.Status != 1;
                    }), "Amount"); //$scope.CheckTotalAmount();
                }
            },
            totalItems: [{
                column: "Name",
                summaryType: "count"
            }, {
                name: "SumAmount",
                showInColumn: "Amount",
                summaryType: "sum",
                displayFormat: "Sum: {0}",
                valueFormat: "currency",
                precision: 2,
                summaryType: "custom"
            }]
        }
    };

    if (_role == 'finance') {
        $scope.preSignRecordsGridOpt.masterDetail = {
            enabled: true,
            template: function (container, options) {
                var opt = {
                    dataSource: options.data.Checks,
                    columnAutoWidth: true,
                    columns: [{
                        dataField: 'PaybleTo',
                        caption: 'Payable To',
                    }, {
                        dataField: 'Amount',
                        format: 'currency', dataType: 'number', precision: 2

                    }, {
                        dataField: 'Date',
                        caption: 'Date of Release',
                        dataType: 'date',
                        format: 'shortDate'
                    }, {
                        dataField: 'Description'
                    }, {
                        dataField: 'Comments',
                        caption: 'Void Reason'
                    }],
                    onRowPrepared: $scope.CheckRowPrepared,
                }
                $("<div>").text("Checks: ").appendTo(container);
                $("<div>")
                    .addClass("internal-grid")
                    .dxDataGrid(opt).appendTo(container);

            }
        }
        $scope.preSignRecordsGridOpt.selection = null;
        $scope.preSignRecordsGridOpt.columns = [{
            dataField: 'PropertyAddress',
            caption: 'Address'
        }, {
            dataField: 'RequestBy',
            caption: 'Request By'
        }, {
            dataField: 'Type',
            caption: 'Request Type'
        }, {
            dataField: 'RequestDate',
            caption: 'Request Date',
            dataType: 'date'
        }, new dxGridColumnModel({
            dataField: 'ExpectedDate',
            caption: 'Expected Date',
            dataType: 'date'
        }), {
            dataField: 'CheckAmount',
            format: 'currency',
            dataType: 'number',
            precision: 2
        }, ]
    }
    if (_model == 'Edit') {
        $scope.initEdit(PortalUtility.QueryUrl().Id);
    }
    $scope.ensurePush = function (modelName, data) {
        ptCom.ensurePush($scope, modelName, data);
    }

    $scope.RequestPreSign = function () {
        $scope.Save();
        if (window.parent && window.parent.preAssignPopopClient) {
            var popup = window.parent.preAssignPopopClient
            popup.Hide();

        }
    }
});
/*************************end old style contoller**************************/