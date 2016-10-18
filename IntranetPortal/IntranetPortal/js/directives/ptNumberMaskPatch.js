angular.module("PortalApp")
    .directive('ptNumberMaskPatch', function () {
        return {
            priority: 1,
            restrict: 'A',
            link: function (scope, el, attrs) {
                var format = attrs['maskformat'] || '';
                scope.$watch(attrs.ngModel, function (newvalue) {
                    if ($(el).is(":focus")) return;
                    if (format == 'money') {
                        if (typeof newvalue == 'string') {
                            var cleanedvalue = newvalue.replace("$", "").replace(",", "")
                            angular.element(el).scope().$eval(attrs.ngModel + "='" + cleanedvalue + "'")
                        }
                    }
                });
                $(el).on('blur', function () {
                    if (format == 'money') {
                        if (typeof this.value == 'string') {
                            var cleanedvalue = this.value.replace("$", "").replace(",", "");
                            if (cleanedvalue.length != this.value.length) {
                                var targetScope = angular.element(el).scope();
                                targetScope.$eval(attrs.ngModel + "='" + cleanedvalue + "'");
                                targetScope.$apply();
                            }
                        }
                    }
                })
            }
        }
    })
