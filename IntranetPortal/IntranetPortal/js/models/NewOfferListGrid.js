/**
 * @return {[class]}                 NewOfferListGrid class
 */
angular.module('PortalApp').factory('NewOfferListGrid', function ($http) {
    var _class = function (data) {

        var opt = {
            dataSource: data,
            headerFilter: {
                visible: true
            },
            searchPanel: {
                visible: true,
                width: 250
            },
            paging: {
                pageSize: 10
            },
            columnAutoWidth: true,
            wordWrapEnabled: true,
            onRowPrepared: this.onRowPrepared,
            columns: [{
                dataField: 'Title',
                caption: 'Address',
                cellTemplate: this.cellTemplate
            },
                'OfferType', {
                    dataField: 'CreateBy',
                    caption: 'Submit By'
                }, {
                    dataField: 'CreateDate',
                    caption: 'Contract Date',
                    dataType: 'date',
                    sortOrder: 'desc',
                    format: 'shortDate'
                },
                {
                    caption: 'History',
                    width: 80,
                    alignment: 'center',
                    cellTemplate: function (container, options) {
                        $("<i>").attr("class", "fa fa-history")
                                .attr("style", "cursor:pointer")
                                .on('dxclick', function () {
                                    auditLog.show('PropertyOffer', options.data.OfferId);
                                    $("#divAuditLog").modal("show");
                                }).appendTo(container);
                    }
                }
            ]
        };
        angular.extend(this, opt)
    }
    _class.prototype.onRowPrepared = function (rowInfo) {
        if (rowInfo.rowType != 'data')
            return;
        rowInfo.rowElement
            .addClass('myRow');
    }
    _class.prototype.cellTemplate = function (container, options) {
        $('<a/>').addClass('dx-link-MyIdealProp')
            .text(options.value)
            .on('dxclick', function () {
                //Do something with options.data;
                //ShowCaseInfo(options.data.BBLE);
                var request = options.data;

                PortalUtility.ShowPopWindow("New Offer", "/NewOffer/ShortSaleNewOffer.aspx?BBLE=" + request.BBLE);
            })
            .appendTo(container);
    }

    return _class;
});