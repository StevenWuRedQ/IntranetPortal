angular.module("PortalApp")
    .directive('numberMask', function () {
        return {
            restrict: 'A',
            link: function (scope, el, attrs) {
                var isValidate = attrs.hasOwnProperty('isvalidate');
                //debugger;
                var rule = /^(\d+|\d*\.\d+)$/;
                var validate = function (val) {
                    if (typeof (val) == 'number') {
                        return true;
                    } else if (typeof (val) == 'string') {
                        return !!rule.exec(val);
                    } else {
                        return false;
                    }

                }
                scope.$watch(attrs.ngModel, function () {
                    if ($(el).is(":focus")) return;
                    $(el).formatCurrency({
                        symbol: ""
                    });
                });
                $(el).on('blur', function () {
                    if (isValidate) {
                        var res = validate(this.value);
                        if (!res) {
                            $(this).css("background-color", "yellow");
                            $(this).attr('error', 'true');

                        } else {
                            $(this).css("background-color", "");
                            $(this).attr('error', '');
                            $(this).formatCurrency({
                                symbol: ""
                            });
                        }
                    } else {
                        $(this).formatCurrency({
                            symbol: ""
                        });
                    }


                });
                $(el).on('focus', function () {
                    $(this).toNumber()
                });
            },
        };
    })