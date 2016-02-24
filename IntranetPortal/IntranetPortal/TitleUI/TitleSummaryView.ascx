<%@ Control Language="vb" AutoEventWireup="false" CodeBehind="TitleSummaryView.ascx.vb" Inherits="IntranetPortal.TitleSummaryView" %>

<style type="text/css">
    a.dx-link-MyIdealProp:hover {
        font-weight: 500;
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
    }

    .apply-filter-option > div:last-child {
        display: inline-block;
        vertical-align: top;
        margin-left: 10px;
        line-height: normal;
    }
</style>

<input type="text" style="display: none" />
<%--<div class="apply-filter-option">
    Apply Filter:
    <div id="useFilterApplyButton"></div>
</div>--%>
<div id="gridContainer" style="margin: 10px"></div>
<script>
    function GoToCase(CaseId) {
        var url = '/BusinessForm/Default.aspx?tag=' + CaseId;
        window.location.href = url;
    }
    var fileWindows = {};
    function ShowCaseInfo(CaseId) {
        for (var win in fileWindows) {
            if (fileWindows.hasOwnProperty(win) && win == CaseId) {
                var caseWin = fileWindows[win];
                if (!caseWin.closed) {
                    caseWin.focus();
                    return;
                }
            }
        }

        var url = '/BusinessForm/Default.aspx?tag=' + CaseId;
        var left = (screen.width / 2) - (1350 / 2);
        var top = (screen.height / 2) - (930 / 2);
        debugger;
        var win = window.open(url, 'View Title Case - ' + CaseId, 'Width=1350px,Height=930px, top=' + top + ', left=' + left);
        fileWindows[CaseId] = win;
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
            }, {
                caption: "Owner",
                dataField: "Owner"
            }]
        }).dxDataGrid('instance');

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

</script>
