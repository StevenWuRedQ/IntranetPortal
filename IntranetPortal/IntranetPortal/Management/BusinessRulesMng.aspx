<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="BusinessRulesMng.aspx.vb" Inherits="IntranetPortal.BusinessRulesMng" MasterPageFile="~/Content.Master" %>

<asp:Content ContentPlaceHolderID="head" runat="server">
</asp:Content>


<asp:Content ContentPlaceHolderID="MainContentPH" runat="server">
    <script type="text/javascript">

        function expandAllClick(s, content) {
            if (content.is(':visible')) {
                content.hide();
                $(s).attr("class", 'fa fa-expand icon_btn tooltip-examples grid_buttons');
            }
            else {
                content.show();
                $(s).attr("class", 'fa fa-compress icon_btn tooltip-examples grid_buttons');
            }
        }

        function StartRule(ruleId) {
            var url = "/api/Management/RulesEngine/Start/" + ruleId;
            PostData(url);
        }

        function StopRule(ruleId) {
            var url = "/api/Management/RulesEngine/Stop/" + ruleId;
            PostData(url);
        }

        function RunRule(ruleId) {
            var url = "/api/Management/RulesEngine/Run/" + ruleId;
            PostData(url);
        }

        function PostData(url) {
            $.ajax({
                type: "POST",
                url: url,
                data: null,
                dataType: 'json',
                contentType: "application/json",
                success: function (data) {
                    RulesEngine.Refresh();
                },
                error: function (data) {
                    alert("Failed to start data." + data);
                }
            });
        }

    </script>

    <style type="text/css">
        .form_header {
            background-color: #efefef;
            line-height: 40px;
            padding-left: 15px;
            font-weight: 600;
        }

        a:hover {
            background-color: #045cad;
            font-weight: 600;
        }

        table tr td {
            padding-left: 5px;
        }

        /* Chrome, Safari, Opera */
        @-webkit-keyframes example {
            from {
                background-color: red;
            }

            to {
                background-color: yellow;
            }
        }

        /* Standard syntax */
        @keyframes example {
            from {
                background-color: red;
            }

            to {
                background-color: yellow;
            }
        }

        tr.new_row {
            animation-name: example;
            animation-duration: 4s;
             background-color: inherit;
            -webkit-animation-name: example; /* Chrome, Safari, Opera */
            -webkit-animation-duration: 4s; /* Chrome, Safari, Opera */
        }

        td.description {
            white-space: nowrap;
            overflow: hidden;
            width: 200px;
            cursor: pointer;
        }

        .form_border {
            border: 1px solid #808080;
            padding: 0px;
            margin-top: 10px;
        }
    </style>

    <div class="container">
        <h3 style="text-align: center; line-height: 50px">Business Rule Management</h3>

        <div class="row form_border">
            <div class="form_header">
                Business Rules &nbsp;<i class="fa fa-compress icon_btn tooltip-examples grid_buttons" style="font-size: 18px;" title="Collapse" onclick="expandAllClick(this, $('#divGridRules'))"></i>
                 <div class="form-inline" style="float: right; font-weight: normal">                    
                    <i class="fa fa-refresh icon_btn tooltip-examples  grid_buttons" style="margin-right: 20px; font-size: 19px" onclick="RulesEngine.Refresh()" title="Refresh"></i>
                </div>
            </div>
            <div id="divGridRules">
                <div id="gridRules"></div>
            </div>
        </div>

        <script id="gridCellAction" type="text/html">
            <i class="fa fa-play icon_btn tooltip-examples grid_buttons" style="margin-left: 10px;" title="Start Rule" onclick='StartRule("{%= value %}")'></i>
            <i class="fa fa-stop icon_btn tooltip-examples grid_buttons" style="margin-left: 10px;" title="Stop Rule" onclick='StopRule("{%= value %}")'></i>
            <i class="fa fa-refresh icon_btn tooltip-examples grid_buttons" style="margin-left: 10px;" title="Run Rule" onclick='RunRule("{%= value %}")'></i>
        </script>

        <script type="text/javascript">
            DevExpress.ui.setTemplateEngine("underscore");
            _.templateSettings = {
                interpolate: /\{%=(.+?)%\}/g,
                escape: /\{%-(.+?)%\}/g,
                evaluate: /\{%(.+?)%\}/g
            };

            var RulesEngine = {
                Result: null,
                DataGrid: null,
                LoadResult: function () {
                    var view = this;
                    var customStore = new DevExpress.data.CustomStore({
                        load: function (loadOptions) {
                            if (view.Result != null)
                                return view.Result

                            var d = $.Deferred();
                            $.getJSON("/api/management/rulesEngine").done(function (data) {
                                d.resolve(data, { totalCount: data.length });
                                view.Result = data;
                            });
                            return d.promise();
                        }
                    });
                    return customStore;
                },
                LoadGrid: function () {
                    var gridOptions = {
                        dataSource: this.LoadResult(),
                        showColumnLines: false,
                        showRowLines: true,
                        rowAlternationEnabled: true,
                        wordWrapEnabled: true,
                        columns: [{
                            dataField: "RuleName",
                            caption: "Name",
                            width: 300
                        }, "ExecuteOn", "Period",
                        {
                            dataField: "ExecuteNow",
                            caption: "Execute Now",

                        }, {
                            dataField: "StatusStr",
                            caption: "Status",
                            width: '80px',
                            dataType: "string"
                        }, {
                            dataField: 'RuleId',
                            caption: '',
                            allowFiltering: false,
                            allowSorting: false,
                            cellTemplate: $('#gridCellAction')
                        }]
                    }

                    this.DataGrid = $("#gridRules").dxDataGrid(gridOptions).dxDataGrid("instance");
                },
                Refresh: function () {
                    this.Result = null;
                    this.DataGrid.refresh();
                }
            }

            RulesEngine.LoadGrid();

        </script>

        <div class="row form_border">
            <div class="form_header">
                System Logs &nbsp;<i class="fa fa-compress icon_btn tooltip-examples grid_buttons" style="font-size: 18px;" title="Collapse" onclick="expandAllClick(this, $('#divLogs'))"></i>
                <div class="form-inline" style="float: right; font-weight: normal">
                    <span id="txtLastUpdateTime" style="font-size: 16px"></span>&nbsp;
                    <i class="fa fa-refresh icon_btn tooltip-examples  grid_buttons" style="margin-right: 20px; font-size: 19px" onclick="systemLogs.Refresh()" title="Refresh"></i>
                </div>
            </div>
            <div id="divLogs" style="height: 500px; overflow-y: scroll; font-size: 14px;">
                <table id="tblLogs" class="table">
                    <thead>
                        <tr>
                            <th>LogId</th>
                            <th>Title</th>
                            <th>Description</th>
                            <th>Category</th>
                            <th>BBLE</th>
                            <th>Date</th>
                            <th>Create By</th>
                        </tr>
                    </thead>
                    <tbody>
                    </tbody>
                </table>
            </div>
        </div>

        <div id="popup">
            <textarea id="txtDesciption" style="width: 100%; height: 100%">

            </textarea>
        </div>

        <script type="text/javascript">

            $("#popup").dxPopup({
                width: 500,
                height: 400,
                showTitle: true,
                title: 'Details',
                closeOnOutsideClick: true,
            });

            function ShowDetails(td) {
                $("#txtDesciption").val(td.title)
                $("#popup").dxPopup("instance").show();
            }

            var systemLogs = {
                UpdateTime: null,
                InUpdateing:false,
                Refresh: function () {
                    var url = "/api/Management/SystemLogs/";
                    var data = this.UpdateTime;
                    var sLogs = this;
                    $.ajax({
                        type: "POST",
                        url: url,
                        data: JSON.stringify(data),
                        dataType: 'json',
                        contentType: "application/json",
                        success: function (data) {
                            sLogs.RenderData(data);                            
                        },
                        error: function (data) {
                            alert("Failed to refresh data." + JSON.stringify(data));
                        }
                    });
                },
                RenderData: function (data) {
                    this.UpdateTime = data.UpdateTime;
                    var tmpDate = new Date(this.UpdateTime);
                    $("#txtLastUpdateTime").html("Last Update Time: " + tmpDate.getUTCHours() + ":" + tmpDate.getUTCMinutes() + ":" + tmpDate.getUTCSeconds());

                    $.each(data.Logs, function (index, value) {
                        var log = value;
                        var table = document.getElementById("tblLogs");
                        // Create an empty <tr> element and add it to the 1st position of the table:
                        var row = table.insertRow(1);
                        row.className = "new_row";
                        // Insert new cells (<td> elements) at the 1st and 2nd position of the "new" <tr> element:
                        var cell0 = row.insertCell(0);
                        cell0.innerHTML = log.LogId;

                        var cell1 = row.insertCell(1);
                        cell1.innerHTML = log.Title;

                        var cell2 = row.insertCell(2);
                        cell2.title = log.Description;
                        cell2.innerHTML = "View Details";
                        cell2.className = "description";
                        cell2.onclick = function () { ShowDetails(this); };

                        var cell3 = row.insertCell(3);
                        cell3.innerHTML = log.Category;

                        var cell = row.insertCell(4);
                        cell.innerHTML = log.BBLE;

                        var cell4 = row.insertCell(5);
                        cell4.innerHTML = log.CreateDate;

                        cell = row.insertCell(6);
                        cell.innerHTML = log.CreateBy;
                    });

                    this.InUpdateing = false;
                },
                Monitor: function () {
                    if (!this.InUpdateing)
                    {
                        this.InUpdateing = true;
                        this.Refresh();
                    }
                    
                    window.setTimeout(function () { systemLogs.Monitor(); }, 3000);
                },
            }


            $(function () {
                systemLogs.Monitor();
            });
        </script>

    </div>
</asp:Content>
