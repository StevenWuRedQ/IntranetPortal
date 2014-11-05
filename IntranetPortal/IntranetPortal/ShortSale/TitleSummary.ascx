<%@ Control Language="vb" AutoEventWireup="false" CodeBehind="TitleSummary.ascx.vb" Inherits="IntranetPortal.UCTitleSummary" %>
<%@ Register Src="~/UserControl/Devexpress/CustomVerticalAppointmentTemplate.ascx" TagName="CustomVerticalAppointmentTemplate" TagPrefix="uc1" %>
<%@ Register Src="~/UserControl/LeadsSubMenu.ascx" TagPrefix="uc1" TagName="LeadsSubMenu" %>
<%@ Register Src="~/ShortSale/ShortSaleSubMenu.ascx" TagPrefix="uc1" TagName="ShortSaleSubMenu" %>

<link rel="stylesheet" href="/scrollbar/jquery.mCustomScrollbar.css" />
<script src="/scrollbar/jquery.mCustomScrollbar.concat.min.js"></script>
<script src="/scrollbar/jquery.mCustomScrollbar.js"></script>
<link rel="stylesheet" href="/css/right-pane.css" />
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
            tbl.style.borderColor = "white";
            tbl.style.backgroundColor = 'transparent';
        }
        else {
            tbl.style.borderColor = 'transparent';
            tbl.style.backgroundColor = 'transparent';
        }
    }
    function initScrollbar_summary() {

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

    function ShowCaseInfo(CaseId) {
        var url = '/ShortSale/ShortSale.aspx?CaseId=' + CaseId;
        var left = (screen.width / 2) - (1350 / 2);
        var top = (screen.height / 2) - (930 / 2);
        debugger;
        window.open(url, 'View Case Info ' + CaseId, 'Width=1350px,Height=930px, top=' + top + ', left=' + left);
    }

    function GoToCase(CaseId) {
        var url = '/ShortSale/ShortSale.aspx?ShowList=1&CaseId=' + CaseId;
        window.location.href = url;
    }

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
        padding-top: 40px;
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


    .dxgvFocusedGroupRow_MetropolisBlue {
        border-bottom: 0px !important;
    }

    /*.dxgvDataRowAlt_Portal {
        background-color: #eff2f5 !important;
    }*/
    /*-------end-------------*/

    /*td.dxgv {
        border-bottom: 0px !important;
    }*/

    
    /*

        */
   

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

    .top_h4 {
        padding: 0px;
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
                    <div style="display: inline-table; font-family: 'Source Sans Pro'; margin-left: 19px; margin-top: 15px;">
                        <div style="float: left; font-weight: 300; font-size: 48px; color: #234b60">
                            <span style="text-transform: capitalize"></span>Summary &nbsp;
                        </div>
                    </div>
                    <%------end------%>
                    <div style="margin-right: 10px; margin-left: 35px; min-width: 1200px;">
                        <table style="vertical-align: top;">
                            <tr style="height: 240px;" class="under_line_div ">
                                <%--fix the disteance between the two grid by steven--%>
                                <td style="width: 300px; vertical-align: top;">
                                    <%--add icon by steven--%>
                                    <h4 class="top_h4">
                                        <i class="fa fa-exclamation-triangle with_circle title_summary_icon" style=""></i><span class="heading_text2">Urgent</span>
                                    </h4>
                                    <div class="div-underline " style="height: 260px;">
                                        <dx:ASPxGridView runat="server" Width="100%" ID="gridUrgent" KeyFieldName="BBLE" Settings-ShowColumnHeaders="false" Settings-GridLines="None" Border-BorderStyle="None" Paddings-PaddingTop="10px" SettingsPager-PageSize="6">
                                            <Columns>
                                                <dx:GridViewDataTextColumn FieldName="LeadsName" Settings-AllowHeaderFilter="False" VisibleIndex="1">
                                                    <DataItemTemplate>
                                                        <div class="group_lable" onclick='<%# String.Format("GoToCase(""{0}"")", Eval("CaseId"))%>'>
                                                        <%# HtmlBlackInfo(Eval("CaseName"))%></div>
                                                    </DataItemTemplate>
                                                </dx:GridViewDataTextColumn>
                                                <dx:GridViewDataColumn Width="40px" VisibleIndex="5" EditCellStyle-BorderLeft-BorderStyle="Solid">
                                                    <DataItemTemplate>
                                                        <%--change the image and the size by steven--%>
                                                        <img src="/images/menu_flag.png" style="/*width: 16px; height: 16px; */vertical-align: bottom; cursor: pointer;" onclick="<%#String.Format("ShowCateMenu(this,{0},'{1}')", Eval("CaseId"), Eval("BBLE"))%>" />
                                                    </DataItemTemplate>
                                                </dx:GridViewDataColumn>
                                            </Columns>
                                            <GroupSummary>
                                                <dx:ASPxSummaryItem SummaryType="Count" />
                                            </GroupSummary>
                                            <SettingsBehavior EnableRowHotTrack="True" ColumnResizeMode="NextColumn" AutoExpandAllGroups="true" />
                                            <Styles>
                                                <AlternatingRow BackColor="#eff2f5"></AlternatingRow>
                                                <RowHotTrack BackColor="#ff400d" ForeColor="White"></RowHotTrack>
                                            </Styles>
                                        </dx:ASPxGridView>
                                    </div>
                                </td>
                                <td rowspan="3" style="width: 30px;"></td>
                                <td style="width: 300px; vertical-align: top;" class="gray_background">
                                    <%--add icon by steven--%>
                                    <h4 class="top_h4">
                                        <i class="fa fa-university with_circle title_summary_icon" style=""></i><span class="heading_text2">Upcoming BPO's</span>
                                    </h4>
                                    <div class="div-underline " style="height: 240px;">
                                        <dx:ASPxGridView runat="server" Width="100%" ID="gridUpcomingApproval" ClientInstanceName="gridPriorityClient" KeyFieldName="BBLE" Settings-ShowColumnHeaders="false" Settings-GridLines="None" Border-BorderStyle="None" Paddings-PaddingTop="10px" SettingsPager-PageSize="4">
                                            <Columns>
                                                <dx:GridViewDataTextColumn FieldName="CaseName" Settings-AllowHeaderFilter="False" VisibleIndex="1">
                                                    <DataItemTemplate>
                                                        <div style="cursor: pointer; height: 40px; padding-left: 20px; line-height: 40px;" onclick='<%# String.Format("GoToCase(""{0}"")",Eval("CaseId"))%>'><%# HtmlBlackInfo(Eval("CaseName"))%></div>
                                                    </DataItemTemplate>
                                                </dx:GridViewDataTextColumn>
                                                <dx:GridViewDataColumn Width="40px" VisibleIndex="5" EditCellStyle-BorderLeft-BorderStyle="Solid">
                                                    <DataItemTemplate>
                                                        <div class="hidden_icon">
                                                            <i class="fa fa-list-alt employee_list_item_icon" style="width: 30px" onclick="<%#String.Format("ShowCateMenu(this,{0},'{1}')", Eval("CaseId"), Eval("BBLE"))%>"></i>
                                                        </div>
                                                    </DataItemTemplate>
                                                </dx:GridViewDataColumn>
                                            </Columns>
                                            <SettingsBehavior EnableRowHotTrack="True" ColumnResizeMode="NextColumn" />
                                            <Styles>
                                                <AlternatingRow BackColor="#eff2f5"></AlternatingRow>
                                                <RowHotTrack BackColor="#ff400d"></RowHotTrack>
                                            </Styles>
                                        </dx:ASPxGridView>
                                    </div>
                                </td>
                                <td rowspan="5" style="width: 30px;"></td>

                                <td style="width: 300px; vertical-align: top;">
                                    <%--add icon by steven--%>
                                    <h4 class="top_h4">
                                        <i class="fa fa-check with_circle title_summary_icon" style=""></i><span class="heading_text2">Counter Offer</span>
                                    </h4>
                                    <div class="div-underline " style="height: 240px;">
                                        <dx:ASPxGridView runat="server" Width="100%" ID="CounterOfferGrid" KeyFieldName="CaseId" Settings-ShowColumnHeaders="false" Settings-GridLines="None" Border-BorderStyle="None" Paddings-PaddingTop="10px" SettingsPager-PageSize="6">
                                            <Columns>
                                                <dx:GridViewDataTextColumn FieldName="LeadsName" Settings-AllowHeaderFilter="False" VisibleIndex="1">
                                                    <DataItemTemplate>
                                                        <div class="group_lable" onclick='<%# String.Format("GoToCase(""{0}"")", Eval("CaseId"))%>'><%# HtmlBlackInfo(Eval("LeadsName"))%></div>
                                                    </DataItemTemplate>
                                                </dx:GridViewDataTextColumn>
                                                <dx:GridViewDataTextColumn FieldName="ScheduleDate" PropertiesTextEdit-DisplayFormatString="d" VisibleIndex="2" Settings-SortMode="Custom">
                                                    <GroupRowTemplate>
                                                        <div>
                                                            <table>
                                                                <tr>
                                                                    <td>
                                                                        <img src="../images/grid_call_backs_canlender.png" /></td>
                                                                    <td style="font-weight: 900; width: 80px; text-align: center;">Date: <%# Container.GroupText%></td>
                                                                    <td style="padding-left: 10px">
                                                                        <div class="raund-label">
                                                                            <%#  Container.SummaryText.Replace("Count=", "").Replace("(","").Replace(")","") %>
                                                                        </div>
                                                                    </td>
                                                                    <%--the round div--%>
                                                                </tr>
                                                            </table>
                                                        </div>
                                                    </GroupRowTemplate>
                                                </dx:GridViewDataTextColumn>
                                                <dx:GridViewDataColumn Width="40px" VisibleIndex="5" EditCellStyle-BorderLeft-BorderStyle="Solid">
                                                    <DataItemTemplate>
                                                        <%--change the image and the size by steven--%>
                                                        <img src="/images/menu_flag.png" style="/*width: 16px; height: 16px; */vertical-align: bottom; cursor: pointer;" onclick="<%#String.Format("ShowCateMenu(this,{0},'{1}')", Eval("CaseId"), Eval("BBLE"))%>" />
                                                    </DataItemTemplate>
                                                </dx:GridViewDataColumn>
                                            </Columns>
                                            <GroupSummary>
                                                <dx:ASPxSummaryItem SummaryType="Count" />
                                            </GroupSummary>
                                            <SettingsBehavior EnableRowHotTrack="True" ColumnResizeMode="NextColumn" AutoExpandAllGroups="true" />
                                            <Styles>
                                                <AlternatingRow BackColor="#eff2f5"></AlternatingRow>
                                                <RowHotTrack BackColor="#ff400d" ForeColor="White"></RowHotTrack>
                                            </Styles>
                                        </dx:ASPxGridView>
                                    </div>
                                </td>

                                <td rowspan="3" style="width: 30px;"></td>



                                <td style="width: 300px; vertical-align: top;" class="gray_background">
                                    <%--add icon by steven--%>
                                    <h4 class="top_h4">
                                        <i class="fa fa-thumbs-up with_circle title_summary_icon" style=""></i><span class="heading_text2">Investor Review</span>
                                    </h4>
                                    <div class="div-underline " style="height: 240px;">
                                        <dx:ASPxGridView runat="server" Width="100%" ID="InvestorReviewGrid" KeyFieldName="CaseId" Settings-ShowColumnHeaders="false" Settings-GridLines="None" Border-BorderStyle="None" Paddings-PaddingTop="10px" SettingsPager-PageSize="6">
                                            <Columns>
                                                <dx:GridViewDataTextColumn FieldName="LeadsName" Settings-AllowHeaderFilter="False" VisibleIndex="1">
                                                    <DataItemTemplate>
                                                        <div class="group_lable" onclick='<%# String.Format("GoToCase(""{0}"")", Eval("CaseId"))%>'><%# HtmlBlackInfo(Eval("LeadsName"))%></div>
                                                    </DataItemTemplate>
                                                </dx:GridViewDataTextColumn>
                                                <dx:GridViewDataTextColumn FieldName="ScheduleDate" PropertiesTextEdit-DisplayFormatString="d" VisibleIndex="2" Settings-SortMode="Custom">
                                                    <GroupRowTemplate>
                                                        <div>
                                                            <table>
                                                                <tr>
                                                                    <td>
                                                                        <img src="../images/grid_call_backs_canlender.png" /></td>
                                                                    <td style="font-weight: 900; width: 80px; text-align: center;">Date: <%# Container.GroupText%></td>
                                                                    <td style="padding-left: 10px">
                                                                        <div class="raund-label">
                                                                            <%#  Container.SummaryText.Replace("Count=", "").Replace("(","").Replace(")","") %>
                                                                        </div>
                                                                    </td>
                                                                    <%--the round div--%>
                                                                </tr>
                                                            </table>
                                                        </div>
                                                    </GroupRowTemplate>
                                                </dx:GridViewDataTextColumn>
                                                <dx:GridViewDataColumn Width="40px" VisibleIndex="5" EditCellStyle-BorderLeft-BorderStyle="Solid">
                                                    <DataItemTemplate>
                                                        <%--change the image and the size by steven--%>
                                                        <img src="/images/menu_flag.png" style="/*width: 16px; height: 16px; */vertical-align: bottom; cursor: pointer;" onclick="<%#String.Format("ShowCateMenu(this,{0},'{1}')", Eval("CaseId"), Eval("BBLE"))%>" />
                                                    </DataItemTemplate>
                                                </dx:GridViewDataColumn>
                                            </Columns>
                                            <GroupSummary>
                                                <dx:ASPxSummaryItem SummaryType="Count" />
                                            </GroupSummary>
                                            <SettingsBehavior EnableRowHotTrack="True" ColumnResizeMode="NextColumn" AutoExpandAllGroups="true" />
                                            <Styles>
                                                <AlternatingRow BackColor="#eff2f5"></AlternatingRow>
                                                <RowHotTrack BackColor="#ff400d" ForeColor="White"></RowHotTrack>
                                            </Styles>
                                        </dx:ASPxGridView>
                                    </div>
                                </td>
                                <td rowspan="5" style="width: 30px;"></td>
                                <td style="width: 300px; vertical-align: top;">
                                    <%--add icon by steven--%>
                                    <h4 class="top_h4">
                                        <i class="fa fa-files-o with_circle title_summary_icon" style=""></i><span class="heading_text2">Document Requests</span>
                                    </h4>
                                    <div class="div-underline " style="height: 240px;">
                                        <dx:ASPxGridView runat="server" Width="100%" ID="DocumentRequestsGrid" KeyFieldName="CaseId" Settings-ShowColumnHeaders="false" Settings-GridLines="None" Border-BorderStyle="None" Paddings-PaddingTop="10px" SettingsPager-PageSize="6">
                                            <Columns>
                                                <dx:GridViewDataTextColumn FieldName="LeadsName" Settings-AllowHeaderFilter="False" VisibleIndex="1">
                                                    <DataItemTemplate>
                                                        <div class="group_lable" onclick='<%# String.Format("GoToCase(""{0}"")", Eval("CaseId"))%>'><%# HtmlBlackInfo(Eval("LeadsName"))%></div>
                                                    </DataItemTemplate>
                                                </dx:GridViewDataTextColumn>
                                                <dx:GridViewDataTextColumn FieldName="ScheduleDate" PropertiesTextEdit-DisplayFormatString="d" VisibleIndex="2" Settings-SortMode="Custom">
                                                    <GroupRowTemplate>
                                                        <div>
                                                            <table>
                                                                <tr>
                                                                    <td>
                                                                        <img src="../images/grid_call_backs_canlender.png" /></td>
                                                                    <td style="font-weight: 900; width: 80px; text-align: center;">Date: <%# Container.GroupText%></td>
                                                                    <td style="padding-left: 10px">
                                                                        <div class="raund-label">
                                                                            <%#  Container.SummaryText.Replace("Count=", "").Replace("(","").Replace(")","") %>
                                                                        </div>
                                                                    </td>
                                                                    <%--the round div--%>
                                                                </tr>
                                                            </table>
                                                        </div>
                                                    </GroupRowTemplate>
                                                </dx:GridViewDataTextColumn>
                                                <dx:GridViewDataColumn Width="40px" VisibleIndex="5" EditCellStyle-BorderLeft-BorderStyle="Solid">
                                                    <DataItemTemplate>
                                                        <%--change the image and the size by steven--%>
                                                        <img src="/images/menu_flag.png" style="/*width: 16px; height: 16px; */vertical-align: bottom; cursor: pointer;" onclick="<%#String.Format("ShowCateMenu(this,{0},'{1}')", Eval("CaseId"), Eval("BBLE"))%>" />
                                                    </DataItemTemplate>
                                                </dx:GridViewDataColumn>
                                            </Columns>
                                            <GroupSummary>
                                                <dx:ASPxSummaryItem SummaryType="Count" />
                                            </GroupSummary>
                                            <SettingsBehavior EnableRowHotTrack="True" ColumnResizeMode="NextColumn" AutoExpandAllGroups="true" />
                                            <Styles>
                                                <AlternatingRow BackColor="#eff2f5"></AlternatingRow>
                                                <RowHotTrack BackColor="#ff400d" ForeColor="White"></RowHotTrack>
                                            </Styles>
                                        </dx:ASPxGridView>
                                    </div>
                                </td>
                                <td rowspan="5" style="width: 30px;"></td>

                                <td rowspan="3" style="vertical-align: top; width: 380px; display: none">
                                    <h4 class="top_h4">
                                        <img src="../images/grid_calendar.png" class="vertical-img" /><span class="heading_text">Today's Calendar</span>

                                    </h4>
                                    <div style="height: 615px; margin-top: 60px">
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
                                                    </CustomFieldMappings>
                                                </Appointments>
                                            </Storage>
                                        </dx:ASPxScheduler>
                                    </div>
                                </td>


                                <td rowspan="4" style="width: 0px; display: none"></td>
                            </tr>
                            <tr style="height: 240px; display: none">
                                <td style="vertical-align: top" class="under_line">
                                    <h4>
                                        <img src="../images/grid_task_icon.png" class="vertical-img" /><span class="heading_text">Task</span> </h4>
                                    <div class="div-underline">
                                        <dx:ASPxGridView runat="server" Width="100%" ID="gridTask" KeyFieldName="BBLE" ClientInstanceName="gridTaskClient" Settings-ShowColumnHeaders="false" Settings-GridLines="None" Border-BorderStyle="None" Paddings-PaddingTop="10px" SettingsPager-PageSize="6">
                                            <Columns>
                                                <dx:GridViewDataTextColumn FieldName="LeadsName" Settings-AllowHeaderFilter="False" VisibleIndex="1">
                                                    <DataItemTemplate>
                                                        <div class="group_lable" onclick='<%# String.Format("NavigateURL(""{0}"",""{1}"")", "Task", Eval("BBLE"))%>'><%# HtmlBlackInfo(Eval("LeadsName"))%></div>
                                                    </DataItemTemplate>
                                                </dx:GridViewDataTextColumn>
                                                <dx:GridViewDataTextColumn FieldName="ScheduleDate" PropertiesTextEdit-DisplayFormatString="d" VisibleIndex="2" Settings-SortMode="Custom">
                                                    <GroupRowTemplate>
                                                        <%--Date: <%# Container.GroupText & Container.SummaryText.Replace("Count=", "")%>--%>
                                                        <%--change group template UI by steven--%>
                                                        <grouprowtemplate>
                                                        <div >
                                                            <table>
                                                                <tr>
                                                                  <td><img src="../images/grid_call_backs_canlender.png"/></td>
                                                                <td style="font-weight:900;width:80px;text-align:center;"> Date: <%# Container.GroupText%></td>
                                                                <td style="padding-left: 10px">
                                                                    <div  class="raund-label">
                                                                     <%#  Container.SummaryText.Replace("Count=", "").Replace("(","").Replace(")","") %>
                                                                    </div>
                                                                </td>
                                                            <%--the round div--%>
                                    
                                                                </tr>
                                                                </table>
                                                        </div>
                                
                                                       </grouprowtemplate>
                                                        <%-------end---------%>
                                                    </GroupRowTemplate>
                                                </dx:GridViewDataTextColumn>
                                                <dx:GridViewDataColumn Width="40px" VisibleIndex="5" EditCellStyle-BorderLeft-BorderStyle="Solid">
                                                    <DataItemTemplate>
                                                        <%--change the image and the size by steven--%>
                                                        <img src="/images/menu_flag.png" style="/*width: 16px; height: 16px; */vertical-align: bottom; cursor: pointer;" onclick='<%#String.Format("ShowCateMenu(this,{0})", Eval("BBLE")) %>' />
                                                    </DataItemTemplate>
                                                </dx:GridViewDataColumn>
                                            </Columns>
                                            <GroupSummary>
                                                <dx:ASPxSummaryItem SummaryType="Count" />
                                            </GroupSummary>
                                            <SettingsBehavior EnableRowHotTrack="True" ColumnResizeMode="NextColumn" AutoExpandAllGroups="true" />
                                            <Styles>
                                                <AlternatingRow BackColor="#eff2f5"></AlternatingRow>
                                                <RowHotTrack BackColor="#ff400d" ForeColor="White"></RowHotTrack>
                                            </Styles>
                                        </dx:ASPxGridView>
                                    </div>
                                </td>
                                <td style="vertical-align: top" class="under_line">
                                    <%--add icon by steven--%>
                                    <h4>
                                        <img src="../images/grid_call_back_icon.png" class="vertical-img" /><span class="heading_text">Follow Up</span> </h4>
                                    <%--------end-------%>
                                    <div class="div-underline">
                                        <dx:ASPxGridView runat="server" Width="100%" ID="gridCallback" ClientInstanceName="gridCallbackClient" KeyFieldName="BBLE" AutoGenerateColumns="false" Settings-ShowColumnHeaders="false" Settings-GridLines="None" Border-BorderStyle="None" Paddings-PaddingTop="10px" SettingsPager-PageSize="6">
                                            <Columns>
                                                <dx:GridViewDataTextColumn FieldName="CaseName" Settings-AllowHeaderFilter="False" VisibleIndex="1" CellStyle-CssClass="cell_hover">
                                                    <DataItemTemplate>
                                                        <div class="group_lable" onclick='<%# String.Format("NavigateURL(""{0}"",""{1}"")", "Call Back", Eval("BBLE"))%>'><%# HtmlBlackInfo(Eval("CaseName"))%></div>
                                                    </DataItemTemplate>
                                                </dx:GridViewDataTextColumn>
                                                <dx:GridViewDataTextColumn FieldName="UpdateDate" VisibleIndex="2" Visible="false" Settings-SortMode="Custom">
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
                                                                        <div class="raund-label">
                                                                            <%#  Container.SummaryText.Replace("Count=", "").Replace("(","").Replace(")","") %>
                                                                        </div>
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
                                            <GroupSummary>
                                                <dx:ASPxSummaryItem FieldName="CallbackDate" SummaryType="Count" />
                                            </GroupSummary>
                                        </dx:ASPxGridView>
                                    </div>
                                </td>
                            </tr>
                            <tr>
                                <td colspan="10" style="border-bottom: 3px solid white">
                                    <div style="max-width: 1570px;margin-right:30px;">
                                        <div class="clearfix" style="margin-bottom: 20px;">
                                            <h4 style="padding-top: 20px">
                                                <i class="fa fa-folder-open with_circle title_summary_icon" style=""></i><span class="heading_text2"><%--Leads and Active--%> Files</span>
                                                <%--<span class="table_tips" style="margin-left: 40px;">Shows all files that haven’t closed or been archived.
                                                </span>--%>

                                            </h4>
                                            <%--margin-top: -35px;--%>
                                            <div style="float: right; margin-top: -35px;" class="form-inline">

                                                <input style="margin-right: 20px; width: 250px; height: 30px;" class="form-control" runat="server" id="QuickSearch" placeholder="Quik Search">
                                                <asp:LinkButton ID="SearchBtn" OnClick="SearchBtn_Click" runat="server" Text='<i class="fa fa-search tooltip-examples icon_btn grid_buttons" style="margin-right: 20px"></i>'></asp:LinkButton>

                                                <%-- <i class="fa fa-filter tooltip-examples icon_btn grid_buttons" style="margin-right: 40px"></i>--%>
                                                <asp:LinkButton ID="ExportExcel" OnClick="ExportExcel_Click" runat="server" Text='<i class="fa fa-file-excel-o report_head_button report_head_button_padding tooltip-examples" ></i>'></asp:LinkButton>
                                                <asp:LinkButton ID="ExportPdf" OnClick="ExportPdf_Click" runat="server" Text='<i class="fa fa-file-pdf-o report_head_button report_head_button_padding tooltip-examples" style="margin-right: 40px;"></i>'></asp:LinkButton>
                                            </div>
                                            <dx:ASPxGridView ID="AllLeadsGrid" runat="server" ClientInstanceName="AllLeadsGridClient" SettingsPager-PageSize="6" KeyFieldName="CaseId" Width="100%" Settings-VerticalScrollBarMode="Auto" Settings-VerticalScrollableHeight="300" ForeColor="#b1b2b7">
                                                <Styles>

                                                    <Row CssClass="summary_row">
                                                    </Row>
                                                </Styles>
                                                <Columns>
                                                    <dx:GridViewDataTextColumn FieldName="PropertyInfo.StreetName" Caption="Street address" SortOrder="Ascending">
                                                        <DataItemTemplate>
                                                            <div style="cursor: pointer" class="font_black" onclick='<%# String.Format("ShowCaseInfo({0})", Eval("CaseId"))%>'><%# GetAddress(CType(Container.Grid.GetRow(Container.VisibleIndex), IntranetPortal.ShortSale.ShortSaleCase))%></div>
                                                        </DataItemTemplate>
                                                    </dx:GridViewDataTextColumn>
                                                    <dx:GridViewDataTextColumn FieldName="Owner" Caption="Name">
                                                    </dx:GridViewDataTextColumn>
                                                    <dx:GridViewDataTextColumn FieldName="OccupiedBy" Caption="Occupancy">
                                                    </dx:GridViewDataTextColumn>
                                                    <dx:GridViewDataTextColumn FieldName="FristMortageProgress" Caption="1st Mortgage Progress">
                                                    </dx:GridViewDataTextColumn>
                                                    <dx:GridViewDataTextColumn FieldName="FristMortageLender" Caption="Servicer (1st Mort)">
                                                    </dx:GridViewDataTextColumn>
                                                    <dx:GridViewDataTextColumn FieldName="SencondMortageProgress" Caption="2nd Mortgage Progress">
                                                    </dx:GridViewDataTextColumn>
                                                    <dx:GridViewDataTextColumn FieldName="SencondMortageLender" Caption="Servicer (2nd Mort)">
                                                    </dx:GridViewDataTextColumn>
                                                    <%--<dx:GridViewDataTextColumn FieldName="PropertyInfo.City"  Caption="Office Price">                                                 
                                                </dx:GridViewDataTextColumn>--%>
                                                    <dx:GridViewDataTextColumn FieldName="ProcessorContact.Name" Caption="Processor">
                                                    </dx:GridViewDataTextColumn>
                                                    <dx:GridViewDataTextColumn FieldName="ListingAgentContact.Name" Caption="Listing agent">
                                                    </dx:GridViewDataTextColumn>
                                                    <dx:GridViewDataTextColumn FieldName="PropertyInfo.UpdateDate" Caption="Last Activity">
                                                        <DataItemTemplate>
                                                            <%# GetLastActivity(CType(Container.Grid.GetRow(Container.VisibleIndex), IntranetPortal.ShortSale.ShortSaleCase))%>
                                                        </DataItemTemplate>
                                                    </dx:GridViewDataTextColumn>
                                                    <%--<dx:GridViewDataTextColumn FieldName="PropertyInfo.City" Caption="Next Task" >                                                 
                                                </dx:GridViewDataTextColumn>--%>
                                                </Columns>
                                                <Settings ShowFooter="True" ShowHeaderFilterButton="true" />
                                                <SettingsPager>
                                                    <PageSizeItemSettings Visible="true"></PageSizeItemSettings>
                                                </SettingsPager>
                                                <SettingsPopup>
                                                    <HeaderFilter Height="200" />
                                                </SettingsPopup>
                                            </dx:ASPxGridView>
                                            <dx:ASPxGridViewExporter ID="AllLeadGridViewExporter" runat="server" GridViewID="AllLeadsGrid"></dx:ASPxGridViewExporter>

                                        </div>
                                    </div>
                                </td>
                            </tr>
                        </table>
                    </div>
                </dx:SplitterContentControl>
            </ContentCollection>
        </dx:SplitterPane>
        <dx:SplitterPane Size="290px" MinSize="280px" Visible="false">
            <PaneStyle BackColor="#EFF2F5"></PaneStyle>
            <Separator Visible="False"></Separator>
            <ContentCollection>
                <dx:SplitterContentControl>
                    <div style="width: 290px; height: 100%; background: #EFF2F5;">
                        <%--/*the showlder box*--%>
                        <div style="width: 30px; height: 100%; float: left; position: relative; left: 0px; top: 0px; box-shadow: inset 20px -10px 13px -15px rgba(2, 2, 2, 0.3);"></div>
                    </div>
                </dx:SplitterContentControl>
            </ContentCollection>
        </dx:SplitterPane>
    </Panes>
</dx:ASPxSplitter>
<uc1:ShortSaleSubMenu runat="server" ID="ShortSaleSubMenu" />
<div id="right-pane-container" class="clearfix">
    <div id="right-pane-button"></div>
    <div id="right-pane">
        <div style="height: 100%; background: #EFF2F5;">
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
                                        <i class="fa fa-times-circle icon_btn note_button_margin" style="display: none"></i>
                                        <i class="fa fa-trash-o icon_btn note_button_margin" onclick='notesCallbackPanel.PerformCallback("Delete|<%= CurrentNote.NoteId%>")'></i>
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
                <i class="fa fa-plus-circle icon_btn" style="color: #999ca1; font-size: 24px; margin-left: 20px" onclick="notesCallbackPanel.PerformCallback('Add')"></i>
            </div>
        </div>
    </div>
</div>
<script src="/scripts/js/right_pane.js" type="text/javascript"></script>
<%--change it to color sytle by steven--%>
