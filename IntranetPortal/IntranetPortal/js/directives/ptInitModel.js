angular.module("PortalApp")
    .directive('ptInitModel', function () {
        return {
            restrict: 'A',
            require: '?ngModel',
            priority: 99,
            link: function (scope, el, attrs) {
                scope.$watch(attrs.ptInitModel, function (newVal) {
                    if (!scope.$eval(attrs.ngModel) && newVal) {
                        if (typeof newVal === 'string') newVal = newVal.replace(/'/g, "\\'");
                        scope.$eval(attrs.ngModel + "='" + newVal + "'");
                    }
                });
            }
        }
    })