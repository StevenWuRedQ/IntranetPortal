angular.module("PortalApp")
    .factory('ptEntityService', ['$http', function ($http) {
    return {
        getEntityByBBLE: function (bble, callback) {
            var url = '/api/CorporationEntities/ByBBLE?BBLE=' + bble;
            $http.get(url).then(function success(res) {
                if (callback) callback(null, res.data);
            }, function error(res) {
                if (callback) callback("load fail", res.data);
            });
        }
    };
}]);