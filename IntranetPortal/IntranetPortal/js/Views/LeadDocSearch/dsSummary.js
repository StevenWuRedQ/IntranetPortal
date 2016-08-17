angular.module("PortalApp")
.directive('dsSummary', function () {
    return {
        restrict: 'E',
        scope: {
            summary:'='
        },
        templateUrl:'/js/Views/LeadDocSearch/new_ds_summary.html'
    };
})