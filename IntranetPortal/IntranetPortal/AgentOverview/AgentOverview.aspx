<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="AgentOverview.aspx.vb" Inherits="IntranetPortal.AgentOverview" MasterPageFile="~/Content.Master" %>

<%@ Register Src="~/AgentOverview/AgentCharts.ascx" TagPrefix="uc1" TagName="AgentCharts" %>

<asp:Content ContentPlaceHolderID="head" runat="server">
    <script src="../scripts/jquery.printElement.js"></script>
    <style type="text/css">
        .InforPanel {
            float: left;
            width: 340px;
        }
    </style>
    <script type="text/javascript">

        var empId = null;

        function SearchNames(inputBox) {
            var key = inputBox.value;
            //alert(key);
            if (key == "")
                gridEmpsClient.ClearFilter();
            else {
                var filterCondition = "[Name] LIKE '%" + key + "%'";
                gridEmpsClient.ApplyFilter(filterCondition);
            }
        }

        var postponedCallbackRequired = false;
        //function is called on changing focused row
        function OnGridFocusedRowChanged() {
            if (gridEmpsClient.GetFocusedRowIndex() >= 0) {
                if (IsInCallback()) {
                    postponedCallbackRequired = true;
                }
                else {
                    DoCallback();
                }
            }
        }

        function OnEndCallback(s, e) {
            if (IsInCallback())
                return;

            if (postponedCallbackRequired) {
                DoCallback();
                postponedCallbackRequired = false;
            }

            //Show chart
            //if (empId != null)
            //    LoadEmployeeBarChart(empId);

            initScrollbars();
        }

        function onGetAgentLogButtonClick() {
            if (empId != null) {

                LoadAngentTodayReport(empId + ",1");
            } else {
                alert('EmpId is null');
            }
        }
        function onGetAgentZoningDateClick() {
            if (empId != null) {
                //alert(empId);
                AgentZoningData(empId)
            } else {
                alert('EmpId is null');
            }
        }

        function DoCallback() {
            var rowKey = gridEmpsClient.GetRowKey(gridEmpsClient.GetFocusedRowIndex());
            var rowIndex = gridEmpsClient.GetFocusedRowIndex();
            if (gridEmpsClient.IsGroupRow(rowIndex)) {
                gridEmpsClient.GetRowValues(rowIndex + 1, "Department", OnGetRowValues);
            }
            if (rowKey != null) {
                //ContentCallbackPanel.PerformCallback("EMP|" + rowKey);
                BindEmployee(rowKey);
            }
        }

        function IsInCallback() {
            return infoCallbackClient.InCallback() || gridReportClient.InCallback();
        }

        function BindEmployee(employeeId) {
            currentOffice = null;
            empId = employeeId;
            infoCallbackClient.SetVisible(true);
            infoCallbackClient.PerformCallback("EMP|" + empId);
            gridReportClient.PerformCallback("BindEmp|" + employeeId);
            LoadEmployeeBarChart(empId);
        }

        function getEmplyeeIDComplete(s, e) {
            BindEmployee(parseInt(e.result));
        }

        var currentOffice = null;
        function BindOffice(office) {
            currentOffice = office;
            gridReportClient.PerformCallback("BindOffice|" + office);
            infoCallbackClient.SetVisible(true);
            infoCallbackClient.PerformCallback("OFFICE|" + office);
            LoadOfficeBarChart(office);
        }

        function OnGetRowValues(Value) {
            BindOffice(Value);
            //gridReportClient.PerformCallback("BindOffice|" + Value);
            //LoadOfficeBarChart(Value);
        }

        function Savelayout(reportName) {
            callbackPnlTemplatesClient.PerformCallback("AddReport|" + reportName);
        }
        function LoadLayout(reportName) {
            gridReportClient.PerformCallback("LoadLayout|" + reportName);
        }
        function RemoveReport(reportName) {
            callbackPnlTemplatesClient.PerformCallback("RemoveReport|" + reportName);
        }

        function ShowLeadstatus(status) {
            infoCallbackClient.SetVisible(false);

            if (currentOffice != null) {               
                gridReportClient.PerformCallback("OfficeStatus|" + currentOffice + "|" + status);
                //ContentCallbackPanel.PerformCallback("Status|" + status)
                //LoadStatusBarChartByOffice(status, currentOffice);
            }
            else {
            gridReportClient.PerformCallback("BindStatus|" + status);
            //ContentCallbackPanel.PerformCallback("Status|" + status)
            LoadStatusBarChart(status);
        }
        }

        function CustomizRefershEnd() {
            initScrollbars();
        }

        function ExpandOrCollapseGroupRow(s, grid, rowIndex) {
            //alert("dd");
            if (grid.IsGroupRow(rowIndex)) {
                if (grid.IsGroupRowExpanded(rowIndex)) {
                    grid.CollapseRow(rowIndex);
                    //s.setAttribute("class", "fa fa-caret-right font_16");
                } else {

                    grid.ExpandRow(rowIndex);
                    // s.setAttribute("class", "fa fa-caret-down font_16");
                }

                return
            }
        }
        function contentSplitterClinet_resize(s, e)
        {
            
            $('#showPanesize').html('size = ' + contentSplitterClinet.GetWidth() - 430);
            $('#chars_with_scorll').width(contentSplitterClinet.GetWidth() - 430);
        }
        function CompareEmp(emps) {
            //alert(emps);
        }

        $(document).ready(function () {

            if ($(".tooltip-examples").tooltip) {
                $(".tooltip-examples").tooltip({
                    placement: 'bottom'
                });
            } else {
                alert('tooltip function can not found' + $(".tooltip-examples").tooltip);
            }

        });
        function expandAllClick(s) {
            if (gridEmpsClient.IsGroupRowExpanded(0)) {
                gridEmpsClient.CollapseAll();
                $(s).attr("class", 'fa fa-compress icon_btn tooltip-examples');
            }
            else {
                gridEmpsClient.ExpandAll();
                $(s).attr("class", 'fa fa-expand icon_btn tooltip-examples');
            }
        }
    </script>

</asp:Content>

<asp:Content ContentPlaceHolderID="MainContentPH" runat="server">



    <dx:ASPxSplitter ID="ASPxSplitter1" runat="server" Height="100%" Width="100%" ClientInstanceName="splitter" FullscreenMode="true">
        <Styles>
            <Pane Paddings-Padding="0">
                <Paddings Padding="0px"></Paddings>
            </Pane>
            <Separator BackColor=" #e7e9ee"></Separator>
        </Styles>
        <Panes>
            <dx:SplitterPane Size="310px" MinSize="180px" ShowCollapseBackwardButton="True">
                <ContentCollection>
                    <dx:SplitterContentControl runat="server">
                        <%--top block--%>
                        <div style="height: 459px; border-bottom: 1px solid #dde0e7">
                            <div style="margin: 30px 20px 30px 30px">
                                <div style="font-size: 24px;">
                                    <i class="fa fa-group with_circle" style="width: 48px; height: 48px; line-height: 48px;"></i>&nbsp;&nbsp;<span style="color: #234b60; font-size: 30px;">Employees</span>&nbsp;&nbsp;&nbsp;&nbsp;
                                    <i class="fa fa-sort-amount-desc" style="display: none"></i><i class="fa fa-expand icon_btn tooltip-examples" title="Expand or Collapse All" onclick="expandAllClick(this)" id="divExpand"></i>
                                </div>
                                <input type="text" data-var="@btn-info-color" class="form-control" style="width: 250px; margin-top: 25px; height: 30px; color: #b1b2b7" placeholder="Type employee’s name" onchange="SearchNames(this)" />
                                <div style="margin-top: 27px; height: 290px; overflow: auto" id="employees_grid">
                                    <dx:ASPxGridView runat="server" Width="100%" ID="gridEmps" KeyFieldName="EmployeeID" Settings-ShowColumnHeaders="false" Settings-GridLines="None" Border-BorderStyle="None" ClientInstanceName="gridEmpsClient" CssClass="font_source_sans_pro">
                                        <Columns>
                                            <dx:GridViewDataTextColumn FieldName="Name" Settings-AllowHeaderFilter="False" VisibleIndex="1">
                                                <Settings AllowHeaderFilter="False"></Settings>
                                                <DataItemTemplate>
                                                    <div class="employee_list_item clearfix">
                                                        <div class="employee_list_item_div">
                                                            <span class="font_black"><%# Eval("Name")%></span><br />
                                                            <%# Eval("Position")%>
                                                        </div>
                                                        <i class="fa fa-list-alt employee_list_item_icon"></i>
                                                    </div>
                                                </DataItemTemplate>
                                            </dx:GridViewDataTextColumn>
                                            <dx:GridViewDataColumn FieldName="Department" VisibleIndex="5">
                                                <GroupRowTemplate>
                                                    <%-- <div>
                                                        <span class="font_black"><%# Container.GroupText%></td></span>&nbsp;&nbsp;&nbsp;
                                                        
                                                    </div>--%>
                                                    <div>
                                                        <table style="height: 30px">
                                                            <tr>
                                                                <td style="width: 80px;"><span class="font_black"><i class="fa fa-caret-<%#If(Container.Expanded,"down","right") %> font_16" onclick="ExpandOrCollapseGroupRow(this, gridEmpsClient, <%# Container.VisibleIndex%>)" style="cursor: pointer"></i>&nbsp; <i class="fa fa-bank font_16"></i>&nbsp; <%# Container.GroupText%>
                                                                </span></td>
                                                                <td style="padding-left: 10px">
                                                                    <span class="employee_lest_head_number_label"><%#  Container.SummaryText.Replace("Count=", "").Replace("(","").Replace(")","") %></span>

                                                                </td>
                                                            </tr>
                                                        </table>
                                                    </div>
                                                </GroupRowTemplate>
                                            </dx:GridViewDataColumn>
                                            <%--why use tr td?--%>
                                            <%-- <dx:GridViewDataColumn FieldName="Position" Visible="false"></dx:GridViewDataColumn>
                                                <dx:GridViewDataColumn Width="25px" VisibleIndex="5">
                                                    <DataItemTemplate>
                                                        <i class="fa fa-list-alt employee_list_item_icon"></i>
                                                    </DataItemTemplate>
                                                </dx:GridViewDataColumn>--%>
                                        </Columns>
                                        <Styles>
                                            <SelectedRow BackColor="#FF400D"></SelectedRow>
                                            <Cell>
                                                <Paddings Padding="0px"></Paddings>
                                            </Cell>
                                        </Styles>
                                        <GroupSummary>
                                            <dx:ASPxSummaryItem SummaryType="Count" />
                                        </GroupSummary>
                                        <SettingsBehavior EnableRowHotTrack="True" ColumnResizeMode="NextColumn" AutoExpandAllGroups="true" AllowFocusedRow="true" AllowClientEventsOnLoad="false" />
                                        <SettingsPager Mode="ShowAllRecords">
                                        </SettingsPager>
                                        <ClientSideEvents FocusedRowChanged="OnGridFocusedRowChanged" />
                                        <Settings ShowColumnHeaders="False" GridLines="None"></Settings>
                                        <Border BorderStyle="None"></Border>
                                    </dx:ASPxGridView>
                                </div>
                                <div style="margin-top: 27px; height: 290px; display: none /*background: blue*/">
                                    <div>
                                        <span class="font_black">A</span>&nbsp;&nbsp;&nbsp;<span class="employee_lest_head_number_label">2</span>
                                    </div>
                                    <ul style="margin-left: -35px; margin-top: 10px;">
                                        <li class="employee_list_item">
                                            <div class="employee_list_item_div">
                                                <span class="font_black">Alko Kone</span><br />
                                                Eviction
                                            </div>
                                        </li>
                                        <li class="employee_list_item">
                                            <div class="employee_list_item_div">
                                                <span class="font_black">Allen Glover</span><br />
                                                Sales
                                            </div>
                                            <i class="fa fa-list-alt employee_list_item_icon"></i>
                                        </li>
                                    </ul>

                                    <div class="employee_list_group_margin">
                                        <span class="font_black">B</span>&nbsp;&nbsp;&nbsp;<span class="employee_lest_head_number_label">4</span>
                                    </div>
                                    <ul style="margin-left: -35px; margin-top: 10px;">
                                        <li class="employee_list_item">
                                            <div class="employee_list_item_div">
                                                <span class="font_black">Benn Martin</span><br />
                                                Sales
                                            </div>
                                            <i class="fa fa-list-alt employee_list_item_icon"></i>
                                        </li>
                                        <li class="employee_list_item">
                                            <div class="employee_list_item_div">
                                                <span class="font_black">Ben Gendin</span><br />
                                                Departemnt
                                            </div>
                                            <i class="fa fa-list-alt employee_list_item_icon"></i>
                                        </li>

                                        <li class="employee_list_item">
                                            <div class="employee_list_item_div">
                                                <span class="font_black">Bibi Khan</span><br />
                                                Short Sale
                                            </div>
                                            <i class="fa fa-list-alt employee_list_item_icon"></i>
                                        </li>
                                    </ul>
                                </div>
                            </div>
                        </div>
                        <%----end top block----%>

                        <%--bottom block--%>
                        <div>
                            <div style="margin: 22px 0px 0px 0px; font-size: 24px;">
                                <div style="padding: 0px 20px;">
                                    <div style="font-size: 24px;" class="clearfix">
                                        <i class="fa fa-suitcase with_circle" style="width: 48px; height: 48px; line-height: 48px;"></i>&nbsp;&nbsp;<span style="color: #234b60; font-size: 30px;">Lead Status</span>
                                        <i class="fa fa-sort-amount-desc icon_right_s" style="display: none"></i>
                                    </div>
                                </div>

                            </div>

                            <%--menu list--%>
                            <div style="margin: 13px 30px 30px 30px">
                                <div class="agent_menu_list_item" onclick="ShowLeadstatus(0)">New Leads</div>
                                <div class="agent_menu_list_item" onclick="ShowLeadstatus(1)">Hot Leads</div>
                                <div class="agent_menu_list_item" onclick="ShowLeadstatus(3)">Follow Up</div>
                                <div class="agent_menu_list_item" onclick="ShowLeadstatus(5)">In Negotiation</div>
                                <div class="agent_menu_list_item" onclick="ShowLeadstatus(4)">Dead Lead </div>
                                <div class="agent_menu_list_item" onclick="ShowLeadstatus(7)">Closed</div>
                            </div>

                            <%-----end-----%>
                        </div>
                        <%----end bottom block--%>
                    </dx:SplitterContentControl>
                </ContentCollection>
            </dx:SplitterPane>
            <dx:SplitterPane>
                <ContentCollection>
                    <dx:SplitterContentControl>
                        <dx:ASPxSplitter runat="server" ID="contentSplitter" Orientation="Vertical" Width="100%" Height="100%" ClientInstanceName="contentSplitterClinet">
                            <Styles>
                                <Pane Paddings-Padding="0">
                                    <Paddings Padding="0px"></Paddings>
                                </Pane>
                                <Separator BackColor=" #e7e9ee"></Separator>
                            </Styles>
                            <Panes>
                                <dx:SplitterPane ShowCollapseBackwardButton="True" Size="480">
                                    <ContentCollection>
                                        <dx:SplitterContentControl runat="server">
                                            <div style="width: 100%" class="agent_layout_float clear-fix">
                                                <table style="width: 100%; vertical-align: top">
                                                    <tr>
                                                        <td style="vertical-align: top">
                                                            <dx:ASPxCallbackPanel runat="server" ID="infoCallback" ClientInstanceName="infoCallbackClient" OnCallback="infoCallback_Callback" CssClass="InforPanel">
                                                                <PanelCollection>
                                                                    <dx:PanelContent>

                                                                        <div style="height: 480px; float: left; border-right: 1px solid #dde0e7;">
                                                                            <%--angent info--%>

                                                                            <div style="width: 370px; background: url('../images/profile_bg.png')">
                                                                                <%--width:201 height:201--%>
                                                                                <asp:Panel runat="server" ID="AgentInfoPanel" Visible="true">
                                                                                    <dx:ASPxImage runat="server" ID="profile_image" CssClass="img-circle class_profile_image" ImageUrl="/images/user-empty-icon.png">
                                                                                    </dx:ASPxImage>
                                                                                    <div style="margin-top: 28px; font-size: 30px; color: #234b60; line-height: 16px" class="agnet_info_text"><%= CurrentEmployee.Name %></div>
                                                                                    <div style="margin-top: 8px; font-size: 16px; color: #234b60; font-weight: 900" class="agnet_info_text"><%= CurrentEmployee.Position %></div>
                                                                                    <%--info detial--%>
                                                                                    <div style="font-size: 14px; margin-top: 25px">
                                                                                        <%--items--%>
                                                                                        <div class="agent_info_detial_left">Manger</div>
                                                                                        <div class="agent_info_detial_space">&nbsp;</div>
                                                                                        <div class="agent_info_detial_right"><%= CurrentEmployee.Manager%>&nbsp;</div>
                                                                                        <%----end item--%>
                                                                                        <%--items--%>
                                                                                        <div class="agent_info_detial_left">Office</div>
                                                                                        <div class="agent_info_detial_space">&nbsp;</div>
                                                                                        <div class="agent_info_detial_right"><%= CurrentEmployee.Position %>(<%= CurrentEmployee.Department%>)&nbsp; </div>
                                                                                        <%----end item--%>
                                                                                        <%--items--%>
                                                                                        <div class="agent_info_detial_left">Employee Since</div>
                                                                                        <div class="agent_info_detial_space">&nbsp;</div>
                                                                                        <div class="agent_info_detial_right"><%=String.Format("{0:d}", CurrentEmployee.EmployeeSince) %>&nbsp;</div>
                                                                                        <%----end item--%>
                                                                                        <%--items--%>
                                                                                        <div class="agent_info_detial_left">Cell</div>
                                                                                        <div class="agent_info_detial_space">&nbsp;</div>
                                                                                        <div class="agent_info_detial_right"><%= String.Format("{0:(###) ###-####}", CurrentEmployee.Cellphone) %>&nbsp;</div>
                                                                                        <%----end item--%>
                                                                                        <%--items--%>
                                                                                        <div class="agent_info_detial_left">Email</div>
                                                                                        <div class="agent_info_detial_space">&nbsp;</div>
                                                                                        <div class="agent_info_detial_right" style="color: #3993c1"><%= CurrentEmployee.Email%>&nbsp;</div>
                                                                                        <%----end item--%>
                                                                                        <%--items--%>

                                                                                        <%----end item--%>
                                                                                        <div style="margin-left: 69px; margin-top: 10px;">
                                                                                            <button class="btn btn-default button_transparent" type="button" id="id_activity_log" onclick="onGetAgentLogButtonClick()">Activity Log</button>

                                                                                            <button class="btn btn-default button_transparent" type="button" onclick="onGetAgentZoningDateClick()" style="margin-left: 20px">Leads's Tax</button>
                                                                                        </div>
                                                                                    </div>
                                                                                </asp:Panel>

                                                                                <asp:Panel runat="server" ID="OfficeInfoPanel" Visible="false">
                                                                                    <dx:ASPxImage runat="server" ID="ASPxImage1" CssClass="img-circle class_profile_image" ImageUrl="/images/user-empty-icon.png">
                                                                                    </dx:ASPxImage>
                                                                                    <div style="margin-top: 28px; font-size: 30px; color: #234b60; line-height: 16px" class="agnet_info_text"><%= CurrentOffice.OfficeDescription %></div>
                                                                                    <div style="margin-top: 8px; font-size: 16px; color: #234b60; font-weight: 900" class="agnet_info_text"><%=  CurrentOffice.OfficeManagers  %></div>
                                                                                    <%--info detial--%>
                                                                                    <div style="font-size: 14px; margin-top: 25px;">
                                                                                        <%--items--%>
                                                                                        <div class="agent_info_detial_left">Address</div>
                                                                                        <div class="agent_info_detial_space">&nbsp;</div>
                                                                                        <div class="agent_info_detial_right"><%= CurrentOffice.Address %>&nbsp;</div>
                                                                                        <%----end item--%>
                                                                                        <%--items--%>
                                                                                        <div class="agent_info_detial_left">Phone</div>
                                                                                        <div class="agent_info_detial_space">&nbsp;</div>
                                                                                        <div class="agent_info_detial_right"><%= CurrentOffice.PhoneNo %>&nbsp; </div>
                                                                                        <%----end item--%>
                                                                                        <%--items--%>
                                                                                        <div class="agent_info_detial_left">Fax</div>
                                                                                        <div class="agent_info_detial_space">&nbsp;</div>
                                                                                        <div class="agent_info_detial_right"><%= CurrentOffice.FaxNo %>&nbsp;</div>
                                                                                        <%----end item--%>
                                                                                    </div>
                                                                                </asp:Panel>
                                                                                <%-----end info detial-----%>
                                                                                <%-----end info detial-----%>
                                                                            </div>
                                                                            <asp:HiddenField runat="server" ID="hfEmpName" />
                                                                            <asp:HiddenField runat="server" ID="hfMode" />
                                                                            <dx:ASPxHiddenField runat="server" ID="hfReports"></dx:ASPxHiddenField>
                                                                        </div>
                                                                    </dx:PanelContent>
                                                                </PanelCollection>
                                                                <ClientSideEvents EndCallback="OnEndCallback" />
                                                            </dx:ASPxCallbackPanel>
                                                            <%--center top--%></td>
                                                        <td style="vertical-align: top">
                                                            <%--chart UI--%>
                                                            <div style="height: 490px; float: left; width: 100%" class="clearfix">
                                                                <div style="padding-top: 10px; height: 325px;" class="clearfix">
                                                                    <div class="layout_float_right clearfix">
                                                                        <div class="layout_float_right" style="margin-left: 20px; margin-right: 20px">

                                                                            <button class="btn btn-default button_transparent" type="button" onclick="$('#container').printElement();">Print Chart</button>
                                                                        </div>

                                                                        <div class="dropdown layout_float_right">
                                                                            <button class="btn btn-default dropdown-toggle" type="button" id="id_detail_x_axis" data-toggle="dropdown" style="background: transparent">
                                                                                Choice Field<span class="caret"></span>

                                                                            </button>
                                                                            <ul class="dropdown-menu" role="menu" aria-labelledby="chart_line_select">
                                                                                <li role="presentation"><a role="menuitem" tabindex="-1" href="#" onclick="change_chart_x_axis(this)">Status</a></li>
                                                                                <li role="presentation"><a role="menuitem" tabindex="-1" href="#" onclick="change_chart_x_axis(this)">ZipCode</a></li>
                                                                                <li role="presentation"><a role="menuitem" tabindex="-1" href="#" onclick="change_chart_x_axis(this)">Zoning</a></li>

                                                                            </ul>
                                                                        </div>
                                                                        <div class="dropdown layout_float_right" style="display: none">
                                                                            <button class="btn btn-default dropdown-toggle" type="button" id="chart_line_select" data-toggle="dropdown" style="background: transparent">
                                                                                Line & Point Chart <span class="caret"></span>
                                                                            </button>
                                                                            <ul class="dropdown-menu" role="menu" aria-labelledby="chart_line_select">
                                                                                <li role="presentation"><a role="menuitem" tabindex="-1" href="#" onclick="change_chart_type(this)">Line</a></li>
                                                                                <li role="presentation"><a role="menuitem" tabindex="-1" href="#" onclick="change_chart_type(this)">Bar</a></li>
                                                                                <li role="presentation"><a role="menuitem" tabindex="-1" href="#" onclick="change_chart_type(this)">Pie</a></li>

                                                                            </ul>
                                                                        </div>

                                                                        <div class="dropdown layout_float_right" style="margin-right: 20px;" id="id_change_range_drop_down">
                                                                            <button class="btn btn-default dropdown-toggle" type="button" id="dropdownMenu1" data-toggle="dropdown" style="background: transparent">
                                                                                Change Stat Range <span class="caret"></span>
                                                                            </button>
                                                                            <ul class="dropdown-menu" role="menu" aria-labelledby="dropdownMenu1">
                                                                                <li role="presentation"><a role="menuitem" tabindex="-1" href="#" onclick="change_chart_time(1)">Log today</a></li>
                                                                                <li role="presentation"><a role="menuitem" tabindex="-1" href="#" onclick="change_chart_time(3)">Logs 3 days</a></li>
                                                                                <li role="presentation"><a role="menuitem" tabindex="-1" href="#" onclick="change_chart_time(7)">Logs 1 week</a></li>
                                                                                <li role="presentation"><a role="menuitem" tabindex="-1" href="#" onclick="change_chart_time(30)">Logs 1 month</a></li>
                                                                            </ul>
                                                                        </div>


                                                                    </div>
                                                                    <div style="margin-left: 50px; margin-right: 50px; margin-bottom: 30px; /*background: blue; */ color: white; height: 100%;">
                                                                        <uc1:AgentCharts runat="server" ID="AgentCharts" />
                                                                    </div>

                                                                </div>
                                                            </div>
                                                            <%-----end chart ui-----%>

                                                        </td>
                                                    </tr>
                                                </table>

                                                <dx:ASPxPopupControl ID="ASPxPopupControl2" runat="server" HeaderText="Select Photo" ClientInstanceName="selectImgs" Modal="true" Width="500px" PopupVerticalAlign="WindowCenter" PopupHorizontalAlign="WindowCenter">
                                                    <ContentCollection>
                                                        <dx:PopupControlContentControl ID="Popupcontrolcontentcontrol2" runat="server">
                                                        </dx:PopupControlContentControl>
                                                    </ContentCollection>
                                                </dx:ASPxPopupControl>

                                                <dx:ASPxPopupControl ID="ASPxPopupControl1" runat="server" HeaderText="Save Report" ClientInstanceName="SaveReportPopup" Modal="true" Width="500px" PopupVerticalAlign="WindowCenter" PopupHorizontalAlign="WindowCenter">
                                                    <HeaderTemplate>
                                                        <div class="pop_up_header_margin">
                                                            <i class="fa fa-save with_circle pop_up_header_icon"></i>
                                                            <span class="pop_up_header_text">Save Report</span>
                                                        </div>
                                                    </HeaderTemplate>
                                                    <ContentCollection>
                                                        <dx:PopupControlContentControl ID="Popupcontrolcontentcontrol1" runat="server">
                                                            <dx:ASPxTextBox runat="server" ID="txtReportName" ClientInstanceName="txtClientReportName"></dx:ASPxTextBox>
                                                            <div style="margin-top: 20px">
                                                                <dx:ASPxButton runat="server" ID="btnSave" AutoPostBack="false" Text="Save" CssClass="rand-button rand-button-blue">
                                                                    <ClientSideEvents Click="function(s, e){
                                                                SaveReportPopup.Hide();
                                                                Savelayout(txtClientReportName.GetText());
                                                                }" />
                                                                </dx:ASPxButton>
                                                            </div>

                                                        </dx:PopupControlContentControl>
                                                    </ContentCollection>
                                                </dx:ASPxPopupControl>

                                            </div>
                                        </dx:SplitterContentControl>
                                    </ContentCollection>
                                </dx:SplitterPane>
                                <dx:SplitterPane>
                                    <ContentCollection>
                                        <dx:SplitterContentControl runat="server">
                                            <%--report UI--%>
                                            <div style="margin-top: 10px;">
                                                <%--tool head--%>
                                                <div style="margin-left: 40px; margin-right: 40px;">
                                                    <%--head--%>
                                                    <div style="font-size: 30px" class="clearfix">
                                                        <span style="color: #234b60; font-weight: 900">Customized Report&nbsp;&nbsp;&nbsp;</span>
                                                        <i class="fa fa-question-circle tooltip-examples" style="color: #999ca1" title="Check items from the pane on the right side to view the customized report."></i>
                                                        <div style="float: right; padding-right: 40px; font-size: 18px;">

                                                            <i class="fa fa-save report_head_button report_head_button_padding tooltip-examples" onclick="SaveReportPopup.Show()" title="Save Report" style="cursor: pointer"></i>
                                                            <i class="fa fa-exchange report_head_button tooltip-examples report_head_button_padding" title="Compare" onclick="cbPnlCompareClient.PerformCallback('CompareEmp');popupControlCompareList.Show();"></i>
                                                            <asp:LinkButton ID="btnExport" runat="server" OnClick="Unnamed_ServerClick" Text='<i class="fa fa-print  report_head_button report_head_button_padding tooltip-examples" title="Save PDF"></i>'>                                                                
                                                            </asp:LinkButton>
                                                            <%--        <i class="fa fa-envelope  report_head_button report_head_button_padding"></i>
                                                            <i class="fa fa-file-pdf-o  report_head_button"></i>--%>
                                                        </div>
                                                    </div>

                                                    <%--grid view--%>
                                                    <script type="text/javascript">
                                                        function ShowSearchLeadsInfo(bble) {
                                                            var url = '/ViewLeadsInfo.aspx?id=' + bble;
                                                            window.open(url, 'View Leads Info', 'Width=1350px,Height=930px');
                                                        }
                                                    </script>
                                                    <%--<div style="overflow-x:scroll;overflow-y:scroll;max-height:900px;">--%>
                                                    <dx:ASPxGridView ID="gridReport" runat="server" KeyFieldName="BBLE" Width="100%" AutoGenerateColumns="false" ClientInstanceName="gridReportClient" OnCustomCallback="gridReport_CustomCallback" Settings-ShowGroupPanel="false" OnInit="gridReport_Init" CssClass="font_source_sans_pro" Settings-VerticalScrollBarMode="Auto">
                                                        <%--Settings-HorizontalScrollBarMode="Auto"--%>
                                                        <Settings ShowFilterBar="Visible" ShowHeaderFilterButton="true" ShowGroupPanel="true" />
                                                        <Columns>
                                                            <dx:GridViewDataColumn FieldName="PropertyAddress">
                                                                <CellStyle Font-Bold="True"></CellStyle>
                                                                <DataItemTemplate>
                                                                     <a href="#" onclick='<%# String.Format("ShowSearchLeadsInfo(""{0}"")", Eval("BBLE"))%>' runat="server">
                                                                        <div style="color: rgb(119, 120, 123);"><%# Eval("LeadsName")%></div>
                                                                            </a>
                                                                </DataItemTemplate>
                                                            </dx:GridViewDataColumn>
                                                        </Columns>
                                                        <%-- Mode="ShowAllRecords" ShowAllItem="True"--%>
                                                        <SettingsPager PageSize="10" PageSizeItemSettings-Visible="true" PageSizeItemSettings-ShowAllItem="true">
                                                            <PageSizeItemSettings Visible="True"></PageSizeItemSettings>
                                                        </SettingsPager>
                                                        <Settings VerticalScrollableHeight="290" />
                                                        <GroupSummary>
                                                            <dx:ASPxSummaryItem FieldName="BBLE" SummaryType="Count" />
                                                        </GroupSummary>
                                                        <Styles>
                                                            <Cell>
                                                                <BorderLeft BorderWidth="0px"></BorderLeft>
                                                                <BorderRight BorderWidth="0px"></BorderRight>
                                                            </Cell>
                                                        </Styles>
                                                        <ClientSideEvents EndCallback="CustomizRefershEnd" />
                                                    </dx:ASPxGridView>
                                                    <dx:ASPxGridViewExporter ID="gridExport" runat="server" GridViewID="gridReport"></dx:ASPxGridViewExporter>
                                                    <%--</div>--%>
                                                </div>

                                            </div>
                                        </dx:SplitterContentControl>
                                    </ContentCollection>                                    
                                </dx:SplitterPane>
                            </Panes>
                          
                        </dx:ASPxSplitter>

                    </dx:SplitterContentControl>
                </ContentCollection>
            </dx:SplitterPane>
            <dx:SplitterPane Size="310px" ShowCollapseForwardButton="True" CollapsedStyle-CssClass="clearfix" Name="RightPane" Collapsed="true">
                <CollapsedStyle CssClass="clearfix"></CollapsedStyle>
                <ContentCollection>
                    <dx:SplitterContentControl>
                        <div style="width: 310px; background: #f5f5f5" class="agent_layout_float">
                            <div style="margin-left: 30px; margin-top: 30px; margin-right: 20px; font-size: 24px; float: none;">
                                <div style="height: 460px" class="border_under_line">
                                    <div style="padding-bottom: 20px;" class="border_under_line">
                                        <span style="color: #234b60">Saved Reports</span>
                                        <i class="fa fa-question-circle tooltip-examples" title="Select item view the customized report." style="color: #999ca1; float: right; margin-top: 3px"></i>

                                    </div>

                                    <dx:ASPxCallbackPanel runat="server" ID="callbackPnlTemplates" ClientInstanceName="callbackPnlTemplatesClient" OnCallback="callbackPnlTemplates_Callback">
                                        <PanelCollection>
                                            <dx:PanelContent>
                                                <% If Not GetTemplates() Is Nothing Then%>
                                                <ul class="list-group" style="font-size: 14px; box-shadow: none">

                                                    <% For Each key In GetTemplates().Keys%>
                                                    <li class="list-group-item color_gray save_report_list" style="background-color: transparent; border: 0px;">
                                                        <i class="fa fa-file-o" style="font-size: 18px"></i>
                                                        <span class="drappable_field_text" onclick='LoadLayout(this.innerHTML)' style="cursor: pointer; width: 178px;"><% = key%></span>
                                                        <i class="fa fa-times icon_btn tooltip-examples" title="Delete" onclick='RemoveReport("<%= key %>")'></i>
                                                        <%--<button type="button" value="delete" onclick='RemoveReport("<%= key %>")'>Delete</button>--%>
                                                    </li>
                                                    <% Next%>
                                                </ul>
                                                <% Else%>
                                                    No template saved.
                                                    <% End If%>
                                            </dx:PanelContent>
                                        </PanelCollection>
                                    </dx:ASPxCallbackPanel>

                                </div>
                                <div style="height: 450px;">

                                    <div style="padding-top: 19px; padding-bottom: 14px;" class="border_under_line">
                                        <span style="color: #234b60">Custom Fields</span>
                                        <i class="fa fa-question-circle tooltip-examples" title="Check items view the customized report." style="color: #999ca1; float: right; margin-top: 3px"></i>
                                    </div>

                                    <div style="margin-top: 20px; overflow: auto; height: 346px;" id="custom_fields_div">

                                        <script type="text/javascript">
                                            function Fields_ValueChanged(s, e) {
                                                var values = filed_CheckBoxList1.GetSelectedValues() + ',' + filed_CheckBoxList2.GetSelectedValues();

                                                gridReportClient.PerformCallback("FieldChange|" + values);
                                                e.processOnServer = false;
                                            }
                                        </script>
                                        <div>
                                            <div class="color_gray upcase_text" style="font-size: 12px; padding-bottom: 10px;">Category 1</div>
                                            <dx:ASPxCheckBoxList ID="chkFields" runat="server" ValueType="System.String" Width="100%" ClientInstanceName="filed_CheckBoxList1">
                                                <Items>

                                                    <dx:ListEditItem Text="Property Address" Value="PropertyAddress" Selected="true" />
                                                    <dx:ListEditItem Text="Call Attemps" Value="CallAttemps" />
                                                    <dx:ListEditItem Text="Doorknock Attemps" Value="DoorKnockAttemps" />
                                                    <dx:ListEditItem Text="Follow Up Attemps" Value="FollowupAttemps" />
                                                    <dx:ListEditItem Text="Create Date" Value="CreateDate" />
                                                </Items>

                                                <%--<CheckBoxStyle  BackgroundImage-ImageUrl="../images/icon_checked_box.png"/>--%>
                                                <%--<CheckedImage Url="../images/icon_checked_box.png"></CheckedImage>--%>
                                                <ClientSideEvents SelectedIndexChanged="Fields_ValueChanged" />
                                            </dx:ASPxCheckBoxList>
                                        </div>
                                        <div>
                                            <div class="color_gray upcase_text" style="font-size: 12px; padding-bottom: 10px; padding-top: 20px">Category 2</div>
                                            <dx:ASPxCheckBoxList ID="chkFields2" runat="server" ValueType="System.String" Width="100%" ClientInstanceName="filed_CheckBoxList2">
                                                <Items>
                                                    <dx:ListEditItem Text="BBLE" Value="BBLE" Selected="true" />
                                                    <dx:ListEditItem Text="Status" Value="Status" />
                                                    <dx:ListEditItem Text="Neighborhood" Value="NeighName" />
                                                    <dx:ListEditItem Text="Borough" Value="Borough" />
                                                    <dx:ListEditItem Text="Sale Date" Value="SaleDate" />
                                                    <dx:ListEditItem Text="Tax Class" Value="TaxClass" />
                                                    <dx:ListEditItem Text="Propety Class" Value="PropertyClassCode" />
                                                    <dx:ListEditItem Text="Block" Value="Block" />
                                                    <dx:ListEditItem Text="Lot" Value="Lot" />
                                                    <dx:ListEditItem Text="Year Build" Value="YearBuilt" />
                                                    <dx:ListEditItem Text="# of floor" Value="NumFloors" />
                                                    <dx:ListEditItem Text="Building Dem" Value="BuildingDem" />
                                                    <dx:ListEditItem Text="Lot Dem" Value="LotDem" />
                                                    <dx:ListEditItem Text="1st Mortgage" Value="C1stMotgrAmt" />
                                                    <dx:ListEditItem Text="2nd Mortgage" Value="C2ndMotgrAmt" />
                                                    <dx:ListEditItem Text="Taxes" Value="TaxesAmt" />
                                                    <dx:ListEditItem Text="Water" Value="WaterAmt" />
                                                    <dx:ListEditItem Text="Taxes" Value="TaxesAmt" />
                                                    <dx:ListEditItem Text="ECB/DOB" Value="ViolationAmount" />
                                                    <dx:ListEditItem Text="Est Value" Value="EstValue" />
                                                    <dx:ListEditItem Text="Zoning" Value="Zoning" />
                                                    <dx:ListEditItem Text="MaxFar" Value="MaxFar" />
                                                    <dx:ListEditItem Text="Actual Far" Value="ActualFar" />
                                                    <dx:ListEditItem Text="NYCSqft" Value="NYCSqft" />
                                                    <dx:ListEditItem Text="Unbuilt Sqft" Value="UnbuiltSqft" />
                                                    <dx:ListEditItem Text="Home Owner" Value="Owner" />
                                                    <dx:ListEditItem Text="Co-Owner" Value="CoOwner" />
                                                    <dx:ListEditItem Text="Good Phones" Value="OwnerPhoneNo" />
                                                </Items>
                                                <%--<CheckBoxStyle  BackgroundImage-ImageUrl="../images/icon_checked_box.png"/>--%>
                                                <%--<CheckedImage Url="../images/icon_checked_box.png"></CheckedImage>--%>
                                                <ClientSideEvents SelectedIndexChanged="Fields_ValueChanged" />
                                            </dx:ASPxCheckBoxList>
                                        </div>
                                    </div>
                                </div>

                            </div>
                        </div>
                    </dx:SplitterContentControl>
                </ContentCollection>
            </dx:SplitterPane>
        </Panes>
        <ClientSideEvents PaneResized="contentSplitterClinet_resize" />
    </dx:ASPxSplitter>

    <!-- custom scrollbar plugin -->

    <script src="../scrollbar/jquery.mCustomScrollbar.concat.min.js"></script>
    <script>
        (function ($) {
            $(window).load(function () {
                initScrollbars();
            });
        })(jQuery);
        function initScrollbars() {
            $(".custom_report_table").mCustomScrollbar(
                  {
                      theme: "minimal-dark"
                  }
                  );
            $('#employees_grid').mCustomScrollbar(
                {
                    theme: "minimal-dark"
                }
            );

            $('#custom_fields_div').mCustomScrollbar(
                {
                    theme: "minimal-dark"
                }
            );
            //use page filter to disable the custom scorllbar that can fix the expand the right spliter panel
            // $('.dxgvCSD').mCustomScrollbar(
            //    {
            //        theme: "minimal-dark"
            //    }
            //);
        }

        $('#ctl00_MainContentPH_ASPxSplitter1_contentSplitter_gridReport_DXPagerBottom_PSP_DXME_').addClass('no_before_and_after');

        empId = '<%= CurrentEmployee.EmployeeID %>';
    </script>
    <%-----------end-------%>
    <dx:ASPxCallback runat="server" ID="getEmployeeIDByName" OnCallback="getEmployeeIDByName_Callback" ClientInstanceName="getEmployeeIDByNameClinet">
        <ClientSideEvents CallbackComplete="getEmplyeeIDComplete" />
    </dx:ASPxCallback>
    <dx:ASPxPopupControl ClientInstanceName="popupControlCompareList" Width="600px" Height="800px" MaxWidth="1000px" MaxHeight="800px" MinHeight="150px" MinWidth="150px" ID="ASPxPopupControl3"
        HeaderText="Compare" AutoUpdatePosition="true" Modal="true" runat="server" PopupVerticalAlign="WindowCenter" PopupHorizontalAlign="WindowCenter" AllowDragging="true">
        <HeaderTemplate>
            <div class="clearfix">
                <div class="pop_up_header_margin">
                    <i class="fa fa-exchange with_circle pop_up_header_icon"></i>
                    <span class="pop_up_header_text">Compare Agents</span>
                </div>
                <div class="pop_up_buttons_div clearfix">
                    <i class="fa fa-times icon_btn" style="float: right" onclick="popupControlCompareList.Hide()"></i>
                    <div style="margin-top: 14px; margin-right: 13px; display: none">
                        <i class="fa fa-save report_head_button report_head_button_padding tooltip-examples" title="Save"></i>
                        <i class="fa fa-print report_head_button tooltip-examples report_head_button_padding" title="Print" onclick="$('#compare_table').printElement();"></i>
                        <i class="fa fa-envelope report_head_button tooltip-examples report_head_button_padding" title="E-mail"></i>
                        <i class="fa fa-file-pdf-o report_head_button tooltip-examples report_head_button_padding" title="PDF"></i>
                    </div>

                </div>
            </div>

        </HeaderTemplate>
        <ContentCollection>
            <dx:PopupControlContentControl runat="server">
                <script type="text/javascript">
                    // <![CDATA[
                    function grid_SelectionChanged(s, e) {
                        s.GetSelectedFieldValues("Name", GetSelectedFieldValuesCallback);
                    }
                    function GetSelectedFieldValuesCallback(values) {
                        selList.BeginUpdate();
                        try {
                            selList.ClearItems();
                            for (var i = 0; i < values.length; i++) {
                                selList.AddItem(values[i]);
                            }
                        } finally {
                            selList.EndUpdate();
                        }
                        document.getElementById("selCount").innerHTML = gridEmpsCompareClient.GetSelectedRowCount();
                    }
                    // ]]> 
                </script>


                <dx:ASPxCallbackPanel runat="server" ID="cbPnlCompare" ClientInstanceName="cbPnlCompareClient" OnCallback="cbPnlCompare_Callback">
                    <PanelCollection>
                        <dx:PanelContent>
                            <asp:HiddenField runat="server" ID="hfComparedEmps" />
                            <%--new compare agnets UI by steven--%>

                            <div style="margin-top: 25px; font-size: 14px" class="clearfix">
                                <table>
                                    <tr>
                                        <td>
                                            <div style="margin-bottom: -40px; width: 200px">
                                                <div class="dropdown">
                                                    <button class="btn btn-default dropdown-toggle" type="button" data-toggle="dropdown" style="background: transparent">
                                                        <span>Change Range</span><span class="caret"></span>
                                                    </button>

                                                    <ul class="dropdown-menu" role="menu" aria-labelledby="button2">
                                                        <li role="presentation"><a role="menuitem" tabindex="-1" href="#" onclick="cbPnlCompareClient.PerformCallback('ChangeDate|7')">1 week</a></li>
                                                        <li role="presentation"><a role="menuitem" tabindex="-1" href="#" onclick="cbPnlCompareClient.PerformCallback('ChangeDate|30')">30 days</a></li>
                                                        <li role="presentation"><a role="menuitem" tabindex="-1" href="#" onclick="cbPnlCompareClient.PerformCallback('ChangeDate|90')">3 months</a></li>
                                                        <li role="presentation"><a role="menuitem" tabindex="-1" href="#" onclick="cbPnlCompareClient.PerformCallback('ChangeDate|180')">6 months</a></li>
                                                    </ul>

                                                </div>
                                            </div>
                                           

                                            <table id="compare_table" style="float: left">
                                                <tr>
                                                    <td>
                                                        <div class="compare_titles_field">
                                                            <%--style="visibility: hidden" not show it on the frist column--%>
                                                            <div style="visibility: hidden">
                                                                <button class="btn btn-default dropdown-toggle" type="button" data-toggle="dropdown" id="button2" style="background: transparent">
                                                                    <span>Been Martin</span><span class="caret"></span>
                                                                </button>
                                                                <ul class="dropdown-menu" role="menu" aria-labelledby="button2">
                                                                    <%For Each empName In allEmpoyeeName()%>
                                                                    <li role="presentation"><a role="menuitem" tabindex="-1" href="#"><%=empName.Name %></a></li>
                                                                    <%Next%>
                                                                </ul>
                                                                <img src="<%=getProfileImage(58) %>" class="img-circle compare_profile_img " />
                                                                <span class="compare_agent_name">Benn Martin</span>
                                                            </div>
                                                            <div>
                                                                <%--table title--%>
                                                                <div class="compare_table_title">Basic Information</div>
                                                                <%--info items--%>
                                                                <%--only the first table row have title--%>
                                                                <div align="right" class="compare_table_row compare_table_row_title">
                                                                    <label class="compare_table_info font_normal">Role</label>
                                                                </div>
                                                                <div align="right" class="compare_table_row compare_table_row_title">
                                                                    <label class="compare_table_info font_normal">Manager</label>
                                                                </div>
                                                                <div align="right" class="compare_table_row compare_table_row_title">
                                                                    <label class="compare_table_info font_normal">Office</label>
                                                                </div>
                                                                <div align="right" class="compare_table_row compare_table_row_title">
                                                                    <label class="compare_table_info font_normal">Employee Since</label>
                                                                </div>
                                                                <div align="right" class="compare_table_row compare_table_row_title">
                                                                    <label class="compare_table_info font_normal">Cell</label>
                                                                </div>
                                                                <div align="right" class="compare_table_row compare_table_row_title">
                                                                    <label class="compare_table_info font_normal">Emal</label>
                                                                </div>

                                                            </div>
                                                            <div>
                                                                <%--table title--%>
                                                                <div class="compare_table_title">Performance</div>
                                                                <%--only the first table row have title--%>
                                                                <div align="right" class="compare_table_row compare_table_row_title">
                                                                    <label class="compare_table_info font_normal">Call Attemps</label>
                                                                </div>
                                                                <div align="right" class="compare_table_row compare_table_row_title">
                                                                    <label class="compare_table_info font_normal">Door Knock</label>
                                                                </div>
                                                                <div align="right" class="compare_table_row compare_table_row_title">
                                                                    <label class="compare_table_info font_normal">Follow Up</label>
                                                                </div>
                                                                <div align="right" class="compare_table_row compare_table_row_title">
                                                                    <label class="compare_table_info font_normal">Leads Count</label>
                                                                </div>

                                                            </div>
                                                        </div>
                                                    </td>

                                                    <%--run this td in loop here--%>


                                                    <% For Each emp In ComparedEmps%>
                                                    <td>
                                                        <div class="compare_agent_field">
                                                            <%--style="visibility: hidden"--%>
                                                            <div>
                                                                <div class="dropdown" <%=If(emp.EmployeeID=CurrentEmployee.EmployeeID,"style=""visibility: hidden""","") %>>
                                                                    <button class="btn btn-default dropdown-toggle" type="button" data-toggle="dropdown" style="background: #f5f5f5; color: #3993c1">
                                                                        <span style="padding-right: 50px"><%= emp.Name %></span><span class="caret"></span>
                                                                    </button>
                                                                    <ul class="dropdown-menu emplyees_drop" role="menu">
                                                                        <%For Each item In allEmpoyeeName()%>
                                                                        <li role="presentation"><a role="menuitem" tabindex="-1" href="#" onclick="cbPnlCompareClient.PerformCallback('ChangeEmp|<%= emp.EmployeeID %>|<%= item.EmployeeID %>')"><%= item.Name %></a></li>
                                                                        <%Next%>
                                                                    </ul>
                                                                </div>

                                                                <img src="<%=getProfileImage(emp.EmployeeID) %>" class="img-circle compare_profile_img " />
                                                                <span class="compare_agent_name"><%= emp.Name %>&nbsp;</span>
                                                            </div>
                                                            <div>
                                                                <%--table title--%>
                                                                <div class="compare_table_title">&nbsp;</div>
                                                                <%--info items--%>
                                                                <%--only the first table row have title--%>
                                                                <div class="compare_table_row compare_table_row_title ">
                                                                    <label class="compare_table_info color_balck"><%=emp.Position%> &nbsp;</label>
                                                                </div>
                                                                <div class="compare_table_row compare_table_row_title ">
                                                                    <label class="compare_table_info color_balck font_normal"><%=emp.Position%> &nbsp;</label>
                                                                </div>
                                                                <div class="compare_table_row compare_table_row_title ">
                                                                    <label class="compare_table_info color_balck font_normal"><%=emp.Office%> &nbsp;</label>
                                                                </div>
                                                                <div class="compare_table_row compare_table_row_title ">
                                                                    <label class="compare_table_info color_balck font_normal"><%=emp.EmployeeSince%> &nbsp;</label>
                                                                </div>
                                                                <div class="compare_table_row compare_table_row_title ">
                                                                    <label class="compare_table_info color_balck font_normal"><%=emp.CellPhone%> &nbsp;</label>
                                                                </div>
                                                                <div class="compare_table_row compare_table_row_title ">
                                                                    <label class="compare_table_info color_balck font_normal" style="color: #3993c1"><%=emp.Email%> &nbsp;</label>
                                                                </div>
                                                            </div>
                                                            <div>
                                                                <%--table title--%>
                                                                <div class="compare_table_title">&nbsp;</div>
                                                                <%--only the first table row have title--%>
                                                                <div class="compare_table_row compare_table_row_title">
                                                                    <label class="compare_table_info color_balck font_normal"><%=emp.Performance.CallAttemps %> &nbsp;</label>
                                                                </div>
                                                                <div class="compare_table_row compare_table_row_title">
                                                                    <label class="compare_table_info color_balck font_normal"><%=emp.Performance.Doorknock %> &nbsp;</label>
                                                                </div>
                                                                <div class="compare_table_row compare_table_row_title">
                                                                    <label class="compare_table_info color_balck font_normal"><%=emp.Performance.FollowUp %> &nbsp;</label>
                                                                </div>
                                                                <div class="compare_table_row compare_table_row_title">
                                                                    <label class="compare_table_info color_balck font_normal"><%=emp.Performance.LeadsCount %> &nbsp;</label>
                                                                </div>
                                                            </div>
                                                        </div>
                                                    </td>
                                                    <% Next%>
                                                </tr>
                                            </table>
                                        </td>
                                        <td style="vertical-align: top">
                                            <div style="margin-left: 20px; margin-top: -12px;">
                                                <i class="fa fa-plus with_circle icon_btn compare_add_button" onclick="cbPnlCompareClient.PerformCallback('AddNewEmp')"></i>
                                            </div>
                                        </td>
                                    </tr>
                                </table>


                            </div>
                        </dx:PanelContent>
                    </PanelCollection>
                </dx:ASPxCallbackPanel>


            </dx:PopupControlContentControl>
        </ContentCollection>
    </dx:ASPxPopupControl>
</asp:Content>


