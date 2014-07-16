<%@ Control Language="vb" AutoEventWireup="false" CodeBehind="UserSummary.ascx.vb" Inherits="IntranetPortal.UserSummary" %>
<%@ Register Src="~/UserControl/Devexpress/CustomVerticalAppointmentTemplate.ascx" TagName="CustomVerticalAppointmentTemplate" TagPrefix="uc1" %>
<%@ Register Src="~/UserControl/LeadsSubMenu.ascx" TagPrefix="uc1" TagName="LeadsSubMenu" %>

<uc1:LeadsSubMenu runat="server" ID="LeadsSubMenu" />
<style type="text/css">
    .Header {
        font: 24px 'Segoe UI', Helvetica, 'Droid Sans', Tahoma, Geneva, sans-serif;
        color: #0072C6;
        vertical-align: top;
    }

    h4 {
        font: 20px 'Segoe UI', Helvetica, 'Droid Sans', Tahoma, Geneva, sans-serif;
        color: #0072C6;
        vertical-align: top;
        padding: 3px;
        margin-bottom: 0px;
        background-color: #ededed;
        margin-top: 10px;
    }
</style>
<div class="Header"><%= Page.User.Identity.Name %>'s Summary &nbsp; (Leads: <%= IntranetPortal.Utility.TotalLeadsCount %> &nbsp;&nbsp; Deals:<%= IntranetPortal.Utility.TotalDealsCount %> )</div>
<table style="width: 100%; vertical-align: top">
    <tr style="height: 350px">
        <td style="width: 380px; vertical-align: top">
            <h4 class="dxhlHeader_MetropolisBlue1">Upcoming Appointments</h4>
            <div style="border: 1px solid #efefef; height: 355px">
                <dx:ASPxGridView runat="server" Width="100%" ID="gridAppointment" ClientInstanceName="gridAppointmentClient" KeyFieldName="BBLE" Settings-ShowColumnHeaders="false" Settings-GridLines="None" Border-BorderStyle="None">
                    
                    <Columns>
                        <dx:GridViewDataTextColumn FieldName="LeadsName" Settings-AllowHeaderFilter="False" VisibleIndex="1">
                            <DataItemTemplate>
                                <span style="cursor: pointer;" onclick='<%# String.Format("NavigateURL(""{0}"",""{1}"")", "Task", Eval("BBLE"))%>'><%# Eval("LeadsName")%></span>
                            </DataItemTemplate>
                        </dx:GridViewDataTextColumn>
                        <dx:GridViewDataTextColumn FieldName="ScheduleDate" PropertiesTextEdit-DisplayFormatString="d" VisibleIndex="2" GroupIndex="0" Settings-SortMode="Custom">
                            <PropertiesTextEdit DisplayFormatString="d"></PropertiesTextEdit>
                            <Settings AllowHeaderFilter="False" GroupInterval="Date"></Settings>
                            <GroupRowTemplate>
                                Date: <%# Container.GroupText & Container.SummaryText.Replace("Count=", "")%>
                            </GroupRowTemplate>                            
                        </dx:GridViewDataTextColumn>                       
                        <dx:GridViewDataColumn Width="25px" VisibleIndex="5">
                            <DataItemTemplate>
                                <img src="/images/flag1.png" style="width: 16px; height: 16px; vertical-align: bottom; cursor: pointer;" onclick='<%#String.Format("ShowCateMenu(this,{0})", Eval("BBLE")) %>' />
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
        <td rowspan="2" style="width: 10px"></td>
        <td style="width: 380px; vertical-align: top">
            <h4>Priority</h4>
            <div style="border: 1px solid #ededed; height: 355px">
                <dx:ASPxGridView runat="server" Width="100%" ID="gridPriority" ClientInstanceName="gridPriorityClient" KeyFieldName="BBLE" Settings-ShowColumnHeaders="false" Settings-GridLines="None" Border-BorderStyle="None">
                    <Columns>
                        <dx:GridViewDataTextColumn FieldName="LeadsName" Settings-AllowHeaderFilter="False" VisibleIndex="1">
                            <DataItemTemplate>
                                <span style="cursor: pointer;" onclick='<%# String.Format("NavigateURL(""{0}"",""{1}"")", "Priority", Eval("BBLE"))%>'><%# Eval("LeadsName")%></span>
                            </DataItemTemplate>
                        </dx:GridViewDataTextColumn>
                        <dx:GridViewDataColumn Width="25px" VisibleIndex="5">
                            <DataItemTemplate>
                                <img src="/images/flag1.png" style="width: 16px; height: 16px; vertical-align: bottom; cursor: pointer;" onclick='<%#String.Format("ShowCateMenu(this,{0})", Eval("BBLE")) %>' />
                            </DataItemTemplate>
                        </dx:GridViewDataColumn>
                    </Columns>
                    <SettingsBehavior EnableRowHotTrack="True" ColumnResizeMode="NextColumn" />
                    <Styles>
                        <AlternatingRow CssClass="gridAlternatingRow"></AlternatingRow>
                    </Styles>
                </dx:ASPxGridView>
            </div>
        </td>
        <td rowspan="2" style="width: 10px"></td>
        <td rowspan="2" style="vertical-align: top; width: 400px">
            <h4>Today's Calendar</h4>
            <div style="border: 1px solid #efefef; height: 752px">
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
        <td rowspan="2" style="width: 5px"></td>
        <td rowspan="2" style="text-align:center;">
            <div class="Header" style="width:90%;text-align:center;left:20px;">
                <%= Quote%>
            </div>
        </td>
    </tr>
    <tr style="height: 350px">
        <td style="vertical-align: top">
            <h4>Task</h4>
            <div style="border: 1px solid #efefef; height: 355px">
                <dx:ASPxGridView runat="server" Width="100%" ID="gridTask" KeyFieldName="BBLE" ClientInstanceName="gridTaskClient" Settings-ShowColumnHeaders="false" Settings-GridLines="None" Border-BorderStyle="None">
                    <Columns>
                        <dx:GridViewDataTextColumn FieldName="LeadsName" Settings-AllowHeaderFilter="False" VisibleIndex="1">
                            <DataItemTemplate>
                                <span style="cursor: pointer;" onclick='<%# String.Format("NavigateURL(""{0}"",""{1}"")", "Task", Eval("BBLE"))%>'><%# Eval("LeadsName")%></span>
                            </DataItemTemplate>
                        </dx:GridViewDataTextColumn>
                        <dx:GridViewDataTextColumn FieldName="ScheduleDate" PropertiesTextEdit-DisplayFormatString="d" VisibleIndex="2" Settings-SortMode="Custom">                         
                            <GroupRowTemplate>                                
                                Date: <%# Container.GroupText & Container.SummaryText.Replace("Count=", "")%>
                            </GroupRowTemplate>
                        </dx:GridViewDataTextColumn>
                        <dx:GridViewDataColumn Width="25px" VisibleIndex="5">
                            <DataItemTemplate>
                                <img src="/images/flag1.png" style="width: 16px; height: 16px; vertical-align: bottom; cursor: pointer;" onclick='<%#String.Format("ShowCateMenu(this,{0})", Eval("BBLE")) %>' />
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
        <td style="vertical-align: top">
            <h4>Call Backs</h4>
            <div style="border: 1px solid #efefef; height: 355px">
                <dx:ASPxGridView runat="server" Width="100%" ID="gridCallback" ClientInstanceName="gridCallbackClient" KeyFieldName="BBLE" AutoGenerateColumns="false" Settings-ShowColumnHeaders="false" Settings-GridLines="None" Border-BorderStyle="None">
                    <Columns>
                        <dx:GridViewDataTextColumn FieldName="LeadsName" Settings-AllowHeaderFilter="False" VisibleIndex="1">
                            <DataItemTemplate>
                                <span style="cursor: pointer;" onclick='<%# String.Format("NavigateURL(""{0}"",""{1}"")", "Call Back", Eval("BBLE"))%>'><%# Eval("LeadsName")%></span>
                            </DataItemTemplate>
                        </dx:GridViewDataTextColumn>
                        <dx:GridViewDataTextColumn FieldName="CallbackDate" VisibleIndex="2" Visible="false" Settings-SortMode="Custom">
                            <Settings AllowHeaderFilter="False" GroupInterval="Date"></Settings>
                            <GroupRowTemplate>
                                Date: <%# Container.GroupText & Container.SummaryText.Replace("Count=", "")%>
                            </GroupRowTemplate>
                        </dx:GridViewDataTextColumn>
                        <dx:GridViewDataColumn Width="25px" VisibleIndex="5">
                            <DataItemTemplate>
                                <img src="/images/flag1.png" style="width: 16px; height: 16px; vertical-align: bottom; cursor: pointer;" onclick='<%#String.Format("ShowCateMenu(this,{0})", Eval("BBLE")) %>' />
                            </DataItemTemplate>
                        </dx:GridViewDataColumn>
                    </Columns>
                    <SettingsBehavior AutoExpandAllGroups="true"
                        EnableRowHotTrack="True" ColumnResizeMode="NextColumn" />
                    <Styles>
                        <AlternatingRow CssClass="gridAlternatingRow"></AlternatingRow>
                    </Styles>
                    <GroupSummary>
                        <dx:ASPxSummaryItem FieldName="CallbackDate" SummaryType="Count" />
                    </GroupSummary>
                </dx:ASPxGridView>
            </div>
        </td>
    </tr>
</table>
