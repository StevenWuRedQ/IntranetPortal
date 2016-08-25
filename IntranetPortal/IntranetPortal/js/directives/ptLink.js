angular.module("PortalApp")
    .directive('ptLink', ['ptFileService', function (ptFileService) {
        return {
            restrict: 'E',
            scope: {
                ptModel: '='
            },
            template: '<a ng-click="onFilePreview(ptModel.path)">{{trunc(ptModel.name,20)}}</a>',
            link: function (scope, el, attrs) {
                scope.onFilePreview = ptFileService.onFilePreview;
                scope.trunc = ptFileService.trunc;
            }

        }
    }])