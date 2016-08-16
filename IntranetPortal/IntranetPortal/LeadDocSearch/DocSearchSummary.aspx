<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="~/Content.Master" CodeBehind="DocSearchSummary.aspx.vb" Inherits="IntranetPortal.DocSearchSummary" %>

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

        .apply-filter-option {
            margin-top: 10px;
            margin-left: 10px;
            position: absolute;
            z-index: 1;
            top: 0;
            line-height: 38px;
            font-size: 20px;
            font-weight: 600;
        }

            .apply-filter-option > div:last-child {
                display: inline-block;
                vertical-align: top;
                margin-left: 20px;
                line-height: normal;
            }
    </style>

    <input type="text" style="display: none" />
    <div id="gridContainer" style="margin: 10px"></div>
    <script>
        $(document).ready(function () {

            var url = "/api/Title/TitleCases/??";

            $.getJSON(url).done(function (data) {
                var dataGrid = $("#gridContainer").dxDataGrid({
                    dataSource: data,
                    rowAlternationEnabled: true,

                    searchPanel: {
                        visible: true,
                        width: 240,
                        placeholder: "Search..."
                    },

                    headerFilter: {
                        visible: true
                    },

                    pager: {
                        showInfo: true,
                    },
                    paging: {
                        enabled: true,
                    },

                    onRowPrepared: function (rowInfo) {
                        if (rowInfo.rowType != 'data') return;
                        rowInfo.rowElement.addClass('myRow');
                    },

                    onContentReady: function (e) {
                        /* var spanTotal = e.element.find('.spanTotal')[0];
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
                        */
                    },

                    summary: {
                        groupItems: [{
                            column: "BBLE",
                            summaryType: "count",
                            displayFormat: "{0}",
                        }]
                    },

                    columns: [{
                        dataField: "BBLE",
                        caption: "BBLE",
                        /* cellTemplate: function (container, options) {
                            $('<a/>').addClass('dx-link-MyIdealProp')
                                .text(options.value)
                                .on('dxclick', function () {
                                    //Do something with options.data;
                                    ShowCaseInfo(options.data.BBLE);
                                })
                                .appendTo(container);
                        } */
                    }, {
                        dataField: "Status",
                        caption: "Status",
                    }, {
                        dataField: "StatusStr",
                        caption: "Title Status",
                        groupIndex: 0
                    }, {
                        caption: "CreateDate",
                        dataField: "Create Date",
                        dataType: "date",
                        customizeText: function (cellInfo) {
                            if (!cellInfo.value) return "";
                            var dt = PortalUtility.FormatLocalDateTime(cellInfo.value);
                            if (dt) return moment(dt).format('MM/DD/YYYY');
                            return "";
                        }
                    }, {
                        caption: "CompletedBy",
                        dataField: "Create By",
                        visible: false
                    }, {
                        caption: "CompletedOn",
                        dataField: "Completed On",
                        dataType: "date",
                        customizeText: function (cellInfo) {
                            if (!cellInfo.value) return "";
                            var dt = PortalUtility.FormatLocalDateTime(cellInfo.value);
                            if (dt) return moment(dt).format('MM/DD/YYYY hh:mm a');
                            return "";
                        }
                    }]
                }).dxDataGrid('instance');

                /* if (url == "/api/Title/TitleCases/") {
                    dataGrid.columnOption("Owner", "visible", true);
                    dataGrid.columnOption("StatusStr", "groupIndex", null);
                }

                if (url == "/api/Title/TitleCases/-1")
                    dataGrid.columnOption("StatusStr", "groupIndex", null);
                    */
            });
        })


    </script>

</asp:Content>
