describe('ConstructionController', function () {

    var scope;
    var ConstructionController;

    beforeEach(module("PortalApp"));
    beforeEach(inject(function ($rootScope, $controller) {
        scope = $rootScope.$new();
        ConstructionController = $controller('ConstructionCtrl', { $scope: scope })
    }));

})