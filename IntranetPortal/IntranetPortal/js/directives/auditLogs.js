angular.module("PortalApp")
    .directive('auditLogs', ['AuditLog', function (AuditLog) {
        return {
            restrict: 'E',
            templateUrl: '/js/directives/AuditLogs.tpl.html',
            scope: {
                tableName: '@',
                recordId: '=',
            },
            link: function (scope, el, attrs) {
                setTimeout(function () {
                    AuditLog.load({ TableName: scope.tableName, RecordId: scope.recordId }, function (data) {
                        var result = _.groupBy(data, function (item) {
                            return item.EventDate;
                        });
                        scope.AuditLogs = result;
                    })
                }, 1000);               
            }
        }
    }])