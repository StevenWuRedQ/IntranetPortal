<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="AgentOverview.aspx.vb" Inherits="IntranetPortal.AgentOverview" MasterPageFile="~/Content.Master" %>

<%@ Register Src="~/AgentOverview/AgentCharts.ascx" TagPrefix="uc1" TagName="AgentCharts" %>


<asp:Content ContentPlaceHolderID="head" runat="server">
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

                LoadAngentTodayReport(empId+",1");
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
            empId = employeeId;
            infoCallbackClient.PerformCallback("EMP|" + employeeId);
            gridReportClient.PerformCallback("BindEmp|" + employeeId);
            LoadEmployeeBarChart(empId);
        }

        function BindOffice(office) {
            gridReportClient.PerformCallback("BindOffice|" + office);
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
            gridReportClient.PerformCallback("BindStatus|" + status);
            //ContentCallbackPanel.PerformCallback("Status|" + status)
            LoadStatusBarChart(status);
        }
        function CustomizRefershEnd() {

            initScrollbars();
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
    </script>
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
                                    <i class="fa fa-group with_circle" style="width: 48px; height: 48px; line-height: 48px;"></i>&nbsp;&nbsp;&nbsp;<span style="color: #234b60; font-size: 30px;">Employees</span>
                                    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<i class="fa fa-sort-amount-desc"></i>
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
                                                                <td style="width: 80px;"><span class="font_black">Department: <%# Container.GroupText%>
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
                                        <i class="fa fa-sort-amount-desc icon_right_s"></i>
                                    </div>
                                </div>

                            </div>

                            <%--menu list--%>
                            <div style="margin: 13px 30px 30px 30px">
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
                        <dx:ASPxSplitter runat="server" ID="contentSplitter" Orientation="Vertical" Width="100%" Height="100%">
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
                                            <div style="width: 1272px;" class="agent_layout_float clear-fix">
                                                <dx:ASPxCallbackPanel runat="server" ID="infoCallback" ClientInstanceName="infoCallbackClient" OnCallback="infoCallback_Callback">
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
                                                                                <button class="btn btn-default button_transparent" type="button" onclick="onGetAgentLogButtonClick()">Today's Log</button>

                                                                                <button class="btn btn-default button_transparent" type="button" onclick="onGetAgentZoningDateClick()" style="margin-left: 20px">Leads's Tax</button>
                                                                            </div>
                                                                        </div>
                                                                    </asp:Panel>

                                                                    <asp:Panel runat="server" ID="OfficeInfoPanel" Visible="false">
                                                                        <dx:ASPxImage runat="server" ID="ASPxImage1" CssClass="img-circle class_profile_image" ImageUrl="/images/user-empty-icon.png">
                                                                        </dx:ASPxImage>
                                                                        <div style="margin-top: 28px; font-size: 30px; color: #234b60; line-height: 16px" class="agnet_info_text"><%= CurrentOffice %>&nbsp;Office </div>
                                                                        <div style="margin-top: 8px; font-size: 16px; color: #234b60; font-weight: 900" class="agnet_info_text"><%= GetOfficeMgr() %></div>
                                                                        <%--info detial--%>
                                                                        <div style="font-size: 14px; margin-top: 25px; display: none">
                                                                            <%--items--%>
                                                                            <div class="agent_info_detial_left">Address</div>
                                                                            <div class="agent_info_detial_space">&nbsp;</div>
                                                                            <div class="agent_info_detial_right">&nbsp;</div>
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
                                                <%--center top--%>


                                                <dx:ASPxPopupControl ID="ASPxPopupControl2" runat="server" HeaderText="Select Photo" ClientInstanceName="selectImgs" Modal="true" Width="500px" PopupVerticalAlign="WindowCenter" PopupHorizontalAlign="WindowCenter">
                                                    <ContentCollection>
                                                        <dx:PopupControlContentControl ID="Popupcontrolcontentcontrol2" runat="server">
                                                        </dx:PopupControlContentControl>
                                                    </ContentCollection>
                                                </dx:ASPxPopupControl>

                                                <dx:ASPxPopupControl ID="ASPxPopupControl1" runat="server" HeaderText="Report Name" ClientInstanceName="SaveReportPopup" Modal="true" Width="500px" PopupVerticalAlign="WindowCenter" PopupHorizontalAlign="WindowCenter">
                                                    <ContentCollection>
                                                        <dx:PopupControlContentControl ID="Popupcontrolcontentcontrol1" runat="server">
                                                            <dx:ASPxTextBox runat="server" ID="txtReportName" ClientInstanceName="txtClientReportName"></dx:ASPxTextBox>
                                                            <dx:ASPxButton runat="server" ID="btnSave" AutoPostBack="false" Text="Add">
                                                                <ClientSideEvents Click="function(s, e){
                                                                SaveReportPopup.Hide();
                                                                Savelayout(txtClientReportName.GetText());
                                                                }" />
                                                            </dx:ASPxButton>
                                                        </dx:PopupControlContentControl>
                                                    </ContentCollection>
                                                </dx:ASPxPopupControl>
                                                <%--chart UI--%>
                                                <div style="height: 490px;" class="clearfix">

                                                    <div style="padding-top: 50px; font-size: 30px; color: #ff400d; text-align: center; display: none">In the last 6 months</div>

                                                    <div style="padding-left: 370px; padding-top: 10px; height: 325px;" class="clearfix">
                                                        <div class="layout_float_right clearfix">

                                                            <div class="dropdown layout_float_right" style="display:none">
                                                                <button class="btn btn-default dropdown-toggle" type="button" id="chart_line_select" data-toggle="dropdown" style="background: transparent">
                                                                    Line & Point Chart <span class="caret"></span>

                                                                </button>
                                                                <ul class="dropdown-menu" role="menu" aria-labelledby="chart_line_select">
                                                                    <li role="presentation"><a role="menuitem" tabindex="-1" href="#" onclick="change_chart_type(this)">Line</a></li>
                                                                    <li role="presentation"><a role="menuitem" tabindex="-1" href="#" onclick="change_chart_type(this)">Bar</a></li>
                                                                    <li role="presentation"><a role="menuitem" tabindex="-1" href="#" onclick="change_chart_type(this)">Pie</a></li>

                                                                </ul>
                                                            </div>

                                                            <div class="dropdown layout_float_right" style="margin-right: 20px;">
                                                                <button class="btn btn-default dropdown-toggle" type="button" id="dropdownMenu1" data-toggle="dropdown" style="background: transparent">
                                                                    Change Stat Range <span class="caret"></span>

                                                                </button>
                                                                <ul class="dropdown-menu" role="menu" aria-labelledby="dropdownMenu1">
                                                                    <li role="presentation"><a role="menuitem" tabindex="-1" href="#" onclick="change_chart_time(1)">Log toady</a></li>
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

                                                            <i class="fa fa-save report_head_button report_head_button_padding" onclick="SaveReportPopup.Show()" style="cursor: pointer"></i>
                                                            <i class="fa fa-exchange report_head_button tooltip-examples report_head_button_padding" title="Compare"></i>
                                                            <asp:LinkButton ID="btnExport" runat="server" OnClick="Unnamed_ServerClick" Text='<i class="fa fa-print  report_head_button report_head_button_padding"></i>'>                                                                
                                                            </asp:LinkButton>
                                                            <i class="fa fa-envelope  report_head_button report_head_button_padding"></i>
                                                            <i class="fa fa-file-pdf-o  report_head_button"></i>
                                                        </div>
                                                    </div>

                                                    <%--grid view--%>

                                                    <%--<div style="overflow-x:scroll;overflow-y:scroll;max-height:900px;">--%>
                                                    <dx:ASPxGridView ID="gridReport" runat="server" KeyFieldName="BBLE" Width="100%" AutoGenerateColumns="false" ClientInstanceName="gridReportClient" OnCustomCallback="gridReport_CustomCallback" Settings-ShowGroupPanel="false" OnInit="gridReport_Init" CssClass="font_source_sans_pro" Settings-VerticalScrollBarMode="Auto">
                                                        <%--Settings-HorizontalScrollBarMode="Auto"--%>
                                                        <Settings ShowFilterBar="Visible" ShowHeaderFilterButton="true" ShowGroupPanel="true" />
                                                        <Columns>
                                                            <dx:GridViewDataColumn FieldName="PropertyAddress">
                                                                <CellStyle Font-Bold="True"></CellStyle>
                                                            </dx:GridViewDataColumn>
                                                        </Columns>
                                                        <%-- Mode="ShowAllRecords" ShowAllItem="True"--%>
                                                        <SettingsPager PageSize="10" PageSizeItemSettings-Visible="true" PageSizeItemSettings-ShowAllItem="true">
                                                            <PageSizeItemSettings  Visible="True"></PageSizeItemSettings>
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
                                                            <Table>
                                                            </Table>
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
                                                        <span class="drappable_field_text" onclick='LoadLayout(this.innerHTML)' style="cursor: pointer; width: 140px;"><% = key%></span>
                                                        <button type="button" value="delete" onclick='RemoveReport("<%= key %>")'>Delete</button>
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
                                                    <dx:ListEditItem Text="Sale Date" Value="SaleDate" />
                                                    <dx:ListEditItem Text="Tax Class" Value="TaxClass" />
                                                    <dx:ListEditItem Text="Block" Value="Block" />
                                                    <dx:ListEditItem Text="Lot" Value="Lot" />
                                                    <dx:ListEditItem Text="Year Build" Value="YearBuilt" />
                                                    <dx:ListEditItem Text="# of floor" Value="NumFloors" />
                                                    <dx:ListEditItem Text="Building Dem" Value="BuildingDem" />
                                                    <dx:ListEditItem Text="Lot Dem" Value="LotDem" />
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
        empId = '<%= CurrentEmployee.EmployeeID %>';
    </script>
    <%-----------end-------%>
</asp:Content>


