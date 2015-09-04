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
         
        function StartRule(ruleId)
        {            
            var url = "/api/Management/RulesEngine/Start/" + ruleId;
            PostData(url);
        }

        function StopRule(ruleId) {
            var url = "/api/Management/RulesEngine/Stop/" + ruleId;
            PostData(url);           
        }

        function PostData(url)
        {
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
            </div>
            <div id="divGridRules">
                <div id="gridRules"></div>
            </div>
        </div>

        <script id="gridCellAction" type="text/html">
            <i class="fa fa-play icon_btn tooltip-examples grid_buttons" style="margin-left: 10px; title="Start Rule" onclick='StartRule("{%= value %}")'></i>
            <i class="fa fa-stop icon_btn tooltip-examples grid_buttons" style="margin-left: 10px; title="Stop Rule" onclick='StopRule("{%= value %}")'></i>
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
                            width:300
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
    </div>
</asp:Content>
