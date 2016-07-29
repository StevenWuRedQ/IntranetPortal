/**
 * @return {[class]}                 Team class
 */
angular.module('PortalApp').factory('Team', function ($http) {
    var _class = function () {


    }
    _class.getTeams = function (successCall) {

        $http.get('/api/CorporationEntities/Teams')
            .success(successCall);

    }

    _class.prototype.isAvailable = function () {
        return this.Available == true;
    }
    return _class;
});