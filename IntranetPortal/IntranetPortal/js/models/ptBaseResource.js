angular.module('PortalApp').factory('ptBaseResource', function ($resource) {
    var BaseUri = '/api';

    var PtBaseResource = function (apiName, key, paramDefaults, actions) {
        var uri = BaseUri + '/' + apiName + '/:' + key;
        var primaryKey = {};
        /*default param */

        primaryKey[key] = "@" + key;
        /*default actions add put */
        var _actions = { 'update': { method: 'PUT' } };

        angular.extend(primaryKey, paramDefaults)
        angular.extend(_actions, actions);
        var Resource = $resource(uri, primaryKey, _actions);

        //static function
        Resource.all = function () {

        }
        Resource.cType = function (obj, Class) {

        }

        /*base class instance function*/
        Resource.prototype.$put = function () {

        }

        return Resource;

    }


    //leadResearch.prototype.func
    //def function
    //leadResearch.func
    //constructor
    return PtBaseResource;
});