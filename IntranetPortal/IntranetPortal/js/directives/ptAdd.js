angular.module("PortalApp")
    .directive('ptAdd', function () {
        return {
            restrict: 'E',
            template: '<i class="fa fa-plus-circle icon_btn text-primary tooltip-examples" title="Add"></i>',
        }
    })