var portalApp = angular.module('PortalApp');

portalApp.controller('perAssignCtrl', function($scope, ptCom, $firebaseObject, $http, $httpBackend) {

    //console.log($httpBackend);
    $scope.preAssign = {
        Parties: [],
        CheckRequestData: {
            Checks: []
        }
    };
    $scope.showHistroy = function()
    {
        auditLog.show(null, $scope.preAssign.Id);
    }
    var _BBLE = PortalUtility.QueryUrl().BBLE;
    var _model = PortalUtility.QueryUrl().model;
    var _role = PortalUtility.QueryUrl().role;
    $scope.role = _role;
    $scope.model = _model;
    $scope.role = _role;
    $scope.gridEdit = {
        mode: "batch",
        editEnabled: true,
        insertEnabled: true,
        removeEnabled: true
    };
    if (_model == 'List') {
        var checksListApi = $scope.role == 'finance' ? '/api/PreSign/CheckRequests' : '/api/presign/records';
        $http.get(checksListApi).success(function(data) {
            $scope.preSignList = _.map(data, function(p) {
                p.ChecksTotal = _.sum(p.Checks, 'Amount');
                return p;
            });
        });
    }
    if (_model == 'View') {
        setTimeout(function() {
            $("#preDealForm input").prop("disabled", true);
            $("#preDealForm select").prop("disabled", true);
        }, 1000);

        $scope.gridEdit = {}
        var _Id = PortalUtility.QueryUrl().Id;

        var preSignRespose = $.ajax({
            url: '/api/PreSign/' + _Id,
            async: false
        });

        var message = PortalHttp.BuildAjaxErrorMessage(preSignRespose);
        if (message) {
            AngularRoot.alert(message)
        } else {
            $scope.preAssign = JSON.parse(preSignRespose.responseText)
            _BBLE = $scope.preAssign.BBLE

        }

    }
    $scope.init = function(preSignId) {

            $http.get('/api/PreSign/' + preSignId).success(function(data) {
                $scope.preAssign = data;
                $scope.preAssign.Parties = $scope.preAssign.Parties || [];

            });
            //auditLog.show("PreSignRecord",preSignId);
        }
        /**
         * Init Edit model data by id
         * @param  {number} id [pre assign Id]
         */
    $scope.initEdit = function(id) {
        $scope.preAssign.Id = id;
        //$scope.partiesGridEditing = {mode: 'batch', editEnabled: false, insertEnabled: true, removeEnabled: true};
        $scope.partiesGridOptions.editing.editEnabled = true;
        $scope.checkGridOptions.onRowInserting = $scope.AddCheck;
        $scope.checkGridOptions.editing.texts ={  deleteRow: 'Avoid'}
        $scope.checkGridOptions.onRowRemoving = $scope.CancelCheck;
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
        $scope.checkGridOptions.onRowPrepared  = function(e)
        {
            if(e.data && e.data.Status==1)
            {
                e.rowElement.addClass('avoid-check');
            }
        }
        $scope.gridEdit.editEnabled = false;

        $scope.init($scope.preAssign.Id);

    }

    $scope.AddCheck = function(e) {
        var cancel = false;
        e.data.RequestId = $scope.preAssign.CheckRequestData.RequestId;
        e.data.Date = new Date(e.data.Date).toISOString();
        var response = $.ajax({
            url: '/api/businesscheck',
            type: 'POST',
            dataType: 'json',
            async: false,
            data: e.data,
            success: function(data, textStatus, xhr) {
                $scope.addedCheck = data;
                $scope.preAssign.CheckRequestData.Checks.push(data);
                e.cancel = true;
            }
        });

        var message = PortalHttp.BuildAjaxErrorMessage(response);
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
    $scope.CancelCheck = function(e) {

        var response = $.ajax({
            url: '/api/businesscheck/' + e.data.CheckId,
            type: 'DELETE',
            async: false,
            success: function(data, textStatus, xhr) {
                e.model = data;
                e.model.Status = 1;
                e.data.Status = 1;
                // _.remove($scope.preAssign.CheckRequestData.Checks, {
                //     CheckId: e.data.CheckId
                // });
                $scope.preAssign.CheckRequestData.Checks.push(data);
                //_.remove($scope.preAssign.CheckRequestData.Checks,function(o){  return o.CheckId == null});
                
                $('#gridChecks').dxDataGrid('instance').refresh();
                $scope.deletedCheck = data;
            }
        });

        var message = PortalHttp.BuildAjaxErrorMessage(response);
        if (message) {
            AngularRoot.alert(message);
            e.cancel = true;
        };
        return e;
    }

    $scope.preAssign.BBLE = _BBLE
    $scope.preAssign.CheckRequestData.BBLE = $scope.preAssign.BBLE;
    $scope.preAssign.NeedCheck = true;
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
    $scope.NextStep = function() {
        $scope.step++;
    }
    $scope.PrevStep = function() {
        $scope.step--;
    }

    /**
     * @param  {[type]}
     * @return {[type]}
     */

    $scope.initByBBLE = function(BBLE) {
        $http.get('/api/Leads/LeadsInfo/' + BBLE).success(function(data) {
            $scope.preAssign.Title = data.PropertyAddress
        });
        if ($scope.model != 'View') {
            $scope.preAssign.CheckRequestData.Type = "Short Sale";
            $scope.preAssign.DealAmount = 0;
            $scope.preAssign.NeedSearch = true;
        }

    }

    if (_BBLE) {
        $scope.initByBBLE(_BBLE);
    }
    /**
     * [validation description my have diffrent in view mode and edit mode]
     */
    $scope.validationPreAssgin = function() {
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
            $scope.alert("If need request check please fill at least one check!");
            return false;
        }

        if ($scope.CheckTotalAmount() > $scope.preAssign.DealAmount) {
            $scope.alert("The check's total amount must less than the deal amount, Please correct! ");
            return false;
        }
        if (!$scope.preAssign.NeedCheck) {
            $scope.preAssign.Parties = null;
            $scope.preAssign.CheckRequestData = null
        }
        return true;
    }

    $scope.alert = function(msg) {
            if (typeof AngularRoot != 'undefined') {
                AngularRoot.alert(msg)
            }
        }
        /**
         * 
         */
    $scope.Save = function() {
        var selfData = $scope.preAssign;

        if ($scope.preAssign.Id) {
            if ($scope.validationPreAssgin()) {
                $http.put('/api/PreSign/' + $scope.preAssign.Id, JSON.stringify($scope.preAssign)).success(function(data) {
                    if (typeof AngularRoot != 'undefined') {
                        AngularRoot.alert("Updated success!");
                    }
                    //for unit test
                    $scope.localhref = '/popupControl/preAssignCropForm.aspx?model=View&Id=' + $scope.preAssign.Id
                    window.location.href = $scope.localhref
                });
            }

        } else {
            if ($scope.validationPreAssgin()) {
                $http.post('/api/PreSign', JSON.stringify($scope.preAssign)).success(function(data) {
                    AngularRoot.alert("Submit success !");
                    $scope.preAssign = data;
                    window.location.href = '/popupControl/preAssignCropForm.aspx?model=View&Id=' + data.Id
                });
            }

        }

    }

    //var ref = new Firebase("https://sdatabasetest.firebaseio.com/qqq");
    //var syncObject = $firebaseObject(ref);
    //syncObject.$bindTo($scope, "Test");

    $scope.onSelectedChanged = function(e) {
        var request = e.selectedRowsData[0];
        PortalUtility.OpenWindow('/PopupControl/PreAssignCropForm.aspx?model=View&Id=' + request.Id, 'Pre Sign ' + request.BBLE, 800, 900);
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
                        PortalUtility.OpenWindow('/PopupControl/PreAssignCropForm.aspx?model=View&Id=' + request.Id, 'Pre Sign ' + request.BBLE, 800, 900);
                    })
                    .appendTo(container);
            }
        }, {
            dataField: 'CreateBy',
            caption: 'Request By'
        }, {
            dataField: 'CreateDate',
            caption: 'Request Date',
            dataType: 'date'
        }, {
            dataField: 'ExpectedDate',
            caption: 'Expected Date Of Sign',
            dataType: 'date'
        }, {
            dataField: 'DealAmount',
            format: 'currency',
            dataType: 'number',
            precision: 2
        }, {
            dataField: 'NeedSearch',
            caption: 'Search Request'
        }, ],
        wordWrapEnabled: true
    }

    if (_role == 'finance') {
        $scope.preSignRecordsGridOpt.masterDetail = {
            enabled: true,
            template: "detail"
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
        summary: {
            totalItems: [{
                column: "Name",
                summaryType: "count"
            }]
        }
    }

    $scope.CheckTotalAmount = function() {
        return _.sum($scope.preAssign.CheckRequestData.Checks, 'Amount');
    }
    $scope.checkGridOptions = {
        bindingOptions: {
            dataSource: 'preAssign.CheckRequestData.Checks'
        },
        //dataSource: $scope.preAssign.CheckRequestData.Checks,
        paging: {
            pageSize: 10
        },

        editing: $scope.gridEdit,
        pager: {
            showPageSizeSelector: true,
            allowedPageSizes: [5, 10, 20],
            showInfo: true
        },
        wordWrapEnabled: true,
        columns: [{
            dataField: "PaybleTo",
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
        }, {
            dataField: 'Date',
            dataType: 'date',
            validationRules: [{
                type: "required"
            }]
        }, {
            dataField: 'Description',
            validationRules: [{
                type: "required"
            }]
        }, ],
        summary: {
            totalItems: [{
                column: "Name",
                summaryType: "count"
            }, {
                column: "Amount",
                summaryType: "sum",
                valueFormat: "currency",
                precision: 2
            }]
        }
    };
    if (_model == 'Edit') {
        $scope.initEdit(PortalUtility.QueryUrl().Id);
    }
    $scope.ensurePush = function(modelName, data) {
        ptCom.ensurePush($scope, modelName, data);
    }

    $scope.RequestPreSign = function() {
        $scope.Save();
        if (window.parent && window.parent.preAssignPopopClient) {
            var popup = window.parent.preAssignPopopClient
            popup.Hide();

        }
    }
});