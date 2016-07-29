describe('PreSign', function () {
    var service, scope;

    beforeEach(function () {
        module('PortalApp');
        inject(function (PreSign) {
            service = PreSign;

        })

    });

    it("should not pass validation when validation is null", function () {

        var preSign = new service();

        expect(docSearch.validation).toBeDefined();
    });

    it("should not pass validation when not sent ExpectedDate", function () {
        var preSign = new service();
        preSign.ExpectedDate = null
        expect(preSign.validation()).toBeFalse();
    })

    it("should not pass validation when there is not Parties", function () {
        var preSign = new service();
        preSign.Parties = []
        expect(preSign.validation()).toBeFalse();
    })

    it("should not pass validation when NeedCheck is ture but not check", function () {
        var preSign = new service();
        preSign.NeedCheck = true;
        preSign.Checks = [];
        expect(preSign.validation()).toBeFalse();
    })
    it("should not pass validation when Check amount more then DealAmount", function () {
        var preSign = new service();
        preSign.CheckRequestData = { Checks: [{Amount:10}]}
        preSign.DealAmount = 1;
       
        expect(preSign.validation()).toBeFalse();
    })

    it("should not pass validation.", function () {
        var preSign = new service();
        preSign.CheckRequestData = { Checks: [{ Amount: 10 }] }
        preSign.DealAmount = 11;
        preSign.NeedCheck = true;
        preSign.Parties = [{}]
        expect(preSign.validation()).toBeTrue();
    })
});