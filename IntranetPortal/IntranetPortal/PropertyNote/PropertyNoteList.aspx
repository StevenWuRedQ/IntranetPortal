<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="~/Content.Master" CodeBehind="PropertyNoteList.aspx.vb" Inherits="IntranetPortal.PropertyNoteList" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContentPH" runat="server">

    <script src="https://cdnjs.cloudflare.com/ajax/libs/moment.js/2.11.2/moment.min.js" type="text/javascript"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/moment-timezone/0.5.0/moment-timezone.min.js" type="text/javascript"></script>

    <style type="text/css">
        a.dx-link-MyIdealProp {
            margin-left: 5px;
        }

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
            font-size: 24px;
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
        Property Notes
        <div id="useFilterApplyButton"></div>
    </div>
    <div id="gridContainer" style="margin: 10px"></div>
    <script>
        $(document).ready(function () {

            function GoToCase(CaseId) {
                var url = '/ViewLeadsInfo.aspx?id=' + CaseId;
                window.location.href = url;
            }

            function ShowCaseInfo(CaseId) {
                var url = '/ViewLeadsInfo.aspx?id=' + CaseId;
                PortalUtility.ShowPopWindow("View Case - " + CaseId, url);
            }

            
            function loadData(view) {
                var url = "/api/propertynote?bble=&status=" + view;
                $.getJSON(url).done(function (data) {
                    var options = {
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
                        },
                        onRowPrepared: function (rowInfo) {
                            if (rowInfo.rowType != 'data')
                                return;
                            rowInfo.rowElement.addClass('myRow');
                        },
                        onContentReady: function (e) {

                        },
                        summary: {
                            groupItems: [{
                                column: "BBLE",
                                summaryType: "count",
                                displayFormat: "{0}",
                            }],
                            totalItems: [{
                                column: "PropertyAddress",
                                summaryType: "count"
                            }]
                        },                   
                        columns: [{
                            dataField: "PropertyAddress",
                            width: 450,
                            caption: "Property Address",
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
                            dataField: "BPOValue",
                            format: 'currency'
                        }, {
                            caption: "FC Status",
                            dataField: "FCStatus"
                        }, {
                            caption: "LastPaid",
                            dataField: "LastPaidInstallmentDt",
                            dataType: "date"
                        }, {
                            caption: "Next Payment",
                            dataField: "NextPmtDueDt",
                            dataType: "date"
                        }, {
                            caption: "FCStart",
                            dataField: "FCStartDt",
                            dataType: "date"
                        }, "CurrentOccupancy",  {                        
                            dataField: "DelinquentInterest",
                            format: 'currency'
                        }, {
                            dataField: "CurrentUPB",
                            format: 'currency'
                        }, {
                            dataField: "ForbearanceAmount",
                            format: 'currency'
                        }, {
                            dataField: "EscrowAdvanceBalance",
                            format: 'currency'
                        }, {
                            dataField: "TotalDue",
                            format: 'currency'
                        }]
                    };

                    var dataGrid = $("#gridContainer").dxDataGrid(options).dxDataGrid('instance');
                });
            }

            var applyFilterTypes = [
                {
                    key: "",
                    name: "All Notes"
                }, {
                    key: "Service Completed",
                    name: "Service Completed"
                }, {
                    key: "Referred",
                    name: "Referred"
                }, {
                    key: "First Legal Filed",
                    name: "First Legal Filed"
                }];

            $("#useFilterApplyButton").dxSelectBox({
                items: applyFilterTypes,
                valueExpr: "key",
                displayExpr: "name",
                onValueChanged: function (data) {
                    loadData(data.value);
                }
            });

            loadData('');
        });
    </script>
    <div class="modal fade" id="divHistory" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
        <div class="modal-dialog" style="width: 750px">
            <div class="modal-content">
                <div class="modal-header">
                    <h4 class="modal-title">Offer History</h4>
                </div>
                <div class="modal-body">
                    <div id="gridHistory"></div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>               
                </div>
            </div>
        </div>
    </div>
    <div class="modal fade" id="divDetail" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
        <div class="modal-dialog" style="width: 750px">
            <div class="modal-content">
                <div class="modal-header">
                    <h4 class="modal-title">Offer Detail</h4>
                </div>
                <div class="modal-body">
                    
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
