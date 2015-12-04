describe('Construction Controller E2E test', function () {

    it("should save the block/lot", function () {
        bowser.get('http://localhost:60956/Construction/ConstructionUI.aspx');
        element(by.model())
    })
})