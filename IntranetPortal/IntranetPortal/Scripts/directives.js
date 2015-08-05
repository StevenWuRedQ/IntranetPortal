var portalApp = angular.module('PortalApp');

portalApp.directive('ssDate', function () {
    return {
        restrict: 'A',
        link: function (scope, el, attrs) {
            $(el).datepicker();
            var initFlag = true;
            scope.$watch(attrs.ngModel, function (newValue, oldValue) {
                var dateStr = newValue;
                if (!dateStr && oldValue != null && initFlag) {
                    scope.$eval(attrs.ngModel + "='" + oldValue + "'");
                    initFlag = false;
                }
                dateStr = !dateStr ? null : dateStr.toString();
                if (dateStr && dateStr.indexOf('-') >= 0) {
                    var dd = new Date(dateStr);
                    dd = (dd.getUTCMonth() + 1) + '/' + (dd.getUTCDate()) + '/' + dd.getUTCFullYear();
                    scope.$eval(attrs.ngModel + "='" + dd + "'");
                }
            })
        }
    };
});

portalApp.directive('inputMask', function () {
    return {
        restrict: 'A',
        link: function (scope, el, attrs) {
            $(el).mask(attrs.inputMask);
            $(el).on('change', function () {
                scope.$eval(attrs.ngModel + "='" + el.val() + "'");
            });
        }
    };
});

portalApp.directive('bindId', function (ptContactServices) {
    return {
        restrict: 'A',
        link: function postLink(scope, el, attrs) {
            scope.$watch(attrs.bindId, function (newValue, oldValue) {
                if (newValue != oldValue) {
                    var contact = ptContactServices.getContactById(newValue);
                    if (contact) scope.$eval(attrs.ngModel + "='" + contact.Name + "'");
                }
            })
        }

    }
});

portalApp.directive('radioInit', function () {
    return {
        restrict: 'A',
        link: function (scope, el, attrs) {
            scope.$eval(attrs.ngModel + "=" + attrs.ngModel + "==null?" + attrs.radioInit + ":" + attrs.ngModel);
            scope.$watch(attrs.ngModel, function () {
                var bVal = scope.$eval(attrs.ngModel);
                bVal = bVal != null && (bVal == 'true' || bVal == true);
                scope.$eval(attrs.ngModel + "=" + bVal.toString());

            })
        }
    }
});

portalApp.directive('moneyMask', function () {
    return {
        restrict: 'A',
        link: function (scope, el, attrs) {

            scope.$watch(attrs.ngModel, function () {
                if ($(el).is(":focus")) return;
                $(el).formatCurrency();
            })
            $(el).on('blur', function () { $(this).formatCurrency(); });
            $(el).on('focus', function () { $(this).toNumber() });

        },
    };
});

portalApp.directive('numberMask', function () {
    return {
        restrict: 'A',
        link: function (scope, el, attrs) {

            scope.$watch(attrs.ngModel, function () {
                if ($(el).is(":focus")) return;
                $(el).formatCurrency({ symbol: "" });
            })
            $(el).on('blur', function () { $(this).formatCurrency({ symbol: "" }); });
            $(el).on('focus', function () { $(this).toNumber() });

        },
    };
});

portalApp.directive('ptRadio', function () {
    return {
        restrict: 'E',
        template:
            '<input type=\'checkbox\' id=\'{{name}}Y\' ng-model=\'model\' class=\'ss_form_input\'>' +
            '<label for=\'{{name}}Y\' class=\'input_with_check\'><span class=\'box_text\'>Yes&nbsp</span></label>' +
            '<input type=\'checkbox\' id=\'{{name}}N\' ng-model=\'model\'  ng-true-value="false" ng-false-value="true" class=\'ss_form_input\'>' +
            '<label for=\'{{name}}N\' class=\'input_with_check\'><span class=\'box_text\'>No&nbsp</span></label>',

        scope: {
            model: '=',
            name: '@'
        },
        link: function postLink(scope, el, attrs) {
            var bVal = scope.model;
            scope.model = bVal == null ? false : bVal;
        }

    }
});

portalApp.directive('ptCollapse', function () {
    return {
        restrict: 'E',
        template:
            '<i class="fa fa-compress icon_btn text-primary" ng-show="!model" ng-click="model=!model"></i>' +
            '<i class="fa fa-expand icon_btn text-primary" ng-show="model" ng-click="model=!model"></i>',
        scope: {
            model: '=',
        },
        link: function postLink(scope, el, attrs) {
            var bVal = scope.model;
            scope.model = bVal === undefined ? false : bVal;
        }

    }
});

portalApp.directive('ckEditor', [function () {
    return {
        require: '?ngModel',
        link: function (scope, elm, attr, ngModel) {

            var ck = CKEDITOR.replace(elm[0], {
                allowedContent: true,
                height: 450,
            });

            ck.on('pasteState', function () {
                scope.$apply(function () {
                    ngModel.$setViewValue(ck.getData());
                });
            });

            ngModel.$render = function (value) {
                ck.setData(ngModel.$modelValue);
            };
        }
    };
}])

portalApp.directive('ptAdd', function () {
    return {
        restrict: 'E',
        template: '<i class="fa fa-plus-circle icon_btn text-primary tooltip-examples" title="Add"></i>',
    }
})

portalApp.directive('ptDel', function () {
    return {
        restrict: 'E',
        template: '<i class="fa fa-times icon_btn text-danger tooltip-examples" title="Delete"></i>',
    }
})


