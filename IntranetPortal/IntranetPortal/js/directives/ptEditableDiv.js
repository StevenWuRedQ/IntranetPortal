/***
 * Author: Shaopeng Zhang
 * Date: 2016/11/01
 * Description: A control to lock/unlock are area, make all
 */
angular.module("PortalApp")
    .directive('ptEditableDiv', [function () {
        return {
            restrict: 'A',
            scope: {
                ptLock: '='
            },
            link: function (scope, el, attrs) {
                // debugger;
                angular.element(el).addClass("pt-editable-div");
                scope.isLocked = true;
                scope.unlock = function () {
                    angular.element(".pt-editable-div input, .pt-editable-div textarea, .pt-editable-div select").prop('disabled', false);
                    scope.isLocked = false;
                }
                scope.lock = function () {
                    angular.element(".pt-editable-div input, .pt-editable-div textarea, .pt-editable-div select").prop('disabled', true);
                    scope.isLocked = true;
                }
                scope.$on('pt-editable-div-lock', function () {
                    scope.lock();
                })
                scope.$on('pt-editable-div-unlock', function () {
                    // debugger;
                    scope.unlock();
                })
                if (scope.ptLock) {
                    scope.lock();
                }
            }
        }
    }])