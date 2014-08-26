<%@ Control Language="vb" AutoEventWireup="false" CodeBehind="UserSummary.ascx.vb" Inherits="IntranetPortal.UserSummary" %>
<%@ Register Src="~/UserControl/Devexpress/CustomVerticalAppointmentTemplate.ascx" TagName="CustomVerticalAppointmentTemplate" TagPrefix="uc1" %>
<%@ Register Src="~/UserControl/LeadsSubMenu.ascx" TagPrefix="uc1" TagName="LeadsSubMenu" %>

<uc1:LeadsSubMenu runat="server" ID="LeadsSubMenu" />

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

    /*@import url(http://fonts.googleapis.com/css?family=PT+Serif:400,400italic);*/

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
    .auto-style1 {
        width: 400px;
    }

    td.dxgv {
        border-bottom: 0px !important;
    }

    td.dxgvIndentCell {
        border-right: 3px Solid #dde0e7 !important;
    }

    td.under_line {
        border-bottom: 3px solid #dde0e7;
    }

    td.grid_padding {
        padding-top: 20px;
    }
</style>

<dx:ASPxSplitter ID="contentSplitter" PaneStyle-BackColor="#f9f9f9" runat="server" Height="100%" Width="100%" ClientInstanceName="contentSplitter" FullscreenMode="true">
    <Styles>
        <Pane Paddings-Padding="0">
            <Paddings Padding="0px"></Paddings>
        </Pane>
    </Styles>
    <Panes>
        <dx:SplitterPane>
            <ContentCollection>
                <dx:SplitterContentControl>
                    <div style="display: inline-table; font-family: 'Source Sans Pro'; margin-left: 19px; margin-top: 15px;">
                        <div style="float: left; font-weight: 300; font-size: 48px; color: #234b60">
                            <%= Page.User.Identity.Name %>'s Summary &nbsp;
                        </div>
                        <div align="center" style="background-color: #ff400d;" class="label-summary-info">
                            <table>
                                <tr>
                                    <td style="font-weight: 900">
                                        <%= IntranetPortal.Utility.TotalLeadsCount %>
                                    </td>
                                    <td style="font-weight: 200">&nbsp;Leads
                                    </td>
                                </tr>
                            </table>
                        </div>
                        <div align="center" style="background-color: #1a3847; margin-left: 10px;" class="label-summary-info">
                            <table>
                                <tr>
                                    <td style="font-weight: 900">
                                        <%= IntranetPortal.Utility.TotalDealsCount %>
                                    </td>
                                    <td style="font-weight: 200">&nbsp;Deals
                                    </td>
                                </tr>
                            </table>

                        </div>
                    </div>
                    <%------end------%>
                    <div style="float: left">
                        <table style="width: 100%; vertical-align: top; height: 700px; margin-top: -21px; margin-left: 35px;">
                            <tr style="height: 240px">
                                <td style="width: 380px; vertical-align: top" class="under_line">
                                    <%--add image by steven--%>
                                    <%--ments--%>
                                    <h4>
                                        <img src="../images/grid_upcoming_icon.png" class="vertical-img"><span class="heading_text">Upcoming Appointments</span></h4>
                                    <div class="div-underline">
                                        <dx:ASPxGridView runat="server" Width="100%" ID="gridAppointment" ClientInstanceName="gridAppointmentClient" KeyFieldName="BBLE" Settings-ShowColumnHeaders="false" Settings-GridLines="None" Border-BorderStyle="None" SettingsPager-PageSize="6">
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
                                                                        <div class="raund-label">
                                                                            <%#  Container.SummaryText.Replace("Count=", "").Replace("(","").Replace(")","") %>
                                                                        </div>
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
                                            <SettingsBehavior EnableRowHotTrack="True" ColumnResizeMode="NextColumn" AutoExpandAllGroups="true" />
                                            <Styles>
                                                <AlternatingRow CssClass="gridAlternatingRow"></AlternatingRow>
                                            </Styles>
                                        </dx:ASPxGridView>
                                    </div>
                                </td>
                                <%--fix the disteance between the two grid by steven--%>
                                <td rowspan="2" style="width: 50px"></td>
                                <td style="width: 380px; vertical-align: top" class="under_line ">
                                    <%--add icon by steven--%>
                                    <h4>
                                        <img src="../images/grid_propity.png" class="vertical-img" /><span class="heading_text">Priority</span>
                                    </h4>
                                    <div class="div-underline">
                                        <dx:ASPxGridView runat="server" Width="100%" ID="gridPriority" ClientInstanceName="gridPriorityClient" KeyFieldName="BBLE" Settings-ShowColumnHeaders="false" Settings-GridLines="None" Border-BorderStyle="None" Paddings-PaddingTop="10px" SettingsPager-PageSize="6">
                                            <Columns>
                                                <dx:GridViewDataTextColumn FieldName="LeadsName" Settings-AllowHeaderFilter="False" VisibleIndex="1">
                                                    <DataItemTemplate>
                                                        <div style="cursor: pointer; height: 40px; padding-left: 20px; line-height: 40px;" onclick='<%# String.Format("NavigateURL(""{0}"",""{1}"")", "Priority", Eval("BBLE"))%>'><%# HtmlBlackInfo(Eval("LeadsName"))%></div>
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
                                            <Styles>
                                                <AlternatingRow BackColor="#eff2f5"></AlternatingRow>
                                                <RowHotTrack BackColor="#ff400d"></RowHotTrack>
                                            </Styles>
                                        </dx:ASPxGridView>
                                    </div>
                                </td>
                                <td rowspan="3" style="width: 50px"></td>
                                <td rowspan="3" style="vertical-align: top;" class="auto-style1 ">
                                    <h4>
                                        <img src="../images/grid_calendar.png" class="vertical-img" /><span class="heading_text">Today's Calendar</span></h4>
                                    <div style="border: 1px solid #efefef; height: 615px">
                                        <dx:ASPxScheduler ID="todayScheduler" runat="server" Width="100%" ActiveViewType="Day"
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
                                <td rowspan="4" style="width: 80px"></td>
                            </tr>
                            <tr style="height: 240px">
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
                                        <img src="../images/grid_call_back_icon.png" class="vertical-img" /><span class="heading_text">Call Backs</span> </h4>
                                    <%--------end-------%>
                                    <div class="div-underline">
                                        <dx:ASPxGridView runat="server" Width="100%" ID="gridCallback" ClientInstanceName="gridCallbackClient" KeyFieldName="BBLE" AutoGenerateColumns="false" Settings-ShowColumnHeaders="false" Settings-GridLines="None" Border-BorderStyle="None" Paddings-PaddingTop="10px" SettingsPager-PageSize="6">
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
                                <td colspan="3">
                                    <div style="width: 815px; height: auto; background: #fff5e7; border-left: 5px solid #ff400d; margin-top: 30px; padding-top: 0px; color: #2b586f; font: 14px 'PT Serif'; font-style: italic; margin-left: 35px;">
                                        <div style="float: left; font-size: 60px; margin-left: 30px; margin-top: 18px;">“</div>
                                        <p style="width: 74%; padding-top: 35px; padding-bottom: 30px; padding-left: 65px;">
                                            <%= HtmlBlackQuote(Quote)%>
                                            <%--To accomplish great things, we must not only act, but also dream, not only plan, but also believe.”
        - Anatole France--%>
                                        </p>
                                    </div>
                                </td>
                            </tr>
                        </table>
                    </div>
                </dx:SplitterContentControl>
            </ContentCollection>
        </dx:SplitterPane>
        <dx:SplitterPane Size="290px">
            <PaneStyle BackColor="#EFF2F5"></PaneStyle>
            <Separator Visible="False"></Separator>
            <ContentCollection>
                <dx:SplitterContentControl>
                    <div style="width: 290px; height: 100%; background: #EFF2F5;">
                        <%--/*the showlder box*--%>
                        <div style="width: 30px; height: 100%; float: left; position: relative; left: 0px; top: 0px; box-shadow: inset 20px -10px 13px -15px rgba(2, 2, 2, 0.3);"></div>
                        <div style="width: 100%; height: 100%;">
                            <div style="height: 70px;">
                                <div style="color: #b2b4b7; padding-top: 35px; margin-left: 26px; font-size: 30px; font-weight: 300;">Notes</div>
                            </div>

                            <div style="background: #f53e0d; color: white; height: 270px; margin-top: 35px">
                                <div style="margin-left: 30px; margin-right: 15px;">
                                    <h2 style="font-size: 30px; font-weight: 400; margin: 0px; padding-top: 35px; padding-bottom: 35px;">Just An Idea</h2>
                                    <div style="font-size: 14px; line-height: 24px; background: transparent !important; margin-bottom: 0px">
                                        Lorem ipsum dolor sit amet, consectetur adipiscing elit. Pellentesque sodales vel orci volutpat fringilla.
                                    </div>
                                    <div style="padding-top: 40px; font-size: 24px; color: white">
                                        <i class="fa fa-check-circle icon_btn" onclick="#"></i>
                                        <i class="fa fa-times-circle icon_btn note_button_margin" onclick="#"></i>
                                        <i class="fa fa-trash-o icon_btn note_button_margin" onclick="#"></i>
                                    </div>
                                </div>
                            </div>
                            <div style="margin-top: 10px; margin-left: -35px; font-size: 18px">
                                <ul>
                                    <li class="right_palne_menu">Note Tile1
                                    </li>
                                    <li class="right_palne_menu">Note Tile2
                                    </li>
                                </ul>
                            </div>
                            <i class="fa fa-plus-circle icon_btn" style="color: #999ca1; font-size: 24px" onclick="#"></i>
                        </div>
                    </div>

                </dx:SplitterContentControl>
            </ContentCollection>
        </dx:SplitterPane>
    </Panes>
</dx:ASPxSplitter>
<%--change it to color sytle by steven--%>
