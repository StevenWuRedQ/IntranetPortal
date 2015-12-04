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
});