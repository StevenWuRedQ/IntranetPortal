describe('ConstructionController', function () {
    var scope, ctrl;

    beforeEach(module("PortalApp"));
    beforeEach(inject(function ($rootScope, $controller, $injector) {
        scope = $rootScope.$new();
        ctrl = $controller('ConstructionCtrl', { $scope: scope });
        var httpBackend = $injector.get('$httpBackend');
        httpBackend.when('GET', '/Services/ContactService.svc/LoadContacts').respond([]);
        httpBackend.when('GET', '/Services/TeamService.svc/GetAllTeam').respond([]);
        httpBackend.when('GET', '/api/ConstructionCases/GetRunners').respond([]);
        scope.$digest();
    }));

    it("should init default models", function () {
        expect(scope.CSCase).not.toBeUndefined();
        expect(scope.CSCase.CSCase.Utilities.Company.length).toBe(0);
        expect(scope.percentage.intake.count).toBe(0);
    });

    it("should reload scope data", function () {

        scope.ReloadedData.NewData = "new data";
        scope.CSCase.CSCase.Photos.NewPhoto = "new photo";
        scope.percentage.intake.count = 1;

        scope.reload();
        expect(scope.ReloadedData.NewData).toBeUndefined();
        expect(scope.CSCase.CSCase.Photos.NewPhoto).toBeUndefined();
        expect(scope.percentage.intake.count).toBe(0);

    });

    it("show company changes", function () {
        scope.CSCase.CSCase.Utilities.Company.push('Taxes');
        scope.CSCase.CSCase.Utilities.Company.push('Insurance');

        scope.$digest();
        expect(scope.CSCase.CSCase.Utilities.ConED_Shown).toBeFalsy();
        expect(scope.CSCase.CSCase.Utilities.Taxes_Shown).toBe(true);
        expect(scope.CSCase.CSCase.Utilities.Insurance_Shown).toBe(true);

    });

    it("add comment", function () {
        Current_User = "testuser";
        scope.addComment("Test Msg");
        expect(scope.CSCase.CSCase.Comments.length).toBe(1);
        expect(scope.CSCase.CSCase.Comments[0].createBy).toBe('testuser');
    });

    it("compile the template", function() {
        scope.TestMsg = "tester";
        var msg = "{{TestMsg}} is good!";
        var result = scope.highlightMsg(msg);
        expect(result).toBe("tester is good!");
    });


})