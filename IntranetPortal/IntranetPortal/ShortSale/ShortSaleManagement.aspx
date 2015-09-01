<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="ShortSaleManagement.aspx.vb" Inherits="IntranetPortal.ShortSaleManagement" MasterPageFile="~/Content.Master" %>

<asp:Content ContentPlaceHolderID="head" runat="server">
    <meta name="viewport" content="width=device-width, initial-scale=1">    
    <style>
        .nofoucs:focus {
            border: none !important;
        }
    </style>
</asp:Content>

<asp:Content ContentPlaceHolderID="MainContentPH" runat="server">    
    <script src="http://cdn3.devexpress.com/jslib/15.1.6/js/dx.chartjs.js"></script>
    <div class="container-fluid">
        <%--Head--%>
        <div style="padding-top: 30px">
            <div style="font-size: 48px; color: #234b60">
                <div class="row">
                    <div class="col-md-4 ">
                        <div class="border_right" style="padding-right: 0px; font-weight: 300;">
                            <table>
                                <tr>
                                    <td id="tdReportTitle"><i class="fa fa-users mag_tabv_i"></i>Case Status Report
                                    </td>
                                    <td>
                                        <%--<i class="fa fa-caret-down" style="color: #2e2f31; font-size: 18px;" ></i>--%>
                                        <div id="reportType" class="nofoucs" style="margin-left: 10px; background: white; border: none; box-shadow: none" />
                                    </td>
                                </tr>
                            </table>
                        </div>
                    </div>
                    <div class="col-md-2">
                        <table>
                            <tr>
                                <td>
                                    <span style="font-size: 30px" id="teams_link">ShortSale Team</span>
                                </td>
                                <td>
                                    <%--<i class="fa fa-caret-down" style="color: #2e2f31; font-size: 18px;" ></i>--%>
                                    <div id="dropDownMenu" class="nofoucs" style="margin-left: 10px; background: white; border: none; box-shadow: none" />
                                </td>
                            </tr>
                        </table>
                        <%--<i class="fa fa-caret-down" style="color: #2e2f31; font-size: 18px;" ></i>--%>
                    </div>
                    <div class="col-md-6">
                        <div>
                            <div style="display: inline-block">
                                <span class="magement_font">Total agents</span>
                                <span class="magement_font magement_number" id="total_agent_count">23</span>
                            </div>
                            <div style="display: inline-block; margin-left: 20px">
                                <span class="magement_font">total deals within last 30 days</span>
                                <span class="magement_font magement_number" id="total_deal_count">241</span>
                            </div>
                            <div style="display: inline-block">
                                <span class="magement_number management_score">
                                    <span class="management_molecular ">87</span> <span class="management_denominator">/100</span>
                                </span>
                            </div>
                            <div style="display: inline-block" class="management_text">
                                <span>Effeciency Score</span><br />
                                <span>This Month</span>
                            </div>
                            <i class="fa fa-search-plus management_search_icon" style="margin-left: 10px;"></i>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <div style="margin-top: 40px;">
            <%--body Left--%>
            <div class="container-fluid">
                <div class="row">
                    <div class="col-md-12">
                        <div style="min-height: 800px">
                            <div class="tab-content" style="padding-right: 10px">
                                <div role="tabpanel" class="tab-pane active" id="Status_Of_Leads_Tab">
                                    <div class="mag_tab_input_group">
                                        <div class="row">
                                            <div class="col-md-5">
                                                <label for="selAgents" style="float: left">Select Status:&nbsp;</label>
                                                <select class="form-control" style="width: 200px; float: left; margin-left: 20px;" id="selectStatus" name="selectStatus">
                                                    <option>All</option>
                                                </select>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="row" style="margin-top: 10px">
                                        <div class="col-md-4">
                                            <div>
                                                <div class="chart_text">
                                                    <div id="CaseStatusChart" class="containers" style="height: 500px; width: 100%; float: left"></div>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="col-md-8">
                                            <div style="border-left: 1px solid #dde0e7;">
                                                <div style="padding: 10px 15px; font-weight: 300; color: #2e2f31">
                                                    <div>
                                                        <i class="fa fa-table report_head_button report_head_button_padding tooltip-examples"></i><span class="font_black" id="gridTitle">Cases Data</span>
                                                    </div>
                                                    <div id="gridCases" style="height: 600px; max-width: 1400px; width: 100%; margin-top: 5px;"></div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    <script type="text/javascript">
                                        var CaseStatusTab = {
                                            CaseDataSouce: {
                                                CaseCategories: new DevExpress.data.DataSource("ShortSaleServices.svc/CategoryList"),
                                                ChartSource: null,
                                                Category: null,
                                                Load: function (category) {
                                                    this.Category = category;
                                                    this.ChartSource = new DevExpress.data.DataSource("ShortSaleServices.svc/GetCategoryCount?category=" + category);
                                                },
                                                LoadGridSource: function (status) {
                                                    var view = this;
                                                    var customStore = new DevExpress.data.CustomStore({
                                                        load: function (loadOptions) {
                                                            var d = $.Deferred();
                                                            $.getJSON("ShortSaleServices.svc/LoadCaseData?category=" + view.Category + "&status=" + status).done(function (data) {
                                                                d.resolve(data, { totalCount: data.length });
                                                            });
                                                            return d.promise();
                                                        }
                                                    });
                                                    return customStore;
                                                },
                                            },
                                            DataView: {
                                                Agent: {
                                                    Name: null,
                                                    LeadsDataSource: null,
                                                    LeadsInProcessDataSource: null,
                                                    LoadDataSource: function () {
                                                        this.LeadsDataSource = new DevExpress.data.DataSource("/wcfdataservices/portalReportservice.svc/LoadAgentLeadsReport/" + this.Name);
                                                        this.LeadsInProcessDataSource = new DevExpress.data.DataSource("/WCFDataServices/PortalReportService.svc/LoadAgentInProcessReport/" + this.Name);
                                                    },
                                                    GetLeadsData: function (status) {
                                                        var view = this;
                                                        var customStore = new DevExpress.data.CustomStore({
                                                            load: function (loadOptions) {
                                                                var d = $.Deferred();
                                                                $.getJSON("/WCFDataServices/PortalReportService.svc/LoadAgentLeadsData/" + view.Name + "/" + status).done(function (data) {
                                                                    d.resolve(data, { totalCount: data.length });
                                                                });
                                                                return d.promise();
                                                            }
                                                        });
                                                        return customStore;
                                                    }
                                                },
                                                Team: {
                                                    Name: null,
                                                    TeamUsers: null,
                                                    LeadsDataSource: null,
                                                    LeadsInProcessDataSource: null,
                                                    LoadDataSource: function () {
                                                        this.LeadsDataSource = new DevExpress.data.DataSource("/wcfdataservices/portalReportservice.svc/LoadTeamLeadsReport/" + this.Name);
                                                        this.LeadsInProcessDataSource = new DevExpress.data.DataSource("/WCFDataServices/PortalReportService.svc/LoadTeamInProcessReport/" + this.Name);
                                                    },
                                                    GetLeadsData: function (status) {
                                                        var view = this;
                                                        var customStore = new DevExpress.data.CustomStore({
                                                            load: function (loadOptions) {
                                                                var d = $.Deferred();
                                                                $.getJSON("/WCFDataServices/PortalReportService.svc/LoadTeamLeadsData/" + view.Name + "/" + status).done(function (data) {
                                                                    d.resolve(data, { totalCount: data.length });
                                                                });
                                                                return d.promise();
                                                            }
                                                        });
                                                        return customStore;
                                                    }
                                                }
                                            },
                                            DisplayView: null,
                                            DataGridCases: $("#gridCases").dxDataGrid({
                                                showColumnLines: false,
                                                showRowLines: true,
                                                rowAlternationEnabled: true,
                                                paging: { enabled: false },
                                                remoteOperations: {
                                                    sorting: false
                                                },
                                                columns: [{
                                                    dataField: "CaseName",
                                                    caption: "Case Name",
                                                    width: 240,
                                                    cellTemplate: function (container, options) {
                                                        if (options.value != null) {
                                                            var fieldHTML = '<a target="_blank" href="javascript:ShowCaseInfo(\'' + options.data.CaseId + '\')">' + options.value + "</a>"
                                                            container.html(fieldHTML);
                                                        }
                                                    }
                                                }, {
                                                    dataField: "BBLE",
                                                    caption: "BBLE",
                                                    width: 100
                                                }, {
                                                    dataField: "Owner",
                                                    caption: "Processor"
                                                },{
                                                    dataField: "OwnerFullName",
                                                    caption: "Home Owner"
                                                }, {
                                                    dataField: "Name",
                                                    caption: "Referral"
                                                }, {
                                                    dataField: "OccupiedBy",
                                                    caption: "Occupancy"
                                                },{
                                                    dataField: "UpdateDate",
                                                    caption: "Last Update",
                                                    dataType: 'date'
                                                }],
                                                summary: {
                                                    totalItems: [{
                                                        column: 'BBLE',
                                                        summaryType: 'count'
                                                    }]
                                                }
                                            }).dxDataGrid("instance"),
                                            CategorySelect: $("#selectStatus"),
                                            InitStatusSelect: function (categories) {
                                                var tab = this;
                                                tab.CategorySelect.html("");
                                                $.each(categories, function (key, value) {
                                                    tab.CategorySelect.append(
                                                   $("<option></option>")
                                                    .attr("value", value)
                                                    .text(value));
                                                });
                                                tab.CategorySelect.prepend("<option value='All' selected='selected'>All</option>");

                                                tab.CategorySelect.change(function () {
                                                    tab.LoadChart(tab.CategorySelect.val());

                                                });
                                            },
                                            ShowTab: function () {
                                                var tab = this;
                                                this.CaseDataSouce.CaseCategories.load().done(function (result) {
                                                    tab.InitStatusSelect(result);
                                                    tab.LoadChart(tab.CategorySelect.val());
                                                });

                                                return;

                                                if (this.Visible() || noCheck) {
                                                    this.DataView.Team.Name = teamName;
                                                    this.DataView.Team.TeamUsers = users;
                                                    this.DisplayView = this.DataView.Team;
                                                    this.InitAgentSelect();
                                                    this.LoadChart();
                                                }
                                            },
                                            ShowAgentChart: function (agentName) {
                                                this.DataView.Agent.Name = agentName;
                                                this.DisplayView = this.DataView.Agent;
                                                this.LoadChart();
                                            },
                                            LoadChart: function (category) {
                                                var tab = this;
                                                tab.CaseDataSouce.Load(category);
                                                if (!$("#CaseStatusChart").has("svg").length) {
                                                    var option = {
                                                        dataSource: tab.CaseDataSouce.ChartSource,
                                                        tooltip: {
                                                            enabled: true,
                                                            percentPrecision: 2,
                                                            customizeText: function () {
                                                                return this.argumentText + " - " + this.percentText;
                                                            }
                                                        },
                                                        legend: {
                                                            visible: true,
                                                            verticalAlignment: "bottom",
                                                            horizontalAlignment: "center"
                                                        },
                                                        series: [{
                                                            type: "doughnut",
                                                            argumentField: "Category",
                                                            valueField: "Count",
                                                            tagField: "Category",
                                                            label: {
                                                                visible: true,
                                                                connector: {
                                                                    visible: true
                                                                }
                                                            },

                                                        }],
                                                        palette: ['#a5bcd7', '#e97c82', '#da5859', '#f09777', '#fbc986', '#a5d7d0', '#a5bcd7']
                                                    }

                                                    option.onDone = function (e) {
                                                        DevExpress.data.query(tab.CaseDataSouce.ChartSource.items()).sum("Count").done(function (result) {
                                                            e.component.option("title", tab.CaseDataSouce.Category + ", Total: <b>" + result + "</b>");
                                                        });
                                                    }

                                                    option.onPointClick = function (e) {
                                                        var point = e.target;
                                                        tab.LoadGridLeads(point.tag);
                                                        $("#gridTitle").html(point.originalArgument);
                                                        //point.isVisible() ? point.hide() : point.show();
                                                    };
                                                    $("#CaseStatusChart").dxPieChart(option);

                                                    //option.dataSource = tab.DisplayView.LeadsDataSource;
                                                    //option.onDone = function (e) {
                                                    //    DevExpress.data.query(tab.DisplayView.LeadsDataSource.items()).sum("Count").done(function (result) {
                                                    //        e.component.option("title", tab.DisplayView.Name + " Leads: <b>" + result + "</b>");
                                                    //    });
                                                    //};

                                                    //$("#ProcessStatusChart").dxPieChart(option);
                                                }
                                                else {
                                                    var chart = $("#CaseStatusChart").dxPieChart("instance");
                                                    chart.option("dataSource", tab.CaseDataSouce.ChartSource);
                                                }
                                            },
                                            LoadGridLeads: function (statusKey) {
                                                var tab = this;

                                                this.DataGridCases.beginUpdate();

                                                var ds = tab.CaseDataSouce.LoadGridSource(statusKey);
                                                this.DataGridCases.option("dataSource", ds);
                                                this.DataGridCases.endUpdate();
                                            }
                                        };
                                    </script>
                                </div>
                            </div>
                        </div>

                    </div>
                </div>
            </div>
        </div>
    </div>
    <script type="text/javascript">
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

            var url = '/ShortSale/ShortSale.aspx?CaseId=' + CaseId;
            var left = (screen.width / 2) - (1350 / 2);
            var top = (screen.height / 2) - (930 / 2);
            debugger;
            var win = window.open(url, 'View Case Info ' + CaseId, 'Width=1350px,Height=930px, top=' + top + ', left=' + left);
            fileWindows[CaseId] = win;
        }


        CaseStatusTab.ShowTab();
    </script>
</asp:Content>

