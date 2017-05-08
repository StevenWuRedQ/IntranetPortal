angular.module('PortalApp').component('ptSelectableInput', {

    template: '<div>' +
              '<select ng-model="$ctrl.selected">' +
              '<option ng-repeat="p in $ctrl.options">{{p}}</option>' +
              '</select>&nbsp;' +
              '<input type="text" ng-model="$ctrl.ngModel" ng-show="$ctrl.isOtherSelected" placeholder="other">' +
              '</input>' +
              '</div>',
    bindings: {
        optionss: '@',
        disableOptions: '=',
        ngModel: '='
    },
    controller: function ($scope, $element, $attrs, $http) {
        var ctrl = this;
        ctrl.options = ctrl.optionss.split("|");
        if (!ctrl.disableOptions || !ctrl.options) {
            ctrl.isOtherSelected = true;
        }
        $scope.$watch('$ctrl.selected',
            function(newValue, oldValue) {
                //debugger;
                if (!newValue) {
                    ctrl.ngModel = "";
                    return;
                }
                if (newValue == 'other') {
                    ctrl.isOtherSelected = true;
                    ctrl.ngModel = "";
                    return;
                }
                if (ctrl.options.indexOf(newValue) >= 0) {
                    ctrl.isOtherSelected = false;
                    ctrl.ngModel = newValue;
                    return;
                }

                ctrl.ngModel = "";

            });
        $scope.$watch('$ctrl.ngModel',
            function(newValue, oldValue) {
                if (newValue != "other" && ctrl.options.indexOf(newValue) >= 0) {
                    ctrl.selected = newValue;
                }
            });
    }

})