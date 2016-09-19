angular.module('PortalApp').factory('ptBaseResource', function ($resource) {
    var BaseUri = '/api';

    var PtBaseResource = function (apiName, key, paramDefaults, actions) {
        var uri = BaseUri + '/' + apiName + '/:' + key;
        var primaryKey = {};
        primaryKey[key] = '@' + key;

        /*default actions add put */
        var _actions = {
            'update': { method: 'PUT' }
        };

        angular.extend(primaryKey, paramDefaults)
        angular.extend(_actions, actions);

        var Resource = $resource(uri, primaryKey, _actions);

        //static function
        Resource.all = function () { }
        Resource.CType = function (obj, Class) {

            if (obj == null || obj == undefined) {
                return null;
            }

            if (obj instanceof Class) {
                return obj;
            }
            var _new = new Class();
            angular.extend(_new, obj);
            angular.extend(obj, _new);
            return _new;
        }

        Resource.prototype.hasId = function () {
            return this[key] != null && this[key] != 0;
        }
        /*********Use for Derived class implement validation interface *************/
        /**************** string array to hold error messages **********************/
        Resource.prototype.errorMsg = [];

        Resource.prototype.clearErrorMsg = function () {
            /* maybe cause memory leak if javascript garbage collection is not good */
            this.errorMsg = []
        }

        Resource.prototype.getErrorMsg = function () {
            return this.errorMsg;
        }
        Resource.prototype.getErrorMsgStr = function () {
            return this.errorMsg.join('<br />');
        }
        Resource.prototype.hasErrorMsg = function () {

            return this.errorMsg && this.errorMsg.length > 0;
        }

        Resource.prototype.pushErrorMsg = function (msg) {
            if (!this.errorMsg) { this.errorMsg = [] };
            this.errorMsg.push(msg);
        }

        /***************************************************************************/
        /*base class instance function*/
        Resource.prototype.$put = function () {

        }

        Resource.prototype.$cType = function (_this, Class) {
            Resource.CType(this, Class);
        }
        return Resource;

    }

    return PtBaseResource;
});