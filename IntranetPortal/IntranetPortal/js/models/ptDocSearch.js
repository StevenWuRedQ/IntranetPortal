﻿
/**
 * @return {[class]}                 DocSearch class
 */
angular.module('PortalApp').factory('DocSearch', function (ptBaseResource, LeadResearch, LeadsInfo, $http) {

    /*api service funciton declear*/
    var docSearch = ptBaseResource('LeadInfoDocumentSearches', 'BBLE', null,
        {
            completed: { method: "post", url: '/api/LeadInfoDocumentSearches/:BBLE/Completed' }
        });


    //docSearch.properties = {
    //    LeadResearch: "{LeadResearch}",
    //    LeadResearchs: "[LeadResearch]"
    //}
    
    docSearch.Stuats = {
        New: 1,
        Completed: 1
    }
    docSearch.prototype.initTeam = function () {
        var self = this
        $http.get('/Services/TeamService.svc/GetTeam?userName=' + this.CreateBy).success(function (data) {
            self.team = data;
        });
    }
    
    docSearch.prototype.initLeadsResearch = function () {
        var self = this;
        //var data1 = LeadsInfo.get({ BBLE: this.BBLE.trim() }, function () {
        var data1 = null;
        if (self.LeadResearch == null) {
            self.LeadResearch = new LeadResearch();
            data1 = self.LeadResearch.initFromLeadsInfo(self.BBLE);
        } else {

            var _LeadSearch = new LeadResearch();
            angular.extend(_LeadSearch, self.LeadResearch);
            self.LeadResearch = _LeadSearch;
            /*always get refershed ssn*/
            if (self.LeadResearch.ownerName) {

                self.LeadResearch.getOwnerSSN(self.BBLE);
            }
        }
       
        //self.LeadResearch = self.LeadResearch || new LeadResearch();

        //});
        return data1;
    }


    /**
     * static function define use class object docSearch.static function;
     */
    /**
     * instance function defanlt use prototype
     * @return {[type]} [description]
     */
    docSearch.prototype.actionTest = function () {
        this.$update()
    }

    /**
     *If property has type use function get property
     */
    docSearch.prototype._leadResearch = function () {
        if (this.LeadResearch && !(this instanceof LeadResearch)) {
            angular.extend(this.LeadResearch, new LeadResearch())
        }
        return this.LeadResearch;
    }

    //def function
    //leadResearch.func
    //constructor
    return docSearch;
});

