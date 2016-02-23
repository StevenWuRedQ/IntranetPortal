<%@ Control Language="vb" AutoEventWireup="false" CodeBehind="TitleSummaryView.ascx.vb" Inherits="IntranetPortal.TitleSummaryView" %>

<style type="text/css">
    a.dx-link-MyIdealProp:hover {
        font-weight: 500;     
    }

    .myRow:hover {
         background-color:#efefef;
    }

</style>

<input type="text" style="display: none" />
<h3 style="text-align:center; margin-top:15px;">All Cases</h3>
<div id="gridContainer" style="margin:10px"></div>
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

    var url = "/api/Title/TitleCases";
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
                showInfo: true
            },
            paging:{
                enabled: true,                
            },
            onRowPrepared: function (rowInfo) {
                if (rowInfo.rowType != 'data')
                    return;
                rowInfo.rowElement
                .addClass('myRow');                
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

    });

</script>
