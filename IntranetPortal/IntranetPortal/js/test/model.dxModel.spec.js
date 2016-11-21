describe('dxGridColumnModel', function () {
	it('it should have constom text function when data type is date', function () {
		
		var opt = new dxGridColumnModel({
			dataField: 'CreateDate', caption: 'Contract Date', dataType: 'date',
			sortOrder: 'desc',
			format: 'shortDate'
		});
		
		expect(opt.customizeText).toBeDefined();
		var mDate = opt.customizeText({value:'2016-05-01T00:00:00'}) 
		/*Javascript date start with 0 so the first day of this month is 0*/
		expect(mDate).toBe('05/01/2016');
		// expect(opt.customizeText).not.toBeNull();
	})
})
