angular.module('PortalApp')
    .factory('UnderwritingRequest', ['$http', 'ptBaseResource', function ($http, ptBaseResource) {

        var resource = ptBaseResource('UnderwritingRequest', 'BBLE', null, {});
        resource.saveByBBLE = function (data) {
            //debugger;
            var promise = $http({
                method: 'POST',
                url: '/api/UnderwritingRequest',
                data: data
            })
            return promise;
        }
        return resource;
    }]);