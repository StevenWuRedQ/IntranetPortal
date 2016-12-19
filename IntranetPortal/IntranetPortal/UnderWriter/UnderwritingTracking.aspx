<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="~/Content.Master" CodeBehind="UnderwritingTracking.aspx.vb" Inherits="IntranetPortal.DocSearchList" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContentPH" runat="server">

    <script src="https://cdnjs.cloudflare.com/ajax/libs/moment.js/2.11.2/moment.min.js" type="text/javascript"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/moment-timezone/0.5.0/moment-timezone.min.js" type="text/javascript"></script>

    <style type="text/css">
        a.dx-link-MyIdealProp:hover {
            font-weight: 500;
            cursor: pointer;
        }

        .myRow:hover {
            background-color: #efefef;
        }


        #xwrapper {
            float: left;
            height: 875px;
        }
    </style>

    <input type="text" style="display: none" />
    <div class="content">
        <div id="xwrapper">
            <div id="gridContainer" style="margin: 10px"></div>
        </div>
    </div>
    <script>

        $(document).ready(function () {
            var url = "/api/PropertyOffer/UnderwritingNewoffer";
            var that = this;
            $.getJSON(url).done(function (data) {
                var dataGrid = $("#gridContainer").dxDataGrid({
                    dataSource: data,
                    searchPanel: {
                        visible: true,
                        width: 240,
                        placeholder: "Search..."
                    },
                    headerFilter: {
                        visible: true
                    },
                    rowAlternationEnabled: true,
                    pager: {
                        showInfo: true,
                    },
                    paging: {
                        enabled: true,
                        //pageSize: 10
                    },
                    onRowPrepared: function (rowInfo) {
                        if (rowInfo.rowType != 'data')
                            return;
                        rowInfo.rowElement.addClass('myRow');
                    },
                    onContentReady: function (e) {
                        var spanTotal = e.element.find('.spanTotal')[0];
                        if (spanTotal) {
                            $(spanTotal).html("Total Count: " + e.component.totalCount());
                        } else {
                            var panel = e.element.find('.dx-datagrid-pager');
                            if (!panel.find(".dx-pages").length) {
                                $("<span />").addClass("spanTotal").html("Total Count: " + e.component.totalCount()).appendTo(e.element);
                            } else {
                                panel.append($("<span />").addClass("spanTotal").html("Total Count: " + e.component.totalCount()))
                            }
                        }
                    },
                    summary: {
                        groupItems: [{
                            column: "BBLE",
                            summaryType: "count",
                            displayFormat: "{0}",
                        }]
                    },
                    columns: [
                        {
                            dataField: 'BBLE',
                            visible: false
                        },
                        {
                            dataField: "PropertyAddress",
                            width: 400,
                            caption: "Property Address",
                        },
                        {
                            dataField: "UnderwriteStatus",
                            caption: "UW. Status",
                            alignment: "left",
                            customizeText: function (cell) {
                                switch (cell.value) {
                                    case 0:
                                        return 'Pending'
                                    case 1:
                                        return 'Accepted';
                                    case 2:
                                        return 'Reject';
                                    default:
                                        return '';

                                }
                            },
                            sortOrder: 'desc'
                        }, {
                            dataField: "UnderwriteCompletedOn",
                            caption: "UW. Completed Date",
                            dataType: "date",
                            customizeText: PortalUtility.customizeDateText2
                        }, {
                            dataField: "UnderwriteCompletedBy",
                            caption: "UW. Completed By",
                        },
                        {
                            dataField: "NewOfferStatus",
                            caption: "NO. Status",
                            alignment: "left",
                            customizeText: function (cell) {
                                switch (cell.value) {
                                    case 2:
                                        return 'Completed';
                                    default:
                                        return 'Not Completed';

                                }
                            }
                        },
                        {
                            dataField: "NewOfferDate",
                            caption: "NO. Updated Date",
                            dataType: "date",
                            customizeText: PortalUtility.customizeDateText2
                        }, {
                            dataField: "NewOfferBy",
                            caption: "NO. Updated By",
                        }, {
                            dataField: "IsShortSaleAccpeted",
                            caption: "SS. Accepted Status",
                            alignment: "left",
                            customizeText: function (cell) {
                                switch (cell.value) {
                                    case 1:
                                        return 'Accepted';
                                    default:
                                        return 'Not Accepted';

                                }
                            }

                        },

                        {
                            dataField: "AcceptedDate",
                            caption: "SS. Accepted Date",
                            dataType: "date",
                            customizeText: PortalUtility.customizeDateText2
                        }, {
                            dataField: "AcceptedBy",
                            caption: "SS. Accepted By",
                        },
                        {
                            dataField: "IsInProcess",
                            caption: "In Process Status",
                            alignment: "left",
                            customizeText: function (cell) {
                                switch (cell.value) {
                                    case 1:
                                        return 'In Process';
                                    default:
                                        return 'Not In Process';

                                }
                            }

                        }, {
                            dataField: "InProcessDate",
                            caption: "In Process Date",
                            dataType: "date",
                            customizeText: PortalUtility.customizeDateText2
                        }, {
                            dataField: "InProcessBy",
                            caption: "In Process By",
                        }]
                }).dxDataGrid('instance');
                $(".dx-datagrid-header-panel").prepend($("<div id='uw-properties-title' style='margin-bottom: -35px'><label class='grid-title-icon' style='display: inline-block'>???</label><span id='useFilterApplyButton' style='z-index: 999'></span></div>"))
                $(".dx-datagrid-header-panel").prepend($("<span id='hideicon' class='btn btn-blue pull-right' data-toggle='tooltip' data-placement='right' title='hide right panel' onclick='previewControl.undo()'><i class='fa fa-angle-double-right fa-lg'></i></span>"))
                var filterDataDelegate = function (data) {
                    //previewControl.undo();
                    filterData(data.value);
                }

                var columns = ["BBLE", "PropertyAddress", "UnderwriteStatus", "UnderwriteCompletedOn", "UnderwriteCompletedBy", "NewOfferStatus", "NewOfferDate", "NewOfferBy", "IsShortSaleAccpeted", "AcceptedBy", "AcceptedDate", "IsInProcess", "InProcessDate", "InProcessBy"];

                var displayall = function () {
                    _.forEach(columns, function (v, i) {
                        dataGrid.columnOption(v, 'visible', true)
                    })

                }
                // use to hide some columns that not needed.
                var hidesome = function (arraylike) {
                    _.forEach(arraylike, function (v, i) {
                        dataGrid.columnOption(v, 'visible', false)
                    })
                }

                var filterData = function (data) {
                    dataGrid.clearFilter();
                    displayall();
                    switch (data) {
                        case 1:
                            dataGrid.filter(['UnderwriteStatus', '=', '1'], 'and', ['NewOfferStatus', '<>', '2']);
                            //hidesome(['CompletedBy', 'CompletedOn', 'UnderwriteCompletedOn', 'Duration'])
                            break;
                    }
                }
                var filterBox = $("#useFilterApplyButton").dxSelectBox({
                    items: [{
                        key: 0,
                        name: "All"
                    }, {
                        key: 1,
                        name: "Underwriting Completed But Not New Offer"
                    }],
                    valueExpr: "key",
                    displayExpr: "name",
                    width: '350',
                    onValueChanged: filterDataDelegate
                }).dxSelectBox('instance');


            });


        })

    </script>

</asp:Content>

