describe('ptFiles', function () {

    var scope, celem, iscope;
    var jsonstr = '[{"name":"image_(14).jpeg","folder":"one","uploadTime":"2015-09-30T19:59:02.131Z","path":"/Shared%20Documents/1004490003/Construction/Photos_PMPhotos/dfex/image_(14).jpeg","thumb":"6308"},{"name":"image_(13).jpeg","folder":"two","uploadTime":"2015-09-30T19:59:02.131Z","path":"/Shared%20Documents/1004490003/Construction/Photos_PMPhotos/dfex/image_(13).jpeg","thumb":"6304"},{"name":"image_(15).jpeg","folder":"three","uploadTime":"2015-09-30T19:59:02.131Z","path":"/Shared%20Documents/1004490003/Construction/Photos_PMPhotos/dfex/image_(15).jpeg","thumb":"6314"}]';

    beforeEach(function () {
        module("PortalApp");
        module("js/templates/ptfiles.html");
        inject(function (_$templateCache_, _$compile_, _$rootScope_) {
            var template = _$templateCache_.get('js/templates/ptfiles.html');
            _$templateCache_.put('/js/templates/ptfiles.html', template);
            scope = _$rootScope_.$new();
            scope.pfiles = angular.fromJson(jsonstr);
            var elem = angular.element('<pt-files file-bble="00000000" file-id="testUpload" file-model="pfiles" folder-enable="true" base-folder="testFolder"></pt-files>');
            celem = _$compile_(elem)(scope);
            scope.$digest();
            iscope = celem.isolateScope();
        });
    });

    it("should init properly", function () {
         expect(iscope.folderEnable).toBe('true');
         expect(iscope.baseFolder).toBe("testFolder");
    });

    it("should be hide folder at first", function () {
        var folderLink = celem.find('span.current_folder');
        expect(iscope.currentFolder).toBe('');
        expect(folderLink.text()).toBe('FOLDERS');
    })
    
    it("The length of li should be three plus three option", function(){
        var folderDropdown = celem.find('ul.dropdown-menu');
        expect(iscope.folders.length).toBe(3);
        expect(folderDropdown.find('li').length).toBe(3+3);
    })

    it("should change current folder after add new folder", function(){
        var folderLink = celem.find('span.current_folder');
        iscope.addFolder("one");
        expect(iscope.folders.length).toBe(3);
        expect(iscope.currentFolder).toBe("one");

        iscope.addFolder("2015.15.20");
        scope.$digest();
        expect(iscope.folders.length).toBe(4);
        expect(folderLink.text()).toBe("2015.15.20");
    })

    it("should change when parent scope FileModel change", function () {
        iscope.currentFolder = "somevalue";
        scope.pfiles = angular.fromJson('[{"name":"image_(16).jpeg","folder":"one","uploadTime":"2015-09-30T19:59:02.131Z","path":"/Shared%20Documents/1004490003/Construction/Photos_PMPhotos/dfex/image_(15).jpeg","thumb":"6314"}]');
        scope.$digest();
        expect(iscope.folders.length).toBe(1);
        expect(iscope.currentFolder).toBe('');
    })

    it("should not allow duplicate files to upload", function () {
        var filesamples = [{
            name: "sample1.txt",
            size: 100,
            type: "text/plain"
        }, {
            name: "sample2.txt",
            size: 101,
            type: "text/plain"
        }, {
            name: "sample1.txt",
            size: 102,
            type: "text/plain"
        }]
        iscope.addFiles(filesamples);
        expect(iscope.files.length).toBe(iscope.nameTable.length);
        expect(iscope.files.length).toBe(2);
        iscope.addFiles([{
            name: "sample4.txt",
            size: 100,
            type: "text/plain"
        }])
        expect(iscope.files.length).toBe(iscope.nameTable.length);
        expect(iscope.files.length).toBe(3);
        iscope.removeChoosed(0);
        expect(iscope.files.length).toBe(2);
        iscope.clearChoosed();
        expect(iscope.files.length).toBe(0);
    })
    
})
