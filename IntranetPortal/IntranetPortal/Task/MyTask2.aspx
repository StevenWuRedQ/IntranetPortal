<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="MyTask2.aspx.vb" Inherits="IntranetPortal.MyTask2" MasterPageFile="~/Content.Master" %>

<%@ Register Src="~/Task/TasklistControl.ascx" TagPrefix="uc1" TagName="TasklistControl" %>

<asp:Content ContentPlaceHolderID="MainContentPH" runat="server">

    <style type="text/css">
        a.dx-link-MyIdealProp:hover {
            font-weight: 500;
            cursor: pointer;
        }

        .myRow:hover {
            background-color: #efefef;
        }

        .apply-filter-option {
            margin-top: 15px;
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
        Task
    <div id="useFilterApplyButton"></div>
    </div>
    <div id="gridContainer" style="margin: 10px; border-top: 5px solid red;"></div>
    <script>
        $(document).ready(function () {
            function GoToCase(CaseId) {
                var url = '/BusinessForm/Default.aspx?tag=' + CaseId;
                window.location.href = url;
            }

            function ShowCaseInfo(sn, url) {
                PortalUtility.ShowPopWindow("View Task " + sn, url);
            }

            var url = "/api/workflow";
            $.getJSON(url).done(function (data) {               
                var dataGrid = $("#gridContainer").dxDataGrid({
                    dataSource: data,
                    searchPanel: {
                        visible: true,
                        width: 240,
                        placeholder: "Search..."
                    },
                    //summary: {
                    //    groupItems: [{                         
                    //        summaryType: "count",
                    //        displayFormat: "{0}",
                    //    }]
                    //},
                    headerFilter: {
                        visible: true
                    },
                    rowAlternationEnabled: true,                   
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
                        dataField: "DisplayName",
                        width: 450,
                        caption: "Case Name",
                        cellTemplate: function (container, options) {
                            $('<a/>').addClass('dx-link-MyIdealProp')
                                .text(options.value)
                                .on('dxclick', function () {
                                    //Do something with options.data;
                                    ShowCaseInfo(options.data.SeriesNumber, options.data.ItemData);
                                })
                                .appendTo(container);
                        }
                    }, {
                        dataField: "Priority",
                        caption: "Priority",
                        customizeText: function (cellInfo) {
                            //return moment(cellInfo.value).tz('America/New_York').format('MM/dd/yyyy hh:mm tt')
                            if (cellInfo.value == null)
                                return ""

                            if (cellInfo.value == 0)
                                return "Normal";

                            if (cellInfo.value == 1)
                                return "High";

                            if (cellInfo.value == 2)
                                return "Urgent";
                        }
                    }, {
                        dataField: "StartDate",
                        caption: "Date Created",
                        dataType: "date",
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
                        dataField: "DueDate",
                        dataType: "date"                        
                        //customizeText: function (cellInfo) {
                        //    //return moment(cellInfo.value).tz('America/New_York').format('MM/dd/yyyy hh:mm tt')
                        //    if (!cellInfo.value)
                        //        return ""

                        //    var dt = PortalUtility.FormatLocalDateTime(cellInfo.value);
                        //    if (dt)
                        //        return moment(dt).format('MM/DD/YYYY');

                        //    return ""
                        //}
                    }, {
                        caption: "Process",
                        dataField: "ProcSchemeDisplayName",
                        groupIndex: 0
                    }, {
                        caption: "Applicant",
                        dataField: "Originator",
                    }, {
                        caption: "Status",
                        dataField: "Status",
                        customizeText: function (cellInfo) {
                            //return moment(cellInfo.value).tz('America/New_York').format('MM/dd/yyyy hh:mm tt')
                            if (cellInfo.value == null)
                                return ""

                            if (cellInfo.value == 0)
                                return "Available";

                            if (cellInfo.value == 1)
                                return "Open";

                            return "Closed";
                        }
                    }]
                }).dxDataGrid('instance');

                var applyFilterTypes = [{
                    key: "all",
                    name: "All Tasks"
                }, {
                    key: "today",
                    name: "Due on Today"
                }, {
                    key: "week",
                    name: "Due in a week"
                }];

                $("#useFilterApplyButton").dxSelectBox({
                    items: applyFilterTypes,
                    value: applyFilterTypes[0].key,
                    valueExpr: "key",
                    displayExpr: "name",
                    onValueChanged: function (data) {
                        if (data.value == "all") {
                            dataGrid.clearFilter();
                        } else {
                            if (data.value == "today")
                            {
                                dataGrid.filter(["DueDate", "<", moment().add(1, 'days').toDate()]);
                            }
                            
                            if (data.value == "week")
                                dataGrid.filter(["DueDate", "<", moment().add(7, 'days').toDate()]);
                        }
                    }
                });
            });
        })


    </script>
</asp:Content>
