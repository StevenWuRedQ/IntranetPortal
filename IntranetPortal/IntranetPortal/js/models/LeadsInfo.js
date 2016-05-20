//Leads/LeadsInfo
angular.module('PortalApp').factory('LeadsInfo', function (ptBaseResource) {

    var leadsInfo = ptBaseResource('LeadsInfo', 'BBLE',null,
    { verify: { url: '/api/LeadsInfo/Verify' } });
   

    //leadResearch.prototype.func
    //def function
    //leadResearch.func
    //constructor
    return leadsInfo;
});