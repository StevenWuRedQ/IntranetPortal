<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="~/Content.Master" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContentPH" runat="server">

    <script src="https://cdnjs.cloudflare.com/ajax/libs/moment.js/2.11.2/moment.min.js" type="text/javascript"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/moment-timezone/0.5.0/moment-timezone.min.js" type="text/javascript"></script>

    <style type="text/css">
        .myRow:hover {
            background-color: #efefef;
        }

        iframe {
            border: none;
            height: 100%;
            width: 100%;
        }

        #xwrapper {
            float: left;
            height: 875px;
        }

        #preview {
            float: right;
            height: 875px;
            position: relative;
            right: 0px;
            top: 0px;
        }

        #iconarea {
            float: left;
            margin-left: -35px;
            position: relative;
            top: 5px;
            visibility: hidden;
        }

        #hideicon:hover {
            cursor: pointer;
        }

        #maximizeicon:hover {
            cursor: pointer;
        }

        #previewWindow {
            position: absolute;
            right: 0px;
            top: 0px;
        }
    </style>

    <input type="text" style="display: none" />
    <div class="content">
        <div id="xwrapper" style="visibility: visible">
            <div id="gridContainer" style="margin: 10px"></div>
        </div>

        <div id="preview" style="visibility: hidden">
            <div id="iconarea">
                <div id="hideicon" data-toggle="tooltip" data-placement="right" title="hide right panel" style="height: 32px; width: 32px">
                    <a class="btn btn-sm btn-blue" onclick="previewControl.undo()">
                        <i class="fa fa-times"></i>
                    </a>
                </div>
                <div style="height: 5px"></div>
                <div id="maximizeicon" data-toggle="tooltip" data-placement="right" title="maximize right panel" style="height: 32px; width: 32px">
                    <a class="btn btn-sm btn-blue" onclick="previewControl.togglemaximize()">
                        <i class="fa fa-square-o"></i>
                    </a>
                </div>
            </div>
            <iframe id="previewWindow"></iframe>
        </div>
    </div>
    <script>
        var onRowClickCallback = function (e) {
            //debugger;
            var bble = e.key.BBLE || '';
            var status = e.key.Status || 0;
            previewControl.showCaseInfo(bble, status);
        };

        $(document).ready(function () {
            var url = "/api/underwriting";
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
                        rowInfo.rowElement
                            .addClass('myRow');
                    },
                    onContentReady: function (e) {
                        var spanTotal = e.element.find('.spanTotal')[0];
                        if (spanTotal) {
                            $(spanTotal).html("Total Count: " + e.component.totalCount());
                        } else {
                            var panel = e.element.find('.dx-datagrid-pager');
                            if (!panel.find(".dx-pages").length) {
                                $("<span />").addClass("spanTotal").html("Total Count: " + e.component.totalCount())
                                    .appendTo(e.element);
                            } else {
                                panel.append($("<span/>").addClass("spanTotal")
                                    .html("Total Count: " + e.component.totalCount()));
                            }
                        }
                        highlightcallback(e);
                    },
                    onRowClick: onRowClickCallback,
                    selection: {
                        mode: 'single'
                    },
                    summary: {
                        groupItems: [
                            {
                                column: "BBLE",
                                summaryType: "count",
                                displayFormat: "{0}",
                            }
                        ]
                    },
                    columns: [
                        {
                            dataField: 'BBLE',
                            visible: false
                        },
                        {
                            dataField: 'UnderwritingUpdateDate',
                            sortIndex: 1,
                            sortOrder: 'desc',
                            visible: false
                        },
                        {
                            dataField: "CaseName",
                            width: 400,
                            caption: "Property Address"
                        },
                        {
                            dataField: "Team"
                        }, {
                            dataField: "UnderwritingCreateBy",
                            caption: "UW Requested By"
                        }, {
                            dataField: "UnderwritingCreateDate",
                            caption: "UW Requested Date",
                            dataType: "date",
                            customizeText: PortalUtility.customizeDateText2
                        }, {
                            dataField: "SearchStatus",
                            caption: "Search Status",
                            alignment: "left",
                            customizeText: function (cell) {
                                switch (cell.value) {
                                    case 1:
                                        return 'Completed';
                                    default:
                                        return 'New';

                                }
                            }
                        }, {
                            dataField: "SearchCompletedBy",
                            caption: "Search Completed By"
                        }, {
                            dataField: "SearchCompletedOn",
                            caption: "Search Completion Date",
                            dataType: "date",
                            customizeText: PortalUtility.customizeDateText2,
                            sortIndex: 0,
                            sortOrder: 'desc'
                        }, {
                            dataField: "UnderwritingStatus",
                            caption: "UW Status",
                            alignment: "left",
                            customizeText: function (cell) {
                                switch (cell.value) {
                                    case 1:
                                        return 'New';
                                    case 2:
                                        return 'Pending';
                                    case 3:
                                        return 'Accepted';
                                    case 4:
                                        return 'Rejected';
                                    default:
                                        return '';
                                }
                            }
                        }, {
                            dataField: "UnderwritingUpdateDate",
                            caption: 'UW Updated On',
                            dataType: "date",
                            customizeText: PortalUtility.customizeDateText2

                        }, {
                            dataField: 'NewOfferStatus',
                            caption: 'OF Status',
                            alignment: "left",
                            customizeText: function (cellInfo) {
                                switch (cellInfo.value) {
                                    case 0:
                                        return "New Offer";
                                    case 1:
                                        return "In Process";
                                    case 2:
                                        return "SS Accepted";
                                    default:
                                        return "";
                                }

                            }
                        }, {
                            caption: "Duration",
                            width: '80px',
                            allowSorting: true,
                            calculateCellValue: function (data) {
                                //debugger;
                                if (!data.UnderwritingUpdateDate || !data.UnderwritingCreateBy ) {
                                    return Infinity;
                                }
                                return new Date(data.UnderwriteCompletedOn) - new Date(data.CreateDate);
                            },
                            customizeText: function (cellInfo) {
                                if (cellInfo.value === Infinity) return "";
                                return moment.duration(cellInfo.value).humanize();
                            }
                        }
                    ]
                }).dxDataGrid('instance');
                $(".dx-datagrid-header-panel")
                    .prepend($("<div id='uw-properties-title' style='margin-bottom: -35px'>" +
                        "<label class='grid-title-icon' style='display: inline-block'>UW</label>" +
                        "<span id='useFilterApplyButton' style='z-index: 999'></span></div>"));
                var filterDataDelegate = function (data) {
                    previewControl.undo();
                    filterData(data.value);
                };
                var columns = [
                    'CaseName', 'Team', 'CreateBy', 'CreateDate', 'Status', 'CompletedBy', 'CompletedOn',
                    'UnderwriteStatus', 'UnderwriteCompletedOn', 'NewOfferStatus', 'Duration'
                ];

                var displayall = function () {
                    _.forEach(columns,
                        function (v, i) {
                            dataGrid.columnOption(v, 'visible', true);
                        });
                };
                // use to hide some columns that not needed.
                var hidesome = function (arraylike) {
                    _.forEach(arraylike,
                        function (v, i) {
                            dataGrid.columnOption(v, 'visible', false);
                        });
                };
                var filterData = function (data) {
                    dataGrid.clearFilter();
                    displayall();
                    switch (data) {
                        case 1:
                            dataGrid.filter(['Status', '=', '0']);
                            hidesome(['CompletedBy', 'CompletedOn', 'UnderwriteCompletedOn', 'Duration', 'NewOfferStatus']);
                            break;
                        case 2:
                            dataGrid.filter(['Status', '=', '1']);
                            break;
                        case 3:
                            dataGrid.filter([['UnderwriteStatus', '=', '0'], ['Status', '=', '1']]);
                            hidesome(['UnderwriteCompletedOn', 'Duration']);
                            break;
                        case 4:
                            dataGrid.filter([['UnderwriteStatus', '=', '1'], ['Status', '=', '1']]);
                            hidesome(['Team']);
                            break;
                        case 5:
                            dataGrid.filter([['UnderwriteStatus', '=', '2'], ['Status', '=', '1']]);
                            hidesome(['Team']);
                    }
                };
                var filterBox = $("#useFilterApplyButton").dxSelectBox({
                    items: [
                        {
                            key: 0,
                            name: "All"
                        }, {
                            key: 1,
                            name: "New Search"
                        }, {
                            key: 3,
                            name: "Pending Underwriting"
                        }, {
                            key: 2,
                            name: "Completed Search"
                        }, {
                            key: 4,
                            name: "Accepted Underwriting"
                        }, {
                            key: 5,
                            name: "Rejected Underwriting"
                        }
                    ],
                    valueExpr: "key",
                    displayExpr: "name",
                    width: '250',
                    onValueChanged: filterDataDelegate
                }).dxSelectBox('instance');
                var hashnum = parseInt(location.hash.split('/')[1]);
                var bble = location.hash.split('/')[2];
                if (hashnum) {
                    filterBox.option('value', hashnum);
                } else {
                    filterBox.option('value', 0);
                }
                //debugger;
                if (bble) {
                    previewControl.showCaseInfo(bble);
                }

                //high light column by refresh
                var highlightcallback = function (e) {
                    // debugger;
                    if (bble) {
                        var grid = e.element.dxDataGrid('instance');
                        var data = grid.option('dataSource');
                        var items = [];
                        _.forEach(data,
                            function (v, i) {
                                if (v.BBLE.trim() == bble.trim())
                                    items.push(v);
                            });
                        if (items.length > 0) {
                            grid.selectRows(items, true);
                        }
                        bble = undefined;
                    }
                };

            });
        });
        previewControl = (function () {
            var previewShown = false;
            var that = this;
            return {
                showCaseInfo: function (CaseId, status) {
                    if (status === 0) {
                    <% If HttpContext.Current.User.IsInRole("Underwriter")%>
                    var url = '/underwriter/DocSearch.aspx?mode=2&BBLE=' + CaseId + '#/searchSummary';
                    <% ELSE%>
                    var url = '/underwriter/DocSearch.aspx?mode=1&BBLE=' + CaseId + '#/searchSummary';
                    <% End IF%>
                } else {
                    <% If HttpContext.Current.User.IsInRole("Underwriter")%>
                    var url = '/underwriter/UnderwritingSummary.aspx?mode=2&BBLE=' + CaseId + '#/searchSummary';
                    <% ELSE%>
                        var url = '/underwriter/UnderwritingSummary.aspx?mode=1&BBLE=' + CaseId + '#/searchSummary';
                    <% End IF%>
                }
                $("#xwrapper").css("width", "50%");
                $("#xwrapper").css("visibility", "visible");
                $("#preview").css("width", "50%");
                $("#preview").css("visibility", "visible");
                $("#iconarea").css("visibility", "visible");
                $("#previewWindow").attr("src", url);
                that.previewShown = true;
            },
            undo: function () {
                $("#xwrapper").css("width", "99%");
                $("#xwrapper").css("visibility", "visible");
                $("#preview").css("width", "0%");
                $("#preview").css("visibility", "hidden");
                $("#iconarea").css("visibility", "hidden");
                $("#previewWindow").attr("src", "");
                that.previewShown = false;
            },
            maximize: function () {
                $("#xwrapper").css("width", "0%");
                $("#xwrapper").css("visibility", "hidden");
                $("#preview").css("width", "97%");
                $("#preview").css("visibility", "visible");
            },
            unmaximize: function () {
                $("#xwrapper").css("width", "50%");
                $("#xwrapper").css("visibility", "visible");
                $("#preview").css("width", "50%");
                $("#preview").css("visibility", "visible");
            },
            togglemaximize: function () {
                var visible = $("#xwrapper").css("visibility");
                if (visible == 'visible') {
                    this.maximize();
                } else {
                    this.unmaximize();
                }
            }
        };
    })();
    </script>
</asp:Content>
