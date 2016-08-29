angular.module("PortalApp")
    .directive('ptRadio', function () {
        return {
            restrict: 'E',
            template: '<input type="checkbox" id="{{name}}Y" ng-model="model" class="ss_form_input" ng-disabled="ngDisabled">' +
                '<label for="{{name}}Y" class="input_with_check"><span class="box_text">{{trueValue}}&nbsp</span></label>' +
                '<input type="checkbox" id="{{name}}N" ng-model="model" ng-true-value="false" ng-false-value="true" class="ss_form_input" ng-disabled="ngDisabled">' +
                '<label for="{{name}}N" class="input_with_check"><span class="box_text">{{falseValue}}&nbsp</span></label>',
            scope: {
                model: '=',
                name: '@',
                defaultValue: '@',
                trueValue: '@',
                falseValue: '@',
                ngDisabled: '='
            },
            link: function (scope, el, attrs) {
                //scope.ngDisabled = attrs.ngDisabled;
                // scope.disabled = attrs.disabled;
                scope.trueValue = scope.trueValue ? scope.trueValue : 'yes';
                scope.falseValue = scope.falseValue ? scope.falseValue : 'no';
                scope.defaultValue = scope.defaultValue === 'true' ? true : false;
                if (typeof scope.model != 'undefined') {
                    scope.model = scope.model == null ? scope.defaultValue : scope.model;

                }

            }

        }
    })