describe("ptFileServices", function () {

    var service;

    beforeEach(function () {

        module('PortalApp');
        inject(function (ptFileService) {

            service = ptFileService;
        })

    })

    it("windows have :\\", function () {
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
})