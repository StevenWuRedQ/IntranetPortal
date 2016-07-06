/**
 * @return {[class]}                 PreSign class
 */
angular.module('PortalApp').factory('PreSign', function (ptBaseResource) {

    var preSign = ptBaseResource('PreSign', 'Id', null, {
        getByBBLE: {
            method: "GET", url: '/api/PreSign/BBLE/:BBLE'
            , params: {
                BBLE: '@BBLE',
                //Test: '@Test'
            },
            options:{noError:true}
        }
    });
    /** init Id in font end model**/
    // preSign.prototype.Id = 0;
    preSign.prototype.BBLE = '';

    preSign.prototype.Parties = [];
    //Later will change to Checks to Check Class
    preSign.prototype.CheckRequestData = { Checks: [] };
    preSign.prototype.NeedSearch = true;
    preSign.prototype.NeedCheck = true;


    return preSign;
});