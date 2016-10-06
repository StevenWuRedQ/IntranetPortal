describe('PreSign', function () {
    var scope, preSign;

    beforeEach(function () {
        module('PortalApp');
        inject(function (PreSign) {
            preSign = new PreSign();

        })

    });

    it("should not pass validation when validation is null", function () {
        expect(preSign.validation).toBeDefined();
    });

    it("should not pass validation when not sent ExpectedDate", function () {
        preSign.ExpectedDate = null
        expect(preSign.validation()).toBeFalsy();
    })

    it("should not pass validation when there is not Parties", function () {
        preSign.Parties = []
        expect(preSign.validation()).toBeFalsy();
    })

    it("should not pass validation when NeedCheck is ture but not check", function () {
        preSign.NeedCheck = true;
        preSign.CheckRequestData = {};
        preSign.Checks = [];
        expect(preSign.validation()).toBeFalsy();
    })
    it("should not pass validation when Check amount more then DealAmount", function () {
        preSign.CheckRequestData = { Checks: [{Amount:10}]}
        preSign.DealAmount = 1;
        expect(preSign.validation()).toBeFalsy();
    })

    it("should not pass validation.", function () {
        preSign.CheckRequestData = { Checks: [{ Amount: 10 }] }
        preSign.DealAmount = 11;
        preSign.NeedCheck = true;
        preSign.Parties = [{}]
        expect(preSign.validation()).toBeFalsy();
    })
});