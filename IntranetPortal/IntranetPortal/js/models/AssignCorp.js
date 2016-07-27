/**
 * @return {[class]}                 AssignCorp class
 */
angular.module('PortalApp').factory('AssignCorp', function (ptBaseResource, CorpEntity) {
    var _class = function()
    {

    }

    _class.prototype.test = function()
    {
        this.text = "1234555";
    }

    _class.prototype.AssingCorp = function()
    {

    }
    /**
     * This is not right have parent ID
     * */
    _class.prototype.newOfferId = 0
    return _class;
});