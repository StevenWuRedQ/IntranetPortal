angular.module("PortalApp")
    .directive('ptInitBind', function () { //one way bind of ptInitModel
        return {
            restrict: 'A',
            require: '?ngBind',
            link: function (scope, el, attrs) {
                scope.$watch(attrs.ptInitBind, function (newVal) {
                    if (!scope.$eval(attrs.ngBind) && newVal) {
                        if (typeof newVal === 'string') newVal = newVal.replace(/'/g, "\\'");
                        scope.$eval(attrs.ngBind + "='" + newVal + "'");
                    }
                });
            }
        }
    })