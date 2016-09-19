angular.module("PortalApp")
    .directive('ptFinishedMark', [function () {
        return {
            restrict: 'E',
            template: '<span ng-if="ssStyle==0">' + '<button type="button" class="btn btn-default" ng-show="!ssModel" ng-click="confirm()">{{text1?text1:"Confirm"}}</button>' + '<button type="button" class="btn btn-success" ng-show="ssModel" ng-dblclick="deconfirm()">{{text2?text2:"Complete"}}&nbsp<i class="fa fa-check-circle"></i></button>' + '</span>' + '<span ng-if="ssStyle==1">' + '<span class="label label-default" ng-show="!ssModel" ng-click="confirm()">{{text1?text1:"Confirm"}}</span>' + '<span class="label label-success" ng-show="ssModel" ng-dblclick="deconfirm()">{{text2?text2:"Complete"}}&nbsp<i class="fa fa-check-circle"></i></span>' + '</span>',
            scope: {
                ssModel: '=',
                text1: '@',
                text2: '@',
                ssStyle: '@'
            },
            link: function (scope, el, attrs) {
                if (!scope.ssModel) scope.ssModel = false;
                if (scope.ssStyle && scope.ssStyle.toLowerCase() === 'label') {
                    scope.ssStyle = 1;
                } else {
                    scope.ssStyle = 0;
                }
                scope.confirm = function () {
                    scope.ssModel = true;
                }
                scope.deconfirm = function () {
                    scope.ssModel = false;
                }
            }
        }
    }])