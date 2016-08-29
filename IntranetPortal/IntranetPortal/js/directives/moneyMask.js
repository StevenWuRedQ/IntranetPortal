angular.module("PortalApp")
    .directive('moneyMask', function () {
        return {
            restrict: 'A',
            link: function (scope, el, attrs) {

                scope.$watch(attrs.ngModel, function () {
                    if ($(el).is(":focus")) return;
                    $(el).formatCurrency();
                });
                $(el).on('blur', function () {
                    $(this).formatCurrency();
                });
                $(el).on('focus', function () {
                    $(this).toNumber()
                });

            },
        };
    })