/**
 * @return {[class]}                 ScopeHelper class
 */
angular.module('PortalApp').factory('ScopeHelper', function ($http) {
    var _class = function () {


    }
    _class.getScope = function (id) {
        return angular.element(document.getElementById(id)).scope();
    }
    _class.getShortSaleScope = function () {

        
        return _class.getScope('ShortSaleCtrl');
    }
    _class.getLeadsSearchScope = function()
    {
        return _class.getScope('DocSearchController');
    }
    return _class;
});

