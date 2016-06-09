/**
 * @return {[class]}                 PreSign class
 */
angular.module('PortalApp').factory('PreSign', function (ptBaseResource) {

    var preSign = ptBaseResource('PreSign', 'Id', null, {
        BBLE: { method: "get", url: '/api/PreSign/BBLE/:BBLE' }
    });

    preSign.prototype.Parties = [];
    //Later will change to Checks to Check Class
    preSign.prototype.CheckRequestData = { Checks: [] };
    preSign.prototype.NeedSearch = true;
    preSign.prototype.NeedCheck = true;


    return preSign;
});