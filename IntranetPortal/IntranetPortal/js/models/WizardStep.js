/**
 * @return {[class]}                 WizardStep class
 */
angular.module('PortalApp').factory('WizardStep', function () {
    var _class = function (step) {
        
        this.title = step.title;
        this.next = step.next;
        this.init = step.init;
        angular.extend(this, step);
    }
    _class.prototype.title = "";

    _class.prototype.next = function ()
    {
        return true;
    }
    _class.prototype.init = function()
    {
        return true;
    }

    return _class;
});