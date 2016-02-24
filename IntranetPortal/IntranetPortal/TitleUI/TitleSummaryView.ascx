<%@ Control Language="vb" AutoEventWireup="false" CodeBehind="TitleSummaryView.ascx.vb" Inherits="IntranetPortal.TitleSummaryView" %>

<script src="https://cdnjs.cloudflare.com/ajax/libs/moment.js/2.11.2/moment.min.js" type="text/javascript"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/moment-timezone/0.5.0/moment-timezone.min.js" type="text/javascript"></script>

<style type="text/css">
    a.dx-link-MyIdealProp:hover {
        font-weight: 500;
        cursor:pointer;
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
<div class="apply-filter-option">
    <%= Category %>
    <%--<div id="useFilterApplyButton"></div>--%>
</div>
<div id="gridContainer" style="margin: 10px"></div>
<script>
    $(document).ready(function () {
        function GoToCase(CaseId) {
            var url = '/BusinessForm/Default.aspx?tag=' + CaseId;
            window.location.href = url;
        }
        
        function ShowCaseInfo(CaseId) {         
            var url = '/BusinessForm/Default.aspx?tag=' + CaseId;
            PortalUtility.ShowPopWindow("View Title Case - " + CaseId, url);
        }

        var url = "/api/Title/TitleCases/<%=CategoryId%>";
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
                    }]},
                columns: [{
                    dataField: "CaseName",
                    width: 450,
                    caption: "Case Name",
                    cellTemplate: function (container, options) {
                        $('<a/>').addClass('dx-link-MyIdealProp')
                            .text(options.value)
                            .on('dxclick', function () {
                                //Do something with options.data;
                                ShowCaseInfo(options.data.BBLE);
                            })
                            .appendTo(container);
                    }
                }, {
                    dataField: "TitleCategory",
                    caption: "Category",
                }, {
                    dataField: "StatusStr",
                    caption: "Status",
                    groupIndex:0
                }, {
                    caption: "LastUpdate",
                    dataField: "UpdateDate",
                    dataType: "date",
                    customizeText: function (cellInfo) {
                        //return moment(cellInfo.value).tz('America/New_York').format('MM/dd/yyyy hh:mm tt')
                        var dt = PortalUtility.FormatLocalDateTime(cellInfo.value);
                        return moment(dt).format('MM/DD/YYYY hh:mm a');
                    }
                }, {
                    caption: "Owner",
                    dataField: "Owner",
                    visible: false
                }]
            }).dxDataGrid('instance');

            if (url == "/api/Title/TitleCases/")
                dataGrid.columnOption("Owner", "visible", true);

        <%-- var applyFilterTypes = [{
            key: "AllCases",
            name: "All Cases"
        }, {
            key: "MyCases",
            name: "My Cases"
        }];

        $("#useFilterApplyButton").dxSelectBox({
            items: applyFilterTypes,
            value: applyFilterTypes[0].key,
            valueExpr: "key",
            displayExpr: "name",
            onValueChanged: function (data) {
                if (data.value == "AllCases") {
                    dataGrid.clearFilter();
                } else {
                    dataGrid.filter(["Owner", "=", "<%= Page.User.Identity.Name%>"]);
        }
            }
        });--%>
    });
    })


</script>
