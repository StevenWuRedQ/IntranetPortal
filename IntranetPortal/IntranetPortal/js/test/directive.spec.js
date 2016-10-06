describe('directives', function() {
    describe('ssDate', function() {
        var scope, celem, cscope;

        beforeEach(function() {
            module("PortalApp");
            inject(function(_$compile_, _$rootScope_) {
                var html = "<input ng-model='xdate' ss-date></input>";
                scope = _$rootScope_.$new();
                celem = _$compile_(html)(scope);
                scope.$digest();
                cscope = celem.scope();
            })
        });

        it("should format date", function() {
            scope.xdate = "2015-12-14T18:05:36.934Z";
            scope.$digest();
            console.log(celem[0].value);
            expect(cscope.xdate).toBe("12/14/2015");
        });
    })

    describe('ptInitModel', function() {

        var scope, celem, cscope;

        beforeEach(function() {
            module("PortalApp");
            inject(function(_$compile_, _$rootScope_) {
                var html = "<input ng-model='xdata' pt-init-model='ydata'></input>";
                scope = _$rootScope_.$new();
                celem = _$compile_(html)(scope);
                scope.$digest();
                cscope = celem.scope();
            })
        })

        it('should ydata if xdata is undefined', function() {
            scope.ydata = 'yes';
            scope.$digest();
            expect(cscope.xdata).toBe('yes');
        })

        it('should xdata if xdata is defined', function() {
            scope.xdata = 'no';
            scope.ydata = 'yes';
            scope.$digest();
            expect(cscope.xdata).not.toBe('yes');
            expect(cscope.xdata).toBe('no');
        })
    })

    describe('moneyMask', function() {

        var scope, celem, cscope;

        beforeEach(function() {
            module("PortalApp");
            inject(function(_$compile_, _$rootScope_) {
                var html = "<input ng-model='xdata' number-mask maskformat='money'></input>";
                scope = _$rootScope_.$new();
                celem = _$compile_(html)(scope);
                scope.$digest();
                cscope = celem.scope();
            })
        })

        it('format money', function() {
            scope.xdata = "123456.78";
            scope.$digest();
            expect(celem[0].value).toBe('$123,456.78');
        })


    });
    describe('ptRadio', function() {

        var scope, celem, cscope;

        beforeEach(function() {
            module("PortalApp");
            inject(function(_$compile_, _$rootScope_) {
                var html = "<pt-radio model='radio' ng-disabled='varDisabled'></pt-radio>";
                scope = _$rootScope_.$new();
                celem = _$compile_(html)(scope);
                scope.$digest();
                cscope = celem.scope();
            })
        })

        it('it should disabled all input when set var to disabled', function() {
            scope.varDisabled = true;
            scope.$digest();
            var elemContents = celem.contents();
            expect(elemContents[0].disabled).toBeTruthy();
            expect(elemContents[2].disabled).toBeTruthy();

        });
        it('it should not all input when set var to disabled', function() {
            scope.varDisabled = false;
            scope.$digest();
            var elemContents = celem.contents();
            expect(elemContents[0].disabled).toBeFalsy();
            expect(elemContents[2].disabled).toBeFalsy();

        });

        it('should deselect all input when model is null', function() {
            //scope.radio = null;
            scope.$digest();
            var elemContents = celem.contents();
           
            expect(elemContents[0].checked).toBe(false);
            expect(elemContents[2].checked).toBe(false);
        });

        it('should only checked frist input when radio value is true and only checked second input when radio is false', function() {
            scope.radio = true;
            scope.$digest();
            
            var elemContents = celem.contents();
            expect(elemContents[0].checked).toBe(true);
            expect(elemContents[2].checked).toBe(false);
            scope.radio = false;
            scope.$digest();
            expect(elemContents[0].checked).toBe(false);
            expect(elemContents[2].checked).toBe(true);
        });

        it('should show ss_warning when there are model is undefined',inject(function(_$compile_, _$rootScope_){
             var html = "<pt-radio model='radio' ng-disabled='varDisabled'></pt-radio><div id='showSsWarning' ng-class='{ss_warning:varDisabled===null||varDisabled===undefined}'></div>";
            scope = _$rootScope_.$new();
            celem = _$compile_(html)(scope);
            scope.$digest();
            expect(celem[1].className).toContain('ss_warning');
            scope.varDisabled = false;
            scope.$digest();
            expect(celem[1].className).not.toContain('ss_warning');
        }))
    });
})