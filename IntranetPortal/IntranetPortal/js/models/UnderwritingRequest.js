angular.module('PortalApp')
    .factory('UnderwritingRequest', ['$http', 'ptBaseResource', function ($http, ptBaseResource) {

        var resource = ptBaseResource('underwriter', 'BBLE', null, {});
        return resoure;
    }]);