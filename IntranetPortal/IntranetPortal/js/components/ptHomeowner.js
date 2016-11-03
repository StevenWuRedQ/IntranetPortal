angular.module('PortalApp').component('ptAudit', {

    templateUrl: '/js/templates/ptAudit.html',
    bindings: {
        label: '@',
        objName: '@',
        recordId: '<',
    },
    controller: function ($scope, $element, $attrs, $http) {

    }
});