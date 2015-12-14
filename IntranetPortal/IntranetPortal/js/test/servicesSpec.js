describe('ptCom', function () {
    var service, scope;

    beforeEach(function () {
        module('PortalApp');
        inject(function (ptCom, _$rootScope_) {
            service = ptCom;
            scope = _$rootScope_.$new();
        })

    });

    it('add to array', function () {
        var model = undefined;
        service.arrayAdd(model, 1);
        expect(model).toBeUndefined();

        model = [];
        service.arrayAdd(model, 1);
        expect(model).toContain(1);
        service.arrayAdd(model, 1);
        expect(model.length).toBe(2);

        model = [];
        service.arrayAdd(model)
        expect(model).not.toBeUndefined();
        expect(model).toContain({});
    });

    it('remove from array', function () {

        var model = [];
        service.arrayRemove(model, 1);
        expect(model.length).toBe(0);

        model = [1];
        service.arrayRemove(model, 1);
        expect(model.length).toBe(1);
        service.arrayRemove(model, 0);
        expect(model.length).toBe(0);
    });

    it('format address', function () {
        var strNO = "14427";
        var strName = "Barclay Ave";
        var aptNO = "608";
        var city = "Flushing";
        var state = "NY";
        var zip = 11355;
        expect(service.formatAddr(strNO, strName, aptNO, city, state, zip))
        .toBe("14427 Barclay Ave, Apt 608, Flushing, NY, 11355")
    });

    it('capitalize First Letter', function () {
        var xname = "xname";
        expect(service.capitalizeFirstLetter(xname)).toBe("Xname");

    });

    it('format name', function () {
        expect(service.formatName("shaopeng", undefined, "zhang"))
        .toBe("Shaopeng Zhang");
        expect(service.formatName("shaopeng", "", "zhang"))
       .toBe("Shaopeng Zhang");
        expect(service.formatName("shaopeng", "von", "zhang"))
       .toBe("Shaopeng Von Zhang");

    });

    it('ensure Array', function () {
        expect(scope["testkey"]).toBeUndefined();
        service.ensureArray(scope, "testkey");
        expect(scope["testkey"]).not.toBeUndefined();
    });

    it('ensure push', function () {
        expect(scope["testkey"]).toBeUndefined();
        service.ensurePush(scope, "testkey", 1);
        expect(scope["testkey"].length).toBe(1);
        expect(scope["testkey"]).toContain(1);

    });

    it('convert null to undefined', function () {
        var model = {
            test: null,
            test1: {
                test1a: null,
                test1b: 2
            }
        }
        service.nullToUndefined(model);
        expect(model.test).toBeUndefined();
        expect(model.test1.test1b).toBe(2);
        expect(model.test1.test1a).toBeUndefined();

    });

    it('convert to UTC date', function () {
        var xdate = new Date("12/15/2015")
        expect(service.toUTCLocaleDateString(xdate)).toBe("12/15/2015");

    })

});

describe("ptFileServices", function () {

    var service;

    beforeEach(function () {

        module('PortalApp');
        inject(function (ptFileService) {

            service = ptFileService;
        })

    })

    it("knows windows folder format", function () {
        var path = "C:\\test.txt";
        expect(service.isIE(path)).toBe(true);
        path = "/home/test.txt";
        expect(service.isIE(path)).toBe(false);

    })

    it("get file name correctly", function () {
        path = ""
        expect(service.getFileName(path)).toBe("");
        expect(service.getFileExt(path)).toBe("");

        path = "test.txt";
        expect(service.getFileName(path)).toBe("test.txt");
        expect(service.getFileExt(path)).toBe("txt");

        var path = "C:\\test.txt";
        expect(service.getFileName(path)).toBe("test.txt");
        expect(service.getFileExt(path)).toBe("txt");

        path = "/home/test.bmp";
        expect(service.getFileName(path)).toBe("test.bmp");
        expect(service.getFileExt(path)).toBe("bmp");

    })

    it("clean file name", function () {
        var oldfilename = "what is this.txt";
        expect(service.cleanName(oldfilename)).toBe("what_is_this.txt");
        oldfilename = "what is %##^this.txt";
        expect(service.cleanName(oldfilename)).toBe("what_is_____this.txt");
    })

    it("is picture", function () {
        var filename = "test.jpg"
        expect(service.isPicture(filename)).toBe(true);
        filename = "test"
        expect(service.isPicture(filename)).toBe(false);
    })

});

