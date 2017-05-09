<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="~/Content.Master" CodeBehind="GPAOfferList.aspx.vb" Inherits="IntranetPortal.GPAOfferList" %>

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
        GPA Offer Files
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

            function enableTitle(bble, data) {
                var url = "/api/gpaoffer/" + bble.trim() + "/enabletitle";
                $.ajax({
                    type: "POST",
                    url: url,
                    data: data,
                    success: function () { AngularRoot.alert('Success'); }
                });
            }

            function loadData(view) {
                var url = "/api/gpaoffer?view=" + view;
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
                                column: "Address",
                                summaryType: "count"
                            }]
                        },
                        columns: [{
                            dataField: "Address",
                            width: 450,
                            caption: "Property Address",
                            cellTemplate: function (container, options) {
                                $('<a/>').addClass('dx-link-MyIdealProp')
                                    .text(options.value)
                                    .on('dxclick', function () {
                                        //Do something with options.data;
                                        ShowCaseInfo(options.data.BBLE, options.data.OfferStage);
                                    })
                                    .appendTo(container);
                            }
                        }, {
                            caption: "Offer",
                            dataField: "OfferPrice"
                        }, {
                            caption: "Generate By",
                            dataField: "GenerateBy"
                        }, {
                            caption: "Last Update",
                            dataField: "LastUpdate",
                            dataType: "date"
                        },
                        {
                            caption: "Agent",
                            dataField: "CurrentAgent"
                        }, {
                            caption: "Offer For",
                            dataField: "OfferFor"
                        }, "Comments", {
                            caption: "Status",
                            dataField: "StatusStr"
                        }, {
                            caption: "Action",
                            cellTemplate: function (container, options) {
                                $('<a/>').addClass('dx-link-MyIdealProp')
                                    .text('Enable Title')
                                    .on('dxclick', function () {
                                        enableTitle(options.data.BBLE, options.data);
                                    })
                                    .appendTo(container);

                                $('<a/>').addClass('dx-link-MyIdealProp')
                                    .text('History')
                                    .on('dxclick', function () {
                                        loadHistory(options.data.BBLE);                                      
                                    })
                                    .appendTo(container);
                            }
                        }]
                    };

                    var dataGrid = $("#gridContainer").dxDataGrid(options).dxDataGrid('instance');
                });
            }

            function loadHistory(bble) {
                var url = "/api/ExternalData?source=grade&api=api/usergradedata/refid/" + bble;
                $.getJSON(url).done(function (data) {
                    var options = {
                        dataSource: data,                     
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
                        columns: [{
                            dataField: "title",                           
                        }, {
                            caption: "Offer",
                            dataField: "offerPrice"
                        }, {
                            caption: "Generate By",
                            dataField: "createdBy"
                        }, {
                            caption: "Offer For",
                            dataField: "offerFor"
                        }, "comments", {
                            dataField: "updatedDate",
                            dataType: "date"
                        }]
                    };

                    var dataGrid = $("#gridHistory").dxDataGrid(options).dxDataGrid('instance');
                    $('#divHistory').modal();
                });
            }

            var applyFilterTypes = [
                {
                    key: -1,
                    name: "All Cases"
                }, {
                    key: 0,
                    name: "Active"
                }, {
                    key: 1,
                    name: "In Title"
                }, {
                    key: 2,
                    name: "Closed"
                }];

            $("#useFilterApplyButton").dxSelectBox({
                items: applyFilterTypes,
                valueExpr: "key",
                displayExpr: "name",
                onValueChanged: function (data) {
                    loadData(data.value);
                }
            });

            loadData(-1);
        });
    </script>
    <div class="modal fade" id="divHistory" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
        <div class="modal-dialog" style="width:750px">
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
</asp:Content>
