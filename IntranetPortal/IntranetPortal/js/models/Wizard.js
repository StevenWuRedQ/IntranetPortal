/// <reference path="DocSearch.js" />
/**
 * Wizard control to support comstom display and show current step
 * @return {[class]}                 Wizard class
 */
angular.module('PortalApp').factory('Wizard', function (WizardStep) {
    /**
     * Wizard class constructor
     */
    var _class = function () {
       
    }
    /**
     * valule of steped filted by conditions 
     */
    _class.prototype.filteredSteps = [];
    /**
     * `public set filtered steps
     * @param {array of WizardStep object} filteredSteps
     */
    _class.prototype.setFilteredSteps = function(filteredSteps)
    {
        this.filteredSteps = filteredSteps;
    }
    /**
     * contorller scope 
     * similar to other MVC framework context
     */
    _class.prototype.scope = { step: 1 };
    /**
     * get current max step of current steps
     * @returns {int} 
     */
    _class.prototype.MaxStep = function()
    {
        return this.filteredSteps.length;
    }
    /**
     * get class scope, other MVC framework UI context 
     * 
     * @param {angular scope} scope
     */
    _class.prototype.setScope = function (scope)
    {
        this.scope = scope;
    }
    /**
     * get current step
     * @returns {WizardStep object} current step object
     */
    _class.prototype.currentStep = function()
    {
        return this.filteredSteps[this.scope.step - 1];
    }
    
    
    return _class;
});