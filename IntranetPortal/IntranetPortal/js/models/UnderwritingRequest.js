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

        resource.createSearch = function (BBLE) {
            debugger;
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

        resource.getAdditionalInfo = function (BBLE) {
            var promise = $http({
                method: 'GET',
                url: '/api/UnderwritingRequest/GetAdditionalInfo/' + BBLE,
            });
            return promise;
        }


        return resource;
    }]);