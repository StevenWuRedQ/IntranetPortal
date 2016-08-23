angular.module("PortalApp")
.directive('newDsSummary', function () {
    return {
        restrict: 'E',
        scope: {
            summary: '=',
            updateby: '=',
            updateon:'='
        },
        templateUrl: '/js/Views/LeadDocSearch/new_ds_summary.html',
        link: function (scope)
        {

        }
    };
})