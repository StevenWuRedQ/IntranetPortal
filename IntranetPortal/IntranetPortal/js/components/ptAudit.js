angular.module('PortalApp').component('ptAudit', {

    templateUrl: '/js/templates/ptAudit.html',
    bindings: {
        label: '@',
        objName: '@',
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
            debugger;
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
            $http({
                method: 'GET',
                url: '/api/auditlog/' + ctrl.objName + "/" + ctrl.recordId
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