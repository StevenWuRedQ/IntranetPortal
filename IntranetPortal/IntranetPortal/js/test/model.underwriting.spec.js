describe('ptUnderwriter', function () {
    var ptUnderwriter, $httpBackend;

    beforeEach(module("PortalApp"));

    beforeEach(inject(function ($injector) {
        ptUnderwriter = $injector.get('ptUnderwriter');
        $httpBackend = $injector.get('$httpBackend');

    }));

    it("should init without bble passed", function () {
        var data = ptUnderwriter.load();
        expect(typeof data['LienCosts'] == 'object').toBe(true);
        // test default values exist
        expect(data['LienCosts'].TaxLienCertificate == 0.0).toBe(true);
    });

    it("should merge data", function () {
        $httpBackend.when('GET', '/api/underwriter/1234').respond({
            LienCosts: {
                TaxLienCertificate: 0.1
            }
        })
        var data = ptUnderwriter.load('1234');
        data.$promise.then(function () {
            expect(data['LienCosts'].TaxLienCertificate == 0.0).toBe(true);
        })

    })
})