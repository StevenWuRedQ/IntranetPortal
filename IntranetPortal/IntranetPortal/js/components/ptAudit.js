angular.module('PortalApp').component('ptAudit', {

    templateUrl: '/js/components/ptAudit.tpl.html',
    bindings: {
        label: '@',
        objName: '@',
        isUnderwriting: "@",
        recordId: '<',
    },
    controller: function ($scope, $element, $attrs, $http) {
        var ctrl = this;
        ctrl.init = function () {
            if (ctrl.objName != null && ctrl.recordId != null) {
                ctrl.updateData();
            }
        }
        ctrl.show = function (/* optional */objName, /* optional*/ recordId) {
            if (objName != null || recordId != null) {
                ctrl.objectName = objName || ctrl.objectName;
                ctrl.recordId = recordId || ctrl.recordId;
                ctrl.updateData();
            }
            ctrl.showDetail = true;
            return;
        }
        ctrl.hide = function () {
            ctrl.showDetail = false;
        }
        ctrl.toggle = function (objName, recordId) {
            if (ctrl.showDetail) {
                ctrl.hide();
            } else {
                ctrl.show(objName, recordId)
            }
        }
        ctrl.updateData = function () {
            //debugger;
            var targetUrlPrefix = '/api/auditlog/';
            if (ctrl.isUnderwriting) targetUrlPrefix = '/api/underwriting/auditlog/';
            $http({
                method: 'GET',
                url: targetUrlPrefix + ctrl.objName + "/" + ctrl.recordId
            }).then(function (d) {
                var result = _.groupBy(d.data, function (item) {
                    return item.EventDate;
                });
                ctrl.AuditLogs = result;
                if (result && Object.keys(result).length > 0) {
                    ctrl.logsize = Object.keys(result).length;
                } else {
                    ctrl.logsize = 0;
                }
            })

        }
        ctrl.init();
    }
})