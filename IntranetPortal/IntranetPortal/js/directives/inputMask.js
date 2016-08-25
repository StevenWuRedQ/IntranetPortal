angular.module("PortalApp")
    .directive('inputMask', function () {
        return {
            restrict: 'A',
            link: function (scope, el, attrs) {
                $(el).mask(attrs.inputMask);
                $(el).on('change', function () {
                    scope.$eval(attrs.ngModel + "='" + el.val() + "'");
                });
            }
        };
    })