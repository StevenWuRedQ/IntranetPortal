/**
 * @return {[class]}                 Wizard class
 */
angular.module('PortalApp').factory('Wizard', function (WizardStep) {

    var _class = function () {
       
    }

    _class.prototype.filteredSteps = [];

    _class.prototype.setFilteredSteps = function(filteredSteps)
    {
        this.filteredSteps = filteredSteps;
    }
    _class.prototype.scope = { step: 1 };

    _class.prototype.MaxStep = function()
    {
        return this.filteredSteps.length;
    }
    _class.prototype.setScope = function (scope)
    {
        this.scope = scope;
    }
    _class.prototype.currentStep = function()
    {
        return this.filteredSteps[this.scope.step - 1];
    }
    
    //return $scope.filteredSteps.length;
    return _class;
});