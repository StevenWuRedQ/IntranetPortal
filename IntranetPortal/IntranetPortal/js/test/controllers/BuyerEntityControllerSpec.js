describe('BuyerEntityController', function() {
    var scope, ctrl;

    beforeEach(module("PortalApp"));
    beforeEach(inject(function($rootScope, $controller, $injector) {
        scope = $rootScope.$new();
        ctrl = $controller('BuyerEntityCtrl', { $scope: scope });
        var httpBackend = $injector.get('$httpBackend');
        httpBackend.when('GET', '/Services/ContactService.svc/LoadContacts').respond([]);
        httpBackend.when('GET', '/Services/TeamService.svc/GetAllTeam').respond([]);
        httpBackend.when('GET', '/Services/ContactService.svc/GetAllBuyerEntities').respond([]);
        scope.$digest();
    }));

    it("init properly", function() {
        expect(scope.selectType).toBe("All Entities");
    });

    it("get title properly", function() {
        scope.ChangeGroups

    })
});