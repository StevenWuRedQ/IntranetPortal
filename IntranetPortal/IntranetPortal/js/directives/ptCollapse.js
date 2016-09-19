angular.module("PortalApp")
    .directive('ptCollapse', function () {
        return {
            restrict: 'E',
            template: '<i class="fa fa-compress icon_btn text-primary" ng-show="!model" ng-click="model=!model"></i>' +
                '<i class="fa fa-expand icon_btn text-primary" ng-show="model" ng-click="model=!model"></i>',
            scope: {
                model: '=',
            },
            link: function postLink(scope, el, attrs) {
                var bVal = scope.model;
                scope.model = bVal === undefined ? false : bVal;
            }

        }
    })