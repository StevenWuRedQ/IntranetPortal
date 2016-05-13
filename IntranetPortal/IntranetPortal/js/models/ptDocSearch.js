
/**
 * @return {[class]}                 DocSearch class
 */
angular.module('PortalApp').factory('DocSearch', function (ptBaseResource, LeadResearch, LeadsInfo) {

    var docSearch = ptBaseResource('LeadInfoDocumentSearches', 'BBLE');


    docSearch.properties = {
        LeadResearch: "{LeadResearch}",
        LeadResearchs: "[LeadResearch]"
    }

    docSearch.prototype.initLeadsResearch = function () {
        var self = this;
        var data1 = LeadsInfo.get({ BBLE: this.BBLE.trim() }, function () {
            if (self.LeadResearch == null) {
                self.LeadResearch = new LeadResearch();
                self.ownerName = data1.Owner;
                self.waterCharges = data1.WaterAmt;
                self.propertyTaxes = data1.TaxesAmt;
                self.mortgageAmount = data1.C1stMotgrAmt;
                self.secondMortgageAmount = data1.C2ndMotgrAmt;

            } else {

                var _LeadSearch = new LeadResearch();
                angular.extend(_LeadSearch, self.LeadResearch);
                self.LeadResearch = _LeadSearch;
            }
            /*always get refershed ssn*/
            if (self.LeadResearch.ownerName) {

                self.LeadResearch.getOwnerSSN(self.BBLE);
            }
            //self.LeadResearch = self.LeadResearch || new LeadResearch();

        });
        return data1;
    }
    docSearch.prototype.completed = function (isSave) {

        this.$update();
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

