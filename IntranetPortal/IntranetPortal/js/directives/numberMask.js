angular.module("PortalApp")
    .directive('numberMask', function () {
        return {
            restrict: 'A',
            link: function (scope, el, attrs) {

                scope.$watch(attrs.ngModel, function () {
                    if ($(el).is(":focus")) return;
                    $(el).formatCurrency({
                        symbol: ""
                    });
                });
                $(el).on('blur', function () {
                    $(this).formatCurrency({
                        symbol: ""
                    });
                });
                $(el).on('focus', function () {
                    $(this).toNumber()
                });

            },
        };
    })