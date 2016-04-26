describe('directives', function () {
    describe('ssDate', function () {
        var scope, celem, cscope;

        beforeEach(function () {
            module("PortalApp");
            inject(function (_$compile_, _$rootScope_) {
                var html = "<input ng-model='xdate' ss-date></input>";
                scope = _$rootScope_.$new();
                celem = _$compile_(html)(scope);
                scope.$digest();
                cscope = celem.scope();
            })
        });

        it("should format date", function () {
            scope.xdate = "2015-12-14T18:05:36.934Z";
            scope.$digest();
            expect(cscope.xdate).toBe("12/14/2015");

        });

    })

    describe('ptInitModel', function () {

        var scope, celem, cscope;

        beforeEach(function () {
            module("PortalApp");
            inject(function (_$compile_, _$rootScope_) {
                var html = "<input ng-model='xdata' pt-init-model='ydata'></input>";
                scope = _$rootScope_.$new();
                celem = _$compile_(html)(scope);
                scope.$digest();
                cscope = celem.scope();
            })
        })

        it('should ydata if xdata is undefined', function () {
            scope.ydata = 'yes';
            scope.$digest();
            expect(cscope.xdata).toBe('yes');
        })

        it('should xdata if xdata is defined', function () {
            scope.xdata = 'no';
            scope.ydata = 'yes';
            scope.$digest();
            expect(cscope.xdata).not.toBe('yes');
            expect(cscope.xdata).toBe('no');
        })
    })

    describe('moneyMask', function () {

        var scope, celem, cscope;

        beforeEach(function () {
            module("PortalApp");
            inject(function (_$compile_, _$rootScope_) {
                var html = "<input ng-model='xdata' money-mask></input>";
                scope = _$rootScope_.$new();
                celem = _$compile_(html)(scope);
                scope.$digest();
                cscope = celem.scope();
            })
        })

        it('format money', function () {
            scope.xdata = "123456.78";
            scope.$digest();
            expect(celem[0].value).toBe('$123,456.78');
        })


    });
    describe('ptRadio', function () {

        var scope, celem, cscope;

        beforeEach(function () {
            module("PortalApp");
            inject(function (_$compile_, _$rootScope_) {
                var html = "<input ng-model='xdata' money-mask></input>";
                scope = _$rootScope_.$new();
                celem = _$compile_(html)(scope);
                scope.$digest();
                cscope = celem.scope();
            })
        })

        it('format money', function () {
            scope.xdata = "123456.78";
            scope.$digest();
            expect(celem[0].value).toBe('$123,456.78');
        });


    });
})
