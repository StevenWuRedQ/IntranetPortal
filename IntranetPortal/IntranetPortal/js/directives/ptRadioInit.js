// the original attribute apply to regular <input type=radio>
// @deprecated, use <pt-radio> instead!
angular.module("PortalApp")
    .directive('ptRadioInit', function () {
        return {
            restrict: 'A',
            link: function (scope, el, attrs) {
                scope.$eval(attrs.ngModel + "=" + attrs.ngModel + "==null?" + attrs.radioInit + ":" + attrs.ngModel);
                scope.$watch(attrs.ngModel, function () {
                    var bVal = scope.$eval(attrs.ngModel);
                    bVal = bVal != null && (bVal == 'true' || bVal == true);
                    scope.$eval(attrs.ngModel + "=" + bVal.toString());
                });
            }
        }
    })