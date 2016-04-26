describe('Pre Assign Ctrl test', function() {
    var scope, ctrl, $httpBackend;

    beforeEach(module("PortalApp"));
    beforeEach(inject(function($rootScope, $controller, $injector) {
        scope = $rootScope.$new();
        scope.SSpreSign = {};
        $httpBackend = $injector.get("$httpBackend");
        $httpBackend.when('GET', '/api/PreSign/2').respond({
            Id: 2
        });
        ctrl = $controller('perAssignCtrl', {
            $scope: scope
        });
    }));

    it("Should only have delete and insert function in Edit model parties should be edit", function() {
        scope.initEdit();
        expect(scope.gridEdit.editEnabled).toBeFalsy();
        expect(scope.gridEdit.insertEnabled).toBeTruthy();
        expect(scope.gridEdit.removeEnabled).toBeTruthy();

        expect(scope.partiesGridOptions.editing.editEnabled).toBeTruthy();

        expect(scope.checkGridOptions.onRowRemoving).toEqual(scope.CancelCheck);
        expect(scope.checkGridOptions.onRowInserting).toEqual(scope.AddCheck);

    });

    it('should go to view page if edit page sucessfully', function() {

        scope.preAssign.Id = 2;
        $httpBackend.expectPUT('/api/PreSign/2', JSON.stringify(scope.preAssign)).respond({
            Id: 2
        });
        scope.Save();
        

        expect(scope.localhref).toBe('/popupControl/preAssignCropForm.aspx?model=View&Id=2');
    });

    it('should add an row of check and return row check id', function() {
        var check = {
            //"CheckId": 30,
            "RequestId": 28,
            "PaybleTo": "Check 1",
            "Amount": 12555.00,
            "Date": "2016-04-13 18:04:13.000",
            "CheckFor": "NULL",
        };
        $httpBackend.expectPOST('/api/businesscheck', JSON.stringify(check)).respond({
            "CheckId": 30
        });
        scope.AddCheck({
            data: check
        });
        
        expect(scope.addedCheck.CheckId).toEqual(30);
    });
    it('shold delete check after delete item', function() {
        var check = {
            "CheckId": 32
        };

        $httpBackend.expectDELETE('/api/businesscheck/32').respond(check);
        scope.CancelCheck({
            data: check
        });
        $httpBackend.flush();
        expect(scope.deletedCheck).toEqual(check);
    });
});