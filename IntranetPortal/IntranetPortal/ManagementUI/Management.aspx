<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="Management.aspx.vb" Inherits="IntranetPortal.Management1" MasterPageFile="~/Content.Master" %>

<asp:Content ContentPlaceHolderID="head" runat="server">
    <meta name="viewport" content="width=device-width, initial-scale=1">
</asp:Content>
<asp:Content ContentPlaceHolderID="MainContentPH" runat="server">
    <script src="/Scripts/globalize/globalize.js"></script>
    <script src="/Scripts/dx.chartjs.js"></script>
    <div class="container-fluid">
        <%--Head--%>
        <div style="padding-top: 30px">
            <div style="font-size: 48px; color: #234b60">

                <div class="row">
                    <div class="col-md-4">
                        <span class="border_right" style="padding-right: 30px; font-weight: 300;">Management Summary</span>
                    </div>
                    <div class="col-md-2">
                        <span style="font-size: 30px" class="icon_btn">Queens Team</span>
                        <i class="fa fa-caret-down" style="color: #2e2f31; font-size: 18px;"></i>
                    </div>
                    <div class="col-md-6">
                        <div>
                            <div style="display: inline-block">
                                <span class="magement_font">Total agents</span>
                                <span class="magement_font magement_number">23</span>
                            </div>
                            <div style="display: inline-block; margin-left: 20px">
                                <span class="magement_font">total deals within last 30 days</span>
                                <span class="magement_font magement_number">241</span>
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
            <div class="row">
                <div class="col-md-7">
                    <div role="tabpanel" class="mag_tab_panel">

                        <!-- Nav tabs -->
                        <ul class="nav nav-tabs" role="tablist">
                            <li role="presentation" class="active mag_tab"><a class="mag_tab_text" href="#phone_callsTab" aria-controls="phone_callsTab" role="tab" data-toggle="tab"><i class="fa fa-phone"></i>
                                <br />
                                Phone Calls</a></li>
                            <li role="presentation" class="mag_tab"><a class="mag_tab_text" href="#profile" aria-controls="profile" role="tab" data-toggle="tab"><i class="fa fa-sign-in"></i>
                                <br />
                                Door Knocks</a></li>
                            <li role="presentation" class="mag_tab"><a class="mag_tab_text" href="#deals_tab" aria-controls="deals_tab" role="tab" data-toggle="tab"><i class="fa fa-check-circle"></i>
                                <br />
                                Deals</a></li>
                            <li role="presentation" class="mag_tab"><a class="mag_tab_text" href="#messages" aria-controls="messages" role="tab" data-toggle="tab"><i class="fa fa-crosshairs"></i>
                                <br />
                                HR Analytics</a></li>

                        </ul>

                        <!-- Tab panes -->
                        <div class="tab-content" style="padding: 30px;">
                            <div role="tabpanel" class="tab-pane active" id="phone_callsTab">
                                <div class="mag_tab_input_group">

                                    <div class="row">
                                        <div class="col-md-3">
                                            <select class="form-control">
                                                <option>Last Month</option>
                                            </select>
                                        </div>
                                        <div class="col-md-3">
                                            <select class="form-control">
                                                <option>All Agents</option>
                                                <option>Agents 1</option>
                                            </select>
                                        </div>
                                        <div class="col-md-1">
                                            <button class="rand-button bg_color_blue rand-button-padding">Display</button>
                                        </div>
                                    </div>
                                </div>
                                <div style="margin: 30px 0; font-size: 24px; color: #234b60">
                                    <span style="font-weight: 900">52,013 </span>Phone Calls<br />
                                    <span style="font-size: 14px; color: #77787b">January 1, 2015 - January 31, 2015</span>
                                </div>
                                <div style="font-size: 14px;">
                                    <table class="table table-striped">
                                        <thead style="text-transform: uppercase">
                                            <tr>
                                                <td>Name</td>
                                                <td>Phone Calls </td>
                                                <td>Total Time</td>
                                                <td>Longest Call TO</td>
                                                <td>Last Called #</td>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <tr>
                                                <th scope="row">BiBi Khan</th>
                                                <td>1,234</td>
                                                <td>37H 23M</td>
                                                <td>718-123-4567</td>
                                                <td>800-324-4567</td>
                                            </tr>
                                            <tr>
                                                <th scope="row">Prakash Maharaj</th>
                                                <td>1,234</td>
                                                <td>37H 23M</td>
                                                <td>718-123-4567</td>
                                                <td>800-324-4567</td>
                                            </tr>

                                        </tbody>
                                    </table>
                                </div>


                            </div>
                            <div role="tabpanel" class="tab-pane" id="profile">...</div>
                            <div role="tabpanel" class="tab-pane" id="deals_tab">deals_tab</div>
                            <div role="tabpanel" class="tab-pane" id="messages">...</div>

                        </div>

                    </div>
                </div>
                <div class="col-md-5">
                    <div style="padding-left: 10px">
                        <div>
                            <i class="fa fa-pie-chart report_head_button report_head_button_padding tooltip-examples"></i><span class="font_black">Status Of Leads</span>
                        </div>
                        <div>
                            <div class="row">
                                <div class="col-md-6">
                                    <div id="container" class="containers" style="height: 300px; width: 100%;"></div>
                                    <div class="chart_text">
                                        In Process Leads: 35
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div id="current_leads" class="containers" style="height: 300px; width: 100%;"></div>
                                    <div class="chart_text">
                                        Current Leads: 1250
                                    </div>
                                </div>
                            </div>
                        </div>

                    </div>
                </div>
            </div>
        </div>
    </div>
    <script>
        var dataSource = [
            { region: "ShortSale", val: 41 },
            { region: "Eviction", val: 10 },
            { region: "Constact", val: 34 },
            { region: "T1", val: 59 },
           { region: "T2", val: 59 },
        ];
        var dataSource2 = [
            { region: "DoorKnock", val: 50 },
            { region: "Task", val: 60 },
            { region: "HotLeads", val: 70 },
            { region: "T1", val: 20 },
           { region: "T2", val: 20 },

        ];
        var option =
            {
                dataSource: dataSource,
                tooltip: {
                    enabled: true,

                    percentPrecision: 2,
                    customizeText: function () {
                        
                        return this.argumentText + " - " + this.percentText;
                    }
                },
                legend: { visible: false },
                series: [{
                    type: "doughnut",
                    argumentField: "region",
                    label: {
                        visible: true,

                        connector: {
                            visible: true
                        }
                    }
                }]
            }
        $("#container").dxPieChart(option);
        option.dataSource = dataSource2;
        $("#current_leads").dxPieChart(option);
    </script>
</asp:Content>

