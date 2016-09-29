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

        $(document).ready(function () {
            function GoToCase(CaseId) {
                var url = '/ViewLeadsInfo.aspx?id=' + CaseId;
                window.location.href = url;
            }

            function ShowCaseInfo(CaseId) {
                $("#xwrapper").css("width", "50%");
                $("#preview").css("visibility", "visible");
                $("#preview").css("width", "50%");

                var url = '/PopupControl/LeadTaxSearchRequest.aspx?si=1&BBLE=' + CaseId + '#/';
                $("#previewWindow").attr("src", url)
            }

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
                                    ShowCaseInfo(options.data.BBLE);
                                })
                                .appendTo(container);
                        }
                    }, {
                        caption: "Search Completed On",
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
                    },
                    //{
                    //    caption: "Completed By",
                    //    dataField: "CompletedBy"
                    //},
                    {
                        caption: "Requested By",
                        dataField: "CreateBy"
                    }]
                }).dxDataGrid('instance');
                $(".dx-datagrid-header-panel").prepend($("<label class='grid-title-icon' style='display: inline-block'>UW</label>"))
            });
        })

    </script>

</asp:Content>

