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

        
        return ScopeHelper.getScope('ShortSaleCtrl');
    }
    _class.getLeadsSearchScope = function()
    {
        return ScopeHelper.getScope('LeadTaxSearchCtrl');
    }
    return _class;
});

