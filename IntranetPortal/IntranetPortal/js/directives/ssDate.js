angular.module("PortalApp")
    .directive('ssDate', function () {
        return {
            restrict: 'A',
            scope: true,
            compile: function (tel, tAttrs) {
                return {
                    post: function (scope, el, attrs) {
                        $(el).datepicker({
                            forceParse: false,
                        });
                        scope.$watch(attrs.ngModel, function (newValue, oldValue) {
                            var dateStr = newValue;
                            if (dateStr && typeof dateStr === 'string' && dateStr.indexOf('T') > -1) {

                                var dd = new Date(dateStr);
                                dd = (dd.getUTCMonth() + 1) + '/' + (dd.getUTCDate()) + '/' + dd.getUTCFullYear();
                                $(el).datepicker('update', new Date(dd))
                            }
                        });
                    }
                }
            }
        };
    })