<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="~/Content.Master" CodeBehind="DocSearchList.aspx.vb" Inherits="IntranetPortal.DocSearchList" %>

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

        iframe {
            border: none;
            width: 100%;
            height: 100%;
        }

        #xwrapper {
            float: left;
            height: 875px;
        }

        #preview {
            float: left;
            height: 875px;
        }

        #hideicon {
            visibility: hidden;
        }

            #hideicon:hover {
                cursor: pointer;
            }
    </style>

    <input type="text" style="display: none" />
    <div class="content">
        <div id="xwrapper">
            <div id="gridContainer" style="margin: 10px"></div>
        </div>

        <div id="preview" style="visibility: hidden">
            <iframe id="previewWindow"></iframe>
        </div>
    </div>
    <script>
        function resizeIframe(obj) {
            obj.style.height = obj.contentWindow.document.body.scrollHeight + 'px';
        }

        function GoToCase(CaseId) {
            var url = '/ViewLeadsInfo.aspx?id=' + CaseId;
            window.location.href = url;
        }

        previewControl = {
            showCaseInfo: function (CaseId) {
                $("#xwrapper").css("width", "50%");
                $("#preview").css("visibility", "visible");
                $("#preview").css("width", "50%");
                var url = '/PopupControl/LeadTaxSearchRequest.aspx?si=1&BBLE=' + CaseId + '#/';
                $("#previewWindow").attr("src", url);
                $("#hideicon").css("visibility", "visible");
            },

            undo: function () {
                $("#preview").css("width", "0%");
                $("#preview").css("visibility", "hidden");
                $("#hideicon").css("visibility", "hidden");
                $("#xwrapper").css("width", "100%");
                $("#previewWindow").attr("src", "");
            }

        }

        $(document).ready(function () {
            var url = "/api/LeadInfoDocumentSearches?status=1";
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
                    columns: [{
                        dataField: "CaseName",
                        width: 450,
                        caption: "Property Address",
                        cellTemplate: function (container, options) {
                            $('<a/>').addClass('dx-link-MyIdealProp')
                                .text(options.value)
                                .on('dxclick', function () {
                                    previewControl.showCaseInfo(options.data.BBLE);
                                })
                                .appendTo(container);
                        }
                    }, {
                        caption: "Requested By",
                        dataField: "CreateBy"
                    }, {
                        caption: "Search Status",
                        dataField: "Status",
                        customizeText: function (cell) {
                            switch (cell.value) {
                                case 1:
                                    return 'Completed';
                                default:
                                    return 'New';

                            }
                        }
                    },
                    {
                        caption: "Search Completion",
                        dataField: "CompletedOn",
                        dataType: "date",
                        sortOrder: 'desc',
                        customizeText: function (cellInfo) {
                            //return moment(cellInfo.value).tz('America/New_York').format('MM/dd/yyyy hh:mm tt')
                            if (!cellInfo.value)
                                return ""
                            var dt = PortalUtility.FormatLocalDateTime(cellInfo.value);
                            if (dt)
                                return moment(dt).format('MM/DD/YYYY hh:mm a');

                            return ""
                        }
                    }, {
                        caption: 'Underwriting Status',
                        dataField: 'UnderwriteStatus',
                        customizeText: function (cell) {
                            switch (cell.value) {
                                case 1:
                                    return 'Completed';
                                case 2:
                                    return 'Rejected';
                                default:
                                    return 'Pending';

                            }
                        }
                    }]
                }).dxDataGrid('instance');
                $(".dx-datagrid-header-panel").prepend($("<label class='grid-title-icon' style='display: inline-block'>UW</label>"))
                $(".dx-datagrid-header-panel").prepend($("<span id='hideicon' data-toggle='tooltip' data-placement='right' title='hide right panel' onclick='previewControl.undo()'><img class='pull-right' src='/images/hide.png' height='40' width='40' /></span>"))
            });
        })

    </script>

</asp:Content>

