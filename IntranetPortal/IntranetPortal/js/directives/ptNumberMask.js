/**
 * a input attribute directive to automatic convert input to certain data format
 * example <input pt-number-mask maskformat='money' isvalidate/>
 * (optional) maskerformat: control how data will present.
 * (optional) isvalidate: if the attribute present, will validate if the user input is correct
 */
angular.module("PortalApp")
    .directive('ptNumberMask', function () {
        return {
            restrict: 'A',
            link: function (scope, el, attrs) {
                var isValidate = attrs.hasOwnProperty('isvalidate');
                var format = attrs['maskformat'] || '';
                var formatConfig;
                switch (format) {
                    case 'integer':
                        formatConfig = {
                            symbol: "",
                            roundToDecimalPlace: 0
                        }
                        break;
                    case 'money':
                        formatConfig = {

                        }
                        break;
                    case 'percentage':
                        formatConfig = {
                            symbol: "%",
                            positiveFormat: '%n%s',
                            negativeFormat: '(%n%s)'
                        }
                        break;
                    default:
                        formatConfig = {
                            symbol: ""
                        }

                }
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

                scope.$watch(attrs.ngModel, function (newvalue) {
                    if ($(el).is(":focus")) return;
                    if (format = 'percentage') {
                        $(el)[0].value = newvalue * 100;
                    }
                    $(el).formatCurrency(formatConfig);
                });
                $(el).on('blur', function () {
                    debugger;
                    if (isValidate) {
                        var res = validate(this.value);
                        if (!res) {
                            $(this).css("background-color", "yellow");
                            $(this).attr('error', 'true');

                        } else {
                            $(this).css("background-color", "");
                            $(this).attr('error', '');
                            if (format = 'percentage') {
                                $(el)[0].value = $(el)[0].value * 100;
                            }
                            $(this).formatCurrency(formatConfig);
                        }
                    } else {
                        if (format = 'percentage') {
                            $(el)[0].value = $(el)[0].value * 100;
                        }
                        $(this).formatCurrency(formatConfig);
                    }
                });
                $(el).on('focus', function () {

                    $(this).toNumber();
                    if (format = 'percentage') {
                        $(el)[0].value = $(el)[0].value / 100;
                    }
                });
            },
        };
    })