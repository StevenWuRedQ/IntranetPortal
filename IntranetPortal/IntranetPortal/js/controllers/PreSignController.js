// global item will be called by datagrid celltemplete functions
var PreSignHelper = (function () {
    var onAccoutingReview = function (checkid) {
        var element = angular.element('#pt-preassign-accouting-ctrl');
        if (element.length > 0) {
            scope = element.scope();
            scope.load(checkid);
        }
    }

    return {
        onAccoutingReview: onAccoutingReview,
    }
})();


var portalApp = angular.module('PortalApp');


portalApp.config(function (portalRouteProvider) {

    var newPreSignResolve = ['$route', 'PreSign', function ($route, PreSign) {
        var preSign = new PreSign();
        preSign.BBLE = $route.current.params.BBLE.toString();
        // debugger;
        return preSign;
    }];

    var preSignListResolve = ['PreSign', function (PreSign) {
        return PreSign.query();
    }];
    var preSignItemResolve = ['$route', 'PreSign', function ($route, PreSign) {
        var preSignId = $route.current.params[portalRouteProvider.ITEM_ID]
        return PreSign.get({ Id: preSignId });
    }];

    var preSignFinanceListResolve = ['PreSign', function (PreSign) {
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
        .whenNew({ PreSignItem: newPreSignResolve })
        // #/preassign/28
        .whenEdit({ PreSignItem: preSignItemResolve })
        // #/preassign/view/28
        .whenView({ PreSignItem: preSignItemResolve })
        // #/preassign
        .whenList({ PreSignList: preSignListResolve })
        // #/preassign/finance/list
        // I don not know why need the suffix url list
        // otherwise it will go to edit view
        .whenOther({ PreSignFinaceList: preSignFinanceListResolve }, 'Finance', 'list')
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

var CONSTANT_ASSIGN_CHECK_GRID_OPTION = {
    bindingOptions: {
        dataSource: 'preAssign.CheckRequestData.Checks',
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
    }, {
        dataField: 'Comments',
        caption: 'Void Reason'
    }],
    //show avoid check any time
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
    }],
    wordWrapEnabled: true
}

/**************************************** end constant define ******************************/
/**
 * HOI name histroy
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

portalApp.controller('preAssignEditCtrl', ['$scope', 'ptCom', 'PreSignItem', 'DxGridModel', '$location', 'PortalHttpInterceptor', '$http', function ($scope, ptCom, PreSignItem, DxGridModel, $location, PortalHttpInterceptor, $http) {

    $scope.preAssign = PreSignItem;
    $scope.preAssign.CreateBy = $scope.preAssign.CreateBy || $('#currentUser').val();
    $scope.preAssign.CheckRequestData = $scope.preAssign.CheckRequestData || { Type: 'Short Sale', Checks: [] };
    if (!$scope.preAssign.Id) {
        $scope.preAssign.CheckRequestData = { Type: 'Short Sale', Checks: [] };
        $scope.preAssign.Parties = [];
        $scope.preAssign.NeedSearch = true;
        $scope.preAssign.NeedCheck = true;
    }
    if ($scope.preAssign.BBLE) {
        $http.get('/api/Leads/LeadsInfo/' + $scope.preAssign.BBLE, { options: { noError: true } })
             .then(function (data) {
                 $scope.preAssign.Title = data.PropertyAddress;
             });
    }


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

    // check if we need redirect
    $scope.CheckByBBLE = function () {
        var preAssign = $scope.preAssign;
        // preAssign have already been requested, now in edit mode.
        if (preAssign.$promise != null) {
            return;
        }
        // if we can get result from database, redirect to view mode.
        if (preAssign.Id == 0 || preAssign.Id == null) {
            // debugger;
            preAssign.$getByBBLE(function () {
                $location.path('/preassign/view/' + preAssign.Id);
            })
        }
    }
    $scope.CheckByBBLE();

    $scope.partiesGridOptions = new DxGridModel(CONSTANT_ASSIGN_PARTIES_GRID_OPTION, {
        editMode: "cell",
    });
    $scope.checkGridOptions = {
        bindingOptions: {
            dataSource: 'preAssign.CheckRequestData.Checks',
            columns: 'scopeColumns'
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
        summary: {
            calculateCustomSummary: function (options) {
                if (options.name == 'SumAmount') {
                    options.totalValue = _.sum(_.filter(options.component._options.dataSource, function (o) {
                        return o.Status != 1;
                    }), "Amount");
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
    $scope.scopeColumns = [{
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
    }, ];
    $scope.checkGridOptions.onRowPrepared = function (e) {
        if (e.data && e.data.Status == 1) {
            e.rowElement.addClass('avoid-check');
        }
    }
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
                        e.model.Status = 1;
                        e.data.Status = 1;
                        e.data.Comments = voidReason;

                        $('#gridChecks').dxDataGrid('instance').refresh();
                        $scope.deletedCheck = data;
                    }
                });
                var message = PortalHttpInterceptor.BuildAjaxErrorMessage(response);
                if (message) {
                    AngularRoot.alert(message);
                };
            }
        }, true)
        $('#gridChecks').dxDataGrid('instance').refresh();
    }
    var path = $location.path();
    // if in edit mode but not new mode, 
    // void button crsos out item
    $scope.isAccounting = true;
    if (path.indexOf('new') < 0) {
        $scope.checkGridOptions.onRowRemoving = $scope.CancelCheck;
        $scope.checkGridOptions.onRowInserting = $scope.AddCheck;
        /**
         * Add Accouting Function under editing mode
         * @author: Shaopeng Zhang
         * @data: 2016/11/16
         */
        var accounting_col = {
            caption: 'Accouting',
            cellTemplate: function (cellElement, cellInfo) {
                var checkId = cellInfo.data && cellInfo.data.CheckId;
                cellElement.html('<a onclick="PreSignHelper.onAccoutingReview(' + checkId + ')" href="javascript:void(0)">Review</a>')
            },
            visible: $scope.isAccounting,
        }
        $scope.scopeColumns.push(accounting_col);
    }
    $scope.test = function () {
        console.log('test');
    }
    $scope.$on('$viewContentLoaded', function () {
        var checkGrid = $('#gridchecks').dxDataGrid('instance');
        if (checkGrid) {
            checkGrid.refresh();
        }
    })

}]);

portalApp.controller('preAssignViewCtrl', function ($scope, PreSignItem, DxGridModel, CheckRequest) {
    $scope.preAssign = PreSignItem;
    if (!$scope.preAssign.CheckRequestData) {
        $scope.preAssign.CheckRequestData = { Checks: [{}] };
    }

    $scope.partiesGridOptions = new DxGridModel(CONSTANT_ASSIGN_PARTIES_GRID_OPTION);
    $scope.checkGridOptions = new DxGridModel(CONSTANT_ASSIGN_CHECK_GRID_OPTION);
    $scope.CheckRowPrepared = function (e) {
        if (e.data && e.data.Status == 1) {
            e.rowElement.addClass('avoid-check');
        }
    }
    $scope.checkGridOptions.onRowPrepared = $scope.CheckRowPrepared;

    $scope.$on('$viewContentLoaded', function (e) {
        var checkGrid = $('#gridchecks').dxDataGrid('instance');
        if (checkGrid) {
            checkGrid.refresh();
        }

        $("#preDealForm input").prop("disabled", true);
        $("#preDealForm select").prop("disabled", true);
    });

});

portalApp.controller('preAssignFinanceCtrl', function ($scope, PreSignFinaceList) {
    $scope.preSignList = PreSignFinaceList;
    $scope.CheckRowPrepared = function (e) {
        if (e.data && e.data.Status == 1) {
            e.rowElement.addClass('avoid-check');
        }
    }
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

});

portalApp.controller('preAssignListCtrl', function ($scope, PreSignList) {
    $scope.preSignList = PreSignList;
    $scope.preSignRecordsGridOpt = angular.extend({}, CONSTANT_ASSIGN_LIST_GRID_OPTION);
});

portalApp.controller('ptPreAssignAccoutingCtrl', function ($scope, $http, $uibModal) {
    $scope.data = {};
    $scope.load = function (checkid) {
        $scope.data = {
            "CheckId": checkid,
            "ConfirmedAmount": undefined,
            "CheckNo": undefined
        }

        $http({
            url: 'api/BusinessCheck/' + checkid,
            method: 'GET',
            options: {noError: true}
        }).then(function (d) {
            $scope.data = d.data;
        })
        // debugger;
        $scope.modal = $uibModal.open({
            templateUrl: 'pt-preassign-accouting-modal'
        })
    }

    $scope.update = function () {
        $http({
            url: '/api/BusinessCheck/' + checkid + '/Process',
            method: 'POST',
            data: this$scope.data
        })
    }
    $scope.closeModal = function () {
        debugger;
        if ($scope.modal) {
            $scope.modal.close();
        }
    }

})

/** fucking below is uesless! **/

/*************************old style contoller******************************/
portalApp.controller('preAssignCtrl', function ($scope, ptCom, PortalHttpInterceptor, $http) {

    $scope.showHistroy = function () {
        auditLog.show(null, $scope.preAssign.Id);
    }

});
/*************************end old style contoller**************************/