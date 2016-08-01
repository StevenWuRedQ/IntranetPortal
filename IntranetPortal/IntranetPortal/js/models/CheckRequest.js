/**
 * @return {[class]}                 CheckRequest class
 */
angular.module('PortalApp').factory('CheckRequest', function (ptBaseResource, BusinessCheck) {
    var checkRequest =  ptBaseResource("CheckRequest",'Id',null,null);
    
    checkRequest.prototype.getTotalAmount = function ()
    {
        if(this.Checks)
        {
            /*** Covert checks data to BusinessCheck type ***/
            var _checks = _.map(this.Checks, function (o) { return checkRequest.CType(o, BusinessCheck) });
            /************************************************/
            
            return _.sum(_.filter(_checks, function (o) { return !o.isVoid() }), 'Amount');
        }

        return 0;
    }

    checkRequest.prototype.Type = 'Short Sale';
    checkRequest.prototype.Checks = [{}];

    return checkRequest;

});