describe('ptFiles', function () {

    var scope, celem;

    beforeEach(function () {
        module("PortalApp");
        module("js/templates/ptfiles.html");
        inject(function ($templateCache, $compile, $rootScope, $injector) {
            var template = $templateCache.get('js/templates/ptfiles.html');
            $templateCache.put('/js/templates/ptfiles.html', template);
            scope = $rootScope.$new();
                    scope.files = angular.fromJson('[{"name":"image_(14).jpeg","folder":"one","uploadTime":"2015-09-30T19:59:02.131Z","path":"/Shared%20Documents/1004490003/Construction/Photos_PMPhotos/dfex/image_(14).jpeg","thumb":"6308"},{"name":"image_(13).jpeg","folder":"two","uploadTime":"2015-09-30T19:59:02.131Z","path":"/Shared%20Documents/1004490003/Construction/Photos_PMPhotos/dfex/image_(13).jpeg","thumb":"6304"},{"name":"image_(15).jpeg","folder":"three","uploadTime":"2015-09-30T19:59:02.131Z","path":"/Shared%20Documents/1004490003/Construction/Photos_PMPhotos/dfex/image_(15).jpeg","thumb":"6314"}]');
            var elem = angular.element('<pt-files file-bble="00000000" file-id="testUpload" file-model="files" folder-enable="true" base-folder="testFolder"></pt-files>');

            celem = $compile(elem)(scope);
            scope.$digest();
        });
    });

    it("should be hide folder at first", function () {

        var folderLink = celem.find('span.current_folder');      
        expect(folderLink.text()).toBe('FOLDERS');
        
    })
    
    it("should change current folder after add new folder", function(){
        
        var folderLink = celem.find('span.current_folder'); 
        var eScope = folderLink.scope();
        eScope.addFolder("2015.15.20");
        eScope.$digest();      
        expect(folderLink.text()).toBe("2015.15.20");
    })

    it("The length of li should be three plus three option", function(){
        scope.$digest();
        var folderDropdown = celem.find('ul.dropdown-menu');
        dump(folderDropdown.scope().fileModel);
        expect(folderDropdown.find('li').length).toBe(3+3);
    })

    it("", function () {

    })

})