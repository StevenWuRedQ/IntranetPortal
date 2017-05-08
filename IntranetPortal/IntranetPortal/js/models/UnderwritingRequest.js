angular.module('PortalApp')
    .factory('UnderwritingRequest', ['$http', 'ptBaseResource', 'DocSearch', function ($http, ptBaseResource, DocSearch) {
        var resource = ptBaseResource('UnderwritingRequest', 'BBLE', null, {});
        resource.saveByBBLE = function (data, bble) {
            if (bble) {
                data.BBLE = bble;
            }
            // debugger;
            var promise = $http({
                method: 'POST',
                url: '/api/UnderwritingRequest',
                data: data
            });
            return promise;
        }

        resource.createSearch = function (BBLE) {
            // debugger;
            var promise = $http({
                method: "POST",
                url: '/api/LeadInfoDocumentSearches',
                data: JSON.stringify({ "BBLE": BBLE }),
                header: {
                    'Content-Type': 'application/json'
                }
            });
            return promise;
        }

        return resource;
    }]);