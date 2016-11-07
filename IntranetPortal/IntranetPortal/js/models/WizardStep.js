/**
 * Wizard step item  class
 * @return {[WizardStep]}                 WizardStep class
 */
angular.module('PortalApp').factory('WizardStep', function () {
    /**
     * WizardStep constructor
     * @param {object} step
     */
    var _class = function (step) {
        
        this.title = step.title;
        this.next = step.next;
        this.init = step.init;
        angular.extend(this, step);
    }
    /**
     * wizard title
     */
    _class.prototype.title = "";
    /**
     * interface of wizard can move to next or not default is true
     * @returns {boolean} wizard can move to next or not
     */
    _class.prototype.next = function ()
    {
        return true;
    }
    /**
     * interface of wizard preload function it will call
     * before wizard contet showup.
     * @returns {boolean} wizard preload function
     */
    _class.prototype.init = function()
    {
        return true;
    }

    return _class;
});