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
        Resource.CType = function (obj, Class) {
            var _new = new Class();
            angular.extend(_new, obj);
            obj = _new;
            return _new;
        }

        /*base class instance function*/
        Resource.prototype.$put = function () {

        }

        Resource.prototype.$cType = function(Class)
        {
            Resource.CType(this, Class);
        }
        return Resource;

    }


    //leadResearch.prototype.func
    //def function
    //leadResearch.func
    //constructor
    return PtBaseResource;
});