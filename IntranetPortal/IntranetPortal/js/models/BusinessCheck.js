/**
 * @return {[class]}                 BusinessCheck class
 */
angular.module('PortalApp').factory('BusinessCheck', function (ptBaseResource) {
    var businessCheck = ptBaseResource('BusinessCheck', 'Id', null, null);
    businessCheck.CheckStatus = {
        Active : 0,
        Canceled : 1,
        Completed : 2
    }
    /*** for instance object to use ****/
    businessCheck.prototype.CheckStatus = {};
    angular.extend(businessCheck.prototype.CheckStatus, businessCheck.CheckStatus);
    /***********************************/

    /* return true if check status is avoid */
    businessCheck.prototype.isVoid = function ()
    {
        return this.Status == this.CheckStatus.Canceled;
    }
    return businessCheck;

});