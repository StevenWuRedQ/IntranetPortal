<%@ Control Language="vb" AutoEventWireup="false" CodeBehind="UserSummary.ascx.vb" Inherits="IntranetPortal.UserSummary" %>
<%@ Register Src="~/UserControl/Devexpress/CustomVerticalAppointmentTemplate.ascx" TagName="CustomVerticalAppointmentTemplate" TagPrefix="uc1" %>
<%@ Register Src="~/UserControl/LeadsSubMenu.ascx" TagPrefix="uc1" TagName="LeadsSubMenu" %>

<uc1:LeadsSubMenu runat="server" ID="LeadsSubMenu" />


<link rel="stylesheet" href="/css/right-pane.css" />
<script src="http://cdn3.devexpress.com/jslib/15.1.6/js/dx.chartjs.js"></script>
<script>
    $(document).ready(function () {

        $("#right-pane-button").mouseenter(function () {
            $("#right-pane-container").css("right", "0");
        });

        $('body').click(function (e) {
            if (e.target.id == 'right-pane-container')
            { return true; }
            else
            {
                $("#right-pane-container").css("right", "-290px");
            }

        });
    })
</script>

<script type="text/javascript">
    function OnNotesKeyDown(s, e) {
        var textArea = s.GetInputElement();

        if (textArea.scrollHeight + 2 > s.GetHeight()) {
            //alert(textArea.scrollHeight + "|" + s.GetHeight());
            s.SetHeight(textArea.scrollHeight + 2);
        }

        if (textArea.scrollHeight + 2 < s.GetHeight()) {
            //alert(textArea.scrollHeight + "|" + s.GetHeight());
            s.SetHeight(textArea.scrollHeight + 2);
        }
    }

    function ShowBorder(s) {
        var tbl = s.GetMainElement();
        if (tbl.style.borderColor == 'transparent') {
            //border-top: 1px solid #9da0aa;
            //border-right: 1px solid #c2c4cb;
            //border-bottom: 1px solid #d9dae0;
            //border-left: 1px solid #c2c4cb;
            tbl.style.borderColor = "white";
            tbl.style.backgroundColor = 'transparent';
        }
        else {
            tbl.style.borderColor = 'transparent';
            tbl.style.backgroundColor = 'transparent';
        }
    }

    function ShowWorklistItem(itemData, processName) {
        window.location.href = "/Task/MyTask.aspx?page=" + encodeURIComponent(itemData);
    }

    function initScrollbar_summary() {
        return;
        $("#ctl00_MainContentPH_UserSummary_contentSplitter_0_CC").mCustomScrollbar(
            {
                theme: "minimal-dark",
                axis: "yx"
            }
         );

    }
    $(document).ready(function () {
        // Handler for .ready() called.
        initScrollbar_summary();

    });

</script>

<%-------end-------%>
<style type="text/css">
    .Header {
        color: #0072C6;
        vertical-align: top;
    }

    h4 {
        /*fix by steven*/
        /*font: 20px 'Segoe UI', Helvetica, 'Droid Sans', Tahoma, Geneva, sans-serif;*/
        /*color: #0072C6; /*change the coloer by steven*/
        font-family: 'Source Sans Pro', sans-serif;
        font-size: 21px;
        vertical-align: central;
        padding: 3px;
        margin-bottom: 0px;
        font-weight: 900;
        /*background-color: #ededed;*/
        margin-top: 10px;
        padding-top: 10px;
    }

    /*add by steven vertical image and text class*/
    .h4_span {
        font-family: 'Source Sans Pro', sans-serif;
        font-size: 21px;
        font-weight: 900;
    }

    .vertical-img {
        /* vertical-align: middle; */
        display: block;
        float: left;
    }


    /*the label near the summary text div*/
    .label-summary-info {
        float: left;
        margin-top: 10px;
        color: white;
        font-size: 20px;
        font-weight: 200;
        padding: 8px 12px;
        border-radius: 5px;
    }

    .dxgv {
        font: 14px 'Source Sans Pro';
        /*height: 40px;*/
    }

    .dxgvFocusedGroupRow_MetropolisBlue {
        border-bottom: 0px !important;
    }

    /*.dxgvDataRowAlt_Portal {
        background-color: #eff2f5 !important;
    }*/
    /*-------end-------------*/

    td.dxgv {
        border-bottom: 0px !important;
    }

    td.dxgvIndentCell {
        border-right: 3px Solid #dde0e7 !important;
    }

    .under_line {
        border-bottom: 3px solid #dde0e7;
    }

    td.grid_padding {
        padding-top: 20px;
    }

    .notesTitleStyle {
        font-size: 30px;
        font-weight: 400;
        color: white;
    }

    .notesDescriptionStyle {
        font-size: 14px;
        line-height: 24px;
        color: white;
    }
</style>

<dx:ASPxSplitter ID="contentSplitter" PaneStyle-BackColor="#f9f9f9" runat="server" Height="100%" Width="100%" ClientInstanceName="contentSplitter" FullscreenMode="true">
    <Styles>
        <Pane Paddings-Padding="0">
            <Paddings Padding="0px"></Paddings>
        </Pane>
    </Styles>
    <Panes>
        <dx:SplitterPane ScrollBars="Auto">
            <ContentCollection>
                <dx:SplitterContentControl>
                    <div style="font-family: 'Source Sans Pro'; margin-left: 19px; margin-top: 15px;">

                        <div style="float: left; font-weight: 300; font-size: 48px; color: #234b60">
                            <span style="text-transform: capitalize" id="spanUserName"><%= Page.User.Identity.Name %></span>'s Summary &nbsp;
                        </div>
                        <div align="center" style="background-color: #ff400d;" class="label-summary-info">

                            <span style="font-weight: 900">
                                <%= IntranetPortal.Utility.TotalLeadsCount%>
                            </span>
                            <span style="font-weight: 200">&nbsp;Leads
                            </span>

                        </div>
                        <div align="center" style="background-color: #1a3847; margin-left: 10px;" class="label-summary-info">

                            <span style="font-weight: 900">
                                <%= IntranetPortal.Utility.TotalDealsCount %>
                            </span>
                            <span style="font-weight: 200">&nbsp;Deals
                            </span>

                        </div>

                        <div align="center" style="background-color: #ff851b; margin-left: 10px;" class="label-summary-info">

                            <span class="icon_btn" style="font-weight: 200" data-toggle="modal" data-target="#calendar-modal">Show Calendar
                            </span>

                        </div>
                        <div align="center" style="background-color: #3c8dbc; margin-left: 10px;" class="label-summary-info">

                            <span class="icon_btn" style="font-weight: 200" onclick="show_chart_modal()">Show Performance
                            </span>

                        </div>
                    </div>

                    <div class="content" style="float: left">
                        <div class="row">
                            <div class="col-md-9 col-lg-9">
                                <div class="row under_line" style="min-height: 360px">
                                    <div class="col-md-4 " style="vertical-align: top">
                                        <h4>
                                            <img src="../images/grid_upcoming_icon.png" class="vertical-img">
                                            <span class="heading_text">Upcoming Appointments</span>
                                        </h4>

                                        <dx:ASPxGridView runat="server" Width="100%" ID="gridAppointment" ClientInstanceName="gridAppointmentClient" KeyFieldName="BBLE" Settings-ShowColumnHeaders="false" Settings-GridLines="None" Border-BorderStyle="None" SettingsPager-PageSize="5" OnDataBinding="gridAppointment_DataBinding">
                                            <Columns>
                                                <dx:GridViewDataTextColumn FieldName="LeadsName" Settings-AllowHeaderFilter="False" VisibleIndex="1">
                                                    <DataItemTemplate>
                                                        <div class="group_lable" onclick='<%# String.Format("NavigateURL(""{0}"",""{1}"")", "Task", Eval("BBLE"))%>'><%# HtmlBlackInfo(Eval("LeadsName")) %>  </div>
                                                    </DataItemTemplate>
                                                </dx:GridViewDataTextColumn>
                                                <dx:GridViewDataTextColumn FieldName="ScheduleDate" PropertiesTextEdit-DisplayFormatString="d" VisibleIndex="2" GroupIndex="0" Settings-SortMode="Custom">
                                                    <PropertiesTextEdit DisplayFormatString="d"></PropertiesTextEdit>
                                                    <Settings AllowHeaderFilter="False" GroupInterval="Date"></Settings>
                                                    <GroupRowTemplate>
                                                        <%--Date: <%# Container.GroupText & Container.SummaryText.Replace("Count=", "")%>--%>
                                                        <%--change group template UI by steven--%>
                                                        <div style="height: 30px">
                                                            <table style="height: 30px">
                                                                <tr>
                                                                    <td>
                                                                        <img src="../images/grid_call_backs_canlender.png" /></td>
                                                                    <td style="font-weight: 900; width: 80px; text-align: center;">Date: <%# Container.GroupText%></td>
                                                                    <td style="padding-left: 10px">
                                                                        <span class="employee_lest_head_number_label"><%# Container.SummaryText.Replace("Count=", "").Replace("(", "").Replace(")", "")%></span>
                                                                    </td>
                                                                    <%--the round div--%>
                                                                </tr>
                                                            </table>
                                                        </div>
                                                        <%-------end---------%>
                                                    </GroupRowTemplate>
                                                </dx:GridViewDataTextColumn>
                                                <dx:GridViewDataColumn Width="40px" VisibleIndex="5">
                                                    <DataItemTemplate>
                                                        <%--change the image and the size by steven--%>
                                                        <img src="/images/menu_flag.png" style="/*width: 16px; height: 16px; */vertical-align: bottom; cursor: pointer;" onclick='<%#String.Format("ShowCateMenu(this,{0})", Eval("BBLE")) %>' />
                                                    </DataItemTemplate>
                                                </dx:GridViewDataColumn>
                                            </Columns>
                                            <GroupSummary>
                                                <dx:ASPxSummaryItem SummaryType="Count" />
                                            </GroupSummary>
                                            <SettingsPager ShowNumericButtons="false"></SettingsPager>
                                            <SettingsBehavior EnableRowHotTrack="True" ColumnResizeMode="NextColumn" AutoExpandAllGroups="true" />
                                            <Styles>
                                                <AlternatingRow CssClass="gridAlternatingRow"></AlternatingRow>
                                            </Styles>
                                        </dx:ASPxGridView>
                                    </div>

                                    <div class="col-md-4" style="vertical-align: top">
                                        <%--add icon by steven--%>
                                        <h4>
                                            <img src="../images/grid_propity.png" class="vertical-img" /><span class="heading_text">Hot Leads</span>
                                        </h4>

                                        <dx:ASPxGridView runat="server" Width="100%" ID="gridPriority" ClientInstanceName="gridPriorityClient" KeyFieldName="BBLE" Settings-ShowColumnHeaders="false" Settings-GridLines="None" Border-BorderStyle="None" Paddings-PaddingTop="10px" SettingsPager-PageSize="5"
                                            OnDataBinding="gridPriority_DataBinding">
                                            <Columns>
                                                <dx:GridViewDataTextColumn FieldName="LeadsName" Settings-AllowHeaderFilter="False" VisibleIndex="1">
                                                    <DataItemTemplate>
                                                        <div style="cursor: pointer; height: 38px; padding-left: 20px; line-height: 38px;" onclick='<%# String.Format("NavigateURL(""{0}"",""{1}"")", "Priority", Eval("BBLE"))%>'><%# HtmlBlackInfo(Eval("LeadsName"))%></div>
                                                    </DataItemTemplate>
                                                </dx:GridViewDataTextColumn>
                                                <dx:GridViewDataColumn Width="40px" VisibleIndex="5" EditCellStyle-BorderLeft-BorderStyle="Solid">
                                                    <DataItemTemplate>
                                                        <%--change the image and the size by steven--%>
                                                        <img src="/images/menu_flag.png" style="/*width: 16px; height: 16px; */vertical-align: bottom; cursor: pointer;" onclick='<%#String.Format("ShowCateMenu(this,{0})", Eval("BBLE")) %>' />
                                                    </DataItemTemplate>
                                                </dx:GridViewDataColumn>
                                            </Columns>
                                            <SettingsBehavior EnableRowHotTrack="True" ColumnResizeMode="NextColumn" />
                                            <SettingsPager ShowNumericButtons="false"></SettingsPager>
                                            <Styles>
                                                <AlternatingRow BackColor="#eff2f5"></AlternatingRow>
                                                <RowHotTrack BackColor="#ff400d"></RowHotTrack>
                                            </Styles>
                                        </dx:ASPxGridView>
                                    </div>

                                    <div class="col-md-4" style="vertical-align: top">
                                        <%--add icon by steven--%>
                                        <h4>
                                            <img src="../images/grid_propity.png" class="vertical-img" /><span class="heading_text">Warmer</span>
                                        </h4>

                                        <dx:ASPxGridView runat="server" Width="100%" ID="gridWarmer" KeyFieldName="BBLE" Settings-ShowColumnHeaders="false" Settings-GridLines="None" Border-BorderStyle="None" Paddings-PaddingTop="10px" SettingsPager-PageSize="5"
                                            OnDataBinding="gridWarmer_DataBinding">
                                            <Columns>
                                                <dx:GridViewDataTextColumn FieldName="LeadsName" Settings-AllowHeaderFilter="False" VisibleIndex="1">
                                                    <DataItemTemplate>
                                                        <div style="cursor: pointer; height: 38px; padding-left: 20px; line-height: 38px;" onclick='<%# String.Format("NavigateURL(""{0}"",""{1}"")", "Warmer", Eval("BBLE"))%>'><%# HtmlBlackInfo(Eval("LeadsName"))%></div>
                                                    </DataItemTemplate>
                                                </dx:GridViewDataTextColumn>
                                                <dx:GridViewDataColumn Width="40px" VisibleIndex="5" EditCellStyle-BorderLeft-BorderStyle="Solid">
                                                    <DataItemTemplate>
                                                        <%--change the image and the size by steven--%>
                                                        <img src="/images/menu_flag.png" style="/*width: 16px; height: 16px; */vertical-align: bottom; cursor: pointer;" onclick='<%#String.Format("ShowCateMenu(this,{0})", Eval("BBLE")) %>' />
                                                    </DataItemTemplate>
                                                </dx:GridViewDataColumn>
                                            </Columns>
                                            <SettingsBehavior EnableRowHotTrack="True" ColumnResizeMode="NextColumn" />
                                            <SettingsPager ShowNumericButtons="false"></SettingsPager>
                                            <Styles>
                                                <AlternatingRow BackColor="#eff2f5"></AlternatingRow>
                                                <RowHotTrack BackColor="#ff400d"></RowHotTrack>
                                            </Styles>
                                        </dx:ASPxGridView>
                                    </div>
                                </div>
                                <div class="row under_line">
                                    <div class="col-md-4" style="vertical-align: top">
                                        <h4>
                                            <img src="../images/grid_task_icon.png" class="vertical-img" />
                                            <span class="heading_text">Task</span>
                                        </h4>

                                        <dx:ASPxGridView runat="server" Width="100%" ID="gridTask" KeyFieldName="ProcInstId;ActInstId" ClientInstanceName="gridTaskClient"
                                            OnDataBinding="gridTask_DataBinding" Settings-ShowColumnHeaders="false" Settings-GridLines="None" Border-BorderStyle="None" Paddings-PaddingTop="10px" SettingsPager-PageSize="6">
                                            <Columns>
                                                <dx:GridViewDataTextColumn FieldName="DisplayName" Settings-AllowHeaderFilter="False" VisibleIndex="1">
                                                    <Settings AutoFilterCondition="Contains" />
                                                    <DataItemTemplate>
                                                        <div style="cursor: pointer; height: 30px; padding-left: 20px; line-height: 30px;" onclick='ShowWorklistItem("<%# Eval("ItemData")%>", "<%# Eval("ProcessName")%>")'><%# Eval("DisplayName")%></div>
                                                    </DataItemTemplate>
                                                </dx:GridViewDataTextColumn>
                                                <dx:GridViewDataTextColumn FieldName="StartDate" Visible="false" PropertiesTextEdit-DisplayFormatString="d" VisibleIndex="2" Caption="Date">
                                                    <PropertiesTextEdit DisplayFormatString="d"></PropertiesTextEdit>
                                                    <Settings AllowHeaderFilter="False" GroupInterval="Date"></Settings>
                                                </dx:GridViewDataTextColumn>
                                                <dx:GridViewDataColumn FieldName="ActivityName" Visible="false" VisibleIndex="3">
                                                </dx:GridViewDataColumn>
                                                <dx:GridViewDataColumn FieldName="ProcSchemeDisplayName" Visible="false" VisibleIndex="5">
                                                    <GroupRowTemplate>
                                                        <div>
                                                            <table style="height: 45px">
                                                                <tr onclick="ExpandOrCollapseGroupRow(<%# Container.VisibleIndex%>)" style="cursor: pointer">
                                                                    <td style="width: 80px;">
                                                                        <span class="font_black">
                                                                            <i class="fa fa-user font_16"></i><span class="group_text_margin"><%#  Container.GroupText  %> &nbsp;</span>
                                                                        </span>
                                                                    </td>
                                                                    <td style="padding-left: 10px">
                                                                        <span class="employee_lest_head_number_label"><%# Container.SummaryText.Replace("Count=", "").Replace("(", "").Replace(")", "")%></span>
                                                                    </td>
                                                                </tr>
                                                            </table>
                                                        </div>
                                                    </GroupRowTemplate>
                                                </dx:GridViewDataColumn>
                                                <dx:GridViewDataColumn Width="40px" VisibleIndex="5" EditCellStyle-BorderLeft-BorderStyle="Solid">
                                                    <DataItemTemplate>
                                                        <%--change the image and the size by steven--%>
                                                        <img src="/images/menu_flag.png" style="/*width: 16px; height: 16px; */vertical-align: bottom; cursor: pointer; visibility: hidden;" />
                                                    </DataItemTemplate>
                                                </dx:GridViewDataColumn>
                                            </Columns>
                                            <GroupSummary>
                                                <dx:ASPxSummaryItem SummaryType="Count" />
                                            </GroupSummary>
                                            <SettingsBehavior EnableRowHotTrack="True" ColumnResizeMode="NextColumn" AutoExpandAllGroups="true" />
                                            <SettingsPager ShowNumericButtons="false"></SettingsPager>
                                            <Styles>
                                                <AlternatingRow BackColor="#eff2f5"></AlternatingRow>
                                                <RowHotTrack BackColor="#ff400d" ForeColor="White"></RowHotTrack>
                                            </Styles>
                                        </dx:ASPxGridView>
                                    </div>

                                    <div class="col-md-4" style="vertical-align: top">

                                        <h4>
                                            <img src="../images/grid_call_back_icon.png" class="vertical-img" /><span class="heading_text">Follow Up</span> </h4>
                                        <%--------end-------%>

                                        <dx:ASPxGridView runat="server" Width="100%" ID="gridCallback" ClientInstanceName="gridCallbackClient" KeyFieldName="BBLE" AutoGenerateColumns="false"
                                            OnDataBinding="gridCallback_DataBinding" Settings-ShowColumnHeaders="false" Settings-GridLines="None" Border-BorderStyle="None" Paddings-PaddingTop="10px" SettingsPager-PageSize="6">
                                            <Columns>
                                                <dx:GridViewDataTextColumn FieldName="LeadsName" Settings-AllowHeaderFilter="False" VisibleIndex="1" CellStyle-CssClass="cell_hover">
                                                    <DataItemTemplate>
                                                        <div class="group_lable" onclick='<%# String.Format("NavigateURL(""{0}"",""{1}"")", "Call Back", Eval("BBLE"))%>'><%#  HtmlBlackInfo(Eval("LeadsName"))%></div>
                                                    </DataItemTemplate>
                                                </dx:GridViewDataTextColumn>
                                                <dx:GridViewDataTextColumn FieldName="CallbackDate" VisibleIndex="2" Visible="false" Settings-SortMode="Custom">
                                                    <Settings AllowHeaderFilter="False" GroupInterval="Date"></Settings>
                                                    <%--change group template UI by steven--%>
                                                    <GroupRowTemplate>
                                                        <div>
                                                            <table>
                                                                <tr>
                                                                    <td>
                                                                        <img src="../images/grid_call_backs_canlender.png" /></td>
                                                                    <td style="font-weight: 900; width: 80px; text-align: center;">Date: <%# Container.GroupText%></td>
                                                                    <td style="padding-left: 10px">
                                                                        <span class="employee_lest_head_number_label"><%# Container.SummaryText.Replace("Count=", "").Replace("(", "").Replace(")", "")%></span>
                                                                    </td>
                                                                    <%--the round div--%>
                                                                </tr>
                                                            </table>
                                                        </div>

                                                    </GroupRowTemplate>
                                                    <%-------end---------%>
                                                </dx:GridViewDataTextColumn>
                                                <dx:GridViewDataColumn Width="40px" VisibleIndex="5" EditCellStyle-BorderLeft-BorderStyle="Solid">
                                                    <DataItemTemplate>
                                                        <%--change the image and the size by steven--%>
                                                        <img src="/images/menu_flag.png" style="/*width: 16px; height: 16px; */vertical-align: bottom; cursor: pointer;" onclick='<%#String.Format("ShowCateMenu(this,{0})", Eval("BBLE")) %>' />
                                                    </DataItemTemplate>
                                                </dx:GridViewDataColumn>
                                            </Columns>
                                            <SettingsBehavior AutoExpandAllGroups="true"
                                                EnableRowHotTrack="True" ColumnResizeMode="NextColumn" />
                                            <Styles>
                                                <AlternatingRow BackColor="#eff2f5"></AlternatingRow>
                                                <RowHotTrack BackColor="#ff400d"></RowHotTrack>

                                            </Styles>
                                            <SettingsPager ShowNumericButtons="false">
                                            </SettingsPager>
                                            <GroupSummary>
                                                <dx:ASPxSummaryItem FieldName="CallbackDate" SummaryType="Count" />
                                            </GroupSummary>
                                        </dx:ASPxGridView>

                                    </div>

                                    <div class="col-md-4" style="vertical-align: top">
                                        <h4>
                                            <img src="../images/grid_call_back_icon.png" class="vertical-img" /><span class="heading_text">LoanMod</span> </h4>
                                        <%--------end-------%>
                                        <dx:ASPxGridView runat="server" Width="100%" ID="gridLoanMod" ClientInstanceName="gridLoanModClient" KeyFieldName="BBLE" AutoGenerateColumns="false"
                                            OnDataBinding="gridLoanMod_DataBinding" Settings-ShowColumnHeaders="false" Settings-GridLines="None" Border-BorderStyle="None" Paddings-PaddingTop="10px" SettingsPager-PageSize="6">
                                            <Columns>
                                                <dx:GridViewDataTextColumn FieldName="LeadsName" Settings-AllowHeaderFilter="False" VisibleIndex="1" CellStyle-CssClass="cell_hover">
                                                    <DataItemTemplate>
                                                        <div class="group_lable" onclick='<%# String.Format("NavigateURL(""{0}"",""{1}"")", "LoanMod", Eval("BBLE"))%>'><%#  HtmlBlackInfo(Eval("LeadsName"))%></div>
                                                    </DataItemTemplate>
                                                </dx:GridViewDataTextColumn>

                                                <dx:GridViewDataColumn FieldName="SubStatusStr" Visible="false" VisibleIndex="6">
                                                    <GroupRowTemplate>
                                                        <div>
                                                            <table style="height: 45px">
                                                                <tr onclick="ExpandOrCollapseGroupRow(<%# Container.VisibleIndex%>)" style="cursor: pointer">
                                                                    <td style="width: 80px;">
                                                                        <span class="font_black">
                                                                            <i class="fa fa-user font_16"></i><span class="group_text_margin"><%#  Container.GroupText  %> &nbsp;</span>
                                                                        </span>
                                                                    </td>
                                                                    <td style="padding-left: 10px">
                                                                        <span class="employee_lest_head_number_label"><%# Container.SummaryText.Replace("Count=", "").Replace("(", "").Replace(")", "")%></span>
                                                                    </td>
                                                                </tr>
                                                            </table>
                                                        </div>
                                                    </GroupRowTemplate>
                                                </dx:GridViewDataColumn>
                                                <dx:GridViewDataColumn Width="40px" VisibleIndex="5" EditCellStyle-BorderLeft-BorderStyle="Solid">
                                                    <DataItemTemplate>
                                                        <%--change the image and the size by steven--%>
                                                        <img src="/images/menu_flag.png" style="/*width: 16px; height: 16px; */vertical-align: bottom; cursor: pointer;" onclick='<%#String.Format("ShowCateMenu(this,{0})", Eval("BBLE")) %>' />
                                                    </DataItemTemplate>
                                                </dx:GridViewDataColumn>
                                            </Columns>
                                            <SettingsBehavior AutoExpandAllGroups="true"
                                                EnableRowHotTrack="True" ColumnResizeMode="NextColumn" />
                                            <Styles>
                                                <AlternatingRow BackColor="#eff2f5"></AlternatingRow>
                                                <RowHotTrack BackColor="#ff400d"></RowHotTrack>

                                            </Styles>
                                            <SettingsPager ShowNumericButtons="false">
                                            </SettingsPager>
                                            <GroupSummary>
                                                <dx:ASPxSummaryItem FieldName="CallbackDate" SummaryType="Count" />
                                            </GroupSummary>
                                        </dx:ASPxGridView>

                                    </div>
                                </div>
                            </div>


                            <div class="col-md-9 col-lg-9">
                                <div>
                                </div>
                            </div>
                        </div>


                        <div id="calendar-modal" class="modal" style="width: 380px">
                            <div class="modal-content">
                                <div class="modal-header">

                                    <h3>Today's Calendar
                                        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                                            <span aria-hidden="true">&times;</span>
                                        </button>
                                    </h3>

                                </div>

                                <div class="modal-body">
                                    <dx:ASPxScheduler ID="todayScheduler" runat="server" Width="100%" ActiveViewType="Day" OnPopupMenuShowing="todayScheduler_PopupMenuShowing"
                                        ClientInstanceName="ASPxClientScheduler1">
                                        <Views>
                                            <DayView ShowAllDayArea="False" ShowWorkTimeOnly="True" NavigationButtonVisibility="Never">
                                                <WorkTime End="23:00:00" Start="08:00:00" />
                                                <TimeRulers>
                                                    <dx:TimeRuler />
                                                </TimeRulers>
                                                <Templates>
                                                    <VerticalAppointmentTemplate>
                                                        <uc1:CustomVerticalAppointmentTemplate ID="CustomVerticalAppointmentTemplate1" runat="server" />
                                                    </VerticalAppointmentTemplate>
                                                </Templates>
                                            </DayView>
                                            <WorkWeekView Enabled="False">
                                                <TimeRulers>
                                                    <dx:TimeRuler />
                                                </TimeRulers>
                                            </WorkWeekView>
                                            <WeekView Enabled="False" />
                                            <MonthView Enabled="False" />
                                            <TimelineView Enabled="False">
                                            </TimelineView>
                                        </Views>
                                        <OptionsBehavior ShowViewSelector="False" ShowViewNavigator="False" ShowViewNavigatorGotoDateButton="False" ShowViewVisibleInterval="False" />
                                        <OptionsCustomization AllowAppointmentDelete="None" AllowAppointmentDrag="None" AllowAppointmentDragBetweenResources="None" AllowAppointmentMultiSelect="False" AllowAppointmentResize="None" AllowAppointmentCreate="None" />
                                        <OptionsForms AppointmentFormVisibility="PopupWindow" AppointmentFormTemplateUrl="~/UserControl/Devexpress/CustomAppointmentForm.ascx" GotoDateFormVisibility="None" RecurrentAppointmentDeleteFormVisibility="None" RecurrentAppointmentEditFormVisibility="None" AppointmentInplaceEditorFormTemplateUrl="~/UserControl/Devexpress/CustomInplaceEditor.ascx" GotoDateFormTemplateUrl="~/DevExpress/ASPxSchedulerForms/GotoDateForm.ascx" RecurrentAppointmentDeleteFormTemplateUrl="~/DevExpress/ASPxSchedulerForms/RecurrentAppointmentDeleteForm.ascx" RecurrentAppointmentEditFormTemplateUrl="~/DevExpress/ASPxSchedulerForms/RecurrentAppointmentEditForm.ascx" RemindersFormTemplateUrl="~/DevExpress/ASPxSchedulerForms/ReminderForm.ascx" />
                                        <OptionsToolTips AppointmentDragToolTipUrl="~/DevExpress/ASPxSchedulerForms/AppointmentDragToolTip.ascx" AppointmentToolTipUrl="~/DevExpress/ASPxSchedulerForms/AppointmentToolTip.ascx" SelectionToolTipUrl="~/DevExpress/ASPxSchedulerForms/SelectionToolTip.ascx" />
                                        <Storage EnableReminders="False" Appointments-ResourceSharing="true">
                                            <Appointments>
                                                <%-- DXCOMMENT: Configure appointment mappings --%>
                                                <Mappings AppointmentId="AppointmentId" Start="Start" End="End" Location="Location"
                                                    Subject="Subject" Description="Description" Status="Status" Label="Label" Type="Type" />
                                                <CustomFieldMappings>
                                                    <dx:ASPxAppointmentCustomFieldMapping Name="Agent" ValueType="String" Member="Agent" />
                                                    <dx:ASPxAppointmentCustomFieldMapping Name="Manager" ValueType="String" Member="Manager" />
                                                    <dx:ASPxAppointmentCustomFieldMapping Name="AppointType" ValueType="String" Member="AppointType" />
                                                    <dx:ASPxAppointmentCustomFieldMapping Name="TitleLink" ValueType="String" Member="TitleLink" />
                                                </CustomFieldMappings>
                                            </Appointments>
                                        </Storage>
                                    </dx:ASPxScheduler>
                                </div>
                            </div>
                        </div>
                        <div id="chart-modal" class="modal">
                            <div class="modal-content" style="width: 375px">
                                <!--div class="modal-header">

                                    <h3>Perfomance
                                        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                                            <span aria-hidden="true">&times;</span>
                                        </button>
                                    </h3>

                                </div-->

                                <style>
                                    .modal-body-chart {
                                        width: 375px;
                                        background-color: #F2F2
                                           -webkit-border-radi s:  10
                                           -webkit-border-r dius:
                                              -moz-border-r dius:
                                              -moz-bor er-ra
                                                   bor er-ra
                                     
                                                                  .modal body-cha
                                             background-color: #D9F1FD;
    t-border-top-left-radius: 10px;
                                             -border-top-right-radius: 1 px;
                                        
                                        oz-border-radius-topleft: 10 x;
                                         z-border-radius-toprigh : 10p
                                          border-top-left-radius  10px
                                     
                                                                    }
                                </style>
                                <div class="modal-body modal-body-chart">
                                    <div class="modal-body-charte">
                                        <div id="dateRange" class="containers" style="width: 100%;"></div>
                                    </div>
                                    <div style="padding: 10px 10px;">
                                        <div id="agentActivityChart" class="containers" style="height: 240px; width: 100%;"></div>
                                        <div id="ProcessStatusChart" class="containers" style="width: 100%;"></div>
                                    </div>
                                </div>

                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-12" style="background: #fff5e7; border-left: 5px solid #ff400d; margin-top: 2px; padding-top: 0px; color: #2b586f; font: 14px 'PT Serif'; font-style: italic; margin-left: 19px;">
                                <div style="float: left; font-size: 30px; margin-left: 30px; margin-top: 5px;">“</div>
                                <p style="width: 90%; padding-top: 5px; padding-bottom: 5px; padding-left: 65px;">
                                    <%= HtmlBlackQuote(Quote)%>
                                </p>
                            </div>
                        </div>
                        <script type="text/javascript">
                            var agentSummaryReport = {
                                ActivityDataSource: null,
                                LeadsDataSource: null,
                                AgentName: null,
                                DateRange: function () {
                                    return $('#dateRange').has("svg").length ? $('#dateRange').dxRangeSelector('instance') : null;

                                },
                                BarChart: function () {
                                    if ($("#agentActivityChart").has("svg").length)
                                        return $("#agentActivityChart").dxChart("instance");
                                    else {
                                        var tab = this;
                                        $("#agentActivityChart").dxChart({
                                            dataSource: {},
                                            commonSeriesSettings: {
                                                argumentField: "Category",
                                                type: "bar",
                                                hoverMode: "allArgumentPoints",
                                                selectionMode: "allArgumentPoints",
                                                label: {
                                                    visible: true,
                                                    format: "fixedPoint",
                                                    precision: 0
                                                }
                                            },
                                            argumentAxis: {
                                                argumentType: 'string'
                                            },
                                            series: [
                                                { valueField: "User", name: "User", tag: "User" },
                                                { valueField: "Avg", name: "Team", tag: "TeamAverage" }
                                            ],
                                            title: {
                                                text: "Activity Summary",
                                                font: {
                                                    family: 'Source Sans Pro, sans-serif',
                                                    size: 21,
                                                    weight: 900
                                                },
                                                horizontalAlignment: 'left',
                                                margin: {
                                                    left: 20
                                                }
                                            },
                                            legend: {
                                                verticalAlignment: "bottom",
                                                horizontalAlignment: "center"
                                            },
                                            loadingIndicator: {
                                                show: true
                                            },
                                            onPointClick: function (info) {
                                                var clickedPoint = info.target;
                                                clickedPoint.isSelected() ? clickedPoint.clearSelection() : clickedPoint.select();

                                                if (clickedPoint.isSelected()) {

                                                }
                                            },
                                            onPointSelectionChanged: function (info) {
                                                //var selectedPoint = info.target;
                                                //if (selectedPoint.isSelected()) {

                                                //}
                                            },
                                            onLegendClick: function (info) {

                                            }
                                        });
                                        return $("#agentActivityChart").dxChart("instance");
                                    }
                                },
                                InitalTab: function () {
                                    var tab = this;
                                    var dateNow = new Date();
                                    var endDate = new Date();
                                    endDate = endDate.setDate(dateNow.getDate() + 1);
                                    var scaleStart = new Date();
                                    scaleStart.setMonth(scaleStart.getMonth() - 3);
                                    var startDate = dateNow;
                                    $("#dateRange").dxRangeSelector({
                                        margin: { top: 5 },
                                        size: { height: 150 },
                                        background: { color: '#ff400d' },
                                        width: 375,
                                        scale: {
                                            startValue: scaleStart,
                                            endValue: endDate,
                                            minorTickInterval: "day",
                                            majorTickInterval: 'week',
                                            minRange: "day",
                                            showMinorTicks: false
                                        },
                                        sliderMarker: {
                                            color: '#ff400d',
                                            format: "monthAndDay"
                                        },
                                        selectedRange: {
                                            startValue: startDate,
                                            endValue: endDate
                                        },
                                        onSelectedRangeChanged: function (e) {
                                            tab.UpdateActivityChart(e.startValue, e.endValue);
                                        }
                                    });
                                },
                                ShowTab: function (name) {
                                    this.AgentName = name;
                                    var range = this.DateRange();
                                    var selectedRange = range.getSelectedRange();
                                    this.UpdateActivityChart(selectedRange.startValue, selectedRange.endValue);
                                    this.LoadStatusChart();
                                },
                                LoadAgentActivityDs: function (startDate, endDate) {
                                    var url = "/wcfdataservices/portalReportservice.svc/LoadAgentSummaryReport/" + this.AgentName + "/" + startDate.toLocaleDateString().replace(/\//g, "-") + "/" + endDate.toLocaleDateString().replace(/\//g, "-");
                                    this.ActivityDataSource = new DevExpress.data.DataSource(url);
                                    this.LeadsDataSource = new DevExpress.data.DataSource("/wcfdataservices/portalReportservice.svc/LoadAgentLeadsReport/" + this.AgentName);
                                },
                                UpdateActivityChart: function (startDate, endDate) {
                                    var chart = this.BarChart();
                                    chart.showLoadingIndicator();
                                    this.LoadAgentActivityDs(startDate, endDate);
                                    chart.beginUpdate();
                                    chart.option("dataSource", this.ActivityDataSource);
                                    chart.endUpdate();
                                    //this.LoadStatusChart();
                                },
                                LoadStatusChart: function () {
                                    var option = {
                                        dataSource: this.LeadsDataSource,
                                        tooltip: {
                                            enabled: true,
                                            percentPrecision: 0,
                                            customizeText: function (arg) {
                                                return {
                                                    text: arg.argumentText + " (" + arg.percentText + ")"
                                                };
                                            }
                                        },
                                        legend: {
                                            visible: true,
                                            verticalAlignment: "bottom",
                                            horizontalAlignment: "center"
                                        },
                                        series: [{
                                            type: "doughnut",
                                            argumentField: "Status",
                                            valueField: "Count",
                                            tagField: "StatusKey",
                                            label: {
                                                visible: true,
                                                connector: {
                                                    visible: true
                                                }
                                            }
                                        }],
                                        title: {
                                            text: "Leads Status",
                                            font: {
                                                family: 'Source Sans Pro, sans-serif',
                                                size: 21,
                                                weight: 900
                                            },
                                            horizontalAlignment: 'left',
                                            margin: {
                                                left: 20
                                            }
                                        },
                                        palette: ['#a5bcd7', '#e97c82', '#da5859', '#f09777', '#fbc986', '#a5d7d0', '#a5bcd7']
                                    };

                                    $("#ProcessStatusChart").dxPieChart(option);
                                },

                                Render: function () {
                                    this.InitalTab();
                                    var name = $("#spanUserName").html();
                                    this.ShowTab(name);
                                }
                            };

                            function show_chart_modal() {

                                $('#chart-modal').on('shown.bs.modal', function (event) {
                                    agentSummaryReport.Render();
                                    debugger;
                                }).modal('show')
                            }



                        </script>
                    </div>

                </dx:SplitterContentControl>
            </ContentCollection>
        </dx:SplitterPane>
    </Panes>
</dx:ASPxSplitter>

<%--change it to color sytle by steven--%>
<div id="right-pane-container" class="clearfix" style="display: none">
    <div id="right-pane-button" style="margin-top: 125px"></div>
    <div id="right-pane">
        <div style="width: 290px; height: 100%; background: #EFF2F5;">
            <%--/*the showlder box*--%>
            <div style="width: 30px; height: 100%; float: left; position: relative; left: 0px; top: 0px; box-shadow: inset 20px -10px 13px -15px rgba(2, 2, 2, 0.3);"></div>
            <div style="width: 100%; height: 100%;">
                <div style="height: 70px;">
                    <div style="color: #b2b4b7; padding-top: 35px; margin-left: 26px; font-size: 30px; font-weight: 300;">Notes</div>
                </div>
                <dx:ASPxCallbackPanel runat="server" ID="notesCallbackPanel" ClientInstanceName="notesCallbackPanel" OnCallback="notesCallbackPanel_Callback">
                    <PanelCollection>
                        <dx:PanelContent>
                            <div style="background: #f53e0d; color: white; min-height: 270px; margin-top: 35px">
                                <div style="margin-left: 30px; margin-right: 15px; padding-bottom: 30px">
                                    <h2 style="font-size: 30px; font-weight: 400; margin: 0px; padding-top: 35px; padding-bottom: 35px;">
                                        <dx:ASPxMemo runat="server" ID="txtTitle" CssClass="notesTitleStyle" BackColor="Transparent" Border-BorderColor="Transparent" Font-Size="30px" ForeColor="White" NullText="Input Title" Height="35px" MaxLength="50">
                                            <ClientSideEvents KeyDown="OnNotesKeyDown" Init="function(s,e){
                                                                                        s.GetInputElement().style.overflowY='hidden';
                                                                                        OnNotesKeyDown(s,e);}"
                                                GotFocus="function(s,e){ShowBorder(s);}" LostFocus="function(s,e){ShowBorder(s);}" />
                                        </dx:ASPxMemo>
                                    </h2>
                                    <div style="font-size: 14px; line-height: 24px; background: transparent !important; margin-bottom: 0px">
                                        <dx:ASPxMemo runat="server" ID="txtNotesDescription" Border-BorderStyle="solid" Border-BorderColor="Transparent" BackColor="Transparent" Font-Size="14px" ForeColor="White" Width="100%" Height="13px" NullText="Description">
                                            <ClientSideEvents KeyDown="OnNotesKeyDown" Init="function(s,e){
                                                                                        s.GetInputElement().style.overflowY='hidden';
                                                                                        OnNotesKeyDown(s,e);                                                               
                                                                                    }"
                                                GotFocus="function(s,e){ShowBorder(s);}" LostFocus="function(s,e){ShowBorder(s);}" />
                                        </dx:ASPxMemo>
                                    </div>
                                    <div style="padding-top: 40px; font-size: 24px; color: white">
                                        <i class="fa fa-check-circle icon_btn" onclick="notesCallbackPanel.PerformCallback('Save|<%= CurrentNote.NoteId%>')"></i>
                                        <i class="fa fa-times-circle icon_btn button_margin" style="display: none"></i>
                                        <i class="fa fa-trash-o icon_btn button_margin" onclick='notesCallbackPanel.PerformCallback("Delete|<%= CurrentNote.NoteId%>")'></i>
                                    </div>
                                </div>
                            </div>
                            <div style="margin-top: 10px; margin-left: -35px; font-size: 18px">
                                <ul>
                                    <% For Each note In PortalNotes%>
                                    <li class="right_palne_menu" style="cursor: pointer" onclick="notesCallbackPanel.PerformCallback('Show|<%= note.NoteId%>')"><%= note.Title%>
                                    </li>
                                    <%Next%>
                                </ul>
                            </div>
                        </dx:PanelContent>
                    </PanelCollection>
                </dx:ASPxCallbackPanel>
                <i class="fa fa-plus-circle icon_btn" style="color: #999ca1; font-size: 24px" onclick="notesCallbackPanel.PerformCallback('Add')"></i>
            </div>
        </div>
    </div>
</div>
