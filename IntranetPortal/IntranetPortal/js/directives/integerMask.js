angular.module("PortalApp")
    .directive('integerMask', function () {
        return {
            restrict: 'A',
            link: function (scope, el, attrs) {

                scope.$watch(attrs.ngModel, function () {
                    if ($(el).is(":focus")) return;
                    $(el).formatCurrency({
                        symbol: "",
                        roundToDecimalPlace: 0
                    });
                });
                $(el).on('blur', function () {
                    $(this).formatCurrency({
                        symbol: "",
                        roundToDecimalPlace: 0
                    });
                });
                $(el).on('focus', function () {
                    $(this).toNumber()
                });

            },
        };
    })