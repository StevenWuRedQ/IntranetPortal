/*For unit test rewite helper class*/


describe('New Offer Ctrl test', function () {
    var scope, ctrl, $httpBackend;

    beforeEach(module("PortalApp"));
    beforeEach(inject(function ($rootScope, $controller, $injector) {
        scope = $rootScope.$new();
        scope.SSpreSign = {};
        ctrl = $controller('shortSalePreSignCtrl', { $scope: scope });

        var httpBackend = $injector.get('$httpBackend');
        $httpBackend = httpBackend;
        httpBackend.when('GET', '/Services/ContactService.svc/LoadContacts').respond([]);
        httpBackend.when('GET', '/Services/TeamService.svc/GetAllTeam').respond([]);
        httpBackend.when('GET', '/api/ConstructionCases/GetRunners').respond([]);
        httpBackend.when('GET', '/api/CorporationEntities/Teams').respond([]);

        httpBackend.when('GET', '/api/businessform/PropertyOffer/Tag/2037130013').respond({
            "BusinessData": {
                "OfferId": 0,
                "FormItemId": 86,
                "BBLE": null,
                "Title": null,
                "Owner": null,
                "OfferType": null,
                "Status": 2,
                "CreateDate": null,
                "CreateBy": null,
                "UpdateBy": null,
                "UpdateDate": null,
                "Name": null
            },
            "DataId": 86,
            "FormName": "PropertyOffer",
            "FormData": {
                "Type": "Short Sale",
                "FormName": "PropertyOffer",
                "PropertyAddress": "1022 WHEELER AVE, Bronx,NY 10472",
                "BBLE": "2037130013",
                "DataId": 86
            },
            "Tag": "2037130013 ",
            "UpdateDate": "2016-04-06T15:36:09.94",
            "UpdateBy": "Chris Yan",
            "CreateDate": null,
            "CreateBy": null
        });
        httpBackend.when('GET', '/api/businessform/PropertyOffer/Tag/2037130014').respond({
            "BusinessData": {
                "OfferId": 0,
                "FormItemId": null,
                "BBLE": null,
                "Title": null,
                "Owner": null,
                "OfferType": null,
                "Status": null,
                "CreateDate": null,
                "CreateBy": null,
                "UpdateBy": null,
                "UpdateDate": null,
                "Name": null
            },
            "DataId": 0,
            "FormName": "PropertyOffer",
            "FormData": null,
            "Tag": "2037130014",
            "UpdateDate": null,
            "UpdateBy": null,
            "CreateDate": null,
            "CreateBy": null
        });

        scope.$digest();
    }));

    it("If request new offer already request but not finish should show view model", inject(function ($injector) {
        //scope.SSpreSign = { BBLE: '2037130013' }

        var $httpBackend = $injector.get('$httpBackend');
        $httpBackend.expectGET('/api/businessform/PropertyOffer/Tag/2037130013');

        scope.CheckCurrentStep('2037130013');
        $httpBackend.flush();
        expect(scope.SSpreSign.BBLE.trim()).toEqual("2037130013");
        expect(scope.SSpreSign.Status).toEqual(2);
    }));

    it("When assign corp successfully should change fromdata status to 1", inject(function ($injector) {
        var $httpBackend = $injector.get('$httpBackend');

        var corp = {
            "EntityId": 2696,
            "CorpName": "DMVBE Management LLC",
            "Address": "118-60 218 Street, Cambria Heights, NY 11411",
            "PropertyAssigned": "1022 WHEELER AVE, Bronx,NY 10472",
            "FillingDate": "2016-02-02T00:00:00",
            "Signer": "Dominique Vabre",
            "Office": "GukasyanTeam",
            "EIN": "123456789",
            "AssignOn": "2016-02-02T00:00:00",
            "CreateTime": "2016-02-02T10:02:48.76",
            "UpdateBy": null,
            "UpdateTime": "2016-02-02T10:05:28.197",
            "Status": "Available",
            "OfficeName": null,
            "BBLE": null,
            "AppId": 1,
            "buyerAttorney": "Craig Hyman"
        }
        scope.SSpreSign.BBLE = '2037130013';
        scope.SSpreSign.assignCrop = { SsCase: {} };
        scope.SsCase = { PropertyInfo: { Owners: [] } };
        scope.SSpreSign.SsCase = {};
        // the controller will still send the request and
        // $httpBackend will respond without you having to
        // specify the expectation and response for this request
        $httpBackend.expectPOST('/api/CorporationEntities/Assign?bble=2037130013', JSON.stringify(corp)).respond(corp);
        scope.AssignCorpSuccessed(corp);
        $httpBackend.flush();

        expect(scope.SSpreSign.assignCrop.CropData).toEqual(corp)
        expect(scope.SSpreSign.assignCrop.Crop).toEqual('DMVBE Management LLC');
        scope.SSpreSign.Status = 1;
        //constract data send back to server
        scope.constractFromData();

        //Check FormData after constract is 1
        var FormData = JSON.parse(scope.SSpreSign.FormData);
        expect(FormData.Status).toEqual(1);

    }));

    it("When Offer formdata is null do not clear the initial data", function () {
        scope.CheckCurrentStep('2037130014');
        expect(scope.SSpreSign).not.toBe(null);
        expect(scope.SSpreSign.BBLE).not.toBe('2037130014');
    });
})