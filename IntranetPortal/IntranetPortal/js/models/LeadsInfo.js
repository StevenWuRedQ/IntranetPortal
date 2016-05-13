//Leads/LeadsInfo
angular.module('PortalApp').factory('LeadsInfo', function (ptBaseResource) {

    var leadsInfo = ptBaseResource('Leads/LeadsInfo', 'BBLE');
   

    //leadResearch.prototype.func
    //def function
    //leadResearch.func
    //constructor
    return leadsInfo;
});