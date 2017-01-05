describe('ptUnderwriting', function () {
    var ptUnderwriting, $httpBackend;

    beforeEach(module("PortalApp"));

    beforeEach(inject(function ($injector) {
        ptUnderwriting = $injector.get('ptUnderwriting');
        $httpBackend = $injector.get('$httpBackend');

    }));

    it("should init without bble passed", function () {
        var data = ptUnderwriting.load();
        expect(typeof data['LienCosts'] == 'object').toBe(true);
        // test default values exist
        expect(data['LienCosts'].TaxLienCertificate === 0.0).toBe(true);
    });

    it("should merge data", function () {
        $httpBackend.when('GET', '/api/underwriting/1234').respond({
            LienCosts: {
                TaxLienCertificate: 0.1
            }
        })
        var data = ptUnderwriting.load('1234');
        data.$promise.then(function () {
            expect(data['LienCosts'].TaxLienCertificate === 0.0).toBe(true);
        })

    })
})