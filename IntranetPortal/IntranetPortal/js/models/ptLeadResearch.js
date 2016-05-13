
angular.module('PortalApp').factory('LeadResearch', function ($http) {

    var leadResearch = function () {


        //constructor init model here
        //this.bble = '12345'

    }

    leadResearch.prototype.getBBLE = function () {
        this.propertyTaxes;
    }

    leadResearch.prototype.getOwnerSSN = function (BBLE) {
        var self = this;
        $http.post("/api/homeowner/ssn/" + BBLE, JSON.stringify(self.ownerName)).
            success(function (ssn, status, headers, config) {
                self.ownerSSN = ssn;
            });
    }
    //leadResearch.prototype.func
    //def function
    //leadResearch.func
    //constructor
    return leadResearch;
});