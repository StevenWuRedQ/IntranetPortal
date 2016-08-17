describe('DivError', function () {
    var service, scope;

    beforeEach(function () {
        module('PortalApp');
        inject(function (DivError) {
            service = DivError;

        })

    });

    it("should have perorty type is DivError", function () {

        var DivError = new service();

        expect(DivError.boolValidate).toBeDefined();

    });

    it("should not pass bool validate object is null", function () {

        var o = { b: null }
        var DivError = new service();
        expect(DivError.boolValidate(o, 'b')).toBeFalsy();
    });

    it("should not pass bool validate object is null 2", function () {

        var o = {}
        var DivError = new service();
        expect(DivError.boolValidate(o, 'b')).toBeFalsy();

    });

    it("should not pass bool validate object is null 2", function () {

        var o = {}
        var DivError = new service();
        expect(DivError.boolValidate(o, 'b')).toBeFalsy();

    });

    
    

});