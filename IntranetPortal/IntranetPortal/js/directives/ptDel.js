angular.module("PortalApp")
    .directive('ptDel', function () {
        return {
            restrict: 'E',
            template: '<i class="fa fa-times icon_btn text-danger tooltip-examples" title="Delete"></i>',
        }
    })