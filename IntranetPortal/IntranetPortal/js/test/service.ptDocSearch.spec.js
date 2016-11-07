describe('DocSearch', function () {
    var docSearch, scope;

    beforeEach(function () {
        module('PortalApp');
        inject(function (DocSearch) {
            docSearch = DocSearch;
           
        })

    });

    it("should have perorty type is LeadResearch",function(){
    	expect(docSearch.get).toBeDefined();
    })

    it("should can query all data",function(){

    	docSearch.get({BBLE:"1234567"},function(){
    		console.log(this.BBLE)
    	})
    	expect(docSearch.query).toBeDefined();
    	expect(docSearch.save).toBeDefined();
    })

});