<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="~/Content.Master" CodeBehind="NewOfferList.aspx.vb" Inherits="IntranetPortal.NewOfferList" %>

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
        New Offer Files
        <div id="useFilterApplyButton"></div>
    </div>
    <div id="gridContainer" style="margin: 10px"></div>
    <script>
        $(document).ready(function () {
            <% If Request.QueryString("view") IsNot Nothing %>
            currentView = <%= Request.QueryString("view")%>;
            <% Else %>
            currentView = 0;
            <% End If%>

            function GoToCase(CaseId) {
                var url = '/ViewLeadsInfo.aspx?id=' + CaseId;
                window.location.href = url;
            }
            
            function ShowCaseInfo(CaseId, stage) {
                var url = '/ViewLeadsInfo.aspx?id=' + CaseId;
                if (stage == "SS Accepted")
                {
                    url = '/NewOffer/NewOfferAccepted.aspx?bble=' + CaseId;                    
                }
                PortalUtility.ShowPopWindow("View Case - " + CaseId, url);                
            }
                        
            function loadData(view){
                var url = "/api/propertyoffer?mgrview=" + view;
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
                                column: "Title",
                                summaryType: "count"                                
                            }]
                        },
                        columns: [{
                            dataField: "Title",
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
                            caption: "Agent",
                            dataField: "LeadsOwner"
                        }, {
                            caption: "Team",
                            dataField: "Team"
                        }, {
                            caption: "Status",
                            dataField: "OfferStage"
                        }]
                    };

                    if (view == 4){
                        var hoi = [ {
                            caption: "HOI Completed On",
                            dataField: "HOICreateOn",
                            dataType: "date",
                            customizeText: PortalUtility.customizeDateText
                        }, {
                            caption: "Completed By",
                            dataField: "HOICreateBy"
                        }];
                        options.columns = options.columns.concat(hoi);   
                    }
                    else
                    {
                        var completed = [ {
                            caption: "New Offer Completed On",
                            dataField: "UpdateDate",
                            dataType: "date",
                            customizeText: PortalUtility.customizeDateText
                        }, {
                            caption: "Completed By",
                            dataField: "Owner"
                        }];
                        options.columns = options.columns.concat(completed);   
                    }

                    if(view == 3){
                        var duration = [{
                            caption: "Acceptance Date",
                            dataField: "AcceptedDate",
                            dataType: "date",
                            customizeText: PortalUtility.customizeDateText
                        }, {
                            caption: "Accepted By",
                            dataField: "AcceptedBy"
                        }, {
                            caption: "Duration",
                            dataField: "AcceptedDuration",
                            width: '80px',
                            customizeText: function(cellInfo){
                                if (!cellInfo.value)
                                    return ""

                                return moment.duration(cellInfo.value).humanize();
                            }
                        }];
                        options.columns = options.columns.concat(duration);                        
                    }

                    if(view == 2){
                        var duration = [{
                            caption: "In Process Date",
                            dataField: "InProcessDate",
                            dataType: "date",
                            customizeText: PortalUtility.customizeDateText
                        }, {
                            caption: "In Process By",
                            dataField: "InProcessBy"
                        }];
                        options.columns = options.columns.concat(duration);                        
                    }

                    var dataGrid = $("#gridContainer").dxDataGrid(options).dxDataGrid('instance');});
            }

            var applyFilterTypes = [
                {
                    key: 0,
                    name: "All Cases"
                },{
                    key: 4,
                    name: "Pending OF"
                }, {
                    key: 1,
                    name: "New Offer"
                }, {
                    key: 2,
                    name: "In Process"
                }, {
                    key: 3,
                    name: "SS Accepted"
                }];

            $("#useFilterApplyButton").dxSelectBox({
                items: applyFilterTypes,
                value: currentView,
                valueExpr: "key",
                displayExpr: "name",
                onValueChanged: function (data) {
                    loadData(data.value);
                }
            });

            loadData(currentView);
        });
    </script>

</asp:Content>
