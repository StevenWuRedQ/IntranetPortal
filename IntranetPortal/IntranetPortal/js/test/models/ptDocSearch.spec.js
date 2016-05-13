describe('DocSearch', function () {
    var service, scope;

    beforeEach(function () {
        module('PortalApp');
        inject(function (DocSearch) {
            service = DocSearch;
           
        })

    });

    it("should have perorty type is LeadResearch",function(){
    	
    	var docSearch = new service();

    	expect(docSearch.get).toBeDefined();
    })

    it("should can query all data",function(){

    	var docSearch = new service();
    	docSearch.get({BBLE:"1234567"},function(){
    		console.log(this.BBLE)
    	})
    	expect(docSearch.query).toBeDefined();
    	expect(docSearch.save).toBeDefined();
    })

});