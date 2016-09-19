angular.module("PortalApp")
    .directive('percentMask', function () {
        return {
            restrict: 'A',
            link: function (scope, el, attrs) {

                scope.$watch(attrs.ngModel, function () {
                    if ($(el).is(":focus")) return;
                    $(el).formatCurrency({
                        symbol: "%",
                        positiveFormat: '%n%s'
                    });
                });
                $(el).on('blur', function () {
                    $(this).formatCurrency({
                        symbol: "%",
                        positiveFormat: '%n%s'
                    });
                });
                $(el).on('focus', function () {
                    $(this).toNumber()
                });

            },
        };
    })